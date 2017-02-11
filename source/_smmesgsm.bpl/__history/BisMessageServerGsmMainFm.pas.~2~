unit BisMessageServerGsmMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, ActnList,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisMessageServerGsmMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
    procedure Options; override;
  end;

  TBisMessageServerGsmMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisMessageServerGsmMainForm: TBisMessageServerGsmMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

{$R *.dfm}

uses BisCore, BisConsts, BisMessageServerGsmConsts, BisUtils, BisMessageServerGsm,
     BisMessageServerGsmModemsFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule.Ifaces do begin
    if IsMainModule then
      AddClass(TBisMessageServerGsmMainFormIface);
    AddClass(TBisMessageServerGsmModemsFormIface);  
  end;
end;

{ TTBisMessageServerGsmMainFormIface }

constructor TBisMessageServerGsmMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessageServerGsmMainForm;
end;

{ TTBisMessageServerGsmMainForm }

constructor TBisMessageServerGsmMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisMessageServerGsmMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisMessageServerGsm;
end;

function TBisMessageServerGsmMainForm.CanOptions: Boolean;
begin
  Result:=inherited CanOptions;
end;

procedure TBisMessageServerGsmMainForm.Options;
var
  Iface: TBisMessageServerGsmModemsFormIface;
begin
  if CanOptions then begin
    Iface:=TBisMessageServerGsmModemsFormIface.Create(nil);
    try
      Iface.ShowModal;
    finally
      Iface.Free;
    end;
  end;
end;


end.
