unit BisSecureTableEditFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ExtCtrls, DB, DBGrids, ClipBrd, Buttons,
  Grids, Menus,
  BisDataSet, BisControls;

type

  TBisSecureTableEditFrame = class(TFrame)
    PanelTop: TPanel;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonCreate: TButton;
    PanelGrid: TPanel;
    Splitter: TSplitter;
    PanelBottom: TPanel;
    GroupBoxValue: TGroupBox;
    PanelValue: TPanel;
    PanelValueButton: TPanel;
    DataSource: TDataSource;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ButtonClear: TButton;
    DBNavigator: TDBNavigator;
    LabelTableName: TLabel;
    EditTableName: TEdit;
    ButtonLoadValue: TButton;
    ButtonSaveValue: TButton;
    btUpColumns: TBitBtn;
    btDownColumns: TBitBtn;
    PanelMemo: TPanel;
    DBMemoValue: TDBMemo;
    LabelFilter: TLabel;
    EditFilter: TEdit;
    ButtonApply: TButton;
    DBGrid: TDBGrid;
    LabelCount: TLabel;
    ButtonClearValue: TButton;
    ButtonEditorValue: TButton;
    PopupMenuEditor: TPopupMenu;
    MenuItemEditorTable: TMenuItem;
    N1: TMenuItem;
    procedure ButtonCreateClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonGenClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonLoadValueClick(Sender: TObject);
    procedure ButtonSaveValueClick(Sender: TObject);
    procedure btUpColumnsClick(Sender: TObject);
    procedure btDownColumnsClick(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure DBGridColEnter(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ButtonClearValueClick(Sender: TObject);
    procedure MenuItemEditorTableClick(Sender: TObject);
    procedure ButtonEditorValueClick(Sender: TObject);
  private
    FDataSet: TBisDataSet;
    FFileName: String;
    procedure DataSetAfterInsert(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshCount;
    procedure SetColumnsColor;

    property DataSet: TBisDataSet read FDataSet;
    property FileName: String read FFileName write FFileName;
  end;

implementation

{$R *.dfm}

uses BisConsts, BisUtils, BisDialogs,
     BisDBTableEditFm, BisSecureTableEditFm;

{ TBisSecureTableEditFrame }

constructor TBisSecureTableEditFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSet:=TBisDataSet.Create(Self);
  FDataSet.AfterInsert:=DataSetAfterInsert;
  FDataSet.AfterDelete:=DataSetAfterInsert;
  FDataSet.AfterCancel:=DataSetAfterInsert;
  FDataSet.AfterPost:=DataSetAfterInsert;

  DataSource.DataSet:=FDataSet;
end;

procedure TBisSecureTableEditFrame.DataSetAfterInsert(DataSet: TDataSet);
begin
  RefreshCount;
end;

procedure TBisSecureTableEditFrame.DBGridCellClick(Column: TColumn);
begin
  if Assigned(DBGrid.SelectedField) then begin
    DBMemoValue.DataField:=Column.FieldName;
    DBMemoValue.LoadMemo;
  end else DBMemoValue.DataField:='';
end;

procedure TBisSecureTableEditFrame.DBGridColEnter(Sender: TObject);
begin
  if Assigned(DBGrid.SelectedField) then begin
    DBMemoValue.DataField:=DBGrid.SelectedField.FieldName;
    DBMemoValue.LoadMemo;
  end else DBMemoValue.DataField:='';
end;

procedure TBisSecureTableEditFrame.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  OldBrush: TBrush;
  AGrid: TDbGrid;
begin
  AGrid:=TDbGrid(Sender);
  if not (gdFocused in State) and (gdSelected in State) then begin
    OldBrush:=TBrush.Create;
    OldBrush.Assign(AGrid.Canvas.Brush);
    try
      AGrid.Canvas.Brush.Color:=clGray;
      AGrid.Canvas.FillRect(Rect);
      AGrid.Canvas.Font.Color:=clHighlightText;
      AGrid.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
    finally
      AGrid.Canvas.Brush.Assign(OldBrush);
      OldBrush.Free;
    end;
  end else
    AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TBisSecureTableEditFrame.ButtonCreateClick(Sender: TObject);
var
  Form: TBisDBTableEditForm;
begin
  Form:=TBisDBTableEditForm.Create(FDataSet);
  DBMemoValue.DataField:='';
  try
    if Form.ShowModal=mrOk then begin
      if ShowQuestion('��������� � ����?')=mrYes then begin
        if SaveDialog.Execute then begin
          if FDataSet.Active then begin
            FDataSet.SaveToFile(SaveDialog.FileName);
          end;
        end;
      end;
      RefreshCount;
      SetColumnsColor;
    end;
  finally
    DBMemoValue.DataField:=FDataSet.Fields[0].FieldName;
    Form.Free;
  end;
end;

procedure TBisSecureTableEditFrame.ButtonLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    DBMemoValue.DataField:='';
    FDataSet.LoadFromFile(OpenDialog.FileName);
    EditTableName.Text:=FDataSet.TableName;
    DBMemoValue.DataField:=FDataSet.Fields[0].FieldName;
    RefreshCount;
    SetColumnsColor;
  end;
end;

procedure TBisSecureTableEditFrame.ButtonSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    if FDataSet.Active then begin
      FDataSet.TableName:=EditTableName.Text;
      FDataSet.SaveToFile(SaveDialog.FileName);
    end;
  end;
end;

procedure TBisSecureTableEditFrame.ButtonGenClick(Sender: TObject);
var
  S: String;
begin
  S:=GetUniqueID;
  Clipboard.AsText:=S;
  if ShowQuestion(Format('�������� �������� �� %s?',[S]))=mrYes then
    if FDataSet.Active and (Trim(DBMemoValue.DataField)<>'') then begin
      FDataSet.Edit;
      FDataSet.FieldByName(DBMemoValue.DataField).Value:=S;
      FDataSet.Post;
    end;
end;

procedure TBisSecureTableEditFrame.ButtonClearClick(Sender: TObject);
begin
  EditTableName.Text:='';
  FDataSet.EmptyTable;
  FDataSet.Close;
  FDataSet.FieldDefs.Clear;
  RefreshCount;
  SetColumnsColor;
end;

procedure TBisSecureTableEditFrame.ButtonClearValueClick(Sender: TObject);
begin
  if FDataSet.Active and (Trim(DBMemoValue.DataField)<>'')then begin
    FDataSet.Edit;
    FDataSet.FieldByName(DBMemoValue.DataField).Value:=Null;
    FDataSet.Post;
  end;
end;

procedure TBisSecureTableEditFrame.ButtonLoadValueClick(Sender: TObject);
var
  Stream: TFileStream;
  AValue: String;
begin
  if FDataSet.Active and (Trim(DBMemoValue.DataField)<>'') then begin
    if OpenDialog.Execute then begin
      Stream:=TFileStream.Create(OpenDialog.FileName,fmOpenRead or fmShareDenyWrite);
      try
        SetLength(AValue,Stream.Size);
        Stream.Read(Pointer(AValue)^,Stream.Size);
        FDataSet.Edit;
        FDataSet.FieldByName(DBMemoValue.DataField).Value:=AValue;
        FDataSet.Post;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

procedure TBisSecureTableEditFrame.ButtonSaveValueClick(Sender: TObject);
var
  Stream: TFileStream;
  AValue: String;
begin
  if FDataSet.Active and (Trim(DBMemoValue.DataField)<>'') and not FDataSet.IsEmpty then begin
    if SaveDialog.Execute then begin
      Stream:=TFileStream.Create(SaveDialog.FileName,fmCreate);
      try
        AValue:=FDataSet.FieldByName(DBMemoValue.DataField).Value;
        Stream.Write(Pointer(AValue)^,Length(AValue));
      finally
        Stream.Free;
      end;
    end;
  end;
end;

procedure TBisSecureTableEditFrame.btUpColumnsClick(Sender: TObject);
begin
  FDataSet.MoveData(true);
end;

procedure TBisSecureTableEditFrame.btDownColumnsClick(Sender: TObject);
begin
  FDataSet.MoveData(false);
end;

procedure TBisSecureTableEditFrame.ButtonApplyClick(Sender: TObject);
var
  FieldName: String;
begin
  if Trim(EditFilter.Text)<>'' then begin
    if Assigned(DBGrid.SelectedField) then begin
      DataSet.FilterOptions:=[foCaseInsensitive,foNoPartialCompare];
      DataSet.Filtered:=false;
      DataSet.Filter:='';
      FieldName:=DBGrid.SelectedField.FieldName;
      DataSet.Filter:=Format('%s LIKE %s',[FieldName,QuotedStr(EditFilter.Text)]);
      DataSet.Filtered:=true;
      RefreshCount;
    end;
  end else begin
    DataSet.Filter:='';
    DataSet.Filtered:=false;
    RefreshCount;
  end;
end;

procedure TBisSecureTableEditFrame.RefreshCount;
var
  Count: Integer;
begin
  Count:=0;
  if DataSet.Active then
    Count:=DataSet.RecordCount;
  LabelCount.Caption:=FormatEx('�����: %d',[Count]);
  LabelCount.Update;
end;

procedure TBisSecureTableEditFrame.SetColumnsColor;
var
  i: Integer;
  Column: TColumn;
  Field: TField;
begin
  for i:=0 to DBGrid.Columns.Count-1 do begin
    Column:=DBGrid.Columns.Items[i];
    Field:=Column.Field;
    if Assigned(Field) and Field.IsBlob then begin
      Column.Color:=ColorControlReadOnly;
    end;
  end;
end;

procedure TBisSecureTableEditFrame.ButtonEditorValueClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=Point(ButtonEditorValue.Left,ButtonEditorValue.Top+ButtonEditorValue.height);
  Pt:=PanelValueButton.ClientToScreen(Pt);
  PopupMenuEditor.Popup(Pt.X,Pt.Y);
end;

procedure TBisSecureTableEditFrame.MenuItemEditorTableClick(Sender: TObject);
var
  AForm: TBisSecureTableEditForm;
  Field: TField;
  Stream: TMemoryStream;
begin
  if FDataSet.Active and (Trim(DBMemoValue.DataField)<>'') then begin
    Field:=FDataSet.FindField(DBMemoValue.DataField);
    if Field.IsBlob then begin
      AForm:=TBisSecureTableEditForm.Create(nil);
      Stream:=TMemoryStream.Create;
      try
        if not Field.IsNull then begin
          TBlobField(Field).SaveToStream(Stream);
          Stream.Position:=0;
          AForm.TableEdit.DataSet.LoadFromStream(Stream);
          AForm.TableEdit.RefreshCount;
          AForm.TableEdit.SetColumnsColor;
        end;
        if AForm.ShowModal=mrOk then begin
          if AForm.TableEdit.DataSet.Active then begin
            Stream.Clear;
            AForm.TableEdit.DataSet.SaveToStream(Stream);
            Stream.Position:=0;
            FDataSet.Edit;
            TBlobField(Field).LoadFromStream(Stream);
            FDataSet.Post;
          end else begin
            FDataSet.Edit;
            Field.Value:=Null;
            FDataSet.Post;
          end;
        end;
      finally
        Stream.Free;
        AForm.Free;
      end;
    end;
  end;
end;


end.
