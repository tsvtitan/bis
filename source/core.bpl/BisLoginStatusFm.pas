unit BisLoginStatusFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, StdCtrls, ExtCtrls,

  BisStatusFm, BisFm;

type
  TBisLoginStatusForm = class(TBisStatusForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisLoginStatusFormIface=class(TBisStatusFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLoginStatusForm: TBisLoginStatusForm;

implementation

{$R *.dfm}

{ TBisLoginStatusFormIface }

constructor TBisLoginStatusFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLoginStatusForm;
end;

end.
