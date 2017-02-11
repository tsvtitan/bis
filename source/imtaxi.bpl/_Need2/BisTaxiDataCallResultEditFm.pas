unit BisTaxiDataCallResultEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisTaxiDataCallResultEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxVisible: TCheckBox;                                                                       
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataCallResultEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallResultFilterFormIface=class(TBisTaxiDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallResultInsertFormIface=class(TBisTaxiDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallResultUpdateFormIface=class(TBisTaxiDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallResultDeleteFormIface=class(TBisTaxiDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCallResultEditForm: TBisTaxiDataCallResultEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataCallResultEditFormIface }

constructor TBisTaxiDataCallResultEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCallResultEditForm;
  with Params do begin
    AddKey('CALL_RESULT_ID').Older('OLD_CALL_RESULT_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddCheckBox('VISIBLE','CheckBoxVisible');
  end;
end;

{ TBisTaxiDataCallResultFilterFormIface }

constructor TBisTaxiDataCallResultFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ����������� ������';
end;

{ TBisTaxiDataCallResultInsertFormIface }

constructor TBisTaxiDataCallResultInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CALL_RESULT';
  Caption:='������� ��������� ������';
end;

{ TBisTaxiDataCallResultUpdateFormIface }

constructor TBisTaxiDataCallResultUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CALL_RESULT';
  Caption:='�������� ��������� ������';
end;

{ TBisTaxiDataCallResultDeleteFormIface }

constructor TBisTaxiDataCallResultDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CALL_RESULT';
  Caption:='������� ��������� ������';
end;

end.
