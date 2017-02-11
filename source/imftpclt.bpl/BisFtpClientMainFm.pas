unit BisFtpClientMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  ExtCtrls, ComCtrls, ImgList, StdCtrls, Buttons, ActnList, Menus,
  ActnPopup, ToolWin, ShellAPI, AppEvnts, CommCtrl,

  IdFtp, IdComponent,

  BisFm, BisIfaces, BisLogger;

type
  TBisIdFtpClient=class(TIdFtp)
  end;

  TBisFtpClientSendStatus=(ssActive,ssSuccess,ssFail);

  TBisFtpClientMainForm=class;

  TBisFtpClientThread=class(TThread)
  private
    FFileStream: TFileStream;
    FFtp: TBisIdFtpClient;
    FParent: TBisFtpClientMainForm;
    FLoggerType: TBisLoggerType;
    FMessage: String;
    FFileName: String;
    FSendStatus: TBisFtpClientSendStatus;
    FMin: Integer;
    FMax: Integer;
    FPosition: Integer;
    FCurrent: Integer;
    FAllCount: Integer;
    FSize: Int64;
    FAllSize: Int64;
    FFirstTime: TTime;
    FFirstSize: Int64;
    FTime: TTime;
    procedure LoggerWrite;
    procedure ChangeStatus;
    procedure Progress;
    procedure UpdateCounters;
    procedure DoStatus(Message: String; LogType: TBisLoggerType=ltInformation);
    procedure FtpWorkBegin(ASender: TObject; AWorkMode: TWorkMode;  AWorkCountMax: Integer);
    procedure FtpWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure FtpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
    procedure FtpStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute; override;

    property Parent: TBisFtpClientMainForm read FParent write FParent;
  end;

  TBisFtpClientMainForm = class(TBisForm)
    ImageList: TImageList;
    ActionList: TActionList;
    GroupBoxFiles: TGroupBox;
    PopupActionBarFiles: TPopupActionBar;
    ActionAddFiles: TAction;
    ActionDelFiles: TAction;
    ActionClearFiles: TAction;
    GroupBoxUpload: TGroupBox;
    MenuItemAddFiles: TMenuItem;
    MenuItemDelFiles: TMenuItem;
    MenuItemClearFiles: TMenuItem;
    ListViewFiles: TListView;
    ControlBarFiles: TControlBar;
    ToolBarFiles: TToolBar;
    ToolButtonAddFiles: TToolButton;
    ToolButtonDelFiles: TToolButton;
    ToolButtonClearFiles: TToolButton;
    OpenDialog: TOpenDialog;
    BitBtnSend: TBitBtn;
    BitBtnPause: TBitBtn;
    ProgressBar: TProgressBar;
    PanelLogo: TPanel;
    ImageLogo: TImage;
    StatusBar: TStatusBar;
    ActionSend: TAction;
    ActionPause: TAction;
    ActionStop: TAction;
    BitBtnStop: TBitBtn;
    LabelFile: TLabel;
    LabelSize: TLabel;
    LabelTime: TLabel;
    LabelSpeed: TLabel;
    N1: TMenuItem;
    MenuItemQueue: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    ActionQueue: TAction;
    procedure ActionAddFilesExecute(Sender: TObject);
    procedure ActionAddFilesUpdate(Sender: TObject);
    procedure ActionDelFilesExecute(Sender: TObject);
    procedure ActionDelFilesUpdate(Sender: TObject);
    procedure ActionClearFilesExecute(Sender: TObject);
    procedure ActionClearFilesUpdate(Sender: TObject);
    procedure ActionSendExecute(Sender: TObject);
    procedure ActionSendUpdate(Sender: TObject);
    procedure ActionPauseExecute(Sender: TObject);
    procedure ActionPauseUpdate(Sender: TObject);
    procedure ActionStopExecute(Sender: TObject);
    procedure ActionStopUpdate(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure ImageLogoClick(Sender: TObject);
    procedure ActionQueueExecute(Sender: TObject);
    procedure ActionQueueUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FThread: TBisFtpClientThread;
    FProfileFileName: String;
    FInProcess: Boolean;
    FExtensions: TStringList;
    FFilters: TStringList;
    FResultQueue: String;
    FResultActive: String;
    FResultSuccess: String;
    FResultFail: String;
    FThreadBreaked: Boolean;

    FFirstFilter: String;
    FFilter: String;

    FMessage: String;
    FServerHost: String;
    FServerPort: Integer;
    FServerDir: String;
    FServerPassive: Boolean;
    FServerUserName: String;
    FServerPassword: String;
    FListFileName: String;
    FTimeOut: Integer;
    FCompanyName: String;
    FSite: String;
    FLowerCase: Boolean;

    procedure LoadProfile;
    procedure SaveProfile;
    procedure LoadLogo;
    procedure LoadList;
    procedure SaveList;
    procedure RefreshExtensions;
    procedure AddFilesFromList(Files: TStrings);
    function CheckExtension(FileName: String): Boolean;
    function QueueExists(Files: TStrings=nil): Boolean;
    procedure ThreadTerminate(Sender: TObject);
    procedure EnableCounters(AEnabled: Boolean);
    procedure NewProgress(Min,Max,Position: Integer);
    procedure UpdateCounters(Current: Integer; AllCount: Integer; ASize: Int64; AllSize: Int64; ATime: TTime);
    procedure ResizeListView;
    procedure WMDropFiles (var Msg: TMessage); message WM_DROPFILES;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeStatus(FileName: String; SendStatus: TBisFtpClientSendStatus);

    procedure AddFiles;
    function CanAddFiles: Boolean;
    procedure DelFiles;
    function CanDelFiles: Boolean;
    procedure ClearFiles;
    function CanClearFiles: Boolean;
    procedure Send;
    function CanSend: Boolean;
    procedure Pause;
    function CanPause: Boolean;
    procedure Stop;
    function CanStop: Boolean;
    procedure Queue;
    function CanQueue: Boolean;

    property InProcess: Boolean read FInProcess write FInProcess;
    property ThreadBreaked: Boolean read FThreadBreaked;

    property ServerHost: String read FServerHost;
    property ServerPort: Integer read FServerPort;
    property ServerDir: String read FServerDir;
    property ServerPassive: Boolean read FServerPassive;
    property ServerUserName: String read FServerUserName;
    property ServerPassword: String read FServerPassword;

    property TimeOut: Integer read FTimeOut;
    property CompanyName: String read FCompanyName;
    property LowerCase: Boolean read FLowerCase;

  end;

  TBisFtpClientMainFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisFtpClientMainForm: TBisFtpClientMainForm;

var
  MainIface: TBisIface=nil;

implementation

{$R *.dfm}

uses BisCore, BisUtils, BisPicture, BisDialogs, BisGradient, BisConsts;

{ TBisFtpClientThread }

constructor TBisFtpClientThread.Create;
begin
  inherited Create(true);
end;

destructor TBisFtpClientThread.Destroy;
begin
  FreeAndNilEx(FFtp);
  FreeAndNilEx(FFileStream);
  FParent:=nil;
  TerminateThread(Handle,0);
  inherited Destroy;
end;

procedure TBisFtpClientThread.LoggerWrite;
begin
  if Assigned(FParent) then
    FParent.LoggerWrite(FMessage,FLoggerType);
end;

procedure TBisFtpClientThread.ChangeStatus;
begin
  if Assigned(FParent) then begin
    FParent.ChangeStatus(FFileName,FSendStatus);
    UpdateCounters;
  end;
end;

procedure TBisFtpClientThread.Progress;
begin
  if Assigned(FParent) then begin
    FParent.NewProgress(FMin,FMax,FPosition);
    UpdateCounters;
  end;
end;

procedure TBisFtpClientThread.UpdateCounters;
begin
  if Assigned(FParent) then begin
    FTime:=FFirstTime-Time;
    FParent.UpdateCounters(FCurrent,FAllCount,FSize,FAllSize,FTime);
  end;
end;

procedure TBisFtpClientThread.DoStatus(Message: String; LogType: TBisLoggerType=ltInformation);
begin
  FMessage:=Message;
  FLoggerType:=LogType;
  Synchronize(LoggerWrite);
end;

procedure TBisFtpClientThread.FtpStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  FMessage:=AStatusText;
  FLoggerType:=ltInformation;
  Synchronize(LoggerWrite);
end;

procedure TBisFtpClientThread.FtpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
begin
  if AWorkMode=wmWrite then begin
    FPosition:=AWorkCount;
    FSize:=FFirstSize+AWorkCount;
    Synchronize(Progress);
  end;
end;

procedure TBisFtpClientThread.FtpWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Integer);
begin
  if AWorkMode=wmWrite then begin
    FMin:=0;
    FMax:=AWorkCountMax;
    FPosition:=0;
    Synchronize(Progress);
  end;
end;

procedure TBisFtpClientThread.FtpWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if AWorkMode=wmWrite then begin
    FMin:=0;
    FMax:=0;
    FPosition:=0;
    Synchronize(Progress);
  end;
end;

procedure TBisFtpClientThread.Execute;


  function RemoveNotFileNameChar(FileName: string): string;
  var
    i: Integer;
  const
    Chars: set of char = ['/','\','"','?','*','<','>',':','|'];
  begin
    Result:='';
    for i:=1 to Length(FileName) do begin
      if not (FileName[i] in Chars) then begin
        Result:=Result+FileName[i];
      end;
    end;
  end;

  function SendFile(FileName: String): Boolean;
  var
    S: String;
    S1: String;
    S2: String;
    S3: String;
    S4: String;
    ASize: Int64;
  begin
    FreeAndNilEx(FFileStream);
    try
      Result:=false;
      try
        FFileStream:=TFileStream.Create(FileName,fmOpenRead);
        S1:=RemoveNotFileNameChar(FParent.CompanyName);
        S2:=ChangeFileExt(ExtractFileName(FileName),'');
        S3:=DateToStr(Date);
        S4:=ExtractFileExt(FileName);
        S:=FormatEx('%s_%s_%s%s',[S1,S2,S3,S4]);
        if FParent.LowerCase then
          S:=AnsiLowerCase(S);

        ASize:=FFtp.Size(S);

        if ASize>=0 then begin

          if ASize<=FFileStream.Size then begin
            FFileStream.Position:=ASize;
//            FFirstSize:=FFirstSize+(FFileStream.Size-ASize);
            FAllSize:=FAllSize-ASize;
          end else
            FFileStream.Position:=0;

          FFtp.Put(FFileStream,S,true);
        end else begin
          FFileStream.Position:=0;
          FFtp.Put(FFileStream,S,false);
        end;

        Result:=true;
      except
        on E: Exception do
          DoStatus(E.Message,ltError);
      end;
    finally
      FFileStream.Free;
    end;
  end;

var
  Files: TStringList;
  i: Integer;
  Sended: Boolean;
begin
  if Assigned(FParent) and Assigned(Core) then begin
    Files:=TStringList.Create;
    FFtp:=TBisIdFtpClient.Create(nil);
    FParent.InProcess:=true;
    try
      if FParent.QueueExists(Files) then begin

        FFtp.Host:=FParent.ServerHost;
        FFtp.Port:=FParent.ServerPort;
        FFtp.Passive:=FParent.ServerPassive;
        FFtp.Username:=FParent.ServerUserName;
        FFtp.Password:=FParent.ServerPassword;
        FFtp.OnWork:=FtpWork;
        FFtp.OnWorkBegin:=FtpWorkBegin;
        FFtp.OnWorkEnd:=FtpWorkEnd;
        FFtp.OnStatus:=FtpStatus;

        FSize:=0;
        FFirstSize:=0;
        FAllSize:=0;
        for i:=0 to Files.Count-1 do
          FAllSize:=FAllSize+GetFileSizeEx(Files[i]);

        FFirstTime:=Time;
        for i:=0 to Files.Count-1 do begin

          FFileName:=Files[i];

          if i>0 then
            Sleep(FParent.TimeOut);

          try
            if not FFtp.Connected then begin
              FFtp.Connect;
              if FFtp.Connected then
                FFtp.ChangeDir(FParent.ServerDir);
            end;

            if FParent.ThreadBreaked then
              Break;

            if FFtp.Connected then begin


              FSendStatus:=ssActive;
              FCurrent:=0;
              FAllCount:=Files.Count;
              Synchronize(ChangeStatus);

              Sleep(FParent.TimeOut);

              FSendStatus:=ssFail;
              Sended:=SendFile(FFileName);

              if Sended then begin
                FCurrent:=i+1;
                FFirstSize:=FSize;
              end;

              FSendStatus:=iff(Sended,ssSuccess,ssFail);
              Synchronize(ChangeStatus);
            end;

          except
            On E: Exception do
              DoStatus(E.Message,ltError);
          end;
        end;
      end;
    finally
      FParent.InProcess:=false;
      FFtp.Free;
      FFtp:=nil;
      Files.Free;
    end;
  end;
end;

{ TBisFtpClientMainFormIface }

constructor TBisFtpClientMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisFtpClientMainForm;
  AutoShow:=true;
  ApplicationCreateForm:=true;
end;

{ TBisFtpClientMainForm }

constructor TBisFtpClientMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  DragAcceptFiles(Handle, true);

  SizesStored:=true;
  FInProcess:=false;

  FExtensions:=TStringList.Create;
  FFilters:=TStringList.Create;

  Caption:=ConfigRead('Caption',Caption);
  FProfileFileName:=ConfigRead('Profile',FProfileFileName);
  FProfileFileName:=ExpandFileNameEx(FProfileFileName);

  FListFileName:=ConfigRead('List',FListFileName);
  FListFileName:=ExpandFileNameEx(FListFileName);

  FFirstFilter:=ConfigRead('FirstFilter',FFirstFilter);
  FFilter:=ConfigRead('Filter',FFilter);

  if Trim(FFirstFilter)<>'' then
    OpenDialog.Filter:=FFirstFilter;

  if Trim(FFilter)<>'' then
    if Trim(OpenDialog.Filter)<>'' then
      OpenDialog.Filter:=OpenDialog.Filter+'|'+FFilter
    else
      OpenDialog.Filter:=FFilter;

  FResultQueue:='�������';
  FResultActive:='��������';
  FResultSuccess:='�������';
  FResultFail:='������';

  FServerHost:=ConfigRead('ServerHost',FServerHost);
  FServerPort:=ConfigRead('ServerPort',FServerPort);
  FServerDir:=ConfigRead('ServerDir',FServerDir);
  FServerPassive:=ConfigRead('ServerPassive',FServerPassive);
  FServerUserName:=ConfigRead('ServerUserName',FServerUserName);
  FServerPassword:=ConfigRead('ServerPassword',FServerPassword);


  FMessage:=ConfigRead('Message',FMessage);
  FTimeOut:=ConfigRead('TimeOut',FTimeOut);
  FCompanyName:=ConfigRead('CompanyName',FCompanyName);
  FSite:=ConfigRead('Site',FSite);
  FLowerCase:=ConfigRead('LowerCase',FLowerCase);

  ImageLogo.Cursor:=iff(Trim(FSite)<>'',crHandPoint,crDefault);

  RefreshExtensions;

  LoadProfile;
  LoadLogo;
  LoadList;

  ActionAddFiles.Update;
  ActionDelFiles.Update;
  ActionClearFiles.Update;
  ActionSend.Update;
  ActionPause.Update;
  ActionStop.Update;
end;

destructor TBisFtpClientMainForm.Destroy;
begin
  Stop;
  SaveList;
  SaveProfile;
  FFilters.Free;
  FExtensions.Free;
  inherited Destroy;
end;

procedure TBisFtpClientMainForm.EnableCounters(AEnabled: Boolean);
begin
  LabelFile.Enabled:=AEnabled;
  LabelSize.Enabled:=AEnabled;
  LabelTime.Enabled:=AEnabled;
  LabelSpeed.Enabled:=AEnabled;
end;

procedure TBisFtpClientMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Suspended: Boolean;
begin
  if FInProcess and Assigned(FThread) then begin
    Suspended:=FThread.Suspended;
    if not Suspended then
      FThread.Suspend;
    CanClose:=ShowQuestion('�������� �� ���������. ����� �� ���������?',mbNo)=mrYes;
    if not CanClose then
      if not Suspended then
        FThread.Resume;
  end else
    CanClose:=true;
end;

procedure TBisFtpClientMainForm.ImageLogoClick(Sender: TObject);
begin
  if Trim(FSite)<>'' then
    ShellExecute(0,'open',PChar(FSite),nil,nil,SW_SHOW);
end;

procedure TBisFtpClientMainForm.LoadLogo;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  PanelLogo.Visible:=false;
  try
    if Core.LocalBase.ReadParam('Logo',Stream) then begin
      Stream.Position:=0;
      TBisPicture(ImageLogo.Picture).LoadFromStream(Stream);
    end;
  finally
    PanelLogo.Visible:=not TBisPicture(ImageLogo.Picture).Empty;
    Stream.Free;
  end;
end;

procedure TBisFtpClientMainForm.LoadProfile;
begin
  try
    if FileExists(FProfileFileName) then
      Core.Profile.LoadFromFile(FProfileFileName);
  except
    on E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

procedure TBisFtpClientMainForm.SaveProfile;
begin
  try
    if FileExists(FProfileFileName) then
      Core.Profile.UpdateFile;
  except
    on E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

procedure TBisFtpClientMainForm.RefreshExtensions;
var
  S: String;
  S1: String;
  Str: TStringList;
  i: Integer;
begin
  Str:=TStringList.Create;
  try
    FExtensions.Clear;
    S:=FFilter;
    GetStringsByString(S,'|',Str);
    for i:=0 to Str.Count-1 do begin
      if Odd(i) then begin
        S1:=Str[i];
        if Length(S1)>0 then begin
          if S1[1]='*' then
            S1:=Copy(S1,2,Length(S1));
          FExtensions.Add(S1);
        end;
      end else
        FFilters.Add(Str[i]);
    end;
  finally
    Str.Free;
  end;
end;

function TBisFtpClientMainForm.CheckExtension(FileName: String): Boolean;
var
  Ext: String;
begin
  Ext:=ExtractFileExt(FileName);
  Result:=FExtensions.IndexOf(Ext)<>-1;
  if not Result then
    Result:=FExtensions.Count=0;
end;

procedure TBisFtpClientMainForm.ActionAddFilesExecute(Sender: TObject);
begin
  AddFiles;
end;

procedure TBisFtpClientMainForm.ActionAddFilesUpdate(Sender: TObject);
begin
  ActionAddFiles.Enabled:=CanAddFiles;
end;

procedure TBisFtpClientMainForm.ActionStopExecute(Sender: TObject);
begin
  Stop;
end;

procedure TBisFtpClientMainForm.ActionStopUpdate(Sender: TObject);
begin
  ActionStop.Enabled:=CanStop;
end;

procedure TBisFtpClientMainForm.ActionClearFilesExecute(Sender: TObject);
begin
  ClearFiles;
end;

procedure TBisFtpClientMainForm.ActionClearFilesUpdate(Sender: TObject);
begin
  ActionClearFiles.Enabled:=CanClearFiles;
end;

procedure TBisFtpClientMainForm.ActionDelFilesExecute(Sender: TObject);
begin
  DelFiles;
end;

procedure TBisFtpClientMainForm.ActionDelFilesUpdate(Sender: TObject);
begin
  ActionDelFiles.Enabled:=CanDelFiles;
end;

procedure TBisFtpClientMainForm.ActionPauseExecute(Sender: TObject);
begin
  Pause;
end;

procedure TBisFtpClientMainForm.ActionPauseUpdate(Sender: TObject);
begin
  ActionPause.Enabled:=CanPause;
end;

procedure TBisFtpClientMainForm.ActionQueueExecute(Sender: TObject);
begin
  Queue;
end;

procedure TBisFtpClientMainForm.ActionQueueUpdate(Sender: TObject);
begin
  ActionQueue.Enabled:=CanQueue;
end;

procedure TBisFtpClientMainForm.ActionSendExecute(Sender: TObject);
begin
  Send;
end;

procedure TBisFtpClientMainForm.ActionSendUpdate(Sender: TObject);
begin
  ActionSend.Enabled:=CanSend;
end;

function TBisFtpClientMainForm.CanAddFiles: Boolean;
begin
  Result:=true;
end;

procedure TBisFtpClientMainForm.AddFilesFromList(Files: TStrings);

  function CheckExists(S: String; ASize: Int64): Boolean;
  var
    i: Integer;
    Item: TListITem;
    Size: Int64;
  begin
    Result:=false;
    for i:=0 to ListViewFiles.Items.Count-1 do begin
      Item:=ListViewFiles.Items[i];
      if AnsiSameText(Item.SubItems[0],S) then begin
        Size:=StrToIntDef(Item.SubItems[1],0);
        Result:=Size=ASize;
        if Result then
          break;
      end;
    end;
  end;
  
var
  i: Integer;
  S: String;
  Item: TListITem;
  ASize: Int64;
  Mes: String;
  Fails: TStringList;
begin
  if Assigned(Files) then begin
    Fails:=TStringList.Create;
    ListViewFiles.Items.BeginUpdate;
    try
      for i:=0 to Files.Count-1 do begin
        S:=Files[i];
        ASize:=GetFileSizeEx(S);
        if CheckExtension(S) then begin
          if not CheckExists(S,ASize) then begin
            Item:=ListViewFiles.Items.Add;
            Item.Caption:=ExtractFileName(S);
            Item.ImageIndex:=6;
            Item.SubItems.Add(S);
            Item.SubItems.Add(IntToStr(ASize));
            Item.SubItems.Add(FResultQueue);
          end;
        end else begin
          Fails.Add(ExtractFileName(S));
        end;
      end;

      if Fails.Count>0 then begin
        Mes:=FMessage;
        if Trim(FMessage)='' then begin
          FFilters.Delimiter:=',';
          Fails.Delimiter:=',';
          Mes:=FormatEx('������ �����(��) %s �� �������������.'+#13#10+
                        '�������������� ������ ��������� �������: %s',[Trim(Fails.DelimitedText),Trim(FFilters.DelimitedText)]);
        end;
        ShowWarning(Mes);
      end;
    finally
      ListViewFiles.Items.EndUpdate;
      Fails.Free;
    end;
  end;
end;

procedure TBisFtpClientMainForm.ApplicationEventsHint(Sender: TObject);
begin
  StatusBar.SimpleText:=Application.Hint;
end;

procedure TBisFtpClientMainForm.AddFiles;
begin
  if CanAddFiles then begin
    if OpenDialog.Execute then begin
      AddFilesFromList(OpenDialog.Files);
      ResizeListView;
    end;
  end;
end;

function TBisFtpClientMainForm.CanDelFiles: Boolean;
begin
  Result:=not FInProcess;
  if Result then
    Result:=ListViewFiles.SelCount>0;
end;

procedure TBisFtpClientMainForm.DelFiles;
var
  i: Integer;
  Item: TListItem;
begin
  if CanDelFiles then begin
    ListViewFiles.Items.BeginUpdate;
    try
      for i:=ListViewFiles.Items.Count-1 downto 0 do begin
        Item:=ListViewFiles.Items[i];
        if Item.Selected then
          Item.Delete;
      end;
    finally
      ListViewFiles.Items.EndUpdate;
    end;

    ResizeListView;
  end;
end;

function TBisFtpClientMainForm.CanClearFiles: Boolean;
begin
  Result:=not FInProcess;
  if Result then
    Result:=ListViewFiles.Items.Count>0;
end;

procedure TBisFtpClientMainForm.ClearFiles;
begin
  if CanClearFiles then begin
    ListViewFiles.Clear;
    ResizeListView;
  end;
end;

function TBisFtpClientMainForm.QueueExists(Files: TStrings=nil): Boolean;
var
  i: Integer;
  Item: TListItem;
begin
  ListViewFiles.Items.BeginUpdate;
  try
    Result:=false;
    for i:=0 to ListViewFiles.Items.Count-1 do begin
      Item:=ListViewFiles.Items[i];
      if (Item.SubItems[2]=FResultQueue) then begin
        Result:=true;
        if Assigned(Files) then
          Files.Add(Item.SubItems[0]);
      end;
    end;
  finally
    ListViewFiles.Items.EndUpdate;
  end;
end;

function TBisFtpClientMainForm.CanSend: Boolean;
var
  i: Integer;
  Item: TListItem;
begin
  Result:=not FInProcess and not Assigned(FThread);
  if Result then begin
    Result:=ListViewFiles.Items.Count>0;
    if Result then
      Result:=false;
    for i:=0 to ListViewFiles.Items.Count-1 do begin
      Item:=ListViewFiles.Items[i];
      if (AnsiSameText(Item.SubItems[2],FResultQueue)) then begin
        Result:=true;
        break;
      end;
    end;
  end else
    Result:=Assigned(FThread) and FThread.Suspended;
end;

procedure TBisFtpClientMainForm.Send;
begin
  if CanSend then begin
    if not Assigned(FThread) then begin
      FThreadBreaked:=false;
      FThread:=TBisFtpClientThread.Create;
      FThread.Parent:=Self;
      FThread.OnTerminate:=ThreadTerminate;
      FThread.FreeOnTerminate:=true;
      NewProgress(0,0,0);
      UpdateCounters(0,0,0,0,0.0);
      EnableCounters(true);
      FThread.Resume;
    end else begin
      if FThread.Suspended then
        FThread.Resume;
    end;
  end;
end;

procedure TBisFtpClientMainForm.ThreadTerminate(Sender: TObject);
begin
  FThread:=nil;
  FInProcess:=false;
  EnableCounters(false);
end;

function TBisFtpClientMainForm.CanPause: Boolean;
begin
  Result:=FInProcess and Assigned(FThread) and not FThread.Suspended;
end;

procedure TBisFtpClientMainForm.Pause;
begin
  if CanPause then begin
    if Assigned(FThread) then
      FThread.Suspend;
  end;
end;

procedure TBisFtpClientMainForm.NewProgress(Min, Max, Position: Integer);
begin
  ProgressBar.Min:=Min;
  ProgressBar.Max:=Max;
  ProgressBar.Position:=Position;
  ProgressBar.Update;
end;

function TBisFtpClientMainForm.CanStop: Boolean;
begin
  Result:=FInProcess and Assigned(FThread);
end;

procedure TBisFtpClientMainForm.Stop;
var
  FileName: String;
begin
  if CanStop then begin
    if Assigned(FThread) then begin
      FileName:=FThread.FFileName;
      FreeAndNilEx(FThread);
      FInProcess:=false;
      ChangeStatus(FileName,ssFail);
      NewProgress(0,0,0);
      UpdateCounters(0,0,0,0,0.0);
      EnableCounters(false);
    end;
  end;
end;

procedure TBisFtpClientMainForm.ChangeStatus(FileName: String; SendStatus: TBisFtpClientSendStatus);
var
  i: Integer;
  Item: TListItem;
begin
  ListViewFiles.Items.BeginUpdate;
  try
    for i:=0 to ListViewFiles.Items.Count-1 do begin
      Item:=ListViewFiles.Items[i];
      if AnsiSameText(Item.SubItems[0],FileName) then begin
        case SendStatus of
          ssActive: begin
            Item.ImageIndex:=7;
            Item.SubItems[2]:=FResultActive;
          end;
          ssSuccess: begin
            Item.ImageIndex:=8;
            Item.SubItems[2]:=FResultSuccess;
          end;
          ssFail: begin
            Item.ImageIndex:=9;
            Item.SubItems[2]:=FResultFail;
          end;
        end;
        Item.Selected:=true;
        Item.MakeVisible(true);
      end;
    end;
  finally
    ListViewFiles.Items.EndUpdate;
  end;
end;

function TBisFtpClientMainForm.CanQueue: Boolean;
var
  i: Integer;
  Item: TListItem;
begin
  Result:=not FInProcess;
  if Result then begin
    Result:=ListViewFiles.SelCount>0;
    for i:=0 to ListViewFiles.Items.Count-1 do begin
      Item:=ListViewFiles.Items[i];
      if Item.Selected then begin
        Result:=Result and (AnsiSameText(Item.SubItems[2],FResultFail) or AnsiSameText(Item.SubItems[2],FResultActive));
      end;
    end;
  end;
end;

procedure TBisFtpClientMainForm.Queue;
var
  i: Integer;
  Item: TListItem;
begin
  if CanQueue then begin
    for i:=0 to ListViewFiles.Items.Count-1 do begin
      Item:=ListViewFiles.Items[i];
      if Item.Selected and (AnsiSameText(Item.SubItems[2],FResultFail) or AnsiSameText(Item.SubItems[2],FResultActive)) then begin
        Item.ImageIndex:=6;
        Item.SubItems[2]:=FResultQueue;
      end;
    end;
  end;
end;

procedure TBisFtpClientMainForm.UpdateCounters(Current, AllCount: Integer; ASize, AllSize: Int64; ATime: TTime);
var
  NewSize: Extended;
  NewAllSize: Extended;
  NewSpeed: Extended;
  NewTime: Extended;
  Hour,Min,Sec,MSec: Word;
  SecFull: Integer;
begin
  LabelFile.Caption:=FormatEx('������: %d / %d',[Current,AllCount]);
  LabelFile.Update;

  NewSize:=0.0;
  if ASize<>0 then begin
    NewSize:=ASize/(1024*1024);
  end;
  NewAllSize:=0.0;
  if AllSize<>0 then begin
    NewAllSize:=AllSize/(1024*1024);
  end;
  LabelSize.Caption:=FormatEx('������: %s / %s Mb',[FormatFloat('#0.00',NewSize),FormatFloat('#0.00',NewAllSize)]);
  LabelSize.Update;

  NewTime:=0.0;
  if ASize<>0 then
    NewTime:=(ATime*AllSize)/ASize;
  
  LabelTime.Caption:=FormatEx('�����: %s / %s',[FormatDateTime('h:nn:ss',ATime),FormatDateTime('h:nn:ss',NewTime)]);
  LabelTime.Update;

  DecodeTime(ATime,Hour,Min,Sec,MSec);
  SecFull:=Hour*3600+Min*60+Sec;
  if SecFull<=0 then SecFull:=1;
    
  NewSpeed:=0.0;
  if SecFull<>0 then
    NewSpeed:=NewSize/SecFull;
  
  LabelSpeed.Caption:=FormatEx('��������: %s Mb/s',[FormatFloat('#0.00',NewSpeed)]);
  LabelSpeed.Update;
  
end;

procedure TBisFtpClientMainForm.ResizeListView;
begin
  ListViewFiles.Width:=ListViewFiles.Width+1;
//  ListView_SetColumnWidth(ListViewFiles.Handle,1,LVSCW_AUTOSIZE_USEHEADER);
end;

procedure TBisFtpClientMainForm.WMDropFiles(var Msg: TMessage);
var
  i, amount, size: integer;
  Filename: PChar;
  Files: TStringList;
begin
  inherited;
  Files:=TStringList.Create;
  try
    Filename:=nil;
    Amount := DragQueryFile(Msg.WParam, $FFFFFFFF, Filename, 255);
    for i := 0 to (Amount - 1) do
    begin
      size := DragQueryFile(Msg.WParam, i, nil, 0) + 1;
      Filename := StrAlloc(size);
      DragQueryFile(Msg.WParam, i, Filename, size);
      Files.Add(FileName);
      StrDispose(Filename);
    end;
    DragFinish(Msg.WParam);
    AddFilesFromList(Files);
  finally
    Files.Free;
  end;
end;

procedure TBisFtpClientMainForm.LoadList;
var
  Files: TStringList;
begin
  if FileExists(FListFileName) then begin
    Files:=TStringList.Create;
    try
      try
        Files.LoadFromFile(FListFileName);
        AddFilesFromList(Files);
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      Files.Free;
    end;
  end;
end;

procedure TBisFtpClientMainForm.SaveList;
var
  Files: TStringList;
  i: Integer;
  Item: TListItem;
begin
  Files:=TStringList.Create;
  try
    for i:=0 to ListViewFiles.Items.Count-1 do begin
      Item:=ListViewFiles.Items[i];
      if (AnsiSameText(Item.SubItems[2],FResultQueue)) or
         (AnsiSameText(Item.SubItems[2],FResultActive)) or
         (AnsiSameText(Item.SubItems[2],FResultQueue)) or
         (AnsiSameText(Item.SubItems[2],FResultFail)) then begin
        Files.Add(Item.SubItems[0]);
      end;
    end;
    try
      if Trim(FListFileName)<>'' then
        Files.SaveToFile(FListFileName);
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  finally
    Files.Free;
  end;
end;


end.
