unit BisTaxiDataPatternMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataPatternMessagesForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataPatternMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataPatternMessagesForm: TBisTaxiDataPatternMessagesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataPatternMessageEditFm, BisConsts;

{ TBisTaxiDataPatternMessagesFormIface }

constructor TBisTaxiDataPatternMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataPatternMessagesForm;
  FilterClass:=TBisTaxiDataPatternMessageFilterFormIface;
  InsertClass:=TBisTaxiDataPatternMessageInsertFormIface;
  UpdateClass:=TBisTaxiDataPatternMessageUpdateFormIface;
  DeleteClass:=TBisTaxiDataPatternMessageDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_PATTERN_MESSAGES';
  with FieldNames do begin
    AddKey('PATTERN_MESSAGE_ID');
    Add('NAME','Наименование',150);
    Add('TEXT_PATTERN','Текст',300);
  end;
  Orders.Add('NAME');
end;

end.
