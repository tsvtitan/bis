unit BisFotomImagePreviewFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  BisFm, ExtCtrls;

type
  TBisFotomImagePreviewForm = class(TBisForm)
    Image: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BisFotomImagePreviewForm: TBisFotomImagePreviewForm;

implementation

{$R *.dfm}

procedure TBisFotomImagePreviewForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    Close;
  

end;

procedure TBisFotomImagePreviewForm.ImageClick(Sender: TObject);
begin
  Close;

end;

end.
