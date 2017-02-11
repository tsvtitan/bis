unit BisKrieltDataDesignsFm;
                                                                                                      
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisDataGridFm, BisFm;

type
  TBisKrieltDataDesignsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataDesignsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataDesignsForm: TBisKrieltDataDesignsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataDesignEditFm;

{ TBisKrieltDataDesignsFormIface }

constructor TBisKrieltDataDesignsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataDesignsForm;
  InsertClass:=TBisKrieltDataDesignInsertFormIface;
  UpdateClass:=TBisKrieltDataDesignUpdateFormIface;
  DeleteClass:=TBisKrieltDataDesignDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_DESIGNS';
  with FieldNames do begin
    AddKey('DESIGN_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('CSS_CLASS');
    Add('NUM','Номер',50);
    Add('NAME','Наименование',300);
  end;
  Orders.Add('NUM');
end;

end.
