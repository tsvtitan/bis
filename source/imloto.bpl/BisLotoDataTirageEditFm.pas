unit BisLotoDataTirageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, DB,
  BisFm, BisDataEditFm, BisParam, BisLotoTiragePrizesFrm, BisControls;

type
  TBisLotoDataTirageEditForm = class(TBisDataEditForm)
    PageControl: TPageControl;
    TabSheetGeneral: TTabSheet;
    LabelNum: TLabel;
    EditNum: TEdit;
    LabelExecutionDate: TLabel;
    DateTimePickerExecution: TDateTimePicker;
    DateTimePickerExecutionTime: TDateTimePicker;
    LabelExecutionPlace: TLabel;
    EditExecutionPlace: TEdit;
    LabelTicketCost: TLabel;
    EditTicketCost: TEdit;
    LabelJackpotPercent: TLabel;
    EditJackpotPercent: TEdit;
    LabelPrizePercent: TLabel;
    EditPrizePercent: TEdit;
    CheckBoxPreparationFlag: TCheckBox;
    LabelFirstRoundPercent: TLabel;
    EditFirstRoundPercent: TEdit;
    LabelThirdRoundSum: TLabel;
    EditThirdRoundSum: TEdit;
    LabelFourthRoundSum: TLabel;
    EditFourthRoundSum: TEdit;
    TabSheetPrizes: TTabSheet;
    LabelTicketCount: TLabel;
    EditTicketCount: TEdit;
    LabelTicketUsedCount: TLabel;
    EditTicketUsedCount: TEdit;
    LabelPrizeSum: TLabel;
    EditPrizeSum: TEdit;
    LabelSecondRoundSum: TLabel;
    EditSecondRoundSum: TEdit;
    LabelFirstRoundSum: TLabel;
    EditFirstRoundSum: TEdit;
    LabelJackpotSum: TLabel;
    EditJackpotSum: TEdit;
    Timer: TTimer;
    PanelPrizes: TPanel;
    procedure CheckBoxPreparationFlagClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure EditTicketCostChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    FBeforeShowed: Boolean;
    FPrizesFrame: TBisLotoTiragePrizesFrame;
    FOldCaption: String;
    FChangeFlag: Boolean;
    procedure SetPreparation;
    procedure SetStatistics;
    procedure UpdateCaption;
    procedure PrizesFrameChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;
    procedure ShowParam(Param: TBisParam); override;
    function ChangesExists: Boolean; override;

  end;

  TBisLotoDataTirageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataTirageFilterFormIface=class(TBisLotoDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataTirageInsertFormIface=class(TBisLotoDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataTirageUpdateFormIface=class(TBisLotoDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataTirageDeleteFormIface=class(TBisLotoDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoDataTirageEditForm: TBisLotoDataTirageEditForm;

implementation

uses
     BisUtils, BisLotoConsts,
     BisValues, BisCore, BisProvider, BisFilterGroups;

{$R *.dfm}

{ TBisLotoDataTirageEditFormIface }

constructor TBisLotoDataTirageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoDataTirageEditForm;
  with Params do begin
    AddKey('TIRAGE_ID').Older('OLD_TIRAGE_ID');
    AddInvisible('PREPARATION_DATE');
    AddEdit('NUM','EditNum','LabelNum',true);
    with AddEdit('TICKET_COUNT','EditTicketCount','LabelTicketCount') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditDateTime('EXECUTION_DATE','DateTimePickerExecution','DateTimePickerExecutionTime','LabelExecutionDate',true);
    AddEdit('EXECUTION_PLACE','EditExecutionPlace','LabelExecutionPlace',true);
    AddEditCalc('TICKET_COST','EditTicketCost','LabelTicketCost',true);
    with AddEdit('TICKET_USED_COUNT','EditTicketUsedCount','LabelTicketUsedCount') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('PRIZE_PERCENT','EditPrizePercent','LabelPrizePercent',true);
    with AddEditCalc('PRIZE_SUM','EditPrizeSum','LabelPrizeSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('JACKPOT_PERCENT','EditJackpotPercent','LabelJackpotPercent',true);
    with AddEditCalc('JACKPOT_SUM','EditJackpotSum','LabelJackpotSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('FIRST_ROUND_PERCENT','EditFirstRoundPercent','LabelFirstRoundPercent',true);
    with AddEditCalc('FIRST_ROUND_SUM','EditFirstRoundSum','LabelFirstRoundSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('THIRD_ROUND_SUM','EditThirdRoundSum','LabelThirdRoundSum',true);
    with AddEditCalc('SECOND_ROUND_SUM','EditSecondRoundSum','LabelSecondRoundSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('FOURTH_ROUND_SUM','EditFourthRoundSum','LabelFourthRoundSum');
    with AddCheckBox('PREPARATION_FLAG','CheckBoxPreparationFlag') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
  end;
end;

{ TBisLotoDataTirageFilterFormIface }

constructor TBisLotoDataTirageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр тиражей';
end;

{ TBisLotoDataTirageInsertFormIface }

constructor TBisLotoDataTirageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TIRAGE';
  Caption:='Создать тираж';
end;

{ TBisLotoDataTirageUpdateFormIface }

constructor TBisLotoDataTirageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TIRAGE';
  Caption:='Изменить тираж';
end;

{ TBisLotoDataTirageDeleteFormIface }

constructor TBisLotoDataTirageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TIRAGE';
  Caption:='Удалить тираж';
end;


{ TBisLotoDataTirageEditForm }

constructor TBisLotoDataTirageEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPrizesFrame:=TBisLotoTiragePrizesFrame.Create(Self);
  FPrizesFrame.Parent:=PanelPrizes;
  FPrizesFrame.Align:=alClient;
  FPrizesFrame.AsModal:=true;
  FPrizesFrame.ShowType:=stNormal;
  FPrizesFrame.OnChange:=PrizesFrameChange;
  
  PageControl.ActivePageIndex:=0;
end;

destructor TBisLotoDataTirageEditForm.Destroy;
begin
  Timer.Enabled:=false;
  FPrizesFrame.Free;
  inherited Destroy;
end;

procedure TBisLotoDataTirageEditForm.Init;
begin
  inherited Init;
  FPrizesFrame.Init;                 
end;

procedure TBisLotoDataTirageEditForm.EditTicketCostChange(Sender: TObject);
begin
  Timer.Enabled:=false;
  Timer.Enabled:=true;
end;

procedure TBisLotoDataTirageEditForm.SetPreparation;
begin
  EnableControl(TabSheetGeneral,not CheckBoxPreparationFlag.Checked);
  PanelControls.Enabled:=true;
  PageControl.Enabled:=true;
  TabSheetGeneral.Enabled:=true;
  TabSheetPrizes.Enabled:=true;
  CheckBoxPreparationFlag.Enabled:=true;
end;

procedure TBisLotoDataTirageEditForm.ShowParam(Param: TBisParam);
begin
  PageControl.ActivePageIndex:=0;
  inherited ShowParam(Param);
end;

procedure TBisLotoDataTirageEditForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:=false;
  SetStatistics;
end;

procedure TBisLotoDataTirageEditForm.UpdateCaption;
var
  NumParam: TBisParam;
begin
  NumParam:=Provider.Params.ParamByName('NUM');
  Caption:=FormatEx('%s № %s',[FOldCaption,NumParam.AsString]);
end;

procedure TBisLotoDataTirageEditForm.ChangeParam(Param: TBisParam);
var
  Flag: Boolean;
begin
  inherited ChangeParam(Param);
  if Assigned(Param) and FBeforeShowed then begin

    if AnsiSameText(Param.ParamName,'NUM') and
       (Mode in [emInsert,emUpdate]) then begin
      UpdateCaption;
    end;

    if AnsiSameText(Param.ParamName,'PREPARATION_FLAG') then begin
      Flag:=Param.AsInteger>0;
      if Flag then
        Provider.Params.ParamByName('PREPARATION_DATE').Value:=Core.ServerDate
      else
        Provider.Params.ParamByName('PREPARATION_DATE').Value:=Null;
      SetPreparation;
    end;
          
  end;
end;

procedure TBisLotoDataTirageEditForm.CheckBoxPreparationFlagClick(
  Sender: TObject);
var
  OldClick: TNotifyEvent;
begin
  OldClick:=CheckBoxPreparationFlag.OnClick;
  try
    CheckBoxPreparationFlag.OnClick:=nil;
    if CheckBoxPreparationFlag.Checked then begin
      CheckBoxPreparationFlag.Checked:=false;
      SetPreparation;
      CheckBoxPreparationFlag.Checked:=CheckParams;
    end;
    SetPreparation;
  finally
    CheckBoxPreparationFlag.OnClick:=OldClick;
  end;
end;

procedure TBisLotoDataTirageEditForm.BeforeShow;
begin
  FOldCaption:=Caption;
  inherited BeforeShow;

  if (Mode in [emInsert,emUpdate,emDuplicate]) then begin
    SetPreparation;
  end;

  SetStatistics;

  TabSheetPrizes.TabVisible:=Mode in [emUpdate,emDelete];

  EnableControl(FPrizesFrame,not (Mode in [emDelete]));

  UpdateCaption;

  FBeforeShowed:=true;
end;

procedure TBisLotoDataTirageEditForm.SetStatistics;
var
  Param: TBisParam;
  P: TBisProvider;
begin
  Param:=Provider.Params.ParamByName('TIRAGE_ID');
  if not Param.Empty and (Mode in [emUpdate,emDelete]) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=true;
      P.ProviderName:='GET_TIRAGE_STATISTICS';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=Param.Value;
        AddInvisible('TICKET_COST').Value:=Provider.Params.ParamByName('TICKET_COST').Value;
        AddInvisible('PRIZE_PERCENT').Value:=Provider.Params.ParamByName('PRIZE_PERCENT').Value;
        AddInvisible('JACKPOT_PERCENT').Value:=Provider.Params.ParamByName('JACKPOT_PERCENT').Value;
        AddInvisible('FIRST_ROUND_PERCENT').Value:=Provider.Params.ParamByName('FIRST_ROUND_PERCENT').Value;
        AddInvisible('THIRD_ROUND_SUM').Value:=Provider.Params.ParamByName('THIRD_ROUND_SUM').Value;
        AddInvisible('FOURTH_ROUND_SUM').Value:=Provider.Params.ParamByName('FOURTH_ROUND_SUM').Value;
        AddInvisible('ALL_COUNT',ptOutput);
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('NOT_USED_COUNT',ptOutput);
        AddInvisible('PRIZE_SUM',ptOutput);
        AddInvisible('JACKPOT_SUM',ptOutput);
        AddInvisible('FIRST_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_ROUND_SUM',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        with Provider.Params do begin
          ParamByName('TICKET_COUNT').SetNewValue(P.Params.ParamByName('ALL_COUNT').Value);
          ParamByName('TICKET_USED_COUNT').SetNewValue(P.Params.ParamByName('USED_COUNT').Value);
          ParamByName('PRIZE_SUM').SetNewValue(P.Params.ParamByName('PRIZE_SUM').Value);
          ParamByName('JACKPOT_SUM').SetNewValue(P.Params.ParamByName('JACKPOT_SUM').Value);
          ParamByName('FIRST_ROUND_SUM').SetNewValue(P.Params.ParamByName('FIRST_ROUND_SUM').Value);
          ParamByName('SECOND_ROUND_SUM').SetNewValue(P.Params.ParamByName('SECOND_ROUND_SUM').Value);
        end;
      end;
    finally
      P.Free;
    end;
  end else begin
    with Provider.Params do begin
      ParamByName('TICKET_COUNT').SetNewValue(Null);
      ParamByName('TICKET_USED_COUNT').SetNewValue(Null);
      ParamByName('PRIZE_SUM').SetNewValue(Null);
      ParamByName('JACKPOT_SUM').SetNewValue(Null);
      ParamByName('FIRST_ROUND_SUM').SetNewValue(Null);
      ParamByName('SECOND_ROUND_SUM').SetNewValue(Null);
    end;
  end;
end;

procedure TBisLotoDataTirageEditForm.PageControlChange(Sender: TObject);
var
  Param: TBisParam;
begin
  if PageControl.ActivePage=TabSheetPrizes then begin
    Param:=Provider.Params.ParamByName('TIRAGE_ID');
    if not Param.Empty then begin
      FPrizesFrame.TirageId:=Param.Value;
      FPrizesFrame.ReadOnly:=CheckBoxPreparationFlag.Checked or (Mode in [emDelete]);
      FPrizesFrame.OpenRecords;
    end;
  end;
end;

procedure TBisLotoDataTirageEditForm.PrizesFrameChange(Sender: TObject);
begin
  FChangeFlag:=true;
end;

function TBisLotoDataTirageEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FChangeFlag;
end;

end.
