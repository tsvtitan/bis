unit BisTaxiDataOutMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataFrm, BisDataGridFm, BisDataEditFm,
  BisMessDataOutMessagesFm, BisMessDataOutMessagesFrm;                                                                       

type
  TBisTaxiDataOutMessagesFrame=class(TBisMessDataOutMessagesFrame)
  private
    FOrderId: Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;

    property OrderId: Variant read FOrderId write FOrderId;
  end;

  TBisTaxiDataOutMessagesForm = class(TBisMessDataOutMessagesForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataOutMessagesFormIface=class(TBisMessDataOutMessagesFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOutMessagesForm: TBisTaxiDataOutMessagesForm;

implementation

uses BisParam,
     BisTaxiDataOutMessageEditFm, BisTaxiDataOutMessageFilterFm;

{$R *.dfm}

{ TBisTaxiDataOutMessagesFrame }

constructor TBisTaxiDataOutMessagesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FilterClass:=TBisTaxiDataOutMessageFilterFormIface;
  ViewClass:=TBisTaxiDataOutMessageViewFormIface;
  InsertClasses.Clear;
  InsertClasses.Add(TBisTaxiDataOutMessageInsertFormIface);
  InsertClasses.Add(TBisTaxiDataOutMessageInsertExFormIface);
  UpdateClass:=TBisTaxiDataOutMessageUpdateFormIface;
  DeleteClass:=TBisTaxiDataOutMessageDeleteFormIface;

  Provider.FieldNames.AddInvisible('ORDER_ID');
  
  FOrderId:=Null;
end;

procedure TBisTaxiDataOutMessagesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  POrder: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      POrder:=Find('ORDER_ID');
      if Assigned(POrder) then
        POrder.Value:=FOrderId;
    end;
  end;
end;

{ TBisTaxiDataOutMessagesFormIface }

constructor TBisTaxiDataOutMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOutMessagesForm;
end;

{ TBisTaxiDataOutMessagesForm }

class function TBisTaxiDataOutMessagesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataOutMessagesFrame;
end;



end.
