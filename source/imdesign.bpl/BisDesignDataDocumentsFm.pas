unit BisDesignDataDocumentsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, ComCtrls, ActnList, DBCtrls,                                              

  BisFm, BisDataGridFm, BisFieldNames, BisDataFrm;

type
  TBisDesignDataDocumentsForm = class(TBisDataGridForm)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataDocumentsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataDocumentsForm: TBisDesignDataDocumentsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataDocumentEditFm;

{ TBisDesignDataDocumentsFormIface }

constructor TBisDesignDataDocumentsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataDocumentsForm;
  FilterClass:=TBisDesignDataDocumentEditFormIface;
  InsertClass:=TBisDesignDataDocumentInsertFormIface;
  UpdateClass:=TBisDesignDataDocumentUpdateFormIface;
  DeleteClass:=TBisDesignDataDocumentDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_DOCUMENTS';
  with FieldNames do begin
    AddInvisible('DOCUMENT_ID').IsKey:=true;
    AddInvisible('PLACE');
    Add('INTERFACE_NAME','���������',250);
    Add('OLE_CLASS','OLE-�����',150);
  end;
  Orders.Add('INTERFACE_NAME');
end;

{ TBisDesignDataDocumentsForm }

constructor TBisDesignDataDocumentsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.