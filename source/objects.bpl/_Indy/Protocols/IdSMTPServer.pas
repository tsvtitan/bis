{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  107843: IdSMTPServer.pas
{
{   Rev 1.8    24/10/2004 21:26:14  ANeillans
{ RCPTList can be set
}
{
    Rev 1.7    9/15/2004 5:02:06 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.6    31/08/2004 20:21:34  ANeillans
{ Bug fix -- format problem.
}
{
{   Rev 1.5    08/08/2004 21:03:10  ANeillans
{ Continuing....
}
{
{   Rev 1.4    02/08/2004 21:14:28  ANeillans
{ Auth working
}
{
{   Rev 1.3    01/08/2004 13:02:16  ANeillans
{ Development.
}
{
{   Rev 1.2    01/08/2004 09:50:26  ANeillans
{ Continued development.
}
{
{   Rev 1.1    7/28/2004 8:26:46 AM  JPMugaas
{ Further work on the SMTP Server.  Not tested yet.
}
{
{   Rev 1.0    7/27/2004 5:14:38 PM  JPMugaas
{ Start on TIdSMTPServer rewrite.
}
unit IdSMTPServer;

interface
uses
  Classes,
  IdAssignedNumbers,
  IdCmdTCPServer,
  IdCommandHandlers,
  IdContext,
  IdEMailAddress,
  IdException,
  IdExplicitTLSClientServerBase,
  IdReply,
  IdReplyRFC,
  IdReplySMTP,
  IdTCPConnection,
  IdTCPServer,
  IdYarn,
  IdStack;

type
  EIdSMTPServerError = class(EIdException);
  EIdSMTPServerNoRcptTo = class(EIdSMTPServerError);
  TIdMailFromReply = (mAccept, mReject);
  TIdRCPToReply =
    (
    rAddressOk, //address is okay
    rRelayDenied, //we do not relay for third-parties
    rInvalid, //invalid address
    rWillForward, //not local - we will forward
    rNoForward, //not local - will not forward - please use
    rTooManyAddresses, //too many addresses
    rDisabledPerm, //disabled permentantly - not accepting E-Mail
    rDisabledTemp //disabled temporarily - not accepting E-Mail
    );
  TIdDataReply =
    (
    dOk, //accept the mail message
    dMBFull, //Mail box full
    dSystemFull, //no more space on server
    dLocalProcessingError, //local processing error
    dTransactionFailed, //transaction failed
    dLimitExceeded  //exceeded administrative limit
    );
  TIdSMTPServerContext = class;
  TOnUserLoginEvent = procedure(ASender: TIdSMTPServerContext; const AUsername, APassword: string;
    var VAuthenticated: Boolean) of object;
  TOnMailFromEvent = procedure(ASender: TIdSMTPServerContext; const AAddress : string;
    var VAction : TIdMailFromReply) of object;
  TOnRcptToEvent = procedure(ASender: TIdSMTPServerContext; const AAddress : string;
    var VAction : TIdRCPToReply; var VForward : String) of object;
  TOnMsgReceive = procedure(ASender: TIdSMTPServerContext; AMsg : TStream;
    var LAction : TIdDataReply) of object;
  TOnReceived = procedure(ASender: TIdSMTPServerContext; AReceived : String) of object;
  TIdSMTPServer = class(TIdExplicitTLSServer)
  protected
    //events
    FOnUserLogin : TOnUserLoginEvent;
    FOnMailFrom : TOnMailFromEvent;
    FOnRcptTo : TOnRcptToEvent;
    FOnMsgReceive : TOnMsgReceive;
    FOnReceived : TOnReceived;
    //misc
    FServerName : String;
    function DoAuthLogin(ASender: TIdCommand; const Login:string): Boolean;
    //command handlers
    procedure CommandNOOP(ASender: TIdCommand);
    procedure CommandQUIT(ASender: TIdCommand);
    procedure CommandEHLO(ASender: TIdCommand);
    procedure CommandHELO(ASender: TIdCommand);
    procedure CommandAUTH(ASender: TIdCommand);
    procedure CommandMAIL(ASender: TIdCommand);
    procedure CommandRCPT(ASender: TIdCommand);
    procedure CommandDATA(ASender: TIdCommand);
    procedure CommandRSET(ASender: TIdCommand);
    procedure CommandSTARTTLS(ASender: TIdCommand);
    {
    Note that for SMTP, I make a lot of procedures for replies.

    The reason is that we use precise enhanced status codes.  These serve
    as diangostics and give much more information than the 3 number standard replies.
    The enhanced codes will sometimes appear in bounce notices.
    Note: Enhanced status codes should only appear if a client uses EHLO instead of HELO.

    }
    //common reply procs
    procedure AuthFailed(ASender: TIdCommand);
    procedure CmdSyntaxError(AContext: TIdContext; ALine: string; const AReply : TIdReply = nil); overload;
    procedure CmdSyntaxError(ASender: TIdCommand); overload;

    procedure BadSequenceError(ASender: TIdCommand);
    procedure InvalidSyntax(ASender: TIdCommand);
    procedure NoHello(ASender: TIdCommand);
    procedure MustUseTLS(ASender: TIdCommand);
    //Mail From
    procedure MailFromAccept(ASender: TIdCommand; const AAddress : String = '');
    procedure MailFromReject(ASender: TIdCommand; const AAddress : String = '');
    //address replies   - RCPT TO
    procedure AddrValid(ASender: TIdCommand; const AAddress : String = '');
    procedure AddrInvalid(ASender: TIdCommand; const AAddress : String = '');
    procedure AddrWillForward(ASender: TIdCommand; const AAddress : String = '');
    procedure AddrNotWillForward(ASender: TIdCommand; const AAddress : String = ''; const ATo : String = '');
    procedure AddrDisabledPerm(ASender: TIdCommand; const AAddress : String = '');
    procedure AddrDisabledTemp(ASender: TIdCommand; const AAddress : String = '');
    procedure AddrNoRelaying(ASender: TIdCommand; const AAddress : String = '');
    procedure AddrTooManyRecipients(ASender: TIdCommand);
    //mail submit replies
    procedure MailSubmitOk(ASender: TIdCommand);
    procedure MailSubmitLimitExceeded(ASender: TIdCommand);
    procedure MailSubmitStorageExceededFull(ASender: TIdCommand);
    procedure MailSubmitTransactionFailed(ASender: TIdCommand);
    procedure MailSubmitLocalProcessingError(ASender: TIdCommand);
    procedure MailSubmitSystemFull(ASender: TIdCommand);
    procedure SetEnhReply(AReply: TIdReply;
      const ANumericCode: Integer; const AEnhReply, AText: String;
      const IsEHLO: Boolean);
    //  overrides for SMTP
    function GetReplyClass: TIdReplyClass; override;
    function GetRepliesClass: TIdRepliesClass; override;
    procedure InitComponent; override;
    procedure DoReplyUnknownCommand(AContext: TIdContext; ALine: string); override;
    procedure InitializeCommandHandlers; override;
  published
    //events
    property OnMsgReceive : TOnMsgReceive read FOnMsgReceive write FOnMsgReceive;
    property OnUserLogin : TOnUserLoginEvent read FOnUserLogin write FOnUserLogin;
    property OnMailFrom : TOnMailFromEvent read FOnMailFrom write FOnMailFrom;
    property OnRcptTo : TOnRcptToEvent read FOnRcptTo write FOnRcptTo;
    property OnReceived: TOnReceived read FOnReceived write FOnReceived;
    //properties
    property ServerName : String read FServerName write FServerName;
    property DefaultPort default IdPORT_SMTP;
    property UseTLS;
  end;

  TIdSMTPState = (idSMTPNone,idSMTPHelo,idSMTPMail,idSMTPRcpt,idSMTPData);
  TIdSMTPServerContext = class(TIdContext)
  protected
    FSMTPState: TIdSMTPState;
    FFrom: string;
    FRCPTList: TIdEMailAddressList;
    FHELO: Boolean;
    FEHLO: Boolean;
    FHeloString: String;
    FUsername: string;
    FPassword: string;
    FLoggedIn: Boolean;
    FPipeLining : Boolean;
    FFinalStage : Boolean;
    function GetUsingTLS:boolean;
    procedure SetPipeLining(const AValue : Boolean);
  public
    constructor Create(
      AConnection: TIdTCPConnection;
      AYarn: TIdYarn;
      AList: TThreadList = nil
      ); override;
    destructor Destroy; override;
    procedure CheckPipeLine;
    property SMTPState: TIdSMTPState read FSMTPState write FSMTPState;
    property From: string read FFrom write FFrom;
    property RCPTList: TIdEMailAddressList read FRCPTList write FRCPTList;
    property HELO: Boolean read FHELO write FHELO;
    property EHLO: Boolean read FEHLO write FEHLO;
    property HeloString : String read FHeloString write FHeloString;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property LoggedIn: Boolean read FLoggedIn write FLoggedIn;
    property FinalStage: Boolean read FFinalStage write FFinalStage;
    property UsingTLS:boolean read GetUsingTLS;
    property PipeLining : Boolean read FPipeLining write SetPipeLining;
    //
  end;

const
 IdSMTPSvrReceivedString = 'Received: from $hostname[$ipaddress] (helo=$helo) by $svrhostname[$svripaddress] with $protocol ($servername)'; {do not localize}

implementation

uses
  IdCoderMIME,
  IdGlobal,
  IdGlobalProtocols,
  IdResourceStringsProtocols,
  IdSSL,
  SysUtils;

{ TIdSMTPServer }

procedure TIdSMTPServer.CmdSyntaxError(AContext: TIdContext; ALine: string;
  const AReply: TIdReply);
var LTmp : String;
  i : Integer;
  LReply : TIdReply;
const
  LWhiteSet = [TAB, CHAR32];    {Do not Localize}
begin
  LTmp := ALine;
  //First make the first word uppercase
  for i := 1 to Length(LTmp) do
  begin
    if CharIsInSet(LTmp,i,LWhiteSet) then
    begin
      Break;
    end
    else
    begin
      LTmp[i] := UpCase(LTmp[i]);
    end;
  end;
  try
    if Assigned(AReply) then
    begin
      LReply := AReply;
    end
    else
    begin
      LReply := FReplyClass.Create(nil, ReplyTexts);
      LReply.Assign(ReplyUnknownCommand);
    end;
//    LReply.Text.Clear;
   if (AContext as TIdSMTPServerContext).Ehlo then begin
     (LReply as TIdReplySMTP).SetEnhReply(500, '5.0.0', Format(RSFTPCmdNotRecognized,[LTmp])); {do not localize}
   end else begin
     LReply.SetReply(500, Format(RSFTPCmdNotRecognized,[LTmp]));
   end;
//    LReply.Text.Add(Format(RSFTPCmdNotRecognized,[LTmp]));
    AContext.Connection.IOHandler.Write(LReply.FormattedReply);
  finally
    if not Assigned(AReply) then begin
      FreeAndNil(LReply);
    end;
  end;
end;

procedure TIdSMTPServer.BadSequenceError(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,503,Id_EHR_PR_OTHER_PERM,RSSMTPSvrBadSequence,
   (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.CmdSyntaxError(ASender: TIdCommand);
begin
  CmdSyntaxError(ASender.Context, ASender.RawLine, FReplyUnknownCommand );
  ASender.PerformReply := False;
end;

procedure TIdSMTPServer.CommandEHLO(ASender: TIdCommand);
var LS : TIdReplySMTP;
    LContext : TIdSMTPServerContext;
begin
  LContext := ASender.Context as TIdSMTPServerContext;
  LS := ASender.Reply as TIdReplySMTP;
  LS.SetEnhReply(250,'',Format(RSSMTPSvrHello, [ASender.UnparsedParams]));
  if Assigned(FOnUserLogin) then
  begin
    LS.Text.Add('AUTH LOGIN');    {Do not Localize}
  end;
  LS.Text.Add('ENHANCEDSTATUSCODES'); {do not localize}
  LS.Text.Add('PIPELINING'); {do not localize}
  if FUseTLS in ExplicitTLSVals then
  begin
    LS.Text.Add('STARTTLS');    {Do not Localize}
  end;
  LContext.EHLO := True;
  LContext.SMTPState := idSMTPHelo;
  LContext.HeloString := ASender.UnparsedParams;
  LContext.SMTPState := idSMTPHelo;
end;

procedure TIdSMTPServer.DoReplyUnknownCommand(AContext: TIdContext;
  ALine: string);
begin
  CmdSyntaxError(AContext,ALine);
end;

function TIdSMTPServer.GetRepliesClass: TIdRepliesClass;
begin
  Result := TIdRepliesSMTP;
end;

function TIdSMTPServer.GetReplyClass: TIdReplyClass;
begin
  Result := TIdReplySMTP;
end;

procedure TIdSMTPServer.InitComponent;
var LS : TIdReplySMTP;
begin
  inherited;
  FContextClass := TIdSMTPServerContext;
  HelpReply.Code := ''; //we will handle the help ourselves
  FRegularProtPort := IdPORT_SMTP;
  FImplicitTLSProtPort := IdPORT_ssmtp;
  DefaultPort := IdPORT_SMTP;
  FServerName  := 'Indy SMTP Server'; {do not localize}
  LS := (ReplyUnknownCommand as TIdReplySMTP);
  LS.SetEnhReply(500, Id_EHR_PR_SYNTAX_ERR, 'Syntax Error'); {do not localize}
  LS := (Greeting as TIdReplySMTP);
  LS.SetEnhReply(220, '' ,RSSMTPSvrWelcome);
end;


procedure TIdSMTPServer.InitializeCommandHandlers;
var LCmd : TIdCommandHandler;
begin
  inherited;
  LCmd := CommandHandlers.Add;
  LCmd.Command := 'EHLO';  {do not localize}
  LCmd.OnCommand := CommandEHLO;
  LCmd.NormalReply.NumericCode := 250;
  LCmd.ParseParams := True;
  SetEnhReply(LCmd.ExceptionReply ,451,Id_EHR_PR_OTHER_TEMP, 'Internal Error', False); {do not localize}

  LCmd := CommandHandlers.Add;
  LCmd.Command := 'HELO';  {do not localize}
  LCmd.OnCommand := CommandHELO;
  LCmd.NormalReply.NumericCode := 250;
  LCmd.ParseParams := True;
  SetEnhReply(LCmd.ExceptionReply ,451,Id_EHR_PR_OTHER_TEMP, 'Internal Error', False); {do not localize}

  LCmd := CommandHandlers.Add;
  LCmd.Command := 'AUTH';  {do not localize}
  LCmd.OnCommand := CommandAUTH;
  LCmd.ParseParams := True;
  SetEnhReply(LCmd.ExceptionReply ,451,Id_EHR_PR_OTHER_TEMP, 'Internal Error', False); {do not localize}

  LCmd := CommandHandlers.Add;
  // NOOP
  LCmd.Command := 'NOOP';    {Do not Localize}
  SetEnhReply(LCmd.NormalReply ,250,Id_EHR_GENERIC_OK,RSSMTPSvrOk, True);
  LCmd.OnCommand := CommandNOOP;
  SetEnhReply(LCmd.ExceptionReply ,451,Id_EHR_PR_OTHER_TEMP, 'Internal Error', False); {do not localize}

  LCmd := CommandHandlers.Add;
  // QUIT
  LCmd.Command := 'QUIT';    {Do not Localize}
  LCmd.CmdDelimiter := ' ';    {Do not Localize}
  LCmd.Disconnect := True;
  SetEnhReply(LCmd.NormalReply, 221, Id_EHR_GENERIC_OK, RSSMTPSvrQuit, False);
  LCmd.OnCommand := CommandQUIT;

  LCmd := CommandHandlers.Add;
  // RCPT <SP> TO:<forward-path> <CRLF>
  LCmd.Command := 'RCPT';    {Do not Localize}
  LCmd.CmdDelimiter := ' ';    {Do not Localize}
  LCmd.OnCommand := CommandRcpt;
  SetEnhReply(LCmd.ExceptionReply,550,Id_EHR_MSG_BAD_DEST,'', False);

  LCmd := CommandHandlers.Add;
  // MAIL <SP> FROM:<reverse-path> <CRLF>
  LCmd.Command := 'MAIL';    {Do not Localize}
  LCmd.CmdDelimiter := ' ';    {Do not Localize}
  LCmd.OnCommand := CommandMail;
  SetEnhReply(LCmd.ExceptionReply,451,Id_EHR_MSG_BAD_SENDER_ADDR,'', False);

  LCmd := CommandHandlers.Add;
  // DATA <CRLF>
  LCmd.Command := 'DATA'; {Do not Localize}
  LCmd.OnCommand := CommandDATA;
  SetEnhReply(LCmd.ExceptionReply, 451, Id_EHR_PR_OTHER_TEMP, 'Internal Error' , False); {do not localize}

  LCmd := CommandHandlers.Add;
  // RSET <CRLF>
  LCmd.Command := 'RSET';    {Do not Localize}
  LCmd.NormalReply.NumericCode := 250;
  LCmd.NormalReply.Text.Text := RSSMTPSvrOk;
  LCmd.OnCommand := CommandRSET;

  LCmd := CommandHandlers.Add;
  // STARTTLS <CRLF>
  LCmd.Command := 'STARTTLS';    {Do not Localize}
  LCmd.OnCommand := CommandStartTLS;
end;

procedure TIdSMTPServer.MustUseTLS(ASender: TIdCommand);
begin
    SetEnhReply(ASender.Reply,530,Id_EHR_USE_STARTTLS,RSSMTPSvrReqSTARTTLS, (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.CommandAUTH(ASender: TIdCommand);
var
  Login: string;
begin
  //Note you can not use PIPELINING with AUTH
  TIdSMTPServerContext(ASender.Context).PipeLining := False;
  if TIdSMTPServerContext(ASender.Context).EHLO then // Only available with EHLO
  begin
    if not ((FUseTLS=utUseRequireTLS) and not TIdSMTPServerContext(ASender.Context).UsingTLS) then
    begin
      if Assigned( FOnUserLogin  ) then
      begin
        if Length(ASender.UnparsedParams) > 0 then
        begin
          Login := ASender.UnparsedParams;
          DoAuthLogin(ASender, Login)
        end
        else
        begin
          CmdSyntaxError(ASender);
        end;
      end;
    end
    else
    begin
      MustUseTLS(ASender);
    end;
  end;
end;

procedure TIdSMTPServer.CommandHELO(ASender: TIdCommand);
var LS : TIdSMTPServerContext;
begin
  LS := ASender.Context as TIdSMTPServerContext;
    if LS.SMTPState <> idSMTPNone then
    begin
      BadSequenceError(ASender);
      Exit;
    end;

  if Length(ASender.UnparsedParams) > 0 then
  begin
    ASender.Reply.SetReply(250,Format(RSSMTPSvrHello, [ASender.UnparsedParams]));
    LS.HELO := True;
    LS.SMTPState := idSMTPHelo;
    LS.HeloString := ASender.UnparsedParams;
  end
  else
  begin
    ASender.Reply.SetReply(501,RSSMTPSvrParmErr);
  end;
  LS.PipeLining := False;
end;

function TIdSMTPServer.DoAuthLogin(ASender: TIdCommand;
  const Login: string): Boolean;
var
  S: string;
  LUsername, LPassword: string;
  LAuthFailed: Boolean;
  LAccepted: Boolean;
  LS : TIdSMTPServerContext;
begin
  LS := ASender.Context as TIdSMTPServerContext;
  Result := False;
  LAuthFailed := False;
  TIdSMTPServerContext(ASender.Context).PipeLining := False;
  if UpperCase(Login) = 'LOGIN' then    {Do not Localize}
  begin // LOGIN USING THE LOGIN AUTH - BASE64 ENCODED
    s := 'Username:';    {Do not Localize}
    s := TIdEncoderMIME.EncodeString(s);
    //  s := SendRequest( '334 ' + s );    {Do not Localize}
    ASender.Reply.SetReply (334, s);    {Do not Localize}
    ASender.SendReply;
    s := Trim(ASender.Context.Connection.IOHandler.ReadLn);
    if s <> '' then    {Do not Localize}
    begin
      try
        s := TIdDecoderMIME.DecodeString(s);

        LUsername := s;
        // What? Endcode this string literal?
        s := 'Password:';    {Do not Localize}
        s := TIdEncoderMIME.EncodeString(s);
        //    s := SendRequest( '334 ' + s );    {Do not Localize}
        ASender.Reply.SetReply (334,s);    {Do not Localize}
        ASender.SendReply;
        s := Trim(ASender.Context.Connection.IOHandler.ReadLn);
        if Length(s) = 0 then
        begin
          LAuthFailed := True;
        end
        else
        begin
          LPassword := TIdDecoderMIME.DecodeString(s);
        end;
      // when TIdDecoderMime.DecodeString(s) raise a exception,catch it and set AuthFailed as true
      except
        LAuthFailed := true;
      end;
    end
    else
    begin
      LAuthFailed := True;
    end;
  end;

  // Add other login units here

  if LAuthFailed then
  begin
    Result := False;
    AuthFailed(ASender);
  end
  else
  begin
    LAccepted := False;
    if Assigned(fOnUserLogin) then
    begin
      fOnUserLogin(LS,  LUsername, LPassword, LAccepted);
    end
    else
    begin
      LAccepted := True;
    end;
    LS.LoggedIn := LAccepted;
    LS.Username := LUsername;
    if not LAccepted then
    begin
      AuthFailed(ASender);
    end
    else
    begin
      SetEnhReply(ASender.Reply,235,Id_EHR_SEC_OTHER_OK,' welcome ' + Trim(LUsername), (ASender.Context as TIdSMTPServerContext).EHLO);    {Do not Localize}
      ASender.SendReply;
    end;
  end;
end;

procedure TIdSMTPServer.SetEnhReply(AReply: TIdReply;
  const ANumericCode: Integer; const AEnhReply, AText: String; const IsEHLO: Boolean);
begin
  if (AReply is TIdReplySMTP) then
   if IsEHLO then begin
     (AReply as TIdReplySMTP).SetEnhReply(ANumericCode, AEnhReply, AText);
   end else begin
     AReply.SetReply(ANumericCode, AText);
   end;
end;

procedure TIdSMTPServer.AuthFailed(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,535,Id_EHR_SEC_OTHER_PERM,RSSMTPSvrAuthFailed, (ASender.Context as TIdSMTPServerContext).EHLO);
  ASender.SendReply;
end;

procedure TIdSMTPServer.AddrInvalid(ASender: TIdCommand; const AAddress : String = '');
begin
  SetEnhReply(ASender.Reply,500,Id_EHR_MSG_BAD_DEST, Format(RSSMTPSvrAddressError, [AAddress]), (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.AddrNotWillForward(ASender: TIdCommand; const AAddress : String = ''; const ATo : String = '');
begin
  SetEnhReply(ASender.Reply,521,Id_EHR_SEC_DEL_NOT_AUTH,Format(RSSMTPUserNotLocal, [AAddress]), (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.AddrValid(ASender: TIdCommand; const AAddress : String = '');
begin
  SetEnhReply(ASender.Reply,250, Id_EHR_MSG_VALID_DEST,Format(RSSMTPSvrAddressOk, [AAddress]), (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.AddrNoRelaying(ASender: TIdCommand;
  const AAddress: String);
begin
  SetEnhReply(ASender.Reply,550, Id_EHR_SEC_DEL_NOT_AUTH,Format( RSSMTPSvrNoRelay, [AAddress]), (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.AddrWillForward(ASender: TIdCommand; const AAddress : String = '');
begin
// Note, changed format from RSSMTPUserNotLocal as it now has two %s.
  SetEnhReply(ASender.Reply,251, Id_EHR_MSG_VALID_DEST,Format(RSSMTPUserNotLocalNoAddr, [AAddress]), (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.AddrTooManyRecipients(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,250,Id_EHR_PR_TOO_MANY_RECIPIENTS_PERM, RSSMTPTooManyRecipients, (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.AddrDisabledPerm(ASender: TIdCommand;
  const AAddress: String);
begin
  SetEnhReply(ASender.Reply,550,Id_EHR_MB_DISABLED_PERM,Format(RSSMTPAccountDisabled,[AAddress]), (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.AddrDisabledTemp(ASender: TIdCommand;
  const AAddress: String);
begin
  SetEnhReply(ASender.Reply,550,Id_EHR_MB_DISABLED_TEMP,Format(RSSMTPAccountDisabled,[AAddress]), (ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.MailSubmitLimitExceeded(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,552,Id_EHR_MB_MSG_LEN_LIMIT,RSSMTPMsgLenLimit, (ASender.Context as TIdSMTPServerContext).EHLO);
  ASender.SendReply;
end;

procedure TIdSMTPServer.MailSubmitLocalProcessingError(
  ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,451,Id_EHR_MD_OTHER_TRANS,RSSMTPLocalProcessingError, (ASender.Context as TIdSMTPServerContext).EHLO);
  ASender.SendReply;
end;

procedure TIdSMTPServer.MailSubmitOk(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,250,'',RSSMTPSvrOk,(ASender.Context as TIdSMTPServerContext).EHLO);
  ASender.SendReply;
end;

procedure TIdSMTPServer.MailSubmitStorageExceededFull(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,552,Id_EHR_MB_FULL,RSSMTPSvrExceededStorageAlloc,(ASender.Context as TIdSMTPServerContext).EHLO);
  ASender.SendReply;
end;

procedure TIdSMTPServer.MailSubmitSystemFull(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,452,Id_EHR_MD_MAIL_SYSTEM_FULL,RSSMTPSvrInsufficientSysStorage,(ASender.Context as TIdSMTPServerContext).EHLO);
  ASender.SendReply;
end;

procedure TIdSMTPServer.MailSubmitTransactionFailed(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,554,Id_EHR_MB_OTHER_STATUS_TRANS,RSSMTPSvrTransactionFailed,(ASender.Context as TIdSMTPServerContext).EHLO);
  ASender.SendReply;
end;

procedure TIdSMTPServer.MailFromAccept(ASender: TIdCommand; const AAddress : String = '');
begin
  SetEnhReply(ASender.Reply,250,Id_EHR_MSG_OTH_OK, Format(RSSMTPSvrAddressOk,[AAddress]),(ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.MailFromReject(ASender: TIdCommand; const AAddress : String = '');
begin
  SetEnhReply(ASender.Reply,250,Id_EHR_SEC_DEL_NOT_AUTH, Format(RSSMTPSvrNotPermitted,[AAddress]),(ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.NoHello(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,501,Id_EHR_PR_OTHER_PERM, RSSMTPSvrNoHello,(ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.CommandMAIL(ASender: TIdCommand);
var
  EMailAddress: TIdEMailAddressItem;
  LS : TIdSMTPServerContext;
  LM : TIdMailFromReply;
begin
  //Note that unlike other protocols, it might not be possible
  //to completely disable MAIL FROM for people not using SSL
  //because SMTP is also used from server to server mail transfers.
  LS := ASender.Context as TIdSMTPServerContext;
  if LS.HELO Or LS.EHLO then // Looking for either HELO or EHLO
  begin

    //reset all information
    LS.From := '';    {Do not Localize}
    LS.RCPTList.Clear;

    if Uppercase(Copy(ASender.UnparsedParams, 1, 5)) = 'FROM:' then    {Do not Localize}
    begin
      EMailAddress := TIdEMailAddressItem.Create(nil);
      Try
        EMailAddress.Text := Trim(Copy(ASender.UnparsedParams, 6,Length(ASender.UnparsedParams)));
        LM := mAccept;
        if Assigned(FOnMailFrom) then
        begin
          FOnMailFrom(LS,EMailAddress.Address,LM);
        end;
        case LM of
          mAccept :
          begin
            MailFromAccept(ASender,EMailAddress.Address);
            LS.From := EMailAddress.Address;
            LS.SMTPState := idSMTPMail;
          end;
          mReject :
          begin
            MailFromReject(ASender,EMailAddress.Text);
          end;
        end;
      Finally
       FreeAndNil(EMailAddress);
      End;
    end
    else
    begin
      InvalidSyntax(ASender);
    end;
  end
  else // No EHLO / HELO was received
  begin
    NoHello(ASender);
  end;
  TIdSMTPServerContext(ASender.Context).CheckPipeLine;
end;

procedure TIdSMTPServer.InvalidSyntax(ASender: TIdCommand);
begin
  SetEnhReply(ASender.Reply,501,Id_EHR_PR_INVALID_CMD_ARGS,RSPOP3SvrInvalidSyntax,(ASender.Context as TIdSMTPServerContext).EHLO);
end;

procedure TIdSMTPServer.CommandRCPT(ASender: TIdCommand);
var
  EMailAddress: TIdEMailAddressItem;
  LS : TIdSMTPServerContext;
  LAction : TIdRCPToReply;
  LForward : String;
begin
  LForward := '';
  LS := ASender.Context as TIdSMTPServerContext;
  if (LS.SMTPState <> idSMTPMail) AND (LS.SMTPState <> idSMTPRcpt) then
  begin
    BadSequenceError(ASender);
    Exit;
  end;

  if LS.HELO or LS.EHLO then
  begin
    if (Uppercase(Copy(ASender.UnparsedParams, 1, 3)) = 'TO:') then    {Do not Localize}
    begin
      LAction :=  rRelayDenied;
      //do not change this in the OnRcptTo event unless one of the following
      //things is TRUE:
      //
      //1.  The user authenticated to the SMTP server
      //
      //2.  The user has is from an IP address being served by the SMTP server.
      //    Test the IP address for this.
      //
      //3.  Another SMTP server outside of your network is sending E-Mail to a
      //    user on YOUR system.
      //
      //The reason is that you do not want to relay E-Messages for outsiders
      //if the E-Mail is from outside of your network.  Be very CAREFUL.  Otherwise,
      //you have a security hazard that spammers can abuse.
      EMailAddress := TIdEMailAddressItem.Create(nil);
      try
        EMailAddress.Text := Trim(Copy(ASender.UnparsedParams, 4,
          Length(ASender.UnparsedParams)));
        if Assigned(FOnRcptTo) then
        begin
          FOnRcptTo(LS,EMailAddress.Address,LAction,LForward);
          case LAction of
            rAddressOk :
            begin
              AddrValid(ASender, EMailAddress.Address);
              LS.RCPTList.Add.Text := EMailAddress.Text;
              LS.SMTPState := idSMTPRcpt;
            end;
            rRelayDenied :
            begin
              AddrNoRelaying( ASender, EMailAddress.Address );
            end;
            rWillForward :
            begin
              AddrWillForward( ASender, EMailAddress.Address );
              LS.RCPTList.Add.Text := EMailAddress.Text;
              LS.SMTPState := idSMTPRcpt;
            end;
            rNoForward : AddrNotWillForward(ASender, EMailAddress.Address, LForward);
            rTooManyAddresses : AddrTooManyRecipients(ASender);
            rDisabledPerm : AddrDisabledPerm(ASender, EMailAddress.Address);
            rDisabledTemp : AddrDisabledTemp(ASender, EMailAddress.Address);
          else
            AddrInvalid(ASender, EMailAddress.Address);
          end;
        end
        else
        begin
          raise EIdSMTPServerNoRcptTo.Create(RSSMTPNoOnRcptTo);
        end;
      finally
       FreeAndNil(EMailAddress);
      end;
    end
    else
    begin
      SetEnhReply(ASender.Reply,501,Id_EHR_PR_SYNTAX_ERR,RSSMTPSvrParmErrRcptTo,(ASender.Context as TIdSMTPServerContext).EHLO);
    end;
  end
  else // No EHLO / HELO was received
  begin
    NoHello(ASender);
  end;
  TIdSMTPServerContext(ASender.Context).CheckPipeLine;
end;

procedure TIdSMTPServer.CommandSTARTTLS(ASender: TIdCommand);
var LIO : TIdSSLIOHandlerSocketBase;
  LS : TIdSMTPServerContext;
begin
  LS := ASender.Context as TIdSMTPServerContext;
  if FUseTLS in ExplicitTLSVals then begin
    if TIdSMTPServerContext(ASender.Context).UsingTLS then begin // we are already using TLS
      Self.BadSequenceError(ASender);
      Exit;
    end;
    SetEnhReply(ASender.Reply,220,Id_EHR_GENERIC_OK,RSSMTPSvrReadyForTLS, (ASender.Context as TIdSMTPServerContext).EHLO);

    LS.PipeLining := False;
    LIO := ASender.Context.Connection.IOHandler as TIdSSLIOHandlerSocketBase;
    LIO.Passthrough := False;
    LS.SMTPState:=idSMTPNone; // to reset the state
    LS.HELO:=false;           //
    LS.EHLO:=false;           //
    LS.Username := '';        //
    LS.Password := '';         //
    LS.LoggedIn:=false;       //
  end else begin
    CmdSyntaxError(ASender);
    TIdSMTPServerContext(ASender.Context).PipeLining := False;
  end;
end;

procedure TIdSMTPServer.CommandNOOP(ASender: TIdCommand);
begin
//we just use the default NOOP and only clear pipelining for synchronization
  TIdSMTPServerContext(ASender.Context).PipeLining := False;
end;

procedure TIdSMTPServer.CommandQUIT(ASender: TIdCommand);
begin
//clear pipelining before exit
  TIdSMTPServerContext(ASender.Context).PipeLining := False;
  ASender.SendReply;
end;

procedure TIdSMTPServer.CommandRSET(ASender: TIdCommand);
var LS : TIdSMTPServerContext;
begin
  LS := ASender.Context as TIdSMTPServerContext;
  LS.RCPTList.Clear;
  LS.From := '';    {Do not Localize}

  if LS.Ehlo or LS.Helo then
  begin
      LS.SMTPState := idSMTPHelo;
  end
  else
  begin
      LS.SMTPState := idSMTPNone;
  end;

  LS.CheckPipeLine;
end;

procedure TIdSMTPServer.CommandDATA(ASender: TIdCommand);
var
  LS : TIdSMTPServerContext;
  LStream: TStream;
  AMsg : TStream;
  LAction : TIdDataReply;
  ReceivedString : String;
begin
  ReceivedString := IdSMTPSvrReceivedString;
  LS := ASender.Context as TIdSMTPServerContext;
  if (LS.SMTPState <> idSMTPRcpt) then
  begin
    BadSequenceError(ASender);
    Exit;
  end;
  if LS.HELO or LS.EHLO then
  begin
    SetEnhReply(ASender.Reply,354, '',RSSMTPSvrStartData,(ASender.Context as TIdSMTPServerContext).EHLO);
    ASender.SendReply;
    LS.PipeLining := False;
    LStream := TMemoryStream.Create;
    AMsg    := TMemoryStream.Create;
    try
      LAction := dOk;
      ASender.Context.Connection.IOHandler.Capture(LStream, '.', True);    {Do not Localize}
      LStream.Position := 0;
      if Assigned(OnReceived) then
      begin
        FOnReceived(LS, ReceivedString);
      end;
      if LS.FinalStage then
       Begin
        // If at the final delivery stage, add the Return-Path line for the received MAIL FROM line.
        WriteStringToStream(AMsg, 'Received-Path: <' + LS.From + '>' + EOL); {do not localize}
       End;

      if ReceivedString <> '' then
       Begin
        // Parse the ReceivedString and replace any of the special 'tokens'
        ReceivedString := StringReplace(ReceivedString, '$hostname', GStack.HostByAddress(ASender.Context.Binding.PeerIP), [rfReplaceall]); {do not localize}
        ReceivedString := StringReplace(ReceivedString, '$ipaddress', ASender.Context.Binding.PeerIP, [rfReplaceall]); {do not localize}
        ReceivedString := StringReplace(ReceivedString, '$helo', LS.HeloString, [rfReplaceall]);
        if LS.EHLO then
         ReceivedString := StringReplace(ReceivedString, '$protocol', 'esmtp', [rfReplaceall]) {do not localize}
        else
         ReceivedString := StringReplace(ReceivedString, '$protocol', 'smtp', [rfReplaceall]); {do not localize}
        ReceivedString := StringReplace(ReceivedString, '$servername', FServerName, [rfReplaceall]);
        ReceivedString := StringReplace(ReceivedString, '$svrhostname', GStack.HostByAddress(ASender.Context.Binding.IP), [rfReplaceAll]);
        ReceivedString := StringReplace(ReceivedString, '$svripaddress', ASender.Context.Binding.IP, [rfReplaceAll]);

        WriteStringToStream(AMsg, ReceivedString + EOL);
       End;
      AMsg.CopyFrom(LStream, 0); // Copy the contents that was captured to the new stream.
      if Assigned(OnMsgReceive) then
      begin
        FOnMsgReceive(LS,AMsg,LAction);
      end;
    finally
      FreeAndNil(LStream);
      FreeAndNil(AMsg);
    end;
    case LAction of
    dOk                   : MailSubmitOk(ASender); //accept the mail message
    dMBFull               : MailSubmitStorageExceededFull(ASender); //Mail box full
    dSystemFull           : MailSubmitSystemFull(ASender); //no more space on server
    dLocalProcessingError : MailSubmitLocalProcessingError(ASender); //local processing error
    dTransactionFailed    : MailSubmitTransactionFailed(ASender); //transaction failed
    dLimitExceeded        : MailSubmitLimitExceeded(ASender); //exceeded administrative limit
    end;
  end
  else // No EHLO / HELO was received
  begin
    Self.NoHello(ASender);
  end;
  TIdSMTPServerContext(ASender.Context).PipeLining := False;
end;

{ TIdSMTPServerContext }

procedure TIdSMTPServerContext.CheckPipeLine;
begin
  if Connection.IOHandler.InputBufferIsEmpty=False then
  begin
    PipeLining := True;
  end;
end;

constructor TIdSMTPServerContext.Create(AConnection: TIdTCPConnection;
  AYarn: TIdYarn; AList: TThreadList);
begin
  inherited;
  SMTPState := idSMTPNone;
  From:='';
  HELO:=false;
  EHLO:=false;
  Username:='';
  Password:='';
  LoggedIn:=false;
  FreeAndNil(FRCPTList);
  FRCPTList := TIdEMailAddressList.Create(nil);
end;

destructor TIdSMTPServerContext.Destroy;
begin
  FreeAndNil(FRCPTList);
  inherited;
end;

function TIdSMTPServerContext.GetUsingTLS: boolean;
begin
  Result:=Connection.IOHandler is TIdSSLIOHandlerSocketBase;
  if result then
  begin
    Result:=not TIdSSLIOHandlerSocketBase(Connection.IOHandler).PassThrough;
  end;
end;

procedure TIdSMTPServerContext.SetPipeLining(const AValue: Boolean);
begin
  if AValue and (PipeLining = False) then
  begin
    Connection.IOHandler.WriteBufferOpen;
  end
  else
  begin
    if (AValue=False) and PipeLining then
    begin
      Connection.IOHandler.WriteBufferClose;
    end;
  end;
  FPipeLining := AValue;
end;

end.
