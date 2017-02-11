unit BisCallcTaskExecuteInfoFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDialogFm, BisControls;

type
  TBisTaskExecuteForm = class(TBisDialogForm)
    LabelResult: TLabel;
    EditResult: TEdit;
    LabelAction: TLabel;
    EditAction: TEdit;
    LabelTaskCount: TLabel;
    EditTaskCount: TEdit;
    LabelDate: TLabel;
    EditDate: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BisTaskExecuteForm: TBisTaskExecuteForm;

implementation

uses BisConsts;

{$R *.dfm}

procedure TBisTaskExecuteForm.FormCreate(Sender: TObject);
begin
  EditResult.Color:=ColorControlReadOnly;
  EditAction.Color:=ColorControlReadOnly;
  EditDate.Color:=ColorControlReadOnly;
  EditTaskCount.Color:=ColorControlReadOnly;
end;

end.
