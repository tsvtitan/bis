unit BisSupportFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList, DB, ImgList, ToolWin,
  ExtCtrls, Menus, ActnPopup, StdCtrls, CommCtrl, Buttons,
  VirtualTrees,
  BisFm, BisIfaces, BisDataSet, BisGradient, BisDBTree, BisDataParams, BisThreads,
  BisMainFm,
  BisSupportConnection, BisSupportTypes, BisWaitFm, BisControls;

type
  TBisSupportSendThreadStep=(tsBefore,tsAfter,tsError);

  TBisSupportSendThread=class;

  TBisSupportSendThreadStatusEvent=procedure (Thread: TBisSupportSendThread; Command: TBisSupportCommand;
                                              Step: TBisSupportSendThreadStep; E: Exception) of object;

  TBisSupportSendThread=class(TBisThread)
  private
    FCommands: TBisSupportCommands;
    FCommand: TBisSupportCommand;
    FConnection: TBisSupportConnection;
    FStep: TBisSupportSendThreadStep;
    FException: Exception;
    FOnStatus: TBisSupportSendThreadStatusEvent;
    procedure DoStatus;
  protected
    procedure DoWork; override;  
  public
    constructor Create; override;
    destructor Destroy; override;

    property OnStatus: TBisSupportSendThreadStatusEvent read FOnStatus write FOnStatus;
  end;

  TBisSupportProcessData=record
    Process: TBisSupportProcess;
  end;
  PBisSupportProcessData=^TBisSupportProcessData;

  TBisSupportComputer=class(TBisDataParam)
  private
    FParams: TBisDataValueParams;
  protected
    procedure SetDataSet(DataSet: TBisDataSet); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Params: TBisDataValueParams read FParams; 
  end;
  
  TBisSupportComputers=class(TBisDataParams)
  private
    function GetItem(Index: Integer): TBisSupportComputer;
  protected
    class function GetDataParamClass: TBisDataParamClass; override;
  public
    property Items[Index: Integer]: TBisSupportComputer read GetItem; default;
  end;
  
  TBisSupportForm = class(TBisMainForm)
    PanelData: TPanel;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    PanelTop: TPanel;
    LabelComputer: TLabel;
    ComboBoxComputers: TComboBox;
    PageControl: TPageControl;
    TabSheetProcesses: TTabSheet;
    TabSheetState: TTabSheet;
    PopupActionBarProcesses: TPopupActionBar;
    ActionRefreshProcesses: TAction;
    MenuItemRefreshProcesses: TMenuItem;
    ActionStartProcess: TAction;
    MenuItemStartProcess: TMenuItem;
    ActionStopProcess: TAction;
    MenuItemStopProcess: TMenuItem;
    MenuItemRestartProcess: TMenuItem;
    ActionRestartProcess: TAction;
    ActionRestartAllProcesses: TAction;
    MenuItemRestartAllProcesses: TMenuItem;
    ActionStartAllProcesses: TAction;
    ActionStopAllProcesses: TAction;
    N3: TMenuItem;
    MenuItemStartAllProcesses: TMenuItem;
    MenuItemStopAllProcesses: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    TabSheetStatus: TTabSheet;
    BitBtnReboot: TBitBtn;
    BitBtnShutdown: TBitBtn;
    procedure ComboBoxComputersChange(Sender: TObject);
    procedure ActionRefreshProcessesUpdate(Sender: TObject);
    procedure ActionRefreshProcessesExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ActionStartProcessUpdate(Sender: TObject);
    procedure ActionStartProcessExecute(Sender: TObject);
    procedure ActionStopProcessUpdate(Sender: TObject);
    procedure ActionStopProcessExecute(Sender: TObject);
    procedure ActionRestartProcessUpdate(Sender: TObject);
    procedure ActionRestartProcessExecute(Sender: TObject);
    procedure ActionRestartAllProcessesUpdate(Sender: TObject);
    procedure ActionRestartAllProcessesExecute(Sender: TObject);
    procedure ActionStartAllProcessesUpdate(Sender: TObject);
    procedure ActionStartAllProcessesExecute(Sender: TObject);
    procedure ActionStopAllProcessesUpdate(Sender: TObject);
    procedure ActionStopAllProcessesExecute(Sender: TObject);
    procedure BitBtnRebootClick(Sender: TObject);
    procedure BitBtnShutdownClick(Sender: TObject);
  private
    FTreeProcesses: TVirtualStringTree;
    FComputers: TBisSupportComputers;
    FShutReasons: TStringList;

    FThread: TBisSupportSendThread;
    FWaitForm: TBisWaitForm;
    FNeedCheck: Boolean;

    FSRefreshProcesses: String;
    FSStopProcess: String;
    FSStartProcesss: String;

    function SelectPassword(var Password: String): Boolean;
    procedure AddStrings(Source,Dest: TStrings);
    procedure RefreshComputers;
    procedure HideWait;
    procedure WaitFormCancel(Sender: TObject);
    procedure ShowWait(Timeout: Integer);
    procedure UpdateWait(Status: String);
    procedure ThreadEnd(Thread: TBisThread);
    procedure ThreadStatus(Thread: TBisSupportSendThread; Command: TBisSupportCommand;
                           Step: TBisSupportSendThreadStep; E: Exception);
    procedure StartSendThread(Commands: TBisSupportCommands; WithWait: Boolean);
    procedure Send(Commands: TBisSupportCommands; Title: String=''; Reasons: TStrings=nil;
                   WithWait: Boolean=True; WithPassword: Boolean=false);

    function FindProcess(ProcessName: String): TBisSupportProcess;

    procedure ClearTreeProcesses;
    procedure TreeProcessesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                                   TextType: TVSTTextType; var CellText: WideString);
    procedure TreeProcessesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
                                         Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeProcessesPaintBackground(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; R: TRect; var Handled: Boolean);
    function GetConnection: TBisSupportConnection;
    function GetProcess: TBisSupportProcess;
    function CanRebootComputer: Boolean;
    procedure RebootComputer;
    function CanShutdownComputer: Boolean;
    procedure ShutdownComputer;
    function CanRefreshProcesses: Boolean;
    procedure RefreshProcesses;
    procedure RefreshTreeProcesses(Processes: TBisSupportProcesses);
    function CanStartProcess: Boolean;
    procedure StartProcess;
    function CanStopProcess: Boolean;
    procedure StopProcess;
    function CanRestartProcess: Boolean;
    procedure RestartProcess;
    function CanRestartAllProcesses: Boolean;
    procedure RestartAllProcesses;
    function CanStartAllProcesses: Boolean;
    procedure StartAllProcesses;
    function CanStopAllProcesses: Boolean;
    procedure StopAllProcesses;
  protected
    procedure ReadDataParams(DataParams: TBisDataValueParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;
  published
    property SRefreshProcesses: String read FSRefreshProcesses write FSRefreshProcesses;
    property SStartProcesss: String read FSStartProcesss write FSStartProcesss;
    property SStopProcess: String read FSStopProcess write FSStopProcess;     
  end;

  TBisSupportFormIface=class(TBisMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisSupportForm: TBisSupportForm;

implementation

uses IdAssignedNumbers, ZLib,
     BisConsts, BisUtils, BisCore, BisDialogs, BisCrypter,
     BisSupportReasonsFm, BisSupportPasswordFm, BisSupportConsts;

{$R *.dfm}

{ TBisSupportFormIface }

constructor TBisSupportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisSupportForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stMdiChild;
end;

{ TBisSupportSendThread }

constructor TBisSupportSendThread.Create;
begin
  inherited Create;
  FCommands:=TBisSupportCommands.Create;
  FCommand:=nil;
end;

destructor TBisSupportSendThread.Destroy;
begin
  FCommand:=nil;
  FCommands.Free;
  inherited Destroy;
end;

procedure TBisSupportSendThread.DoStatus;
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self,FCommand,FStep,FException);
end;

procedure TBisSupportSendThread.DoWork;
var
  i: Integer;
  Request: TBisSupportRequest;
  Interrupt: Boolean;
begin
  if Assigned(FConnection) then begin
    Interrupt:=false;
    for i:=0 to FCommands.Count-1 do begin
      FException:=nil;
      if not Terminated then begin
        Request:=TBisSupportRequest.Create;
        try
          FCommand:=FCommands.Items[i];
          Request.Commands.OwnsObjects:=false;
          Request.Commands.Add(FCommand);
          try
            FStep:=tsBefore;
            Synchronize(DoStatus);
            if FConnection.Send(Request) then begin
              FStep:=tsAfter;
              Synchronize(DoStatus);
              if not FCommand.Success and (Trim(FCommand.Error)<>'') then
                raise Exception.Create(FCommand.Error);
            end else begin
              Interrupt:=true;
              raise Exception.Create(Request.Error);
            end;
          except
            On E: Exception do begin
              FStep:=tsError;
              FException:=E;
              Synchronize(DoStatus);
              if Interrupt then
                Terminate;
            end;
          end;
        finally
          Request.Free;
        end;
      end else
        break;
    end;
  end;
end;


{ TBisSupportComputer }

constructor TBisSupportComputer.Create;
begin
  inherited Create;
  FParams:=TBisDataValueParams.Create;
end;

destructor TBisSupportComputer.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

procedure TBisSupportComputer.SetDataSet(DataSet: TBisDataSet);
var
  Field: TField;
begin
  inherited SetDataSet(DataSet);

  FParams.Clear;
  Field:=DataSet.FindField(SFieldParams);
  if Assigned(Field) then
    FParams.CopyFromDataSet(Field.AsString);
end;

{ TBisSupportComputers }

class function TBisSupportComputers.GetDataParamClass: TBisDataParamClass;
begin
  Result:=TBisSupportComputer;
end;

function TBisSupportComputers.GetItem(Index: Integer): TBisSupportComputer;
begin
  Result:=TBisSupportComputer(inherited Items[Index]);
end;

{ TBisSupportForm }

constructor TBisSupportForm.Create(AOwner: TComponent);
var
  Column: TVirtualTreeColumn;
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  FComputers:=TBisSupportComputers.Create;

  FTreeProcesses:=TVirtualStringTree.Create(nil);
  FTreeProcesses.Parent:=TabSheetProcesses;
  FTreeProcesses.AlignWithMargins:=true;
  FTreeProcesses.Align:=alClient;
  FTreeProcesses.NodeDataSize:=SizeOf(TBisDBTreeNodeData);
  FTreeProcesses.Images:=ImageList;
  FTreeProcesses.PopupMenu:=PopupActionBarProcesses;
  with FTreeProcesses.TreeOptions do begin
    PaintOptions:=[toShowBackground,toShowHorzGridLines,toShowTreeLines,toShowVertGridLines,toThemeAware];
    AnimationOptions:=[];
    AutoOptions:=[];
    MiscOptions:=[toFullRepaintOnResize,toGridExtensions,toReportMode,toWheelPanning];
    SelectionOptions:=[toExtendedFocus,toCenterScrollIntoView{,toRightClickSelect},toMultiSelect];
  end;
  FTreeProcesses.OnGetText:=TreeProcessesGetText;
  FTreeProcesses.OnGetImageIndex:=TreeProcessesGetImageIndex;
  FTreeProcesses.OnPaintBackground:=TreeProcessesPaintBackground;

  FTreeProcesses.Header.Options:=[hoVisible,hoDblClickResize,hoAutoSpring,hoColumnResize,hoDrag];
  FTreeProcesses.Header.Height:=FTreeProcesses.DefaultNodeHeight;

  Column:=FTreeProcesses.Header.Columns.Add;
  Column.Text:='#';
  Column.Width:=25;
  Column.Alignment:=taRightJustify;
  Column.Options:=[coVisible,coResizable,coFixed];

  Column:=FTreeProcesses.Header.Columns.Add;
  Column.Text:='������������';
  Column.Width:=250;
  Column.Options:=[coEnabled,coResizable,coVisible,coAutoSpring];

  Column:=FTreeProcesses.Header.Columns.Add;
  Column.Text:='����� ������';
  Column.Width:=120;
  Column.Options:=[coEnabled,coResizable,coVisible{,coAutoSpring}];

  FShutReasons:=TStringList.Create;

  FThread:=TBisSupportSendThread.Create;
  FThread.OnStatus:=ThreadStatus;
  FThread.OnEnd:=ThreadEnd;

  PageControl.TabIndex:=0;

  FSRefreshProcesses:='���������� ������ ...';
  FSStartProcesss:= '�����: %s ...';
  FSStopProcess:='����: %s ...';

end;

destructor TBisSupportForm.Destroy;
begin
  FThread.Free;
  HideWait;
  FShutReasons.Free;
  ClearTreeProcesses;
  FTreeProcesses.Free;
  FComputers.Free;
  inherited Destroy;
end;

procedure TBisSupportForm.HideWait;
begin
  if Assigned(FWaitForm) then
    FreeAndNilEx(FWaitForm);
end;

procedure TBisSupportForm.WaitFormCancel(Sender: TObject);
var
  Commands: TBisSupportCommands;
  Form: TBisWaitForm;
begin
  Form:=TBisWaitForm(Sender);
  if Assigned(Form) then begin
    Form.ButtonCancel.Enabled:=false;
    Commands:=TBisSupportCommands.Create;
    try
      Commands.AddProcesses;
      Commands.AddSleep(250);
      FThread.Terminate;
    finally
      Commands.Free;
    end;
  end;
end;

procedure TBisSupportForm.ShowWait(Timeout: Integer);
begin
  HideWait;
  if not Assigned(FWaitForm) then begin
    FWaitForm:=TBisWaitForm.Create(Self);
    FWaitForm.Init;
    FWaitForm.Position:=poOwnerFormCenter;
    FWaitForm.FormStyle:=fsStayOnTop;
    FWaitForm.Timeout:=Timeout;
    FWaitForm.OnCancel:=WaitFormCancel;
    FWaitForm.Show;
    FWaitForm.Update;
  end;
end;

procedure TBisSupportForm.UpdateWait(Status: String);
begin
  if Assigned(FWaitForm) then begin
    FWaitForm.LabelStatus.Caption:=Status;
    FWaitForm.Update;
  end;
end;

procedure TBisSupportForm.ThreadEnd(Thread: TBisThread);
begin
  Thread.Synchronize(HideWait);
end;

procedure TBisSupportForm.ThreadStatus(Thread: TBisSupportSendThread; Command: TBisSupportCommand;
                                       Step: TBisSupportSendThreadStep; E: Exception);

  procedure ShowException;
  begin
    if Assigned(E) then
      ShowError(E.Message,5);
  end;

var
  Process: TBisSupportProcess;
begin
  if Assigned(Command) then begin

    if Command.Same(TBisSupportStatus) then begin
      case Step of
        tsAfter: begin
          FShutReasons.Assign(TBisSupportStatus(Command).ShutReasons);
          FNeedCheck:=TBisSupportStatus(Command).NeedCheck;
        end;
      end;
    end else if Command.Same(TBisSupportProcesses) then begin
      case Step of
        tsBefore: UpdateWait(FSRefreshProcesses);
        tsAfter: RefreshTreeProcesses(TBisSupportProcesses(Command));
        tsError: RefreshTreeProcesses(nil);
      end;
    end else if Command.Same(TBisSupportShutdown) then begin

    end else if Command.Same(TBisSupportStart) then begin
      Process:=FindProcess(TBisSupportStart(Command).ProcessName);
      if Assigned(Process) then
        case Step of
          tsBefore: UpdateWait(FormatEx(FSStartProcesss,[Process.Caption]));
          tsAfter: Process.State:=psUp;
          tsError: Process.State:=psUnknown;
        end;
    end else if Command.Same(TBisSupportStop) then begin
      Process:=FindProcess(TBisSupportStart(Command).ProcessName);
      if Assigned(Process) then
        case Step of
          tsBefore: UpdateWait(FormatEx(FSStopProcess,[Process.Caption]));
          tsAfter: Process.State:=psDown;
          tsError: Process.State:=psUnknown;
        end;
    end;

    if (Step=tsError) then
      ShowException
    else
      FTreeProcesses.Repaint;  

  end;
end;

procedure TBisSupportForm.StartSendThread(Commands: TBisSupportCommands; WithWait: Boolean);

  function GetTimeout: Integer;
  var
    i: Integer;
    Item: TBisSupportCommand;
    Plus: Integer;
  begin
    Result:=0;
    for i:=0 to Commands.Count-1 do begin
      Item:=Commands.Items[i];
      Plus:=10;
      if Item.Same(TBisSupportSleep) then
        Plus:=0
      else if Item.Same(TBisSupportProcesses) then
        Plus:=5;
      Inc(Result,Plus);
    end;
  end;

begin
  FThread.Stop;

  if WithWait then
    ShowWait(GetTimeout);

  FThread.FConnection:=GetConnection;
  FThread.FCommands.CopyFrom(Commands);
  FThread.Start;
end;

procedure TBisSupportForm.ActionRefreshProcessesExecute(Sender: TObject);
begin
  RefreshProcesses;
end;

procedure TBisSupportForm.ActionRefreshProcessesUpdate(Sender: TObject);
begin
  ActionRefreshProcesses.Enabled:=CanRefreshProcesses;
end;

procedure TBisSupportForm.ActionRestartAllProcessesExecute(Sender: TObject);
begin
  RestartAllProcesses;
end;

procedure TBisSupportForm.ActionRestartAllProcessesUpdate(Sender: TObject);
begin
  ActionRestartAllProcesses.Enabled:=CanRestartAllProcesses;
end;

procedure TBisSupportForm.ActionRestartProcessExecute(Sender: TObject);
begin
  RestartProcess;
end;

procedure TBisSupportForm.ActionRestartProcessUpdate(Sender: TObject);
begin
  ActionRestartProcess.Enabled:=CanRestartProcess;
end;

procedure TBisSupportForm.ActionStartAllProcessesExecute(Sender: TObject);
begin
   StartAllProcesses;
end;

procedure TBisSupportForm.ActionStartAllProcessesUpdate(Sender: TObject);
begin
  ActionStartAllProcesses.Enabled:=CanStartAllProcesses;
end;

procedure TBisSupportForm.ActionStartProcessExecute(Sender: TObject);
begin
  StartProcess;
end;

procedure TBisSupportForm.ActionStartProcessUpdate(Sender: TObject);
begin
  ActionStartProcess.Enabled:=CanStartProcess;
end;

procedure TBisSupportForm.ActionStopAllProcessesExecute(Sender: TObject);
begin
  StopAllProcesses;
end;

procedure TBisSupportForm.ActionStopAllProcessesUpdate(Sender: TObject);
begin
  ActionStopAllProcesses.Enabled:=CanStopAllProcesses;
end;

procedure TBisSupportForm.ActionStopProcessExecute(Sender: TObject);
begin
  StopProcess;
end;

procedure TBisSupportForm.ActionStopProcessUpdate(Sender: TObject);
begin
  ActionStopProcess.Enabled:=CanStopProcess;
end;

procedure TBisSupportForm.AddStrings(Source, Dest: TStrings);
var
  i: Integer;
  Index: Integer;
begin
  for i:=0 to Source.Count-1 do begin
    Index:=Dest.IndexOf(Source[i]);
    if Index=-1 then
      Dest.Add(Source[i]);
  end;
end;

function TBisSupportForm.GetConnection: TBisSupportConnection;
begin
  Result:=nil;
  if ComboBoxComputers.ItemIndex>-1 then begin
    Result:=TBisSupportConnection(ComboBoxComputers.Items.Objects[ComboBoxComputers.ItemIndex]);
    if not Result.Exists then begin
      Result:=nil;
      BitBtnReboot.Enabled:=false;
      BitBtnShutdown.Enabled:=false;
    end else begin
      BitBtnReboot.Enabled:=true;
      BitBtnShutdown.Enabled:=true;
    end;
  end else begin
    BitBtnReboot.Enabled:=false;
    BitBtnShutdown.Enabled:=false;
  end;
end;

function TBisSupportForm.GetProcess: TBisSupportProcess;
var
  Data: PBisSupportProcessData;
begin
  Result:=nil;
  if Assigned(FTreeProcesses.FocusedNode) then begin
    Data:=FTreeProcesses.GetNodeData(FTreeProcesses.FocusedNode);
    if Assigned(Data) then
      Result:=Data.Process;
  end;
end;

procedure TBisSupportForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisSupportForm.BitBtnRebootClick(Sender: TObject);
begin
  RebootComputer;
end;

procedure TBisSupportForm.BitBtnShutdownClick(Sender: TObject);
begin
  ShutdownComputer;
end;

procedure TBisSupportForm.RefreshComputers;
var
  i: Integer;
  Computer: TBisSupportComputer;
  Obj: TBisSupportConnection;
  UseProxy: Boolean;
begin
  ComboBoxComputers.Items.BeginUpdate;
  try
    ComboBoxComputers.Items.Clear;
    for i:=0 to FComputers.Count-1 do begin
      Computer:=FComputers.Items[i];
      if Computer.Enabled and Computer.NameExists then begin

        Obj:=TBisSupportConnection.Create(nil);
        Obj.Request.UserAgent:='';

        ComboBoxComputers.Items.AddObject(Computer.Name,Obj);

        with Computer.Params do begin
          Obj.Host:=AsString(SParamHost);
          Obj.Port:=AsInteger(SParamPort,IdPORT_HTTP);
          Obj.Path:=AsString(SParamPath);
          Obj.Protocol:=AsString(SParamProtocol);
          Obj.ConnectionType:=AsEnumeration(SParamType,TypeInfo(TBisSupportConnectionType),ctDirect);
          Obj.ConnectionTimeout:=AsInteger(SParamConnectionTimeout,Obj.ConnectionTimeout);
          Obj.ProxyParams.Clear;
          UseProxy:=AsBoolean(SParamUseProxy,false);
          if UseProxy then begin
            Obj.ProxyParams.ProxyServer:=AsString(SParamProxyHost);
            Obj.ProxyParams.ProxyPort:=AsInteger(SParamProxyPort,0);
            Obj.ProxyParams.ProxyUsername:=AsString(SParamProxyUser);
            Obj.ProxyParams.ProxyPassword:=AsString(SParamProxyPassword);
          end;
          Obj.RemoteAuto:=AsBoolean(SParamRemoteAuto,false);
          Obj.RemoteName:=AsString(SParamRemoteName);
          Obj.Dialer.UserName:=AsString(SParamModemUser);
          Obj.Dialer.Password:=AsString(SParamModemPassword);
          Obj.Dialer.Domain:=AsString(SParamModemDomain);
          Obj.Dialer.PhoneNumber:=AsString(SParamModemPhone);
          Obj.UseCrypter:=AsBoolean(SParamUseCrypter,false);
          Obj.CrypterAlgorithm:=AsEnumeration(SParamCrypterAlgorithm,TypeInfo(TBisCipherAlgorithm),caRC5);
          Obj.CrypterMode:=AsEnumeration(SParamCrypterMode,TypeInfo(TBisCipherMode),cmCTS);
          Obj.CrypterKey:=AsString(SParamCrypterKey);
          Obj.UseCompressor:=AsBoolean(SParamUseCompressor,false);
          Obj.CompressorLevel:=AsEnumeration(SParamCompressorLevel,TypeInfo(TCompressionLevel),clFastest);
          Obj.StreamFormat:=AsEnumeration(SParamStreamFormat,TypeInfo(TBisSupportStreamFormat),sfRaw);
          Obj.Request.UserAgent:=AsString(SParamUserAgent);
          Obj.AuthUserName:=AsString(SParamAuthUserName);
          Obj.AuthPassword:=AsString(SParamAuthPassword);
          Obj.CheckExists;
        end;
      end;

    end;
  finally
    ComboBoxComputers.Items.EndUpdate;
  end;
end;

procedure TBisSupportForm.ReadDataParams(DataParams: TBisDataValueParams);
begin
  inherited ReadDataParams(DataParams);
  if Assigned(DataParams) then begin
    with DataParams do begin
      FComputers.CopyFromDataSet(AsString(SParamComputers));
      RefreshComputers;
    end;
  end;
end;

function TBisSupportForm.SelectPassword(var Password: String): Boolean;
var
  Form: TBisSupportPasswordForm;
begin
  Form:=TBisSupportPasswordForm.Create(nil);
  try
    Result:=Form.ShowModal=mrOk;
    if Result then
      Password:=Form.EditPassword.Text;
  finally
    Form.Free;
  end;
end;

procedure TBisSupportForm.Send(Commands: TBisSupportCommands; Title: String='';
                               Reasons: TStrings=nil; WithWait: Boolean=true; WithPassword: Boolean=false);
var
  Form: TBisSupportReasonsForm;
  Connection: TBisSupportConnection;
  i: Integer;
  Command: TBisSupportCommand;
  AReason: String;
  Flag: Boolean;
  Password: String;
begin
  Connection:=GetConnection;
  if Assigned(Connection) then begin

    Flag:=true;
    if WithPassword then begin
      Flag:=SelectPassword(Password); 
      Flag:=Flag and (Trim(Password)<>'');
      if Flag then begin
        for i:=0 to Commands.Count-1 do
          if Commands[i].Same(TBisSupportPassword,true) then
            TBisSupportPassword(Commands[i]).Password:=Password;
      end;
    end;

    if Flag then
      if Assigned(Reasons) and (Reasons.Count>0) then begin
        Form:=TBisSupportReasonsForm.Create(nil);
        try
          Form.SetReasons(Reasons);
          Form.Title:=Title;
          if Form.ShowModal=mrOk then begin

            AReason:=Form.Reason;
            for i:=0 to Commands.Count-1 do begin
              Command:=Commands.Items[i];
              if not Command.Same(TBisSupportProcesses) then
                Command.Reason:=AReason;
            end;

            FTreeProcesses.Repaint;

            StartSendThread(Commands,WithWait);
          end;
        finally
          Form.Free;
        end;
      end else begin
        FTreeProcesses.Repaint;
        StartSendThread(Commands,WithWait);
      end;
  end;
end;

function TBisSupportForm.CanRebootComputer: Boolean;
var
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Result:=Assigned(Connection);
end;

procedure TBisSupportForm.RebootComputer;
var
  Commands: TBisSupportCommands;
begin
  if CanRebootComputer then begin
    Commands:=TBisSupportCommands.Create;
    try
      Commands.AddShutdown(0,'',true,true);
      Commands.AddSleep(250);
      Send(Commands,BitBtnReboot.Hint,FShutReasons,true,true);
    finally
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.CanShutdownComputer: Boolean;
var
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Result:=Assigned(Connection);
end;

procedure TBisSupportForm.ShutdownComputer;
var
  Commands: TBisSupportCommands;
begin
  if CanShutdownComputer then begin
    Commands:=TBisSupportCommands.Create;
    try
      Commands.AddShutdown(0,'',true,false);
      Commands.AddSleep(250);
      Send(Commands,BitBtnShutdown.Hint,FShutReasons,true,true);
    finally
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.CanRefreshProcesses: Boolean;
var
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Result:=Assigned(Connection);
end;

procedure TBisSupportForm.RefreshProcesses;
var
  Commands: TBisSupportCommands;
begin
  if CanRefreshProcesses then begin
    Commands:=TBisSupportCommands.Create;
    try
      Commands.AddStatus;
      Commands.AddProcesses;
      Commands.AddSleep(250);
      Send(Commands,'',nil,true);
    finally
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.FindProcess(ProcessName: String): TBisSupportProcess;
var
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
begin
  Result:=nil;
  Node:=FTreeProcesses.GetFirst;
  while Assigned(Node) do begin
    Data:=FTreeProcesses.GetNodeData(Node);
    if Assigned(Data) and Assigned(Data.Process) and
       AnsiSameText(Data.Process.Name,ProcessName) then begin
      Result:=Data.Process;
      break;
    end;
    Node:=FTreeProcesses.GetNext(Node);
  end;

end;

procedure TBisSupportForm.ClearTreeProcesses;
var
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
begin
  FTreeProcesses.BeginUpdate;
  try
    Node:=FTreeProcesses.GetLast;
    while Assigned(Node) do begin
      Data:=FTreeProcesses.GetNodeData(Node);
      if Assigned(Data) then
        Data.Process.Free;
      Node:=FTreeProcesses.GetPrevious(Node);
    end;
    FTreeProcesses.Clear;
  finally
    FTreeProcesses.EndUpdate;
  end;
end;

procedure TBisSupportForm.RefreshTreeProcesses(Processes: TBisSupportProcesses);
var
  i: Integer;
  Process, NewProcess: TBisSupportProcess;
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
begin
  ClearTreeProcesses;
  if Assigned(Processes) then begin
    FTreeProcesses.BeginUpdate;
    try
      for i:=0 to Processes.Count-1 do begin
        Process:=Processes.Items[i];

        NewProcess:=TBisSupportProcess.Create;
        NewProcess.CopyFrom(Process);

        Node:=FTreeProcesses.AddChild(nil,nil);
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Data) then
          Data.Process:=NewProcess;
      end;
    finally
      FTreeProcesses.EndUpdate;
    end;
  end;
end;

function TBisSupportForm.CanRestartProcess: Boolean;
var
  Process: TBisSupportProcess;
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Process:=GetProcess;
  Result:=Assigned(Connection) and Assigned(Process);
end;

procedure TBisSupportForm.RestartProcess;
var
  Commands: TBisSupportCommands;
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
  Reasons: TStringList;
  NeedCheck: Boolean;
begin
  if CanRestartAllProcesses then begin
    Commands:=TBisSupportCommands.Create;
    Reasons:=TStringList.Create;
    try
      NeedCheck:=false;

      Node:=FTreeProcesses.GetLast;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) and (vsSelected in Node.States) then begin
          Commands.AddStop(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StopReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetPrevious(Node);
      end;
      Commands.AddProcesses;

      Node:=FTreeProcesses.GetFirstSelected;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) then begin
          Commands.AddStart(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StartReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetNextSelected(Node);
      end;
      Commands.AddProcesses;

      Send(Commands,ActionRestartAllProcesses.Caption,Reasons,true,NeedCheck);
    finally
      Reasons.Free;
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.CanStartProcess: Boolean;
var
  Process: TBisSupportProcess;
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Process:=GetProcess;
  Result:=Assigned(Connection) and
          Assigned(Process) and (Process.State<>psUp);
end;

procedure TBisSupportForm.StartProcess;
var
  Commands: TBisSupportCommands;
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
  Reasons: TStringList;
  NeedCheck: Boolean;
begin
  if CanStartProcess then begin
    Commands:=TBisSupportCommands.Create;
    Reasons:=TStringList.Create;
    try
      NeedCheck:=false;
      Node:=FTreeProcesses.GetFirstSelected;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) then begin
          Commands.AddStart(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StartReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetNextSelected(Node);
      end;
      Commands.AddProcesses;
      Send(Commands,ActionStartProcess.Caption,Reasons,true,NeedCheck);
    finally
      Reasons.Free;
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.CanStopProcess: Boolean;
var
  Process: TBisSupportProcess;
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Process:=GetProcess;
  Result:=Assigned(Connection) and
          Assigned(Process) and (Process.State<>psDown);
end;

procedure TBisSupportForm.StopProcess;
var
  Commands: TBisSupportCommands;
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
  Reasons: TStringList;
  NeedCheck: Boolean;
begin
  if CanStopProcess then begin
    Commands:=TBisSupportCommands.Create;
    Reasons:=TStringList.Create;
    try
      NeedCheck:=false;
      Node:=FTreeProcesses.GetLast;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) and (vsSelected in Node.States) then begin
          Commands.AddStop(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StopReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetPrevious(Node);
      end;
      Commands.AddProcesses;
      Send(Commands,ActionStopProcess.Caption,Reasons,true,NeedCheck);
    finally
      Reasons.Free;
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.CanStopAllProcesses: Boolean;
var
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Result:=Assigned(Connection) and (FTreeProcesses.TotalCount>0);
end;

procedure TBisSupportForm.StopAllProcesses;
var
  Commands: TBisSupportCommands;
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
  Reasons: TStringList;
  NeedCheck: Boolean;
begin
  if CanStopAllProcesses then begin
    Commands:=TBisSupportCommands.Create;
    Reasons:=TStringList.Create;
    try
      NeedCheck:=false;
      Node:=FTreeProcesses.GetLast;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) then begin
          Commands.AddStop(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StopReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetPrevious(Node);
      end;
      Commands.AddProcesses;
      Send(Commands,ActionStopAllProcesses.Caption,Reasons,true,NeedCheck);
    finally
      Reasons.Free;
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.CanStartAllProcesses: Boolean;
var
  Connection: TBisSupportConnection;
begin
  Connection:=GetConnection;
  Result:=Assigned(Connection) and (FTreeProcesses.TotalCount>0);
end;

procedure TBisSupportForm.StartAllProcesses;
var
  Commands: TBisSupportCommands;
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
  Reasons: TStringList;
  NeedCheck: Boolean;
begin
  if CanStartAllProcesses then begin
    Commands:=TBisSupportCommands.Create;
    Reasons:=TStringList.Create;
    try
      NeedCheck:=false;
      Node:=FTreeProcesses.GetFirst;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) then begin
          Commands.AddStart(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StartReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetNext(Node);
      end;
      Commands.AddProcesses;
      Send(Commands,ActionStartAllProcesses.Caption,Reasons,true,NeedCheck);
    finally
      Reasons.Free;
      Commands.Free;
    end;
  end;
end;

function TBisSupportForm.CanRestartAllProcesses: Boolean;
begin
  Result:=CanStopAllProcesses and CanStartAllProcesses;
end;

procedure TBisSupportForm.RestartAllProcesses;
var
  Commands: TBisSupportCommands;
  Node: PVirtualNode;
  Data: PBisSupportProcessData;
  Reasons: TStringList;
  NeedCheck: Boolean;
begin
  if CanRestartAllProcesses then begin
    Commands:=TBisSupportCommands.Create;
    Reasons:=TStringList.Create;
    try
      NeedCheck:=false;

      Node:=FTreeProcesses.GetLast;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) then begin
          Commands.AddStop(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StopReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetPrevious(Node);
      end;
      Commands.AddProcesses;

      Node:=FTreeProcesses.GetFirst;
      while Assigned(Node) do begin
        Data:=FTreeProcesses.GetNodeData(Node);
        if Assigned(Node) then begin
          Commands.AddStart(Data.Process.Name);
          if Data.Process.NeedCheck then
            NeedCheck:=true;
          AddStrings(Data.Process.StartReasons,Reasons);
        end;
        Node:=FTreeProcesses.GetNext(Node);
      end;
      Commands.AddProcesses;

      Send(Commands,ActionRestartAllProcesses.Caption,Reasons,true,NeedCheck);
    finally
      Reasons.Free;
      Commands.Free;
    end;
  end;
end;

procedure TBisSupportForm.TreeProcessesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                                               TextType: TVSTTextType; var CellText: WideString);
var
  Data: PBisSupportProcessData;
begin
  Data:=Sender.GetNodeData(Node);
  if Assigned(Data) then begin
    case Column of
      0: CellText:=IntToStr(Node.Index+1);
      1: CellText:=iff(Trim(Data.Process.Caption)<>'',Data.Process.Caption,Data.Process.Name);
      2: CellText:=iff(Data.Process.StartTime<>NullDate,DateTimeToStr(Data.Process.StartTime),'');
    end;
  end;
end;

procedure TBisSupportForm.TreeProcessesPaintBackground(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; R: TRect; var Handled: Boolean);
begin
  TargetCanvas.Brush.Style:=bsSolid;
  DrawGradient(TargetCanvas,Sender.ClientRect,gsVertical,clWhite,ColorSelected);
  Handled:=true;
end;

procedure TBisSupportForm.TreeProcessesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
                                                     Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PBisSupportProcessData;
begin
  Data:=Sender.GetNodeData(Node);
  if Assigned(Data) then begin
    case Column of
      1: begin
        case Data.Process.State of
          psUp: ImageIndex:=1;
          psDown: ImageIndex:=2;
        else
          ImageIndex:=0;
        end;
      end;
    end;
  end;
end;

procedure TBisSupportForm.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage=TabSheetProcesses then begin
    RefreshProcesses;
  end;
end;

procedure TBisSupportForm.ComboBoxComputersChange(Sender: TObject);
begin
  ClearTreeProcesses;
  RefreshProcesses;
end;


end.
