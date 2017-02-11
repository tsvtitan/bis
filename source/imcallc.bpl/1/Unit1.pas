unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  StdCtrls, ExtCtrls, Grids, DBGrids,
  BisDataFrm, BisDataGridFrm, BisDataEditFm, BisCallcHbookTaskEditFm, BisControls;

type

  TBisCallcDealFrameTaskViewingFormIface=class(TBisCallcHbookTaskUpdateFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcDealFrameTaskDeleteFormIface=class(TBisCallcHbookTaskDeleteFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TFrame1 = class(TBisDataGridFrame)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses SysUtils,
     BisProvider, BisFilterGroups;

{$R *.dfm}

{ TBisCallcDealFrameTasksFrame }

constructor TBisCallcDealFrameTasksFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ViewingClass:=TBisCallcDealFrameTaskViewingFormIface;
  DeleteClass:=TBisCallcDealFrameTaskDeleteFormIface;
  Grid.NumberVisible:=true;
  Grid.AutoResizeableColumns:=true;
  ActionFilter.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionUpdate.Visible:=false;
  LabelCounter.Visible:=true;
  with Provider do begin
    ProviderName:='S_TASKS';
    with FieldNames do begin
      AddKey('TASK_ID');
      AddInvisible('DEAL_ID');
      AddInvisible('DEAL_NUM');
      AddInvisible('ACTION_ID');
      AddInvisible('ACCOUNT_ID');
      AddInvisible('PERFORMER_ID');
      AddInvisible('RESULT_ID');
      AddInvisible('USER_NAME');
      AddInvisible('PERFORMER_USER_NAME');
      AddInvisible('DATE_CREATE');
      AddInvisible('DATE_BEGIN');
      Add('ACTION_NAME','Действие',100);
      Add('RESULT_NAME','Результат',145);
      Add('DATE_END','Дата выполнения',110);
      Add('DESCRIPTION','Комментарий',250);
    end;
    Orders.Add('DATE_END');
  end;
  AsModal:=true;
end;

destructor TBisCallcDealFrameTasksFrame.Destroy;
begin
  inherited Destroy;
end;

{ TBisCallcDealFrameTaskViewingFormIface }

constructor TBisCallcDealFrameTaskViewingFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Просмотр мероприятия';
end;

{ TBisCallcDealFrameTaskDeleteFormIface }

constructor TBisCallcDealFrameTaskDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Удалить мероприятие';
end;


end.
