unit BisKrieltDataColumnEditFm;

interface
                                                                                                
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type

  TBisKrieltDataColumnEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPresentation: TLabel;
    EditPresentation: TEdit;
    ButtonPresentation: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelDefault: TLabel;
    EditDefault: TEdit;
    CheckBoxVisible: TCheckBox;
    CheckBoxUseDepend: TCheckBox;
    CheckBoxNotEmpty: TCheckBox;
    LabelWidth: TLabel;
    EditWidth: TEdit;
    LabelAlign: TLabel;
    ComboBoxAlign: TComboBox;
    EditSearchPriority: TEdit;
    LabelSearchPriority: TLabel;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnFilterFormIface=class(TBisKrieltDataColumnEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnInsertFormIface=class(TBisKrieltDataColumnEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnUpdateFormIface=class(TBisKrieltDataColumnEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnDeleteFormIface=class(TBisKrieltDataColumnEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataColumnEditForm: TBisKrieltDataColumnEditForm;

implementation

uses BisKrieltDataPresentationsFm;

{$R *.dfm}

{ TBisKrieltDataColumnEditFormIface }

constructor TBisKrieltDataColumnEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataColumnEditForm;
  with Params do begin
    AddKey('COLUMN_ID').Older('OLD_COLUMN_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddEditDataSelect('PRESENTATION_ID','EditPresentation','LabelPresentation','ButtonPresentation',
                      TBisKrieltDataPresentationsFormIface,'PRESENTATION_NAME',true,false,'','NAME');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('VALUE_DEFAULT','EditDefault','LabelDefault');
    AddComboBoxIndex('ALIGN','ComboBoxAlign','LabelAlign',true).Value:=0;
    AddEdit('WIDTH','EditWidth','LabelWidth');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddEditInteger('SEARCH_PRIORITY','EditSearchPriority','LabelSearchPriority');
    AddCheckBox('VISIBLE','CheckBoxVisible').ExcludeModes([emFilter]);
    AddCheckBox('USE_DEPEND','CheckBoxUseDepend').ExcludeModes([emFilter]);
    AddCheckBox('NOT_EMPTY','CheckBoxNotEmpty').ExcludeModes([emFilter]);
  end;
end;

{ TBisKrieltDataColumnFilterFormIface }

constructor TBisKrieltDataColumnFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataColumnInsertFormIface }

constructor TBisKrieltDataColumnInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_COLUMN';
end;

{ TBisKrieltDataColumnUpdateFormIface }

constructor TBisKrieltDataColumnUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_COLUMN';
end;

{ TBisKrieltDataColumnDeleteFormIface }

constructor TBisKrieltDataColumnDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_COLUMN';
end;

{ TBisKrieltDataColumnEditForm }

constructor TBisKrieltDataColumnEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
