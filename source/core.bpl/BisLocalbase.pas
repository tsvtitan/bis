unit BisLocalbase;

interface

uses Classes, SysUtils,
     BisObject, BisLogger, BisDataSet, BisConfig, BisCrypter, 
     BisCmdLine;

type

  TBisLocalBase=class(TBisObject)
  private
    FDataSet: TBisDataSet;
    FLogger: TBisLogger;
    FConfig: TBisConfig;
    FCmdLine: TBisCmdLine;
    FFileName: String;
    FCrypterEnabled: Boolean;
    FCrypterKey: String;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FExceptionEnabled: Boolean;
    FEnabled: Boolean;

    FSLoadFromFileSuccess: String;
    FSLoadFromFileFailed: String;
    FSSaveToFileSuccess: String;
    FSSaveToFileFailed: String;

    function GetBaseLoaded: Boolean;
    function GetReadOnly: Boolean;
    function DecodeValue(ParamName: String; Value: String): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Done; override;
    procedure Load;
    procedure Save;
    procedure LoadFromFile(const FileName: String);
    procedure SaveToFile(const FileName: String);
    procedure CreateEmpty;
    function ParamExists(ParamName: String): Boolean;
    function ReadParam(ParamName: String; var Value: String; UseCrypter: Boolean=false): Boolean; overload;
    function ReadParam(ParamName: String; Stream: TStream; UseCrypter: Boolean=false): Boolean; overload;
    procedure WriteParam(const ParamName, Value: String); overload;
    procedure WriteParam(const ParamName: String; Stream: TStream); overload;
    procedure LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation);
    function ReadToConfig(ParamName: String; AConfig: TBisConfig; UseCrypter: Boolean=false): Boolean;
    procedure WriteFromConfig(ParamName: String; AConfig: TBisConfig);
    procedure SetFile(const FileName: String);
    procedure SetParamValue(const Param,Value: String; WithSave: Boolean=true);

    property Logger: TBisLogger read FLogger write FLogger;
    property Config: TBisConfig read FConfig write FConfig;
    property CmdLine: TBisCmdLine read FCmdLine write FCmdLine;
    property FileName: String read FFileName;
    property BaseLoaded: Boolean read GetBaseLoaded;
    property DataSet: TBisDataSet read FDataSet;
    property CrypterEnabled: Boolean read FCrypterEnabled write FCrypterEnabled;
    property CrypterKey: String read FCrypterKey write FCrypterKey;
    property CrypterAlgorithm: TBisCipherAlgorithm read FCrypterAlgorithm write FCrypterAlgorithm;
    property CrypterMode: TBisCipherMode read FCrypterMode write FCrypterMode;
    property ExceptionEnabled: Boolean read FExceptionEnabled write FExceptionEnabled;
    property Enabled: Boolean read FEnabled write FEnabled;
    property ReadOnly: Boolean read GetReadOnly;

  published

  end;

implementation

uses DB, StrUtils,
     BisCryptUtils,
     BisUtils, BisBase64, BisConsts;

{ TBisLocalBase }

constructor TBisLocalBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSet:=TBisDataSet.Create(nil);

  FEnabled:=false;
  FCrypterEnabled:=true;

  FSLoadFromFileSuccess:='Загрузка из файла %s прошла успешно';
  FSLoadFromFileFailed:='Загрузка из файла %s прошло с ошибкой: %s';
  FSSaveToFileSuccess:='Сохранение в файл %s прошло успешно';
  FSSaveToFileFailed:='Сохранение в файл %s прошло с ошибкой: %s';

end;

destructor TBisLocalBase.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

procedure TBisLocalBase.Init;
var
  Path: string;
begin
  inherited Init;
  FFileName:=PrepareFileName(FCmdLine,ChangeFileExt(FCmdLine.FileName,SBisExtension),SCmdParamBase,FEnabled);
  if Assigned(FConfig) then begin
    FFileName:=FConfig.Read(ObjectName,SFileName,FFileName);

    Path:=ExtractFilePath(FFileName);
    if (Trim(Path)='') then
      FFileName:=ExtractFilePath(CmdLine.FileName)+ExtractFileName(FFileName)
    else
      FFileName:=ExpandFileNameEx(FFileName);
      
    FEnabled:=FConfig.Read(ObjectName,SEnabled,FEnabled);
    FSLoadFromFileSuccess:=FConfig.Read(ObjectName,SLocalBaseLoadFromFileSuccess,FSLoadFromFileSuccess);
    FSLoadFromFileFailed:=FConfig.Read(ObjectName,SLocalBaseLoadFromFileFailed,FSLoadFromFileFailed);
    FSSaveToFileSuccess:=FConfig.Read(ObjectName,SLocalBaseSaveToFileSuccess,FSSaveToFileSuccess);
    FSSaveToFileFailed:=FConfig.Read(ObjectName,SLocalBaseSaveToFileFailed,FSSaveToFileFailed);
  end;
end;

procedure TBisLocalBase.Done;
begin
  inherited Done;
end;

procedure TBisLocalBase.Load;
begin
  if FEnabled then
    LoadFromFile(FFileName);
end;

procedure TBisLocalBase.Save;
begin
  if FEnabled then
    SaveToFile(FFileName);
end;

procedure TBisLocalBase.LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation);
begin
  if Assigned(FLogger) then
    FLogger.Write(Message,LogType,ObjectName);
end;

procedure TBisLocalBase.LoadFromFile(const FileName: String);
var
  FS: TFileStream;
  MS: TMemoryStream;
begin
  try
    FS:=nil;
    MS:=TMemoryStream.Create;
    try
      FS:=TFileStream.Create(FileName,fmOpenRead or fmShareDenyNone);
      if FCrypterEnabled then begin
        CrypterDecodeStream(CrypterKey,FS,MS,CrypterAlgorithm,CrypterMode);
        MS.Position:=0;
        FDataSet.LoadFromStream(MS);
      end else begin
        FS.Position:=0;
        FDataSet.LoadFromStream(FS);
      end;
      if True then
      
      LoggerWrite(FormatEx(FSLoadFromFileSuccess,[FileName]));
    finally
      MS.Free;
      FS.Free;
    end;
  except
    on E: Exception do begin
      LoggerWrite(Formatex(FSLoadFromFileFailed,[FileName,E.Message]),ltError);
      if FExceptionEnabled then raise;
    end;
  end;
end;

procedure TBisLocalBase.SaveToFile(const FileName: String);
var
  FS: TFileStream;
  MS: TMemoryStream;
begin
  try
    FS:=nil;
    MS:=TMemoryStream.Create;
    try
      FS:=TFileStream.Create(FileName,fmCreate or fmOpenWrite);
      if FCrypterEnabled then begin
        FS.Position:=0;
        FDataSet.SaveToStream(MS);
        MS.Position:=0;
        CrypterEncodeStream(CrypterKey,MS,FS,CrypterAlgorithm,CrypterMode);
      end else begin
        FDataSet.SaveToStream(FS);
      end;
    finally
      MS.Free;
      FS.Free;
    end;
    LoggerWrite(FormatEx(FSSaveToFileSuccess,[FileName]));
  except
    on E: Exception do begin
      LoggerWrite(FormatEx(FSSaveToFileFailed,[FileName,E.Message]),ltError);
      if FExceptionEnabled then raise;
    end;
  end;
end;

procedure TBisLocalBase.CreateEmpty;
begin
  FDataSet.Close;
  with FDataSet.FieldDefs do begin
    Clear;
    Add(SFieldName,ftString,MaxFieldNameSize);
    Add(SFieldDescription,ftString,MaxFieldDescriptionSize);
    Add(SFieldType,ftInteger);
    Add(SFieldValue,ftBlob);
  end;
  FDataSet.CreateTable;
  FDataSet.Open;
end;

function TBisLocalBase.ParamExists(ParamName: String): Boolean;
begin
  Result:=BaseLoaded and
          FDataSet.Locate(SFieldName,ParamName,[loCaseInsensitive]);
end;

function TBisLocalBase.DecodeValue(ParamName: String; Value: String): String;
var
  Crypter: TBisCrypter;
  S: String;
  Key: String;
begin
  Crypter:=TBisCrypter.Create;
  try
    S:=Base64ToStr(Value);
    Key:=FCrypterKey+MD5(ParamName);
    Result:=Crypter.DecodeString(Key,S,FCrypterAlgorithm,FCrypterMode);
  finally
    Crypter.Free;
  end;
end;

function TBisLocalBase.ReadParam(ParamName: String; var Value: String; UseCrypter: Boolean=false): Boolean;
var
  S: String;
begin
  Result:=false;
  if BaseLoaded then
    if FDataSet.Locate(SFieldName,ParamName,[loCaseInsensitive]) then begin
      Value:=FDataSet.FieldByName(SFieldValue).AsString;
      if UseCrypter then begin
        S:=DecodeValue(ParamName,Value);
        Result:=S<>Value;
        Value:=S;
      end else
        Result:=True;
    end;
end;

function TBisLocalBase.ReadParam(ParamName: String; Stream: TStream; UseCrypter: Boolean=false): Boolean;
var
  OldPos: Int64;
begin
  Result:=false;
  if Assigned(Stream) and BaseLoaded then
    if FDataSet.Locate(SFieldName,ParamName,[loCaseInsensitive]) then begin
      OldPos:=Stream.Position;
      try
        TBlobField(FDataSet.FieldByName(SFieldValue)).SaveToStream(Stream);
        Result:=true;
      finally
        Stream.Position:=OldPos;
      end;
    end;
end;

procedure TBisLocalBase.WriteParam(const ParamName, Value: String);
begin
  if BaseLoaded then
    if FDataSet.Locate(SFieldName,ParamName,[loCaseInsensitive]) then begin
      FDataSet.Edit;
      try
        try
          FDataSet.FieldByName(SFieldValue).Value:=Value;
        except
          FDataSet.Cancel;
        end;
      finally
        FDataSet.Post;
      end;
    end;
end;

procedure TBisLocalBase.WriteParam(const ParamName: String; Stream: TStream);
begin
  if Assigned(Stream) and BaseLoaded then
    if FDataSet.Locate(SFieldName,ParamName,[loCaseInsensitive]) then begin
      FDataSet.Edit;
      try
        try
          TBlobField(FDataSet.FieldByName(SFieldValue)).LoadFromStream(Stream);
        except
          FDataSet.Cancel;
        end;
      finally
        FDataSet.Post;
      end;
    end;
end;

function TBisLocalBase.GetBaseLoaded: Boolean;
begin
  Result:=FDataSet.Active;
end;

function TBisLocalBase.GetReadOnly: Boolean;
var
  H: THandle;
begin
  Result:=false;
  H:=FileOpen(FFileName,fmCreate or fmOpenWrite);
  if H<>0 then begin
    FileClose(H);
    Result:=True;
  end;
end;

function TBisLocalBase.ReadToConfig(ParamName: String; AConfig: TBisConfig; UseCrypter: Boolean=false): Boolean;
var
  S: String;
begin
  Result:=false;
  if Assigned(AConfig) then begin
    Result:=ReadParam(ParamName,S,UseCrypter);
    if Result then begin
      AConfig.SetSectionText(ParamName,S);
    end;
  end;
end;

procedure TBisLocalBase.WriteFromConfig(ParamName: String; AConfig: TBisConfig);
begin
  if Assigned(AConfig) then begin
    WriteParam(ParamName,AConfig.GetSectionText(ParamName));
  end;
end;

procedure TBisLocalBase.SetParamValue(const Param, Value: String; WithSave: Boolean=true);

  function BuildStream(Params: TStringList; OldValue,NewValue: TMemoryStream): Boolean;

    procedure LoadDataSet(DataSet: TBisDataSet);
    var
      Old: Int64;
    begin
      Old:=OldValue.Position;
      try
        try
          OldValue.Position:=0;
          DataSet.LoadFromStream(OldValue);
        except
        end;
      finally
        OldValue.Position:=Old;
      end;
    end;

    function GetNeeds(const S: String; var S1,S2,S3: String): Boolean;
    var
      Str: TStringList;
    begin
      Str:=TStringList.Create;
      try
        Result:=false;
        GetStringsByString(S,'|',Str);
        if Str.Count>=3 then begin
          S1:=Trim(Str[0]);
          S2:=Trim(Str[1]);
          S3:=Trim(Str[2]);
          Result:=(S1<>'') and (S2<>'') and (S3<>'');
        end;
      finally
        Str.Free;
      end;
    end;

  var
    DataSet: TBisDataSet;
    S1,S2,S3: String;
    FieldSearch: TField;
    FieldValue: TField;
    OStream: TMemoryStream;
  begin
    Result:=false;
    if (Params.Count>0) then begin
      if ParseBetween(Params[0],'[',']',S1) and GetNeeds(S1,S1,S2,S3) then begin
        DataSet:=TBisDataSet.Create(nil);
        try
          LoadDataSet(DataSet);
          if DataSet.Active then begin
            FieldSearch:=DataSet.FindField(S1);
            if Assigned(FieldSearch) then begin
              if DataSet.Locate(FieldSearch.FieldName,S2,[loCaseInsensitive]) then begin
                FieldValue:=DataSet.FindField(S3);
                if Assigned(FieldValue) then begin
                  Params.Delete(0);
                  if Params.Count=0 then begin
                    DataSet.Edit;
                    SetLength(S1,NewValue.Size);
                    NewValue.Read(Pointer(S1)^,Length(S1));
                    FieldValue.AsString:=S1;
                    DataSet.Post;
                    NewValue.Clear;
                    DataSet.SaveToStream(NewValue);
                    Result:=true;
                  end else begin
                    OStream:=TMemoryStream.Create;
                    try
                      S1:=FieldValue.AsString;
                      OStream.Write(Pointer(S1)^,Length(S1));
                      OStream.Position:=0;
                      Result:=BuildStream(Params,OStream,NewValue);
                      if Result then begin
                        DataSet.Edit;
                        SetLength(S1,NewValue.Size);
                        NewValue.Position:=0;
                        NewValue.Read(Pointer(S1)^,Length(S1));
                        FieldValue.AsString:=S1;
                        DataSet.Post;
                        NewValue.Clear;
                        DataSet.SaveToStream(NewValue);
                     end;
                    finally
                      OStream.Free;
                    end;
                  end;
                end;
              end;
            end;
          end;
        finally
          DataSet.Free;
        end;
      end;
    end;
  end;

var
  S: String;
  Params: TStringList;
  OldValue,NewValue: TMemoryStream;
  FirstParam: String;
  Flag: Boolean;
begin
  Params:=TStringList.Create;
  OldValue:=TMemoryStream.Create;
  try
    GetStringsByString(Param,'\',Params);
    if (Params.Count>0) and ReadParam(Params[0],OldValue) then begin
      NewValue:=TMemoryStream.Create;
      try
        FirstParam:=Params[0];

        S:=ExpandFileNameEx(Value);
        if FileExists(S) then
          NewValue.LoadFromFile(S)
        else
          NewValue.Write(Pointer(Value)^,Length(Value));

        Flag:=true;  
        if Params.Count>1 then begin
          Params.Delete(0);
          NewValue.Position:=0;
          OldValue.Position:=0;
          Flag:=BuildStream(Params,OldValue,NewValue);
        end;

        if Flag then begin
          NewValue.Position:=0;
          WriteParam(FirstParam,NewValue);
        end;

      finally
        NewValue.Free;
      end;
    end;

    if WithSave then
      Save;

  finally
    OldValue.Free;
    Params.Free;
  end;
end;

procedure TBisLocalBase.SetFile(const FileName: String);
var
  Str: TStringList;
  i: Integer;
  P,V: String;
begin
  Str:=TStringList.Create;
  try
    Str.LoadFromFile(FileName);
    for i:=0 to Str.Count-1 do begin
      P:=Str.Names[i];
      V:=Str.ValueFromIndex[i];
      SetParamValue(P,V,i=(Str.Count-1));
    end;
  finally
    Str.Free;
  end;
end;


end.
