unit BisDesignDataApplicationsFm;

interface

uses                                                                                                           
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm;

type
  TBisDesignDataApplicationsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisDesignDataApplicationsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataApplicationsForm: TBisDesignDataApplicationsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataApplicationEditFm, BisDesignDataApplicationsFrm;

{ TBisDesignDataApplicationsFormIface }

constructor TBisDesignDataApplicationsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataApplicationsForm;
  FilterClass:=TBisDesignDataApplicationEditFormIface;
  InsertClass:=TBisDesignDataApplicationInsertFormIface;
  UpdateClass:=TBisDesignDataApplicationUpdateFormIface;
  DeleteClass:=TBisDesignDataApplicationDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_APPLICATIONS';
  with FieldNames do begin
    AddKey('APPLICATION_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',300);
    Add('VERSION','Версия',100);
    AddInvisible('LOCKED');
  end;
end;

{ TBisDesignDataApplicationsForm }

class function TBisDesignDataApplicationsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataApplicationsFrame;
end;

end.
