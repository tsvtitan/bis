unit BisDataTreeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, DBActns, ActnList, DB,
  ComCtrls, ToolWin, ExtCtrls, Grids, DBGrids, StdCtrls,
  BisDataFrm, BisDataGridFrm, BisDBTree;

type
  TBisDataTreeFrame = class(TBisDataGridFrame)
    ToolBarOptions: TToolBar;
    ToolButtonTree: TToolButton;
    ActionTree: TAction;
    N13: TMenuItem;
    N2: TMenuItem;
    procedure ActionTreeExecute(Sender: TObject);
    procedure ActionTreeUpdate(Sender: TObject);
  private
    function GetTree: TBisDBTree;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ResizeToolbars; override;

    property Tree: TBisDBTree read GetTree;
  end;

var
  BisDataTreeFrame: TBisDataTreeFrame;

implementation

{$R *.dfm}

uses BisUtils;

{ TBisDataTreeFrame }

constructor TBisDataTreeFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tree.GridEmulate:=not ActionTree.Checked;
  Tree.NormalIndex:=16;
  Tree.OpenIndex:=17;
  Tree.LastIndex:=18;
end;

destructor TBisDataTreeFrame.Destroy;
begin
  inherited Destroy;
end;

function TBisDataTreeFrame.GetTree: TBisDBTree;
begin
  Result:=inherited Grid;
end;

procedure TBisDataTreeFrame.Init;
begin
  inherited Init;
end;

procedure TBisDataTreeFrame.ResizeToolbars;
begin
  inherited ResizeToolbars;
  ResizeToolbar(ToolBarOptions);
end;

procedure TBisDataTreeFrame.ActionTreeExecute(Sender: TObject);
begin
  ActionTree.Checked:=not ActionTree.Checked;
  Tree.GridEmulate:=not ActionTree.Checked;
end;

procedure TBisDataTreeFrame.ActionTreeUpdate(Sender: TObject);
begin
  ActionTree.Enabled:=CanRefreshRecords;
end;



end.