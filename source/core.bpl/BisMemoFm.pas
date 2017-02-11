unit BisMemoFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs,
  BisDialogFm, BisFm, BisSynEdit;

type
  TBisMemoType=(mtDefault,mtSQL);

  TBisMemoForm = class(TBisDialogForm)
    PanelMemo: TPanel;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    OpenTextFileDialog: TOpenTextFileDialog;
    SaveTextFileDialog: TSaveTextFileDialog;
    ButtonFont: TButton;
    FontDialog: TFontDialog;
    ButtonSort: TButton;
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonFontClick(Sender: TObject);
    procedure ButtonSortClick(Sender: TObject);
  private
    FMemo: TBisSynEdit;
    FSqlHighlighter: TBisSynSQLSyn;
    procedure SetCloseOnEscape(const Value: Boolean);
    function GetCloseOnEscape: Boolean;
    function GetMemoType: TBisMemoType;
    procedure SetMemoType(const Value: TBisMemoType);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Memo: TBisSynEdit read FMemo;
    property MemoType: TBisMemoType read GetMemoType write SetMemoType; 

    property CloseOnEscape: Boolean read GetCloseOnEscape write SetCloseOnEscape;
  end;

  TBisMemoFormIface=class(TBisDialogFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMemoForm: TBisMemoForm;

implementation

{$R *.dfm}

{ TBisMemoFormIface }

constructor TBisMemoFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMemoForm;
end;

{ TBisMemoForm }

constructor TBisMemoForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSqlHighlighter:=TBisSynSQLSyn.Create(nil);

  FMemo:=TBisSynEdit.Create(nil);
  FMemo.Parent:=PanelMemo;
  FMemo.Align:=alClient;
  FMemo.OnKeyDown:=MemoKeyDown;

  SizeGrip.Visible:=true;
end;

destructor TBisMemoForm.Destroy;
begin
  FMemo.Free;
  FSqlHighlighter.Free;
  inherited Destroy;
end;

function TBisMemoForm.GetCloseOnEscape: Boolean;
begin
  Result:=ButtonCancel.Cancel;
end;

procedure TBisMemoForm.ButtonFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(FMemo.Font);
  if FontDialog.Execute then
    FMemo.Font.Assign(FontDialog.Font);
end;

procedure TBisMemoForm.ButtonLoadClick(Sender: TObject);
begin
  if OpenTextFileDialog.Execute then
    FMemo.Lines.LoadFromFile(OpenTextFileDialog.FileName);
end;

procedure TBisMemoForm.ButtonSaveClick(Sender: TObject);
begin
  if SaveTextFileDialog.Execute then
    FMemo.Lines.SaveToFile(SaveTextFileDialog.FileName);
end;

procedure TBisMemoForm.ButtonSortClick(Sender: TObject);
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  FMemo.Lines.BeginUpdate;
  try
    Str.Text:=FMemo.Lines.Text;
    Str.Sort;
    FMemo.Lines.Text:=Str.Text;
  finally
    FMemo.Lines.EndUpdate;
    Str.Free;
  end;
end;

procedure TBisMemoForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ButtonCancel.Cancel and (Key=VK_ESCAPE) then
    Close;
end;

procedure TBisMemoForm.SetCloseOnEscape(const Value: Boolean);
begin
  ButtonCancel.Cancel:=Value;
end;

function TBisMemoForm.GetMemoType: TBisMemoType;
begin
  Result:=mtDefault;
  if Assigned(FMemo.Highlighter) then begin
    if FMemo.Highlighter=FSqlHighlighter then Result:=mtSQL;
  end;
end;

procedure TBisMemoForm.SetMemoType(const Value: TBisMemoType);
begin
  case Value of
    mtDefault: FMemo.Highlighter:=nil;
    mtSQL: FMemo.Highlighter:=FSqlHighlighter;
  end;
end;

end.