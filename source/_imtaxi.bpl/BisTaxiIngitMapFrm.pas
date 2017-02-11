unit BisTaxiIngitMapFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, ActnPopup, ActnList, ComCtrls, ToolWin, ExtCtrls,
  ActiveX,
  BisIngitMapFrm;

type
  TBisTaxiIngitMapFrame = class(TBisIngitMapFrame)
    ActionAddMapObject: TAction;
    N2: TMenuItem;
    MenuAddMapObject: TMenuItem;
    procedure ActionAddMapObjectExecute(Sender: TObject);
  private
    { Private declarations }
  public
    function CanAddMapObject: Boolean;
    procedure AddMapObject;
  end;

implementation

uses BisTaxiDataMapObjectInsertFm;

{$R *.dfm}

procedure TBisTaxiIngitMapFrame.ActionAddMapObjectExecute(Sender: TObject);
begin
  AddMapObject;
end;

function TBisTaxiIngitMapFrame.CanAddMapObject: Boolean;
begin
  Result:=MapLoaded;
end;

procedure TBisTaxiIngitMapFrame.AddMapObject;
var
  AIface: TBisTaxiDataMapObjectInsertFormIface;
begin
  if CanAddMapObject then begin
    AIface:=TBisTaxiDataMapObjectInsertFormIface.Create(nil);
    try
      AIface.Init;
      with AIface.Params do begin
        ParamByName('LAT').Value:=CurrentLat;
        ParamByName('LON').Value:=CurrentLon;
      end;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

end.
