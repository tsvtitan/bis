unit BisCallcOperatorTaskFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisCallcTaskFm;

type
  TBisCallcTaskOperatorForm = class(TBisCallcTaskForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcOperatorTaskFormIface=class(TBisCallcTaskFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcTaskOperatorForm: TBisCallcTaskOperatorForm;

implementation

{$R *.dfm}

{ TBisCallcOperatorTaskFormIface }

constructor TBisCallcOperatorTaskFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcTaskOperatorForm;

end;

end.
