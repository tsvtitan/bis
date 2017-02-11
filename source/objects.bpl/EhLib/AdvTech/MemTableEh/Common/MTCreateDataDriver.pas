{*******************************************************}
{                                                       }
{                     EhLib vX.X                        }
{                                                       }
{     TMemTableFieldsEditorEh component (Build 14)      }
{                                                       }
{        Copyright (c) 2003,04 by EhLib Team and        }
{                Dmitry V. Bolshakov                    }
{                                                       }
{*******************************************************}

unit MTCreateDataDriver;

interface

{$I EhLib.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MemTableEh, DataDriverEh, Db, TypInfo, DBUtilsEh,
  DBTables, IBCustomDataSet,
{$IFDEF EH_LIB_6} DBXDataDriverEh,
{$IFDEF CIL}
  Borland.Vcl.Design.DesignIntf,
{$ELSE}
  DesignIntf,
{$ENDIF}
  SqlExpr,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  BDEDataDriverEh,
{$IFNDEF CIL}
  ADODataDriverEh,
  ADODb,
{$ENDIF}
  IBXDataDriverEh, ExtCtrls;

type
  TfMTCreateDataDriver = class(TForm)
    DataSetList: TListBox;
    DataDriversList: TListBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FDataSet: TCustomMemTableEh;
{$IFDEF EH_LIB_6}
    FDesigner: IDesigner;
{$ELSE}
    FDesigner: IFormDesigner;
{$ENDIF}
    function Edit: Boolean;
    procedure CheckComponent(const Value: string);
  end;

var
  fMTCreateDataDriver: TfMTCreateDataDriver;

function EditMTCreateDataDriver(ADataSet: TCustomMemTableEh; ADesigner: IDesigner): Boolean;

implementation

{$R *.dfm}

function EditMTCreateDataDriver(ADataSet: TCustomMemTableEh; ADesigner: IDesigner): Boolean;
begin
  with TfMTCreateDataDriver.Create(Application) do
  try
    Caption := Format('SClientDataSetEditor', [ADataSet.Owner.Name, ADataSet.Name]);
    FDataSet := ADataSet;
{$IFDEF EH_LIB_6}
    FDesigner := ADesigner;
{$ELSE}
    FDesigner := IFormDesigner(ADesigner);
{$ENDIF}
    Result := Edit;
  finally
    Free;
  end;
end;

procedure TfMTCreateDataDriver.FormCreate(Sender: TObject);
var
  NonClientMetrics: TNonClientMetrics;
begin
  if ParentFont then
  begin
    NonClientMetrics.cbSize := sizeof(NonClientMetrics);
{$IFDEF CIL}
  { TODO : To do for CIL }
//    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
//      Font.Name := NonClientMetrics.lfMessageFont.lfFaceName;
{$ELSE}
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
      Font.Name := NonClientMetrics.lfMessageFont.lfFaceName;
{$ENDIF}
  end;

  DataDriversList.Items.Objects[0] := TObject(TDataSetDriverEh);
  DataDriversList.Items.Objects[1] := TObject(TSQLDataDriverEh);
  DataDriversList.Items.Objects[2] := TObject(TBDEDataDriverEh);
{$IFDEF EH_LIB_6}
  DataDriversList.Items.Objects[3] := TObject(TDBXDataDriverEh);
{$ENDIF}
{$IFNDEF CIL}
  DataDriversList.Items.Objects[4] := TObject(TADODataDriverEh);
{$ENDIF}
  DataDriversList.Items.Objects[5] := TObject(TIBXDataDriverEh);
end;

function TfMTCreateDataDriver.Edit: Boolean;
begin
  DataSetList.Clear;
  FDesigner.GetComponentNames(GetTypeData(TDataSet.ClassInfo), CheckComponent);
  if DataSetList.Items.Count > 0 then
  begin
    DataSetList.Enabled := True;
    DataSetList.ItemIndex := 0;
    OkBtn.Enabled := True;
    ActiveControl := DataSetList;
  end else
    ActiveControl := CancelBtn;
  Result := ShowModal = mrOK;
end;

procedure TfMTCreateDataDriver.OkBtnClick(Sender: TObject);
var
//  form: TCustomForm;
  ddr: TDataDriverEh;
  SourceDS: TDataSet;
{$IFDEF CIL}
//  pos: LongRec;
{$ELSE}
  pos: LongRec;
{$ENDIF}
  SQLPropValue: WideString;
  Params: TParams;
  ddrName: String;
  I: Integer;

  function IsUnique(const AName: string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    with FDataSet.Owner do
      for I := 0 to ComponentCount - 1 do
        if CompareText(AName, Components[I].Name) = 0 then Exit;
    Result := True;
  end;

begin
  if (DataSetList.ItemIndex < 0) or (DataDriversList.ItemIndex < 0) then Exit;
//  form := (FDataSet.Owner as TCustomForm);
  SourceDS := FDesigner.GetComponent(DataSetList.Items[DataSetList.ItemIndex]) as TDataSet;
{$IFDEF CIL}
//  ddr := TDataDriverEh(FDesigner.CreateComponent(
//    TComponentClass(DataDriversList.Items.Objects[DataDriversList.ItemIndex]), FDataSet.Owner,
//    LongRec(FDataSet.DesignInfo).Lo - 24, LongRec(FDataSet.DesignInfo).Hi, 0,0));
{$ELSE}
  ddr := TDataDriverEh(FDesigner.CreateComponent(
    TComponentClass(DataDriversList.Items.Objects[DataDriversList.ItemIndex]), FDataSet.Owner,
    LongRec(FDataSet.DesignInfo).Lo - 24, LongRec(FDataSet.DesignInfo).Hi, 0,0));
{$ENDIF}

//    ddr := TDataSetDriverEh.Create(form);
  ddrName := 'dd' + FDataSet.Name;
  if not IsUnique(ddrName) then
    for I := 1 to MaxInt do
    begin
      ddrName := 'dd' + FDataSet.Name + IntToStr(I);
      if IsUnique(ddrName) then Break;
    end;

  ddr.Name := ddrName;
{$IFDEF CIL}
//  pos.Lo := LongRec(FDataSet.DesignInfo).Lo - 24;
//  pos.Hi := LongRec(FDataSet.DesignInfo).Hi;
//  ddr.DesignInfo := Longint(pos);
{$ELSE}
  pos.Lo := LongRec(FDataSet.DesignInfo).Lo - 24;
  pos.Hi := LongRec(FDataSet.DesignInfo).Hi;
  ddr.DesignInfo := Longint(pos);
{$ENDIF}
  FDesigner.Modified;
  FDataSet.DataDriver := ddr;

  if DataDriversList.Items[DataDriversList.ItemIndex] = 'TDataSetDriverEh' then
  begin
    TDataSetDriverEh(ddr).ProviderDataSet := SourceDS;
  end else
  begin
    if IsDataSetHaveSQLLikeProp(SourceDS, 'SQL', SQLPropValue) then
    begin
      TSQLDataDriverEh(ddr).SelectSQL.Text := SQLPropValue;
      Params := IProviderSupport(SourceDS).PSGetParams;
      if Params <> nil then
        TSQLDataDriverEh(ddr).SelectCommand.Params := Params;
    end;
    if (SourceDS is TQuery) and (TQuery(SourceDS).UpdateObject <> nil) and
      (TQuery(SourceDS).UpdateObject is TUpdateSQL) then
    begin
      TSQLDataDriverEh(ddr).InsertSQL.Text :=
        TUpdateSQL(TQuery(SourceDS).UpdateObject).SQL[ukInsert].Text;
      TSQLDataDriverEh(ddr).UpdateSQL.Text :=
        TUpdateSQL(TQuery(SourceDS).UpdateObject).SQL[ukModify].Text;
      TSQLDataDriverEh(ddr).DeleteSQL.Text :=
        TUpdateSQL(TQuery(SourceDS).UpdateObject).SQL[ukDelete].Text;
    end;
    if (SourceDS is TDBDataSet) and (ddr is TBDEDataDriverEh) then
      TBDEDataDriverEh(ddr).DatabaseName := TDBDataSet(SourceDS).DatabaseName;

{$IFDEF EH_LIB_6}
    if (SourceDS is TCustomSQLDataSet) and (ddr is TDBXDataDriverEh) then
      TDBXDataDriverEh(ddr).SQLConnection := TCustomSQLDataSet(SourceDS).SQLConnection;
{$ENDIF}

{$IFNDEF CIL}
    if (SourceDS is TCustomADODataSet) and (ddr is TADODataDriverEh) then
    begin
      TADODataDriverEh(ddr).ADOConnection := TCustomADODataSet(SourceDS).Connection;
      TADODataDriverEh(ddr).ConnectionString := TCustomADODataSet(SourceDS).ConnectionString;
    end;
{$ENDIF}
    if (SourceDS is TIBCustomDataSet) and (ddr is TIBXDataDriverEh) then
      TIBXDataDriverEh(ddr).Database := TIBCustomDataSet(SourceDS).Database;
  end;
end;

procedure TfMTCreateDataDriver.CheckComponent(const Value: string);
var
  DataSet: TDataSet;
begin
  DataSet := TDataSet(FDesigner.GetComponent(Value));
  if (DataSet.Owner <> FDataSet.Owner) then
    DataSetList.Items.Add(Concat(DataSet.Owner.Name, '.', DataSet.Name))
  else
    if AnsiCompareText(DataSet.Name, FDataSet.Name) <> 0 then
      DataSetList.Items.Add(DataSet.Name);
end;

end.
