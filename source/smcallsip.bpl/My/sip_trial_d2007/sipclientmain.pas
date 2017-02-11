unit sipclientmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ToolWin, sipints, ExtCtrls, Menus, ImgList, Buttons,
  mmSystem, sipclient, IniFiles, acm, WavFiles, ActnList, mainframe, accountsframe,
  audioframe, ShellApi, jpeg, regform, ringtone;

type
  TMainForm = class(TForm)
    StatusBar1: TStatusBar;
    StatusPopupMenu: TPopupMenu;
    OnlineMenu: TMenuItem;
    OfflineMenu: TMenuItem;
    StatusImages: TImageList;
    SipClient: TSipClient;
    ImageList1: TImageList;
    ActionList1: TActionList;
    CallAction: TAction;
    HangUpAction: TAction;
    HoldAction: TAction;
    TransferAction: TAction;
    RegisterAction: TAction;
    RemoveAction: TAction;
    EditAction: TAction;
    AddAction: TAction;
    Timer1: TTimer;
    ConferenceAction: TAction;
    Panel2: TPanel;
    Panel3: TPanel;
    TAudioFrm1: TAudioFrm;
    TAccountsFrm1: TAccountsFrm;
    TDialFrm1: TDialFrm;
    ActivateDialpadFrameBtn: TSpeedButton;
    ActivateAccountsFrameBtn: TSpeedButton;
    ActivateAudioFrameBtn: TSpeedButton;
    AboutBtn: TSpeedButton;
    RecordAction: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure InfoBtnClick(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure FormCreate(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure OnlineMenuClick(Sender: TObject);
    procedure OfflineMenuClick(Sender: TObject);
    procedure SipClientRegistrationOk(Sender: TObject;
      const AAccount: ISipAccount);
    procedure SipClientRegistrationBye(Sender: TObject;
      const AAccount: ISipAccount);
    procedure HangUpActionExecute(Sender: TObject);
    procedure CallActionExecute(Sender: TObject);
    procedure CallActionUpdate(Sender: TObject);
    procedure HangUpActionUpdate(Sender: TObject);
    procedure SipClientBye(Sender: TObject; const ACall: ISipCall);
    procedure SipClientInvite(Sender: TObject; const ACall: ISipCall);
    procedure SipClientInviteOk(Sender: TObject; const Call: ISipCall);
    procedure HoldActionExecute(Sender: TObject);
    procedure HoldActionUpdate(Sender: TObject);
    procedure TransferActionUpdate(Sender: TObject);
    procedure TransferActionExecute(Sender: TObject);
    procedure RegisterActionExecute(Sender: TObject);
    procedure RegisterActionUpdate(Sender: TObject);
    procedure RemoveActionExecute(Sender: TObject);
    procedure RemoveActionUpdate(Sender: TObject);
    procedure AddActionExecute(Sender: TObject);
    procedure EditActionUpdate(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
    procedure SipClientDtmf(Sender: TObject; const ACall: ISipCall;
      const Dtmf: String);
    procedure SBtn1Click(Sender: TObject);
    procedure RefreshLines;
    procedure ShowMemo;
    procedure Timer1Timer(Sender: TObject);
    procedure ActivateDialpadFrameBtnClick(Sender: TObject);
    procedure ActivateAccountsFrameBtnClick(Sender: TObject);
    procedure ActivateAudioFrameBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure ConferenceActionUpdate(Sender: TObject);
    procedure ConferenceActionExecute(Sender: TObject);
    procedure RecordActionExecute(Sender: TObject);
    procedure RecordActionUpdate(Sender: TObject);
  protected
  private
    FConnected: Boolean;
    FRingThread: TRingThread;
    FLineIndex: Integer;
    FButtons: array[1..6] of TSpeedButton;
    FLines: array[1..6] of ISipCall;
    FDtmf: array[1..6] of String;
    FLineImages: array[1..6] of Boolean;
    FConference: ISipConference;
    FRecorder: ISipRecorder;
  public
    Account: ISipAccount;
    ServerEditText, UserEditText, PasswordEditText, STUNEditText, ProxyEditText: String;
    procedure SaveAccountInfo;
    procedure LoadAccountInfo;
  end;


var
  MainForm: TMainForm;

const
  IniFileName = 'sipphone.ini';

implementation

{$R *.dfm}

{ TMainForm }

procedure TMainForm.FormShow(Sender: TObject);
var
  DevOutCaps: TWaveOutCaps;
  DevInCaps: TWaveInCaps;
  n, i: Integer;
  s: String;
  Ini: TIniFile;
begin
  FLineIndex := 1;

  FButtons[1] := TDialFrm1.SBtn1;
  FButtons[2] := TDialFrm1.SBtn2;
  FButtons[3] := TDialFrm1.SBtn3;
  FButtons[4] := TDialFrm1.SBtn4;
  FButtons[5] := TDialFrm1.SBtn5;
  FButtons[6] := TDialFrm1.SBtn6;

  RefreshLines;

  FRingThread := nil;

  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
  try
    TDialFrm1.PhoneEdit.Text := Ini.ReadString('CALL', 'Phone', TDialFrm1.PhoneEdit.Text);
    SipClient.LocalPort := Ini.ReadInteger('SIP', 'LocalPort', SipClient.LocalPort);
  finally
    Ini.Free;
  end;

  TAudioFrm1.waveOutDevice.Items.Clear;
  TAudioFrm1.waveOutDevice.Items.AddObject('Default', TObject(WAVE_MAPPER));
  n := waveOutGetNumDevs;
  for i := 0 to n-1 do
  begin
    waveOutGetDevCaps(i, @DevOutCaps, SizeOf(DevOutCaps));
    s := PChar(@DevOutCaps.szPname);
    TAudioFrm1.waveOutDevice.Items.Add(s);
  end;
  TAudioFrm1.waveInDevice.Items.Clear;
  TAudioFrm1.waveInDevice.Items.AddObject('Default', TObject(WAVE_MAPPER));
  n := waveInGetNumDevs;
  for i := 0 to n-1 do
  begin
    waveInGetDevCaps(i, @DevInCaps, SizeOf(DevInCaps));
    s := PChar(@DevInCaps.szPname);
    TAudioFrm1.waveInDevice.Items.Add(s);
  end;
  TAudioFrm1.waveRingDevice.Items.Clear;
  TAudioFrm1.waveRingDevice.Items.AddObject('Default', TObject(WAVE_MAPPER));
  n := waveOutGetNumDevs;
  for i := 0 to n-1 do
  begin
    waveOutGetDevCaps(i, @DevOutCaps, SizeOf(DevOutCaps));
    s := PChar(@DevOutCaps.szPname);
    TAudioFrm1.waveRingDevice.Items.Add(s);
  end;

  TAudioFrm1.waveOutDevice.ItemIndex := 0;
  TAudioFrm1.waveInDevice.ItemIndex := 0;
  TAudioFrm1.waveRingDevice.ItemIndex := 0;

  LoadAccountInfo;

  SipClient.Active := True;
  if (ServerEditText <> '') and (UserEditText <> '') then
  begin
    OnlineMenuClick(Self);
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Ini: TIniFile;
begin
  FreeAndNil(FRingThread);
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
  try
    Ini.WriteString('CALL', 'Phone', TDialFrm1.PhoneEdit.Text);
  finally
    Ini.Free;
  end;
  SaveAccountInfo;  
end;

procedure TMainForm.InfoBtnClick(Sender: TObject);
begin
  if Assigned(FLines[FLineIndex]) and (FLines[FLineIndex].State = csActive) then
  begin
    case TSpeedButton(Sender).Tag of
     0: SipClient.SendDtmf(FLines[FLineIndex], '0');
     1: SipClient.SendDtmf(FLines[FLineIndex], '1');
     2: SipClient.SendDtmf(FLines[FLineIndex], '2');
     3: SipClient.SendDtmf(FLines[FLineIndex], '3');
     4: SipClient.SendDtmf(FLines[FLineIndex], '4');
     5: SipClient.SendDtmf(FLines[FLineIndex], '5');
     6: SipClient.SendDtmf(FLines[FLineIndex], '6');
     7: SipClient.SendDtmf(FLines[FLineIndex], '7');
     8: SipClient.SendDtmf(FLines[FLineIndex], '8');
     9: SipClient.SendDtmf(FLines[FLineIndex], '9');
    10: SipClient.SendDtmf(FLines[FLineIndex], '*');
    11: SipClient.SendDtmf(FLines[FLineIndex], '#');
    end;
  end
  else
    if TSpeedButton(Sender).Tag in [0,1,2,3,4,5,6,7,8,9] then
      TDialFrm1.PhoneEdit.Text := TDialFrm1.PhoneEdit.Text + IntToStr(TSpeedButton(Sender).Tag)
    else
    if TSpeedButton(Sender).Tag = 10 then
      TDialFrm1.PhoneEdit.Text := TDialFrm1.PhoneEdit.Text + '*'
    else
    if TSpeedButton(Sender).Tag = 11 then
      TDialFrm1.PhoneEdit.Text := TDialFrm1.PhoneEdit.Text + '#';
end;

procedure TMainForm.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  case Panel.Index of
  0:
  begin
    StatusImages.Draw(StatusBar1.Canvas,Rect.Left,Rect.Top, 0, FConnected);
    StatusBar1.Canvas.Font.Color := clBlack;
    StatusBar1.Canvas.Brush.Style := bsClear;
    if not FConnected then
      StatusBar1.Canvas.TextOut(20, 3, 'Offline')
    else
    if Assigned(Account) then
      StatusBar1.Canvas.TextOut(20, 3, 'sip:'+Account.User+'@' + Account.Server);
  end
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FConnected := False;
end;

procedure TMainForm.StatusBar1Click(Sender: TObject);
begin
  StatusPopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TMainForm.OnlineMenuClick(Sender: TObject);
begin
  if not SipClient.Active then
    SipClient.Active := True;
  Account := SipClient.AddAccount(ServerEditText, UserEditText, PasswordEditText, ProxyEditText, STUNEditText);
  Account.Expires := 3000;
  SipClient.RegisterAccount(Account);
end;

procedure TMainForm.OfflineMenuClick(Sender: TObject);
begin
  if SipClient.Active then
  begin
    if Assigned(Account) then
    begin
      SipClient.UnRegisterAccount(Account);
      StatusBar1.Repaint;
      OfflineMenu.Checked := True;
    end;
  end;
end;

procedure TMainForm.SipClientRegistrationOk(Sender: TObject;
  const AAccount: ISipAccount);
begin
  FConnected := True;
  StatusBar1.Repaint;
  OnlineMenu.Checked := True;
end;

procedure TMainForm.SipClientRegistrationBye(Sender: TObject;
  const AAccount: ISipAccount);
begin
  if Account = AAccount then
  begin
    Account := nil;
    FConnected := False;
  end;
  StatusBar1.Repaint;
  OfflineMenu.Checked := True;
end;

procedure TMainForm.SaveAccountInfo;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
  try
    Ini.WriteString('ACCOUNT', 'STUN', STUNEditText);
    Ini.WriteString('ACCOUNT', 'Server', ServerEditText);
    Ini.WriteString('ACCOUNT', 'Proxy', ProxyEditText);
    Ini.WriteString('ACCOUNT', 'User', UserEditText);
    Ini.WriteString('ACCOUNT', 'Password', PasswordEditText);
    Ini.WriteString('AUDIO', 'In', TAudioFrm1.waveInDevice.Text);
    Ini.WriteString('AUDIO', 'Out', TAudioFrm1.waveOutDevice.Text);
    Ini.WriteString('AUDIO', 'Ring', TAudioFrm1.waveRingDevice.Text);
  finally
    Ini.Free;
  end;
end;

procedure TMainForm.LoadAccountInfo;
var
  Ini: TIniFile;
  i, cnt: Integer;
  s, u: String;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
  try
    STUNEditText := Ini.ReadString('ACCOUNT', 'STUN','');
    ProxyEditText := Ini.ReadString('ACCOUNT', 'PROXY', '');
    ServerEditText := Ini.ReadString('ACCOUNT', 'Server','');
    UserEditText := Ini.ReadString('ACCOUNT', 'User','');
    PasswordEditText := Ini.ReadString('ACCOUNT', 'Password','');

    if Length(ServerEditText) > 0 then
    begin
      TAccountsFrm1.AccountList.Items.Add.Caption := ServerEditText;
      TAccountsFrm1.AccountList.Items[0].SubItems.Add(UserEditText);
    end;

    cnt := Ini.ReadInteger('ACCOUNT', 'Count',0);

    for i := 1 to cnt do
    begin
      s := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server','');
      u := Ini.ReadString('ACCOUNT'+IntToStr(i), 'User','');
      if (s <> ServerEditText) or (u <> UserEditText) then
      begin
        TAccountsFrm1.AccountList.Items.Add.Caption := s;
        TAccountsFrm1.AccountList.Items[TAccountsFrm1.AccountList.Items.Count-1].SubItems.Add(u);
      end;
    end;

    for i := 0 to TAudioFrm1.waveInDevice.Items.Count - 1 do
      if Trim(TAudioFrm1.waveInDevice.Items[i]) = Trim(Ini.ReadString('AUDIO', 'In','')) then
      begin
        TAudioFrm1.waveInDevice.ItemIndex := i;
        break;
      end;
    for i := 0 to TAudioFrm1.waveOutDevice.Items.Count - 1 do
      if Trim(TAudioFrm1.waveOutDevice.Items[i]) = Trim(Ini.ReadString('AUDIO', 'Out','')) then
      begin
        TAudioFrm1.waveOutDevice.ItemIndex := i;
        break;
      end;
    for i := 0 to TAudioFrm1.waveRingDevice.Items.Count - 1 do
      if Trim(TAudioFrm1.waveRingDevice.Items[i]) = Trim(Ini.ReadString('AUDIO', 'Ring','')) then
      begin
        TAudioFrm1.waveRingDevice.ItemIndex := i;
        break;
      end;
  finally
    Ini.Free;
  end;
end;

procedure TMainForm.HangUpActionExecute(Sender: TObject);
begin
  FreeAndNil(FRingThread);
  if Assigned(FLines[FLineIndex]) then
  begin
    if ((FLines[FLineIndex].State <> csRinging) or (FLines[FLineIndex].CallType = ctOutgoing)) then
    begin
      TDialFrm1.HangUpBtn.Enabled := False;
      SipClient.EndCall(FLines[FLineIndex]);
    end
    else
    if (FLines[FLineIndex].State = csRinging) and (FLines[FLineIndex].CallType = ctIncoming) then
    begin
      TDialFrm1.HangUpBtn.Enabled := False;
      SipClient.SendBusy(FLines[FLineIndex]);
    end;
  end;
end;

procedure TMainForm.CallActionExecute(Sender: TObject);
begin
  FreeAndNil(FRingThread);
  if Assigned(Account) then
  if not Assigned(FLines[FLineIndex]) then
  begin
    FLines[FLineIndex] := SipClient.AddCall(Account, TDialFrm1.PhoneEdit.Text,
      AudioInDeviceNameToDeviceID(TAudioFrm1.waveInDevice.Items[TAudioFrm1.waveInDevice.ItemIndex]),
      AudioOutDeviceNameToDeviceID(TAudioFrm1.waveOutDevice.Items[TAudioFrm1.waveOutDevice.ItemIndex]));
  end
  else
  if FLines[FLineIndex].State = csRinging then
  begin
    FLines[FLineIndex].AudioInDeviceID := AudioInDeviceNameToDeviceID(TAudioFrm1.waveInDevice.Items[TAudioFrm1.waveInDevice.ItemIndex]);
    FLines[FLineIndex].AudioOutDeviceID := AudioOutDeviceNameToDeviceID(TAudioFrm1.waveOutDevice.Items[TAudioFrm1.waveOutDevice.ItemIndex]);
    SipClient.AnswerCall(FLines[FLineIndex]);
  end;
end;

procedure TMainForm.CallActionUpdate(Sender: TObject);
begin
  CallAction.Enabled :=
    FConnected and (not Assigned(FLines[FLineIndex]) or (Assigned(FLines[FLineIndex])
    and (FLines[FLineIndex].State = csRinging) and (FLines[FLineIndex].CallType = ctIncoming)));
  TDialFrm1.CallBtn.Enabled := CallAction.Enabled;
end;

procedure TMainForm.HangUpActionUpdate(Sender: TObject);
begin
  HangUpAction.Enabled := Assigned(FLines[FLineIndex]) and
    (FLines[FLineIndex].State in [csActive, csRinging, csHold, csConnecting, csAutConnecting]);
  TDialFrm1.HangUpBtn.Enabled := HangUpAction.Enabled;
end;

procedure TMainForm.SipClientBye(Sender: TObject; const ACall: ISipCall);
var
  i: Integer;
begin
  FreeAndNil(FRingThread);
  for i := 1 to 6 do
  if FLines[i] = ACall then
  begin
    FLines[i] := nil;
    FDtmf[i] := '';
  end;
  RefreshLines;
end;

procedure TMainForm.SipClientInvite(Sender: TObject;
  const ACall: ISipCall);
var
  i, FreeLine: Integer;
begin
  FreeLine := 0;
  for i := 1 to 6 do
    if not Assigned(FLines[i]) then
    begin
      FreeLine := i;
      break;
    end;
  if FreeLine = 0 then
  begin
    SipClient.SendBusy(ACall);
  end
  else
  begin
    FLines[FreeLine] := ACall;
    FreeAndNil(FRingThread);
    FRingThread := TRingThread.Create(13);
  end;
end;

procedure TMainForm.SipClientInviteOk(Sender: TObject;
  const Call: ISipCall);
begin
  FreeAndNil(FRingThread);
end;

procedure TMainForm.HoldActionExecute(Sender: TObject);
begin
  if Assigned(FLines[FLineIndex]) then
  begin
    if FLines[FLineIndex].State = csActive then
      SipClient.HoldCall(FLines[FLineIndex])
    else if FLines[FLineIndex].State = csHold then
      SipClient.UnHoldCall(FLines[FLineIndex]);
  end;
end;

procedure TMainForm.HoldActionUpdate(Sender: TObject);
begin
  HoldAction.Enabled := Assigned(FLines[FLineIndex]) and (FLines[FLineIndex].State in [csActive, csHold]);
  if Assigned(FLines[FLineIndex]) then
  begin
    if FLines[FLineIndex].State = csActive then
      HoldAction.Caption := 'Hold'
    else
    if FLines[FLineIndex].State = csHold then
      HoldAction.Caption := 'Unhold';
  end;
end;

procedure TMainForm.TransferActionUpdate(Sender: TObject);
begin
  TransferAction.Enabled := Assigned(FLines[FLineIndex])
    and (FLines[FLineIndex].State in [csActive]);
end;

procedure TMainForm.TransferActionExecute(Sender: TObject);
begin
  if Assigned(FLines[FLineIndex]) then
  begin
    if TDialFrm1.TransferEdit.Text <> '' then
    begin
      if Assigned(FLines[FLineIndex]) and (FLines[FLineIndex].State = csActive) then
        SipClient.TransferCall(FLines[FLineIndex], TDialFrm1.TransferEdit.Text);
    end
    else
    begin
      MessageBox(Handle, 'Please enter the phone number you want to transfer the call to.', 'Call Transfer',MB_OK + MB_ICONSTOP);
      TDialFrm1.TransferEdit.SetFocus;
    end;
  end;
end;

procedure TMainForm.RegisterActionExecute(Sender: TObject);
var
  s, u: String;
  idx: Integer;
  Ini: TIniFile;
  cur: Boolean;
  cnt, i: Integer;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
  try
    s := TAccountsFrm1.AccountList.Selected.Caption;
    u := TAccountsFrm1.AccountList.Selected.SubItems[0];
    cur := (s = Ini.ReadString('ACCOUNT', 'Server','')) and
      (u = Ini.ReadString('ACCOUNT', 'User',''));

    cnt := Ini.ReadInteger('ACCOUNT', 'Count',0);
    idx := 0;

    if not cur then
    begin
      for i := 1 to cnt do
      begin
        if (s = Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server','')) and
        (u = Ini.ReadString('ACCOUNT'+IntToStr(i), 'User','')) then
        begin
          PasswordEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Password','');
          STUNEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'STUN','');
          ProxyEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Proxy','');
          idx := i;
          break;
        end;
      end;
    end;  

    if not cur then
    begin
      OfflineMenuClick(nil);
      ServerEditText := s;
      UserEditText := u;
      PasswordEditText := Ini.ReadString('ACCOUNT'+IntToStr(idx), 'Password','');
      STUNEditText := Ini.ReadString('ACCOUNT'+IntToStr(idx), 'STUN','');
      ProxyEditText := Ini.ReadString('ACCOUNT'+IntToStr(idx), 'Proxy','');
      Ini.WriteString('ACCOUNT', 'Server',ServerEditText);
      Ini.WriteString('ACCOUNT', 'User',UserEditText);
      Ini.WriteString('ACCOUNT', 'Password',PasswordEditText);
      Ini.WriteString('ACCOUNT', 'STUN',STUNEditText);
      Ini.WriteString('ACCOUNT', 'Proxy', ProxyEditText);
    end;
    
  finally
    Ini.Free;
  end;
  if Assigned(Account) then
  begin
    FConnected := False;
    SipClient.UnRegisterAccount(Account);
  end;
  OnlineMenuClick(Self);
end;

procedure TMainForm.RegisterActionUpdate(Sender: TObject);
begin
  RegisterAction.Enabled :=
    (TAccountsFrm1.AccountList.Selected <> nil)
    and ((Assigned(Account)
    and ((Account.Server <> TAccountsFrm1.AccountList.Selected.Caption) or (Account.User <> TAccountsFrm1.AccountList.Selected.SubItems[0]))) or
    (not Assigned(Account)));
end;

procedure TMainForm.RemoveActionExecute(Sender: TObject);
var
  cnt, i: Integer;
  s, u: String;
  sl, ul, pl, tl: TStringList;
  cur: Boolean;
  Ini: TIniFile;
begin
  if TAccountsFrm1.AccountList.Selected <> nil then
    if MessageBox(Handle, PChar(Format('Do you want to remove account %s@%s ?',
      [TAccountsFrm1.AccountList.Selected.SubItems[0], TAccountsFrm1.AccountList.Selected.Caption])), 'Confirm', MB_YESNO + MB_ICONWARNING) <> mrYes then
        Exit;
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
  try
    if TAccountsFrm1.AccountList.Selected <> nil then
    if TAccountsFrm1.AccountList.Items.Count > 0 then
    begin
      s := TAccountsFrm1.AccountList.Selected.Caption;
      u := TAccountsFrm1.AccountList.Selected.SubItems[0];
      cur := (ServerEditText = s) and (UserEditText = u);
      if cur then
      begin
        OfflineMenuClick(nil);
      end;

      cnt := Ini.ReadInteger('ACCOUNT', 'Count',0);
      if cnt > 0 then
      begin
        sl := TStringList.Create;
        ul := TStringList.Create;
        pl := TStringList.Create;
        tl := TStringList.Create;
        try
          for i := 1 to cnt do
          begin
            if (s <> Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server','')) or
            (u <> Ini.ReadString('ACCOUNT'+IntToStr(i), 'User','')) then
            begin
              sl.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server',''));
              ul.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'User',''));
              pl.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'Password',''));
              tl.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'STUN',''));
            end;
            Ini.EraseSection('ACCOUNT'+IntToStr(i));
          end;

          for i := 0 to sl.Count - 1 do
          begin
            Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'Server',sl[i]);
            Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'User',ul[i]);
            Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'Password',pl[i]);
            Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'STUN',tl[i]);
          end;
          Ini.WriteInteger('ACCOUNT', 'Count', sl.Count);
        finally
          sl.Free;
          ul.Free;
          pl.Free;
          tl.Free;
        end;
      end;
      TAccountsFrm1.AccountList.Items.Delete(TAccountsFrm1.AccountList.Selected.Index);
      if cur then
      begin
        ServerEditText := '';
        UserEditText := '';
        PasswordEditText := '';
        STUNEditText := '';
        ProxyEditText := '';
      end;
      if TAccountsFrm1.AccountList.Items.Count > 0 then
      begin
        TAccountsFrm1.AccountList.Items[0].Focused := True;
        TAccountsFrm1.AccountList.Items[0].Selected := True;
        s := TAccountsFrm1.AccountList.Selected.Caption;
        u := TAccountsFrm1.AccountList.Selected.SubItems[0];
        cnt := Ini.ReadInteger('ACCOUNT', 'Count',0);
        for i := 1 to cnt do
        if (s = Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server',''))
        and (u = Ini.ReadString('ACCOUNT'+IntToStr(i), 'User','')) then
        begin
          ServerEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server','');
          UserEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'User','');
          PasswordEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Password','');
          STUNEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'STUN','');
          ProxyEditText := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Proxy', '');
          break;
        end;
        Ini.WriteString('ACCOUNT', 'Server', ServerEditText);
        Ini.WriteString('ACCOUNT', 'User', UserEditText);
        Ini.ReadString('ACCOUNT', 'Password', PasswordEditText);
        Ini.WriteString('ACCOUNT', 'STUN', STUNEditText);
        Ini.WriteString('ACCOUNT', 'Proxy', ProxyEditText);
        if Length(ServerEditText) > 0 then
          OnlineMenuClick(Self);
      end;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TMainForm.RemoveActionUpdate(Sender: TObject);
begin
  RemoveAction.Enabled := (TAccountsFrm1.AccountList.Items.Count > 0) and (TAccountsFrm1.AccountList.Selected <> nil);
end;

procedure TMainForm.AddActionExecute(Sender: TObject);
var
  RF: TRegistrationForm;
  cnt, i: Integer;
  s, u: String;
  sl, ul, pl, tl, xl: TStringList;
  Ini: TIniFile;
  exists: Boolean;
begin
  RF := TRegistrationForm.Create(nil);
  try
    if RF.ShowModal = mrOk then
    begin
      s := RF.ServerEdit.Text;
      u := RF.UserEdit.Text;
      exists := False;
      for i := 0 to TAccountsFrm1.AccountList.Items.Count - 1 do
      if (TAccountsFrm1.AccountList.Items[i].Caption = s) and (TAccountsFrm1.AccountList.Items[i].SubItems[0] = u) then
      begin
        exists := True;
        break;
      end;
      if not exists then
      begin
        Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
        try
          cnt := Ini.ReadInteger('ACCOUNT', 'Count',0);
          sl := TStringList.Create;
          ul := TStringList.Create;
          pl := TStringList.Create;
          tl := TStringList.Create;
          xl := TStringList.Create;
          try
            for i := 1 to cnt do
            begin
              if (s <> Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server','')) or
              (u <> Ini.ReadString('ACCOUNT'+IntToStr(i), 'User','')) then
              begin
                sl.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server',''));
                ul.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'User',''));
                pl.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'Password',''));
                tl.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'STUN',''));
                xl.Add(Ini.ReadString('ACCOUNT'+IntToStr(i), 'Proxy', ''));
              end;
              Ini.EraseSection('ACCOUNT'+IntToStr(i));
            end;
            sl.Add(s);
            ul.Add(u);
            pl.Add(RF.PasswordEdit.Text);
            tl.Add(RF.STUNEdit.Text);
            xl.Add(RF.ProxyEdit.Text);
            for i := 0 to sl.Count - 1 do
            begin
              Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'Server',sl[i]);
              Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'User',ul[i]);
              Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'Password',pl[i]);
              Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'STUN',tl[i]);
              Ini.WriteString('ACCOUNT'+IntToStr(i+1), 'Proxy', xl[i]);
            end;
            Ini.WriteInteger('ACCOUNT', 'Count', sl.Count);
          finally
            sl.Free;
            ul.Free;
            pl.Free;
            tl.Free;
            xl.Free;
          end;
          TAccountsFrm1.AccountList.Items.Add.Caption := s;
          TAccountsFrm1.AccountList.Items[TAccountsFrm1.AccountList.Items.Count-1].SubItems.Add(u);
        finally
          Ini.Free;
        end;
      end;
    end;
  finally
    RF.Free;
  end;
end;

procedure TMainForm.EditActionUpdate(Sender: TObject);
begin
  EditAction.Enabled := (TAccountsFrm1.AccountList.Items.Count > 0) and
    (TAccountsFrm1.AccountList.Selected <> nil);
end;

procedure TMainForm.EditActionExecute(Sender: TObject);
var
  RF: TRegistrationForm;
  s, u: String;
  idx: Integer;
  Ini: TIniFile;
  cur: Boolean;
  cnt, i: Integer;
begin
  RF := TRegistrationForm.Create(nil);
  try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+IniFileName);
    try
      s := TAccountsFrm1.AccountList.Selected.Caption;
      u := TAccountsFrm1.AccountList.Selected.SubItems[0];
      RF.ServerEdit.Text := s;
      RF.UserEdit.Text := u;

      cur := (s = Ini.ReadString('ACCOUNT', 'Server','')) and
        (u = Ini.ReadString('ACCOUNT', 'User',''));

      if cur then
      begin
        RF.PasswordEdit.Text := Ini.ReadString('ACCOUNT', 'Password','');
        RF.STUNEdit.Text := Ini.ReadString('ACCOUNT', 'STUN','');
        RF.ProxyEdit.Text := Ini.ReadString('ACCOUNT', 'Proxy','');
      end;

      cnt := Ini.ReadInteger('ACCOUNT', 'Count',0);
      idx := 0;

      for i := 1 to cnt do
      begin
        if (s = Ini.ReadString('ACCOUNT'+IntToStr(i), 'Server','')) and
        (u = Ini.ReadString('ACCOUNT'+IntToStr(i), 'User','')) then
        begin
          RF.PasswordEdit.Text := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Password','');
          RF.STUNEdit.Text := Ini.ReadString('ACCOUNT'+IntToStr(i), 'STUN','');
          RF.ProxyEdit.Text := Ini.ReadString('ACCOUNT'+IntToStr(i), 'Proxy', '');
          idx := i;
          break;
        end;
      end;

      if RF.ShowModal = mrOk then
      begin
        if cur then
        begin
          OfflineMenuClick(nil);
          ServerEditText := RF.ServerEdit.Text;
          UserEditText := RF.UserEdit.Text;
          PasswordEditText := RF.PasswordEdit.Text;
          STUNEditText := RF.STUNEdit.Text;
          ProxyEditText := RF.ProxyEdit.Text;
          Ini.WriteString('ACCOUNT', 'Server',ServerEditText);
          Ini.WriteString('ACCOUNT', 'User',UserEditText);
          Ini.WriteString('ACCOUNT', 'Password',PasswordEditText);
          Ini.WriteString('ACCOUNT', 'STUN',STUNEditText);
          Ini.WriteString('ACCOUNT', 'Proxy',ProxyEditText);
        end;
        if idx > 0 then
        begin
          Ini.WriteString('ACCOUNT'+IntToStr(idx), 'Server', RF.ServerEdit.Text);
          Ini.WriteString('ACCOUNT'+IntToStr(idx), 'User', RF.UserEdit.Text);
          Ini.WriteString('ACCOUNT'+IntToStr(idx), 'Password', RF.PasswordEdit.Text);
          Ini.WriteString('ACCOUNT'+IntToStr(idx), 'STUN', RF.STUNEdit.Text);
          Ini.WriteString('ACCOUNT'+IntToStr(idx), 'Proxy', RF.ProxyEdit.Text);
        end;
        TAccountsFrm1.AccountList.Selected.Caption := RF.ServerEdit.Text;
        TAccountsFrm1.AccountList.Selected.SubItems[0] := RF.UserEdit.Text;
      end;
    finally
      Ini.Free;
    end;
  finally
    RF.Free;
  end;
end;

procedure TMainForm.SipClientDtmf(Sender: TObject; const ACall: ISipCall;
  const Dtmf: String);
var
  i: Integer;
begin
  for i := 1 to 6 do
  begin
    if (FLines[i] = ACall) and (ACall.State = csActive) then
    begin
      FDtmf[i] := FDtmf[i] + Dtmf;
      ShowMemo;
    end;
  end;
end;

procedure TMainForm.ShowMemo;
var
  text: String;
begin
  text := 'Line '+IntToStr(FLineIndex);
  if Assigned(FLines[FLineIndex]) then
  begin
    if FLines[FLineIndex].CallType = ctIncoming then
      text := text + ' Incoming'+#13#10
    else
      text := text + ' Outgoing'+#13#10;
    text := text + FLines[FLineIndex].RemoteUser;
    if FDtmf[FLineIndex] <> '' then
      text := text + #13#10 + 'DTMF detected: '+FDtmf[FLineIndex];
  end;
  TDialFrm1.LineMemo.Text := text;
end;

procedure TMainForm.SBtn1Click(Sender: TObject);
begin
  FLineIndex := (Sender as TSpeedButton).Tag;
  RefreshLines;
end;

procedure TMainForm.RecordActionExecute(Sender: TObject);
var
  Dlg: TSaveDialog;
begin
  if not Assigned(FRecorder) then
  begin
    FRecorder := SipClient.CreateRecorder;
    if Assigned(FLines[FLineIndex]) then
      FLines[FLineIndex].SetRecorder(FRecorder);
  end
  else
  begin
    Dlg := TSaveDialog.Create(nil);
    try
      if Dlg.Execute then
        FRecorder.SaveToFile(Dlg.FileName);
    finally
      Dlg.Free;
    end;
    FRecorder := nil;
  end;
end;

procedure TMainForm.RecordActionUpdate(Sender: TObject);
begin
  RecordAction.Enabled := (Assigned(FLines[FLineIndex]) and
    (FLines[FLineIndex].State in [csActive, csRinging, csHold, csConnecting]))
    or Assigned(FRecorder);

  TDialFrm1.RecordBtn.Enabled := RecordAction.Enabled;
  if not Assigned(FRecorder) then
  begin
    if TDialFrm1.RecordBtn.Caption <> 'Record' then
      TDialFrm1.RecordBtn.Caption := 'Record'
  end
  else
  begin
    if TDialFrm1.RecordBtn.Caption <> 'Save Audio File' then
      TDialFrm1.RecordBtn.Caption := 'Save Audio File';
  end;
end;

procedure TMainForm.RefreshLines;
var
  i: Integer;

  procedure SetGlyph(Index: Integer);
  var
    B: TBitmap;
  begin
    B := TBitmap.Create;
    try
      StatusImages.GetBitmap(2+Integer(FLineImages[Index]), B);
      B.PixelFormat := pf24bit;
      FButtons[Index].Glyph.Assign(B);
      FButtons[Index].Glyph.TransparentColor := clWhite;
      FButtons[Index].Glyph.Transparent := True;
    finally
      B.Free;
    end;
  end;

begin
  for i := 1 to 6 do
  begin

    if Assigned(FLines[i]) then
    begin
      if FLines[i].EnableAudioOut <> (FLineIndex = i) then
        FLines[i].EnableAudioOut := FLineIndex = i;
      if FLines[i].EnableAudioIn <> (FLineIndex = i) then
        FLines[i].EnableAudioIn := FLineIndex = i;
    end;

    if (FLineIndex = i) and Assigned(FLines[i]) and (FLines[i].State = csActive) then
    begin
      if not FLineImages[i] then
      begin
        FLineImages[i] := True;
        SetGlyph(i);
      end;
    end
    else
    begin
      if Assigned(FLines[i]) and (FLines[i].State <> csInactive) then
      begin
        FLineImages[i] := not FLineImages[i];
        SetGlyph(i);
      end
      else
      begin
        if FLineImages[i] then
        begin
          FLineImages[i] := False;
          SetGlyph(i);
        end;
      end;
    end;
  end;
  ShowMemo;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  RefreshLines;
end;

procedure TMainForm.ActivateDialpadFrameBtnClick(Sender: TObject);
begin
  TDialFrm1.Visible := True;
  TAccountsFrm1.Visible := False;
  TAudioFrm1.Visible := False;
end;

procedure TMainForm.ActivateAccountsFrameBtnClick(Sender: TObject);
begin
  TDialFrm1.Visible := False;
  TAccountsFrm1.Visible := True;
  TAudioFrm1.Visible := False;
end;

procedure TMainForm.ActivateAudioFrameBtnClick(Sender: TObject);
begin
  TDialFrm1.Visible := False;
  TAccountsFrm1.Visible := False;
  TAudioFrm1.Visible := True;
end;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://sipcomponents.com', nil, nil,  sw_ShowMaximized);
end;

procedure TMainForm.ConferenceActionUpdate(Sender: TObject);
var
  cnt, i: Integer;
begin
  if not Assigned(FConference) then
  begin
    cnt := 0;
    for i := 1 to 6 do
    begin
      if Assigned(FLines[i]) and (FLines[i].State = csActive) then
      begin
        Inc(cnt);
        if cnt > 1 then break;
      end;
    end;
    ConferenceAction.Enabled := cnt > 1;
    ConferenceAction.Caption := 'Conference';
  end
  else
  begin
    ConferenceAction.Caption := 'Stop Conf.';
    ConferenceAction.Enabled := True;
  end;
end;

procedure TMainForm.ConferenceActionExecute(Sender: TObject);
var
  i: Integer;
begin
  if Assigned(FConference) then
    FConference := nil
  else
    FConference := SipClient.CreateConference;

  for i := 1 to 6 do
  begin
    if Assigned(FLines[i]) and (FLines[i].State = csActive) then
      FLines[i].SetConference(FConference);
  end;
end;

end.
