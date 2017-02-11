unit BisMessDataPatternMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisMessDataPatternMessagesForm = class(TBisDataGridForm)
  end;

  TBisMessDataPatternMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataPatternMessagesForm: TBisMessDataPatternMessagesForm;

implementation

{$R *.dfm}

uses BisUtils, BisMessDataPatternMessageEditFm, BisConsts;

{ TBisMessDataPatternMessagesFormIface }

constructor TBisMessDataPatternMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataPatternMessagesForm;
  FilterClass:=TBisMessDataPatternMessageFilterFormIface;
  InsertClass:=TBisMessDataPatternMessageInsertFormIface;
  UpdateClass:=TBisMessDataPatternMessageUpdateFormIface;
  DeleteClass:=TBisMessDataPatternMessageDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_PATTERN_MESSAGES';
  with FieldNames do begin
    AddKey('PATTERN_MESSAGE_ID');
    Add('NAME','Наименование',150);
    Add('TEXT_PATTERN','Текст',300);
  end;
  Orders.Add('NAME');
end;

end.
