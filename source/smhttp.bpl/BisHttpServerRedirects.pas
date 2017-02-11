unit BisHttpServerRedirects;

interface

uses Classes, Contnrs,
     HTTPApp, ZLib, DB,
     BisObject, BisCoreObjects, BisCrypter, BisDataSet;

type
  TBisHttpServerRedirectInParams=class(TObject)
  private
    FPath: String;
    FHost: String;
    FUseCrypter: Boolean;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FCrypterKey: String;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
  public
    property Host: String read FHost write FHost;
    property Path: String read FPath write FPath;
    property UseCrypter: Boolean read FUseCrypter write FUseCrypter;
    property CrypterAlgorithm: TBisCipherAlgorithm read FCrypterAlgorithm write FCrypterAlgorithm;
    property CrypterMode: TBisCipherMode read FCrypterMode write FCrypterMode;
    property CrypterKey: String read FCrypterKey write FCrypterKey;
    property UseCompressor: Boolean read FUseCompressor write FUseCompressor;
    property CompressorLevel: TCompressionLevel read FCompressorLevel write FCompressorLevel;
  end;

  TBisHttpServerRedirectOutParams=class(TObject)
  private
    FPath: String;
    FHost: String;
    FUseCrypter: Boolean;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FCrypterKey: String;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
    FPort: Integer;
    FProtocol: String;
    FProxyPort: Integer;
    FProxyPassword: String;
    FProxyHost: String;
    FProxyUserName: String;
    FUseProxy: Boolean;
    FAuthUserName: String;
    FAuthPassword: String;
  public
    property Host: String read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property Path: String read FPath write FPath;
    property Protocol: String read FProtocol write FProtocol;
    property UseProxy: Boolean read FUseProxy write FUseProxy;
    property ProxyHost: String read FProxyHost write FProxyHost;
    property ProxyPort: Integer read FProxyPort write FProxyPort;
    property ProxyUserName: String read FProxyUserName write FProxyUserName;
    property ProxyPassword: String read FProxyPassword write FProxyPassword;
    property UseCrypter: Boolean read FUseCrypter write FUseCrypter;
    property CrypterAlgorithm: TBisCipherAlgorithm read FCrypterAlgorithm write FCrypterAlgorithm;
    property CrypterMode: TBisCipherMode read FCrypterMode write FCrypterMode;
    property CrypterKey: String read FCrypterKey write FCrypterKey;
    property UseCompressor: Boolean read FUseCompressor write FUseCompressor;
    property CompressorLevel: TCompressionLevel read FCompressorLevel write FCompressorLevel;
    property AuthUserName: String read FAuthUserName write FAuthUserName;
    property AuthPassword: String read FAuthPassword write FAuthPassword;  
  end;

  TBisHttpServerRedirectMode=(rmQuery,rmRedirect);

  TBisHttpServerRedirect=class(TBisCoreObject)
  private
    FEnabled: Boolean;
    FInParams: TBisHttpServerRedirectInParams;
    FOutParams: TBisHttpServerRedirectOutParams;
    FInTable: TBisDataSet;
    FOutTable: TBisDataSet;
    FMode: TBisHttpServerRedirectMode;
  protected
    property InTable: TBisDataSet read FInTable;
    property OutTable: TBisDataSet read FOutTable;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    property Enabled: Boolean read FEnabled write FEnabled;
    property Mode: TBisHttpServerRedirectMode read FMode write FMode;

    property InParams: TBisHttpServerRedirectInParams read FInParams;
    property OutParams: TBisHttpServerRedirectOutParams read FOutParams;
  end;

  TBisHttpServerRedirectClass=class of TBisHttpServerRedirect;

  TBisHttpServerRedirects=class(TBisCoreObjects)
  private
    FTable: TBisDataSet;
    function GetItems(Index: Integer): TBisHttpServerRedirect;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function AddRedirect(ARedirect: TBisHttpServerRedirect): Boolean;
    function FindRedirect(const Host, Document: String; var OutPath,OutScript: string): TBisHttpServerRedirect;

    property Items[Index: Integer]: TBisHttpServerRedirect read GetItems;

    property Table: TBisDataSet read FTable; 
  end;


implementation

uses SysUtils,
     IdAssignedNumbers,
     BisUtils, BisHttpServerConsts, BisConsts;



{ TBisHttpServerRedirect }

constructor TBisHttpServerRedirect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInParams:=TBisHttpServerRedirectInParams.Create;
  FOutParams:=TBisHttpServerRedirectOutParams.Create;
  FInTable:=TBisDataSet.Create(Self);
  FOutTable:=TBisDataSet.Create(Self);
end;

destructor TBisHttpServerRedirect.Destroy;
begin
  FOutTable.Free;
  FInTable.Free;
  FOutParams.Free;
  FInParams.Free;
  inherited Destroy;
end;

procedure TBisHttpServerRedirect.Init;
var
  AName: String;
  AValue: String;
begin
  inherited Init;

  if FInTable.Active and not FInTable.Empty then begin
    FInTable.First;
    while not FInTable.Eof do begin
      AName:=FInTable.FieldByName(SFieldName).AsString;
      AValue:=FInTable.FieldByName(SFieldValue).AsString;

      if AnsiSameText(AName,SParamHost) then FInParams.Host:=AValue;
      if AnsiSameText(AName,SParamPath) then FInParams.Path:=AValue;
      if AnsiSameText(AName,SParamUseCrypter) then FInParams.UseCrypter:=Boolean(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterAlgorithm) then FInParams.CrypterAlgorithm:=TBisCipherAlgorithm(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterMode) then FInParams.CrypterMode:=TBisCipherMode(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterKey) then FInParams.CrypterKey:=AValue;
      if AnsiSameText(AName,SParamUseCompressor) then FInParams.UseCompressor:=Boolean(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCompressorLevel) then FInParams.CompressorLevel:=TCompressionLevel(StrToIntDef(AValue,0));

      FInTable.Next;
    end;
  end;

  if FOutTable.Active and not FOutTable.Empty then begin
    FOutTable.First;
    while not FOutTable.Eof do begin
      AName:=FOutTable.FieldByName(SFieldName).AsString;
      AValue:=FOutTable.FieldByName(SFieldValue).AsString;

      if AnsiSameText(AName,SParamHost) then FOutParams.Host:=AValue;
      if AnsiSameText(AName,SParamPort) then FOutParams.Port:=StrToIntDef(AValue,IdPORT_HTTP);
      if AnsiSameText(AName,SParamPath) then FOutParams.Path:=AValue;
      if AnsiSameText(AName,SParamProtocol) then FOutParams.Protocol:=AValue;
      if AnsiSameText(AName,SParamUseProxy) then FOutParams.UseProxy:=Boolean(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamProxyHost) then FOutParams.ProxyHost:=AValue;
      if AnsiSameText(AName,SParamProxyPort) then FOutParams.ProxyPort:=StrToIntDef(AValue,IdPORT_HTTP);
      if AnsiSameText(AName,SParamProxyUserName) then FOutParams.ProxyUserName:=AValue;
      if AnsiSameText(AName,SParamProxyPassword) then FOutParams.ProxyPassword:=AValue;
      if AnsiSameText(AName,SParamUseCrypter) then FOutParams.UseCrypter:=Boolean(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterAlgorithm) then FOutParams.CrypterAlgorithm:=TBisCipherAlgorithm(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterMode) then FOutParams.CrypterMode:=TBisCipherMode(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterKey) then FOutParams.CrypterKey:=AValue;
      if AnsiSameText(AName,SParamUseCompressor) then FOutParams.UseCompressor:=Boolean(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCompressorLevel) then FOutParams.CompressorLevel:=TCompressionLevel(StrToIntDef(AValue,0));

      if AnsiSameText(AName,SParamAuthUserName) then FOutParams.AuthUserName:=AValue;
      if AnsiSameText(AName,SParamAuthPassword) then FOutParams.AuthPassword:=AValue;

      FOutTable.Next;
    end;
  end;
  
end;

{ TBisHttpServerRedirects }

constructor TBisHttpServerRedirects.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTable:=TBisDataSet.Create(Self);
end;

destructor TBisHttpServerRedirects.Destroy;
begin
  FTable.Free;
  inherited Destroy;
end;

function TBisHttpServerRedirects.GetItems(Index: Integer): TBisHttpServerRedirect;
begin
  Result:=TBisHttpServerRedirect(inherited Items[Index]);
end;

function TBisHttpServerRedirects.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisHttpServerRedirect;
end;

procedure TBisHttpServerRedirects.Init;
var
  Redirect: TBisHttpServerRedirect;
  Stream: TMemoryStream;
begin
  inherited Init;

  if FTable.Active and not FTable.IsEmpty then begin
    Stream:=TMemoryStream.Create;
    try
      FTable.First;
      while not FTable.Eof do begin
        Redirect:=TBisHttpServerRedirect.Create(Self);
        Redirect.ObjectName:=FTable.FieldByName(SFieldName).AsString+Redirect.ObjectName;
        if AddRedirect(Redirect) then begin
          Redirect.Description:=FTable.FieldByName(SFieldDescription).AsString;
          Redirect.Enabled:=Boolean(FTable.FieldByName(SFieldEnabled).AsInteger);
          Redirect.Mode:=TBisHttpServerRedirectMode(FTable.FieldByName(SFieldMode).AsInteger);
          Stream.Clear;
          TBlobField(FTable.FieldByName(SFieldInParams)).SaveToStream(Stream);
          if Stream.Size>0 then begin
            Stream.Position:=0;
            Redirect.InTable.Close;
            Redirect.InTable.LoadFromStream(Stream);
            Redirect.InTable.Open;
          end;
          Stream.Clear;
          TBlobField(FTable.FieldByName(SFieldOutParams)).SaveToStream(Stream);
          if Stream.Size>0 then begin
            Stream.Position:=0;
            Redirect.OutTable.Close;
            Redirect.OutTable.LoadFromStream(Stream);
            Redirect.OutTable.Open;
          end;
          Redirect.Init;
        end else
          Redirect.Free;
        FTable.Next;
      end;
    finally
      Stream.Free;
    end;
  end;

end;

function TBisHttpServerRedirects.AddRedirect(ARedirect: TBisHttpServerRedirect): Boolean;
begin
  Result:=false;
  if not Assigned(Find(ARedirect.ObjectName)) then begin
    AddObject(ARedirect);
    Result:=true;
  end;
end;

function TBisHttpServerRedirects.FindRedirect(const Host, Document: String; var OutPath, OutScript: string): TBisHttpServerRedirect;
    
  function CheckPath(RedirectPath: string): Boolean;
  var
    Apos: Integer;
    S1,S2: string;
    Path: string;
  begin
    Result:=false;
    S1:=AnsiLowerCase(RedirectPath);
    S2:=AnsiLowerCase(Document);
    Apos:=AnsiPos(S1,S2);
    if Apos=1 then begin
      if Length(S1)<>Length(S2) then begin
        if Length(S1)<Length(S2) then begin
          Path:=Copy(Document,Length(RedirectPath)+1,Length(Document));
          if Length(Path)>0 then begin
            if Path[1]=SSlash then begin
              OutScript:=iff(Path=SSlash,'',Path);
              OutPath:=RedirectPath;
              Result:=true;
            end else begin
          {    OutScript:=Path;
              OutPath:=RedirectPath;
              Result:=true;  }
            end;
          end;
        end;
      end else begin
        OutScript:='';
        OutPath:=Document;
        Result:=true;
      end;
    end else begin
      if (Trim(S2)='') and (S1=SSlash) then begin
        OutScript:='';
        OutPath:='';
        Result:=true;
      end;
    end;
  end;
  
var
  i: Integer;
  Item: TBisHttpServerRedirect;
  Hosts, Paths: TStringList;
  APath: String;
  Flag: Boolean;
begin
  Result:=nil;
  Hosts:=TStringList.Create;
  Paths:=TStringList.Create;
  try
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if Item.Enabled then begin
        Hosts.Clear;
        Paths.Clear;
        GetStringsByString(Item.InParams.Host,';',Hosts);
        GetStringsByString(Item.InParams.Path,';',Paths);
        if Hosts.IndexOf(Host)<>-1 then begin
          Flag:=false;
          for APath in Paths do begin
            if CheckPath(APath) then begin
              Flag:=true;
              break;
            end;
          end;
          if Flag then begin
            Result:=Item;
            exit;
          end;
        end;
      end;
    end;
  finally
    Paths.Free;
    Hosts.Free;
  end;
end;

end.
