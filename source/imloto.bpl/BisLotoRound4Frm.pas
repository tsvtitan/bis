unit BisLotoRound4Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB,
  BisLotoBarrelFrm, BisControls, Buttons;

type
  TBisLotoRound4Frame = class(TBisLotoBarrelFrame)
  protected
    function GetBarrelNums: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanAdd: Boolean; override;
    function CheckBarrelNum(BarrelNum: String): Boolean; override;
  end;

var
  BisLotoRound4Frame: TBisLotoRound4Frame;

implementation

uses BisProvider, BisConsts, BisLotoConsts;

{$R *.dfm}

{ TBisLotoRound1Frame }

constructor TBisLotoRound4Frame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=4;
  ProviderName:='GET_FOURTH_ROUND';
end;

function TBisLotoRound4Frame.CanAdd: Boolean;
begin
  Result:=inherited CanAdd and ((StringGrid.ColCount-2)<8);
end;

function TBisLotoRound4Frame.CheckBarrelNum(BarrelNum: String): Boolean;
var
  Num: Integer;
begin
  Result:=inherited CheckBarrelNum(BarrelNum);
  if Result then begin
    Result:=TryStrToInt(BarrelNum,Num);
    if Result then
      Result:=(Num>=0) and (Num<=9);
  end;
end;

function TBisLotoRound4Frame.GetBarrelNums: String;
var
  S,S1: String;
  i: Integer;
begin
  S:=SUnknownValue;
  if StringGrid.ColCount>2 then begin
    S:='';
    for i:=StringGrid.ColCount-2 downto 1 do begin
      S1:=Trim(StringGrid.Cells[i,1]);
      if i=StringGrid.ColCount-2 then
        S:=S1
      else S:=S+S1;
    end;
  end;
  Result:=S;
end;

end.
