unit BisMessageServerGsm;

interface

uses Windows, Classes, Contnrs, Variants, DB, SyncObjs,
     BisObject, BisCoreObjects, BisServers, BisServerModules,
     BisLogger, BisGsmModem, BisComPort, BisThread;

type
  TBisMessageServerGsm=class;

  TBisMessageServerGsmModemMode=(mmAll,mmIncoming,mmOutgoing);

  TBisMessageServerGsmModem=class;
                                                               
  TBisMessageServerGsmModemThread=class(TBisThread)
  private
    FModem: TBisGsmModem;
    FParent: TBisMessageServerGsmModem;
    FLoggerType: TBisLoggerType;
    FMessage: String;
    FEvent: TEvent;
    procedure LoggerWrite;
    procedure DoStatus(Message: String; LogType: TBisLoggerType=ltInformation);
    procedure ModemStatus(Sender: TObject; Message: String; Error: Boolean=false);
  protected
    property Modem: TBisGsmModem read FModem;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Execute; override;

    property Parent: TBisMessageServerGsmModem read FParent write FParent;
  end;

  TBisMessageServerGsmModem=class(TBisCoreObject)
  private
    FThread: TBisMessageServerGsmModemThread;

    FMode: TBisMessageServerGsmModemMode;
    FServer: TBisMessageServerGsm;
    FCheckImsi: String;
    FCheckImei: String;
    FBaudRate: TBisComPortBaudRate;
    FParityBits: TBisComPortParityBits;
    FStopBits: TBisComPortStopBits;
    FPort: String;
    FDataBits: TBisComPortDataBits;
    FInterval: Integer;
    FStorages: String;
    FMaxCount: Integer;
    FTimeOut: Integer;
    FUnknownSender: String;
    FUnknownCode: String;
    FPeriod: Variant;
    FDestPort: Variant;
    FSrcPort: Variant;
    FOperatorId: Variant;

    function GetConnected: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation; const LoggerName: String=''); override;

    procedure Connect;
    procedure Disconnect;

    property Mode: TBisMessageServerGsmModemMode read FMode write FMode;
    property CheckImei: String read FCheckImei write FCheckImei;
    property CheckImsi: String read FCheckImsi write FCheckImsi;

    property Port: String read FPort write FPort;
    property BaudRate: TBisComPortBaudRate read FBaudRate write FBaudRate;
    property StopBits: TBisComPortStopBits read FStopBits write FStopBits;
    property DataBits: TBisComPortDataBits read FDataBits write FDataBits;
    property ParityBits: TBisComPortParityBits read FParityBits write FParityBits;
    property Interval: Integer read FInterval write FInterval;
    property Storages: String read FStorages write FStorages;
    property MaxCount: Integer read FMaxCount write FMaxCount;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property UnknownSender: String read FUnknownSender write FUnknownSender;
    property UnknownCode: String read FUnknownCode write FUnknownCode;
    property Period: Variant read FPeriod write FPeriod;
    property DestPort: Variant read FDestPort write FDestPort;
    property SrcPort: Variant read FSrcPort write FSrcPort;
    property OperatorId: Variant read FOperatorId write FOperatorId;

    property Server: TBisMessageServerGsm read FServer write FServer;

    property Connected: Boolean read GetConnected;

  end;

  TBisMessageServerGsmModems=class(TBisCoreObjects)
  private
    function GetItems(Index: Integer): TBisMessageServerGsmModem;
    function GetConnected: Boolean;
  public
    function FindByPort(Port: String): TBisMessageServerGsmModem;
    function AddPort(Port: String): TBisMessageServerGsmModem;

    procedure Connect;
    procedure Disconnect;

    property Items[Index: Integer]: TBisMessageServerGsmModem read GetItems;
    property Connected: Boolean read GetConnected;
  end;

  TBisMessageServerGsm=class(TBisServer)
  private
    FSStart: String;
    FSStop: String;
    FModems: TBisMessageServerGsmModems;
    FOnlyOneModem: Boolean;
    FServerIP: String;

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
    FSCheckImeiFail: String;
    FSCheckImsiFail: String;
    FSInMessagesStart: String;
    FSOutMessagesStart: String;
    FSLockMessages: String;
    FSOutMessageParams: String;
    FSOutMessageSendSuccess: String;
    FSOutMessageSendFail: String;
    FSUnlockOutMessageStart: String;
    FSUnlockOutMessageFail: String;
    FSUnlockOutMessageSuccess: String;
    FSDeleteMessagesStart: String;
    FSDeleteMessagesEnd: String;
    FSStopFail: String;
    FSStartFail: String;
    FSStartSuccess: String;
    FSStopSuccess: String;
    FSChannelFormat: String;

    procedure ChangeParams(Sender: TObject);
//    procedure ResetMessages;
  protected
    function GetStarted: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Start; override;
    procedure Stop; override;

  published
    property SStart: String read FSStart write FSStart;
    property SStartSuccess: String read FSStartSuccess write FSStartSuccess;
    property SStartFail: String read FSStartFail write FSStartFail;

    property SStop: String read FSStop write FSStop;
    property SStopSuccess: String read FSStopSuccess write FSStopSuccess;
    property SStopFail: String read FSStopFail write FSStopFail;

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
    property SLockMessages: String read FSLockMessages write FSLockMessages;
    property SOutMessageParams: String read FSOutMessageParams write FSOutMessageParams;

    property SOutMessageSendSuccess: String read FSOutMessageSendSuccess write FSOutMessageSendSuccess;
    property SOutMessageSendFail: String read FSOutMessageSendFail write FSOutMessageSendFail;

    property SUnlockOutMessageStart: String read FSUnlockOutMessageStart write FSUnlockOutMessageStart;
    property SUnlockOutMessageSuccess: String read FSUnlockOutMessageSuccess write FSUnlockOutMessageSuccess;
    property SUnlockOutMessageFail: String read FSUnlockOutMessageFail write FSUnlockOutMessageFail;

    property SCheckImeiFail: String read FSCheckImeiFail write FSCheckImeiFail;
    property SCheckImsiFail: String read FSCheckImsiFail write FSCheckImsiFail;

    property SChannelFormat: String read FSChannelFormat write FSChannelFormat;     
  end;

procedure InitServerModule(AModule: TBisServerModule); stdcall;

exports
  InitServerModule;

implementation

uses SysUtils,
     BisConsts, BisUtils, BisDataSet, BisProvider, BisNetUtils,
     BisCore, BisFilterGroups, BisValues, BisOrders, BisCoreUtils,
     BisMessageServerGsmConsts;


procedure InitServerModule(AModule: TBisServerModule); stdcall;
begin
  ServerModule:=AModule;
  AModule.ServerClass:=TBisMessageServerGsm;
end;

{ TBisMessageServerGsmModemThread }

constructor TBisMessageServerGsmModemThread.Create;
begin
  inherited Create;
  FModem:=TBisGsmModem.Create(nil);
  FEvent:=TEvent.Create(nil,false,false,'');
  TranslateObject(FModem);
end;

destructor TBisMessageServerGsmModemThread.Destroy;
begin
  FEvent.SetEvent;
  FEvent.Free;
  FreeAndNilEx(FModem);
  inherited Destroy;
end;

procedure TBisMessageServerGsmModemThread.LoggerWrite;
begin
  if Assigned(FParent) then
    FParent.LoggerWrite(FMessage,FLoggerType);
end;

procedure TBisMessageServerGsmModemThread.DoStatus(Message: String; LogType: TBisLoggerType=ltInformation);
begin
  FMessage:=Message;
  FLoggerType:=LogType;
  Synchronize(LoggerWrite);
end;

procedure TBisMessageServerGsmModemThread.ModemStatus(Sender: TObject; Message: String; Error: Boolean=false);
begin
  FMessage:=VisibleControlCharacters(Message);
  FLoggerType:=ltInformation;
  if Error then
    FLoggerType:=ltError;
  Synchronize(LoggerWrite);
end;

procedure TBisMessageServerGsmModemThread.Execute;
var
//  Accounts: TBisProvider;
  CodeMessages: TBisProvider;
const
  PhoneChars=['+','0','1','2','3','4','5','6','7','8','9'];

{  procedure RefreshAccounts;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.ProviderName:='S_ACCOUNTS';
      with P.FieldNames do begin
        AddInvisible('ACCOUNT_ID');
        AddInvisible('PHONE');
        AddInvisible('FIRM_ID');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('LOCKED',fcEqual,0);
        Filters.Add('IS_ROLE',fcEqual,0);
        Filters.Add('PHONE',fcIsNotNull,Null);
      end;
      try
        P.Open;
        if P.Active then begin
          Accounts.Close;
          Accounts.CreateTable(P);
          Accounts.CopyRecords(P);
        end;
      except
        on E: Exception do
          DoStatus(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;}

  procedure RefreshCodeMessages;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
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
          DoStatus(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;

  // delete messages by types
  procedure DeleteMessages(Types: TBisGsmModemReadMessageTypes);
  var
    i: Integer;
    Storage: String;
    Storages: TStringList;
    Messages: TBisGsmModemMessages;
    Item: TBisGsmModemMessage;
  begin
    Storages:=TStringList.Create;
    Messages:=TBisGsmModemMessages.Create;
    try

      DoStatus(FParent.Server.SDeleteMessagesStart);

      GetStringsByString(FParent.Storages,';',Storages);

      for i:=0 to Storages.Count-1 do begin
        Storage:=Storages[i];
        FModem.ReadPduMessages(Messages,Storage,Types,FParent.MaxCount);
      end;

      for i:=0 to Messages.Count-1 do begin
        Item:=Messages.Items[i];
        FModem.DeleteMessage(Item);
      end;

      DoStatus(FParent.Server.SDeleteMessagesEnd);

    finally
      Messages.Free;
      Storages.Free;
    end;
  end;

  // read from modem and insert into database
  procedure InMessages;

    procedure GetSenderId(Contact: String; Senders: TBisDataSet);
    var
      Phone: String;
      P: TBisProvider;
    begin
      Phone:=GetOnlyChars(Contact,PhoneChars);
      if Trim(Contact)<>'' then begin
        P:=TBisProvider.Create(nil);
        try
          P.StopException:=false;
          P.WithWaitCursor:=false;
          P.ProviderName:='S_ACCOUNTS';
          with P.FieldNames do begin
            AddInvisible('ACCOUNT_ID');
            AddInvisible('PHONE');
            AddInvisible('FIRM_ID');
          end;
          with P.FilterGroups.Add do begin
            Filters.Add('LOCKED',fcEqual,0);
            Filters.Add('IS_ROLE',fcEqual,0);
            Filters.Add('PHONE',fcEqual,Phone);
          end;
          try
            P.Open;
            if P.Active then begin
              Senders.CreateTable(P);
              Senders.CopyRecords(P);
            end;
          except
            on E: Exception do
              DoStatus(E.Message,ltError);
          end;
        finally
          P.Free;
        end;
      end;

{      if Accounts.Active and not Accounts.IsEmpty and Assigned(Senders) then begin
        Senders.CreateTable(Accounts);
        Contact:=GetOnlyNumbers(Contact);
        if Trim(Contact)<>'' then begin
          Accounts.First;
          while not Accounts.Eof do begin
            Phone:=Accounts.FieldByName('PHONE').AsString;
            Phone:=GetOnlyNumbers(Phone);
            if AnsiSameText(Phone,Contact) then
              Senders.CopyRecord(Accounts);
            Accounts.Next;
          end;
        end;
      end;}
    end;

    function GetCodeMessageId(TextIn: String; var RetCode,ProcName, CommandString, Answer: String): Variant;

      function FindByDelimeter(Code, Delimeter: String): Boolean;
      var
        S: String;
        APos: Integer;
      begin
        Result:=false;
        APos:=AnsiPos(Delimeter,TextIn);
        if APos>0 then begin
          S:=Copy(TextIn,1,APos-1);
          Result:=AnsiSameText(S,Code);
        end;
      end;

      function CheckCodeByDelimeter(Code: String): Boolean;
      begin
        Result:=AnsiSameText(Code,TextIn);
        if not Result then
          Result:=FindByDelimeter(Code,':');
        if not Result then
          Result:=FindByDelimeter(Code,'=');
        if not Result then
          Result:=FindByDelimeter(Code,'-');
        if not Result then
          Result:=FindByDelimeter(Code,' ');
      end;

      function FindByCode(var NewCode: String): Boolean;
      var
        Str: TStringList;
        i: Integer;
      begin
        Result:=CheckCodeByDelimeter(NewCode);
        if not Result then begin
          Str:=TStringList.Create;
          try
            GetStringsByString(NewCode,';',Str);
            for i:=0 to Str.Count-1 do begin
              if CheckCodeByDelimeter(Str[i]) then begin
                NewCode:=Str[i];
                Result:=true;
                break;
              end;
            end;
          finally
            Str.Free;
          end;
        end;
      end;

    var
      CodeMessageId: Variant;
      LCode: Integer;
      LTextIn: Integer;
      NewCode: String;
      Code: String;
    begin
      Result:=Null;
      TextIn:=Trim(TextIn);
      LTextIn:=Length(TextIn);
      if (LTextIn>0) and CodeMessages.Active and not CodeMessages.IsEmpty then begin
        CodeMessages.First;
        while not CodeMessages.Eof do begin
          CodeMessageId:=CodeMessages.FieldByName('CODE_MESSAGE_ID').Value;
          Code:=Trim(CodeMessages.FieldByName('CODE').AsString);
          LCode:=Length(Code);
          NewCode:=Code;
          if (LCode>0) and FindByCode(NewCode) then begin
            RetCode:=NewCode;
            ProcName:=CodeMessages.FieldByName('PROC_NAME').AsString;
            CommandString:=CodeMessages.FieldByName('COMMAND_STRING').AsString;
            Answer:=CodeMessages.FieldByName('ANSWER').AsString;
            Result:=CodeMessageId;
            exit;
          end;
          CodeMessages.Next;
        end;
      end;
    end;

    procedure ExecuteProc(ProcName: String; InMessageId: Variant);
    var
      P: TBisProvider;
    begin
      DoStatus(FormatEx(FParent.Server.SExecuteProcStart,[ProcName]));
      P:=TBisProvider.Create(nil);
      try
        P.StopException:=false;
        P.WithWaitCursor:=false;
        P.ProviderName:=ProcName;
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
          AddInvisible('IN_MESSAGE_ID').Value:=InMessageId;
        end;
        try
          P.Execute;
          if P.Success then
            DoStatus(FParent.Server.SExecuteProcSuccess);
        except
          On E: Exception do begin
            DoStatus(FormatEx(FParent.Server.SExecuteProcFail,[E.Message]),ltError);
          end;
        end;
      finally
        P.Free;
      end;
    end;

    procedure ExecuteCommand(Code,CommandString: String; Contact,TextIn: String; DateSend: TDateTime;
                             SenderId, CodeMessageId, InMessageId: Variant);
    var
      S: String;
      i: Integer;
      Params: TBisValues;
      Param: TBisValue;
      StartupInfo: TStartupInfo;
      ProcessInfo: TProcessInformation;
      Ret: Boolean;
    begin
      DoStatus(FormatEx(FParent.Server.SExecuteCommandStart,[CommandString]));
      Params:=TBisValues.Create;
      try
        Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));
        Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
        Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
        Params.Add('DATE_SEND',DateTimeToStr(DateSend));
        Params.Add('TEXT_IN',TextIn);
        Params.Add('CONTACT',Contact);
        Params.Add('CODE',Code);

        S:=CommandString;
        for i:=0 to Params.Count-1 do begin
          Param:=Params.Items[i];
          S:=StringReplace(S,'%'+Param.Name,'"'+VarToStrDef(Param.Value,'')+'"',[rfReplaceAll, rfIgnoreCase]);
        end;
        try
          FillChar(StartupInfo,SizeOf(TStartupInfo),0);
          with StartupInfo do begin
            cb:=SizeOf(TStartupInfo);
            wShowWindow:=SW_SHOWDEFAULT;
          end;
          Ret:=CreateProcess(nil,PChar(S),nil,nil,False,
                             NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo, ProcessInfo);
          if Ret then
            DoStatus(FParent.Server.SExecuteCommandSuccess)
          else
            DoStatus(FormatEx(FParent.Server.SExecuteCommandFail,[SysErrorMessage(GetLastError)]),ltError);
        except
          On E: Exception do begin
            DoStatus(FormatEx(FParent.Server.SExecuteCommandFail,[E.Message]),ltError);
          end;
        end;
      finally
        Params.Free;
      end;
    end;

    procedure ExecuteAnswer(Code,Answer: String; Contact: String; DateSend: TDateTime;
                            SenderId, CodeMessageId, InMessageId: Variant);
    var
      S: String;
      i: Integer;
      Params: TBisValues;
      Param: TBisValue;
      Ret: Boolean;
      Item: TBisGsmModemMessage;
      Number: String;
    begin
      DoStatus(FParent.Server.SExecuteAnswerStart);
      Params:=TBisValues.Create;
      Item:=TBisGsmModemMessage.Create;
      try
        Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));
        Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
        Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
        Params.Add('DATE_SEND',DateTimeToStr(DateSend));
        Params.Add('CONTACT',Contact);
        Params.Add('CODE',Code);

        S:=Answer;
        for i:=0 to Params.Count-1 do begin
          Param:=Params.Items[i];
          S:=StringReplace(S,'%'+Param.Name,VarToStrDef(Param.Value,''),[rfReplaceAll, rfIgnoreCase]);
        end;
        try
          DoStatus(FormatEx(FParent.Server.SExecuteAnswerText,[S]));

          Number:=GetOnlyChars(Contact,PhoneChars);
          if Trim(Number)<>'' then begin
            Item.OriginalText:=S;
            Item.FlashSMS:=true;
            Item.OriginalNumber:=Number;
            Ret:=FModem.SendPduMessage(Item);
            if Ret then begin
  //            FModem.DeleteMessage(Item);
              DoStatus(FParent.Server.SExecuteAnswerSuccess)
            end else
              DoStatus(FormatEx(FParent.Server.SExecuteAnswerFail,[SysErrorMessage(GetLastError)]),ltError);
          end;
        except
          On E: Exception do begin
            DoStatus(FormatEx(FParent.Server.SExecuteAnswerFail,[E.Message]),ltError);
          end;
        end;
      finally
        Item.Free;
        Params.Free;
      end;
    end;

    function WriteMessage(Storage: String; Index: Integer; DateSend: TDateTime;
                          Contact, TextIn: String; SenderId, CodeMessageId, FirmId: Variant;
                          Answer, RetCode, ProcName, CommandString: String): Variant;
    var
      P: TBisProvider;
    begin
      Result:=Null;
      
      P:=TBisProvider.Create(nil);
      try
        DoStatus(FormatEx(FParent.Server.SInsertIntoDatabaseParams,
                         [Storage,
                          IntToStr(Index),
                          DateTimeToStr(DateSend),
                          Contact,
                          TextIn]));

        P.WithWaitCursor:=false;
        P.StopException:=false;
        P.ProviderName:='I_IN_MESSAGE';
        with P.Params do begin
          AddKey('IN_MESSAGE_ID');
          AddInvisible('SENDER_ID').Value:=SenderId;
          AddInvisible('CODE_MESSAGE_ID').Value:=CodeMessageId;
          AddInvisible('DATE_SEND').Value:=DateSend;
          AddInvisible('TEXT_IN').Value:=TextIn;
          AddInvisible('DATE_IN').Value:=Null;
          AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
          AddInvisible('CONTACT').Value:=Contact;
          AddInvisible('CHANNEL').Value:=FormatEx(FParent.FServer.FSChannelFormat,[FParent.FServer.FServerIP,FParent.Port]);
          AddInvisible('FIRM_ID').Value:=FirmId;
          AddInvisible('OPERATOR_ID').Value:=Null;
        end;
        try
          P.Execute;
          if P.Success then begin
            Result:=P.Params.ParamByName('IN_MESSAGE_ID').Value;
            DoStatus(FormatEx(FParent.Server.SInsertIntoDatabaseSuccess,[VarToStrDef(Result,'')]));
          end;
        except
          On E: Exception do
            DoStatus(FormatEx(FParent.Server.SInsertIntoDatabaseFail,[E.Message]),ltError);
        end;
      finally
        P.Free;
      end;

      if not VarIsNull(Result) then begin

        if not VarIsNull(CodeMessageId) then begin

          if not VarIsNull(SenderId) then
            if Trim(Answer)<>'' then
              ExecuteAnswer(RetCode,Answer,Contact,DateSend,SenderId,CodeMessageId,Result);

          if VarIsNull(SenderId) then
            if Trim(FParent.UnknownSender)<>'' then
              ExecuteAnswer(RetCode,FParent.UnknownSender,Contact,DateSend,SenderId,CodeMessageId,Result);

          if Trim(ProcName)<>'' then
            ExecuteProc(ProcName,Result);

          if Trim(CommandString)<>'' then
            ExecuteCommand(RetCode,CommandString,Contact,TextIn,DateSend,SenderId,CodeMessageId,Result);

        end else begin

          if Trim(FParent.UnknownCode)<>'' then
            ExecuteAnswer(RetCode,FParent.UnknownCode,Contact,DateSend,SenderId,CodeMessageId,Result);

        end;

      end;

    end;

    function IncomingGranted(SenderId: Variant): Boolean;
    var
      P: TBisProvider;
    begin
      Result:=false;
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.StopException:=false;
        P.ProviderName:='GET_INCOMING_GRANTED';
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=SenderId;
          AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
          AddInvisible('GRANTED',ptOutput);
        end;
        P.Execute;
        if P.Success then
          Result:=P.ParamByName('GRANTED').AsBoolean;
      finally
        P.Free;
      end;
    end;

  var
    i: Integer;
    Storage: String;
    Storages: TStringList;
    Messages: TBisGsmModemMessages;
    Senders: TBisDataSet;
    Item: TBisGsmModemMessage;
    SenderId: Variant;
    CodeMessageId: Variant;
    FirmId: Variant;
    DateSend: TDateTime;
    TextIn: String;
    Contact: String;
    ProcName: String;
    CommandString: String;
    Answer: String;
    RetCode: String;
    InMessageId: Variant;
    FlagWrite: Boolean;
  begin
    DoStatus(FParent.Server.SInMessagesStart);

    Storages:=TStringList.Create;
    Messages:=TBisGsmModemMessages.Create;
    try

      DoStatus(FParent.Server.SReadMessagesStart);

      GetStringsByString(FParent.Storages,';',Storages);
      for i:=0 to Storages.Count-1 do begin
        Storage:=Storages[i];
        FModem.ReadPduMessages(Messages,Storage,[mtReceivedNew],FParent.MaxCount);
      end;

      DoStatus(FormatEx(FParent.Server.SReadMessagesEnd,[Messages.Count]));

      for i:=0 to Messages.Count-1 do begin
        Item:=Messages.Items[i];

        DoStatus(FParent.Server.SInsertIntoDatabaseStart);

        FlagWrite:=false;

        Contact:=Item.Number;
        TextIn:=Item.Text;
        DateSend:=Item.TimeStamp;
        ProcName:='';
        CommandString:='';
        CodeMessageId:=GetCodeMessageId(TextIn,RetCode,ProcName,CommandString,Answer);

        Senders:=TBisDataSet.Create(nil);
        try
          GetSenderId(Contact,Senders);
          if Senders.Active and not Senders.Empty then begin
            Senders.First;
            while not Senders.Eof do begin
              SenderId:=Senders.FieldByName('ACCOUNT_ID').Value;
              if IncomingGranted(SenderId) then begin
                FirmId:=Senders.FieldByName('FIRM_ID').Value;
                InMessageId:=WriteMessage(Item.Storage,Item.Index,DateSend,Contact,TextIn,SenderId,
                                          CodeMessageId,FirmId,Answer,RetCode,ProcName,CommandString);
                FlagWrite:=not VarIsNull(InMessageId);
              end else
                FlagWrite:=true;
              Senders.Next;
            end;
          end else begin
            InMessageId:=WriteMessage(Item.Storage,Item.Index,DateSend,Contact,TextIn,Null,
                                      CodeMessageId,Null,Answer,RetCode,ProcName,CommandString);
            FlagWrite:=not VarIsNull(InMessageId);                                      
          end;
        finally
          Senders.Free;
        end;

        if FlagWrite then begin
          DoStatus(FParent.Server.SDeleteMessageStart);
          try
            FModem.DeleteMessage(Item);
          finally
            DoStatus(FParent.Server.SDeleteMessageEnd);
          end;
        end;

      end;

      DeleteMessages([mtReceivedRead]);

    finally
      Messages.Free;
      Storages.Free;
    end;
  end;

  // read from database and send by modem
  procedure OutMessages;
  var
    Locked: String;
    PSelect: TBisProvider;

    procedure UnlockMessage(Sended: Boolean);
    var
      P: TBisProvider;
    begin
      DoStatus(FParent.Server.SUnlockOutMessageStart);
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.StopException:=false;
        P.ProviderName:='UNLOCK_OUT_MESSAGE';
        with P.Params do begin
          AddInvisible('OUT_MESSAGE_ID').Value:=PSelect.FieldByName('OUT_MESSAGE_ID').Value;
          AddInvisible('SENDED').Value:=Integer(Sended);
        end;
        try
          P.Execute;
          if P.Success then
            DoStatus(FParent.Server.SUnlockOutMessageSuccess);
        except
          On E: Exception do
            DoStatus(FormatEx(FParent.Server.SUnlockOutMessageFail,[E.Message]),ltError);
        end;
      finally
        P.Free;
      end;
    end;

  var
    PLock: TBisProvider;
    LockCount: Integer;
    Item: TBisGsmModemMessage;
    i: Integer;
    Sended: Boolean;
    S: String;
    Field: TField;
    TextOut: String;
    Number: String;
    DestPort: Variant;
  begin
    DoStatus(FParent.Server.SOutMessagesStart);

    PLock:=TBisProvider.Create(nil);
    try
      Locked:=GetUniqueID;
      PLock.StopException:=false;
      PLock.WithWaitCursor:=false;
      PLock.ProviderName:='LOCK_OUT_MESSAGES';
      with PLock.Params do begin
        AddInvisible('MAX_COUNT').Value:=FParent.MaxCount;
        AddInvisible('LOCKED').Value:=Locked;
        AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
        if VarIsNull(FParent.Period) then AddInvisible('PERIOD').Value:=MaxInt
        else AddInvisible('PERIOD').Value:=FParent.Period;
        AddInvisible('CHANNEL').Value:=FormatEx(FParent.FServer.FSChannelFormat,[FParent.FServer.FServerIP,FParent.Port]);
        AddInvisible('OPERATOR_ID').Value:=FParent.OperatorId;
        AddInvisible('LOCK_COUNT',ptOutput).Value:=0;
      end;
      try
        PLock.Execute;
        if PLock.Success then begin
          LockCount:=PLock.Params.ParamByName('LOCK_COUNT').AsInteger;
          DoStatus(FormatEx(FParent.Server.SLockMessages,[LockCount]));

          if LockCount>0 then begin

            PSelect:=TBisProvider.Create(nil);
            try
              PSelect.StopException:=false;
              PSelect.WithWaitCursor:=false;
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
                  AddInvisible('CREATOR_NAME');
                  AddInvisible('RECIPIENT_NAME');
                  AddInvisible('RECIPIENT_PHONE');
                end;
                with FilterGroups.Add do begin
                  Filters.Add('LOCKED',fcEqual,Locked);
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

                  DeleteMessages([mtStoredUnsent,mtStoredSent]);
                  
                  PSelect.First;
                  while not PSelect.Eof do begin
                    Item:=TBisGsmModemMessage.Create;
                    try
                      Sended:=false;
                      S:=PSelect.FieldByName('TEXT_OUT').AsString;
                      for i:=0 to PSelect.Fields.Count-1 do begin
                        Field:=PSelect.Fields[i];
                        if not AnsiSameText(Field.FieldName,'TEXT_OUT') then
                          S:=StringReplace(S,'%'+Field.FieldName,VarToStrDef(Field.Value,''),[rfReplaceAll, rfIgnoreCase]);
                      end;
                      TextOut:=S;
                      Number:=GetOnlyChars(PSelect.FieldByName('CONTACT').AsString,PhoneChars);
                      if Trim(Number)<>'' then begin
                        Item.OriginalText:=TextOut;
                        Item.StatusRequest:=Boolean(PSelect.FieldByName('DELIVERY').AsInteger);
                        Item.FlashSMS:=Boolean(PSelect.FieldByName('FLASH').AsInteger);
                        Item.OriginalNumber:=Number;

                        DestPort:=PSelect.FieldByName('DEST_PORT').Value;
                        if VarIsNull(DestPort) then
                          DestPort:=FParent.DestPort;
                        Item.DestinationPort:=VarToIntDef(DestPort,Item.DestinationPort);
                        Item.SourcePort:=VarToIntDef(FParent.SrcPort,Item.SourcePort);

                        DoStatus(FormatEx(FParent.Server.SOutMessageParams,
                                          [PSelect.FieldByName('OUT_MESSAGE_ID').AsString,
                                           Number,TextOut]));

                        Sended:=FModem.SendPduMessage(Item);
                        if Sended then begin
                           FModem.DeleteMessage(Item);
                          DoStatus(FParent.Server.SOutMessageSendSuccess)
                        end else
                          DoStatus(FormatEx(FParent.Server.SOutMessageSendFail,[SysErrorMessage(GetLastError)]),ltError);
                      end;

                      UnlockMessage(Sended);
                    finally
                      Item.Free;
                    end;
                    PSelect.Next;
                  end;

                end;
              except
                On E: Exception do
                  DoStatus(E.Message,ltError);
              end;
            finally
              PSelect.Free;
            end;
          end;
        end;
      except
        On E: Exception do
          DoStatus(E.Message,ltError);
      end;
    finally
      PLock.Free;
    end;
  end;

  function CheckImei: Boolean;
  begin
    Result:=Trim(FParent.CheckImei)='';
    if not Result then begin
      Result:=AnsiSameText(FParent.CheckImei,FModem.SerialNumber);
      if not Result then
        DoStatus(FParent.Server.FSCheckImeiFail);
    end;
  end;

  function CheckImsi: Boolean;
  begin
    Result:=Trim(FParent.CheckImsi)='';
    if not Result then begin
      Result:=AnsiSameText(FParent.CheckImsi,FModem.Subscriber);
      if not Result then
        DoStatus(FParent.Server.FSCheckImsiFail);
    end;
  end;

var
  Flag: Boolean;
  Ret: TWaitResult;
begin
  inherited Execute;
  if Assigned(FParent) and Assigned(FParent.Server) and Assigned(Core) then begin

//    Accounts:=TBisProvider.Create(nil);
    CodeMessages:=TBisProvider.Create(nil);
    try
      FModem.OnStatus:=ModemStatus;
      FModem.Port:=FParent.Port;
      FModem.BaudRate:=FParent.BaudRate;
      FModem.StopBits:=FParent.StopBits;
      FModem.DataBits:=FParent.DataBits;
      FModem.ParityBits:=FParent.ParityBits;
      FModem.Timeout:=FParent.TimeOut;

      try
        while not Terminated do begin

          FEvent.ResetEvent;
          Ret:=FEvent.WaitFor(FParent.Interval);
          if Ret=wrTimeout then begin

            if not FModem.Connected then
              FModem.Connect;

            if FModem.Connected then begin

              Flag:=CheckImei;
              if Flag then
                Flag:=CheckImsi;

              if Flag then begin
                FParent.Server.Working:=true;
                try

                  if FParent.MaxCount>0 then begin
                    case FParent.Mode of
                      mmAll: begin
//                        RefreshAccounts;
                        RefreshCodeMessages;
                        InMessages;
                        OutMessages;
                      end;
                      mmIncoming: begin
//                        RefreshAccounts;
                        RefreshCodeMessages;
                        InMessages;
                      end;
                      mmOutgoing: OutMessages;
                    end;
                  end;

                finally
                  FParent.Server.Working:=false;
                end;
              end;
            end;
          end else
            Terminate;

        end;
      finally
        FModem.Disconnect;
      end;

    finally
      CodeMessages.Free;
//      Accounts.Free;
    end;
  end;
end;

{ TBisMessageServerGsmModem }

constructor TBisMessageServerGsmModem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInterval:=1000;
end;

destructor TBisMessageServerGsmModem.Destroy;
begin
  FreeAndNilEx(FThread);
  inherited Destroy;
end;

function TBisMessageServerGsmModem.GetConnected: Boolean;
begin
  Result:=Assigned(FThread) and Assigned(FThread.Modem) and
          FThread.Modem.Connected;
end;

procedure TBisMessageServerGsmModem.LoggerWrite(const Message: String; LogType: TBisLoggerType; const LoggerName: String);
var
  S: String;
begin
  if Assigned(FServer) then begin
    S:=Format('%s: %s',[FPort,Message]);
    FServer.LoggerWrite(S,LogType,LoggerName);
  end;
end;

procedure TBisMessageServerGsmModem.Connect;
begin
  Disconnect;
  if not Connected then begin
    FThread:=TBisMessageServerGsmModemThread.Create;
    FThread.Parent:=Self;
    FThread.Resume;
  end;
end;

procedure TBisMessageServerGsmModem.Disconnect;
begin
  FreeAndNilEx(FThread);
end;

{ TBisMessageServerGsmModems }

procedure TBisMessageServerGsmModems.Connect;
var
  i: Integer;
begin
  for i:=0 to Count-1 do
    Items[i].Connect;
end;

procedure TBisMessageServerGsmModems.Disconnect;
var
  i: Integer;
begin
  for i:=0 to Count-1 do
    Items[i].Disconnect;
end;

function TBisMessageServerGsmModems.GetConnected: Boolean;
var
  i: Integer;
begin
  Result:=false;
  for i:=0 to Count-1 do
    if Items[i].Connected then begin
      Result:=true;
      exit;
    end;

end;

function TBisMessageServerGsmModems.FindByPort(Port: String): TBisMessageServerGsmModem;
var
  i: Integer;
  Item: TBisMessageServerGsmModem;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Port,Port) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisMessageServerGsmModems.AddPort(Port: String): TBisMessageServerGsmModem;
begin
  Result:=nil;
  if not Assigned(FindByPort(Port)) then begin
    Result:=TBisMessageServerGsmModem.Create(nil);
    Result.Port:=Port;
    AddObject(Result);
  end;
end;

function TBisMessageServerGsmModems.GetItems(Index: Integer): TBisMessageServerGsmModem;
begin
  Result:=TBisMessageServerGsmModem(inherited Items[Index]);
end;

{ TBisMessageServerGsm }

constructor TBisMessageServerGsm.Create(AOwner: TComponent);
var
  Buffer: String;
begin
  inherited Create(AOwner);
  Params.OnChange:=ChangeParams;
  FModems:=TBisMessageServerGsmModems.Create(Self);

  FOnlyOneModem:=false;
  if Core.LocalBase.ReadParam(SParamOnlyOneModem,Buffer) then
    FOnlyOneModem:=Boolean(StrToIntDef(Buffer,0));

  FSStart:='������� ������ ...';
  FSStartSuccess:='������� ������ ��������� �������.';
  FSStartFail:='������� ������ �� ���������. ������: %s';
  FSStop:='�������� ������ ...';
  FSStopSuccess:='�������� ������ ��������� �������.';
  FSStopFail:='�������� ������ �� ���������. ������: %s';
  FSInMessagesStart:='��������� �������� ��������� ...';
  FSReadMessagesStart:='������ �������� ��������� ...';
  FSReadMessagesEnd:='��������� %d �������� ���������.';
  FSInsertIntoDatabaseStart:='������ �������� ��������� ��������� ...';
  FSInsertIntoDatabaseParams:='��������� ��������� ���������: ���������=>%s  ������=>%s ���� ��������=>%s �����=>%s �����=>%s';
  FSInsertIntoDatabaseSuccess:='�������� ��������� ������� �������. �������������=>%s';
  FSInsertIntoDatabaseFail:='�������� ��������� �� �������. ������: %s';
  FSExecuteProcStart:='������ ���������� ��������� %s ...';
  FSExecuteProcSuccess:='��������� ��������� �������.';
  FSExecuteProcFail:='��������� �� ���������. ������: %s';
  FSExecuteCommandStart:='������ ���������� ������� %s ...';
  FSExecuteCommandSuccess:='������� ��������� �������.';
  FSExecuteCommandFail:='������� �� ���������. ������: %s';
  FSExecuteAnswerStart:='������ ���������� ������ ...';
  FSExecuteAnswerText:='����� ������ =>%s';
  FSExecuteAnswerSuccess:='����� �������� �������.';
  FSExecuteAnswerFail:='����� �� ��������. ������: %s';
  FSDeleteMessageStart:='������ �������� ��������� ��������� ...';
  FSDeleteMessageEnd:='�������� ��������� �������.';
  FSDeleteMessagesStart:='������ �������� ��������� ...';
  FSDeleteMessagesEnd:='��������� �������.';
  FSOutMessagesStart:='��������� ��������� ��������� ...';
  FSLockMessages:='������������� %d ��������� ���������.';
  FSOutMessageParams:='��������� ���������� ���������: �������������=>%s �����=>%s �����=>%s';
  FSOutMessageSendSuccess:='��������� ��������� ���������� �������.';
  FSOutMessageSendFail:='��������� ��������� �� ����������. ������: %s';
  FSUnlockOutMessageStart:='������ ������������� ��������� ...';
  FSUnlockOutMessageSuccess:='������������� ��������� ��������� �������.';
  FSUnlockOutMessageFail:='������������� ��������� �� ���������. ������: %s';
  FSCheckImeiFail:='�� ������ IMEI.';
  FSCheckImsiFail:='�� ������ IMSI.';
  FSChannelFormat:='%s:%s';


end;

destructor TBisMessageServerGsm.Destroy;
begin
  FModems.Free;
  inherited Destroy;
end;

function TBisMessageServerGsm.GetStarted: Boolean;
begin
  Result:=FModems.Connected;
end;

procedure TBisMessageServerGsm.Init;
begin
  inherited Init;
  FModems.Init;
end;

procedure TBisMessageServerGsm.ChangeParams(Sender: TObject);
var
  i: Integer;
  Param: TBisServerParam;
  Stream: TMemoryStream;
  Table: TBisDataSet;
  AEnabled: Boolean;
  Port: String;
  Modem: TBisMessageServerGsmModem;
  EnableCount: Integer;
begin
  FModems.Clear;
  for i:=0 to Params.Count-1 do begin
    Param:=Params.Items[i];
    if AnsiSameText(Param.ParamName,SParamModems) then begin
      Stream:=TMemoryStream.Create;
      try
        Stream.WriteBuffer(Pointer(Param.Value)^,Length(Param.Value));
        if Stream.Size>0 then begin
          Stream.Position:=0;
          Table:=TBisDataSet.Create(nil);
          try
            Table.LoadFromStream(Stream);
            Table.Open;
            if Table.Active and not Table.IsEmpty then begin
              EnableCount:=0;
              Table.First;
              while not Table.Eof do begin
                AEnabled:=Boolean(Table.FieldByName(SFieldEnabled).AsInteger);
                if FOnlyOneModem and (EnableCount>0) then
                  AEnabled:=false;
                if AEnabled then begin
                  Port:=Table.FieldByName(SFieldPort).AsString;
                  if Trim(Port)<>'' then begin
                    Modem:=FModems.AddPort(Port);
                    if Assigned(Modem) then begin
                      Modem.Mode:=TBisMessageServerGsmModemMode(Table.FieldByName(SFieldMode).AsInteger);
                      Modem.Interval:=Table.FieldByName(SFieldInterval).AsInteger;
                      Modem.Storages:=Table.FieldByName(SFieldStorages).AsString;
                      Modem.MaxCount:=Table.FieldByName(SFieldMaxCount).AsInteger;
                      Modem.TimeOut:=Table.FieldByName(SFieldTimeOut).AsInteger;
                      Modem.CheckImei:=Table.FieldByName(SFieldImei).AsString;
                      Modem.CheckImsi:=Table.FieldByName(SFieldImsi).AsString;
                      Modem.BaudRate:=TBisComPortBaudRate(Table.FieldByName(SFieldBaudRate).AsInteger);
                      Modem.DataBits:=TBisComPortDataBits(Table.FieldByName(SFieldDataBits).AsInteger);
                      Modem.StopBits:=TBisComPortStopBits(Table.FieldByName(SFieldStopBits).AsInteger);
                      Modem.ParityBits:=TBisComPortParityBits(Table.FieldByName(SFieldParityBits).AsInteger);
                      Modem.UnknownSender:=Table.FieldByName(SFieldUnknownSender).AsString;
                      Modem.UnknownCode:=Table.FieldByName(SFieldUnknownCode).AsString;
                      Modem.Period:=Table.FieldByName(SFieldPeriod).Value;
                      Modem.DestPort:=Table.FieldByName(SFieldDestPort).Value;
                      Modem.SrcPort:=Table.FieldByName(SFieldSrcPort).Value;
                      Modem.OperatorId:=Table.FieldByName(SFieldOperatorId).Value;
                      Modem.Server:=Self;
                      Inc(EnableCount);
                    end;
                  end;
                end;
                Table.Next;
              end;
            end;
          finally
            Table.Free;
          end;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

{procedure TBisMessageServerGsm.ResetMessages;
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=false;
    P.ProviderName:='RESET_LOCK_OUT_MESSAGES';
    P.Execute;
  finally
    P.Free;
  end;
end;}

procedure TBisMessageServerGsm.Start;

  function GetIP: String;
  var
    List: TStringList;
    i: Integer;
    Index: Integer;
  begin
    List:=TStringList.Create;
    try
      Result:='';
      GetIPList(List);
      if List.Count>0 then begin

        Index:=List.IndexOf(Result);
        if Index<>-1 then
          List.Delete(Index);
        Index:=List.IndexOf('0.0.0.0');
        if Index<>-1 then
          List.Delete(Index);

        List.Sort;
        for i:=0 to List.Count-1 do begin
          Result:=List[i];
          if Trim(Result)<>'' then
            exit;
        end;
      end;
    finally
      List.Free;
    end;
  end;

begin
  LoggerWrite(FSStart);
  try
//    ResetMessages;
    FServerIP:=GetIP;
    FModems.Connect;
    LoggerWrite(FSStartSuccess);
  except
    On E: Exception do begin
      LoggerWrite(FormatEx(FSStartFail,[E.Message]),ltError);
    end;
  end;
end;

procedure TBisMessageServerGsm.Stop;
begin
  LoggerWrite(FSStop);
  try
    FModems.Disconnect;
    LoggerWrite(FSStopSuccess);
  except
    On E: Exception do begin
      LoggerWrite(FormatEx(FSStopFail,[E.Message]),ltError);
    end;
  end;
end;

end.
