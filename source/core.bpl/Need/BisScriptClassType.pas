unit BisScriptClassType;

interface

uses Contnrs,
     BisScriptSymbols, BisScriptType, BisScriptParams, BisScriptFuncs;

type
  TBisScriptClassType=class;

  TBisScriptClassTypeField=class(TBisScriptSymbol)
  private
    FParent: TBisScriptClassType;
    FTypeName: String;
  public
    property Parent: TBisScriptClassType read FParent;
    property TypeName: String read FTypeName;
  end;

  TBisScriptClassTypeFields=class(TBisScriptSymbols)
  private
    FParent: TBisScriptClassType;
    function GetItem(Index: Integer): TBisScriptClassTypeField;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClassType); reintroduce;
    function Find(Name: String): TBisScriptClassTypeField; reintroduce;
    function Add(Name: String; TypeName: String): TBisScriptClassTypeField; reintroduce;

    property Items[Index: Integer]: TBisScriptClassTypeField read GetItem; default;
    property Parent: TBisScriptClassType read FParent;
  end;

  TBisScriptClassTypeProp=class;

  TBisScriptClassTypePropGetValue=function(Prop: TBisScriptClassTypeProp; Obj: TObject): Variant of object;

  TBisScriptClassTypePropSetValue=procedure(Prop: TBisScriptClassTypeProp; Obj: TObject; Value: Variant) of object;

  TBisScriptClassTypeProp=class(TBisScriptSymbol)
  private
    FParent: TBisScriptClassType;
    FTypeName: String;
    FOnGetValue: TBisScriptClassTypePropGetValue;
    FOnSetValue: TBisScriptClassTypePropSetValue;
  public
    function GetValue(Obj: TObject): Variant;
    procedure SetValue(Obj: TObject; Value: Variant);

    property Parent: TBisScriptClassType read FParent;
    property TypeName: String read FTypeName;

    property OnGetValue: TBisScriptClassTypePropGetValue read FOnGetValue;
    property OnSetValue: TBisScriptClassTypePropSetValue read FOnSetValue;
  end;

  TBisScriptClassTypeProps=class(TBisScriptSymbols)
  private
    FParent: TBisScriptClassType;
    function GetItem(Index: Integer): TBisScriptClassTypeProp;
    function GetPublishedPropValue(Prop: TBisScriptClassTypeProp; Obj: TObject): Variant;
    procedure SetPublishedPropValue(Prop: TBisScriptClassTypeProp; Obj: TObject; Value: Variant);
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClassType); reintroduce;
    function Find(Name: String): TBisScriptClassTypeProp; reintroduce;
    function Add(Name: String; TypeName: String;
                 OnGetValue: TBisScriptClassTypePropGetValue=nil;
                 OnSetValue: TBisScriptClassTypePropSetValue=nil): TBisScriptClassTypeProp; reintroduce; overload;
    function Add(Name: String): TBisScriptClassTypeProp; reintroduce; overload;
    procedure AddByClass;

    property Items[Index: Integer]: TBisScriptClassTypeProp read GetItem; default;
    property Parent: TBisScriptClassType read FParent;
  end;

  TBisScriptClassTypeMethod=class;

  TBisScriptClassTypeMethodExecute=function(Method: TBisScriptClassTypeMethod; var Obj: TObject): Variant of object;

  TBisScriptClassTypeMethodKind=(scmkConstructor,scmkDestructor,scmkProcedure,scmkFunction);

  TBisScriptClassTypeMethod=class(TBisScriptSymbol)
  private
    FParams: TBisScriptParams;
    FResultType: String;
    FOnExecute: TBisScriptClassTypeMethodExecute;
    FParent: TBisScriptClassType;
    FKind: TBisScriptClassTypeMethodKind;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Execute(var Obj: TObject): Variant;

    property Parent: TBisScriptClassType read FParent;
    property ResultType: String read FResultType;
    property Params: TBisScriptParams read FParams;
    property Kind: TBisScriptClassTypeMethodKind read FKind;

    property OnExecute: TBisScriptClassTypeMethodExecute read FOnExecute;
  end;

  TBisScriptClassTypeMethods=class(TBisScriptSymbols)
  private
    FParent: TBisScriptClassType;
    function GetItem(Index: Integer): TBisScriptClassTypeMethod;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClassType); reintroduce;
    function Find(Name: String): TBisScriptClassTypeMethod; reintroduce;
    function Add(Name: String; OnExecute: TBisScriptClassTypeMethodExecute;
                 Kind: TBisScriptClassTypeMethodKind; ResultType: String=''): TBisScriptClassTypeMethod; reintroduce;
    function AddConstructor(Name: String; OnExecute: TBisScriptClassTypeMethodExecute): TBisScriptClassTypeMethod;
    function AddDestructor(Name: String; OnExecute: TBisScriptClassTypeMethodExecute): TBisScriptClassTypeMethod;
    function AddProcedure(Name: String; OnExecute: TBisScriptClassTypeMethodExecute): TBisScriptClassTypeMethod;
    function AddFunction(Name: String; OnExecute: TBisScriptClassTypeMethodExecute; ResultType: String): TBisScriptClassTypeMethod;

    property Items[Index: Integer]: TBisScriptClassTypeMethod read GetItem; default;
    property Parent: TBisScriptClassType read FParent;
  end;

  TBisScriptClassTypeEvent=class;

  TBisScriptClassTypeEventHandler=class;

  TBisScriptClassTypeEventHandlerExecute=function(Handler: TBisScriptClassTypeEventHandler): Variant of object;

  TBisScriptClassTypeEventHandler=class(TObject)
  private
    FParams: TBisScriptParams;
    FObj: TObject;
    FParent: TBisScriptClassTypeEvent;
    FOnExecute: TBisScriptClassTypeEventHandlerExecute;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute: Variant;

    property Params: TBisScriptParams read FParams;
    property Obj: TObject read FObj;
    property Parent: TBisScriptClassTypeEvent read FParent;
    property OnExecute: TBisScriptClassTypeEventHandlerExecute read FOnExecute;
  end;

  TBisScriptClassTypeEventHandlers=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisScriptClassTypeEventHandler;
  public
    function Find(Obj: TObject): TBisScriptClassTypeEventHandler;

    property Items[Index: Integer]: TBisScriptClassTypeEventHandler read GetItem; default;
  end;

  TBisScriptClassTypeEvent=class(TBisScriptClassTypeProp)
  private
    FCode: Pointer;
    FTypeName: String;
    FHandlers: TBisScriptClassTypeEventHandlers;
    FParams: TBisScriptParams;
  public
    constructor Create; override;
    destructor Destroy; override;

    function AddHandler(Obj: TObject; OnExecute: TBisScriptClassTypeEventHandlerExecute): TBisScriptClassTypeEventHandler;
    procedure RemoveHandler(Obj: TObject);

    property TypeName: String read FTypeName;
    property Params: TBisScriptParams read FParams;
  end;

  TBisScriptClassTypeEvents=class(TBisScriptClassTypeProps)
  private
    function GetItem(Index: Integer): TBisScriptClassTypeEvent;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClassType); reintroduce;
    function Find(Name: String): TBisScriptClassTypeEvent; reintroduce;
    function Add(Name: String; TypeName: String; Code: Pointer): TBisScriptClassTypeEvent; reintroduce;

    property Items[Index: Integer]: TBisScriptClassTypeEvent read GetItem; default;
  end;

  TBisScriptClassType=class(TBisScriptType)
  private
    FValue: TClass;
    FFields: TBisScriptClassTypeFields;
    FProps: TBisScriptClassTypeProps;
    FMethods: TBisScriptClassTypeMethods;
    FEvents: TBisScriptClassTypeEvents;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Value: TClass read FValue;
    property Fields: TBisScriptClassTypeFields read FFields;
    property Props: TBisScriptClassTypeProps read FProps;
    property Methods: TBisScriptClassTypeMethods read FMethods;
    property Events: TBisScriptClassTypeEvents read FEvents;
  end;

implementation

uses TypInfo;

{ TBisScriptClassTypeProp }

function TBisScriptClassTypeProp.GetValue(Obj: TObject): Variant;
begin
  if Assigned(FOnGetValue) then
    Result:=FOnGetValue(Self,Obj);
end;

procedure TBisScriptClassTypeProp.SetValue(Obj: TObject; Value: Variant);
begin
  if Assigned(FOnSetValue) then
    FOnSetValue(Self,Obj,Value);
end;

{ TBisScriptClassTypeProps }

constructor TBisScriptClassTypeProps.Create(AParent: TBisScriptClassType);
begin
  inherited Create;
  FParent:=AParent;
end;

function TBisScriptClassTypeProps.Find(Name: String): TBisScriptClassTypeProp;
begin
  Result:=TBisScriptClassTypeProp(inherited Find(Name));
end;

function TBisScriptClassTypeProps.GetItem(Index: Integer): TBisScriptClassTypeProp;
begin
  Result:=TBisScriptClassTypeProp(inherited Items[Index]);
end;

function TBisScriptClassTypeProps.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassTypeProp;
end;

function TBisScriptClassTypeProps.Add(Name: String; TypeName: String;
                                  OnGetValue: TBisScriptClassTypePropGetValue=nil;
                                  OnSetValue: TBisScriptClassTypePropSetValue=nil): TBisScriptClassTypeProp;
begin
  Result:=TBisScriptClassTypeProp(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FParent:=Parent;
    Result.FTypeName:=TypeName;
    Result.FOnGetValue:=OnGetValue;
    Result.FOnSetValue:=OnSetValue;
  end;
end;

function TBisScriptClassTypeProps.GetPublishedPropValue(Prop: TBisScriptClassTypeProp; Obj: TObject): Variant;
begin
  Result:=GetPropValue(Obj,Prop.Name);
end;

procedure TBisScriptClassTypeProps.SetPublishedPropValue(Prop: TBisScriptClassTypeProp; Obj: TObject; Value: Variant);
begin
  SetPropValue(Obj,Prop.Name,Value);
end;

function TBisScriptClassTypeProps.Add(Name: String): TBisScriptClassTypeProp;
var
  PPI: PPropInfo;
  TypeName: String;
begin
  Result:=nil;
  PPI:=GetPropInfo(Parent.Value,Name);
  if Assigned(PPI) then begin
    TypeName:=PPI.PropType^.Name;
    Result:=Add(Name,TypeName);
    if Assigned(Result) then begin
      Result.FOnGetValue:=GetPublishedPropValue;
      Result.FOnSetValue:=SetPublishedPropValue;
    end;
  end;
end;

procedure TBisScriptClassTypeProps.AddByClass;
var
  i: Integer;
  TypeData: PTypeData;
  PropList: PPropList;
  PropName: String;
  TypeName: String;
  Include: Boolean;
  Prop: TBisScriptClassTypeProp;
begin
  TypeData:=GetTypeData(Parent.Value.ClassInfo);
  New(PropList);
  try
    GetPropInfos(Parent.Value.ClassInfo,PropList);
    for i:=0 to Pred(TypeData^.PropCount) do begin

      PropName:=PropList^[i]^.Name;
      TypeName:=PropList^[i]^.PropType^.Name;
      Include:=false;
      case PropList^[i]^.PropType^.Kind of
        tkUnknown: ;
        tkInteger: Include:=true;
        tkChar: Include:=true;
        tkEnumeration: Include:=false;
        tkFloat: Include:=true;
        tkString: Include:=true;
        tkSet: Include:=false;
        tkClass: Include:=true;
        tkMethod: Include:=false;
        tkWChar: Include:=true;
        tkLString: Include:=true;
        tkWString: Include:=true;
        tkVariant: Include:=true;
        tkArray: Include:=false;
        tkRecord: Include:=false;
        tkInterface: Include:=false;
        tkInt64: Include:=false;
        tkDynArray: Include:=false;
      end;

      if Include then begin
        Prop:=Add(PropName,TypeName);
        if Assigned(Prop) then begin
          Prop.FOnGetValue:=GetPublishedPropValue;
          Prop.FOnSetValue:=SetPublishedPropValue;
        end;
      end;

    end;
  finally
    Dispose(PropList);
  end;
end;

{ TBisScriptClassTypeFields }

constructor TBisScriptClassTypeFields.Create(AParent: TBisScriptClassType);
begin
  inherited Create;
  FParent:=AParent;
end;

function TBisScriptClassTypeFields.Find(Name: String): TBisScriptClassTypeField;
begin
  Result:=TBisScriptClassTypeField(inherited Find(Name));
end;

function TBisScriptClassTypeFields.GetItem(Index: Integer): TBisScriptClassTypeField;
begin
  Result:=TBisScriptClassTypeField(inherited Items[Index]);
end;

function TBisScriptClassTypeFields.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassTypeField;
end;

function TBisScriptClassTypeFields.Add(Name: String; TypeName: String): TBisScriptClassTypeField;
begin
  Result:=TBisScriptClassTypeField(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FParent:=Parent;
    Result.FTypeName:=TypeName;
  end;
end;

{ TBisScriptClassTypeMethod }

constructor TBisScriptClassTypeMethod.Create;
begin
  inherited Create;
  FParams:=TBisScriptParams.Create;
end;

destructor TBisScriptClassTypeMethod.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisScriptClassTypeMethod.Execute(var Obj: TObject): Variant;
begin
  if Assigned(FOnExecute) then
    Result:=FOnExecute(Self,Obj);
end;

{ TBisScriptClassTypeMethods }

constructor TBisScriptClassTypeMethods.Create(AParent: TBisScriptClassType);
begin
  inherited Create;
  FParent:=AParent;
end;

function TBisScriptClassTypeMethods.Find(Name: String): TBisScriptClassTypeMethod;
begin
  Result:=TBisScriptClassTypeMethod(inherited Find(Name));
end;

function TBisScriptClassTypeMethods.GetItem(Index: Integer): TBisScriptClassTypeMethod;
begin
  Result:=TBisScriptClassTypeMethod(inherited Items[Index]);
end;

function TBisScriptClassTypeMethods.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassTypeMethod;
end;

function TBisScriptClassTypeMethods.Add(Name: String; OnExecute: TBisScriptClassTypeMethodExecute;
                                    Kind: TBisScriptClassTypeMethodKind; ResultType: String=''): TBisScriptClassTypeMethod;
begin
  Result:=TBisScriptClassTypeMethod(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FParent:=Parent;
    Result.FOnExecute:=OnExecute;
    Result.FResultType:=ResultType;
    Result.FKind:=Kind;
  end;
end;

function TBisScriptClassTypeMethods.AddConstructor(Name: String; OnExecute: TBisScriptClassTypeMethodExecute): TBisScriptClassTypeMethod;
begin
  Result:=Add(Name,OnExecute,scmkConstructor);
end;

function TBisScriptClassTypeMethods.AddDestructor(Name: String; OnExecute: TBisScriptClassTypeMethodExecute): TBisScriptClassTypeMethod;
begin
  Result:=Add(Name,OnExecute,scmkDestructor);
end;

function TBisScriptClassTypeMethods.AddProcedure(Name: String; OnExecute: TBisScriptClassTypeMethodExecute): TBisScriptClassTypeMethod;
begin
  Result:=Add(Name,OnExecute,scmkProcedure);
end;

function TBisScriptClassTypeMethods.AddFunction(Name: String; OnExecute: TBisScriptClassTypeMethodExecute; ResultType: String): TBisScriptClassTypeMethod;
begin
  Result:=Add(Name,OnExecute,scmkFunction,ResultType);
end;

{ TBisScriptClassTypeEventHandler }

constructor TBisScriptClassTypeEventHandler.Create;
begin
  inherited Create;
  FParams:=TBisScriptParams.Create;
end;

destructor TBisScriptClassTypeEventHandler.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisScriptClassTypeEventHandler.Execute: Variant;
begin
  if Assigned(FOnExecute) then
    Result:=FOnExecute(Self);
end;

{ TBisScriptClassTypeEventHandlers }

function TBisScriptClassTypeEventHandlers.GetItem(Index: Integer): TBisScriptClassTypeEventHandler;
begin
  Result:=TBisScriptClassTypeEventHandler(inherited Items[Index]);
end;

function TBisScriptClassTypeEventHandlers.Find(Obj: TObject): TBisScriptClassTypeEventHandler;
var
  i: Integer;
  Item: TBisScriptClassTypeEventHandler;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if (Item.Obj=Obj) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

{ TBisScriptClassTypeEvent }

constructor TBisScriptClassTypeEvent.Create;
begin
  inherited Create;
  FHandlers:=TBisScriptClassTypeEventHandlers.Create;
  FParams:=TBisScriptParams.Create;
  FCode:=nil;
end;

destructor TBisScriptClassTypeEvent.Destroy;
begin
  FParams.Free;
  FHandlers.Free;
  inherited Destroy;
end;

procedure TBisScriptClassTypeEvent.RemoveHandler(Obj: TObject);
var
  Met: TMethod;
  Handler: TBisScriptClassTypeEventHandler;
begin
  if Assigned(Obj) then begin
    Handler:=FHandlers.Find(Obj);
    Met.Code:=nil;
    Met.Data:=nil;
    SetMethodProp(Obj,Name,Met);
    if Assigned(Handler) then
      FHandlers.Remove(Handler);
  end;
end;

function TBisScriptClassTypeEvent.AddHandler(Obj: TObject; OnExecute: TBisScriptClassTypeEventHandlerExecute): TBisScriptClassTypeEventHandler;
var
  Met: TMethod;
begin
  Result:=nil;
  if Assigned(Obj) then begin
    RemoveHandler(Obj);
    if Assigned(OnExecute) then begin
      Result:=TBisScriptClassTypeEventHandler.Create;
      Result.FObj:=Obj;
      Result.FParent:=Self;
      Result.FOnExecute:=OnExecute;
      Result.Params.CopyFrom(FParams);
      FHandlers.Add(Result);
      Met.Code:=FCode;
      Met.Data:=Result;
      SetMethodProp(Obj,Name,Met);
    end;
  end;
end;

{ TBisScriptClassTypeEvents }

constructor TBisScriptClassTypeEvents.Create(AParent: TBisScriptClassType);
begin
  inherited Create(AParent);
end;

function TBisScriptClassTypeEvents.Find(Name: String): TBisScriptClassTypeEvent;
begin
  Result:=TBisScriptClassTypeEvent(inherited Find(Name));
end;

function TBisScriptClassTypeEvents.GetItem(Index: Integer): TBisScriptClassTypeEvent;
begin
  Result:=TBisScriptClassTypeEvent(inherited Items[Index]);
end;

function TBisScriptClassTypeEvents.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassTypeEvent;
end;

function TBisScriptClassTypeEvents.Add(Name: String; TypeName: String; Code: Pointer): TBisScriptClassTypeEvent;
begin
  Result:=TBisScriptClassTypeEvent(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FTypeName:=TypeName;
    Result.FCode:=Code;
  end;
end;

{ TBisScriptClassType }

constructor TBisScriptClassType.Create;
begin
  inherited Create;
  FFields:=TBisScriptClassTypeFields.Create(Self);
  FProps:=TBisScriptClassTypeProps.Create(Self);
  FMethods:=TBisScriptClassTypeMethods.Create(Self);
  FEvents:=TBisScriptClassTypeEvents.Create(Self);
end;

destructor TBisScriptClassType.Destroy;
begin
  FEvents.Free;
  FMethods.Free;
  FProps.Free;
  FFields.Free;
  inherited Destroy;
end;


end.
