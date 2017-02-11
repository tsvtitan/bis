unit BisUpdateMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ExtCtrls,

  BisSizeGrip, BisUpdateConfig, BisUpdateConnection, BisUpdateMapFile;

type
  TBisUpdateMainForm=class;

  TBisUpdateThread=class(TThread)
  private
    FParent: TBisUpdateMainForm;
    FPosition: Integer;
    FMax: Integer;
    FStatus: String;
    FSuccess: Boolean;
    FError: Boolean;
    procedure UpdateStatus;
    procedure UpdateProgress;
    procedure ConnectionProgress(Sender: TObject; Min,Max,Position: Integer; var Breaked: Boolean);
  public
    procedure Execute; override;

    property Parent: TBisUpdateMainForm read FParent;

    property Success: Boolean read FSuccess;
  end;

  TBisUpdateMainForm = class(TForm)
    LabelStatus: TLabel;
    ButtonBreak: TButton;
    ImageList: TImageList;
    ButtonAdvance: TButton;
    Panel: TPanel;
    ListView: TListView;
    ProgressBar: TProgressBar;
    LabelPercent: TLabel;
    procedure ButtonBreakClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonAdvanceClick(Sender: TObject);
  private
    FSizeGrip: TBisSizeGrip;
    FThread: TBisUpdateThread;
    FSClose: String;
    FSmallView: Boolean;
    FAutoExit: Boolean;
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure ThreadTerminate(Sender: TObject);
    procedure ResizeListView;
    procedure SmallView(AVisible: Boolean);
    procedure ButtonCloseClick(Sender: TObject);
    function PrepareStatus(Status: String): String;
//    procedure ChangeImageIndex(ImageIndex: Integer);
    procedure UpdateStatus(Status: String; Error: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  BisUpdateMainForm: TBisUpdateMainForm;

var
  FConfig: TBisUpdateConfig;
  FMutexHandle: THandle;
  FMapFile: TBisUpdateMapFile;

function Exists: Boolean;
procedure Init;
procedure Done;

implementation

uses StrUtils, ZLib,
     IdAssignedNumbers,
     BisCrypter, BisUpdateConsts, BisUpdateTypes, BisModuleInfo, BisFileDirs;

{$R *.dfm}

var
  ConfigFile: String;

function ExpandFileNameEx(FileName: String): String;
var
  Dir: String;
  ModuleName: String;
begin
  Result:=ExpandFileName(FileName);
  ModuleName:=GetModuleName(HInstance);
  Dir:=ExtractFileDir(ModuleName);
  if SetCurrentDir(Dir) then begin
    Result:=ExpandFileName(FileName);
    if Trim(Result)='' then
      Result:=Dir;
  end;
end;

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

function Exists: Boolean;
var
  Ret: DWord;
  S: String;
  Crypter: TBisCrypter;
begin
  Result:=true;
  if not FConfig.Empty then begin
    Crypter:=TBisCrypter.Create;
    try
      S:=Crypter.HashString(FConfig.FileName,haMD5,hfHEX);
      FMutexHandle:=CreateMutex(nil,false,PChar(S));
      Ret:=GetLastError;
      Result:=Ret=ERROR_ALREADY_EXISTS;
    finally
      Crypter.Free;
    end;
  end;
end;

procedure Init;
begin
  ConfigFile:=ChangeFileExt(Application.ExeName,'.ini');

  FConfig:=TBisUpdateConfig.Create(nil);
  FConfig.LoadFromFile(ConfigFile);

//  Sleep(20000);

  FMapFile:=TBisUpdateMapFile.Create(nil);
  FMapFile.OpenMapFile(ParamStr(1));
end;

procedure Done;
begin
  FMapFile.Free;
  FConfig.Free;
  if FMutexHandle<>0 then
    CloseHandle(FMutexHandle);
end;

{ TBisUpdateThread }

procedure TBisUpdateThread.UpdateProgress;
var
  Percent: Extended;
begin
  if Assigned(FParent) then begin
    FParent.ProgressBar.Position:=FPosition;
    FParent.ProgressBar.Max:=FMax;
    FParent.ProgressBar.Update;
    if FMax>FPosition then begin
      Percent:=0.0;
      if FMax>0 then
        Percent:=(FPosition/FMax)*100;
      Percent:=Abs(Percent);
      FParent.LabelPercent.Visible:=true;
      FParent.LabelPercent.Caption:=IntToStr(Round(Percent))+' %';
      FParent.LabelPercent.Update;
    end else
      FParent.LabelPercent.Visible:=false;
  end;
end;

procedure TBisUpdateThread.UpdateStatus;
begin
  if Assigned(FParent) then
    FParent.UpdateStatus(FStatus,FError);
end;

procedure TBisUpdateThread.ConnectionProgress(Sender: TObject; Min,Max,Position: Integer; var Breaked: Boolean);
begin
  FMax:=Max;
  FPosition:=Position;
  Breaked:=Terminated;
  Synchronize(UpdateProgress);
end;

procedure TBisUpdateThread.Execute;
var
  Connection: TBisUpdateConnection;
  List: TBisUpdateList;
  UpdateDir: String;
  BackupDir: String;
  BackupEnabled: Boolean;
  SServerConnect: String;
  SGetList: String;
  SCheckList: String;
  SServerDisconnect: String;
  SCreateBackup: String;
  SGetFiles: String;
  SSaveFiles: String;
  SRestart: String;
  SBeginUpdate: String;
  SUpdateSuccess: String;
  SUpdateFail: String;
  Exceptions: TStringList;

  procedure DoProgress(Position,Max: Integer);
  begin
    FPosition:=Position;
    FMax:=Max;
    Synchronize(UpdateProgress);
  end;

  procedure DoStatus(Status: String; Error: Boolean=false);
  begin
    FStatus:=Status;
    FError:=Error;
    Synchronize(UpdateStatus);
  end;

  procedure ReadParams;
  var
    UseProxy: Boolean;
  begin
    UpdateDir:=FConfig.Read(SSectionMain,SParamUpdateDir,'');
    UpdateDir:=ExpandFileNameEx(UpdateDir);
    BackupDir:=FConfig.Read(SSectionMain,SParamBackupDir,'');
    BackupDir:=ExpandFileNameEx(BackupDir);
    BackupEnabled:=FConfig.Read(SSectionMain,SParamBackupEnabled,false);

    SServerConnect:=FConfig.Read(SSectionConnection,SParamSServerConnect,'���������� � ��������...');
    SGetList:=FConfig.Read(SSectionConnection,SParamSGetList,'��������� ������...');
    SCheckList:=FConfig.Read(SSectionConnection,SParamSCheckList,'�������� ������...');
    SServerDisconnect:=FConfig.Read(SSectionConnection,SParamSServerDisconnect,'���������� �� �������...');
    SCreateBackup:=FConfig.Read(SSectionConnection,SParamSCreateBackup,'�������� ������...');
    SGetFiles:=FConfig.Read(SSectionConnection,SParamSGetFiles,'��������� ������...');
    SSaveFiles:=FConfig.Read(SSectionConnection,SParamSSaveFiles,'���������� ������...');
    SRestart:=FConfig.Read(SSectionConnection,SParamSRestart,'����������...');
    SBeginUpdate:=FConfig.Read(SSectionConnection,SParamSBeginUpdate,'������ ����������...');
    SUpdateSuccess:=FConfig.Read(SSectionConnection,SParamSUpdateSuccess,'���������� ������ �������.');
    SUpdateFail:=FConfig.Read(SSectionConnection,SParamSUpdateFail,'���������� ������ � �������.');

    with Connection do begin
      Host:=FConfig.Read(SSectionConnection,SParamHost,'');
      Port:=FConfig.Read(SSectionConnection,SParamPort,IdPORT_HTTP);
      Path:=FConfig.Read(SSectionConnection,SParamPath,'');
      Protocol:=FConfig.Read(SSectionConnection,SParamProtocol,'');
      ConnectionType:=FConfig.Read(SSectionConnection,SParamType,htDirect);
      UseProxy:=FConfig.Read(SSectionConnection,SParamUseProxy,false);
      if UseProxy then begin
        ProxyParams.ProxyServer:=FConfig.Read(SSectionConnection,SParamProxyHost,'');
        ProxyParams.ProxyPort:=FConfig.Read(SSectionConnection,SParamProxyPort,0);
        ProxyParams.ProxyUsername:=FConfig.Read(SSectionConnection,SParamProxyUser,'');
        ProxyParams.ProxyPassword:=FConfig.Read(SSectionConnection,SParamProxyPassword,'');
      end;
      RemoteAuto:=FConfig.Read(SSectionConnection,SParamRemoteAuto,false);
      RemoteName:=FConfig.Read(SSectionConnection,SParamRemoteName,'');
      Dialer.UserName:=FConfig.Read(SSectionConnection,SParamModemUser,'');
      Dialer.Password:=FConfig.Read(SSectionConnection,SParamModemPassword,'');
      Dialer.Domain:=FConfig.Read(SSectionConnection,SParamModemDomain,'');
      Dialer.PhoneNumber:=FConfig.Read(SSectionConnection,SParamModemPhone,'');
      UseCrypter:=FConfig.Read(SSectionConnection,SParamUseCrypter,false);
      CrypterAlgorithm:=FConfig.Read(SSectionConnection,SParamCrypterAlgorithm,caRC5);
      CrypterMode:=FConfig.Read(SSectionConnection,SParamCrypterMode,cmCTS);
      CrypterKey:=Trim(FConfig.Read(SSectionConnection,SParamCrypterKey,''));
      UseCompressor:=FConfig.Read(SSectionConnection,SParamUseCompressor,false);
      CompressorLevel:=FConfig.Read(SSectionConnection,SParamCompressorLevel,clFastest);
      StreamFormat:=FConfig.Read(SSectionConnection,SParamStreamFormat,sfRaw);
      Request.UserAgent:=FConfig.Read(SSectionConnection,SParamUserAgent,'');
      AuthUserName:=FConfig.Read(SSectionConnection,SParamAuthUserName,'');
      AuthPassword:=FConfig.Read(SSectionConnection,SParamAuthPassword,'');
      ConnectionTimeout:=FConfig.Read(SSectionConnection,SParamConnectionTimeout,ConnectionTimeout);
    end;

    FConfig.ReadSectionValues(SSectionExceptions,Exceptions);
  end;

  procedure GetVersion(Version: String; var N1,N2,N3,N4: Integer);
  var
    Str: TStringList;
  begin
    N1:=0;
    N2:=0;
    N3:=0;
    N4:=0;
    Version:=Trim(Version);
    if Version<>'' then begin
      Str:=TStringList.Create;
      try
        GetStringsByString(Version,'.',Str);
        if Str.Count<>4 then begin
          Str.Clear;
          GetStringsByString(Version,',',Str);
        end;
        if Str.Count=4 then begin
          N1:=StrToIntDef(Trim(Str.Strings[0]),0);
          N2:=StrToIntDef(Trim(Str.Strings[1]),0);
          N3:=StrToIntDef(Trim(Str.Strings[2]),0);
          N4:=StrToIntDef(Trim(Str.Strings[3]),0);
        end;
      finally
        Str.Free;
      end;
    end;
  end;

  function CheckVersion(Version1, Version2: String): Boolean;
  var
    F1,F2,F3,F4: Integer;
    N1,N2,N3,N4: Integer;
  begin
    Result:=AnsiSameText(Version1,Version2);
    if not Result then begin
      GetVersion(Version1,F1,F2,F3,F4);
      GetVersion(Version2,N1,N2,N3,N4);
      Result:=(F1<=N1) and (F2<=N2) and (F3<=N3) and (F4<=N4);
    end;
  end;

  procedure CheckList;
  var
    I: Integer;
    Item: TBisUpdateItem;
    AName: String;
    MI: TBisModuleInfo;
    Version: String;
    Hash: String;
  begin
    if Assigned(List) then begin
      if List.Count>0 then
        DoStatus(SCheckList);
      for i:=0 to List.Count-1 do begin
        if Terminated then exit;
        Item:=List.Items[i];
        AName:=UpdateDir+Item.Dir+PathDelim+Item.Name;
        if not FileExists(AName) then
          Item.Need:=true
        else begin
          MI:=TBisModuleInfo.Create(AName);
          try
            Version:=MI.FileVersion;
            Hash:=MI.FileHash;
            Item.Need:=true;
            if Trim(Version)<>'' then
              Item.Need:=not CheckVersion(Item.Version,Version)
            else begin
              Item.Need:=not AnsiSameText(Item.Hash,Hash);
            end;
          finally
            MI.Free;
          end;
        end;  
      end;
    end;
  end;

  function CreateDirEx(Dir: String): Boolean;

    procedure GetDirs(str: TStringList);
    var
      i: Integer;
      s,tmps: string;
    begin
      tmps:='';
      for i:=1 to Length(Dir) do begin
        if dir[i]=PathDelim then begin
          s:=tmps;
          str.Add(s);
        end;
        tmps:=tmps+Dir[i];
      end;
      str.Add(Dir);
    end;

  var
    str: TStringList;
    i: Integer;
    isCreate: Boolean;
  begin
    str:=TStringList.Create;
    try
      isCreate:=false;
      GetDirs(str);
      for i:=0 to str.Count-1 do begin
        isCreate:=CreateDir(str.Strings[i]);
      end;
      Result:=isCreate;
    finally
      str.Free;
    end;
  end;

  procedure CreateBackup;
  var
    i: Integer;
    FileDirs: TBisFileDirs;
    FileDir: TBisFileDir;
    AName: String;
    NewDir: String;
    S: String;
    ADir: String;
  begin
    if BackupEnabled then begin
      CreateDirEx(BackupDir);
      if DirectoryExists(BackupDir) then begin
        DoStatus(SCreateBackup);
        FileDirs:=TBisFileDirs.Create;
        try
          FileDirs.Refresh(UpdateDir,false);
          for i:=0 to FileDirs.Count-1 do begin
            if Terminated then exit;
            FileDir:=FileDirs.Items[i];
            AName:=FileDir.Name;
            S:=ExtractFileDir(FileDir.Name);
            S:=Copy(S,Length(UpdateDir)+1,Length(S));
            NewDir:=BackupDir+S;
            AName:=ChangeFilePath(AName,NewDir);
            if FileDir.IsDir then
              CreateDirEx(AName)
            else begin
              ADir:=ExtractFileDir(FileDir.Name);
              CreateDirEx(ADir);
              CopyFile(PChar(FileDir.Name),PChar(AName),true);
            end;
          end;
        finally
          FileDirs.Free;
        end;
      end;
    end;
  end;

  function CheckMapFile: Boolean;
  var
    Ret: DWord;
    MutexName: String;
    MutexHandle: THandle;
    Flag: Boolean;
    Cycle: Integer;
  const
    MaxCycle=100;
  begin
    Result:=not FMapFile.Exists;
    if not Result then begin
      FMapFile.WriteUpdateType(utSuccess);
      MutexName:=FMapFile.ReadMutexName;
      if Trim(MutexName)<>'' then begin
        Flag:=false;
        Cycle:=0;
        while not Flag do begin
          if Terminated then exit;
          Sleep(MaxCycle);
          Inc(Cycle);
          if Cycle>MaxCycle then
            break
          else begin
            MutexHandle:=CreateMutex(nil,false,PChar(MutexName));
            try
              Ret:=GetLastError;
              Flag:=not (Ret=ERROR_ALREADY_EXISTS);
              if Flag then begin
                Result:=true;
                exit;
              end;
            finally
              if MutexHandle<>0 then
                CloseHandle(MutexHandle);
            end;
          end;
        end;
      end;
    end;
  end;

  procedure SaveFiles;
  var
    I: Integer;
    Item: TBisUpdateItem;
    ADir: String;
    AName: String;
  begin
    if Assigned(List) then begin
      if List.Count>0 then
        DoStatus(SSaveFiles);
      for i:=0 to List.Count-1 do begin
        if Terminated then exit;
        Item:=List.Items[i];
        ADir:=UpdateDir+Item.Dir;
        CreateDirEx(ADir);
        AName:=ADir+PathDelim+Item.Name;
        Item.Stream.SaveToFile(AName);
      end;
    end;
  end;

  procedure DeleteFiles(AList: TBisUpdateList);

    function CheckFileForDelete(FileName: String): Boolean;
    var
      i: Integer;
      NewName: String;
    begin
      Result:=true;
      if AnsiSameText(FileName,Application.ExeName) or
         AnsiSameText(FileName,ConfigFile) then begin
        Result:=false;
      end else begin
        for i:=0 to Exceptions.Count-1 do begin
          NewName:=Exceptions[i];
          NewName:=UpdateDir+PathDelim+NewName;
          if AnsiSameText(FileName,NewName) then begin
            Result:=false;
            break;
          end;
        end;
      end;
    end;

 {   procedure DeleteEmptyDir(Dir: String);
    var
      FileDirs: TBisFileDirs;
    begin
      FileDirs:=TBisFileDirs.Create;
      try
        FileDirs.Refresh(Dir,true);
        if FileDirs.Count=0 then begin
          SetCurrentDir(UpdateDir);
          RemoveDir(Dir);
        end;
      finally
        FileDirs.Free;
      end;
    end; }

  var
    FileDirs: TBisFileDirs;
    FileDir: TBisFileDir;
    Item: TBisUpdateItem;
    i: Integer;
    AName, ADir: String;
    Dirs: TStringList;
  begin
    FileDirs:=TBisFileDirs.Create;
    Dirs:=TStringList.Create;
    try
      FileDirs.Refresh(UpdateDir,false);
      for i:=0 to FileDirs.Count-1 do begin
        FileDir:=FileDirs.Items[i];
        if not FileDir.IsDir then begin
          AName:=ExtractFileName(FileDir.Name);
          ADir:=ExtractFileDir(FileDir.Name);
          ADir:=Copy(ADir,Length(UpdateDir)+1,Length(ADir));
          Item:=AList.FindItem(AName,ADir);
          if not Assigned(Item) then begin
            if CheckFileForDelete(FileDir.Name) then
              DeleteFile(FileDir.Name);
          end;
        end else
          Dirs.Add(FileDir.Name);
      end;

  {    for i:=Dirs.Count-1 downto 0 do
        DeleteEmptyDir(Dirs[i]);}

    finally
      Dirs.Free;
      FileDirs.Free;
    end;
  end;

  procedure Restart;
  var
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
    FileName: String;
    S: String;
  begin
    if FMapFile.Exists then begin
      DoStatus(SRestart);
      FillChar(StartupInfo,SizeOf(TStartupInfo),0);
      with StartupInfo do begin
        cb:=SizeOf(TStartupInfo);
        wShowWindow:=SW_SHOWDEFAULT;
      end;
      FileName:=FMapFile.ReadCommandLine;
      S:=Format('%s /noupdate',[FileName]);
      CreateProcess(nil,PChar(S),nil,nil,False,
                    NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo,ProcessInfo);
    end;
  end;

var
  OldList: TBisUpdateList;
begin
  if Assigned(FParent) and Assigned(FConfig) and Assigned(FMapFile) then begin
    FMapFile.WriteUpdateType(utUnknown);
    DoProgress(0,0);
    FSuccess:=false;
    Connection:=TBisUpdateConnection.Create(nil);
    Exceptions:=TStringList.Create;
    List:=TBisUpdateList.Create;
    OldList:=TBisUpdateList.Create;
    try
      try
        Connection.OnProgress:=ConnectionProgress;
        ReadParams;
        DoStatus(SBeginUpdate);
        if DirectoryExists(UpdateDir) then begin
          DoStatus(SServerConnect);
          Connection.Connect;
          if Terminated then exit;
          try
            DoStatus(SGetList);
            if Connection.GetList(List) then begin
              OldList.CopyFrom(List);
              CheckList;
              if Terminated then exit;
              DoStatus(SGetFiles);
              if Connection.GetFiles(List) then begin
                if CheckMapFile then begin
                  CreateBackup;
                  SaveFiles;
                  DeleteFiles(OldList);
                  Restart;
                  FSuccess:=True;
                end;
              end;
            end;
          finally
            DoStatus(SServerDisconnect);
            Connection.Disconnect;
          end;
        end;
      except
        on E: Exception do
          DoStatus(E.Message,True);
      end;
    finally
      OldList.Free;
      List.Free;
      Exceptions.Free;
      Connection.Free;
      DoProgress(0,0);
      if not FSuccess then begin
        FMapFile.WriteUpdateType(utError);
        DoStatus(SUpdateFail,true);
      end else begin
        DoStatus(SUpdateSuccess);
      end;
    end;
  end;
end;

{ TBisUpdateMainForm }

constructor TBisUpdateMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSizeGrip:=TBisSizeGrip.Create(Self);
  FSizeGrip.Parent:=Self;
  
  FThread:=TBisUpdateThread.Create(true);
  FThread.FParent:=Self;
  FThread.OnTerminate:=ThreadTerminate;

  Caption:=FConfig.Read(SSectionMain,SParamSCaption,Caption);
  LabelStatus.Caption:=FConfig.Read(SSectionMain,SParamSStatus,LabelStatus.Caption);
  ListView.Columns.Items[0].Caption:=FConfig.Read(SSectionMain,SParamSTime,ListView.Columns.Items[0].Caption);
  ListView.Columns.Items[1].Caption:=FConfig.Read(SSectionMain,SParamSDescription,ListView.Columns.Items[1].Caption);
  ButtonBreak.Caption:=FConfig.Read(SSectionMain,SParamSBreak,ButtonBreak.Caption);
  FSClose:=FConfig.Read(SSectionMain,SParamSClose,'�������');
  FSmallView:=FConfig.Read(SSectionMain,SParamSmallView,true);
  FAutoExit:=FConfig.Read(SSectionMain,SParamAutoExit,true);
  FAutoExit:=FAutoExit;
end;

destructor TBisUpdateMainForm.Destroy;
begin
  FThread.Free;
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisUpdateMainForm.SmallView(AVisible: Boolean);
var
  H,W: Integer;
begin
  FSmallView:=AVisible;
  if FSmallView then begin
    ButtonAdvance.Caption:='>>';
    Panel.Visible:=false;
    H:=105;
    W:=300;
    Constraints.MinHeight:=H;
    Constraints.MaxHeight:=H;
    Constraints.MinWidth:=W;
    Height:=H;
    Width:=W;
  end else begin
    ButtonAdvance.Caption:='<<';
    Panel.Visible:=true;
    H:=300;
    W:=400;
    Constraints.MinHeight:=H;
    Constraints.MaxHeight:=0;
    Constraints.MinWidth:=400;
    Height:=H;
    Width:=W;
    ResizeListView;
  end;
end;

procedure TBisUpdateMainForm.FormShow(Sender: TObject);
begin
  SmallView(FSmallView);
  FThread.Resume;
end;

procedure TBisUpdateMainForm.ResizeListView;
begin
  ListView.Width:=ListView.Width+1;
  ListView.Width:=ListView.Width-1;
end;

procedure TBisUpdateMainForm.ThreadTerminate(Sender: TObject);
begin
  if FAutoExit then begin
    Close;
  end else begin
    if FAutoExit and FThread.Success then
      Close
    else begin
      ButtonBreak.Caption:=FSClose;
      ButtonBreak.OnClick:=ButtonCloseClick;
    end;
  end;
end;

procedure TBisUpdateMainForm.ButtonAdvanceClick(Sender: TObject);
begin
  SmallView(not FSmallView);
end;

procedure TBisUpdateMainForm.ButtonBreakClick(Sender: TObject);
begin
  if not FThread.Suspended then
    FThread.Terminate;
  Close;
end;

procedure TBisUpdateMainForm.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

function TBisUpdateMainForm.PrepareStatus(Status: String): String;
begin
  Result:=ReplaceText(Status,#13#10,' ');
  Result:=ReplaceText(Result,#13,' ');
  Result:=ReplaceText(Result,#10,' ');
end;

procedure TBisUpdateMainForm.UpdateStatus(Status: String; Error: Boolean);
var
  ListItem: TListItem;
begin
  Status:=PrepareStatus(Status);

  ListItem:=ListView.Items.Add;
  ListItem.Caption:=TimeToStr(Now);
  ListItem.SubItems.Add(Status);
  ListItem.ImageIndex:=Integer(Error);
  ListItem.Selected:=true;
  ListItem.MakeVisible(true);

  ResizeListView;

  ListItem.MakeVisible(true);

  LabelStatus.Caption:=Status;
  LabelStatus.Update;
end;

procedure TBisUpdateMainForm.WMSizing(var Message: TMessage);
var
  NewHeight, NewWidth: Integer;
  R: PRect;
begin
  R := PRect(Message.LParam);
  NewHeight:=R.Bottom-R.Top;
  NewWidth:=R.Right-R.Left;

  if Constraints.MinHeight>0 then
   if NewHeight<=Constraints.MinHeight then
      NewHeight:=Constraints.MinHeight;

  if Constraints.MinWidth>0 then
   if NewWidth<=Constraints.MinWidth then
      NewWidth:=Constraints.MinWidth;

  if Constraints.MaxHeight>0 then
    if NewHeight>=Constraints.MaxHeight then
      NewHeight:=Constraints.MaxHeight;

  if Constraints.MaxWidth>0 then
    if NewWidth>=Constraints.MaxWidth then
      NewWidth:=Constraints.MaxWidth;

  if Message.WParam in [WMSZ_BOTTOM,WMSZ_BOTTOMRIGHT,WMSZ_BOTTOMLEFT] then begin
    R.Bottom := R.Top + NewHeight;
  end else begin
    R.Top := R.Bottom - NewHeight;
  end;

  if Message.WParam in [WMSZ_RIGHT,WMSZ_TOPRIGHT,WMSZ_BOTTOMRIGHT] then begin
    R.Right := R.Left + NewWidth;
  end else begin
    R.Left := R.Right - NewWidth;
  end;

end;

end.
