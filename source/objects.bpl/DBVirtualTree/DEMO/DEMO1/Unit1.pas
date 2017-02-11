unit Unit1;

interface

{$I DTDBTree.Inc}

uses
{$IFNDEF TR_DELPHI5}
  Variants,
{$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, DBClient, DB, DBTables, Grids, DBGrids,
  VirtualTrees, DTTableTree, StdCtrls, DTDBTreeView, Mask, DBCtrls, ImgList,
  Menus, ActnPopup, DTADOTree, DTClientTree, kbmMemTable, ADODB;

type
  TDTADOTree=class(DTADOTree.TDTADOTree)
  protected
    procedure CreateCloneDataSet; override;
  end;

  TForm1 = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    DTTableTree1: TDTTableTree;
    Table1ID: TAutoIncField;
    Table1PARENT: TIntegerField;
    Table1NAME: TStringField;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button1: TButton;
    DBGrid1: TDBGrid;
    ImageList1: TImageList;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    PopupActionBar1: TPopupActionBar;
    gtiotuio1: TMenuItem;
    tuio1: TMenuItem;
    tuio2: TMenuItem;
    tuio3: TMenuItem;
    DataSource2: TDataSource;
    kbmMemTable1: TkbmMemTable;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    kbmMemTable1FIRM_ID: TStringField;
    kbmMemTable1FIRM_TYPE_ID: TStringField;
    kbmMemTable1PARENT_ID: TStringField;
    kbmMemTable1SMALL_NAME: TStringField;
    kbmMemTable1FULL_NAME: TStringField;
    kbmMemTable1INN: TStringField;
    kbmMemTable1PAYMENT_ACCOUNT: TStringField;
    kbmMemTable1BANK: TStringField;
    kbmMemTable1BIK: TStringField;
    kbmMemTable1CORR_ACCOUNT: TStringField;
    kbmMemTable1LEGAL_ADDRESS: TStringField;
    kbmMemTable1POST_ADDRESS: TStringField;
    kbmMemTable1PHONE: TStringField;
    kbmMemTable1FAX: TStringField;
    kbmMemTable1EMAIL: TStringField;
    kbmMemTable1SITE: TStringField;
    kbmMemTable1OKONH: TStringField;
    kbmMemTable1OKPO: TStringField;
    kbmMemTable1KPP: TStringField;
    kbmMemTable1DIRECTOR: TStringField;
    kbmMemTable1ACCOUNTANT: TStringField;
    kbmMemTable1CONTACT_FACE: TStringField;
    kbmMemTable1FIRM_TYPE_NAME: TStringField;
    kbmMemTable1PARENT_SMALL_NAME: TStringField;
    kbmThreadDataSet1: TkbmThreadDataSet;
    DTADOTree1: TDTADOTree;
    ADOTable1: TADOTable;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure DTTableTree1BeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses DTCommon, ShellAPI;

{ TDTADOTree }

procedure TDTADOTree.CreateCloneDataSet;
begin
  if DataSource.DataSet is TkbmMemTable then
  begin
    FCloneDataSet := TkbmMemTable.Create(nil);
    TkbmMemTable(FCloneDataSet).CreateTableAs(DataSource.DataSet,[]);
    TkbmMemTable(FCloneDataSet).Open;
  end
  else
    raise Exception.Create(sDatasetIsNotCustomADODataSet);  
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with Table1 do
  begin
    DatabaseName := ExtractFilePath(Application.ExeName);
    TableType := ttParadox;
    TableName := 'TreeTbl';
    Open;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   Table1.Close;
end;

procedure TForm1.Label2Click(Sender: TObject);
var
  Addr: array[0..255] of char;
begin
  ShellExecute(Handle, 'open', StrPCopy(Addr, Label2.Caption), nil, nil, SW_SHOW);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ParentValue: Variant;
begin
  with Table1, DTTableTree1.DBTreeFields do
  begin
    ParentValue := FieldValues[KeyFieldName];
    if ParentValue = NULL then
      ParentValue := ParentOfRootValue;
    Append;
    FieldValues[ParentFieldName] := ParentValue;
    Post;
    Edit;
    FieldValues[ListFieldName] :=
      'Node ' + IntToStr(FieldByName(KeyFieldName).AsInteger);
    Post;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  ParentValue: Variant;
begin
  with Table1, DTTableTree1.DBTreeFields do
  begin
    ParentValue := FieldValues[ParentFieldName];
    Append;
    FieldValues[ParentFieldName] := ParentValue;
    Post;
    Edit;
    FieldValues[ListFieldName] := 'Node ' + IntToStr(FieldByName(KeyFieldName).AsInteger);
    Post;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if DTTableTree1.RecordHasChildren then
    Information('Selected node has children. Can not delete.')
  else
    Table1.Delete;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  DTTableTree1.GoTop;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  DTTableTree1.GoDown;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  DTTableTree1.Next;
end;

procedure TForm1.DTTableTree1BeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
begin
  if Node=Sender.FocusedNode then 
    TargetCanvas.Brush.Color:=clLIme;
end;

end.
