unit BisSmsServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisSmsServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisSmsServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var                                                                    
  BisSmsServerMainForm: TBisSmsServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

{$R *.dfm}

uses BisConsts, BisSmsServerConsts, BisUtils, BisSmsServer;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  AModule.Ifaces.AddClass(TBisSmsServerMainFormIface);
end;

{ TTBisSmsServerMainFormIface }

constructor TBisSmsServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisSmsServerMainForm;
end;

{ TTBisSmsServerMainForm }

constructor TBisSmsServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisSmsServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisSmsServer;
end;

end.
