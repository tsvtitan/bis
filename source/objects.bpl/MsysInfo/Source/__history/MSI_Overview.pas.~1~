
{*******************************************************}
{                                                       }
{         MiTeC System Information Component            }
{                System Overview                        }
{           version 5.5 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}


{$INCLUDE MITEC_DEF.INC}

unit MSI_Overview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MSystemInfo, ComCtrls, StdCtrls, ExtCtrls, CheckLst,
  {$IFDEF D4PLUS} ImgList,{$ENDIF}
  Mask, Menus, Gauges, Buttons;

type
  TPage = (pgWksta, pgOS, pgCPU, pgMem, pgDisplay, pgAPM, pgMedia, pgNet, pgDev,
           pgPrn, pgEng, pgDisk, pgTZ, pgProcs, pgStartup, pgSoftware, pgAbout);

  TPages = set of TPage;

const
  iiComputer      = 0;
  iiSystem        = 1;
  iiDisplay       = 2;
  iiMonitor       = 3;
  iiVolumes       = 4;
  iiFDD           = 5;
  iiHDD           = 6;
  iiCDROM         = 7;
  iiTape          = 8;
  iiAPM           = 9;
  iiImaging       = 10;
  iiKeyboard      = 11;
  iiMouse         = 12;
  iiModem         = 13;
  iiPort          = 14;
  iiAdapter       = 15;
  iiPackage       = 16;
  iiSCSI          = 17;
  iiDriver        = 18;
  iiSound         = 19;
  iiUSB           = 20;
  iiGame          = 21;
  iiNet           = 22;
  iiProcess       = 23;
  iiPCMCIA        = 24;
  iiChanger       = 25;
  iiHID           = 26;
  iiGPS           = 27;
  iiReader        = 28;
  iiInfrared      = 29;
  iiMIDI          = 30;
  iiWave          = 31;
  iiMixer         = 32;
  iiAUX           = 33;
  iiDirectX       = 34;
  iiPrinter       = 35;
  iiPrinterDef    = 36;
  iiNetPrinter    = 37;
  iiNetPrinterDef = 38;
  


  pgAll = [pgWksta, pgOS, pgCPU, pgMem, pgDisplay, pgAPM, pgMedia, pgNet, pgDev,
           pgPrn, pgEng, pgDisk, pgTZ, pgProcs, pgStartup, pgSoftware];


type
  TfrmMSI_Overview = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bRefresh: TButton;
    Panel3: TPanel;
    pc: TPageControl;
    tsWksta: TTabSheet;
    tsOS: TTabSheet;
    tsCPU: TTabSheet;
    gbMID: TGroupBox;
    Label1: TLabel;
    eWksta: TEdit;
    Label2: TLabel;
    eUser: TEdit;
    Image1: TImage;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    eBIOSName: TEdit;
    eBIOSCopy: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    eBIOSDate: TEdit;
    eBIOSExt: TEdit;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    eLastBoot: TEdit;
    eSysTime: TEdit;
    pNumLock: TPanel;
    pCapsLock: TPanel;
    pScrollLock: TPanel;
    bOK: TButton;
    Image2: TImage;
    lVersion: TLabel;
    lVerNo: TLabel;
    Bevel1: TBevel;
    Label9: TLabel;
    Label10: TLabel;
    ePID: TEdit;
    eRegUser: TEdit;
    Label11: TLabel;
    eRegOrg: TEdit;
    GroupBox4: TGroupBox;
    bEnvironment: TButton;
    Image3: TImage;
    lCPU: TLabel;
    tsMemory: TTabSheet;
    GroupBox7: TGroupBox;
    Image4: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ePT: TEdit;
    ePF: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    eFT: TEdit;
    eFF: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    eVT: TEdit;
    eVF: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    eAG: TEdit;
    eAppAddr: TEdit;
    Label30: TLabel;
    ePS: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    tsDisplay: TTabSheet;
    Image5: TImage;
    cbDisplay: TComboBox;
    Label33: TLabel;
    GroupBox10: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    eChip: TEdit;
    eDAC: TEdit;
    eMem: TEdit;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    eBIOS: TEdit;
    lTechnology: TLabel;
    lMetrics: TLabel;
    lPixWidth: TLabel;
    lPixHeight: TLabel;
    lPixDiag: TLabel;
    bCurve: TButton;
    bLine: TButton;
    bPoly: TButton;
    bRaster: TButton;
    bText: TButton;
    Label37: TLabel;
    tsAPM: TTabSheet;
    GroupBox13: TGroupBox;
    Label38: TLabel;
    Label39: TLabel;
    eAC: TEdit;
    eBat: TEdit;
    Image6: TImage;
    GroupBox14: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    eBatFull: TEdit;
    eBatLife: TEdit;
    tsMedia: TTabSheet;
    Label42: TLabel;
    Panel5: TPanel;
    img: TImageList;
    tsNetwork: TTabSheet;
    Label47: TLabel;
    Panel6: TPanel;
    lvNetwork: TListView;
    GroupBox16: TGroupBox;
    tsDevices: TTabSheet;
    psd: TPrinterSetupDialog;
    tsPrinters: TTabSheet;
    Label48: TLabel;
    Panel7: TPanel;
    lvPrinter: TListView;
    bPrint: TButton;
    tsEngines: TTabSheet;
    GroupBox17: TGroupBox;
    Image7: TImage;
    GroupBox18: TGroupBox;
    Image8: TImage;
    lODBC: TLabel;
    lBDE: TLabel;
    lDirectX: TLabel;
    tsDrives: TTabSheet;
    Label54: TLabel;
    cbDrive: TComboBox;
    GroupBox19: TGroupBox;
    imgDrive: TImage;
    lDriveType: TLabel;
    clbFlags: TCheckListBox;
    Label55: TLabel;
    Label56: TLabel;
    eUNC: TEdit;
    eDSN: TEdit;
    Bevel3: TBevel;
    lCapacity: TLabel;
    lFree: TLabel;
    lBPS: TLabel;
    lSPC: TLabel;
    lTC: TLabel;
    lFC: TLabel;
    Bevel4: TBevel;
    bReport: TButton;
    ReportMenu: TPopupMenu;
    pmAll: TMenuItem;
    pmSelected: TMenuItem;
    sd: TSaveDialog;
    Panel10: TPanel;
    gDisk: TGauge;
    Panel11: TPanel;
    gAPM: TGauge;
    GroupBox20: TGroupBox;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Image9: TImage;
    eWSDesc: TEdit;
    eWSVer: TEdit;
    eWSStat: TEdit;
    bModes: TButton;
    tsTZ: TTabSheet;
    Panel12: TPanel;
    Image10: TImage;
    gbStd: TGroupBox;
    Label12: TLabel;
    Label73: TLabel;
    eStdStart: TEdit;
    eStdBias: TEdit;
    eTZ: TEdit;
    Label74: TLabel;
    gbDay: TGroupBox;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    edayStart: TEdit;
    eDayBias: TEdit;
    gMemory: TGauge;
    Panel13: TPanel;
    Panel14: TPanel;
    lbIP: TListBox;
    lbMAC: TListBox;
    Label64: TLabel;
    Label69: TLabel;
    Panel15: TPanel;
    bProto: TButton;
    bServ: TButton;
    bCli: TButton;
    lFontRes: TLabel;
    Panel8: TPanel;
    Tree: TTreeView;
    FolderList: TListView;
    Panel9: TPanel;
    bProps: TButton;
    pcCPU: TPageControl;
    tsID: TTabSheet;
    tsFeatures: TTabSheet;
    GroupBox5: TGroupBox;
    lModel: TLabel;
    lSerial: TLabel;
    lVendor: TLabel;
    lTrans: TLabel;
    GroupBox21: TGroupBox;
    lL1Data: TLabel;
    lL1Code: TLabel;
    lLevel1: TLabel;
    lLevel2: TLabel;
    GroupBox6: TGroupBox;
    Panel4: TPanel;
    clbCPU: TCheckListBox;
    lCodename: TLabel;
    lDAO: TLabel;
    tsAbout: TTabSheet;
    FooterPanel: TPanel;
    sbMail: TSpeedButton;
    TitlePanel: TPanel;
    imgIcon: TImage;
    Panel16: TPanel;
    Memo: TMemo;
    tsProcs: TTabSheet;
    Panel17: TPanel;
    lvProcs: TListView;
    ProcPanel: TPanel;
    bTerminate: TButton;
    bProcProps: TButton;
    tsStartup: TTabSheet;
    tsSoftware: TTabSheet;
    tcStartup: TTabControl;
    bNTSpec: TButton;
    lvMedia: TListView;
    Panel18: TPanel;
    lvSound: TListView;
    Label14: TLabel;
    Panel19: TPanel;
    lvDirectX: TListView;
    Label13: TLabel;
    Panel20: TPanel;
    lvSW: TListView;
    Panel21: TPanel;
    lvStartup: TListView;
    lTitle: TLabel;
    lVer: TLabel;
    lADO: TLabel;
    Label15: TLabel;
    ePKey: TEdit;
    lCSD: TLabel;
    lDVD: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmRefresh(Sender: TObject);
    procedure cmClose(Sender: TObject);
    procedure cmEnvironment(Sender: TObject);
    procedure cmCaps(Sender: TObject);
    procedure cmPrintSetup(Sender: TObject);
    procedure cbDriveChange(Sender: TObject);
    procedure cmReportClick(Sender: TObject);
    procedure cmReportAll(Sender: TObject);
    procedure cmReportCurrent(Sender: TObject);
    procedure clbClickCheck(Sender: TObject);
    procedure cmModes(Sender: TObject);
    procedure cmProto(Sender: TObject);
    procedure cmServ(Sender: TObject);
    procedure cmCli(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure cmProps(Sender: TObject);
    procedure cmMail(Sender: TObject);
    procedure cmTerminate(Sender: TObject);
    procedure cmProcProps(Sender: TObject);
    procedure tcStartupChange(Sender: TObject);
    procedure cmNTSpec(Sender: TObject);
  private
    FPages: TPages;
    FSysInfo: TMSystemInfo;
    FShowRepBut: Boolean;
    procedure SetPages(const Value: TPages);
    procedure SetShowRepBut(const Value: Boolean);
    procedure SetCaptionText(const Value: string);
  public
    Report :TStringList;

    property DisplayedPages: TPages read FPages write SetPages;
    property SysInfo: TMSystemInfo read FSysInfo write FSysInfo;
    property ShowReportButton: Boolean read FShowRepBut write SetShowRepBut;
    property CaptionText: string Write SetCaptionText;

    procedure GetInfo;

    procedure GetWkstaInfo;
    procedure GetOSInfo;
    procedure GetCPUInfo;
    procedure GetMemoryInfo;
    procedure GetDisplayInfo;
    procedure GetAPMInfo;
    procedure GetMediaInfo;
    procedure GetNetInfo;
    procedure GetDeviceInfo;
    procedure GetEngInfo;
    procedure GetDriveInfo;
    procedure GetTZInfo;
    procedure GetProcInfo;
    procedure GetPrintInfo;
    procedure GetStartupInfo;
    procedure GetSWInfo;
  end;

var
  frmMSI_Overview: TfrmMSI_Overview;

implementation

uses ShellAPI, MiTeC_Routines, MSI_Devices, MSI_DetailDlg, MSI_OS, MSI_APM,
  MSI_Startup;

{$R *.DFM}

const
  cDeviceImageIndex: array[TDeviceClass] of integer =
                      (iiAPM, iiSystem, iiVolumes, iiDisplay, iiCDROM, iiVolumes,
                       iiFDD, iiGPS, iiHID, iiVolumes, iiDriver, iiImaging,
                       iiInfrared, iiKeyboard, iiChanger, iiDriver, iiMouse, iiModem,
                       iiMonitor, iiReader, iiPort, iiAdapter, iiDriver,
                       iiPackage, iiDriver, iiAdapter, iiPort, iiPrinter, iiSCSI,
                       iiReader, iiSound, iiHDD, iiSystem, iiTape, iiUSB);

{ TfrmMSI_Overview }

procedure TfrmMSI_Overview.GetWkstaInfo;
begin
  with SysInfo.Machine do begin
    if Trim(Computer)<>'' then
      tsWkSta.Caption:=' '+Computer+' ';
    eWksta.text:=Name;
    eUser.text:=User;
    eBIOSName.text:=BIOSName;
    eBIOSCopy.text:=BIOSCopyright;
    eBIOSDate.text:=BIOSDate;
    eBIOSExt.text:=BIOSExtendedInfo;
    eLastBoot.text:=datetimetostr(LastBoot);
    eSysTime.text:=formatseconds(SystemUpTime,true,false,false);
    if NumLock then
      pNumLock.color:=clLime
    else
      pNumLock.color:=clSilver;
    if CapsLock then
      pCapsLock.color:=clLime
    else
      pCapsLock.color:=clSilver;
    if ScrollLock then
      pScrollLock.color:=clLime
    else
      pScrollLock.color:=clSilver;
  end;
end;

procedure TfrmMSI_Overview.GetOSInfo;
var
  i: integer;
  s: string;
begin
  with SysInfo.OS do begin
    s:=OSVersion;
    tsOS.caption:=Platform;
    if IsNT then begin
      case NTSpecific.ProductType of
        ptWorkstation: s:=s+' - Workstation';
        ptServer: s:=s+' - Server';
        ptAdvancedServer: s:=s+' - Advanced Server';
      end;
      lCSD.caption:=CSD;
    end;

    lVersion.caption:=s;
    lVerNo.caption:=format('Version: %d.%d.%d',[MajorVersion,MinorVersion,BuildNumber]);

    bNTSpec.Enabled:=Is2K or IsXP;
    if IsOSR2 then
      lCSD.caption:='OSR 2'
    else
      if IsSE then
        lCSD.caption:='Second Edition';
    ePID.text:=ProductID;
    ePKey.text:=ProductKey;
    eRegUser.text:=RegisteredUser;
    eRegOrg.text:=RegisteredOrg;
    lDVD.Caption:='DVD Region: '+DVDRegion;

    FolderList.Items.Clear;
    for i:=0 to Folders.Count-1 do
      if Folders.Values[Folders.Names[i]]<>'' then
        with FolderList.Items.Add do begin
          Caption:=Folders.Names[i];
          SubItems.Add(Folders.Values[Folders.Names[i]]);
        end;
  end;
end;

procedure TfrmMSI_Overview.GetCPUInfo;
var
  sl :TStringList;
  i :Longint;
begin
  with SysInfo.CPU do begin
    lCPU.caption:=format('%d x %s %s - %d MHz',[Count,Trim(Vendor),Trim(VendorID),Frequency]);
    lVendor.Caption:='Vendor: '+VendorEx;
    lSerial.caption:='Serial Number: '+SerialNumber;
    lTrans.Caption:=Format('Transistors: %d',[Transistors]);
    lCodename.Caption:='Code Name: '+Codename;
    lModel.caption:=format('Family %d  Model %d  Stepping %d',[Family,Model,Stepping]);
    sl:=TStringList.Create;
    Features.Report(sl);
    sl.Add(Format('FDIV Bug=%d',[integer(FDIVBug)]));
    clbCPU.items.Clear;
    for i:=1 to sl.count-1 do begin
      clbCPU.items.Add(sl.Names[i]);
      clbCPU.Checked[clbCPU.items.count-1]:=Boolean(StrToInt(sl.Values[sl.Names[i]]));
    end;
    sl.Free;
    lL1Data.Caption:=Format('Level 1 Data Cache: %d Kb',[Cache.L1Data]);
    lL1Code.Caption:=Format('Level 1 Instruction Cache: %d Kb',[Cache.L1Code]);
    lLevel1.Caption:=Format('Level 1 Unified Cache: %d Kb',[Cache.Level1]);
    lLevel2.Caption:=Format('Level 2 Unified Cache: %d Kb',[Cache.Level2]);
  end;
end;

procedure TfrmMSI_Overview.GetMemoryInfo;
begin
  with SysInfo.Memory do begin
    ePT.text:=formatfloat('#,##',PhysicalTotal);
    ePF.text:=formatfloat('#,#0',PhysicalFree);
    eFT.text:=formatfloat('#,##',PageFileTotal);
    eFF.text:=formatfloat('#,#0',PageFileFree);
    eVT.text:=formatfloat('#,##',VirtualTotal);
    eVF.text:=formatfloat('#,#0',VirtualFree);
    gMemory.Progress:=MemoryLoad;
    eAG.text:=formatfloat('#,##',AllocGranularity);
    eAppAddr.text:=format('%s - %s',[inttohex(MinAppAddress,8),inttohex(MaxAppAddress,8)]);
    ePS.text:=formatfloat('#,##',PageSize);
  end;
end;

procedure TfrmMSI_Overview.GetDisplayInfo;
begin
  with SysInfo, Display do begin
    cbDisplay.Items.Add(Adapter);
    cbDisplay.itemindex:=0;
    eChip.text:=Chipset;
    eDAC.text:=DAC;
    eMem.text:=IntToStr(Memory);
    eBIOS.text:=format('%s (%s)',[BIOSVersion,BIOSDate]);
    lTechnology.caption:='Technology: '+Technology;
    lMetrics.caption:=format('Metrics: %d x %d - %d bit',[HorzRes,VertRes,ColorDepth]);
    lPixWidth.caption:=format('Pixel Width: %d',[PixelWidth]);
    lPixHeight.caption:=format('Pixel Height: %d',[PixelHeight]);
    lPixDiag.caption:=format('Pixel Diagonal: %d',[PixelDiagonal]);
    lFontRes.caption:=format('Font Resolution: %d dpi',[FontResolution]);
  end;
end;

procedure TfrmMSI_Overview.GetAPMInfo;
begin
  with SysInfo.APM do begin
    case ACPowerStatus of
      psUnknown: eAC.text:='Unknown';
      psOnline: eAC.text:='Online';
      psOffline: eAC.text:='Offline';
    end;
    case BatteryChargeStatus of
      bsUnknown: eBat.text:='Unknown';
      bsHigh: eBat.text:='High';
      bsLow: eBat.text:='Low';
      bsCritical: eBat.text:='Critical';
      bsCharging: eBat.text:='Charging';
      bsNoBattery: eBat.text:='No Battery';
    end;
    if BatteryLifePercent<=100 then begin
      eBatFull.text:=formatseconds(BatteryLifeFullTime,true,false,false);
      eBatLife.text:=formatseconds(BatteryLifeTime,true,false,false);
      gAPM.Progress:=BatteryLifePercent;
    end else begin
      eBatFull.text:='<info not available>';
      eBatLife.text:='<info not available>';
    end;
  end;
end;

procedure TfrmMSI_Overview.GetMediaInfo;
var
  i :integer;
begin
  with SysInfo.Media do begin
    lvMedia.Items.beginUpdate;
    lvMedia.items.clear;
    for i:=0 to Devices.count-1 do
      with lvMedia.items.add do begin
        caption:=Devices[i];
        if i=GamePortIndex then
          imageindex:=iiGame
        else
          if i=SoundCardIndex then
            imageindex:=iiAdapter
          else
            imageindex:=iiSound;
      end;
    lvMedia.Items.EndUpdate;
    lvSound.Items.beginUpdate;
    lvSound.items.clear;
    for i:=0 to WaveIn.count-1 do
      with lvSound.items.add do begin
        caption:=WaveIn[i];
        SubItems.Add('Wave In');
        ImageIndex:=iiWave;
      end;
    for i:=0 to WaveOut.count-1 do
      with lvSound.items.add do begin
        caption:=WaveOut[i];
        SubItems.Add('Wave Out');
        ImageIndex:=iiWave;
      end;
    for i:=0 to MIDIIn.count-1 do
      with lvSound.items.add do begin
        caption:=MIDIIn[i];
        SubItems.Add('MIDI In');
        ImageIndex:=iiMIDI;
      end;
    for i:=0 to MIDIOut.count-1 do
      with lvSound.items.add do begin
        caption:=MIDIOut[i];
        SubItems.Add('MIDI Out');
        ImageIndex:=iiMIDI;
      end;
    for i:=0 to AUX.count-1 do
      with lvSound.items.add do begin
        caption:=AUX[i];
        SubItems.Add('AUX');
        ImageIndex:=iiAUX;
      end;
    for i:=0 to Mixer.count-1 do
      with lvSound.items.add do begin
        caption:=Mixer[i];
        SubItems.Add('Mixer');
        ImageIndex:=iiMixer;
      end;
  end;
  lvSound.Items.endUpdate;
end;

procedure TfrmMSI_Overview.GetNetInfo;
var
  i :integer;
begin
  with SysInfo.Network do begin
    lvNetwork.items.clear;
    for i:=0 to Adapters.count-1 do
      with lvNetwork.items.add do begin
        caption:=Adapters[i];
        if CardAdapterIndex=i then
          imageindex:=iiAdapter
        else
          imageindex:=iiNet;
      end;
    lbIP.Items.Text:=IPAddresses.Text;
    lbMAC.Items.Text:=MACAddresses.Text;
    eWSDesc.Text:=Winsock.Description;
    eWSVer.Text:=Format('%d.%d',[Winsock.MajorVersion,Winsock.MinorVersion]);
    eWSStat.Text:=Winsock.Status;
  end;
end;

procedure TfrmMSI_Overview.GetDeviceInfo;
var
  i,c: integer;
  r,n: TTreeNode;
  cn,dn: string;
  pi: PInteger;
  ldc: TDeviceClass;
begin
  with SysInfo, Devices, Tree,Items do begin
    c:=DeviceCount-1;
    BeginUpdate;
    while Count>0 do begin
      if Assigned(Items[Count-1].Data) then
        FreeMem(Items[Count-1].Data);
      Delete(Items[Count-1]);
    end;
    r:=Add(nil,GetMachine);
    r.ImageIndex:=0;
    r.SelectedIndex:=r.ImageIndex;
    n:=nil;
    for i:=0 to c do begin
      if Trim(Devices[i].ClassDesc)<>'' then
        cn:=Devices[i].ClassDesc
      else
        cn:=Devices[i].ClassName;
      if not Assigned(n) or (Devices[i].DeviceClass<>ldc) then begin
        ldc:=Devices[i].DeviceClass;
        n:=AddChild(r,cn);
        n.ImageIndex:=cDeviceImageIndex[Devices[i].DeviceClass];
        n.SelectedIndex:=n.ImageIndex;
      end;
      if Trim(Devices[i].FriendlyName)='' then
        dn:=Devices[i].Description
      else
        dn:=Devices[i].FriendlyName;
      with AddChild(n,dn) do begin
        ImageIndex:=n.ImageIndex;
        SelectedIndex:=ImageIndex;
        new(pi);
        pi^:=i;
        Data:=pi;
      end;
      n.AlphaSort;
    end;
    r.AlphaSort;
    r.Expand(False);
    EndUpdate;
  end;
end;

procedure TfrmMSI_Overview.GetEngInfo;
var
  i: integer;
begin
  with SysInfo.Engines do begin
    if ODBC<>'' then
      lODBC.caption:='Open Database Connectivity '+ODBC
    else
      lODBC.caption:='Open Database Connectivity not found';
    if BDE<>'' then
      lBDE.caption:='Borland Database Engine '+BDE
    else
      lBDE.caption:='Borland Database Engine not found';
    if DAO<>'' then
      lDAO.caption:='Microsoft Data Access Objects '+DAO
    else
      lDAO.caption:='Microsoft Data Access Objects not found';
    if ADO<>'' then
      lADO.caption:='Microsoft ActiveX Data Objects '+ADO
    else
      lADO.caption:='Microsoft ActiveX Data Objects not found';
  end;
  with SysInfo.DirectX do begin
    if Version<>'' then begin
      lDirectX.caption:='Installed version: '+Version;
      lvDirectX.Items.beginUpdate;
      lvDirectX.items.clear;
      for i:=0 to Direct3D.count-1 do
        with lvDirectX.items.add do begin
          caption:=Direct3D[i];
          SubItems.Add('Direct3D');
          ImageIndex:=iiDirectX;
        end;
      for i:=0 to DirectMusic.count-1 do
        with lvDirectX.items.add do begin
          caption:=DirectMusic[i];
          SubItems.Add('DirectMusic');
          ImageIndex:=iiDirectX;
        end;
      for i:=0 to DirectPlay.count-1 do
        with lvDirectX.items.add do begin
          caption:=DirectPlay[i];
          SubItems.Add('DirectPlay');
          ImageIndex:=iiDirectX;
        end;
      lvDirectX.Items.endUpdate;
    end else
      lDirectX.caption:='Not installed.';
  end;
end;

procedure TfrmMSI_Overview.GetDriveInfo;
var
  i,j :integer;
  s :string;
begin
  j:=0;
  with SysInfo.Disk do begin
    cbDrive.items.clear;
    for i:=1 to length(AvailableDisks) do begin
      s:=uppercase(copy(AvailableDisks,i,1));
      cbDrive.items.add(s+':');
      if s=uppercase(copy(SysInfo.OS.Folders.Values['Windows'],1,1)) then
        j:=i-1;
    end;
    cbDrive.itemindex:=j;
    cbDriveChange(nil);
  end;
end;

procedure TfrmMSI_Overview.GetInfo;
begin
  screen.cursor:=crhourglass;
  try
    if pgWksta in DisplayedPages then
      GetWkstaInfo;
    if pgOS in DisplayedPages then
      GetOSInfo;
    if pgCPU in DisplayedPages then
      GetCPUInfo;
    if pgMem in DisplayedPages then
      GetMemoryInfo;
    if pgDisplay in DisplayedPages then
      GetDisplayInfo;
    if pgAPM in DisplayedPages then
      GetAPMInfo;
    if pgMedia in DisplayedPages then
      GetMediaInfo;
    if pgNet in DisplayedPages then
      GetNetInfo;
    if pgDev in DisplayedPages then
      GetDeviceInfo;
    if pgEng in DisplayedPages then
      GetEngInfo;
    if pgDisk in DisplayedPages then
      GetDriveInfo;
    if pgTZ in DisplayedPages then
      GetTZInfo;
    if pgProcs in DisplayedPages then
      GetProcInfo;
    if pgPrn in DisplayedPages then
      GetPrintInfo;
    if pgStartup in DisplayedPages then
      GetStartupInfo;
    if pgSoftware in DisplayedPages then
      GetSWInfo;
  finally
    screen.cursor:=crdefault;
  end;
end;

procedure TfrmMSI_Overview.FormCreate(Sender: TObject);
begin
  Report:=TStringList.Create;
  DisplayedPages:=pgAll;
  pc.activepage:=tsWksta;
  pcCPU.ActivePage:=tsID;
  lTitle.Caption:=cCompName;
  lVer.Caption:='Version '+cVersion;
  FooterPanel.Caption:=cCopyright;
end;

procedure TfrmMSI_Overview.cmRefresh(Sender: TObject);
begin
  screen.cursor:=crhourglass;
  try
    SysInfo.Refresh;
    GetInfo;
  finally
    screen.cursor:=crdefault;
  end;
end;

procedure TfrmMSI_Overview.cmClose(Sender: TObject);
begin
  close;
end;

procedure TfrmMSI_Overview.cmEnvironment(Sender: TObject);
var
  i: integer;
begin
  with TdlgMSI_Detail.Create(Self) do begin
    Notebook.pageindex:=3;
    TitlePanel.Caption:='Environment';
    for i:=0 to SysInfo.OS.Environment.Count-1 do
      with lv.Items.Add do begin
        Caption:=SysInfo.OS.Environment.Names[i];
        SubItems.Add(SysInfo.OS.Environment.Values[SysInfo.OS.Environment.Names[i]]);
      end;
    showmodal;
    free;
  end;
end;

procedure TfrmMSI_Overview.cmCaps(Sender: TObject);
var
  i :integer;
  sl :TStringList;
begin
  with TdlgMSI_Detail.Create(self) do begin
    Notebook.pageindex:=1;
    sl:=TStringList.Create;
    case TComponent(sender).tag of
      0: begin
        TitlePanel.Caption:='Curve Capabilities';
        SysInfo.Display.Report_CurveCaps(sl);
      end;
      1: begin
        TitlePanel.Caption:='Line Capabilities';
        SysInfo.Display.Report_LineCaps(sl);
      end;
      2: begin
        TitlePanel.Caption:='Polygonal Capabilities';
        SysInfo.Display.Report_PolygonCaps(sl);
      end;
      3: begin
        TitlePanel.Caption:='Raster Capabilities';
        SysInfo.Display.Report_RasterCaps(sl);
      end;
      4: begin
        TitlePanel.Caption:='Text Capabilities';
        SysInfo.Display.Report_TextCaps(sl);
      end;
    end;
    clb.items.clear;
    for i:=1 to sl.count-1 do begin
      clb.items.Add(sl.Names[i]);
      clb.Checked[clb.items.count-1]:=Boolean(StrToInt(sl.Values[sl.Names[i]]));
    end;
    sl.free;
    showmodal;
    free;
  end;
end;

procedure TfrmMSI_Overview.cmPrintSetup(Sender: TObject);
begin
  psd.execute;
end;


procedure TfrmMSI_Overview.cbDriveChange(Sender: TObject);
var
  p,i :Word;
  b :pchar;
  sl :TStringList;
begin
  with SysInfo.Disk do begin
    gdisk.progress:=0;
    b:=stralloc(255);
    p:=0;
    Drive:=copy(cbDrive.text,1,2);
    strpcopy(b,Drive+'\');
    lDriveType.caption:=GetMediaTypeStr(MediaType)+' - '+FileSystem;
    if MediaPresent then
      imgDrive.picture.icon.handle:=extractassociatedicon(hinstance,b,p)
    else
      imgDrive.picture.icon.handle:=0;
    strdispose(b);
    eUNC.text:=expanduncfilename(Drive);
    eDSN.text:=SerialNumber;
    if pos('[',cbdrive.items[cbdrive.itemindex])=0 then begin
      i:=cbdrive.itemindex;
      cbdrive.items[i]:=cbdrive.items[i]+' ['+VolumeLabel+']';
      cbdrive.itemindex:=i;
    end;
    {$IFDEF D4PLUS}
    lCapacity.caption:=formatfloat('Capacity: #,#0 B',Capacity);
    lFree.caption:=formatfloat('Free space: #,#0 B',FreeSpace);
    try
      gDisk.Progress:=round((Capacity-FreeSpace)/Capacity*100);
    except
    end;
    {$ELSE}
    lCapacity.caption:=formatfloat('Capacity: #,#0 B',Capacity.QuadPart);
    lFree.caption:=formatfloat('Free space: #,#0 B',FreeSpace.QuadPart);
    try
      gDisk.Progress:=round((Capacity.QuadPart-FreeSpace.QuadPart)/Capacity.QuadPart*100);
    except
      gDisk.Progress:=0;
    end;
    {$ENDIF}
    lBPS.caption:=formatfloat('Bytes/sector: 0',BytesPerSector);
    lSPC.caption:=formatfloat('Sector/cluster: 0',SectorsPerCluster);
    lFC.caption:=formatfloat('Free clusters: #,#0',FreeClusters);
    lTC.caption:=formatfloat('Total clusters: #,#0',TotalClusters);
    sl:=TStringList.Create;
    Report_FileFlags(sl);
    clbFlags.items.Clear;
    for i:=1 to sl.count-1 do begin
      clbFlags.items.Add(sl.Names[i]);
      clbFlags.Checked[clbFlags.items.count-1]:=Boolean(StrToInt(sl.Values[sl.Names[i]]));
    end;
    sl.Free;
  end;
end;

procedure TfrmMSI_Overview.cmReportClick(Sender: TObject);
var
  p :tpoint;
begin
  p.y:=twincontrol(sender).top+twincontrol(sender).height;
  p.x:=twincontrol(sender).left;
  p:=twincontrol(sender).parent.clienttoscreen(p);
  ReportMenu.Popup(p.x,p.y);
end;

procedure TfrmMSI_Overview.cmReportAll(Sender: TObject);
begin
  Report.Clear;
  sd.filename:='SystemInfo.txt';
  if sd.execute then begin
    SysInfo.Report(Report);
    Report.savetofile(sd.filename);
  end;
end;

procedure TfrmMSI_Overview.cmReportCurrent(Sender: TObject);
begin
  Report.Clear;
  sd.filename:=Trim(pc.ActivePage.Caption)+'.txt';
  if sd.execute then begin
    case pc.activepage.pageindex of
      0: SysInfo.Machine.Report(Report);
      1: SysInfo.OS.Report(Report);
      2: SysInfo.CPU.Report(Report);
      3: SysInfo.Memory.Report(Report);
      4: SysInfo.Display.Report(Report);
      5: SysInfo.APM.Report(Report);
      6: SysInfo.Media.Report(Report);
      7: SysInfo.Network.Report(Report);
      8: SysInfo.Devices.Report(Report);
      9: SysInfo.Printers.Report(Report);
      10: SysInfo.Engines.Report(Report);
      11: SysInfo.Disk.Report(Report);
      12: SysInfo.OS.TimeZone.Report(Report);
      13: SysInfo.Processes.Report(Report);
      14: SysInfo.Startup.Report(Report);
      15: SysInfo.Software.Report(Report);
    end;
    Report.savetofile(sd.filename);
  end;
end;

procedure TfrmMSI_Overview.clbClickCheck(Sender: TObject);
var
  OCC: TNotifyEvent;
  idx: integer;
  p: TPoint;
begin
  with TCheckListBox(Sender) do begin
    OCC:=OnClickCheck;
    OnClickCheck:=nil;
    GetCursorPos(p);
    p:=ScreenToClient(p);
    idx:=ItemAtPos(p,True);
    if idx>-1 then
      Checked[idx]:=not Checked[idx];
    OnClickCheck:=OCC;
  end;
end;

procedure TfrmMSI_Overview.SetPages(const Value: TPages);
var
  i: integer;
begin
  FPages:=Value;
  for i:=pc.PageCount-1 downto 0 do begin
    pc.Pages[i].TabVisible:=TPage(i) in DisplayedPages;
    if pc.Pages[i].TabVisible then
      pc.ActivePage:=pc.Pages[i];
  end;
end;

procedure TfrmMSI_Overview.SetShowRepBut(const Value: Boolean);
begin
  FShowRepBut:=Value;
  bReport.Visible:=FShowRepBut;
end;

procedure TfrmMSI_Overview.cmModes(Sender: TObject);
var
  i: integer;
begin
  with TdlgMSI_Detail.Create(self) do begin
    Notebook.pageindex:=1;
    clb.items.clear;
    clb.Items.AddStrings(SysInfo.Display.Modes);
    for i:=0 to clb.Items.Count-1 do
      clb.Checked[i]:=True;
    TitlePanel.Caption:='Supported Video Modes';
    showmodal;
    free;
  end;
end;

procedure TfrmMSI_Overview.GetTZInfo;
begin
  with SysInfo.OS.TimeZone do begin
    eTZ.Text:=DisplayName;
    gbStd.Caption:=' '+StandardName+' ';
    gbDay.Caption:=' '+DaylightName+' ';
    eStdStart.Text:=DateTimeToStr(StandardStart);
    eStdBias.Text:=IntToStr(StandardBias);
    eDayStart.Text:=DateTimeToStr(DaylightStart);
    eDayBias.Text:=IntToStr(DaylightBias);
  end;
end;

procedure TfrmMSI_Overview.cmProto(Sender: TObject);
var
  i: integer;
begin
  with TdlgMSI_Detail.Create(self) do begin
    Notebook.pageindex:=1;
    clb.items.clear;
    clb.Items.AddStrings(SysInfo.Network.Protocols);
    for i:=0 to clb.Items.Count-1 do
      clb.Checked[i]:=True;
    TitlePanel.Caption:='Protocols';
    showmodal;
    free;
  end;
end;

procedure TfrmMSI_Overview.cmServ(Sender: TObject);
var
  i: integer;
begin
  with TdlgMSI_Detail.Create(self) do begin
    Notebook.pageindex:=1;
    clb.items.clear;
    clb.Items.AddStrings(SysInfo.Network.Services);
    for i:=0 to clb.Items.Count-1 do
      clb.Checked[i]:=True;
    TitlePanel.Caption:='Services';
    showmodal;
    free;
  end;
end;

procedure TfrmMSI_Overview.cmCli(Sender: TObject);
var
  i: integer;
begin
  with TdlgMSI_Detail.Create(self) do begin
    Notebook.pageindex:=1;
    clb.items.clear;
    clb.Items.AddStrings(SysInfo.Network.Clients);
    for i:=0 to clb.Items.Count-1 do
      clb.Checked[i]:=True;
    TitlePanel.Caption:='Clients';
    showmodal;
    free;
  end;
end;

procedure TfrmMSI_Overview.SetCaptionText(const Value: string);
begin
  Caption:=Value;
end;

procedure TfrmMSI_Overview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfrmMSI_Overview.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  bProps.Enabled:=Assigned(Node) and (Node.Level=2);
end;

procedure TfrmMSI_Overview.cmProps(Sender: TObject);
var
  dr: TDevice;
  i: integer;
begin
  if Assigned(Tree.Selected) and (Tree.Selected.Level=2) then
    with TdlgMSI_Detail.Create(self) do begin
      Notebook.pageindex:=3;
      lv.items.clear;
      i:=PInteger(Tree.Selected.Data)^;
      dr:=SysInfo.Devices.Devices[i];
      with lv.Items.Add do begin
        Caption:='Device Name';
        Subitems.Add(Tree.Selected.Text);
      end;
      with lv.Items.Add do begin
        Caption:='Class Name';
        Subitems.Add(dr.ClassName);
      end;
      with lv.Items.Add do begin
        Caption:='Class Description';
        Subitems.Add(Tree.Selected.Parent.Text);
      end;
      with lv.Items.Add do begin
        Caption:='Class GUID';
        Subitems.Add(dr.GUID);
      end;
      with lv.Items.Add do begin
        Caption:='Manufacturer';
        Subitems.Add(dr.Manufacturer);
      end;
      with lv.Items.Add do begin
        Caption:='Location';
        SubItems.Add(dr.Location);
      end;
      with lv.Items.Add do begin
        Caption:='HardwareID';
        Subitems.Add(dr.HardwareID);
      end;
      with lv.Items.Add do begin
        Caption:='Driver Version';
        SubItems.Add(dr.DriverVersion);
      end;
      with lv.Items.Add do begin
        Caption:='Driver Date';
        SubItems.Add(dr.DriverDate);
      end;
      with lv.Items.Add do begin
        Caption:='Driver Provider';
        SubItems.Add(dr.DriverProvider);
      end;
      with lv.Items.Add do begin
        Caption:='Service Name';
        if dr.ServiceName='' then
          SubItems.Add(dr.Service)
        else
          SubItems.Add(dr.ServiceName);
      end;
      with lv.Items.Add do begin
        Caption:='Service Group';
        SubItems.Add(dr.ServiceGroup);
      end;
      TitlePanel.Caption:='Device Properties';
      showmodal;
      free;
    end;
end;

procedure TfrmMSI_Overview.cmMail(Sender: TObject);
begin
  ShellExecute(handle,'open',
               'mailto:michal.mutl@atlas.cz?subject='+cCompName,
               nil,nil,SW_NORMAL);
end;

procedure TfrmMSI_Overview.GetProcInfo;
var
  i,n :integer;
  pid: DWORD;
begin
  with SysInfo.Processes do begin
    lvProcs.Items.Clear;
    n:=ProcessCount-1;
    for i:=0 to n do
      with lvProcs.Items.Add do begin
        pid:=GetPIDFromProcessName(ProcessNames[i]);
        if IsNT then
          Caption:=Format('%d',[pid])
        else
          Caption:=Format('0x%x',[pid]);
        SubItems.Add(ExtractFilename(ProcessNames[i]));
        SubItems.Add(ExtractFilepath(ProcessNames[i]));
        ImageIndex:=iiProcess;
      end;
    ProcPanel.Caption:=Format('  %d processes',[ProcessCount]);
  end;
end;

procedure TfrmMSI_Overview.cmTerminate(Sender: TObject);
const
  SWARN = 'WARNING: Terminating a process can cause undesired '#13#10+
                    'results including loss of data and system instability. The '#13#10+
                    'process will not be given the chance to save its state or '#13#10+
                    'data before it is terminated. Are you sure you want to '#13#10+
                    'terminate the process?';
  SCannotTerm = 'Cannot terminate this process.';
var
  pid: DWORD;
  ph: THandle;
begin
  if Assigned(lvProcs.Selected) then begin
    if IsNT then
      pid:=StrToInt(lvProcs.Selected.Caption)
    else
      pid:=StrToInt('$'+Copy(lvProcs.Selected.Caption,3,255));
    if (MessageDlg(lvProcs.Selected.SubItems[0]+#13#10#13#10+SWARN,mtWarning,[mbYes,mbNo],0)=mryes) then begin
      ph:=OpenProcess(PROCESS_TERMINATE,False,pid);
      if ph<>0 then begin
        TerminateProcess(ph,0);
        CloseHandle(ph);
        lvProcs.Selected.Delete;
      end else
        MessageDlg(SCannotTerm,mtWarning,[mbOK],0);
    end;
  end;
end;

procedure TfrmMSI_Overview.cmProcProps(Sender: TObject);
begin
  if Assigned(lvProcs.Selected) and FileExists(lvProcs.Selected.SubItems[1]+lvProcs.Selected.SubItems[0]) then
    DisplayPropDialog(Handle,lvProcs.Selected.SubItems[1]+lvProcs.Selected.SubItems[0]);
end;

procedure TfrmMSI_Overview.GetPrintInfo;
var
  i: integer;
begin
  with SysInfo.Printers do begin
    lvPrinter.items.clear;
    for i:=0 to Names.count-1 do
      with lvPrinter.items.add do begin
        caption:=Names[i];
        SubItems.Add(Ports[i]);
        if Pos('\\',Ports[i])>0 then
          ImageIndex:=iiNetPrinter
        else
          ImageIndex:=iiPrinter;
        if i=DefaultIndex then
          ImageIndex:=ImageIndex+1;
      end;
  end;
end;

procedure TfrmMSI_Overview.tcStartupChange(Sender: TObject);
var
  i,n: integer;
begin
  with SysInfo.Startup, lvStartup, Items do begin
    BeginUpdate;
    Clear;
    case tcStartup.TabIndex of
      0: begin
        n:=User_Count-1;
        for i:=0 to n do
          with Add do begin
            Caption:=User_Runs[i];
            SubItems.Add(GetRunCommand(rtUser,i));
            ImageIndex:=iiProcess;
          end;
      end;
      1: begin
        n:=Common_Count-1;
        for i:=0 to n do
          with Add do begin
            Caption:=Common_Runs[i];
            SubItems.Add(GetRunCommand(rtCommon,i));
            ImageIndex:=iiProcess;
          end;
      end;
      2: begin
        n:=HKLM_Count-1;
        for i:=0 to n do
          with Add do begin
            Caption:=HKLM_Runs[i];
            SubItems.Add(GetRunCommand(rtHKLM,i));
            ImageIndex:=iiProcess;
          end;
      end;
      3: begin
        n:=HKCU_Count-1;
        for i:=0 to n do
          with Add do begin
            Caption:=HKCU_Runs[i];
            SubItems.Add(GetRunCommand(rtHKCU,i));
            ImageIndex:=iiProcess;
          end;
      end;
      4: begin
        n:=Once_Count-1;
        for i:=0 to n do
          with Add do begin
            Caption:=Once_Runs[i];
            SubItems.Add(GetRunCommand(rtOnce,i));
            ImageIndex:=iiProcess;
          end;
      end;
      5: begin
        n:=WININI_Count-1;
        for i:=0 to n do
          with Add do begin
            Caption:=WININI_Runs[i];
            SubItems.Add(GetRunCommand(rtWININI,i));
            ImageIndex:=iiProcess;
          end;
      end;
    end;
    EndUpdate;
  end;
end;

procedure TfrmMSI_Overview.GetStartupInfo;
begin
  tcStartupChange(tcStartup);
end;

procedure TfrmMSI_Overview.GetSWInfo;
var
  i: integer;
begin
  with SysInfo.Software, lvSW, Items do begin
    BeginUpdate;
    Clear;
    for i:=0 to Installed.Count-1 do
      with Add do begin
        Caption:=Installed[i];
        ImageIndex:=iiPackage;
      end;
    EndUpdate;
  end;
end;

procedure TfrmMSI_Overview.cmNTSpec(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  with TdlgMSI_Detail.Create(self) do begin
    Notebook.pageindex:=1;
    TitlePanel.Caption:='Installed Suites';
    clb.items.clear;
    sl:=TStringList.Create;
    SysInfo.OS.NTSpecific.Report_InstalledSuites(sl);
    for i:=0 to sl.count-1 do begin
      clb.items.Add(sl.Names[i]);
      clb.Checked[clb.items.count-1]:=Boolean(StrToInt(sl.Values[sl.Names[i]]));
    end;
    sl.Free;
    showmodal;
    free;
  end;
end;

end.
