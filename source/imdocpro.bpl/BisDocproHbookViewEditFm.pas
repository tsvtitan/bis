unit BisDocproHbookViewEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ComCtrls;

type
  TBisDocproHbookViewEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDocproHbookViewEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookViewInsertFormIface=class(TBisDocproHbookViewEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookViewUpdateFormIface=class(TBisDocproHbookViewEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookViewDeleteFormIface=class(TBisDocproHbookViewEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookViewEditForm: TBisDocproHbookViewEditForm;

implementation

{$R *.dfm}

{ TBisDocproHbookViewEditFormIface }

constructor TBisDocproHbookViewEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookViewEditForm;
  with Params do begin
    AddKey('VIEW_ID').Older('OLD_VIEW_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisDocproHbookViewInsertFormIface }

constructor TBisDocproHbookViewInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_VIEW';
end;

{ TBisDocproHbookViewUpdateFormIface }

constructor TBisDocproHbookViewUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_VIEW';
end;

{ TBisDocproHbookViewDeleteFormIface }

constructor TBisDocproHbookViewDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_VIEW';
end;

end.
