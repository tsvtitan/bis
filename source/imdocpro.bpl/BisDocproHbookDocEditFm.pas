unit BisDocproHbookDocEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls;

type
  TBisDocproHbookDocEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelView: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    LabelNum: TLabel;
    EditNum: TEdit;
    LabelDateDoc: TLabel;
    DateTimePickerDateDoc: TDateTimePicker;
  private
    { Private declarations }
  public
  end;

  TBisDocproHbookDocEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookDocInsertFormIface=class(TBisDocproHbookDocEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookDocUpdateFormIface=class(TBisDocproHbookDocEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookDocDeleteFormIface=class(TBisDocproHbookDocEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookDocEditForm: TBisDocproHbookDocEditForm;

implementation

uses BisDocproHbookViewsFm;

{$R *.dfm}

{ TBisDocproHbookDocEditFormIface }

constructor TBisDocproHbookDocEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookDocEditForm;
  with Params do begin
    AddKey('DOC_ID').Older('OLD_DOC_ID');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEditDate('DATE_DOC','DateTimePickerDateDoc','LabelDateDoc',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisDocproHbookViewsFormIface,'VIEW_NAME',true,false,'','NAME');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisDocproHbookDocInsertFormIface }

constructor TBisDocproHbookDocInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DOC';
end;

{ TBisDocproHbookDocUpdateFormIface }

constructor TBisDocproHbookDocUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DOC';
end;

{ TBisDocproHbookDocDeleteFormIface }

constructor TBisDocproHbookDocDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DOC';
end;

end.
