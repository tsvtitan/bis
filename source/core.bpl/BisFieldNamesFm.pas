unit BisFieldNamesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, DBCtrls, DB,
  BisFieldNames, BisProvider;

type
  TBisFieldNamesForm = class(TForm)
    PanelButton: TPanel;
    ButtonCancel: TButton;
    ButtonOk: TButton;
    PanelGrid: TPanel;
    Grid: TDBGrid;
    DBNavigator: TDBNavigator;
    Bevel: TBevel;
    DataSource: TDataSource;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FProvider: TBisProvider;
    FFieldNames: TBisFieldNames;
    procedure FillTypes(PickList: TStrings);
    procedure FieldFuncTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FieldFuncTypeSetText(Sender: TField; const Text: string);
    procedure GetFieldNames;
    procedure FillFieldNames;
    procedure SetFieldNames(Value: TBisFieldNames);
  public
    property FieldNames: TBisFieldNames read FFieldNames write SetFieldNames;
  end;

var
  BisFieldNamesForm: TBisFieldNamesForm;

implementation

uses TypInfo, Consts, 
     BisUtils;

{$R *.dfm}

{ TSgtsBaseFieldNamesForm }

procedure TBisFieldNamesForm.FormCreate(Sender: TObject);
begin
  FProvider:=TBisProvider.Create(nil);
  with FProvider.FieldDefs do begin
    Add('NAME',ftString,100);
    Add('FUNC_TYPE',ftInteger);
  end;
  FProvider.CreateTable;
  with FProvider.Fields[1] do begin
    OnGetText:=FieldFuncTypeGetText;
    OnSetText:=FieldFuncTypeSetText;
    Alignment:=taLeftJustify;
  end;

  DataSource.DataSet:=FProvider;

  FillTypes(Grid.Columns.Items[1].PickList);
end;

procedure TBisFieldNamesForm.FormDestroy(Sender: TObject);
begin
  FProvider.Free;
end;

procedure TBisFieldNamesForm.FillTypes(PickList: TStrings);
var
  i: Integer;
  PInfo: PTypeInfo;
  PData: PTypeData;
begin
  PickList.BeginUpdate;
  try
    PickList.Clear;
    PData:=nil;
    PInfo:=TypeInfo(TBisFieldNameFuncType);
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

procedure TBisFieldNamesForm.FieldFuncTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if (Sender.AsInteger in [0..Grid.Columns.Items[1].PickList.Count-1]) and
      not FProvider.IsEmpty then
    Text:=Grid.Columns.Items[1].PickList[Sender.AsInteger];
end;

procedure TBisFieldNamesForm.FieldFuncTypeSetText(Sender: TField; const Text: string);
var
  Index: Integer;
begin
  Index:=Grid.Columns.Items[1].PickList.IndexOf(Text);
  if Index in [0..Grid.Columns.Items[1].PickList.Count-1] then
    Sender.AsInteger:=Index;
end;


procedure TBisFieldNamesForm.SetFieldNames(Value: TBisFieldNames);
begin
  FFieldNames:=Value;
  FillFieldNames;
end;

procedure TBisFieldNamesForm.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TBisFieldNamesForm.ButtonOkClick(Sender: TObject);
begin
  GetFieldNames;
  ModalResult:=mrOk;
end;

procedure TBisFieldNamesForm.GetFieldNames;
var
  FieldName: TBisFieldName;
begin
  if Assigned(FFieldNames) then begin
    FFieldNames.Clear;
    FProvider.BeginUpdate;
    try
      FProvider.First;
      while not FProvider.Eof do begin
        FieldName:=FFieldNames.AddInvisible(FProvider.FieldByName('NAME').AsString);
        if Assigned(FieldName) then begin
          FieldName.FuncType:=TBisFieldNameFuncType(FProvider.FieldByName('FUNC_TYPE').AsInteger);
        end;
        FProvider.Next;
      end;
    finally
      FProvider.EndUpdate;
    end;
  end;
end;

procedure TBisFieldNamesForm.FillFieldNames;
var
  i: Integer;
  Item: TBisFieldName;
begin
  if Assigned(FFieldNames) then begin
    FProvider.BeginUpdate;
    try
      FProvider.EmptyTable;
      for i:=0 to FFieldNames.Count-1 do begin
        Item:=FFieldNames.Items[i];
        FProvider.Append;
        FProvider.FieldByName('NAME').AsString:=Item.FieldName;
        FProvider.FieldByName('FUNC_TYPE').AsInteger:=Integer(Item.FuncType);
        FProvider.Post;
      end;
      FProvider.First;
    finally
      FProvider.EndUpdate;
    end;
  end;
end;

end.
