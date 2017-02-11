unit BisBallThirdRoundFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB, Buttons,
  BisBallBarrelFrm, BisControls;

type
  TBisBallThirdRoundFrame = class(TBisBallBarrelFrame)
  public
    constructor Create(AOwner: TComponent); override;
    function GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor; override;
  end;

implementation

uses BisProvider, BisConsts, BisFilterGroups;

{$R *.dfm}

{ TBisBallSecondRoundFrame }

constructor TBisBallThirdRoundFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=3;
  ProviderName:='GET_THIRD_ROUND';
end;

function TBisBallThirdRoundFrame.GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor;
begin
  Result:=inherited GetLotteryColor(ARoundNum,ASubroundId);
end;

end.
