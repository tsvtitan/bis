unit BisScriptFuncs;

interface

uses Contnrs, Variants,
     BisScriptSymbols, BisScriptParams;

type
  TBisScriptFunc=class;

  TBisScriptFuncExecute=function(Func: TBisScriptFunc): Variant of object;

  TBisScriptFuncKind=(fkProcedure,fkFunction);

  TBisScriptFunc=class(TBisScriptSymbol)
  private
    FParams: TBisScriptParams;
    FResultType: String;
    FOnExecute: TBisScriptFuncExecute;
    FKind: TBisScriptFuncKind;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Execute: Variant;

    property ResultType: String read FResultType;
    property Params: TBisScriptParams read FParams;
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
    function Add(Name: String; OnExecute: TBisScriptFuncExecute; Kind: TBisScriptFuncKind;
                 ResultType: String=''): TBisScriptFunc; reintroduce;
    function AddProcedure(Name: String; OnExecute: TBisScriptFuncExecute): TBisScriptFunc;
    function AddFunction(Name: String; OnExecute: TBisScriptFuncExecute; ResultType: String): TBisScriptFunc;

    property Items[Index: Integer]: TBisScriptFunc read GetItem;
  end;

implementation

{ TBisScriptFunc }

constructor TBisScriptFunc.Create;
begin
  inherited Create;
  FParams:=TBisScriptParams.Create;
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

function TBisScriptFuncs.Add(Name: String; OnExecute: TBisScriptFuncExecute; Kind: TBisScriptFuncKind;
                             ResultType: String): TBisScriptFunc;
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

function TBisScriptFuncs.AddFunction(Name: String; OnExecute: TBisScriptFuncExecute;
                                     ResultType: String): TBisScriptFunc;
begin
  Result:=Add(Name,OnExecute,fkFunction,ResultType);
end;

end.
