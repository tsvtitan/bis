unit BisMessDataPatternMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;
                                                                                                         
type
  TBisMessDataPatternMessageEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelText: TLabel;
    MemoText: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisMessDataPatternMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataPatternMessageFilterFormIface=class(TBisMessDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataPatternMessageInsertFormIface=class(TBisMessDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataPatternMessageUpdateFormIface=class(TBisMessDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataPatternMessageDeleteFormIface=class(TBisMessDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataPatternMessageEditForm: TBisMessDataPatternMessageEditForm;

implementation

{$R *.dfm}

{ TBisMessDataPatternMessageEditFormIface }

constructor TBisMessDataPatternMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataPatternMessageEditForm;
  with Params do begin
    AddKey('PATTERN_MESSAGE_ID').Older('OLD_PATTERN_MESSAGE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('TEXT_PATTERN','MemoText','LabelText',true);
  end;
end;

{ TBisMessDataPatternMessageFilterFormIface }

constructor TBisMessDataPatternMessageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������� ���������';
end;

{ TBisMessDataPatternMessageInsertFormIface }

constructor TBisMessDataPatternMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PATTERN_MESSAGE';
  Caption:='������� ������ ���������';
end;

{ TBisMessDataPatternMessageUpdateFormIface }

constructor TBisMessDataPatternMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PATTERN_MESSAGE';
  Caption:='�������� ������ ���������';
end;

{ TBisMessDataPatternMessageDeleteFormIface }

constructor TBisMessDataPatternMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PATTERN_MESSAGE';
  Caption:='������� ������ ���������';
end;

end.
