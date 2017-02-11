unit BisBallTirageSubroundEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisBallTirageSubroundEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelRoundNum: TLabel;
    LabelPercent: TLabel;
    EditPercent: TEdit;
    ComboBoxRoundNum: TComboBox;
    procedure EditPriorityChange(Sender: TObject);
  private
  public
  end;

  TBisBallTirageSubroundEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallTirageSubroundFilterFormIface=class(TBisBallTirageSubroundEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallTirageSubroundInsertFormIface=class(TBisBallTirageSubroundEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallTirageSubroundUpdateFormIface=class(TBisBallTirageSubroundEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallTirageSubroundDeleteFormIface=class(TBisBallTirageSubroundEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallTirageSubroundEditForm: TBisBallTirageSubroundEditForm;

implementation

uses
     BisUtils, BisBallConsts, 
     BisValues;

{$R *.dfm}

{ TBisBallTirageSubroundEditFormIface }

constructor TBisBallTirageSubroundEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallTirageSubroundEditForm;
  with Params do begin
    AddKey('SUBROUND_ID').Older('OLD_SUBROUND_ID');
    AddInvisible('TIRAGE_ID');
    AddComboBoxText('ROUND_NUM','ComboBoxRoundNum','LabelRoundNum',true).ExcludeModes(AllParamEditModes);
    AddEdit('NAME','EditName','LabelName',true);
    AddEditCalc('PERCENT','EditPercent','LabelPercent',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisBallTirageSubroundFilterFormIface }

constructor TBisBallTirageSubroundFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ��������';
end;

{ TBisBallTirageSubroundInsertFormIface }

constructor TBisBallTirageSubroundInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SUBROUND';
  Caption:='������� ������';
end;

{ TBisBallTirageSubroundUpdateFormIface }

constructor TBisBallTirageSubroundUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SUBROUND';
  Caption:='�������� ������';
end;

{ TBisBallTirageSubroundDeleteFormIface }

constructor TBisBallTirageSubroundDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SUBROUND';
  Caption:='������� ������';
end;


procedure TBisBallTirageSubroundEditForm.EditPriorityChange(Sender: TObject);
var
  PName: TBisParam;
  PPriority: TBisParam;
begin
  PName:=Provider.ParamByName('NAME');
  PPriority:=Provider.ParamByName('PRIORITY');
  if Assigned(PName) and not PPriority.Empty then begin
    PName.Value:=FormatEx('%s ������',[FormatFloat('#00',PPriority.AsInteger)]);
  end;
end;

end.
