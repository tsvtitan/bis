unit EventsMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, dws2Comp, dws2Exprs;

type
  TFEvents = class(TForm)
    Script: TDelphiWebScriptII;
    PALeft: TPanel;
    PARight: TPanel;
    MSource: TMemo;
    EDText: TEdit;
    LBTextTitle: TLabel;
    LBItems: TListBox;
    LBTextOutputTitle: TLabel;
    LBListboxOutputTitle: TLabel;
    LBTextOutput: TLabel;
    LBListboxTitle: TLabel;
    LBListboxOutput: TLabel;
    dws2Unit: Tdws2Unit;
    LBDescription: TLabel;
    procedure dws2UnitFunctionsSetTextOutputEval(Info: TProgramInfo);
    procedure dws2UnitFunctionsSetListboxOutputEval(Info: TProgramInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EDTextChange(Sender: TObject);
    procedure LBItemsClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FProg: TProgram;
  public
    { Public-Deklarationen }
  end;

var
  FEvents: TFEvents;

implementation

{$R *.dfm}

procedure TFEvents.FormCreate(Sender: TObject);
begin
  FProg := Script.Compile(MSource.Text);
  FProg.BeginProgram;
end;

procedure TFEvents.FormDestroy(Sender: TObject);
begin
  FProg.EndProgram;
end;

procedure TFEvents.dws2UnitFunctionsSetTextOutputEval(Info: TProgramInfo);
begin
  LBTextOutput.Caption := Info['NewCaption'];
end;

procedure TFEvents.dws2UnitFunctionsSetListboxOutputEval(
  Info: TProgramInfo);
begin
  LBListboxOutput.Caption := Info['NewCaption'];
end;

procedure TFEvents.EDTextChange(Sender: TObject);
begin
  FProg.Info.Func['OnEditChange'].Call([EDText.Text]);
end;

procedure TFEvents.LBItemsClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := LBItems.ItemIndex;
  if idx >= 0 then
    FProg.Info.Func['OnListboxChange'].Call([LBItems.Items[idx]]);
end;

end.
