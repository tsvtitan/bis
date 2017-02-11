unit BisDesignDataLocalityEditFm;

interface
                                                                                                                
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisDesignDataLocalityEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelPrefix: TLabel;
    EditPrefix: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataLocalityEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataLocalityInsertFormIface=class(TBisDesignDataLocalityEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataLocalityUpdateFormIface=class(TBisDesignDataLocalityEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataLocalityDeleteFormIface=class(TBisDesignDataLocalityEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataLocalityEditForm: TBisDesignDataLocalityEditForm;

implementation

{$R *.dfm}

{ TBisDesignDataLocalityEditFormIface }

constructor TBisDesignDataLocalityEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataLocalityEditForm;
  with Params do begin
    AddKey('LOCALITY_ID').Older('OLD_LOCALITY_ID');
    AddEdit('PREFIX','EditPrefix','LabelPrefix');
    AddEdit('NAME','EditName','LabelName',true);
  end;
end;

{ TBisDesignDataLocalityInsertFormIface }

constructor TBisDesignDataLocalityInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_LOCALITY';
end;

{ TBisDesignDataLocalityUpdateFormIface }

constructor TBisDesignDataLocalityUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_LOCALITY';
end;

{ TBisDesignDataLocalityDeleteFormIface }

constructor TBisDesignDataLocalityDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_LOCALITY';
end;

end.
