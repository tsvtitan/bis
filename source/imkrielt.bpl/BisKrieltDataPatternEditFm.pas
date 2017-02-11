unit BisKrieltDataPatternEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  BisDataEditFm, BisParam, BisSynEdit, BisControls;

type
  TBisKrieltDataPatternEditForm = class(TBisDataEditForm)
    LabelExport: TLabel;
    EditExport: TEdit;
    ButtonExport: TButton;
    LabelDesign: TLabel;
    PageControl: TPageControl;
    TabSheetRtf: TTabSheet;
    MemoRtf: TMemo;
    ComboBoxDesign: TComboBox;
  private
    FXmlHighlighter: TBisSynXmlSyn;
    FMemoRtf: TBisSynEdit;
    procedure MemoRtfChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataPatternEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPatternInsertFormIface=class(TBisKrieltDataPatternEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPatternUpdateFormIface=class(TBisKrieltDataPatternEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPatternDeleteFormIface=class(TBisKrieltDataPatternEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPatternEditForm: TBisKrieltDataPatternEditForm;

implementation

uses BisUtils, BisCore, BisFilterGroups,
     BisKrieltDataExportsFm, BisKrieltDataDesignsFm;

{$R *.dfm}

{ TBisKrieltDataPatternEditFormIface }

constructor TBisKrieltDataPatternEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPatternEditForm;
  with Params do begin
    AddInvisible('RTF').CaptionName:='TabSheetRtf';
    AddEditDataSelect('EXPORT_ID','EditExport','LabelExport','ButtonExport',
                      TBisKrieltDataExportsFormIface,'EXPORT_NAME',true,true,'','NAME').Older('OLD_EXPORT_ID');
    AddComboBoxDataSelect('DESIGN_ID','ComboBoxDesign','LabelDesign','ButtonDesign',
                          TBisKrieltDataDesignsFormIface,'DESIGN_NAME',true,true,'','NAME').Older('OLD_DESIGN_ID');
  end;
end;

{ TBisKrieltDataPatternInsertFormIface }

constructor TBisKrieltDataPatternInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PATTERN';
  Caption:='������� ������';
end;

{ TBisKrieltDataPatternUpdateFormIface }

constructor TBisKrieltDataPatternUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PATTERN';
  Caption:='�������� ������';
end;

{ TBisKrieltDataPatternDeleteFormIface }

constructor TBisKrieltDataPatternDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PATTERN';
  Caption:='������� ������';
end;

{ TBisKrieltDataPatternEditForm }

constructor TBisKrieltDataPatternEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FXmlHighlighter:=TBisSynXmlSyn.Create(Self);

  FMemoRtf:=TBisSynEdit.Create(Self);
  FMemoRtf.Parent:=TabSheetRtf;
  FMemoRtf.Align:=alClient;
  FMemoRtf.Highlighter:=FXmlHighlighter;
  FMemoRtf.AlignWithMargins:=true;
  FMemoRtf.Margins.Assign(MemoRtf.Margins);
  FMemoRtf.RightEdge:=120;
  FMemoRtf.Gutter.Width:=20;
  FMemoRtf.OnChange:=MemoRtfChange;

  MemoRtf.Free;
  MemoRtf:=nil;

end;

procedure TBisKrieltDataPatternEditForm.BeforeShow;
begin
  inherited BeforeShow;

  if Mode in [emUpdate,emDuplicate,emDelete,emView] then begin
    FMemoRtf.OnChange:=nil;
    try
      FMemoRtf.Text:=Provider.ParamByName('RTF').AsString;
    finally
      FMemoRtf.OnChange:=MemoRtfChange;
    end;
  end;

end;

procedure TBisKrieltDataPatternEditForm.MemoRtfChange(Sender: TObject);
begin
  Provider.ParamByName('RTF').Value:=FMemoRtf.Text;
end;

end.