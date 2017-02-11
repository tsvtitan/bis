unit BisGsmServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, ActnList,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisGsmServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
    procedure Options; override;
  end;

  TBisGsmServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisGsmServerMainForm: TBisGsmServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

{$R *.dfm}

uses BisCore, BisConsts, BisGsmServerConsts, BisUtils, BisGsmServerInit,
     BisGsmServerModemsFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule.Ifaces do begin
    if IsMainModule then
      AddClass(TBisGsmServerMainFormIface);
    AddClass(TBisGsmServerModemsFormIface);  
  end;
end;

{ TTBisGsmServerMainFormIface }

constructor TBisGsmServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisGsmServerMainForm;
end;

{ TTBisGsmServerMainForm }

constructor TBisGsmServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisGsmServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisGsmServer;
end;

function TBisGsmServerMainForm.CanOptions: Boolean;
begin
  Result:=Servers.Started;
end;

procedure TBisGsmServerMainForm.Options;
var
  Iface: TBisGsmServerModemsFormIface;
begin
  if CanOptions then begin
    Iface:=TBisGsmServerModemsFormIface.Create(nil);
    try
      Iface.ShowModal;
    finally
      Iface.Free;
    end;
  end;
end;


end.