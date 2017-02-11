unit BisDataGridFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataFm, BisDataFrm, BisDataGridFrm;

type
  TBisDataGridForm = class(TBisDataForm)
  private
    FOldGridDblClick: TNotifyEvent;
    function GetDataFrame: TBisDataGridFrame;
    procedure GridDblClick(Sender: TObject);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CloseQuery: Boolean; override;

    property DataFrame: TBisDataGridFrame read GetDataFrame;
  end;

  TBisDataGridFormIface=class(TBisDataFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDataGridForm: TBisDataGridForm;

implementation

{$R *.dfm}

{ TBisDataGridFormIface }

constructor TBisDataGridFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDataGridForm;
end;

{ TBisDataGridForm }

function TBisDataGridForm.CloseQuery: Boolean;
begin
  Result:=inherited CloseQuery and
          Assigned(DataFrame) and DataFrame.CanClose;
end;

constructor TBisDataGridForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    FOldGridDblClick:=DataFrame.Grid.OnDblClick;
    DataFrame.Grid.OnDblClick:=GridDblClick;
  end;
end;

class function TBisDataGridForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDataGridFrame;
end;

procedure TBisDataGridForm.GridDblClick(Sender: TObject);
begin
  if ActionOk.Visible and ActionOk.Enabled then begin
    if Assigned(DataFrame) and Assigned(DataFrame.Provider) then begin
      if DataFrame.Provider.Active and
         not DataFrame.Provider.IsEmpty then
        ModalResult:=mrOk;
    end;
  end else begin
    if Assigned(FOldGridDblClick) then
       FOldGridDblClick(Sender);
  end;
end;

procedure TBisDataGridForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key,Shift);
end;

function TBisDataGridForm.GetDataFrame: TBisDataGridFrame;
begin
  Result:=TBisDataGridFrame(inherited DataFrame);
end;

end.
