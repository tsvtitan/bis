unit BisKrieltDataOperationEditFm;

interface                                                                                               

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ComCtrls, ImgList;

type
  TBisKrieltDataOperationEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    LabelDescription: TLabel;
    LabelNum: TLabel;
    EditName: TEdit;
    MemoDescription: TMemo;
    EditNum: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataOperationEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataOperationInsertFormIface=class(TBisKrieltDataOperationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataOperationUpdateFormIface=class(TBisKrieltDataOperationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataOperationDeleteFormIface=class(TBisKrieltDataOperationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataOperationEditForm: TBisKrieltDataOperationEditForm;

implementation

{$R *.dfm}

{ TBisKrieltDataOperationEditFormIface }

constructor TBisKrieltDataOperationEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataOperationEditForm;
  with Params do begin
    AddKey('OPERATION_ID').Older('OLD_OPERATION_ID');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisKrieltDataOperationInsertFormIface }

constructor TBisKrieltDataOperationInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_OPERATION';
end;

{ TBisKrieltDataOperationUpdateFormIface }

constructor TBisKrieltDataOperationUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OPERATION';
end;

{ TBisKrieltDataOperationDeleteFormIface }

constructor TBisKrieltDataOperationDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OPERATION';
end;

end.