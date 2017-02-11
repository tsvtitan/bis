unit BisUtilTableEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisFm, BisDialogFm, BisUtilsTableEditFrm;

type
  TBisUtilsTableEditForm = class(TBisDialogForm)
    PanelFrame: TPanel;
  private
    FTableEdit: TBisUtilsTableEditFrame;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property TableEdit: TBisUtilsTableEditFrame read FTableEdit;
  end;

var
  BisUtilsTableEditForm: TBisUtilsTableEditForm;

implementation

{$R *.dfm}

{ TBisUtilTableEditForm }

constructor TBisUtilsTableEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTableEdit:=TBisUtilsTableEditFrame.Create(Self);
  FTableEdit.Parent:=PanelFrame;
  FTableEdit.Align:=alClient;
end;

destructor TBisUtilsTableEditForm.Destroy;
begin
  FTableEdit.Free;
  inherited Destroy;
end;

end.
