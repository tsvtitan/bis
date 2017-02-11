unit BisDialogFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisFm, BisSizeGrip;

type
  TBisDialogForm = class(TBisForm)
    PanelButton: TPanel;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    procedure ButtonCancelClick(Sender: TObject);
  private
    FSizeGrip: TBisSizeGrip;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property SizeGrip: TBisSizeGrip read FSizeGrip; 
  end;

  TBisDialogFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDialogForm: TBisDialogForm;

implementation

{$R *.dfm}

{ TBisDialogFormIface }

constructor TBisDialogFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDialogForm;
end;

{ TBisDialogForm }

constructor TBisDialogForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSizeGrip:=TBisSizeGrip.Create(Self);
  FSizeGrip.Parent:=PanelButton;
  FSizeGrip.Visible:=false;
end;

destructor TBisDialogForm.Destroy;
begin
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisDialogForm.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

end.
