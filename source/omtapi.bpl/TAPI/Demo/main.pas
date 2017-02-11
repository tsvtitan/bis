{******************************************************************************}
{*        Copyright 1999-2003 by J.Friebel all rights reserved.               *}
{*        Autor           :  J�rg Friebel                                     *}
{*        Compiler        :  Delphi 7                                         *}
{*        System          :  Windows XP / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  22.08.2003                                       *}
{*        Version         :  3.9                                              *}
{*        EMail           :  tapi@delphiclub.de                               *}
{******************************************************************************}
{*                                                                            *}
{*    This File is free software; You can redistribute it and/or modify it    *}
{*    under the term of GNU Library General Public License as published by    *}
{*    the Free Software Foundation. This File is distribute in the hope       *}
{*    it will be useful "as is", but WITHOUT ANY WARRANTY OF ANY KIND;        *}
{*    See the GNU Library Public Licence for more details.                    *}
{*                                                                            *}
{******************************************************************************}
{*                                                                            *}
{*    Diese Datei ist Freie-Software. Sie k�nnen sie weitervertreiben         *}
{*    und/oder ver�ndern im Sinne der Bestimmungen der "GNU Library GPL"      *}
{*    der Free Software Foundation. Diese Datei wird,"wie sie ist",           *}
{*    zur Verf�gung gestellt, ohne irgendeine GEW�HRLEISTUNG                  *}
{*                                                                            *}
{******************************************************************************}
{*                          www.delphiclub.de                                 *}
{******************************************************************************}

unit main;

interface

uses
  mmsystem,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, TAPICall, CallList, TAPITon, TAPIPhone, DevConf,
  TAPIAddress, TAPILines, TAPIDevices, TAPIServices, TAPISystem, Menus,
  StdCtrls, ComCtrls, Dialogs, TAPIErr, TAPILineConfigDlg, TAPIWave;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Beenden1: TMenuItem;
    N1: TMenuItem;
    Look: TMenuItem;
    DialNumber: TMenuItem;
    ReInit: TMenuItem;
    Neu1: TMenuItem;
    KeypadGroupBox: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    DialButton: TButton;
    Label1: TLabel;
    TAPILineService1: TTAPILineService;
    TAPIPhoneService1: TTAPIPhoneService;
    TAPILineDevice1: TTAPILineDevice;
    TAPIPhoneDevice1: TTAPIPhoneDevice;
    TAPILine1: TTAPILine;
    TAPIAddress1: TTAPIAddress;
    OutboundCall: TTAPICall;
    InboundCall: TTAPICall;
    StatusBar1: TStatusBar;
    TAPILineDeviceConfig1: TTAPILineDeviceConfig;
    ClearButton: TButton;
    TAPIPhone1: TTAPIPhone;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    InboundDigits: TTAPIDigits;
    OutboundDigits: TTAPIDigits;
    HoldButton: TButton;
    HandSetVolumeBar: TProgressBar;
    HandSetGainBar: TProgressBar;
    HandSetGainUpDown: TUpDown;
    HeadSetGainBar: TProgressBar;
    HeadSetVolumeBar: TProgressBar;
    HeadSetVolUpDown: TUpDown;
    HeadSetGainUpDown: TUpDown;
    SpeakerGainBar: TProgressBar;
    SpeakerVolumeBar: TProgressBar;
    SpeakerGainUpDown: TUpDown;
    SpeakerVolUpDown: TUpDown;
    HandSetVolUpDown: TUpDown;
    TAPICallList1: TTAPICallList;
    SpkCheckBox: TCheckBox;
    CallParams1: TCallParams;
    Edit1: TEdit;
    Label2: TLabel;
    CallInfoBox: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    HdsCheckBox: TCheckBox;
    TAPILineConfigDlg1: TTAPILineConfigDlg;
    TAPILine2: TTAPILine;
    MonitorCall: TTAPICall;
    TAPIAddress2: TTAPIAddress;
    InboundModemCall: TTAPICall;
    Button13: TButton;
    AVMSecondDevice: TTAPILineDevice;
    AVMSecondLine: TTAPILine;
    AVMInboundCall: TTAPICall;
    AVMAddress: TTAPIAddress;
    Option1: TMenuItem;
    AVMSupportoff1: TMenuItem;
    procedure Beenden1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TAPILine1AfterOpen(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure DialButtonClick(Sender: TObject);
    procedure KeypadClick(Sender: TObject);
    procedure TAPILine1BeforeOpen(Sender: TObject);
    procedure TAPIPhone1Reply(Sender: TObject; AsyncFunc: TAsyncFunc;
      Error: Cardinal);
    procedure TAPIPhone1StateDisplay(Sender: TObject);
    procedure InboundCallStateDisconnected(Sender: TObject;
      DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
    procedure OutboundCallStateDisconnected(Sender: TObject;
      DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
    procedure ComboBox1Change(Sender: TObject);
    procedure InboundCallStateOnHold(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure InboundCallStateOffering(Sender: TObject;
      OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
    procedure InboundCallStateIdle(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure HoldButtonClick(Sender: TObject);
    procedure InboundCallStateConnected(Sender: TObject;
      ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
    procedure OutboundCallStateProceeding(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure OutboundCallStateIdle(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure TAPIPhone1StateHandSetGain(Sender: TObject);
    procedure HandSetGainUpDownChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure TAPIPhone1StateHandSetVolume(Sender: TObject);
    procedure VolUpDownChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure TAPIPhone1StateHeadSetGain(Sender: TObject);
    procedure TAPIPhone1StateSpeakerGain(Sender: TObject);
    procedure TAPIPhone1StateSpeakerVolume(Sender: TObject);
    procedure SpeakerVolUpDownChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure SpeakerGainUpDownChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure HeadSetVolUpDownChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure HeadSetGainUpDownChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure TAPIPhone1StateHeadSetVolume(Sender: TObject);
    procedure TAPILineDevice1StateClose(Sender: TObject);
    procedure OutboundCallStateDialing(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure OutboundCallStateRingBack(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure OutboundCallStateDialTone(Sender: TObject;
      DialTonMode: TLineDialToneMode; Rights: TLineCallPrivilege);
    procedure InboundCallStateAccepted(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure TAPILineDevice1StateRinging(Sender: TObject; RingModeIndex,
      RingCounter: Cardinal);
    procedure TAPIAddress1AppNewCall(Sender: TObject; Call: TTAPICall;
      AddressID: Cardinal; Privilege: TLineCallPrivilege);
    procedure OutboundCallStateBusy(Sender: TObject;
      BusyMode: TLineBusyMode; Rights: TLineCallPrivilege);
    procedure SpkCheckBoxClick(Sender: TObject);
    procedure TAPILineDevice1StateNumCalls(Sender: TObject);
    procedure ReInitClick(Sender: TObject);
    procedure TAPILine1Reply(Sender: TObject; AsyncFunc: TAsyncFunc;
      Error: Cardinal);
    procedure OutboundCallReply(Sender: TObject; AsyncFunc: TAsyncFunc;
      Error: Cardinal);
    procedure DialNumberClick(Sender: TObject);
    procedure OutboundCallStateUnknown(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure ComboBox2Change(Sender: TObject);
    procedure TAPIPhone1AfterOpen(Sender: TObject);
    procedure TAPIPhone1BeforeOpen(Sender: TObject);
    procedure LookClick(Sender: TObject);
    procedure OutboundCallInfoDisplay(Sender: TObject);
    procedure OutboundCallInfoOrigin(Sender: TObject);
    procedure OutboundCallInfoCallerId(Sender: TObject);
    procedure OutboundCallInfoCalledId(Sender: TObject);
    procedure InboundCallInfoCalledId(Sender: TObject);
    procedure InboundCallInfoCallerId(Sender: TObject);
    procedure InboundCallInfoDisplay(Sender: TObject);
    procedure InboundCallInfoOrigin(Sender: TObject);
    procedure TAPILineService1LineCreate(Sender: TObject;
      NewDeviceID: Cardinal);
    procedure TAPIPhoneService1PhoneCreate(Sender: TObject;
      NewDeviceID: Cardinal);
    procedure TAPIPhoneService1PhoneRemove(Sender: TObject;
      DeviceID: Cardinal);
    procedure TAPILineService1LineRemove(Sender: TObject;
      DeviceID: Cardinal);
    procedure HdsCheckBoxClick(Sender: TObject);
    procedure Neu1Click(Sender: TObject);
    procedure OutboundCallStateOnHold(Sender: TObject;
      Rights: TLineCallPrivilege);
    procedure InboundModemCallStateOffering(Sender: TObject;
      OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
    procedure TAPIAddress2AppNewCall(Sender: TObject; Call: TTAPICall;
      AddressID: Cardinal; Privilege: TLineCallPrivileges);
    procedure MonitorCallStateOffering(Sender: TObject;
      OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
    procedure MonitorCallStateDisconnected(Sender: TObject;
      DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
    procedure InboundModemCallStateDisconnected(Sender: TObject;
      DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
    procedure MonitorCallInfoOrigin(Sender: TObject);
    procedure MonitorCallInfoCalledId(Sender: TObject);
    procedure MonitorCallInfoCallerId(Sender: TObject);
    procedure MonitorCallInfoDisplay(Sender: TObject);
    procedure MonitorCallInfoNumOwnerDecr(Sender: TObject);
    procedure InboundModemCallInfoNumOwnerDecr(Sender: TObject);
    procedure InboundCallInfoConnectedId(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure AVMInboundCallStateDisconnected(Sender: TObject;
      DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
    procedure AVMInboundCallStateIdle(Sender: TObject;
      Rights: TLineCallPrivileges);
    procedure AVMInboundCallStateOffering(Sender: TObject;
      OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
    procedure AVMAddressAppNewCall(Sender: TObject; Call: TTAPICall;
      AddressID: Cardinal; Privilege: TLineCallPrivileges);
    procedure AVMInboundCallStateAccepted(Sender: TObject;
      Rights: TLineCallPrivileges);
    procedure AVMSupportoff1Click(Sender: TObject);
    procedure AVMInboundCallStateConnected(Sender: TObject;
      ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
    procedure OutboundCallStateConnected(Sender: TObject;
      ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
  private
    { Private-Deklarationen }
    FHandsetStatus: Boolean;
    FSpeakerStatus: Boolean;
    FHeadSetStatus: Boolean;
    FLinePriority: Boolean;
    FUseingModem: Boolean;
    LinesFromPhone: Array[0..3]of DWord;
    //FAVMSecondDevice: TTAPILineDevice;
    //FAVMSecondLine: TTAPILine;
    function GetPhoneSupport: Boolean;
    function GetCanDial: Boolean;
    function GetHandset: Boolean;
    function RealPos(Value:Smallint):DWord;
    function VirtPos(Value:Integer):Smallint;
    procedure DisplaySpeakerVol(UpdateUpDown: Boolean = False);
    procedure DisplaySpeakerGain(UpdateUpDown: Boolean = False);
    procedure DisplayHandSetVol(UpdateUpDown: Boolean = False);
    procedure DisplayHandSetGain(UpdateUpDown: Boolean = False);
    procedure DisplayHeadSetVol(UpdateUpDown: Boolean = False);
    procedure DisplayHeadSetGain(UpdateUpDown: Boolean = False);
    procedure SetHandSet(const Value: Boolean);
    function GetCallExist(const Index: Integer): Boolean;
    function GetSpeaker: Boolean;
    procedure SetSpeaker(const Value: Boolean);
    procedure Disconnect;
    function GetLineSupport: Boolean;
    procedure UpdateCallerInfo;
    function GetHeadSet: Boolean;
    procedure SetHeadSet(const Value: Boolean);
  public
    { Public-Deklarationen }
    property PhoneSupport: Boolean read GetPhoneSupport;
    property LineSupport: Boolean read GetLineSupport;
    property CanDial: Boolean read GetCanDial;
    property Handset: Boolean read GetHandset write SetHandSet;
    property Speaker: Boolean read GetSpeaker write SetSpeaker;
    property Headset: Boolean read GetHeadSet write SetHeadSet;
    property InboundCallExist: Boolean index 1 read GetCallExist;
    property OutboundCallExist:Boolean index 2 read GetCallExist;
    property MonitorCallExist:Boolean index 3 read GetCallExist;
    property InboundAVMCallExist:Boolean index 4 read GetCallExist;
  end;

var
  Form1: TForm1;

implementation

uses linedlg;

{$R *.dfm}

procedure TForm1.Beenden1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var TempLineDevice: TTAPILineDevice;
    TempPhoneDevice: TTAPIPhoneDevice;
    i: Integer;
    LastDev:Integer;
begin
  UpdateCallerInfo;
  if TAPILineService1.Version < 3.8 then Close;
  HandSetGainBar.Max:=$FFFF;
  HandSetVolumeBar.Max:=$FFFF;
  HeadSetGainBar.Max:=$FFFF;
  HeadSetVolumeBar.Max:=$FFFF;
  SpeakerGainBar.Max:=$FFFF;
  SpeakerVolumeBar.Max:=$FFFF;
  Label1.Caption:='';
  LastDev:=0;
  Memo1.Lines.Add('System - Check');
  TAPILineService1.Active:=True;
  TempLineDevice:=TTAPILineDevice.Create(self);
  TempLineDevice.Service:=TAPILineService1;
  ComboBox1.Clear;
  for i:=0 to TAPILineService1.NumDevice -1 do
  begin
    TempLineDevice.ID:=i;
    if mmInteractiveVoice in TempLineDevice.Caps.MediaModes then
      LastDev:=i;
    ComboBox1.Items.Add(TempLineDevice.Caps.Name);
  end;
  TAPILineDevice1.ID:=LastDev;
  TempLineDevice.Free;
  TAPIPhoneService1.Active:=True;
  ComboBox2.Clear;
  ComboBox2.Items.Add('Phone Support disabled');
  TempPhoneDevice:=TTAPIPhoneDevice.Create(self);
  try
    try
      TempPhoneDevice.Service:=TAPIPhoneService1;
      for i:=0 to TAPIPhoneService1.NumDevice -1 do
      begin
        TempPhoneDevice.ID:=i;
        ComboBox2.Items.Add(TempPhoneDevice.Caps.Name);
      end;
    except
      // Not Phone Devices avalible !!
    end
  finally
    TempPhoneDevice.Free;
  end;
  ComboBox2.ItemIndex:=0;
  
  TAPILine1.Active:=True;
end;

function TForm1.GetPhoneSupport: Boolean;
var i: Integer;
begin
  Result:=False;
  if TAPIPhoneService1.Active then
  begin
    if (TAPIPhoneService1.NumDevice > 0) then
    begin
      for i:=0 to 3 do
      begin
        If TAPILineDevice1.ID = LinesFromPhone[i] then
        begin
          FLinePriority:=False;
          Result:=True;
          break;
        end;  
      end;
    end;
  end;
end;

function TForm1.GetLineSupport: Boolean;
begin
  Result:=False;
  if TAPILineService1.Active then
  begin
    if TAPILineService1.NumDevice > 0 then
    begin
      if LinesFromPhone[0]<> DWORD(-1) then
      begin
        FLinePriority:=False;
        Result:=True;
      end;
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TAPIPhone1.Active:=False;
  PlaySound(nil,hInstance,SND_PURGE);
  TAPIPhoneService1.Active:=False;
  TAPILine1.Active:=False;
  TAPILine2.Active:=False;
  AVMSecondLine.Active:=False;
  TAPILineService1.Active:=False;
end;

procedure TForm1.TAPILine1AfterOpen(Sender: TObject);
var i: Integer;
    aTerm: TTermCapsItem;
begin
  if TAPILine1.Status.NumActiveCalls <> 0 then
  begin
    TAPICallList1.UpdateList;

  end;
  if TAPILine1.Active then Memo1.Lines.Add('Lines - Check: OK');
   StatusBar1.SimpleText:=TAPILineDevice1.Caps.Name;

  if PhoneSupport then
  begin
    //TAPIPhone1.Device.ID:=TAPILine1.PhoneID;
    ComboBox2.ItemIndex:=TAPIPhone1.Device.ID+1;
    TAPIPhone1.Active:=True;
    //for i:=0 to 3 do LinesFromPhone[i]:=DWord(-1);
    //TAPIPhone1.GetLineIDs(LinesFromPhone);
    Memo1.Lines.Add(TAPIPhone1.Device.Caps.Name);
    Memo1.Lines.Add('Phone - Check: OK');
  end
  else
    Memo1.Lines.Add('Phone - Check: ERROR');

  for i:=0 to TAPILine1.Device.Caps.TerminalCaps.Count-1 do
  begin
    aTerm:=TAPILine1.Device.Caps.TerminalCaps.Items[i];
    if aTerm.TermDev = ltdPhone then
    begin

    end
  end;

  DialButton.Enabled:=CanDial;
  TAPIPhone1StateDisplay(self);
  DisplayHandSetGain(True);
  DisplayHandSetVol(True);
  DisplayHeadSetGain(True);
  DisplayHeadSetVol(True);
  DisplaySpeakerGain(True);
  DisplaySpeakerVol(True);
end;

procedure TForm1.TAPIPhone1AfterOpen(Sender: TObject);
var i: Integer;
begin
  for i:=0 to 3 do LinesFromPhone[i]:=DWord(-1);
  TAPIPhone1.GetLineIDs(LinesFromPhone);
  if TAPIPhone1.Active then Memo1.Lines.Add('Phone - Check: OK');
   StatusBar1.SimpleText:=TAPIPhoneDevice1.Caps.Name;

  if LineSupport then
  begin
    if LinesFromPhone[1] = DWORD(-1) then
      TAPILine1.Device.ID:=LinesFromPhone[0]
    else
    begin
      SelLineDlg:=TSelLineDlg.Create(self);
      SelLineDlg.ComboBox1.Clear;
      SelLineDlg.ComboBox1.ItemIndex:=-1;
      for i:=0 to 3 do
      begin
        if LinesFromPhone[i] <> DWord(-1) then
        begin
          TAPILine1.Device.ID:=LinesFromPhone[i];
          SelLineDlg.ComboBox1.Items.Add(TAPILine1.Device.Caps.Name);
          SelLineDlg.ComboBox1.ItemIndex:=0;
        end;
      end;
      SelLineDlg.ShowModal;
      TAPILine1.Device.ID:=LinesFromPhone[SelLineDlg.ComboBox1.ItemIndex];
      SelLineDlg.Free;
    end;
    ComboBox1.ItemIndex:=TAPILine1.Device.ID;
    TAPILine1.Active:=True;
    Memo1.Lines.Add(TAPILine1.Device.Caps.Name);
    Memo1.Lines.Add('Line - Check: OK');
  end;
  DialButton.Enabled:=CanDial;
  TAPIPhone1StateDisplay(self);
  DisplayHandSetGain(True);
  DisplayHandSetVol(True);
  DisplayHeadSetGain(True);
  DisplayHeadSetVol(True);
  DisplaySpeakerGain(True);
  DisplaySpeakerVol(True);
end;

procedure TForm1.ClearButtonClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
  if PhoneSupport then
    TAPIPhone1StateDisplay(self);
  TAPIAddress1.Address:='';
  DialButton.Enabled:=CanDial;
end;

function TForm1.GetCanDial: Boolean;
begin
  Result:=False;
  with TAPIAddress1 do
  begin
    if Line.Active and (Address <> '') and
      (lfMakeCall in Line.Device.Caps.LineFeatures) then Result:=True;
  end;
end;

procedure TForm1.DialButtonClick(Sender: TObject);
//var Addr: PChar;
begin
  Handset:=Not(Handset);
  if DialButton.Caption='Dial' then
  begin
    ClearButton.Enabled:=False;
    //
    //Addr:=PChar(Edit1.Text);
    {if Not (amAddressID in TAPIAddress1.Line.Device.Caps.AddressModes ) or DialNumber.Checked then
    begin
      try
        TAPIAddress1.GetAddressID(Addr);
      except
      end;
      CallParams1.AddressMode:=amDialableAddr;
      CallParams1.AddressID:=TAPIAddress1.ID;
      CallParams1.OrigAddress:=Addr;
    end
    else
      CallParams1.AddressMode:=amAddressID; }
    TAPIAddress1.MakeCall;
  end;
 if DialButton.Caption='Answer'then
    if InboundCallExist then InBoundCall.Answer;
    if InBoundAVMCallExist then AVMInBoundCall.Answer;
 if DialButton.Caption='Drop' then
  begin
    if InboundCallExist then InboundCall.Drop;
    if OutboundCallExist then OutBoundCall.Drop;
    if InBoundAVMCallExist then AVMInBoundCall.Drop;
    ClearButton.Enabled:=True;
    SpkCheckBox.Checked:=False;
    HdsCheckBox.Checked:=False;
  end;
end;

procedure TForm1.KeypadClick(Sender: TObject);
var Key: Integer;
begin
  Key:=-1;
  if Sender = Button1 then Key:=Button1.Tag;
  if Sender = Button2 then Key:=Button2.Tag;
  if Sender = Button3 then Key:=Button3.Tag;
  if Sender = Button4 then Key:=Button4.Tag;
  if Sender = Button5 then Key:=Button5.Tag;
  if Sender = Button6 then Key:=Button6.Tag;
  if Sender = Button7 then Key:=Button7.Tag;
  if Sender = Button8 then Key:=Button8.Tag;
  if Sender = Button9 then Key:=Button9.Tag;
  if Sender = Button10 then Key:=Button10.Tag;
  if Sender = Button11 then Key:=Button11.Tag;
  if Sender = Button12 then Key:=Button12.Tag;
  if (TAPILine1.Status.NumActiveCalls <> DWord(-1)) then
  begin
    if Key < 10 then
      TAPIAddress1.Address:=TAPIAddress1.Address+IntToStr(Key)
    else
    begin
      if Key=10 then TAPIAddress1.Address:=TAPIAddress1.Address+'*';
      if Key=11 then TAPIAddress1.Address:=TAPIAddress1.Address+'#';
    end;
  end
  else
  begin
    InBoundDigits.GenerateDigits:=IntToStr(Key);
    InBoundDigits.GenerateDigit;
    OutBoundDigits.GenerateDigits:=IntToStr(Key);
    OutBoundDigits.GenerateDigit;
  end;
  DialButton.Enabled:=CanDial;
  TAPIPhone1StateDisplay(self);
end;

function TForm1.GetHeadSet: Boolean;
begin
  Result:=FHeadSetStatus;
  if PhoneSupport then
    Result:=Result and not(phsmOnHook = TAPIPhone1.Status.HeadSetHookSwitchMode);
end;

procedure TForm1.SetHeadSet(const Value: Boolean);
begin
  if FHeadSetStatus <> Value then
  begin
    if PhoneSupport then
    begin
      if pfSetHookSwitchHeadSet in TAPIPhone1.Device.Caps.PhoneFeatures then
        if Value then
          TAPIPhone1.HeadSetHookSwitchMode:=phsmMicSpeaker
        else
          TAPIPhone1.HeadSetHookSwitchMode:=phsmOnHook;
    end;
    FHeadSetStatus:=Value;
  end;
end;

function TForm1.GetHandset: Boolean;
begin
  Result:=FHandsetStatus;
  if PhoneSupport then
    Result:=Result and not(phsmOnHook = TAPIPhone1.Status.HandSetHookSwitchMode);
    //.HandSetHookSwitchOffHook;
end;

procedure TForm1.SetHandSet(const Value: Boolean);
begin
  if FHandsetStatus <> Value then
  begin
    if PhoneSupport then
    begin
      if pfSetHookSwitchHandset in TAPIPhone1.Device.Caps.PhoneFeatures then
        if Value then
          TAPIPhone1.HandSetHookSwitchMode:=phsmMicSpeaker
        else
          TAPIPhone1.HandSetHookSwitchMode:=phsmOnHook;
    end;
    FHandsetStatus:=Value;
  end;
end;

function TForm1.GetSpeaker: Boolean;
begin
  Result:=FSpeakerStatus;
  if PhoneSupport then
    Result:=Result and not(phsmOnHook = TAPIPhone1.Status.SpeakerHookSwitchMode);
end;

procedure TForm1.SetSpeaker(const Value: Boolean);
begin
  if FSpeakerStatus <> Value then
  begin
    if PhoneSupport then
    begin
      if pfSetHookSwitchSpeaker in TAPIPhone1.Device.Caps.PhoneFeatures then
        if Value then
          TAPIPhone1.SpeakerHookSwitchMode:=phsmMicSpeaker
        else
          TAPIPhone1.SpeakerHookSwitchMode:=phsmOnHook;
    end;
    FSpeakerStatus:=Value;
  end;
end;

procedure TForm1.TAPILine1BeforeOpen(Sender: TObject);
begin
  ComboBox1.ItemIndex:=TAPILine1.Device.ID;
end;

procedure TForm1.TAPIPhone1Reply(Sender: TObject; AsyncFunc: TAsyncFunc;
  Error: Cardinal);
begin
  if Error <> 0 then Memo1.Lines.Add('Error');
end;

procedure TForm1.TAPIPhone1StateDisplay(Sender: TObject);
var i: Integer;
    s: String;
begin
  Memo1.Lines.Clear;
  if PhoneSupport and (TAPIPhone1.Display.NumRows >=1) then
  begin
    s:= TAPIPhone1.Display.GetDisplay;
    for i:=0 to TAPIPhone1.Display.NumRows do
      Memo1.Lines.Add(copy(s,i*(TAPIPhone1.Display.NumColumn+1),TAPIPhone1.Display.NumColumn));
  end
  else
  begin
    Memo1.Lines.Add(TAPIAddress1.Address);
  end;
end;

procedure TForm1.Disconnect;
begin
  Label1.Caption:='';
  HoldButton.Enabled:=False;
  ClearButton.Enabled:=True;
  DialButton.Caption:='Dial';
  SpkCheckBox.Enabled:=False;
  SpkCheckBox.Checked:=False;
  HdsCheckBox.Enabled:=False;
  HdsCheckBox.Checked:=False;
end;

procedure TForm1.InboundCallStateDisconnected(Sender: TObject;
  DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
begin
  Disconnect;
  InboundCall.DeallocateCall;
end;

procedure TForm1.OutboundCallStateDisconnected(Sender: TObject;
  DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
begin
  //PlaySound(nil,0,SND_ALIAS or SND_ASYNC or SND_LOOP);
  Disconnect;
  PlaySound(nil,hInstance,SND_PURGE);
  OutBoundCall.DeallocateCall;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  FUseingModem:=False;
  ClearButton.Enabled:=True;
  Combobox2.ItemIndex:=0;
  TAPILine1.Active:=False;
  TAPILine2.Active:=False;
  AVMSecondLine.Active:=False;
  TAPIPhone1.Active:=False;
  TAPILine1.Device.ID:=ComboBox1.ItemIndex;
  try
    TAPILine1.Active:=True;
  except
    on ELineError do
    begin
      //MessageDlg('Line not active! ',mtError,[mbOK],0);
      //mmInteractiveVoice not supported
      TAPILine1.CallPrivileges:=[cpMonitor];
      TAPILine1.Active:=True;
      // Open LineDevice as DataModem
      TAPILine2.Active:=True;
    end;
  end;
  // AVM ISDN TAPI Services (Cntrl X)
  if AVMSupportoff1.Checked=False then
    if Pos('AVM ISDN TAPI',TAPILine1.Device.Caps.Name)=1 then
    begin
      {$IFDEF DEBUG}
      OutputDebugString('AVM ISDN TAPI Services');
      {$ENDIF}
      AVMSecondLine.Active:=False;
      AVMSecondDevice.ID:=TAPILineDevice1.ID+1;
      if AVMSecondDevice.Caps.Name <> TAPILineDevice1.Caps.Name then
        AVMSecondDevice.ID:=TAPILineDevice1.ID-1;
      AVMSecondLine.CallPrivileges:=[cpOwner];
      AVMSecondLine.Active:=True;
    end
    else
      AVMSecondLine.Active:=False;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
var i: Integer;
begin
  ClearButton.Enabled:=True;
  //Combobox1.ItemIndex:=0;
  TAPILine1.Active:=False;
  TAPIPhone1.Active:=False;
  if ComboBox2.ItemIndex > 0 then
  begin
    TAPIPhoneDevice1.ID:=ComboBox2.ItemIndex -1;
    try
      TAPIPhone1.Active:=True;
    except
      on ELineError do MessageDlg('Phone not active! ',mtError,[mbOK],0);
    end
  end
  else
  begin
    for i:=0 to 3 do LinesFromPhone[i]:=DWord(-1);
    TAPILine1.Active:=True;
  end;
end;

procedure TForm1.OutboundCallStateConnected(Sender: TObject;
  ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
begin
  PlaySound(nil,HInstance,SND_PURGE);
  Label1.Caption:='Please speak now';
  SpkCheckBox.Enabled:=True;
  SpkCheckBoxClick(SpkCheckBox);
  HdsCheckBox.Enabled:=True;
  HoldButton.Enabled:=lcfHold in TAPIAddress1.Caps.CallFeatures;
  DialButton.Caption:='Drop';
end;

procedure TForm1.InboundCallStateConnected(Sender: TObject;
  ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
begin
  UpdateCallerInfo;
  Label1.Caption:='Please speak now';
  SpkCheckBox.Enabled:=True;
  HoldButton.Enabled:=lcfHold in TAPIAddress1.Caps.CallFeatures;
  DialButton.Caption:='Drop';
end;

procedure TForm1.InboundCallStateOnHold(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  Label1.Caption:='Call is hold now';
end;

procedure TForm1.InboundCallStateOffering(Sender: TObject;
  OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
begin
  if Rights=[] then Rights:=TAPIAddress1.InBoundCall.Status.CallPrivilege;
  if (cpOwner in Rights) then
  begin
    if (lomActive in OfferingMode) or (OfferingMode=[])then
      if lacfAcceptToAlert in TAPIAddress1.Caps.AddrCapFlags then
      begin
        if lcfAccept in TAPIAddress1.InboundCall.Status.Features then
          TAPIAddress1.InBoundCall.Accept;
      end
      else
        Label1.Caption:='Please use your Handset';
  end;
  UpdateCallerInfo;
end;

procedure TForm1.InboundCallStateIdle(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  PlaySound(nil,hInstance,SND_PURGE);
  Label1.Caption:='';
  InboundCall.DeallocateCall;
  DialButton.Caption:='Dial';
end;

procedure TForm1.HoldButtonClick(Sender: TObject);
begin
  if InboundCallExist then
  begin
    if csOnHold in InboundCall.Status.State  then
      InboundCall.UnHold
    else
      InboundCall.Hold;
  end;
  if OutboundCallExist then
  begin
    if csOnHold in OutboundCall.Status.State then
      OutboundCall.UnHold
    else
      OutboundCall.Hold;
  end;
end;

function TForm1.GetCallExist(const Index: Integer): Boolean;
begin
  case Index of
    1: if (InboundCall.Handle <> DWORD(-1)) then Result:=True else Result:=False;
    2: if (OutboundCall.Handle <> DWORD(-1))then Result:=True else Result:=False;
    3: if (MonitorCall.Handle <> DWORD(-1))then Result:=True else Result:=False;
    4: if (AVMInboundCall.Handle <> DWORD(-1)) then Result:=True else Result:=False;
  else
    Result:=False;
  end;
end;

procedure TForm1.OutboundCallStateProceeding(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  Label1.Caption:='Proceeding ...';
  DialButton.Caption:='Drop';
end;

procedure TForm1.OutboundCallStateIdle(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  Disconnect;
  Label1.Caption:='';
  OutboundCall.DeallocateCall;
  DialButton.Caption:='Dial';
end;

procedure TForm1.TAPIPhone1StateHandSetGain(Sender: TObject);
begin
  DisplayHandSetGain;
end;

procedure TForm1.TAPIPhone1StateHandSetVolume(Sender: TObject);
begin
  DisplayHandSetVol;
end;

procedure TForm1.TAPIPhone1StateHeadSetGain(Sender: TObject);
begin
  DisplayHeadSetGain;
end;

procedure TForm1.TAPIPhone1StateHeadSetVolume(Sender: TObject);
begin
  DisplayHeadSetVol;
end;

procedure TForm1.TAPIPhone1StateSpeakerGain(Sender: TObject);
begin
  DisplaySpeakerGain;
end;

procedure TForm1.TAPIPhone1StateSpeakerVolume(Sender: TObject);
begin
  DisplaySpeakerVol;
end;

procedure TForm1.HandSetGainUpDownChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  TAPIPhone1.HandSetGain:=RealPos(NewValue);
end;

procedure TForm1.VolUpDownChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  TAPIPhone1.HandSetVolume:=RealPos(NewValue);
end;

procedure TForm1.SpeakerVolUpDownChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  TAPIPhone1.SpeakerVolume:=RealPos(NewValue);
end;

procedure TForm1.SpeakerGainUpDownChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  TAPIPhone1.SpeakerGain:=RealPos(NewValue);
end;

procedure TForm1.HeadSetVolUpDownChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  TAPIPhone1.HeadSetVolume:=RealPos(NewValue);
end;

procedure TForm1.HeadSetGainUpDownChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  TAPIPhone1.HeadSetGain:=RealPos(NewValue);
end;

function TForm1.RealPos(Value: Smallint): DWord;
begin
  Result:=Trunc((Value / 100)*$FFFF);
end;

function TForm1.VirtPos(Value: Integer): Smallint;
begin
  Result:=Trunc((Value / $FFFF)*100);
end;

procedure TForm1.DisplaySpeakerVol(UpdateUpDown: Boolean = False);
begin
  if PhoneSupport=False then
  begin
    SpeakerVolUpDown.Enabled:=False;
    SpeakerVolUpDown.Visible:=False;
    SpeakerVolumeBar.Visible:=False;
  end
  else
  begin
    SpeakerVolUpDown.Visible:=True;
    SpeakerVolumeBar.Visible:=True;
    SpeakerVolUpDown.Enabled:=TAPIPhone1.Device.Caps.SpeakerHookSwitchVolumeFlag;
    SpeakerVolumeBar.Position:=TAPIPhone1.SpeakerVolume;
    if UpdateUpDown then
      SpeakerVolUpDown.Position:=VirtPos(TAPIPhone1.SpeakerVolume);
  end;
end;

procedure TForm1.DisplaySpeakerGain(UpdateUpDown: Boolean = False);
begin
  if PhoneSupport=False then
  begin
    SpeakerGainUpDown.Enabled:=False;
    SpeakerGainUpDown.Visible:=False;
    SpeakerGainBar.Visible:=False;
  end
  else
  begin
    SpeakerGainUpDown.Visible:=True;
    SpeakerGainBar.Visible:=True;
    SpeakerGainUpDown.Enabled:=TAPIPhone1.Device.Caps.SpeakerHookSwitchGainFlag;
    SpeakerGainBar.Position:=TAPIPhone1.SpeakerGain;
    if UpdateUpDown then
      SpeakerGainUpDown.Position:=VirtPos(TAPIPhone1.SpeakerGain);
  end;
end;

procedure TForm1.DisplayHandSetGain(UpdateUpDown: Boolean = False);
begin
  if PhoneSupport=False then
  begin
    HandSetGainUpDown.Enabled:=False;
    HandSetGainUpDown.Visible:=False;
    HandSetGainBar.Visible:=False;
  end
  else
  begin
    HandSetGainUpDown.Visible:=True;
    HandSetGainBar.Visible:=True;
    HandSetGainUpDown.Enabled:=TAPIPhone1.Device.Caps.HandsetHookSwitchGainFlag;
    HandSetGainBar.Position:=TAPIPhone1.HandSetGain;
    if UpdateUpDown then
      HandSetGainUpDown.Position:=VirtPos(TAPIPhone1.HandSetGain);
  end;
end;

procedure TForm1.DisplayHandSetVol(UpdateUpDown: Boolean = False);
begin
  if PhoneSupport=False then
  begin
    HandSetVolUpDown.Enabled:=False;
    HandSetVolUpDown.Visible:=False;
    HandSetVolumeBar.Visible:=False;
  end
  else
  begin
    HandSetVolUpDown.Visible:=True;
    HandSetVolumeBar.Visible:=True;
    HandSetVolUpDown.Enabled:=TAPIPhone1.Device.Caps.HandsetHookSwitchVolumeFlag;
    HandSetVolumeBar.Position:=TAPIPhone1.HandSetVolume;
    if UpdateUpDown then
      HandSetVolUpDown.Position:=VirtPos(TAPIPhone1.HandSetVolume);
  end;
end;

procedure TForm1.DisplayHeadSetGain(UpdateUpDown: Boolean = False);
begin
  if PhoneSupport=False then
  begin
    HeadSetGainUpDown.Enabled:=False;
    HeadSetGainUpDown.Visible:=False;
    HeadSetGainBar.Visible:=False;
  end
  else
  begin
    HeadSetGainUpDown.Visible:=True;
    HeadSetGainBar.Visible:=True;
    HeadSetGainUpDown.Enabled:=TAPIPhone1.Device.Caps.HeadsetHookSwitchGainFlag;
    HeadSetGainBar.Position:=TAPIPhone1.HeadSetGain;
    if UpdateUpDown then
      HeadSetGainUpDown.Position:=VirtPos(TAPIPhone1.HeadSetGain);
  end;
end;

procedure TForm1.DisplayHeadSetVol(UpdateUpDown: Boolean = False);
begin
  if PhoneSupport=False then
  begin
    HeadSetVolUpDown.Enabled:=False;
    HeadSetVolUpDown.Visible:=False;
    HeadSetVolumeBar.Visible:=False;
  end  
  else
  begin
    HeadSetVolUpDown.Visible:=True;
    HeadSetVolumeBar.Visible:=True;
    HeadSetVolUpDown.Enabled:=TAPIPhone1.Device.Caps.HeadsetHookSwitchVolumeFlag;
    HeadSetVolumeBar.Position:=TAPIPhone1.HeadSetVolume;
    if UpdateUpDown then
      HeadSetVolUpDown.Position:=VirtPos(TAPIPhone1.HeadSetVolume);
  end;
end;

procedure TForm1.TAPILineDevice1StateClose(Sender: TObject);
begin
  //MessageDlg('Device is Closed',mtInformation,[mbOK],0);
end;

procedure TForm1.OutboundCallStateDialing(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  //PlaySound('RingOut',0,SND_ALIAS or SND_ASYNC or SND_LOOP);
  PlaySound(nil,hInstance,SND_PURGE);
  Label1.Caption:='Dialing ...';
end;

procedure TForm1.OutboundCallStateRingBack(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  Label1.Caption:='Ring Back';
end;

procedure TForm1.OutboundCallStateDialTone(Sender: TObject;
  DialTonMode: TLineDialToneMode; Rights: TLineCallPrivilege);
var SMode: String;
begin
  //PlaySound(nil,0,SND_ALIAS or SND_ASYNC or SND_LOOP);
  PlaySound(nil,hInstance,SND_PURGE);
  case DialTonMode of
    dtmNormal: SMode:='normal';
    dtmSpecial: SMode:='special';
    dtmInternal: SMode:='internal';
    dtmExternal: SMode:='external';
    dtmUnknown: SMode:='unknown';
    dtmUnavail: SMode:='unavail';
  end;
  Label1.Caption:='Dialton '+SMode;
end;

procedure TForm1.InboundCallStateAccepted(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  DialButton.Caption:='Answer';
  DialButton.Enabled:=True;
  Label1.Caption:='Press Answer to speak';
  UpdateCallerInfo; // AVM 
end;

procedure TForm1.TAPILineDevice1StateRinging(Sender: TObject;
  RingModeIndex, RingCounter: Cardinal);
begin
  {$IFDEF DEBUG}
  OutputDebugString(PChar('MonitorCall Handle'+IntToStr(MonitorCall.Handle)));
  {$ENDIF}
  if FUseingModem then
  begin
    //DialButton.Caption:='Answer';
    DialButton.Enabled:=False;
    Label1.Caption:='Use your phone to speak ';
  end
  else
  begin
    DialButton.Caption:='Answer';
    DialButton.Enabled:=True;
    Label1.Caption:='Press Answer to speak ';
  end;
  if RingCounter > 5 then
  begin
    DialButton.Enabled:=False;
    if FUseingModem then
      MonitorCall.Drop
    else
      InboundCall.Drop;
  end;
end;

procedure TForm1.TAPIAddress1AppNewCall(Sender: TObject; Call: TTAPICall;
  AddressID: Cardinal; Privilege: TLineCallPrivilege);
begin
  UpdateCallerInfo;
end;

procedure TForm1.OutboundCallStateBusy(Sender: TObject;
  BusyMode: TLineBusyMode; Rights: TLineCallPrivilege);
begin
  //PlaySound(nil,0,SND_ALIAS or SND_ASYNC or SND_LOOP);
  PlaySound(nil,hInstance,SND_PURGE);
  if lcfCompleteCall in OutBoundCall.Status.Features then
  begin
    OutBoundCall.CompletionMode:=lccmCampon;
    OutBoundCall.CompleteCall;
  end;
end;

procedure TForm1.SpkCheckBoxClick(Sender: TObject);
begin
  Speaker:=Not(Speaker);
end;

procedure TForm1.HdsCheckBoxClick(Sender: TObject);
begin
  HeadSet:=Not(HeadSet);
end;

procedure TForm1.TAPILineDevice1StateNumCalls(Sender: TObject);
begin
 // DEBUG
end;

procedure TForm1.ReInitClick(Sender: TObject);
begin
  TAPIPhone1.Active:=False;
  TAPILine1.Active:=False;
  TAPIPhoneService1.Active:=False;
  TAPILineService1.Active:=False;
  TAPIAddress1.Address:='';
  Sleep(1000);
  TAPILineService1.Active:=True;
  TAPIPhoneService1.Active:=True;
  TAPILine1.Active:=True;
end;

procedure TForm1.TAPILine1Reply(Sender: TObject; AsyncFunc: TAsyncFunc;
  Error: Cardinal);
begin
  if Error <> 0 then Label1.Caption:='Line Error';
end;

procedure TForm1.OutboundCallReply(Sender: TObject; AsyncFunc: TAsyncFunc;
  Error: Cardinal);
begin
  if Error <> 0 then Label1.Caption:='Call Error'
  else
  if AsyncFunc =afMakeCall then
  begin
    Label1.Caption:='Please use your Handset';
    PlaySound('RingOut',0,SND_ALIAS or SND_ASYNC or SND_LOOP);
  end;
end;

procedure TForm1.DialNumberClick(Sender: TObject);
begin
  DialNumber.Checked:=Not(DialNumber.Checked);
end;

procedure TForm1.OutboundCallStateUnknown(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  OutBoundCall.SetMediaMode([mmInteractiveVoice]);
end;



procedure TForm1.TAPIPhone1BeforeOpen(Sender: TObject);
begin
  ComboBox2.ItemIndex:=TAPIPhone1.Device.ID+1;
end;

procedure TForm1.LookClick(Sender: TObject);
begin
  Look.Checked:=Not(Look.Checked);
  KeypadGroupBox.Enabled:=Not(Look.Checked);
end;

procedure TForm1.UpdateCallerInfo;
var usedInfo: TCallInfo;
begin
  usedInfo:=nil;
  if InboundCallExist then usedInfo:=InboundCall.Info;
  if InboundAVMCallExist then usedInfo:=AVMInboundCall.Info;
  if OutboundCallExist then usedInfo:=OutboundCall.Info;
  if MonitorCallExist then usedInfo:=MonitorCall.Info;
  if InboundCallExist or OutboundCallExist or InboundAVMCallExist then
  begin
    with usedInfo do
    begin
      case Origin of
        coOutBound: Label5.Caption:='OutBound';
        coInternal: Label5.Caption:='Internal';
        coExternal: Label5.Caption:='External';
        coUnknown: Label5.Caption:='Unknown';
        coUnavail: Label5.Caption:='Unavail';
        coConference: Label5.Caption:='Conference';
        coInbound: Label5.Caption:='Inbound';
      end;
      Label6.Caption:=CallerID;
      Label8.Caption:=CalledID;
      Label9.Caption:=Display;
      {$IFDEF DEBUG}
      if Label6.Caption <> '' then OutputDebugString('CallerID Info')
      else
        OutputDebugString('No CallerID Info');
      {$ENDIF}
    end;
  end
  else
  begin

    Label5.Caption:='';
    Label6.Caption:='';
    Label8.Caption:='';
    Label9.Caption:='';
  end;
end;

procedure TForm1.OutboundCallInfoDisplay(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.OutboundCallInfoOrigin(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.OutboundCallInfoCallerId(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.OutboundCallInfoCalledId(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.InboundCallInfoCalledId(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.InboundCallInfoCallerId(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.InboundCallInfoDisplay(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.InboundCallInfoOrigin(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.TAPILineService1LineCreate(Sender: TObject;
  NewDeviceID: Cardinal);
begin
  ReInitClick(Self);
end;

procedure TForm1.TAPIPhoneService1PhoneCreate(Sender: TObject;
  NewDeviceID: Cardinal);
begin
  ReInitClick(Self);
end;

procedure TForm1.TAPIPhoneService1PhoneRemove(Sender: TObject;
  DeviceID: Cardinal);
begin
  ReInitClick(Self);
end;

procedure TForm1.TAPILineService1LineRemove(Sender: TObject;
  DeviceID: Cardinal);
begin
  ReInitClick(Self);
end;

procedure TForm1.Neu1Click(Sender: TObject);
begin
  TAPILineConfigDlg1.Execute;
end;

procedure TForm1.OutboundCallStateOnHold(Sender: TObject;
  Rights: TLineCallPrivilege);
begin
  Label1.Caption:='Call is hold now';
end;

procedure TForm1.InboundModemCallStateOffering(Sender: TObject;
  OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
begin
  if Rights=[] then Rights:=TAPIAddress2.InBoundCall.Status.CallPrivilege;
  if (cpOwner in Rights) then
  begin
    if (lomActive in OfferingMode) or (OfferingMode=[])then
      if lacfAcceptToAlert in TAPIAddress1.Caps.AddrCapFlags then
        TAPIAddress2.InBoundCall.Accept;
  end;
  TAPIAddress2.InBoundCall.ChangePrivilege([cpMonitor]);
end;

procedure TForm1.TAPIAddress2AppNewCall(Sender: TObject; Call: TTAPICall;
  AddressID: Cardinal; Privilege: TLineCallPrivileges);
begin
  UpdateCallerInfo;
  if Privilege= [cpOwner] then
  begin
    Call.ChangePrivilege([cpMonitor]);
    FUseingModem:=True;
  end;
end;

procedure TForm1.MonitorCallStateOffering(Sender: TObject;
  OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
begin
  MonitorCall.ChangePrivilege([cpOwner]);
end;

procedure TForm1.MonitorCallStateDisconnected(Sender: TObject;
  DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
begin
  Disconnect;
  MonitorCall.DeallocateCall;
end;

procedure TForm1.InboundModemCallStateDisconnected(Sender: TObject;
  DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
begin
  Disconnect;
  InboundModemCall.DeallocateCall;
end;

procedure TForm1.MonitorCallInfoOrigin(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.MonitorCallInfoCalledId(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.MonitorCallInfoCallerId(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.MonitorCallInfoDisplay(Sender: TObject);
begin
  UpdateCallerInfo;
end;

procedure TForm1.MonitorCallInfoNumOwnerDecr(Sender: TObject);
begin
  if MonitorCall.Info.NumOwners=0 then MonitorCall.DeallocateCall;
end;

procedure TForm1.InboundModemCallInfoNumOwnerDecr(Sender: TObject);
begin
  if InboundModemCall.Info.NumOwners=1 then InboundModemCall.DeallocateCall;
end;

procedure TForm1.InboundCallInfoConnectedId(Sender: TObject);
begin
   UpdateCallerInfo;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  Label5.Caption:='';
  Label6.Caption:='';
  Label8.Caption:='';
  Label9.Caption:='';
end;

procedure TForm1.AVMInboundCallStateDisconnected(Sender: TObject;
  DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
begin
  Disconnect;
  AVMInboundCall.DeallocateCall;
end;

procedure TForm1.AVMInboundCallStateIdle(Sender: TObject;
  Rights: TLineCallPrivileges);
begin
  UpdateCallerInfo;
  PlaySound(nil,hInstance,SND_PURGE);
  Label1.Caption:='';
  AVMInboundCall.DeallocateCall;
  DialButton.Caption:='Dial';
end;

procedure TForm1.AVMInboundCallStateOffering(Sender: TObject;
  OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
begin
  if Rights=[] then Rights:=AVMAddress.InBoundCall.Status.CallPrivilege;
  if (cpOwner in Rights) then
  begin
    if (lomActive in OfferingMode) or (OfferingMode=[])then
      if lacfAcceptToAlert in AVMAddress.Caps.AddrCapFlags then
      begin
        if lcfAccept in AVMAddress.InboundCall.Status.Features then
          AVMAddress.InBoundCall.Accept;
      end
      else
        Label1.Caption:='Please use your Handset';
  end;
  UpdateCallerInfo;
end;

procedure TForm1.AVMAddressAppNewCall(Sender: TObject; Call: TTAPICall;
  AddressID: Cardinal; Privilege: TLineCallPrivileges);
begin
   UpdateCallerInfo;
end;

procedure TForm1.AVMInboundCallStateAccepted(Sender: TObject;
  Rights: TLineCallPrivileges);
begin
  DialButton.Caption:='Answer';
  DialButton.Enabled:=True;
  Label1.Caption:='Press Answer to speak';
end;

procedure TForm1.AVMSupportoff1Click(Sender: TObject);
begin
  AVMSupportoff1.Checked:=Not(AVMSupportoff1.Checked);
  if AVMSecondLine.Active and AVMSupportoff1.Checked then
    AVMSecondLine.Active:=False
  else
    MessageDlg('Please select a AVM Device !!',mtInformation,[mbOK],0);
end;

procedure TForm1.AVMInboundCallStateConnected(Sender: TObject;
  ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
begin
  UpdateCallerInfo;
  Label1.Caption:='Please speak now';
  SpkCheckBox.Enabled:=True;
  HoldButton.Enabled:=lcfHold in AVMAddress.Caps.CallFeatures;
  DialButton.Caption:='Drop';
end;

end.
