unit BisKrieltDataExportEditFm;

interface                                                                                       

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs, CheckLst, ImgList,
  BisFm, BisDataFrm, BisDataEditFm, BisParam, BisSynEdit,
  BisKrieltDataPatternsFm,
  BisControls;

type
  TBisKrieltDataExportEditForm = class(TBisDataEditForm)
    PageControl: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheetPatterns: TTabSheet;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelExport: TLabel;
    EditExport: TEdit;
    EditView: TEdit;
    ButtonView: TButton;
    LabelView: TLabel;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelOperation: TLabel;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelCond: TLabel;
    ComboBoxCond: TComboBox;
    LabelValue: TLabel;
    EditValue: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    TabSheetSorting: TTabSheet;
    MemoSorting: TMemo;
    TabSheetRtf: TTabSheet;
    GridPanelRtf: TGridPanel;
    GroupBoxHeadRtf: TGroupBox;
    MemoHeadRtf: TMemo;
    GroupBoxBodyRtf: TGroupBox;
    MemoBodyRtf: TMemo;
    CheckBoxDisabled: TCheckBox;
    procedure PageControlChange(Sender: TObject);
  private
    FPatternFrame: TBisKrieltDataPatternsFrame;
    FXmlHighlighter: TBisSynXmlSyn;
    FMemoHeadRtf: TBisSynEdit;
    FMemoBodyRtf: TBisSynEdit;

    procedure MemoHeadRtfChange(Sender: TObject);
    procedure MemoBodyRtfChange(Sender: TObject);
    function FrameCan(Sender: TBisDataFrame): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;

  end;

  TBisKrieltDataExportEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataExportInsertFormIface=class(TBisKrieltDataExportEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataExportInsertChildFormIface=class(TBisKrieltDataExportEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataExportUpdateFormIface=class(TBisKrieltDataExportEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataExportDeleteFormIface=class(TBisKrieltDataExportEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataExportEditForm: TBisKrieltDataExportEditForm;

implementation

uses BisProvider, BisFilterGroups, BisUtils, BisCore,
     BisKrieltDataExportsFm, BisKrieltDataParamsFm, BisKrieltDataParamEditFm,
     BisKrieltDataViewsFm, BisKrieltDataViewTypesFm, BisKrieltDataOperationsFm;

{$R *.dfm}

{ TBisKrieltDataExportEditFormIface }

constructor TBisKrieltDataExportEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataExportEditForm;
  with Params do begin
    AddKey('EXPORT_ID').Older('OLD_EXPORT_ID');
    AddInvisible('VIEW_NAME');
    AddInvisible('VIEW_NUM');
    AddInvisible('TYPE_NAME');
    AddInvisible('TYPE_NUM');
    AddInvisible('OPERATION_NAME');
    AddInvisible('OPERATION_NUM');
    AddInvisible('HEAD_RTF').CaptionName:='GroupBoxHeadRtf';
    AddInvisible('BODY_RTF').CaptionName:='GroupBoxBodyRtf';
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisKrieltDataExportsFormIface,'PARENT_NAME',false,false,'EXPORT_ID','NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('EXPORT','EditExport','LabelExport');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisKrieltDataViewsFormIface,'VIEW_NUM;VIEW_NAME',false,false,'','NUM;NAME').DataAliasFormat:='%s - %s';
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataViewTypesFormIface,'TYPE_NUM;TYPE_NAME',false,false,'','').DataAliasFormat:='%s - %s';
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataOperationsFormIface,'OPERATION_NUM;OPERATION_NAME',false,false,'','NUM;NAME').DataAliasFormat:='%s - %s';
    with AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                           TBisKrieltDataParamsFormIface,'PARAM_NAME',false,false,'','NAME') do begin
    end;
    AddComboBoxIndex('COND','ComboBoxCond','LabelCond');
    AddEdit('VALUE','EditValue','LabelValue');
    AddMemo('SORTING','MemoSorting','').CaptionName:='TabSheetSorting';
    AddCheckBox('DISABLED','CheckBoxDisabled');
  end;
end;

{ TBisKrieltDataExportInsertFormIface }

constructor TBisKrieltDataExportInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_EXPORT';
  Caption:='������� �������';
end;

function TBisKrieltDataExportInsertFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('PARENT_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('PARENT_NAME').Value);
      end;
    end;
  end;
end;

{ TBisKrieltDataExportInsertChildFormIface }

constructor TBisKrieltDataExportInsertChildFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_EXPORT';
  Caption:='������� �������� �������';
end;


function TBisKrieltDataExportInsertChildFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('EXPORT_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('NAME').Value);
      end;
    end;
  end;
end;

{ TBisKrieltDataExportUpdateFormIface }

constructor TBisKrieltDataExportUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_EXPORT';
end;

{ TBisKrieltDataExportDeleteFormIface }

constructor TBisKrieltDataExportDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_EXPORT';
end;

{ TBisKrieltDataExportEditForm }

constructor TBisKrieltDataExportEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FXmlHighlighter:=TBisSynXmlSyn.Create(Self);

  FMemoHeadRtf:=TBisSynEdit.Create(Self);
  FMemoHeadRtf.Parent:=GroupBoxHeadRtf;
  FMemoHeadRtf.Align:=alClient;
  FMemoHeadRtf.Highlighter:=FXmlHighlighter;
  FMemoHeadRtf.AlignWithMargins:=true;
  FMemoHeadRtf.Margins.Assign(MemoHeadRtf.Margins);
  FMemoHeadRtf.RightEdge:=120;
  FMemoHeadRtf.Gutter.Width:=20;
  FMemoHeadRtf.OnChange:=MemoHeadRtfChange;

  MemoHeadRtf.Free;
  MemoHeadRtf:=nil;

  FMemoBodyRtf:=TBisSynEdit.Create(Self);
  FMemoBodyRtf.Parent:=GroupBoxBodyRtf;
  FMemoBodyRtf.Align:=alClient;
  FMemoBodyRtf.Highlighter:=FXmlHighlighter;
  FMemoBodyRtf.AlignWithMargins:=true;
  FMemoBodyRtf.Margins.Assign(MemoBodyRtf.Margins);
  FMemoBodyRtf.RightEdge:=120;
  FMemoBodyRtf.Gutter.Width:=20;
  FMemoBodyRtf.OnChange:=MemoBodyRtfChange;

  MemoBodyRtf.Free;
  MemoBodyRtf:=nil;

  FPatternFrame:=TBisKrieltDataPatternsFrame.Create(nil);
  with FPatternFrame do begin
    Parent:=TabSheetPatterns;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('EXPORT_NAME').Visible:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;
  
end;

destructor TBisKrieltDataExportEditForm.Destroy;
begin
  FPatternFrame.Free;
  inherited Destroy;
end;

function TBisKrieltDataExportEditForm.FrameCan(Sender: TBisDataFrame): Boolean;
begin
  Result:=Mode in [emUpdate];
end;

procedure TBisKrieltDataExportEditForm.Init;
begin
  inherited Init;
  FPatternFrame.Init;
end;

procedure TBisKrieltDataExportEditForm.PageControlChange(Sender: TObject);
var
  Param: TBisParam;
begin
  if PageControl.ActivePage=TabSheetPatterns then begin
 //  GridPanelRtf.Height:=GridPanelRtf.Height+1;
    Param:=Provider.Params.ParamByName('EXPORT_ID');
    if not Param.Empty then begin
      with FPatternFrame do begin
        ExportId:=Param.Value;
        ExportName:=Self.Provider.Params.ParamByName('NAME').AsString;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('EXPORT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;
end;

procedure TBisKrieltDataExportEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'') then begin

  end;
end;

procedure TBisKrieltDataExportEditForm.BeforeShow;
var
  Exists: Boolean;
begin
  inherited BeforeShow;

  PageControl.TabIndex:=0;

  Exists:=Mode in [emUpdate,emDelete,emView];
  TabSheetPatterns.TabVisible:=Exists;

  FPatternFrame.BeforeShow;
  
  if Mode in [emDelete] then begin
    EnableControl(TabSheetMain,false);
    EnableControl(TabSheetRtf,false);
    EnableControl(TabSheetPatterns,false);
    EnableControl(TabSheetSorting,false);
  end else begin
    FPatternFrame.ShowType:=ShowType;
  end;

  if Mode in [emUpdate,emDuplicate,emDelete,emView] then begin
    FMemoHeadRtf.OnChange:=nil;
    FMemoBodyRtf.OnChange:=nil;
    try
      FMemoHeadRtf.Text:=Provider.ParamByName('HEAD_RTF').AsString;
      FMemoBodyRtf.Text:=Provider.ParamByName('BODY_RTF').AsString;
    finally
      FMemoHeadRtf.OnChange:=MemoHeadRtfChange;
      FMemoBodyRtf.OnChange:=MemoBodyRtfChange;
    end;
  end;

  GridPanelRtf.Height:=GridPanelRtf.Height+1;
end;

procedure TBisKrieltDataExportEditForm.MemoBodyRtfChange(Sender: TObject);
begin
  Provider.ParamByName('BODY_RTF').Value:=FMemoBodyRtf.Text;
end;

procedure TBisKrieltDataExportEditForm.MemoHeadRtfChange(Sender: TObject);
begin
  Provider.ParamByName('HEAD_RTF').Value:=FMemoHeadRtf.Text;
end;


end.
