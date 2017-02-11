unit BisMessDataCodeMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisMessDataCodeMessagesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisMessDataCodeMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;                                                                                    

var
  BisMessDataCodeMessagesForm: TBisMessDataCodeMessagesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisMessDataCodeMessageEditFm;

{ TBisMessDataCodeMessagesFormIface }

constructor TBisMessDataCodeMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataCodeMessagesForm;
  FilterClass:=TBisMessDataCodeMessageEditFormIface;
  InsertClass:=TBisMessDataCodeMessageInsertFormIface;
  UpdateClass:=TBisMessDataCodeMessageUpdateFormIface;
  DeleteClass:=TBisMessDataCodeMessageDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_CODE_MESSAGES';
  with FieldNames do begin
    AddKey('CODE_MESSAGE_ID');
    AddInvisible('PROC_NAME');
    AddInvisible('COMMAND_STRING');
    AddInvisible('ANSWER');
    Add('CODE','���',120);
    Add('DESCRIPTION','��������',250);
    AddCheckBox('ENABLED','�������',30);
  end;
end;

end.
