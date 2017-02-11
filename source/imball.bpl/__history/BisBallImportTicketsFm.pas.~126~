unit BisBallImportTicketsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB,
  BisFm, BisSizeGrip, BisControls;

type
  TBisBallImportTicketsForm = class(TBisForm)
    PanelControls: TPanel;
    EditTirage: TEdit;
    ButtonFile: TButton;
    EditFile: TEdit;
    LabelFile: TLabel;
    GroupBoxAction: TGroupBox;
    RadioButtonReplace: TRadioButton;
    RadioButtonAppend: TRadioButton;
    ButtonTirage: TButton;
    LabelTirage: TLabel;
    OpenDialog: TOpenDialog;
    ProgressBar: TProgressBar;
    LabelCounter: TLabel;
    ButtonImport: TButton;
    RadioButtonExclude: TRadioButton;
    RadioButtonInclude: TRadioButton;
    GroupBoxStatistics: TGroupBox;
    LabelTicketCount: TLabel;
    LabelTicketManageCount: TLabel;
    LabelTicketUsedCount: TLabel;
    LabelTicketNotUsedCount: TLabel;
    LabelTicketCounter: TLabel;
    LabelTicketManageCounter: TLabel;
    LabelTicketNotUsedCounter: TLabel;
    LabelTicketUsedCounter: TLabel;
    LabelDealer: TLabel;
    EditDealer: TEdit;
    ButtonDealer: TButton;
    LabelTicketUsedCountByDealer: TLabel;
    LabelTicketNotUsedCountByDealer: TLabel;
    LabelTicketNotUsedCounterByDealer: TLabel;
    LabelTicketUsedCounterByDealer: TLabel;
    LabelTicketCountByDealer: TLabel;
    LabelTicketCounterByDealer: TLabel;
    procedure ButtonImportClick(Sender: TObject);
    procedure ButtonFileClick(Sender: TObject);
    procedure ButtonTirageClick(Sender: TObject);
    procedure ButtonDealerClick(Sender: TObject);
  private
    FTirageId: Variant;
    FDealerId: Variant;
    FSizeGrip: TBisSizeGrip;
    FProcessCounter: Integer;
    function CheckFields: Boolean;
    procedure Import;
    procedure SetTirageStatistics;
    procedure SetDealerStatistics;
    procedure UpdateOptions; 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EnableControls(AEnabled: Boolean); override;

  end;

  TBisBallImportTicketsFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallImportTicketsForm: TBisBallImportTicketsForm;

implementation

uses ALXmlDoc,
     BisDialogs, BisUtils, BisConsts, BisLogger, BisProvider, BisFilterGroups, BisCore,
     BisBallDataTiragesFm, BisBallDataDealersFm;

{$R *.dfm}

{ TBisBallImportTicketsFormIface }

constructor TBisBallImportTicketsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallImportTicketsForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stMdiChild;
end;

{ TBisBallTicketImportForm }

constructor TBisBallImportTicketsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  EditTirage.Color:=ColorControlReadOnly;
  EditFile.Color:=ColorControlReadOnly;

  FSizeGrip:=TBisSizeGrip.Create(nil);
  FSizeGrip.Parent:=PanelControls;

  FTirageId:=Null;
  FDealerId:=Null;
end;

destructor TBisBallImportTicketsForm.Destroy;
begin
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisBallImportTicketsForm.EnableControls(AEnabled: Boolean);
begin
  inherited EnableControls(AEnabled);
  Enabled:=true;
  ProgressBar.Enabled:=true;
  LabelCounter.Enabled:=true;
  Update;
end;

procedure TBisBallImportTicketsForm.ButtonDealerClick(Sender: TObject);
var
  Iface: TBisBallDataDealersFormIface;
  P: TBisProvider;
begin
  Iface:=TBisBallDataDealersFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    Iface.Init;
    Iface.LocateFields:='DEALER_ID';
    Iface.LocateValues:=FDealerId;
    if Iface.SelectInto(P) then begin
      if P.Active then begin
        FDealerId:=P.FieldByName('DEALER_ID').Value;
        EditDealer.Text:=FormatEx('%s',[P.FieldByName('SMALL_NAME').AsString]);
        SetDealerStatistics;
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

procedure TBisBallImportTicketsForm.ButtonFileClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    EditFile.Text:=OpenDialog.FileName;
    UpdateOptions;
  end;
end;

procedure TBisBallImportTicketsForm.ButtonImportClick(Sender: TObject);
begin
  Import;
end;

procedure TBisBallImportTicketsForm.ButtonTirageClick(Sender: TObject);
var
  Iface: TBisBallDataTiragesFormIface;
  P: TBisProvider;
begin
  Iface:=TBisBallDataTiragesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    Iface.Init;
    Iface.FilterGroups.Add.Filters.Add('PREPARATION_DATE',fcIsNull,Null);
    Iface.LocateFields:='TIRAGE_ID';
    Iface.LocateValues:=FTirageId;
    if Iface.SelectInto(P) then begin
      if P.Active then begin
        FTirageId:=P.FieldByName('TIRAGE_ID').Value;
        EditTirage.Text:=FormatEx('%s от %s',
                                  [P.FieldByName('NUM').AsString,
                                   P.FieldByName('EXECUTION_DATE').AsString]);
        SetTirageStatistics;
        SetDealerStatistics;
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

function TBisBallImportTicketsForm.CheckFields: Boolean;
begin
  Result:=false;

  if (Trim(EditTirage.Text)='') or VarIsNull(FTirageId) then begin
    ShowError('Выберите тираж.');
    EditTirage.SetFocus;
    exit;
  end;

  if Trim(EditFile.Text)='' then begin
    ShowError('Выберите файл.');
    EditFile.SetFocus;
    exit;
  end;

  if not FileExists(Trim(EditFile.Text)) then begin
    ShowError(FormatEx('Файл %s не существует.',[Trim(EditFile.Text)]));
    EditFile.SetFocus;
    exit;
  end;

  Result:=true;
end;

procedure TBisBallImportTicketsForm.Import;
var
  AllCount: Integer;

  procedure ClearTickets;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='CLEAR_TICKETS';
      P.Params.AddInvisible('TIRAGE_ID').Value:=FTirageId;
      P.Execute;
    finally
      P.Free;
    end;
  end;

  procedure AppendTicket(Num,Series: String;
                         G1Prize,G1Money,G1Code: String;
                         G2_1: array of String;
                         G2_2: array of String;
                         G2_3: array of String;
                         G2_4: array of String;
                         G2_5: array of String;
                         G2_6: array of String);
  var
    P: TBisProvider;
    I: Integer;
    S: String;
    V: Variant;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='I_TICKET';
      with P.Params do begin
        AddInvisible('TICKET_ID').Value:=GetUniqueID;
        AddInvisible('DEALER_ID').Value:=FDealerId;
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('SERIES').Value:=Trim(Series);
        AddInvisible('NUM').Value:=Trim(Num);
        AddInvisible('USED').Value:=0;
        AddInvisible('SURNAME').Value:=Null;
        AddInvisible('NAME').Value:=Null;
        AddInvisible('PATRONYMIC').Value:=Null;
        AddInvisible('ADDRESS').Value:=Null;
        AddInvisible('PHONE').Value:=Null;
        AddInvisible('G1_PRIZE').Value:=iff(Trim(G1Prize)<>'',Trim(G1Prize),Null);
        AddInvisible('G1_MONEY').Value:=iff(Trim(G1Money)<>'',Trim(G1Money),Null);
        AddInvisible('G1_CODE').Value:=iff(Trim(G1Code)<>'',Trim(G1Code),Null);

        for i:=Low(G2_1) to High(G2_1) do begin
          S:='G2_1'+FormatFloat('#0',i+1);
          V:=iff(Trim(G2_1[i])<>'',Trim(G2_1[i]),Null);
          AddInvisible(S).Value:=V;
        end;

        for i:=Low(G2_2) to High(G2_2) do begin
          S:='G2_2'+FormatFloat('#0',i+1);
          V:=iff(Trim(G2_2[i])<>'',Trim(G2_2[i]),Null);
          AddInvisible(S).Value:=V;
        end;

        for i:=Low(G2_3) to High(G2_3) do begin
          S:='G2_3'+FormatFloat('#0',i+1);
          V:=iff(Trim(G2_3[i])<>'',Trim(G2_3[i]),Null);
          AddInvisible(S).Value:=V;
        end;

        for i:=Low(G2_4) to High(G2_4) do begin
          S:='G2_4'+FormatFloat('#0',i+1);
          V:=iff(Trim(G2_4[i])<>'',Trim(G2_4[i]),Null);
          AddInvisible(S).Value:=V;
        end;

        for i:=Low(G2_5) to High(G2_5) do begin
          S:='G2_5'+FormatFloat('#0',i+1);
          V:=iff(Trim(G2_5[i])<>'',Trim(G2_5[i]),Null);
          AddInvisible(S).Value:=V;
        end;

        for i:=Low(G2_6) to High(G2_6) do begin
          S:='G2_6'+FormatFloat('#0',i+1);
          V:=iff(Trim(G2_6[i])<>'',Trim(G2_6[i]),Null);
          AddInvisible(S).Value:=V;
        end;

      end;

      P.Execute;
    finally
      P.Free;
    end;
  end;

  procedure ImportXml(FileName: String);
  var
    Xml: TALXMLDocument;
    i,j,x: Integer;
    Node: TALXMLNode;
    Row: TALXMLNode;
    Attr: TALXMLNode;
    G1Prize, G1Money, G1Code: String;
    Num,Series: String;
    G2_1: array[0..4] of String;
    G2_2: array[0..4] of String;
    G2_3: array[0..4] of String;
    G2_4: array[0..4] of String;
    G2_5: array[0..4] of String;
    G2_6: array[0..4] of String;
  begin
    Xml:=TALXMLDocument.Create(nil);
    try
      Xml.LoadFromFile(FileName);
      for i:=0 to Xml.ChildNodes.Count-1 do begin
        Node:=Xml.ChildNodes[i];
        if AnsiSameText(Node.NodeName,'VFPData') then begin
          ProgressBar.Max:=Node.ChildNodes.Count;
          LabelCounter.Caption:=Format('Обработано %d из %d',[AllCount,ProgressBar.Max]);
          LabelCounter.Update;
          for j:=0 to Node.ChildNodes.Count-1 do begin
            Row:=Node.ChildNodes[j];
            if AnsiSameText(Row.NodeName,'row') then begin
              Num:='';
              Series:='';
              FillChar(G2_1,SizeOf(G2_1),#0);
              FillChar(G2_2,SizeOf(G2_2),#0);
              FillChar(G2_3,SizeOf(G2_3),#0);
              FillChar(G2_4,SizeOf(G2_4),#0);
              FillChar(G2_5,SizeOf(G2_5),#0);
              FillChar(G2_5,SizeOf(G2_6),#0);
              for x:=0 to Row.AttributeNodes.Count-1 do begin
                Attr:=Row.AttributeNodes[x];

                if AnsiSameText(Attr.NodeName,'g1_prize') then G1Prize:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g1_money') then G1Money:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g1_code') then G1Code:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'g2_11') then G2_1[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_12') then G2_1[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_13') then G2_1[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_14') then G2_1[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_15') then G2_1[4]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'g2_21') then G2_2[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_22') then G2_2[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_23') then G2_2[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_24') then G2_2[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_25') then G2_2[4]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'g2_31') then G2_3[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_32') then G2_3[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_33') then G2_3[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_34') then G2_3[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_35') then G2_3[4]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'g2_41') then G2_4[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_42') then G2_4[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_43') then G2_4[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_44') then G2_4[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_45') then G2_4[4]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'g2_51') then G2_5[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_52') then G2_5[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_53') then G2_5[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_54') then G2_5[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_55') then G2_5[4]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'g2_61') then G2_6[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_62') then G2_6[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_63') then G2_6[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_64') then G2_6[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'g2_65') then G2_6[4]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'number') then Num:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'seria') then Series:=VarToStrDef(Attr.NodeValue,'');

              end;
              AppendTicket(Num,Series,G1Prize,G1Money,G1Code,G2_1,G2_2,G2_3,G2_4,G2_5,G2_6);
              Inc(AllCount);
              LabelCounter.Caption:=Format('Обработано %d из %d',[AllCount,ProgressBar.Max]);
              LabelCounter.Update;
              Application.ProcessMessages;
            end;
            ProgressBar.Position:=j+1;
            ProgressBar.Update;
          end;
        end;
      end;
    finally
      Xml.Free;
    end;
  end;

  procedure SetTicketStatus(TicketNum: String; Used: Boolean);
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='SET_TICKET_STATUS_BY_NUM';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('DEALER_ID').Value:=FDealerId;
        AddInvisible('TICKET_NUM').Value:=TicketNum;
        AddInvisible('USED').Value:=Integer(Used);
      end;
      P.Execute;
    finally
      P.Free;
    end;
  end;

  procedure ImportTxt(FileName: String);

    function IntervalExists(S: String; var S1,S2: String): Boolean;
    var
      Str: TStringList;
    begin
      Result:=false;
      if not Result then begin
        Str:=TStringList.Create;
        try
          GetStringsByString(S,'-',Str);
          Result:=Str.Count=2;
          if Result then begin
            S1:=Trim(Str.Strings[0]);
            S2:=Trim(Str.Strings[1]);
          end;
        finally
          Str.Free;
        end;
      end;
    end;

    procedure ParseInStr(InStr,OutStr: TStringList);
    var
      i,j: Integer;
      S: String;
      S1,S2: String;
      N1,N2: Integer;
    begin
      for i:=0 to InStr.Count-1 do begin
        S:=Trim(InStr.Strings[i]);
        if IntervalExists(S,S1,S2) then begin
          if TryStrToInt(S1,N1) and
             TryStrToInt(S2,N2) then begin
            if N2>=N1 then begin
              for j:=N1 to N2 do begin
                S:=FormatFloat('00000000',j);
                OutStr.Add(S);
              end;
            end;
          end;
        end else
          OutStr.Add(S);
      end;
    end;

  var
    InStr: TStringList;
    OutStr: TStringList;
    i: Integer;
  begin
    InStr:=TStringList.Create;
    OutStr:=TStringList.Create;
    try
      InStr.LoadFromFile(FileName);
      ParseInStr(InStr,OutStr);
      ProgressBar.Max:=OutStr.Count;
      LabelCounter.Caption:=Format('Обработано %d из %d',[AllCount,ProgressBar.Max]);
      LabelCounter.Update;
      for i:=0 to OutStr.Count-1 do begin
        SetTicketStatus(OutStr.Strings[i],RadioButtonInclude.Checked);
        Inc(AllCount);
        LabelCounter.Caption:=Format('Обработано %d из %d',[AllCount,ProgressBar.Max]);
        LabelCounter.Update;
        ProgressBar.Position:=i+1;
        ProgressBar.Update;
        Application.ProcessMessages;
      end;
    finally
      OutStr.Free;
      InStr.Free;
    end;
  end;

var
  S: String;
  OldCursor: TCursor;
begin
  if CheckFields then begin
    try

      EnableControls(false);
      OldCursor:=Screen.Cursor;
      ProgressBar.Position:=0;
      try
        Screen.Cursor:=crHourGlass;
        AllCount:=0;
        FProcessCounter:=0;
        S:=Trim(EditFile.Text);
        if RadioButtonReplace.Checked or
           RadioButtonAppend.Checked then begin
          if RadioButtonReplace.Checked then
            ClearTickets;
          ImportXml(S);
        end;
        if RadioButtonExclude.Checked or
           RadioButtonInclude.Checked then begin
          ImportTxt(S);
        end;
      finally
        FProcessCounter:=FProcessCounter+AllCount;
        LabelTicketManageCounter.Caption:=IntToStr(FProcessCounter);
        ProgressBar.Position:=0;
        Screen.Cursor:=OldCursor;
        EnableControls(true);
        UpdateOptions;
      end;

      SetTirageStatistics;
      SetDealerStatistics;
      
      ShowInfo(FormatEx('Обработано %d билетов.',[AllCount]));
    except
      On E: Exception do begin
        LoggerWrite(E.Message,ltError);
        ShowError(E.Message);
      end;
    end;
  end;
end;

procedure TBisBallImportTicketsForm.SetDealerStatistics;
var
  P: TBisProvider;
  AllCount: Integer;
  UsedCount: Integer;
  NotUsedCount: Integer;
begin
  if not VarIsNull(FTirageId) and not VarIsNull(FDealerId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='GET_DEALER_STATISTICS';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('DEALER_ID').Value:=FDealerId;
        AddInvisible('ALL_COUNT',ptOutput);
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('NOT_USED_COUNT',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        AllCount:=P.Params.ParamByName('ALL_COUNT').AsInteger;
        UsedCount:=P.Params.ParamByName('USED_COUNT').AsInteger;
        NotUsedCount:=P.Params.ParamByName('NOT_USED_COUNT').AsInteger;

        LabelTicketCounterByDealer.Caption:=IntToStr(AllCount);
        LabelTicketUsedCounterByDealer.Caption:=IntToStr(UsedCount);
        LabelTicketNotUsedCounterByDealer.Caption:=IntToStr(NotUsedCount);
      end;
    finally
      P.Free;
    end;
  end else begin
    LabelTicketCounterByDealer.Caption:=IntToStr(0);
    LabelTicketUsedCounterByDealer.Caption:=IntToStr(0);
    LabelTicketNotUsedCounterByDealer.Caption:=IntToStr(0);
  end;
end;

procedure TBisBallImportTicketsForm.SetTirageStatistics;
var
  P: TBisProvider;
  AllCount: Integer;
  UsedCount: Integer;
  NotUsedCount: Integer;
begin
  if not VarIsNull(FTirageId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='GET_LOTTERY_STATISTICS';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('ALL_COUNT',ptOutput);
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('NOT_USED_COUNT',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        AllCount:=P.Params.ParamByName('ALL_COUNT').AsInteger;
        UsedCount:=P.Params.ParamByName('USED_COUNT').AsInteger;
        NotUsedCount:=P.Params.ParamByName('NOT_USED_COUNT').AsInteger;

        LabelTicketCounter.Caption:=IntToStr(AllCount);
        LabelTicketUsedCounter.Caption:=IntToStr(UsedCount);
        LabelTicketNotUsedCounter.Caption:=IntToStr(NotUsedCount);
      end;
    finally
      P.Free;
    end;
  end else begin
    LabelTicketCounter.Caption:=IntToStr(0);
    LabelTicketUsedCounter.Caption:=IntToStr(0);
    LabelTicketNotUsedCounter.Caption:=IntToStr(0);
  end;
end;

procedure TBisBallImportTicketsForm.UpdateOptions;
var
  Ext: String;
begin
  RadioButtonReplace.Enabled:=false;
  RadioButtonAppend.Enabled:=false;
  RadioButtonExclude.Enabled:=false;
  RadioButtonInclude.Enabled:=false;

  Ext:=ExtractFileExt(EditFile.Text);
  if AnsiSameText(Ext,'.xml') then begin
    RadioButtonReplace.Enabled:=true;
    RadioButtonAppend.Enabled:=true;
    if not RadioButtonReplace.Checked and
       not RadioButtonAppend.Checked then
      RadioButtonReplace.Checked:=true;
  end;
  if AnsiSameText(Ext,'.txt') then begin
    RadioButtonExclude.Enabled:=true;
    RadioButtonInclude.Enabled:=true;
    if not RadioButtonExclude.Checked and
       not RadioButtonInclude.Checked then
      RadioButtonExclude.Checked:=true;
  end;

end;

end.
