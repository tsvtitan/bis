unit BisBallDataTirageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, DB,
  BisFm, BisDataEditFm, BisParam, BisBallTirageSubroundsFrm, BisControls;

type
  TBisBallDataTirageEditForm = class(TBisDataEditForm)
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
    LabelFirstPercent: TLabel;
    EditFirstPercent: TEdit;
    TabSheetSubrounds: TTabSheet;
    LabelTicketCount: TLabel;
    EditTicketCount: TEdit;
    LabelTicketUsedCount: TLabel;
    EditTicketUsedCount: TEdit;
    LabelPrizeSum: TLabel;
    EditPrizeSum: TEdit;
    LabelFirstSum: TLabel;
    EditFirstSum: TEdit;
    LabelJackpotSum: TLabel;
    EditJackpotSum: TEdit;
    Timer: TTimer;
    PanelPrizes: TPanel;
    LabelSecond1RoundPercent: TLabel;
    EditSecond1RoundPercent: TEdit;
    LabelSecond1RoundSum: TLabel;
    EditSecond1RoundSum: TEdit;
    LabelSecond2RoundPercent: TLabel;
    EditSecond2RoundPercent: TEdit;
    LabelSecond2RoundSum: TLabel;
    EditSecond2RoundSum: TEdit;
    LabelSecond3RoundPercent: TLabel;
    EditSecond3RoundPercent: TEdit;
    LabelSecond3RoundSum: TLabel;
    EditSecond3RoundSum: TEdit;
    LabelSecond4RoundPercent: TLabel;
    EditSecond4RoundPercent: TEdit;
    LabelSecond4RoundSum: TLabel;
    EditSecond4RoundSum: TEdit;
    procedure CheckBoxPreparationFlagClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure EditTicketCostChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    FBeforeShowed: Boolean;
    FSubroundsFrame: TBisBallTirageSubroundsFrame;
    FOldCaption: String;
    FChangeFlag: Boolean;
    procedure SetPreparation;
    procedure SetStatistics;
    procedure UpdateCaption;
    procedure SubroundsFrameChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;
    procedure ShowParam(Param: TBisParam); override;
    function ChangesExists: Boolean; override;

  end;

  TBisBallDataTirageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataTirageFilterFormIface=class(TBisBallDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataTirageInsertFormIface=class(TBisBallDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataTirageUpdateFormIface=class(TBisBallDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataTirageDeleteFormIface=class(TBisBallDataTirageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallDataTirageEditForm: TBisBallDataTirageEditForm;

implementation

uses
     BisUtils, BisBallConsts,
     BisValues, BisCore, BisProvider, BisFilterGroups;

{$R *.dfm}

{ TBisBallDataTirageEditFormIface }

constructor TBisBallDataTirageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallDataTirageEditForm;
  with Params do begin
    AddKey('TIRAGE_ID').Older('OLD_TIRAGE_ID');
    AddInvisible('PREPARATION_DATE');
    AddEdit('NUM','EditNum','LabelNum',true);
    with AddEdit('TICKET_COUNT','EditTicketCount','LabelTicketCount') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditDateTime('EXECUTION_DATE','DateTimePickerExecution','DateTimePickerExecutionTime','LabelExecutionDate',true);
    with AddCheckBox('PREPARATION_FLAG','CheckBoxPreparationFlag') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEdit('EXECUTION_PLACE','EditExecutionPlace','LabelExecutionPlace',true);
    AddEditCalc('TICKET_COST','EditTicketCost','LabelTicketCost',true);
    with AddEditCalc('TICKET_USED_COUNT','EditTicketUsedCount','LabelTicketUsedCount') do begin
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
    AddEditCalc('FIRST_PERCENT','EditFirstPercent','LabelFirstPercent',true);
    with AddEditCalc('FIRST_SUM','EditFirstSum','LabelFirstSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('SECOND_1_ROUND_PERCENT','EditSecond1RoundPercent','LabelSecond1RoundPercent',true);
    with AddEditCalc('SECOND_1_ROUND_SUM','EditSecond1RoundSum','LabelSecond1RoundSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('SECOND_2_ROUND_PERCENT','EditSecond2RoundPercent','LabelSecond2RoundPercent',true);
    with AddEditCalc('SECOND_2_ROUND_SUM','EditSecond2RoundSum','LabelSecond2RoundSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('SECOND_3_ROUND_PERCENT','EditSecond3RoundPercent','LabelSecond3RoundPercent',true);
    with AddEditCalc('SECOND_3_ROUND_SUM','EditSecond3RoundSum','LabelSecond3RoundSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
    AddEditCalc('SECOND_4_ROUND_PERCENT','EditSecond4RoundPercent','LabelSecond4RoundPercent',true);
    with AddEditCalc('SECOND_4_ROUND_SUM','EditSecond4RoundSum','LabelSecond4RoundSum') do begin
      ExcludeModes([emFilter]);
      ParamType:=ptUnknown;
    end;
  end;
end;

{ TBisBallDataTirageFilterFormIface }

constructor TBisBallDataTirageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������';
end;

{ TBisBallDataTirageInsertFormIface }

constructor TBisBallDataTirageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TIRAGE';
  Caption:='������� �����';
end;

{ TBisBallDataTirageUpdateFormIface }

constructor TBisBallDataTirageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TIRAGE';
  Caption:='�������� �����';
end;

{ TBisBallDataTirageDeleteFormIface }

constructor TBisBallDataTirageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TIRAGE';
  Caption:='������� �����';
end;


{ TBisBallDataTirageEditForm }

constructor TBisBallDataTirageEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSubroundsFrame:=TBisBallTirageSubroundsFrame.Create(Self);
  FSubroundsFrame.Parent:=PanelPrizes;
  FSubroundsFrame.Align:=alClient;
  FSubroundsFrame.AsModal:=true;
  FSubroundsFrame.ShowType:=stMdiChild;
  FSubroundsFrame.OnChange:=SubroundsFrameChange;

  FSubroundsFrame.Provider.FieldNames.FieldByName('ROUND_NUM').Visible:=false;

  PageControl.ActivePageIndex:=0;
end;

destructor TBisBallDataTirageEditForm.Destroy;
begin
  Timer.Enabled:=false;
  FSubroundsFrame.Free;
  inherited Destroy;
end;

procedure TBisBallDataTirageEditForm.Init;
begin
  inherited Init;
  FSubroundsFrame.Init;                 
end;

procedure TBisBallDataTirageEditForm.EditTicketCostChange(Sender: TObject);
begin
  Timer.Enabled:=false;
  Timer.Enabled:=true;
end;

procedure TBisBallDataTirageEditForm.SetPreparation;
begin
  EnableControl(TabSheetGeneral,not CheckBoxPreparationFlag.Checked);
  PanelControls.Enabled:=true;
  PageControl.Enabled:=true;
  TabSheetGeneral.Enabled:=true;
  TabSheetSubrounds.Enabled:=true;
  CheckBoxPreparationFlag.Enabled:=true;
end;

procedure TBisBallDataTirageEditForm.ShowParam(Param: TBisParam);
begin
  PageControl.ActivePageIndex:=0;
  inherited ShowParam(Param);
end;

procedure TBisBallDataTirageEditForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:=false;
  SetStatistics;
end;

procedure TBisBallDataTirageEditForm.UpdateCaption;
var
  NumParam: TBisParam;
begin
  NumParam:=Provider.Params.ParamByName('NUM');
  Caption:=FormatEx('%s � %s',[FOldCaption,NumParam.AsString]);
end;

procedure TBisBallDataTirageEditForm.ChangeParam(Param: TBisParam);
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

procedure TBisBallDataTirageEditForm.CheckBoxPreparationFlagClick(
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

procedure TBisBallDataTirageEditForm.BeforeShow;
begin
  FOldCaption:=Caption;
  inherited BeforeShow;

  if (Mode in [emInsert,emUpdate,emDuplicate]) then begin
    SetPreparation;
  end;

  SetStatistics;

  TabSheetSubrounds.TabVisible:=Mode in [emUpdate,emDelete];

  EnableControl(FSubroundsFrame,not (Mode in [emDelete]));

  UpdateCaption;

  FBeforeShowed:=true;
end;

procedure TBisBallDataTirageEditForm.SetStatistics;
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
        AddInvisible('FIRST_PERCENT').Value:=Provider.Params.ParamByName('FIRST_PERCENT').Value;
        AddInvisible('SECOND_1_ROUND_PERCENT').Value:=Provider.Params.ParamByName('SECOND_1_ROUND_PERCENT').Value;
        AddInvisible('SECOND_2_ROUND_PERCENT').Value:=Provider.Params.ParamByName('SECOND_2_ROUND_PERCENT').Value;
        AddInvisible('SECOND_3_ROUND_PERCENT').Value:=Provider.Params.ParamByName('SECOND_3_ROUND_PERCENT').Value;
        AddInvisible('SECOND_4_ROUND_PERCENT').Value:=Provider.Params.ParamByName('SECOND_4_ROUND_PERCENT').Value;

        AddInvisible('ALL_COUNT',ptOutput);
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('NOT_USED_COUNT',ptOutput);
        AddInvisible('PRIZE_SUM',ptOutput);
        AddInvisible('JACKPOT_SUM',ptOutput);
        AddInvisible('FIRST_SUM',ptOutput);
        AddInvisible('SECOND_1_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_2_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_3_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_4_ROUND_SUM',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        with Provider.Params do begin
          ParamByName('TICKET_COUNT').SetNewValue(P.Params.ParamByName('ALL_COUNT').Value);
          ParamByName('TICKET_USED_COUNT').SetNewValue(P.Params.ParamByName('USED_COUNT').Value);
          ParamByName('PRIZE_SUM').SetNewValue(P.Params.ParamByName('PRIZE_SUM').Value);
          ParamByName('JACKPOT_SUM').SetNewValue(P.Params.ParamByName('JACKPOT_SUM').Value);
          ParamByName('FIRST_SUM').SetNewValue(P.Params.ParamByName('FIRST_SUM').Value);
          ParamByName('SECOND_1_ROUND_SUM').SetNewValue(P.Params.ParamByName('SECOND_1_ROUND_SUM').Value);
          ParamByName('SECOND_2_ROUND_SUM').SetNewValue(P.Params.ParamByName('SECOND_2_ROUND_SUM').Value);
          ParamByName('SECOND_3_ROUND_SUM').SetNewValue(P.Params.ParamByName('SECOND_3_ROUND_SUM').Value);
          ParamByName('SECOND_4_ROUND_SUM').SetNewValue(P.Params.ParamByName('SECOND_4_ROUND_SUM').Value);
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
      ParamByName('FIRST_SUM').SetNewValue(Null);
      ParamByName('SECOND_1_ROUND_SUM').SetNewValue(Null);
      ParamByName('SECOND_2_ROUND_SUM').SetNewValue(Null);
      ParamByName('SECOND_3_ROUND_SUM').SetNewValue(Null);
      ParamByName('SECOND_4_ROUND_SUM').SetNewValue(Null);
    end;
  end;
end;

procedure TBisBallDataTirageEditForm.PageControlChange(Sender: TObject);
var
  Param: TBisParam;
begin
  if PageControl.ActivePage=TabSheetSubrounds then begin
    Param:=Provider.Params.ParamByName('TIRAGE_ID');
    if not Param.Empty then begin
      FSubroundsFrame.TirageId:=Param.Value;
      FSubroundsFrame.ReadOnly:=CheckBoxPreparationFlag.Checked or (Mode in [emDelete]);
      FSubroundsFrame.OpenRecords;
    end;
  end;
end;
        
procedure TBisBallDataTirageEditForm.SubroundsFrameChange(Sender: TObject);
begin
  FChangeFlag:=true;
end;

function TBisBallDataTirageEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FChangeFlag;
end;

end.
