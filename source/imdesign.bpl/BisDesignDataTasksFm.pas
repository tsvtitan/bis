unit BisDesignDataTasksFm;

interface

uses                                                                                            
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm, BisDataFrm, BisDataGridFrm,
  BisDesignDataTasksFrm;

type
  TBisDesignDataTasksForm = class(TBisDataGridForm)
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisDesignDataTasksFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiDesignDataTasksForm: TBisDesignDataTasksForm;

implementation

{$R *.dfm}

{ TBisDesignDataTasksFormIface }

constructor TBisDesignDataTasksFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataTasksForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisDesignDataTasksForm }

class function TBisDesignDataTasksForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataTasksFrame;
end;

end.
