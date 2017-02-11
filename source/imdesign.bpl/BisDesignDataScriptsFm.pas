unit BisDesignDataScriptsFm;

interface                                                                                             

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, ComCtrls, ActnList, DBCtrls,

  BisFm, BisDataGridFm, BisFieldNames, BisDataFrm, BisDesignDataScriptsFrm;

type
  TBisDesignDataScriptsForm = class(TBisDataGridForm)
  private
    function GetDataFrame: TBisDesignDataScriptsFrame;
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;

    property DataFrame: TBisDesignDataScriptsFrame read GetDataFrame;
  end;

  TBisDesignDataScriptsFormIface=class(TBisDataGridFormIface)
  private
    function GetLastForm: TBisDesignDataScriptsForm;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property LastForm: TBisDesignDataScriptsForm read GetLastForm;
  end;

var
  BisDesignDataScriptsForm: TBisDesignDataScriptsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataScriptEditFm;

{ TBisDesignDataScriptsFormIface }

constructor TBisDesignDataScriptsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataScriptsForm;
  FilterClass:=TBisDesignDataScriptEditFormIface;
  InsertClass:=TBisDesignDataScriptInsertFormIface;
  UpdateClass:=TBisDesignDataScriptUpdateFormIface;
  DeleteClass:=TBisDesignDataScriptDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_SCRIPTS';
  with FieldNames do begin
    AddInvisible('SCRIPT_ID').IsKey:=true;
    AddInvisible('PLACE');
    Add('INTERFACE_NAME','���������',300);
    Add('ENGINE','������ �������',100);
  end;
  Orders.Add('INTERFACE_NAME');
end;

function TBisDesignDataScriptsFormIface.GetLastForm: TBisDesignDataScriptsForm;
begin
  Result:=TBisDesignDataScriptsForm(inherited LastForm);
end;

function TBisDesignDataScriptsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) and Assigned(LastForm.DataFrame) then begin
    with LastForm do begin
    end;
  end;
end;

{ TBiDesignDataScriptsForm }

constructor TBisDesignDataScriptsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisDesignDataScriptsForm.GetDataFrame: TBisDesignDataScriptsFrame;
begin
  Result:=TBisDesignDataScriptsFrame(inherited DataFrame);
end;

class function TBisDesignDataScriptsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataScriptsFrame;
end;

end.
