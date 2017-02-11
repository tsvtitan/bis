unit BisMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,

  BisSmpp, BisSmppClient;

type
  TBisMainForm = class(TForm)
    GroupBoxConnection: TGroupBox;
    GroupBoxOperations: TGroupBox;
    GroupBoxLog: TGroupBox;
    MemoLog: TMemo;
    LabelHost: TLabel;
    EditHost: TEdit;
    EditPort: TEdit;
    LabelPort: TLabel;
    LabelSystemId: TLabel;
    EditSystemId: TEdit;
    LabelPassword: TLabel;
    EditPassword: TEdit;
    LabelSystemType: TLabel;
    EditSystemType: TEdit;
    LabelTypeOfNumber: TLabel;
    LabelPlanIndicator: TLabel;
    LabelRange: TLabel;
    EditRange: TEdit;
    ButtonConnect: TButton;
    ButtonDisconnect: TButton;
    LabelMode: TLabel;
    ComboBoxMode: TComboBox;
    ComboBoxTypeOfNumber: TComboBox;
    ComboBoxPlanIndicator: TComboBox;
    ButtonSend: TButton;
    LabelMessage: TLabel;
    MemoMessage: TMemo;
    LabelLetters: TLabel;
    GroupBoxSource: TGroupBox;
    LabelSourceAddrTON: TLabel;
    ComboBoxSourceAddrTON: TComboBox;
    LabelSourceAddrNPI: TLabel;
    ComboBoxSourceAddrNPI: TComboBox;
    LabelSourceAddr: TLabel;
    EditSourceAddr: TEdit;
    GroupBoxDest: TGroupBox;
    LabelDestAddrTON: TLabel;
    LabelDestAddrNPI: TLabel;
    LabelDestAddresses: TLabel;
    ComboBoxDestAddrTON: TComboBox;
    ComboBoxDestAddrNPI: TComboBox;
    MemoDestAddresses: TMemo;
    LabelSendType: TLabel;
    ComboBoxSendType: TComboBox;
    LabelConcat: TLabel;
    ComboBoxConcat: TComboBox;
    LabelDestPort: TLabel;
    EditDestPort: TEdit;
    CheckBoxUCS2: TCheckBox;
    ButtonQuery: TButton;
    CheckBoxRequestDelivery: TCheckBox;
    CheckBoxFlash: TCheckBox;
    ButtonCancel: TButton;
    ComboBoxDestPort: TComboBox;
    LabelReadTimeOut: TLabel;
    EditReadTimeOut: TEdit;
    EditMaxLen: TEdit;
    LabelMaxLen: TLabel;
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure MemoMessageChange(Sender: TObject);
    procedure ButtonQueryClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ComboBoxConcatChange(Sender: TObject);
    procedure CheckBoxUCS2Click(Sender: TObject);
    procedure EditMaxLenChange(Sender: TObject);
    procedure EditDestPortChange(Sender: TObject);
    procedure ComboBoxDestPortChange(Sender: TObject);
  private
    FClient: TBisSmppClient;

    procedure UpdateButtons;
    procedure Log(const S: String);
    procedure SetStringsByMessage(Strings: TStrings; Message: TBisSmppMessage);
    procedure ClientConnect(Sender: TBisSmppClient);
    procedure ClientDisconnect(Sender: TBisSmppClient);
    procedure ClientError(Sender: TBisSmppClient; const Message: String);
    procedure ClientRequest(Sender: TBisSmppClient; Request: TBisSmppRequest);
    procedure ClientResponse(Sender: TBisSmppClient; Response: TBisSmppResponse);

    function GetMaxLen: Integer;
    procedure Send;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  BisMainForm: TBisMainForm;

implementation

uses TypInfo, DateUtils, Math,
     BisUtils, cUnicodeCodecs;

{$R *.dfm}

function EncodeUCS2(const Value: WideString): string;
var
  i,j: integer;
  Wide: string;
  Bytes: TBytes;
begin
  Result := '';

  j := Length(Value);
  SetLength(Bytes,2);

  for i := 1 to j do begin
    Bytes[0]:=Hi(Ord(Value[i]));
    Bytes[1]:=Lo(Ord(Value[i]));
    Wide := BytesToString(BYtes,0);
    Result := Result + Wide;
  end;
end;

function StrToHex(S: String): String;
var
  I, L: Integer;
  B: Byte;
begin
  Result:='';
  L := Length(S);
  for i:=1 to L do begin
    B:=Byte(S[i]);
    Result:=Result+IntToHex(B,2);
  end;
end;

{ TBisMainForm }

constructor TBisMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FClient:=TBisSmppClient.Create(nil);
  FClient.OnConnect:=ClientConnect;
  FClient.OnDisconnect:=ClientDisconnect;
  FClient.OnError:=ClientError;
  FClient.OnRequest:=ClientRequest;
  FClient.OnResponse:=ClientResponse;
  FClient.CheckTimeout:=20;

  UpdateButtons;

  MemoMessageChange(nil);
  ComboBoxConcatChange(nil);
end;

destructor TBisMainForm.Destroy;
begin
  FClient.Free;
  inherited Destroy;
end;

procedure TBisMainForm.EditDestPortChange(Sender: TObject);
begin
  MemoMessageChange(nil);
end;

procedure TBisMainForm.EditMaxLenChange(Sender: TObject);
begin
  MemoMessageChange(nil);
end;

function TBisMainForm.GetMaxLen: Integer;
begin
  Result:=StrToIntDef(EditMaxLen.Text,255);
end;

procedure TBisMainForm.Log(const S: String);
begin
  MemoLog.Lines.Add(Format('%s %s',[FormatDateTime('dd.mm.yy hh:nn:ss.zzz',Now),S]));
end;

procedure TBisMainForm.MemoMessageChange(Sender: TObject);
var
  L: Integer;
  Count: Integer;
  DestPort: Integer;
  MaxLen: Integer;
  DestPortExists: Boolean;
  MaxLenExists: Boolean;
begin
  Count:=0;
  L:=Length(Trim(MemoMessage.Lines.Text));
  DestPortExists:=TryStrToInt(EditDestPort.Text,DestPort);
  if DestPortExists then
    case ComboBoxDestPort.ItemIndex of
      1,2: L:=L+6;
    end;
  MaxLenExists:=TryStrToInt(EditMaxLen.Text,MaxLen);
  if MaxLenExists then begin
    if CheckBoxUCS2.Checked then
      MaxLen:=MaxLen div 2;
    if (MaxLen>0) then
      case ComboBoxConcat.ItemIndex of
        0: Count:=1;
        1: Count:=(L div MaxLen)+1;
        2: Count:=((L+5) div MaxLen)+1;
      end;
  end;
  LabelLetters.Caption:=Format('%d/%d',[L,Count]);
end;

procedure TBisMainForm.SetStringsByMessage(Strings: TStrings; Message: TBisSmppMessage);

  procedure BindRequest(Request: TBisSmppBindRequest);
  begin
    Strings.Add(Format('SystemId: %s',[Request.SystemId]));
    Strings.Add(Format('Password: %s',[Request.Password]));
    Strings.Add(Format('SystemType: %s',[Request.SystemType]));
    Strings.Add(Format('InterfaceVersion: $%s',[IntToHex(Request.InterfaceVersion,2)]));
    Strings.Add(Format('AddrTon: %s',[GetEnumName(TypeInfo(TBisSmppTypeOfNumber),Integer(Request.AddrTon))]));
    Strings.Add(Format('AddrNpi: %s',[GetEnumName(TypeInfo(TBisSmppNumberingPlanIndicator),Integer(Request.AddrNpi))]));
    Strings.Add(Format('AddressRange: %s',[Request.AddressRange]));
  end;

  procedure BindResponse(Response: TBisSmppBindResponse);
  begin
    Strings.Add(Format('SystemId: %s',[Response.SystemId]));
  end;

  procedure SubmitSmRequest(Request: TBisSmppSubmitSmRequest);
  begin
    Strings.Add(Format('ServiceType: %s',[Request.ServiceType]));
    Strings.Add(Format('SourceAddrTon: %s',[GetEnumName(TypeInfo(TBisSmppTypeOfNumber),Integer(Request.SourceAddrTon))]));
    Strings.Add(Format('SourceAddrNpi: %s',[GetEnumName(TypeInfo(TBisSmppNumberingPlanIndicator),Integer(Request.SourceAddrNpi))]));
    Strings.Add(Format('SourceAddr: %s',[Request.SourceAddr]));
  end;

  procedure SubmitSmResponse(Response: TBisSmppSubmitSmResponse);
  begin
    Strings.Add(Format('MessageId: %s',[Response.MessageId]));
  end;

  procedure SubmitMultiRequest(Request: TBisSmppSubmitMultiRequest);
  begin
    Strings.Add(Format('ServiceType: %s',[Request.ServiceType]));
    Strings.Add(Format('SourceAddrTon: %s',[GetEnumName(TypeInfo(TBisSmppTypeOfNumber),Integer(Request.SourceAddrTon))]));
    Strings.Add(Format('SourceAddrNpi: %s',[GetEnumName(TypeInfo(TBisSmppNumberingPlanIndicator),Integer(Request.SourceAddrNpi))]));
    Strings.Add(Format('SourceAddr: %s',[Request.SourceAddr]));
  end;

  procedure SubmitMultiResponse(Response: TBisSmppSubmitMultiResponse);
  begin
    Strings.Add(Format('MessageId: %s',[Response.MessageId]));
    Strings.Add(Format('NoUnsuccess: %d',[Response.NoUnsuccess]));
  end;

  procedure DeliverSmRequest(Request: TBisSmppDeliverSmRequest);

    function GetDateTime(DateTimeS: String): TDateTime;
    var
      FS: TFormatSettings;
    begin
      FS.DateSeparator:='-';
      FS.TimeSeparator:=':';
      FS.ShortDateFormat:='yyyy-mm-dd';
      FS.ShortTimeFormat:='hh:nn:ss';
      Result:=StrToDateTimeDef(DateTimeS,NullDateTime,FS);
    end;
    
  var
    Str: TStringList;
    MessageId: String;
    DT: TDateTime;
  begin
    Strings.Add(Format('ShortMessage: %s',[Request.ShortMessage]));
    Str:=TStringList.Create;
    try
      GetStringsByString(Request.ShortMessage,' ',Str);
      // may be it is status report, just check it
      if (Str.Count>=8) and (Str.Strings[4]='REASON') then begin
        // may be it is message_id
        if ParseBetween(Str.Strings[6],'(',')',MessageId) and (Str.Strings[2]='SUCCEED') then begin
          DT:=GetDateTime(Str.Strings[0]+' '+Str.Strings[1]);
          Strings.Add(Format('MessageId: %s was delivered at %s',[MessageId,DateTimeToStr(DT)]));
        end;
      end;
    finally
      Str.Free;
    end;
  end;

  procedure DeliverSmResponse(Response: TBisSmppDeliverSmResponse);
  begin
  end;

  procedure DataSmRequest(Request: TBisSmppDataSmRequest);
  begin
  end;

  procedure DataSmResponse(Response: TBisSmppDataSmResponse);
  begin
  end;

  procedure QuerySmRequest(Request: TBisSmppQuerySmRequest);
  begin
    Strings.Add(Format('MessageId: %s',[Request.MessageId]));
  end;

  procedure QuerySmResponse(Response: TBisSmppQuerySmResponse);
  begin
    Strings.Add(Format('MessageId: %s',[Response.MessageId]));
    Strings.Add(Format('FinalDate: %s',[iff(Response.FinalDate<>NullDateTime,DateTimeToStr(Response.FinalDate),'')]));
    Strings.Add(Format('MessageState: %s',[GetEnumName(TypeInfo(TBisSmppMessageState),Integer(Response.MessageState))]));
    Strings.Add(Format('ErrorCode: %d',[Response.ErrorCode]));
  end;

  procedure CancelSmRequest(Request: TBisSmppCancelSmRequest);
  begin
  end;

  procedure CancelSmResponse(Response: TBisSmppCancelSmResponse);
  begin
  end;

  procedure OptionalParameters;
  var
    Item: TBisSmppOptionalParameter;
    i: Integer;
  begin
    for i:=0 to Message.Parameters.Count-1 do begin
      Item:=Message.Parameters.Items[i];

      if Item is TBisSmppScInterfaceVersion then
        Strings.Add(Format('%s: $%s',[Item.ClassName,IntToHex(TBisSmppScInterfaceVersion(Item).Value,2)]));

    end;
  end;

begin
  Strings.Add(Format('CommandStatus: %s',[GetEnumName(TypeInfo(TBisSmppCommandStatus),Integer(Message.CommandStatus))]));
  Strings.Add(Format('SequenceNumber: %s',[IntToStr(Message.SequenceNumber)]));

  if IsClassParent(Message.ClassType,TBisSmppBindRequest) then
    BindRequest(TBisSmppBindRequest(Message));

  if IsClassParent(Message.ClassType,TBisSmppBindResponse) then
    BindResponse(TBisSmppBindResponse(Message));

  if IsClassParent(Message.ClassType,TBisSmppSubmitSmRequest) then
    SubmitSmRequest(TBisSmppSubmitSmRequest(Message));

  if IsClassParent(Message.ClassType,TBisSmppSubmitSmResponse) then
    SubmitSmResponse(TBisSmppSubmitSmResponse(Message));
   
  if IsClassParent(Message.ClassType,TBisSmppSubmitMultiRequest) then
    SubmitMultiRequest(TBisSmppSubmitMultiRequest(Message));

  if IsClassParent(Message.ClassType,TBisSmppSubmitMultiResponse) then
    SubmitMultiResponse(TBisSmppSubmitMultiResponse(Message));

  if IsClassParent(Message.ClassType,TBisSmppDeliverSmRequest) then
    DeliverSmRequest(TBisSmppDeliverSmRequest(Message));

  if IsClassParent(Message.ClassType,TBisSmppDeliverSmResponse) then
    DeliverSmResponse(TBisSmppDeliverSmResponse(Message));

  if IsClassParent(Message.ClassType,TBisSmppDataSmRequest) then
    DataSmRequest(TBisSmppDataSmRequest(Message));

  if IsClassParent(Message.ClassType,TBisSmppDataSmResponse) then
    DataSmResponse(TBisSmppDataSmResponse(Message));

  if IsClassParent(Message.ClassType,TBisSmppQuerySmRequest) then
    QuerySmRequest(TBisSmppQuerySmRequest(Message));

  if IsClassParent(Message.ClassType,TBisSmppQuerySmResponse) then
    QuerySmResponse(TBisSmppQuerySmResponse(Message));

  if IsClassParent(Message.ClassType,TBisSmppCancelSmRequest) then
    CancelSmRequest(TBisSmppCancelSmRequest(Message));

  if IsClassParent(Message.ClassType,TBisSmppCancelSmResponse) then
    CancelSmResponse(TBisSmppCancelSmResponse(Message));

  OptionalParameters; 
end;

procedure TBisMainForm.UpdateButtons;
begin
  ButtonConnect.Enabled:=not FClient.Connected;
  ButtonDisconnect.Enabled:=FClient.Connected;
  ButtonSend.Enabled:=FClient.Connected;
  ButtonQuery.Enabled:=FClient.Connected;
  ButtonCancel.Enabled:=FClient.Connected;
end;

procedure TBisMainForm.CheckBoxUCS2Click(Sender: TObject);
begin
  MemoMessageChange(nil);
end;

procedure TBisMainForm.ClientConnect(Sender: TBisSmppClient);
begin
  Log('Connected');
  UpdateButtons;
end;

procedure TBisMainForm.ClientDisconnect(Sender: TBisSmppClient);
begin
  Log('Disconnected');
  UpdateButtons;
end;

procedure TBisMainForm.ClientError(Sender: TBisSmppClient; const Message: String);
begin
  Log(Format('Error: %s',[Message]));
end;

procedure TBisMainForm.ClientRequest(Sender: TBisSmppClient; Request: TBisSmppRequest);
begin
  Log(Format('Request is %s ($%s)',[Request.ClassName,IntToHex(Request.CommandId,8)]));
  SetStringsByMessage(MemoLog.Lines,Request);
end;

procedure TBisMainForm.ClientResponse(Sender: TBisSmppClient; Response: TBisSmppResponse);
begin
  Log(Format('Response is %s ($%s)',[Response.ClassName,IntToHex(Response.CommandId,8)]));
  SetStringsByMessage(MemoLog.Lines,Response);
end;

procedure TBisMainForm.ComboBoxConcatChange(Sender: TObject);
begin
  MemoMessageChange(nil);
end;

procedure TBisMainForm.ComboBoxDestPortChange(Sender: TObject);
begin
  MemoMessageChange(nil);
end;

procedure TBisMainForm.ButtonConnectClick(Sender: TObject);
begin
  ButtonDisconnect.Click;

  MemoLog.Lines.Clear;

  FClient.Host:=EditHost.Text;
  FClient.Port:=StrToIntDef(EditPort.Text,2275);
  FClient.SystemId:=EditSystemId.Text;
  FClient.Password:=EditPassword.Text;
  FClient.SystemType:=EditSystemType.Text;
  FClient.TypeOfNumber:=TBisSmppTypeOfNumber(ComboBoxTypeOfNumber.ItemIndex);
  FClient.PlanIndicator:=TBisSmppNumberingPlanIndicator(ComboBoxPlanIndicator.ItemIndex);
  FClient.Mode:=TBisSmppClientMode(ComboBoxMode.ItemIndex);
  FClient.Range:=EditRange.Text;
  FClient.TransportReadTimeout:=StrToIntDef(EditReadTimeOut.Text,1000);

  FClient.Connect;
  FClient.AutoReconnect:=true;

end;

procedure TBisMainForm.ButtonDisconnectClick(Sender: TObject);
begin
  FClient.AutoReconnect:=false;
  FClient.Disconnect;
end;

procedure TBisMainForm.Send;

  procedure SendToAddress(AClass: TBisSmppSubmitRequestClass; Address: String);

    procedure SetCommonParams(Request: TBisSmppSubmitRequest);
    var
      DestPort: Integer;
      i: Integer;
      Str: TStringList;
      S: String;
    begin
      Request.SourceAddrTon:=TBisSmppTypeOfNumber(ComboBoxSourceAddrTON.ItemIndex);
      Request.SourceAddrNpi:=TBisSmppNumberingPlanIndicator(ComboBoxSourceAddrNPI.ItemIndex);
      Request.SourceAddr:=Trim(EditSourceAddr.Text);

      if Request is TBisSmppSubmitSmRequest then begin
        with TBisSmppSubmitSmRequest(Request) do begin
          DestAddrTon:=TBisSmppTypeOfNumber(ComboBoxDestAddrTON.ItemIndex);
          DestAddrNpi:=TBisSmppNumberingPlanIndicator(ComboBoxDestAddrNPI.ItemIndex);
          DestinationAddr:=Trim(Address);
        end;
      end;

      if Request is TBisSmppSubmitMultiRequest then begin
        Str:=TStringList.Create;
        try
          Str.Text:=Address;
          for i:=0 to Str.Count-1 do begin
            S:=Trim(Str.Strings[i]);
            if S<>'' then begin
              with TBisSmppSubmitMultiRequest(Request) do
                DestAddresses.AddSMEAddress(TBisSmppTypeOfNumber(ComboBoxDestAddrTON.ItemIndex),
                                                                 TBisSmppNumberingPlanIndicator(ComboBoxDestAddrNPI.ItemIndex),
                                                                 S);
            end;
          end;
        finally
          Str.Free;
        end;
      end;

//      Request.ValidityPeriod:=5;

      Request.DataCoding:=dcDefaultAlphabet;
      if CheckBoxUCS2.Checked then
        Request.DataCoding:=dcUCS2;

      if CheckBoxRequestDelivery.Checked then
        Request.RegisteredDeliveryReceipt:=rdrSuccessOrFailure;

      if CheckBoxFlash.Checked then
        Request.Indication:=indFlash;

      if TryStrToInt(EditDestPort.Text,DestPort) then begin
        if (ComboBoxDestPort.ItemIndex in [0,2]) then begin
          Request.Parameters.AddDestinationPort(DestPort);
        end;
      end;
    end;

    procedure SendRequest(Request: TBisSmppSubmitRequest);
    begin
      if Request is TBisSmppSubmitSmRequest then
        FClient.Send(TBisSmppSubmitSmRequest(Request));
        
      if Request is TBisSmppSubmitMultiRequest then
        FClient.Send(TBisSmppSubmitMultiRequest(Request));
    end;

  var
    Request: TBisSmppSubmitRequest;
    Original: String;
    L,Count: Integer;
    LMax: Integer;
    i: Integer;
    NewL: Integer;
    NewMessage: String;
    RefNum: Word;
    DataH, DataM, DataP: TBytes;
    DestPort: Integer;
    S: String;
  begin
    Randomize;
    if Trim(Address)<>'' then begin
      Original:=Trim(MemoMessage.Lines.Text);
      case ComboBoxConcat.ItemIndex of
        0: begin
          Request:=AClass.Create;
          SetCommonParams(Request);

          NewMessage:=Original;
          if CheckBoxUCS2.Checked then
             NewMessage:=EncodeUCS2(NewMessage);

          L:=Length(NewMessage);

          if L<=GetMaxLen then begin
            Request.SmLength:=L;
            Request.ShortMessage:=NewMessage;
          end else begin
            Request.Parameters.AddMessagePayload(NewMessage);
          end;
          SendRequest(Request);
        end;
        1: begin
          L:=Length(Original);

          LMax:=GetMaxLen;
          if CheckBoxUCS2.Checked then
            LMax:=LMax div 2;

          if (L mod LMax)<>0 then
            Count:=(L div LMax)+1
          else
            Count:=(L div LMax);

          RefNum:=RandomRange(1,MAXWORD);

          for i:=0 to Count-1 do begin
            Request:=AClass.Create;
            SetCommonParams(Request);

            NewMessage:=Copy(Original,(i*LMax)+1,LMax);
            if CheckBoxUCS2.Checked then
              NewMessage:=EncodeUCS2(NewMessage);

            NewL:=Length(NewMessage);
            Request.SmLength:=NewL;
            Request.ShortMessage:=NewMessage;

            Request.Parameters.AddSarMsgRefNum(RefNum);
            Request.Parameters.AddSarTotalSegments(Count);
            Request.Parameters.AddSarSegmentSeqnum(i+1);
            Request.Parameters.AddMoreMessagesToSend(i<>(Count-1));

            SendRequest(Request);
          end;
        end;
        2: begin
          L:=Length(Original);
          
          SetLength(DataH,1);
          if (ComboBoxDestPort.ItemIndex in [1,2]) and TryStrToInt(EditDestPort.Text,DestPort) then begin
            SetLength(DataP,6);
            DataP[0]:=5;
            DataP[1]:=4;
            DataP[2]:=Hi(DestPort);
            DataP[3]:=Lo(DestPort);
            DataP[4]:=0;
            DataP[5]:=0;
          end;

          LMax:=GetMaxLen;
          if CheckBoxUCS2.Checked then
            LMax:=LMax div 2;

          SetLength(DataM,5);

          DataH[0]:=Length(DataP)+Length(DataM);

          LMax:=LMax-DataH[0];

          if (L mod LMax)<>0 then
            Count:=(L div LMax)+1
          else
            Count:=(L div LMax);

          DataM[0]:=0;
          DataM[1]:=3;
          DataM[2]:=RandomRange(1,MAXBYTE);
          DataM[3]:=Count;
          DataM[4]:=0;

          for i:=0 to Count-1 do begin
            Request:=AClass.Create;
            SetCommonParams(Request);

            DataM[4]:=i+1;

            NewMessage:=BytesToString(DataH,0)+BytesToString(DataP,0)+BytesToString(DataM,0);

            MemoLog.Lines.Add(Format('UDH: %s',[StrToHex(NewMessage)]));

            S:=Copy(Original,(i*LMax)+1,LMax);
            if CheckBoxUCS2.Checked then
              S:=EncodeUCS2(S);
            NewMessage:=NewMessage+S;

            Request.EsmClassMessageType:=ectManual;
            Request.EsmClassFeatures:=ecfUDHI;

            NewL:=Length(NewMessage);
            Request.SmLength:=NewL;
            Request.ShortMessage:=NewMessage;

            SendRequest(Request);
          end;
        end;
      end;
    end;
  end;

var
  i: Integer;
begin
  case ComboBoxSendType.ItemIndex of
    0: begin
      for i:=0 to MemoDestAddresses.Lines.Count-1 do
        SendToAddress(TBisSmppSubmitSmRequest,MemoDestAddresses.Lines[i]);
    end;
    1: SendToAddress(TBisSmppSubmitMultiRequest,MemoDestAddresses.Lines.Text);
  end;
end;

procedure TBisMainForm.ButtonSendClick(Sender: TObject);
begin
  if FClient.Connected then begin
//    FClient.Requests.Clear;
    Send;
  end;
end;

procedure TBisMainForm.ButtonQueryClick(Sender: TObject);
var
  S: String;
  Request: TBisSmppQuerySmRequest;
begin
  if FClient.Connected then begin
//    FClient.Requests.Clear;
    if InputQuery('Get Message ID','Message ID',S) then begin
      Request:=TBisSmppQuerySmRequest.Create;
      Request.MessageId:=S;
      Request.SourceAddrTon:=TBisSmppTypeOfNumber(ComboBoxSourceAddrTON.ItemIndex);
      Request.SourceAddrNpi:=TBisSmppNumberingPlanIndicator(ComboBoxSourceAddrNPI.ItemIndex);
      Request.SourceAddr:=Trim(EditSourceAddr.Text);
      FClient.Send(Request);
    end;
  end;
end;

procedure TBisMainForm.ButtonCancelClick(Sender: TObject);
var
  S: String;
  Request: TBisSmppCancelSmRequest;
begin
  if FClient.Connected then begin
//    FClient.Requests.Clear;
    if InputQuery('Get Message ID','Message ID',S) then begin
      Request:=TBisSmppCancelSmRequest.Create;
      Request.MessageId:=S;
      Request.SourceAddrTon:=TBisSmppTypeOfNumber(ComboBoxSourceAddrTON.ItemIndex);
      Request.SourceAddrNpi:=TBisSmppNumberingPlanIndicator(ComboBoxSourceAddrNPI.ItemIndex);
      Request.SourceAddr:=Trim(EditSourceAddr.Text);
      Request.DestAddrTon:=TBisSmppTypeOfNumber(ComboBoxDestAddrTON.ItemIndex);
      Request.DestAddrNpi:=TBisSmppNumberingPlanIndicator(ComboBoxDestAddrNPI.ItemIndex);
      if MemoDestAddresses.Lines.Count>0 then
        Request.DestinationAddr:=MemoDestAddresses.Lines[0];
      FClient.Send(Request);
    end;
  end;
end;


end.
