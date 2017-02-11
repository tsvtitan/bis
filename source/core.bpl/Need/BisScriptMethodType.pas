unit BisScriptMethodType;

interface

uses
     BisScriptType, BisScriptParams;

type
  TBisScriptMethodTypeKind=(smtkProcedure,smtkFunction);

  TBisScriptMethodType=class(TBisScriptType)
  private
    FParams: TBisScriptParams;
    FResultType: String;
    FMethodKind: TBisScriptMethodTypeKind;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Params: TBisScriptParams read FParams;
    property ResultType: String read FResultType write FResultType;
    property MethodKind: TBisScriptMethodTypeKind read FMethodKind write FMethodKind;
  end;


implementation

{ TBisScriptMethodType }

constructor TBisScriptMethodType.Create;
begin
  inherited Create;
  Kind:=stkMethod;
  FParams:=TBisScriptParams.Create;
end;

destructor TBisScriptMethodType.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

end.
