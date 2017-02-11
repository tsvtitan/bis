unit BisTaxiDataResultEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;
                                                                                                      
type
  TBisTaxiDataResultEditForm = class(TBisDataEditForm)
    LabelAction: TLabel;
    EditAction: TEdit;
    LabelNext: TLabel;
    EditNext: TEdit;
    ButtonNext: TButton;
    LabelName: TLabel;
    LabelDescription: TLabel;
    LabelFontColor: TLabel;
    LabelBrushColor: TLabel;
    LabelProcDetect: TLabel;
    EditName: TEdit;
    ColorBoxFontColor: TColorBox;
    MemoDescription: TMemo;
    ColorBoxBrushColor: TColorBox;
    EditProcDetect: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelProcProcess: TLabel;
    EditProcProcess: TEdit;
    CheckBoxVisible: TCheckBox;
  private
  public
  end;

  TBisTaxiDataResultEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataResultFilterFormIface=class(TBisTaxiDataResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataResultInsertFormIface=class(TBisTaxiDataResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataResultUpdateFormIface=class(TBisTaxiDataResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataResultDeleteFormIface=class(TBisTaxiDataResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataResultEditForm: TBisTaxiDataResultEditForm;

implementation

uses DB, BisUtils, BisTaxiConsts, BisTaxiDataActionsFm;

{$R *.dfm}

{ TBisTaxiDataResultEditFormIface }

constructor TBisTaxiDataResultEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataResultEditForm;
  with Params do begin
    AddKey('RESULT_ID').Older('OLD_RESULT_ID');
    AddInvisible('ACTION_ID');
    AddEdit('ACTION_NAME','EditAction','LabelAction').ExcludeModes(AllParamEditModes);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDataSelect('NEXT_ID','EditNext','LabelNext','ButtonNext',
                      TBisTaxiDataActionsFormIface,'NEXT_NAME',false,false,'ACTION_ID','NAME');
    AddEdit('PROC_DETECT','EditProcDetect','LabelProcDetect');
    AddEdit('PROC_PROCESS','EditProcProcess','LabelProcProcess');
    AddColorBox('FONT_COLOR','ColorBoxFontColor','LabelFontColor');
    AddColorBox('BRUSH_COLOR','ColorBoxBrushColor','LabelBrushColor');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddCheckBox('VISIBLE','CheckBoxVisible');
  end;
end;

{ TBisTaxiDataResultFilterFormIface }

constructor TBisTaxiDataResultFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �����������';
end;

{ TBisTaxiDataResultInsertFormIface }

constructor TBisTaxiDataResultInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_RESULT';
  Caption:='������� ���������';
end;

{ TBisTaxiDataResultUpdateFormIface }

constructor TBisTaxiDataResultUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_RESULT';
  Caption:='�������� ���������';
end;

{ TBisTaxiDataResultDeleteFormIface }

constructor TBisTaxiDataResultDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_RESULT';
  Caption:='������� ���������';
end;

end.
