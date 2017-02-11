unit BisKrieltDataPublishingFm;

interface

uses                                                                                                     
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisKrieltDataPublishingForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataPublishingFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPublishingForm: TBisKrieltDataPublishingForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataPublishingEditFm;

{ TBisKrieltDataPublishingFormIface }

constructor TBisKrieltDataPublishingFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPublishingForm;
  InsertClass:=TBisKrieltDataPublishingInsertFormIface;
  UpdateClass:=TBisKrieltDataPublishingUpdateFormIface;
  DeleteClass:=TBisKrieltDataPublishingDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_PUBLISHING';
  with FieldNames do begin
    AddKey('PUBLISHING_ID');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',200);
    AddInvisible('PRIORITY');
  end;
  Orders.Add('PRIORITY');
end;

end.
