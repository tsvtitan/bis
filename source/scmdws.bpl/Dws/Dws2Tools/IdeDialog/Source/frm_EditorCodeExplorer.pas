unit frm_EditorCodeExplorer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, ComCtrls, XMLTreeView,
  ImgList,
  dws2Symbols;

type
  TfrmEditorCodeExplorer = class(TForm)
    CodeExplorerTree: TXMLTreeView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure GetFuncSymobols(XMLNode: IXMLNode);
  public
    { Public declarations }
    procedure Refresh;
  end;

var
  frmEditorCodeExplorer: TfrmEditorCodeExplorer;

implementation

uses UEngine, frm_Editor;

{$R *.dfm}



procedure TfrmEditorCodeExplorer.FormCreate(Sender: TObject);
begin
  CodeExplorerTree.XMLDoc := CodeTree;
end;

procedure TfrmEditorCodeExplorer.Refresh;
begin
  GetFuncSymobols(CodeTree.DocumentElement);
  CodeExplorerTree.Refresh;
end;

end.
