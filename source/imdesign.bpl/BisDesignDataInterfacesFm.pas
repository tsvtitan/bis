unit BisDesignDataInterfacesFm;

interface

uses                                                                                                         
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls,

  BisDataFrm, BisDataGridFm, BisDesignDataInterfacesFrm,
  BisControls;

type
  TBisDesignDataInterfacesForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataInterfacesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataInterfacesForm: TBisDesignDataInterfacesForm;

implementation

{$R *.dfm}

{ TBisDesignDataInterfacesFormIface }

constructor TBisDesignDataInterfacesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataInterfacesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ BisDesignDataInterfacesForm }

constructor TBisDesignDataInterfacesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

class function TBisDesignDataInterfacesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataInterfacesFrame;
end;

end.
