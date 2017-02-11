unit BisTaxiDataCallsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataFrm, BisDataGridFm,
  BisTaxiDataCallEditFm;

type

  TBisTaxiDataCallsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataCallsFormIface=class(TBisDataGridFormIface)                                    
  private
    FViewMode: TBisTaxiDataCallViewMode;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInCallsFormIface=class(TBisTaxiDataCallsFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutCallsFormIface=class(TBisTaxiDataCallsFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCallsForm: TBisTaxiDataCallsForm;

implementation

uses BisTaxiDataCallsFrm;

{$R *.dfm}

{ TBisTaxiDataCallsFormIface }

constructor TBisTaxiDataCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCallsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;

  FViewMode:=vmFull;
end;

function TBisTaxiDataCallsFormIface.CreateForm: TBisForm;
var
  Form: TBisTaxiDataCallsForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) and (Result is TBisTaxiDataCallsForm) then begin
    Form:=TBisTaxiDataCallsForm(Result);
    if Assigned(Form.DataFrame) and (Form.DataFrame is TBisTaxiDataCallsFrame) then
      TBisTaxiDataCallsFrame(Form.DataFrame).ViewMode:=FViewMode;
  end;
end;

{ TBisTaxiDataCallsForm }

class function TBisTaxiDataCallsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataCallsFrame;
end;

{ TBisTaxiDataInCallsFormIface }

constructor TBisTaxiDataInCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FViewMode:=vmIncoming;
end;

{ TBisTaxiDataOutCallsFormIface }

constructor TBisTaxiDataOutCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FViewMode:=vmOutgoing;
end;

end.
