unit dwsSMTPLib;

interface

uses
  Forms, SysUtils, Classes, dwsComp, WIndows, VMSockets, VMSmtp;

const
  ERRMAILSEND = 'SendMail ERROR';

type
  TdwsSMTPLib = class(TdwsLib)
  protected
    procedure AddFunctions; override;
  public
//    SmtpEMail: TVMSmtpEMail;
    constructor Create(AOwner: TComponent); override; { diese Syntax ist immer gleich }
        //Create : Remote Host, Remote Port,  From, To, Subject, text
    function SendSMTPmail(sRemoteHost, sRemotePort, sFrom, sTo, sSubject, sBody:string):string;
  end;
  //Create : Remote Host, Remote Port,  From, To, Subject
  TSMTPCreate     = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  //Carbon Copy
  TSMTPCC         = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  //Blind Copy
  TSMTPBC         = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  //Body lines
  TSMTPBodyClear  = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  TSMTPBodyAdd    = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  TSMTPBodyText   = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  //Files Lines
  TSMTPFilesClear = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  TSMTPFilesAdd   = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  //Send : TimeOut-Sec
  TSMTPSend       = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  //Error Descrition : String
  TSMTPErrorDesc  = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;
  TSMTPClose      = class (TFunction) function Evaluate (argpat : Integer; args : TArgList) : Variant; override; end;

procedure Register;

implementation

uses dwsErrors;

type
  TSMTPObj = class (TdwsObject)
    SmtpEMail: TVMSmtpEMail;
    constructor Create;
    destructor Destroy; override;
  end;

procedure Register;
begin
  RegisterComponents ('DWS', [TdwsSMTPLib]);
end;

{ TSMTPObj }

destructor TSMTPObj.Destroy;
begin
  SmtpEMail.Free;
  inherited;
end;

constructor TSMTPObj.Create;
begin
  FAutoDestroy := true;
end;

function GetObj (script : TDelphiWebScript; expr : TExpr) : TSMTPObj;
begin
  result := TSMTPObj (script.GetObj (TExpr (expr).Eval));
end;

constructor TdwsSMTPLib.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);      { diesen Schritt IMMER zuerst! }
//    SmtpEMail := TVMSmtpEMail.Create(Application);
//    SmtpEMail.EEncMethod := MIMEEncode;
//    SmtpEMail.EFormat := mPlainText;
end;

{ TdwsStringsLib }
procedure TdwsSMTPLib.AddFunctions;
begin
  //Criar : Remote Host, Remote Porte,  From, To, Subject
  AddF (TSMTPCreate.CreateArg ('SMTPCreate', atInteger, [atString, atString, atString, atString, atString]));
  //Carbon Copy
  AddF (TSMTPCC.CreateArg ('SMTPCC', atVoid, [atInteger, atString]));
  //Blind Copy
  AddF (TSMTPBC.CreateArg ('SMTPBC', atVoid, [atInteger, atString]));
  //Body lines
  AddF (TSMTPBodyClear.CreateArg ('SMTPBodyClear', atVoid, [atInteger]));
  AddF (TSMTPBodyAdd.CreateArg ('SMTPBodyAdd', atVoid, [atInteger, atString]));
  AddF (TSMTPBodyText.CreateArg ('SMTPBodyText', atVoid, [atInteger, atString]));
  //Files Lines
  AddF (TSMTPFilesClear.CreateArg ('SMTPFilesClear', atVoid, [atInteger]));
  AddF (TSMTPFilesAdd.CreateArg ('SMTPFilesAdd', atVoid, [atInteger, atString]));
  //Send : TimeOut-Sec
  AddF (TSMTPSend.CreateArg ('SMTPSend', atBoolean, [atInteger, atInteger]));
  //Error Descrition : String
  AddF (TSMTPErrorDesc.CreateArg ('SMTPErrorDesc', atString, [atInteger]));
  //Close
  AddF (TSMTPClose.CreateArg ('SMTPClose', atVoid, [atInteger]));
end;

function TdwsSMTPLib.SendSMTPmail(sRemoteHost, sRemotePort, sFrom, sTo, sSubject, sBody:string):string;
var
  SmtpEMail: TVMSmtpEMail;
begin
  SmtpEMail := TVMSmtpEMail.Create(Application);
  with SmtpEMail do
  try
    EEncMethod := MIMEEncode;
    EFormat := mPlainText;
    RemoteHost := sRemoteHost;
    RemotePort := sRemotePort;
    EFrom := sFrom;
    ETo := sTo;
    ESub := sSubject;
    EBody.Text := sBody;
    try
      SendEMail(25);
      result := 'OK';
    except
      result := ERRMAILSEND;
    end;
  finally
    SmtpEMail.free;
  end;
end;

//Create : Remote Host, From, To, Subject
function TSMTPCreate.Evaluate(argpat: Integer; args: TArgList): Variant;
var
  SMail : TSMTPObj;
begin
  try
    SMail := TSMTPObj.Create;
    SMail.SmtpEMail := TVMSmtpEMail.Create(Application);
    with SMail.SmtpEMail do
    begin
      RemoteHost  := TExpr(args[0]).Eval;
      if TExpr(args[1]).Eval > 0 then
        RemotePort  := TExpr(args[1]).Eval
      else
        RemotePort := '25';
      EFrom    := TExpr(args[2]).Eval;
      ETo      := TExpr(args[3]).Eval;
      ESub     := TExpr(args[4]).Eval;
      EEncMethod := MIMEEncode;
      EFormat := mPlainText;
    end;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, [] );
  end;
  result := fScript.NewObj (SMail);
end;

//Carbon Copy
function TSMTPCC.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    GetObj (fScript, args[0]).SmtpEMail.ECC := TExpr(args[1]).Eval;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

//Blind Copy
function TSMTPBC.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    GetObj (fScript, args[0]).SmtpEMail.EBCC := TExpr(args[1]).Eval;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

//Body lines Clear
function TSMTPBodyClear.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    GetObj (fScript, args[0]).SmtpEMail.EBody.Clear;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

//BodyAdd
function TSMTPBodyAdd.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    GetObj (fScript, args[0]).SmtpEMail.EBody.Add(TExpr(args[1]).Eval);
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

//BodyText
function TSMTPBodyText.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    GetObj (fScript, args[0]).SmtpEMail.EBody.Text := TExpr(args[1]).Eval;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);    
  end;
end;

//FilesClear
function TSMTPFilesClear.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    GetObj (fScript, args[0]).SmtpEMail.EAttachs.Clear;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

//FilesAdd
function TSMTPFilesAdd.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    GetObj (fScript, args[0]).SmtpEMail.EAttachs.Add(TExpr(args[1]).Eval);
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

//Send : TimeOut
function TSMTPSend.Evaluate(argpat: Integer; args: TArgList): Variant;
var
  iTimeOut : integer;
begin
  if TExpr(args[1]).Eval < 1 then
    iTimeOut := 108
  else
    iTimeOut := TExpr(args[1]).Eval;
  try
    Result := GetObj (fScript, args[0]).SmtpEMail.SendEMail(iTimeOut);
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);  
  end;
end;

//Error Descrition : String
function TSMTPErrorDesc.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    Result := GetObj (fScript, args[0]).SmtpEMail.ErrorDescr;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

//Close, Free Object
function TSMTPClose.Evaluate(argpat: Integer; args: TArgList): Variant;
begin
  try
    fScript.FreeObj (TExpr (args[0]).Eval);
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, []);
  end;
end;

end.

