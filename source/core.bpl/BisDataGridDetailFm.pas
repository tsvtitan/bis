unit BisDataGridDetailFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ExtCtrls, ComCtrls,
  BisFm, BisDataFrm, BisDataGridFm, BisDataGridDetailFrm;

type
  TBisDataGridDetailForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisDataGridDetailFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDataGridDetailForm: TBisDataGridDetailForm;

implementation

{$R *.dfm}

{ TBisDataGridDetailFormIface }

constructor TBisDataGridDetailFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDataGridDetailForm;
end;

{ TBisDataGridDetailForm }

class function TBisDataGridDetailForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDataGridDetailFrame;
end;

end.
