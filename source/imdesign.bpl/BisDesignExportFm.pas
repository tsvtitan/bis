unit BisDesignExportFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList, DB, ImgList, ToolWin,
  ExtCtrls, Grids, DBGrids, Menus, ActnPopup, StdCtrls, CommCtrl,
  BisFm, BisDataSet, BisDBTree, BisFieldNames, BisControls;

type
  TBisDesignExportForm = class(TBisForm)
    StatusBar: TStatusBar;
    ImageList: TImageList;
    DataSource: TDataSource;
    ActionList: TActionList;
    ActionLoad: TAction;
    ActionExport: TAction;
    PanelData: TPanel;
    GridPattern: TDBGrid;
    ControlBar: TControlBar;
    ToolBarConnections: TToolBar;
    Popup: TPopupActionBar;
    N1: TMenuItem;
    N2: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ComboBoxConnections: TComboBox;
    ToolButtonConnection: TToolButton;
    ActionConnection: TAction;
    ToolBarExport: TToolBar;
    ToolButtonLoad: TToolButton;
    ToolButtonExport: TToolButton;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolButton1: TToolButton;
    N5: TMenuItem;
    procedure ActionLoadExecute(Sender: TObject);
    procedure ActionExportExecute(Sender: TObject);
    procedure ActionLoadUpdate(Sender: TObject);
    procedure ActionExportUpdate(Sender: TObject);
    procedure ActionConnectionExecute(Sender: TObject);
    procedure ActionConnectionUpdate(Sender: TObject);
  private
    FDataSet: TBisDataSet;
    FGrid: TBisDBTree;
    FExporting: Boolean;
    FFieldNameCheck: TBisFieldName;
    procedure RefreshConnections;
    procedure GridClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataSetNewRecord(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TBisDesignExportFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignExportForm: TBisDesignExportForm;

implementation

uses BisConsts, BisUtils, BisCore, BisConnections, BisConnectionModules, BisConnectionEditFm,
     BisDialogs;

{$R *.dfm}

{ TBisDesignExportFormIface }

constructor TBisDesignExportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignExportForm;
  Available:=true;
  Permissions.Enabled:=true;
  OnlyOneForm:=false;
end;

{ TBisDesignExportForm }

constructor TBisDesignExportForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FreeOnClose:=true;
  
  FDataSet:=TBisDataSet.Create(Self);
  with FDataSet.FieldDefs do begin
    Add(SFieldID,ftString,32);
    Add(SFieldType,ftInteger);
    Add(SFieldDescription,ftString,250);
    Add(SFieldValue,ftBlob);
    Add(SFieldResult,ftBlob);
    Add(SFieldChecked,ftInteger);
  end;
  with FDataSet.FieldNames do begin
    AddKey(SFieldID);
    FFieldNameCheck:=AddCheckBox(SFieldChecked,'�������',60);
    Add(SFieldDescription,'��������',300);
  end;
  FDataSet.CreateTable();
  FDataSet.OnNewRecord:=DataSetNewRecord;
  DataSource.DataSet:=FDataSet;

  FGrid:=TBisDBTree.Create(Self);
  FGrid.Parent:=GridPattern.Parent;
  FGrid.Align:=GridPattern.Align;
  FGrid.SortEnabled:=false;
  FGrid.NavigatorVisible:=true;
  FGrid.NumberVisible:=true;
  FGrid.SearchEnabled:=true;
  FGrid.SortColumnVisible:=true;
  FGrid.ChessVisible:=true;
  FGrid.GridEmulate:=true;
  FGrid.RowVisible:=true;
  FGrid.ReadOnly:=true;
  FGrid.DataSource:=GridPattern.DataSource;
  FGrid.AutoResizeableColumns:=true;
  FGrid.PopupMenu:=GridPattern.PopupMenu;
  FGrid.CopyFromFieldNames(FDataSet.FieldNames);
  FGrid.OnClick:=GridClick;
  FGrid.OnKeyDown:=GridKeyDown;

  FreeAndNilEx(GridPattern);

  RefreshConnections;
end;

destructor TBisDesignExportForm.Destroy;
begin
  FGrid.Free;
  FDataSet.Free;
  inherited Destroy;
end;

procedure TBisDesignExportForm.DataSetNewRecord(DataSet: TDataSet);
begin
  FDataSet.FieldByName(SFieldID).Value:=GetUniqueID;
end;

procedure TBisDesignExportForm.RefreshConnections;
var
  i: Integer;
  j: Integer;
  Index, IndexConnection: Integer;
  Module: TBisConnectionModule;
  AConnection: TBisConnection;
begin
  ComboBoxConnections.Items.BeginUpdate;
  try
    ComboBoxConnections.Items.Clear;
    IndexConnection:=-1;
    for i:=0 to Core.ConnectionModules.Count-1 do begin
      Module:=Core.ConnectionModules.Items[i];
      if Module.Enabled then begin
        for j:=0 to Module.Connections.Count-1 do begin
          AConnection:=Module.Connections.Items[j];
          if AConnection.Enabled then begin
            Index:=ComboBoxConnections.Items.AddObject(AConnection.Caption,AConnection);
            if AConnection=Core.Connection then
              IndexConnection:=Index;
          end;
        end;
      end;
    end;
    if ComboBoxConnections.Items.Count>0 then begin
      if IndexConnection<>-1 then begin
        ComboBoxConnections.ItemIndex:=IndexConnection;
      end else begin
        ComboBoxConnections.ItemIndex:=0;
      end;
    end;
  finally
    ComboBoxConnections.Items.EndUpdate;
  end;
end;

procedure TBisDesignExportForm.ActionExportUpdate(Sender: TObject);
begin
  ActionExport.Enabled:=not FExporting and FDataSet.Active and
                        not FDataSet.IsEmpty and (ComboBoxConnections.ItemIndex<>-1);
end;

procedure TBisDesignExportForm.ActionConnectionUpdate(Sender: TObject);
begin
  ActionConnection.Enabled:=not FExporting and FDataSet.Active and
                            not FDataSet.IsEmpty and (ComboBoxConnections.ItemIndex<>-1);
end;

procedure TBisDesignExportForm.ActionLoadUpdate(Sender: TObject);
begin
  ActionLoad.Enabled:=not FExporting;
end;

procedure TBisDesignExportForm.ActionLoadExecute(Sender: TObject);
var
  P: TBisDataSet;
begin
  if OpenDialog.Execute then begin
    P:=TBisDataSet.Create(nil);
    try
      P.LoadFromFile(OpenDialog.FileName);
      FDataSet.EmptyTable;
      FDataSet.BeginUpdate;
      try
        FDataSet.CopyRecords(P);
        FDataSet.First;
      finally
        FDataSet.EndUpdate;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisDesignExportForm.ActionExportExecute(Sender: TObject);
var
  Stream: TMemoryStream;
  AChecked: Boolean;
  OldCursor: TCursor;
  AConnection: TBisConnection;
  Breaked: Boolean;
  Position: Integer;
  B: TBookmark;
begin
  if not FExporting and SaveDialog.Execute then begin
    if ComboBoxConnections.ItemIndex<>-1 then begin
      AConnection:=TBisConnection(ComboBoxConnections.Items.Objects[ComboBoxConnections.ItemIndex]);
      if Assigned(AConnection) then begin
        OldCursor:=Screen.Cursor;
        Screen.Cursor:=crHourGlass;
        FExporting:=true;
        ComboBoxConnections.Enabled:=false;
        B:=FDataSet.GetBookmark;
        Stream:=TMemoryStream.Create;
        Progress(0,0,0,Breaked);
        try
          AConnection.Connect;
          if AConnection.Connected then begin
            Position:=1;
            Progress(0,FDataSet.RecordCount,0,Breaked);
            FDataSet.First;
            while not FDataSet.Eof do begin
              AChecked:=Boolean(FDataSet.FieldByName(SFieldChecked).AsInteger);
              if AChecked then begin
                Stream.Clear;
                try
                  AConnection.Export(TBisConnectionExportType(FDataSet.FieldByName(SFieldType).AsInteger),
                                     FDataSet.FieldByName(SFieldValue).AsString,Stream);
                except
                  on E: Exception do begin
                    Stream.WriteBuffer(E.Message,Length(E.Message));
                  end;
                end;

                Stream.Position:=0;
                FDataSet.Edit;
                TBlobField(FDataSet.FieldByName(SFieldResult)).LoadFromStream(Stream);
                FDataSet.Post;
              end;

              FDataSet.Next;
              Progress(0,FDataSet.RecordCount,Position,Breaked);
              Inc(Position)
            end;
            FDataSet.SaveToFile(SaveDialog.FileName);
            AConnection.Disconnect;
          end;
        finally
          Progress(0,0,0,Breaked);
          Stream.Free;
          if Assigned(B) and FDataSet.BookmarkValid(B) then
            FDataSet.GotoBookmark(B);          
          ComboBoxConnections.Enabled:=true;
          FExporting:=false;
          Screen.Cursor:=OldCursor;
        end;
      end;
    end;
  end;
end;

procedure TBisDesignExportForm.GridClick(Sender: TObject);
var
  AColumn: TBisDBTreeColumn;
  AChecked: Boolean;
begin
  if FDataSet.Active and not FDataSet.IsEmpty then begin
    AColumn:=TBisDBTreeColumn(FGrid.Header.Columns[FGrid.FocusedColumn]);
    if Assigned(AColumn) and (AColumn.FieldName=FFieldNameCheck) then begin
      FDataSet.BeginUpdate(true);
      try
        AChecked:=Boolean(FDataSet.FieldByName(SFieldChecked).AsInteger);
        FDataSet.Edit;
        FDataSet.FieldByName(SFieldChecked).AsInteger:=Integer(not AChecked);
        FDataSet.Post;
      finally
        FDataSet.EndUpdate;
      end;
    end;
  end;
end;

procedure TBisDesignExportForm.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift=[]) and (Key=VK_SPACE) then begin
    GridClick(nil);
  end;
end;

procedure TBisDesignExportForm.ActionConnectionExecute(Sender: TObject);
var
  Form: TBisConnectionEditForm;
  AConnection: TBisConnection;
begin
  if ComboBoxConnections.ItemIndex<>-1 then begin
    AConnection:=TBisConnection(ComboBoxConnections.Items.Objects[ComboBoxConnections.ItemIndex]);
    if Assigned(AConnection) then begin
      Form:=TBisConnectionEditForm.Create(nil);
      try
        Form.Connection:=AConnection;
        if Form.ShowModal=mrOk then begin
          if Form.CheckBoxDefault.Checked then
//            AConnection.
        end;
      finally
        Form.Free;
      end;
    end;
  end;
end;


end.
