unit BisModules;

interface

uses Windows, Classes,
     BisObject, BisObjects, BisDataSet,
     BisCoreObjects,
     BisModuleIntf;

type
  TBisModule=class(TBisCoreObject,IBisModule)
  private
    FEnabled: Boolean;
    FModule: HMODULE;
    FFileName: String;

    FSLoadBegin: String;
    FSLoadSuccess: String;
    FSLoadFailed: String;
    FSUnLoadSuccess: String;
    FSUnLoadFailed: String;
    FSInitFailed: String;
    FSInitSuccess: String;
    FSInitProcNotFound: String;

    function GetIsLoad: Boolean;
    function CheckProductVersion: Boolean;
  protected
    procedure DoInitProc(AModule: TBisModule); virtual;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure Load; virtual;
    procedure Unload; virtual;
    procedure Save; virtual;

    property Enabled: Boolean read FEnabled write FEnabled;
    property IsLoad: Boolean read GetIsLoad;
    property FileName: String read FFileName write FFileName;
    property Module: HMODULE read FModule;
  published
    property SLoadBegin: String read FSLoadBegin write FSLoadBegin;
    property SLoadSuccess: String read FSLoadSuccess write FSLoadSuccess;
    property SLoadFailed: String read FSLoadFailed write FSLoadFailed;
    property SUnLoadSuccess: String read FSUnLoadSuccess write FSUnLoadSuccess;
    property SUnLoadFailed: String read FSUnLoadFailed write FSUnLoadFailed;
    property SInitFailed: String read FSInitFailed write FSInitFailed;
    property SInitSuccess: String read FSInitSuccess write FSInitSuccess;
    property SInitProcNotFound: String read FSInitProcNotFound write FSInitProcNotFound;
  end;

  TBisModules=class;
  
  TBisModulesCreateEvent=procedure (Modules: TBisModules; Module: TBisModule) of object;

  TBisModules=class(TBisCoreObjects)
  private
    FTable: TBisDataSet;
    FOnCreateModule: TBisModulesCreateEvent;
    function GetItem(Index: Integer): TBisModule;
  protected
    function GetObjectClass: TBisObjectClass; override;
    procedure DoCreateModule(Module: TBisModule); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Load; virtual;
    procedure Unload; virtual;
    function AddModule(Module: TBisModule): Boolean;
    procedure SaveToLocalbase;
    function IsFirstModule(Module: TBisModule): Boolean;
    function Find(ObjectName: String): TBisModule; reintroduce;

    property Items[Index: Integer]: TBisModule read GetItem; default;
    property Table: TBisDataSet read FTable;

    property OnCreateModule: TBisModulesCreateEvent read FOnCreateModule write FOnCreateModule;
  end;

implementation

uses SysUtils,
     BisConsts, BisCore, BisLogger, BisUtils, BisModuleInfo;

{ TBisModule }

constructor TBisModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSLoadBegin:='�������� ������ %s �������� ...';
  FSLoadSuccess:='�������� ������ %s ������ �������.';
  FSLoadFailed:='�������� ������ %s ������ � �������: %s';
  FSUnLoadSuccess:='�������� ������ %s ������ �������.';
  FSUnLoadFailed:='�������� ������ %s ������ � �������: %s';
  FSInitSuccess:='������������� ������ %s ������ �������.';
  FSInitFailed:='������������� ������ %s ������ � �������: %s';
  FSInitProcNotFound:='��������� ������������� �� ������� � ������ %s';
end;

procedure TBisModule.Init;
begin
  inherited Init;
end;

procedure TBisModule.DoInitProc(AModule: TBisModule); 
begin
end;

function TBisModule.CheckProductVersion: Boolean;
begin
  Result:=true;
  if Assigned(Core) then
    Result:=AnsiSameText(Core.ProductVersion,GetProductVersion(FFileName));
end;

procedure TBisModule.Load;
begin
  if FEnabled and CheckProductVersion then begin
    try
      LoggerWrite(FormatEx(FSLoadBegin,[FFileName]));
      FModule:=LoadPackage(FFileName);
      if IsLoad then begin
        LoggerWrite(FormatEx(FSLoadSuccess,[FFileName]));
        DoInitProc(Self);
      end else
        LoggerWrite(FormatEx(FSLoadFailed,[FFileName,SysErrorMessage(GetLastError)]),ltError);
    except
      on E: Exception do begin
        LoggerWrite(FormatEx(FSLoadFailed,[FFileName,E.Message]),ltError);
      end;
    end;
  end;
end;

procedure TBisModule.Save;
begin
end;

procedure TBisModule.Unload;
begin
  if FEnabled and IsLoad then begin
    try
      UnloadPackage(FModule);
      LoggerWrite(FormatEx(FSUnLoadSuccess,[FFileName]));
      FModule:=0;
    except
      on E: Exception do begin
        LoggerWrite(FormatEx(FSUnLoadFailed,[FFileName,E.Message]),ltError);
      end;
    end;
  end;
end;

function TBisModule.GetIsLoad: Boolean;
begin
  Result:=FModule<>0;
end;

{ TBisModules }

constructor TBisModules.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTable:=TBisDataSet.Create(Self);
end;

destructor TBisModules.Destroy;
begin
  FTable.Free;
  inherited Destroy;
end;

procedure TBisModules.DoCreateModule(Module: TBisModule);
begin
  if Assigned(FOnCreateModule) then
    FOnCreateModule(Self,Module);
end;

function TBisModules.Find(ObjectName: String): TBisModule;
begin
  Result:=TBisModule(inherited Find(ObjectName));
end;

procedure TBisModules.Init;
var
  i: Integer;
  Modules: TStringList;
  ModuleClass: TBisObjectClass;
  Module: TBisModule;
  Stream: TMemoryStream;
  AEnabled: Boolean;
begin
  inherited Init;

  Stream:=TMemoryStream.Create;
  try
    if not FTable.Active then
      if Core.LocalBase.ReadParam(ObjectName,Stream) then begin
        FTable.LoadFromStream(Stream);
        FTable.Open;
      end;
  finally
    Stream.Free;
  end;

  if FTable.Active and not FTable.IsEmpty then begin
    FTable.First;
    while not FTable.Eof do begin
      ModuleClass:=GetObjectClass;
      if Assigned(ModuleClass) then begin
        AEnabled:=Boolean(FTable.FieldByName(SFieldEnabled).AsInteger);
        if AEnabled then begin
          Module:=TBisModule(ModuleClass.Create(Self));
          Module.ObjectName:=FTable.FieldByName(SFieldName).AsString+Module.ObjectName;
          if AddModule(Module) then begin
            DoCreateModule(Module);
            Module.Description:=FTable.FieldByName(SFieldDescription).AsString;
            Module.Enabled:=AEnabled;
            Module.FileName:=FTable.FieldByName(SFieldFileName).AsString;
            Module.Init;
          end else
            Module.Free;
        end;
      end;
      FTable.Next;
    end;
  end;

  Modules:=TStringList.Create;
  try
    Core.Config.ReadSection(ObjectName,Modules);
    for i:=0 to Modules.Count-1 do begin
      ModuleClass:=GetObjectClass;
      if Assigned(ModuleClass) then begin
        AEnabled:=Core.Config.Read(ObjectName,Modules.Strings[i],false);
        if AEnabled then begin
          Module:=TBisModule(ModuleClass.Create(Self));
          Module.ObjectName:=Modules.Strings[i]+Module.ObjectName;
          if AddModule(Module) then begin
            DoCreateModule(Module);
            Module.Description:=Core.Config.Read(Modules.Strings[i],SDescription,Module.Description);
            Module.Enabled:=AEnabled;
            Module.FileName:=Core.Config.Read(Modules.Strings[i],SFileName,Module.FileName);
            Module.Init;
          end else
            Module.Free;
        end;
      end;
    end;
  finally
    Modules.Free;
  end;

end;

function TBisModules.GetItem(Index: Integer): TBisModule;
begin
  Result:=TBisModule(inherited Items[Index]);
end;

function TBisModules.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisModule;
end;

procedure TBisModules.Load;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    if Items[i].Enabled then
      Items[i].Load;
  end;
end;

procedure TBisModules.SaveToLocalbase;
var
  i: Integer;
  AObjectName: String;
  ModuleClass: TBisObjectClass;
  Stream: TMemoryStream;
begin
  ModuleClass:=GetObjectClass;
  if Assigned(ModuleClass) then begin
    if FTable.Active and not FTable.IsEmpty then begin
      for i:=0 to Count-1 do begin
        FTable.First;
        while not FTable.Eof do begin
          AObjectName:=FTable.FieldByName(SFieldName).AsString+ModuleClass.GetObjectName;
          if AnsiSameText(AObjectName,Items[i].ObjectName) then begin
            FTable.Edit;
            FTable.FieldByName(SFieldDescription).AsString:=Items[i].Description;
            FTable.FieldByName(SFieldEnabled).AsInteger:=Integer(Items[i].Enabled);
            FTable.FieldByName(SFieldFileName).AsString:=Items[i].FileName;
            Items[i].Save;
            FTable.Post;
          end;
          FTable.Next;
        end;
      end;

      Stream:=TMemoryStream.Create;
      try
        if FTable.Active then begin
          FTable.SaveToStream(Stream);
          Stream.Position:=0;
          Core.LocalBase.WriteParam(ObjectName,Stream);
          Core.LocalBase.Save;
        end;
      finally
        Stream.Free;
      end;
      
    end;
  end;
end;

procedure TBisModules.Unload;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    if Items[i].Enabled then
      Items[i].UnLoad;
  end;
end;

function TBisModules.AddModule(Module: TBisModule): Boolean;
begin
  Result:=false;
  if not Assigned(Find(Module.ObjectName)) then begin
    AddObject(Module);
    Result:=true;  
  end;
end;

function TBisModules.IsFirstModule(Module: TBisModule): Boolean;
var
  i: Integer;
begin
  Result:=false;
  if Assigned(Module) then
    for i:=0 to Count-1 do begin
      if Items[i].Enabled and Items[i].IsLoad then begin
        Result:=Items[i]=Module;
        break;
      end;
    end;
end;


end.
