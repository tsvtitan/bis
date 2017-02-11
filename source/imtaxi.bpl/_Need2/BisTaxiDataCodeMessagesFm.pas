unit BisTaxiDataCodeMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataCodeMessagesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataCodeMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;                                                                                    

var
  BisTaxiDataCodeMessagesForm: TBisTaxiDataCodeMessagesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisTaxiDataCodeMessageEditFm;

{ TBisTaxiDataCodeMessagesFormIface }

constructor TBisTaxiDataCodeMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCodeMessagesForm;
  FilterClass:=TBisTaxiDataCodeMessageEditFormIface;
  InsertClass:=TBisTaxiDataCodeMessageInsertFormIface;
  UpdateClass:=TBisTaxiDataCodeMessageUpdateFormIface;
  DeleteClass:=TBisTaxiDataCodeMessageDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_CODE_MESSAGES';
  with FieldNames do begin
    AddKey('CODE_MESSAGE_ID');
    AddInvisible('PROC_NAME');
    AddInvisible('COMMAND_STRING');
    AddInvisible('ANSWER');
    Add('CODE','Код',120);
    Add('DESCRIPTION','Описание',250);
    AddCheckBox('ENABLED','Включен',30);
  end;
  Orders.Add('CODE');
end;

end.
