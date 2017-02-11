unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MSystemInfo, MSI_CPUUsage, Gauges, ExtCtrls, Buttons;

type
  TfrmMain = class(TForm)
    MCPUUsage: TMCPUUsage;
    Panel2: TPanel;
    ListBox: TListBox;
    TitlePanel: TPanel;
    sbMail: TSpeedButton;
    Panel3: TPanel;
    Button3: TButton;
    Button5: TButton;
    Panel4: TPanel;
    Button4: TSpeedButton;
    Button2: TSpeedButton;
    Button1: TSpeedButton;
    Label1: TLabel;
    Gauge: TGauge;
    procedure Button1Click(Sender: TObject);
    procedure MCPUUsageInterval(Sender: TObject; Value: Cardinal);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure sbMailClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
  public
    procedure Refresh;
  end;

var
  frmMain: TfrmMain;

implementation

uses ShellAPI, WI, MiTeC_Routines, PL;

{$R *.DFM}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  with TMSystemInfo.Create(Self) do
    ShowOverview;
end;

procedure TfrmMain.MCPUUsageInterval(Sender: TObject; Value: Cardinal);
begin
  Gauge.Progress:=Value;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  try
    frmWI.Show;
  except
    frmWI:=TfrmWI.Create(Self);
    with frmWI do begin
      GetWinList;
      Show;
    end;
  end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.sbMailClick(Sender: TObject);
begin
  ShellExecute(handle,'open','mailto:michal.mutl@atlas.cz',nil,nil,SW_NORMAL);
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  try
    frmPerfLib.Show;
  except
    frmPerfLib:=TfrmPerfLib.Create(Self);
    with frmPerfLib do begin
      Refresh;
      Show;
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmMain.Refresh;
begin
  TitlePanel.Caption:='          '+cCopyright;
  with TMSystemInfo.Create(Self) do
    try
      Screen.Cursor:=crHourGlass;
      Caption:=cCompName+' '+cVersion;
      ListBox.Items.Clear;
      Refresh;
      ListBox.Items.Add(Format('Machine: %s (User: %s)',[Machine.Name, Machine.User]));
      ListBox.Items.Add(Format('System Up Time: %s',[formatseconds(Machine.SystemUpTime,true,false,False)]));
      ListBox.Items.Add(Format('CPU: %s %s - %d Mhz',[CPU.Vendor,
                                                      CPU.VendorID,
                                                      CPU.Frequency]));
      ListBox.Items.Add(Format('Memory: %d MB (%d KB free)',[Memory.PhysicalTotal div 1024 div 1024,Memory.PhysicalFree div 1024]));
      ListBox.Items.Add(Format('OS: %s [%d.%d.%d]',[OSVersion,
                                                     OS.MajorVersion,
                                                     OS.MinorVersion,
                                                     OS.BuildNumber]));
      ListBox.Items.Add(Format('Video: %s (%d x %d - %d bit)',[Display.Adapter,
                                                             Display.HorzRes,
                                                             Display.VertRes,
                                                             Display.ColorDepth]));
      if Media.Devices.Count>0 then begin
        if Media.SoundCardIndex>-1 then
          ListBox.Items.Add(Format('Sound: %s',[Media.Devices[Media.SoundCardIndex]]))
        else
          ListBox.Items.Add(Format('Sound: %s',[Media.Devices[0]]));
      end;
      if Network.Adapters.Count>0 then begin
        if Network.CardAdapterIndex>-1 then
          ListBox.Items.Add(Format('Network: %s',
                            [Network.Adapters[Network.CardAdapterIndex]]))
        else
          ListBox.Items.Add(Format('Network: %s',
                            [Network.Adapters[0]]));
      end;

      ListBox.Items.Add(Format('IP Address: %s',[Network.IPAddresses[0]]));
      ListBox.Items.Add(Format('MAC Address: %s',[Network.MACAddresses[0]]));
      if Printers.Names.Count>0 then
        ListBox.Items.Add(Format('Printer: %s on %s',[Printers.Names[Printers.DefaultIndex],
                                                      Printers.Ports[Printers.DefaultIndex]]));
    finally
      Free;
      Screen.Cursor:=crDefault;
    end;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  Refresh;
end;

end.
