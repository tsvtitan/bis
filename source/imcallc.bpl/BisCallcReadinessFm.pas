unit BisCallcReadinessFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  BisFm, StdCtrls, Buttons;

type
  TBisCallcReadinessForm = class(TBisForm)
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BisCallcReadinessForm: TBisCallcReadinessForm;

implementation

{$R *.dfm}

end.
