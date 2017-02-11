unit BisTaxiDataCodeMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisTaxiDataCodeMessageEditForm = class(TBisDataEditForm)
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

  TBisTaxiDataCodeMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCodeMessageFilterFormIface=class(TBisTaxiDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCodeMessageInsertFormIface=class(TBisTaxiDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCodeMessageUpdateFormIface=class(TBisTaxiDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCodeMessageDeleteFormIface=class(TBisTaxiDataCodeMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCodeMessageEditForm: TBisTaxiDataCodeMessageEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataCodeMessageEditFormIface }

constructor TBisTaxiDataCodeMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCodeMessageEditForm;
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

{ TBisTaxiDataCodeMessageFilterFormIface }

constructor TBisTaxiDataCodeMessageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр кодов сообщений';
end;

{ TBisTaxiDataCodeMessageInsertFormIface }

constructor TBisTaxiDataCodeMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CODE_MESSAGE';
  Caption:='Создать код сообщения';
end;

{ TBisTaxiDataCodeMessageUpdateFormIface }

constructor TBisTaxiDataCodeMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CODE_MESSAGE';
  Caption:='Изменить код сообщения';
end;

{ TBisTaxiDataCodeMessageDeleteFormIface }

constructor TBisTaxiDataCodeMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CODE_MESSAGE';
  Caption:='Удалить код сообщения';
end;

end.
