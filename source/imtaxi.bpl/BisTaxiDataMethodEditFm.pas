unit BisTaxiDataMethodEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDataMethodEditForm = class(TBisDataEditForm)                                                     
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    GroupBoxIncoming: TGroupBox;
    GroupBoxOutgoing: TGroupBox;
    ComboBoxOutgoing: TComboBox;
    CheckBoxInMessage: TCheckBox;
    CheckBoxInQuery: TCheckBox;
    CheckBoxInCall: TCheckBox;
    LabelDestPort: TLabel;
    EditDestPort: TEdit;
  private
  public
  end;

  TBisTaxiDataMethodEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMethodFilterFormIface=class(TBisTaxiDataMethodEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMethodInsertFormIface=class(TBisTaxiDataMethodEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMethodUpdateFormIface=class(TBisTaxiDataMethodEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMethodDeleteFormIface=class(TBisTaxiDataMethodEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataMethodEditForm: TBisTaxiDataMethodEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataMethodEditFormIface }

constructor TBisTaxiDataMethodEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataMethodEditForm;
  with Params do begin
    AddKey('METHOD_ID').Older('OLD_METHOD_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddCheckBox('IN_MESSAGE','CheckBoxInMessage');
    AddCheckBox('IN_QUERY','CheckBoxInQuery');
    AddCheckBox('IN_CALL','CheckBoxInCall');
    AddComboBox('OUTGOING','ComboBoxOutgoing','LabelOutgoing',true).Value:=0;
    AddEditInteger('DEST_PORT','EditDestPort','LabelDestPort');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataMethodFilterFormIface }

constructor TBisTaxiDataMethodFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ��������';
end;

{ TBisTaxiDataMethodInsertFormIface }

constructor TBisTaxiDataMethodInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_METHOD';
  Caption:='������� ������';
end;

{ TBisTaxiDataMethodUpdateFormIface }

constructor TBisTaxiDataMethodUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_METHOD';
  Caption:='�������� ������';
end;

{ TBisTaxiDataMethodDeleteFormIface }

constructor TBisTaxiDataMethodDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_METHOD';
  Caption:='������� ������';
end;

end.
