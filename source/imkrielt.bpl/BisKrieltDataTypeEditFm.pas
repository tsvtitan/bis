unit BisKrieltDataTypeEditFm;

interface
                                                                                                  
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisKrieltDataTypeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    LabelDescription: TLabel;
    LabelNum: TLabel;
    EditName: TEdit;
    MemoDescription: TMemo;
    EditNum: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisKrieltDataTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeInsertFormIface=class(TBisKrieltDataTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeUpdateFormIface=class(TBisKrieltDataTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeDeleteFormIface=class(TBisKrieltDataTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataTypeEditForm: TBisKrieltDataTypeEditForm;

implementation

{$R *.dfm}

{ TBisKrieltDataTypeEditFormIface }

constructor TBisKrieltDataTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataTypeEditForm;
  with Params do begin
    AddKey('TYPE_ID').Older('OLD_TYPE_ID');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisKrieltDataTypeInsertFormIface }

constructor TBisKrieltDataTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TYPE';
end;

{ TBisKrieltDataTypeUpdateFormIface }

constructor TBisKrieltDataTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TYPE';
end;

{ TBisKrieltDataTypeDeleteFormIface }

constructor TBisKrieltDataTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TYPE';
end;


end.
