unit BisScriptFuncs;

interface

uses Contnrs, Variants, TypInfo,
     BisScriptSymbols;

type
  TBisScriptFuncParamKind=(spkNone,spkConst,spkVar);

  TBisScriptFuncParam=class(TBisScriptSymbol)
  private
    FDefaultValue: Variant;
    FTypeName: String;
    FValue: Variant;
    FKind: TBisScriptFuncParamKind;
    function GetAsBoolean: Boolean;
    function GetAsDateTime: TDateTime;
    function GetAsFloat: Extended;
    function GetAsInteger: Integer;
    function GetAsObject: TObject;
    function GetAsString: string;
    function GetDefaultExists: Boolean;
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsFloat(const Value: Extended);
    procedure SetAsString(const Value: string);
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsObject(const Value: TObject);
  public
    property TypeName: String read FTypeName;
    property Kind: TBisScriptFuncParamKind read FKind;
    property DefaultValue: Variant read FDefaultValue;
    property DefaultExists: Boolean read GetDefaultExists;
    property Value: Variant read FValue write FValue;

    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    property AsString: string read GetAsString write SetAsString;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsObject: TObject read GetAsObject write SetAsObject;

  end;

  TBisScriptFuncParams=class(TBisScriptSymbols)
  private
    function GetItem(Index: Integer): TBisScriptFuncParam;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    function Find(Name: String): TBisScriptFuncParam; reintroduce;

    function Add(Name: String; TypeName: String; Kind: TBisScriptFuncParamKind=spkNone): TBisScriptFuncParam; reintroduce; overload;
    function Add(Name: String; TypeName: String; DefaultValue: Variant;
                 Kind: TBisScriptFuncParamKind=spkNone): TBisScriptFuncParam; reintroduce; overload;

    procedure DefaultValues;

    procedure CopyFrom(Source: TBisScriptFuncParams);

    property Items[Index: Integer]: TBisScriptFuncParam read GetItem; default;
  end;

  TBisScriptFunc=class;

  TBisScriptFuncExecute=function(Func: TBisScriptFunc): Variant of object;

  TBisScriptFuncKind=(fkProcedure,fkFunction);

  TBisScriptFunc=class(TBisScriptSymbol)
  private
    FParams: TBisScriptFuncParams;
    FResultType: String;
    FOnExecute: TBisScriptFuncExecute;
    FKind: TBisScriptFuncKind;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Execute: Variant;

    property ResultType: String read FResultType;
    property Params: TBisScriptFuncParams read FParams;
    property Kind: TBisScriptFuncKind read FKind;

    property OnExecute: TBisScriptFuncExecute read FOnExecute;
  end;

  TBisScriptFuncs=class(TBisScriptSymbols)
  private
    function GetItem(Index: Integer): TBisScriptFunc;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    function Find(Name: String): TBisScriptFunc; reintroduce;
    function Add(Name: String; OnExecute: TBisScriptFuncExecute; Kind: TBisScriptFuncKind; ResultType: String=''): TBisScriptFunc; reintroduce;
    function AddProcedure(Name: String; OnExecute: TBisScriptFuncExecute): TBisScriptFunc;
    function AddFunction(Name: String; OnExecute: TBisScriptFuncExecute; ResultType: String): TBisScriptFunc;

    property Items[Index: Integer]: TBisScriptFunc read GetItem;
  end;

implementation

uses BisUtils;

{ TBisScriptFuncParam }

function TBisScriptFuncParam.GetAsInteger: Integer;
begin
  Result:=VarToIntDef(FValue,0);
end;

function TBisScriptFuncParam.GetAsFloat: Extended;
begin
  Result:=VarToExtendedDef(FValue,0.0);
end;

function TBisScriptFuncParam.GetAsString: string;
begin
  Result:=VarToStrDef(FValue,'');
end;

function TBisScriptFuncParam.GetAsBoolean: Boolean;
begin
  Result:=Boolean(AsInteger);
end;

function TBisScriptFuncParam.GetAsDateTime: TDateTime;
begin
  Result:=VarToDateDef(FValue,0.0);
end;

function TBisScriptFuncParam.GetAsObject: TObject;
begin
  Result:=V2O(FValue);
end;

function TBisScriptFuncParam.GetDefaultExists: Boolean;
begin
  Result:=not VarIsClear(FDefaultValue);
end;

procedure TBisScriptFuncParam.SetAsBoolean(const Value: Boolean);
begin
  FValue:=Value;
end;

procedure TBisScriptFuncParam.SetAsDateTime(const Value: TDateTime);
begin
  FValue:=Value;
end;

procedure TBisScriptFuncParam.SetAsFloat(const Value: Extended);
begin
  FValue:=Value;
end;

procedure TBisScriptFuncParam.SetAsInteger(const Value: Integer);
begin
  FValue:=Value;
end;

procedure TBisScriptFuncParam.SetAsObject(const Value: TObject);
begin
  FValue:=O2V(Value);
end;

procedure TBisScriptFuncParam.SetAsString(const Value: string);
begin
  FValue:=Value;
end;

{ TBisScriptFuncParams }

function TBisScriptFuncParams.Find(Name: String): TBisScriptFuncParam;
begin
  Result:=TBisScriptFuncParam(inherited Find(Name));
end;

function TBisScriptFuncParams.GetItem(Index: Integer): TBisScriptFuncParam;
begin
  Result:=TBisScriptFuncParam(inherited Items[Index]);
end;

function TBisScriptFuncParams.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptFuncParam;
end;

function TBisScriptFuncParams.Add(Name: String; TypeName: String; Kind: TBisScriptFuncParamKind=spkNone): TBisScriptFuncParam;
begin
  Result:=TBisScriptFuncParam(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FTypeName:=TypeName;
    Result.FKind:=Kind;
  end;
end;

function TBisScriptFuncParams.Add(Name: String; TypeName: String; DefaultValue: Variant;
                                  Kind: TBisScriptFuncParamKind=spkNone): TBisScriptFuncParam;
begin
  Result:=Add(Name,TypeName,Kind);
  if Assigned(Result) then begin
    Result.FDefaultValue:=DefaultValue;
  end;
end;

procedure TBisScriptFuncParams.DefaultValues;
var
  i: Integer;
  Item: TBisScriptFuncParam;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Item.Value:=Item.DefaultValue;
  end;
end;

procedure TBisScriptFuncParams.CopyFrom(Source: TBisScriptFuncParams);
var
  i: Integer;
  Param: TBisScriptFuncParam;
  NewParam: TBisScriptFuncParam;
begin
  Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Param:=Source.Items[i];

      NewParam:=Add(Param.Name,Param.TypeName,Param.Kind);
      if Assigned(NewParam) then begin
        NewParam.Description:=Param.Description;
        NewParam.FValue:=Param.Value;
        NewParam.FDefaultValue:=Param.DefaultValue;
      end;

    end;
  end;
end;

{ TBisScriptFunc }

constructor TBisScriptFunc.Create;
begin
  inherited Create;
  FParams:=TBisScriptFuncParams.Create;
end;

destructor TBisScriptFunc.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisScriptFunc.Execute: Variant;
begin
  if Assigned(FOnExecute) then
    Result:=FOnExecute(Self);
end;

{ TBisScriptFuncs }

function TBisScriptFuncs.Find(Name: String): TBisScriptFunc;
begin
  Result:=TBisScriptFunc(inherited Find(Name));
end;

function TBisScriptFuncs.GetItem(Index: Integer): TBisScriptFunc;
begin
  Result:=TBisScriptFunc(inherited Items[Index]);
end;

function TBisScriptFuncs.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptFunc;
end;

function TBisScriptFuncs.Add(Name: String; OnExecute: TBisScriptFuncExecute; Kind: TBisScriptFuncKind; ResultType: String=''): TBisScriptFunc;
begin
  Result:=TBisScriptFunc(inherited Add(Name));
  if Assigned(Result) then begin
    Result.FOnExecute:=OnExecute;
    Result.FResultType:=ResultType;
    Result.FKind:=Kind;
  end;
end;

function TBisScriptFuncs.AddProcedure(Name: String; OnExecute: TBisScriptFuncExecute): TBisScriptFunc;
begin
  Result:=Add(Name,OnExecute,fkProcedure);
end;

function TBisScriptFuncs.AddFunction(Name: String; OnExecute: TBisScriptFuncExecute; ResultType: String): TBisScriptFunc;
begin
  Result:=Add(Name,OnExecute,fkFunction,ResultType);
end;

end.
