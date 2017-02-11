unit BisImportFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList, DB, ImgList, ToolWin,
  ExtCtrls, Grids, DBGrids, Menus, ActnPopup, StdCtrls, CommCtrl,
  BisFm, BisDataSet, BisDBTree, BisFieldNames, BisCmdLine, BisControls;

type
  TBisImportForm = class(TBisForm)
    ControlBar: TControlBar;
    ToolBarConnections: TToolBar;
    ComboBoxConnections: TComboBox;
    ToolButtonConnection: TToolButton;
    ToolBarExport: TToolBar;
    ToolButtonLoad: TToolButton;
    ToolButtonExport: TToolButton;
    PanelData: TPanel;
    GridPattern: TDBGrid;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    ActionLoad: TAction;
    ActionImport: TAction;
    ActionConnection: TAction;
    ImageList: TImageList;
    DataSource: TDataSource;
    Popup: TPopupActionBar;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    OpenDialog: TOpenDialog;
    ToolButtonImportCurrent: TToolButton;
    ToolButtonSeparator: TToolButton;
    ActionImportCurrent: TAction;
    N5: TMenuItem;
    N6: TMenuItem;
    TimerExecute: TTimer;
    N7: TMenuItem;
    ActionInfo: TAction;
    N8: TMenuItem;
    procedure ActionLoadExecute(Sender: TObject);
    procedure ActionImportExecute(Sender: TObject);
    procedure ActionConnectionExecute(Sender: TObject);
    procedure ActionImportUpdate(Sender: TObject);
    procedure ActionConnectionUpdate(Sender: TObject);
    procedure ActionLoadUpdate(Sender: TObject);
    procedure ActionImportCurrentExecute(Sender: TObject);
    procedure ActionImportCurrentUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerExecuteTimer(Sender: TObject);
    procedure ActionInfoExecute(Sender: TObject);
    procedure ActionInfoUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FSImportSuccess: String;
    FSImportFail: String;
    FDataSet: TBisDataSet;
    FGrid: TBisDBTree;
    FImporting: Boolean;
    FSColumnChecked: String;
    FSColumnDescription: String;
    FAutoImport: Boolean;
    FSStartImport: String;
    FInterrupted: Boolean;
    procedure RefreshConnections;
    procedure GridDblClick(Sender: TObject);
    procedure DataSetNewRecord(DataSet: TDataSet);
  protected
    procedure AfterImport(Success: Boolean); virtual;
    procedure LoadFromFile(const FileName: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;
  published
    property SColumnDescription: String read FSColumnDescription write FSColumnDescription;
    property SColumnChecked: String read FSColumnChecked write FSColumnChecked;
    property SImportSuccess: String read FSImportSuccess write FSImportSuccess;
    property SImportFail: String read FSImportFail write FSImportFail;
    property SStartImport: String read FSStartImport write FSStartImport;
  end;

  TBisImportFormIface=class(TBisFormIface)
  private
    FAutoImport: Boolean;
    FImportFileName: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ShowByCommand(Param: TBisCmdParam; const Command: String); override;
    procedure BeforeFormShow; override;
  end;

var
  BisImportForm: TBisImportForm;

implementation

uses BisConsts, BisUtils, BisCore, BisConnections,
     BisConnectionModules, BisConnectionEditFm,
     BisDialogs, BisMemoFm;

{$R *.dfm}

{ TBisImportFormIface }

constructor TBisImportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisImportForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=false;
end;

procedure TBisImportFormIface.ShowByCommand(Param: TBisCmdParam; const Command: String);
begin
  Permissions.Enabled:=false;
  try
//    FImportFileName:=Core.CmdLine.ValueByParam(SCmdParamCommand,1);
    FImportFileName:=Param.Next(Command);
    FImportFileName:=ExpandFileNameEx(FImportFileName);
    FAutoImport:=FileExists(FImportFileName);
    if FAutoImport then
      ShowModal;
  finally
    Permissions.Enabled:=true;
  end;
end;

procedure TBisImportFormIface.BeforeFormShow;
begin
  inherited BeforeFormShow;
  if Assigned(LastForm) and FAutoImport then begin
    TBisImportForm(LastForm).FAutoImport:=true;
    TBisImportForm(LastForm).LoadFromFile(FImportFileName);
  end;
end;


{ TBisImportForm }

constructor TBisImportForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  FSColumnChecked:='�����';
  FSColumnDescription:='��������';

  FSImportSuccess:='������ ������� ��������.';
  FSImportFail:='������ �������� � ��������.';
  FSStartImport:='��������� ������?';
  
//  TranslateProperties();

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
    Add(SFieldDescription,FSColumnDescription,310);
    AddCheckBox(SFieldChecked,FSColumnChecked,50).Alignment:=daCenter;
  end;
  FDataSet.CreateTable();
  FDataSet.OnNewRecord:=DataSetNewRecord;
  DataSource.DataSet:=FDataSet;

  FGrid:=TBisDBTree.Create(Self);
  FGrid.Parent:=GridPattern.Parent;
  FGrid.Align:=GridPattern.Align;
  FGrid.SortEnabled:=false;
  FGrid.NavigatorVisible:=true;
  FGrid.NumberVisible:=false;
  FGrid.SearchEnabled:=true;
  FGrid.SortColumnVisible:=true;
  FGrid.ChessVisible:=true;
  FGrid.GridEmulate:=true;
  FGrid.RowVisible:=true;
  FGrid.ReadOnly:=true;
  FGrid.AutoResizeableColumns:=true;
  FGrid.CopyFromFieldNames(FDataSet.FieldNames);
  FGrid.DataSource:=GridPattern.DataSource;
  FGrid.PopupMenu:=GridPattern.PopupMenu;
  FGrid.OnDblClick:=GridDblClick;

  FreeAndNilEx(GridPattern);

  RefreshConnections;

end;

destructor TBisImportForm.Destroy;
begin
  FGrid.Free;
  FDataSet.Free;
  inherited Destroy;
end;

procedure TBisImportForm.BeforeShow;
begin
  inherited BeforeShow;
  if FAutoImport then begin
    ActionLoad.Visible:=false;
    ToolButtonSeparator.Visible:=false;
    ToolBarExport.Width:=ToolButtonExport.Width*2+2;
    ToolBarConnections.Left:=ToolBarExport.Left+ToolBarExport.Width+1;
  end;
end;

procedure TBisImportForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=not FImporting;
end;

procedure TBisImportForm.FormShow(Sender: TObject);
begin
 // TimerExecute.Enabled:=FAutoImport;
end;

procedure TBisImportForm.DataSetNewRecord(DataSet: TDataSet);
begin
  FDataSet.FieldByName(SFieldID).Value:=GetUniqueID;
  FDataSet.FieldByName(SFieldChecked).Value:=Integer(false);
end;

procedure TBisImportForm.RefreshConnections;
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

procedure TBisImportForm.TimerExecuteTimer(Sender: TObject);
begin
  TimerExecute.Enabled:=false;
//  if ShowQuestion(FSStartImport)=mrYes then
    ActionImport.Execute;
end;


procedure TBisImportForm.ActionInfoExecute(Sender: TObject);
var
  AForm: TBisMemoForm;
  Stream: TMemoryStream;
begin
  if FDataSet.Active and not FDataSet.IsEmpty then begin
    AForm:=TBisMemoForm.Create(nil);
    Stream:=TMemoryStream.Create;
    try
      TBlobField(FDataSet.FieldByName(SFieldResult)).SaveToStream(Stream);
      Stream.Position:=0;
      AForm.Memo.Lines.LoadFromStream(Stream);
      AForm.Memo.WordWrap:=true;
      AForm.Memo.ScrollBars:=ssVertical;
      AForm.ShowModal;
    finally
      Stream.Free;
      AForm.Free;
    end;
  end;
end;

procedure TBisImportForm.ActionImportUpdate(Sender: TObject);
begin
  ActionImport.Enabled:=not FImporting and FDataSet.Active and
                        not FDataSet.IsEmpty and (ComboBoxConnections.ItemIndex<>-1);
end;

procedure TBisImportForm.ActionInfoUpdate(Sender: TObject);
begin
  ActionInfo.Enabled:=not FImporting and FDataSet.Active and
                      not FDataSet.IsEmpty and (Trim(FDataSet.FieldByName(SFieldResult).AsString)<>'');
end;

procedure TBisImportForm.ActionImportCurrentUpdate(Sender: TObject);
begin
  ActionImportCurrent.Enabled:=not FImporting and FDataSet.Active and
                               not FDataSet.IsEmpty and (ComboBoxConnections.ItemIndex<>-1);
end;

procedure TBisImportForm.ActionConnectionUpdate(Sender: TObject);
begin
  ActionConnection.Enabled:=not FImporting and FDataSet.Active and
                            (ComboBoxConnections.ItemIndex<>-1);
end;

procedure TBisImportForm.ActionLoadUpdate(Sender: TObject);
begin
  ActionLoad.Enabled:=not FImporting and FDataSet.Active;
end;

procedure TBisImportForm.ActionImportCurrentExecute(Sender: TObject);
var
  Stream: TMemoryStream;
  AChecked: Boolean;
  OldCursor: TCursor;
  AConnection: TBisConnection;
  Ret: String;
begin
  if not FImporting then begin
    if ComboBoxConnections.ItemIndex<>-1 then begin
      AConnection:=TBisConnection(ComboBoxConnections.Items.Objects[ComboBoxConnections.ItemIndex]);
      if Assigned(AConnection) then begin
        OldCursor:=Screen.Cursor;
        Screen.Cursor:=crHourGlass;
        FImporting:=true;
        ComboBoxConnections.Enabled:=false;
        FDataSet.BeginUpdate(true);
        Stream:=TMemoryStream.Create;
        try
          AConnection.Connect;
          if AConnection.Connected then begin
            Ret:='';
            Stream.Clear;
            TBlobField(FDataSet.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            AChecked:=false;
            try
              AConnection.Import(TBisConnectionImportType(FDataSet.FieldByName(SFieldType).AsInteger),Stream);
              AChecked:=true;
            except
              on E: Exception do begin
                Ret:=E.Message;
                ShowError(Ret);
              end;
            end;

            FDataSet.Edit;
            FDataSet.FieldByName(SFieldChecked).Value:=Integer(AChecked);
            FDataSet.FieldByName(SFieldResult).Value:=Ret;
            FDataSet.Post;

            AConnection.Disconnect;
          end;
        finally
          Stream.Free;
          FDataSet.EndUpdate;
          ComboBoxConnections.Enabled:=true;
          FImporting:=false;
          Screen.Cursor:=OldCursor;
        end;
      end;
    end;
  end;
end;

procedure TBisImportForm.AfterImport(Success: Boolean);
begin
  if Success then begin
    ShowInfo(FSImportSuccess);
    if FAutoImport then
      Close;
  end else
    ShowWarning(FSImportFail,false);
end;

procedure TBisImportForm.ActionImportExecute(Sender: TObject);
var
  Stream: TMemoryStream;
  AChecked: Boolean;
  OldCursor: TCursor;
  AConnection: TBisConnection;
  Ret: String;
  Position: Integer;
  B: TBookmark;
  Success: Boolean;
begin
  if not FImporting then begin
    if ComboBoxConnections.ItemIndex<>-1 then begin
      AConnection:=TBisConnection(ComboBoxConnections.Items.Objects[ComboBoxConnections.ItemIndex]);
      if Assigned(AConnection) then begin
        OldCursor:=Screen.Cursor;
        Screen.Cursor:=crHourGlass;
        FImporting:=true;
        Success:=false;
        ComboBoxConnections.Enabled:=false;
        B:=FDataSet.GetBookmark;
        Stream:=TMemoryStream.Create;
        FInterrupted:=false;
        Progress(0,0,0,FInterrupted);
        try
          AConnection.Connect;
          if AConnection.Connected then begin
            Position:=1;
            Progress(0,FDataSet.RecordCount,0,FInterrupted);
            if not FDataSet.IsEmpty then
              Success:=true;
            FDataSet.First;
            while not FDataSet.Eof do begin

              Ret:='';
              Stream.Clear;
              TBlobField(FDataSet.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;

              AChecked:=false;
              try
                AConnection.Import(TBisConnectionImportType(FDataSet.FieldByName(SFieldType).AsInteger),Stream);
                AChecked:=true;
              except
                on E: Exception do begin
                  Ret:=E.Message;
                end;
              end;

              Success:=Success and AChecked;

              FDataSet.Edit;
              FDataSet.FieldByName(SFieldChecked).Value:=Integer(AChecked);
              FDataSet.FieldByName(SFieldResult).Value:=Ret;
              FDataSet.Post;

              FDataSet.Next;
              Progress(0,FDataSet.RecordCount,Position,FInterrupted);

              Application.ProcessMessages;
              if FInterrupted then
                break;

              Inc(Position)
            end;
            AConnection.Disconnect;
          end;
        finally
          Progress(0,0,0,FInterrupted);
          Stream.Free;
          if Assigned(B) and FDataSet.BookmarkValid(B) then
            FDataSet.GotoBookmark(B);
          ComboBoxConnections.Enabled:=true;
          FImporting:=false;
          Screen.Cursor:=OldCursor;
          AfterImport(Success);
        end;
      end;
    end;
  end;
end;

procedure TBisImportForm.GridDblClick(Sender: TObject);
begin
  ActionInfo.Execute;
end;

procedure TBisImportForm.ActionConnectionExecute(Sender: TObject);
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
        Form.DisableConnections;
        if Form.ShowModal=mrOk then begin
        end;
      finally
        Form.Free;
      end;
    end;
  end;
end;

procedure TBisImportForm.LoadFromFile(const FileName: String);
var
  P: TBisDataSet;
begin
  try
    P:=TBisDataSet.Create(nil);
    try
      P.LoadFromFile(FileName);
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
  except
    On E: Exception do
      ShowError(E.Message);
  end;
end;

procedure TBisImportForm.ActionLoadExecute(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    LoadFromFile(OpenDialog.FileName);
  end;
end;


end.