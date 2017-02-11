unit Unit12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, ADODB, kbmMemTable, Grids, DBGrids, DTDBTreeView,
  DBCtrls, VirtualDBTreeEx, ImgList, BisDBTree, ComCtrls, StdCtrls, ActnMan,
  ActnColorMaps, ActnList, BisOrders, Provider, DBClient;

type
  TBisDataSet=class(TkbmMemTable)
  end;

  TBisDBTree=class(TDTDBTreeView)
  protected
    procedure CreateCloneDataSet; override;
    procedure DestroyCloneDataSet; override;
  end;

  TBisDBTreeEx=class(BisDBTree.TBisDBTree)
  end;

  TForm12 = class(TForm)
    Panel1: TPanel;
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Panel2: TPanel;
    ImageList1: TImageList;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button1: TButton;
    CheckBox4: TCheckBox;
    ActionList1: TActionList;
    Action1: TAction;
    XPColorMap1: TXPColorMap;
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    Edit1: TEdit;
    Button2: TButton;
    ADOQuery2: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FDataSet: TBisDataSet;
    FTree: TBisDBTree;
    FTreeEx: TBisDBTreeEx;
    procedure TreeExSorting(Sender: TObject; FieldName: String; OrderType: TBisOrderType; var Success: Boolean);
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

uses VirtualTrees;

{ TBisDBTree }

procedure TBisDBTree.CreateCloneDataSet;
var
  DS: TBisDataSet;
begin
    DS:=TBisDataSet.Create(nil);
    DS.CreateTableAs(DataSource.DataSet,[]);
    DS.LoadFromDataSet(DataSource.DataSet,[]);
    FCloneDataSet:=DS;
end;

procedure TBisDBTree.DestroyCloneDataSet;
begin
  Inherited DestroyCloneDataSet;
end;

{ TForm12 }

procedure TForm12.Button1Click(Sender: TObject);
begin
  ADOQuery1.Close;
  ADOQuery1.Open;
  FDataSet.EmptyTable;
  FDataSet.LoadFromDataSet(ADOQuery1,[]);
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
  //DataSource1.DataSet.DisableControls;
  DataSource1.DataSet.Edit;
  DataSource1.DataSet.FieldByName('SMALL_NAME').AsString:=Edit1.Text;
  DataSource1.DataSet.Post;
//  DataSource1.DataSet.EnableControls;
end;

procedure TForm12.CheckBox1Click(Sender: TObject);
begin
  FTreeEx.NavigatorVisible:=CheckBox1.Checked;
end;

procedure TForm12.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
    FTreeEx.DBOptions:=FTreeEx.DBOptions+[dboListView]
  else
    FTreeEx.DBOptions:=FTreeEx.DBOptions-[dboListView];
end;

procedure TForm12.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked then
    FTreeEx.TreeOptions.PaintOptions:=FTreeEx.TreeOptions.PaintOptions+[toShowButtons,toShowRoot]
  else
    FTreeEx.TreeOptions.PaintOptions:=FTreeEx.TreeOptions.PaintOptions-[toShowButtons,toShowRoot];
end;

procedure TForm12.CheckBox4Click(Sender: TObject);
begin
  FTreeEx.NumberVisible:=CheckBox4.Checked;
end;

procedure TForm12.FormCreate(Sender: TObject);
var
  Column: TDTDBVirtualTreeColumn;
  ColumnEx: TBisDBTreeColumn; 
begin

  FTree:=TBisDBTree.Create(Self);
  FTree.Parent:=Panel1;
  FTree.Align:=alClient;
  FTree.Header.Options:=FTree.Header.Options+[hoShowSortGlyphs, hoVisible];
  FTree.UseFilter:=false;
  FTree.TreeOptions.MiscOptions:= [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave,{ toReportMode, }toToggleOnDblClick, toWheelPanning];
  FTree.TreeOptions.PaintOptions:= [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware];
  FTree.TreeOptions.SelectionOptions:= [toExtendedFocus, {toFullRowSelect,{ toMultiSelect, }toRightClickSelect, toCenterScrollIntoView];
  FTree.IncrementalSearch:= isAll;
  FTree.IncrementalSearchStart:= ssLastHit;

  Column:=TDTDBVirtualTreeColumn(FTree.Header.Columns.Add);
  Column.FieldName:='FIRM_ID';
  Column.Text:=Column.FieldName;
  Column.Width:=200;

  Column:=TDTDBVirtualTreeColumn(FTree.Header.Columns.Add);
  Column.FieldName:='PARENT_ID';
  Column.Text:=Column.FieldName;
  Column.Width:=200;

  Column:=TDTDBVirtualTreeColumn(FTree.Header.Columns.Add);
  Column.FieldName:='SMALL_NAME';
  Column.Text:=Column.FieldName;
  Column.Width:=200;

//  FTree.DataSource:=DataSource1;
  FTree.DBTreeFields.KeyFieldName:='FIRM_ID';
  FTree.DBTreeFields.ParentFieldName:='PARENT_ID';
  FTree.DBTreeFields.ListFieldName:='SMALL_NAME';


  FTreeEx:=TBisDBTreeEx.Create(Self);
  FTreeEx.Parent:=Panel2;
  FTreeEx.Align:=alClient;
  FTreeEx.DataSource:=DataSource1;
 // FTreeEx.KeyFieldName:='FIRM_ID';
//  FTreeEx.ParentFieldName:='FIRM_ID';
//  FTreeEx.ParentFieldName:='PARENT_ID';
  FTreeEx.ViewFieldName:='ROLE_NAME';
  FTreeEx.Header.Options:=FTreeEx.Header.Options+[{hoAutoResize,}hoShowSortGlyphs, hoVisible,hoDblClickResize,hoAutoSpring];
  FTreeEx.TreeOptions.AutoOptions:=[toAutoSort];
  FTreeEx.TreeOptions.MiscOptions:= [toFullRepaintOnResize, toInitOnSave, toGridExtensions,{ toReportMode, }toToggleOnDblClick,
                                     toWheelPanning];
  FTreeEx.TreeOptions.PaintOptions:= [{toShowButtons,} toShowDropmark, toShowHorzGridLines, {toShowRoot,} toShowTreeLines,
                                     toShowVertGridLines, toThemeAware]-[toHideSelection];
  FTreeEx.TreeOptions.SelectionOptions:= [toExtendedFocus,{ toFullRowSelect,} toMultiSelect, toRightClickSelect, toCenterScrollIntoView];
  FTreeEx.DBOptions:=FTreeEx.DBOptions+[dboListView];
  FTreeEx.Images:=ImageList1;
  FTreeEx.NormalIndex:=0;
  FTreeEx.OpenIndex:=1;
  FTreeEx.LastIndex:=2;
//  FTreeEx.Header.Style:=hsFlatButtons;
  FTreeEx.Header.Style:=hsThickButtons;
  FTreeEx.Margin:=2;
  FTreeEx.TextMargin:=1; 
//  FTreeEx.OnSorting:=TreeExSorting;

//  FTreeEx.DBOptions:=FTreeEx.DBOptions+[dboListView];

  ColumnEx:=TBisDBTreeColumn(FTreeEx.Header.Columns.Add);
  ColumnEx.FieldName:='ROLE_NAME';
  ColumnEx.Text:=ColumnEx.FieldName;
  ColumnEx.Width:=200;
  ColumnEx.MinWidth:=20;
  ColumnEx.Options:=ColumnEx.Options+[coAutoSpring];
//  ColumnEx.Options:=ColumnEx.Options-[coDraggable,coShowDropMark];

  ColumnEx:=TBisDBTreeColumn(FTreeEx.Header.Columns.Add);
  ColumnEx.FieldName:='USER_NAME';
  ColumnEx.Text:=ColumnEx.FieldName;
  ColumnEx.Width:=200;

{  ColumnEx:=TBisDBTreeColumn(FTreeEx.Header.Columns.Add);
  ColumnEx.FieldName:='FIRM_ID';
  ColumnEx.Text:=ColumnEx.FieldName;
  ColumnEx.Width:=250;
  ColumnEx.Options:=ColumnEx.Options+[coAutoSpring];
  ColumnEx.Alignment:=taRightJustify;}

  FTreeEx.NavigatorVisible:=true;
  FTreeEx.SortEnabled:=true;
  FTreeEx.SearchEnabled:=true;
  FTreeEx.SortColumnVisible:=true;
  FTreeEx.ChessVisible:=false;


  FDataSet:=TBisDataSet.Create(Self);
  FDataSet.CreateTableAs(ADOQuery2,[]);

  FDataSet.Open;
  FDataSet.LoadFromDataSet(ADOQuery2,[]);

  ClientDataSet1.Open;

//  DataSource1.DataSet:=ClientDataSet1;
  DataSource1.DataSet:=FDataSet;

  FDataSet.First;

  CheckBox1.Checked:=FTreeEx.NavigatorVisible;
end;

procedure TForm12.TreeExSorting(Sender: TObject; FieldName: String; OrderType: TBisOrderType; var Success: Boolean);
begin
  Success:=FDataSet.Active;
  if Success then begin
    case OrderType of
      otNone: FDataSet.SortDefault;
      otAsc: FDataSet.SortOn(FieldName,[]);
      otDesc: FDataSet.SortOn(FieldName,[mtcoDescending]);
    end;
  end;
end;

end.
