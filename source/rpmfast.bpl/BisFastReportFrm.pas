unit BisFastReportFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, ComCtrls, ToolWin, IniFiles,
  ExtCtrls, StdCtrls,
  frxClass, frxPreview, frxDBSet,
  BisReportFrm, BisFastReportClasses;


type

  TBisFastReportFrame = class(TBisReportFrame)
    ActionUp: TAction;
    ActionDown: TAction;
    ActionPopup: TAction;
    PopupExport: TPopupActionBar;
    ToolBarScale: TToolBar;
    PanelScale: TPanel;
    ComboBoxScale: TComboBox;
    procedure FrameMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ActionUpExecute(Sender: TObject);
    procedure ActionUpUpdate(Sender: TObject);
    procedure ActionDownExecute(Sender: TObject);
    procedure ActionDownUpdate(Sender: TObject);
    procedure ActionPopupExecute(Sender: TObject);
    procedure ActionExportUpdate(Sender: TObject);
    procedure ComboBoxScaleChange(Sender: TObject);
  private
    FPreview: TBisFastReportPreview;
    FReport: TBisFastReport;
    FPrepared: Boolean;
    FLoaded: Boolean;
    FSWholePage: String;
    FSByWidth: String;
    procedure PreviewPageChanged(Sender: TfrxPreview; PageNo: Integer);
    procedure ReportProgressStart(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
    procedure ReportProgressStop(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
    procedure ReportProgress(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
    procedure ReportGetValue(const VarName: String; var Value: Variant);
    procedure RefreshScales;
    procedure RefreshExportMenus(Menus: TMenuItem);
    procedure MenuExportClick(Sender: TObject);
    function PreviewGetIniFile(var Created: Boolean): TCustomIniFile;
    procedure ReportBeforePrepareReport(Sender: TObject);
  protected
    procedure SetPageNum(PageNum: Integer); override;
    function GetPageNum: Integer; override;
    function GetPageCount: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OpenReport; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure CreateByPattern; override;
    function ReportExists: Boolean; override;
    function ReportLoaded: Boolean; override;
    function ReportPrepared: Boolean; override;
    function CanExportReport: Boolean; override;
    procedure ExportReport; override;
    function CanEditPage: Boolean; override;
    procedure EditPage; override;
    function CanPrintReport: Boolean; override;
    procedure PrintReport; override;
    function CanFindText: Boolean; override;
    procedure FindText; override;
    function CanPropertyPage: Boolean; override;
    procedure PropertyPage; override;
    function CanFirstPage: Boolean; override;
    procedure FirstPage; override;
    function CanPriorPage: Boolean; override;
    procedure PriorPage; override;
    function CanNextPage: Boolean; override;
    procedure NextPage; override;
    function CanLastPage: Boolean; override;
    procedure LastPage; override;
    function PageExists(PageNum: Integer): Boolean; override;
  published
    property SWholePage: String read FSWholePage write FSWholePage;
    property SByWidth: String read FSByWidth write FSByWidth;
  end;

var
  BisFastReportFrame: TBisFastReportFrame;

implementation

{$R *.dfm}

uses Printers, DB, TypInfo,
     frxDsgnIntf, frxUtils, frxPreviewPageSettings,
     VirtualTrees,
     BisDBTree, BisDataSet,
     BisConsts, BisCore;

{ TBisFastReportFrame }

constructor TBisFastReportFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPreview:=TBisFastReportPreview.Create(Self);
  FPreview.Parent:=PanelReport;
  FPreview.Align:=alClient;
  FPreview.ZoomMode:=zmPageWidth;
  FPreview.PopupMenu:=Popup;
  FPreview.OnPageChanged:=PreviewPageChanged;
  FPreview.OnGetIniFile:=PreviewGetIniFile;
  FPreview.TabStop:=true;
  FPreview.TabOrder:=0;

  ComboBoxScale.TabOrder:=1;
  EditPageNum.TabOrder:=2;

  FReport:=TBisFastReport.Create(Self);
  FReport.Preview:=FPreview;
  FReport.EngineOptions.UseFileCache:=false;
  FReport.OnProgressStart:=ReportProgressStart;
  FReport.OnProgressStop:=ReportProgressStop;
  FReport.OnProgress:=ReportProgress;
  FReport.OnGetValue:=ReportGetValue;
  FReport.OnBeforePrepareReport:=ReportBeforePrepareReport;

  FSWholePage:='�������';
  FSByWidth:='�� ������';

  RefreshExportMenus(PopupExport.Items);
  RefreshExportMenus(MenuItemExport);

  RefreshScales;
end;

destructor TBisFastReportFrame.Destroy;
begin
  FReport.Free;
  FPreview.Free;
  inherited Destroy;
end;

function TBisFastReportFrame.PreviewGetIniFile(var Created: Boolean): TCustomIniFile;
begin
  Result:=Core.Profile.IniFile;
  Created:=false;
end;

procedure TBisFastReportFrame.RefreshScales;
begin
  ComboBoxScale.Clear;
  with ComboBoxScale.Items do begin
    Add('25%');
    Add('50%');
    Add('75%');
    Add('100%');
    Add('150%');
    Add('200%');
    Add(FSWholePage);
    Add(FSByWidth);
  end;
  ComboBoxScale.ItemIndex:=7;
end;

procedure TBisFastReportFrame.ComboBoxScaleChange(Sender: TObject);
var
  s: String;
  Mode: TfrxZoomMode;
begin
  if ReportExists and ReportLoaded and FPrepared and
     (ComboBoxScale.ItemIndex<>-1) then begin
    Mode:=zmDefault;
    case ComboBoxScale.ItemIndex of
      0..5: Mode:=zmDefault;
      6: Mode:=zmWholePage;
      7: Mode:=zmPageWidth;
    end;
    case Mode of
      zmDefault: begin
        s:=ComboBoxScale.Items[ComboBoxScale.ItemIndex];
        if Pos('%', s) <> 0 then
          s[Pos('%', s)] := ' ';
        while Pos(' ', s) <> 0 do
          System.Delete(s, Pos(' ', s), 1);

        if s <> '' then
          FPreview.Zoom := frxStrToFloat(s) / 100;
      end;
    else
      FPreview.ZoomMode:=Mode;
    end;
    FPreview.SetFocus;
  end;
end;
procedure TBisFastReportFrame.RefreshExportMenus(Menus: TMenuItem);
var
  i: Integer;
  Menu: TMenuItem;
  Item: TfrxExportFilterItem;
begin
  Menus.Clear;
  for i:=0 to frxExportFilters.Count-1 do begin
    Item:=frxExportFilters.Items[i];
    Menu:=TMenuItem.Create(Menus);
    Menu.Caption:=Item.Filter.GetDescription;
    Menu.Hint:=Menu.Caption;
    Menu.RadioItem:=true;
    Menu.Checked:=i=0;
    Menu.OnClick:=MenuExportClick;
    Menus.Add(Menu);
  end;
end;

procedure TBisFastReportFrame.MenuExportClick(Sender: TObject);
var
  Item: TfrxExportFilterItem;
begin
  if Sender is TMenuItem then begin
    with TMenuItem(Sender) do begin
      Checked:=true;
      if Parent<>PopupExport.Items then
        PopupExport.Items[MenuIndex].Checked:=true
      else MenuItemExport.Items[MenuIndex].Checked:=true;
      if MenuIndex in [0..frxExportFilters.Count-1] then begin
        Item:=frxExportFilters.Items[MenuIndex];
        FPreview.Export(Item.Filter);
      end;
    end;
  end;
end;

procedure TBisFastReportFrame.PreviewPageChanged(Sender: TfrxPreview; PageNo: Integer);
begin
end;

function TBisFastReportFrame.ReportExists: Boolean;
begin
  Result:=inherited ReportExists;
end;

procedure TBisFastReportFrame.ReportGetValue(const VarName: String; var Value: Variant);
begin
  DoGetParamValue(VarName,Value);
end;

function TBisFastReportFrame.ReportLoaded: Boolean;
begin
  Result:=FLoaded;
end;

function TBisFastReportFrame.ReportPrepared: Boolean;
begin
  Result:=FPrepared;
end;

procedure TBisFastReportFrame.ReportProgress(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
{var
  Interrrupted: Boolean;}
begin
{  If ProgressType<>ptRunning then
    Core.Progress(0,FPreview.PageCount,Progress,Interrrupted);}
end;

procedure TBisFastReportFrame.ReportProgressStart(Sender: TfrxReport; ProgressType: TfrxProgressType; Progress: Integer);
{var
  Interrrupted: Boolean;}
begin
{  If ProgressType<>ptRunning then
    Core.Progress(0,FPreview.PageCount,Progress,Interrrupted);}
end;

procedure TBisFastReportFrame.ReportProgressStop(Sender: TfrxReport;  ProgressType: TfrxProgressType; Progress: Integer);
{var
  Interrrupted: Boolean;}
begin
{  If ProgressType<>ptRunning then
    Core.Progress(0,FPreview.PageCount,Progress,Interrrupted);}  
end;

procedure TBisFastReportFrame.LoadFromStream(Stream: TStream);
begin
  FLoaded:=false;
  if Assigned(Stream) and (Stream.Size>0) then begin
    FReport.LoadFromStream(Stream);
    if not FPrepared then begin
      FPrepared:=FReport.PrepareReport(true)
    end else begin
      FPreview.RefreshReport;
    end;
    FLoaded:=true;
  end;
end;

procedure TBisFastReportFrame.OpenReport;
begin
  inherited OpenReport;
end;

procedure TBisFastReportFrame.ActionDownExecute(Sender: TObject);
begin
  if not ComboBoxScale.Focused then
    FPreview.MouseWheelScroll(-1)
  else begin
    if (ComboBoxScale.ItemIndex+1)<=(ComboBoxScale.Items.Count-1) then
      ComboBoxScale.ItemIndex:=ComboBoxScale.ItemIndex+1;
    ComboBoxScaleChange(ComboBoxScale);
  end;

end;

procedure TBisFastReportFrame.ActionDownUpdate(Sender: TObject);
begin
  ActionDown.Enabled:=ReportLoaded and FPrepared;
end;

procedure TBisFastReportFrame.ActionExportUpdate(Sender: TObject);
begin
  inherited;
  MenuItemExport.Enabled:=CanExportReport;
  ComboBoxScale.Enabled:=MenuItemExport.Enabled;
  EditPageNum.Enabled:=MenuItemExport.Enabled;
end;

procedure TBisFastReportFrame.ActionPopupExecute(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=FPreview.ClientToScreen(Point(FPreview.Left,FPreview.Top));
  Popup.Popup(Pt.X,Pt.Y);
end;

procedure TBisFastReportFrame.ActionUpExecute(Sender: TObject);
begin
  if not ComboBoxScale.Focused then
    FPreview.MouseWheelScroll(1)
  else begin
    if (ComboBoxScale.ItemIndex-1)>=0 then
      ComboBoxScale.ItemIndex:=ComboBoxScale.ItemIndex-1;
    ComboBoxScaleChange(ComboBoxScale);
  end;
end;

procedure TBisFastReportFrame.ActionUpUpdate(Sender: TObject);
begin
  ActionUp.Enabled:=ReportLoaded and FPrepared;
end;

function TBisFastReportFrame.CanEditPage: Boolean;
begin
  Result:=inherited CanEditPage and FPrepared;
end;

procedure TBisFastReportFrame.EditPage;
begin
  inherited EditPage;
  if CanEditPage then
    FPreview.Edit;
end;

function TBisFastReportFrame.CanPrintReport: Boolean;
begin
  Result:=inherited CanPrintReport and FPrepared;
end;

procedure TBisFastReportFrame.PrintReport;
begin
  inherited PrintReport;
  if CanPrintReport then
    FPreview.Print;
end;

function TBisFastReportFrame.CanFindText: Boolean;
begin
  Result:=inherited CanFindText and FPrepared;
end;

procedure TBisFastReportFrame.FindText;
begin
  inherited FindText;
  if CanFindText then
    FPreview.Find;
end;

function TBisFastReportFrame.CanPropertyPage: Boolean;
begin
  Result:=inherited CanPropertyPage and FPrepared;
end;

procedure TBisFastReportFrame.PropertyPage;
begin
  inherited PropertyPage;
  if CanPropertyPage then begin
    FPreview.PageSetupDlg;
  end;
end;

function TBisFastReportFrame.CanFirstPage: Boolean;
begin
  Result:=inherited CanFirstPage and FPrepared and
          (FPreview.PageNo>1);
end;

procedure TBisFastReportFrame.FirstPage;
begin
  if CanFirstPage then
    FPreview.First;
  inherited FirstPage;
end;

function TBisFastReportFrame.CanPriorPage: Boolean;
begin
  Result:=inherited CanPriorPage and FPrepared and
          (FPreview.PageNo>1);
end;

procedure TBisFastReportFrame.PriorPage;
begin
  if CanPriorPage then
    FPreview.Prior;
  inherited PriorPage;
end;

function TBisFastReportFrame.CanLastPage: Boolean;
begin
  Result:=inherited CanLastPage and (FPreview.PageNo<FPreview.PageCount);
end;

procedure TBisFastReportFrame.LastPage;
begin
  if CanLastPage then
    FPreview.Last;
  inherited LastPage;
end;

function TBisFastReportFrame.CanNextPage: Boolean;
begin
  Result:=inherited CanNextPage and (FPreview.PageNo<FPreview.PageCount);
end;

procedure TBisFastReportFrame.NextPage;
begin
  if CanNextPage then
    FPreview.Next;
  inherited NextPage;
end;

procedure TBisFastReportFrame.FrameMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  FPreview.MouseWheelScroll(WheelDelta, False, ssCtrl in Shift);
end;

function TBisFastReportFrame.CanExportReport: Boolean;
begin
  Result:=inherited CanExportReport and FPrepared;
end;

procedure TBisFastReportFrame.ExportReport;
var
  Item: TMenuItem;
  i: Integer;
begin
  if CanExportReport then begin
    Item:=nil;
    for i:=0 to PopupExport.Items.Count-1 do begin
      if PopupExport.Items[i].Checked then begin
        Item:=PopupExport.Items[i];
        break;
      end;
    end;
    if Assigned(Item) then begin
      MenuExportClick(Item);
    end;
  end;
end;

function TBisFastReportFrame.PageExists(PageNum: Integer): Boolean;
begin
  Result:=FPreview.PageCount>=PageNum;
end;

procedure TBisFastReportFrame.SetPageNum(PageNum: Integer);
begin
  if PageExists(PageNum) then
    FPreview.PageNo:=PageNum;
end;

function TBisFastReportFrame.GetPageCount: Integer;
begin
  Result:=FPreview.PageCount;
end;

function TBisFastReportFrame.GetPageNum: Integer;
begin
  Result:=FPreview.PageNo;
end;

procedure TBisFastReportFrame.CreateByPattern;

begin
  FLoaded:=false;
  if Assigned(Pattern) then begin
    FPrepared:=FReport.PrepareReport(true);
    FLoaded:=true;
  end;
end;

type
  TBisDBTreeDataSet=class(TfrxDataset)
  private
    FTree: TBisDBTree;
    FCurrentNode: PVirtualNode;
  protected
    function GetDisplayText(Index: String): WideString; override;
    function GetValue(Index: String): Variant; override;
  public
    function FieldsCount: Integer; override;
    procedure GetFieldList(List: TStrings); override;
    procedure Initialize; override;
    procedure First; override;
    procedure Next; override;
    procedure Prior; override;
    function Eof: Boolean; override;
  end;

{ TBisDBTreeDataSet }

function TBisDBTreeDataSet.GetDisplayText(Index: String): WideString;
var
  Column: TBisDBTreeColumn;
begin
  Result:='';
  if Assigned(FTree) then begin
    Column:=FTree.Header.Columns.Find(Index);
    if Assigned(Column) and Assigned(FCurrentNode) then
      Result:=FTree.Text[FCurrentNode,Column.Index];
  end;
end;

function TBisDBTreeDataSet.GetValue(Index: String): Variant;
begin
  Result:=Null;
  if Assigned(FTree) then
    Result:=FTree.GetNodeValue(FCurrentNode,Index);
end;

procedure TBisDBTreeDataSet.Initialize;
begin
  inherited Initialize;
  FCurrentNode:=nil;
end;

function TBisDBTreeDataSet.FieldsCount: Integer;
begin
  Result:=inherited FieldsCount;
  if Assigned(FTree) then
    Result:=FTree.Header.Columns.VisibleCount;
end;

procedure TBisDBTreeDataSet.GetFieldList(List: TStrings);
var
  i: Integer;
  Item: TBisDBTreeColumn;
begin
  if Assigned(FTree) then begin
    for i:=0 to FTree.Header.Columns.Count-1 do begin
      Item:=FTree.Header.Columns[i];
      if (coVisible in Item.Options) and
          Assigned(Item.Field) then
        List.Add(Item.FieldName);
    end;
  end;
end;

procedure TBisDBTreeDataSet.First;
begin
  inherited First;
  FCurrentNode:=nil;
  if Assigned(FTree) then
    FCurrentNode:=FTree.GetFirst;
end;

procedure TBisDBTreeDataSet.Next;
begin
  inherited Next;
  if Assigned(FTree) then
    FCurrentNode:=FTree.GetNext(FCurrentNode);
end;

procedure TBisDBTreeDataSet.Prior;
begin
  inherited Prior;
  if Assigned(FTree) then
    FCurrentNode:=FTree.GetPrevious(FCurrentNode);
end;

function TBisDBTreeDataSet.Eof: Boolean;
begin
  Result:=inherited Eof;
  if Assigned(FTree) then
    Result:=not Assigned(FCurrentNode);
end;

procedure TBisFastReportFrame.ReportBeforePrepareReport(Sender: TObject);
var
  FirstPage: TfrxReportPage;

  procedure PrepareByTree(Tree: TBisDBTree);
  var
    ATop,ALeft: Integer;
    Page: TfrxReportPage;
    Memo: TfrxMemoView;
    Header: TfrxColumnHeader;
    DataBand: TfrxMasterData;
    Footer: TfrxFooter;
    i: Integer;
    Column: TBisDBTreeColumn;
    ReportDataSet: TBisDBTreeDataSet;
    Title: TfrxReportTitle;
    PageFooter: TfrxPageFooter;
    Stream: TMemoryStream;

    function ColumnNumeric: Boolean;
    begin
      Result:=false;
      if Assigned(Column.Field) then begin
        Result:=Column.Field.DataType in [ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftBCD];
      end;
    end;

    function GetHAlign: TfrxHAlign;
    begin
      Result:=haLeft;
      case Column.Alignment of
        taLeftJustify: Result:=haLeft;
        taRightJustify: Result:=haRight;
        taCenter: Result:=haCenter;
      end;
    end; 

    procedure SetDisplayFormat(Memo: TfrxMemoView);
    var
      S: String;
      Field: TField;
    const
      SPropertyDisplayFormat='DisplayFormat';
    begin
      Field:=Column.Field;
      if Assigned(Field) then begin
        S:='';
        if IsPublishedProp(Field,SPropertyDisplayFormat) then
          S:=GetStrProp(Field,SPropertyDisplayFormat);
        if S='' then
          S:=Column.DisplayFormat;

        Memo.DisplayFormat.DecimalSeparator:=DecimalSeparator;
        Memo.DisplayFormat.FormatStr:=S;
        case Field.DataType of
          ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftBCD: begin
            if Trim(S)<>'' then
              Memo.DisplayFormat.Kind:=fkNumeric;
          end;
          ftString, ftBlob, ftMemo, ftFixedChar, ftWideString: begin
            Memo.DisplayFormat.Kind:=fkText;
          end;
          ftDate, ftDateTime, ftTime, ftTimeStamp: begin
            Memo.DisplayFormat.Kind:=fkDateTime;
          end;
        end;
      end;
    end;

    
  begin
    Stream:=TMemoryStream.Create;
    try
      FReport.Clear;
      FReport.DataSets.Clear;

      Page:=TfrxReportPage.Create(FReport);
      Page.CreateUniqueName;
      if Assigned(FirstPage) then begin
        Page.Orientation:=FirstPage.Orientation;
        Page.PaperWidth:=FirstPage.PaperWidth;
        Page.PaperHeight:=FirstPage.PaperHeight;
        Page.PaperSize:=FirstPage.PaperSize;
        Page.LeftMargin:=FirstPage.LeftMargin;
        Page.RightMargin:=FirstPage.RightMargin;
        Page.TopMargin:=FirstPage.TopMargin;
        Page.BottomMargin:=FirstPage.BottomMargin;
      end else
        Page.SetDefaults;

      ReportDataSet:=TBisDBTreeDataSet.Create(FReport);
      ReportDataSet.CreateUniqueName;
      ReportDataSet.FTree:=Tree;

      FReport.DataSets.Add(ReportDataSet);

      ATop:=0;

      Title:=TfrxReportTitle.Create(Page);
      Title.CreateUniqueName;
      Title.Top:=ATop;
      Title.Stretched:=true;

      Memo:=TfrxMemoView.Create(Title);
      Memo.CreateUniqueName;
      Memo.Text:=Format('%s �� %s',[Caption,DateTimeToStr(Now)]);
      Memo.HAlign:=haCenter;
      Memo.VAlign:=vaCenter;
      Memo.Align:=baLeft;
      Memo.GapX:=10;
      Memo.StretchMode:=smMaxHeight;
      Memo.AutoWidth:=true;
      Memo.Font.Assign(Tree.Header.Font);
      Memo.Font.Size:=Memo.Font.Size+1;
      Memo.Font.Style:=[];

      Title.Height:=Memo.CalcHeight+5;
    
      Inc(ATop,Round(Title.Height));

      Header:=TfrxColumnHeader.Create(Page);
      Header.CreateUniqueName;
      Header.Height:=Tree.Header.Height;
      Header.Top:=ATop;

      Inc(ATop,Round(Header.Height));

      DataBand:=TfrxMasterData.Create(Page);
      DataBand.CreateUniqueName;
      DataBand.DataSet:=ReportDataSet;
      DataBand.Top:=ATop;
      DataBand.Height:=Tree.DefaultNodeHeight;

      Inc(ATop,Round(Header.Height));

      Footer:=TfrxFooter.Create(Page);
      Footer.CreateUniqueName;
      Footer.Top:=ATop;
      Footer.Height:=Tree.DefaultNodeHeight;

      ALeft:=0;

      Memo:=TfrxMemoView.Create(Header);
      Memo.CreateUniqueName;
      Memo.Text:='#';
      Memo.SetBounds(ALeft,0,40,Header.Height);
      Memo.Frame.Style:=fsSolid;
      Memo.Frame.Typ:=[ftLeft,ftRight,ftTop,ftBottom];
      Memo.Font.Assign(Tree.Header.Font);
      Memo.Font.Style:=[fsBold];
      Memo.Color:=Tree.Header.Background;
      Memo.HAlign:=haCenter;
      Memo.VAlign:=vaCenter;

      Memo:=TfrxMemoView.Create(DataBand);
      Memo.CreateUniqueName;
      Memo.Text:='[Line]';
      Memo.SetBounds(ALeft,0,40,DataBand.Height);
      Memo.Frame.Style:=fsSolid;
      Memo.Frame.Typ:=[ftLeft,ftRight,ftTop,ftBottom];
      Memo.Font.Assign(Tree.Font);
      Memo.Color:=Tree.Color;
      Memo.GapX:=4;
      Memo.HAlign:=haRight;
      Memo.VAlign:=vaCenter;

      Inc(ALeft,Round(Memo.Width));

      for i:=0 to Tree.Header.Columns.Count-1 do begin
        Column:=TBisDBTreeColumn(Tree.Header.Columns[i]);
        if (Column<>Tree.NavigatorColumn) and 
           (coVisible in Column.Options) and
           (Trim(Column.Text)<>'') then begin

          Memo:=TfrxMemoView.Create(Header);
          Memo.CreateUniqueName;
          Memo.Text:=Column.Text;
          Memo.SetBounds(ALeft,0,Column.Width,Header.Height);
          Memo.Frame.Style:=fsSolid;
          Memo.Frame.Typ:=[ftLeft,ftRight,ftTop,ftBottom];
          Memo.Font.Assign(Tree.Header.Font);
          Memo.Font.Style:=[fsBold];
          Memo.Color:=Tree.Header.Background;
          Memo.HAlign:=GetHAlign;
          Memo.GapX:=4;
          Memo.VAlign:=vaCenter;
          Memo.WordWrap:=false;

          Memo:=TfrxMemoView.Create(DataBand);
          Memo.CreateUniqueName;
          Memo.Text:=Format('[%s."%s"]',[DataBand.DataSetName,Column.FieldName]);
          Memo.DataSet:=DataBand.DataSet;
          Memo.DataField:=Column.FieldName;
          Memo.SetBounds(ALeft,0,Column.Width,DataBand.Height);
          Memo.Frame.Style:=fsSolid;
          Memo.Frame.Typ:=[ftLeft,ftRight,ftTop,ftBottom];
          Memo.Font.Assign(Tree.Font);
          Memo.Color:=Column.Color;
          Memo.HAlign:=GetHAlign;
          Memo.GapX:=4;
          Memo.VAlign:=vaCenter;
          Memo.WordWrap:=false;
          SetDisplayFormat(Memo);

          if ColumnNumeric then begin
            Memo:=TfrxMemoView.Create(Footer);
            Memo.CreateUniqueName;
            Memo.Text:=Format('[SUM(<%s."%s">)]',[DataBand.DataSetName,Column.FieldName]);
            Memo.SetBounds(ALeft,0,Column.Width,Footer.Height);
            Memo.Frame.Style:=fsSolid;
            Memo.Frame.Typ:=[ftLeft,ftRight,ftTop,ftBottom];
            Memo.Font.Assign(Tree.Font);
            Memo.Color:=Column.Color;
            Memo.Font.Style:=[fsBold];
            Memo.HAlign:=GetHAlign;
            Memo.GapX:=4;
            Memo.VAlign:=vaCenter;
            Memo.WordWrap:=false;
            SetDisplayFormat(Memo);
          end;

          ALeft:=ALeft+Column.Width;
        end;
      end;

      Inc(ATop,Round(DataBand.Height));

      PageFooter:=TfrxPageFooter.Create(Page);
      PageFooter.CreateUniqueName;
      PageFooter.Top:=ATop;
      PageFooter.Stretched:=true;

      Memo:=TfrxMemoView.Create(PageFooter);
      Memo.CreateUniqueName;
      Memo.Text:='[Page#] �� [TotalPages#]';
      Memo.HAlign:=haCenter;
      Memo.VAlign:=vaCenter;
      Memo.Align:=baRight;
      Memo.StretchMode:=smMaxHeight;
      Memo.AutoWidth:=true;
      Memo.Font.Assign(Tree.Header.Font);
      Memo.Font.Size:=Memo.Font.Size-1;

      if not Assigned(FirstPage) then
        if ALeft>(Page.Width-(Page.LeftMargin+Page.RightMargin)*fr01cm) then begin
          Page.Orientation:=poLandscape;
          Page.PaperWidth:=ALeft / fr01cm + Page.LeftMargin+Page.RightMargin;
        end;

    finally
      Stream.Free;
    end;
  end;   

begin
  FirstPage:=nil;
  if (FPreview.PreviewPages.Count>0) then
    FirstPage:=FPreview.PreviewPages.Page[FPreview.PageNo-1];
  if Assigned(Pattern) then begin
    if Pattern is TBisDBTree then
      PrepareByTree(TBisDBTree(Pattern))
  end;
  FPreview.PreviewPages.Clear;
  FPreview.UpdatePages;
end;

initialization
  RegisterClass(TBisDBTreeDataSet);

end.
