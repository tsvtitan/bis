unit BisLotoSiteExportIface;

interface

uses Classes, Controls,
     BisFm;

type
  TBisLotoSiteExportIface=class(TBisFormIface)
  private
    function SelectTirage(var TirageNum, ExecutionDate: String): Variant;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Show; override;
  end;

implementation

uses SysUtils, Forms, Variants, DB, DateUtils, Dialogs,
     ALXmlDoc,
     BisProvider, BisDataSet, BisDialogs, BisFilterGroups,
     BisLotoDataTiragesFm;

{ TBisLotoSiteExportIface }

constructor TBisLotoSiteExportIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  Available:=true;
end;

function TBisLotoSiteExportIface.SelectTirage(var TirageNum, ExecutionDate: String): Variant;
var
  Iface: TBisLotoDataTiragesFormIface;
  P: TBisProvider;
begin
  Result:=Null;
  if VarIsNull(Result) then begin
    Iface:=TBisLotoDataTiragesFormIface.Create(nil);
    P:=TBisProvider.Create(nil);
    try
      Iface.Init;
      Iface.Caption:='Выбрать тираж для экспорта';
      if Iface.SelectInto(P) then begin
        if P.Active then begin
          Result:=P.FieldByName('TIRAGE_ID').Value;
          TirageNum:=P.FieldByName('NUM').AsString;
          ExecutionDate:=DateToStr(DateOf(P.FieldByName('EXECUTION_DATE').AsDateTime));
        end;
      end;
    finally
      P.Free;
      Iface.Free;
    end;
  end;
end;

procedure TBisLotoSiteExportIface.Show;
var
  TirageId: Variant;
  TirageNum, ExecutionDate: String;
{  AllCount,UsedCount,NotUsedCount: Integer;
  PrizeSum,JackpotSum: Extended;
  FirstRoundSum,SecondRoundSum,ThirdRoundSum,FourthRoundSum: Extended;}

{  procedure GetStattistics;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='GET_LOTTERY_STATISTICS';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=TirageId;
        AddInvisible('ALL_COUNT',ptOutput);
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('NOT_USED_COUNT',ptOutput);
        AddInvisible('PRIZE_SUM',ptOutput);
        AddInvisible('JACKPOT_SUM',ptOutput);
        AddInvisible('FIRST_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_ROUND_SUM',ptOutput);
        AddInvisible('THIRD_ROUND_SUM',ptOutput);
        AddInvisible('FOURTH_ROUND_SUM',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        AllCount:=P.Params.ParamByName('ALL_COUNT').AsInteger;
        UsedCount:=P.Params.ParamByName('USED_COUNT').AsInteger;
        NotUsedCount:=P.Params.ParamByName('NOT_USED_COUNT').AsInteger;
        PrizeSum:=P.Params.ParamByName('PRIZE_SUM').AsExtended;
        JackpotSum:=P.Params.ParamByName('JACKPOT_SUM').AsExtended;
        FirstRoundSum:=P.Params.ParamByName('FIRST_ROUND_SUM').AsExtended;
        SecondRoundSum:=P.Params.ParamByName('SECOND_ROUND_SUM').AsExtended;
        ThirdRoundSum:=P.Params.ParamByName('THIRD_ROUND_SUM').AsExtended;
        FourthRoundSum:=P.Params.ParamByName('FOURTH_ROUND_SUM').AsExtended;
      end;
    finally
      P.Free;
    end;
  end;}

  procedure GetProtocol(Stream: TStream);

    procedure GetBarrels(RoundNum: Integer; RoundNode: TALXMLNode);
    var
      P: TBisProvider;
      LotteryNode: TALXMLNode;
      BarrelNode: TALXMLNode;
      Counter: Integer;
      PrizeName: String;
    begin
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.ProviderName:='S_LOTTERY';
        with P.FieldNames do begin
          AddInvisible('BARREL_NUM');
          AddInvisible('PRIZE_NAME');
        end;
        with P.FilterGroups.Add do begin
          Filters.Add('TIRAGE_ID',fcEqual,TirageId).CheckCase:=true;
          Filters.Add('ROUND_NUM',fcEqual,RoundNum).CheckCase:=true;
        end;
        P.Orders.Add('INPUT_DATE');
        P.Open;
        if P.Active and not P.Empty then begin
          LotteryNode:=RoundNode.AddChild('lottery');
          Counter:=1;
          P.First;
          while not P.Eof do begin
            PrizeName:=P.FieldByName('PRIZE_NAME').AsString;
            BarrelNode:=LotteryNode.AddChild('barrel');
            BarrelNode.Attributes['order']:=IntToStr(Counter);
            BarrelNode.Attributes['num']:=P.FieldByName('BARREL_NUM').AsString;
            if Trim(PrizeName)<>'' then
              BarrelNode.Attributes['prize']:=PrizeName;
            Inc(Counter);
            P.Next;
          end;
        end;
      finally
        P.Free;
      end;
    end;
    
  var
    Xml: TALXMLDocument;
    RoundNode: TALXMLNode;
    TirageNode: TALXMLNode;
    WinningsNode: TALXMLNode;
    TicketNode: TALXMLNode;
    P: TBisProvider;
    RoundNum, OldRoundNum: Integer;
    RoundName: String;
//    RoundSum: Extended;
    PrizeId: Variant;
  begin
    Xml:=TALXMLDocument.Create(nil);
    P:=TBisProvider.Create(nil);
    try
      Xml.Options:=Xml.Options+[doNodeAutoIndent];
      Xml.Active:=true;
      Xml.Version:='1.0';
      Xml.Encoding:='windows-1251';
      Xml.StandAlone:='yes';
      P.WithWaitCursor:=false;
      P.ProviderName:='GET_PROTOCOL';
      with P.FieldNames do begin
        AddInvisible('ROUND_NUM');
        AddInvisible('NUM');
        AddInvisible('SERIES');
        AddInvisible('PRIZE_NAME');
        AddInvisible('PRIZE_COST');
      end;
      P.Params.AddInvisible('TIRAGE_ID').Value:=TirageId;
      P.OpenWithExecute;
      if P.Active and not P.Empty then begin
        TirageNode:=Xml.AddChild('tirage');
        TirageNode.Attributes['num']:=TirageNum;
        TirageNode.Attributes['date']:=ExecutionDate;
        OldRoundNum:=0;
        WinningsNode:=nil;
//        RoundSum:=0.0;
        P.First;
        while not P.Eof do begin
          PrizeId:=P.FieldByName('PRIZE_ID').Value;
          RoundNum:=P.FieldByName('ROUND_NUM').AsInteger;
          if RoundNum<>OldRoundNum then begin
            RoundName:='none';
//            RoundSum:=0.0;
            case RoundNum of
              1: begin
                RoundName:='first';
//                RoundSum:=FirstRoundSum;
              end;
              2: begin
                RoundName:='second';
//                RoundSum:=SecondRoundSum;
              end;
              3: begin
                RoundName:='third';
//                RoundSum:=ThirdRoundSum;
              end;
              4: begin
                RoundName:='fourth';
//                RoundSum:=FourthRoundSum;
              end;
            end;
            RoundNode:=TirageNode.AddChild(RoundName);
            GetBarrels(RoundNum,RoundNode);
            WinningsNode:=RoundNode.AddChild('winnings');
          end;
          if Assigned(WinningsNode) then begin
            TicketNode:=WinningsNode.AddChild('ticket');
            TicketNode.Attributes['num']:=P.FieldByName('NUM').AsString;
            TicketNode.Attributes['series']:=P.FieldByName('SERIES').AsString;
            TicketNode.Attributes['prize']:=P.FieldByName('PRIZE_NAME').AsString;
            TicketNode.Attributes['sum']:=P.FieldByName('PRIZE_COST').AsString;
          end;
          OldRoundNum:=RoundNum;
          P.Next;
        end;
        Xml.SaveToStream(Stream);
        Stream.Position:=0;
      end;
    finally
      P.Free;
      Xml.Free;
    end;
  end;

var
  OldCursor: TCursor;
  Stream: TMemoryStream;
  Dialog: TSaveDialog;
begin
  if CanShow then begin
    TirageId:=SelectTirage(TirageNum, ExecutionDate);
    if not VarIsNull(TirageId) then begin
      Dialog:=TSaveDialog.Create(nil);
      try
        Dialog.Filter:='Файлы xml (*.xml)|*.xml';
        Dialog.DefaultExt:='xml';
        Dialog.FileName:=Format('tirage_%s',[TirageNum]);
        if Dialog.Execute then begin
          OldCursor:=Screen.Cursor;
          Stream:=TMemoryStream.Create;
          try
            Screen.Cursor:=crHourGlass;
            // GetStattistics;
            GetProtocol(Stream);
            Stream.SaveToFile(Dialog.FileName);
            ShowInfo('Экспорт для сайта выполнен успешно.');
          finally
            Stream.Free;
            Screen.Cursor:=OldCursor;
          end;
        end;
      finally
        Dialog.Free;
      end;
    end;  
  end;
end;

end.
