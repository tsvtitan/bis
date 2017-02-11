unit BisDBTableEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, DBGrids, Grids,
  BisDataSet, BisDialogFm, BisControls;

type
  TBisDBTableEditForm = class(TBisDialogForm)
    PanelGrid: TPanel;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonClear: TButton;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    FIndexDataType: Integer;
    FDefaultDataSet: TBisDataSet;
    FOriginalDataSet: TBisDataSet;
    procedure CreateDataSetByOriginal;
    procedure FillDataTypes(PickList: TStrings);
    procedure FieldDataTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FieldDataTypeSetText(Sender: TField; const Text: string);
  public
    constructor Create(ADataSet: TBisDataSet); reintroduce;
    destructor Destroy; override;
  end;

var
  BisDBTableEditForm: TBisDBTableEditForm;

implementation

uses TypInfo, Consts, kbmMemTable,
     BisConsts, BisUtils;

{$R *.dfm}

{ TBisDBTableEditForm }

constructor TBisDBTableEditForm.Create(ADataSet: TBisDataSet);
begin
  inherited Create(nil);
  FOriginalDataSet:=ADataSet;
  FDefaultDataSet:=TBisDataSet.Create(nil);
  with FDefaultDataSet do begin
    FieldDefs.Add(SFieldName,ftString,100);
    FieldDefs.Add(SFieldWidth,ftInteger);
    FieldDefs.Add(SFieldDataType,ftInteger);
    FieldDefs.Add(SFieldSize,ftInteger);
    FieldDefs.Add(SFieldPrecision,ftInteger);
    FieldDefs.Add(SFieldDescription,ftString,250);
    CreateTable;
    with FDefaultDataSet do begin
      FieldByName(SFieldDataType).OnGetText:=FieldDataTypeGetText;
      FieldByName(SFieldDataType).OnSetText:=FieldDataTypeSetText;
      FieldByName(SFieldDataType).Alignment:=taLeftJustify;
    end;
    Open;
  end;
  DataSource.DataSet:=FDefaultDataSet;
  FIndexDataType:=2;
  FillDataTypes(DBGrid.Columns.Items[FIndexDataType].PickList);
  CreateDataSetByOriginal;
end;

procedure TBisDBTableEditForm.DBGridDrawColumnCell(Sender: TObject;
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

destructor TBisDBTableEditForm.Destroy;
begin
  FDefaultDataSet.Free;
  inherited Destroy;
end;

procedure TBisDBTableEditForm.FillDataTypes(PickList: TStrings);
var
  i: Integer;
  PInfo: PTypeInfo;
  PData: PTypeData;
begin
  PickList.BeginUpdate;
  try
    PickList.Clear;
    PData:=nil;
    PInfo:=TypeInfo(TFieldType);
    if Assigned(PInfo) then
      PData:=GetTypeData(PInfo);
    if Assigned(PData) then
      for i:=PData.MinValue to PData.MaxValue do begin
        PickList.Add(GetEnumName(PInfo,i));
      end;
  finally
    PickList.EndUpdate;
  end;
end;

procedure TBisDBTableEditForm.FieldDataTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not FDefaultDataSet.IsEmpty then
    if Sender.AsInteger in [0..DBGrid.Columns.Items[FIndexDataType].PickList.Count-1] then
      Text:=DBGrid.Columns.Items[FIndexDataType].PickList[Sender.AsInteger];
end;

procedure TBisDBTableEditForm.FieldDataTypeSetText(Sender: TField; const Text: string);
var
  Index: Integer;
begin
  Index:=DBGrid.Columns.Items[FIndexDataType].PickList.IndexOf(Text);
  if Index in [0..DBGrid.Columns.Items[FIndexDataType].PickList.Count-1] then
    Sender.AsInteger:=Index;
end;

procedure TBisDBTableEditForm.CreateDataSetByOriginal;
var
  B: TBookmark;
  I: Integer;
  Field: TField;
begin
  if Assigned(FOriginalDataSet) and FOriginalDataSet.Active then begin
    FOriginalDataSet.DisableControls;
    B:=FOriginalDataSet.GetBookmark;
    try
      FDefaultDataSet.EmptyTable;
      for i:=0 to FOriginalDataSet.FieldCount-1 do begin
        Field:=FOriginalDataSet.Fields[i];
        with FDefaultDataSet do begin
          Append;
          FieldByName(SFieldName).Value:=Field.FieldName;
          FieldByName(SFieldDataType).Value:=Field.DataType;
          FieldByName(SFieldSize).Value:=iff(Field.Size>0,Field.Size,NULL);
          FieldByName(SFieldPrecision).Value:=iff(FOriginalDataSet.FieldDefs.Items[i].Precision>0,
                                                      FOriginalDataSet.FieldDefs.Items[i].Precision,
                                                      NULL);
          FieldByName(SFieldDescription).Value:=Field.DisplayLabel;
          FieldByName(SFieldWidth).Value:=Field.DisplayWidth;
          Post;
        end;
      end;
    finally
      if Assigned(B) and FOriginalDataSet.BookmarkValid(B) then
        FOriginalDataSet.GotoBookmark(B);
      FOriginalDataSet.EnableControls;
    end;
  end;
end;

procedure TBisDBTableEditForm.ButtonLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    FDefaultDataSet.LoadFromFile(OpenDialog.FileName);
    with FDefaultDataSet do begin
      FieldByName(SFieldDataType).OnGetText:=FieldDataTypeGetText;
      FieldByName(SFieldDataType).OnSetText:=FieldDataTypeSetText;
      FieldByName(SFieldDataType).Alignment:=taLeftJustify;
    end;  
  end;
end;

procedure TBisDBTableEditForm.ButtonSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    if FDefaultDataSet.State in [dsEdit, dsInsert] then
      FDefaultDataSet.Post;
    FDefaultDataSet.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TBisDBTableEditForm.ButtonClearClick(Sender: TObject);
begin
  FDefaultDataSet.EmptyTable;
end;

procedure TBisDBTableEditForm.ButtonOkClick(Sender: TObject);
var
  B: TBookmark;
  DataType: TFieldType;
  Field: TField;
  FieldDef: TFieldDef;
  OldDataSet: TBisDataSet;
  CopyOptions: TkbmMemTableCopyTableOptions;
begin
  if Assigned(FOriginalDataSet) and FDefaultDataSet.Active then begin
    OldDataSet:=TBisDataSet.Create(nil);
    if FOriginalDataSet.Active then begin
      CopyOptions:=[mtcpoStructure,mtcpoOnlyActiveFields,mtcpoProperties,mtcpoLookup,mtcpoCalculated,
                    mtcpoFieldIndex,mtcpoDontDisableIndexes,mtcpoIgnoreErrors];
      OldDataSet.LoadFromDataSet(FOriginalDataSet,CopyOptions);
    end;  
    FOriginalDataSet.Close;
    FOriginalDataSet.FieldDefs.Clear;
    FDefaultDataSet.DisableControls;
    B:=FDefaultDataSet.GetBookmark;
    try
      FDefaultDataSet.First;
      while not FDefaultDataSet.Eof do begin
        DataType:=TFieldType(FDefaultDataSet.FieldByName(SFieldDataType).AsInteger);
        if DataType in [ftUnknown..ftFMTBcd] then begin
          with FOriginalDataSet do begin
            FieldDef:=FieldDefs.AddFieldDef;
            FieldDef.Name:=FDefaultDataSet.FieldByName(SFieldName).AsString;
            FieldDef.DataType:=DataType;
            FieldDef.Size:=FDefaultDataSet.FieldByName(SFieldSize).AsInteger;
            FieldDef.Precision:=FDefaultDataSet.FieldByName(SFieldPrecision).AsInteger;
          end;
        end;
        FDefaultDataSet.Next;
      end;
      FOriginalDataSet.CreateTable;
      FDefaultDataSet.First;
      while not FDefaultDataSet.Eof do begin
        Field:=FOriginalDataSet.FindField(FDefaultDataSet.FieldByName(SFieldName).AsString);
        if Assigned(Field) then begin
          Field.DisplayLabel:=FDefaultDataSet.FieldByName(SFieldDescription).AsString;
          Field.DisplayWidth:=FDefaultDataSet.FieldByName(SFieldWidth).AsInteger;
        end;
        FDefaultDataSet.Next;
      end;
      if OldDataSet.Active then begin
        CopyOptions:=[mtcpoLookup,mtcpoCalculated,mtcpoFieldIndex,mtcpoDontDisableIndexes,mtcpoIgnoreErrors];
        FOriginalDataSet.LoadFromDataSet(OldDataSet,CopyOptions);
      end;
      FOriginalDataSet.Open;
      ModalResult:=mrOk;
    finally
      if Assigned(B) and FDefaultDataSet.BookmarkValid(B) then
        FDefaultDataSet.GotoBookmark(B);
      FDefaultDataSet.EnableControls;
      OldDataSet.Free;
    end;
  end;
end;

end.