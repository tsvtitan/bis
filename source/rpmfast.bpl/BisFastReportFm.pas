unit BisFastReportFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,
  
  BisFm, BisReportFm, BisReportFrm, BisFastReportFrm;

type
  TBisFastReportForm = class(TBisReportForm)
  private
    { Private declarations }
  protected
    function GetReportFrameClass: TBisReportFrameClass; override;
  public
    { Public declarations }
  end;

  TBisFastReportFormIface=class(TBisReportFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisFastReportForm: TBisFastReportForm;

implementation

{$R *.dfm}

{ TBisFastReportFormIface }

constructor TBisFastReportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisFastReportForm;
end;

{ TBisFastReportForm }

function TBisFastReportForm.GetReportFrameClass: TBisReportFrameClass;
begin
  Result:=TBisFastReportFrame;
end;

end.
