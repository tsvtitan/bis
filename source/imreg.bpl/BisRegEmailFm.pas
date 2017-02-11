unit BisRegEmailFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisFm, BisControls, BisSizeGrip;

type
  TBisRegEmailForm = class(TBisForm)
    GroupBoxDesc: TGroupBox;
    MemoDesc: TMemo;
    LabelFrom: TLabel;
    EditFrom: TEdit;
    LabelTo: TLabel;
    EditTo: TEdit;
    GroupBoxBody: TGroupBox;
    LabelSubject: TLabel;
    EditSubject: TEdit;
    MemoBody: TMemo;
  private
    FSizeGrip: TBisSizeGrip;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  BisRegEmailForm: TBisRegEmailForm;

implementation

{$R *.dfm}

{ TBisRegEmailForm }

constructor TBisRegEmailForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSizeGrip:=TBisSizeGrip.Create(Self);
  FSizeGrip.Parent:=Self;
  FSizeGrip.Visible:=true;
end;

destructor TBisRegEmailForm.Destroy;
begin
  FSizeGrip.Free;
  inherited Destroy;
end;

end.
