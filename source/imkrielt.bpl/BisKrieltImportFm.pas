unit BisKrieltImportFm;
                                                                                                              
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, DBGrids, ComCtrls, Menus, ActnPopup,
  DB, DBCtrls, CheckLst, Contnrs,

  BisFm, BisKrieltDataParamEditFm, BisIfaces, BisProvider, BisControls;

type
{  TDBGrid=class(DBGrids.TDBGrid)
  end;}

  TBisKrieltImportForm = class(TBisForm)
    PanelGeneral: TPanel;
    PanelPreview: TPanel;
    GroupBoxPreview: TGroupBox;
    PanelPreviewBottom: TPanel;
    PanelGridPreview: TPanel;
    GridPreview: TDBGrid;
    StatusBar: TStatusBar;
    ButtonImport: TButton;
    OpenDialogExcel: TOpenDialog;
    PopupActionBarPreview: TPopupActionBar;
    MenuItemDelete: TMenuItem;
    N2: TMenuItem;
    MenuItemClear: TMenuItem;
    DataSourcePreview: TDataSource;
    PanelGeneralLeft: TPanel;
    GroupBoxGeneralLeft: TGroupBox;
    PanelGeneralClient: TPanel;
    GroupBoxPresentation: TGroupBox;
    EditPresentation: TEdit;
    ButtonPresentation: TButton;
    GridPresentation: TDBGrid;
    DataSourcePresentation: TDataSource;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelView: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelOperation: TLabel;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    DateTimePickerTimeBegin: TDateTimePicker;
    DateTimePickerDateBegin: TDateTimePicker;
    LabelDateBegin: TLabel;
    LabelNext: TLabel;
    ComboBoxNext: TComboBox;
    Timer: TTimer;
    Navigator: TDBNavigator;
    N3: TMenuItem;
    MenuItemRefresh: TMenuItem;
    N4: TMenuItem;
    MenuItemAddVariant: TMenuItem;
    CheckBoxTimer: TCheckBox;
    LabelCount: TLabel;
    ButtonIssue: TButton;
    CheckListBoxPublishing: TCheckListBox;
    LabelPublishing: TLabel;
    ButtonCancel: TButton;
    ButtonLoad: TButton;
    LabelDesign: TLabel;
    EditDesign: TEdit;
    ButtonDesign: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelColor: TLabel;
    procedure ButtonLoadClick(Sender: TObject);
    procedure PopupActionBarPreviewPopup(Sender: TObject);
    procedure MenuItemDeleteClick(Sender: TObject);
    procedure MenuItemClearClick(Sender: TObject);
    procedure GridPreviewDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ButtonPresentationClick(Sender: TObject);
    procedure ButtonAccountClick(Sender: TObject);
    procedure ButtonViewClick(Sender: TObject);
    procedure ButtonTypeClick(Sender: TObject);
    procedure ButtonOperationClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure GridPreviewEditButtonClick(Sender: TObject);
    procedure GridPresentationDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure MenuItemRefreshClick(Sender: TObject);
    procedure MenuItemAddVariantClick(Sender: TObject);
    procedure ButtonImportClick(Sender: TObject);
    procedure CheckBoxTimerClick(Sender: TObject);
    procedure GridPresentationCellClick(Column: TColumn);
    procedure GridPresentationColEnter(Sender: TObject);
    procedure GridPresentationColExit(Sender: TObject);
    procedure GridPresentationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridPresentationEditButtonClick(Sender: TObject);
    procedure ButtonIssueClick(Sender: TObject);
    procedure CheckListBoxPublishingDblClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonDesignClick(Sender: TObject);
  private
    FPresentation: TBisProvider;
    FPreview: TBisProvider;
    FEditPriority: TEditInteger;

    FFirstGroupBoxPreviewCaption: String;
    FPresentationId: Variant;
    FAccountId: Variant;
    FViewId: Variant;
    FViewNum: String;
    FTypeId: Variant;
    FTypeNum: String;
    FOperationId: Variant;
    FOperationNum: String;
    FDesignId: Variant;
    FDesignNum: String;
    FIssueId: Variant;
    FLoading: Boolean;

    FLastFileName: String;
    FSNeedControlValue: String;

    procedure LoadExcel(FileName: String);
    procedure UpdateCaptionByFileName(FileName: String);
    procedure ReloadPresentation;
    procedure RecreatePreview;
    function GetDateTimeBegin: TDateTime;
    function GetDateTimeEnd: TDateTime;
    procedure RealignGridPreviewByIndex(Index: Integer);
    procedure RealignGridPreview;
    procedure GetColumnListByParamId(List: TList; ParamId: Variant);
    procedure GetColumnListByColumnId(List: TList; ColumnId: Variant);
    procedure UpdateButtons;
    procedure RefreshValues;
    procedure Import;
    procedure UpdateLabelCount;
    procedure FieldSetText(Sender: TField; const Text: string);
    procedure EditByValue(AColumnId: String; Value: Variant);
    procedure RefreshCheckListboxPublishing;
    procedure SetPublishingId(PublishingId: Variant);
    procedure PreviewAfterDelete(DataSet: TDataSet);
    procedure PreviewAfterClose(DataSet: TDataSet);
    procedure PreviewAfterInsert(DataSet: TDataSet);
    procedure PresentationAfterScroll(DataSet: TDataSet);
    procedure PresentationAfterInsert(DataSet: TDataSet);
    function CheckImport(var Breaked: Boolean): Boolean;
    procedure AlignColumnsWidth(Grid: TDBGrid);
    procedure RefreshViews(List: TObjectList);
    procedure RefreshDesigns(List: TObjectList);
    procedure SetDepends(ACurrentColumn: TColumn; ParamValueId: Variant; WithMode,CheckNull: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisKrieltImportFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisKrieltImportForm: TBisKrieltImportForm;

implementation

{$R *.dfm}

uses DateUtils, StrUtils, Themes,
     ActiveX, ComObj,
     BisUtils, BisKrieltDataPresentationsFm, BisFilterGroups, BisKrieltDataPresentationEditFm,
     BisKrieltDataViewsFm, BisKrieltDataViewTypesFm, BisKrieltDataTypeOperationsFm,
     BisKrieltDataIssuesFm, BisConsts, BisKrieltDataParamValuesFm, BisKrieltDataParamValueDependsFm,
     BisKrieltDataDesignsFm,
     BisCore, BisDataFm, BisKrieltConsts, BisDialogs, BisParams;

type
  TBisOperationInfo=class(TObject)
  public
    var OperationId: Variant;
    var OperationName: String;
    var OperationNum: String;
  end;

  TBisOperationInfos=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisOperationInfo;
  public
    function AddOperation(OperationId: Variant; OperationName, OperationNum: String): TBisOperationInfo;

    property Items[Index: Integer]: TBisOperationInfo read GetItem; default;
  end;

  TBisTypeInfo=class(TObject)
  private
    FOperations: TBisOperationInfos;
  public
    var TypeId: Variant;
    var TypeName: String;
    var TypeNum: String;

    constructor Create;
    destructor Destroy; override;

    property Operations: TBisOperationInfos read FOperations;
  end;

  TBisTypeInfos=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisTypeInfo;
  public
    function AddType(TypeId: Variant; TypeName, TypeNum: String): TBisTypeInfo;

    property Items[Index: Integer]: TBisTypeInfo read GetItem; default;
  end;

  TBisViewInfo=class(TObject)
  private
    FTypes: TBisTypeInfos;
  public
    var ViewId: Variant;
    var ViewName: String;
    var ViewNum: String;

    constructor Create;
    destructor Destroy; override;

    property Types: TBisTypeInfos read FTypes;
  end;

  TBisViewInfos=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisViewInfo;
  public
    function AddView(ViewId: Variant; ViewName, ViewNum: String): TBisViewInfo;

    property Items[Index: Integer]: TBisViewInfo read GetItem; default;
  end;

{ TBisOperationInfos }

function TBisOperationInfos.AddOperation(OperationId: Variant; OperationName, OperationNum: String): TBisOperationInfo;
begin
  Result:=TBisOperationInfo.Create;
  Result.OperationId:=OperationId;
  Result.OperationName:=OperationName;
  Result.OperationNum:=OperationNum;
  inherited Add(Result);
end;

function TBisOperationInfos.GetItem(Index: Integer): TBisOperationInfo;
begin
  Result:=TBisOperationInfo(inherited Items[Index]);
end;

{ TBisTypeInfo }

constructor TBisTypeInfo.Create;
begin
  inherited Create;
  FOperations:=TBisOperationInfos.Create;
end;

destructor TBisTypeInfo.Destroy;
begin
  FOperations.Free;
  inherited Destroy;
end;

{ TBisTypeInfos }

function TBisTypeInfos.AddType(TypeId: Variant; TypeName, TypeNum: String): TBisTypeInfo;
begin
  Result:=TBisTypeInfo.Create;
  Result.TypeId:=TypeId;
  Result.TypeName:=TypeName;
  Result.TypeNum:=TypeNum;
  inherited Add(Result);
end;

function TBisTypeInfos.GetItem(Index: Integer): TBisTypeInfo;
begin
  Result:=TBisTypeInfo(inherited Items[Index]);
end;

{ TBisViewInfo }

constructor TBisViewInfo.Create;
begin
  inherited Create;
  FTypes:=TBisTypeInfos.Create;
end;

destructor TBisViewInfo.Destroy;
begin
  FTypes.Free;
  inherited Destroy;
end;

{ TBisViewInfos }

function TBisViewInfos.AddView(ViewId: Variant; ViewName, ViewNum: String): TBisViewInfo;
begin
  Result:=TBisViewInfo.Create;
  Result.ViewId:=ViewId;
  Result.ViewName:=ViewName;
  Result.ViewNum:=ViewNum;
  inherited Add(Result);
end;

function TBisViewInfos.GetItem(Index: Integer): TBisViewInfo;
begin
  Result:=TBisViewInfo(inherited Items[Index]);
end;

type
  TBisDesignInfo=class(TObject)
  public
    var DesignId: Variant;
    var DesignName: String;
    var DesignNum: String;
  end;

  TBisDesignInfos=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisDesignInfo;
  public
    function AddDesign(DesignId: Variant; DesignName, DesignNum: String): TBisDesignInfo;

    property Items[Index: Integer]: TBisDesignInfo read GetItem; default;
  end;


{ TBisDesignInfos }

function TBisDesignInfos.AddDesign(DesignId: Variant; DesignName, DesignNum: String): TBisDesignInfo;
begin
  Result:=TBisDesignInfo.Create;
  Result.DesignId:=DesignId;
  Result.DesignName:=DesignName;
  Result.DesignNum:=DesignNum;
  inherited Add(Result);
end;

function TBisDesignInfos.GetItem(Index: Integer): TBisDesignInfo;
begin
  Result:=TBisDesignInfo(inherited Items[Index]);
end;


type
  TBisPublishingInfo=class(TObject)
  var
    PublishingId: Variant;
    Name: String;
    IssueId: Variant;
    Number: String;
    DateBegin: TDate;
    DateEnd: TDate;
  end;

  TBisDependInfo=class(TObject)
  public
    var ParamId: Variant;
    var ValueId: Variant;
    var Name: String;
  end;

  TBisDependInfos=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisDependInfo;
  public
    function AddDepend(ParamId, ValueId: Variant; Name: String): TBisDependInfo;

    property Items[Index: Integer]: TBisDependInfo read GetItem; default;
  end;

{ TBisDependInfos }

function TBisDependInfos.AddDepend(ParamId, ValueId: Variant; Name: String): TBisDependInfo;
begin
  Result:=TBisDependInfo.Create;
  Result.ParamId:=ParamId;
  Result.ValueId:=ValueId;
  Result.Name:=Name;
  inherited Add(Result);
end;

function TBisDependInfos.GetItem(Index: Integer): TBisDependInfo;
begin
  Result:=TBisDependInfo(inherited Items[Index]);
end;

type
  TBisValueInfo=class(TObject)
  private
    FVariants: TStringList;
    FDepends: TBisDependInfos;
  public
    var Id: Variant;
    var Name: String;
    var Description: String;
    var Export: String;

    constructor Create;
    destructor Destroy; override;

    property Variants: TStringList read FVariants;
    property Depends: TBisDependInfos read FDepends;
  end;

  TBisValueInfos=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisValueInfo;
  public
    function AddValue(Id: Variant; Name, Description, Export: String): TBisValueInfo;
    function FindByName(Name: String): TBisValueInfo;
    function FindById(Id: Variant): TBisValueInfo;
    function VariantExists(Value: String): TBisValueInfo;
    function NameExists(Name: String): Boolean;

    property Items[Index: Integer]: TBisValueInfo read GetItem; default;
  end;

{ TBisValueInfo }

constructor TBisValueInfo.Create;
begin
  inherited Create;
  FVariants:=TStringList.Create;
  FDepends:=TBisDependInfos.Create;
end;

destructor TBisValueInfo.Destroy;
begin
  FDepends.Free;
  FVariants.Free;
  inherited Destroy;
end;

{ TBisValueInfos }

function TBisValueInfos.AddValue(Id: Variant; Name, Description, Export: String): TBisValueInfo;
begin
  Result:=TBisValueInfo.Create;
  Result.Id:=Id;
  Result.Name:=Name;
  Result.Description:=Description;
  Result.Export:=Export;
  inherited Add(Result);
end;

function TBisValueInfos.GetItem(Index: Integer): TBisValueInfo;
begin
  Result:=TBisValueInfo(inherited Items[Index]);
end;

function TBisValueInfos.FindById(Id: Variant): TBisValueInfo;
var
  Item: TBisValueInfo;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if VarSameValue(Id,Item.Id) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisValueInfos.FindByName(Name: String): TBisValueInfo;
var
  Item: TBisValueInfo;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Name,Item.Name) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisValueInfos.NameExists(Name: String): Boolean;
begin
  Result:=Assigned(FindByName(Name));
end;

function TBisValueInfos.VariantExists(Value: String): TBisValueInfo;
var
  Item: TBisValueInfo;
  i: Integer;
begin
  Result:=nil;
  if Trim(Value)<>'' then
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if Item.Variants.IndexOf(Value)<>-1 then begin
        Result:=Item;
        exit;
      end;
    end;
end;

type
  TBisPreviewColumn=class(TColumn)
  private
    FColumnId: Variant;
    FHandbook: Boolean;
    FParamId: Variant;
    FParamType: TBisKrieltDataParamType;
    FValues: TBisValueInfos;
    FStringBefore: String;
    FStringAfter: String;
    FNotEmpty: Boolean;
    FUseDepend: Boolean;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    property ColumnId: Variant read FColumnId write FColumnId;
    property Handbook: Boolean read FHandbook write FHandbook;
    property ParamId: Variant read FParamId write FParamId;
    property ParamType: TBisKrieltDataParamType read FParamType write FParamType;
    property Values: TBisValueInfos read FValues;
    property StringBefore: String read FStringBefore write FStringBefore;
    property StringAfter: String read FStringAfter write FStringAfter;
    property NotEmpty: Boolean read FNotEmpty write FNotEmpty;
    property UseDepend: Boolean read FUseDepend write FUseDepend; 
  end;


{ TBisPreviewColumn }

constructor TBisPreviewColumn.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FValues:=TBisValueInfos.Create;
end;

destructor TBisPreviewColumn.Destroy;
begin
  FValues.Free;
  inherited Destroy;
end;

{ TBisKrieltImportFormIface }

constructor TBisKrieltImportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltImportForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=false;
  ShowType:=stMdiChild;
end;

{ TBisKrieltImportForm }

type
  THackGrid=class(TCustomGrid)
  end;

constructor TBisKrieltImportForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  FAccountId:=Null;
  FViewId:=Null;
  FTypeId:=Null;
  FOperationId:=Null;

  FSNeedControlValue:='���������� ��������� �������� � ���� [%s]';

  FEditPriority:=ReplaceEditToEditInteger(EditPriority);

  FPresentation:=TBisProvider.Create(Self);
  FPresentation.ProviderName:='S_COLUMNS';
  FPresentation.Orders.Add('PRIORITY');
  FPresentation.AfterScroll:=PresentationAfterScroll;
  FPresentation.AfterInsert:=PresentationAfterInsert;
  DataSourcePresentation.DataSet:=FPresentation;

  FPreview:=TBisProvider.Create(Self);
  FPreview.AfterDelete:=PreviewAfterDelete;
  FPreview.AfterClose:=PreviewAfterClose;
  FPreview.AfterInsert:=PreviewAfterInsert;
  DataSourcePreview.DataSet:=FPreview;

  FFirstGroupBoxPreviewCaption:=GroupBoxPreview.Caption;
  DateTimePickerDateBegin.Date:=DateOf(Now);
  DateTimePickerTimeBegin.Time:=TimeOf(Now);
  THackGrid(GridPresentation).Options:=THackGrid(GridPresentation).Options-[goColMoving];
  THackGrid(GridPreview).Options:=THackGrid(GridPreview).Options-[goColMoving];

  RefreshCheckListboxPublishing;
end;

destructor TBisKrieltImportForm.Destroy;
begin
  ClearStrings(CheckListBoxPublishing.Items);
  FPreview.Free;
  FPresentation.Free;
  inherited Destroy;
end;

procedure TBisKrieltImportForm.CheckBoxTimerClick(Sender: TObject);
begin
  Timer.Enabled:=CheckBoxTimer.Checked;
end;

procedure TBisKrieltImportForm.RefreshCheckListboxPublishing;
var
  P: TBisProvider;
  Obj: TBisPublishingInfo;
begin
  ClearStrings(CheckListBoxPublishing.Items);
  CheckListBoxPublishing.Items.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_PUBLISHING';
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.IsEmpty then begin
      P.First;
      while not P.Eof do begin
        Obj:=TBisPublishingInfo.Create;
        Obj.PublishingId:=P.FieldByName('PUBLISHING_ID').Value;
        Obj.Name:=P.FieldByName('NAME').AsString;
        Obj.IssueId:=Null;
        CheckListBoxPublishing.Items.AddObject(Obj.Name,Obj);
        P.Next;
      end;
    end;
  finally
    P.Free;
    CheckListBoxPublishing.Items.EndUpdate;
  end;
end;

procedure TBisKrieltImportForm.SetPublishingId(PublishingId: Variant);
var
  i: Integer;
  Obj: TBisPublishingInfo;
begin
  for i:=0 to CheckListBoxPublishing.Items.Count-1 do begin
    CheckListBoxPublishing.Checked[i]:=false;
  end;
  for i:=0 to CheckListBoxPublishing.Items.Count-1 do begin
    Obj:=TBisPublishingInfo(CheckListBoxPublishing.Items.Objects[i]);
    if Assigned(Obj) and (Obj.PublishingId=PublishingId) then begin
      CheckListBoxPublishing.Checked[i]:=true;
      break;
    end;
  end;
end;

procedure TBisKrieltImportForm.PresentationAfterInsert(DataSet: TDataSet);
begin
  DataSet.Cancel;
end;

procedure TBisKrieltImportForm.PresentationAfterScroll(DataSet: TDataSet);
begin
  GridPreview.Invalidate;
end;

procedure TBisKrieltImportForm.PreviewAfterClose(DataSet: TDataSet);
begin
  UpdateButtons;
  UpdateLabelCount;
end;

procedure TBisKrieltImportForm.PreviewAfterDelete(DataSet: TDataSet);
begin
  UpdateButtons;
  UpdateLabelCount;
end;

procedure TBisKrieltImportForm.GridPresentationCellClick(Column: TColumn);
begin
  if Column.Index<>2 then begin
    GridPresentation.Options:=GridPresentation.Options-[dgEditing];
    GridPresentation.ReadOnly:=true;
  end else begin
    GridPresentation.Options:=GridPresentation.Options+[dgEditing];
    GridPresentation.ReadOnly:=false;
  end;
end;

procedure TBisKrieltImportForm.GridPresentationColEnter(Sender: TObject);
begin
  if GridPresentation.SelectedIndex<>-1 then
    GridPresentationCellClick(GridPresentation.Columns[GridPresentation.SelectedIndex]);
end;

procedure TBisKrieltImportForm.GridPresentationColExit(Sender: TObject);
begin
  if GridPresentation.SelectedIndex<>-1 then
    GridPresentationCellClick(GridPresentation.Columns[GridPresentation.SelectedIndex]);
end;

procedure TBisKrieltImportForm.GridPresentationDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  OldBrush: TBrush;
  AGrid: TDbGrid;
  Checked: Boolean;
  rt: TRect;
  Details: TThemedElementDetails;
begin
  AGrid:=TDbGrid(Sender);
  if FPresentation.Active and not FPresentation.IsEmpty  then begin
    if (Column.Index<=AGrid.Columns.Count-2) then begin
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
    end else begin
      rt.Right:=rect.Right;
      rt.Left:=rect.Left;
      rt.Top:=rect.Top+2;
      rt.Bottom:=rect.Bottom-2;
      Checked:=Boolean(FPresentation.FieldByName('VISIBLE').AsInteger);
      if not ThemeServices.ThemesEnabled then begin
        if not Checked then
          DrawFrameControl(GridPresentation.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK)
        else
          DrawFrameControl(GridPresentation.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
      end else begin
        Details:=ThemeServices.GetElementDetails(TThemedButton(iff(Checked,tbCheckBoxCheckedNormal,tbCheckBoxUncheckedNormal)));
        ThemeServices.DrawElement(AGrid.Canvas.Handle,Details,Rect);
      end;
    end;
  end;
end;

procedure TBisKrieltImportForm.GridPresentationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE) and (ssCtrl in Shift) then
    Key:=0;
end;

procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment; ARightToLeft: Boolean);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
  RTL: array [Boolean] of Integer = (0, DT_RTLREADING);
var
//  B, R: TRect;
  {Hold, }Left: Integer;
  I: TColorRef;
begin
  I := ColorToRGB(ACanvas.Brush.Color);
  if GetNearestColor(ACanvas.Handle, I) = I then
  begin                       { Use ExtTextOut for solid colors }
    { In BiDi, because we changed the window origin, the text that does not
      change alignment, actually gets its alignment changed. }
    if (ACanvas.CanvasOrientation = coRightToLeft) and (not ARightToLeft) then
      ChangeBiDiModeAlignment(Alignment);
    case Alignment of
      taLeftJustify:
        Left := ARect.Left + DX;
      taRightJustify:
        Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
    else { taCenter }
      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
        - (ACanvas.TextWidth(Text) shr 1);
    end;
    ACanvas.TextRect(ARect, Left, ARect.Top + DY, Text);
  end
  else begin                  { Use FillRect and Drawtext for dithered colors }
    //
  end;
end;

type
  THackDBGrid=class(TDBGrid)
  end;

procedure TBisKrieltImportForm.GridPreviewDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  AGrid: TDBGrid;

  procedure DefaultDraw;
  var
    OldBrush: TBrush;
  begin
    if (gdSelected in State) then begin
      OldBrush:=TBrush.Create;
      OldBrush.Assign(AGrid.Canvas.Brush);
      try
        AGrid.Canvas.Brush.Color:=clGray;
        AGrid.Canvas.FillRect(Rect);
        WriteText(AGrid.Canvas, Rect, 2, 2, Column.Field.Text, Column.Alignment,
                  THackDBGrid(AGrid).UseRightToLeftAlignmentForField(Column.Field, Column.Alignment));
        if (gdFocused in State) then
          AGrid.Canvas.DrawFocusRect(Rect);
      finally
        AGrid.Canvas.Brush.Assign(OldBrush);
        OldBrush.Free;
      end;
    end else
      AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;

  function GetFontColor: TColor;
  begin
    Result:=clWindowText;
    if Column.FieldName='PRIORITY' then
      Result:=FEditPriority.Font.Color;
    if Column.FieldName='VIEW_NUM' then
      Result:=EditView.Font.Color;
    if Column.FieldName='TYPE_NUM' then
      Result:=EditType.Font.Color;
    if Column.FieldName='OPERATION_NUM' then
      Result:=EditOperation.Font.Color;
    if Column.FieldName='DESIGN_NUM' then
      Result:=EditDesign.Font.Color;
  end;

var
  AColumn: TBisPreviewColumn;
  ColumnId: String;
  Value: String;
  OldBrush: TBrush;
begin
  AGrid:=TDBGrid(Sender);
  if Assigned(Column) then begin
    if not (Column is TBisPreviewColumn) then begin
      if not (gdSelected in State) then begin
        OldBrush:=TBrush.Create;
        OldBrush.Assign(AGrid.Canvas.Brush);
        try
          AGrid.Canvas.Brush.Color:=LabelColor.Color;
          AGrid.Canvas.FillRect(Rect);
          AGrid.Canvas.Font.Color:=GetFontColor;
          WriteText(AGrid.Canvas, Rect, 2, 2, Column.Field.Text, Column.Alignment,
                    THackDBGrid(AGrid).UseRightToLeftAlignmentForField(Column.Field, Column.Alignment));
        finally
          AGrid.Canvas.Brush.Assign(OldBrush);
          OldBrush.Free;
        end;
      end else
        DefaultDraw;
    end else begin
      AColumn:=TBisPreviewColumn(Column);
      if FPresentation.Active and not FPresentation.IsEmpty and
         (FPreview.State<>dsInactive) then begin
        if AColumn.Handbook then begin
          if FPreview.Active and not FPreview.IsEmpty then begin
            Value:=AColumn.Field.AsString;
            if not AColumn.Values.NameExists(Value) then
              AGrid.Canvas.Font.Color:=clRed
            else begin
              if gdSelected in State then
                AGrid.Canvas.Font.Color:=clHighlightText
              else
                AGrid.Canvas.Font.Color:=clWindowText;
            end;
          end;
        end;
      end;
      ColumnId:=FPresentation.FieldByName('COLUMN_ID').AsString;
      with AGrid.Canvas do begin
        if AnsiSameText(AColumn.ColumnId,ColumnId) then begin
          Brush.Color:=clInfoBk;
        end;
      end;
      DefaultDraw;
    end;
  end;
end;

procedure TBisKrieltImportForm.ButtonAccountClick(Sender: TObject);
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
  P: TBisProvider;
begin
  AClass:=Core.FindIfaceClass(SIfaceClassDataAccountsFormIface);
  if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
    AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
    P:=TBisProvider.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=FAccountId;
      if AIface.SelectInto(P) then begin
        FAccountId:=P.FieldByName('ACCOUNT_ID').Value;
        EditAccount.Text:=P.FieldByName('USER_NAME').AsString;
      end;
    finally
      P.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisKrieltImportForm.ButtonIssueClick(Sender: TObject);
var
  AIface: TBisKrieltDataIssuesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataIssuesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='ISSUE_ID';
    AIface.LocateValues:=FIssueId;
    if AIface.SelectInto(P) then begin
      CheckBoxTimer.Checked:=false;
      CheckBoxTimerClick(CheckBoxTimer);
      FIssueId:=P.FieldByName('ISSUE_ID').Value;
      DateTimePickerDateBegin.Date:=DateOf(P.FieldByName('DATE_BEGIN').AsDateTime);
      DateTimePickerTimeBegin.Time:=TimeOf(NullDate);
      ComboBoxNext.ItemIndex:=6;
      SetPublishingId(P.FieldByName('PUBLISHING_ID').Value);
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltImportForm.ButtonLoadClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  if OpenDialogExcel.Execute then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    try
      LoadExcel(OpenDialogExcel.FileName);
      RealignGridPreview;
      UpdateCaptionByFileName(OpenDialogExcel.FileName);
      FLastFileName:=OpenDialogExcel.FileName;
      UpdateButtons;
      UpdateLabelCount;
    finally
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisKrieltImportForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:=false;
  try
    DateTimePickerDateBegin.Date:=DateOf(Now);
    DateTimePickerTimeBegin.Time:=TimeOf(Now);
  finally
    Timer.Enabled:=CheckBoxTimer.Checked;
  end;
end;

procedure TBisKrieltImportForm.ButtonCancelClick(Sender: TObject);
begin
  Close;

end;

procedure TBisKrieltImportForm.ButtonDesignClick(Sender: TObject);
var
  AIface: TBisKrieltDataDesignsFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataDesignsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='DESIGN_ID';
    AIface.LocateValues:=FDesignId;
    if AIface.SelectInto(P) then begin
      FDesignId:=P.FieldByName('DESIGN_ID').Value;
      FDesignNum:=P.FieldByName('NUM').AsString;
      EditDesign.Text:=FormatEx('%s - %s',[FDesignNum,P.FieldByName('NAME').AsString]);
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltImportForm.ButtonImportClick(Sender: TObject);
var
  i: Integer;
  Flag: Boolean;
begin
  if VarIsNull(FAccountId) then begin
    ShowError(FormatEx(FSNeedControlValue,[LabelAccount.Caption]));
    EditAccount.SetFocus;
    exit;
  end;

  Flag:=false;
  for i:=0 to CheckListBoxPublishing.Items.Count-1 do begin
    if CheckListBoxPublishing.Checked[i] then begin
      Flag:=true;
      break;
    end;
  end;
  if not Flag then begin
    ShowError(FormatEx(FSNeedControlValue,[LabelPublishing.Caption]));
    CheckListBoxPublishing.SetFocus;
    exit;
  end;

  Import;
end;

procedure TBisKrieltImportForm.MenuItemClearClick(Sender: TObject);
begin
  if FPreview.Active then
    FPreview.EmptyTable;
end;

procedure TBisKrieltImportForm.MenuItemDeleteClick(Sender: TObject);
begin
  if FPreview.Active and not FPreview.IsEmpty then
    FPreview.Delete;
end;

procedure TBisKrieltImportForm.MenuItemRefreshClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  if FileExists(FLastFileName) then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    try
      LoadExcel(FLastFileName);
      RealignGridPreview;
      UpdateCaptionByFileName(FLastFileName);
      UpdateButtons;
      UpdateLabelCount;
    finally
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisKrieltImportForm.PopupActionBarPreviewPopup(Sender: TObject);
var
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  S: String;
begin
  MenuItemRefresh.Enabled:=FPreview.Active and FileExists(FLastFileName);
  MenuItemAddVariant.Enabled:=FPreview.Active and not FPreview.IsEmpty and (GridPreview.SelectedIndex<>-1);
  if MenuItemAddVariant.Enabled then begin
    Column:=GridPreview.Columns[GridPreview.SelectedIndex];
    if Assigned(Column) and (Column is TBisPreviewColumn) then begin
      AColumn:=TBisPreviewColumn(Column);
      if AColumn.Handbook then begin
        S:=FPreview.FieldByName(AColumn.FieldName).AsString;
        if Trim(S)<>'' then begin
          MenuItemAddVariant.Enabled:=not Assigned(AColumn.Values.VariantExists(S));
        end else MenuItemAddVariant.Enabled:=false;
      end else MenuItemAddVariant.Enabled:=false;
    end else begin
      MenuItemAddVariant.Enabled:=false;
    end;
  end;
  MenuItemDelete.Enabled:=FPreview.Active and not FPreview.IsEmpty;
  MenuItemClear.Enabled:=FPreview.Active;
end;

procedure TBisKrieltImportForm.UpdateCaptionByFileName(FileName: String);
begin
  if Trim(FileName)<>'' then
    GroupBoxPreview.Caption:=FormatEx('%s --> %s',[FFirstGroupBoxPreviewCaption,FileName])
  else GroupBoxPreview.Caption:=FFirstGroupBoxPreviewCaption;
end;

procedure TBisKrieltImportForm.RefreshValues;
var
  AParamId, OldParamId: Variant;
  AParamValueId: Variant;
  List: TList;
  i: Integer;
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  P: TBisProvider;
  ValueInfo: TBisValueInfo;
  Group: TBisFilterGroup;
begin
  if (GridPreview.Columns.Count>3) then begin
    List:=TList.Create;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;

      P.ProviderName:='S_PARAM_VALUES';
      with P.FieldNames do begin
        AddInvisible('PARAM_VALUE_ID');
        AddInvisible('PARAM_ID');
        AddInvisible('NAME');
        AddInvisible('DESCRIPTION');
        AddInvisible('EXPORT');
      end;
      Group:=P.FilterGroups.Add;
      for i:=0 to GridPreview.Columns.Count-1 do begin
        Column:=GridPreview.Columns.Items[i];
        if Assigned(Column) and (Column is TBisPreviewColumn) then begin
          AColumn:=TBisPreviewColumn(Column);
          AColumn.Values.Clear;
          if AColumn.Handbook then
            Group.Filters.Add('PARAM_ID',fcEqual,AColumn.ParamId).Operator:=foOr;
        end;
      end;
      with P.Orders do begin
        Add('PARAM_ID');
        Add('PRIORITY');
      end;
      P.Open;
      if P.Active and not P.Empty then begin
        OldParamId:=Null;
        P.First;
        while not P.Eof do begin
          AParamId:=P.FieldByName('PARAM_ID').Value;
          if not VarSameValue(AParamId,OldParamId) then begin
            List.Clear;
            GetColumnListByParamId(List,AParamId);
            OldParamId:=AParamId;
          end;
          for i:=0 to List.Count-1 do begin
            AColumn:=TBisPreviewColumn(List.Items[i]);
            ValueInfo:=AColumn.Values.AddValue(P.FieldByName('PARAM_VALUE_ID').Value,
                                               P.FieldByName('NAME').AsString,
                                               P.FieldByName('DESCRIPTION').AsString,
                                               P.FieldByName('EXPORT').AsString);
            ValueInfo.Variants.Add(ValueInfo.Name);
          end;
          P.Next;
        end;
      end;

      P.Close;
      P.ProviderName:='S_PARAM_VALUE_VARIANTS';
      with P.FieldNames do begin
        Clear;
        AddInvisible('PARAM_VALUE_ID');
        AddInvisible('PARAM_ID');
        AddInvisible('VALUE');
      end;
      P.FilterGroups.Clear;
      with P.Orders do begin
        Clear;
        Add('PARAM_ID');
        Add('PRIORITY');
      end;
      P.Open;
      if P.Active and not P.Empty then begin
        OldParamId:=Null;
        P.First;
        while not P.Eof do begin
          AParamId:=P.FieldByName('PARAM_ID').Value;
          AParamValueId:=P.FieldByName('PARAM_VALUE_ID').Value;
          if not VarSameValue(AParamId,OldParamId) then begin
            List.Clear;
            GetColumnListByParamId(List,AParamId);
            OldParamId:=AParamId;
          end;
          for i:=0 to List.Count-1 do begin
            AColumn:=TBisPreviewColumn(List.Items[i]);
            ValueInfo:=AColumn.Values.FindById(AParamValueId);
            if Assigned(ValueInfo) then
              ValueInfo.Variants.Add(P.FieldByName('VALUE').AsString);
          end;
          P.Next;
        end;
      end;

      P.Close;
      P.ProviderName:='S_PARAM_VALUE_DEPENDS';
      with P.FieldNames do begin
        Clear;
        AddInvisible('WHAT_PARAM_ID');
        AddInvisible('WHAT_PARAM_VALUE_ID');
        AddInvisible('FROM_PARAM_ID');
        AddInvisible('FROM_PARAM_VALUE_ID');
        AddInvisible('FROM_PARAM_VALUE_NAME');
      end;
      P.FilterGroups.Clear;
      with P.Orders do begin
        Clear;
        Add('WHAT_PARAM_ID');
        Add('WHAT_PARAM_VALUE_ID');
        Add('WHAT_PRIORITY');
      end;
      P.Open;
      if P.Active and not P.Empty then begin
        OldParamId:=Null;
        P.First;
        while not P.Eof do begin
          AParamId:=P.FieldByName('WHAT_PARAM_ID').Value;
          AParamValueId:=P.FieldByName('WHAT_PARAM_VALUE_ID').Value;
          if not VarSameValue(AParamId,OldParamId) then begin
            List.Clear;
            GetColumnListByParamId(List,AParamId);
            OldParamId:=AParamId;
          end;
          for i:=0 to List.Count-1 do begin
            AColumn:=TBisPreviewColumn(List.Items[i]);
            ValueInfo:=AColumn.Values.FindById(AParamValueId);
            if Assigned(ValueInfo) then
              ValueInfo.Depends.AddDepend(P.FieldByName('FROM_PARAM_ID').Value,
                                          P.FieldByName('FROM_PARAM_VALUE_ID').Value,
                                          P.FieldByName('FROM_PARAM_VALUE_NAME').AsString);
          end;
          P.Next;
        end;
      end;  

    finally
      P.Free;
      List.Free;
    end;
  end;
end;

procedure TBisKrieltImportForm.AlignColumnsWidth(Grid: TDBGrid);
var
  i: Integer;
  w1,w2: Integer;
  Col: TColumn;
  r: Extended;
  Flag: Boolean;
begin
  if THackGrid(Grid).ColCount>2 then begin
    w1:=0;
    for i:=0 to Grid.Columns.Count-1 do begin
      Col:=Grid.Columns.Items[i];
      Flag:=(Grid=GridPresentation) or ((Grid=GridPreview) and (Col is TBisPreviewColumn));
      if Flag and Col.Visible then
        w1:=w1+Col.Width;
    end;
    w2:=Grid.ClientWidth-THackGrid(Grid).ColWidths[0]-Grid.Columns.Count-GetSystemMetrics(SM_CYVSCROLL);

    for i:=0 to Grid.Columns.Count-1 do begin
      Col:=Grid.Columns.Items[i];
      Flag:=(Grid=GridPresentation) or ((Grid=GridPreview) and (Col is TBisPreviewColumn));
      if Flag and Col.Visible and (w1>0) then begin
        r:=w2*Col.Width/w1;
        Col.Width:=Trunc(r);
      end;
    end;
  end;
end;

procedure TBisKrieltImportForm.RecreatePreview;
var
  NewFieldName: String;
  AName: String;
  AParamType: TBisKrieltDataParamType;
  ADataType: TFieldType;
  ASize: Integer;
  Column: TColumn;
  APreviewColumn: TBisPreviewColumn;
  AParamId: Variant;
  P: TBisProvider;
  FlagSupport: Boolean;
  i: Integer;
begin
  FPreview.Close;
  FPreview.FieldDefs.Clear;
  GridPreview.Columns.Clear;
  if not VarIsNull(FPresentationId) then begin
    P:=TBisProvider.Create(nil);
    FPreview.DisableControls;
    try
      FPreview.Close;
      P.ProviderName:='S_PRESENTATION_PARAMS';
      P.FilterGroups.Add.Filters.Add('PRESENTATION_ID',fcEqual,FPresentationId);
      P.Open;
      if P.Active and not P.Empty then begin
        FPreview.FieldDefs.Add('PRIORITY',ftInteger);
        FPreview.FieldDefs.Add('VIEW_ID',ftString,32,false);
        FPreview.FieldDefs.Add('VIEW_NUM',ftString,10,false);
        FPreview.FieldDefs.Add('TYPE_ID',ftString,32,false);
        FPreview.FieldDefs.Add('TYPE_NUM',ftString,10,false);
        FPreview.FieldDefs.Add('OPERATION_ID',ftString,32,false);
        FPreview.FieldDefs.Add('OPERATION_NUM',ftString,10,false);
        FPreview.FieldDefs.Add('DESIGN_ID',ftString,32,false);
        FPreview.FieldDefs.Add('DESIGN_NUM',ftString,10,false);

        Column:=TColumn.Create(GridPreview.Columns);
        Column.FieldName:='PRIORITY';
        Column.Title.Caption:='���������';
        Column.Width:=25;

        Column:=TColumn.Create(GridPreview.Columns);
        Column.FieldName:='VIEW_NUM';
        Column.Title.Caption:='���';
        Column.ButtonStyle:=cbsEllipsis;
        Column.ReadOnly:=true;
        Column.Width:=30;

        Column:=TColumn.Create(GridPreview.Columns);
        Column.FieldName:='TYPE_NUM';
        Column.Title.Caption:='���';
        Column.ButtonStyle:=cbsEllipsis;
        Column.ReadOnly:=true;
        Column.Width:=30;

        Column:=TColumn.Create(GridPreview.Columns);
        Column.FieldName:='OPERATION_NUM';
        Column.Title.Caption:='��������';
        Column.ButtonStyle:=cbsEllipsis;
        Column.ReadOnly:=true;
        Column.Width:=30;

        Column:=TColumn.Create(GridPreview.Columns);
        Column.FieldName:='DESIGN_NUM';
        Column.Title.Caption:='����������';
        Column.ButtonStyle:=cbsEllipsis;
        Column.ReadOnly:=true;
        Column.Width:=30;

        P.First;
        while not P.Eof do begin
          AName:=P.FieldByName('PARAM_NAME').AsString;
          AParamType:=TBisKrieltDataParamType(P.FieldByName('PARAM_TYPE').AsInteger);
          AParamId:=P.FieldByName('PARAM_ID').Value;
          ASize:=P.FieldByName('MAX_LENGTH').AsInteger;

          ADataType:=ftString;
          FlagSupport:=true;
          case AParamType of
            dptList,dptString,dptLink: ADataType:=ftString;
            dptInteger: ADataType:=ftInteger;
            dptFloat: ADataType:=ftFloat;
            dptDate: ADataType:=ftDate;
            dptDateTime: ADataType:=ftDateTime;
            dptImage, dptDocument, dptVideo: FlagSupport:=false;
          else
            FlagSupport:=false;
          end;
          if FlagSupport then begin
            NewFieldName:=Format('FIELD_%d',[FPreview.FieldDefs.Count]);

            FPreview.FieldDefs.Add(NewFieldName,ADataType,ASize,false);

            APreviewColumn:=TBisPreviewColumn.Create(GridPreview.Columns);
            APreviewColumn.FieldName:=NewFieldName;
            APreviewColumn.Title.Caption:=AName;
            APreviewColumn.ButtonStyle:=iff(AParamType=dptList,cbsEllipsis,APreviewColumn.ButtonStyle);
            APreviewColumn.Width:=35;
            APreviewColumn.ColumnId:=P.FieldByName('COLUMN_ID').Value;
            APreviewColumn.ParamId:=AParamId;
            APreviewColumn.ParamType:=AParamType;
            APreviewColumn.Handbook:=AParamType=dptList;
            APreviewColumn.StringBefore:=P.FieldByName('STRING_BEFORE').AsString;
            APreviewColumn.StringAfter:=P.FieldByName('STRING_AFTER').AsString;
            APreviewColumn.NotEmpty:=Boolean(P.FieldByName('NOT_EMPTY').AsInteger);
            APreviewColumn.UseDepend:=Boolean(P.FieldByName('USE_DEPEND').AsInteger);

          end;

          P.Next;
        end;



      //  AlignColumnsWidth(GridPreview);

        FPreview.CreateTable();
        for i:=0 to FPreview.Fields.Count-1 do begin
          FPreview.Fields[i].OnSetText:=FieldSetText;
        end;

      end;
      RefreshValues;
    finally
      FPreview.EnableControls;
      P.Free;
    end;
  end;
end;

procedure TBisKrieltImportForm.ReloadPresentation;
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  FPresentation.AfterInsert:=nil;
  try
    if not VarIsNull(FPresentationId) then begin
      FPresentation.Close;
      FPresentation.FilterGroups.Clear;
      FPresentation.FilterGroups.Add.Filters.Add('PRESENTATION_ID',fcEqual,FPresentationId);
      FPresentation.Open;
      AlignColumnsWidth(GridPresentation);
      RecreatePreview;
    end;
  finally
    FPresentation.AfterInsert:=PresentationAfterInsert;
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisKrieltImportForm.ButtonPresentationClick(Sender: TObject);
var
  AIface: TBisKrieltDataPresentationsFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataPresentationsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    with AIface do begin
      FilterGroups.Add.Filters.Add('PRESENTATION_TYPE',fcEqual,ptImport);
      LocateFields:='PRESENTATION_ID';
      LocateValues:=FPresentationId;
      if SelectInto(P) then begin
        FPresentationId:=P.FieldByName('PRESENTATION_ID').Value;
        EditPresentation.Text:=P.FieldByName('NAME').AsString;
        Self.Update;
        ReloadPresentation;
        UpdateButtons;
        UpdateLabelCount;
      end;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltImportForm.ButtonViewClick(Sender: TObject);
var
  AIface: TBisKrieltDataViewsFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataViewsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='VIEW_ID';
    AIface.LocateValues:=FViewId;
    if AIface.SelectInto(P) then begin
      FViewId:=P.FieldByName('VIEW_ID').Value;
      FViewNum:=P.FieldByName('NUM').AsString;
      EditView.Text:=FormatEx('%s - %s',[FViewNum,P.FieldByName('NAME').AsString]);
      FTypeId:=Null;
      FTypeNum:='';
      EditType.Text:='';
      FOperationId:=Null;
      FOperationNum:='';
      EditOperation.Text:='';
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltImportForm.ButtonTypeClick(Sender: TObject);
var
  AIface: TBisKrieltDataViewTypesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataViewTypesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.FilterGroups.Add.Filters.Add('VIEW_ID',fcEqual,FViewId);
    AIface.LocateFields:='TYPE_ID';
    AIface.LocateValues:=FTypeId;
    if AIface.SelectInto(P) then begin
      FTypeId:=P.FieldByName('TYPE_ID').Value;
      FTypeNum:=P.FieldByName('TYPE_NUM').AsString;
      EditType.Text:=FormatEx('%s - %s',[FTypeNum,P.FieldByName('TYPE_NAME').AsString]);
      FOperationId:=Null;
      FOperationNum:='';
      EditOperation.Text:='';
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltImportForm.ButtonOperationClick(Sender: TObject);
var
  AIface: TBisKrieltDataTypeOperationsFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataTypeOperationsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.FilterGroups.Add.Filters.Add('TYPE_ID',fcEqual,FTypeId);
    AIface.LocateFields:='OPERATION_ID';
    AIface.LocateValues:=FOperationId;
    if AIface.SelectInto(P) then begin
      FOperationId:=P.FieldByName('OPERATION_ID').Value;
      FOperationNum:=P.FieldByName('OPERATION_NUM').AsString;
      EditOperation.Text:=FormatEx('%s - %s',[FOperationNum,P.FieldByName('OPERATION_NAME').AsString]);
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltImportForm.GetColumnListByParamId(List: TList; ParamId: Variant);
var
  i: Integer;
  Column: TColumn;
  AColumn: TBisPreviewColumn;
begin
  for i:=0 to GridPreview.Columns.Count-1 do begin
    Column:=GridPreview.Columns[i];
    if Assigned(Column) and (Column is TBisPreviewColumn) then begin
      AColumn:=TBisPreviewColumn(Column);
      if VarSameValue(AColumn.ParamId,ParamId) then begin
        List.Add(AColumn);
      end;
    end else begin
      //
    end;
  end;
end;

procedure TBisKrieltImportForm.GetColumnListByColumnId(List: TList; ColumnId: Variant);
var
  i: Integer;
  Column: TColumn;
  AColumn: TBisPreviewColumn;
begin
  for i:=0 to GridPreview.Columns.Count-1 do begin
    Column:=GridPreview.Columns[i];
    if Assigned(Column) and (Column is TBisPreviewColumn) then begin
      AColumn:=TBisPreviewColumn(Column);
      if VarSameValue(AColumn.ColumnId,ColumnId) then begin
        List.Add(AColumn);
      end;
    end;
  end;
end;

function TBisKrieltImportForm.GetDateTimeBegin: TDateTime;
begin
  Result:=DateOf(DateTimePickerDateBegin.Date)+TimeOf(DateTimePickerTimeBegin.Time);
end;

function TBisKrieltImportForm.GetDateTimeEnd: TDateTime;
var
  DBegin: TDateTime;
begin
  Result:=0.0;
  DBegin:=DateOf(DateTimePickerDateBegin.Date)+TimeOf(DateTimePickerTimeBegin.Time);
  case ComboBoxNext.ItemIndex of
    0: Result:=IncDay(DBegin,1);
    1: Result:=IncDay(DBegin,2);
    2: Result:=IncDay(DBegin,3);
    3: Result:=IncDay(DBegin,4);
    4: Result:=IncDay(DBegin,5);
    5: Result:=IncDay(DBegin,6);
    6: Result:=IncDay(DBegin,7);
    7: Result:=IncDay(DBegin,14);
    8: Result:=IncDay(DBegin,21);
    9: Result:=IncMonth(DBegin,1);
  end;
end;

procedure TBisKrieltImportForm.RealignGridPreviewByIndex(Index: Integer);
var
  B: TBookmark;
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  W: Integer;
  S: String;
  DW: Integer;
begin
  if Index<>-1 then begin
    Column:=GridPreview.Columns[Index];
    if Assigned(Column) and (Column is TBisPreviewColumn) then begin
      AColumn:=TBisPreviewColumn(Column);
      if Assigned(AColumn) and FPreview.Active and not FPreview.IsEmpty then begin
        DW:=3;
        if AColumn.Handbook then
          DW:=23;
        FPreview.DisableControls;
        B:=FPreview.GetBookmark;
        try
          FPreview.First;
          while not FPreview.Eof do begin
            S:=FPreview.FieldByName(AColumn.FieldName).AsString;
            W:=GridPreview.Canvas.TextWidth(S)+DW;
            if AColumn.Width<W then
              AColumn.Width:=W;
            FPreview.Next;
          end;
        finally
          if Assigned(B) and FPreview.BookmarkValid(B) then
            FPreview.GotoBookmark(B);
          FPreview.EnableControls;
        end;
      end;
    end;
  end;
end;

procedure TBisKrieltImportForm.RealignGridPreview;
var
  i: Integer;
begin
  for i:=0 to GridPreview.Columns.Count-1 do begin
    RealignGridPreviewByIndex(i);
  end;
end;

procedure TBisKrieltImportForm.EditByValue(AColumnId: String; Value: Variant);

  function GetValueByIndex(List: TList; Index: Integer; Value: Variant): Variant;
  var
    S: String;
    Ret: String;
    ID: String;
    AColumn: TBisPreviewColumn;
    Before, After: String;
    i: Integer;
    APos: Integer;
  begin
    Result:=Value;
    ID:=GetUniqueID;
    S:=VarToStrDef(Value,ID);
    if S<>ID then begin
      Ret:='';
      for i:=0 to List.Count-1 do begin
        AColumn:=TBisPreviewColumn(List.Items[i]);
        if i=0 then begin
          Before:=AColumn.StringBefore;
          After:=AColumn.StringAfter;
          if List.Count>1 then begin
            After:=After+TBisPreviewColumn(List.Items[i+1]).StringBefore;
          end;
        end else if (i=List.Count-1) then begin
          Before:=TBisPreviewColumn(List.Items[i-1]).StringAfter+AColumn.StringBefore;
          After:=AColumn.StringAfter;
        end else begin
          Before:=TBisPreviewColumn(List.Items[i-1]).StringAfter+AColumn.StringBefore;
          After:=AColumn.StringAfter+TBisPreviewColumn(List.Items[i+1]).StringBefore;
        end;
        APos:=AnsiPos(Before,S);
        if APos>0 then begin
          S:=Copy(S,APos+Length(Before),Length(S));
        end;
        APos:=AnsiPos(After,S);
        if APos>0 then begin
          Ret:=Copy(S,1,APos-Length(After));
          S:=Copy(S,APos,Length(S));
        end else begin
          Ret:=S;
          S:='';
        end;
        if i=Index then begin
          Result:=iff(Trim(Ret)<>'',Trim(Ret),Null);
          break;
        end;
      end;
    end;
  end;

var
  List: TList;
  VNew: Variant;
  i: Integer;
  AColumn: TBisPreviewColumn;
  ValueInfo: TBisValueInfo;
  S: String;
begin
  List:=TList.Create;
  try
    GetColumnListByColumnId(List,AColumnId);
    for i:=0 to List.Count-1 do begin
      AColumn:=TBisPreviewColumn(List.Items[i]);
      try
        VNew:=GetValueByIndex(List,i,Value);
        S:=Trim(VarToStrDef(VNew,''));
        case AColumn.ParamType of
          dptList: begin
            if AColumn.Handbook and not VarIsNull(VNew) then begin
              ValueInfo:=AColumn.Values.VariantExists(VarToStrDef(VNew,''));
              if Assigned(ValueInfo) then begin
                VNew:=ValueInfo.Name;
              end;
            end;
          end;
          dptInteger: begin
            if not VarIsNull(VNew) and (S<>'') then
              VNew:=VarToIntDef(VNew,0);
          end;
          dptFloat: begin
            if not VarIsNull(VNew) and (S<>'') then begin
              S:=ReplaceStr(S,'.',DecimalSeparator);
              VNew:=StrToFloatDef(S,0.0);
            end;
          end;
          dptString:;
          dptDate,dptDateTime: begin
            if not VarIsNull(VNew) and (S<>'') then begin
              VNew:=VarToDateTimeDef(VNew,NullDate);
            end;
          end;
          dptImage,dptDocument,dptVideo:;
          dptLink:;
        end;
        FPreview.FieldByName(AColumn.FieldName).Value:=VNew;
      except
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TBisKrieltImportForm.FieldSetText(Sender: TField; const Text: string);
var
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  Flag: Boolean;
  ValueInfo: TBisValueInfo;
begin
  Flag:=false;
  if FPreview.Active and not FPreview.IsEmpty and
     (GridPreview.SelectedIndex<>-1) then begin
    Column:=GridPreview.Columns[GridPreview.SelectedIndex];
    if Assigned(Column) and (Column is TBisPreviewColumn) then begin
      AColumn:=TBisPreviewColumn(Column);
      if Assigned(AColumn) and AColumn.Handbook then begin
        ValueInfo:=AColumn.Values.FindByName(Text);
        if not Assigned(ValueInfo) then begin
          ValueInfo:=AColumn.Values.VariantExists(Text);
          if Assigned(ValueInfo) then begin
            Sender.AsString:=ValueInfo.Name;
            Flag:=true;
          end;
        end;
      end;
    end else begin
      //
    end;
  end;
  if not Flag then
    Sender.AsString:=Text;
end;

procedure TBisKrieltImportForm.FormResize(Sender: TObject);
begin
  AlignColumnsWidth(GridPresentation);
end;

procedure TBisKrieltImportForm.UpdateLabelCount;
var
  ACount: Integer;
begin
  ACount:=0;
  if FPreview.Active then
    ACount:=FPreview.RecordCount;
  LabelCount.Caption:='����� �������: '+InttoStr(ACount);
  LabelCount.Update;
end;

procedure TBisKrieltImportForm.SetDepends(ACurrentColumn: TColumn; ParamValueId: Variant; WithMode, CheckNull: Boolean);
var
  List: TList;
  i,j: Integer;
  ValueInfo: TBisValueInfo;
  DependInfo: TBisDependInfo;
  AColumn: TBisPreviewColumn;
  V: Variant;
  Flag: Boolean;
begin
  if Assigned(ACurrentColumn) and (ACurrentColumn is TBisPreviewColumn) then begin
    List:=TList.Create;
    try
      AColumn:=TBisPreviewColumn(ACurrentColumn);
      ValueInfo:=AColumn.Values.FindById(ParamValueId);
      if Assigned(ValueInfo) then begin
        for i:=0 to ValueInfo.Depends.Count-1 do begin
          DependInfo:=ValueInfo.Depends[i];
          List.Clear;
          GetColumnListByParamId(List,DependInfo.ParamId);
          for j:=0 to List.Count-1 do begin
            AColumn:=TBisPreviewColumn(List.Items[j]);
            V:=FPreview.FieldByName(AColumn.FieldName).Value;
            if WithMode then
              FPreview.Edit;
            Flag:=true;  
            if CheckNull then
              Flag:=VarIsNull(V);
            if Flag then
              FPreview.FieldByName(AColumn.FieldName).AsString:=DependInfo.Name;
            if WithMode then
              FPreview.Post;
          end;
        end;
      end;
    finally
      List.Free;
    end;
  end;
end;

procedure TBisKrieltImportForm.GridPreviewEditButtonClick(Sender: TObject);
var
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  AIfaceParamValues: TBisKrieltDataParamValuesFormIface;
  AIfaceParamDepends: TBisKrieltDataParamValueDependsFormIface; 
  AIfaceClass: TBisDataFormIfaceClass;
  AIface: TBisDataFormIface;
  P: TBisProvider;
  AParamValueId: String;
  AName: String;
  FieldNameId,FieldNameNum,FieldNameParent: String;
  ValueInfo: TBisValueInfo;
begin
  if GridPreview.SelectedIndex<>-1 then begin
    Column:=GridPreview.Columns[GridPreview.SelectedIndex];
    if (Column is TBisPreviewColumn) then begin
      AColumn:=TBisPreviewColumn(Column);
      if Assigned(AColumn) and AColumn.Handbook then begin
        if not AColumn.UseDepend then begin
          AIfaceParamValues:=TBisKrieltDataParamValuesFormIface.Create(nil);
          P:=TBisProvider.Create(nil);
          try
            AIfaceParamValues.FilterGroups.Add.Filters.Add('PARAM_ID',fcEqual,AColumn.ParamId);
            AIfaceParamValues.LocateFields:='NAME';
            AIfaceParamValues.LocateValues:=FPreview.FieldByName(AColumn.FieldName).AsString;
            AIfaceParamValues.FilterOnShow:=false;
            if AIfaceParamValues.SelectInto(P) then begin
              AParamValueId:=P.FieldByName('PARAM_VALUE_ID').AsString;
              AName:=P.FieldByName('NAME').AsString;
              FPreview.Edit;
              FPreview.FieldByName(AColumn.FieldName).AsString:=AName;
              FPreview.Post;
              RealignGridPreviewByIndex(GridPreview.SelectedIndex);
            end;
          finally
            P.Free;
            AIfaceParamValues.Free;
          end;
        end else begin
          AIfaceParamDepends:=TBisKrieltDataParamValueDependsFormIface.Create(nil);
          P:=TBisProvider.Create(nil);
          try
            AIfaceParamDepends.FilterGroups.Add.Filters.Add('WHAT_PARAM_ID',fcEqual,AColumn.ParamId);
            AIfaceParamDepends.LocateFields:='WHAT_PARAM_VALUE_NAME';
            AIfaceParamDepends.LocateValues:=FPreview.FieldByName(AColumn.FieldName).AsString;
            AIfaceParamDepends.FilterOnShow:=false;
            if AIfaceParamDepends.SelectInto(P) then begin
              AParamValueId:=P.FieldByName('WHAT_PARAM_VALUE_ID').AsString;
              AName:=P.FieldByName('WHAT_PARAM_VALUE_NAME').AsString;

              FPreview.Edit;
              FPreview.FieldByName(AColumn.FieldName).AsString:=AName;
              FPreview.Post;

              ValueInfo:=AColumn.Values.FindById(AParamValueId);
              if Assigned(ValueInfo) and (ValueInfo.Depends.Count>0) then
                if ShowQuestion(Format('�������� ����� ��� ��������� %s?',[AColumn.Title.Caption]),mbNo)=mrYes then
                  SetDepends(AColumn,AParamValueId,true,false);

              RealignGridPreviewByIndex(GridPreview.SelectedIndex);
            end;
          finally
            P.Free;
            AIfaceParamDepends.Free;
          end;
        end;
      end;
    end else begin
      AIfaceClass:=nil;
      FieldNameId:='';
      FieldNameNum:=Column.FieldName;
      FieldNameParent:='';
      if AnsiSameText(Column.FieldName,'VIEW_NUM') then begin
        AIfaceClass:=TBisKrieltDataViewsFormIface;
        FieldNameId:='VIEW_ID';
        FieldNameNum:='NUM';
      end;
      if AnsiSameText(Column.FieldName,'TYPE_NUM') then begin
        AIfaceClass:=TBisKrieltDataViewTypesFormIface;
        FieldNameId:='TYPE_ID';
        FieldNameParent:='VIEW_ID';
      end;
      if AnsiSameText(Column.FieldName,'OPERATION_NUM') then begin
        AIfaceClass:=TBisKrieltDataTypeOperationsFormIface;
        FieldNameId:='OPERATION_ID';
        FieldNameParent:='TYPE_ID';
      end;
      if AnsiSameText(Column.FieldName,'DESIGN_NUM') then begin
        AIfaceClass:=TBisKrieltDataDesignsFormIface;
        FieldNameId:='DESIGN_ID';
        FieldNameNum:='NUM';
      end;
      if Assigned(AIfaceClass) then begin
        AIface:=AIfaceClass.Create(nil);
        P:=TBisProvider.Create(nil);
        try
          AIface.FilterOnShow:=false;
          if FieldNameParent<>'' then
            AIface.FilterGroups.Add.Filters.Add(FieldNameParent,fcEqual,FPreview.FieldByName(FieldNameParent).Value);
          AIface.LocateFields:=FieldNameId;
          AIface.LocateValues:=FPreview.FieldByName(FieldNameId).Value;
          if AIface.SelectInto(P) then begin
            FPreview.Edit;
            FPreview.FieldByName(FieldNameId).Value:=P.FieldByName(FieldNameId).Value;
            FPreview.FieldByName(Column.FieldName).Value:=P.FieldByName(FieldNameNum).Value;
            if AnsiSameText(FieldNameId,'VIEW_ID') then begin
              FPreview.FieldByName('TYPE_ID').Value:=Null;
              FPreview.FieldByName('TYPE_NUM').Value:=Null;
              FPreview.FieldByName('OPERATION_ID').Value:=Null;
              FPreview.FieldByName('OPERATION_NUM').Value:=Null;
            end;
            if AnsiSameText(FieldNameId,'TYPE_ID') then begin
              FPreview.FieldByName('OPERATION_ID').Value:=Null;
              FPreview.FieldByName('OPERATION_NUM').Value:=Null;
            end;
            FPreview.Post;
          end;
        finally
          P.Free;
          AIface.Free;
        end;
      end;
    end;
  end;
end;

procedure TBisKrieltImportForm.MenuItemAddVariantClick(Sender: TObject);
var
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  AIface: TBisKrieltDataParamValuesFormIface;
  SV: String;
  S: String;
  Str: TStringList;
  B: TBookmark;
  P: TBisProvider;
  PInsert: TBisProvider;
  ValueInfo: TBisValueInfo;
begin
  if GridPreview.SelectedIndex<>-1 then begin
    Column:=GridPreview.Columns[GridPreview.SelectedIndex];
    if Assigned(Column) and (Column is TBisPreviewColumn) then begin
      AColumn:=TBisPreviewColumn(Column);
      if Assigned(AColumn) and AColumn.Handbook then begin
        AIface:=TBisKrieltDataParamValuesFormIface.Create(nil);
        P:=TBisProvider.Create(nil);
        try
          AIface.FilterGroups.Add.Filters.Add('PARAM_ID',fcEqual,AColumn.ParamId);
          AIface.FilterOnShow:=false;
          AIface.LocateFields:='NAME';
          AIface.LocateValues:=FPreview.FieldByName(AColumn.FieldName).AsString;
          if AIface.SelectInto(P) then begin
            S:=P.FieldByName('NAME').AsString;
            ValueInfo:=AColumn.Values.FindByName(S);
            if not Assigned(ValueInfo) then
              ValueInfo:=AColumn.Values.AddValue(P.FieldByName('PARAM_VALUE_ID').Value,
                                                 S,
                                                 P.FieldByName('DESCRIPTION').AsString,
                                                 P.FieldByName('EXPORT').AsString);
            if Assigned(ValueInfo) then begin
              Str:=ValueInfo.Variants;
              SV:=FPreview.FieldByName(AColumn.FieldName).AsString;
              PInsert:=TBisProvider.Create(nil);
              try
                PInsert.ProviderName:='I_PARAM_VALUE_VARIANT';
                with PInsert.Params do begin
                  AddInvisible('PARAM_VALUE_ID').Value:=ValueInfo.Id;
                  AddInvisible('VALUE').Value:=SV;
                  AddInvisible('PRIORITY').Value:=Str.Count+1;
                end;
                PInsert.Execute;
              finally
                PInsert.Free;
              end;
              Str.Add(SV);
              FPreview.Edit;
              FPreview.FieldByName(AColumn.FieldName).AsString:=S;
              SetDepends(AColumn,ValueInfo.Id,false,true);
              FPreview.Post;
              FPreview.DisableControls;
              B:=FPreview.GetBookmark;
              try
                FPreview.First;
                while not FPreview.Eof do begin
                  if AnsiSameText(FPreview.FieldByName(AColumn.FieldName).AsString,SV) then begin
                    FPreview.Edit;
                    FPreview.FieldByName(AColumn.FieldName).AsString:=S;
                    SetDepends(AColumn,ValueInfo.Id,false,true);
                    FPreview.Post;
                  end;
                  FPreview.Next;
                end;
              finally
                if Assigned(B) and FPreview.BookmarkValid(B) then
                  FPreview.GotoBookmark(B);
                FPreview.EnableControls;
              end;
              RealignGridPreviewByIndex(GridPreview.SelectedIndex);
            end;
          end;
        finally
          P.Free;
          AIface.Free;
        end;
      end;
    end else begin
      //
    end;
  end;
end;

procedure TBisKrieltImportForm.UpdateButtons;
begin
  ButtonLoad.Enabled:=FPresentation.Active and
                      not FPresentation.IsEmpty and
                      FPreview.Active;
  ButtonImport.Enabled:=ButtonLoad.Enabled;
end;

procedure TBisKrieltImportForm.PreviewAfterInsert(DataSet: TDataSet);
var
  S: String;
  ColumnId: String;
  B: TBookmark;
begin
  FPreview.FieldByName('PRIORITY').Value:=iff(Trim(FEditPriority.Text)<>'',FEditPriority.Value,Null);
  if not FLoading then begin

    FPresentation.DisableControls;
    B:=FPresentation.GetBookmark;
    try
      FPresentation.First;
      while not FPresentation.Eof do begin
        S:=FPresentation.FieldByName('VALUE_DEFAULT').AsString;
        if Trim(S)<>'' then begin
          ColumnId:=FPresentation.FieldByName('COLUMN_ID').AsString;
          EditByValue(ColumnId,S);
        end;
        FPresentation.Next;
      end;
    finally
      if Assigned(B) and FPresentation.BookmarkValid(B) then
        FPresentation.GotoBookmark(B);
      FPresentation.EnableControls;
    end;

    FPreview.FieldByName('VIEW_ID').Value:=FViewId;
    FPreview.FieldByName('VIEW_NUM').Value:=FViewNum;

    FPreview.FieldByName('TYPE_ID').Value:=FTypeId;
    FPreview.FieldByName('TYPE_NUM').Value:=FTypeNum;

    FPreview.FieldByName('OPERATION_ID').Value:=FOperationId;
    FPreview.FieldByName('OPERATION_NUM').Value:=FOperationNum;

    FPreview.FieldByName('DESIGN_ID').Value:=FDesignId;
    FPreview.FieldByName('DESIGN_NUM').Value:=FDesignNum;

    UpdateButtons;
    UpdateLabelCount;
  end;
end;

procedure TBisKrieltImportForm.RefreshViews(List: TObjectList);
var
  &Type: TBisTypeInfo;
  View: TBisViewInfo;
  Views: TBisViewInfos;
  PView: TBisProvider;
  PType: TBisProvider;
  POperation: TBisProvider;
begin
  if Assigned(List) and (List is TBisViewInfos) then begin
    PView:=TBisProvider.Create(nil);
    PType:=TBisProvider.Create(nil);
    POperation:=TBisProvider.Create(nil);
    try
      Views:=TBisViewInfos(List);
      Views.Clear;

      PView.WithWaitCursor:=false;
      PView.ProviderName:='S_VIEWS';
      PView.Orders.Add('NUM');
      PView.Open;

      PType.WithWaitCursor:=false;
      PType.ProviderName:='S_VIEW_TYPES';
      PType.Orders.Add('PRIORITY');
      PType.Open;

      POperation.WithWaitCursor:=false;
      POperation.ProviderName:='S_TYPE_OPERATIONS';
      POperation.Orders.Add('PRIORITY');
      POperation.Open;

      if PView.Active and not PView.Empty and
         PType.Active and POperation.Active then begin

        PView.First;
        while not PView.Eof do begin
          View:=Views.AddView(PView.FieldByName('VIEW_ID').Value,
                              PView.FieldByName('NAME').AsString,
                              PView.FieldByName('NUM').AsString);

          PType.Filtered:=false;
          PType.Filter:=Format('VIEW_ID=%s',[QuotedStr(VarToStrDef(View.ViewId,''))]);
          PType.Filtered:=true;
          PType.First;
          while not PType.Eof do begin
            &Type:=View.Types.AddType(PType.FieldByName('TYPE_ID').Value,
                                      PType.FieldByName('TYPE_NAME').AsString,
                                      PType.FieldByName('TYPE_NUM').AsString);

            POperation.Filtered:=false;
            POperation.Filter:=Format('TYPE_ID=%s',[QuotedStr(VarToStrDef(&Type.TypeId,''))]);
            POperation.Filtered:=true;
            POperation.First;
            while not POperation.Eof do begin
              &Type.Operations.AddOperation(POperation.FieldByName('OPERATION_ID').Value,
                                            POperation.FieldByName('OPERATION_NAME').AsString,
                                            POperation.FieldByName('OPERATION_NUM').AsString);
              POperation.Next
            end;
            PType.Next;
          end;
          PView.Next;
        end;
      end;
    finally
      POperation.Free;
      PType.Free;
      PView.Free;
    end;
  end;
end;

procedure TBisKrieltImportForm.RefreshDesigns(List: TObjectList);
var
  Designs: TBisDesignInfos;
  PDesign: TBisProvider;
begin
  if Assigned(List) and (List is TBisDesignInfos) then begin
    PDesign:=TBisProvider.Create(nil);
    try
      Designs:=TBisDesignInfos(List);
      Designs.Clear;

      PDesign.WithWaitCursor:=false;
      PDesign.ProviderName:='S_DESIGNS';
      PDesign.Orders.Add('NUM');
      PDesign.Open;

      if PDesign.Active and not PDesign.Empty then begin

        PDesign.First;
        while not PDesign.Eof do begin
          Designs.AddDesign(PDesign.FieldByName('DESIGN_ID').Value,
                            PDesign.FieldByName('NAME').AsString,
                            PDesign.FieldByName('NUM').AsString);
          PDesign.Next;
        end;
      end;
    finally
      PDesign.Free;
    end;
  end;
end;

procedure TBisKrieltImportForm.LoadExcel(FileName: String);

  function GetViewInfo(Views: TBisViewInfos; var Number: String): TBisViewInfo;
  var
    i: Integer;
    Item: TBisViewInfo;
    S: String;
  begin
    Result:=nil;
    for i:=0 to Views.Count-1 do begin
      Item:=Views[i];
      S:=Copy(Number,1,Length(Item.ViewNum));
      if AnsiSameText(S,Item.ViewNum) then begin
        Number:=Copy(Number,Length(S)+1,Length(Number));
        Result:=Item;
        exit;
      end;
    end;
  end;

  function GetTypeInfo(Types: TBisTypeInfos; var Number: String): TBisTypeInfo;
  var
    i: Integer;
    Item: TBisTypeInfo;
    S: String;
  begin
    Result:=nil;
    for i:=0 to Types.Count-1 do begin
      Item:=Types[i];
      S:=Copy(Number,1,Length(Item.TypeNum));
      if AnsiSameText(S,Item.TypeNum) then begin
        Number:=Copy(Number,Length(S)+1,Length(Number));
        Result:=Item;
        exit;
      end;
    end;
  end;

  function GetOperationInfo(Operations: TBisOperationInfos; var Number: String): TBisOperationInfo;
  var
    i: Integer;
    Item: TBisOperationInfo;
    S: String;
  begin
    Result:=nil;
    for i:=0 to Operations.Count-1 do begin
      Item:=Operations[i];
      S:=Copy(Number,1,Length(Item.OperationNum));
      if AnsiSameText(S,Item.OperationNum) then begin
        Number:=Copy(Number,Length(S)+1,Length(Number));
        Result:=Item;
        exit;
      end;
    end;
  end;

  function GetDesignInfo(Designs: TBisDesignInfos; var Number: String): TBisDesignInfo;
  var
    i: Integer;
    Item: TBisDesignInfo;
    S: String;
  begin
    Result:=nil;
    for i:=0 to Designs.Count-1 do begin
      Item:=Designs[i];
      S:=Copy(Number,1,Length(Item.DesignNum));
      if AnsiSameText(S,Item.DesignNum) then begin
        Number:=Copy(Number,Length(S)+1,Length(Number));
        Result:=Item;
        exit;
      end;
    end;
  end;

var
  Views: TBisViewInfos;
  Designs: TBisDesignInfos;

  procedure EditByColumnIndex(Value: OleVariant; Index: Integer);
  var
    V: Variant;
    AColumnId: String;
    Counter: Integer;
    S: String;
    View: TBisViewInfo;
    &Type: TBisTypeInfo;
    Operation: TBisOperationInfo;
    Design: TBisDesignInfo;
  begin
    if Index<=(FPresentation.RecordCount+2) then begin
      V:=Value;
      if Index=1 then begin
        S:=VarToStrDef(V,'');

        View:=GetViewInfo(Views,S);
        if Assigned(View) then begin
          FPreview.FieldByName('VIEW_ID').Value:=View.ViewId;
          FPreview.FieldByName('VIEW_NUM').Value:=View.ViewNum;
          &Type:=GetTypeInfo(View.Types,S);
          if Assigned(&Type) then begin
            FPreview.FieldByName('TYPE_ID').Value:=&Type.TypeId;
            FPreview.FieldByName('TYPE_NUM').Value:=&Type.TypeNum;
            Operation:=GetOperationInfo(&Type.Operations,S);
            if Assigned(Operation) then begin
              FPreview.FieldByName('OPERATION_ID').Value:=Operation.OperationId;
              FPreview.FieldByName('OPERATION_NUM').Value:=Operation.OperationNum;
            end;
          end;
        end;

        if VarIsNull(FPreview.FieldByName('VIEW_ID').Value) then begin
          FPreview.FieldByName('VIEW_ID').Value:=FViewId;
          FPreview.FieldByName('VIEW_NUM').Value:=FViewNum;
          if VarIsNull(FPreview.FieldByName('TYPE_ID').Value) then begin
            FPreview.FieldByName('TYPE_ID').Value:=FTypeId;
            FPreview.FieldByName('TYPE_NUM').Value:=FTypeNum;
            if VarIsNull(FPreview.FieldByName('OPERATION_ID').Value) then begin
              FPreview.FieldByName('OPERATION_ID').Value:=FOperationId;
              FPreview.FieldByName('OPERATION_NUM').Value:=FOperationNum;
            end;
          end;
        end;

      end else if Index=2 then begin
        S:=VarToStrDef(V,'');
        Design:=GetDesignInfo(Designs,S);
        if Assigned(Design) then begin
          FPreview.FieldByName('DESIGN_ID').Value:=Design.DesignId;
          FPreview.FieldByName('DESIGN_NUM').Value:=Design.DesignNum;
        end;
      end else begin

        Counter:=2;
        FPresentation.First;
        while not FPresentation.Eof do begin
          if Boolean(FPresentation.FieldByName('VISIBLE').AsInteger) then
            Inc(Counter);
          if Counter=Index then
            break;
          FPresentation.Next;
        end;

        AColumnId:=FPresentation.FieldByName('COLUMN_ID').AsString;

        EditByValue(AColumnId,V);
        
      end;
    end;
  end;

  procedure SetColumnDepends;
  var
    i: Integer;
    Column: TColumn;
    AColumn: TBisPreviewColumn;
    V: Variant;
    ValueInfo: TBisValueInfo;
  begin
    for i:=0 to GridPreview.Columns.Count-1 do begin
      Column:=GridPreview.Columns.Items[i];
      if Assigned(Column) and (Column is TBisPreviewColumn) then begin
        AColumn:=TBisPreviewColumn(Column);
        if AColumn.Handbook then begin
          V:=FPreview.FieldByName(AColumn.FieldName).Value;
          if not VarIsNull(V) then begin
            ValueInfo:=AColumn.Values.FindByName(VarToStrDef(V,''));
            if Assigned(ValueInfo) then
              SetDepends(AColumn,ValueInfo.Id,false,true);
          end;
        end;
      end;
    end;
  end;

  procedure SetColumnDefaults;

    function ValueExists(AParentColumn: TBisPreviewColumn): Boolean;
    var
      List: TList;
      i: Integer;
      AColumn: TBisPreviewColumn;
      V: Variant;
    begin
      List:=TList.Create;
      try
        Result:=false;
        GetColumnListByColumnId(List,AParentColumn.ColumnId);
        for i:=0 to List.Count-1 do begin
          AColumn:=TBisPreviewColumn(List.Items[i]);
          V:=FPreview.FieldByName(AColumn.FieldName).Value;
          if not VarIsNull(V) then begin
            Result:=true;
            exit;
          end;
        end;
      finally
        List.Free;
      end;
    end;

  var
    i: Integer;
    Column: TColumn;
    AColumn: TBisPreviewColumn;
    V: Variant;
    Counter: Integer;
  begin
    for i:=0 to GridPreview.Columns.Count-1 do begin
      Column:=GridPreview.Columns.Items[i];
      if Assigned(Column) and (Column is TBisPreviewColumn) then begin
        AColumn:=TBisPreviewColumn(Column);
        if not ValueExists(AColumn) then begin
          V:=FPreview.FieldByName(AColumn.FieldName).Value;
          Counter:=0;
          FPresentation.First;
          while not FPresentation.Eof do begin
            if Boolean(FPresentation.FieldByName('VISIBLE').AsInteger) then
              Inc(Counter);
            if Counter=(i-3) then
              break;
            FPresentation.Next;
          end;
          V:=FPresentation.FieldByName('VALUE_DEFAULT').Value;
          if not VarIsNull(V) then
            if Trim(VarToStrDef(V,''))<>'' then
              EditByValue(AColumn.ColumnId,V);
        end;
      end;
    end;
  end;

var
  Excel: OleVariant;
  Wb: OleVariant;
  Sh: OleVariant;
  V: OleVariant;
  S: OleVariant;
  Data: OleVariant;
  RowCount: Integer;
  ColCount: Integer;
  i,j: Integer;
  B: TBookmark;
  Breaked: Boolean;
const
  SExcelOleObject='Excel.Application';
begin
  if FPreview.Active then begin
    CoInitialize(nil);
    Views:=TBisViewInfos.Create;
    Designs:=TBisDesignInfos.Create;
    GridPreview.DataSource:=nil;
    try
      FPreview.EmptyTable;
      RefreshValues;
      RefreshViews(Views);
      RefreshDesigns(Designs);
      Update;
      Excel:=CreateOleObject(SExcelOleObject);
      Update;
      Excel:=Excel.Application;
      Excel.WorkBooks.Open(FileName);
      Wb:=Excel.WorkBooks.Item[1];
      Sh:=Wb.Sheets.Item[1];
      S:=Excel.Selection;
      if not VarIsEmpty(S) then begin
        Update;
        RowCount:=S.Rows.Count;
        ColCount:=S.Columns.Count;
        if (RowCount<>0) and (ColCount<>0) then begin
          Data:=S.Value;

          Progress(0,RowCount,0,Breaked);
          FPresentation.DisableControls;
          B:=FPresentation.GetBookmark;
          FPreview.DisableControls;
          FLoading:=true;
          try
            for i:=1 to RowCount do begin
              if Breaked then
                break;
              try
                FPreview.Append;
                for j:=1 to ColCount do begin
                  V:=Data[i,j];
                  EditByColumnIndex(V,j);
                end;
                SetColumnDepends;
                SetColumnDefaults;
                FPreview.Post;
              except
                FPreview.Cancel;
              end;
              Progress(0,RowCount,i,Breaked);
            end;
          finally
            FLoading:=false;
            FPreview.First;
            FPreview.EnableControls;
            if Assigned(B) and FPresentation.BookmarkValid(B) then
              FPresentation.GotoBookmark(B);
            FPresentation.EnableControls;
            Progress(0,0,0,Breaked);
          end;
        end;
      end;
    finally
      GridPreview.DataSource:=DataSourcePreview;
      Designs.Free;
      Views.Free;
      if not VarIsEmpty(Excel) then
        Excel.Quit;
      CoUninitialize;
    end;
  end;
end;

procedure TBisKrieltImportForm.GridPresentationEditButtonClick(Sender: TObject);
var
  AIface: TBisKrieltDataParamValuesFormIface;
  AIface2: TBisKrieltDataParamValueDependsFormIface;
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  List: TList;
  i: Integer;
  S: String;
  Value: String;
  ParamValueId: Variant;
  Flag: Boolean;
  FLag2: Boolean;
  Usedepend: Boolean;
  P: TBisProvider;
begin
  if FPresentation.Active and not FPresentation.IsEmpty and
     (GridPresentation.SelectedIndex=2) then begin
    Column:=GridPresentation.Columns[GridPresentation.SelectedIndex];
    List:=TList.Create;
    try
      Value:='';
      Flag:=true;
      ParamValueId:=Null;
      Usedepend:=Boolean(FPresentation.FieldByName('USE_DEPEND').AsInteger);
      GetColumnListByColumnId(List,FPresentation.FieldByName('COLUMN_ID').AsString);
      for i:=0 to List.Count-1 do begin
        S:='';
        FLag2:=false;
        AColumn:=TBisPreviewColumn(List[i]);
        if AColumn.Handbook then begin
          if not Usedepend then begin
            AIface:=TBisKrieltDataParamValuesFormIface.Create(nil);
            P:=TBisProvider.Create(nil);
            try
              if not FLag2 then begin
                AIface.LocateFields:='NAME';
                AIface.LocateValues:=FPresentation.FieldByName('VALUE_DEFAULT').AsString;
              end;
              AIface.FilterGroups.Add.Filters.Add('PARAM_ID',fcEqual,AColumn.ParamId);
              AIface.FilterOnShow:=false;
              if AIface.SelectInto(P) then begin
                S:=P.FieldByName('NAME').AsString;
                Flag2:=true;
              end;
            finally
              P.Free;
              AIface.Free;
            end;
          end else begin
            AIface2:=TBisKrieltDataParamValueDependsFormIface.Create(nil);
            P:=TBisProvider.Create(nil);
            try
              if not FLag2 then begin
                AIface2.LocateFields:='WHAT_PARAM_VALUE_NAME';
                AIface2.LocateValues:=FPresentation.FieldByName('VALUE_DEFAULT').AsString;
              end;
              with AIface2.FilterGroups.Add do begin
                Filters.Add('WHAT_PARAM_ID',fcEqual,AColumn.ParamId);
                if not VarIsNull(ParamValueId) then
                  Filters.Add('WHAT_PARAM_VALUE_ID',fcEqual,ParamValueId); 
              end;
              AIface2.FilterOnShow:=false;
              if AIface2.SelectInto(P) then begin
                S:=P.FieldByName('WHAT_PARAM_VALUE_NAME').AsString;
                ParamValueId:=P.FieldByName('FROM_PARAM_VALUE_ID').Value;
                Flag2:=true;
              end;
            finally
              P.Free;
              AIface2.Free;
            end;
          end;
          Flag:=Flag and Flag2;
        end;
        Value:=Value+AColumn.StringBefore+S+AColumn.StringAfter;
      end;
      if Flag then begin
        FPresentation.Edit;
        FPresentation.FieldByName(Column.FieldName).AsString:=Value;
        FPresentation.Post;
      end;
    finally
      List.Free;
    end;
  end;
end;

procedure TBisKrieltImportForm.CheckListBoxPublishingDblClick(Sender: TObject);
var
  AIface: TBisKrieltDataIssuesFormIface;
  P: TBisProvider;
  Obj: TBisPublishingInfo;
  Index: Integer;
begin
  Index:=CheckListBoxPublishing.ItemIndex;
  if Index<>-1 then begin
    Obj:=TBisPublishingInfo(CheckListBoxPublishing.Items.Objects[Index]);
    if Assigned(Obj) then begin
      AIface:=TBisKrieltDataIssuesFormIface.Create(nil);
      P:=TBisProvider.Create(nil);
      try
        AIface.LocateFields:='ISSUE_ID';
        AIface.LocateValues:=Obj.IssueId;
        AIface.FilterGroups.Add.Filters.Add('PUBLISHING_ID',fcEqual,Obj.PublishingId);
        if AIface.SelectInto(P) then begin
          Obj.IssueId:=P.FieldByName('ISSUE_ID').Value;
          Obj.DateBegin:=P.FieldByName('DATE_BEGIN').AsDateTime;
          Obj.DateEnd:=P.FieldByName('DATE_END').AsDateTime;
          Obj.Number:=P.FieldByName('NUM').AsString;
          CheckListBoxPublishing.Items[Index]:=Format('%s: %s',[Obj.Name,Obj.Number]);
          CheckListBoxPublishing.Checked[Index]:=true;
        end;
      finally
        P.Free;
        AIface.Free;
      end;
    end;
  end;
end;

function TBisKrieltImportForm.CheckImport(var Breaked: Boolean): Boolean;
var
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  i: Integer;
  Field: TField;
  V: Variant;
  S: String;
begin
  Result:=true;
  if FPreview.Active and not FPreview.IsEmpty then begin
    for i:=0 to GridPreview.Columns.Count-1 do begin
      Column:=GridPreview.Columns[i];
      if Assigned(Column) then begin
        Field:=Column.Field;
        if Assigned(Field)then begin
          V:=Field.Value;
          S:=Trim(VarToStrDef(V,''));
          if (Column is TBisPreviewColumn) then begin
            AColumn:=TBisPreviewColumn(Column);

            if (S='') and AColumn.NotEmpty then begin
              if ShowErrorQuestion(Format('���� [%s] ������ ��������� ��������. �������� ������?',[AColumn.Title.Caption]))=mrYes then
                Breaked:=true;
              Result:=false;
              GridPreview.SelectedIndex:=i;
              GridPreview.SetFocus;
              break;
            end;

            if (S<>'') and AColumn.Handbook and not AColumn.Values.NameExists(S) then begin
              if ShowErrorQuestion(Format('���� [%s] �������� �������� ��������. �������� ������?',[AColumn.Title.Caption]))=mrYes then
                Breaked:=true;
              Result:=false;
              GridPreview.SelectedIndex:=i;
              GridPreview.SetFocus;
              break;
            end;

          end else begin

            if (S='') and
               (AnsiSameText(Column.FieldName,'VIEW_NUM') or
                AnsiSameText(Column.FieldName,'TYPE_NUM') or
                AnsiSameText(Column.FieldName,'OPERATION_NUM')) then begin
              ShowError(Format('���� [%s] ������ ��������� ��������.',[Column.Title.Caption]));
              Breaked:=true;
              Result:=false;
              GridPreview.SelectedIndex:=i;
              GridPreview.SetFocus;
              break;
            end;

          end;
        end;
      end;
    end;
  end;
end;

procedure TBisKrieltImportForm.Import;
var
  OldCursor: TCursor;
  AObjectId: String;
  APosition: Integer;
  D1, D2: TDateTime;
  Column: TColumn;
  AColumn: TBisPreviewColumn;
  i: Integer;
  Value: Variant;
  Description: Variant;
  Export: Variant;
  FlagInsert: Boolean;
  PObject: TBisProvider;
  Obj: TBisPublishingInfo;
  Breaked: Boolean;
  Checked: Boolean;
  Params: TBisParams;
  ValueInfo: TBisValueInfo;
  S: String;
  AMax: Integer;
begin
  if FPreview.Active and not FPreview.IsEmpty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    AMax:=FPreview.RecordCount;
    Progress(0,AMax,0,Breaked);
    try
      APosition:=0;
      D1:=GetDateTimeBegin;
      D2:=GetDateTimeEnd;
      FPreview.First;
      while not FPreview.Eof do begin
        Checked:=CheckImport(Breaked);
        if Breaked then
          break;
        if Checked then begin
          try
            AObjectId:=GetUniqueID;
            PObject:=TBisProvider.Create(nil);
            try
              PObject.WithWaitCursor:=false;
              PObject.ProviderName:='I_OBJECT';
              with PObject.Params do begin
                AddInvisible('OBJECT_ID').Value:=AObjectId;
                AddInvisible('ACCOUNT_ID').Value:=FAccountId;
                AddInvisible('VIEW_ID').Value:=FPreview.FieldByName('VIEW_ID').Value;
                AddInvisible('TYPE_ID').Value:=FPreview.FieldByName('TYPE_ID').Value;
                AddInvisible('OPERATION_ID').Value:=FPreview.FieldByName('OPERATION_ID').Value;
                AddInvisible('DESIGN_ID').Value:=FPreview.FieldByName('DESIGN_ID').Value;
                AddInvisible('PRIORITY').Value:=FPreview.FieldByName('PRIORITY').Value;
                AddInvisible('STATUS').Value:=1;
              end;

              for i:=0 to CheckListBoxPublishing.Items.Count-1 do begin
                if CheckListBoxPublishing.Checked[i] then begin
                  Obj:=TBisPublishingInfo(CheckListBoxPublishing.Items.Objects[i]);
                  if Assigned(Obj) then begin
                    Params:=PObject.PackageAfter.Add;
                    Params.ProviderName:='I_PUBLISHING_OBJECT2';
                    with Params do begin
                      AddInvisible('PUBLISHING_ID').Value:=Obj.PublishingId;
                      AddInvisible('OBJECT_ID').Value:=AObjectId;
                      if VarIsNull(Obj.IssueId) then begin
                        AddInvisible('DATE_BEGIN').Value:=D1;
                        AddInvisible('DATE_END').Value:=D2;
                      end else begin
                        AddInvisible('DATE_BEGIN').Value:=Obj.DateBegin;
                        AddInvisible('DATE_END').Value:=Obj.DateEnd;
                      end;
                    end;
                  end;
                end;
              end;

              for i:=0 to GridPreview.Columns.Count-1 do begin
                Column:=GridPreview.Columns[i];
                if Assigned(Column) and (Column is TBisPreviewColumn) then begin
                  AColumn:=TBisPreviewColumn(Column);
                  Value:=FPreview.FieldByName(AColumn.FieldName).Value;
                  S:=Trim(VarToStrDef(Value,''));
                  if S<>'' then begin
                    FlagInsert:=true;
                    if FlagInsert then begin
                      Params:=PObject.PackageAfter.Add;
                      Params.ProviderName:='I_OBJECT_PARAM';
                      with Params do begin
                        AddInvisible('OBJECT_PARAM_ID').Value:=GetUniqueID;
                        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
                        AddInvisible('PARAM_ID').Value:=AColumn.ParamId;
                        AddInvisible('OBJECT_ID').Value:=AObjectId;
                        AddInvisible('DATE_CREATE').Value:=Now;
                        Description:=Null;
                        Export:=Null;
                        case AColumn.ParamType of
                          dptList: begin
                            AddInvisible('VALUE_STRING').Value:=Value;
                            if AColumn.Handbook then begin
                              ValueInfo:=AColumn.Values.FindByName(S);
                              if Assigned(ValueInfo) then begin
                                Description:=ValueInfo.Description;
                                Export:=ValueInfo.Export;
                              end;
                            end;
                          end;
                          dptString,dptLink: AddInvisible('VALUE_STRING').Value:=Value;
                          dptInteger,dptFloat: AddInvisible('VALUE_NUMBER').Value:=Value;
                          dptDate,dptDateTime: AddInvisible('VALUE_DATE').Value:=Value;
                          dptImage,dptDocument,dptVideo: AddInvisible('VALUE_BLOB').Value:=Value;
                        end;
                        AddInvisible('DESCRIPTION').Value:=Description;
                        AddInvisible('EXPORT').Value:=Export;
                      end;
                    end;
                  end;
                end;
              end;

              PObject.Execute;
            finally
              PObject.Free;
            end;

            FPreview.Delete;
          except
            FPreview.Next;
          end;
        end else
          FPreview.Next;
        Inc(APosition);
        Progress(0,AMax,APosition,Breaked);
      end;
      UpdateLabelCount;
    finally
      Progress(0,0,0,Breaked);
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

end.


