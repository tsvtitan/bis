{-----------------------------------------------------------}
{----Purpose : Demo of VT Descendants                       }
{    By      : Ir. G.W. van der Vegt                        }
{    For     : Fun                                          }
{    Module  : Unit1.pas                                    }
{    Depends : VT 3.2.1                                     }
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 14052002-Initial version.                                 }
{ 21052002-Added Sorting to VirtualStringTreeData1.         }
{         -Added RTTIGrid1 to Demo.                         }
{-----------------------------------------------------------}
{ nr.    todo                                               }
{ ------ -------------------------------------------------- }
{ 1.     -                                                  }
{                                                           }
{-----------------------------------------------------------}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, VirtualIniTree,
  VirtualStringTreeData, IniFiles, ComCtrls, ExtCtrls, VirtualStringList,
  RttiGrid;

type
  TForm1 = class(TForm)
    Button1: Tbutton;
    Button2: Tbutton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    VirtualIniTree1: TVirtualIniTree;
    VirtualList1: TVirtualList;
    VirtualMemo1: TVirtualMemo;
    VirtualNumberedMemo1: TVirtualNumberedMemo;
    VirtualStringTreeData1: TVirtualStringTreeData;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    TabSheet6: TTabSheet;
    RttiGrid1: TRttiGrid;
    Memo6: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VirtualStringTreeData1HeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure VirtualStringTreeData1CompareNodes(Sender: TBaseVirtualTree;
      Node1, Node2: TVirtualListViewItem; Column: TColumnIndex;
      var Result: Integer);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    fWindir: String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  sections,
  section: TStringList;
  ini: TIniFile;
  aItem,
  aNode: TVirtualListViewItem;
  i,
  j: integer;
begin
  VirtualIniTree1.IniFile := Format('%s\system.ini', [fWindir]);
  VirtualList1.Lines.LoadFromFile(Format('%s\system.ini', [fWindir]));
  VirtualMemo1.Lines.LoadFromFile(Format('%s\system.ini', [fWindir]));
  VirtualNumberedMemo1.Lines.LoadFromFile(Format('%s\system.ini', [fWindir]));
  Button1.Enabled := False;
  Button2.Enabled := true;

  sections := TStringList.Create;
  ini := TIniFile.Create(Format('%s\system.ini', [fWindir]));
  ini.ReadSections(sections);
  for i := 0 to sections.Count-1 do
  begin
    section := TStringList.Create;
    aItem := VirtualStringTreeData1.Data.Add;
    aItem.Caption := '['+sections[i]+']';
    ini.ReadSection(sections[i], section);
    for j := 0 to section.Count-1 do
    begin
      aNode := VirtualStringTreeData1.Data.AddChild(aItem, section[j]);
      aNode.SubItems.Add(ini.ReadString(sections[i], section[j],
                                        'n/a'))
    end;
    //FreeAndNil(aItem);
    //FreeAndNil(aNode);
    FreeAndNil(section)
  end;
  ini.Free;
  sections.Free
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  VirtualIniTree1.IniFile := '';
  VirtualMemo1.Lines.Clear;
  VirtualList1.Lines.Clear;
  VirtualNumberedMemo1.Lines.Clear;
  VirtualStringTreeData1.Clear;
  Button1.Enabled := true;
  Button2.Enabled := False
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  p: PChar;
begin
  p := StrAlloc(MAX_PATH+1);
  GetWindowsDirectory(p, MAX_PATH);
  fWindir := p;
  StrDispose(p);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SetLength(fWindir, 0);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  RttiGrid1.SetObject(Form1);
end;

procedure TForm1.VirtualStringTreeData1HeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if VirtualStringTreeData1.Header.SortColumn<>Column
    then
      begin
        VirtualStringTreeData1.Header.SortDirection:=sdAscending;
        VirtualStringTreeData1.Header.SortColumn:=Column;
      end
    else
      case VirtualStringTreeData1.Header.SortDirection of
        sdAscending : VirtualStringTreeData1.Header.SortDirection:=sdDescending;
        sdDescending : VirtualStringTreeData1.Header.SortDirection:=sdAscending;
      end;
  VirtualStringTreeData1.SortTree(VirtualStringTreeData1.Header.SortColumn,VirtualStringTreeData1.Header.SortDirection);
end;

procedure TForm1.VirtualStringTreeData1CompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: TVirtualListViewItem;
  Column: TColumnIndex; var Result: Integer);
begin
  case column of
    -1,
     0 : Result:=CompareText(Node1.Caption,Node2.Caption);
  else
    begin
      if (Node1.SubItems.Count>=Column) and (Node2.SubItems.Count>=Column)
        then Result:=CompareText(Node1.SubItems[Column-1],Node2.SubItems[Column-1])
        else Result:=0;
    end
  end
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  RttiGrid1.SetObject(nil);
  RttiGrid1.SetObject(Form1);
end;

end.
