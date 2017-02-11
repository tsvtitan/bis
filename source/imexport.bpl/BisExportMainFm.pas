unit BisExportMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, DB, ImgList, ActnList, ComCtrls,
  Grids, DBGrids, ExtCtrls, StdCtrls, ToolWin, BisExportFm;

type
  TBisExportMainForm = class(TBisExportForm)
  private
  public
    constructor Create(AOwner: TComponent); override;
    function CanShow: Boolean; override;
  end;

  TBisExportMainFormIface=class(TBisExportFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisExportMainForm: TBisExportMainForm;

implementation

{$R *.dfm}

uses BisDialogs, BisCore, BisUtils;

{ TBisExportMainFormIface }

constructor TBisExportMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisExportMainForm;
  ApplicationCreateForm:=true;
  AutoShow:=true;
//  Available:=false;
  Permissions.Enabled:=false;
  OnlyOneForm:=true;
end;

{ TBisExportMainForm }

constructor TBisExportMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisExportMainForm.CanShow: Boolean;
begin
  Result:=false;
end;

end.