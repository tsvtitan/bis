unit BisScriptMethod;

interface

uses
     BisScriptType, BisScriptParams;

type
  TBisScriptMethodKind=(smtkProcedure,smtkFunction);

  TBisScriptMethod=class(TBisScriptType)
  private
    FParams: TBisScriptParams;
    FResultType: String;
    FMethodKind: TBisScriptMethodKind;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Params: TBisScriptParams read FParams;
    property ResultType: String read FResultType write FResultType;
    property MethodKind: TBisScriptMethodKind read FMethodKind write FMethodKind;
  end;


implementation

{ TBisScriptMethod }

constructor TBisScriptMethod.Create;
begin
  inherited Create;
  Kind:=stkMethod;
  FParams:=TBisScriptParams.Create;
end;

destructor TBisScriptMethod.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

end.
