unit BisImportMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, DB, ImgList, ActnList, ComCtrls,
  Grids, DBGrids, ExtCtrls, StdCtrls, ToolWin,
  BisImportFm, BisControls;

type
  TBisImportMainForm = class(TBisImportForm)
  private
  public
    constructor Create(AOwner: TComponent); override;
    function CanShow: Boolean; override;
  end;

  TBisImportMainFormIface=class(TBisImportFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisImportMainForm: TBisImportMainForm;

implementation

{$R *.dfm}

uses BisDialogs, BisCore, BisUtils;

{ TBisImportMainFormIface }

constructor TBisImportMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisImportMainForm;
  ApplicationCreateForm:=true;
  AutoShow:=true;
  Permissions.Enabled:=false;
  OnlyOneForm:=true;
end;

{ TBisImportMainForm }

constructor TBisImportMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisImportMainForm.CanShow: Boolean;
begin
  Result:=false;
end;

end.
