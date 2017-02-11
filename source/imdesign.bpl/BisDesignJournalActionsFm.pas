unit BisDesignJournalActionsFm;
                                                                                            
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataGridFm, BisFieldNames, DBCtrls;

type
  TBisDesignJournalActionsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoValue: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignJournalActionsFormIface=class(TBisDataGridFormIface)
  private
    function GetActionTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiDesignJournalActionsForm: TBisDesignJournalActionsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignJournalActionEditFm, BisOrders;

{ TBisDesignJournalActionsFormIface }

constructor TBisDesignJournalActionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignJournalActionsForm;
  FilterClass:=TBisDesignJournalActionFilterFormIface;
  InsertClass:=TBisDesignJournalActionInsertFormIface;
  UpdateClass:=TBisDesignJournalActionUpdateFormIface;
  DeleteClass:=TBisDesignJournalActionDeleteFormIface;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
  ProviderName:='S_JOURNAL_ACTIONS';
  with FieldNames do begin
    AddKey('JOURNAL_ACTION_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('APPLICATION_ID');
    AddInvisible('ACTION_TYPE');
    AddInvisible('VALUE');
    Add('APPLICATION_NAME','Приложение',75);
    Add('USER_NAME','Учетная запись',75);
    AddCalculate('ACTION_TYPE_NAME','Тип действия',GetActionTypeName,ftString,100,75);
    Add('DATE_ACTION','Дата действия',60);
    Add('MODULE','Модуль',75);
    Add('OBJECT','Объект',75);
    Add('METHOD','Метод',75);
    Add('PARAM','Параметр',75);
  end;
  Orders.Add('DATE_ACTION',otDesc);
end;

function TBisDesignJournalActionsFormIface.GetActionTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetActionTypeByIndex(DataSet.FieldByName('ACTION_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;


{ TBisDesignJournalActionsForm }

constructor TBisDesignJournalActionsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DBMemoValue.DataSource:=DataFrame.DataSource;
end;

end.
