unit BisDesignDataExchangesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm;
                                                                                                       
type
  TBisDesignDataExchangesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataExchangesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataExchangesForm: TBisDesignDataExchangesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataExchangeEditFm;

{ TBisDesignDataExchangesFormIface }

constructor TBisDesignDataExchangesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataExchangesForm;
  FilterClass:=TBisDesignDataExchangeEditFormIface;
  InsertClass:=TBisDesignDataExchangeInsertFormIface;
  UpdateClass:=TBisDesignDataExchangeUpdateFormIface;
  DeleteClass:=TBisDesignDataExchangeDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_EXCHANGES';
  with FieldNames do begin
    AddKey('EXCHANGE_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('SCRIPT');
    AddInvisible('SOURCE_BEFORE');
    AddInvisible('SOURCE_AFTER');
    AddInvisible('DESTINATION_BEFORE');
    AddInvisible('DESTINATION_AFTER');
    Add('NAME','������������',165);
    Add('SOURCE','��������',115);
    Add('DESTINATION','����������',115);
    Add('PRIORITY','�������',35);
    AddCheckBox('ENABLED','��������',30)
  end;
end;

end.
