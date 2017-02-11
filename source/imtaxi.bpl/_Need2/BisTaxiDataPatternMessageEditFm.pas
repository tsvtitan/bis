unit BisTaxiDataPatternMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;
                                                                                                         
type
  TBisTaxiDataPatternMessageEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelText: TLabel;
    MemoText: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataPatternMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataPatternMessageFilterFormIface=class(TBisTaxiDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataPatternMessageInsertFormIface=class(TBisTaxiDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataPatternMessageUpdateFormIface=class(TBisTaxiDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataPatternMessageDeleteFormIface=class(TBisTaxiDataPatternMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataPatternMessageEditForm: TBisTaxiDataPatternMessageEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataPatternMessageEditFormIface }

constructor TBisTaxiDataPatternMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataPatternMessageEditForm;
  with Params do begin
    AddKey('PATTERN_MESSAGE_ID').Older('OLD_PATTERN_MESSAGE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('TEXT_PATTERN','MemoText','LabelText',true);
  end;
end;

{ TBisTaxiDataPatternMessageFilterFormIface }

constructor TBisTaxiDataPatternMessageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр шаблонов сообщений';
end;

{ TBisTaxiDataPatternMessageInsertFormIface }

constructor TBisTaxiDataPatternMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PATTERN_MESSAGE';
  Caption:='Создать шаблон сообщения';
end;

{ TBisTaxiDataPatternMessageUpdateFormIface }

constructor TBisTaxiDataPatternMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PATTERN_MESSAGE';
  Caption:='Изменить шаблон сообщения';
end;

{ TBisTaxiDataPatternMessageDeleteFormIface }

constructor TBisTaxiDataPatternMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PATTERN_MESSAGE';
  Caption:='Удалить шаблон сообщения';
end;

end.
