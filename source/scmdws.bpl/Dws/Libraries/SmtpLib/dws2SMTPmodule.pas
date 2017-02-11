{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 1, 2001                                                   }
{                                                                      }
{    http://www.dwscript.com                                           }
{                                                                      }
{    The Initial Developers of the Original Code are Matthias          }
{    Ackermann and hannes hernler.                                     }
{    Portions created by Matthias Ackermann are Copyright (C) 2001     }
{    Matthias Ackermann, Switzerland. All Rights Reserved.             }
{    Portions created by hannes hernler are Copyright (C) 2001         }
{    hannes hernler, Austria. All Rights Reserved.                     }
{                                                                      }
{    Contributor(s): Willibald Krenn, Eric Grange.                     }
{                                                                      }
{**********************************************************************}
unit dws2SMTPmodule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, dws2Exprs, Psock, NMsmtp;

const
  ERRMAILSEND = 'SendMail ERROR';

type
 { TdwsSMTPObj = class (TObject)
    SmtpEMail: TNMSMTP;
    constructor Create;
    destructor Destroy; override;
  end;      }

  Tdws2SMTPlib = class(TDataModule)
    customSMTPunit: Tdws2Unit;
    NMSMTP1: TNMSMTP;
    constructor Create(AOwner : TComponent); override;
    procedure customSMTPunitClassesSMTPMsgMethodsGetBodyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsSetBodyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsAddLineEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsClearEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsGetSubjectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsSetSubjectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsAddAddressEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsGetAddressEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsSetAddressEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsAddCCEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsGetCCEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsSetCCEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsAddBCCEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsGetBCCEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsSetBCCEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsSendMailEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesSMTPMsgMethodsQuickMailEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSMTPunitClassesTSMTPMailConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
  private
    { Private-Deklarationen }
    FScript: TDelphiWebScriptII;
    FDefaultHost : string;
    FDefaultPort : Integer;
    FTimeOut : integer;
 //   FEncodeType: UUMethods;
    FCharSet : string ;
    FXMailer : string ;
    procedure SetScript(const Value: TDelphiWebScriptII);
  public
    { Public-Deklarationen }
    function SendSMTPmail(sFrom, sTo, sSubject, sBody:string):string;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
    property DefaultHost : string read FDefaultHost write FDefaultHost;
    property DefaultPort : integer read FDefaultPort write FDefaultPort;
    property DefaultTimeOut : integer read FTimeOut write FTimeOut;
 //   property EncodeType: UUMethods read FEncodeType write FEncodeType;
    property DefaultCharSet : string read FCharSet write FCharSet;
    property XMailer : string read FXMailer write FXMailer;
  end;

procedure Register;


implementation
{$R *.DFM}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2SMTPlib]);
end;

// ****************************************************************************
// ********************* internal library classes  *****************************
// ****************************************************************************

{constructor TdwsSMTPObj.Create;
begin
  SmtpEMail := TNMSMTP.Create(Application);
end;
destructor TdwsSMTPObj.Destroy;
begin
  SmtpEMail.Free;
  inherited;
end;        }

constructor Tdws2SMTPlib.Create(AOwner : TComponent);
begin
  inherited;
  DefaultPort := 25;;
  DefaultCharset :=  'ISO-8859-1';
  DefaultTimeOut := 20;
  XMailer := 'DWS II server side - www.dwscript.com';
end;

procedure Tdws2SMTPlib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
  inherited;
end;

procedure Tdws2SMTPlib.SetScript(const Value: TDelphiWebScriptII);
var
  x: Integer;
begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  FScript := Value;
  if Assigned(FScript) then
    FScript.FreeNotification(Self);
  if not (csDesigning in ComponentState)  then
  for x := 0 to ComponentCount - 1 do
    if Components[x] is Tdws2Unit then
      Tdws2Unit(Components[x]).Script := Value;
//  customWebUnit.Script := FScript;
end;

function Tdws2SMTPlib.SendSMTPmail(sFrom, sTo, sSubject, sBody : string):string;
var
  SmtpEMail: TNMSMTP;
begin
  SmtpEMail := TNMSMTP.Create(Application);
  with SmtpEMail, SmtpEMail.PostMessage do
  try
    EncodeType := uuMime;  // EncodeType
    SubType := mtPlain;
    Host := DefaultHost;
    Port := DefaultPort;
    Charset :=  DefaultCharset;
    TimeOut := DefaultTimeOut * 1000;
    ClearParams := true;
    FromAddress := sFrom;
    ToAddress.Text := stringreplace( sTo,';',#13#10,[rfReplaceAll]);
    Subject := sSubject;
    Body.Text := sBody;
    LocalProgram := XMailer;
    try
      Connect;
      SendMail;
      Disconnect;
      result := 'OK';
    except
      result := ERRMAILSEND;
    end;
  finally
    SmtpEMail.free;
  end;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesTSMTPMailConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  SmtpEMail: TNMSMTP;
  sH : string;
  p : Integer;
begin
  try
    SmtpEMail := TNMSMTP.Create(Application);
    with SmtpEMail do
    begin
      EncodeType := uuMime;  // EncodeType
      SubType := mtPlain;
      Charset :=  DefaultCharset;
      TimeOut := DefaultTimeOut * 1000;
      ClearParams := true;
      PostMessage.LocalProgram := XMailer;

      sH  := Info['Host'];
      p := pos(':',sH);
      if p>0 then
      begin
        Port := StrToIntDef(copy(sH,p+1,4),DefaultPort);
        sH := copy(sH,1,p-1);
      end
      else
        Port := DefaultPort;
      if length(sH)>0 then
        Host := sH
      else
        Host := DefaultHost;
      PostMessage.FromAddress := Info['From'];
      PostMessage.ToAddress.Text := stringreplace( Info['To'],';',#13#10,[rfReplaceAll]);
    end;
  except
    on e: Exception do raise Exception.CreateFmt(E.Message, [] );
  end;
  ExtObject := SmtpEMail;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsGetBodyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TNMSMTP(ExtObject).PostMessage.Body.Text;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsSetBodyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.Body.Text := Info['Value'];
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsAddLineEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.Body.Add(Info['Line']);
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsClearEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TNMSMTP(ExtObject).PostMessage do
  begin
    Attachments.Clear;
    Body.Clear;
    Subject := '';
    ToAddress.Clear;
    ToBlindCarbonCopy.Clear;
    ToCarbonCopy.Clear;
  end;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsGetSubjectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TNMSMTP(ExtObject).PostMessage.Subject;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsSetSubjectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.Subject := Info['Value'];
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsAddAddressEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.ToAddress.Add(Info['Value']);
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsGetAddressEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TNMSMTP(ExtObject).PostMessage.ToAddress.Text;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsSetAddressEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.ToAddress.Text :=
              stringreplace( Info['Value'],';',#13#10,[rfReplaceAll]);
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsAddCCEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.ToCarbonCopy.Add(Info['Value']);
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsGetCCEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TNMSMTP(ExtObject).PostMessage.ToCarbonCopy.Text;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsSetCCEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.ToCarbonCopy.Text :=
              stringreplace( Info['Value'],';',#13#10,[rfReplaceAll]);
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsAddBCCEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.ToBlindCarbonCopy.Add(Info['Value']);
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsGetBCCEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TNMSMTP(ExtObject).PostMessage.ToBlindCarbonCopy.Text;
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsSetBCCEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TNMSMTP(ExtObject).PostMessage.ToBlindCarbonCopy.Text :=
              stringreplace( Info['Value'],';',#13#10,[rfReplaceAll]);
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsSendMailEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TNMSMTP(ExtObject) do
  begin
    Connect;
    SendMail;
    Disconnect;
  end;
  Info['Result'] := 'OK';
end;

procedure Tdws2SMTPlib.customSMTPunitClassesSMTPMsgMethodsQuickMailEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := SendSMTPmail(Info['From'],Info['To'],Info['Subject'],Info['Body']);
end;

end.
