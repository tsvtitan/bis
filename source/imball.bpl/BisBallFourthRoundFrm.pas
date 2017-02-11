unit BisBallFourthRoundFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB, Buttons,
  BisBallBarrelFrm, BisControls;

type
  TBisBallFourthRoundFrame = class(TBisBallBarrelFrame)
  public
    constructor Create(AOwner: TComponent); override;
    function GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor; override;
  end;

var
  BisLotoRound2Frame: TBisBallFourthRoundFrame;

implementation

uses BisProvider, BisConsts, BisFilterGroups;

{$R *.dfm}

{ TBisBallSecondRoundFrame }

constructor TBisBallFourthRoundFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=4;
  ProviderName:='GET_FOURTH_ROUND';
end;

function TBisBallFourthRoundFrame.GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor;
var
  Index: Integer;
begin
  Result:=inherited GetLotteryColor(ARoundNum,ASubroundId);
  Index:=GetSubround(ASubroundId);
  if (RoundNum=ARoundNum) and (ComboBoxSubrounds.ItemIndex>Index) then begin
    Result:=$00FFAAFF;
  end;
end;

end.
