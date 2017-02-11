unit BisBallFirstRoundFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB, Buttons,
  BisBallBarrelFrm, BisControls, GIFImg;

type
  TBisBallFirstRoundFrame = class(TBisBallBarrelFrame)
  public
    constructor Create(AOwner: TComponent); override;
    function GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor; override;
  end;

implementation

uses BisProvider, BisConsts, BisFilterGroups;

{$R *.dfm}

{ TBisBallRound1Frame }

constructor TBisBallFirstRoundFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=1;
  ProviderName:='GET_FIRST_ROUND'
end;

function TBisBallFirstRoundFrame.GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor;
begin
  Result:=inherited GetLotteryColor(ARoundNum,ASubroundId);
end;

end.
