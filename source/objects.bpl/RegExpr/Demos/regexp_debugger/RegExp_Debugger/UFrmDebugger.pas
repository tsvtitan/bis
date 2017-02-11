{$I Directives.inc}
unit UFrmDebugger;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils, RegExpr
  {$IFDEF EnableXPMan}, XPMan{$ENDIF};

type
  TRichEdit = class(ComCtrls.TRichEdit)
  published
    property OnDblClick;
  end;

  TFrmDebugger = class(TForm)
    gbExpression: TGroupBox;
    EdtExpr: TLabeledEdit;
    BtnValider: TButton;
    EdtModifiers: TLabeledEdit;
    LblErrorPos: TLabel;
    LblError: TLabel;
    gbText: TGroupBox;
    REdit: TRichEdit;
    OD: TOpenDialog;
    Splitter: TSplitter;
    MatchTree: TTreeView;
    SB: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnValiderClick(Sender: TObject);
  private
    FExpr: TRegExpr;
    procedure LoadFile(Sender: TObject);
  end;

var
  FrmDebugger: TFrmDebugger;

implementation

{$R *.dfm}

procedure TFrmDebugger.FormCreate(Sender: TObject);
begin
  FExpr := TRegExpr.Create;
  REdit.OnDblClick := LoadFile;
end;

procedure TFrmDebugger.FormDestroy(Sender: TObject);
begin
  FExpr.Free;
end;

procedure TFrmDebugger.LoadFile(Sender: TObject);
var
  SL: TStringList;
begin
  {>> Utilisation d'un TStringList temporaire pour empècher l'interprétation
  des fichiers par le RichEdit (affichage text brut) }
  if OD.Execute then
  begin
    SL := TStringList.Create;
    try
      SL.LoadFromFile(OD.FileName);
      REdit.Lines.Text := Sl.Text;
    finally
      SL.Free;
    end;
  end;
end;

procedure TFrmDebugger.BtnValiderClick(Sender: TObject);
var
  I, Nbre: Integer;
  ParentNode: TTreeNode;
begin
  try
    {>> Initialisation }
    LblError.Caption := '';
    LblErrorPos.Caption := '';
    MatchTree.Items.Clear;
    REdit.SelectAll;
    REdit.SelAttributes.Color := REdit.Font.Color;
    REdit.SelLength := 0;
    FExpr.Expression := EdtExpr.Text;
    FExpr.ModifierStr := EdtModifiers.Text;

    {>> Tente de compiler (génère une exception si l'expression est
    syntaxiquement incorrecte) }
    FExpr.Compile;

    {>> Analyse le texte :
    - Remplit le TreeView avec les Matches + SubMatches
    - Met en rouge les Matches dans le RichEdit }
    Nbre := 0;
    if FExpr.Exec(REdit.Text) then
    repeat
      { Rouge }
      REdit.SelStart := FExpr.MatchPos[0] - 1;
      REdit.SelLength := FExpr.MatchLen[0];
      REdit.SelAttributes.Color := clRed;

      { TreeView }
      ParentNode := MatchTree.Items.AddChild(nil, FExpr.Match[0]);
      for I := 1 to FExpr.SubExprMatchCount do
        MatchTree.Items.AddChild(ParentNode, FExpr.Match[I]);

      Inc(Nbre)
    until not FExpr.ExecNext;

    REdit.SelLength := 0;
    MatchTree.FullExpand;

    {>> Affichage du nombre de matches }
    if Nbre in [0..1] then
      SB.SimpleText := Format('%d expression found', [Nbre])
    else
      SB.SimpleText := Format('%d expressions founded', [Nbre]);

  except
    {>> Gère les fautes de syntaxe: affichage du message d'erreur et
    de la position défaillante }
    on E: ERegExpr do
    begin
      LblError.Caption := E.Message;
      LblErrorPos.Caption := DupeString(' ', E.CompilerErrorPos - 1) + '^';
    end;
    on E: Exception do raise;
  end;
end;

end.
