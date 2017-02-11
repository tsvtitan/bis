unit BisDesignDataStreetEditFm;

interface

uses                                                                                            
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisDesignDataStreetEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelPrefix: TLabel;
    EditPrefix: TEdit;
    LabelLocality: TLabel;
    EditLocality: TEdit;
    ButtonLocality: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataStreetEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataStreetFilterFormIface=class(TBisDesignDataStreetEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataStreetInsertFormIface=class(TBisDesignDataStreetEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataStreetUpdateFormIface=class(TBisDesignDataStreetEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataStreetDeleteFormIface=class(TBisDesignDataStreetEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataStreetEditForm: TBisDesignDataStreetEditForm;

implementation

uses BisDesignDataLocalitiesFm;

{$R *.dfm}

{ TBisDesignDataStreetEditFormIface }

constructor TBisDesignDataStreetEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataStreetEditForm;
  with Params do begin
    AddKey('STREET_ID').Older('OLD_STREET_ID');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddEdit('PREFIX','EditPrefix','LabelPrefix');
    AddEdit('NAME','EditName','LabelName',true);
    AddEditDataSelect('LOCALITY_ID','EditLocality','LabelLocality','ButtonLocality',
                      TBisDesignDataLocalitiesFormIface,'LOCALITY_PREFIX;LOCALITY_NAME',true,false,'','PREFIX;NAME').DataAliasFormat:='%s%s';
  end;
end;


{ TBisDesignDataStreetFilterFormIface }

constructor TBisDesignDataStreetFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisDesignDataStreetInsertFormIface }

constructor TBisDesignDataStreetInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_STREET';
end;

{ TBisDesignDataStreetUpdateFormIface }

constructor TBisDesignDataStreetUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_STREET';
end;

{ TBisDesignDataStreetDeleteFormIface }

constructor TBisDesignDataStreetDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_STREET';
end;

end.
