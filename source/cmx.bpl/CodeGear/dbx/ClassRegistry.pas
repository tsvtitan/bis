{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }
unit ClassRegistry;

interface
uses
  Windows, Classes, SysUtils
{$IF DEFINED(CLR)}
  , System.Reflection
{$ELSE}
  , WideStrings
{$IFEND}
;

resourcestring
  SAlreadyRegistered        = '%s class already registered';
  SNotRegistered            = '%s class is not registered';
  SInvalidClassRegister     = '%s class registered with a nil class reference';
{$IF DEFINED(CLR)}
  SInvalidClassName         = '%s class cannot be found in %s';
{$IFEND}
  SCannotFreeClassRegistry  = 'Cannot free TClassRegistry.ClassRegistry';

type
{$IF DEFINED(CLR)}
  TWideStringList = TStringList;
{$IFEND}

  // TObject constructor is not virtual, so allow for virtual constructor
  // for registered Objects.
  //
  TClassRegistryObject = class
    public
      constructor Create; virtual;
  end;

  TRegistryClass = class of TClassRegistryObject; 

//  TObjectClass = class of TObject;

  EClassRegistryError = class(Exception);

  TInstanceCreator = packed record
    private
      FClassName:     WideString;
      FObjectClass:   TClass;
      FRegistryClass: TRegistryClass;
{$IF DEFINED(CLR)}
      FClassType:     System.Type;
{$ELSE}
{$IFEND}
      function CreateInstance: TObject;
  end;

  TClassRegistryPackageItem = class
    private
      FUseCount:      Integer;
      FPackageName:   WideString;

{$IF DEFINED(CLR)}
      FAssembly:      Assembly;
{$ELSE}
      FPackageHandle: Cardinal;
{$IFEND}
      constructor Create(PackageName: WideString);

    public
      destructor Destroy; override;

  end;

  TClassRegistryItem = class
    private
      FClassName:     WideString;
      FObjectClass:   TClass;
      FRegistryClass: TRegistryClass;
      FPackageItem:   TClassRegistryPackageItem;
{$IF DEFINED(CLR)}
      FClassType:     System.Type;
{$ELSE}
{$IFEND}

      procedure InitializeInstanceCreator(var InstanceCreator: TInstanceCreator);

    end;

  TClassRegistry = class
    private
      FLock:        TThreadList;
      FClasses:     TWideStringList;
      FPackages:    TWideStringList;


    private
      FCanDestroy:  Boolean;
      class var
        ClassRegistry: TClassRegistry;
      var

      function FindClass(ClassName: WideString): TClassRegistryItem;
      function FindPackage(PackageName: WideString): TClassRegistryPackageItem;

    public
      constructor Create;
      destructor  Destroy; override;

      class function GetClassRegistry: TClassRegistry;

      procedure RegisterPackageClass(ClassName: WideString; PackageName: WideString);
      procedure RegisterClass(ClassName: WideString; ObjectClass: TClass); overload;
      procedure RegisterRegistryClass(ClassName: WideString; RegistryClass: TRegistryClass);
      procedure UnregisterClass(ClassName: WideString);

      function HasClass(ClassName: WideString): Boolean;
      function CreateInstance(ClassName: WideString): TObject;

  end;

implementation


{ TClassRegistry }

constructor TClassRegistry.Create;
begin
  inherited Create;
  FLock       := TThreadList.Create;
  FClasses    := TWideStringList.Create;
  FClasses.Sorted := true;
  FPackages   := TWideStringList.Create;
  FPackages.Sorted := true;
  FCanDestroy := true;
end;

destructor TClassRegistry.Destroy;
var
  Index: Integer;
begin
  if not FCanDestroy then
    raise EClassRegistryError.Create(SCannotFreeClassRegistry);
  FreeAndNil(FLock);
  if FClasses <> nil then
    for Index := 0 to FClasses.Count - 1 do
      FClasses.Objects[Index].Free;
  FreeAndNil(FClasses);
  if FPackages <> nil then
    for Index := 0 to FPackages.Count - 1 do
      FPackages.Objects[Index].Free;
  FreeAndNil(FPackages);
end;

function TClassRegistry.CreateInstance(ClassName: WideString): TObject;
var
  Item: TClassRegistryItem;
  InstanceCreator: TInstanceCreator;
begin
  FLock.LockList;
  try
    Item := FindClass(ClassName);
    if Item = nil then
      raise EClassRegistryError.Create(Wideformat(SNotRegistered, [ClassName]))
    else
      Item.InitializeInstanceCreator(InstanceCreator);
  finally
    FLock.UnlockList;
  end;
  // To improve performance, create the instance out of the critical section.
  //
  Result := InstanceCreator.CreateInstance;
end;

function TClassRegistry.FindClass(ClassName: WideString): TClassRegistryItem;
var
  Index: Integer;
begin
  if FClasses.Find(ClassName, Index) then
    Result := TClassRegistryItem(FClasses.Objects[Index])
  else
    Result := nil;
end;

function TClassRegistry.FindPackage(
  PackageName: WideString): TClassRegistryPackageItem;
var
  Index: Integer;
begin
  if FPackages.Find(PackageName, Index) then
    Result := TClassRegistryPackageItem(FPackages.Objects[Index])
  else
    Result := nil;
end;

class function TClassRegistry.GetClassRegistry: TClassRegistry;
begin
  if TClassRegistry.ClassRegistry = nil then
  begin
    TClassRegistry.ClassRegistry := TClassRegistry.Create;
    TClassRegistry.ClassRegistry.FCanDestroy := false;
  end;
  Result := ClassRegistry;
end;

function TClassRegistry.HasClass(ClassName: WideString): Boolean;
var
  Index: Integer;
begin
  Result := FClasses.Find(ClassName, Index);
end;

procedure TClassRegistry.RegisterClass(ClassName: WideString;
  ObjectClass: TClass);
var
  ClassItem: TClassRegistryItem;
begin
  FLock.LockList;
  ClassItem := nil;
  try
    ClassItem := FindClass(ClassName);
    if ClassItem <> nil then begin
      // Subtle.  Get here on .net if RegisterPackageClass was called first
      // and then the initialization section is consequently invoked
      // and calls RegisterClass.  The initial RegisterPackageClass did
      // not have the class reference, so it is nil.  Corner case resulting
      // from a general system for static and dynamic linkage across native
      // and managed code.
      //
      if ClassItem.FObjectClass <> nil then
        raise EClassRegistryError.Create(WideFormat(SAlreadyRegistered, [ClassName]));
      ClassItem.FObjectClass := ObjectClass;
    end else begin
      ClassItem := TClassRegistryItem.Create;
      ClassItem.FClassName      := ClassName;
      ClassItem.FObjectClass    := ObjectClass;
      ClassItem.FRegistryClass  := nil;
{$IF DEFINED(CLR)}
      ClassItem.FClassType := Assembly.GetCallingAssembly.GetType(ClassName);
      if ClassItem.FClassType = nil then
        raise EClassRegistryError.Create(WideFormat(SInvalidClassName, [ClassName, Assembly.GetCallingAssembly.GetName.ToString]));
{$ELSE}
{$IFEND}
      FClasses.AddObject(ClassName, ClassItem);
    end;
    ClassItem := nil;
  finally
    ClassItem.Free;
    FLock.UnlockList;
  end;
end;

procedure TClassRegistry.RegisterRegistryClass(ClassName: WideString;
  RegistryClass: TRegistryClass);
var
  ClassItem: TClassRegistryItem;
begin
  FLock.LockList;
  ClassItem := nil;
  try
    ClassItem := FindClass(ClassName);
    if ClassItem <> nil then begin
      // Subtle.  Get here on .net if RegisterPackageClass was called first
      // and then the initialization section is consequently invoked
      // and calls RegisterClass.  The initial RegisterPackageClass did
      // not have the class reference, so it is nil.  Corner case resulting
      // from a general system for static and dynamic linkage across native
      // and managed code.
      //
      if ClassItem.FObjectClass <> nil then
        raise EClassRegistryError.Create(WideFormat(SAlreadyRegistered, [ClassName]));
      ClassItem.FObjectClass := nil;
    end else begin
      ClassItem := TClassRegistryItem.Create;
      ClassItem.FClassName      := ClassName;
      ClassItem.FObjectClass    := nil;
      ClassItem.FRegistryClass  := RegistryClass;
{$IF DEFINED(CLR)}
      ClassItem.FClassType := Assembly.GetCallingAssembly.GetType(ClassName);
      if ClassItem.FClassType = nil then
        raise EClassRegistryError.Create(WideFormat(SInvalidClassName, [ClassName, Assembly.GetCallingAssembly.GetName.ToString]));
{$ELSE}
{$IFEND}
      FClasses.AddObject(ClassName, ClassItem);
    end;
    ClassItem := nil;
  finally
    ClassItem.Free;
    FLock.UnlockList;
  end;
end;

procedure TClassRegistry.RegisterPackageClass(ClassName,
  PackageName: WideString);
var
  ClassItem: TClassRegistryItem;
  PackageItem: TClassRegistryPackageItem;
  IsNewPackage: Boolean;
  ClassItemCreated: Boolean;
begin
  ClassItem := nil;
  PackageItem := nil;
  FLock.LockList;
  try
    ClassItem := FindClass(ClassName);
    if ClassItem <> nil then
      raise EClassRegistryError.Create(WideFormat(SAlreadyRegistered, [ClassName]));
    PackageItem := FindPackage(PackageName);
    if PackageItem = nil then
      begin
        IsNewPackage := true;
        PackageItem := TClassRegistryPackageItem.Create(PackageName);
      end
    else
      IsNewPackage := false;
    ClassItem := FindClass(ClassName);
    ClassItemCreated := false;
    // native unit initialization section is invoked when the package was loaded.
    //
    if ClassItem = nil then
    begin
      ClassItem := TClassRegistryItem.Create;
      ClassItem.FClassName := ClassName;
      ClassItemCreated := true;
    end;
    ClassItem.FPackageItem := PackageItem;
{$IF DEFINED(CLR)}
    ClassItem.FClassType := PackageItem.FAssembly.GetType(ClassName);
    if ClassItem.FClassType = nil then
      raise EClassRegistryError.Create(WideFormat(SInvalidClassName, [ClassName, PackageName]));
{$ELSE}
{$IFEND}
    if IsNewPackage then
      FPackages.AddObject(PackageName, PackageItem);
    inc(PackageItem.FUseCount);
    if ClassItemCreated then
      FClasses.AddObject(ClassName, ClassItem);
    ClassItem := nil;
    PackageItem := nil;
  finally
    PackageItem.Free;
    ClassItem.Free;
    FLock.UnlockList;
  end;
end;

procedure TClassRegistry.UnregisterClass(ClassName: WideString);
begin
  FLock.LockList;
  try
  finally
    FLock.UnlockList;
  end;
end;

{ TInstanceCreator }

function TInstanceCreator.CreateInstance: TObject;
begin
  Result := nil;
{$IF DEFINED(CLR)}
    if FClassType <> nil then
      Result := FClassType.InvokeMember(
        '',
        BindingFlags.Public
        or BindingFlags.Instance
        or BindingFlags.CreateInstance,
        nil, FClassType, []);
{$ELSE}
    if FObjectClass <> nil then
      Result := FObjectClass.Create
    else if FRegistryClass <> nil then
      Result := FRegistryClass.Create;
         
{$IFEND}

  if Result = nil then
    raise EClassRegistryError.Create(WideFormat(SInvalidClassRegister, [FClassName]));


end;

{ TClassRegistryPackageItem }

constructor TClassRegistryPackageItem.Create(PackageName: WideString);
begin
  inherited Create;
  FPackageName := PackageName;
{$IF DEFINED(CLR)}
  FAssembly := Assembly.Load(PackageName);
{$ELSE}
  FPackageHandle := LoadPackage(PackageName);
{$IFEND}

end;

destructor TClassRegistryPackageItem.Destroy;
begin
{$IF DEFINED(CLR)}
  if FAssembly <> nil then
    FAssembly.Free;
{$ELSE}
  UnloadPackage(FPackageHandle);
{$IFEND}

  inherited;
end;


{ TClassRegistryItem }


procedure TClassRegistryItem.InitializeInstanceCreator(
  var InstanceCreator: TInstanceCreator);
begin
  InstanceCreator.FClassName      := FClassName;
  InstanceCreator.FObjectClass    := FObjectClass;
  InstanceCreator.FRegistryClass  := FRegistryClass;
{$IF DEFINED(CLR)}
  InstanceCreator.FClassType    := FClassType;
{$ELSE}
{$IFEND}
end;

{ TClassRegistryObject }

constructor TClassRegistryObject.Create;
begin
  inherited Create;
end;

initialization
finalization
  if TClassRegistry.ClassRegistry <> nil then
  begin
    TClassRegistry.ClassRegistry.FCanDestroy := true;
    FreeAndNil(TClassRegistry.ClassRegistry);
  end;
end.
