unit BisScriptClass;

interface

uses Contnrs,
     BisScriptSymbols, BisScriptType, BisScriptParams, BisScriptFuncs;

type
  TBisScriptClass=class;

  TBisScriptClassField=class(TBisScriptSymbol)
  private
    FParent: TBisScriptClass;
    FTypeName: String;
  public
    property Parent: TBisScriptClass read FParent;
    property TypeName: String read FTypeName;
  end;

  TBisScriptClassFields=class(TBisScriptSymbols)
  private
    FParent: TBisScriptClass;
    function GetItem(Index: Integer): TBisScriptClassField;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClass); reintroduce;
    function Find(Name: String): TBisScriptClassField; reintroduce;
    function Add(Name: String; TypeName: String): TBisScriptClassField; reintroduce;

    property Items[Index: Integer]: TBisScriptClassField read GetItem; default;
    property Parent: TBisScriptClass read FParent;
  end;

  TBisScriptClassProp=class;

  TBisScriptClassPropGetValue=function(Prop: TBisScriptClassProp; Obj: TObject): Variant of object;

  TBisScriptClassPropSetValue=procedure(Prop: TBisScriptClassProp; Obj: TObject; Value: Variant) of object;

  TBisScriptClassProp=class(TBisScriptSymbol)
  private
    FParent: TBisScriptClass;
    FTypeName: String;
    FOnGetValue: TBisScriptClassPropGetValue;
    FOnSetValue: TBisScriptClassPropSetValue;
  public
    function GetValue(Obj: TObject): Variant;
    procedure SetValue(Obj: TObject; Value: Variant);

    property Parent: TBisScriptClass read FParent;
    property TypeName: String read FTypeName;

    property OnGetValue: TBisScriptClassPropGetValue read FOnGetValue;
    property OnSetValue: TBisScriptClassPropSetValue read FOnSetValue;
  end;

  TBisScriptClassProps=class(TBisScriptSymbols)
  private
    FParent: TBisScriptClass;
    function GetItem(Index: Integer): TBisScriptClassProp;
    function GetPublishedPropValue(Prop: TBisScriptClassProp; Obj: TObject): Variant;
    procedure SetPublishedPropValue(Prop: TBisScriptClassProp; Obj: TObject; Value: Variant);
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClass); reintroduce;
    function Find(Name: String): TBisScriptClassProp; reintroduce;
    function Add(Name: String; TypeName: String;
                 OnGetValue: TBisScriptClassPropGetValue=nil;
                 OnSetValue: TBisScriptClassPropSetValue=nil): TBisScriptClassProp; reintroduce; overload;
    function Add(Name: String): TBisScriptClassProp; reintroduce; overload;
    procedure AddByClass;

    property Items[Index: Integer]: TBisScriptClassProp read GetItem; default;
    property Parent: TBisScriptClass read FParent;
  end;

  TBisScriptClassMethod=class;

  TBisScriptClassMethodExecute=function(Method: TBisScriptClassMethod; var Obj: TObject): Variant of object;

  TBisScriptClassMethodKind=(scmkConstructor,scmkDestructor,scmkProcedure,scmkFunction);

  TBisScriptClassMethod=class(TBisScriptSymbol)
  private
    FParams: TBisScriptParams;
    FResultType: String;
    FOnExecute: TBisScriptClassMethodExecute;
    FParent: TBisScriptClass;
    FKind: TBisScriptClassMethodKind;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Execute(var Obj: TObject): Variant;

    property Parent: TBisScriptClass read FParent;
    property ResultType: String read FResultType;
    property Params: TBisScriptParams read FParams;
    property Kind: TBisScriptClassMethodKind read FKind;

    property OnExecute: TBisScriptClassMethodExecute read FOnExecute;
  end;

  TBisScriptClassMethods=class(TBisScriptSymbols)
  private
    FParent: TBisScriptClass;
    function GetItem(Index: Integer): TBisScriptClassMethod;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClass); reintroduce;
    function Find(Name: String): TBisScriptClassMethod; reintroduce;
    function Add(Name: String; OnExecute: TBisScriptClassMethodExecute;
                 Kind: TBisScriptClassMethodKind; ResultType: String=''): TBisScriptClassMethod; reintroduce;
    function AddConstructor(Name: String; OnExecute: TBisScriptClassMethodExecute): TBisScriptClassMethod;
    function AddDestructor(Name: String; OnExecute: TBisScriptClassMethodExecute): TBisScriptClassMethod;
    function AddProcedure(Name: String; OnExecute: TBisScriptClassMethodExecute): TBisScriptClassMethod;
    function AddFunction(Name: String; OnExecute: TBisScriptClassMethodExecute; ResultType: String): TBisScriptClassMethod;

    property Items[Index: Integer]: TBisScriptClassMethod read GetItem; default;
    property Parent: TBisScriptClass read FParent;
  end;

  TBisScriptClassEvent=class;

  TBisScriptClassEventHandler=class;

  TBisScriptClassEventHandlerExecute=function(Handler: TBisScriptClassEventHandler): Variant of object;

  TBisScriptClassEventHandler=class(TObject)
  private
    FParams: TBisScriptParams;
    FObj: TObject;
    FParent: TBisScriptClassEvent;
    FOnExecute: TBisScriptClassEventHandlerExecute;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute: Variant;

    property Params: TBisScriptParams read FParams;
    property Obj: TObject read FObj;
    property Parent: TBisScriptClassEvent read FParent;
    property OnExecute: TBisScriptClassEventHandlerExecute read FOnExecute;
  end;

  TBisScriptClassEventHandlers=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisScriptClassEventHandler;
  public
    function Find(Obj: TObject): TBisScriptClassEventHandler;

    property Items[Index: Integer]: TBisScriptClassEventHandler read GetItem; default;
  end;

  TBisScriptClassEvent=class(TBisScriptClassProp)
  private
    FCode: Pointer;
    FTypeName: String;
    FHandlers: TBisScriptClassEventHandlers;
    FParams: TBisScriptParams;
  public
    constructor Create; override;
    destructor Destroy; override;

    function AddHandler(Obj: TObject; OnExecute: TBisScriptClassEventHandlerExecute): TBisScriptClassEventHandler;
    procedure RemoveHandler(Obj: TObject);

    property TypeName: String read FTypeName;
    property Params: TBisScriptParams read FParams;
  end;

  TBisScriptClassEvents=class(TBisScriptClassProps)
  private
    function GetItem(Index: Integer): TBisScriptClassEvent;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    constructor Create(AParent: TBisScriptClass); reintroduce;
    function Find(Name: String): TBisScriptClassEvent; reintroduce;
    function Add(Name: String; TypeName: String; Code: Pointer): TBisScriptClassEvent; reintroduce;

    property Items[Index: Integer]: TBisScriptClassEvent read GetItem; default;
  end;

  TBisScriptClass=class(TBisScriptType)
  private
    FValue: TClass;
    FFields: TBisScriptClassFields;
    FProps: TBisScriptClassProps;
    FMethods: TBisScriptClassMethods;
    FEvents: TBisScriptClassEvents;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Value: TClass read FValue write FValue;
    property Fields: TBisScriptClassFields read FFields;
    property Props: TBisScriptClassProps read FProps;
    property Methods: TBisScriptClassMethods read FMethods;
    property Events: TBisScriptClassEvents read FEvents;
  end;

implementation

uses TypInfo;

{ TBisScriptClassProp }

function TBisScriptClassProp.GetValue(Obj: TObject): Variant;
begin
  if Assigned(FOnGetValue) then
    Result:=FOnGetValue(Self,Obj);
end;

procedure TBisScriptClassProp.SetValue(Obj: TObject; Value: Variant);
begin
  if Assigned(FOnSetValue) then
    FOnSetValue(Self,Obj,Value);
end;

{ TBisScriptClassProps }

constructor TBisScriptClassProps.Create(AParent: TBisScriptClass);
begin
  inherited Create;
  FParent:=AParent;
end;

function TBisScriptClassProps.Find(Name: String): TBisScriptClassProp;
begin
  Result:=TBisScriptClassProp(inherited Find(Name));
end;

function TBisScriptClassProps.GetItem(Index: Integer): TBisScriptClassProp;
begin
  Result:=TBisScriptClassProp(inherited Items[Index]);
end;

function TBisScriptClassProps.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassProp;
end;

function TBisScriptClassProps.Add(Name: String; TypeName: String;
                                  OnGetValue: TBisScriptClassPropGetValue=nil;
                                  OnSetValue: TBisScriptClassPropSetValue=nil): TBisScriptClassProp;
begin
  Result:=TBisScriptClassProp(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FParent:=Parent;
    Result.FTypeName:=TypeName;
    Result.FOnGetValue:=OnGetValue;
    Result.FOnSetValue:=OnSetValue;
  end;
end;

function TBisScriptClassProps.GetPublishedPropValue(Prop: TBisScriptClassProp; Obj: TObject): Variant;
begin
  Result:=GetPropValue(Obj,Prop.Name);
end;

procedure TBisScriptClassProps.SetPublishedPropValue(Prop: TBisScriptClassProp; Obj: TObject; Value: Variant);
begin
  SetPropValue(Obj,Prop.Name,Value);
end;

function TBisScriptClassProps.Add(Name: String): TBisScriptClassProp;
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

procedure TBisScriptClassProps.AddByClass;
var
  i: Integer;
  TypeData: PTypeData;
  PropList: PPropList;
  PropName: String;
  TypeName: String;
  Include: Boolean;
  Prop: TBisScriptClassProp;
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

{ TBisScriptClassFields }

constructor TBisScriptClassFields.Create(AParent: TBisScriptClass);
begin
  inherited Create;
  FParent:=AParent;
end;

function TBisScriptClassFields.Find(Name: String): TBisScriptClassField;
begin
  Result:=TBisScriptClassField(inherited Find(Name));
end;

function TBisScriptClassFields.GetItem(Index: Integer): TBisScriptClassField;
begin
  Result:=TBisScriptClassField(inherited Items[Index]);
end;

function TBisScriptClassFields.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassField;
end;

function TBisScriptClassFields.Add(Name: String; TypeName: String): TBisScriptClassField;
begin
  Result:=TBisScriptClassField(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FParent:=Parent;
    Result.FTypeName:=TypeName;
  end;
end;

{ TBisScriptClassMethod }

constructor TBisScriptClassMethod.Create;
begin
  inherited Create;
  FParams:=TBisScriptParams.Create;
end;

destructor TBisScriptClassMethod.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisScriptClassMethod.Execute(var Obj: TObject): Variant;
begin
  if Assigned(FOnExecute) then
    Result:=FOnExecute(Self,Obj);
end;

{ TBisScriptClassMethods }

constructor TBisScriptClassMethods.Create(AParent: TBisScriptClass);
begin
  inherited Create;
  FParent:=AParent;
end;

function TBisScriptClassMethods.Find(Name: String): TBisScriptClassMethod;
begin
  Result:=TBisScriptClassMethod(inherited Find(Name));
end;

function TBisScriptClassMethods.GetItem(Index: Integer): TBisScriptClassMethod;
begin
  Result:=TBisScriptClassMethod(inherited Items[Index]);
end;

function TBisScriptClassMethods.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassMethod;
end;

function TBisScriptClassMethods.Add(Name: String; OnExecute: TBisScriptClassMethodExecute;
                                    Kind: TBisScriptClassMethodKind; ResultType: String=''): TBisScriptClassMethod;
begin
  Result:=TBisScriptClassMethod(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FParent:=Parent;
    Result.FOnExecute:=OnExecute;
    Result.FResultType:=ResultType;
    Result.FKind:=Kind;
  end;
end;

function TBisScriptClassMethods.AddConstructor(Name: String; OnExecute: TBisScriptClassMethodExecute): TBisScriptClassMethod;
begin
  Result:=Add(Name,OnExecute,scmkConstructor);
end;

function TBisScriptClassMethods.AddDestructor(Name: String; OnExecute: TBisScriptClassMethodExecute): TBisScriptClassMethod;
begin
  Result:=Add(Name,OnExecute,scmkDestructor);
end;

function TBisScriptClassMethods.AddProcedure(Name: String; OnExecute: TBisScriptClassMethodExecute): TBisScriptClassMethod;
begin
  Result:=Add(Name,OnExecute,scmkProcedure);
end;

function TBisScriptClassMethods.AddFunction(Name: String; OnExecute: TBisScriptClassMethodExecute; ResultType: String): TBisScriptClassMethod;
begin
  Result:=Add(Name,OnExecute,scmkFunction,ResultType);
end;

{ TBisScriptClassEventHandler }

constructor TBisScriptClassEventHandler.Create;
begin
  inherited Create;
  FParams:=TBisScriptParams.Create;
end;

destructor TBisScriptClassEventHandler.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisScriptClassEventHandler.Execute: Variant;
begin
  if Assigned(FOnExecute) then
    Result:=FOnExecute(Self);
end;

{ TBisScriptClassEventHandlers }

function TBisScriptClassEventHandlers.GetItem(Index: Integer): TBisScriptClassEventHandler;
begin
  Result:=TBisScriptClassEventHandler(inherited Items[Index]);
end;

function TBisScriptClassEventHandlers.Find(Obj: TObject): TBisScriptClassEventHandler;
var
  i: Integer;
  Item: TBisScriptClassEventHandler;
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

{ TBisScriptClassEvent }

constructor TBisScriptClassEvent.Create;
begin
  inherited Create;
  FHandlers:=TBisScriptClassEventHandlers.Create;
  FParams:=TBisScriptParams.Create;
  FCode:=nil;
end;

destructor TBisScriptClassEvent.Destroy;
begin
  FParams.Free;
  FHandlers.Free;
  inherited Destroy;
end;

procedure TBisScriptClassEvent.RemoveHandler(Obj: TObject);
var
  Met: TMethod;
  Handler: TBisScriptClassEventHandler;
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

function TBisScriptClassEvent.AddHandler(Obj: TObject; OnExecute: TBisScriptClassEventHandlerExecute): TBisScriptClassEventHandler;
var
  Met: TMethod;
begin
  Result:=nil;
  if Assigned(Obj) then begin
    RemoveHandler(Obj);
    if Assigned(OnExecute) then begin
      Result:=TBisScriptClassEventHandler.Create;
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

{ TBisScriptClassEvents }

constructor TBisScriptClassEvents.Create(AParent: TBisScriptClass);
begin
  inherited Create(AParent);
end;

function TBisScriptClassEvents.Find(Name: String): TBisScriptClassEvent;
begin
  Result:=TBisScriptClassEvent(inherited Find(Name));
end;

function TBisScriptClassEvents.GetItem(Index: Integer): TBisScriptClassEvent;
begin
  Result:=TBisScriptClassEvent(inherited Items[Index]);
end;

function TBisScriptClassEvents.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptClassEvent;
end;

function TBisScriptClassEvents.Add(Name: String; TypeName: String; Code: Pointer): TBisScriptClassEvent;
begin
  Result:=TBisScriptClassEvent(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FTypeName:=TypeName;
    Result.FCode:=Code;
  end;
end;

{ TBisScriptClass }

constructor TBisScriptClass.Create;
begin
  inherited Create;
  Kind:=stkClass;
  FFields:=TBisScriptClassFields.Create(Self);
  FProps:=TBisScriptClassProps.Create(Self);
  FMethods:=TBisScriptClassMethods.Create(Self);
  FEvents:=TBisScriptClassEvents.Create(Self);
end;

destructor TBisScriptClass.Destroy;
begin
  FEvents.Free;
  FMethods.Free;
  FProps.Free;
  FFields.Free;
  inherited Destroy;
end;


end.