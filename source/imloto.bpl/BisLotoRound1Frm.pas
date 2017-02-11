unit BisLotoRound1Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB,
  BisLotoBarrelFrm, BisControls, Buttons;

type
  TBisLotoRound1Frame = class(TBisLotoBarrelFrame)
  public
    constructor Create(AOwner: TComponent); override;
    function CanAdd: Boolean; override;
    function CheckBarrelNum(BarrelNum: String): Boolean; override;
    function ExistsBarrelNum(BarrelNum: String): Boolean; override;
  end;

var
  BisLotoRound1Frame: TBisLotoRound1Frame;

implementation

uses BisProvider, BisConsts, BisFilterGroups;

{$R *.dfm}

{ TBisLotoRound1Frame }

constructor TBisLotoRound1Frame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=1;
  ProviderName:='GET_FIRST_ROUND'
end;

function TBisLotoRound1Frame.CanAdd: Boolean;
begin
  Result:=inherited CanAdd;
end;

function TBisLotoRound1Frame.CheckBarrelNum(BarrelNum: String): Boolean;
var
  Num: Integer;
begin
  Result:=inherited CheckBarrelNum(BarrelNum);
  if Result then begin
    Result:=TryStrToInt(BarrelNum,Num);
    if Result then
      Result:=(Num>0) and (Num<37);
  end;
end;

function TBisLotoRound1Frame.ExistsBarrelNum(BarrelNum: String): Boolean;
var
  P: TBisProvider;
begin
  Result:=inherited ExistsBarrelNum(BarrelNum);
  if not Result then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_LOTTERY';
      P.FieldNames.Add('INPUT_DATE');
      P.FilterGroups.Add.Filters.Add('TIRAGE_ID',fcEqual,TirageId).CheckCase:=true;
      with P.FilterGroups.Add do begin
        Filters.Add('ROUND_NUM',fcEqual,2).CheckCase:=true;
        with Filters.Add('ROUND_NUM',fcEqual,RoundNum) do begin
          &Operator:=foOr;
          CheckCase:=true;
        end;
      end;
      P.FilterGroups.Add.Filters.Add('BARREL_NUM',fcEqual,BarrelNum).CheckCase:=true;
      P.FilterGroups.Add.Filters.Add('PRIZE_ID',fcEqual,PrizeId).CheckCase:=true;
      P.Open;
      Result:=P.Active and not P.Empty;
    finally
      P.Free;
    end;
  end;
end;

end.
