unit BisHttpServerHandlerKrasplatWm;

interface

uses
  SysUtils, Classes, HTTPApp, DB, Contnrs,
  BisLogger, BisHttpServerHandlers;

type
  TBisHttpServerHandlerKrasplatWebModule = class(TWebModule)
    procedure BisHttpServerHandlerKrasplatWebModuleDefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerKrasplatWebModuleCheckAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerKrasplatWebModulePaymentAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerKrasplatWebModuleCommitAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    FHandler: TBisHttpServerHandler;
    FClientKey: String;
    FServerKey: String;

    procedure LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);
    function AccountExists(UserName: String; var AccountId: Variant; var FIO: String): Boolean;
    function GetMD5(S: String): String;

    function Check(Request: TWebRequest; Response: TWebResponse): Boolean;
    function Payment(Request: TWebRequest; Response: TWebResponse): Boolean;
    function Commit(Request: TWebRequest; Response: TWebResponse): Boolean;

  public
    property Handler: TBisHttpServerHandler read FHandler write FHandler;
    property ClientKey: String read FClientKey write FClientKey;
    property ServerKey: String read FServerKey write FServerKey;
  end;

var
  BisHttpServerHandlerKrasplatWebModule: TBisHttpServerHandlerKrasplatWebModule;

implementation

{$R *.dfm}

uses Windows, Variants, StrUtils, DateUtils,
     AlXmlDoc,
     BisConsts, BisUtils, BisProvider, BisCore, BisConnections, BisDataSet,
     BisValues, BisFilterGroups, BisCrypter, BisCoreUtils,
     BisHttpServerHandlerKrasplatConsts;

type     
  TBisResponseStatus=(rsSuccess,rsInvalidTimeP,rsInvalidIdP,rsInvalidAcc,rsInvalidSum,rsInvalidMD5,rsInvalidTransaction,rs07,rs08,rs09,
                      rs10,rs11,rs12,rs13,rs14,rs15,rs16,rs17,rs18,rs19,rs20,rs21,rs22,rs23,rs24,rs25,rs26,rs27,rs28,rs29,
                      rs30,rs31,rs32,rs33,rs34,rs35,rs36,rs37,rs38,rs39,rs40,rs41,rs42,rs43,rs44,rs45,rs46,rs47,rs48,rs49,
                      rs50,rs51,rs52,rs53,rs54,rs55,rs56,rs57,rs58,rs59,rs60,rs61,rs62,rs63,rs64,rs65,rs66,rs67,rs68,rs69,
                      rs70,rs71,rs72,rs73,rs74,rs75,rs76,rs77,rs78,rs79,rs80,rs81,rs82,rs83,rs84,rs85,rs86,rs87,rs88,rs89,
                      rs90,rs91,rs92,rs93,rs94,rs95,rs96,rs97,rs98,rsInternalError);


{ TBisHttpServerHandlerMessageWebModule }

procedure TBisHttpServerHandlerKrasplatWebModule.LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);
begin
  BisCoreUtils.ClassLoggerWrite(ClassName,Message,LogType);
end;

function TBisHttpServerHandlerKrasplatWebModule.GetMD5(S: String): String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.HashString(S,haMD5,hfHEX);
  finally
    Crypter.Free;
  end;
end;

function TBisHttpServerHandlerKrasplatWebModule.AccountExists(UserName: String; var AccountId: Variant; var FIO: String): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  P:=TBisProvider.Create(nil);
  try
    P.UseShowError:=false;
    P.UseWaitCursor:=false;
    P.ProviderName:='S_ACCOUNTS';
    with P.FieldNames do begin
      AddInvisible('ACCOUNT_ID');
      AddInvisible('SURNAME');
      AddInvisible('NAME');
      AddInvisible('PATRONYMIC');
    end;
    with P.FilterGroups.Add do begin
      Filters.Add('LOCKED',fcEqual,0);
      Filters.Add('USER_NAME',fcEqual,UserName);
    end;
    P.Open;
    if P.Active and not P.Empty then begin
      AccountId:=P.FieldByName('ACCOUNT_ID').Value;
      FIO:=FormatEx('%s %s %s',[Trim(P.FieldByName('SURNAME').AsString),
                                Trim(P.FieldByName('NAME').AsString),
                                Trim(P.FieldByName('PATRONYMIC').AsString)]);
      FIO:=Trim(FIO);
      Result:=true;
    end;
  finally
    P.Free;
  end;
end;

function TBisHttpServerHandlerKrasplatWebModule.Check(Request: TWebRequest; Response: TWebResponse): Boolean;

  function ReadParams(var DateReceipt: TDateTime; var UserName: String): TBisResponseStatus;
  var
    TimeP: String;
    MD5: String;
    I: Int64;
    S: String;
  begin
    Result:=rsInternalError;
    TimeP:=Trim(Request.QueryFields.Values['time_p']);
    UserName:=Trim(Request.QueryFields.Values['acc']);
    MD5:=Trim(Request.QueryFields.Values['md5']);
    if (TimeP<>'') and (UserName<>'') and (MD5<>'') then begin
      if not TryStrToInt64(TimeP,I) then begin
        Result:=rsInvalidTimeP;
      end else begin
        DateReceipt:=UnixToDateTime(I);
        S:=GetMD5(TimeP+UserName+FClientKey);
        if not AnsiSameText(S,MD5) then
          Result:=rsInvalidMD5
        else Result:=rsSuccess;   
      end;
    end;
  end;

  function WriteParams(FIO: String; Status: TBisResponseStatus): String;
  var
    Xml: TALXMLDocument;
    ResponseNode: TALXMLNode;
    TimeVNode: TALXMLNode;
    FIONode: TALXMLNode;
    TimeV: String;
    StatusNode: TALXMLNode;
    MD5: String;
    MD5Node: TALXMLNode;
  begin
    try
      Xml:=TALXMLDocument.Create(nil);
      try
        Xml.LoadFromXML(FormatEx('<?xml version="1.0" encoding="%s" ?>',[SDefaultEncoding]));
        ResponseNode:=Xml.AddChild('response');
        TimeVNode:=ResponseNode.AddChild('time_v');
        TimeV:=IntToStr(DateTimeToUnix(Now));
        TimeVNode.NodeValue:=TimeV;
        FIONode:=ResponseNode.AddChild('fio');
        FIONode.NodeValue:=FIO;
        StatusNode:=ResponseNode.AddChild('status');
        StatusNode.NodeValue:=IntToStr(Integer(Status));
        MD5:=GetMD5(TimeV+FIO+FServerKey);
        MD5Node:=ResponseNode.AddChild('md5');
        MD5Node.NodeValue:=MD5;
        Result:=Trim(Xml.XML.Text);
      finally
        Xml.Free;
      end;
    except
      on E: Exception do begin
        LoggerWrite(E.Message,ltError);
      end;
    end;
  end;

var
  DateReceipt: TDateTime;
  UserName: String;
  AccountId: Variant;
  FIO: String;
  Status: TBisResponseStatus; 
begin
  Result:=Assigned(Core);
  if Result then begin
    Status:=rsSuccess;
    FIO:='';
    try
      DateReceipt:=Now;
      UserName:='';
      try
        Status:=ReadParams(DateReceipt,UserName);
        if Status=rsSuccess then begin
          AccountId:=Null;
          if not AccountExists(UserName,AccountId,FIO) then
            Status:=rsInvalidAcc;
        end;
      except
        On E: Exception do begin
          Status:=rsInternalError;
          LoggerWrite(E.Message,ltError);
        end;
      end;
    finally
      Response.Content:=WriteParams(FIO,Status);
      Response.ContentType:=SXMLType;
      Response.ContentEncoding:=SDefaultEncoding;
    end;
  end;
end;

function TBisHttpServerHandlerKrasplatWebModule.Payment(Request: TWebRequest; Response: TWebResponse): Boolean;

  function ReadParams(var DateReceipt: TDateTime; var UserName, Description: String; var SumReceipt: Extended): TBisResponseStatus;
  var
    TimeP: String;
    Sum: String;
    MD5: String;
    I: Int64;
    E: Extended;
    S: String;
  begin
    Result:=rsInternalError;
    TimeP:=Trim(Request.QueryFields.Values['time_p']);
    UserName:=Trim(Request.QueryFields.Values['acc']);
    Sum:=Trim(Request.QueryFields.Values['sum']);
    Description:=Trim(Request.QueryFields.Values['id_p']);
    MD5:=Trim(Request.QueryFields.Values['md5']);
    if (TimeP<>'') and (UserName<>'') and
       (Sum<>'') and (Description<>'') and (MD5<>'') then begin
      if not TryStrToInt64(TimeP,I) then begin
        Result:=rsInvalidTimeP;
      end else begin
        S:=Sum;
        S:=ReplaceText(S,',',DecimalSeparator);
        S:=ReplaceText(S,'.',DecimalSeparator);
        if not TryStrToFloat(S,E) then begin
          Result:=rsInvalidSum;
        end else begin
          DateReceipt:=UnixToDateTime(I);
          SumReceipt:=E;
          S:=GetMD5(TimeP+UserName+Sum+Description+FClientKey);
          if not AnsiSameText(S,MD5) then
            Result:=rsInvalidMD5
          else Result:=rsSuccess;
        end;
      end;
    end;
  end;

  function CreatePayment(AccountId: Variant; SumReceipt: Extended; DateReceipt: TDateTime;
                         Description: String; var ReceiptId: Variant): Boolean;
  var
    P: TBisProvider;
    NewReceiptID: Variant;
  begin
    Result:=false;
    P:=TBisProvider.Create(nil);
    try
      P.UseWaitCursor:=false;
      P.UseShowError:=false;
      P.ProviderName:='CREATE_PAYMENT';
      NewReceiptID:=GetUniqueID;
      with P.Params do begin
        AddInvisible('RECEIPT_ID').Value:=NewReceiptID;
        AddInvisible('ACCOUNT_ID').Value:=AccountId;
        AddInvisible('WHO_CREATE_ID').Value:=Core.AccountId;
        AddInvisible('SUM_RECEIPT').Value:=SumReceipt;
        AddInvisible('DATE_RECEIPT').Value:=DateReceipt;
        AddInvisible('DESCRIPTION').Value:=Description;
        AddInvisible('PAYMENT_EXISTS',ptOutput).Value:=0;
      end;
      P.Execute;
      if P.Success then begin
        Result:=not P.ParamByName('PAYMENT_EXISTS').AsBoolean;
        if Result then
          ReceiptId:=NewReceiptID;
      end;
    finally
      P.Free;
    end;
  end;

  function WriteParams(ReceiptId: Variant; Status: TBisResponseStatus): String;
  var
    Xml: TALXMLDocument;
    ResponseNode: TALXMLNode;
    TimeVNode: TALXMLNode;
    IdVNode: TALXMLNode;
    IdV: String;
    TimeV: String;
    StatusNode: TALXMLNode;
    MD5: String;
    MD5Node: TALXMLNode;
  begin
    try
      Xml:=TALXMLDocument.Create(nil);
      try
        Xml.LoadFromXML(FormatEx('<?xml version="1.0" encoding="%s" ?>',[SDefaultEncoding]));
        ResponseNode:=Xml.AddChild('response');
        TimeVNode:=ResponseNode.AddChild('time_v');
        TimeV:=IntToStr(DateTimeToUnix(Now));
        TimeVNode.NodeValue:=TimeV;
        IdVNode:=ResponseNode.AddChild('id_v');
        IdV:=VarToStrDef(ReceiptId,'');
        IdVNode.NodeValue:=IdV;
        StatusNode:=ResponseNode.AddChild('status');
        StatusNode.NodeValue:=IntToStr(Integer(Status));
        MD5:=GetMD5(TimeV+IdV+FServerKey);
        MD5Node:=ResponseNode.AddChild('md5');
        MD5Node.NodeValue:=MD5;
        Result:=Trim(Xml.XML.Text);
      finally
        Xml.Free;
      end;
    except
      on E: Exception do begin
        LoggerWrite(E.Message,ltError);
      end;
    end;
  end;

var
  DateReceipt: TDateTime;
  UserName: String;
  AccountId: Variant;
  FIO: String;
  Description: String;
  SumReceipt: Extended;
  ReceiptId: Variant;
  Status: TBisResponseStatus;
begin
  Result:=Assigned(Core);
  if Result then begin
    Status:=rsSuccess;
    ReceiptId:=Null;
    try
      try
        DateReceipt:=Now;
        UserName:='';
        Description:='';
        SumReceipt:=0.0;
        Status:=ReadParams(DateReceipt,UserName,Description,SumReceipt);
        if Status=rsSuccess then begin
          AccountId:=Null;
          FIO:='';
          if not AccountExists(UserName,AccountId,FIO) then
            Status:=rsInvalidAcc
          else begin
            if not CreatePayment(AccountId,SumReceipt,DateReceipt,Description,ReceiptId) then
              Status:=rsInternalError;
          end;
        end;
      except
        On E: Exception do begin
          Status:=rsInternalError;
          LoggerWrite(E.Message,ltError);
        end;
      end;
    finally
      Response.Content:=WriteParams(ReceiptId,Status);
      Response.ContentType:=SXMLType;
      Response.ContentEncoding:=SDefaultEncoding;
    end;
  end;
end;

function TBisHttpServerHandlerKrasplatWebModule.Commit(Request: TWebRequest; Response: TWebResponse): Boolean;

  function ReadParams(var DateReceipt: TDateTime; var ReceiptId: Variant): TBisResponseStatus;
  var
    TimeP: String;
    IdV: String;
    MD5: String;
    I: Int64;
    S: String;
  begin
    Result:=rsInternalError;
    TimeP:=Trim(Request.QueryFields.Values['time_p']);
    IdV:=Trim(Request.QueryFields.Values['id_v']);
    MD5:=Trim(Request.QueryFields.Values['md5']);
    if (TimeP<>'') and (IdV<>'') and (MD5<>'') then begin
      if not TryStrToInt64(TimeP,I) then begin
        Result:=rsInvalidTimeP;
      end else begin
        DateReceipt:=UnixToDateTime(I);
        ReceiptId:=IdV;
        S:=GetMD5(TimeP+IdV+FClientKey);
        if not AnsiSameText(S,MD5) then
          Result:=rsInvalidMD5
        else Result:=rsSuccess;
      end;
    end;
  end;

  function PaymentExists(ReceiptId: Variant): Boolean;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.UseShowError:=false;
      P.UseWaitCursor:=false;
      P.ProviderName:='S_RECEIPTS';
      with P.FieldNames do begin
        AddInvisible('RECEIPT_ID');
      end;
      P.FilterGroups.Add.Filters.Add('RECEIPT_ID',fcEqual,ReceiptId).CheckCase:=true;
      P.Open;
      Result:=P.Active and not P.Empty;
    finally
      P.Free;
    end;
  end;

  function WriteParams(Status: TBisResponseStatus): String;
  var
    Xml: TALXMLDocument;
    ResponseNode: TALXMLNode;
    TimeVNode: TALXMLNode;
    TimeV: String;
    StatusNode: TALXMLNode;
    MD5: String;
    MD5Node: TALXMLNode;
  begin
    try
      Xml:=TALXMLDocument.Create(nil);
      try
        Xml.LoadFromXML(FormatEx('<?xml version="1.0" encoding="%s" ?>',[SDefaultEncoding]));
        ResponseNode:=Xml.AddChild('response');
        TimeVNode:=ResponseNode.AddChild('time_v');
        TimeV:=IntToStr(DateTimeToUnix(Now));
        TimeVNode.NodeValue:=TimeV;
        StatusNode:=ResponseNode.AddChild('status');
        StatusNode.NodeValue:=IntToStr(Integer(Status));
        MD5:=GetMD5(TimeV+FServerKey);
        MD5Node:=ResponseNode.AddChild('md5');
        MD5Node.NodeValue:=MD5;
        Result:=Trim(Xml.XML.Text);
      finally
        Xml.Free;
      end;
    except
      on E: Exception do begin
        LoggerWrite(E.Message,ltError);
      end;
    end;
  end;
  
var
  DateReceipt: TDateTime;
  ReceiptId: Variant;
  Status: TBisResponseStatus;
begin
  Result:=Assigned(Core);
  if Result then begin
    Status:=rsSuccess;
    try
      try
        DateReceipt:=Now;
        ReceiptId:=Null;
        Status:=ReadParams(DateReceipt,ReceiptId);
        if Status=rsSuccess then begin
          if not PaymentExists(ReceiptId) then
            Status:=rsInvalidTransaction;
        end;
      except
        On E: Exception do begin
          Status:=rsInternalError;
          LoggerWrite(E.Message,ltError);
        end;
      end;
    finally
      Response.Content:=WriteParams(Status);
      Response.ContentType:=SXMLType;
      Response.ContentEncoding:=SDefaultEncoding;
    end;
  end;
end;

procedure TBisHttpServerHandlerKrasplatWebModule.BisHttpServerHandlerKrasplatWebModuleCheckAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=Check(Request,Response);
end;

procedure TBisHttpServerHandlerKrasplatWebModule.BisHttpServerHandlerKrasplatWebModuleCommitAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=Commit(Request,Response);
end;

procedure TBisHttpServerHandlerKrasplatWebModule.BisHttpServerHandlerKrasplatWebModuleDefaultAction(Sender: TObject;
          Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=false;
end;

procedure TBisHttpServerHandlerKrasplatWebModule.BisHttpServerHandlerKrasplatWebModulePaymentAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=Payment(Request,Response)
end;

end.