unit BisMessDataOutMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataFrm, BisDataGridFm;                                                                       

type
  TBisMessDataOutMessagesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisMessDataOutMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataOutMessagesForm: TBisMessDataOutMessagesForm;

implementation

uses BisMessDataOutMessagesFrm;

{$R *.dfm}

{ TBisMessDataOutMessagesFormIface }

constructor TBisMessDataOutMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataOutMessagesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisMessDataOutMessagesForm }

class function TBisMessDataOutMessagesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisMessDataOutMessagesFrame;
end;



end.
