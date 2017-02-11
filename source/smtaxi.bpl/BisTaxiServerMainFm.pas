unit BisTaxiServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules, ActnList;

type
  TBisTaxiServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;

  end;

  TBisTaxiServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var                                                                    
  BisTaxiServerMainForm: TBisTaxiServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

{$R *.dfm}

uses BisConsts, BisTaxiServerConsts, BisUtils, BisTaxiServerInit;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  AModule.Ifaces.AddClass(TBisTaxiServerMainFormIface);
end;

{ TTBisTaxiServerMainFormIface }

constructor TBisTaxiServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiServerMainForm;
end;

{ TTBisTaxiServerMainForm }

constructor TBisTaxiServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisTaxiServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisTaxiServer;
end;

function TBisTaxiServerMainForm.CanOptions: Boolean;
begin
  Result:=false;
end;


end.
