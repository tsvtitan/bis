unit XMLTreeTestFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, VirtualTrees, XMLTree, MSXML_TLB, ImgList;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ImagesTree: TImageList;
    Button2: TButton;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    XMLTree1: TXMLTree;
    CheckBox5: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure XMLTree1CheckNode(Sender: TXMLTree; Node: PVirtualNode;
      var XmlNode: IXMLDOMNode; var NodeType: Integer; var Add: Boolean);
    procedure XMLTree1GetBackColor(Sender: TXMLTree; Node: PVirtualNode;
      XmlNode: IXMLDOMNode; NodeType: Integer; var BackColor: TColor);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure XMLTree1Edited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure XMLTree1FocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  XmlTree1.UseTextNodes := CheckBox1.Checked;
  if CheckBox5.Checked and Assigned(XmlTree1.FocusedNode) then
    XmlTree1.NodeXml[XmlTree1.FocusedNode] := Memo1.Text
  else
    XMLTree1.Xml := Memo1.Text;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  XMLTree1.FullExpand;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  with XMLTree1 do
    if GridMode = gmBands then GridMode := gmNormal
    else GridMode := gmBands;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  with XMLTree1.Header, Columns[MainColumn] do
    if BiDiMode = bdLeftToRight then BiDiMode := bdRightToLeft
    else BiDiMode := bdLeftToRight;
end;

procedure TForm1.XMLTree1CheckNode(Sender: TXMLTree; Node: PVirtualNode;
  var XmlNode: IXMLDOMNode; var NodeType: Integer; var Add: Boolean);
begin
  if CheckBox2.Checked and (NodeType = ntComment) then Add := False
  else if CheckBox1.Checked then Add := True;

  if Add and (NodeType = ntNode) and (XmlNode.nodeName = 'hidetest') then
    with XmlNode.selectNodes('*') do
      if length = 1 then begin
        XmlNode := item[0];
        NodeType := 8;
      end;

  if Add and (NodeType = ntElement) and (XmlNode.nodeName = 'linktest')
    and (Sender.GetNodeLevel(Node) < 20) then begin
    try
      XmlNode := XmlNode.selectSingleNode(XmlNode.text);
    except
      XmlNode := nil;
    end;
    NodeType := -1;
  end;
end;

procedure TForm1.XMLTree1GetBackColor(Sender: TXMLTree; Node: PVirtualNode;
  XmlNode: IXMLDOMNode; NodeType: Integer; var BackColor: TColor);
begin
  case NodeType of
    8: BackColor := $EEFFFF;
    //6: BackColor:= clAqua;
    //1: BackColor:= clPurple;
  end;
end;

procedure TForm1.XMLTree1Edited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  Memo1.Text := XMLTree1.Xml;
end;

procedure TForm1.XMLTree1FocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if CheckBox5.Checked and Assigned(Node) then
    Memo1.Text := XmlTree1.NodeXml[Node];
end;

end.

