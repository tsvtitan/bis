unit BisLotoTicketImportFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB,
  BisFm, BisSizeGrip, BisControls;

type
  TBisLotoTicketImportForm = class(TBisForm)
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
    procedure ButtonImportClick(Sender: TObject);
    procedure ButtonFileClick(Sender: TObject);
    procedure ButtonTirageClick(Sender: TObject);
  private
    FTirageId: Variant;
    FSizeGrip: TBisSizeGrip;
    FProcessCounter: Integer;
    function CheckFields: Boolean;
    procedure Import;
    procedure SetStatistics;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EnableControls(AEnabled: Boolean); override;

  end;

  TBisLotoTicketImportFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoTicketImportForm: TBisLotoTicketImportForm;

implementation

uses ALXmlDoc,
     BisDialogs, BisUtils, BisConsts, BisLogger, BisProvider, BisFilterGroups, BisCore,
     BisLotoDataTiragesFm;

{$R *.dfm}

{ TBisLotoTicketImportFormIface }

constructor TBisLotoTicketImportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoTicketImportForm;
  Available:=true;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
end;

{ TBisLotoTicketImportForm }

constructor TBisLotoTicketImportForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  EditTirage.Color:=ColorControlReadOnly;
  EditFile.Color:=ColorControlReadOnly;

  FSizeGrip:=TBisSizeGrip.Create(nil);
  FSizeGrip.Parent:=PanelControls;

  FTirageId:=Null;
end;

destructor TBisLotoTicketImportForm.Destroy;
begin
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisLotoTicketImportForm.EnableControls(AEnabled: Boolean);
begin
  inherited EnableControls(AEnabled);
  Enabled:=true;
  ProgressBar.Enabled:=true;
  LabelCounter.Enabled:=true;
  Update;
end;

procedure TBisLotoTicketImportForm.ButtonFileClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    EditFile.Text:=OpenDialog.FileName;
  end;
end;

procedure TBisLotoTicketImportForm.ButtonImportClick(Sender: TObject);
begin
  Import;
end;

procedure TBisLotoTicketImportForm.ButtonTirageClick(Sender: TObject);
var
  Iface: TBisLotoDataTiragesFormIface;
  P: TBisProvider;
begin
  Iface:=TBisLotoDataTiragesFormIface.Create(nil);
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
        FProcessCounter:=0;
        SetStatistics;                                   
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

function TBisLotoTicketImportForm.CheckFields: Boolean;
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

procedure TBisLotoTicketImportForm.Import;
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
                         F1: array of String;
                         F2: array of String;
                         F3: array of String;
                         F4: array of String);
  var
    P: TBisProvider;
    I: Integer;
    S: String;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='I_TICKET';
      with P.Params do begin
        AddInvisible('TICKET_ID').Value:=GetUniqueID;
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('NUM').Value:=Trim(Num);
        AddInvisible('SERIES').Value:=Trim(Series);

        for i:=Low(F1) to High(F1) do begin
          S:='F1_'+FormatFloat('#00',i+1);
          AddInvisible(S).Value:=iff(Trim(F1[i])<>'',Trim(F1[i]),Null);
        end;

        for i:=Low(F2) to High(F2) do begin
          S:='F2_'+FormatFloat('#00',i+1);
          AddInvisible(S).Value:=iff(Trim(F2[i])<>'',Trim(F2[i]),Null);
        end;

        for i:=Low(F3) to High(F3) do begin
          S:='F3_'+FormatFloat('#00',i+1);
          AddInvisible(S).Value:=iff(Trim(F3[i])<>'',Trim(F3[i]),Null);
        end;

        for i:=Low(F4) to High(F4) do begin
          S:='F4_'+FormatFloat('#00',i+1);
          AddInvisible(S).Value:=iff(Trim(F4[i])<>'',Trim(F4[i]),Null);
        end;

        AddInvisible('NOT_USED').Value:=0;
        AddInvisible('SURNAME').Value:=Null;
        AddInvisible('NAME').Value:=Null;
        AddInvisible('PATRONYMIC').Value:=Null;
        AddInvisible('ADDRESS').Value:=Null;
        AddInvisible('PHONE').Value:=Null;
      end;

      P.Execute;
    finally
      P.Free;
    end;
  end;

  procedure SetTicketStatus(TicketNum: String; NotUsed: Boolean);
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='SET_TICKET_STATUS_EX';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('TICKET_NUM').Value:=TicketNum;
        AddInvisible('NOT_USED').Value:=Integer(NotUsed);
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
    Num,Series: String;
    F1: array[0..8] of String;
    F2: array[0..8] of String;
    F3: array[0..8] of String;
    F4: array[0..8] of String;
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
              FillChar(F1,SizeOf(F1),#0);
              FillChar(F2,SizeOf(F2),#0);
              FillChar(F3,SizeOf(F3),#0);
              FillChar(F4,SizeOf(F4),#0);
              for x:=0 to Row.AttributeNodes.Count-1 do begin
                Attr:=Row.AttributeNodes[x];
                if AnsiSameText(Attr.NodeName,'number') then Num:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'seria') then Series:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'f1_01') then F1[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_02') then F1[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_03') then F1[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_04') then F1[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_05') then F1[4]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_06') then F1[5]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_07') then F1[6]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_08') then F1[7]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f1_09') then F1[8]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'f2_01') then F2[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_02') then F2[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_03') then F2[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_04') then F2[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_05') then F2[4]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_06') then F2[5]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_07') then F2[6]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_08') then F2[7]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f2_09') then F2[8]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'f3_01') then F3[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_02') then F3[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_03') then F3[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_04') then F3[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_05') then F3[4]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_06') then F3[5]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_07') then F3[6]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_08') then F3[7]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f3_09') then F3[8]:=VarToStrDef(Attr.NodeValue,'');

                if AnsiSameText(Attr.NodeName,'f4_01') then F4[0]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_02') then F4[1]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_03') then F4[2]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_04') then F4[3]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_05') then F4[4]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_06') then F4[5]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_07') then F4[6]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_08') then F4[7]:=VarToStrDef(Attr.NodeValue,'');
                if AnsiSameText(Attr.NodeName,'f4_09') then F4[8]:=VarToStrDef(Attr.NodeValue,'');
              end;
              AppendTicket(Num,Series,F1,F2,F3,F4);
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
        SetTicketStatus(OutStr.Strings[i],RadioButtonExclude.Checked);
        Inc(AllCount);
        LabelCounter.Caption:=Format('Обработано %d из %d',[AllCount,ProgressBar.Max]);
        LabelCounter.Update;
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
  Ext: String;
begin
  if CheckFields then begin
    try

      EnableControls(false);
      OldCursor:=Screen.Cursor;
      ProgressBar.Position:=0;
      try

        Screen.Cursor:=crHourGlass;
        AllCount:=0;
        S:=Trim(EditFile.Text);
        Ext:=ExtractFileExt(S);
        if AnsiSameText(Ext,'.xml') then begin
          if RadioButtonReplace.Checked or
             RadioButtonAppend.Checked then begin
            if RadioButtonReplace.Checked then
              ClearTickets;
            ImportXml(S);
          end else
            raise Exception.Create('Такое действие не поддерживается.');
        end;
        if AnsiSameText(Ext,'.txt') then begin
          if RadioButtonExclude.Checked or
             RadioButtonInclude.Checked then begin
            ImportTxt(S);
          end else
            raise Exception.Create('Такое действие не поддерживается.');
        end;

      finally
        FProcessCounter:=FProcessCounter+AllCount;
        ProgressBar.Position:=0;
        Screen.Cursor:=OldCursor;
        EnableControls(true);
      end;

      SetStatistics;
      ShowInfo(FormatEx('Обработано %d билетов.',[AllCount]));
    except
      On E: Exception do begin
        LoggerWrite(E.Message,ltError);
        ShowError(E.Message);
      end;
    end;
  end;
end;


procedure TBisLotoTicketImportForm.SetStatistics;
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
        LabelTicketManageCounter.Caption:=IntToStr(FProcessCounter);
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

end.
