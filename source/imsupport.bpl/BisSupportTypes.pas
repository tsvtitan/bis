unit BisSupportTypes;

interface

uses Classes, Contnrs,
     ALXmlDoc;

type

  TBisSupportStreamFormat=(sfRaw,sfXml);

  TBisSupportCommand=class(TObject)
  private
    FSuccess: Boolean;
    FError: String;
    FTag: String;
    FReason: String;
  protected
    class function GetName: string; virtual;
    procedure ReadRawData(Reader: TReader); virtual;
    procedure WriteRawData(Writer: TWriter); virtual;
    procedure ReadXmlData(Node: TALXMLNode); virtual;
    procedure WriteXmlData(Node: TALXMLNode); virtual;
  public
    constructor Create; virtual;
    procedure CopyFrom(Source: TBisSupportCommand); virtual;

    property Name: String read GetName;
    property Tag: String read FTag write FTag;
    property Reason: String read FReason write FReason;
    property Success: Boolean read FSuccess write FSuccess;
    property Error: String read FError write FError;
  end;

  TBisSupportCommandClass=class of TBisSupportCommand;

  TBisSupportCommandHelper=class helper for TBisSupportCommand
  public
    function Same(AClass: TBisSupportCommandClass; WithParent: Boolean=false): Boolean;
  end;

  TBisSupportProcessState=(psUnknown,psUp,psDown,psNotFound);

  TBisSupportProcess=class(TObject)
  private
    FProcessID: Cardinal;
    FName: String;
    FCaption: String;
    FDescription: String;
    FState: TBisSupportProcessState;
    FService: Boolean;
    FStartTime: TDateTime;
    FStartReasons: TStringList;
    FStopReasons: TStringList;
    FNeedCheck: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisSupportProcess);

    property ProcessID: Cardinal read FProcessID write FProcessID;
    property Name: String read FName write FName;
    property Caption: String read FCaption write FCaption;
    property Description: String read FDescription write FDescription;
    property State: TBisSupportProcessState read FState write FState;
    property Service: Boolean read FService write FService;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property StartReasons: TStringList read FStartReasons;
    property StopReasons: TStringList read FStopReasons;
    property NeedCheck: Boolean read FNeedCheck write FNeedCheck;
  end;

  TBisSupportProcesses=class(TBisSupportCommand)
  private
    FProcesses: TObjectList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TBisSupportProcess;
  protected
    class function GetName: string; override;
    procedure ReadRawData(Reader: TReader); override;
    procedure WriteRawData(Writer: TWriter); override;
    procedure ReadXmlData(Node: TALXMLNode); override;
    procedure WriteXmlData(Node: TALXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add(ProcessID: Cardinal; const Name, Caption, Description: String;
                 State: TBisSupportProcessState; Service: Boolean;
                 StartReasons,StopReasons: String; NeedCheck: Boolean): TBisSupportProcess;
    procedure CopyFrom(Source: TBisSupportCommand); override;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TBisSupportProcess read GetItem; default;
  end;

  TBisSupportStatus=class(TBisSupportCommand)
  private
    FShutReasons: TStringList;
    FNeedCheck: Boolean;
  protected
    class function GetName: string; override;
    procedure ReadRawData(Reader: TReader); override;
    procedure WriteRawData(Writer: TWriter); override;
    procedure ReadXmlData(Node: TALXMLNode); override;
    procedure WriteXmlData(Node: TALXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisSupportCommand); override;

    property ShutReasons: TStringList read FShutReasons;
    property NeedCheck: Boolean read FNeedCheck write FNeedCheck;
  end;

  TBisSupportPassword=class(TBisSupportCommand)
  private
    FPassword: String;
  protected
    procedure ReadRawData(Reader: TReader); override;
    procedure WriteRawData(Writer: TWriter); override;
    procedure ReadXmlData(Node: TALXMLNode); override;
    procedure WriteXmlData(Node: TALXMLNode); override;
  public
    procedure CopyFrom(Source: TBisSupportCommand); override;

    property Password: String read FPassword write FPassword;
  end;


  TBisSupportShutdown=class(TBisSupportPassword)
  private
    FTimeout: Integer;
    FMessage: String;
    FForced: Boolean;
    FReboot: Boolean;
  protected
    class function GetName: string; override;
    procedure ReadRawData(Reader: TReader); override;
    procedure WriteRawData(Writer: TWriter); override;
    procedure ReadXmlData(Node: TALXMLNode); override;
    procedure WriteXmlData(Node: TALXMLNode); override;
  public
    procedure CopyFrom(Source: TBisSupportCommand); override;

    property Timeout: Integer read FTimeout write FTimeout;
    property Message: String read FMessage write FMessage;
    property Forced: Boolean read FForced write FForced;
    property Reboot: Boolean read FReboot write FReboot;
  end;

  TBisSupportStart=class(TBisSupportPassword)
  private
    FProcessName: String;
  protected
    class function GetName: string; override;
    procedure ReadRawData(Reader: TReader); override;
    procedure WriteRawData(Writer: TWriter); override;
    procedure ReadXmlData(Node: TALXMLNode); override;
    procedure WriteXmlData(Node: TALXMLNode); override;
  public
    procedure CopyFrom(Source: TBisSupportCommand); override;

    property ProcessName: String read FProcessName write FProcessName;
  end;

  TBisSupportStop=class(TBisSupportStart)
  protected
    class function GetName: string; override;
  end;

  TBisSupportSleep=class(TBisSupportCommand)
  private
    FTimeout: Integer;
  protected
    class function GetName: string; override;
    procedure ReadRawData(Reader: TReader); override;
    procedure WriteRawData(Writer: TWriter); override;
    procedure ReadXmlData(Node: TALXMLNode); override;
    procedure WriteXmlData(Node: TALXMLNode); override;
  public
    procedure CopyFrom(Source: TBisSupportCommand); override;

    property Timeout: Integer read FTimeout write FTimeout;
  end;

  TBisSupportCommands=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSupportCommand;
  public
    function Find(const Tag: String): TBisSupportCommand;
    function Add(Command: TBisSupportCommand): Boolean;
    function AddShutdown(Timeout: Integer; const Message: String; Forced,Reboot: Boolean): TBisSupportShutdown;
    function AddProcesses: TBisSupportProcesses;
    function AddStatus: TBisSupportStatus;
    function AddStart(const ProcessName: String): TBisSupportStart;
    function AddStop(const ProcessName: String): TBisSupportStop;
    function AddSleep(const Timeout: Integer): TBisSupportSleep;

    procedure CopyFrom(Source: TBisSupportCommands; WithClear: Boolean=true);

    property Items[Index: Integer]: TBisSupportCommand read GetItem; default;
  end;

  TBisSupportRequest=class(TObject)
  private
    FRnd: String;
    FCommands: TBisSupportCommands;
    FSuccess: Boolean;
    FError: String;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToStream(Stream: TStream; AFormat: TBisSupportStreamFormat);
    procedure LoadFromStream(Stream: TStream; AFormat: TBisSupportStreamFormat);

    property Commands: TBisSupportCommands read FCommands;

    property Rnd: String read FRnd write FRnd;
    property Success: Boolean read FSuccess write FSuccess;
    property Error: String read FError write FError;

  end;

implementation

uses Windows, SysUtils, Variants,
     BisUtils, BisConsts;

var
  FClassList: TClassList=nil;

function FindClassByName(const Name: String): TBisSupportCommandClass;
var
  i: Integer;
  AClass: TBisSupportCommandClass;
begin
  Result:=nil;
  for i:=0 to FClassList.Count-1 do begin
    AClass:=TBisSupportCommandClass(FClassList.Items[i]);
    if AnsiSameText(AClass.GetName,Name) then begin
      Result:=AClass;
      exit;
    end;
  end;
end;

{ TBisSupportCommand }

constructor TBisSupportCommand.Create;
begin
  inherited Create;
  FTag:=GetUniqueID;
end;

procedure TBisSupportCommand.CopyFrom(Source: TBisSupportCommand);
begin
  if Assigned(Source) then begin
    FSuccess:=Source.Success;
    FError:=Source.Error;
    FTag:=Source.Tag;
    FReason:=Source.Reason;
  end;
end;

class function TBisSupportCommand.GetName: string;
begin
  Result:='';
end;

procedure TBisSupportCommand.ReadRawData(Reader: TReader);
begin
  FReason:=Reader.ReadString;
  FSuccess:=Reader.ReadBoolean;
  FError:=Reader.ReadString;
end;

procedure TBisSupportCommand.WriteRawData(Writer: TWriter);
begin
  Writer.WriteString(FReason);
  Writer.WriteBoolean(FSuccess);
  Writer.WriteString(FError);
end;

procedure TBisSupportCommand.ReadXmlData(Node: TALXMLNode);
begin
  FReason:=VarToStrDef(Node.Attributes['reason'],'');
  FSuccess:=Boolean(VarToIntDef(Node.Attributes['success'],0));
  FError:=VarToStrDef(Node.Attributes['error'],'');
end;

procedure TBisSupportCommand.WriteXmlData(Node: TALXMLNode);
begin
  if Trim(FReason)<>'' then Node.Attributes['reason']:=FReason;
  if FSuccess then Node.Attributes['success']:=Integer(FSuccess);
  if Trim(FError)<>'' then Node.Attributes['error']:=FError;
end;

{ TBisSupportCommandHelper }

function TBisSupportCommandHelper.Same(AClass: TBisSupportCommandClass; WithParent: Boolean=false): Boolean;
begin
  Result:=false;
  if Assigned(AClass) then begin
    Result:=AnsiSameText(Name,AClass.GetName);
    if not Result and WithParent then 
      Result:=IsClassParent(ClassType,AClass);
  end;
end;

{ TBisSupportProcess }

constructor TBisSupportProcess.Create;
begin
  inherited Create;
  FStartReasons:=TStringList.Create;
  FStopReasons:=TStringList.Create;
end;

destructor TBisSupportProcess.Destroy;
begin
  FStopReasons.Free;
  FStartReasons.Free;
  inherited Destroy;
end;

procedure TBisSupportProcess.CopyFrom(Source: TBisSupportProcess);
begin
  if Assigned(Source) then begin
    FProcessID:=Source.ProcessID;
    FName:=Source.Name;
    FCaption:=Source.Caption;
    FDescription:=Source.Description;
    FState:=Source.State;
    FService:=Source.Service;
    FStartTime:=Source.StartTime;
    FStartReasons.Assign(Source.StartReasons);
    FStopReasons.Assign(Source.StopReasons);
    FNeedCheck:=Source.NeedCheck;
  end;
end;

{ TBisSupportProcesses }

constructor TBisSupportProcesses.Create;
begin
  inherited Create;
  FProcesses:=TObjectList.Create;
end;

destructor TBisSupportProcesses.Destroy;
begin
  FProcesses.Free;
  inherited Destroy;
end;

procedure TBisSupportProcesses.CopyFrom(Source: TBisSupportCommand);
var
  Command: TBisSupportProcesses;
  SourceProcess, Process: TBisSupportProcess;
  i: Integer;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSupportProcesses) then begin
    Command:=TBisSupportProcesses(Source);

    for i:=0 to Command.Count-1 do begin
      SourceProcess:=Command.Items[i];

      Process:=TBisSupportProcess.Create;
      Process.CopyFrom(SourceProcess);

      FProcesses.Add(Process);
    end;
  end;
end;

function TBisSupportProcesses.GetCount: Integer;
begin
  Result:=FProcesses.Count;
end;

function TBisSupportProcesses.GetItem(Index: Integer): TBisSupportProcess;
begin
  Result:=TBisSupportProcess(FProcesses.Items[Index]);
end;

class function TBisSupportProcesses.GetName: string;
begin
  Result:='processes';
end;

function TBisSupportProcesses.Add(ProcessID: Cardinal; const Name, Caption, Description: String;
                                  State: TBisSupportProcessState; Service: Boolean;
                                  StartReasons,StopReasons: String; NeedCheck: Boolean): TBisSupportProcess;
begin
  Result:=TBisSupportProcess.Create;
  Result.ProcessID:=ProcessID;
  Result.Name:=Name;
  Result.Caption:=Caption;
  Result.Description:=Description;
  Result.State:=State;
  Result.Service:=Service;
  Result.StartReasons.Text:=StartReasons;
  Result.StopReasons.Text:=StopReasons;
  Result.NeedCheck:=NeedCheck;
  FProcesses.Add(Result);
end;

procedure TBisSupportProcesses.ReadRawData(Reader: TReader);
var
  Item: TBisSupportProcess;
begin
  inherited ReadRawData(Reader);
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    Item:=TBisSupportProcess.Create;
    FProcesses.Add(Item);
    Item.ProcessID:=Reader.ReadInteger;
    Item.Name:=Reader.ReadString;
    Item.Caption:=Reader.ReadString;
    Item.Description:=Reader.ReadString;
    Item.State:=TBisSupportProcessState(Reader.ReadInteger);
    Item.Service:=Reader.ReadBoolean;
    Item.StartTime:=Reader.ReadDate;
    Item.StartReasons.Text:=Reader.ReadString;
    Item.StopReasons.Text:=Reader.ReadString;
    Item.NeedCheck:=Reader.ReadBoolean;
  end;
  Reader.ReadListEnd;
end;

procedure TBisSupportProcesses.WriteRawData(Writer: TWriter);
var
  i: Integer;
  Item: TBisSupportProcess;
begin
  inherited WriteRawData(Writer);
  Writer.WriteListBegin;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Writer.WriteInteger(Item.ProcessID);
    Writer.WriteString(Item.Name);
    Writer.WriteString(Item.Caption);
    Writer.WriteString(Item.Description);
    Writer.WriteInteger(Integer(Item.State));
    Writer.WriteBoolean(Item.Service);
    Writer.WriteDate(Item.StartTime);
    Writer.WriteString(Item.StartReasons.Text);
    Writer.WriteString(Item.StopReasons.Text);
    Writer.WriteBoolean(Item.NeedCheck);
  end;
  Writer.WriteListEnd;
end;

procedure TBisSupportProcesses.ReadXmlData(Node: TALXMLNode);
var
  i: Integer;
  ItemNode: TALXMLNode;
  Item: TBisSupportProcess;
begin
  inherited ReadXmlData(Node);
  for i:=0 to Node.ChildNodes.Count-1 do begin
    ItemNode:=Node.ChildNodes[i];
    if AnsiSameText(ItemNode.NodeName,'item') then begin
      Item:=TBisSupportProcess.Create;
      FProcesses.Add(Item);
      Item.ProcessID:=VarToIntDef(ItemNode.Attributes['pid'],0);
      Item.Name:=VarToStrDef(ItemNode.Attributes['name'],'');
      Item.Caption:=VarToStrDef(ItemNode.Attributes['caption'],'');
      Item.Description:=VarToStrDef(ItemNode.Attributes['description'],'');
      Item.State:=TBisSupportProcessState(VarToIntDef(ItemNode.Attributes['state'],0));
      Item.Service:=Boolean(VarToIntDef(ItemNode.Attributes['service'],0));
      Item.StartTime:=VarToDateTimeDef(ItemNode.Attributes['starttime'],NullDate);
      Item.StartReasons.Text:=VarToStrDef(ItemNode.Attributes['startreasons'],'');
      Item.StopReasons.Text:=VarToStrDef(ItemNode.Attributes['stopreasons'],'');
      Item.NeedCheck:=Boolean(VarToIntDef(ItemNode.Attributes['needcheck'],0));
    end;
  end;
end;

procedure TBisSupportProcesses.WriteXmlData(Node: TALXMLNode);
var
  ItemNode: TALXMLNode;
  i: Integer;
  Item: TBisSupportProcess;
begin
  inherited WriteXmlData(Node);
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    ItemNode:=Node.AddChild('item');
    if Item.ProcessID>0 then ItemNode.Attributes['pid']:=Item.ProcessID;
    if Trim(Item.Name)<>'' then ItemNode.Attributes['name']:=Item.Name;
    if Trim(Item.Caption)<>'' then ItemNode.Attributes['caption']:=Item.Caption;
    if Trim(Item.Description)<>'' then ItemNode.Attributes['description']:=Item.Description;
    if Item.State<>psUnknown then ItemNode.Attributes['state']:=Integer(Item.State);
    if Item.Service then ItemNode.Attributes['service']:=Integer(Item.Service);
    if Item.StartTime<>NullDate then ItemNode.Attributes['starttime']:=Item.StartTime;
    if Trim(Item.StartReasons.Text)<>'' then ItemNode.Attributes['startreasons']:=Item.StartReasons.Text;
    if Trim(Item.StopReasons.Text)<>'' then ItemNode.Attributes['stopreasons']:=Item.StopReasons.Text;
    if Item.NeedCheck then ItemNode.Attributes['needcheck']:=Integer(Item.NeedCheck);
  end;
end;

{ TBisSupportStatus }

constructor TBisSupportStatus.Create;
begin
  inherited Create;
  FShutReasons:=TStringList.Create;
end;

destructor TBisSupportStatus.Destroy;
begin
  FShutReasons.Free;
  inherited Destroy;
end;

procedure TBisSupportStatus.CopyFrom(Source: TBisSupportCommand);
var
  Status: TBisSupportStatus;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSupportStatus) then begin
    Status:=TBisSupportStatus(Source);
    FShutReasons.Assign(Status.ShutReasons);
    FNeedCheck:=Status.NeedCheck;
  end;
end;

class function TBisSupportStatus.GetName: string;
begin
  Result:='status';
end;

procedure TBisSupportStatus.ReadRawData(Reader: TReader);
begin
  inherited ReadRawData(Reader);
  FShutReasons.Text:=Reader.ReadString;
  FNeedCheck:=Reader.ReadBoolean;
end;

procedure TBisSupportStatus.WriteRawData(Writer: TWriter);
begin
  inherited WriteRawData(Writer);
  Writer.WriteString(FShutReasons.Text);
  Writer.WriteBoolean(FNeedCheck);
end;

procedure TBisSupportStatus.ReadXmlData(Node: TALXMLNode);
begin
  inherited ReadXmlData(Node);
  FShutReasons.Text:=VarToStrDef(Node.Attributes['shutreasons'],'');
  FNeedCheck:=Boolean(VarToIntDef(Node.Attributes['needcheck'],0));
end;

procedure TBisSupportStatus.WriteXmlData(Node: TALXMLNode);
begin
  inherited WriteXmlData(Node);
  if Trim(FShutReasons.Text)<>'' then Node.Attributes['reasons']:=FShutReasons.Text;
  if FNeedCheck then Node.Attributes['needcheck']:=Integer(FNeedCheck);
end;

{ TBisSupportPassword }

procedure TBisSupportPassword.CopyFrom(Source: TBisSupportCommand);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSupportPassword) then begin
    FPassword:=TBisSupportPassword(Source).Password;
  end;
end;

procedure TBisSupportPassword.ReadRawData(Reader: TReader);
begin
  inherited ReadRawData(Reader);
  FPassword:=Reader.ReadString;
end;

procedure TBisSupportPassword.WriteRawData(Writer: TWriter);
begin
  inherited WriteRawData(Writer);
  Writer.WriteString(FPassword);
end;

procedure TBisSupportPassword.ReadXmlData(Node: TALXMLNode);
begin
  inherited ReadXmlData(Node);
  FPassword:=VarToStrDef(Node.Attributes['password'],'');
end;

procedure TBisSupportPassword.WriteXmlData(Node: TALXMLNode);
begin
  inherited WriteXmlData(Node);
  if Trim(FPassword)<>'' then Node.Attributes['password']:=FPassword;
end;

{ TBisSupportShutdown }

procedure TBisSupportShutdown.CopyFrom(Source: TBisSupportCommand);
var
  Command: TBisSupportShutdown;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSupportShutdown) then begin
    Command:=TBisSupportShutdown(Source);
    FTimeout:=Command.Timeout;
    FMessage:=Command.Message;
    FForced:=Command.Forced;
    FReboot:=Command.Reboot;
  end;
end;

class function TBisSupportShutdown.GetName: string;
begin
  Result:='shutdown';
end;

procedure TBisSupportShutdown.ReadRawData(Reader: TReader);
begin
  inherited ReadRawData(Reader);
  FTimeout:=Reader.ReadInteger;
  FMessage:=Reader.ReadString;
  FForced:=Reader.ReadBoolean;
  FReboot:=Reader.ReadBoolean;
end;

procedure TBisSupportShutdown.WriteRawData(Writer: TWriter);
begin
  inherited WriteRawData(Writer);
  Writer.WriteInteger(FTimeout);
  Writer.WriteString(FMessage);
  Writer.WriteBoolean(FForced);
  Writer.WriteBoolean(FReboot);
end;

procedure TBisSupportShutdown.ReadXmlData(Node: TALXMLNode);
begin
  inherited ReadXmlData(Node);
  FTimeout:=VarToIntDef(Node.Attributes['Timeout'],0);
  FMessage:=VarToStrDef(Node.Attributes['message'],'');
  FForced:=Boolean(VarToIntDef(Node.Attributes['forced'],0));
  FReboot:=Boolean(VarToIntDef(Node.Attributes['reboot'],0));
end;

procedure TBisSupportShutdown.WriteXmlData(Node: TALXMLNode);
begin
  inherited WriteXmlData(Node);
  if FTimeout>0 then Node.Attributes['Timeout']:=FTimeout;
  if Trim(FMessage)<>'' then Node.Attributes['message']:=FMessage;
  if FForced then Node.Attributes['forced']:=Integer(FForced);
  if FReboot then Node.Attributes['reboot']:=Integer(FReboot);
end;

{ TBisSupportStart }

procedure TBisSupportStart.CopyFrom(Source: TBisSupportCommand);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSupportStart) then
    FProcessName:=TBisSupportStart(Source).ProcessName;
end;

class function TBisSupportStart.GetName: string;
begin
  Result:='start';
end;

procedure TBisSupportStart.ReadRawData(Reader: TReader);
begin
  inherited ReadRawData(Reader);
  FProcessName:=Reader.ReadString;
end;

procedure TBisSupportStart.WriteRawData(Writer: TWriter);
begin
  inherited WriteRawData(Writer);
  Writer.WriteString(FProcessName);
end;

procedure TBisSupportStart.ReadXmlData(Node: TALXMLNode);
begin
  inherited ReadXmlData(Node);
  FProcessName:=VarToStrDef(Node.Attributes['process'],'');
end;

procedure TBisSupportStart.WriteXmlData(Node: TALXMLNode);
begin
  inherited WriteXmlData(Node);
  if Trim(FProcessName)<>'' then Node.Attributes['process']:=FProcessName;
end;

{ TBisSupportStop }

class function TBisSupportStop.GetName: string;
begin
  Result:='stop';
end;

{ TBisSupportSleep }

procedure TBisSupportSleep.CopyFrom(Source: TBisSupportCommand);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSupportSleep) then
    FTimeout:=TBisSupportSleep(Source).Timeout;
end;

class function TBisSupportSleep.GetName: string;
begin
  Result:='sleep';
end;

procedure TBisSupportSleep.ReadRawData(Reader: TReader);
begin
  inherited ReadRawData(Reader);
  FTimeout:=Reader.ReadInteger;
end;

procedure TBisSupportSleep.WriteRawData(Writer: TWriter);
begin
  inherited WriteRawData(Writer);
  Writer.WriteInteger(FTimeout);
end;

procedure TBisSupportSleep.ReadXmlData(Node: TALXMLNode);
begin
  inherited ReadXmlData(Node);
  FTimeout:=VarToIntDef(Node.Attributes['timeout'],0);
end;

procedure TBisSupportSleep.WriteXmlData(Node: TALXMLNode);
begin
  inherited WriteXmlData(Node);
  if FTimeout>0 then Node.Attributes['timeout']:=FTimeout;
end;

{ TBisSupportCommands }

function TBisSupportCommands.GetItem(Index: Integer): TBisSupportCommand;
begin
  Result:=TBisSupportCommand(inherited Items[Index]);
end;

function TBisSupportCommands.Find(const Tag: String): TBisSupportCommand;
var
  i: Integer;
  Item: TBisSupportCommand;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Tag,Tag) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisSupportCommands.Add(Command: TBisSupportCommand): Boolean;
begin
  Result:=inherited Add(Command)>-1;
end;

function TBisSupportCommands.AddShutdown(Timeout: Integer; const Message: String; Forced,Reboot: Boolean): TBisSupportShutdown;
begin
  Result:=TBisSupportShutdown.Create;
  Result.Timeout:=Timeout;
  Result.Message:=Message;
  Result.Forced:=Forced;
  Result.Reboot:=Reboot;
  Add(Result);
end;

function TBisSupportCommands.AddProcesses: TBisSupportProcesses;
begin
  Result:=TBisSupportProcesses.Create;
  Add(Result);
end;

function TBisSupportCommands.AddStatus: TBisSupportStatus;
begin
  Result:=TBisSupportStatus.Create;
  Add(Result);
end;

function TBisSupportCommands.AddStart(const ProcessName: String): TBisSupportStart;
begin
  Result:=TBisSupportStart.Create;
  Result.ProcessName:=ProcessName;
  Add(Result);
end;

function TBisSupportCommands.AddStop(const ProcessName: String): TBisSupportStop;
begin
  Result:=TBisSupportStop.Create;
  Result.ProcessName:=ProcessName;
  Add(Result);
end;

function TBisSupportCommands.AddSleep(const Timeout: Integer): TBisSupportSleep;
begin
  Result:=TBisSupportSleep.Create;
  Result.Timeout:=Timeout;
  Add(Result);
end;

procedure TBisSupportCommands.CopyFrom(Source: TBisSupportCommands; WithClear: Boolean=true);
var
  i: Integer;
  ItemSource, Item: TBisSupportCommand;
begin
  if WithClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      ItemSource:=Source.Items[i];

      Item:=TBisSupportCommandClass(ItemSource.ClassType).Create;
      Item.CopyFrom(ItemSource);
      
      Add(Item);
    end;
  end;
end;

{ TBisSupportRequest }

constructor TBisSupportRequest.Create;
begin
  inherited Create;
  FCommands:=TBisSupportCommands.Create;
end;

destructor TBisSupportRequest.Destroy;
begin
  FCommands.Free;
  inherited Destroy;
end;

procedure TBisSupportRequest.LoadFromStream(Stream: TStream; AFormat: TBisSupportStreamFormat);

  procedure LoadRawStream;
  var
    Reader: TReader;
    ATag: String;
    AName: String;
    AClass: TBisSupportCommandClass;
    Command: TBisSupportCommand;
  begin
    Reader:=TReader.Create(Stream,GetMemoryPageSize);
    try
      FSuccess:=Reader.ReadBoolean;
      FError:=Reader.ReadString;
      FRnd:=Reader.ReadString;
      Reader.ReadListBegin;
      while not Reader.EndOfList do begin
        ATag:=Reader.ReadString;
        AName:=Reader.ReadString;
        Command:=FCommands.Find(ATag);
        if not Assigned(Command) then begin
          AClass:=FindClassByName(AName);
          if Assigned(AClass) then begin
            Command:=AClass.Create;
            Command.Tag:=ATag;
            FCommands.Add(Command);
            Command.ReadRawData(Reader);
          end;
        end else
          Command.ReadRawData(Reader);
      end;
      Reader.ReadListEnd;
    finally
      Reader.Free;
    end;
  end;

  procedure LoadXmlStream;
  var
    Xml: TALXMLDocument;
    i,j,x: Integer;
    Node: TALXMLNode;
    SupportNode: TALXMLNode;
    CommandsNode: TALXMLNode;
    AName, ATag: String;
    Command: TBisSupportCommand;
    AClass: TBisSupportCommandClass;
  begin
    Xml:=TALXMLDocument.Create(nil);
    try
      Xml.LoadFromStream(Stream);
      for i:=0 to Xml.ChildNodes.Count-1 do begin
        Node:=Xml.ChildNodes[i];
        if AnsiSameText(Node.NodeName,'support') then begin
          SupportNode:=Node;
          FRnd:=VarToStrDef(SupportNode.Attributes['rnd'],'');
          FSuccess:=Boolean(VarToIntDef(SupportNode.Attributes['success'],0));
          FError:=VarToStrDef(SupportNode.Attributes['error'],'');
          for j:=0 to SupportNode.ChildNodes.Count-1 do begin
            Node:=SupportNode.ChildNodes[j];
            if AnsiSameText(Node.NodeName,'commands') then begin
              CommandsNode:=Node;
              for x:=0 to CommandsNode.ChildNodes.Count-1 do begin
                Node:=CommandsNode.ChildNodes[x];
                AName:=Node.NodeName;
                ATag:=VarToStrDef(Node.Attributes['tag'],'');
                Command:=FCommands.Find(ATag);
                if not Assigned(Command) then begin
                  AClass:=FindClassByName(AName);
                  if Assigned(AClass) then begin
                    Command:=AClass.Create;
                    Command.Tag:=ATag;
                    FCommands.Add(Command);
                    Command.ReadXmlData(Node);
                  end;
                end else
                  Command.ReadXmlData(Node);
              end;
            end;
          end;
        end;
      end;
    finally
      Xml.Free;
    end;
  end;
  
begin
  case AFormat of
    sfRaw: LoadRawStream;
    sfXml: LoadXmlStream;
  end;
end;

procedure TBisSupportRequest.SaveToStream(Stream: TStream; AFormat: TBisSupportStreamFormat);

  procedure SaveRawStream;
  var
    Writer: TWriter;
    i: Integer;
    Command: TBisSupportCommand;
  begin
    Writer:=TWriter.Create(Stream,GetMemoryPageSize);
    try
      Writer.WriteBoolean(FSuccess);
      Writer.WriteString(FError);
      Writer.WriteString(FRnd);
      Writer.WriteListBegin;
      for i:=0 to FCommands.Count-1 do begin
        Command:=FCommands[i];
        Writer.WriteString(Command.Tag);
        Writer.WriteString(Command.Name);
        Command.WriteRawData(Writer);
      end;
      Writer.WriteListEnd;
    finally
      Writer.Free;
    end;
  end;

  procedure SaveXmlStream;
  var
    Xml: TALXMLDocument;
    SupportNode: TALXMLNode;
    CommandsNode: TALXMLNode;
    i: Integer;
    Command: TBisSupportCommand;
    Node: TALXMLNode;
  begin
    Xml:=TALXMLDocument.Create(nil);
    try
      Xml.Active:=true;
     { Xml.Version:='1.0';
      Xml.Encoding:='windows-1251';
      Xml.StandAlone:='yes'; }
      SupportNode:=Xml.AddChild('support');
      SupportNode.Attributes['rnd']:=FRnd;
      SupportNode.Attributes['success']:=Integer(FSuccess);
      SupportNode.Attributes['error']:=FError;
      CommandsNode:=SupportNode.AddChild('commands');
      for i:=0 to FCommands.Count-1 do begin
        Command:=FCommands.Items[i];
        Node:=CommandsNode.AddChild(Command.Name);
        Node.Attributes['tag']:=Command.Tag;
        Command.WriteXmlData(Node);
      end;
      Xml.SaveToStream(Stream);
    finally
      Xml.Free;
    end;
  end;

begin
  case AFormat of
    sfRaw: SaveRawStream;
    sfXml: SaveXmlStream;
  end;
end;

initialization
  FClassList:=TClassList.Create;
  FClassList.Add(TBisSupportProcesses);
  FClassList.Add(TBisSupportStatus);
  FClassList.Add(TBisSupportShutdown);
  FClassList.Add(TBisSupportStart);
  FClassList.Add(TBisSupportStop);
  FClassList.Add(TBisSupportSleep);

finalization
  FClassList.Free;

end.
