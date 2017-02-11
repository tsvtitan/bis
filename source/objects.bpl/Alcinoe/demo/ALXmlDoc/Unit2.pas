unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses ALXmlDoc;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  Xml: TALXMLDocument;
begin
    Xml:=TALXMLDocument.Create(nil);
    try
      xml.Options:=xml.Options+[doNodeAutoIndent];
      xml.LoadFromFile('c:\11.xml');
      xml.SaveToFile('c:\2.xml');
    finally
      Xml.Free;
    end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  Xml: TALXMLDocument;
  Node, Nd: TALXMLNode;
begin
    Xml:=TALXMLDocument.Create(nil);
    try
      xml.Options:=xml.Options+[doNodeAutoIndent];
      xml.LoadFromXML('<?xml version="1.0" encoding="windows-1251" standalone="yes"?>');
      Node:=xml.AddChild('data');
      Node:=Node.AddChild('test1');
      Node:=Node.AddChild('test2');
      Node:=Node.AddChild('test3');
      Nd:=Node.AddChild('rnd');
      if Assigned(Nd) then begin
        Nd.NodeValue:='dfgdgdfg';
        Node.AddChild('rnd2').NodeValue:='ffffffff';
        Node.AddChild('rnd3').NodeValue:='vvvvvvvvv';
        Node.AddChild('rnd4').NodeValue:='bbbbbbbbb';
      end;

      xml.SaveToFile('c:\22.xml');
    finally
      Xml.Free;
    end;
end;

procedure TForm2.Button3Click(Sender: TObject);

  function GetList(Stream: TMemoryStream): String;
  var
    Xml: TALXMLDocument;
    List, Node, Nd: TALXMLNode;
  begin
    Result:='';
    Xml:=TALXMLDocument.Create(nil);
    try
      xml.Active:=true;
      xml.Options:=xml.Options+[doNodeAutoIndent];
      List:=xml.AddChild('list');
      List.AddChild('1').NodeValue:=11111111;
      List.AddChild('2').NodeValue:=22222222;
      List.AddChild('2').NodeValue:=33333333;
      Result:=List.XML;
      List.SaveToStream(Stream,false);
    finally
      Xml.Free;
    end;
  end;

  function SetList(Stream: TMemoryStream): String;
  var
    Xml: TALXMLDocument;
    List, Node, Nd: TALXMLNode;
    i: Integer;
  begin
    Result:='';
    Xml:=TALXMLDocument.Create(nil);
    try
      xml.LoadFromStream(Stream);
      List:=Xml.ChildNodes.FindNode('list');


      Result:=List.XML;
      List.SaveToStream(Stream,false);
    finally
      Xml.Free;
    end;
  end;

var
  Xml: TALXMLDocument;
  Stream: TMemoryStream;
  Data, Node, Nd: TALXMLNode;
  S: String;
begin
    Xml:=TALXMLDocument.Create(nil);
    Stream:=TMemoryStream.Create;
    try
      xml.Active:=true;
      xml.Options:=xml.Options+[doNodeAutoIndent];
      xml.Encoding:='windows-1251';
      xml.StandAlone:='yes';
      xml.Version:='1.0';
   //   xml.LoadFromXML('<?xml version="1.0" encoding="windows-1251" standalone="yes"?>');
      Node:=xml.AddChild('data');
      Data:=Node;
      Node:=Node.AddChild('test1');
      Node:=Node.AddChild('test2');
      Node:=Node.AddChild('test3');
      Nd:=Node.AddChild('rnd');
      if Assigned(Nd) then begin
        Nd.NodeValue:='qqqqqqqq';
        Node.AddChild('rnd2').NodeValue:='ffffffff';
        Node.AddChild('rnd3').NodeValue:='vvvvvvvvv';
        Node.AddChild('rnd4').NodeValue:='bbbbbbbbb';
        ShowMessage(GetList(Stream));
        Stream.Position:=0;
        Node:=Node.AddChild('list');
        Node.LoadFromStream(Stream,false);
        Stream.Clear;
        Node.SaveToStream(Stream);
        SetLength(S,Stream.Size);
        Stream.Position:=0;
        Stream.Read(Pointer(S)^,Length(S));
        ShowMessage(S);
        Stream.Position:=0;
        ShowMessage(SetList(Stream));
      end;
//      xml.SaveToFile('c:\33.xml');
//      S:=Xml.XML.Text;
      S:='';
      Xml.SaveToXML(S);
      ShowMessage(S);
    finally
      Stream.Free;
      Xml.Free;
    end;
end;

end.