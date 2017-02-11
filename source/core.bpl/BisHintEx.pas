unit BisHintEx;

interface

uses Classes, Types, BisHint;

type
  TBisHintWindowEx=class(TBisHintWindow)
  private
    FNewHint: TBisHint;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
  end;

implementation

uses SysUtils, Graphics, StdCtrls;

{ TBisHintWindowEx }

constructor TBisHintWindowEx.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FNewHint:=TBisHint.Create(Self);
  with FNewHint do begin
    FillDirection:=fdUp;
    StartColor:=clWhite;
    EndColor:=TColor($00B3F8FF);
    Brush.Style:=bsClear;
    Alignment:=taLeftJustify;
    Layout:=tlTop;
  end;
  HintComponent:=FNewHint;
end;

destructor TBisHintWindowEx.Destroy;
begin
  HintComponent:=nil;
  if Assigned(FNewHint) then
    FreeAndNil(FNewHint);
  inherited Destroy;
end;

procedure TBisHintWindowEx.ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer);
begin
  if Assigned(FNewHint) then
    FNewHint.Caption.Text:=AHint;
  inherited ActivateHintData(Rect,AHint,FNewHint);
end;

function TBisHintWindowEx.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
begin
  if Assigned(FNewHint) then
    FNewHint.Caption.Text:=AHint;
  Result:=inherited CalcHintRect(MaxWidth,AHint,FNewHint);
end;


end.
