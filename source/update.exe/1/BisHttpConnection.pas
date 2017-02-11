unit BisHttpConnection;

interface


uses Windows, Classes, Controls, DB,
     WinInet,
     Ras, RasUtils, RasHelperClasses,
     IdHttp, IdComponent, IdGlobal,
     BisConnectionModules, BisConnections, BisExceptions, BisCrypter,
     BisDataSet, BisProfile, BisInterfaces, BisMenus;

type
  TBisHttpConnection=class;

  TBisHttpConnectionType=(ctDirect,ctRemote,ctModem);

  TBisHttpConnectionInternetType=(citUnknown,citModem,citLan,citProxy);

  TBisHttpConnectionFormat=(cfRaw,cfXml);

  TBisHttpConnectionMethod=(cmConnect,cmDisconnect,cmImport,cmExport,cmGetServerDate,
                            cmLogin,cmLogout,cmCheck,
                            cmLoadProfile,cmSaveProfile,cmRefreshPermissions,cmLoadInterfaces,
                            cmGetRecords,cmExecute,cmLoadMenus,
                            cmLoadScript,cmLoadReport,cmLoadDocument);

  TBisIdHttp=class(TIdHttp)
  private
    FConnection: TBisHttpConnection;
    FUseCrypter: Boolean;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FCrypterKey: String;
    FPath: String;
    FProtocol: String;
    FUseCompress: Boolean;

    function GetFullUrl(const Document: String=''): String;
    function GetKey: String;
    function ExecuteMethod(Method: TBisHttpConnectionMethod; Params: TBisDataSet=nil): Boolean;
    function CreateParams: TBisDataSet;
    procedure Compress(Stream: TStream);
    procedure Decompress(Stream: TStream);
  protected
    procedure DoOnConnected; override;
  public
    constructor Create(AOwner: TComponent);
    procedure Connect; reintroduce;
    procedure Disconnect; reintroduce;
    procedure Import(ImportType: TBisConnectionImportType; Stream: TStream);
    procedure Export(ExportType: TBisConnectionExportType; const Value: String; Stream: TStream);
    function GetServerDate: TDateTime;

    function Login(const ApplicationId,UserName,Password: String; Params: TBisConnectionLoginParams=nil): String;
    procedure Logout(const SessionId: String);
    function Check(const SessionId: String): Boolean;
    procedure LoadProfile(const SessionId: String; Profile: TBisProfile);
    procedure SaveProfile(const SessionId: String; Profile: TBisProfile);
    procedure RefreshPermissions(const SessionId: String);
    procedure LoadInterfaces(const SessionId: String; Interfaces: TBisInterfaces);
    procedure GetRecords(const SessionId: String; DataSet: TBisDataSet);
    procedure Execute(const SessionId: String; DataSet: TBisDataSet);
    procedure LoadMenus(const SessionId: String; Menus: TBisMenus);
    procedure LoadScript(const SessionId: String; ScriptId: String; Stream: TStream);
    procedure LoadReport(const SessionId: String; ReportId: String; Stream: TStream);
    procedure LoadDocument(const SessionId: String; DocumentId: String; Stream: TStream);

    property Connection: TBisHttpConnection read FConnection write FConnection;
    property UseCrypter: Boolean read FUseCrypter write FUseCrypter;
    property CrypterAlgorithm: TBisCipherAlgorithm read FCrypterAlgorithm write FCrypterAlgorithm;
    property CrypterMode: TBisCipherMode read FCrypterMode write FCrypterMode;
    property CrypterKey: String read FCrypterKey write FCrypterKey;
    property Path: String read FPath write FPath;
    property Protocol: String read FProtocol write FProtocol;
    property UseCompress: Boolean read FUseCompress write FUseCompress; 
  end;

  TBisDialer=class(TRasDialer)
  end;

  TBisHttpConnection=class(TBisConnection)
  private
    FLock: TRTLCriticalSection;
    FOldCursor: TCursor;
    FConnected: Boolean;
    FConnection: TBisIdHttp;
    FConnectionType: TBisHttpConnectionType;
    FRemoteAuto: Boolean;
    FRemoteName: String;
    FInternet: DWord;
    FDialer: TBisDialer;
    FWorkCountMax: Integer;
    FProgressEnabled: Boolean;

    FSNameAuto: String;

    procedure Lock;
    procedure UnLock;
    procedure ChangeParams(Sender: TObject);
    function GetInternetType: TBisHttpConnectionInternetType;
    procedure DialerNotify(Sender: TObject; State: TRasConnState; ErrorCode: DWORD);
    procedure ConnectionWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Integer);
    procedure ConnectionWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
    procedure ConnectionWorkEnd(ASender: TObject; AWorkMode: TWorkMode);

    procedure ConnectDirect;
    procedure ConnectRemote;
    procedure ConnectModem;

    procedure DisconnectDirect;
    procedure DisconnectRemote;
    procedure DisconnectModem;
  protected
    function GetConnected: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Connect; override;
    procedure Disconnect; override;
    procedure Import(ImportType: TBisConnectionImportType; Stream: TStream); override;
    procedure Export(ExportType: TBisConnectionExportType; const Value: String; Stream: TStream); override;
    function GetServerDate: TDateTime; override;

    function Login(const ApplicationId,UserName,Password: String; Params: TBisConnectionLoginParams=nil): String; override;
    procedure Logout(const SessionId: String); override;
    function Check(const SessionId: String): Boolean; override;
    procedure LoadProfile(const SessionId: String; Profile: TBisProfile); override;
    procedure SaveProfile(const SessionId: String; Profile: TBisProfile); override;
    procedure RefreshPermissions(const SessionId: String); override;
    procedure LoadInterfaces(const SessionId: String; Interfaces: TBisInterfaces); override;
    procedure GetRecords(const SessionId: String; DataSet: TBisDataSet); override;
    procedure Execute(const SessionId: String; DataSet: TBisDataSet); override;
    procedure LoadMenus(const SessionId: String; Menus: TBisMenus); override;
    procedure LoadScript(const SessionId: String; ScriptId: String; Stream: TStream); override;
    procedure LoadReport(const SessionId: String; ReportId: String; Stream: TStream); override;
    procedure LoadDocument(const SessionId: String; DocumentId: String; Stream: TStream); override;

  published
    property SNameAuto: String read FSNameAuto write FSNameAuto;
  end;


procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses SysUtils, Forms, Variants, ZLib,
     IdAssignedNumbers,
     BisConsts, BisHttpConnectionConsts, BisUtils, BisCore, BisParams;

     
procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisHttpConnection;
end;

{ TBisIdHttp }

constructor TBisIdHttp.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
end;

procedure TBisIdHttp.DoOnConnected;
begin
  inherited DoOnConnected;

end;

function TBisIdHttp.CreateParams: TBisDataSet;
begin
  Result:=TBisDataSet.Create(nil);
  with Result do begin
    FieldDefs.Add(SFieldName,ftString,100);
    FieldDefs.Add(SFieldValue,ftBlob);
  end;
  Result.CreateTable();
  Result.Open;
end;

function TBisIdHttp.GetFullUrl(const Document: String=''): String;
begin
  Result:='';
  try
    URL.Host:=Host;
    URL.Port:=IntToStr(Port);
    URL.Protocol:=FProtocol;
    URL.Path:=FPath;
    URL.Document:=Document;
    Result:=URL.GetFullURI([]);
  except
  end;
end;

function TBisIdHttp.GetKey: String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Trim(Format('%s:%s%s%s+%s',[Url.Host,Url.Port,Url.Path,Url.Document,FCrypterKey]));
    Result:=Crypter.HashString(Result,haMD5,hfHEX);
  finally
    Crypter.Free;
  end;
end;

procedure TBisIdHttp.Compress(Stream: TStream);
var
  Zip: TCompressionStream;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    try
      Zip:=TCompressionStream.Create(clFastest,TempStream);
      try
        Stream.Position:=0;
        Zip.CopyFrom(Stream,Stream.Size);
      finally
        Zip.Free;
      end;
      Stream.Size:=0;
      TempStream.Position:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      TempStream.Free;
    end;
  end;
end;

procedure TBisIdHttp.Decompress(Stream: TStream);
var
  Zip: TDecompressionStream;
  Count: Integer;
  Buffer: array[0..1023] of Char;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    try
      Stream.Position:=0; 
      Zip:=TDecompressionStream.Create(Stream);
      try
        repeat
          Count:=Zip.Read(Buffer,SizeOf(Buffer));
          TempStream.Write(Buffer,Count);
        until Count=0;
      finally
        Zip.Free;
      end;
      TempStream.Position:=0;
      Stream.Size:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      TempStream.Free;
    end;
  end;
end;

function TBisIdHttp.ExecuteMethod(Method: TBisHttpConnectionMethod; Params: TBisDataSet): Boolean;
var
  Writer: TWriter;
  Reader: TReader;
  ParamsStream: TMemoryStream;
  RequestStream: TMemoryStream;
  ResponseStream: TMemoryStream;
  TempStream: TMemoryStream;
  FullUrl: String;
  Key: String;
  Error: String;
  ASize: Int64;
  Crypter: TBisCrypter;
  Success: Boolean;
  Format: TBisHttpConnectionFormat;
begin
  ParamsStream:=TMemoryStream.Create;
  RequestStream:=TMemoryStream.Create;
  ResponseStream:=TMemoryStream.Create;
  TempStream:=TMemoryStream.Create;
  Crypter:=TBisCrypter.Create;
  try
    Result:=false;

    FullUrl:=GetFullUrl();
    Key:=GetKey;

    if Assigned(Params) and Params.Active then begin
      Params.SaveToStream(ParamsStream);
      ParamsStream.Position:=0;
    end;

    Format:=cfRaw;

    Writer:=TWriter.Create(TempStream,WriterBufferSize);
    try
      Writer.WriteInteger(Integer(Format));
      Writer.WriteInteger(Integer(Method));
      Writer.WriteInteger(ParamsStream.Size);
    finally
      Writer.Free;
    end;

    if ParamsStream.Size>0 then begin
      TempStream.CopyFrom(ParamsStream,ParamsStream.Size);
    end;

    if FUseCompress then
      Compress(TempStream);

    RequestStream.Clear;
    TempStream.Position:=0;
    if FUseCrypter then
      Crypter.EncodeStream(Key,TempStream,RequestStream,FCrypterAlgorithm,FCrypterMode)
    else
      RequestStream.CopyFrom(TempStream,TempStream.Size);

    RequestStream.Position:=0;

    Post(FullUrl,RequestStream,ResponseStream);

    ResponseStream.Position:=0;
    TempStream.Clear;
    if FUseCrypter then
      Crypter.DecodeStream(Key,ResponseStream,TempStream,FCrypterAlgorithm,FCrypterMode)
    else
      TempStream.CopyFrom(ResponseStream,ResponseStream.Size);

    if FUseCompress then
      Decompress(TempStream);
      
    Success:=false;
    TempStream.Position:=0;

    if TempStream.Size>0 then begin
      Reader:=TReader.Create(TempStream,ReaderBufferSize);
      try
        Success:=Reader.ReadBoolean;
        Error:=Reader.ReadString;
        ASize:=Reader.ReadInt64;
      finally
        Reader.Free;
      end;

      if ASize>0 then begin
        ParamsStream.Clear;
        ParamsStream.CopyFrom(TempStream,ASize);
        ParamsStream.Position:=0;
      end;

      if Assigned(Params) and (ParamsStream.Size>0) then begin
        case Format of
          cfRaw: Params.LoadFromStream(ParamsStream);
          cfXml: ;
        end;
        Params.Open;
      end;
    end;

    Result:=Success;
    if not Result then
      raise Exception.Create(Error);

  finally
    Crypter.Free;
    TempStream.Free;
    ResponseStream.Free;
    RequestStream.Free;
    ParamsStream.Free;
  end;
end;

procedure TBisIdHttp.Connect;
begin
  ExecuteMethod(cmConnect);
end;

procedure TBisIdHttp.Disconnect;
begin
  ExecuteMethod(cmDisconnect);
end;

procedure TBisIdHttp.Import(ImportType: TBisConnectionImportType; Stream: TStream);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SImportType;
    DS.FieldByName(SFieldValue).Value:=ImportType;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SStream;
    TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
    DS.Post;

    ExecuteMethod(cmImport,DS);
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.Export(ExportType: TBisConnectionExportType; const Value: String; Stream: TStream);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SExportType;
    DS.FieldByName(SFieldValue).Value:=ExportType;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SValue;
    DS.FieldByName(SFieldValue).Value:=Value;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SStream;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmExport,DS) then begin

      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SStream,[]) then begin
          TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

function TBisIdHttp.GetServerDate: TDateTime;
var
  DS: TBisDataSet;
begin
  Result:=Now;
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SResult;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmGetServerDate,DS) then begin
      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SResult,[]) then begin
          Result:=VarToDateDef(DS.FieldByName(SFieldValue).Value,Result);
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

function TBisIdHttp.Login(const ApplicationId, UserName, Password: String; Params: TBisConnectionLoginParams=nil): String;
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  LoginParams: TBisConnectionLoginParams;
begin
  Result:='';
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SApplicationId;
    DS.FieldByName(SFieldValue).Value:=ApplicationId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SUserName;
    DS.FieldByName(SFieldValue).Value:=UserName;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SPassword;
    DS.FieldByName(SFieldValue).Value:=Password;
    DS.Post;

    if Assigned(Params) then begin
      Stream:=TMemoryStream.Create;
      try
        Params.SaveToStream(Stream);
        Stream.Position:=0;
        DS.Append;
        DS.FieldByName(SFieldName).Value:=SParams;
        TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
        DS.Post;
      finally
        Stream.Free;
      end;
    end;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SResult;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmLogin,DS) then begin

      if DS.Active and not DS.IsEmpty then begin

        if DS.Locate(SFieldName,SParams,[]) then begin
          if Assigned(Params) then begin
            LoginParams:=TBisConnectionLoginParams.Create;
            Stream:=TMemoryStream.Create;
            try
              TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;
              LoginParams.LoadFromStream(Stream);
              Params.AccountId:=LoginParams.AccountId;
            finally
              Stream.Free;
              LoginParams.Free;
            end;
          end;

          Result:=DS.FieldByName(SFieldValue).AsString;
        end;

        if DS.Locate(SFieldName,SResult,[]) then begin
          Result:=DS.FieldByName(SFieldValue).AsString;
        end;

      end;
    end;
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.Logout(const SessionId: String);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    ExecuteMethod(cmLogout,DS);
  finally
    DS.Free;
  end;
end;

function TBisIdHttp.Check(const SessionId: String): Boolean;
var
  DS: TBisDataSet;
begin
  Result:=false;
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SResult;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmCheck,DS) then begin

      if DS.Active and not DS.IsEmpty then begin

        if DS.Locate(SFieldName,SResult,[]) then begin
          Result:=Boolean(StrToIntDef(DS.FieldByName(SFieldValue).AsString,0));
        end;

      end;
      
    end;
    
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.LoadProfile(const SessionId: String; Profile: TBisProfile);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SProfile;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmLoadProfile,DS) then begin

      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SProfile,[]) then begin
          Stream:=TMemoryStream.Create;
          try
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Profile.LoadFromStream(Stream);
          finally
            Stream.Free;
          end;
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.SaveProfile(const SessionId: String; Profile: TBisProfile);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    Stream:=TMemoryStream.Create;
    try
      Profile.SaveToStream(Stream);
      Stream.Position:=0;
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SProfile;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;
    finally
      Stream.Free;
    end;

    ExecuteMethod(cmSaveProfile,DS);
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.RefreshPermissions(const SessionId: String);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    ExecuteMethod(cmRefreshPermissions,DS);
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.LoadInterfaces(const SessionId: String; Interfaces: TBisInterfaces);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SInterfaces;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmLoadInterfaces,DS) then begin

      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SInterfaces,[]) then begin
          Stream:=TMemoryStream.Create;
          try
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Interfaces.LoadFromStream(Stream);
          finally
            Stream.Free;
          end;
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.GetRecords(const SessionId: String; DataSet: TBisDataSet);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
begin
  DS:=CreateParams;
  Stream:=TMemoryStream.Create;
  try

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SProviderName;
    DS.FieldByName(SFieldValue).Value:=DataSet.ProviderName;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SFetchCount;
    DS.FieldByName(SFieldValue).Value:=DataSet.FetchCount;
    DS.Post;

    Stream.Clear;
    DataSet.FieldNames.SaveToStream(Stream);
    Stream.Position:=0;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SFieldNames;
    TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
    DS.Post;

    Stream.Clear;
    DataSet.FilterGroups.SaveToStream(Stream);
    Stream.Position:=0;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SFilterGroups;
    TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
    DS.Post;

    Stream.Clear;
    DataSet.Orders.SaveToStream(Stream);
    Stream.Position:=0;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SOrders;
    TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
    DS.Post;

    Stream.Clear;
    DataSet.Params.SaveToStream(Stream);
    Stream.Position:=0;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SParams;
    TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SDataSet;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SServerRecordCount;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmGetRecords,DS) then begin

      if DS.Active and not DS.IsEmpty then begin

        if DS.Locate(SFieldName,SDataSet,[]) then begin
          Stream.Clear;
          TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
          Stream.Position:=0;
          if Stream.Size>0 then begin
            DataSet.BeginUpdate;
            try
              DataSet.Close;
              DataSet.LoadFromStream(Stream);
              DataSet.First;
            finally
              DataSet.EndUpdate;
            end;
          end;
        end;

        if DS.Locate(SFieldName,SServerRecordCount,[]) then begin
          DataSet.ServerRecordCount:=VarToIntDef(DS.FieldByName(SFieldValue).Value,0);
        end;
      end;
    end;
  finally
    Stream.Free;
    DS.Free;
  end;
end;

procedure TBisIdHttp.Execute(const SessionId: String; DataSet: TBisDataSet);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  Params: TBisParams;
  PackageParams: TBisPackageParams;
begin
  DS:=CreateParams;
  Stream:=TMemoryStream.Create;
  Params:=TBisParams.Create;
  try

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SProviderName;
    DS.FieldByName(SFieldValue).Value:=DataSet.ProviderName;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SFetchCount;
    DS.FieldByName(SFieldValue).Value:=DataSet.FetchCount;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SInGetRecords;
    DS.FieldByName(SFieldValue).Value:=DataSet.InGetRecords;
    DS.Post;

    Stream.Clear;
    DataSet.FieldNames.SaveToStream(Stream);
    Stream.Position:=0;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SFieldNames;
    TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
    DS.Post;

    Params.CopyFrom(DataSet.Params,true,false);
    Stream.Clear;
    Params.SaveToStream(Stream);
    Stream.Position:=0;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SParams;
    TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
    DS.Post;

    PackageParams:=TBisPackageParams.Create;
    try
      PackageParams.CopyFrom(DataSet.PackageParams,true,false);
      Stream.Clear;
      PackageParams.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SPackageParams;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;
    finally
      PackageParams.Free;
    end;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SDataSet;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SServerRecordCount;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmExecute,DS) then begin

      if DS.Active and not DS.IsEmpty then begin

        if DS.Locate(SFieldName,SDataSet,[]) then begin
          Stream.Clear;
          TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
          Stream.Position:=0;
          if Stream.Size>0 then begin
            DataSet.BeginUpdate;
            try
              DataSet.Close;
              DataSet.LoadFromStream(Stream);
              DataSet.First;
            finally
              DataSet.EndUpdate;
            end;
          end;
        end;

        if DS.Locate(SFieldName,SServerRecordCount,[]) then begin
          DataSet.ServerRecordCount:=VarToIntDef(DS.FieldByName(SFieldValue).Value,0);
        end;

        if DS.Locate(SFieldName,SParams,[]) then begin
          Stream.Clear;
          TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
          Stream.Position:=0;
          Params.Clear;
          Params.LoadFromStream(Stream);
          DataSet.Params.CopyFrom(Params,false,false,[ptOutput,ptInputOutput,ptResult]);
        end;
        
      end;
    end;
  finally
    Params.Free;
    Stream.Free;
    DS.Free;
  end;
end;


procedure TBisIdHttp.LoadMenus(const SessionId: String; Menus: TBisMenus);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SMenus;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmLoadMenus,DS) then begin

      if DS.Active and not DS.IsEmpty then begin

        if DS.Locate(SFieldName,SMenus,[]) then begin
          Stream:=TMemoryStream.Create;
          try
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Menus.LoadFromStream(Stream);
          finally
            Stream.Free;
          end;
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.LoadScript(const SessionId: String; ScriptId: String; Stream: TStream);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SScriptId;
    DS.FieldByName(SFieldValue).Value:=ScriptId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SStream;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmLoadScript,DS) then begin

      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SStream,[]) then begin
          TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.LoadReport(const SessionId: String; ReportId: String; Stream: TStream);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SReportId;
    DS.FieldByName(SFieldValue).Value:=ReportId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SStream;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmLoadReport,DS) then begin

      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SStream,[]) then begin
          TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.LoadDocument(const SessionId: String; DocumentId: String; Stream: TStream);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SDocumentId;
    DS.FieldByName(SFieldValue).Value:=DocumentId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SStream;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmLoadDocument,DS) then begin

      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SStream,[]) then begin
          TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
        end;
      end;
    end;
  finally
    DS.Free;
  end;
end;

{ TBisHttpConnection }

constructor TBisHttpConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeCriticalSection(FLock);

  FConnection:=TBisIdHttp.Create(Self);
  FConnection.Connection:=Self;
  FConnection.OnWorkBegin:=ConnectionWorkBegin;
  FConnection.OnWork:=ConnectionWork;
  FConnection.OnWorkEnd:=ConnectionWorkEnd;

  FDialer:=TBisDialer.Create;
  FDialer.Mode:=dmSync;
  FDialer.OnNotify:=DialerNotify;

  Params.OnChange:=ChangeParams;

  FSNameAuto:='¿‚ÚÓÓÔÂ‰ÂÎÂÌËÂ';
end;

destructor TBisHttpConnection.Destroy;
begin
  FDialer.OnNotify:=nil;
  FDialer.Free;
  FConnection.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TBisHttpConnection.Init;
begin
  inherited Init;
  FConnection.Request.UserAgent:=ObjectName;
end;

procedure TBisHttpConnection.Lock;
begin
  EnterCriticalSection(FLock);
  FOldCursor:=Screen.Cursor;
end;

procedure TBisHttpConnection.UnLock;
begin
  Screen.Cursor:=FOldCursor;
  LeaveCriticalSection(FLock);
end;

procedure TBisHttpConnection.ChangeParams(Sender: TObject);
var
  i: Integer;
  Param: TBisConnectionParam;
  UseProxy: Boolean;
begin
  UseProxy:=false;
  for i:=0 to Params.Count-1 do begin
    Param:=Params.Items[i];

    if AnsiSameText(Param.ParamName,SParamHost) then FConnection.Host:=Param.Value;
    if AnsiSameText(Param.ParamName,SParamPort) then FConnection.Port:=StrToIntDef(Param.Value,IdPORT_HTTP);
    if AnsiSameText(Param.ParamName,SParamPath) then FConnection.Path:=Param.Value;
    if AnsiSameText(Param.ParamName,SParamProtocol) then FConnection.Protocol:=Param.Value;

    if AnsiSameText(Param.ParamName,SParamType) then FConnectionType:=TBisHttpConnectionType(StrToIntDef(Param.Value,0));

    if AnsiSameText(Param.ParamName,SParamUseProxy) then UseProxy:=Boolean(StrToIntDef(Param.Value,0));
    if AnsiSameText(Param.ParamName,SParamProxyHost) then FConnection.ProxyParams.ProxyServer:=Param.Value;
    if AnsiSameText(Param.ParamName,SParamProxyPort) then FConnection.ProxyParams.ProxyPort:=StrToIntDef(Param.Value,0);
    if AnsiSameText(Param.ParamName,SParamProxyUser) then FConnection.ProxyParams.ProxyUsername:=Param.Value;
    if AnsiSameText(Param.ParamName,SParamProxyPassword) then FConnection.ProxyParams.ProxyPassword:=Param.Value;

    if AnsiSameText(Param.ParamName,SParamRemoteAuto) then FRemoteAuto:=Boolean(StrToIntDef(Param.Value,0));
    if AnsiSameText(Param.ParamName,SParamRemoteName) then FRemoteName:=Param.Value;

    if AnsiSameText(Param.ParamName,SParamModemUser) then FDialer.UserName:=Param.Value;
    if AnsiSameText(Param.ParamName,SParamModemPassword) then FDialer.Password:=Param.Value;
    if AnsiSameText(Param.ParamName,SParamModemDomain) then FDialer.Domain:=Param.Value;
    if AnsiSameText(Param.ParamName,SParamModemPhone) then FDialer.PhoneNumber:=Param.Value;

    if AnsiSameText(Param.ParamName,SParamUseCrypter) then FConnection.UseCrypter:=Boolean(StrToIntDef(Param.Value,0));
    if AnsiSameText(Param.ParamName,SParamCrypterAlgorithm) then FConnection.CrypterAlgorithm:=TBisCipherAlgorithm(StrToIntDef(Param.Value,0));
    if AnsiSameText(Param.ParamName,SParamCrypterMode) then FConnection.CrypterMode:=TBisCipherMode(StrToIntDef(Param.Value,0));
    if AnsiSameText(Param.ParamName,SParamCrypterKey) then FConnection.CrypterKey:=Param.Value;

    if AnsiSameText(Param.ParamName,SParamUseCompress) then FConnection.UseCompress:=Boolean(StrToIntDef(Param.Value,0));
  end;

  if not UseProxy then
    FConnection.ProxyParams.Clear;
  
end;

function TBisHttpConnection.GetConnected: Boolean;
begin
  Result:=FConnected;
end;

function TBisHttpConnection.GetInternetType: TBisHttpConnectionInternetType;
var
  Connected: Bool;
  dwFlags: Dword;
begin
  Result:=citUnknown;
  Connected:=InternetGetConnectedState(@dwFlags,0) and ((dwFlags and INTERNET_CONNECTION_MODEM_BUSY)=0);
  if Connected then begin
    if (dwFlags and INTERNET_CONNECTION_MODEM)=1 then Result:=citModem;
    if (dwFlags and INTERNET_CONNECTION_LAN)=1 then Result:=citLan;
    if (dwFlags and INTERNET_CONNECTION_PROXY)=1 then Result:=citProxy;
  end;
end;

procedure TBisHttpConnection.DialerNotify(Sender: TObject; State: TRasConnState;
  ErrorCode: DWORD);
begin
  FConnected:=FDialer.Active;
end;

procedure TBisHttpConnection.ConnectionWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Integer);
var
  Breaked: Boolean;
begin
  FWorkCountMax:=AWorkCountMax;
  if FProgressEnabled then
    Progress(0,AWorkCountMax,0,Breaked);
end;

procedure TBisHttpConnection.ConnectionWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
var
  Breaked: Boolean;
begin
  if FProgressEnabled then
    Progress(0,FWorkCountMax,AWorkCount,Breaked);
end;

procedure TBisHttpConnection.ConnectionWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
var
  Breaked: Boolean;
begin
  FWorkCountMax:=0;
  if FProgressEnabled then
    Progress(0,0,0,Breaked);
end;

procedure TBisHttpConnection.ConnectDirect;
var
  AConnected: Boolean;
begin
  AConnected:=false;
  try
    FConnection.Connect;
    AConnected:=true;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisHttpConnection.ConnectRemote;
var
  InternetType: TBisHttpConnectionInternetType;
  Ret: Dword;
  dwConnection: DWord;
  AConnected: Boolean;
  NewRemoteName: string;
  S: String;
begin
  AConnected:=false;
  try
    NewRemoteName:=iff(FRemoteAuto,FSNameAuto,FRemoteName);
    InternetType:=GetInternetType;
    if InternetType<>citLan then begin
      if FRemoteAuto then begin
        AConnected:=InternetAutoDial(INTERNET_AUTODIAL_FORCE_UNATTENDED,ParentHandle);
      end else begin
        Ret:=InternetDial(ParentHandle,PChar(FRemoteName),INTERNET_AUTODIAL_FORCE_UNATTENDED,@dwConnection,0);
        if Ret=ERROR_SUCCESS then begin
          FInternet:=dwConnection;
          AConnected:=true;
        end;
      end;
    end else AConnected:=true;

    if AConnected then begin
      S:=FConnection.GetFullUrl;
      InternetGoOnline(PChar(S),ParentHandle,0);
      FConnection.Connect;
    end;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisHttpConnection.ConnectModem;
var
  InternetType: TBisHttpConnectionInternetType;
  Ret: Dword;
  AConnected: Boolean;
  S: String;
begin
  AConnected:=false;
  try
    Ret:=ERROR_SUCCESS;
    InternetType:=GetInternetType;
    if InternetType<>citLan then begin
      try
        FDialer.Dial;
      except
        On E: EWin32Error do begin
          Ret:=E.ErrorCode;
        end;
      end;
      if Ret=ERROR_SUCCESS then begin
        FInternet:=FDialer.ConnHandle;
        AConnected:=true;
      end;
    end else AConnected:=true;

    if AConnected then begin
      S:=FConnection.GetFullUrl;
      InternetGoOnline(PChar(S),ParentHandle,0);
      FConnection.Connect;
    end;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisHttpConnection.Connect;
begin
  Lock;
  try
    try
      inherited Connect;
      if not FConnected then
        case FConnectionType of
          ctDirect: ConnectDirect;
          ctRemote: ConnectRemote;
          ctModem: ConnectModem;
        end;
    except
      On E: Exception do
        raise EBisConnection.Create(ECConnectFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.DisconnectDirect;
begin
  FConnection.Disconnect;
  FConnected:=false;
end;

procedure TBisHttpConnection.DisconnectRemote;
var
  InternetType: TBisHttpConnectionInternetType;
begin
  FConnection.Disconnect;
  InternetType:=GetInternetType;
  if InternetType<>citLan then begin
    if FRemoteAuto then
      InternetAutodialHangup(0)
    else begin
      InternetHangUp(FInternet,0);
    end;
  end;
  FConnected:=false;
end;

procedure TBisHttpConnection.DisconnectModem;
var
  InternetType: TBisHttpConnectionInternetType;
begin
  FConnection.Disconnect;
  InternetType:=GetInternetType;
  if InternetType<>citLan then begin
    try
      if FDialer.Active then
        FDialer.HangUp;
    except
    end;
  end;
  FConnected:=false;
end;

procedure TBisHttpConnection.Disconnect;
begin
  Lock;
  try
    inherited Disconnect;
    try
      if FConnected then
        case FConnectionType of
          ctDirect: DisconnectDirect;
          ctRemote: DisconnectRemote;
          ctModem: DisconnectModem;
        end;
    except
      On E: Exception do
        raise EBisConnection.Create(E—DisconnectFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.Import(ImportType: TBisConnectionImportType; Stream: TStream);
begin
  Lock;
  try
    inherited Import(ImportType,Stream);
    try
      if Assigned(Stream) then
        FConnection.Import(ImportType,Stream)
    except
      on E: Exception do
        raise EBisConnection.Create(ECImportFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.Export(ExportType: TBisConnectionExportType; const Value: String; Stream: TStream);
begin
  Lock;
  try
    inherited Export(ExportType,Value,Stream);
    try
      if Assigned(Stream) then
        FConnection.Export(ExportType,Value,Stream);
    except
      on E: Exception do
        raise EBisConnection.Create(ECExportFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

function TBisHttpConnection.GetServerDate: TDateTime;
begin
  Lock;
  try
    Result:=inherited GetServerDate;
    try
      Result:=FConnection.GetServerDate;
    except
      on E: Exception do
        raise EBisConnection.Create(ECGetServerDateFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

function TBisHttpConnection.Login(const ApplicationId, UserName, Password: String; Params: TBisConnectionLoginParams=nil): String;
begin
  Lock;
  try
    Result:=inherited Login(ApplicationId,UserName,Password);
    try
      Result:=FConnection.Login(ApplicationId,UserName,Password,Params);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLoginFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.Logout(const SessionId: String);
begin
  Lock;
  try
    inherited Logout(SessionId);
    try
      FConnection.Logout(SessionId);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLogoutFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

function TBisHttpConnection.Check(const SessionId: String): Boolean;
begin
  Lock;
  try
    Result:=inherited Check(SessionId);
    try
      Result:=FConnection.Check(SessionId);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLogoutFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.LoadProfile(const SessionId: String; Profile: TBisProfile);
begin
  Lock;
  try
    inherited LoadProfile(SessionId,Profile);
    if Assigned(Profile) then begin
      try
        FConnection.LoadProfile(SessionId,Profile);
      except
        on E: Exception do
          raise EBisConnection.Create(ECLoadProfileFailed,E.Message);
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.SaveProfile(const SessionId: String; Profile: TBisProfile);
begin
  Lock;
  try
    inherited LoadProfile(SessionId,Profile);
    try
      if Assigned(Profile) then
        FConnection.SaveProfile(SessionId,Profile);
    except
      on E: Exception do
        raise EBisConnection.Create(ECSaveProfileFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.RefreshPermissions(const SessionId: String);
begin
  Lock;
  try
    inherited RefreshPermissions(SessionId);
    try
      FConnection.RefreshPermissions(SessionId);
    except
      on E: Exception do
        raise EBisConnection.Create(ECRefreshPermissionsFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.LoadInterfaces(const SessionId: String; Interfaces: TBisInterfaces);
begin
  Lock;
  try
    inherited LoadInterfaces(SessionId,Interfaces);
    try
      if Assigned(Interfaces) then
        FConnection.LoadInterfaces(SessionId,Interfaces);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLoadInterfacesFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.GetRecords(const SessionId: String; DataSet: TBisDataSet);
begin
  Lock;
  FProgressEnabled:=ProgressNeedLook;
  try
    inherited GetRecords(SessionId,DataSet);
    try
      if Assigned(DataSet) then
        FConnection.GetRecords(SessionId,DataSet);
    except
      on E: Exception do
        raise EBisConnection.Create(ECGetRecordsFailed,E.Message);
    end;
  finally
    FProgressEnabled:=false;
    UnLock;
  end;
end;

procedure TBisHttpConnection.Execute(const SessionId: String; DataSet: TBisDataSet);
begin
  Lock;
  FProgressEnabled:=ProgressNeedLook;
  try
    inherited Execute(SessionId,DataSet);
    try
      if Assigned(DataSet) then
        FConnection.Execute(SessionId,DataSet);
    except
      on E: Exception do
        raise EBisConnection.Create(ECExecuteFailed,E.Message);
    end;
  finally
    FProgressEnabled:=false;
    UnLock;
  end;
end;

procedure TBisHttpConnection.LoadMenus(const SessionId: String; Menus: TBisMenus);
begin
  Lock;
  try
    inherited LoadMenus(SessionId,Menus);
    try
      if Assigned(Menus) then
        FConnection.LoadMenus(SessionId,Menus);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLoadMenusFailed,E.Message);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisHttpConnection.LoadScript(const SessionId: String; ScriptId: String; Stream: TStream);
begin
  Lock;
  FProgressEnabled:=ProgressNeedLook;
  try
    inherited LoadScript(SessionId,ScriptId,Stream);
    try
      if Assigned(Stream) then
        FConnection.LoadScript(SessionId,ScriptId,Stream);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLoadScriptFailed,E.Message);
    end;
  finally
    FProgressEnabled:=false;
    UnLock;
  end;
end;

procedure TBisHttpConnection.LoadReport(const SessionId: String; ReportId: String; Stream: TStream);
begin
  Lock;
  FProgressEnabled:=ProgressNeedLook;
  try
    inherited LoadReport(SessionId,ReportId,Stream);
    try
      if Assigned(Stream) then
        FConnection.LoadReport(SessionId,ReportId,Stream);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLoadReportFailed,E.Message);
    end;
  finally
    FProgressEnabled:=false;
    UnLock;
  end;
end;

procedure TBisHttpConnection.LoadDocument(const SessionId: String; DocumentId: String; Stream: TStream);
begin
  Lock;
  FProgressEnabled:=ProgressNeedLook;
  try
    inherited LoadDocument(SessionId,DocumentId,Stream);
    try
      if Assigned(Stream) then
        FConnection.LoadDocument(SessionId,DocumentId,Stream);
    except
      on E: Exception do
        raise EBisConnection.Create(ECLoadDocumentFailed,E.Message);
    end;
  finally
    FProgressEnabled:=false;
    UnLock;
  end;
end;


end.
