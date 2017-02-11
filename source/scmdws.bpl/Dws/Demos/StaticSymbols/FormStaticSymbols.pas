unit FormStaticSymbols;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dws2Comp, dws2StringResult, dws2ComConnector,
  dws2GlobalVarsFunctions, dws2VCLGUIFunctions, dws2FileFunctions, Contnrs,
  ExtCtrls, dws2Debugger;

type
  TForm1 = class(TForm)
    DelphiWebScriptII1: TDelphiWebScriptII;
    dws2FileFunctions1: Tdws2FileFunctions;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    dws2GlobalVarsFunctions1: Tdws2GlobalVarsFunctions;
    dws2Unit1: Tdws2Unit;
    dws2ComConnector1: Tdws2ComConnector;
    ButtonCompile: TButton;
    LabelMemory: TLabel;
    ButtonRelease: TButton;
    CheckBoxStatic: TCheckBox;
    dws2Unit2: Tdws2Unit;
    RadioGroupProgramCount: TRadioGroup;
    LabelTime: TLabel;
    LabelProgramCount: TLabel;
    LabelProgramCountValue: TLabel;
    LabelMemoryValue: TLabel;
    LabelTimeValue: TLabel;
    RadioGroupStackChunkSize: TRadioGroup;
    ButtonRun: TButton;
    LabelRunTimeValue: TLabel;
    dws2SimpleDebugger1: Tdws2SimpleDebugger;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonCompileClick(Sender: TObject);
    procedure ButtonReleaseClick(Sender: TObject);
    procedure CheckBoxStaticClick(Sender: TObject);
    procedure ButtonRunClick(Sender: TObject);
    procedure RadioGroupStackChunkSizeClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FCounterFrequency : Int64;
    FProgs : TObjectList;
    FLastCompile : Int64;
    FLastRun : Int64;
    procedure UpdateResourceView;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses dws2Functions, dws2Exprs;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FProgs := TObjectList.Create(True);
  QueryPerformanceFrequency(FCounterFrequency);
  if FCounterFrequency = 0 then
    FCounterFrequency := 1; // To avoid divbyzero's
  UpdateResourceView;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FProgs.Free;
end;

procedure TForm1.ButtonCompileClick(Sender: TObject);
var
  i,c : Integer;
  tStart, tStop: Int64;
begin
  Screen.Cursor := crHourGlass;
  try
    c := StrToInt(RadioGroupProgramCount.Items[RadioGroupProgramCount.ItemIndex]);
    QueryPerformanceCounter(tStart);
    for i := 1 to c do
      FProgs.Add(DelphiWebScriptII1.Compile('var a,b : Integer; a := a + b'));
    QueryPerformanceCounter(tStop);
    FLastCompile := tStop - tStart;
    UpdateResourceView;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.ButtonReleaseClick(Sender: TObject);
begin
  FProgs.Clear;
  UpdateResourceView;
end;

procedure TForm1.UpdateResourceView;
begin
  LabelProgramCountValue.Caption := IntToStr(FProgs.Count);
  LabelMemoryValue.Caption := IntToStr(AllocMemSize);
  LabelTimeValue.Caption := Format('%.3f ms', [1000 * FLastCompile / FCounterFrequency]);
  LabelRunTimeValue.Caption := Format('%.3f ms', [1000 * FLastRun / FCounterFrequency]);
end;

procedure TForm1.CheckBoxStaticClick(Sender: TObject);
var StaticSymbols : Boolean;
begin
  StaticSymbols := CheckBoxStatic.Checked;
  dws2Unit1.StaticSymbols    := StaticSymbols;
  dws2Unit2.StaticSymbols    := StaticSymbols;
  InternalUnit.StaticSymbols := StaticSymbols;
  UpdateResourceView;
end;

procedure TForm1.ButtonRunClick(Sender: TObject);
var
  i : Integer;
  tStart, tStop: Int64;
begin
  QueryPerformanceCounter(tStart);
  for i := 0 to FProgs.Count - 1 do
    TProgram(FProgs[i]).Execute;
  QueryPerformanceCounter(tStop);
  FLastRun := tStop - tStart;
  UpdateResourceView;
end;

procedure TForm1.RadioGroupStackChunkSizeClick(Sender: TObject);
var StackChunkSize : Integer;
begin
  case RadioGroupStackChunkSize.ItemIndex of
    0 : StackChunkSize := 1;
    1 : StackChunkSize := 1024;
  else
    StackChunkSize := 4096;
  end;
  DelphiWebScriptII1.Config.StackChunkSize := StackChunkSize;
end;

end.
