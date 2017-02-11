unit BisHttpServerHandlerDefaultWm;

interface

uses
  SysUtils, Classes, HTTPApp, DB, ZLib,
  BisDataSet, BisConnections, BisDataParams,
  BisHttpServerHandlers;

type
  TBisHttpConnectionReturnType=(rtError,rtSuccess,rtRelay);
  TBisHttpConnectionFormat=(cfRaw,cfXml);
  TBisHttpConnectionMethodType=(cmConnect,cmDisconnect,cmImport,cmExport,cmGetServerDate,
                                cmLogin,cmLogout,cmCheck,cmUpdate,
                                cmLoadProfile,cmSaveProfile,cmRefreshPermissions,cmLoadInterfaces,
                                cmGetRecords,cmExecute,cmLoadMenus,cmLoadTasks,cmSaveTask,cmLoadAlarms,
                                cmLoadScript,cmLoadReport,cmLoadDocument,cmCancel);



  TBisConnectionDataParam=class(TBisDataParam)
  private
    FParams: TBisDataValueParams;
  protected
    procedure SetDataSet(DataSet: TBisDataSet); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Params: TBisDataValueParams read FParams; 
  end;

  TBisConnectionDataParams=class(TBisDataParams)
  private
    function GetItem(Index: Integer): TBisConnectionDataParam;
  protected
    class function GetDataParamClass: TBisDataParamClass; override; 
  public
    property Items[Index: Integer]: TBisConnectionDataParam read GetItem; default;
  end;                                

  TBisHttpServerHandlerDefaultWebModule = class(TWebModule)
    procedure BisHttpServerHandlerDefaultWebModuleDefaultAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerDefaultWebModuleBusyAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    FHandler: TBisHttpServerHandler;
    FConnections: TBisConnectionDataParams;
    FConnectTimeOut: Integer;
    FSConnectionNotFound: String;
    FSModeNotSupported: String;
    FMaxSessionCount: Integer;
    FRandomStringSize: Integer;
    FSConnectionBusy: String;

    function CheckParams(Params: TBisDataSet): Boolean;
    function GetSessionId(Params: TBisDataSet): Variant;
    function GetCheckSum(Stream: TStream): String;
    function GetConnection: TBisConnection;

    procedure Connect(Connection: TBisConnection);
    procedure Disconnect(Connection: TBisConnection);
    procedure Import(Connection: TBisConnection; Params: TBisDataSet);
    procedure Export(Connection: TBisConnection; Params: TBisDataSet);
    procedure GetServerDate(Connection: TBisConnection; Params: TBisDataSet);
    procedure Login(Connection: TBisConnection; Params: TBisDataSet; var SessionId: Variant);
    procedure Logout(Connection: TBisConnection; SessionId: Variant);
    procedure Update(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure Check(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure LoadProfile(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure SaveProfile(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure RefreshPermissions(Connection: TBisConnection; SessionId: Variant);
    procedure LoadInterfaces(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure GetRecords(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure Execute(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure LoadMenus(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure LoadTasks(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure SaveTask(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure LoadAlarms(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure LoadScript(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure LoadReport(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure LoadDocument(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
    procedure Cancel(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);

    function CanConnectionRelay(Params: TBisDataSet; var Error: String): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Handler: TBisHttpServerHandler read FHandler write FHandler;
    property ConnectTimeOut: Integer read FConnectTimeOut write FConnectTimeOut;
    property MaxSessionCount: Integer read FMaxSessionCount write FMaxSessionCount;
    property RandomStringSize: Integer read FRandomStringSize write FRandomStringSize;

    property Connections: TBisConnectionDataParams read FConnections;  

  published
    property SConnectionNotFound: String read FSConnectionNotFound write FSConnectionNotFound;
    property SConnectionBusy: String read FSConnectionBusy write FSConnectionBusy;
    property SModeNotSupported: String read FSModeNotSupported write FSModeNotSupported;
  end;

var
  BisHttpServerHandlerDefaultWebModule: TBisHttpServerHandlerDefaultWebModule;

implementation

{$R *.dfm}

uses Windows, Variants,
     AsyncCalls,
     IdStackWindows, IdHttp, IdAuthentication, IdAssignedNumbers,
     BisCore, BisConsts, BisProfile, BisInterfaces, BisMenus, BisUtils, BisLogger, BisNetUtils,
     BisParams, BisProvider, BisTasks, BisAlarmsFm, BisCrypter, BisConfig, BisConnectionUtils,
     BisCryptUtils, BisCompressUtils,
     BisHttpServerHandlerDefaultConsts;

{ TBisConnectionDataParam }

constructor TBisConnectionDataParam.Create;
begin
  inherited Create;
  FParams:=TBisDataValueParams.Create;
end;

destructor TBisConnectionDataParam.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

procedure TBisConnectionDataParam.SetDataSet(DataSet: TBisDataSet);
var
  Field: TField;
begin
  inherited SetDataSet(DataSet);

  FParams.Clear;
  Field:=DataSet.FindField(SFieldParams);
  if Assigned(Field) then
    FParams.CopyFromDataSet(Field.AsString);
end;

{ TBisConnectionDataParams }

class function TBisConnectionDataParams.GetDataParamClass: TBisDataParamClass;
begin
  Result:=TBisConnectionDataParam;
end;

function TBisConnectionDataParams.GetItem(Index: Integer): TBisConnectionDataParam;
begin
  Result:=TBisConnectionDataParam(inherited Items[Index]);
end;

{ TBisHttpServerHandlerDefaultWebModule }

constructor TBisHttpServerHandlerDefaultWebModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnections:=TBisConnectionDataParams.Create;

  FSConnectionNotFound:='Соединение не найдено.';
  FSConnectionBusy:='Соединение занято.';
  FSModeNotSupported:='Режим не поддерживается.';
end;

destructor TBisHttpServerHandlerDefaultWebModule.Destroy;
begin
  FConnections.Free;
  inherited Destroy;
end;

function TBisHttpServerHandlerDefaultWebModule.CheckParams(Params: TBisDataSet): Boolean;
begin
  Result:=false;
  if Assigned(Params) and Params.Active and not Params.IsEmpty then begin
    Result:=Assigned(Params.FindField(SFieldName)) and
            Assigned(Params.FindField(SFieldValue)) and
            Params.FindField(SFieldValue).IsBlob;
  end;
end;

function TBisHttpServerHandlerDefaultWebModule.GetSessionId(Params: TBisDataSet): Variant;
begin
  Result:=Null;
  if CheckParams(Params) and Params.Locate(SFieldName,SSessionId,[]) then begin
    Result:=Params.FieldByName(SFieldValue).Value;
    Params.Delete;
  end;
end;

function TBisHttpServerHandlerDefaultWebModule.GetCheckSum(Stream: TStream): String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Stream.Position:=0;
    Result:=Crypter.HashStream(Stream,haMD5,hfHEX);
  finally
    Crypter.Free;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Connect(Connection: TBisConnection);
begin
  if Assigned(Connection) then
    Connection.Connect;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Disconnect(Connection: TBisConnection);
begin
  if Assigned(Connection) then
    Connection.Disconnect;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Export(Connection: TBisConnection; Params: TBisDataSet);
var
  ExportType: TBisConnectionExportType;
  ExportParams: TBisConnectionExportParams;
  Value: String;
  Stream: TMemoryStream;
  StreamExport: TMemoryStream;
  Flag: Boolean;
begin
  if Connection.Connected and CheckParams(Params) then begin

    ExportParams:=TBisConnectionExportParams.Create;
    Stream:=TMemoryStream.Create;
    try
      ExportType:=etUnknown;
      if Params.Locate(SFieldName,SExportType,[]) then begin
        ExportType:=TBisConnectionExportType(VarToIntDef(Params.FieldByName(SFieldValue).Value,0));
        Params.Delete;
      end;

      Value:='';
      if Params.Locate(SFieldName,SValue,[]) then begin
        Value:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Flag:=false;
      if Params.Locate(SFieldName,SParams,[]) then begin
        StreamExport:=TMemoryStream.Create;
        try
          TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(StreamExport);
          StreamExport.Position:=0;
          ExportParams.LoadFromStream(StreamExport);
          Flag:=true;
        finally
          StreamExport.Free;
        end;
      end;

      if Flag then
        Connection.Export(ExportType,Value,Stream,ExportParams)
      else
        Connection.Export(ExportType,Value,Stream);

      if Params.Locate(SFieldName,SStream,[]) then begin
        Params.Edit;
        TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
        Params.Post;
      end;

    finally
      Stream.Free;
      ExportParams.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Import(Connection: TBisConnection; Params: TBisDataSet);
var
  ImportType: TBisConnectionImportType;
  Stream: TMemoryStream;
begin
  if Connection.Connected and CheckParams(Params) then begin
    Stream:=TMemoryStream.Create;
    try
      ImportType:=itUnknown;
      if Params.Locate(SFieldName,SImportType,[]) then begin
        ImportType:=TBisConnectionImportType(VarToIntDef(Params.FieldByName(SFieldValue).Value,0));
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SStream,[]) then begin
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Params.Delete;
      end;

      Connection.Import(ImportType,Stream);

    finally
      Stream.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.GetServerDate(Connection: TBisConnection; Params: TBisDataSet);
var
  Ret: TDateTime;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Ret:=Connection.GetServerDate;

    if Params.Locate(SFieldName,SResult,[]) then begin
      Params.Edit;
      Params.FieldByName(SFieldValue).AsString:=FormatDateTime(SDateTimeFormatEx,Ret);
      Params.Post;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Login(Connection: TBisConnection; Params: TBisDataSet; var SessionId: Variant);
var
  ApplicationId: Variant;
  UserName: String;
  Password: String;
  Stream: TMemoryStream;
  LoginParams: TBisConnectionLoginParams;
  Ret: Variant;
begin
  if Connection.Connected and CheckParams(Params) then begin

    LoginParams:=TBisConnectionLoginParams.Create;
    Stream:=TMemoryStream.Create;
    try
      ApplicationId:=Null;
      if Params.Locate(SFieldName,SApplicationId,[]) then begin
        ApplicationId:=Params.FieldByName(SFieldValue).Value;
        Params.Delete;
      end;

      UserName:='';
      if Params.Locate(SFieldName,SUserName,[]) then begin
        UserName:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Password:='';
      if Params.Locate(SFieldName,SPassword,[]) then begin
        Password:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SParams,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        LoginParams.LoadFromStream(Stream);
      end;

      Ret:=Connection.Login(ApplicationId,UserName,Password,LoginParams);

      SessionId:=Ret;

      if Params.Locate(SFieldName,SParams,[]) then begin
        LoginParams.SessionParams.Clear;
        LoginParams.IPList.Clear;
        Stream.Clear;
        LoginParams.SaveToStream(Stream);
        Stream.Position:=0;
        Params.Edit;
        TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
        Params.Post;
      end;

      if Params.Locate(SFieldName,SResult,[]) then begin
        Params.Edit;
        Params.FieldByName(SFieldValue).AsString:=Ret;
        Params.Post;
      end;
      
    finally
      Stream.Free;
      LoginParams.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Logout(Connection: TBisConnection; SessionId: Variant);
begin
  if Connection.Connected then begin
    Connection.Logout(SessionId);
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Check(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  ServerDate: TDateTime;
  Ret: Boolean;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Ret:=Connection.Check(SessionId,ServerDate);

    if Params.Locate(SFieldName,SResult,[]) then begin
      Params.Edit;
      Params.FieldByName(SFieldValue).AsString:=IntToStr(Integer(Ret));
      Params.Post;
    end;

    if Ret and Params.Locate(SFieldName,SServerDate,[]) then begin
      Params.Edit;
      Params.FieldByName(SFieldValue).AsString:=FormatDateTime(SDateTimeFormatEx,ServerDate);;
      Params.Post;
    end;

  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Update(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  UpdateParams: TBisConfig;
  Stream: TMemoryStream;
begin
  if Connection.Connected and CheckParams(Params) then begin

    UpdateParams:=TBisConfig.Create(nil);
    try

      if Params.Locate(SFieldName,SParams,[]) then begin
        Stream:=TMemoryStream.Create;
        try
          TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
          Stream.Position:=0;
          UpdateParams.LoadFromStream(Stream);
          Params.Delete;
        finally
          Stream.Free;
        end;
      end;

      Connection.Update(SessionId,UpdateParams);

    finally
      UpdateParams.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadProfile(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Profile: TBisProfile;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Profile:=TBisProfile.Create(nil);
    try

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Connection.LoadProfile(SessionId,Profile);

      if Params.Locate(SFieldName,SProfile,[]) then begin
        Stream:=TMemoryStream.Create;
        try
          Profile.SaveToStream(Stream);
          Stream.Position:=0;
          NewCheckSum:=GetCheckSum(Stream);
          if OldCheckSum<>NewCheckSum then begin
            Stream.Position:=0;
            Params.Edit;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          end;
        finally
          Stream.Free;
        end;
      end;

    finally
      Profile.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.SaveProfile(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Profile: TBisProfile;
  Stream: TMemoryStream;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Profile:=TBisProfile.Create(nil);
    try

      if Params.Locate(SFieldName,SProfile,[]) then begin
        Stream:=TMemoryStream.Create;
        try
          TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
          Stream.Position:=0;
          Profile.LoadFromStream(Stream);
          Params.Delete;
        finally
          Stream.Free;
        end;
      end;

      Connection.SaveProfile(SessionId,Profile);

    finally
      Profile.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.RefreshPermissions(Connection: TBisConnection; SessionId: Variant);
begin
  if Connection.Connected then begin
    Connection.RefreshPermissions(SessionId);
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadInterfaces(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Interfaces: TBisInterfaces;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Interfaces:=TBisInterfaces.Create(nil);
    try

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Connection.LoadInterfaces(SessionId,Interfaces);

      if Params.Locate(SFieldName,SInterfaces,[]) then begin
        Stream:=TMemoryStream.Create;
        try
          Interfaces.SaveToStream(Stream);
          Stream.Position:=0;
          NewCheckSum:=GetCheckSum(Stream);
          if OldCheckSum<>NewCheckSum then begin
            Stream.Position:=0;
            Params.Edit;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          end;
        finally
          Stream.Free;
        end;
      end;

    finally
      Interfaces.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.GetRecords(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Provider: TBisProvider;
  Stream: TMemoryStream;
  DataSet: TBisDataSet;
  NewPackage: TBisPackageParams;
  OldCheckSum,NewCheckSum: String;
begin
  if Assigned(Core) and CheckParams(Params) then begin

    DataSet:=TBisDataSet.Create(nil);
    Stream:=TMemoryStream.Create;
    try
      DataSet.InGetRecords:=true;

      DataSet.ProviderName:='';
      if Params.Locate(SFieldName,SProviderName,[]) then begin
        DataSet.ProviderName:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      DataSet.FetchCount:=0;
      if Params.Locate(SFieldName,SFetchCount,[]) then begin
        DataSet.FetchCount:=VarToIntDef(Params.FieldByName(SFieldValue).Value,0);
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SFieldNames,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.FieldNames.LoadFromStream(Stream);
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SFilterGroups,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.FilterGroups.LoadFromStream(Stream);
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SOrders,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.Orders.LoadFromStream(Stream);
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SParams,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.Params.LoadFromStream(Stream);
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SPackageBefore,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.PackageBefore.ReadDataOnlyInvisible:=true;
        DataSet.PackageBefore.LoadFromStream(Stream);
      end;

      if Params.Locate(SFieldName,SPackageAfter,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.PackageAfter.ReadDataOnlyInvisible:=true;
        DataSet.PackageAfter.LoadFromStream(Stream);
      end;

      if Params.Locate(SFieldName,SCollectionBefore,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.CollectionBefore.LoadFromStream(Stream);
      end;

      if Params.Locate(SFieldName,SCollectionAfter,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.CollectionAfter.LoadFromStream(Stream);
      end;

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Provider:=Core.ProviderModules.LockFindProvider(DataSet.ProviderName);

      if not Assigned(Provider) then begin
        if Connection.Connected then
          Connection.GetRecords(SessionId,DataSet);
      end else
        Provider.Handle(DataSet);

      if Params.Locate(SFieldName,SDataSet,[]) then begin
        if DataSet.Active then begin
          Stream.Clear;
          DataSet.SaveToStream(Stream);
          Stream.Position:=0;
          NewCheckSum:=GetCheckSum(Stream);
          if OldCheckSum<>NewCheckSum then begin
            Stream.Position:=0;
            Params.Edit;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          end;
        end;
      end;

      if Params.Locate(SFieldName,SServerRecordCount,[]) then begin
        Params.Edit;
        Params.FieldByName(SFieldValue).Value:=DataSet.ServerRecordCount;
        Params.Post;
      end;

      if Params.Locate(SFieldName,SPackageBefore,[]) then begin
        NewPackage:=TBisPackageParams.Create;
        try
          NewPackage.CopyFrom(DataSet.PackageBefore,true,false,[ptOutput,ptInputOutput,ptResult]);
          Stream.Clear;
          NewPackage.SaveToStream(Stream);
          Stream.Position:=0;
          Params.Edit;
          TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
          Params.Post;
        finally
          NewPackage.Free;
        end;
      end;

      if Params.Locate(SFieldName,SPackageAfter,[]) then begin
        NewPackage:=TBisPackageParams.Create;
        try
          NewPackage.CopyFrom(DataSet.PackageAfter,true,false,[ptOutput,ptInputOutput,ptResult]);
          Stream.Clear;
          NewPackage.SaveToStream(Stream);
          Stream.Position:=0;
          Params.Edit;
          TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
          Params.Post;
        finally
          NewPackage.Free;
        end;
      end;
      
      if Params.Locate(SFieldName,SCollectionBefore,[]) then begin
        Stream.Clear;
        DataSet.CollectionBefore.SaveToStream(Stream);
        Stream.Position:=0;
        Params.Edit;
        TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
        Params.Post;
      end;

      if Params.Locate(SFieldName,SCollectionAfter,[]) then begin
        Stream.Clear;
        DataSet.CollectionAfter.SaveToStream(Stream);
        Stream.Position:=0;
        Params.Edit;
        TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
        Params.Post;
      end;
      
    finally
      Stream.Free;
      DataSet.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Execute(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Provider: TBisProvider;
  Stream: TMemoryStream;
  DataSet: TBisDataSet;
  NewParams: TBisParams;
  OldCheckSum,NewCheckSum: String;
begin
  if Assigned(Core) and CheckParams(Params) then begin

    DataSet:=TBisDataSet.Create(nil);
    Stream:=TMemoryStream.Create;
    try
      DataSet.InExecute:=true;

      DataSet.ProviderName:='';
      if Params.Locate(SFieldName,SProviderName,[]) then begin
        DataSet.ProviderName:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      DataSet.FetchCount:=0;
      if Params.Locate(SFieldName,SFetchCount,[]) then begin
        DataSet.FetchCount:=VarToIntDef(Params.FieldByName(SFieldValue).Value,0);
        Params.Delete;
      end;

      DataSet.InGetRecords:=false;
      if Params.Locate(SFieldName,SInGetRecords,[]) then begin
        DataSet.InGetRecords:=Boolean(VarToIntDef(Params.FieldByName(SFieldValue).Value,0));
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SFieldNames,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.FieldNames.LoadFromStream(Stream);
        Params.Delete;
      end;

      if Params.Locate(SFieldName,SParams,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.Params.ReadDataOnlyInvisible:=true;
        DataSet.Params.LoadFromStream(Stream);
      end;

      if Params.Locate(SFieldName,SPackageBefore,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.PackageBefore.ReadDataOnlyInvisible:=true;
        DataSet.PackageBefore.LoadFromStream(Stream);
      end;

      if Params.Locate(SFieldName,SPackageAfter,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.PackageAfter.ReadDataOnlyInvisible:=true;
        DataSet.PackageAfter.LoadFromStream(Stream);
      end;

      if Params.Locate(SFieldName,SCollectionBefore,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.CollectionBefore.LoadFromStream(Stream);
      end;

      if Params.Locate(SFieldName,SCollectionAfter,[]) then begin
        Stream.Clear;
        TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
        Stream.Position:=0;
        DataSet.CollectionAfter.LoadFromStream(Stream);
      end;

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Provider:=Core.ProviderModules.LockFindProvider(DataSet.ProviderName);

      if not Assigned(Provider) then begin
        if Connection.Connected then
          Connection.Execute(SessionId,DataSet);
      end else
        Provider.Handle(DataSet);

      if Params.Locate(SFieldName,SDataSet,[]) then begin
        if DataSet.Active then begin
          Stream.Clear;
          DataSet.SaveToStream(Stream);
          Stream.Position:=0;
          NewCheckSum:=GetCheckSum(Stream);
          if OldCheckSum<>NewCheckSum then begin
            Stream.Position:=0;
            Params.Edit;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          end;
        end;
      end;

      if Params.Locate(SFieldName,SServerRecordCount,[]) then begin
        Params.Edit;
        Params.FieldByName(SFieldValue).Value:=DataSet.ServerRecordCount;
        Params.Post;
      end;

      if Params.Locate(SFieldName,SParams,[]) then begin
        NewParams:=TBisParams.Create;
        try
          NewParams.CopyFrom(DataSet.Params,true,false,[ptOutput,ptInputOutput,ptResult]);
          Stream.Clear;
          NewParams.SaveToStream(Stream);
          Stream.Position:=0;
          Params.Edit;
          TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
          Params.Post;
        finally
          NewParams.Free;
        end;
      end;

      if Params.Locate(SFieldName,SCollectionBefore,[]) then begin
        Stream.Clear;
        DataSet.CollectionBefore.SaveToStream(Stream);
        Stream.Position:=0;
        Params.Edit;
        TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
        Params.Post;
      end;

      if Params.Locate(SFieldName,SCollectionAfter,[]) then begin
        Stream.Clear;
        DataSet.CollectionAfter.SaveToStream(Stream);
        Stream.Position:=0;
        Params.Edit;
        TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
        Params.Post;
      end;
      
    finally
      Stream.Free;
      DataSet.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadMenus(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Menus: TBisMenus;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Menus:=TBisMenus.Create(nil);
    try

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Connection.LoadMenus(SessionId,Menus);

      if Params.Locate(SFieldName,SMenus,[]) then begin
        Stream:=TMemoryStream.Create;
        try
          Menus.SaveToStream(Stream);
          Stream.Position:=0;
          NewCheckSum:=GetCheckSum(Stream);
          if OldCheckSum<>NewCheckSum then begin
            Stream.Position:=0;
            Params.Edit;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          end;
        finally
          Stream.Free;
        end;
      end;
    finally
      Menus.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadTasks(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Tasks: TBisTasks;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
  Crypter: TBisCrypter;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Tasks:=TBisTasks.Create(nil);
    try

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Connection.LoadTasks(SessionId,Tasks);

      if Params.Locate(SFieldName,STasks,[]) then begin
        Stream:=TMemoryStream.Create;
        Crypter:=TBisCrypter.Create;
        try
          Tasks.SaveToStream(Stream);
          Stream.Position:=0;
          NewCheckSum:=Crypter.HashStream(Stream,haMD5,hfHEX);
          if OldCheckSum<>NewCheckSum then begin
            Stream.Position:=0;
            Params.Edit;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          end;
        finally
          Crypter.Free;
          Stream.Free;
        end;
      end;
    finally
      Tasks.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.SaveTask(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Task: TBisTask;
  Stream: TMemoryStream;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Task:=TBisTask.Create(nil);
    try

      if Params.Locate(SFieldName,STask,[]) then begin
        Stream:=TMemoryStream.Create;
        try
          TBlobField(Params.FieldByName(SFieldValue)).SaveToStream(Stream);
          Stream.Position:=0;
          Task.LoadFromStream(Stream);
          Params.Delete;
        finally
          Stream.Free;
        end;
      end;

      Connection.SaveTask(SessionId,Task);

    finally
      Task.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadAlarms(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  Alarms: TBisAlarms;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
  Crypter: TBisCrypter;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Alarms:=TBisAlarms.Create(nil);
    try

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Connection.LoadAlarms(SessionId,Alarms);

      if Params.Locate(SFieldName,SAlarms,[]) then begin
        Stream:=TMemoryStream.Create;
        Crypter:=TBisCrypter.Create;
        try
          Alarms.SaveToStream(Stream);
          Stream.Position:=0;
          NewCheckSum:=Crypter.HashStream(Stream,haMD5,hfHEX);
          if OldCheckSum<>NewCheckSum then begin
            Stream.Position:=0;
            Params.Edit;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          end;
        finally
          Crypter.Free;
          Stream.Free;
        end;
      end;
    finally
      Alarms.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadScript(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  ScriptId: Variant;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Stream:=TMemoryStream.Create;
    try

      ScriptId:=Null;
      if Params.Locate(SFieldName,SScriptId,[]) then begin
        ScriptId:=Params.FieldByName(SFieldValue).Value;
        Params.Delete;
      end;

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;
      
      Connection.LoadScript(SessionId,ScriptId,Stream);

      if Params.Locate(SFieldName,SStream,[]) then begin
        Stream.Position:=0;
        NewCheckSum:=GetCheckSum(Stream);
        if OldCheckSum<>NewCheckSum then begin
          Stream.Position:=0;
          Params.Edit;
          TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
          Params.Post;
        end;
      end;

    finally
      Stream.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadReport(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  ReportId: Variant;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Stream:=TMemoryStream.Create;
    try

      ReportId:=Null;
      if Params.Locate(SFieldName,SReportId,[]) then begin
        ReportId:=Params.FieldByName(SFieldValue).Value;
        Params.Delete;
      end;

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Connection.LoadReport(SessionId,ReportId,Stream);

      if Params.Locate(SFieldName,SStream,[]) then begin
        Stream.Position:=0;
        NewCheckSum:=GetCheckSum(Stream);
        if OldCheckSum<>NewCheckSum then begin
          Stream.Position:=0;
          Params.Edit;
          TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
          Params.Post;
        end;
      end;

    finally
      Stream.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.LoadDocument(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  DocumentId: Variant;
  Stream: TMemoryStream;
  OldCheckSum, NewCheckSum: String;
begin
  if Connection.Connected and CheckParams(Params) then begin

    Stream:=TMemoryStream.Create;
    try

      DocumentId:=Null;
      if Params.Locate(SFieldName,SDocumentId,[]) then begin
        DocumentId:=Params.FieldByName(SFieldValue).Value;
        Params.Delete;
      end;

      OldCheckSum:='';
      if Params.Locate(SFieldName,SCheckSum,[]) then begin
        OldCheckSum:=Params.FieldByName(SFieldValue).AsString;
        Params.Delete;
      end;

      Connection.LoadDocument(SessionId,DocumentId,Stream);

      if Params.Locate(SFieldName,SStream,[]) then begin
        Stream.Position:=0;
        NewCheckSum:=GetCheckSum(Stream);
        if OldCheckSum<>NewCheckSum then begin
          Stream.Position:=0;
          Params.Edit;
          TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
          Params.Post;
        end;
      end;

    finally
      Stream.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerDefaultWebModule.Cancel(Connection: TBisConnection; SessionId: Variant; Params: TBisDataSet);
var
  DataSetCheckSum: String;
begin
  if Connection.Connected and CheckParams(Params) then begin

    DataSetCheckSum:='';
    if Params.Locate(SFieldName,SDataSetCheckSum,[]) then begin
      DataSetCheckSum:=Params.FieldByName(SFieldValue).AsString;
      Params.Delete;
    end;

    Connection.Cancel(SessionId,DataSetCheckSum);

  end;
end;

function TBisHttpServerHandlerDefaultWebModule.GetConnection: TBisConnection;
begin
  Result:=nil;
  if Assigned(Core) and Assigned(Core.Connection) then
    Result:=Core.Connection;
end;

procedure TBisHttpServerHandlerDefaultWebModule.BisHttpServerHandlerDefaultWebModuleBusyAction(Sender: TObject;
                                                Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Connection: TBisConnection;
  Busy: Boolean;
begin
  Connection:=GetConnection;
  if Assigned(Connection) then begin
    Busy:=(Connection.SessionCount>FMaxSessionCount);
    Response.Content:=IntToStr(Integer(Busy));
    Handled:=true;
  end;
end;

function TBisHttpServerHandlerDefaultWebModule.CanConnectionRelay(Params: TBisDataSet; var Error: String): Boolean;

  function ConnectionAccept(Connection: TBisConnectionDataParam): Boolean;
  var
    UseCrypter: Boolean;
    CrypterAlgorithm: TBisCipherAlgorithm;
    CrypterMode: TBisCipherMode;
    CrypterKey: String;
    UseCompressor: Boolean;
  //  CompressorLevel: TCompressionLevel;

    function Decode(const S: String): String;
    begin
      if UseCrypter then
        Result:=CrypterDecodeString(CrypterKey,S,CrypterAlgorithm,CrypterMode)
      else
        Result:=S;
    end;

    function Decompress(const S: String): String;
    begin
      if UseCompressor then
        Result:=DecompressString(S)
      else
        Result:=S;
    end;

  var
    Url: String;
    Http: TIdHttp;
    S: String;
    UseProxy: Boolean;
    UserAgent: String;
    AuthUserName, AuthPassword: String;
  begin
    Result:=false;
    if Assigned(Connection) then begin
      Http:=TIdHttp.Create(nil);
      try
        with Connection.Params do begin
          Http.URL.Host:=AsString(SParamHost);
          Http.URL.Port:=AsString(SParamPort);
          Http.URL.Path:=AsString(SParamBusyPath);
          Http.URL.Protocol:=AsString(SParamProtocol);

          UseProxy:=AsBoolean(SParamUseProxy);
          Http.ProxyParams.ProxyServer:=AsString(SParamUseProxy);
          Http.ProxyParams.ProxyPort:=AsInteger(SParamProxyPort);
          Http.ProxyParams.ProxyUsername:=AsString(SParamProxyUserName);
          Http.ProxyParams.ProxyPassword:=AsString(SParamProxyPassword);

          UserAgent:=AsString(SParamUserAgent);

          UseCrypter:=AsBoolean(SParamUseCrypter);
          CrypterAlgorithm:=AsEnumeration(SParamCrypterAlgorithm,TypeInfo(TBisCipherAlgorithm),ca3Way);
          CrypterMode:=AsEnumeration(SParamCrypterMode,TypeInfo(TBisCipherMode),cmCTS);
          CrypterKey:=AsString(SParamCrypterKey);
          UseCompressor:=AsBoolean(SParamUseCompressor);
  //        CompressorLevel:=AsEnumeration(SParamCompressorLevel,TypeInfo(TCompressionLevel),clNone);

          AuthUserName:=AsString(SParamAuthUserName);
          AuthPassword:=AsString(SParamAuthPassword);
        end;

        if not UseProxy then
          Http.ProxyParams.Clear;

        if Trim(AuthUserName)<>'' then begin
          Http.Request.BasicAuthentication:=true;
          if not Assigned(Http.Request.Authentication) then
            Http.Request.Authentication:=TIdBasicAuthentication.Create;
          Http.Request.Authentication.Username:=AuthUserName;
          Http.Request.Authentication.Password:=AuthPassword;
        end;

        try
          Url:=Http.URL.GetFullURI([]);
        except
        end;

        if ServerExists(ResolveIP(Http.URL.Host),
                        StrToIntDef(Http.URL.Port,IdPORT_HTTP),
                        FConnectTimeOut) then begin

          Http.Request.UserAgent:=UserAgent;
          try
            S:=Http.Get(Url);
            if S<>'' then begin
              S:=Decode(S);
              S:=Decompress(S);
              Result:=not Boolean(StrToIntDef(S,1));
              if not Result then
                Error:=FSConnectionBusy;
            end;
          except
            On E: Exception do begin
              Error:=FSConnectionNotFound;
              FHandler.LoggerWrite(E.Message,ltError);
            end;
          end;
        end;

      finally
        Http.Free;
      end;
    end;
  end;

  function ConnectionExists(var Connection: TBisConnectionDataParam): Boolean;
  var
    i: Integer;
    Item: TBisConnectionDataParam;
  begin
    Result:=false;
    for i:=0 to FConnections.Count-1 do begin
      Item:=FConnections.Items[i];
      if Item.Enabled then begin
        if ConnectionAccept(Item) then begin
          Connection:=Item;
          Result:=true;
          break;
        end;
      end;
    end;
  end;

var
  Stream: TMemoryStream;
  Connection: TBisConnectionDataParam;
  DataParams: TBisDataValueParams;
begin
  Result:=not FConnections.Empty;
  if Result and CheckParams(Params) then begin
    if Params.Locate(SFieldName,SConnection,[]) then begin
      Stream:=TMemoryStream.Create;
      try
        Result:=ConnectionExists(Connection);
        if Result then begin
          DataParams:=TBisDataValueParams.Create;
          try
            DataParams.CopyFrom(Connection.Params);
            DataParams.Add(SCaption,Connection.Caption);
            DataParams.SaveToStream(Stream);
            Params.Edit;
            Stream.Position:=0;
            TBlobField(Params.FieldByName(SFieldValue)).LoadFromStream(Stream);
            Params.Post;
          finally
            DataParams.Free;
          end;
        end else
          Error:=iff(Trim(Error)='',FSConnectionNotFound,Error);
      finally
        Stream.Free;
      end;
    end;
  end else
    Error:=FSConnectionNotFound;
end;

procedure TBisHttpServerHandlerDefaultWebModule.BisHttpServerHandlerDefaultWebModuleDefaultAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Connection: TBisConnection;

  function BuildRandomString: String;
  begin
    Result:=RandomString(FRandomStringSize);
  end;

  procedure DefaultConnectionUpdate;
  begin
    try
      DefaultUpdate(nil);
    except
      On E: Exception do
//        FHandler.LoggerWrite(E.Message,ltError);
    end;
  end;

var
  Reader: TReader;
  Writer: TWriter;
  TempStream: TMemoryStream;
  RequestStream: TMemoryStream;
  Format: TBisHttpConnectionFormat;
  Method: TBisHttpConnectionMethodType;
  ASize: Int64;
  Params: TBisDataSet;
  RetType: TBisHttpConnectionReturnType;
  Error: String;
  SessionId: Variant;
  NeedConnect: Boolean;
begin
  RequestStream:=TMemoryStream.Create;
  TempStream:=TMemoryStream.Create;
  Params:=TBisDataSet.Create(nil);
  try
    RequestStream.WriteBuffer(Pointer(Request.Content)^,Length(Request.Content));
    RequestStream.Position:=0;

    if RequestStream.Size>0 then begin

      Error:='';
      
      Reader:=TReader.Create(RequestStream,ReaderBufferSize);
      try
        Format:=TBisHttpConnectionFormat(Reader.ReadInteger);
        Method:=TBisHttpConnectionMethodType(Reader.ReadInteger);
        Reader.ReadString; // read random string;
        ASize:=Reader.ReadInt64;
      finally
        Reader.Free;
      end;

      if ASize>0 then begin
        TempStream.CopyFrom(RequestStream,ASize);
        TempStream.Position:=0;
      end;

      if TempStream.Size>0 then begin
        Params.LoadFromStream(TempStream);
        Params.Open;
      end;

      RetType:=rtSuccess;
      try

        SessionId:=GetSessionId(Params);
        Connection:=GetConnection;

     {   if not Assigned(Connection) then
          DefaultConnectionUpdate; } 

        if Assigned(Connection) then begin
          case Method of
            cmConnect: begin
              Connection.CheckSessions;
              NeedConnect:=VarIsNull(SessionId);
              if NeedConnect and (Connection.SessionCount>FMaxSessionCount) then begin
                if CanConnectionRelay(Params,Error) then begin
                  RetType:=rtRelay;
                  NeedConnect:=false;
                end else
                  raise Exception.Create(Error);
              end;
              if NeedConnect then
                Connect(Connection);
            end;
            cmDisconnect: Disconnect(Connection);
            cmImport: Import(Connection,Params);
            cmExport: Export(Connection,Params);
            cmGetServerDate: GetServerDate(Connection,Params);
            cmLogin: Login(Connection,Params,SessionId);
            // by Session
            cmLogout: Logout(Connection,SessionId);
            cmCheck: Check(Connection,SessionId,Params);
            cmUpdate: Update(Connection,SessionId,Params);
            cmLoadProfile: LoadProfile(Connection,SessionId,Params);
            cmSaveProfile: SaveProfile(Connection,SessionId,Params);
            cmRefreshPermissions: RefreshPermissions(Connection,SessionId);
            cmLoadInterfaces: LoadInterfaces(Connection,SessionId,Params);
            cmGetRecords: GetRecords(Connection,SessionId,Params);
            cmExecute: Execute(Connection,SessionId,Params);
            cmLoadMenus: LoadMenus(Connection,SessionId,Params);
            cmLoadTasks: LoadTasks(Connection,SessionId,Params);
            cmSaveTask: SaveTask(Connection,SessionId,Params);
            cmLoadAlarms: LoadAlarms(Connection,SessionId,Params);
            cmLoadScript: LoadScript(Connection,SessionId,Params);
            cmLoadReport: LoadReport(Connection,SessionId,Params);
            cmLoadDocument: LoadDocument(Connection,SessionId,Params);
            cmCancel: Cancel(Connection,SessionId,Params);
          end;

          DefaultConnectionUpdate;

          if RetType=rtError then
            RetType:=rtSuccess;

        end else begin
          if (Method=cmConnect) then begin
            if CanConnectionRelay(Params,Error) then
              RetType:=rtRelay
            else
              raise Exception.Create(Error);
          end else
            raise Exception.Create(FSModeNotSupported);
        end;

      except
        On E: Exception do begin
          RetType:=rtError;
          Error:=E.Message;
        end;
      end;

      TempStream.Clear;
      if Params.Active then begin
        case Format of
          cfRaw: Params.SaveToStream(TempStream);
          cfXml: ;
        end;
        TempStream.Position:=0;
      end;

      if Assigned(Response.ContentStream) then begin
        Writer:=TWriter.Create(Response.ContentStream,WriterBufferSize);
        try
          Writer.WriteInteger(Integer(RetType));
          Writer.WriteString(Error);
          Writer.WriteString(BuildRandomString);
          Writer.WriteInteger(TempStream.Size);
        finally
          Writer.Free;
        end;
      end;

      if TempStream.Size>0 then begin
        Response.ContentStream.CopyFrom(TempStream,TempStream.Size);
        Response.ContentStream.Position:=0;
      end;

      Handled:=true;
    end;
  finally
    Params.Free;
    TempStream.Free;
    RequestStream.Free;
  end;
end;

end.
