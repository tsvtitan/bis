unit BisSdp;

interface

uses Classes, Contnrs;

type

  TBisSdpDesc=class(TObject)
  protected
    class function GetName: String; virtual;
    procedure Parse(const Body: String); virtual;
    function AsString: String; virtual;
    function NameEqual: String; virtual;
  public

    property Name: String read GetName;
  end;

  TBisSdpDescClass=class of TBisSdpDesc;

  TBisSdpSimple=class(TBisSdpDesc)
  private
    FValue: String;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
  end;

  TBisSdpVersion=class(TBisSdpSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSdpOrigin=class(TBisSdpDesc)
  private
    FUserName, FSessionId, FSessionVersion: String;
    FNettype, FAddrtype, FUnicastAddress: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
  end;

  TBisSdpSession=class(TBisSdpSimple)
  protected
    class function GetName: String; override;
  public
    function AsString: String; override;
  end;

  TBisSdpConnection=class(TBisSdpDesc)
  private
    FNettype, FAddrtype, FUnicastAddress: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;

    property UnicastAddress: String read FUnicastAddress;
  end;

  TBisSdpBandwidth=class(TBisSdpDesc)
  private
    FType, FWidth: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
  end;

  TBisSdpTiming=class(TBisSdpDesc)
  private
    FStart, FStop: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
  end;

  TBisSdpMedia=class(TBisSdpDesc)
  private
    FMedia, FPort, FProto, FFormat: String;
    function GetPort: Integer;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;

    property Port: Integer read GetPort;
  end;

  TBisSdpAttr=class(TBisSdpSimple)
  protected
    class function GetName: String; override;
    function NameEqual: String; override;
    class function GetIdent: String; virtual;
  public
    property Ident: String read GetIdent;
  end;

  TBisSdpAttrClass=class of TBisSdpAttr;

  TBisSdpRtpmapAttr=class(TBisSdpAttr)
  private
    FPayloadType, FEncoding, FClockrate: String;
  protected
    class function GetIdent: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
  end;

  TBisSdpPtimeAttr=class(TBisSdpAttr)
  protected
    class function GetIdent: String; override;
  end;

  TBisSdpFmtpAttr=class(TBisSdpAttr)
  private
    FFormat, FParameters: String;
  protected
    class function GetIdent: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
  end;

  TBisSdp=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSdpDesc;
  public
    procedure GetDescs(AClass: TBisSdpDescClass; Sdp: TBisSdp);
    function Find(AClass: TBisSdpDescClass): TBisSdpDesc;
    procedure Parse(const Body: String);
    function AsString: String;

    function Add(Desc: TBisSdpDesc): Boolean; overload;
    function Add(AClass: TBisSdpDescClass): TBisSdpDesc; overload;

    function AddVersion(Value: String): TBisSdpVersion;
    function AddOrigin(UserName, SessionId, SessionVersion, Nettype, Addrtype, UnicastAddress: String): TBisSdpOrigin;
    function AddSession(Value: String): TBisSdpSession;
    function AddConnection(Nettype, Addrtype, UnicastAddress: String): TBisSdpConnection;
    function AddBandwidth(AType, Width: String): TBisSdpBandwidth;
    function AddTiming(Start, Stop: String): TBisSdpTiming;
    function AddMedia(Media, Port, Proto, Format: String): TBisSdpMedia;
    function AddAttr(Value: String): TBisSdpAttr;
    function AddRtpmapAttr(PayloadType, Encoding, Clockrate: String): TBisSdpRtpmapAttr;
    function AddPtimeAttr(Value: String): TBisSdpPtimeAttr;
    function AddFmtpAttr(Format, Parameters: String): TBisSdpFmtpAttr;

    property Items[Index: Integer]: TBisSdpDesc read GetItem; default;
  end;

implementation

uses Windows, SysUtils,
     BisUtils;

var
  FDescClasses: TClassList=nil;
  FAttrClasses: TClassList=nil; 

function FindAttrClass(const AIdent: String): TBisSdpAttrClass;
var
  i: Integer;
  AClass: TBisSdpAttrClass;
begin
  Result:=nil;
  if Assigned(FAttrClasses) then begin
    for i:=0 to FAttrClasses.Count-1 do begin
      AClass:=TBisSdpAttrClass(FAttrClasses[i]);
      if AnsiSameText(AClass.GetIdent,AIdent) then begin
        Result:=AClass;
        exit;
      end;
    end;
  end;
end;

function FindDescClass(const AName: String; var AValue: String): TBisSdpDescClass;
var
  i: Integer;
  AClass: TBisSdpDescClass;
  AIdent: String;
begin
  Result:=nil;
  if Assigned(FDescClasses) then begin
    for i:=0 to FDescClasses.Count-1 do begin
      AClass:=TBisSdpDescClass(FDescClasses[i]);
      if AnsiSameText(AClass.GetName,AName) then begin
        Result:=AClass;
        if IsClassParent(Result,TBisSdpAttr) then begin
          if ParseName(AValue,':',AIdent,AValue) then begin
            AClass:=FindAttrClass(AIdent);
            if Assigned(AClass) then
              Result:=AClass;
          end;
        end;
        exit;
      end;
    end;
  end;
end;

{ TBisSdpDesc }

function TBisSdpDesc.AsString: String;
begin
  Result:='';
end;

class function TBisSdpDesc.GetName: String;
begin
  Result:='';
end;

function TBisSdpDesc.NameEqual: String;
begin
  Result:=GetName;
  Result:=iff(Result<>'',Result+'=','');
end;

procedure TBisSdpDesc.Parse(const Body: String);
begin
end;

{ TBisSdpSimpleName }

function TBisSdpSimple.AsString: String;
begin
  Result:=Format('%s%s',[NameEqual,
                         iff(FValue<>'',FValue,'')]);
  Result:=Trim(Result);                         
end;

procedure TBisSdpSimple.Parse(const Body: String);
begin
  FValue:=Body;
end;

{ TBisSdpVersion }

class function TBisSdpVersion.GetName: String;
begin
  Result:='v';
end;

{ TBisSdpOrigin }

function TBisSdpOrigin.AsString: String;
begin
  Result:=Format('%s%s%s%s%s%s%s',[NameEqual,
                                   iff(FUserName<>'',FUserName,'-'),
                                   iff(FSessionId<>'',' '+FSessionId,''),
                                   iff(FSessionVersion<>'',' '+FSessionVersion,''),
                                   iff(FNettype<>'',' '+FNettype,''),
                                   iff(FAddrtype<>'',' '+FAddrtype,''),
                                   iff(FUnicastAddress<>'',' '+FUnicastAddress,'')]);
  Result:=Trim(Result);
end;

class function TBisSdpOrigin.GetName: String;
begin
  Result:='o';
end;

procedure TBisSdpOrigin.Parse(const Body: String);
var
  S: TStringList;
begin
  S:=TStringList.Create;
  try
    GetStringsByString(Body,' ',S);
    if S.Count>0 then begin
      FUserName:=S[0];
      if S.Count>1 then begin
        FSessionId:=S[1];
        if S.Count>2 then begin
          FSessionVersion:=S[2];
          if S.Count>3 then begin
            FNettype:=S[3];
            if S.Count>4 then begin
              FAddrtype:=S[4];
              if S.Count>5 then
                FUnicastAddress:=S[5];
            end;
          end;
        end;
      end;
    end;
  finally
    S.Free;
  end;
end;

{ TBisSdpSession }

function TBisSdpSession.AsString: String;
begin
  Result:=Format('%s%s',[NameEqual,
                         iff(FValue<>'',FValue,'-')]);
  Result:=Trim(Result);
end;

class function TBisSdpSession.GetName: String;
begin
  Result:='s';
end;

{ TBisSdpConnection }

function TBisSdpConnection.AsString: String;
begin
  Result:=Format('%s%s%s%s',[NameEqual,
                             iff(FNettype<>'',FNettype,''),
                             iff(FAddrtype<>'',' '+FAddrtype,''),
                             iff(FUnicastAddress<>'',' '+FUnicastAddress,'')]);
  Result:=Trim(Result);
end;

class function TBisSdpConnection.GetName: String;
begin
  Result:='c';
end;

procedure TBisSdpConnection.Parse(const Body: String);
var
  S: TStringList;
begin
  S:=TStringList.Create;
  try
    GetStringsByString(Body,' ',S);
    if S.Count>0 then begin
      FNettype:=S[0];
      if S.Count>1 then begin
        FAddrtype:=S[1];
        if S.Count>2 then
          FUnicastAddress:=S[2];
      end;
    end;
  finally
    S.Free;
  end;
end;

{ TBisSdpBandwidth }

function TBisSdpBandwidth.AsString: String;
begin
  Result:=Format('%s%s%s',[NameEqual,
                           iff(FType<>'',FType,''),
                           iff(FWidth<>'',':'+FWidth,'')]);
  Result:=Trim(Result);
end;

class function TBisSdpBandwidth.GetName: String;
begin
  Result:='b';
end;

procedure TBisSdpBandwidth.Parse(const Body: String);
var
  S: TStringList;
begin
  S:=TStringList.Create;
  try
    GetStringsByString(Body,':',S);
    if S.Count>0 then begin
      FType:=S[0];
      if S.Count>1 then
        FWidth:=S[1];
    end;
  finally
    S.Free;
  end;
end;

{ TBisSdpTiming }

function TBisSdpTiming.AsString: String;
begin
  Result:=Format('%s%s%s',[NameEqual,
                           iff(FStart<>'',FStart,''),
                           iff(FStop<>'',' '+FStop,'')]);
  Result:=Trim(Result);
end;

class function TBisSdpTiming.GetName: String;
begin
  Result:='t';
end;

procedure TBisSdpTiming.Parse(const Body: String);
var
  S: TStringList;
begin
  S:=TStringList.Create;
  try
    GetStringsByString(Body,' ',S);
    if S.Count>0 then begin
      FStart:=S[0];
      if S.Count>1 then
        FStop:=S[1];
    end;
  finally
    S.Free;
  end;
end;

{ TBisSdpMedia }

function TBisSdpMedia.AsString: String;
begin
  Result:=Format('%s%s%s%s%s',[NameEqual,
                               iff(FMedia<>'',FMedia,''),
                               iff(FPort<>'',' '+FPort,''),
                               iff(FProto<>'',' '+FProto,''),
                               iff(FFormat<>'',' '+FFormat,'')]);
  Result:=Trim(Result);
end;

class function TBisSdpMedia.GetName: String;
begin
  Result:='m';
end;

function TBisSdpMedia.GetPort: Integer;
begin
  Result:=StrToIntDef(FPort,0);
end;

procedure TBisSdpMedia.Parse(const Body: String);
var
  S: TStringList;
  i: Integer;
begin
  S:=TStringList.Create;
  try
    GetStringsByString(Body,' ',S);
    if S.Count>0 then begin
      FMedia:=S[0];
      if S.Count>1 then begin
        FPort:=S[1];
        if S.Count>2 then begin
          FProto:=S[2];
          if S.Count>3 then begin
            for i:=3 to S.Count-1 do
              FFormat:=FFormat+' '+S[i];
            FFormat:=Trim(FFormat);
          end;
        end;
      end;
    end;
  finally
    S.Free;
  end;
end;

{ TBisSdpAttr }

class function TBisSdpAttr.GetIdent: String;
begin
  Result:='';
end;

class function TBisSdpAttr.GetName: String;
begin
  Result:='a';
end;

function TBisSdpAttr.NameEqual: String;
var
  AIdent: String;
begin
  AIdent:=GetIdent;
  Result:=inherited NameEqual;
  Result:=Format('%s%s',[Result,
                         iff(AIdent<>'',AIdent+':','')]);
  Result:=Trim(Result);                         
end;

{ TBisSdpRtpmapAttr }

function TBisSdpRtpmapAttr.AsString: String;
begin
  Result:=Format('%s%s%s%s',[NameEqual,
                             iff(FPayloadType<>'',FPayloadType,''),
                             iff(FEncoding<>'',' '+FEncoding,''),
                             iff(FClockrate<>'','/'+FClockrate,'')]);
  Result:=Trim(Result);
end;

class function TBisSdpRtpmapAttr.GetIdent: String;
begin
  Result:='rtpmap';
end;

procedure TBisSdpRtpmapAttr.Parse(const Body: String);
var
  S: TStringList;
begin
  S:=TStringList.Create;
  try
    GetStringsByString(Body,' ',S);
    if S.Count>0 then begin
      FPayloadType:=S[0];
      if S.Count>1 then begin
        ParseName(S[1],'/',FEncoding,FClockrate);
      end;
    end;
  finally
    S.Free;
  end;
end;

{ TBisSdpPtimeAttr }

class function TBisSdpPtimeAttr.GetIdent: String;
begin
  Result:='ptime';
end;

{ TBisSdpFmtpAttr }

function TBisSdpFmtpAttr.AsString: String;
begin
  Result:=Format('%s%s%s',[NameEqual,
                           iff(FFormat<>'',FFormat,''),
                           iff(FParameters<>'',' '+FParameters,'')]);
end;

class function TBisSdpFmtpAttr.GetIdent: String;
begin
  Result:='fmtp';
end;

procedure TBisSdpFmtpAttr.Parse(const Body: String);
begin
  inherited;

end;

{ TBisSdp }

function TBisSdp.GetItem(Index: Integer): TBisSdpDesc;
begin
  Result:=TBisSdpDesc(inherited Items[Index]);
end;

procedure TBisSdp.Parse(const Body: String);
var
  S: TStringList;
  i: Integer;
  AClass: TBisSdpDescClass;
  AName,AValue: String;
  Item: TBisSdpDesc;
begin
  S:=TStringList.Create;
  try
    S.Text:=Body;
    for i:=0 to S.Count-1 do begin
      if ParseName(S[i],'=',AName,AValue) then begin
        AClass:=FindDescClass(AName,AValue);
        if Assigned(AClass) then begin
          Item:=Add(AClass);
          if Assigned(Item) then
            Item.Parse(AValue);
        end;
      end;
    end;
  finally
    S.Free;
  end;
end;

function TBisSdp.AsString: String;
var
  i: Integer;
  Item: TBisSdpDesc;
  S: TStringList;
begin
  S:=TStringList.Create;
  try
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      S.Add(Item.AsString);
    end;
    Result:=Trim(S.Text);
  finally
    S.Free;
  end;
end;

procedure TBisSdp.GetDescs(AClass: TBisSdpDescClass; Sdp: TBisSdp);
var
  i: Integer;
  Item: TBisSdpDesc;
begin
  if Assigned(AClass) and Assigned(List) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if IsClassParent(Item.ClassType,AClass) then
        Sdp.Add(Item);
    end;
  end;
end;

function TBisSdp.Find(AClass: TBisSdpDescClass): TBisSdpDesc;
var
  Sdp: TBisSdp;
begin
  Result:=nil;
  Sdp:=TBisSdp.Create;
  try
    Sdp.OwnsObjects:=false;
    GetDescs(AClass,Sdp);
    if Sdp.Count>0 then
      Result:=Sdp.Items[Sdp.Count-1];
  finally
    Sdp.Free;
  end;
end;

function TBisSdp.Add(Desc: TBisSdpDesc): Boolean;
var
  Item: TBisSdpDesc;
begin
  Result:=false;
  if Assigned(Desc) then begin
    if IsClassParent(Desc.ClassType,TBisSdpAttr) then begin
      inherited Add(Desc);
      Result:=true;
    end else begin
      Item:=Find(TBisSdpDescClass(Desc.ClassType));
      if not Assigned(Item) then begin
        inherited Add(Desc);
        Result:=true;
      end;
    end;
  end;
end;

function TBisSdp.Add(AClass: TBisSdpDescClass): TBisSdpDesc;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    if IsClassParent(AClass,TBisSdpAttr) then begin
      Result:=AClass.Create;
      inherited Add(Result);
    end else begin
      Result:=Find(AClass);
      if not Assigned(Result) then begin
        Result:=AClass.Create;
        inherited Add(Result);
      end;
    end;
  end;
end;

function TBisSdp.AddVersion(Value: String): TBisSdpVersion;
begin
  Result:=TBisSdpVersion(Add(TBisSdpVersion));
  if Assigned(Result) then
    Result.FValue:=Value;
end;

function TBisSdp.AddOrigin(UserName, SessionId, SessionVersion, Nettype, Addrtype, UnicastAddress: String): TBisSdpOrigin;
begin
  Result:=TBisSdpOrigin(Add(TBisSdpOrigin));
  if Assigned(Result) then begin
    Result.FUserName:=UserName;
    Result.FSessionId:=SessionId;
    Result.FSessionVersion:=SessionVersion;
    Result.FNettype:=Nettype;
    Result.FAddrtype:=Addrtype;
    Result.FUnicastAddress:=UnicastAddress;
  end;
end;

function TBisSdp.AddSession(Value: String): TBisSdpSession;
begin
  Result:=TBisSdpSession(Add(TBisSdpSession));
  if Assigned(Result) then
    Result.FValue:=Value;
end;

function TBisSdp.AddConnection(Nettype, Addrtype, UnicastAddress: String): TBisSdpConnection;
begin
  Result:=TBisSdpConnection(Add(TBisSdpConnection));
  if Assigned(Result) then begin
    Result.FNettype:=Nettype;
    Result.FAddrtype:=Addrtype;
    Result.FUnicastAddress:=UnicastAddress;
  end;
end;

function TBisSdp.AddBandwidth(AType, Width: String): TBisSdpBandwidth;
begin
  Result:=TBisSdpBandwidth(Add(TBisSdpBandwidth));
  if Assigned(Result) then begin
    Result.FType:=AType;
    Result.FWidth:=Width;
  end;
end;

function TBisSdp.AddTiming(Start, Stop: String): TBisSdpTiming;
begin
  Result:=TBisSdpTiming(Add(TBisSdpTiming));
  if Assigned(Result) then begin
    Result.FStart:=Start;
    Result.FStop:=Stop;
  end;
end;

function TBisSdp.AddMedia(Media, Port, Proto, Format: String): TBisSdpMedia;
begin
  Result:=TBisSdpMedia(Add(TBisSdpMedia));
  if Assigned(Result) then begin
    Result.FMedia:=Media;
    Result.FPort:=Port;
    Result.FProto:=Proto;
    Result.FFormat:=Format;
  end;
end;

function TBisSdp.AddAttr(Value: String): TBisSdpAttr;
begin
  Result:=TBisSdpAttr(Add(TBisSdpAttr));
  if Assigned(Result) then
    Result.FValue:=Value;
end;

function TBisSdp.AddRtpmapAttr(PayloadType, Encoding, Clockrate: String): TBisSdpRtpmapAttr;
begin
  Result:=TBisSdpRtpmapAttr(Add(TBisSdpRtpmapAttr));
  if Assigned(Result) then begin
    Result.FPayloadType:=PayloadType;
    Result.FEncoding:=Encoding;
    Result.FClockrate:=Clockrate;
  end;
end;

function TBisSdp.AddPtimeAttr(Value: String): TBisSdpPtimeAttr;
begin
  Result:=TBisSdpPtimeAttr(Add(TBisSdpPtimeAttr));
  if Assigned(Result) then
    Result.FValue:=Value;
end;

function TBisSdp.AddFmtpAttr(Format, Parameters: String): TBisSdpFmtpAttr;
begin
  Result:=TBisSdpFmtpAttr(Add(TBisSdpFmtpAttr));
  if Assigned(Result) then begin
    Result.FFormat:=Format;
    Result.FParameters:=Parameters;
  end;
end;


initialization
  FDescClasses:=TClassList.Create;
  with FDescClasses do begin
    Add(TBisSdpVersion);
    Add(TBisSdpOrigin);
    Add(TBisSdpSession);
    Add(TBisSdpConnection);
    Add(TBisSdpBandwidth);
    Add(TBisSdpTiming);
    Add(TBisSdpMedia);
    Add(TBisSdpAttr);
  end;

  FAttrClasses:=TClassList.Create;
  with FAttrClasses do begin
    Add(TBisSdpRtpmapAttr);
    Add(TBisSdpPtimeAttr);
    Add(TBisSdpFmtpAttr);
  end

finalization
  FAttrClasses.Free;
  FDescClasses.Free;
  
end.
