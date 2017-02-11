unit BisParamCalculate;

interface

uses Classes,
     BisParam;

type

  TBisParamCalculateGetValueEvent=function (Param: TBisParam): Variant of object;

  TBisParamCalculate=class(TBisParam)
  private
    FOnGetValue: TBisParamCalculateGetValueEvent;
  protected
    function GetValue: Variant; override;
  public
    constructor Create; override;

    property OnGetValue: TBisParamCalculateGetValueEvent read FOnGetValue write FOnGetValue;
  end;

implementation

uses Variants, Sysutils,
     BisUtils;

{ TBisParamCalculate }

constructor TBisParamCalculate.Create;
begin
  inherited Create;
end;

function TBisParamCalculate.GetValue: Variant;
begin
  if Assigned(FOnGetValue) then
    Result:=FOnGetValue(Self)
  else
    Result:=inherited GetValue;
end;

end.
