unit BisSmppServerInit;

interface

uses Windows, Classes, SysUtils, Contnrs, Variants, DB, SyncObjs,
     IdExceptionCore,
     BisObject, BisCoreObjects, BisServers, BisServerModules,
     BisLogger, BisThreads, BisSmpp, BisSmppClient;

type
  TBisSmppServer=class(TBisServer)
  private
    FThread: TBisWaitThread;

    FLocalIP: String;
    
    FHost: String;
    FPort: Integer;
    FSystemId: String;
    FPassword: String;
    FSystemType: String;
    FRange: String;
    FTypeOfNumber: TBisSmppTypeOfNumber;
    FPlanIndicator: TBisSmppNumberingPlanIndicator;
    FMode: TBisSmppClientMode;
    FTransportReadTimeout: Integer;
    FCheckTimeout: Integer;

    FSourceTypeOfNumber: TBisSmppTypeOfNumber;
    FSourcePlanIndicator: TBisSmppNumberingPlanIndicator;
    FSourceAddress: String;
    FSourcePort: Integer;  
    FDestTypeOfNumber: TBisSmppTypeOfNumber;
    FDestPlanIndicator: TBisSmppNumberingPlanIndicator;
    FDestPort: Integer;
    FInterval: Integer;
    FMaxCount: Integer;
    FPeriod: Integer;
    FOperatorIds: TStringList;
    FUnknownSender: String;
    FUnknownCode: String;

    FSReadMessagesStart: String;
    FSReadMessagesEnd: String;
    FSInsertIntoDatabaseStart: String;
    FSInsertIntoDatabaseSuccess: String;
    FSInsertIntoDatabaseFail: String;
    FSInsertIntoDatabaseParams: String;
    FSExecuteProcStart: String;
    FSExecuteProcSuccess: String;
    FSExecuteProcFail: String;
    FSExecuteCommandFail: String;
    FSExecuteCommandSuccess: String;
    FSExecuteCommandStart: String;
    FSDeleteMessageStart: String;
    FSDeleteMessageEnd: String;
    FSExecuteAnswerSuccess: String;
    FSExecuteAnswerText: String;
    FSExecuteAnswerStart: String;
    FSExecuteAnswerFail: String;
    FSInMessagesStart: String;
    FSOutMessagesStart: String;
    FSOutMessagesStartAll: String;
    FSLockMessages: String;
    FSOutMessageParams: String;
    FSOutMessageSendSuccess: String;
    FSOutMessageSendFail: String;
    FSUnlockOutMessageStart: String;
    FSUnlockOutMessageFail: String;
    FSUnlockOutMessageSuccess: String;
    FSDeleteMessagesStart: String;
    FSDeleteMessagesEnd: String;
    FSChannelFormat: String;
    FSRequestFormat: String;
    FSResponseFormat: String;

    procedure ChangeParams(Sender: TObject);

    procedure ClientError(Sender: TBisSmppClient; const Message: String);
    procedure ClientRequest(Sender: TBisSmppClient; Request: TBisSmppRequest);
    procedure ClientResponse(Sender: TBisSmppClient; Response: TBisSmppResponse);

    procedure ThreadTimeout(Thread: TBisWaitThread);
    procedure ThreadBegin(Thread: TBisThread);
    procedure ThreadEnd(Thread: TBisThread);
  protected
    function GetStarted: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Start; override;
    procedure Stop; override;

  published

    property SInMessagesStart: String read FSInMessagesStart write FSInMessagesStart;
    property SReadMessagesStart: String read FSReadMessagesStart write FSReadMessagesStart;
    property SReadMessagesEnd: String read FSReadMessagesEnd write FSReadMessagesEnd;

    property SInsertIntoDatabaseStart: String read FSInsertIntoDatabaseStart write FSInsertIntoDatabaseStart;
    property SInsertIntoDatabaseParams: String read FSInsertIntoDatabaseParams write FSInsertIntoDatabaseParams;
    property SInsertIntoDatabaseSuccess: String read FSInsertIntoDatabaseSuccess write FSInsertIntoDatabaseSuccess;
    property SInsertIntoDatabaseFail: String read FSInsertIntoDatabaseFail write FSInsertIntoDatabaseFail;

    property SExecuteProcStart: String read FSExecuteProcStart write FSExecuteProcStart;
    property SExecuteProcSuccess: String read FSExecuteProcSuccess write FSExecuteProcSuccess;
    property SExecuteProcFail: String read FSExecuteProcFail write FSExecuteProcFail;

    property SExecuteCommandStart: String read FSExecuteCommandStart write FSExecuteCommandStart;
    property SExecuteCommandSuccess: String read FSExecuteCommandSuccess write FSExecuteCommandSuccess;
    property SExecuteCommandFail: String read FSExecuteCommandFail write FSExecuteCommandFail;

    property SExecuteAnswerStart: String read FSExecuteAnswerStart write FSExecuteAnswerStart;
    property SExecuteAnswerText: String read FSExecuteAnswerText write FSExecuteAnswerText;
    property SExecuteAnswerSuccess: String read FSExecuteAnswerSuccess write FSExecuteAnswerSuccess;
    property SExecuteAnswerFail: String read FSExecuteAnswerFail write FSExecuteAnswerFail;

    property SDeleteMessageStart: String read FSDeleteMessageStart write FSDeleteMessageStart;
    property SDeleteMessageEnd: String read FSDeleteMessageEnd write FSDeleteMessageEnd;

    property SDeleteMessagesStart: String read FSDeleteMessagesStart write FSDeleteMessagesStart;
    property SDeleteMessagesEnd: String read FSDeleteMessagesEnd write FSDeleteMessagesEnd;

    property SOutMessagesStart: String read FSOutMessagesStart write FSOutMessagesStart;
    property SOutMessagesStartAll: String read FSOutMessagesStartAll write FSOutMessagesStartAll;
    property SLockMessages: String read FSLockMessages write FSLockMessages;
    property SOutMessageParams: String read FSOutMessageParams write FSOutMessageParams;

    property SOutMessageSendSuccess: String read FSOutMessageSendSuccess write FSOutMessageSendSuccess;
    property SOutMessageSendFail: String read FSOutMessageSendFail write FSOutMessageSendFail;

    property SUnlockOutMessageStart: String read FSUnlockOutMessageStart write FSUnlockOutMessageStart;
    property SUnlockOutMessageSuccess: String read FSUnlockOutMessageSuccess write FSUnlockOutMessageSuccess;
    property SUnlockOutMessageFail: String read FSUnlockOutMessageFail write FSUnlockOutMessageFail;

    property SChannelFormat: String read FSChannelFormat write FSChannelFormat;
    property SRequestFormat: String read FSRequestFormat write FSRequestFormat;
    property SResponseFormat: String read FSResponseFormat write FSResponseFormat;
  end;

procedure InitServerModule(AModule: TBisServerModule); stdcall;

exports
  InitServerModule;

implementation

uses Math, TypInfo,
     BisConsts, BisUtils, BisDataSet, BisProvider, BisNetUtils, BisDataParams,
     BisCore, BisFilterGroups, BisValues, BisOrders, BisCoreUtils,
     BisExceptNotifier, BisSmppServerConsts;


procedure InitServerModule(AModule: TBisServerModule); stdcall;
begin
  ServerModule:=AModule;
  AModule.ServerClass:=TBisSmppServer;
end;

type
  TBisSmppServerThread=class(TBisWaitThread)
  private
    FClient: TBisSmppClient;
    FCodeMessages: TBisDataSet;
  end;

{ TBisSmppServer }

constructor TBisSmppServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Params.OnChange:=ChangeParams;

  FOperatorIds:=TStringList.Create;

  FThread:=TBisSmppServerThread.Create;
  FThread.OnTimeout:=ThreadTimeout;
  FThread.OnBegin:=ThreadBegin;
  FThread.OnEnd:=ThreadEnd;

  FPort:=2275;
  FTransportReadTimeout:=1000;
  FCheckTimeout:=20;
  FInterval:=1000;
  FMaxCount:=MaxInt;
  FPeriod:=MaxInt;

  FSInMessagesStart:='Обработка входящих сообщений ...';
  FSReadMessagesStart:='Чтение входящих сообщений ...';
  FSReadMessagesEnd:='Прочитано %d входящих сообщений.';
  FSInsertIntoDatabaseStart:='Начало создания входящего сообщения ...';
  FSInsertIntoDatabaseSuccess:='Входящее сообщение создано успешно. Идентификатор=>%s';
  FSInsertIntoDatabaseFail:='Входящее сообщение не создано. %s';
  FSExecuteProcStart:='Начало выполнения процедуры %s ...';
  FSExecuteProcSuccess:='Процедура выполнена успешно.';
  FSExecuteProcFail:='Процедура не выполнена. %s';
  FSExecuteCommandStart:='Начало выполнения команды %s ...';
  FSExecuteCommandSuccess:='Команда выполнена успешно.';
  FSExecuteCommandFail:='Команда не выполнена. %s';
  FSExecuteAnswerStart:='Начало выполнения ответа ...';
  FSExecuteAnswerText:='Текст ответа =>%s';
  FSExecuteAnswerSuccess:='Ответ выполнен успешно.';
  FSExecuteAnswerFail:='Ответ не выполнен. %s';
  FSDeleteMessageStart:='Начало удаления входящего сообщения ...';
  FSDeleteMessageEnd:='Входящее сообщение удалено.';
  FSDeleteMessagesStart:='Начало удаления сообщений ...';
  FSDeleteMessagesEnd:='Сообщения удалены.';
  FSOutMessagesStart:='Обработка исходящих сообщений для оператора %s ...';
  FSOutMessagesStartAll:='Обработка исходящих сообщений для всех операторов ...';
  FSLockMessages:='Заблокировано %d исходящих сообщений.';
  FSOutMessageParams:='Параметры исходящего сообщения: идентификатор=>%s номер=>%s текст=>%s';
  FSOutMessageSendSuccess:='Исходящее сообщение отправлено успешно.';
  FSOutMessageSendFail:='Исходящее сообщение не отправлено.';
  FSUnlockOutMessageStart:='Начало разблокировки сообщения ...';
  FSUnlockOutMessageSuccess:='Разблокировка сообщения выполнена успешно.';
  FSUnlockOutMessageFail:='Разблокировка сообщения не выполнена. %s';
  FSChannelFormat:='%s:%s';
  FSRequestFormat:='Запрос #%d %s (%s|%s)';
  FSResponseFormat:='Ответ #%d %s (%s|%s)';


end;

destructor TBisSmppServer.Destroy;
begin
  Stop;
  FThread.Free;
  FOperatorIds.Free;
  inherited Destroy;
end;

function TBisSmppServer.GetStarted: Boolean;
begin
  Result:=FThread.Working;
end;

procedure TBisSmppServer.Init;
begin
  inherited Init;
end;

procedure TBisSmppServer.ChangeParams(Sender: TObject);
begin

  with Params do begin

    FHost:=AsString(SParamHost);
    FPort:=AsInteger(SParamPort,FPort);
    FSystemId:=AsString(SParamSystemId);
    FPassword:=AsString(SParamPassword);
    FSystemType:=AsString(SParamSystemType);
    FRange:=AsString(SParamRange);
    FTypeOfNumber:=AsEnumeration(SParamTypeOfNumber,TypeInfo(TBisSmppTypeOfNumber),tonUnknown);
    FPlanIndicator:=AsEnumeration(SParamPlanIndicator,TypeInfo(TBisSmppNumberingPlanIndicator),npiUnknown);
    FMode:=AsEnumeration(SParamMode,TypeInfo(TBisSmppClientMode),cmTransceiver);
    FTransportReadTimeout:=AsInteger(SParamReadTimeout,FTransportReadTimeout);
    FCheckTimeout:=AsInteger(SParamCheckTimeout,FCheckTimeout);
    FSourceTypeOfNumber:=AsEnumeration(SParamSourceTypeOfNumber,TypeInfo(TBisSmppTypeOfNumber),tonAlphanumeric);
    FSourcePlanIndicator:=AsEnumeration(SParamSourcePlanIndicator,TypeInfo(TBisSmppNumberingPlanIndicator),npiUnknown);
    FSourceAddress:=AsString(SParamSourceAddress);
    FSourcePort:=AsInteger(SParamSourcePort);
    FDestTypeOfNumber:=AsEnumeration(SParamDestTypeOfNumber,TypeInfo(TBisSmppTypeOfNumber),tonInternational);
    FDestPlanIndicator:=AsEnumeration(SParamDestPlanIndicator,TypeInfo(TBisSmppNumberingPlanIndicator),npiISDN);
    FDestPort:=AsInteger(SParamDestPort);
    FInterval:=AsInteger(SParamInterval,FInterval);
    FMaxCount:=AsInteger(SParamMaxCount,FMaxCount);
    FPeriod:=AsInteger(SParamPeriod,FPeriod);
    FOperatorIds.Text:=Trim(AsString(SParamOperatorIds));
    FUnknownSender:=AsString(SParamUnknownSender);
    FUnknownCode:=AsString(SParamUnknownCode);
  
  end;

end;

procedure TBisSmppServer.ThreadTimeout(Thread: TBisWaitThread);
var
  Client: TBisSmppClient;
  CodeMessages: TBisDataSet;
const
  PhoneChars=['+','0','1','2','3','4','5','6','7','8','9'];

  procedure RefreshCodeMessages;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_CODE_MESSAGES';
      with P.FieldNames do begin
        AddInvisible('CODE_MESSAGE_ID');
        AddInvisible('CODE');
        AddInvisible('PROC_NAME');
        AddInvisible('COMMAND_STRING');
        AddInvisible('ANSWER');
      end;
      P.FilterGroups.Add.Filters.Add('ENABLED',fcEqual,1);
      P.Orders.Add('CODE');
      try
        P.Open;
        if P.Active then begin
          CodeMessages.Close;
          CodeMessages.CreateTable(P);
          CodeMessages.CopyRecords(P);
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;

  function PrepareNumber(const Number: String; var TON: TBisSmppTypeOfNumber; var NPI: TBisSmppNumberingPlanIndicator): String;
  begin
    Result:=Number;
    case TON of
      tonInternational: begin
        Result:=StringReplace(Result,'+','',[rfReplaceAll]);
        Result:=Copy(Result,1,11);
      end;
      tonAlphanumeric: begin
        if (Length(Result)=12) and (Result[1]='+') then begin
          Result:=StringReplace(Result,'+','',[rfReplaceAll]);
          Result:=Copy(Result,1,11);
          TON:=tonInternational;
          NPI:=npiISDN;
        end;
      end;
    end;
  end;

  function Text8Bit(S: AnsiString): Boolean;
  var
    i: Integer;
    tempByte: Byte;
  begin
    Result:=true;
    for i := 1 to Length(S) do  begin
      tempByte := Byte(S[i]);
      if (tempByte and $80) <> 0 then begin
        Result:=false;
        exit;
      end;
    end;
  end;

  procedure OutMessages(OperatorId: Variant);

    procedure UnlockMessage(OutMessageId: Variant; Sent: Boolean; MessageId: Variant);
    var
      P: TBisProvider;
    begin
      LoggerWrite(FSUnlockOutMessageStart);
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='UNLOCK_OUT_MESSAGE';
        with P.Params do begin
          AddInvisible('OUT_MESSAGE_ID').Value:=OutMessageId;
          AddInvisible('SENT').Value:=Integer(Sent);
          AddInvisible('MESSAGE_ID').Value:=MessageId;
        end;
        try
          P.Execute;
          if P.Success then
            LoggerWrite(FSUnlockOutMessageSuccess);
        except
          On E: Exception do
            LoggerWrite(FormatEx(FSUnlockOutMessageFail,[E.Message]),ltError);
        end;
      finally
        P.Free;
      end;
    end;

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

    function TryToSend(const TextOut: String; Dest, Source: String; DestPort,SourcePort: Integer;
                       Delivery,Flash: Boolean; var MessageId: Variant): Boolean;
    var
      DestPortExists: Boolean;
      SourcePortExists: Boolean;

      procedure SetCommonParams(Request: TBisSmppSubmitSmRequest);
      var
        TON: TBisSmppTypeOfNumber;
        NPI: TBisSmppNumberingPlanIndicator;
      begin
        TON:=FSourceTypeOfNumber;
        NPI:=FSourcePlanIndicator;
        Request.SourceAddr:=PrepareNumber(Source,TON,NPI);
        Request.SourceAddrTon:=TON;
        Request.SourceAddrNpi:=NPI;

        TON:=FDestTypeOfNumber;
        NPI:=FDestPlanIndicator;
        Request.DestinationAddr:=PrepareNumber(Dest,TON,NPI);
        Request.DestAddrTon:=TON;
        Request.DestAddrNpi:=NPI;

        Request.DataCoding:=dcDefaultAlphabet;

        if Delivery then
          Request.RegisteredDeliveryReceipt:=rdrSuccessOrFailure;

        if Flash then
          Request.Indication:=indFlash;

        if DestPortExists then
          Request.Parameters.AddDestinationPort(DestPort);

        if SourcePortExists then
          Request.Parameters.AddSourcePort(SourcePort);
      end;

      function GetMessageId(Request: TBisSmppSubmitSmRequest): Variant;
      begin
        Result:=Null;
        if Assigned(Request.Response) and (Request.Response is TBisSmppSubmitSmResponse) then
          Result:=TBisSmppSubmitSmResponse(Request.Response).MessageId;
      end;

    var
      Flag8bit: Boolean;
      Total: Integer;
      Request: TBisSmppSubmitSmRequest;
      NewTextOut: String;
      S: String;
      UDH: TBytes;
      i: Integer;
      Count: Integer;
      MaxLen: Integer;
    const
      UDHLen=6;
      OneUcs2MaxLen=79;
      One8bitMaxLen=152;
      LotsUcs2MaxLen=138;
      Lots8bitMaxLen=One8bitMaxLen;
    begin
      Result:=false;
      Total:=Length(TextOut);
      Flag8bit:=Text8Bit(TextOut);
      DestPortExists:=DestPort>0;
      SourcePortExists:=SourcePort>0;

      if (not DestPortExists and not SourcePortExists) or
         (not Flag8bit and (DestPortExists or SourcePortExists) and (Total<=OneUcs2MaxLen)) or
         (Flag8bit and (DestPortExists or SourcePortExists) and (Total<=One8bitMaxLen)) then begin

        Request:=TBisSmppSubmitSmRequest.Create;
        SetCommonParams(Request);

        if not Flag8bit and (DestPortExists or SourcePortExists) and (Total<=OneUcs2MaxLen) then
          Request.DataCoding:=dcUCS2;

        if Flash then
          Request.DataCoding:=dcUCS2;

        NewTextOut:=TextOut;
        if Request.DataCoding=dcUCS2 then
          NewTextOut:=EncodeUCS2(NewTextOut);

        Total:=Length(NewTextOut);

        if Total<=MAXBYTE then begin
          Request.SmLength:=Total;
          Request.ShortMessage:=NewTextOut;
        end else begin
          Request.Parameters.AddMessagePayload(TextOut);
        end;

        Result:=Client.Send(Request);
        if Result then
          MessageId:=GetMessageId(Request);

      end else begin

        MaxLen:=Lots8bitMaxLen;
        if not Flag8bit then begin
          MaxLen:=LotsUcs2MaxLen;
          MaxLen:=MaxLen div 2;
        end;

        MaxLen:=MaxLen-UDHLen;

        if (Total mod MaxLen)<>0 then
          Count:=(Total div MaxLen)+1
        else
          Count:=(Total div MaxLen);

        SetLength(UDH,6);
        UDH[0]:=UDHLen-1;
        UDH[1]:=0;
        UDH[2]:=3;
        UDH[3]:=RandomRange(1,MAXBYTE);
        UDH[4]:=Count;
        UDH[5]:=0;

        for i:=0 to Count-1 do begin
          Request:=TBisSmppSubmitSmRequest.Create;
          SetCommonParams(Request);

          UDH[5]:=i+1;
          NewTextOut:=BytesToString(UDH,0);

          S:=Copy(TextOut,(i*MaxLen)+1,MaxLen);
          if not Flag8bit then begin
            Request.DataCoding:=dcUCS2;
            S:=EncodeUCS2(S);
          end;
          NewTextOut:=NewTextOut+S;

          Request.EsmClassMessageType:=ectManual;
          Request.EsmClassFeatures:=ecfUDHI;

          Total:=Length(NewTextOut);
          Request.SmLength:=Total;
          Request.ShortMessage:=NewTextOut;

          Result:=Client.Send(Request);
          if Result then begin
            if i=0 then
              MessageId:=GetMessageId(Request);
          end else
            break;

        end;

      end;
    end;

  var
    Locked: String;
    PSelect: TBisProvider;
    PLock: TBisProvider;
    LockCount: Integer;
    i: Integer;
    S: String;
    Field: TField;
    TextOut: String;
    Dest: String;
    Source: String;
    Sent: Boolean;
    MessageId: Variant;
    OutMessageId: Variant;
    DestPort: Integer;
  begin
    if VarIsNull(OperatorId) then
      LoggerWrite(FSOutMessagesStartAll)
    else
      LoggerWrite(FormatEx(FSOutMessagesStart,[VarToStrDef(OperatorId,'')]));
    PLock:=TBisProvider.Create(nil);
    try
      Locked:=GetUniqueID;
      PLock.ProviderName:='LOCK_OUT_MESSAGES';
      with PLock.Params do begin
        AddInvisible('MAX_COUNT').Value:=FMaxCount;
        AddInvisible('LOCKED').Value:=Locked;
        AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
        AddInvisible('PERIOD').Value:=iff(FPeriod=0,MaxInt,FPeriod);
        AddInvisible('CHANNEL').Value:=FLocalIP;
        AddInvisible('OPERATOR_ID').Value:=OperatorId;
        AddInvisible('LOCK_COUNT',ptOutput).Value:=0;
      end;
      try
        PLock.Execute;
        if PLock.Success then begin
          LockCount:=PLock.Params.ParamByName('LOCK_COUNT').AsInteger;
          LoggerWrite(FormatEx(FSLockMessages,[LockCount]));

          if LockCount>0 then begin

            PSelect:=TBisProvider.Create(nil);
            try
              PSelect.ProviderName:='S_OUT_MESSAGES';
              with PSelect do begin
                with FieldNames do begin
                  AddInvisible('OUT_MESSAGE_ID');
                  AddInvisible('CREATOR_ID');
                  AddInvisible('RECIPIENT_ID');
                  AddInvisible('DATE_CREATE');
                  AddInvisible('TEXT_OUT');
                  AddInvisible('CONTACT');
                  AddInvisible('DELIVERY');
                  AddInvisible('FLASH');
                  AddInvisible('DEST_PORT');
                  AddInvisible('DESCRIPTION');
                  AddInvisible('SOURCE');
                  AddInvisible('CREATOR_NAME');
                  AddInvisible('RECIPIENT_NAME');
                  AddInvisible('RECIPIENT_PHONE');
                end;
                with FilterGroups.Add do begin
                  Filters.Add('LOCKED',fcEqual,Locked).CheckCase:=true;
                  Filters.Add('DATE_OUT',fcIsNull,Null);
                  Filters.Add('TYPE_MESSAGE',fcEqual,DefaultTypeMessage);
                end;
                with Orders do begin
                  Add('PRIORITY');
                  Add('DATE_BEGIN');
                end;
              end;
              try
                PSelect.Open;
                if PSelect.Active and not PSelect.IsEmpty then begin
                  PSelect.First;
                  while not PSelect.Eof do begin
                    MessageId:=Null;
                    Sent:=false;
                    OutMessageId:=PSelect.FieldByName('OUT_MESSAGE_ID').Value;
                    try
                      if not Thread.Terminated then begin
                        S:=PSelect.FieldByName('TEXT_OUT').AsString;
                        for i:=0 to PSelect.Fields.Count-1 do begin
                          Field:=PSelect.Fields[i];
                          if not AnsiSameText(Field.FieldName,'TEXT_OUT') then
                            S:=StringReplace(S,'%'+Field.FieldName,VarToStrDef(Field.Value,''),[rfReplaceAll, rfIgnoreCase]);
                        end;
                        TextOut:=S;

                        Dest:=GetOnlyChars(PSelect.FieldByName('CONTACT').AsString,PhoneChars);
                        if Dest<>'' then begin

                          Source:=Trim(PSelect.FieldByName('SOURCE').AsString);
                          Source:=iff(Source<>'',Source,FSourceAddress);

                          DestPort:=PSelect.FieldByName('DEST_PORT').AsInteger;
                          if DestPort=0 then
                            DestPort:=FDestPort;

                          LoggerWrite(FormatEx(FSOutMessageParams,[VarToStrDef(OutMessageId,''),Dest,TextOut]));

                          Sent:=TryToSend(TextOut,Dest,Source,
                                          DestPort,FSourcePort,
                                          Boolean(PSelect.FieldByName('DELIVERY').AsInteger),
                                          Boolean(PSelect.FieldByName('FLASH').AsInteger),
                                          MessageId);
                          if Sent then begin
                            LoggerWrite(FSOutMessageSendSuccess)
                          end else
                            LoggerWrite(FSOutMessageSendFail,ltError);

                        end;
                      end;
                    finally
                      UnlockMessage(OutMessageId,Sent,MessageId);
                    end;
                    PSelect.Next;
                  end;
                end;
              except
                On E: Exception do
                  LoggerWrite(E.Message,ltError);
              end;
            finally
              PSelect.Free;
            end;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      PLock.Free;
    end;
  end;

  procedure OutMessagesByOperators;
  var
    i: Integer;
  begin
    if FOperatorIds.Count>0 then begin
      for i:=0 to FOperatorIds.Count-1 do begin
        if Thread.Terminated then
          break;
         OutMessages(FOperatorIds[i]);
      end;
    end else
      OutMessages(Null);
  end;

  procedure InMessages;
  begin
    //    
  end;

begin
  Client:=TBisSmppServerThread(Thread).FClient;
  CodeMessages:=TBisSmppServerThread(Thread).FCodeMessages;

  if Assigned(Core) and
     Assigned(Client) and Assigned(CodeMessages) then begin

    Working:=true;
    try
      Randomize;
      try

        if not Client.Connected then
          Client.Connect;

        if Client.Connected then begin
          if FMaxCount>0 then begin
            case FMode of
              cmTransmitter: begin
                OutMessagesByOperators;
              end;
              cmReceiver: begin
                RefreshCodeMessages;
                InMessages;
              end;
              cmTransceiver: begin
                RefreshCodeMessages;
                InMessages;
                OutMessagesByOperators;
              end;
            end;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      Thread.Reset;
      Working:=false;
    end;
     
  end;
end;

procedure TBisSmppServer.ClientError(Sender: TBisSmppClient; const Message: String);
begin
  LoggerWrite(Message,ltError);
end;

procedure TBisSmppServer.ClientRequest(Sender: TBisSmppClient; Request: TBisSmppRequest);

  procedure DeliverSmRequest(ARequest: TBisSmppDeliverSmRequest);

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

    procedure OutMessageDelivery(MessageId,Contact: String; DateDelivery: TDateTime);
    var
      P: TBisProvider;
    begin
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='OUT_MESSAGE_DELIVERY';
        with P.Params do begin
          AddInvisible('MESSAGE_ID').Value:=MessageId;
          AddInvisible('CONTACT').Value:=Contact;
          AddInvisible('DATE_DELIVERY').Value:=DateDelivery;
        end;
        try
          P.Execute;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;

  var
    Str: TStringList;
    MessageId: String;
    DateDelivery: TDateTime;
    Contact: String;
  begin
    LoggerWrite(ARequest.ShortMessage);
    
    Str:=TStringList.Create;
    try
      GetStringsByString(ARequest.ShortMessage,' ',Str);
      // may be it is status report, just check it
      if (Str.Count>=8) and (Str.Strings[4]='REASON') then begin
        // may be it is message_id
        if ParseBetween(Str.Strings[6],'(',')',MessageId) and (Str.Strings[2]='SUCCEED') then begin
          DateDelivery:=GetDateTime(Str.Strings[0]+' '+Str.Strings[1]);
          Contact:=Str.Strings[3];
          OutMessageDelivery(MessageId,Contact,DateDelivery);
        end;
      end;
    finally
      Str.Free;
    end;
  end;

begin
  if Assigned(Request) then begin
    LoggerWrite(FormatEx(FSRequestFormat,
                         [Request.SequenceNumber,GetNameByClass(Request.ClassName),
                          IntToHex(Request.CommandId,SizeOf(Request.CommandId)*2),
                          GetEnumName(TypeInfo(TBisSmppCommandStatus),Integer(Request.CommandStatus))]));
    if Request is TBisSmppDeliverSmRequest then
      DeliverSmRequest(TBisSmppDeliverSmRequest(Request));
  end;
end;

procedure TBisSmppServer.ClientResponse(Sender: TBisSmppClient; Response: TBisSmppResponse);
begin
  if Assigned(Response) then begin
    LoggerWrite(FormatEx(FSResponseFormat,
                         [Response.SequenceNumber,GetNameByClass(Response.ClassName),
                          IntToHex(Response.CommandId,SizeOf(Response.CommandId)*2),
                          GetEnumName(TypeInfo(TBisSmppCommandStatus),Integer(Response.CommandStatus))]));
  end;
end;

procedure TBisSmppServer.ThreadBegin(Thread: TBisThread);
var
  AThread: TBisSmppServerThread;
begin
  AThread:=TBisSmppServerThread(Thread);
  AThread.FCodeMessages:=TBisDataSet.Create(Self);
  AThread.FClient:=TBisSmppClient.Create(Self);

  with AThread do begin
    FClient.Host:=FHost;
    FClient.Port:=FPort;
    FClient.SystemId:=FSystemId;
    FClient.Password:=FPassword;
    FClient.SystemType:=FSystemType;
    FClient.TypeOfNumber:=FTypeOfNumber;
    FClient.PlanIndicator:=FPlanIndicator;
    FClient.Range:=FRange;
    FClient.Mode:=FMode;
    FClient.TransportReadTimeout:=FTransportReadTimeout;
    FClient.AutoReconnect:=false;
    FClient.CheckTimeout:=FCheckTimeout;
    FClient.OnError:=ClientError;
    FClient.OnRequest:=ClientRequest;
    FClient.OnResponse:=ClientResponse;
  end;
end;

procedure TBisSmppServer.ThreadEnd(Thread: TBisThread);
begin
  with TBisSmppServerThread(Thread) do begin
    FreeAndNilEx(FCodeMessages);
    FreeAndNilEx(FClient);
  end;
end;

procedure TBisSmppServer.Start;
begin
  Stop;
  if not Started and Enabled then begin
    LoggerWrite(SStart);
    try
      FLocalIP:=GetLocalIP;
      FThread.Timeout:=FInterval;
      FThread.Start;
      LoggerWrite(SStartSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStartFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

procedure TBisSmppServer.Stop;
begin
  if Started then begin
    LoggerWrite(SStop);
    try
      FThread.Stop;
      LoggerWrite(SStopSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStopFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

initialization
  ExceptNotifierIgnores.Add(EIdReadTimeout);

end.
