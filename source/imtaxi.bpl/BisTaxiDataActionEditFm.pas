unit BisTaxiDataActionEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type                                                                                                              
  TBisTaxiDataActionEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    ColorBoxFontColor: TColorBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelFontColor: TLabel;
    LabelPeriod: TLabel;
    EditPeriod: TEdit;
    LabelBrushColor: TLabel;
    ColorBoxBrushColor: TColorBox;
    LabelProcDetect: TLabel;
    EditProcDetect: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataActionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionFilterFormIface=class(TBisTaxiDataActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionInsertFormIface=class(TBisTaxiDataActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionUpdateFormIface=class(TBisTaxiDataActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionDeleteFormIface=class(TBisTaxiDataActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataActionEditForm: TBisTaxiDataActionEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataActionEditFormIface }

constructor TBisTaxiDataActionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataActionEditForm;
  with Params do begin
    AddKey('ACTION_ID').Older('OLD_ACTION_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEdit('PROC_DETECT','EditProcDetect','LabelProcDetect');
    AddColorBox('FONT_COLOR','ColorBoxFontColor','LabelFontColor');
    AddColorBox('BRUSH_COLOR','ColorBoxBrushColor','LabelBrushColor');
    AddEditInteger('PERIOD','EditPeriod','LabelPeriod');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataActionFilterFormIface }

constructor TBisTaxiDataActionFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр действий';
end;

{ TBisTaxiDataActionInsertFormIface }

constructor TBisTaxiDataActionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACTION';
  Caption:='Создать действие';
end;

{ TBisTaxiDataActionUpdateFormIface }

constructor TBisTaxiDataActionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACTION';
  Caption:='Изменить действие';
end;

{ TBisTaxiDataActionDeleteFormIface }

constructor TBisTaxiDataActionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACTION';
  Caption:='Удалить действие';
end;

end.
