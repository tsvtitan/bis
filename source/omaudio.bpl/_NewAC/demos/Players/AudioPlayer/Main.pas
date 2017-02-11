(*
  NewAC Audio Player demo
  Written by Andrei Borovsky, anb@symmetrica.net
*)

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ACS_Classes, ACS_Wave, StdCtrls, ComCtrls, ACS_Vorbis,
  ACS_FLAC, ACS_smpeg, ExtCtrls, ACS_DXAudio, ACS_WinMedia;

type
  TForm1 = class(TForm)
    PlayButton: TButton;
    ProgressBar1: TProgressBar;
    VorbisIn1: TVorbisIn;
    StopButton: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    WaveIn1: TWaveIn;
    StatusBar1: TStatusBar;
    FLACIn1: TFLACIn;
    AddtoPLButton: TButton;
    ListBox1: TListBox;
    MP3In1: TMP3In;
    SkipButton: TButton;
    Panel1: TPanel;
    ForwardButton: TButton;
    BackwardButton: TButton;
    DXAudioOut1: TDXAudioOut;
    procedure PlayButtonClick(Sender: TObject);
    procedure AudioOut1Done(Sender: TComponent);
    procedure AudioOut1Progress(Sender: TComponent);
    procedure StopButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddtoPLButtonClick(Sender: TObject);
    procedure AudioOut1ThreadException(Sender: TComponent;
      const Msg: String);
    procedure ListBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SkipButtonClick(Sender: TObject);
    procedure ForwardButtonClick(Sender: TObject);
    procedure BackwardButtonClick(Sender: TObject);
  private
    { Private declarations }
    PlayingIndex : Integer;
    StopPlaying : Boolean;
    function GetSelectedItem : Integer;
    procedure PlayItem;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.PlayButtonClick(Sender: TObject);
var
  SelInd : Integer;
begin
  SelInd := GetSelectedItem;
  if (SelInd < 0) and (ListBox1.Count > 0) then
    SelInd := 0;
  if SelInd >= 0 then
  begin
    StopPlaying := False;
    PlayingIndex := SelInd;
    PlayItem;
  end;
end;

procedure TForm1.AudioOut1Done(Sender: TComponent);
begin
  PlayButton.Enabled := True;
  StatusBar1.Panels[0].Text := '';
  ProgressBar1.Position := 0;
  if StopPlaying then
    Exit;
  Inc(PlayingIndex);
  if PlayingIndex < ListBox1.Items.Count then
    PlayItem;
end;

procedure TForm1.AudioOut1Progress(Sender: TComponent);
begin
  ProgressBar1.Position :=  Self.DXAudioOut1.Progress;
end;

procedure TForm1.StopButtonClick(Sender: TObject);
begin
  StopPlaying := True;
  DXAudioOut1.Stop;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // AudioOut1.Delay := 10;
end;

procedure TForm1.AddtoPLButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    ListBox1.Items.Add(OpenDialog1.FileName);
end;

function TForm1.GetSelectedItem;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to ListBox1.Items.Count - 1 do
  begin
    if ListBox1.Selected[i] then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

procedure TForm1.PlayItem;
var
  FileName : String;
  Min, Sec : Integer;
  Fmt : String;
  FI : TAuFileIn;
  Ext : String;
begin
  DXAudioOut1.Stop(False);
  FileName := ListBox1.Items[PlayingIndex];
  Ext := SysUtils.ExtractFileExt(FileName);
  Ext := AnsiLowerCase(Ext);
  FI := nil;
  if Ext = '.mp3' then FI := MP3In1;
  if Ext = '.ogg' then FI := VorbisIn1;
  if Ext = '.wav' then FI := WaveIn1;
  if Ext = '.flac' then FI := FLACIn1;
  if FI = nil then
  begin
    StatusBar1.Panels[0].Text := 'Unknown file extension';
    Exit;
  end;
  FI.FileName := FileName;
  if not FI.Valid then Exit;
  StatusBar1.Panels[0].Text := 'Playing: ' + ExtractFileName(FileName);
  FI.Loop := CheckBox1.Checked;
  DXAudioOut1.Input := FI;
  PlayButton.Enabled := False;
  DXAudioOut1.Run;
  Sec := FI.TotalTime;
  Min := Sec div 60;
  Sec := Sec - Min*60;
  if Sec < 10 then Fmt := '%d:0%d'
  else Fmt := '%d:%d';
  Label2.Caption := Format(Fmt, [Min, Sec]);
end;


procedure TForm1.AudioOut1ThreadException(Sender: TComponent;
  const Msg: String);
begin
  StatusBar1.Panels[0].Text := Msg;
  PlayButton.Enabled := True;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  SelInd : Integer;
begin
  SelInd := GetSelectedItem;
  if SelInd >= 0 then
  begin
    PlayingIndex := SelInd;
    PlayItem;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DXAudioOut1.Stop(False);
end;

procedure TForm1.SkipButtonClick(Sender: TObject);
begin
  DXAudioOut1.Stop;
end;

procedure TForm1.ForwardButtonClick(Sender: TObject);
begin
  TAuFileIn(DXAudioOut1.Input).Jump(10);
end;

procedure TForm1.BackwardButtonClick(Sender: TObject);
begin
  TAuFileIn(DXAudioOut1.Input).Jump(-10);
end;

end.
