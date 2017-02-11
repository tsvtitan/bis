unit BisHttpServerHandlers;

interface

uses Classes,
     HTTPApp, ZLib,
     BisObject, BisCoreObjects, BisCrypter, BisDataSet;

type

  TBisHttpServerHandler=class(TBisCoreObject)
  private
    FEnabled: Boolean;
    FPath: String;
    FHost: String;
    FUseCrypter: Boolean;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FCrypterKey: String;
    FUseCompressor: Boolean;

    FParams: TBisDataSet;
    FSoftware: String;
    FCompressorLevel: TCompressionLevel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    function HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean; virtual;
    procedure CopyFrom(Source: TBisHttpServerHandler); virtual;

    property Enabled: Boolean read FEnabled write FEnabled;
    property Host: String read FHost write FHost;
    property Path: String read FPath write FPath;
    property UseCrypter: Boolean read FUseCrypter write FUseCrypter;
    property CrypterAlgorithm: TBisCipherAlgorithm read FCrypterAlgorithm write FCrypterAlgorithm;
    property CrypterMode: TBisCipherMode read FCrypterMode write FCrypterMode;
    property CrypterKey: String read FCrypterKey write FCrypterKey;
    property UseCompressor: Boolean read FUseCompressor write FUseCompressor;
    property CompressorLevel: TCompressionLevel read FCompressorLevel write FCompressorLevel; 
    property Software: String read FSoftware write FSoftware; 

    property Params: TBisDataSet read FParams;
  end;

  TBisHttpServerHandlerClass=class of TBisHttpServerHandler;

  TBisHttpServerHandlers=class(TBisCoreObjects)
  private
    function GetItems(Index: Integer): TBisHttpServerHandler;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    function AddClass(AClass: TBisHttpServerHandlerClass; const ObjectName: String=''): TBisHttpServerHandler;
    function AddHandler(AHandler: TBisHttpServerHandler): Boolean;
    procedure Remove(AHandler: TBisHttpServerHandler);
    function FindHandler(const Host, Document: String; var OutPath,OutScript: string): TBisHttpServerHandler;

    property Items[Index: Integer]: TBisHttpServerHandler read GetItems;
  end;


implementation

uses SysUtils,
     BisUtils, BisHttpServerConsts, BisConsts;

{ TBisHttpServerHandler }

constructor TBisHttpServerHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParams:=TBisDataSet.Create(nil);
end;

destructor TBisHttpServerHandler.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisHttpServerHandler.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  Result:=false;
end;

procedure TBisHttpServerHandler.CopyFrom(Source: TBisHttpServerHandler);
begin
  if Assigned(Source) then begin
    FHost:=Source.Host;
    FPath:=Source.Path;
    FUseCrypter:=Source.UseCrypter;
    FCrypterAlgorithm:=Source.CrypterAlgorithm;
    FCrypterMode:=Source.CrypterMode;
    FCrypterKey:=Source.CrypterKey;
    FUseCompressor:=Source.UseCompressor;
    FCompressorLevel:=Source.CompressorLevel;
    FSoftware:=Source.Software;
  end;
end;

procedure TBisHttpServerHandler.Init;
var
  AName: String;
  AValue: String;
begin
  inherited Init;
  if FParams.Active and not FParams.Empty then begin
    FParams.First;
    while not FParams.Eof do begin
      AName:=FParams.FieldByName(SFieldName).AsString;
      AValue:=FParams.FieldByName(SFieldValue).AsString;
      
      if AnsiSameText(AName,SParamHost) then FHost:=AValue;
      if AnsiSameText(AName,SParamPath) then FPath:=AValue;
      if AnsiSameText(AName,SParamUseCrypter) then FUseCrypter:=Boolean(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterAlgorithm) then FCrypterAlgorithm:=TBisCipherAlgorithm(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterMode) then FCrypterMode:=TBisCipherMode(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCrypterKey) then FCrypterKey:=AValue;
      if AnsiSameText(AName,SParamUseCompressor) then FUseCompressor:=Boolean(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamCompressorLevel) then FCompressorLevel:=TCompressionLevel(StrToIntDef(AValue,0));
      if AnsiSameText(AName,SParamSoftware) then FSoftware:=AValue;

      FParams.Next;
    end;
  end;
end;

{ TBisHttpServerHandlers }

function TBisHttpServerHandlers.GetItems(Index: Integer): TBisHttpServerHandler;
begin
  Result:=TBisHttpServerHandler(inherited Items[Index]);
end;

function TBisHttpServerHandlers.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisHttpServerHandler;
end;

function TBisHttpServerHandlers.AddClass(AClass: TBisHttpServerHandlerClass; const ObjectName: String): TBisHttpServerHandler;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    if Trim(ObjectName)<>'' then
      Result.ObjectName:=ObjectName;
    if not Assigned(Find(Result.ObjectName)) then begin
      Objects.Add(Result);
    end else begin
      FreeAndNilEx(Result);
    end;
  end;
end;

function TBisHttpServerHandlers.AddHandler(AHandler: TBisHttpServerHandler): Boolean;
begin
  Result:=false;
  if not Assigned(Find(AHandler.ObjectName)) then begin
    Objects.Add(AHandler);
    Result:=true;
  end;
end;

procedure TBisHttpServerHandlers.Remove(AHandler: TBisHttpServerHandler);
begin
  Objects.Remove(AHandler);
end;

function TBisHttpServerHandlers.FindHandler(const Host, Document: String; var OutPath, OutScript: string): TBisHttpServerHandler;
    
  function CheckPath(HandlerPath: string): Boolean;
  var
    Apos: Integer;
    S1,S2: string;
    Path: string;
  begin
    Result:=false;
    S1:=AnsiLowerCase(HandlerPath);
    S2:=AnsiLowerCase(Document);
    Apos:=AnsiPos(S1,S2);
    if Apos=1 then begin
      if Length(S1)<>Length(S2) then begin
        if Length(S1)<Length(S2) then begin
          Path:=Copy(Document,Length(HandlerPath)+1,Length(Document));
          if Length(Path)>0 then begin
            if Path[1]=SSlash then begin
              OutScript:=iff(Path=SSlash,'',Path);
              OutPath:=HandlerPath;
              Result:=true;
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
  Item: TBisHttpServerHandler;
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
        GetStringsByString(Item.Host,';',Hosts);
        GetStringsByString(Item.Path,';',Paths);
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
