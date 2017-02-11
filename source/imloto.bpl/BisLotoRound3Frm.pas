unit BisLotoRound3Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB,
  BisLotoBarrelFrm, BisControls, Buttons;

type
  TBisLotoRound3Frame = class(TBisLotoBarrelFrame)
  protected
    function GetBarrelNums: String; override;
    function GetTicketSum: Extended; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanAdd: Boolean; override;
    function CheckBarrelNum(BarrelNum: String): Boolean; override;
  end;

var
  BisLotoRound3Frame: TBisLotoRound3Frame;

implementation

uses BisProvider, BisConsts, BisLotoConsts, BisUtils;

{$R *.dfm}

{ TBisLotoRound1Frame }

constructor TBisLotoRound3Frame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=3;
  ClearFromIndex:=1;
  ProviderName:='GET_THIRD_ROUND';
  WithPrize:=true;
end;

function TBisLotoRound3Frame.CanAdd: Boolean;
begin
  Result:=inherited CanAdd and ((StringGrid.ColCount-2)<5);
end;

function TBisLotoRound3Frame.CheckBarrelNum(BarrelNum: String): Boolean;
begin
  Result:=inherited CheckBarrelNum(BarrelNum);
  if Result then begin
    if Length(BarrelNum)>0 then
      Result:=BarrelNum[1] in ['0','1','2','3','4','5','6','7','8','9',
                               'À','Á','Â','Ã','Ä','Æ','Ç','Ê','Ë','Ì'];
  end;
end;

function TBisLotoRound3Frame.GetBarrelNums: String;
var
  S,S1: String;
  i: Integer;
begin
  S:=SUnknownValue;
  if StringGrid.ColCount>2 then begin
    S:='';
    for i:=1 to StringGrid.ColCount-2 do begin
      S1:=Trim(StringGrid.Cells[i,1]);
      if i=1 then
        S:=S1
      else S:=S+S1;
    end;
  end;
  Result:=S;
end;


function TBisLotoRound3Frame.GetTicketSum: Extended;
begin
  Result:=0.0;
  if not VarIsNull(PrizeCost) then begin
    if TicketCount>0 then
      Result:=VarToExtendedDef(PrizeCost,0.0)/TicketCount;
  end;
end;

end.
