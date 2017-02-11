unit BisUdpEventServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, ActnList,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisUdpEventServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
  end;

  TBisUdpEventServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisUdpEventServerMainForm: TBisUdpEventServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;


implementation

{$R *.dfm}

uses BisConsts, BisUtils,
     BisUdpEventServerConsts, BisUdpEventServerInit;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  AModule.Ifaces.AddClass(TBisUdpEventServerMainFormIface);
end;

{ TTBisUdpEventServerMainFormIface }

constructor TBisUdpEventServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisUdpEventServerMainForm;
end;

{ TTBisUdpEventServerMainForm }

function TBisUdpEventServerMainForm.CanOptions: Boolean;
begin
  Result:=false;
end;

constructor TBisUdpEventServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisUdpEventServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisUdpEventServer;
end;

end.
