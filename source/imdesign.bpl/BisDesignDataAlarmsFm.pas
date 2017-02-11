unit BisDesignDataAlarmsFm;

interface

uses                                                                                                             
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  VirtualTrees,
  BisFm, BisDataGridFm, BisFieldNames;

type
  TBisDesignDataAlarmsForm = class(TBisDataGridForm)
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoText: TDBMemo;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataAlarmsFormIface=class(TBisDataGridFormIface)
  private
    function GetTypeAlarmName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataAlarmsForm: TBisDesignDataAlarmsForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisConsts, BisVariants, BisOrders, BisFilterGroups, BisValues, BisCore,
     BisDesignDataAlarmEditFm, BisDesignDataAlarmFilterFm;

{ TBisDesignDataAlarmsFormIface }

constructor TBisDesignDataAlarmsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataAlarmsForm;
  FilterClass:=TBisDesignDataAlarmFilterFormIface;
  InsertClass:=TBisDesignDataAlarmInsertFormIface;
  UpdateClass:=TBisDesignDataAlarmUpdateFormIface;
  DeleteClass:=TBisDesignDataAlarmDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_ALARMS';
  with FieldNames do begin
    AddKey('ALARM_ID');
    AddInvisible('SENDER_ID');
    AddInvisible('SENDER_NAME');
    AddInvisible('RECIPIENT_ID');
    AddInvisible('TYPE_ALARM');
    AddInvisible('TEXT_ALARM');
    Add('DATE_BEGIN','���� ������',110);
    Add('DATE_END','���� ���������',110);
    AddCalculate('TYPE_ALARM_NAME','��� ����������',GetTypeAlarmName,ftString,20,100);
    Add('CAPTION','���������',130);
    Add('RECIPIENT_NAME','����������',100);
  end;
  Orders.Add('DATE_BEGIN',otDesc);
end;

function TBisDesignDataAlarmsFormIface.GetTypeAlarmName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetTypeAlarmNameByIndex(DataSet.FieldByName('TYPE_ALARM').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

{ TBisDesignDataAlarmsForm }

constructor TBisDesignDataAlarmsForm.Create(AOwner: TComponent);
var
  D: TDateTime;
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin

    DBMemoText.DataSource:=DataFrame.DataSource;

    D:=Core.ServerDate;

    with DataFrame.CreateFilterMenuItem('�������') do begin
      with FilterGroups.AddVisible do begin
        Filters.Add('DATE_BEGIN',fcEqualGreater,DateOf(D));
        Filters.Add('DATE_BEGIN',fcLess,IncDay(DateOf(D)));
      end;
      Checked:=true;
    end;

    with DataFrame.CreateFilterMenuItem('�����') do begin
      FilterGroups.AddVisible.Filters.Add('DATE_BEGIN',fcLess,DateOf(D));
    end;

  end;
end;

end.
