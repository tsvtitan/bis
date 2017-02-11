unit BisDesignDataFirmTypeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                  
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisDesignDataFirmTypeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataFirmTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataFirmTypeInsertFormIface=class(TBisDesignDataFirmTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataFirmTypeUpdateFormIface=class(TBisDesignDataFirmTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataFirmTypeDeleteFormIface=class(TBisDesignDataFirmTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataFirmTypeEditForm: TBisDesignDataFirmTypeEditForm;

implementation

{$R *.dfm}

{ TBisDesignDataFirmTypeEditFormIface }

constructor TBisDesignDataFirmTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataFirmTypeEditForm;
  with Params do begin
    AddKey('FIRM_TYPE_ID').Older('OLD_FIRM_TYPE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisDesignDataFirmTypeInsertFormIface }

constructor TBisDesignDataFirmTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_FIRM_TYPE';
end;

{ TBisDesignDataFirmTypeUpdateFormIface }

constructor TBisDesignDataFirmTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_FIRM_TYPE';
end;

{ TBisDesignDataFirmTypeDeleteFormIface }

constructor TBisDesignDataFirmTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_FIRM_TYPE';
end;

end.
