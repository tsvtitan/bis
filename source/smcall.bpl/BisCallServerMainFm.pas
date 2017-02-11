unit BisCallServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, ActnList,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisCallServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
  end;

  TBisCallServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisCallServerMainForm: TBisCallServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;


implementation

{$R *.dfm}

uses BisConsts, BisUtils,
     BisCallServerConsts, BisCallServerInit;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  AModule.Ifaces.AddClass(TBisCallServerMainFormIface);
end;

{ TTBisCallServerMainFormIface }

constructor TBisCallServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallServerMainForm;
end;

{ TTBisCallServerMainForm }

function TBisCallServerMainForm.CanOptions: Boolean;
begin
  Result:=false;
end;

constructor TBisCallServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisCallServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisCallServer;
end;

end.
