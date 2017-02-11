unit CDSDesignEh;

{$I EhLib.Inc}

interface

uses
  Windows, Messages, SysUtils,
{$IFDEF EH_LIB_6} Variants, DesignEditors, DesignIntf, DesignWindows,
          {$ELSE} DsgnIntf,  DsgnWnds, {$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, DSDesign, Menus, DB, StdCtrls, DBCtrls, ExtCtrls, Grids,
  DBGridEh, ComCtrls, DsnDBCst,  DBClient,
  Buttons, ActnList, CDSEdit, DBGridEhImpExp;

type
  TCliDataSetFieldsEditorEh = class(TFieldsEditor)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGridEh1: TDBGridEh;
    TabSheet3: TTabSheet;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    ActionList1: TActionList;
    actFetchParams: TAction;
    actAssignLocalData: TAction;
    actLoadFromMyBaseTable: TAction;
    actCreateDataSet: TAction;
    actSaveToMyBaseXmlTable: TAction;
    actSaveToMyBaseXmlUTF8Table: TAction;
    actSaveToBinaryMyBaseTable: TAction;
    actClearData: TAction;
    GridMenu: TPopupMenu;
    GridCut: TMenuItem;
    GridCopy: TMenuItem;
    GridPaste: TMenuItem;
    GridDelete: TMenuItem;
    GridSelectAll: TMenuItem;
    procedure actFetchParamsExecute(Sender: TObject);
    procedure actAssignLocalDataExecute(Sender: TObject);
    procedure actLoadFromMyBaseTableExecute(Sender: TObject);
    procedure actCreateDataSetExecute(Sender: TObject);
    procedure actSaveToMyBaseXmlTableExecute(Sender: TObject);
    procedure actSaveToMyBaseXmlUTF8TableExecute(Sender: TObject);
    procedure actSaveToBinaryMyBaseTableExecute(Sender: TObject);
    procedure actClearDataExecute(Sender: TObject);
    procedure actCreateDataSetUpdate(Sender: TObject);
    procedure SelectTable(Sender: TObject);
    procedure GridCutClick(Sender: TObject);
    procedure GridCopyClick(Sender: TObject);
    procedure GridPasteClick(Sender: TObject);
    procedure GridDeleteClick(Sender: TObject);
    procedure GridSelectAllClick(Sender: TObject);
    procedure DBGridEh1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

  TCliDataSetEditorEh = class(TComponentEditor{$IFDEF LINUX}, IDesignerThreadAffinity{$ENDIF})
  protected
    function GetDSDesignerClass: TDSDesignerClass; virtual;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
{$IFDEF LINUX}
    procedure Edit; override;
    {IDesignerThreadAffinity}
    function GetThreadAffinity: TThreadAffinity;
{$ENDIF}
  end;

procedure ShowFieldsEditorEh(Designer: IDesigner; ADataset: TDataset;
  DesignerClass: TDSDesignerClass);
function CreateFieldsEditorEh(Designer: IDesigner; ADataset: TDataset;
  DesignerClass: TDSDesignerClass; var Shared: Boolean): TFieldsEditor;

//function CreateUniqueName(Dataset: TDataset; const FieldName: string;
//  FieldClass: TFieldClass; Component: TComponent): string;

var
  CliDataSetFieldsEditorEh: TCliDataSetFieldsEditorEh;

procedure Register;

implementation

uses Clipbrd;

{$R *.dfm}

{ Utility functions }

procedure ShowFieldsEditorEh(Designer: IDesigner; ADataset: TDataset;
  DesignerClass: TDSDesignerClass);
var
  FieldsEditor: TFieldsEditor;
  vShared: Boolean;
begin
  FieldsEditor := CreateFieldsEditorEh(Designer, ADataSet, DesignerClass, vShared);
  if FieldsEditor <> nil then
    FieldsEditor.Show;
end;

function CreateFieldsEditorEh(Designer: IDesigner; ADataset: TDataset;
  DesignerClass: TDSDesignerClass; var Shared: Boolean): TFieldsEditor;
begin
  Shared := True;
  if ADataset.Designer <> nil then
  begin
    Result := (ADataset.Designer as TDSDesigner).FieldsEditor;
  end
  else
  begin
    Result := TCliDataSetFieldsEditorEh.Create(Application);
    Result.DSDesignerClass := DesignerClass;
{$IFDEF EH_LIB_6}
    Result.Designer := Designer;
{$ELSE}
    Result.Form := Designer.Form;
{$ENDIF}
    Result.Dataset := ADataset;
    Shared := False;
  end;
end;


{ TDataSetEditor }

function TCliDataSetEditorEh.GetDSDesignerClass: TDSDesignerClass;
begin
  Result := TDSDesigner;
end;

procedure TCliDataSetEditorEh.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:
      ShowFieldsEditorEh(Designer, TDataSet(Component), GetDSDesignerClass);
    1:
      begin
        TClientDataSet(Component).FetchParams;
        Designer.Modified;
      end;
    2:
      if EditClientDataSet(TClientDataSet(Component),Designer)
        then Designer.Modified;

    3:
      if LoadFromFile(TClientDataSet(Component))
        then Designer.Modified;
  else
    if TDataSet(Component).Active then
      case Index of
        4: SaveToFile(TClientDataSet(Component) {$IFDEF EH_LIB_6},dfXML{$ENDIF} );
        5: SaveToFile(TClientDataSet(Component) {$IFDEF EH_LIB_6},dfXMLUTF8{$ENDIF} );
        6: SaveToFile(TClientDataSet(Component) {$IFDEF EH_LIB_6},dfBinary{$ENDIF} );
        7:
          begin
            TClientDataSet(Component).Close;
            TClientDataSet(Component).FieldDefs.Clear;
            Designer.Modified;
          end;
      end
    else if ((TDataSet(Component).FieldCount > 0) or
             (TDataSet(Component).FieldDefs.Count > 0)) and
            not TDataSet(Component).Active
    then
      case Index of
        4:
          begin
            TClientDataSet(Component).CreateDataSet;
            Designer.Modified;
          end;
      end
  end;
end;

function TCliDataSetEditorEh.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Fields Editor...';
    1: Result := 'Fetch Params';
    2: Result := 'Assign Local Data...';
    3: Result := 'Load from MyBase table...';
  else
    if TDataSet(Component).Active then
      case Index of
        4: Result := 'Save to MyBase Xml table...';
        5: Result := 'Save to MyBase Xml UTF8 table...';
        6: Result := 'Save to binary MyBase table...';
        7: Result := 'Clear Data';
      end
    else if ((TDataSet(Component).FieldCount > 0) or
             (TDataSet(Component).FieldDefs.Count > 0)) and
            not TDataSet(Component).Active
    then
      case Index of
        4: Result := 'Create DataSet';
      end
  end;
end;

function TCliDataSetEditorEh.GetVerbCount: Integer;
begin
  if TDataSet(Component).Active then
    Result := 8
  else if ((TDataSet(Component).FieldCount > 0) or
           (TDataSet(Component).FieldDefs.Count > 0)) and
          not TDataSet(Component).Active
  then
    Result := 5
  else
    Result := 4;

end;

{$IFDEF LINUX}
function TCliDataSetEditorEh.GetThreadAffinity: TThreadAffinity;
begin
  Result  := taQT;
end;

procedure TCliDataSetEditorEh.Edit;
begin
  ShowFieldsEditorEh(Designer, TDataSet(Component), GetDSDesignerClass);
end;

{$ENDIF}

procedure Register;
begin
    // Ampy table
  // Fields Editor...
  // Fetch Params
  // Assign Local Data...
  // Load from MyBase table...

    // Ampy table with created fields
  // Fields Editor...
  // Fetch Params
  // Assign Local Data...
  // Load from MyBase table...
  //
  // Create DataSet

    // Ampy table with created fields and created table
  // Fields Editor...
  // Fetch Params
  // Assign Local Data...
  // Load from MyBase table...
  //
  // Save to MyBase Xml table...
  // Save to MyBase Xml UTF8 table...
  // Save to binary MyBase table...
  // Clear Data

  { Database Components are excluded from the STD SKU }
  if GDAL <> LongWord(-16) then
    RegisterComponentEditor(TClientDataSet, TCliDataSetEditorEh);
end;

{ TCliDataSetFieldsEditorEh }

constructor TCliDataSetFieldsEditorEh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AggListBox.Parent := TabSheet1;
  FieldListBox.Parent := TabSheet1;
  Splitter1.Parent := TabSheet1;
  Splitter1.Top := 0;
  DBNavigator.VisibleButtons := [nbFirst..nbRefresh];
  PopupMenu := nil;
  FieldListBox.PopupMenu := LocalMenu;
  SpeedButton1.Align := alTop;
  SpeedButton2.Align := alTop;
  SpeedButton3.Align := alTop;
  SpeedButton4.Align := alTop;
  SpeedButton5.Align := alTop;
  SpeedButton6.Align := alTop;
  SpeedButton7.Align := alTop;
  SpeedButton8.Align := alTop;
end;

procedure TCliDataSetFieldsEditorEh.actFetchParamsExecute(Sender: TObject);
begin
  TClientDataSet(Dataset).FetchParams;
  Designer.Modified;
end;

procedure TCliDataSetFieldsEditorEh.actAssignLocalDataExecute(
  Sender: TObject);
begin
  if EditClientDataSet(TClientDataSet(Dataset),Designer)
    then Designer.Modified;
end;

procedure TCliDataSetFieldsEditorEh.actLoadFromMyBaseTableExecute(
  Sender: TObject);
begin
  if LoadFromFile(TClientDataSet(Dataset))
    then Designer.Modified;
end;

procedure TCliDataSetFieldsEditorEh.actCreateDataSetExecute(
  Sender: TObject);
begin
  TClientDataSet(Dataset).CreateDataSet;
  Designer.Modified;
end;

procedure TCliDataSetFieldsEditorEh.actSaveToMyBaseXmlTableExecute(Sender: TObject);
begin
  SaveToFile(TClientDataSet(Dataset) {$IFDEF EH_LIB_6},dfXML{$ENDIF} );
end;

procedure TCliDataSetFieldsEditorEh.actSaveToMyBaseXmlUTF8TableExecute(
  Sender: TObject);
begin
  SaveToFile(TClientDataSet(Dataset) {$IFDEF EH_LIB_6},dfXMLUTF8{$ENDIF} );
end;

procedure TCliDataSetFieldsEditorEh.actSaveToBinaryMyBaseTableExecute(
  Sender: TObject);
begin
  SaveToFile(TClientDataSet(Dataset) {$IFDEF EH_LIB_6},dfBinary{$ENDIF} );
end;

procedure TCliDataSetFieldsEditorEh.actClearDataExecute(Sender: TObject);
begin
  TClientDataSet(Dataset).Close;
  TClientDataSet(Dataset).FieldDefs.Clear;
  Designer.Modified;
end;

procedure TCliDataSetFieldsEditorEh.actCreateDataSetUpdate(
  Sender: TObject);
begin
  actCreateDataSet.Enabled := ((Dataset.FieldCount > 0) or
                               (Dataset.FieldDefs.Count > 0)) and
                              not Dataset.Active;
  actSaveToMyBaseXmlTable.Enabled := Dataset.Active;
  actSaveToMyBaseXmlUTF8Table.Enabled := Dataset.Active;
  actSaveToBinaryMyBaseTable.Enabled := Dataset.Active;
  actClearData.Enabled := Dataset.Active;
end;

procedure TCliDataSetFieldsEditorEh.SelectTable(Sender: TObject);
var
  I: Integer;
begin
  FieldListBox.ItemIndex := 0;
  with FieldListBox do
    for I := 0 to Items.Count - 1 do
      if Selected[I] then Selected[I] := False;
  Activated;   //UpdateSelection;
  case PageControl1.ActivePageIndex of
    0: FieldListBox.SetFocus;
    1: DBGridEh1.SetFocus;
  end;
end;

procedure TCliDataSetFieldsEditorEh.GridCutClick(Sender: TObject);
begin
  DBGridEh_DoCutAction(DBGridEh1,False);
end;

procedure TCliDataSetFieldsEditorEh.GridCopyClick(Sender: TObject);
begin
  DBGridEh_DoCopyAction(DBGridEh1,False);
end;

procedure TCliDataSetFieldsEditorEh.GridPasteClick(Sender: TObject);
begin
  DBGridEh_DoPasteAction(DBGridEh1,False);
end;

procedure TCliDataSetFieldsEditorEh.GridDeleteClick(Sender: TObject);
begin
  DBGridEh_DoDeleteAction(DBGridEh1,False);
end;

procedure TCliDataSetFieldsEditorEh.GridSelectAllClick(Sender: TObject);
begin
  DBGridEh1.Selection.SelectAll;
end;

procedure TCliDataSetFieldsEditorEh.DBGridEh1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var Pos: TPoint;
begin
  if not ((DBGridEh1.InplaceEditor <> nil) and
          (DBGridEh1.InplaceEditor.Visible)) then
  begin
    GridCut.Enabled := (DBGridEh1.Selection.SelectionType <> gstNon);
    GridCopy.Enabled := (DBGridEh1.Selection.SelectionType <> gstNon);
    GridPaste.Enabled := Clipboard.HasFormat(CF_VCLDBIF) or
                         Clipboard.HasFormat(CF_TEXT);
    GridDelete.Enabled := (DBGridEh1.Selection.SelectionType <> gstNon);
    GridSelectAll.Enabled := (DBGridEh1.Selection.SelectionType <> gstAll);
    Pos := DBGridEh1.ClientToScreen(MousePos);
    GridMenu.Popup(Pos.X,Pos.Y);
  end;
end;

end.

