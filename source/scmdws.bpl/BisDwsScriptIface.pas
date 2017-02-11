unit BisDwsScriptIface;

interface

uses Classes, Contnrs,
     dws2Comp, dws2Exprs, dws2Symbols, dws2Functions, dws2Stack,
     BisScriptIface, BisScriptUnits,
     BisScriptType, BisScriptMethod, BisScriptClass,
     BisScriptTypes, BisScriptVars, BisScriptFuncs, BisScriptParams;

type

  TBisDwsScriptUnit=class;

  TBisDwsFunction=class;

  TBisDwsFunctionExecute=procedure(Func: TBisDwsFunction) of object;

  TBisDwsFunction=class(TAnonymousFunction)
  private
    FOnExecute: TBisDwsFunctionExecute;
  public
    procedure Call(Caller: TProgram; Func: TFuncSymbol; Expr: TExpr); override;
    procedure Execute; override;
    property OnExecute: TBisDwsFunctionExecute read FOnExecute write FOnExecute;
  end;

  TBisDwsAliasSymbol=class(TAliasSymbol)
  private
    FType: TBisScriptType;
    FUnit: TBisDwsScriptUnit;
  public
    constructor Create(Typ: TTypeSymbol; AType: TBisScriptType; AUnit: TBisDwsScriptUnit); reintroduce;
  end;

  TBisDwsMethodSymbol=class(TMethodSymbol)
  private
    FType: TBisScriptMethod;
    FUnit: TBisDwsScriptUnit;
  public
    constructor Create(AType: TBisScriptMethod; AUnit: TBisDwsScriptUnit); reintroduce;
    function IsCompatible(typSym: TSymbol): Boolean; override;
  end;

  TBisDwsClassSymbol=class;

  TBisDwsClassFieldSymbol=class(TFieldSymbol)
  private
    FField: TBisScriptClassField;
    FUnit: TBisDwsScriptUnit;
    FClassSymbol: TBisDwsClassSymbol;
  public
    constructor Create(Typ: TSymbol; AField: TBisScriptClassField;
                       AUnit: TBisDwsScriptUnit; AClassSymbol: TBisDwsClassSymbol); reintroduce;
  end;

  TBisDwsClassPropertySymbol=class(TPropertySymbol)
  private
    FReadMet: TMethodSymbol;
    FWriteMet: TMethodSymbol;
    FGetValue: TBisDwsFunction;
    FSetValue: TBisDwsFunction;
    FProp: TBisScriptClassProp;
    FUnit: TBisDwsScriptUnit;
    FTable: TSymbolTable;
    FClassSymbol: TBisDwsClassSymbol;
  protected
    procedure GetValue(Func: TBisDwsFunction); virtual;
    procedure SetValue(Func: TBisDwsFunction); virtual;
  public
    constructor Create(Typ: TSymbol; AProp: TBisScriptClassProp;
                       AUnit: TBisDwsScriptUnit; ATable: TSymbolTable; AClassSymbol: TBisDwsClassSymbol); reintroduce;
    function IsCompatible(typSym: TSymbol): Boolean; override;                       
  end;

  TBisDwsClassEventSymbol=class;

  TBisDwsClassEventHandler=class(TObject)
  private
    FInfo: IInfo;
    FEvent: TBisScriptClassEvent;
    FObj: TObject;
    FFuncName: String;

    function Execute(Handler: TBisScriptClassEventHandler): Variant;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetupHandler;

    property Info: IInfo read FInfo;
    property Obj: TObject read FObj;
    property FuncName: String read FFuncName; 
  end;

  TBisDwsClassEventHandlers=class(TObjectList)
  public
    function Find(Obj: TObject): TBisDwsClassEventHandler;
    function AddHandler(Event: TBisScriptClassEvent; Obj: TObject; AInfo: IInfo; FuncName: String): TBisDwsClassEventHandler;
    procedure RemoveHandler(Obj: TObject);
  end;

  TBisDwsClassEventSymbol=class(TBisDwsClassPropertySymbol)
  private
    FHandlers: TBisDwsClassEventHandlers;
    FEvent: TBisScriptClassEvent;
    function GetInfo(Func: TBisDwsFunction; var FuncName: String): IInfo;
  protected
    procedure GetValue(Func: TBisDwsFunction); override;
    procedure SetValue(Func: TBisDwsFunction); override;
  public
    constructor Create(Typ: TSymbol; AEvent: TBisScriptClassEvent;
                       AUnit: TBisDwsScriptUnit; ATable: TSymbolTable; AClassSymbol: TBisDwsClassSymbol); reintroduce;
    destructor Destroy; override;
    function IsCompatible(typSym: TSymbol): Boolean; override;

  end;

  TBisDwsClassMethodSymbol=class(TMethodSymbol)
  private
    FMethod: TBisScriptClassMethod;
    FUnit: TBisDwsScriptUnit;
    FTable: TSymbolTable;
    FClassSymbol: TBisDwsClassSymbol;
    FExecute: TBisDwsFunction;
    procedure GetParameters(Table: TSymbolTable);
    procedure Execute(Func: TBisDwsFunction);
  public
    constructor Create(AMethod: TBisScriptClassMethod;
                       AUnit: TBisDwsScriptUnit; ATable: TSymbolTable; AClassSymbol: TBisDwsClassSymbol); reintroduce;
  end;

  TBisDwsClassSymbol=class(TClassSymbol)
  private
    FClass: TBisScriptClass;
    FUnit: TBisDwsScriptUnit;
    FTable: TSymbolTable;
    function TableFindLocal(Table: TSymbolTable; const Name: String): TSymbol;
  public
    constructor Create(AClass: TBisScriptClass; AUnit: TBisDwsScriptUnit; ATable: TSymbolTable); reintroduce;
    procedure CreateClassFields;
    procedure CreateClassProps;
    procedure CreateClassEvents;
    procedure CreateClassMethods;
  end;

  TBisDwsVarSymbol=class(TExternalVarSymbol)
  private
    FGetValueFunc: TBisDwsFunction;
    FSetValueFunc: TBisDwsFunction;
    FVar: TBisScriptVar;
    FUnit: TBisDwsScriptUnit;
    procedure GetValue(Func: TBisDwsFunction);
    procedure SetValue(Func: TBisDwsFunction);
  public
    constructor Create(Typ: TSymbol; AVar: TBisScriptVar; AUnit: TBisDwsScriptUnit); reintroduce;
  end;

  TBisDwsFuncSymbol=class(TFuncSymbol)
  private
    FExecute: TBisDwsFunction;
    FFunc: TBisScriptFunc;
    FUnit: TBisDwsScriptUnit;
    FTable: TSymbolTable;
    procedure GetParameters(Table: TSymbolTable);
    procedure Execute(Func: TBisDwsFunction);
  public
    constructor Create(AFunc: TBisScriptFunc; AUnit: TBisDwsScriptUnit; ATable: TSymbolTable); reintroduce;
    destructor Destroy; override;
  end;

  TBisDwsScriptUnitFindSymbol=function (AUnit: TBisDwsScriptUnit; const Name: String): TSymbol of object;

  TBisDwsScriptUnit=class(Tdws2AbstractStaticUnit)
  private
    FScriptUnit: TBisScriptUnit;
    FUnitTable: TSymbolTable;
    FOnFindSymbol: TBisDwsScriptUnitFindSymbol;

    function FindType(ATypeName: String; var Ret: TSymbol; Table: TSymbolTable): Boolean;
    function FindVar(AVarName: String; var Ret: TSymbol; Table: TSymbolTable): Boolean;
    function FindFunc(AFuncName: String; var Ret: TSymbol; Table: TSymbolTable): Boolean;

    function UnitTableFindSymbol(const Name: String): TSymbol;
    function TableFindLocal(Table: TSymbolTable; const Name: String): TSymbol;
    function DoFindSymbol(const Name: String): TSymbol;
  public
    constructor Create(AOwner: TComponent); override;

    function GetUnitName: String; override;
    procedure AddUnitSymbols(Table: TSymbolTable); override;

    property ScriptUnit: TBisScriptUnit read FScriptUnit;
    property UnitTable: TSymbolTable read FUnitTable;

    property OnFindSymbol: TBisDwsScriptUnitFindSymbol read FOnFindSymbol write FOnFindSymbol;
  end;

  TBisDwsScriptUnits=class(TObjectList)
  public
    function Find(Name: String): TBisDwsScriptUnit;
  end;

  TBisDwsScript=class(TDelphiWebScriptII)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDwsScriptIface=class;

  TBisIfaceScriptUnit=class(TBisScriptUnit)
  private
    FIface: TBisDwsScriptIface;
  public
    constructor Create(AOwner: TComponent); override;

    property Iface: TBisDwsScriptIface read FIface write FIface;
  end;

  TBisDwsScriptIface=class(TBisScriptIface)
  private
    FDel: TObject;
    FScript: TBisDwsScript;
    FProgram: TProgram;
    FIfaceUnit: TBisIfaceScriptUnit;
    FUnits: TBisDwsScriptUnits;
    function AddUnit(ScriptUnit: TBisScriptUnit): TBisDwsScriptUnit;
    procedure ScriptUses(const UnitName: String; var UnitList: TInterfaceList);
    function UnitFindSymbol(AUnit: TBisDwsScriptUnit; const Name: String): TSymbol;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Show; override;
  end;

implementation

uses SysUtils, Variants, TypInfo,
     dws2Errors, dws2Strings, BisDwsConsts, BrowserFrm,
     BisUtils, BisDialogs, BisCore, BisObjectModules, BisScriptUtils;

function GetTypeKind(Sym: TSymbol): TBisScriptTypeKind;
begin
  Result:=stkUnknown;
  if Assigned(Sym) then begin
    if Sym is TBisDwsAliasSymbol then
      Result:=TBisDwsAliasSymbol(Sym).FType.Kind
    else if (Sym is TClassSymbol) then
      Result:=stkClass;
  end;
end;

function GetSelfObject(Func: TBisDwsFunction): TObject;
var
  scriptObj: IScriptObj;
begin
  Result:=nil;

  if Assigned(Func) and Assigned(Func.Info) then begin

    scriptObj:=Func.Info.Vars[SSelf].ScriptObj;
    Func.Info.ScriptObj:=scriptObj;

    if Assigned(Func.Info.ScriptObj) then
      Result:=Func.Info.ScriptObj.ExternalObject;

  end;
end;

function ValueToScript(TypeKind: TBisScriptTypeKind; Info: TProgramInfo; Value: Variant): Variant; overload;
begin
  Result:=Null;
  case TypeKind of
    stkUnknown: Result:=Value;
    stkInteger: Result:=ScriptTypeAsInteger(Value);
    stkFloat: Result:=ScriptTypeAsFloat(Value);
    stkString: Result:=ScriptTypeAsString(Value);
    stkDateTime: Result:=ScriptTypeAsDateTime(Value);
    stkBoolean: Result:=ScriptTypeAsBoolean(Value);
    stkVariant: Result:=Value;
    stkMethod: Result:=Value;
    stkClass: Result:=Info.RegisterExternalObject(ScriptTypeAsObject(Value),false,false);
  end;
end;

function ValueToScript(TypeKind: TBisScriptTypeKind; Info: IInfo; Value: Variant): Variant; overload;
begin
  Result:=Null;
  case TypeKind of
    stkUnknown: Result:=Value;
    stkInteger: Result:=ScriptTypeAsInteger(Value);
    stkFloat: Result:=ScriptTypeAsFloat(Value);
    stkString: Result:=ScriptTypeAsString(Value);
    stkDateTime: Result:=ScriptTypeAsDateTime(Value);
    stkBoolean: Result:=ScriptTypeAsBoolean(Value);
    stkVariant: Result:=Value;
    stkMethod: Result:=Value;
    stkClass: Result:=Info.RegisterExternalObject(ScriptTypeAsObject(Value),false,false);
  end;
end;

function ScriptToValue(TypeKind: TBisScriptTypeKind; Info: TProgramInfo; Name: String): Variant;
var
  scriptObj: IScriptObj;
  Value: Variant;
begin
  Result:=Null;
  Value:=Info.Vars[Name].Value;;
  case TypeKind of
    stkUnknown: Result:=Value;
    stkInteger: Result:=IntegerAsScriptType(Value);
    stkFloat: Result:=FloatAsScriptType(Value);
    stkString: Result:=StringAsScriptType(Value);
    stkDateTime: Result:=DateTimeAsScriptType(Value);
    stkBoolean: Result:=BooleanAsScriptType(Value);
    stkVariant: Result:=Value;
    stkMethod: Result:=Value;
    stkClass: begin
      scriptObj:=Info.Vars[Name].ScriptObj;
      if Assigned(scriptObj) then
        Result:=ObjectAsScriptType(scriptObj.ExternalObject);
    end;
  end;  
end;

{ TBisDwsFunction }

procedure TBisDwsFunction.Call(Caller: TProgram; Func: TFuncSymbol; Expr: TExpr);
begin
  FInfo.Caller:=Caller;
  FInfo.FuncSym:=Func;
  if Expr is TFuncExpr then
     FInfo.FuncExpr:=TFuncExpr(Expr);
  Execute;   
end;

procedure TBisDwsFunction.Execute;
begin
  if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

{ TBisDwsAliasSymbol }

constructor TBisDwsAliasSymbol.Create(Typ: TTypeSymbol; AType: TBisScriptType; AUnit: TBisDwsScriptUnit);
begin
  inherited Create(AType.Name,Typ);
  FType:=AType;
  FUnit:=AUnit;
end;

{ TBisDwsMethodSymbol }

constructor TBisDwsMethodSymbol.Create(AType: TBisScriptMethod; AUnit: TBisDwsScriptUnit);
var
  FuncKind: TFuncKind;
begin
  FuncKind:=dws2Symbols.fkProcedure;
  case AType.MethodKind of
    smtkProcedure: FuncKind:=dws2Symbols.fkProcedure;
    smtkFunction: FuncKind:=dws2Symbols.fkFunction;
  end;

  inherited Create(AType.Name,FuncKind,TClassSymbol(AUnit.DoFindSymbol(SYS_TOBJECT)),-1);

  FType:=AType;
  FUnit:=AUnit;

end;


function TBisDwsMethodSymbol.IsCompatible(typSym: TSymbol): Boolean;
var
  funcSym: TFuncSymbol;
//  i: Integer;
//  Param: TBisScriptParam;
  Flag: Boolean;
begin
  Result:=inherited IsCompatible(typSym);
  if not Result then begin
    if (typSym is TFuncSymbol) then begin
      funcSym:=TFuncSymbol(typSym);
      if (Kind=funcSym.Kind) and (FType.Params.Count=funcSym.Params.Count) then begin

        Flag:=true;
{        for i:=0 to FType.Params.Count-1 do begin
          Param:=FType.Params[i];
          if not AnsiSameText(Param.Name,funcSym.Params[i].Name) then begin
            Flag:=false;
            break;
          end;
        end;}

        // Need Check Params

        Result:=Flag;
      end;
    end;
  end;
end;

{ TBisDwsClassFieldSymbol }

constructor TBisDwsClassFieldSymbol.Create(Typ: TSymbol; AField: TBisScriptClassField;
                                           AUnit: TBisDwsScriptUnit; AClassSymbol: TBisDwsClassSymbol);
begin
  inherited Create(AField.Name,Typ);
  FField:=AField;
  FUnit:=AUnit;
  FClassSymbol:=AClassSymbol;
end;

{ TBisDwsClassPropertySymbol }

constructor TBisDwsClassPropertySymbol.Create(Typ: TSymbol; AProp: TBisScriptClassProp;
                                              AUnit: TBisDwsScriptUnit; ATable: TSymbolTable; AClassSymbol: TBisDwsClassSymbol);
begin
  inherited Create(AProp.Name,Typ);
  FProp:=AProp;
  FUnit:=AUnit;
  FTable:=ATable;
  FClassSymbol:=AClassSymbol;

  if Assigned(FProp.OnGetValue) then begin

    FReadMet:=TMethodSymbol.Generate(FTable,dws2Symbols.mkFunction,[],'',nil,AProp.TypeName,FClassSymbol);

//    GetParameters(FTable);
    FReadMet.Params.AddParent(FTable);

    FGetValue:=TBisDwsFunction.Create(FReadMet);
    FGetValue.OnExecute:=GetValue;

    FReadMet.Executable:=ICallable(FGetValue);
    ReadSym:=FReadMet;
  end;

  if Assigned(FProp.OnSetValue) then begin

    FWriteMet:=TMethodSymbol.Generate(FTable,dws2Symbols.mkProcedure,[],'',nil,'',FClassSymbol);
    FWriteMet.AddParam(TParamSymbol.Create(SValue,Typ));

//    GetParameters(FTable);
    FWriteMet.Params.AddParent(FTable);

    FSetValue:=TBisDwsFunction.Create(FWriteMet);
    FSetValue.OnExecute:=SetValue;

    FWriteMet.Executable:=ICallable(FSetValue);
    WriteSym:=FWriteMet;
  end;

end;

function TBisDwsClassPropertySymbol.IsCompatible(typSym: TSymbol): Boolean;
begin
  Result:=inherited IsCompatible(typSym);
end;

procedure TBisDwsClassPropertySymbol.GetValue(Func: TBisDwsFunction);
var
  Obj: TObject;
  Ret: Variant;
begin
  Obj:=GetSelfObject(Func);
  Ret:=FProp.GetValue(Obj);
  Func.Info.Result:=ValueToScript(GetTypeKind(Typ),Func.Info,Ret);
end;

procedure TBisDwsClassPropertySymbol.SetValue(Func: TBisDwsFunction);
var
  Obj: TObject;
  V: Variant;
begin
  Obj:=GetSelfObject(Func);
  V:=ScriptToValue(GetTypeKind(Typ),Func.Info,SValue);
  FProp.SetValue(Obj,V);
end;

{ TBisDwsClassEventHandler }

constructor TBisDwsClassEventHandler.Create;
begin
  inherited Create;
end;

destructor TBisDwsClassEventHandler.Destroy;
begin
  if Assigned(FEvent) then
    FEvent.RemoveHandler(FObj);
  FInfo:=nil;
  inherited Destroy;
end;

procedure TBisDwsClassEventHandler.SetupHandler;
begin
  if Assigned(FEvent) then begin
    if Assigned(FObj) then
      FEvent.AddHandler(FObj,Execute);
  end;
end;

function TBisDwsClassEventHandler.Execute(Handler: TBisScriptClassEventHandler): Variant;
var
  Param: TBisScriptParam; 
  Params: array of Variant;
  i: Integer;
  AInfo: IInfo;
begin
  if Assigned(FInfo) and Assigned(Handler) then begin
    SetLength(Params,Handler.Params.Count);
    for i:=0 to Handler.Params.Count-1 do begin
      Param:=Handler.Params[i];
      AInfo:=FInfo.Parameter[i];
      Params[i]:=ValueToScript(GetTypeKind(AInfo.TypeSym),FInfo,Param.Value);
    end;
    FInfo.Call(Params);
  end;
end;

{ TBisDwsClassEventHandlers }

function TBisDwsClassEventHandlers.Find(Obj: TObject): TBisDwsClassEventHandler;
var
  i: Integer;
  Item: TBisDwsClassEventHandler;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=TBisDwsClassEventHandler(Items[i]);
    if Item.Obj=Obj then begin
      Result:=Item;
      exit;
    end;
  end;
end;

procedure TBisDwsClassEventHandlers.RemoveHandler(Obj: TObject);
var
  Handler: TBisDwsClassEventHandler;
begin
  if Assigned(Obj) then begin
    Handler:=Find(Obj);
    if Assigned(Handler) then
      Remove(Handler);
  end;
end;

function TBisDwsClassEventHandlers.AddHandler(Event: TBisScriptClassEvent; Obj: TObject;
                                              AInfo: IInfo; FuncName: String): TBisDwsClassEventHandler;
begin
  Result:=nil;
  RemoveHandler(Obj);
  if Assigned(Obj) then begin
    Result:=TBisDwsClassEventHandler.Create;
    Result.FObj:=Obj;
    Result.FInfo:=AInfo;
    Result.FEvent:=Event;
    Result.FFuncName:=FuncName;
    Result.SetupHandler;
    inherited Add(Result);
  end;
end;

{ TBisDwsClassEventSymbol }

constructor TBisDwsClassEventSymbol.Create(Typ: TSymbol; AEvent: TBisScriptClassEvent; AUnit: TBisDwsScriptUnit;
                                           ATable: TSymbolTable; AClassSymbol: TBisDwsClassSymbol);
begin
  inherited Create(Typ,AEvent,AUnit,ATable,AClassSymbol);
  FEvent:=AEvent;
  FHandlers:=TBisDwsClassEventHandlers.Create;
end;

destructor TBisDwsClassEventSymbol.Destroy;
begin
  FHandlers.Free;
  inherited Destroy;
end;

function TBisDwsClassEventSymbol.IsCompatible(typSym: TSymbol): Boolean;
begin
  Result:=inherited IsCompatible(typSym);
end;

function TBisDwsClassEventSymbol.GetInfo(Func: TBisDwsFunction; var FuncName: String): IInfo;
var
  FuncSym: TFuncSymbol;
  FE: TExpr;
  FCE: TFuncCodeExpr;
begin
  Result:=nil;
  if Assigned(Func) then begin
    if Assigned(Func.Info) and Assigned(Func.Info.FuncExpr) then begin
      if Func.Info.FuncExpr.Args.Count>0 then begin
        FE:=Func.Info.FuncExpr.Args[0];
        if (FE is TFuncCodeExpr) then begin
          FCE:=TFuncCodeExpr(FE);
          if Assigned(FCE.FuncExpr) then begin
            FuncSym:=FCE.FuncExpr.FuncSym;
            if Assigned(FuncSym) then begin
              Func.Info.Table.AddSymbol(FuncSym);
              Result:=Func.Info.Method[FuncSym.Name];
              FuncName:=FuncSym.Name;
              Func.Info.Table.Remove(FuncSym);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisDwsClassEventSymbol.GetValue(Func: TBisDwsFunction);
begin
end;

procedure TBisDwsClassEventSymbol.SetValue(Func: TBisDwsFunction);
var
  Obj: TObject;
  Info: IInfo;
  FuncName: String;
begin
  Obj:=GetSelfObject(Func);
  if Assigned(Obj) then begin

    FuncName:='';
    Info:=GetInfo(Func,FuncName);

    if Assigned(Info) then
      FHandlers.AddHandler(FEvent,Obj,Info,FuncName)
    else
      FHandlers.RemoveHandler(Obj);

  end;
end;

{ TBisDwsClassMethodSymbol }

constructor TBisDwsClassMethodSymbol.Create(AMethod: TBisScriptClassMethod; AUnit: TBisDwsScriptUnit;
                                            ATable: TSymbolTable; AClassSymbol: TBisDwsClassSymbol);
var
  MethKind: dws2Symbols.TMethodKind;
begin
  MethKind:=dws2Symbols.mkProcedure;
  case AMethod.Kind of
    scmkConstructor: MethKind:=dws2Symbols.mkConstructor;
    scmkDestructor: MethKind:=dws2Symbols.mkDestructor;
    scmkProcedure: MethKind:=dws2Symbols.mkProcedure;
    scmkFunction: MethKind:=dws2Symbols.mkFunction;
  end;

  FMethod:=AMethod;
  FUnit:=AUnit;
  FTable:=ATable;
  FClassSymbol:=AClassSymbol;

  Generate(FTable,MethKind,[],FMethod.Name,nil,FMethod.ResultType,FClassSymbol);

  GetParameters(FTable);

  Params.AddParent(FTable);

  FExecute:=TBisDwsFunction.Create(Self);
  FExecute.OnExecute:=Execute;

  Executable:=ICallable(FExecute);
end;

procedure TBisDwsClassMethodSymbol.GetParameters(Table: TSymbolTable);
var
  i: Integer;
  Item: TBisScriptParam;
  Sym: TSymbol;
  ParamSym: TParamSymbol;
  IsVarParam: Boolean;
  IsWritable: Boolean;
  HasDefaultValue: Boolean;
  DefaultValue: TData;
begin
  for i:=0 to FMethod.Params.Count - 1 do begin
    Item:=FMethod.Params.Items[i];
    IsVarParam:=Item.Kind=spkVar;
    IsWritable:=Item.Kind=spkVar;
    HasDefaultValue:=Item.DefaultExists;

    if AnsiSameText(Item.TypeName,FMethod.Parent.Name) then
      Sym:=FClassSymbol
    else
      Sym:=FUnit.DoFindSymbol(Item.TypeName);

    if Assigned(Sym) then begin

      if IsVarParam then
        ParamSym:=TVarParamSymbol.Create(Item.Name,Sym,IsWritable)
      else
        ParamSym:=TParamSymbol.Create(Item.Name,Sym);

      if HasDefaultValue then begin
        SetLength(DefaultValue,1);
        DefaultValue[0]:=Item.DefaultValue;
        ParamSym.SetDefaultValue(DefaultValue,0);
      end;

      Params.AddSymbol(ParamSym);
    end else
      raise Exception.CreateFmt(CPE_TypeForParamNotFound,[Item.TypeName,Item.Name,Name]);
  end;
end;

procedure TBisDwsClassMethodSymbol.Execute(Func: TBisDwsFunction);

  procedure SetMethodParams;
  var
    i: Integer;
    Item: TBisScriptParam;
    Info: IInfo;
  begin
    for i:=0 to FMethod.Params.Count - 1 do begin
      Item:=FMethod.Params.Items[i];
      Info:=Func.Info.Vars[Item.Name];
      Item.Value:=ScriptToValue(GetTypeKind(Info.TypeSym),Func.Info,Item.Name);
//+      Item.Value:=Func.Info.Vars[Item.Name].Value;
    end;
  end;

  procedure GetMethodParams;
  var
    i: Integer;
    Item: TBisScriptParam;
    Info: IInfo;
  begin
    for i:=0 to FMethod.Params.Count - 1 do begin
      Item:=FMethod.Params.Items[i];
      Info:=Func.Info.Vars[Item.Name];
      if Item.Kind in [spkVar] then
        Func.Info.Vars[Item.Name].Value:=ValueToScript(GetTypeKind(Info.TypeSym),Func.Info,Item.Value);
//+        Func.Info.Vars[Item.Name].Value:=Item.Value;
    end;
  end;

  procedure SetObject(Obj: TObject);
  var
    scriptObj: IScriptObj;
  begin

    if not (Func.Info.FuncSym as TMethodSymbol).IsClassMethod then
      scriptObj:=Func.Info.Vars[SSelf].ScriptObj;

    Func.Info.ScriptObj:=scriptObj;

    if Assigned(Func.Info.ScriptObj) then
      Func.Info.ScriptObj.ExternalObject:=Obj;

  end;

var
  Ret: Variant;
  OldObj: TObject;
  NewObj: TObject;
begin
  SetMethodParams;
  OldObj:=GetSelfObject(Func);
  NewObj:=OldObj;
  Ret:=FMethod.Execute(NewObj);
  if OldObj<>NewObj then
    SetObject(NewObj);
  if FMethod.Kind=scmkFunction then
    Func.Info.Result:=ValueToScript(GetTypeKind(Typ),Func.Info,Ret);
  GetMethodParams;
end;

{ TBisDwsClassSymbol }

constructor TBisDwsClassSymbol.Create(AClass: TBisScriptClass; AUnit: TBisDwsScriptUnit; ATable: TSymbolTable);
begin
  inherited Create(AClass.Name);
  FClass:=AClass;
  FUnit:=AUnit;
  FTable:=ATable;
  FTable.OnFindLocal:=TableFindLocal;
end;

function TBisDwsClassSymbol.TableFindLocal(Table: TSymbolTable; const Name: String): TSymbol;
begin
  Result:=FUnit.DoFindSymbol(Name);
end;

procedure TBisDwsClassSymbol.CreateClassFields;
var
  AField: TBisScriptClassField;
  Sym: TSymbol;
  FieldSym: TFieldSymbol;
  i: Integer;
begin
  for i:=0 to FClass.Fields.Count-1 do begin
    AField:=FClass.Fields.Items[i];
    Sym:=FUnit.DoFindSymbol(AField.TypeName);
    if Assigned(Sym) and (Sym is TTypeSymbol) then begin
      FieldSym:=TBisDwsClassFieldSymbol.Create(Sym,AField,FUnit,Self);
      AddField(FieldSym);
    end;
  end;
end;

procedure TBisDwsClassSymbol.CreateClassProps;
var
  AProp: TBisScriptClassProp;
  Sym: TSymbol;
  PropSym: TPropertySymbol;
  i: Integer;
begin
  for i:=0 to FClass.Props.Count-1 do begin
    AProp:=FClass.Props.Items[i];
    Sym:=FUnit.DoFindSymbol(AProp.TypeName);
    if Assigned(Sym) and (Sym is TTypeSymbol) then begin
      PropSym:=TBisDwsClassPropertySymbol.Create(Sym,AProp,FUnit,FTable,Self);
      AddProperty(PropSym);
    end;
  end;
end;

procedure TBisDwsClassSymbol.CreateClassEvents;
var
  AEvent: TBisScriptClassEvent;
  Sym: TSymbol;
  PropSym: TPropertySymbol;
  i: Integer;
begin
  for i:=0 to FClass.Events.Count-1 do begin
    AEvent:=FClass.Events.Items[i];
    Sym:=FUnit.DoFindSymbol(AEvent.TypeName);
    if Assigned(Sym) and (Sym is TTypeSymbol) then begin
      PropSym:=TBisDwsClassEventSymbol.Create(Sym,AEvent,FUnit,FTable,Self);
      AddProperty(PropSym);
    end;
  end;
end;

procedure TBisDwsClassSymbol.CreateClassMethods;
var
  AMethod: TBisScriptClassMethod;
  MethodSym: TMethodSymbol;
  i: Integer;
begin
  for i:=0 to FClass.Methods.Count-1 do begin
    AMethod:=FClass.Methods.Items[i];
    MethodSym:=TBisDwsClassMethodSymbol.Create(AMethod,FUnit,FTable,Self);
    AddMethod(MethodSym);
  end;
end;

{ TBisDwsVarSymbol }

constructor TBisDwsVarSymbol.Create(Typ: TSymbol; AVar: TBisScriptVar; AUnit: TBisDwsScriptUnit);
begin
  inherited Create(AVar.Name,Typ);
  FVar:=AVar;
  FUnit:=AUnit;

  ReadFunc:=TFuncSymbol.Create('', dws2Symbols.fkFunction, 1);
  ReadFunc.Typ:=Typ;

  FGetValueFunc:=TBisDwsFunction.Create(ReadFunc);
  FGetValueFunc.OnExecute:=GetValue;

  ReadFunc.Executable:=ICallable(FGetValueFunc);

  if not FVar.ReadOnly then begin

    WriteFunc:=TFuncSymbol.Create('', dws2Symbols.fkProcedure, 1);
    WriteFunc.AddParam(TParamSymbol.Create(SValue,Typ));

    FSetValueFunc:=TBisDwsFunction.Create(WriteFunc);
    FSetValueFunc.OnExecute:=SetValue;

    WriteFunc.Executable:=ICallable(FSetValueFunc);
    
  end;
end;

procedure TBisDwsVarSymbol.GetValue(Func: TBisDwsFunction);
begin
  Func.Info.Result:=ValueToScript(GetTypeKind(Typ),Func.Info,FVar.Value);
end;

procedure TBisDwsVarSymbol.SetValue(Func: TBisDwsFunction);
begin
  FVar.Value:=ScriptToValue(GetTypeKind(Typ),Func.Info,SValue);
end;

{ TBisDwsFuncSymbol }

constructor TBisDwsFuncSymbol.Create(AFunc: TBisScriptFunc; AUnit: TBisDwsScriptUnit; ATable: TSymbolTable);
begin
  FFunc:=AFunc;
  FUnit:=AUnit;
  FTable:=ATable;

  Generate(FTable,AFunc.Name,nil,FFunc.ResultType);

  GetParameters(FTable);

  Params.AddParent(FTable);

  FExecute:=TBisDwsFunction.Create(Self);
  FExecute.OnExecute:=Execute;

  Executable:=ICallable(FExecute);
end;

destructor TBisDwsFuncSymbol.Destroy;
begin
  inherited Destroy;
end;

procedure TBisDwsFuncSymbol.GetParameters(Table: TSymbolTable);
var
  i: Integer;
  Item: TBisScriptParam;
  Sym: TSymbol;
  ParamSym: TParamSymbol;
  IsVarParam: Boolean;
  IsWritable: Boolean;
  HasDefaultValue: Boolean;
  DefaultValue: TData;
begin
  for i:=0 to FFunc.Params.Count - 1 do begin
    Item:=FFunc.Params.Items[i];
    IsVarParam:=Item.Kind=spkVar;
    IsWritable:=Item.Kind=spkVar;
    HasDefaultValue:=Item.DefaultExists;

    Sym:=FUnit.DoFindSymbol(Item.TypeName);
    if Assigned(Sym) then begin

      if IsVarParam then
        ParamSym:=TVarParamSymbol.Create(Item.Name,Sym,IsWritable)
      else
        ParamSym:=TParamSymbol.Create(Item.Name,Sym);

      if HasDefaultValue then begin
        SetLength(DefaultValue,1);
        DefaultValue[0]:=Item.DefaultValue;
        ParamSym.SetDefaultValue(DefaultValue,0);
      end;

      Params.AddSymbol(ParamSym);
    end else
      raise Exception.CreateFmt(CPE_TypeForParamNotFound,[Item.TypeName,Item.Name,Name]);
  end;
end;

procedure TBisDwsFuncSymbol.Execute(Func: TBisDwsFunction);

  procedure SetFuncParams;
  var
    i: Integer;
    Item: TBisScriptParam;
    Info: IInfo;
  begin
    for i:=0 to FFunc.Params.Count - 1 do begin
      Item:=FFunc.Params.Items[i];
      Info:=Func.Info.Vars[Item.Name];
      Item.Value:=ScriptToValue(GetTypeKind(Info.TypeSym),Func.Info,Item.Name);
//+      Item.Value:=Func.Info.Vars[Item.Name].Value;
    end;
  end;

  procedure GetFuncParams;
  var
    i: Integer;
    Item: TBisScriptParam;
    Info: IInfo;
  begin
    for i:=0 to FFunc.Params.Count - 1 do begin
      Item:=FFunc.Params.Items[i];
      Info:=Func.Info.Vars[Item.Name];
      if Item.Kind in [spkVar] then
        Func.Info.Vars[Item.Name].Value:=ValueToScript(GetTypeKind(Info.TypeSym),Func.Info,Item.Value);
//+        Func.Info.Vars[Item.Name].Value:=Item.Value;
    end;
  end;

var
  Ret: Variant;
begin
  SetFuncParams;
  Ret:=FFunc.Execute;
  if FFunc.Kind=fkFunction then
    Func.Info.Result:=ValueToScript(GetTypeKind(Typ),Func.Info,Ret);
  GetFuncParams;
end;

{ TBisDwsScriptUnit }

constructor TBisDwsScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  StaticSymbols:=false;
end;

function TBisDwsScriptUnit.GetUnitName: String;
begin
  Result:=inherited GetUnitName;
  if Assigned(FScriptUnit) then
    Result:=FScriptUnit.UnitName;
end;

procedure TBisDwsScriptUnit.AddUnitSymbols(Table: TSymbolTable);
begin
  FUnitTable:=nil;
  if Assigned(Table) then begin
    Table.OnFindLocal:=TableFindLocal;
    FUnitTable:=Table;
  end;
end;

function TBisDwsScriptUnit.DoFindSymbol(const Name: String): TSymbol;
var
  Event: TSymbolTableFindLocalEvent;
begin
  Result:=nil;
  if Assigned(FUnitTable) then begin
    Event:=FUnitTable.OnFindLocal;
    FUnitTable.OnFindLocal:=nil;
    try
      Result:=FUnitTable.FindLocal(Name);

      if not Assigned(Result) then
        Result:=TableFindLocal(FUnitTable,Name);
        
      if not Assigned(Result) and Assigned(FOnFindSymbol) then
        Result:=FOnFindSymbol(Self,Name);

      if not Assigned(Result) then
        Result:=FUnitTable.FindSymbol(Name);
    finally
      FUnitTable.OnFindLocal:=Event;
    end;
  end;
end;

function TBisDwsScriptUnit.UnitTableFindSymbol(const Name: String): TSymbol;
var
  Event: TSymbolTableFindLocalEvent;
begin
  Event:=FUnitTable.OnFindLocal;
  FUnitTable.OnFindLocal:=nil;
  try
    Result:=FUnitTable.FindSymbol(Name);
  finally
    FUnitTable.OnFindLocal:=Event;
  end;
end;

function TBisDwsScriptUnit.FindType(ATypeName: String; var Ret: TSymbol; Table: TSymbolTable): Boolean;
var
  AType: TBisScriptType;
  Sym: TSymbol;
  S: String;
begin
  Result:=false;
  if Assigned(FScriptUnit) then begin
    AType:=FScriptUnit.Types.Find(ATypeName);
    if Assigned(AType) then begin
      case AType.Kind of
        stkMethod: begin
          if AType is TBisScriptMethod then begin
            Ret:=TBisDwsMethodSymbol.Create(TBisScriptMethod(AType),Self);
            Result:=Assigned(Ret);
            if Result then
              FUnitTable.AddSymbol(Ret);
          end;
        end;
        stkClass: begin
          if AType is TBisScriptClass then begin
            Sym:=nil;
            Ret:=nil;

            if Trim(AType.Ancestor)<>'' then begin
              Ret:=TBisDwsClassSymbol.Create(TBisScriptClass(AType),Self,Table);
              if Assigned(Ret) then begin
                TBisDwsClassSymbol(Ret).IsForward:=true;
                FUnitTable.AddSymbol(Ret);
              end;
              Sym:=DoFindSymbol(AType.Ancestor);
            end;

            if not Assigned(Sym) then begin
              Sym:=UnitTableFindSymbol(SYS_TOBJECT);
              Ret:=TBisDwsClassSymbol.Create(TBisScriptClass(AType),Self,Table);
              if Assigned(Ret) then begin
                TBisDwsClassSymbol(Ret).IsForward:=true;
                FUnitTable.AddSymbol(Ret);
              end;
            end;

            if Assigned(Sym) and (Sym is TClassSymbol) then begin
              Result:=Assigned(Ret);
              if Result then begin
                TBisDwsClassSymbol(Ret).IsForward:=false;
                TBisDwsClassSymbol(Ret).InheritFrom(TClassSymbol(Sym));
                TBisDwsClassSymbol(Ret).Typ:=Sym;
                with TBisDwsClassSymbol(Ret) do begin
                  CreateClassFields;
                  CreateClassMethods;
                  CreateClassProps;
                  CreateClassEvents;
                end;
              end;
            end;

          end;
        end
        else begin
          Sym:=nil;
          if Trim(AType.Ancestor)<>'' then
            Sym:=DoFindSymbol(AType.Ancestor);
          S:='';
          case AType.Kind of
            stkInteger: S:=SYS_INTEGER;
            stkFloat: S:=SYS_FLOAT;
            stkString: S:=SYS_STRING;
            stkDateTime: S:=SYS_DATETIME;
            stkBoolean: S:=SYS_BOOLEAN;
            stkVariant: S:=SYS_VARIANT;
          end;
          if not Assigned(Sym) then 
            Sym:=UnitTableFindSymbol(S);
          if Assigned(Sym) and (Sym is TTypeSymbol) then begin
            Ret:=TBisDwsAliasSymbol.Create(TTypeSymbol(Sym),AType,Self);
            Result:=Assigned(Ret);
            if Result then
              FUnitTable.AddSymbol(Ret);
          end;
        end;
      end;
    end;
  end;
end;

function TBisDwsScriptUnit.FindVar(AVarName: String; var Ret: TSymbol; Table: TSymbolTable): Boolean;
var
  AVar: TBisScriptVar;
  Sym: TSymbol;
begin
  Result:=false;
  if Assigned(FScriptUnit) then begin
    AVar:=FScriptUnit.Vars.Find(AVarName);
    if Assigned(AVar) then begin
      Sym:=DoFindSymbol(AVar.TypeName);
      if Assigned(Sym) then begin
        Ret:=TBisDwsVarSymbol.Create(Sym,AVar,Self);
        Result:=Assigned(Ret);
        if Result then
          FUnitTable.AddSymbol(Ret);
      end;
    end;
  end;
end;

function TBisDwsScriptUnit.FindFunc(AFuncName: String; var Ret: TSymbol; Table: TSymbolTable): Boolean;
var
  AFunc: TBisScriptFunc;
begin
  Result:=false;
  if Assigned(FScriptUnit) then begin
    AFunc:=FScriptUnit.Funcs.Find(AFuncName);
    if Assigned(AFunc) then begin
      Ret:=TBisDwsFuncSymbol.Create(AFunc,Self,Table);
      Result:=Assigned(Ret);
      if Result then
        FUnitTable.AddSymbol(Ret);
    end;
  end;
end;

function TBisDwsScriptUnit.TableFindLocal(Table: TSymbolTable; const Name: String): TSymbol;
begin
  Result:=nil;
  if Assigned(FScriptUnit) and Assigned(Table) then begin
    if FindType(Name,Result,Table) then exit;
    if FindVar(Name,Result,Table) then exit;
    if FindFunc(Name,Result,Table) then exit;
  end;
end;

{ TBisDwsScriptUnits }

function TBisDwsScriptUnits.Find(Name: String): TBisDwsScriptUnit;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    if AnsiSameText(TBisDwsScriptUnit(Items[i]).UnitName,Name) then begin
      Result:=TBisDwsScriptUnit(Items[i]);
      exit;
    end;
  end;
end;

{ TBisDwsScript }

constructor TBisDwsScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RemoveUnit(Self);
end;

{ TBisIfaceScriptUnit }

constructor TBisIfaceScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisDwsScriptIface }

constructor TBisDwsScriptIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScript:=TBisDwsScript.Create(nil);
  FScript.Config.InternalUnitEnabled:=false;
  FScript.OnUses:=ScriptUses;

  FIfaceUnit:=TBisIfaceScriptUnit.Create(Self);
  FIfaceUnit.Iface:=Self;
  with FIfaceUnit do begin
    UnitName:='Script';
    Depends.Add('System');
    Vars.Add('Iface',Self,'TComponent',false);
  end;

  FUnits:=TBisDwsScriptUnits.Create;
end;

destructor TBisDwsScriptIface.Destroy;
begin
  FreeAndNilEx(FProgram);
  FUnits.Free;
  FIfaceUnit.Free;
  FScript.Free;
  inherited Destroy;
end;

function TBisDwsScriptIface.UnitFindSymbol(AUnit: TBisDwsScriptUnit; const Name: String): TSymbol;
var
  i: Integer;
  Item: TBisDwsScriptUnit;
  Event: TSymbolTableFindLocalEvent;
begin
  Result:=nil;
  for i:=0 to FUnits.Count-1 do begin
    Item:=TBisDwsScriptUnit(FUnits.Items[i]);
    if Assigned(Item.UnitTable) then begin
      Event:=Item.UnitTable.OnFindLocal;
      Item.UnitTable.OnFindLocal:=nil;
      try
        Result:=Item.UnitTable.FindLocal(Name);
        if not Assigned(Result) then
          Result:=Item.TableFindLocal(Item.UnitTable,Name);
        if Assigned(Result) then
          exit;
      finally
        Item.UnitTable.OnFindLocal:=Event;
      end;
    end;
  end;
end;

function TBisDwsScriptIface.AddUnit(ScriptUnit: TBisScriptUnit): TBisDwsScriptUnit;
begin
  Result:=TBisDwsScriptUnit.Create(Self);
  Result.FScriptUnit:=ScriptUnit;
  Result.Script:=FScript;
  Result.OnFindSymbol:=UnitFindSymbol;
  FUnits.Add(Result);
end;

procedure TBisDwsScriptIface.ScriptUses(const UnitName: String; var UnitList: TInterfaceList);
var
  S: String;
  ScriptUnitFirst: TBisScriptUnit;
  ScriptUnitNext: TBisScriptUnit;
  DepUnit: TBisDwsScriptUnit;
  i: Integer;
begin
  ScriptUnitFirst:=FindUnit(UnitName);
  if not Assigned(ScriptUnitFirst) and AnsiSameText(UnitName,FIfaceUnit.UnitName) then
    ScriptUnitFirst:=FIfaceUnit;
  if Assigned(ScriptUnitFirst) and Assigned(UnitList) then begin

    for i:=0 to ScriptUnitFirst.Depends.Count-1 do begin
      S:=ScriptUnitFirst.Depends[i];
      DepUnit:=FUnits.Find(S);
      if not Assigned(DepUnit) and
         not AnsiSameText(S,UnitName) then begin
        ScriptUnitNext:=FindUnit(S);
        UnitList.Add(AddUnit(ScriptUnitNext));
      end;
    end;

    UnitList.Add(AddUnit(ScriptUnitFirst));
  end;
end;

procedure TBisDwsScriptIface.Show;
var
  Stream: TStringStream;
  Error: String;
  t1: TDateTime;
begin
  if CanShow then begin
    Stream:=TStringStream.Create('');
    try
      Core.ConnectionLoadScript(ScriptId,Stream);
      Stream.Position:=0;
      FUnits.Clear;

      FreeAndNilEx(FDel);
      FreeAndNilEx(FProgram);


      FProgram:=FScript.Compile(Stream.DataString);
      if Assigned(FProgram) then begin
        if FProgram.Msgs.HasErrors or FProgram.Msgs.HasCompilerErrors or FProgram.Msgs.HasExecutionErrors then begin
          Error:=Self.Caption+#13#10+FProgram.Msgs.AsInfo;
          if FProgram.Msgs.Msgs[0] is TScriptMsg then begin
            ShowError(Error);
          end;
        end;
        t1:=now;

        FDel:=TBrowserForm.Create(nil);
        with TBrowserForm(FDel)  do begin
          SymbolTable:=FProgram.Table;
          Show;
        end;

        FProgram.Execute;
        LoggerWrite(Format('Time Executed: %s',[FormatDateTime('hh.nn.ss.zzz',Now-t1)]));
      end;
    finally
      Stream.Free;
    end;
  end;
end;

end.