unit BisDesignDataReportsFm;

interface
                                                                                                      
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, ComCtrls, ActnList, DBCtrls,

  BisFm, BisDataGridFm, BisFieldNames, BisDataFrm, BisDesignDataReportsFrm;

type
  TBisDesignDataReportsForm = class(TBisDataGridForm)
  private
    function GetDataFrame: TBisDesignDataReportsFrame;
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;

    property DataFrame: TBisDesignDataReportsFrame read GetDataFrame;
  end;

  TBisDesignDataReportsFormIface=class(TBisDataGridFormIface)
  private
    function GetLastForm: TBisDesignDataReportsForm;
    function CanReportEdit(Sender: TBisDataFrame): Boolean;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property LastForm: TBisDesignDataReportsForm read GetLastForm;
  end;

var
  BisDesignDataReportsForm: TBisDesignDataReportsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataReportEditFm;

{ TBisDesignDataReportsFormIface }

constructor TBisDesignDataReportsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataReportsForm;
  FilterClass:=TBisDesignDataReportEditFormIface;
  InsertClass:=TBisDesignDataReportInsertFormIface;
  UpdateClass:=TBisDesignDataReportUpdateFormIface;
  DeleteClass:=TBisDesignDataReportDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_REPORTS';
  with FieldNames do begin
    AddInvisible('REPORT_ID').IsKey:=true;
    AddInvisible('PLACE');
    Add('INTERFACE_NAME','���������',300);
    Add('ENGINE','������ ������',100);
  end;
  Orders.Add('INTERFACE_NAME');
end;

function TBisDesignDataReportsFormIface.GetLastForm: TBisDesignDataReportsForm;
begin
  Result:=TBisDesignDataReportsForm(inherited LastForm);
end;

function TBisDesignDataReportsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) and Assigned(LastForm.DataFrame) then begin
    with LastForm do begin
      DataFrame.OnCanReportEdit:=CanReportEdit;
    end;
  end;
end;

function TBisDesignDataReportsFormIface.CanReportEdit(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(SPermissionUpdate);
end;

{ TBiDesignDataReportsForm }

constructor TBisDesignDataReportsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisDesignDataReportsForm.GetDataFrame: TBisDesignDataReportsFrame;
begin
  Result:=TBisDesignDataReportsFrame(inherited DataFrame);
end;

class function TBisDesignDataReportsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataReportsFrame;
end;

end.
