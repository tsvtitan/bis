unit BisMessDataCodeMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisMessDataCodeMessageEditForm = class(TBisDataEditForm)
    LabelCode: TLabel;
    EditCode: TEdit;                                                                              
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelProcName: TLabel;
    EditProcName: TEdit;
    LabelCommandString: TLabel;
    EditCommandString: TEdit;
    CheckBoxEnabled: TCheckBox;
    LabelAnswer: TLabel;
    MemoAnswer: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisMessDataCodeMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataCodeMessageFilterFormIface=class(TBisMessDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataCodeMessageInsertFormIface=class(TBisMessDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataCodeMessageUpdateFormIface=class(TBisMessDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataCodeMessageDeleteFormIface=class(TBisMessDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCodeMessageEditForm: TBisMessDataCodeMessageEditForm;

implementation

{$R *.dfm}

{ TBisMessDataCodeMessageEditFormIface }

constructor TBisMessDataCodeMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataCodeMessageEditForm;
  with Params do begin
    AddKey('CODE_MESSAGE_ID').Older('OLD_CODE_MESSAGE_ID');
    AddEdit('CODE','EditCode','LabelCode',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEdit('PROC_NAME','EditProcName','LabelProcName');
    AddEdit('COMMAND_STRING','EditCommandString','LabelCommandString');
    AddMemo('ANSWER','MemoAnswer','LabelAnswer');
    AddCheckBox('ENABLED','CheckBoxEnabled');
  end;
end;

{ TBisMessDataCodeMessageFilterFormIface }

constructor TBisMessDataCodeMessageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр кодов сообщений';
end;

{ TBisMessDataCodeMessageInsertFormIface }

constructor TBisMessDataCodeMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CODE_MESSAGE';
  Caption:='Создать код сообщения';
end;

{ TBisMessDataCodeMessageUpdateFormIface }

constructor TBisMessDataCodeMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CODE_MESSAGE';
  Caption:='Изменить код сообщения';
end;

{ TBisMessDataCodeMessageDeleteFormIface }

constructor TBisMessDataCodeMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CODE_MESSAGE';
  Caption:='Удалить код сообщения';
end;

end.
