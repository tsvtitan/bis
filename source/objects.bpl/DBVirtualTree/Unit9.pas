unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, DB, DBClient, WideStrings, FMTBcd,
  SqlExpr, Provider, StdCtrls, DBCtrls,

  BisDBTree, ComCtrls, Mask;

type
  TForm9 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
    DataSetProvider1: TDataSetProvider;
    Panel2: TPanel;
    LabelRecordCount: TLabel;
    DBNavigator1: TDBNavigator;
    ButtonOpen: TButton;
    ButtonClose: TButton;
    ButtonFirst: TButton;
    ButtonPrior: TButton;
    ButtonNext: TButton;
    ButtonLast: TButton;
    ButtonInsert: TButton;
    ButtonAppend: TButton;
    ButtonDelete: TButton;
    ButtonEdit: TButton;
    ButtonPost: TButton;
    ButtonCancel: TButton;
    ButtonMoveBy: TButton;
    ButtonLocateEdit: TButton;
    ButtonFillup: TButton;
    ButtonGrid: TButton;
    ProgressBar: TProgressBar;
    ButtonBreak: TButton;
    ButtonTree: TButton;
    DBEdit1: TDBEdit;
    CheckBoxDirectScan: TCheckBox;
    procedure ClientDataSet1AfterOpen(DataSet: TDataSet);
    procedure ClientDataSet1AfterDelete(DataSet: TDataSet);
    procedure ClientDataSet1AfterClose(DataSet: TDataSet);
    procedure ClientDataSet1AfterInsert(DataSet: TDataSet);
    procedure ButtonOpenClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonFirstClick(Sender: TObject);
    procedure ButtonPriorClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure ButtonLastClick(Sender: TObject);
    procedure ButtonMoveByClick(Sender: TObject);
    procedure ButtonDisableControlsClick(Sender: TObject);
    procedure ButtonEnableControlsClick(Sender: TObject);
    procedure ButtonInsertClick(Sender: TObject);
    procedure ButtonAppendClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonPostClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonFillupClick(Sender: TObject);
    procedure ButtonGridClick(Sender: TObject);
    procedure ButtonBreakClick(Sender: TObject);
    procedure ButtonLocateEditClick(Sender: TObject);
    procedure ButtonTreeClick(Sender: TObject);
    procedure CheckBoxDirectScanClick(Sender: TObject);
  private
    FTree: TBisDBTree;
    FBreaked: Boolean;
    FBeginTime: TTime;
    procedure TreeProgress(Sender: TBisDBTree; Min,Max,Position: Integer; var Breaked: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RefreshRecordCount;

  end;

var
  Form9: TForm9;

implementation

uses DateUtils;

{$R *.dfm}

{ TForm9 }

constructor TForm9.Create(AOwner: TComponent);
var
  Column: TBisDBTreeColumn;
begin
  inherited Create(AOwner);

  ClientDataSet1.Active:=false;

  FTree:=TBisDBTree.Create(nil);
  FTree.Parent:=Panel1;
  FTree.Align:=alClient;
  FTree.DataSource:=DataSource1;
  FTree.OnProgress:=TreeProgress;
  with FTree.Header do begin

{    Column:=Columns.Add;
    Column.FieldName:='PHONE';
    Column.Text:='PHONE';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='STREET_NAME';
    Column.Text:='STREET_NAME';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='HOUSE';
    Column.Text:='HOUSE';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='FLAT';
    Column.Text:='FLAT';
    Column.Width:=200;}

  {  Column:=Columns.Add;
    Column.FieldName:='ORDER_NUM';
    Column.Text:='ORDER_NUM';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='DATE_HISTORY';
    Column.Text:='DATE_HISTORY';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='ORDER_ID';
    Column.Text:='ORDER_ID';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='PARENT_ID';
    Column.Text:='PARENT_ID';
    Column.Width:=200;  }

    Column:=Columns.Add;
    Column.FieldName:='SMALL_NAME';
    Column.Text:='SMALL_NAME';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='PARENT_SMALL_NAME';
    Column.Text:='PARENT_SMALL_NAME';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='FIRM_ID';
    Column.Text:='FIRM_ID';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='PARENT_ID';
    Column.Text:='PARENT_ID';
    Column.Width:=200;

  {  Column:=Columns.Add;
    Column.FieldName:='MENU_ID';
    Column.Text:='MENU_ID';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='NAME';
    Column.Text:='NAME';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='PARENT_ID';
    Column.Text:='PARENT_ID';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='PARENT_NAME';
    Column.Text:='PARENT_NAME';
    Column.Width:=200;

    Column:=Columns.Add;
    Column.FieldName:='LEVEL';
    Column.Text:='LEVEL';
    Column.Width:=100;

    Column:=Columns.Add;
    Column.FieldName:='PRIORITY';
    Column.Text:='PRIORITY';
    Column.Width:=100;    }

  end;

{  FTree.KeyFieldName:='ORDER_ID';
  FTree.ParentFieldName:='PARENT_ID';
  FTree.GridEmulate:=false; }

  FTree.KeyFieldName:='FIRM_ID';
  FTree.ParentFieldName:='PARENT_ID';
  FTree.GridEmulate:=false;
  FTree.SearchEnabled:=true;

{  FTree.KeyFieldName:='MENU_ID';
  FTree.ParentFieldName:='PARENT_ID';
  FTree.GridEmulate:=false;\}

//  ShowMessage(FTree.KeyFieldName);

end;

destructor TForm9.Destroy;
begin
  FTree.Free;
  inherited Destroy;
end;

procedure TForm9.ButtonAppendClick(Sender: TObject);
begin
  ClientDataSet1.Append;
end;

procedure TForm9.ButtonBreakClick(Sender: TObject);
begin
  FBreaked:=true;
end;

procedure TForm9.ButtonCancelClick(Sender: TObject);
begin
  ClientDataSet1.Cancel;
end;

procedure TForm9.ButtonCloseClick(Sender: TObject);
begin
  ClientDataSet1.Close;
end;

procedure TForm9.ButtonDeleteClick(Sender: TObject);
begin
  ClientDataSet1.Delete;
end;

procedure TForm9.ButtonDisableControlsClick(Sender: TObject);
begin
  ClientDataSet1.DisableControls;
end;

procedure TForm9.ButtonEditClick(Sender: TObject);
begin
  ClientDataSet1.Edit;
end;

procedure TForm9.ButtonEnableControlsClick(Sender: TObject);
begin
  ClientDataSet1.EnableControls;
end;

procedure TForm9.ButtonFillupClick(Sender: TObject);
var
  i: Integer;
begin
  ClientDataSet1.DisableControls;
  try
    for i:=0 to 10 do begin
      ClientDataSet1.insert;
//      ClientDataSet1.FieldByName('OUT_MESSAGE_ID').Value:='1';
//      ClientDataSet1.FieldByName('CREATOR_ID').Value:='1';
//      ClientDataSet1.FieldByName('DATE_CREATE').Value:=Now;
//      ClientDataSet1.FieldByName('TEXT_OUT').Value:=IntToStr(i);
//      ClientDataSet1.FieldByName('TYPE_MESSAGE').Value:=0;
//      ClientDataSet1.FieldByName('CONTACT').Value:='1';
//      ClientDataSet1.FieldByName('PRIORITY').Value:=1;
//      ClientDataSet1.FieldByName('DATE_BEGIN').Value:=Now;
      ClientDataSet1.Post;
    end;
  finally
    ClientDataSet1.EnableControls;
  end;
end;

procedure TForm9.ButtonFirstClick(Sender: TObject);
begin
  ClientDataSet1.First;
end;

procedure TForm9.ButtonInsertClick(Sender: TObject);
begin
  ClientDataSet1.Insert;
end;

procedure TForm9.ButtonLastClick(Sender: TObject);
begin
  ClientDataSet1.Last;
end;

procedure TForm9.ButtonLocateEditClick(Sender: TObject);
var
  S: String;
begin
  if InputQuery('������ ������','������� ������',S) then  begin
    ClientDataSet1.DisableControls;
    try
//      ClientDataSet1.First;
  {    while ClientDataSet1.Locate('TEXT_OUT',S,[loCaseInsensitive]) do begin
        ClientDataSet1.Edit;
        ClientDataSet1.FieldByName('TEXT_OUT').Value:='================= �������� ================';
        ClientDataSet1.Post;
        ClientDataSet1.First;
      end;}
    finally
      ClientDataSet1.EnableControls;
    end;
  end;
end;

procedure TForm9.ButtonMoveByClick(Sender: TObject);
begin
  ClientDataSet1.MoveBy(1);
end;

procedure TForm9.ButtonNextClick(Sender: TObject);
begin
  ClientDataSet1.Next;
end;

procedure TForm9.ButtonOpenClick(Sender: TObject);
begin
  ClientDataSet1.Close;
  
  FTree.Visible:=false;
  FBeginTime:=Time;
  try
    DBEdit1.DataField:='';
    FBreaked:=false;
    ClientDataSet1.Open;
    if ClientDataSet1.Active then
      DBEdit1.DataField:=ClientDataSet1.Fields[0].FieldName;
  finally
    ShowMessage(Format('Time is %d',[MilliSecondsBetween(Time,FBeginTime)]));
    FTree.Visible:=true;
  end;
end;

procedure TForm9.ButtonPostClick(Sender: TObject);
begin
  ClientDataSet1.Post;
end;

procedure TForm9.ButtonPriorClick(Sender: TObject);
begin
  ClientDataSet1.Prior;
end;

procedure TForm9.ButtonTreeClick(Sender: TObject);
begin
  FTree.GridEmulate:=not FTree.GridEmulate;
end;

procedure TForm9.ButtonGridClick(Sender: TObject);
begin
  if not Assigned(DBGrid1.DataSource) then
     DBGrid1.DataSource:=DataSource1
  else
    DBGrid1.DataSource:=nil;
end;

procedure TForm9.CheckBoxDirectScanClick(Sender: TObject);
begin
  FTree.DirectScan:=not FTree.DirectScan;
end;

procedure TForm9.ClientDataSet1AfterClose(DataSet: TDataSet);
begin
  RefreshRecordCount;
end;

procedure TForm9.ClientDataSet1AfterDelete(DataSet: TDataSet);
begin
  RefreshRecordCount;
end;

procedure TForm9.ClientDataSet1AfterInsert(DataSet: TDataSet);
begin
  RefreshRecordCount;
end;

procedure TForm9.ClientDataSet1AfterOpen(DataSet: TDataSet);
begin
  RefreshRecordCount;
end;

procedure TForm9.RefreshRecordCount;
var
  d: Cardinal;
begin
  d:=FTree.TotalCount;
  LabelRecordCount.Caption:=Format('����� �������: %d',[d]);
  LabelRecordCount.Update;
end;

procedure TForm9.TreeProgress(Sender: TBisDBTree; Min,Max,Position: Integer; var Breaked: Boolean);
var
  delta: Integer;
  m: integer;
begin
 { ProgressBar.Min:=Min;
  ProgressBar.Max:=Max;
  ProgressBar.Position:=Position;
  ProgressBar.Update; }
//  if FBreaked then

  Breaked:=FBreaked;

  delta:=Max div 10;
  if delta>0 then begin
    m:=Position mod delta;
    if m=0 then begin
      ProgressBar.Min:=Min;
      ProgressBar.Max:=Max;
      ProgressBar.Position:=Position;
      ProgressBar.Update;
      Application.ProcessMessages;
    end;
  end;





{  if Position=0 then
    FBeginTime:=Time
  else if (Position=Max) then begin
    ShowMessage(Format('Time is %d',[MilliSecondsBetween(Time,FBeginTime)]));
  end;}

end;

end.
