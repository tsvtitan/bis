unit BisParamKey;

interface

uses DB,
     BisParam;

type

  TBisParamKey=class(TBisParam)
  private
    FFirstValue: Boolean;
  protected
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
    function GetSize: Integer; override;
    function GetAuto: Boolean; override;
  public
    constructor Create; override;
    procedure CopyFrom(Source: TBisParam; WithReset: Boolean=true); override;
    procedure Reset; override;
  end;

implementation

uses Variants,
     BisUtils;

{ TBisParamKey }

procedure TBisParamKey.CopyFrom(Source: TBisParam; WithReset: Boolean);
begin
  inherited CopyFrom(Source,WithReset);
  if Assigned(Source) and (Source is TBisParamKey) then begin

  end;
end;

constructor TBisParamKey.Create;
begin
  inherited Create;
  DataType:=ftString;
  FFirstValue:=true;

end;

function TBisParamKey.GetValue: Variant;
begin
  Result:=inherited GetValue;
  if FFirstValue then begin
    Value:=GetUniqueID;
    Result:=Value;
    FFirstValue:=false;
  end;
end;

procedure TBisParamKey.Reset;
begin
  inherited Reset;
  FFirstValue:=true;
end;

procedure TBisParamKey.SetValue(const AValue: Variant);
begin
  FFirstValue:=false;
  inherited SetValue(AValue);
end;

function TBisParamKey.GetAuto: Boolean;
begin
  Result:=true;
end;

function TBisParamKey.GetSize: Integer;
begin
  Result:=Length(GetUniqueID);
end;

end.