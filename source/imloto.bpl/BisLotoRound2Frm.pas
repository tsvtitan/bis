unit BisLotoRound2Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB,
  BisLotoBarrelFrm, BisControls, Buttons;

type
  TBisLotoRound2Frame = class(TBisLotoBarrelFrame)
  public
    constructor Create(AOwner: TComponent); override;
    function CanAdd: Boolean; override;
    function CheckBarrelNum(BarrelNum: String): Boolean; override;
    function ExistsBarrelNum(BarrelNum: String): Boolean; override;
    procedure RefreshBarrels(WithCursor: Boolean); override;
  end;

var
  BisLotoRound2Frame: TBisLotoRound2Frame;

implementation

uses BisProvider, BisConsts, BisFilterGroups;

{$R *.dfm}

{ TBisLotoRound1Frame }

constructor TBisLotoRound2Frame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=2;
  ProviderName:='GET_SECOND_ROUND';
end;

function TBisLotoRound2Frame.CanAdd: Boolean;
begin
  Result:=inherited CanAdd;
end;

function TBisLotoRound2Frame.CheckBarrelNum(BarrelNum: String): Boolean;
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

function TBisLotoRound2Frame.ExistsBarrelNum(BarrelNum: String): Boolean;
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
        Filters.Add('ROUND_NUM',fcEqual,1).CheckCase:=true;
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

procedure TBisLotoRound2Frame.RefreshBarrels(WithCursor: Boolean);
var
  P: TBisProvider;
  ARoundNum: Integer;
  FS: TFormatSettings;
begin
  FirstState;
  if not VarIsNull(TirageId) then begin
//    EditPrizeSum.Text:=FormatFloat('#0',RoundSum);
    FS.ThousandSeparator:=' ';
    EditPrizeSum.Text:=FloatToStrF(RoundSum,ffNumber,15,0,FS);
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=WithCursor;
      P.ProviderName:='S_LOTTERY';
      with P.FieldNames do begin
        AddInvisible('LOTTERY_ID');
        AddInvisible('ROUND_NUM');
        AddInvisible('BARREL_NUM');
      end;
      P.FilterGroups.Add.Filters.Add('TIRAGE_ID',fcEqual,TirageId).CheckCase:=true;
      with P.FilterGroups.Add do begin
        Filters.Add('ROUND_NUM',fcEqual,1).CheckCase:=true;
        with Filters.Add('ROUND_NUM',fcEqual,RoundNum) do begin
          &Operator:=foOr;
          CheckCase:=true;
        end;
      end;
      P.FilterGroups.Add.Filters.Add('PRIZE_ID',fcEqual,PrizeId).CheckCase:=true;
      P.Orders.Add('ROUND_NUM');
      P.Orders.Add('INPUT_DATE');
      P.Open;
      if P.Active then begin
        P.First;
        while not P.Eof do begin
          ARoundNum:=P.FieldByName('ROUND_NUM').AsInteger;
          if ARoundNum<>RoundNum then
            MinCount:=MinCount+1;
          StringGrid.ColCount:=StringGrid.ColCount+1;
          StringGrid.Cells[StringGrid.ColCount-2,0]:=IntToStr(StringGrid.ColCount-2);
          StringGrid.Cells[StringGrid.ColCount-2,1]:=P.FieldByName('BARREL_NUM').AsString;
          StringGrid.Cells[StringGrid.ColCount-1,0]:='';
          StringGrid.Cells[StringGrid.ColCount-1,1]:='';
          LotteryList.Add(P.FieldByName('LOTTERY_ID').AsString);
          P.Next;
        end;
        UpdateButtons;
        StringGrid.Repaint;
        UpdateScrollBars;
        DoAction(false);
        SetStatistics;
      end;
    finally
      P.Free;
    end;
  end else
    EditPrizeSum.Text:='';
end;


end.
