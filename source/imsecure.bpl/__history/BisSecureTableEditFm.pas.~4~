unit BisSecureTableEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisFm, BisDialogFm, BisSecureTableEditFrm;

type
  TBisSecureTableEditForm = class(TBisDialogForm)
    PanelFrame: TPanel;
  private
    FTableEdit: TBisSecureTableEditFrame;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property TableEdit: TBisSecureTableEditFrame read FTableEdit;
  end;

var
  BisSecureTableEditForm: TBisSecureTableEditForm;

implementation

{$R *.dfm}

{ TBisSecureTableEditForm }

constructor TBisSecureTableEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTableEdit:=TBisSecureTableEditFrame.Create(Self);
  FTableEdit.Parent:=PanelFrame;
  FTableEdit.Align:=alClient;
end;

destructor TBisSecureTableEditForm.Destroy;
begin
  FTableEdit.Free;
  inherited Destroy;
end;

end.
