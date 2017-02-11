unit BisCallcHbookGroupEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookGroupEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPattern: TLabel;
    EditPattern: TEdit;
    ButtonPattern: TButton;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookGroupEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookGroupInsertFormIface=class(TBisCallcHbookGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookGroupUpdateFormIface=class(TBisCallcHbookGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookGroupDeleteFormIface=class(TBisCallcHbookGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookGroupEditForm: TBisCallcHbookGroupEditForm;

implementation

uses BisCallcHbookGroupsFm, BisCallcHbookPatternsFm;

{$R *.dfm}

{ TBisCallcHbookGroupEditFormIface }

constructor TBisCallcHbookGroupEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookGroupEditForm;
  with Params do begin
    AddKey('GROUP_ID').Older('OLD_GROUP_ID');
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisCallcHbookGroupsFormIface,'PARENT_NAME',false,false,'GROUP_ID','NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditDataSelect('PATTERN_ID','EditPattern','LabelPattern','ButtonPattern',
                      TBisCallcHbookPatternsFormIface,'PATTERN_NAME',false,false,'','NAME');
  end;
end;

{ TBisCallcHbookGroupInsertFormIface }

constructor TBisCallcHbookGroupInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_GROUP';
end;

{ TBisCallcHbookGroupUpdateFormIface }

constructor TBisCallcHbookGroupUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_GROUP';
end;

{ TBisCallcHbookGroupDeleteFormIface }

constructor TBisCallcHbookGroupDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_GROUP';
end;

end.