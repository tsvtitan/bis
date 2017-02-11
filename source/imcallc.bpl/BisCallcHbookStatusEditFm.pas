unit BisCallcHbookStatusEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookStatusEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelCondition: TLabel;
    MemoCondition: TMemo;
    LabelTableName: TLabel;
    EditTableName: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookStatusEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookStatusInsertFormIface=class(TBisCallcHbookStatusEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookStatusUpdateFormIface=class(TBisCallcHbookStatusEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookStatusDeleteFormIface=class(TBisCallcHbookStatusEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookStatusEditForm: TBisCallcHbookStatusEditForm;

implementation

{$R *.dfm}

{ TBisCallcHbookStatusEditFormIface }

constructor TBisCallcHbookStatusEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookStatusEditForm;
  with Params do begin
    AddKey('STATUS_ID').Older('OLD_STATUS_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('TABLE_NAME','EditTableName','LabelTableName',true);
    AddMemo('CONDITION','MemoCondition','LabelCondition',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisCallcHbookStatusInsertFormIface }

constructor TBisCallcHbookStatusInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_STATUS';
end;

{ TBisCallcHbookStatusUpdateFormIface }

constructor TBisCallcHbookStatusUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_STATUS';
end;

{ TBisCallcHbookStatusDeleteFormIface }

constructor TBisCallcHbookStatusDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_STATUS';
end;

end.
