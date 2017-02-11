unit BisTaxiOrderEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, CheckLst, Contnrs, Tabs, DB,
  Menus, ActnPopup, ImgList,

  BisFm, BisDataFrm, BisDataEditFm, BisParam, BisTaxiAddressFrm, BisTaxiRouteFrm, BisGradient,
  BisTaxiHistoryFrm, BisTaxiIngitMapFrm, BisMapFrm,
  BisTaxiDataInMessagesFm, BisTaxiDataOutMessagesFrm, BisTaxiDataReceiptsFrm,
  BisTaxiDataCallEditFm, BisTaxiDataCallsFrm,
  BisTaxiDataChargesFrm, BisTaxiRouteHistoryFrm,
  BisParams, BisControls;

type

  TBisTaxiMapFramePoint=class(TBisMapFramePoint)
  public
    var Found: Boolean;
  end;

  TBisTaxiMapFramePoints=class(TBisMapFramePoints)
  private
    function GetItems(Index: Integer): TBisTaxiMapFramePoint;
  public
    function AddPoint(Lat,Lon: Extended; Found: Boolean): TBisTaxiMapFramePoint; reintroduce;

    property Items[Index: Integer]: TBisTaxiMapFramePoint read GetItems;
  end;

  TBisTaxiTypeRate=(trNone,trProc,trZone,trZone1km,trZone1min,trMap1km);

  TBisTaxiService=class(TObject)
  private
    FName: String;
    FId: Variant;
    FCost: Extended;
  public
    property Id: Variant read FId write FId;
    property Name: String read FName write FName;
    property Cost: Extended read FCost write FCost; 
  end;

  TBisTaxiRoute=class(TObject)
  private
    FFrame: TBisTaxiRouteFrame;
    FPanel: TPanel;
    FGradient: TBisGradient;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Enable(Distance,Period,Cost: Boolean);

    property Frame: TBisTaxiRouteFrame read FFrame;
    property Panel: TPanel read FPanel;
    property Gradient: TBisGradient read FGradient;
  end;

  TBisTaxiRoutes=class(TObjectList)
  private
    FParent: TWinControl;
    function GetItems(Index: Integer): TBisTaxiRoute;
    procedure SetItems(Index: Integer; const Value: TBisTaxiRoute);
  public
    function Add: TBisTaxiRoute;
    procedure UpdateButtons(AEnabled: Boolean);
    procedure CopyFrom(Sender: TBisTaxiAddressFrame);
    procedure RefreshZoneCost(Route: TBisTaxiRoute);
    procedure Enable(Distance,Period,Cost: Boolean);
    procedure EnableControls(AEnabled: Boolean);
    procedure ChangeByZone(AChange: Boolean); 

    property Items[Index: Integer]: TBisTaxiRoute read GetItems write SetItems;
    property Parent: TWinControl read FParent write FParent;
  end;
  
  TBisTaxiOrderEditForm = class(TBisDataEditForm)
    PageControl: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheetHistory: TTabSheet;
    TabSheetProcess: TTabSheet;
    GroupBoxMain: TGroupBox;
    PanelMain: TPanel;
    LabelPhone: TLabel;
    LabelDescription: TLabel;
    LabelRate: TLabel;
    LabelClient: TLabel;
    LabelOrderNum: TLabel;
    LabelLogin: TLabel;
    LabelCarType: TLabel;
    LabelServices: TLabel;
    LabelDateArrival: TLabel;
    MemoDescription: TMemo;
    ComboBoxRate: TComboBox;
    EditClient: TEdit;
    EditOrderNum: TEdit;
    BitBtnBlack: TBitBtn;
    ComboBoxCarType: TComboBox;
    ButtonOrderNum: TBitBtn;
    CheckListBoxServices: TCheckListBox;
    DateTimePickerArrival: TDateTimePicker;
    DateTimePickerArrivalTime: TDateTimePicker;
    GroupBoxAddress: TGroupBox;
    GroupBoxDriver: TGroupBox;
    PanelDriver: TPanel;
    LabelCar: TLabel;
    LabelPark: TLabel;
    LabelDriver: TLabel;
    EditCar: TEdit;
    ComboBoxPark: TComboBox;
    GroupBoxAccept: TGroupBox;
    PanelAccept: TPanel;
    LabelTypeAccept: TLabel;
    LabelWhoAccept: TLabel;
    LabelDateAccept: TLabel;
    ComboBoxTypeAccept: TComboBox;
    EditWhoAccept: TEdit;
    DateTimePickerAccept: TDateTimePicker;
    DateTimePickerAcceptTime: TDateTimePicker;
    GroupBoxCost: TGroupBox;
    ComboBoxDriver: TComboBox;
    PanelCost: TPanel;
    LabelDiscount: TLabel;
    ComboBoxDiscount: TComboBox;
    LabelCostRate: TLabel;
    EditCostRate: TEdit;
    LabelCostFact: TLabel;
    EditCostFact: TEdit;
    GroupBoxProcess: TGroupBox;
    PanelProcess: TPanel;
    LabelWhoProcess: TLabel;
    EditWhoProcess: TEdit;
    LabelAction: TLabel;
    ComboBoxAction: TComboBox;
    LabelDateBegin: TLabel;
    DateTimePickerBeginTime: TDateTimePicker;
    DateTimePickerBegin: TDateTimePicker;
    LabelResult: TLabel;
    ComboBoxResult: TComboBox;
    LabelDateEnd: TLabel;
    DateTimePickerEndTime: TDateTimePicker;
    DateTimePickerEnd: TDateTimePicker;
    BitBtnCheckPhone: TBitBtn;
    TimerProcess: TTimer;
    PanelHistory: TPanel;
    PopupActionBarArrival: TPopupActionBar;
    MenuItemThrough5min: TMenuItem;
    MenuItemThrough10min: TMenuItem;
    MenuItemThrough15min: TMenuItem;
    MenuItemThrough20min: TMenuItem;
    MenuItemThrough30min: TMenuItem;
    MenuItemThrough40min: TMenuItem;
    MenuItemThrough50min: TMenuItem;
    MenuItemThrough1hour: TMenuItem;
    MenuItemThrough2hour: TMenuItem;
    MenuItemThrough3hour: TMenuItem;
    MenuItemThrough4hour: TMenuItem;
    MenuItemThrough5hour: TMenuItem;
    ButtonArrival: TBitBtn;
    MenuItemNow: TMenuItem;
    ButtonCostRate: TBitBtn;
    RadioButtonAutomatic: TRadioButton;
    RadioButtonHand: TRadioButton;
    LabelBeforePeriod: TLabel;
    EditBeforePeriod: TEdit;
    BitBtnClient: TBitBtn;
    TabSheetMap: TTabSheet;
    PanelMap: TPanel;
    CheckBoxFinished: TCheckBox;
    LabelSource: TLabel;
    ComboBoxSource: TComboBox;
    BitBtnClientPhone: TBitBtn;
    PopupClientPhone: TPopupActionBar;
    ClientPhoneMenuItemMessage: TMenuItem;
    ClientPhoneMenuItemCall: TMenuItem;
    TimerPhone: TTimer;
    PopupDriverPhone: TPopupActionBar;
    DriverPhoneMenuItemMessage: TMenuItem;
    DriverPhoneMenuItemCall: TMenuItem;
    BitBtnDriverPhone: TBitBtn;
    TimerLogin: TTimer;
    EditLogin: TEdit;
    LabelCostGross: TLabel;
    EditCostGross: TEdit;
    TimerCostGross: TTimer;
    PanelAddressRoutes: TPanel;
    BevelAddress: TBevel;
    PanelAddress: TPanel;
    PanelRoutes: TPanel;
    PanelRouteButtons: TPanel;
    TabSetRoutes: TTabSet;
    BitBtnAddRoute: TBitBtn;
    BitBtnDeleteRoute: TBitBtn;
    TabSetAddressHistory: TTabSet;
    PanelRouteHistory: TPanel;
    ComboBoxPhone: TComboBox;
    TabSheetMessages: TTabSheet;
    PageControlMessages: TPageControl;
    TabSheetInMessages: TTabSheet;
    TabSheetOutMessages: TTabSheet;
    LabelWhoAcceptFirm: TLabel;
    EditWhoAcceptFirm: TEdit;
    TabSheetCharges: TTabSheet;
    TabSheetReceipts: TTabSheet;
    TabSheetCalls: TTabSheet;
    PageControlCalls: TPageControl;
    TabSheetInCalls: TTabSheet;
    TabSheetOutCalls: TTabSheet;
    procedure BitBtnAddRouteClick(Sender: TObject);
    procedure BitBtnDeleteRouteClick(Sender: TObject);
    procedure TabSetRoutesChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure CheckListBoxServicesClickCheck(Sender: TObject);
    procedure BitBtnBlackClick(Sender: TObject);
    procedure ButtonOrderNumClick(Sender: TObject);
    procedure TimerProcessTimer(Sender: TObject);
    procedure MenuItemThrough5hourClick(Sender: TObject);
    procedure ButtonArrivalClick(Sender: TObject);
    procedure BitBtnCheckPhoneClick(Sender: TObject);
    procedure ButtonCostRateClick(Sender: TObject);
    procedure RadioButtonAutomaticClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBoxParkEnter(Sender: TObject);
    procedure ComboBoxDriverEnter(Sender: TObject);
    procedure ComboBoxDiscountEnter(Sender: TObject);
    procedure BitBtnClientPhoneClick(Sender: TObject);
    procedure TimerPhoneTimer(Sender: TObject);
    procedure ClientPhoneMenuItemMessageClick(Sender: TObject);
    procedure ClientPhoneMenuItemCallClick(Sender: TObject);
    procedure PopupClientPhonePopup(Sender: TObject);
    procedure PopupDriverPhonePopup(Sender: TObject);
    procedure DriverPhoneMenuItemCallClick(Sender: TObject);
    procedure DriverPhoneMenuItemMessageClick(Sender: TObject);
    procedure BitBtnDriverPhoneClick(Sender: TObject);
    procedure TimerLoginTimer(Sender: TObject);
    procedure EditLoginChange(Sender: TObject);
    procedure TimerCostGrossTimer(Sender: TObject);
    procedure EditCostGrossChange(Sender: TObject);
    procedure TabSetAddressHistoryChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure ComboBoxPhoneChange(Sender: TObject);
    procedure ComboBoxPhoneExit(Sender: TObject);
    procedure ComboBoxPhoneSelect(Sender: TObject);
    procedure PageControlMessagesChange(Sender: TObject);
    procedure PageControlCallsChange(Sender: TObject);
  private
    FGradientMain: TBisGradient;
    FGradientAddress: TBisGradient;
    FGradientDriver: TBisGradient;
    FGradientCost: TBisGradient;
    FGradientAccept: TBisGradient;
    FGradientProcess: TBisGradient;

    FRoutes: TBisTaxiRoutes;
    FAddressFrame: TBisTaxiAddressFrame;
    FHistoryFrame: TBisTaxiHistoryFrame;
    FInMessagesFrame: TBisTaxiDataInMessagesFrame;
    FOutMessagesFrame: TBisTaxiDataOutMessagesFrame;
    FInCallsFrame: TBisTaxiDataCallsFrame;
    FOutCallsFrame: TBisTaxiDataCallsFrame;
    FReceiptsFrame: TBisTaxiDataReceiptsFrame;
    FChargesFrame: TBisTaxiDataChargesFrame;
    FMapFrame: TBisTaxiIngitMapFrame;
    FRouteHistoryFrame: TBisTaxiRouteHistoryFrame;
    FFirstSpaceWidth: Integer;

    FChangeServices: Boolean;
    FChangeTypeProcess: Boolean;
    FChangeRoutes: Boolean;
    FChangeAddress: Boolean;
    FChangeZone: Boolean;
    FChangeCost: Boolean;

    FOldCaption: String;
    FBeforeShowed: Boolean;
    FDateBegin: TDateTime;
    FDefaultLocalityName: String;
    FMapFileName: String;
    FRefreshDrivers: Boolean;
    FLocked: Boolean;
    FCheckLocked: Boolean;
    FFirstRefreshPark: Boolean;
    FFirstRefreshDriver: Boolean;
    FFirstRefreshDiscount: Boolean;
    FManualCalculate: Boolean;
    FNeedClientChange: Boolean;
    FDefaultPhone: String;
    FCallId: Variant;

    function FrameCan(Sender: TBisDataFrame): Boolean;
    procedure RouteFrameChangeZone(Sender: TObject);
    procedure RouteFrameZoneCostChange(Sender: TObject);
    procedure UpdateRoutesCaption;
    procedure UpdateRouteSize;
    procedure UpdateRoutesControls;
    function AddRoute: TBisTaxiRoute;
    procedure DeleteRoute;
    procedure RefreshServices;
    procedure RefreshOrderServices;
    procedure RefreshRoutes;
    function CanClientPhone: Boolean;
    function CanDriverPhone: Boolean;
    function CanBlackInsert: Boolean;
    procedure BlackInsert;
    function CanCheckPhoneBlack: Boolean;
    function ExistsPhoneBlack(Phone: String; var Description: String): Boolean;
    function CheckPhoneBlack(SuccessMessage: Boolean; QuestionMessage: Boolean): Boolean;
    procedure AddressFrameChangeZone(Sender: TObject);
    procedure AddressFrameChangeAddress(Sender: TObject);
    procedure AddressFrameSetFirm(Sender: TObject);
    function GetOrderNum(VisibleCursor: Boolean): String;
    procedure UpdateCaption;
    procedure RefreshData;
    procedure UpdateButtons;
    function PreparePhone(S: String): String;
    function GetCost(var ABaseCost, ABaseDistance: Extended; var ABasePeriod: Integer): Extended;
    function GetDiscount(ABaseCost: Extended; ABaseDistance: Extended; ABasePeriod: Integer; ResultCost: Extended): Extended;
    function CanCalculate: Boolean;
    procedure Calculate(Gross,Rate: Boolean);
    procedure RefreshInsertRoutes;
    procedure RefreshInsertOrderServices;
    function GetDefaultActionId: Variant;
    procedure SetDefaultActionId;
    function GetDefaultResultId: Variant;
    procedure SetDefaultResultId;
    procedure ProcessResult;
    procedure GetParams(OrderId: Variant);
    function CheckLockOrder: Boolean;
    function LockOrder: Boolean;
    procedure UnLockOrder;
    function CreateOrderHistory: Boolean;
    procedure GetRoutePoints(Points: TBisTaxiMapFramePoints);
    procedure SetDistanceByMap(WithCalc: Boolean);
    procedure SetClientDataByPhone;
    procedure SetClientDataByLogin;
    function CanClientMessage: Boolean;
    procedure ClientMessage;
    function CanClientCall: Boolean;
    procedure ClientCall;
    function CanDriverMessage: Boolean;
    procedure DriverMessage;
    function CanDriverCall: Boolean;
    procedure DriverCall;
    function GetAddressString(StreetPrefix,StreetName,House,Flat,LocalityPrefix,LocalityName: Variant): String;
    procedure SetRouteHistory(TabChange: Boolean);
    procedure RouteHistoryAddressChange(Sender: TObject);
    procedure RefreshPhones;
  protected
    procedure CreateWnd; override;

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function ChangesExists: Boolean; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
    function FindParamComponent(Param: TBisParam; ComponentName: String): TComponent; override;
    procedure Execute; override;
    function CheckParam(Param: TBisParam): Boolean; override;
    procedure ShowParam(Param: TBisParam); override;
    function CanShow: Boolean; override;
    procedure RefreshParams; override;

  end;

  TBisTaxiOrderEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiOrderFilterFormIface=class(TBisTaxiOrderEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiOrderViewFormIface=class(TBisTaxiOrderEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiOrderInsertFormIface=class(TBisTaxiOrderEditFormIface)
  private
    FDefaultPhone: String;
    FCallId: Variant;
  protected
    function CreateForm: TBisForm; override;  
  public
    constructor Create(AOwner: TComponent); override;

    property DefaultPhone: String read FDefaultPhone write FDefaultPhone;
    property CallId: Variant read FCallId write FCallId;
  end;

  TBisTaxiOrderUpdateFormIface=class(TBisTaxiOrderEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiOrderDeleteFormIface=class(TBisTaxiOrderEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiOrderEditForm: TBisTaxiOrderEditForm;

function GetTypeAcceptByIndex(Index: Integer): String;
function GetTypeProcessByIndex(Index: Integer): String;

implementation

uses DateUtils,
     BisValues, BisLogger, BisDialogs, BisFieldNames, BisIfaces, BisDataSet,
     BisUtils, BisParamComboBoxDataSelect, BisParamEditDataSelect, BisParamComboBox,
     BisParamEditCalc,
     BisTaxiDataRatesFm, BisTaxiDataCarTypesFm, BisCore, BisTaxiConsts,
     BisProvider, BisFilterGroups, BisTaxiDataBlackEditFm, BisTaxiDataParksFm,
     BisTaxiDataSourcesFm, BisTaxiDataDiscountsFm, BisTaxiDataActionsFm,
     BisTaxiDataResultsFm, BisTaxiDataDriversFm, BisTaxiDataParkStatesFm,
     BisTaxiDataDriverShiftsFm, BisTaxiDataZonesFm,
     BisTaxiDataClientsFm, BisTaxiDataOutMessageEditFm, BisTaxiDataDriverOutMessageEditFm,
     BisTaxiPhoneFm, BisTaxiPhoneFrm;

{$R *.dfm}

function GetTypeAcceptByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='������';
    1: Result:='���������';
  end;
end;

function GetTypeProcessByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='��������������';
    1: Result:='������';
  end;
end;

{ TBisTaxiMapFramePoints }

function TBisTaxiMapFramePoints.AddPoint(Lat, Lon: Extended; Found: Boolean): TBisTaxiMapFramePoint;
begin
  Result:=TBisTaxiMapFramePoint.Create;
  Result.Lat:=Lat;
  Result.Lon:=Lon;
  Result.Found:=Found;
  inherited Add(Result);
end;


function TBisTaxiMapFramePoints.GetItems(Index: Integer): TBisTaxiMapFramePoint;
begin
  Result:=TBisTaxiMapFramePoint(inherited Items[Index]);
end;

{ TBisTaxiOrderEditFormIface }

constructor TBisTaxiOrderEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiOrderEditForm;
  with Params do begin
    AddKey('ORDER_ID').Older('OLD_ORDER_ID');
    AddInvisible('LOCALITY_ID');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('STREET_ID');
    AddInvisible('STREET_PREFIX');
    AddInvisible('ZONE_ID');
    AddInvisible('DRIVER_USER_NAME');
    AddInvisible('DRIVER_SURNAME');
    AddInvisible('DRIVER_NAME');
    AddInvisible('DRIVER_PATRONYMIC');
    AddInvisible('DRIVER_PHONE');
    AddInvisible('CAR_CALLSIGN');
    AddInvisible('CAR_ID');
    AddInvisible('CAR_BRAND');
    AddInvisible('CAR_STATE_NUM');
    AddInvisible('CAR_COLOR');
    AddInvisible('WHO_ACCEPT_ID');
    AddInvisible('WHO_PROCESS_ID');
    AddInvisible('TYPE_PROCESS');
    AddInvisible('ACTION_BRUSH_COLOR');
    AddInvisible('ACTION_FONT_COLOR');
    AddInvisible('RESULT_BRUSH_COLOR');
    AddInvisible('RESULT_FONT_COLOR');
    AddInvisible('PARK_NAME');
    AddInvisible('PARK_DESCRIPTION');
    AddInvisible('ROUTE_STREET_ID');
    AddInvisible('ROUTE_STREET_PREFIX');
    AddInvisible('ROUTE_LOCALITY_ID');
    AddInvisible('ROUTE_LOCALITY_NAME');
    AddInvisible('ROUTE_LOCALITY_PREFIX');
    AddInvisible('ROUTE_STREET_NAME');
    AddInvisible('ROUTE_HOUSE');
    AddInvisible('ROUTE_FLAT');
    AddInvisible('ROUTE_PORCH');
    AddInvisible('ROUTE_ZONE_ID');
    AddInvisible('ROUTE_ZONE_NAME');
    AddInvisible('DISCOUNT_TYPE_NAME');
    AddInvisible('DISCOUNT_NUM');
    AddInvisible('CLIENT_SURNAME');
    AddInvisible('CLIENT_NAME');
    AddInvisible('CLIENT_PATRONYMIC');
    AddInvisible('CLIENT_FIRM_SMALL_NAME');
    AddInvisible('CUSTOMER');
    AddInvisible('FIRM_ID');
    AddInvisible('CALL_ID');

    with AddComboBoxDataSelect('RATE_ID','ComboBoxRate','LabelRate','',
                               TBisTaxiDataRatesFormIface,'RATE_NAME',true,false,'','NAME') do begin
      FirstSelected:=true;
      AutoRefresh:=false;
    end;
    with AddComboBoxDataSelect('CAR_TYPE_ID','ComboBoxCarType','LabelCarType','',
                               TBisTaxiDataCarTypesFormIface,'CAR_TYPE_NAME',true,false,'','NAME') do begin
      FirstSelected:=true;
      AutoRefresh:=false;
    end;
    AddEditDateTime('DATE_ARRIVAL','DateTimePickerArrival','DateTimePickerArrivalTime','LabelDateArrival',true);

    AddComboBoxText('PHONE','ComboBoxPhone','LabelPhone',true);
//    AddPopupDataSelect('PHONE','EditPhone','LabelPhone',TBisTaxiDataClientsFormIface,'PHONE',true);

    AddEdit('CLIENT_USER_NAME','EditLogin','LabelLogin');
    AddEdit('ORDER_NUM','EditOrderNum','LabelOrderNum',true).ExcludeModes([emUpdate]);
    with AddEditDataSelect('CLIENT_ID','EditClient','LabelClient','BitBtnClient',
                           TBisTaxiDataClientsFormIface,'CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME',
                           false,false,'ID','SURNAME;NAME;PATRONYMIC;FIRM_SMALL_NAME') do begin
      DataAliasFormat:='%s %s %s [%s]';
    end;
    AddComboBoxDataSelect('SOURCE_ID','ComboBoxSource','LabelSource','',
                          TBisTaxiDataSourcesFormIface,'SOURCE_NAME',false,false,'','NAME').AutoRefresh:=false;
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');

    AddComboBoxText('LOCALITY_NAME','ComboBoxLocality','LabelLocality',true);
    AddComboBoxText('STREET_NAME','ComboBoxStreet','LabelStreet',true);
    AddEdit('HOUSE','EditHouse','LabelHouse',true);
    AddEdit('FLAT','EditFlat','LabelFlat');
    AddEdit('PORCH','EditPorch','LabelPorch');
    AddComboBoxText('ZONE_NAME','ComboBoxZone','LabelZone');

    with AddComboBoxDataSelect('PARK_ID','ComboBoxPark','LabelPark','',
                               TBisTaxiDataParksFormIface,'PARK_NAME;PARK_DESCRIPTION',false,false,'','NAME;DESCRIPTION') do begin
      AutoRefresh:=false;
      DataAliasFormat:='%s - %s';
    end;
    with AddComboBoxDataSelect('DRIVER_ID','ComboBoxDriver','LabelDriver',
                               '','DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME',false,false,'','USER_NAME;SURNAME;NAME') do begin

      AutoRefresh:=false;
      DataAliasFormat:='%s - %s %s';
      FilterGroups.Add.Filters.Add('DATE_END',fcIsNull,Null);
    end;
    with AddEdit('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM','EditCar','LabelCar') do begin
      ParamFormat:='%s %s %s';
    end;

    AddEditCalc('COST_GROSS','EditCostGross','LabelCostGross',true);
    with AddComboBoxDataSelect('DISCOUNT_ID','ComboBoxDiscount','LabelDiscount','',
                               '','DISCOUNT_NUM;DISCOUNT_TYPE_NAME',false,false,'','NUM;DISCOUNT_TYPE_NAME') do begin
      AutoRefresh:=false;
      DataAliasFormat:='%s - %s';
    end;
    AddEditCalc('COST_RATE','EditCostRate','LabelCostRate',true);
    AddEditCalc('COST_FACT','EditCostFact','LabelCostFact');

    AddComboBoxIndex('TYPE_ACCEPT','ComboBoxTypeAccept','LabelTypeAccept',true).Value:=0;
    AddEditDateTime('DATE_ACCEPT','DateTimePickerAccept','DateTimePickerAcceptTime','LabelDateAccept',true).ExcludeModes(AllParamEditModes);
    AddEdit('WHO_ACCEPT','EditWhoAccept','LabelWhoAccept').ExcludeModes(AllParamEditModes);
    AddEdit('FIRM_SMALL_NAME','EditWhoAcceptFirm','LabelWhoAcceptFirm').ExcludeModes(AllParamEditModes);

    with AddComboBoxDataSelect('ACTION_ID','ComboBoxAction','LabelAction','',
                               TBisTaxiDataActionsFormIface,'ACTION_NAME',true,false,'','NAME') do begin
      AutoRefresh:=false;
    end;
    with AddComboBoxDataSelect('RESULT_ID','ComboBoxResult','LabelResult','',
                               TBisTaxiDataResultsFormIface,'RESULT_NAME',false,false,'','NAME') do begin
      AutoRefresh:=false;
    end;
    AddEditInteger('BEFORE_PERIOD','EditBeforePeriod','LabelBeforePeriod',true).Value:=30;

    AddCheckBox('FINISHED','CheckBoxFinished').Value:=0;
    AddEdit('WHO_PROCESS','EditWhoProcess','LabelWhoProcess').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd').ExcludeModes(AllParamEditModes);

  end;
end;

{ TBisTaxiOrderFilterFormIface }

constructor TBisTaxiOrderFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisTaxiOrderViewFormIface }

constructor TBisTaxiOrderViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ������';
end;

{ TBisTaxiOrderInsertFormIface }

constructor TBisTaxiOrderInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_ORDER';
  ParentProviderName:='S_ORDERS';
  Caption:='������� �����';
  SMessageSuccess:='����� � %ORDER_NUM ������� ������.';
end;

function TBisTaxiOrderInsertFormIface.CreateForm: TBisForm;
begin
  Result:=Inherited CreateForm;
  if Assigned(Result) and (Result is TBisTaxiOrderEditForm) then begin
    TBisTaxiOrderEditForm(Result).FDefaultPhone:=FDefaultPhone;
    TBisTaxiOrderEditForm(Result).FCallId:=FCallId;
    FCallId:=Null;
    FDefaultPhone:='';
  end;
end;

{ TBisTaxiOrderUpdateFormIface }

constructor TBisTaxiOrderUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ORDER';
  Caption:='�������� �����';
end;

{ TBisTaxiOrderDeleteFormIface }

constructor TBisTaxiOrderDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ORDER';
  Caption:='������� �����';
end;

{ TBisTaxiRoute }

constructor TBisTaxiRoute.Create;
begin
  inherited Create;
  FPanel:=TPanel.Create(nil);
  FPanel.BevelOuter:=bvNone;
  FPanel.Name:='';

  FFrame:=TBisTaxiRouteFrame.Create(nil);
  FFrame.Parent:=FPanel;
  FFrame.Align:=alClient;
  FFrame.Name:='';

  FGradient:=TBisGradient.Create(nil);
  FGradient.Parent:=FFrame;
  FGradient.Align:=alClient;
end;

destructor TBisTaxiRoute.Destroy;
begin
  FGradient.Free;
  FFrame.Free;
  FPanel.Free;
  inherited Destroy;
end;

procedure TBisTaxiRoute.Enable(Distance, Period, Cost: Boolean);
begin
  FFrame.LabelDistance.Enabled:=Distance;
  FFrame.EditDistance.Enabled:=Distance;
  FFrame.EditDistanceAll.Enabled:=Distance;
  FFrame.LabelPeriod.Enabled:=Period;
  FFrame.EditPeriod.Enabled:=Period;
  FFrame.LabelCost.Enabled:=Cost;
  FFrame.EditCost.Enabled:=Cost;
end;

{ TBisTaxiRoutes }

function TBisTaxiRoutes.Add: TBisTaxiRoute;
begin
  Result:=TBisTaxiRoute.Create;
  Result.Panel.Parent:=FParent;
  Result.Panel.Align:=alClient;
  Result.Gradient.SendToBack;
  inherited Add(Result);
end;

function TBisTaxiRoutes.GetItems(Index: Integer): TBisTaxiRoute;
begin
  Result:=TBisTaxiRoute(inherited Items[Index]);
end;

procedure TBisTaxiRoutes.RefreshZoneCost(Route: TBisTaxiRoute);
var
  i: Integer;
  Item: TBisTaxiRoute;
  Prior: TBisTaxiAddressFrame;
begin
  Prior:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if i>0 then
      Item.Frame.PriorFrame:=Prior
    else
      Item.Frame.PriorFrame:=nil;
    Item.Frame.RefreshZoneCost;
    Prior:=Item.Frame;
  end;
end;

procedure TBisTaxiRoutes.SetItems(Index: Integer; const Value: TBisTaxiRoute);
begin
  inherited Items[Index]:=Value;
end;

procedure TBisTaxiRoutes.CopyFrom(Sender: TBisTaxiAddressFrame);
var
  i: Integer;
  Item: TBisTaxiRoute;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Item.Frame.CopyFrom(Sender);
  end;
end;

procedure TBisTaxiRoutes.Enable(Distance, Period, Cost: Boolean);
var
  i: Integer;
  Item: TBisTaxiRoute;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Item.Enable(Distance,Period,Cost);
  end;
end;

procedure TBisTaxiRoutes.EnableControls(AEnabled: Boolean);
var
  i: Integer;
  Item: TBisTaxiRoute;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Item.Panel.Enabled:=AEnabled;
    Item.Frame.EnableControls(AEnabled);
  end;
end;

procedure TBisTaxiRoutes.UpdateButtons(AEnabled: Boolean);
var
  i: Integer;
  Item: TBisTaxiRoute;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Item.Frame.UpdateButtons(AEnabled);
  end;
end;

procedure TBisTaxiRoutes.ChangeByZone(AChange: Boolean);
var
  i: Integer;
  Item: TBisTaxiRoute;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Item.Frame.ChangeByZone:=AChange;
  end;
end;

{ TBisTaxiOrderEditForm }

constructor TBisTaxiOrderEditForm.Create(AOwner: TComponent);
var
  i: Integer;
  Buffer: String;
begin
  inherited Create(AOwner);

  FBeforeShowed:=false;

  FDefaultLocalityName:='';
  if Core.LocalBase.ReadParam(SParamDefaultLocalityName,Buffer) then
    FDefaultLocalityName:=Buffer;

  FMapFileName:='';
  if Core.LocalBase.ReadParam(SParamMapFileName,Buffer) then
    FMapFileName:=Buffer;

  FAddressFrame:=TBisTaxiAddressFrame.Create(Self);
  FAddressFrame.Parent:=PanelAddress;
  FAddressFrame.Align:=alClient;
  FAddressFrame.ParentForm:=Self;
  FAddressFrame.DefaultLocalityName:=FDefaultLocalityName;
  FAddressFrame.OnChangeZone:=AddressFrameChangeZone;
  FAddressFrame.OnChangeAddress:=AddressFrameChangeAddress;
  FAddressFrame.OnSetFirm:=AddressFrameSetFirm;

  FRoutes:=TBisTaxiRoutes.Create;
  FRoutes.Parent:=PanelRoutes;

  TabSetRoutes.Tabs.Clear;
  TabSetRoutes.TabStop:=true;

  FGradientMain:=TBisGradient.Create(Self);
  FGradientMain.Parent:=PanelMain;
  FGradientMain.Align:=alClient;
  FGradientMain.BeginColor:=PanelMain.Color;
  FGradientMain.SendToBack;

  FGradientAddress:=TBisGradient.Create(Self);
  FGradientAddress.Parent:=FAddressFrame;
  FGradientAddress.Align:=alClient;
  FGradientAddress.BeginColor:=PanelAddress.Color;
  FGradientAddress.SendToBack;

  FGradientDriver:=TBisGradient.Create(Self);
  FGradientDriver.Parent:=PanelDriver;
  FGradientDriver.Align:=alClient;
  FGradientDriver.BeginColor:=PanelDriver.Color;
  FGradientDriver.SendToBack;

  FGradientCost:=TBisGradient.Create(Self);
  FGradientCost.Parent:=PanelCost;
  FGradientCost.Align:=alClient;
  FGradientCost.BeginColor:=PanelCost.Color;
  FGradientCost.SendToBack;

  FGradientAccept:=TBisGradient.Create(Self);
  FGradientAccept.Parent:=PanelAccept;
  FGradientAccept.Align:=alClient;
  FGradientAccept.BeginColor:=PanelAccept.Color;
  FGradientAccept.SendToBack;

  FGradientProcess:=TBisGradient.Create(Self);
  FGradientProcess.Parent:=PanelProcess;
  FGradientProcess.Align:=alClient;
  FGradientProcess.BeginColor:=PanelProcess.Color;
  FGradientProcess.SendToBack;

  FHistoryFrame:=TBisTaxiHistoryFrame.Create(Self);
  FHistoryFrame.Parent:=PanelHistory;
  FHistoryFrame.Align:=alClient;

  FReceiptsFrame:=TBisTaxiDataReceiptsFrame.Create(nil);
  with FReceiptsFrame do begin
    Parent:=TabSheetReceipts;
    Align:=alClient;
    AsModal:=true;
    ShowAnotherFirms:=true;
    LabelCounter.Visible:=true;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FChargesFrame:=TBisTaxiDataChargesFrame.Create(nil);
  with FChargesFrame do begin
    Parent:=TabSheetCharges;
    Align:=alClient;
    AsModal:=true;
    ShowAnotherFirms:=true;
    LabelCounter.Visible:=true;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FInMessagesFrame:=TBisTaxiDataInMessagesFrame.Create(Self);
  FInMessagesFrame.Name:='InMessagesFrame';
  with FInMessagesFrame do begin
    Parent:=TabSheetInMessages;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    FilterMenuItemHour.Visible:=false;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutMessagesFrame:=TBisTaxiDataOutMessagesFrame.Create(Self);
  FOutMessagesFrame.Name:='OutMessagesFrame';
  with FOutMessagesFrame do begin
    InsertClasses.Remove(InsertClasses.Items[InsertClasses.Count-1]);
    Parent:=TabSheetOutMessages;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    FilterMenuItemHour.Visible:=false;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FInCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FInCallsFrame do begin
    Parent:=TabSheetInCalls;
    Align:=alClient;
    AsModal:=true;
    ViewMode:=vmIncoming;
    LabelCounter.Visible:=true;
    FilterMenuItemHour.Visible:=false;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FOutCallsFrame do begin
    Parent:=TabSheetOutCalls;
    Align:=alClient;
    AsModal:=true;
    ViewMode:=vmOutgoing;
    LabelCounter.Visible:=true;
    FilterMenuItemHour.Visible:=false;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;
  
  FMapFrame:=TBisTaxiIngitMapFrame.Create(Self);
  FMapFrame.Parent:=PanelMap;
  FMapFrame.Align:=alClient;
  FMapFrame.LoadFromFile(FMapFileName);

  FRouteHistoryFrame:=TBisTaxiRouteHistoryFrame.Create(Self);
  FRouteHistoryFrame.Name:='RouteHistoryFrame';
  FRouteHistoryFrame.Parent:=PanelRouteHistory;
  FRouteHistoryFrame.Align:=alClient;
  FRouteHistoryFrame.OnAddressChange:=RouteHistoryAddressChange;
  FRouteHistoryFrame.OnRouteChange:=RouteHistoryAddressChange;

  PanelRouteHistory.Align:=alClient;

  ComboBoxTypeAccept.Clear;
  for i:=0 to 1 do
    ComboBoxTypeAccept.Items.Add(GetTypeAcceptByIndex(i));

  FNeedClientChange:=true;

  FCallId:=Null;
end;

destructor TBisTaxiOrderEditForm.Destroy;
begin
  TimerProcess.Enabled:=false;
  UnLockOrder;
  FRouteHistoryFrame.Free;
  FMapFrame.Free;
  FOutCallsFrame.Free;
  FInCallsFrame.Free;
  FOutMessagesFrame.Free;
  FInMessagesFrame.Free;
  FChargesFrame.Free;
  FReceiptsFrame.Free;
  FHistoryFrame.Free;
  FRoutes.Free;
  FAddressFrame.Free;
  ClearStrings(CheckListBoxServices.Items);
  inherited Destroy;
end;

procedure TBisTaxiOrderEditForm.CreateWnd;
begin
  inherited CreateWnd;
  if Assigned(FMapFrame) then begin
    FMapFrame.PrepareMap;
    TabSheetMap.TabVisible:=FMapFrame.MapLoaded;
  end;
end;

procedure TBisTaxiOrderEditForm.Init;
begin
  inherited Init;
  FAddressFrame.Init;
  FHistoryFrame.Init;
  FReceiptsFrame.Init;
  FChargesFrame.Init;
  FInMessagesFrame.Init;
  FOutMessagesFrame.Init;
  FInCallsFrame.Init;
  FOutCallsFrame.Init;
  FMapFrame.Init;
  FRouteHistoryFrame.Init;
end;

procedure TBisTaxiOrderEditForm.RefreshServices;
var
  P: TBisProvider;
  Obj: TBisTaxiService;
begin
  ClearStrings(CheckListBoxServices.Items);
  CheckListBoxServices.Items.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=false;
    P.StopException:=false;
    P.ProviderName:='S_SERVICES';
    with P.FieldNames do begin
      AddInvisible('SERVICE_ID');
      AddInvisible('NAME');
      AddInvisible('COST');
    end;
    P.Orders.Add('PRIORITY');
    try
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          Obj:=TBisTaxiService.Create;
          Obj.Id:=P.FieldByName('SERVICE_ID').Value;
          Obj.Name:=P.FieldByName('NAME').AsString;
          Obj.Cost:=P.FieldByName('COST').AsFloat;
          CheckListBoxServices.Items.AddObject(Obj.Name,Obj);
          P.Next;
        end;
      end;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  finally
    CheckListBoxServices.Items.EndUpdate;
    P.Free;
  end;
end;

procedure TBisTaxiOrderEditForm.RefreshOrderServices;
var
  P: TBisProvider;
  Param: TBisParam;
  ServiceId: Variant;
  i: Integer;
  Obj: TBisTaxiService;
begin
  Param:=Provider.Params.Find('ORDER_ID');
  if Assigned(Param) and not Param.Empty then begin
    CheckListBoxServices.Items.BeginUpdate;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.StopException:=false;
      P.ProviderName:='S_ORDER_SERVICES';
      P.FieldNames.AddInvisible('SERVICE_ID');
      P.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
      try
        P.Open;
        if P.Active then begin
          P.First;
          while not P.Eof do begin
            ServiceId:=P.FieldByName('SERVICE_ID').Value;
            for i:=0 to CheckListBoxServices.Items.Count-1 do begin
              Obj:=TBisTaxiService(CheckListBoxServices.Items.Objects[i]);
              if VarSameValue(ServiceId,Obj.Id) then begin
                CheckListBoxServices.Checked[i]:=true;
              end;
            end;
            P.Next;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
      CheckListBoxServices.Items.EndUpdate;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.MenuItemThrough5hourClick(Sender: TObject);
type
  TArrivalThroughTimeType=(tNow,t5min,t10min,t15min,t20min,t30min,t40min,t50min,t1hour,t2hour,t3hour,t4hour,t5hour);
var
  Param: TBisParam;
  Typ: TArrivalThroughTimeType;
  ParamDate: TDateTime;
begin
  Param:=Provider.Params.Find('DATE_ARRIVAL');
  if Assigned(Param) and not Param.Empty and Assigned(Sender) and (Sender is TMenuItem) then begin
    Typ:=tNow;
    if (Sender=MenuItemThrough5min) then Typ:=t5min;
    if (Sender=MenuItemThrough10min) then Typ:=t10min;
    if (Sender=MenuItemThrough15min) then Typ:=t15min;
    if (Sender=MenuItemThrough20min) then Typ:=t20min;
    if (Sender=MenuItemThrough30min) then Typ:=t30min;
    if (Sender=MenuItemThrough40min) then Typ:=t40min;
    if (Sender=MenuItemThrough50min) then Typ:=t50min;
    if (Sender=MenuItemThrough1hour) then Typ:=t1hour;
    if (Sender=MenuItemThrough2hour) then Typ:=t2hour;
    if (Sender=MenuItemThrough3hour) then Typ:=t3hour;
    if (Sender=MenuItemThrough4hour) then Typ:=t4hour;
    if (Sender=MenuItemThrough5hour) then Typ:=t5hour;

    ParamDate:=Param.AsDateTime;
    case Typ of
      tNow: ParamDate:=Core.ServerDate;
      t5min: ParamDate:=IncMinute(ParamDate,5);
      t10min: ParamDate:=IncMinute(ParamDate,10);
      t15min: ParamDate:=IncMinute(ParamDate,15);
      t20min: ParamDate:=IncMinute(ParamDate,20);
      t30min: ParamDate:=IncMinute(ParamDate,30);
      t40min: ParamDate:=IncMinute(ParamDate,40);
      t50min: ParamDate:=IncMinute(ParamDate,50);
      t1hour: ParamDate:=IncHour(ParamDate,1);
      t2hour: ParamDate:=IncHour(ParamDate,2);
      t3hour: ParamDate:=IncHour(ParamDate,3);
      t4hour: ParamDate:=IncHour(ParamDate,4);
      t5hour: ParamDate:=IncHour(ParamDate,5);
    end;
    Param.Value:=ParamDate;
  end;
end;

procedure TBisTaxiOrderEditForm.UpdateCaption;
var
  NumParam: TBisParam;
  Route: TBisTaxiRoute;
  Address: String;
  F1,F2,F3,F4,F5,F6: String;
  T1,T2,T3,T4,T5,T6: String;
const
  SQ='?';
begin
  NumParam:=Provider.Params.ParamByName('ORDER_NUM');

  F1:=Trim(VarToStrDef(FAddressFrame.StreetPrefix,''));
  F2:=Trim(VarToStrDef(FAddressFrame.StreetName,''));
  F3:=Trim(VarToStrDef(FAddressFrame.House,''));
  F4:=Trim(VarToStrDef(FAddressFrame.Flat,''));
  F5:=Trim(VarToStrDef(FAddressFrame.LocalityPrefix,''));
  F6:=Trim(VarToStrDef(FAddressFrame.LocalityName,''));

  Route:=FRoutes.Items[FRoutes.Count-1];
  T1:=Trim(VarToStrDef(Route.Frame.StreetPrefix,''));
  T2:=Trim(VarToStrDef(Route.Frame.StreetName,''));
  T3:=Trim(VarToStrDef(Route.Frame.House,''));
  T4:=Trim(VarToStrDef(Route.Frame.Flat,''));
  T5:=Trim(VarToStrDef(Route.Frame.LocalityPrefix,''));
  T6:=Trim(VarToStrDef(Route.Frame.LocalityName,''));

  Address:='';
  if F2<>'' then
    Address:=FormatEx(' [%s%s %s-%s (%s%s) => %s%s %s-%s (%s%s)]',
                      [iff(F1='',SQ,F1),iff(F2='',SQ,F2),iff(F3='',SQ,F3),
                       iff(F4='',SQ,F4),iff(F5='',SQ,F5),iff(F6='',SQ,F6),
                       iff(T1='',SQ,T1),iff(T2='',SQ,T2),iff(T3='',SQ,T3),
                       iff(T4='',SQ,T4),iff(T5='',SQ,T5),iff(T6='',SQ,T6)]);

  Caption:=FormatEx('%s � %s%s',[FOldCaption,NumParam.AsString,Address]);
end;

procedure TBisTaxiOrderEditForm.UpdateRoutesControls;
var
  RateParam: TBisParamComboBoxDataSelect;
  TypeRate: TBisTaxiTypeRate;
  AEnabled: Boolean;
begin
  RateParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('RATE_ID'));
  if not RateParam.Empty then begin
    TypeRate:=TBisTaxiTypeRate(VarToIntDef(RateParam.Values.GetValue('TYPE_RATE'),0));
    AEnabled:=(Mode in [emInsert]) or ((Mode in [emUpdate]));
    FRoutes.ChangeByZone(not (TypeRate in [trMap1km]));
    FRoutes.Enable((TypeRate in [trProc,trZone1km]) and AEnabled,
                   (TypeRate in [trProc,trZone1min]) and AEnabled,
                   (TypeRate in [trProc,trZone]) and AEnabled);
  end;
end;

procedure TBisTaxiOrderEditForm.RadioButtonAutomaticClick(Sender: TObject);
var
  RadioButton: TRadioButton;
  Param: TBisParam;
begin
  RadioButton:=TRadioButton(Sender);
  if Assigned(RadioButton) then begin
    Param:=Provider.Params.ParamByName('TYPE_PROCESS');
    if (RadioButton=RadioButtonAutomatic) and RadioButton.Checked then Param.Value:=0;
    if (RadioButton=RadioButtonHand) and RadioButton.Checked then Param.Value:=1;
    FChangeTypeProcess:=true;
  end;
end;

procedure TBisTaxiOrderEditForm.RefreshRoutes;
var
  P: TBisProvider;
  Param: TBisParam;
  Route: TBisTaxiRoute;
begin
  Param:=Provider.Params.Find('ORDER_ID');
  if Assigned(Param) and not Param.Empty then begin
    TabSetRoutes.Tabs.BeginUpdate;
    TabSetRoutes.Tabs.Clear;
    FRoutes.Clear;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.StopException:=false;
      P.ProviderName:='S_ROUTES';
      with P.FieldNames do begin
        AddInvisible('LOCALITY_ID');
        AddInvisible('STREET_ID');
        AddInvisible('ZONE_ID');
        AddInvisible('HOUSE');
        AddInvisible('FLAT');
        AddInvisible('PORCH');
        AddInvisible('DISTANCE');
        AddInvisible('COST');
        AddInvisible('PERIOD');
        AddInvisible('AMOUNT');
      end;
      P.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
      P.Orders.Add('PRIORITY');
      try
        P.Open;
        if P.Active and not P.IsEmpty then begin
          P.First;
          while not P.Eof do begin
            Route:=AddRoute;
            with Route.Frame do begin
              Route.Frame.DisableChanges;
              try
                LocalityId:=P.FieldByName('LOCALITY_ID').Value;
                StreetId:=P.FieldByName('STREET_ID').Value;
                ZoneId:=P.FieldByName('ZONE_ID').Value;
                House:=P.FieldByName('HOUSE').Value;
                Flat:=P.FieldByName('FLAT').Value;
                Porch:=P.FieldByName('PORCH').Value;
                Distance:=P.FieldByName('DISTANCE').Value;
                Cost:=P.FieldByName('COST').Value;
                Period:=P.FieldByName('PERIOD').Value;
                Amount:=P.FieldByName('AMOUNT').Value;
                if VarIsNull(LocalityId) then begin
                  SetDefaultLocality;
                end;
              finally
                Route.Frame.EnableChanges;
              end;
            end;
            P.Next;
          end;
        end else
          AddRoute;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
      TabSetRoutes.Tabs.EndUpdate;
    end;
  end;
end;

function TBisTaxiOrderEditForm.LockOrder: Boolean;
var
  Param: TBisParam;
  P: TBisProvider;
  ALocked: String;
begin
  Result:=false;
  Param:=Provider.Params.ParamByName('ORDER_ID');
  if not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      ALocked:=GetUniqueID;
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.ProviderName:='LOCK_ORDER';
      with P.Params do begin
        AddInvisible('ORDER_ID').Value:=Param.Value;
        AddInvisible('LOCKED').Value:=ALocked;
        AddInvisible('TYPE_PROCESS').Value:=1;
      end;
      try
        P.Execute;
        Result:=P.Success;
        if Result and Assigned(Provider.ParentDataSet) and Provider.ParentDataSet.Active then begin
          if Provider.ParentDataSet.Locate('ORDER_ID',Param.Value,[loCaseInsensitive]) then begin
            Provider.ParentDataSet.Edit;
            Provider.ParentDataSet.FieldByName('LOCKED').Value:=ALocked;
            Provider.ParentDataSet.FieldByName('TYPE_PROCESS').Value:=1;
            Provider.ParentDataSet.Post;
          end;
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.UnLockOrder;
var
  Param: TBisParam;
  P: TBisProvider;
begin
  Param:=Provider.Params.ParamByName('ORDER_ID');
  if FLocked and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.ProviderName:='UNLOCK_ORDER';
      with P.Params do begin
        AddInvisible('ORDER_ID').Value:=Param.Value;
      end;
      try
        P.Execute;
        if P.Success and Assigned(Provider.ParentDataSet) and Provider.ParentDataSet.Active then begin
          if Provider.ParentDataSet.Locate('ORDER_ID',Param.Value,[loCaseInsensitive]) then begin
            Provider.ParentDataSet.Edit;
            Provider.ParentDataSet.FieldByName('LOCKED').Value:=Null;
            Provider.ParentDataSet.Post;
          end;
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisTaxiOrderEditForm.CheckLockOrder: Boolean;

  function Check: Boolean;
  var
    OrderId: Variant;
    P: TBisProvider;
  begin
    Result:=false;
    if (Mode in [emUpdate,emDelete]) and Assigned(Provider.ParentDataSet) and Provider.ParentDataSet.Active then begin
      OrderId:=Provider.ParentDataSet.FieldByName('ORDER_ID').Value;
      P:=TBisProvider.Create(nil);
      try
        P.StopException:=false;
        P.WithWaitCursor:=false;
        P.ProviderName:='CHECK_LOCK_ORDER';
        with P.Params do begin
          AddInvisible('ORDER_ID').Value:=OrderId;
          AddInvisible('LOCKED',ptOutput);
        end;
        try
          P.Execute;
          if P.Success then
            Result:=not VarIsNull(P.Params.ParamByName('LOCKED').Value);
        except
          on E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;
  end;

var
  S: String;
begin
  Result:=Check;
  if Result and Assigned(Provider.ParentDataSet) and Provider.ParentDataSet.Active then begin
    S:=FormatEx('����� � %s ������������. ��������������?',
                [Provider.ParentDataSet.FieldByName('ORDER_NUM').AsString]);
    Result:=ShowWarningQuestion(S,mbNo)=mrNo;
  end;
  FCheckLocked:=Result;
end;

procedure TBisTaxiOrderEditForm.RefreshData;
var
  DriverId: Variant;
  DriverParam: TBisParamComboBoxDataSelect;
  ClientId: Variant;
  DiscountParam: TBisParamComboBoxDataSelect;
begin
  RefreshServices;
 // Provider.Params.Refresh;

  Provider.Params.ParamByName('RATE_ID').Refresh;
  Provider.Params.ParamByName('CAR_TYPE_ID').Refresh;
  Provider.Params.ParamByName('PARK_ID').Refresh;

  if (Mode in [emView,emUpdate,emDelete]) and Assigned(Provider.ParentDataSet) and Provider.ParentDataSet.Active then begin
    DriverId:=Provider.ParentDataSet.FieldByName('DRIVER_ID').Value;
    DriverParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DRIVER_ID'));
    if not VarIsNull(DriverId) then begin
      DriverParam.FilterGroups.Clear;
      DriverParam.ProviderName:='S_DRIVERS';
      DriverParam.DataAlias:='USER_NAME;SURNAME;NAME';
      with DriverParam.FilterGroups.Add do begin
        Filters.Add('DRIVER_ID',fcEqual,DriverId).CheckCase:=true;
      end;
      DriverParam.Orders.Clear;
      DriverParam.Orders.Add('PRIORITY');
      DriverParam.Refresh;
    end else
      DriverParam.Clear;
  end;

  if (Mode in [emView,emUpdate,emDelete]) and Assigned(Provider.ParentDataSet) and Provider.ParentDataSet.Active then begin
    ClientId:=Provider.ParentDataSet.FieldByName('CLIENT_ID').Value;
    DiscountParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DISCOUNT_ID'));
    if not VarIsNull(ClientId) then begin
      DiscountParam.FilterGroups.Clear;
      DiscountParam.ProviderName:='S_DISCOUNTS';
      with DiscountParam.FilterGroups.Add do begin
        Filters.Add('CLIENT_ID',fcEqual,ClientId).CheckCase:=true;
      end;
      DiscountParam.Orders.Clear;
      DiscountParam.Orders.Add('PRIORITY');
      DiscountParam.Refresh;
    end else
      DiscountParam.Clear;
  end;

  Provider.Params.ParamByName('SOURCE_ID').Refresh;
  Provider.Params.ParamByName('ACTION_ID').Refresh;
  Provider.Params.ParamByName('RESULT_ID').Refresh;

  if not (Mode in [emInsert,emDuplicate]) then
    RefreshOrderServices;

  FAddressFrame.DisableChanges;
  try
    FAddressFrame.RefreshAll;
    if Mode in [emInsert] then begin
      with Provider.Params do begin
        Find('LOCALITY_NAME').DefaultValue:=Find('LOCALITY_NAME').Value;
        Find('STREET_NAME').DefaultValue:=Find('STREET_NAME').Value;
        Find('HOUSE').DefaultValue:=Find('HOUSE').Value;
        Find('FLAT').DefaultValue:=Find('FLAT').Value;
        Find('PORCH').DefaultValue:=Find('PORCH').Value;
        Find('ZONE_NAME').DefaultValue:=Find('ZONE_NAME').Value;
      end;
    end;
    if Mode in [emView,emUpdate,emDelete] then begin
      with FAddressFrame do begin
        LocalityId:=Provider.Params.ParamByName('LOCALITY_ID').Value;
        StreetId:=Provider.Params.ParamByName('STREET_ID').Value;
        ZoneId:=Provider.Params.ParamByName('ZONE_ID').Value;
        House:=Provider.Params.ParamByName('HOUSE').Value;
        Flat:=Provider.Params.ParamByName('FLAT').Value;
        Porch:=Provider.Params.ParamByName('PORCH').Value;
      end;
    end;
  finally
    FAddressFrame.EnableChanges;
  end;

  if Mode in [emView,emUpdate] then
    RefreshPhones;

  if Mode in [emInsert] then
    if not FBeforeShowed then
      AddRoute
    else FRoutes.CopyFrom(FAddressFrame)
  else
    RefreshRoutes;

  if Mode in [emInsert] then begin
    SetDefaultActionId;
  end;

end;

procedure TBisTaxiOrderEditForm.RefreshParams;
var
  D: TDateTime;
  Num: String;
  OldCursor: TCursor;
  OldProgress: Boolean;
  OldProgress2: Boolean;
begin

  OldCursor:=Screen.Cursor;
  OldProgress:=Core.ProgressEvents.Enabled;
  OldProgress2:=Core.ProgressEvents2.Enabled;
  Screen.Cursor:=crHourGlass;
  Core.ProgressEvents.Enabled:=false;
  Core.ProgressEvents2.Enabled:=false;
  EditCostGross.OnChange:=nil;
  try
    inherited RefreshParams;
    RefreshData;
    inherited RefreshParams;

    if Mode in [emInsert] then begin
      D:=Core.ServerDate;
      Num:=GetOrderNum(false);
      with Provider.Params do begin
        Find('DATE_ARRIVAL').SetNewValue(D);
        Find('ORDER_NUM').SetNewValue(Num);
        Find('WHO_ACCEPT_ID').SetNewValue(Core.AccountId);
        Find('WHO_ACCEPT').SetNewValue(Core.AccountUserName);
        Find('FIRM_ID').SetNewValue(Core.FirmId);
        Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
        Find('DATE_ACCEPT').SetNewValue(D);
        Find('WHO_PROCESS_ID').SetNewValue(Core.AccountId);
        Find('WHO_PROCESS').SetNewValue(Core.AccountUserName);
        Find('DATE_BEGIN').SetNewValue(D);
        Find('DATE_END').SetNewValue(D);
        Find('TYPE_PROCESS').SetNewValue(1);
      end;
    end;
    if Mode in [emUpdate] then begin
      D:=Core.ServerDate;
      FLocked:=LockOrder;
      if FLocked then begin
        with Provider.Params do begin
          Find('WHO_PROCESS_ID').SetNewValue(Core.AccountId);
          Find('WHO_PROCESS').SetNewValue(Core.AccountUserName);
          Find('DATE_BEGIN').SetNewValue(D);
          Find('DATE_END').SetNewValue(Null);
        end;
      end else begin
        with Provider.Params do begin
          Find('WHO_PROCESS_ID').SetNewValue(Core.AccountId);
          Find('WHO_PROCESS').SetNewValue(Core.AccountUserName);
          Find('DATE_BEGIN').SetNewValue(D);
          Find('DATE_END').SetNewValue(Null);
        end;
      end;
      Provider.Params.Enabled:=not FCheckLocked or FLocked;
      Provider.Params.ApplyMode(Mode);
      ChangeParam(Provider.Params.ParamByName('TYPE_PROCESS'));
      SetDistanceByMap(false);
    end;

    if Mode in [emView,emDelete] then
      SetDistanceByMap(false);
    
  finally
    EditCostGross.OnChange:=EditCostGrossChange;
    Core.ProgressEvents.Enabled:=OldProgress;
    Core.ProgressEvents2.Enabled:=OldProgress2;
    Screen.Cursor:=OldCursor;
  end;
end;

function TBisTaxiOrderEditForm.CanShow: Boolean;
begin
  Result:=inherited CanShow;
  if Result then
    Result:=not CheckLockOrder;
end;

procedure TBisTaxiOrderEditForm.BeforeShow;
var
  ACanUpdate: Boolean;
begin
  FOldCaption:=Caption;
  PageControl.TabIndex:=0;

  FRefreshDrivers:=true;

  inherited BeforeShow;

  ACanUpdate:=true;
  if Mode in [emUpdate] then
    ACanUpdate:=not FCheckLocked or FLocked;

  ACanUpdate:=ACanUpdate and (Mode in [emInsert,emUpdate]);

  TabSheetHistory.TabVisible:=not (Mode in [emInsert]);
  TabSheetMessages.TabVisible:=not (Mode in [emInsert]);
  TabSheetCalls.TabVisible:=not (Mode in [emInsert]);
  TabSheetCharges.TabVisible:=not (Mode in [emInsert]);
  TabSheetReceipts.TabVisible:=not (Mode in [emInsert]);
  ButtonArrival.Enabled:=ACanUpdate or (Mode=emView);
  ButtonOrderNum.Enabled:=Mode in [emInsert];
  LabelServices.Enabled:=ACanUpdate or (Mode=emView);
  CheckListBoxServices.Enabled:=ACanUpdate or (Mode=emView);
  BitBtnAddRoute.Enabled:=ACanUpdate or (Mode=emView);
  BitBtnDeleteRoute.Enabled:=(TabSetRoutes.Tabs.Count>1) and (ACanUpdate or (Mode=emView));
  ButtonCostRate.Enabled:=ACanUpdate or (Mode=emView);
  RadioButtonAutomatic.Enabled:=ACanUpdate or (Mode=emView);
  RadioButtonHand.Enabled:=ACanUpdate or (Mode=emView);

  FAddressFrame.EnableControls(ACanUpdate or (Mode=emView));
  FRoutes.EnableControls(ACanUpdate or (Mode=emView));
  TabSetRoutes.Enabled:=ACanUpdate or (Mode=emView);
  FRouteHistoryFrame.EnableControls(ACanUpdate or (Mode=emView));

  UpdateCaption;
  UpdateButtons;
  FAddressFrame.UpdateButtons(ACanUpdate or (Mode=emView));
  FRoutes.UpdateButtons(ACanUpdate or (Mode=emView));
  UpdateRoutesControls;
  UpdateButtonState;

  FDateBegin:=Provider.Params.ParamByName('DATE_BEGIN').AsDateTime;
  TimerProcess.Enabled:=ACanUpdate;

  TBisParamEditCalc(Provider.Params.ParamByName('COST_GROSS')).EditCalc.MaxValue:=99999.0;
  TBisParamEditCalc(Provider.Params.ParamByName('COST_RATE')).EditCalc.MaxValue:=99999.0;
  TBisParamEditCalc(Provider.Params.ParamByName('COST_FACT')).EditCalc.MaxValue:=99999.0;

  FChangeServices:=false;
  FChangeTypeProcess:=false;
  FChangeRoutes:=false;
  FChangeAddress:=false;
  FChangeZone:=false;
  FChangeCost:=false;

  FFirstRefreshPark:=false;
  FFirstRefreshDriver:=false;
  FFirstRefreshDiscount:=false;

  if not (Mode in [emDelete]) then


  if Mode in [emDelete] then begin
    EnableControl(TabSheetMain,false);
    EnableControl(TabSheetReceipts,false);
    EnableControl(TabSheetCharges,false);
    EnableControl(TabSheetInMessages,false);
    EnableControl(TabSheetOutMessages,false);
    EnableControl(TabSheetInCalls,false);
    EnableControl(TabSheetOutCalls,false);
  end else begin
    FReceiptsFrame.ShowType:=ShowType;
    FChargesFrame.ShowType:=ShowType;
    FInMessagesFrame.ShowType:=ShowType;
    FOutMessagesFrame.ShowType:=ShowType;
    FInCallsFrame.ShowType:=ShowType;
    FOutCallsFrame.ShowType:=ShowType;
    ActiveControl:=FAddressFrame.ComboBoxStreet;
  end;

  if Trim(FDefaultPhone)<>'' then begin
    Provider.ParamByName('PHONE').SetNewValue(FDefaultPhone);
    TimerPhone.Interval:=500;
    TimerPhone.Enabled:=true;
    FDefaultPhone:='';
  end;

  FBeforeShowed:=true;
end;

procedure TBisTaxiOrderEditForm.ChangeParam(Param: TBisParam);
var
  PhoneParam: TBisParam;
  CarTypeParam: TBisParamComboBoxDataSelect;
  DriverParam: TBisParamComboBoxDataSelect;
  ParkParam: TBisParamComboBoxDataSelect;
  ActionParam: TBisParamComboBoxDataSelect;
  ResultParam: TBisParamComboBoxDataSelect;
  ClientParam: TBisParamEditdataSelect;
  DiscountParam: TBisParamComboBoxDataSelect;
  P1: TBisParam;
  FlagAccept: Boolean;
  D: TDateTime;
begin
  inherited ChangeParam(Param);
  if Assigned(Param) then begin
//    LoggerWrite(Param.ParamName);

    if (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'ZONE_NAME') then begin
      Caption:=Caption;
    end;

    if FBeforeShowed and
       (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'RATE_NAME') then begin
      UpdateRoutesControls;
      SetDistanceByMap(false);
      Calculate(true,true);
    end;

    if (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'CAR_TYPE_NAME') then begin
      if FBeforeShowed then begin
        ChangeParam(Provider.Params.ParamByName('PARK_NAME;PARK_DESCRIPTION'));
        Calculate(true,true);
      end;
    end;

    if FBeforeShowed and
       (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'ORDER_NUM') then begin
      UpdateCaption;
    end;

    if FBeforeShowed and
       (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME') then begin
      ClientParam:=TBisParamEditdataSelect(Provider.Params.ParamByName('CLIENT_ID'));

      DiscountParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DISCOUNT_ID'));
      DiscountParam.FilterGroups.Clear;
      if ClientParam.Empty then begin
        DiscountParam.FirstSelected:=false;
        DiscountParam.Clear;
      end else begin
        D:=DateOf(Core.ServerDate);
        DiscountParam.ProviderName:='S_DISCOUNTS';
        DiscountParam.FirstSelected:=true;
        with DiscountParam.FilterGroups.Add do begin
          Filters.Add('CLIENT_ID',fcEqual,ClientParam.Value).CheckCase:=true;
          Filters.Add('DATE_BEGIN',fcEqualLess,D);
        end;
        with DiscountParam.FilterGroups.Add do begin
          Filters.Add('DATE_END',fcIsNull,Null);
          Filters.Add('DATE_END',fcEqualGreater,D).&Operator:=foOr;
        end;
        DiscountParam.Orders.Clear;
        DiscountParam.Orders.Add('PRIORITY');
        DiscountParam.Refresh;
      end;
      
      if FNeedClientChange then begin

        PhoneParam:=Provider.Params.ParamByName('PHONE');
        if PhoneParam.Empty and not Param.Empty then
          PhoneParam.Value:=ClientParam.Values.GetValue('PHONE');
        if ClientParam.Empty then begin
          Provider.ParamByName('CLIENT_USER_NAME').SetNewValue(Null);
          Provider.ParamByName('CLIENT_SURNAME').SetNewValue(Null);
          Provider.ParamByName('CLIENT_NAME').SetNewValue(Null);
          Provider.ParamByName('CLIENT_PATRONYMIC').SetNewValue(Null);
          Provider.ParamByName('CLIENT_FIRM_SMALL_NAME').SetNewValue(Null);
          Provider.ParamByName('CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME').SetNewValue(Null);
        end else begin
          Provider.ParamByName('CLIENT_USER_NAME').SetNewValue(ClientParam.Values.GetValue('USER_NAME'));
          Provider.ParamByName('CLIENT_SURNAME').SetNewValue(ClientParam.Values.GetValue('SURNAME'));
          Provider.ParamByName('CLIENT_NAME').SetNewValue(ClientParam.Values.GetValue('NAME'));
          Provider.ParamByName('CLIENT_PATRONYMIC').SetNewValue(ClientParam.Values.GetValue('PATRONYMIC'));
          Provider.ParamByName('CLIENT_FIRM_SMALL_NAME').SetNewValue(ClientParam.Values.GetValue('FIRM_SMALL_NAME'));
          P1:=Provider.Params.ParamByName('CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME');
          P1.SetNewValue(FormatEx(P1.ParamFormat,[ClientParam.Values.Find('SURNAME').Value,
                                                  ClientParam.Values.Find('NAME').Value,
                                                  ClientParam.Values.Find('PATRONYMIC').Value,
                                                  ClientParam.Values.Find('FIRM_SMALL_NAME').Value]));
        end;

        FlagAccept:=true;
        if not Param.Empty then
          FlagAccept:=ShowQuestion('����� ����� ������� � �������� ������ ������?')=mrYes;
        if FlagAccept then begin
          if ClientParam.Empty then begin
            Provider.ParamByName('DESCRIPTION').SetNewValue(Null);
            FAddressFrame.LocalityId:=Null;
            FAddressFrame.StreetId:=Null;
            FAddressFrame.EditHouse.Text:='';
            FAddressFrame.EditFlat.Text:='';
            FAddressFrame.EditPorch.Text:='';
          end else begin
            Provider.ParamByName('DESCRIPTION').SetNewValue(ClientParam.Values.GetValue('ADDRESS_DESC'));
            FAddressFrame.LocalityId:=ClientParam.Values.GetValue('LOCALITY_ID');
            FAddressFrame.StreetId:=ClientParam.Values.GetValue('STREET_ID');
            FAddressFrame.EditHouse.Text:=VarToStrDef(ClientParam.Values.GetValue('HOUSE'),'');
            FAddressFrame.EditFlat.Text:=VarToStrDef(ClientParam.Values.GetValue('FLAT'),'');
            FAddressFrame.EditPorch.Text:=VarToStrDef(ClientParam.Values.GetValue('PORCH'),'');
          end;
          if VarIsNull(FAddressFrame.LocalityId) then
            FAddressFrame.SetDefaultLocality;
          SetDistanceByMap(false);
          RefreshPhones;
          SetRouteHistory(false);  
        end;
      end;

    end;

    if FBeforeShowed and
       (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'PARK_NAME;PARK_DESCRIPTION') then begin
      CarTypeParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('CAR_TYPE_ID'));
      ParkParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('PARK_ID'));
      DriverParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DRIVER_ID'));
      DriverParam.FilterGroups.Clear;
      DriverParam.Orders.Clear;
      if ParkParam.Empty then begin
        Provider.Params.ParamByName('PARK_NAME').SetNewValue(Null);
        Provider.Params.ParamByName('PARK_DESCRIPTION').SetNewValue(Null);
        DriverParam.ProviderName:='S_DRIVER_SHIFTS';
        DriverParam.DataAlias:='DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME';
        with DriverParam.FilterGroups.Add do begin
          Filters.AddInside('CAR_ID','','S_CAR_IN_TYPES').InsideFilterGroups.Add.Filters.Add('CAR_TYPE_ID',fcEqual,CarTypeParam.Value).CheckCase:=true;
          Filters.Add('DATE_END',fcIsNull,Null);
        end;
        with DriverParam.Orders do begin
          Add('DRIVER_USER_NAME');
        end;
      end else begin
        Provider.Params.ParamByName('PARK_NAME').SetNewValue(ParkParam.Values.GetValue('PARK_NAME'));
        Provider.Params.ParamByName('PARK_DESCRIPTION').SetNewValue(ParkParam.Values.GetValue('PARK_DESCRIPTION'));
        DriverParam.ProviderName:='S_PARK_STATES';
        DriverParam.DataAlias:='DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME';
        with DriverParam.FilterGroups.Add do begin
          Filters.AddInside('CAR_ID','','S_CAR_IN_TYPES').InsideFilterGroups.Add.Filters.Add('CAR_TYPE_ID',fcEqual,CarTypeParam.Value).CheckCase:=true;
          Filters.Add('PARK_ID',fcEqual,ParkParam.Value).CheckCase:=true;
          Filters.Add('DATE_OUT',fcIsNull,Null);
        end;
        with DriverParam.Orders do begin
          Add('PRIORITY');
          Add('DATE_IN');
        end;
      end;

      if FRefreshDrivers then begin
        DriverParam.Refresh;
//        Calculate;
      end;
    end;

    if FBeforeShowed and
       (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME') then begin
      DriverParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DRIVER_ID'));
      if DriverParam.Empty then begin
        Provider.Params.ParamByName('DRIVER_USER_NAME').SetNewValue(Null);
        Provider.Params.ParamByName('DRIVER_SURNAME').SetNewValue(Null);
        Provider.Params.ParamByName('DRIVER_NAME').SetNewValue(Null);
        Provider.Params.ParamByName('DRIVER_PATRONYMIC').SetNewValue(Null);
        Provider.Params.ParamByName('DRIVER_PHONE').SetNewValue(Null);
        Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(Null);
        Provider.Params.ParamByName('CAR_ID').SetNewValue(Null);
        Provider.Params.ParamByName('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM').SetNewValue(Null);
      end else begin
        Provider.Params.ParamByName('DRIVER_USER_NAME').SetNewValue(DriverParam.Values.GetValue('DRIVER_USER_NAME'));
        Provider.Params.ParamByName('DRIVER_SURNAME').SetNewValue(DriverParam.Values.GetValue('DRIVER_SURNAME'));
        Provider.Params.ParamByName('DRIVER_NAME').SetNewValue(DriverParam.Values.GetValue('DRIVER_NAME'));
        Provider.Params.ParamByName('DRIVER_PATRONYMIC').SetNewValue(DriverParam.Values.GetValue('DRIVER_PATRONYMIC'));
        Provider.Params.ParamByName('DRIVER_PHONE').SetNewValue(DriverParam.Values.GetValue('DRIVER_PHONE'));
        Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(DriverParam.Values.GetValue('CAR_CALLSIGN'));
        Provider.Params.ParamByName('CAR_ID').SetNewValue(DriverParam.Values.Find('CAR_ID').Value);
        P1:=Provider.Params.ParamByName('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM');
        P1.SetNewValue(FormatEx(P1.ParamFormat,[DriverParam.Values.Find('CAR_COLOR').Value,
                                                DriverParam.Values.Find('CAR_BRAND').Value,
                                                DriverParam.Values.Find('CAR_STATE_NUM').Value]));
      end;
      UpdateButtons;
    end;

    if FBeforeShowed and
       (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'DISCOUNT_NUM;DISCOUNT_TYPE_NAME') then begin
      FManualCalculate:=true;
      try
        Calculate(false,true);
      finally
        FManualCalculate:=false;
      end;
    end;

    if (Mode in [emInsert,emUpdate]) and
       (AnsiSameText(Param.ParamName,'ACTION_NAME') or AnsiSameText(Param.ParamName,'ACTION_ID')) then begin
      ActionParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('ACTION_ID'));
      ResultParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('RESULT_ID'));
      if not ActionParam.Empty then begin
        Provider.Params.ParamByName('ACTION_BRUSH_COLOR').SetNewValue(ActionParam.Values.GetValue('BRUSH_COLOR'));
        Provider.Params.ParamByName('ACTION_FONT_COLOR').SetNewValue(ActionParam.Values.GetValue('FONT_COLOR'));
        ResultParam.FilterGroups.Clear;
        ResultParam.FilterGroups.Add.Filters.Add('ACTION_ID',fcEqual,ActionParam.Value).CheckCase:=true;
        ResultParam.FilterGroups.Add.Filters.Add('VISIBLE',fcEqual,1);
        ResultParam.Refresh;
      end else begin
        Provider.Params.ParamByName('ACTION_BRUSH_COLOR').SetNewValue(Null);
        Provider.Params.ParamByName('ACTION_FONT_COLOR').SetNewValue(Null);
        ResultParam.Clear;
      end;
    end;

    if (Mode in [emInsert,emUpdate]) and
       (AnsiSameText(Param.ParamName,'RESULT_NAME') or AnsiSameText(Param.ParamName,'RESULT_ID')) then begin
      ResultParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('RESULT_ID'));
      if not ResultParam.Empty then begin
        Provider.Params.ParamByName('RESULT_BRUSH_COLOR').SetNewValue(ResultParam.Values.GetValue('BRUSH_COLOR'));
        Provider.Params.ParamByName('RESULT_FONT_COLOR').SetNewValue(ResultParam.Values.GetValue('FONT_COLOR'));
      end else begin
        Provider.Params.ParamByName('RESULT_BRUSH_COLOR').SetNewValue(Null);
        Provider.Params.ParamByName('RESULT_FONT_COLOR').SetNewValue(Null);
      end;
    end;

    if (Mode in [emInsert,emUpdate]) and
       AnsiSameText(Param.ParamName,'TYPE_PROCESS') and not Param.Empty then begin
      RadioButtonAutomatic.Checked:=not Boolean(Param.AsInteger);
      RadioButtonHand.Checked:=not RadioButtonAutomatic.Checked;
      Provider.Params.ParamByName('ACTION_ID').Enabled:=Boolean(Param.AsInteger);
      Provider.Params.ParamByName('RESULT_ID').Enabled:=Boolean(Param.AsInteger);
    end;

  end;
end;

procedure TBisTaxiOrderEditForm.AddressFrameChangeAddress(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TBisTaxiAddressFrame) then begin
    if TBisTaxiAddressFrame(Sender).CanDistance then
      SetDistanceByMap(true);
    FChangeAddress:=true;
    UpdateCaption;
    UpdateButtonState;
  end;
end;

procedure TBisTaxiOrderEditForm.AddressFrameChangeZone(Sender: TObject);
var
  ZoneId: Variant;
  ParkParam: TBisParamComboBoxDataSelect;
  DriverParam: TBisParamComboBoxDataSelect;
begin
  ZoneId:=FAddressFrame.ZoneId;
  DriverParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DRIVER_ID'));
  ParkParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('PARK_ID'));
  ParkParam.FilterGroups.Clear;
  ParkParam.Orders.Clear;
  if VarIsNull(ZoneId) then begin
    FRefreshDrivers:=true;
    ParkParam.DataClass:=TBisTaxiDataParksFormIface;
    ParkParam.ProviderName:='';
    ParkParam.DataAlias:='NAME;DESCRIPTION';
    ParkParam.FirstSelected:=false;
    ParkParam.Refresh;
  end else begin
    FRefreshDrivers:=false;
    ParkParam.DataClass:=nil;
    ParkParam.ProviderName:='S_ZONE_PARKS';
    ParkParam.DataAlias:='PARK_NAME;PARK_DESCRIPTION';
//    ParkParam.FirstSelected:=true;
    ParkParam.Orders.Add('DISTANCE');
    ParkParam.Orders.Add('PERIOD');
    ParkParam.FilterGroups.Add.Filters.Add('ZONE_ID',fcEqual,ZoneId).CheckCase:=true;
    ParkParam.Refresh;
    FRefreshDrivers:=true;
    DriverParam.Refresh;
  end;
  if TabSetRoutes.Tabs.Count>0 then
    FRoutes.RefreshZoneCost(TBisTaxiRoute(TabSetRoutes.Tabs.Objects[0]));
  Calculate(true,true);
  FChangeZone:=true;
  UpdateButtonState;
end;

procedure TBisTaxiOrderEditForm.AddressFrameSetFirm(Sender: TObject);
begin
  Provider.Params.ParamByName('DESCRIPTION').Value:=FAddressFrame.FirmSmallName;
end;

function TBisTaxiOrderEditForm.ChangesExists: Boolean;
begin
  Result:=(inherited ChangesExists or FChangeServices or FChangeTypeProcess or
           FChangeRoutes or FChangeAddress or FChangeZone or FChangeCost) and FBeforeShowed;
end;

function TBisTaxiOrderEditForm.FindParamComponent(Param: TBisParam; ComponentName: String): TComponent;
begin
  Result:=inherited FindParamComponent(Param,ComponentName);
  if Assigned(Param) then begin
    if AnsiSameText(Param.ParamName,'LOCALITY_NAME') or
       AnsiSameText(Param.ParamName,'STREET_NAME') or
       AnsiSameText(Param.ParamName,'HOUSE') or
       AnsiSameText(Param.ParamName,'FLAT') or
       AnsiSameText(Param.ParamName,'PORCH') or
       AnsiSameText(Param.ParamName,'ZONE_NAME') then
      Result:=FAddressFrame.FindComponent(ComponentName);
  end;
end;

procedure TBisTaxiOrderEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Index: Integer;
begin
  if (ssCtrl in Shift) and (PageControl.ActivePage=TabSheetMain) then begin
    if Char(Key) in ['1'..'9'] then begin
      Index:=StrToIntDef(Char(Key),1)-1;
      if TabSetRoutes.Tabs.Count>Index then begin
        if TabSetRoutes.TabIndex<>Index then
          TabSetRoutes.TabIndex:=Index;
      end;
    end;
    if (Mode in [emInsert,emUpdate]) then begin
      if Char(Key) in ['k'] then
        if BitBtnAddRoute.Enabled then
          BitBtnAddRoute.Click;
      if Char(Key) in ['m'] then
        if BitBtnDeleteRoute.Enabled then
          BitBtnDeleteRoute.Click;
    end;
    if Char(Key) in ['q','Q','�','�'] then begin
      if TabSetAddressHistory.TabIndex<>0 then begin
        TabSetAddressHistory.TabIndex:=0;
      end;
    end;
    if Char(Key) in ['w','W','�','�'] then begin
      if TabSetAddressHistory.TabIndex<>1 then begin
        TabSetAddressHistory.TabIndex:=1;
      end;
    end;
  end;
end;

function TBisTaxiOrderEditForm.FrameCan(Sender: TBisDataFrame): Boolean;
begin
  Result:=false;
end;

procedure TBisTaxiOrderEditForm.UpdateRouteSize;
var
  Route: TBisTaxiRoute;
begin
  if Assigned(TabSetRoutes) and (TabSetRoutes.TabIndex<>-1) then begin
    Route:=TBisTaxiRoute(TabSetRoutes.Tabs.Objects[TabSetRoutes.TabIndex]);
    with Route.Frame do begin
      ComboBoxStreet.Anchors:=ComboBoxStreet.Anchors-[akRight];
      ComboBoxZone.Anchors:=ComboBoxZone.Anchors-[akRight];
      EditCost.Anchors:=EditCost.Anchors-[akRight];
      LabelDistance.Anchors:=LabelDistance.Anchors-[akRight];
      EditDistance.Anchors:=EditDistance.Anchors-[akRight];
      EditDistanceAll.Anchors:=EditDistanceAll.Anchors-[akRight];
      LabelPeriod.Anchors:=LabelPeriod.Anchors-[akRight];
      EditPeriod.Anchors:=EditPeriod.Anchors-[akRight];

      ComboBoxStreet.Width:=PanelRoutes.Width-ComboBoxStreet.Left-FFirstSpaceWidth;
      ComboBoxZone.Width:=PanelRoutes.Width-ComboBoxZone.Left-FFirstSpaceWidth;
      EditCost.Width:=PanelRoutes.Width-EditCost.Left-FFirstSpaceWidth;

      ComboBoxStreet.Anchors:=ComboBoxStreet.Anchors+[akRight];
      ComboBoxZone.Anchors:=ComboBoxZone.Anchors+[akRight];
      EditCost.Anchors:=EditCost.Anchors+[akRight];
      LabelDistance.Anchors:=LabelDistance.Anchors+[akRight];
      EditDistance.Anchors:=EditDistance.Anchors+[akRight];
      EditDistanceAll.Anchors:=EditDistanceAll.Anchors+[akRight];
      LabelPeriod.Anchors:=LabelPeriod.Anchors+[akRight];
      EditPeriod.Anchors:=EditPeriod.Anchors+[akRight];
    end;
  end;
end;

function TBisTaxiOrderEditForm.AddRoute: TBisTaxiRoute;
var
  Index: Integer;
  Route: TBisTaxiRoute;
  RateParam: TBisParamComboBoxDataSelect;
  TypeRate: TBisTaxiTypeRate;
begin
  Route:=FRoutes.Add;
  Route.Frame.Init;
  Route.Gradient.BeginColor:=PanelRoutes.Color;
  if FRoutes.Count=1 then begin
    FFirstSpaceWidth:=TabSetRoutes.Width+7;
    Route.Frame.CopyFrom(FAddressFrame);
    Route.Frame.PriorFrame:=FAddressFrame;
  end else begin
    if FRoutes.Count>1 then begin
      Route.Frame.CopyFrom(FAddressFrame);
      Route.Frame.PriorFrame:=FRoutes.Items[FRoutes.Count-2].Frame;
    end;
  end;
  Index:=FRoutes.Count;
  Index:=TabSetRoutes.Tabs.AddObject(IntToStr(Index),Route);
  RateParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('RATE_ID'));
  if not RateParam.Empty then begin
    TypeRate:=TBisTaxiTypeRate(VarToIntDef(RateParam.Values.GetValue('TYPE_RATE'),0));
    Route.Frame.ChangeByZone:=not (TypeRate in [trMap1km]);
    Route.Enable(TypeRate in [trProc,trZone1km], TypeRate in [trProc,trZone1min], TypeRate in [trProc,trZone]);
  end;
  Route.Frame.OnChangeAddress:=AddressFrameChangeAddress;
  Route.Frame.OnChangeZone:=RouteFrameChangeZone;
  Route.Frame.OnZoneCostChange:=RouteFrameZoneCostChange;
  Route.Frame.UpdateButtons(true);
  Route.Frame.ParentForm:=Self;
  TabSetRoutes.TabIndex:=Index;
  UpdateRouteSize;
  BitBtnAddRoute.Enabled:=Index<8;
//  BitBtnDeleteRoute.Enabled:=Index>0;
  BitBtnDeleteRoute.Enabled:=TabSetRoutes.Tabs.Count>1;
  PanelRouteButtons.TabOrder:=Route.Panel.TabOrder+1;
  FChangeRoutes:=true;
  UpdateButtonState;
  Result:=Route;
end;

procedure TBisTaxiOrderEditForm.RouteFrameChangeZone(Sender: TObject);
var
  Index: Integer;
begin
  if Assigned(Sender) and (Sender is TBisTaxiAddressFrame) then begin
    Index:=TabSetRoutes.TabIndex+1;
    if Index<TabSetRoutes.Tabs.Count then
      FRoutes.RefreshZoneCost(TBisTaxiRoute(TabSetRoutes.Tabs.Objects[Index]));
    Calculate(true,true);
    FChangeZone:=true;
    UpdateButtonState;
  end;
end;

procedure TBisTaxiOrderEditForm.RouteFrameZoneCostChange(Sender: TObject);
begin
  Calculate(true,true);
  FChangeCost:=true;
  UpdateButtonState;
end;

procedure TBisTaxiOrderEditForm.UpdateRoutesCaption;
var
  i: Integer;
begin
  TabSetRoutes.Tabs.BeginUpdate;
  try
    for i:=0 to FRoutes.Count-1 do
      TabSetRoutes.Tabs.Strings[i]:=IntToStr(i+1);
  finally
    TabSetRoutes.Tabs.EndUpdate;
  end;
end;

procedure TBisTaxiOrderEditForm.DeleteRoute;
var
  Route: TBisTaxiRoute;
  AllowChange: Boolean;
begin
  if TabSetRoutes.TabIndex<>-1 then begin
    Route:=TBisTaxiRoute(TabSetRoutes.Tabs.Objects[TabSetRoutes.TabIndex]);
    FRoutes.Remove(Route);
    FChangeRoutes:=true;
    TabSetRoutes.Tabs.Delete(TabSetRoutes.TabIndex);
    UpdateRoutesCaption;
    AllowChange:=true;
    TabSetRoutesChange(TabSetRoutes,TabSetRoutes.TabIndex,AllowChange);
  end;
  FRoutes.RefreshZoneCost(TBisTaxiRoute(TabSetRoutes.Tabs.Objects[TabSetRoutes.TabIndex]));
  Calculate(true,true);
  BitBtnAddRoute.Enabled:=TabSetRoutes.Tabs.Count<=8;
//  BitBtnDeleteRoute.Enabled:=TabSetRoutes.TabIndex>0;
  BitBtnDeleteRoute.Enabled:=TabSetRoutes.Tabs.Count>1;
  UpdateButtonState;
end;

procedure TBisTaxiOrderEditForm.BitBtnAddRouteClick(Sender: TObject);
begin
  AddRoute;
end;

procedure TBisTaxiOrderEditForm.BitBtnBlackClick(Sender: TObject);
begin
  BlackInsert;
end;

procedure TBisTaxiOrderEditForm.BitBtnCheckPhoneClick(Sender: TObject);
begin
  CheckPhoneBlack(true,false);
end;

procedure TBisTaxiOrderEditForm.BitBtnDeleteRouteClick(Sender: TObject);
begin
  DeleteRoute;
end;

procedure TBisTaxiOrderEditForm.BitBtnDriverPhoneClick(Sender: TObject);
var
  Pt: TPoint;
begin
  if CanDriverPhone then begin
    Pt:=PanelDriver.ClientToScreen(Point(BitBtnDriverPhone.Left,BitBtnDriverPhone.Top+BitBtnDriverPhone.Height));
    PopupDriverPhone.Popup(Pt.X,Pt.Y);
  end;
end;

procedure TBisTaxiOrderEditForm.BitBtnClientPhoneClick(Sender: TObject);
var
  Pt: TPoint;
begin
  if CanClientPhone then begin
    Pt:=PanelMain.ClientToScreen(Point(BitBtnClientPhone.Left,BitBtnClientPhone.Top+BitBtnClientPhone.Height));
    PopupClientPhone.Popup(Pt.X,Pt.Y);
  end;
end;

procedure TBisTaxiOrderEditForm.TabSetAddressHistoryChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  PanelAddressRoutes.Visible:=NewTab=0;
  PanelRouteHistory.Visible:=not PanelAddressRoutes.Visible;
  if PanelRouteHistory.Visible then
    SetRouteHistory(false);
end;

procedure TBisTaxiOrderEditForm.TabSetRoutesChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
var
  OldRoute: TBisTaxiRoute;
  NewRoute: TBisTaxiRoute;
begin
  if (TabSetRoutes.TabIndex<>-1) and (TabSetRoutes.TabIndex<>NewTab) then begin
    OldRoute:=TBisTaxiRoute(TabSetRoutes.Tabs.Objects[TabSetRoutes.TabIndex]);
    OldRoute.Panel.Visible:=false;
  end;
  NewRoute:=TBisTaxiRoute(TabSetRoutes.Tabs.Objects[NewTab]);
  NewRoute.Panel.Visible:=true;
  if FBeforeShowed and NewRoute.Panel.Visible and NewRoute.Frame.ComboBoxStreet.CanFocus then
    NewRoute.Frame.ComboBoxStreet.SetFocus;
//  BitBtnDeleteRoute.Enabled:=(NewTab>0) and NewRoute.Panel.Enabled;
  BitBtnDeleteRoute.Enabled:=(TabSetRoutes.Tabs.Count>1) and NewRoute.Panel.Enabled;
end;

procedure TBisTaxiOrderEditForm.TimerProcessTimer(Sender: TObject);
var
  OldChange: TBisParamChangeEvent;
begin
  TimerProcess.Enabled:=false;
  OldChange:=Provider.Params.ParamByName('DATE_END').OnChange;
  try
    FDateBegin:=IncMilliSecond(FDateBegin,TimerProcess.Interval);
    Provider.Params.ParamByName('DATE_END').OnChange:=nil;
    Provider.Params.ParamByName('DATE_END').SetNewValue(FDateBegin);
  finally
    Provider.Params.ParamByName('DATE_END').OnChange:=OldChange;
    TimerProcess.Enabled:=true;
  end;
end;

procedure TBisTaxiOrderEditForm.CheckListBoxServicesClickCheck(Sender: TObject);
begin
  FChangeServices:=true;
  Calculate(true,true);
  UpdateButtonState;
end;

function TBisTaxiOrderEditForm.CanBlackInsert: Boolean;
var
  AIface: TBisTaxiDataBlackInsertFormIface;
  ParamPhone: TBisParam;
begin
  AIface:=TBisTaxiDataBlackInsertFormIface.Create(Self);
  try
    AIface.Init;
    ParamPhone:=Provider.Params.ParamByName('PHONE');
    Result:=AIface.CanShow and not ParamPhone.Empty;
  finally
    AIface.Free;
  end;
end;

function TBisTaxiOrderEditForm.CanClientPhone: Boolean;
var
  ParamPhone: TBisParam;
begin
  ParamPhone:=Provider.Params.ParamByName('PHONE');
  Result:=not ParamPhone.Empty;
end;

function TBisTaxiOrderEditForm.CanDriverPhone: Boolean;
var
  ParamPhone: TBisParam;
begin
  ParamPhone:=Provider.Params.ParamByName('DRIVER_PHONE');
  Result:=not ParamPhone.Empty;
end;

procedure TBisTaxiOrderEditForm.BlackInsert;
var
  AIface: TBisTaxiDataBlackInsertFormIface;
  Phone: String;
  Description: String;
  ParamPhone: TBisParam;
  Param: TBisParam;
begin
  if CanBlackInsert then begin
    ParamPhone:=Provider.Params.ParamByName('PHONE');
    if not ExistsPhoneBlack(ParamPhone.AsString,Description) then begin
      AIface:=TBisTaxiDataBlackInsertFormIface.Create(Self);
      try
        AIface.Init;
        AIface.ShowType:=ShowType;
        with Provider.Params do begin
          Phone:=PreparePhone(ParamPhone.AsString);
          AIface.Params.ParamByName('PHONE').SetNewValue(Phone);
          AIface.Params.ParamByName('LOCALITY_PREFIX').Value:=FAddressFrame.LocalityPrefix;
          AIface.Params.ParamByName('LOCALITY_NAME').Value:=FAddressFrame.LocalityName;
          AIface.Params.ParamByName('LOCALITY_ID').Value:=FAddressFrame.LocalityId;
          AIface.Params.ParamByName('STREET_PREFIX').Value:=FAddressFrame.StreetPrefix;
          AIface.Params.ParamByName('STREET_NAME').Value:=FAddressFrame.StreetName;
          AIface.Params.ParamByName('STREET_ID').Value:=FAddressFrame.StreetId;

          Param:=AIface.Params.ParamByName('STREET_PREFIX;STREET_NAME;LOCALITY_PREFIX;LOCALITY_NAME');
          Param.Value:=FormatEx(TBisParamEditDataSelect(AIface.Params.ParamByName('STREET_ID')).DataAliasFormat,
                                [FAddressFrame.StreetPrefix,FAddressFrame.StreetName,FAddressFrame.LocalityPrefix,FAddressFrame.LocalityName]);

          AIface.Params.ParamByName('HOUSE').Value:=ParamByName('HOUSE').Value;
          AIface.Params.ParamByName('FLAT').Value:=ParamByName('FLAT').Value;
          AIface.Params.ParamByName('DESCRIPTION').Value:=FormatEx('%s %s'+#13#10+
                                                                   '%s %s'+#13#10+
                                                                   '%s %s'+#13#10,
                                                                   [LabelOrderNum.Caption,ParamByName('ORDER_NUM').Value,
                                                                    LabelDateAccept.Caption,ParamByName('DATE_ACCEPT').Value,
                                                                    LabelClient.Caption,Trim(EditClient.Text)]);
          AIface.ChangesExists:=true;
          AIface.ShowModal;
        end;
      finally
        AIface.Free;
      end;
    end else
      ShowError(FormatEx('������� %s ��� ��������� � ������ ������.'+#13#10+
                         '��������: %s',
                         [ParamPhone.Value,Description]))      
  end;
end;

function TBisTaxiOrderEditForm.GetOrderNum(VisibleCursor: Boolean): String;
var
  P: TBisProvider;
begin
  Result:='';
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=VisibleCursor;
    P.StopException:=false;
    P.ProviderName:='GET_ORDER_NUM';
    P.Params.AddInvisible('ORDER_NUM',ptInputOutput);
    try
      P.Execute;
      if P.Success then
        Result:=P.Params.Find('ORDER_NUM').AsString;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiOrderEditForm.ButtonArrivalClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelMain.ClientToScreen(Point(ButtonArrival.Left,ButtonArrival.Top+ButtonArrival.Height));
  PopupActionBarArrival.Popup(Pt.X,Pt.Y);
end;

procedure TBisTaxiOrderEditForm.ButtonCostRateClick(Sender: TObject);
begin
  FManualCalculate:=true;
  try
    Calculate(true,true);
  finally
    FManualCalculate:=false;
  end;
end;

procedure TBisTaxiOrderEditForm.ButtonOrderNumClick(Sender: TObject);
begin
  Provider.Params.ParamByName('ORDER_NUM').Value:=GetOrderNum(true);
end;

procedure TBisTaxiOrderEditForm.EditCostGrossChange(Sender: TObject);
begin
  TimerCostGross.Enabled:=false;
  TimerCostGross.Enabled:=true;
end;

procedure TBisTaxiOrderEditForm.EditLoginChange(Sender: TObject);
begin
  ComboBoxPhone.OnChange:=nil;
  try
    TimerLogin.Enabled:=false;
    TimerLogin.Enabled:=true;
  finally
    ComboBoxPhone.OnChange:=ComboBoxPhoneChange;
  end;
end;

procedure TBisTaxiOrderEditForm.ComboBoxPhoneChange(Sender: TObject);
begin
  EditLogin.OnChange:=nil;
  try
    TimerPhone.Enabled:=false;
    TimerPhone.Enabled:=true;
    UpdateButtons;
  finally
    EditLogin.OnChange:=EditLoginChange;
  end;
end;

procedure TBisTaxiOrderEditForm.ComboBoxPhoneExit(Sender: TObject);
begin
  CheckPhoneBlack(false,true);
end;

procedure TBisTaxiOrderEditForm.ComboBoxPhoneSelect(Sender: TObject);
begin
  // Nothing
end;

function TBisTaxiOrderEditForm.CheckParam(Param: TBisParam): Boolean;
begin
  Result:=inherited CheckParam(Param);
end;

procedure TBisTaxiOrderEditForm.ShowParam(Param: TBisParam);
begin
  if AnsiSameText(Param.ParamName,'TYPE_ACCEPT') or
     AnsiSameText(Param.ParamName,'WHO_ACCEPT') or
     AnsiSameText(Param.ParamName,'FIRM_SMALL_NAME') or
     AnsiSameText(Param.ParamName,'DATE_ACCEPT') or
     AnsiSameText(Param.ParamName,'TYPE_PROCESS') or
     AnsiSameText(Param.ParamName,'ACTION_NAME') or
     AnsiSameText(Param.ParamName,'BEFORE_PERIOD') or
     AnsiSameText(Param.ParamName,'WHO_PROCESS') or
     AnsiSameText(Param.ParamName,'WHO_PROCESS') then begin
    PageControl.ActivePageIndex:=1;
    if AnsiSameText(Param.ParamName,'ACTION_NAME') then begin
      if not Param.Enabled then begin
        Provider.Params.ParamByName('TYPE_PROCESS').Value:=1;
      end;
    end;
  end else begin
    PageControl.ActivePageIndex:=0;
    if AnsiSameText(Param.ParamName,'LOCALITY_NAME') or
       AnsiSameText(Param.ParamName,'STREET_NAME') or
       AnsiSameText(Param.ParamName,'HOUSE') then begin
      TabSetAddressHistory.TabIndex:=0;
    end;
  end;
  inherited ShowParam(Param);
end;

function TBisTaxiOrderEditForm.CanCheckPhoneBlack: Boolean;
var
  ParamPhone: TBisParam;
begin
  ParamPhone:=Provider.Params.ParamByName('PHONE');
  Result:=not ParamPhone.Empty;
end;

function TBisTaxiOrderEditForm.ExistsPhoneBlack(Phone: String; var Description: String): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if CanCheckPhoneBlack then begin
    Phone:=PreparePhone(Phone);
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.ProviderName:='S_BLACKS';
      P.FieldNames.AddInvisible('DESCRIPTION');
      P.FilterGroups.Add.Filters.Add('PHONE',fcEqual,Phone).CheckCase:=true;
      try
        P.Open;
        Result:=P.Active and not P.IsEmpty;
        if Result then
          Description:=P.FieldByName('DESCRIPTION').AsString;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisTaxiOrderEditForm.CheckPhoneBlack(SuccessMessage: Boolean; QuestionMessage: Boolean): Boolean;
var
  ParamPhone: TBisParam;
  Description: String;
begin
  Result:=true;
  if CanCheckPhoneBlack then begin
    ParamPhone:=Provider.Params.ParamByName('PHONE');
    Result:=not ExistsPhoneBlack(ParamPhone.AsString,Description);
    if not Result then
      if QuestionMessage then begin
        if ShowWarningQuestion(FormatEx('������� %s ��������� � ������ ������.'+#13#10+
                                        '��������: %s'+#13#10+#13#10+
                                        '���������� ����?',
                                        [ParamPhone.Value,Description]),mbNo)=mrNo then begin
          if Assigned(ParamPhone.Control) and ParamPhone.Control.Visible and ParamPhone.Control.Enabled then begin
            ParamPhone.Control.SetFocus;
          end;
        end;
      end else
        ShowWarning(FormatEx('������� %s ��������� � ������ ������.'+#13#10+
                             '��������: %s',
                             [ParamPhone.Value,Description]))
    else
      if SuccessMessage then
        ShowInfo(FormatEx('������� %s �� ��������� � ������ ������.',[ParamPhone.Value]));
  end;
end;

procedure TBisTaxiOrderEditForm.ComboBoxDiscountEnter(Sender: TObject);
var
  ClientParam: TBisParamEditdataSelect;
  DiscountParam: TBisParamComboBoxDataSelect;
  D: TDateTime;
begin
  if (Mode in [emUpdate]) and not FFirstRefreshDiscount then begin
    ClientParam:=TBisParamEditdataSelect(Provider.Params.ParamByName('CLIENT_ID'));
    DiscountParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DISCOUNT_ID'));
    DiscountParam.FilterGroups.Clear;
    if ClientParam.Empty then begin
      DiscountParam.FirstSelected:=false;
      DiscountParam.Clear;
    end else begin
      D:=DateOf(Core.ServerDate);
      DiscountParam.FirstSelected:=true;
      with DiscountParam.FilterGroups.Add do begin
        Filters.Add('CLIENT_ID',fcEqual,ClientParam.Value).CheckCase:=true;
        Filters.Add('DATE_BEGIN',fcEqualLess,D);
      end;
      with DiscountParam.FilterGroups.Add do begin
        Filters.Add('DATE_END',fcIsNull,Null);
        Filters.Add('DATE_END',fcEqualGreater,D).&Operator:=foOr;
      end;
      DiscountParam.Orders.Clear;
      DiscountParam.Orders.Add('PRIORITY');
      DiscountParam.Refresh;
    end;
    FFirstRefreshDiscount:=true;
  end;
end;

procedure TBisTaxiOrderEditForm.ComboBoxDriverEnter(Sender: TObject);
begin
  if (Mode in [emInsert,emUpdate]) and not FFirstRefreshDriver and not FFirstRefreshPark then begin
    ChangeParam(Provider.Params.ParamByName('PARK_NAME;PARK_DESCRIPTION'));
    FFirstRefreshDriver:=true;
  end;
end;

procedure TBisTaxiOrderEditForm.ComboBoxParkEnter(Sender: TObject);
begin
  if (Mode in [emUpdate]) and not FFirstRefreshPark then begin
    AddressFrameChangeZone(nil);
    FFirstRefreshPark:=true;
  end;
end;

procedure TBisTaxiOrderEditForm.UpdateButtons;
var
  Flag: Boolean;
begin
  Flag:=Mode in [emView,emInsert,emUpdate];
  BitBtnClientPhone.Enabled:=Flag and CanClientPhone;
  BitBtnBlack.Enabled:=Flag and CanBlackInsert;
  BitBtnCheckPhone.Enabled:=Flag and CanCheckPhoneBlack;
  BitBtnDriverPhone.Enabled:=Flag and CanDriverPhone;
end;

function TBisTaxiOrderEditForm.PreparePhone(S: String): String;
const
  PhoneChars=['+','0','1','2','3','4','5','6','7','8','9'];
begin
  Result:=GetOnlyChars(S,PhoneChars);
end;

function TBisTaxiOrderEditForm.GetCost(var ABaseCost, ABaseDistance: Extended; var ABasePeriod: Integer): Extended;

  function GetTypeCarRatio: Extended;
  var
    CarTypeParam: TBisParamComboBoxDataSelect;
    V: Variant;
  begin
    Result:=1.0;
    CarTypeParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('CAR_TYPE_ID'));
    if not CarTypeParam.Empty then begin
      V:=CarTypeParam.Values.GetValue('RATIO');
      if not VarIsNull(V) then
        Result:=VarToExtendedDef(V,1.0);
    end;
  end;

  function GetDeliveryCost(var DeliveryDistance,DeliveryPeriod: Integer): Extended;
  var
    ParkParam: TBisParamComboBoxDataSelect;
    V: Variant;
  begin
    Result:=0.0;
    DeliveryDistance:=0;
    DeliveryPeriod:=0;
    ParkParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('PARK_ID'));
    if not ParkParam.Empty then begin
      V:=ParkParam.Values.GetValue('COST');
      if not VarIsNull(V) then
        Result:=VarToExtendedDef(V,0.0);
      V:=ParkParam.Values.GetValue('DISTANCE');
      if not VarIsNull(V) then
        DeliveryDistance:=VarToIntDef(V,0);
      V:=ParkParam.Values.GetValue('PERIOD');
      if not VarIsNull(V) then
        DeliveryPeriod:=VarToIntDef(V,0);
    end;
  end;

  function GetBaseCost(var BaseDistance: Extended; var BasePeriod: Integer): Extended;
  var
    i: Integer;
    Item: TBisTaxiRoute;
  begin
    Result:=0.0;
    BaseDistance:=0.0;
    BasePeriod:=0;
    for i:=0 to FRoutes.Count-1 do begin
      Item:=FRoutes.Items[i];
      if Assigned(Item.Frame) then begin
        Result:=Result+VarToExtendedDef(Item.Frame.Cost,0.0);
        BaseDistance:=BaseDistance+VarToExtendedDef(Item.Frame.Distance,0.0);
        BasePeriod:=BasePeriod+VarToIntDef(Item.Frame.Period,0);
      end;
    end;
  end;

  function GetRemoteCost: Extended;

    function ExistsOtherZones: Boolean;
    var
      i: Integer;
      Item: TBisTaxiRoute;
    begin
      Result:=false;
      for i:=0 to FRoutes.Count-2 do begin
        Item:=FRoutes.Items[i];
        if Assigned(Item.Frame) then begin
          if not VarSameValue(Item.Frame.ZoneId,FAddressFrame.ZoneId) then begin
            Result:=true;
            break;
          end;
        end;
      end;
    end;
    
  var
    Route: TBisTaxiRoute;
    CostOut: Variant;
    CostIn: Variant;
    Flag: Boolean;
  begin
    CostOut:=FAddressFrame.CostOut;
    if FRoutes.Count>0 then begin
      Route:=FRoutes.Items[FRoutes.Count-1];
      if Assigned(Route.Frame) then begin
        if FRoutes.Count=1 then
          Flag:=not VarSameValue(Route.Frame.ZoneId,FAddressFrame.ZoneId)
        else Flag:=ExistsOtherZones;
        if Flag then
          CostIn:=Route.Frame.CostIn;
      end;
    end;
    Result:=VarToExtendedDef(CostOut,0.0)+VarToExtendedDef(CostIn,0.0);
  end;

  function GetServiceCost: Extended;
  var
    i: Integer;
    Obj: TBisTaxiService;
  begin
    Result:=0.0;
    for i:=0 to CheckListBoxServices.Count-1 do begin
      if CheckListBoxServices.Checked[i] then begin
        Obj:=TBisTaxiService(CheckListBoxServices.Items.Objects[i]);
        Result:=Result+Obj.Cost;
      end;
    end;
  end;

  function GetProcCost(ProcName: String; BaseCost: Extended; BaseDistance: Extended; BasePeriod: Integer): Extended;
  var
    P: TBisProvider;
  begin
    Result:=0.0;
    if Trim(ProcName)<>'' then begin
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.StopException:=false;
        P.ProviderName:=ProcName;
        with P.Params do begin
          AddInvisible('ORDER_ID');
          AddInvisible('STREET_ID');
          AddInvisible('ZONE_ID');
          AddInvisible('CAR_ID');
          AddInvisible('RATE_ID');
          AddInvisible('CAR_TYPE_ID');
          AddInvisible('CLIENT_ID');
          AddInvisible('PARK_ID');
          AddInvisible('DRIVER_ID');
          AddInvisible('SOURCE_ID');
          AddInvisible('DISCOUNT_ID');
          AddInvisible('HOUSE');
          AddInvisible('FLAT');
          AddInvisible('PORCH');
          AddInvisible('PHONE');
          AddInvisible('CUSTOMER');
          AddInvisible('ORDER_NUM');
          AddInvisible('BASE_COST').Value:=BaseCost;
          AddInvisible('BASE_DISTANCE').Value:=BaseDistance;
          AddInvisible('BASE_PERIOD').Value:=BasePeriod;
          AddInvisible('COST',ptOutput);
        end;
        P.Params.CopyFrom(Provider.Params,false,false,[ptInput,ptOutput],false);
        try
          P.Execute;
          if P.Success then
            Result:=P.Params.ParamByName('COST').AsExtended;
        except
          on E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;
  end;

  function GetZoneCost(ProcName: String; BaseCost: Extended): Extended;
  begin
    Result:=BaseCost;
    if Trim(ProcName)<>'' then begin
      Result:=GetProcCost(ProcName,BaseCost,0.0,0);
    end;
  end;

  function GetZone1kmCost(ProcName: String; RateSum: Extended; BaseDistance: Extended):Extended;
  begin
    Result:=RateSum*BaseDistance;
    if Trim(ProcName)<>'' then begin
      Result:=GetProcCost(ProcName,RateSum,BaseDistance,0);
    end;
  end;

  function GetZone1minCost(ProcName: String; RateSum: Extended; BasePeriod: Integer):Extended;
  begin
    Result:=RateSum*BasePeriod;
    if Trim(ProcName)<>'' then begin
      Result:=GetProcCost(ProcName,RateSum,0.0,BasePeriod);
    end;
  end;

  function GetMap1kmCost(ProcName: String; RateSum: Extended; BaseDistance: Extended):Extended;
  begin
    Result:=RateSum*BaseDistance;
    if Trim(ProcName)<>'' then begin
      Result:=GetProcCost(ProcName,RateSum,BaseDistance,0);
    end;
  end;

var
  RateParam: TBisParamComboBoxDataSelect;
  V: TBisValue;
  TypeRate: TBisTaxiTypeRate;
  ProcName: String;
  RateSum: Extended;
  TypeCarRatio: Extended;
  DeliveryCost: Extended;
  DeliveryDistance: Integer;
  DeliveryPeriod: Integer;
  ServiceCost: Extended;
  RemoteCost: Extended;
begin
  Result:=0.0;
  RateParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('RATE_ID'));
  if not RateParam.Empty then begin

    ProcName:=VarToStrDef(RateParam.Values.GetValue('PROC_NAME'),'');
    RateSum:=VarToExtendedDef(RateParam.Values.GetValue('RATE_SUM'),0.0);

    V:=RateParam.Values.Find('TYPE_RATE');
    if Assigned(V) then begin

      TypeCarRatio:=GetTypeCarRatio;
      DeliveryCost:=GetDeliveryCost(DeliveryDistance,DeliveryPeriod);
      ABaseCost:=GetBaseCost(ABaseDistance,ABasePeriod);
      RemoteCost:=GetRemoteCost;
      ServiceCost:=GetServiceCost;

      TypeRate:=TBisTaxiTypeRate(VarToIntDef(V.Value,0));
      case TypeRate of
        trNone: Result:=0.0;
        trProc: Result:=GetProcCost(ProcName,ABaseCost,ABaseDistance,ABasePeriod);
        trZone: Result:=GetZoneCost(ProcName,ABaseCost);
        trZone1km: Result:=GetZone1kmCost(ProcName,RateSum,ABaseDistance);
        trZone1min: Result:=GetZone1minCost(ProcName,RateSum,ABasePeriod);
        trMap1km: Result:=GetMap1kmCost(ProcName,RateSum,ABaseDistance);
      end;
      if Result<0.0 then
        Result:=0.0;
      if Result>0.0 then
        Result:=(Result+DeliveryCost+RemoteCost)*TypeCarRatio+ServiceCost;
    end;
  end;
end;

function TBisTaxiOrderEditForm.GetDiscount(ABaseCost: Extended; ABaseDistance: Extended; ABasePeriod: Integer; ResultCost: Extended): Extended;
type
  TTypeCalc=(tcNone,tcProc,tcPercent,tcFixed);
var
  DiscountParam: TBisParamComboBoxDataSelect;
  V: TBisValue;
  TypeCalc: TTypeCalc;
  Percent: Extended;
  DiscountSum: Extended;
  ProcName: String;
  P: TBisProvider;
begin
  Result:=0.0;
  DiscountParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('DISCOUNT_ID'));
  if not DiscountParam.Empty then begin
    V:=DiscountParam.Values.Find('TYPE_CALC');
    if Assigned(V) then begin
      TypeCalc:=TTypeCalc(VarToIntDef(V.Value,0));
      Percent:=VarToExtendedDef(DiscountParam.Values.GetValue('PERCENT'),0.0);
      DiscountSum:=VarToExtendedDef(DiscountParam.Values.GetValue('DISCOUNT_SUM'),0.0);
      ProcName:=VarToStrDef(DiscountParam.Values.GetValue('PROC_NAME'),'');
      case TypeCalc of
        tcNone: Result:=0.0;
        tcProc: begin
          if Trim(ProcName)<>'' then begin
            P:=TBisProvider.Create(nil);
            try
              P.WithWaitCursor:=false;
              P.StopException:=false;
              P.ProviderName:=ProcName;
              with P.Params do begin
                AddInvisible('ORDER_ID');
                AddInvisible('STREET_ID');
                AddInvisible('ZONE_ID');
                AddInvisible('CAR_ID');
                AddInvisible('RATE_ID');
                AddInvisible('CAR_TYPE_ID');
                AddInvisible('CLIENT_ID');
                AddInvisible('PARK_ID');
                AddInvisible('DRIVER_ID');
                AddInvisible('SOURCE_ID');
                AddInvisible('DISCOUNT_ID');
                AddInvisible('HOUSE');
                AddInvisible('FLAT');
                AddInvisible('PORCH');
                AddInvisible('PHONE');
                AddInvisible('CUSTOMER');
                AddInvisible('ORDER_NUM');
                AddInvisible('BASE_COST').Value:=ABaseCost;
                AddInvisible('BASE_DISTANCE').Value:=ABaseDistance;
                AddInvisible('BASE_PERIOD').Value:=ABasePeriod;
                AddInvisible('DISCOUNT',ptOutput);
              end;
              P.Params.CopyFrom(Provider.Params,false,false,[ptInput,ptOutput],false);
              try
                P.Execute;
                if P.Success then
                  Result:=P.Params.ParamByName('DISCOUNT').AsExtended;
              except
                on E: Exception do
                  LoggerWrite(E.Message,ltError);
              end;
            finally
              P.Free;
            end;
          end;
        end;
        tcPercent: Result:=(ResultCost*Percent)/100;
        tcFixed: Result:=DiscountSum;
      end;
      if Result<0.0 then
        Result:=0.0;
    end;
  end;
end;

function TBisTaxiOrderEditForm.CanCalculate: Boolean;
begin
  Result:=(Mode in [emInsert,emDuplicate]) or FManualCalculate;
end;

procedure TBisTaxiOrderEditForm.Calculate(Gross,Rate: Boolean);
var
  CostRate,CostGross: Extended;
  CostGrossParam: TBisParam;
  CostRateParam: TBisParam;
  BaseCost,BaseDistance: Extended;
  BasePeriod: Integer;
begin
  if CanCalculate then begin
    CostGrossParam:=Provider.Params.ParamByName('COST_GROSS');
    CostRateParam:=Provider.Params.ParamByName('COST_RATE');

    if Gross then begin
      CostGross:=GetCost(BaseCost,BaseDistance,BasePeriod);
      if FBeforeShowed then
        CostGrossParam.Value:=CostGross
      else
        CostGrossParam.SetNewValue(CostGross)
    end else begin
      CostGross:=CostGrossParam.AsExtended;
    end;

    if Rate then begin
      CostRate:=CostGross-GetDiscount(BaseCost,BaseDistance,BasePeriod,CostGross);
      if CostRate<0.0 then
        CostRate:=0.0;
      if FBeforeShowed then
        CostRateParam.Value:=CostRate
      else
        CostRateParam.SetNewValue(CostRate)
    end;

  end;
end;

procedure TBisTaxiOrderEditForm.RefreshInsertOrderServices;
var
  Obj: TBisTaxiService;
  OrderParam: TBisParam;
  Params: TBisParams;
  i: Integer;
begin
  OrderParam:=Provider.Params.Find('ORDER_ID');
  if Assigned(OrderParam) and not OrderParam.Empty then begin
    for i:=0 to CheckListBoxServices.Items.Count-1 do begin
      if CheckListBoxServices.Checked[i] then begin
        Obj:=TBisTaxiService(CheckListBoxServices.Items.Objects[i]);
        Params:=Provider.PackageAfter.Add;
        Params.ProviderName:='I_ORDER_SERVICE';
        with Params do begin
          AddInvisible('SERVICE_ID').Value:=Obj.Id;
          AddInvisible('ORDER_ID').Value:=OrderParam.Value;
          AddInvisible('COST').Value:=Obj.Cost;
          AddInvisible('AMOUNT').Value:=1;
        end;
      end;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.RefreshInsertRoutes;
var
  OrderParam: TBisParam;
  Params: TBisParams;
  Route: TBisTaxiRoute;
  i: Integer;
begin
  OrderParam:=Provider.Params.Find('ORDER_ID');
  if Assigned(OrderParam) and not OrderParam.Empty then begin
    for i:=0 to FRoutes.Count-1 do begin
      Route:=FRoutes.Items[i];
      Params:=Provider.PackageAfter.Add;
      Params.ProviderName:='I_ROUTE';
      with Params do begin
        AddInvisible('ROUTE_ID').Value:=GetUniqueID;
        AddInvisible('ORDER_ID').Value:=OrderParam.Value;
        AddInvisible('ZONE_ID').Value:=Route.Frame.ZoneId;
        AddInvisible('STREET_ID').Value:=Route.Frame.StreetId;
        AddInvisible('HOUSE').Value:=Route.Frame.House;
        AddInvisible('FLAT').Value:=Route.Frame.Flat;
        AddInvisible('PORCH').Value:=Route.Frame.Porch;
        AddInvisible('DISTANCE').Value:=Route.Frame.Distance;
        AddInvisible('COST').Value:=Route.Frame.Cost;
        AddInvisible('PERIOD').Value:=Route.Frame.Period;
        AddInvisible('AMOUNT').Value:=Route.Frame.Amount;
        AddInvisible('PRIORITY').Value:=i;
      end;
    end;
  end;
end;

function TBisTaxiOrderEditForm.CreateOrderHistory: Boolean;
var
  OrderParam: TBisParam;
  P: TBisProvider;
  NewOrderId: Variant;
begin
  Result:=false;
  OrderParam:=Provider.Params.Find('ORDER_ID');
  if Assigned(OrderParam) and not OrderParam.Empty then begin
    NewOrderId:=GetUniqueID;
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.ProviderName:='CREATE_ORDER_HISTORY';
      with P.Params do begin
        AddInvisible('OLD_ORDER_ID').Value:=OrderParam.Value;
        AddInvisible('NEW_ORDER_ID').Value:=NewOrderId;
        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
        AddInvisible('ACTION_ID').Value:=Provider.Params.ParamByName('ACTION_ID').Value;
        AddInvisible('RESULT_ID').Value:=Provider.Params.ParamByName('RESULT_ID').Value;
        AddInvisible('TYPE_PROCESS').Value:=Provider.Params.ParamByName('TYPE_PROCESS').Value;
        AddInvisible('DATE_BEGIN').Value:=Core.ServerDate;
        AddInvisible('WITH_DEPENDS').Value:=Null;
        AddInvisible('WITH_EVENT').Value:=Null;
      end;
      try
        P.Execute;
        if P.Success then begin
          OrderParam.SetNewValue(NewOrderId);
          OrderParam.ValueToStored;
          Result:=true;
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.Execute;
var
  OldCursor: TCursor;
  OrderParam: TBisParam;
  OldOrderId: Variant;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  FNeedClientChange:=false;
  try
    Provider.PackageAfter.Clear;

    with Provider.Params do begin
      Find('LOCALITY_ID').Value:=FAddressFrame.LocalityId;
      Find('LOCALITY_PREFIX').Value:=FAddressFrame.LocalityPrefix;
      Find('LOCALITY_NAME').Value:=FAddressFrame.LocalityName;
      Find('STREET_ID').Value:=FAddressFrame.StreetId;
      Find('STREET_PREFIX').Value:=FAddressFrame.StreetPrefix;
      Find('STREET_NAME').Value:=FAddressFrame.StreetName;
      Find('ZONE_ID').Value:=FAddressFrame.ZoneId;
      Find('HOUSE').Value:=FAddressFrame.House;
      Find('FLAT').Value:=FAddressFrame.Flat;
      Find('PORCH').Value:=FAddressFrame.Porch;
      Find('TYPE_PROCESS').Value:=Integer(RadioButtonHand.Checked);

      Find('ROUTE_STREET_ID').Value:=FRoutes.Items[FRoutes.Count-1].Frame.StreetId;
      Find('ROUTE_STREET_PREFIX').Value:=FRoutes.Items[FRoutes.Count-1].Frame.StreetPrefix;
      Find('ROUTE_LOCALITY_ID').Value:=FRoutes.Items[FRoutes.Count-1].Frame.LocalityId;
      Find('ROUTE_LOCALITY_NAME').Value:=FRoutes.Items[FRoutes.Count-1].Frame.LocalityName;
      Find('ROUTE_LOCALITY_PREFIX').Value:=FRoutes.Items[FRoutes.Count-1].Frame.LocalityPrefix;
      Find('ROUTE_STREET_NAME').Value:=FRoutes.Items[FRoutes.Count-1].Frame.StreetName;
      Find('ROUTE_HOUSE').Value:=FRoutes.Items[FRoutes.Count-1].Frame.House;
      Find('ROUTE_FLAT').Value:=FRoutes.Items[FRoutes.Count-1].Frame.Flat;
      Find('ROUTE_PORCH').Value:=FRoutes.Items[FRoutes.Count-1].Frame.Porch;
      Find('ROUTE_ZONE_ID').Value:=FRoutes.Items[FRoutes.Count-1].Frame.ZoneId;
      Find('ROUTE_ZONE_NAME').Value:=FRoutes.Items[FRoutes.Count-1].Frame.ZoneName;
    end;

    case Mode of
      emInsert: begin
        RefreshInsertOrderServices;
        RefreshInsertRoutes;
        Provider.ParamByName('CALL_ID').Value:=FCallId;
        Provider.Execute;
        SetDefaultResultId;
        Provider.InsertIntoParent;
        FLocked:=false;
      end;
      emUpdate: begin
        OrderParam:=Provider.Params.ParamByName('ORDER_ID');
        OldOrderId:=OrderParam.OldValue;
        if CreateOrderHistory then begin
          RefreshInsertOrderServices;
          RefreshInsertRoutes;
          Provider.Execute;
          SetDefaultResultId;
          OrderParam.OldValue:=OldOrderId;
          Provider.UpdateIntoParent;
        end;
        FLocked:=false;
      end;
      emDelete: begin
        Provider.Execute;
        Provider.DeleteFromParent;
        FLocked:=false;
      end;
    end;

  finally
    FNeedClientChange:=true;
    Screen.Cursor:=OldCursor;
  end;
end;

function TBisTaxiOrderEditForm.GetDefaultActionId: Variant;
var
  P: TBisProvider;
begin
  Result:=Null;
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=false;
    P.StopException:=false;
    P.ProviderName:='GET_DEFAULT_ACTION_ID';
    with P.Params do begin
      AddInvisible('ORDER_ID');
      AddInvisible('STREET_ID');
      AddInvisible('ZONE_ID');
      AddInvisible('CAR_ID');
      AddInvisible('RATE_ID');
      AddInvisible('CAR_TYPE_ID');
      AddInvisible('CLIENT_ID');
      AddInvisible('PARK_ID');
      AddInvisible('DRIVER_ID');
      AddInvisible('SOURCE_ID');
      AddInvisible('DISCOUNT_ID');
      AddInvisible('HOUSE');
      AddInvisible('FLAT');
      AddInvisible('PORCH');
      AddInvisible('PHONE');
      AddInvisible('CUSTOMER');
      AddInvisible('ORDER_NUM');
      AddInvisible('ACTION_ID',ptOutput);
    end;
    P.Params.CopyFrom(Provider.Params,false,false,[ptInput],false);
    try
      P.Execute;
      if P.Success then
        Result:=P.Params.ParamByName('ACTION_ID').Value;
    except
      on E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiOrderEditForm.SetDefaultActionId;
var
  ActionParam: TBisParam;
  ResultParam: TBisParamComboBoxDataSelect;
  ActionId: Variant;
begin
  ActionParam:=Provider.Params.ParamByName('ACTION_ID');
  ResultParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('RESULT_ID'));
  if ActionParam.Empty then begin
    ActionId:=GetDefaultActionId;
    if FBeforeShowed then
      ActionParam.Value:=ActionId
    else
      ActionParam.SetNewValue(ActionId);
    if ActionParam.Empty then
      ResultParam.Clear
    else begin
      ResultParam.FilterGroups.Clear;
      ResultParam.FilterGroups.Add.Filters.Add('ACTION_ID',fcEqual,ActionParam.Value).CheckCase:=true;
      ResultParam.Refresh;
    end;
  end;
end;

function TBisTaxiOrderEditForm.GetDefaultResultId: Variant;
var
  P: TBisProvider;
begin
  Result:=Null;
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=false;
    P.StopException:=false;
    P.ProviderName:='GET_DEFAULT_RESULT_ID';
    with P.Params do begin
      AddInvisible('ORDER_ID');
      AddInvisible('STREET_ID');
      AddInvisible('ZONE_ID');
      AddInvisible('CAR_ID');
      AddInvisible('RATE_ID');
      AddInvisible('CAR_TYPE_ID');
      AddInvisible('CLIENT_ID');
      AddInvisible('PARK_ID');
      AddInvisible('DRIVER_ID');
      AddInvisible('SOURCE_ID');
      AddInvisible('DISCOUNT_ID');
      AddInvisible('ACTION_ID');
      AddInvisible('HOUSE');
      AddInvisible('FLAT');
      AddInvisible('PORCH');
      AddInvisible('PHONE');
      AddInvisible('CUSTOMER');
      AddInvisible('ORDER_NUM');
      AddInvisible('RESULT_ID',ptOutput);
    end;
    P.Params.CopyFrom(Provider.Params,false,false,[ptInput],false);
    try
      P.Execute;
      if P.Success then
        Result:=P.Params.ParamByName('RESULT_ID').Value;
    except
      on E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiOrderEditForm.SetDefaultResultId;
var
  ResultParam: TBisParam;
  ActionParam: TBisParam;
  TypeProcess: Integer;
  ResultId: Variant;
begin
  ActionParam:=Provider.Params.ParamByName('ACTION_ID');
  ResultParam:=Provider.Params.ParamByName('RESULT_ID');
  TypeProcess:=Provider.Params.ParamByName('TYPE_PROCESS').AsInteger;
  if TypeProcess=1 then begin
    if not ActionParam.Empty and ResultParam.Empty then begin
      ResultId:=GetDefaultResultId;
      if FBeforeShowed then
        ResultParam.Value:=ResultId
      else
        ResultParam.SetNewValue(ResultId);
    end;
    ProcessResult;
  end;
end;

procedure TBisTaxiOrderEditForm.GetParams(OrderId: Variant);
var
  P: TBisProvider;
begin
  if Assigned(Provider.ParentDataSet) and not VarIsNull(OrderId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.StopException:=false;
      P.ProviderName:='S_ORDERS';
      P.FieldNames.CopyFrom(Provider.ParentDataSet.FieldNames);
      P.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,OrderId).CheckCase:=true;
      try
        P.Open;
        if P.Active and not P.Empty then begin
          Provider.Params.RefreshByDataSet(P,true,false);
          Provider.Params.ValueToStored;
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.ProcessResult;
var
  P: TBisProvider;
  ResultParam: TBisParam;
begin
  ResultParam:=Provider.Params.ParamByName('RESULT_ID');
  if not ResultParam.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.StopException:=false;
      P.ProviderName:='PROCESS_RESULT';
      with P.Params do begin
        AddInvisible('OLD_ORDER_ID').Value:=Provider.Params.ParamByName('ORDER_ID').Value;
        AddInvisible('NEW_ORDER_ID').Value:=GetUniqueID;
        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
        AddInvisible('RESULT_ID').Value:=ResultParam.Value;
        AddInvisible('TYPE_PROCESS').Value:=Provider.Params.ParamByName('TYPE_PROCESS').Value;
        AddInvisible('WITH_EVENT').Value:=Null;
        AddInvisible('ORDER_ID',ptOutput);
      end;
      try
        P.Execute;
        if P.Success then begin
          GetParams(P.Params.ParamByName('ORDER_ID').Value);
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.PageControlMessagesChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlMessages.ActivePage=TabSheetInMessages then begin
    Param:=Provider.Params.ParamByName('ORDER_ID');
    if not Param.Empty then begin
      with FInMessagesFrame do begin
        ResizeToolbars;
        OrderId:=Param.Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlMessages.ActivePage=TabSheetOutMessages then begin
    Param:=Provider.Params.ParamByName('ORDER_ID');
    if not Param.Empty then begin
      with FOutMessagesFrame do begin
        ResizeToolbars;
        OrderId:=Param.Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiOrderEditForm.PageControlCallsChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlCalls.ActivePage=TabSheetInCalls then begin
    Param:=Provider.Params.ParamByName('ORDER_ID');
    if not Param.Empty then begin
      with FInCallsFrame do begin
        ResizeToolbars;
        OrderId:=Param.Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlCalls.ActivePage=TabSheetOutCalls then begin
    Param:=Provider.Params.ParamByName('ORDER_ID');
    if not Param.Empty then begin
      with FOutCallsFrame do begin
        ResizeToolbars;
        OrderId:=Param.Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiOrderEditForm.PageControlChange(Sender: TObject);
var
  Param: TBisParam;
  Points: TBisTaxiMapFramePoints;
begin

  if PageControl.ActivePage=TabSheetMain then begin
    SetDistanceByMap(true);
  end;

  if PageControl.ActivePage=TabSheetHistory then begin
    Param:=Provider.Params.ParamByName('ORDER_ID');
    if not Param.Empty then begin
      FHistoryFrame.ResizeToolbars;
      with FHistoryFrame.Provider do begin
        FilterGroups.Clear;
        with FilterGroups.Add do begin
          Filters.Add('PARENT_ID',fcEqual,Param.Value).CheckCase:=true;
        {  Filters.Add('DATE_HISTORY',fcIsNotNull,Null);
          Filters.Add('WHO_HISTORY_ID',fcIsNotNull,Null);  }
        end;
        with FilterGroups.Add(foOr) do begin
          Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
        end;
      end;
      FHistoryFrame.OpenRecords;
    end;
  end;

  if PageControl.ActivePage=TabSheetReceipts then begin
    Param:=Provider.Params.ParamByName('ORDER_ID');
    if not Param.Empty then begin
      with FReceiptsFrame do begin
        ResizeToolbars;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetCharges then begin
    Param:=Provider.Params.ParamByName('ORDER_ID');
    if not Param.Empty then begin
      with FChargesFrame do begin
        ResizeToolbars;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetMessages then begin
    PageControlMessagesChange(nil);
  end;

  if PageControl.ActivePage=TabSheetCalls then begin
    PageControlCallsChange(nil);
  end;

  if PageControl.ActivePage=TabSheetMap then begin
    Points:=TBisTaxiMapFramePoints.Create;
    try
      GetRoutePoints(Points);
      FMapFrame.VisibleRoute(Points);
    finally
      Points.Free;
    end;
  end;

end;

procedure TBisTaxiOrderEditForm.GetRoutePoints(Points: TBisTaxiMapFramePoints);
var
  i: Integer;
  P: TBisProvider;
  Lat, Lon: Extended;
  Route: TBisTaxiRoute;
  CanOpen: Boolean;
begin
  if Assigned(Points) then begin
    P:=TBisProvider.Create(nil);
    try

      P.ProviderName:='S_MAP_OBJECTS';
      with P.FieldNames do begin
        AddInvisible('STREET_ID');
        AddInvisible('HOUSE');
        AddInvisible('LAT');
        AddInvisible('LON');
      end;

      CanOpen:=false;
      
      with P.FilterGroups.Add do begin
        if not VarIsNull(FAddressFrame.StreetId) and not VarIsNull(FAddressFrame.House) then begin
          Filters.Add('STREET_ID',fcEqual,FAddressFrame.StreetId).CheckCase:=true;
//          Filters.Add('HOUSE',fcEqual,FAddressFrame.House).CheckCase:=true;
          Filters.Add('HOUSE',fcEqual,FAddressFrame.House);
          CanOpen:=true;
        end;
      end;

      for i:=0 to FRoutes.Count-1 do begin
        Route:=FRoutes.Items[i];
        if not VarIsNull(Route.Frame.StreetId) and not VarIsNull(Route.Frame.House) then begin
          with P.FilterGroups.Add(foOr) do begin
            Filters.Add('STREET_ID',fcEqual,Route.Frame.StreetId).CheckCase:=true;
//            Filters.Add('HOUSE',fcEqual,Route.Frame.House).CheckCase:=true;
            Filters.Add('HOUSE',fcEqual,Route.Frame.House);
          end;
          CanOpen:=true;
        end;
      end;

      if CanOpen then
        P.Open;

      if P.Active then begin
        P.First;
        if P.Locate('STREET_ID;HOUSE',VarArrayOf([FAddressFrame.StreetId,FAddressFrame.House]),
                    [loCaseInsensitive,loPartialKey]) then begin
          Lat:=P.FieldByName('LAT').AsFloat;
          Lon:=P.FieldByName('LON').AsFloat;
          Points.AddPoint(Lat,Lon,true);
        end else begin
          Points.AddPoint(0.0,0.0,false);
        end;
      end else
        Points.AddPoint(0.0,0.0,false);

      for i:=0 to FRoutes.Count-1 do begin
        Route:=FRoutes.Items[i];
        if P.Active then begin
          P.First;
          if P.Locate('STREET_ID;HOUSE',VarArrayOf([Route.Frame.StreetId,Route.Frame.House]),
                      [loCaseInsensitive,loPartialKey]) then begin
            Lat:=P.FieldByName('LAT').AsFloat;
            Lon:=P.FieldByName('LON').AsFloat;
            Points.AddPoint(Lat,Lon,true);
          end else begin
            Points.AddPoint(0.0,0.0,false);
          end;
        end else
          Points.AddPoint(0.0,0.0,false);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.SetDistanceByMap(WithCalc: Boolean);

  function GetRouteDistance(Lat1,Lon1,Lat2,Lon2: Extended): Extended;
  var
    P: TBisProvider;
  begin
    Result:=0.0;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.StopException:=true;
      P.ProviderName:='GET_ROUTE_DISTANCE';
      with P.Params do begin
        AddInvisible('LAT1').Value:=Lat1;
        AddInvisible('LON1').Value:=Lon1;
        AddInvisible('LAT2').Value:=Lat2;
        AddInvisible('LON2').Value:=Lon2;
        AddInvisible('DISTANCE',ptOutput);
      end;
      P.Execute;
      if P.Success then
        Result:=P.Params.ParamByName('DISTANCE').AsExtended;
    finally
      P.Free;
    end;
  end;

var
  RateParam: TBisParamComboBoxDataSelect;
  TypeRate: TBisTaxiTypeRate;
  Points: TBisTaxiMapFramePoints;
  OldCursor: TCursor;
  Distance: Extended;
  i: Integer;
  Route: TBisTaxiRoute;
  Point: TBisTaxiMapFramePoint;
  Found1: Boolean;
  Lat1, Lon1: Extended;
  Lat2, Lon2: Extended;
  T: TDateTime;
begin
  RateParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('RATE_ID'));
  if {FBeforeShowed and }not RateParam.Empty then begin
    TypeRate:=TBisTaxiTypeRate(VarToIntDef(RateParam.Values.GetValue('TYPE_RATE'),0));
    if (Mode in [emInsert,emUpdate]) and (TypeRate in [trMap1km]) then begin
      OldCursor:=Screen.Cursor;
      Screen.Cursor:=crHourGlass;
      Points:=TBisTaxiMapFramePoints.Create;
      try
        GetRoutePoints(Points);

        Lat1:=0.0;
        Lon1:=0.0;
        Found1:=false;
        if Points.Count>0 then begin
          Point:=Points.Items[0];
          if Point.Found then begin
            Found1:=true;
            Lat1:=Point.Lat;
            Lon1:=Point.Lon;
          end;
          FAddressFrame.AddressFound:=Point.Found;
          FAddressFrame.ImageAddress.Visible:=true;
        end;

        for i:=0 to FRoutes.Count-1 do begin
          Route:=FRoutes.Items[i];
          Route.Frame.DisableChanges;
          try
            Distance:=0.0;
            if Points.Count>(i+1) then begin
              Point:=Points.Items[i+1];
              if Point.Found then begin
                Lat2:=Point.Lat;
                Lon2:=Point.Lon;
                if Found1 then begin
                  if FMapFrame.MapLoaded then begin
                    T:=Time;
                    try
                      Distance:=FMapFrame.GetRouteDistance(Lat1,Lon1,Lat2,Lon2);
                    finally
                      LoggerWrite(FormatDateTime('nn:ss.zzz',Time-T));
                    end;
                  end else
                    Distance:=GetRouteDistance(Lat1,Lon1,Lat2,Lon2);
                end;
                Found1:=true;
                Lat1:=Lat2;
                Lon1:=Lon2;
              end else begin
                Found1:=false;
              end;
              Route.Frame.AddressFound:=Point.Found;
              Route.Frame.ImageAddress.Visible:=true;
            end else begin
              Found1:=false;
            end;


            if Distance<>0.0 then
              Distance:=Distance/1000;

            if FBeforeShowed then
              Route.Frame.Distance:=Distance;
          finally
            Route.Frame.EnableChanges;
          end;
        end;

        if WithCalc then
          Calculate(true,true);

      finally
        Points.Free;
        Screen.Cursor:=OldCursor;
      end;
    end else begin
      FAddressFrame.AddressFound:=false;
      FAddressFrame.ImageAddress.Visible:=false;
      for i:=0 to FRoutes.Count-1 do begin
        Route:=FRoutes.Items[i];
        Route.Frame.AddressFound:=false;
        Route.Frame.ImageAddress.Visible:=false;
      end;
    end;
  end;
end;

function TBisTaxiOrderEditForm.GetAddressString(StreetPrefix,StreetName,House,Flat,LocalityPrefix,LocalityName: Variant): String;
var
  F1,F2,F3,F4,F5,F6: String;
const
  SQ='?';
begin
  Result:='';

  F1:=Trim(VarToStrDef(StreetPrefix,''));
  F2:=Trim(VarToStrDef(StreetName,''));
  F3:=Trim(VarToStrDef(House,''));
  F4:=Trim(VarToStrDef(Flat,''));
  F5:=Trim(VarToStrDef(LocalityPrefix,''));
  F6:=Trim(VarToStrDef(LocalityName,''));

  if F2<>'' then
    Result:=FormatEx('%s%s %s-%s (%s%s)',
                     [iff(F1='',SQ,F1),iff(F2='',SQ,F2),iff(F3='',SQ,F3),
                      iff(F4='',SQ,F4),iff(F5='',SQ,F5),iff(F6='',SQ,F6)]);

end;

procedure TBisTaxiOrderEditForm.SetClientDataByLogin;
var
  P: TBisProvider;
  P1: TBisParam;
  Flag: Boolean;
  ParamUserName: TBisParam;
  S: String;
begin
  ParamUserName:=Provider.ParamByName('CLIENT_USER_NAME');
  if (Mode in [emInsert]) and not ParamUserName.Empty then begin
    FNeedClientChange:=false;
    FAddressFrame.DisableChanges;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=true;
      P.ProviderName:='S_CLIENTS';
      with P.FieldNames do begin
        AddInvisible('CLIENT_ID');
        AddInvisible('PHONE');
        AddInvisible('SURNAME');
        AddInvisible('NAME');
        AddInvisible('PATRONYMIC');
        AddInvisible('LOCALITY_ID');
        AddInvisible('LOCALITY_PREFIX');
        AddInvisible('LOCALITY_NAME');
        AddInvisible('STREET_ID');
        AddInvisible('STREET_PREFIX');
        AddInvisible('STREET_NAME');
        AddInvisible('HOUSE');
        AddInvisible('FLAT');
        AddInvisible('PORCH');
        AddInvisible('ADDRESS_DESC');
        AddInvisible('FIRM_SMALL_NAME');
        AddInvisible('PASSWORD');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('USER_NAME',fcEqual,ParamUserName.Value);
        Filters.Add('LOCKED',fcEqual,0);
      end;
      P.Open;
      if P.Active then begin
        if not P.Empty then begin
          Flag:=true;
          if P.RecordCount>1 then
            Flag:=ShowWarningQuestion('������� ����� ������ �������. ������� ������� � ������?',mbYes)=mrYes;
          if Flag then begin
            S:=FormatEx('�������: %s'+#13+
                        '���: %s %s %s'+#13+
                        '�����������: %s'+#13+
                        '�����: %s'+#13+
                        '������: %s'+#13,
                        [P.FieldByName('PHONE').Value,
                         P.FieldByName('SURNAME').Value,P.FieldByName('NAME').Value,P.FieldByName('PATRONYMIC').Value,
                         P.FieldByName('FIRM_SMALL_NAME').Value,
                         GetAddressString(P.FieldByName('STREET_PREFIX').Value,
                                          P.FieldByName('STREET_NAME').Value,
                                          P.FieldByName('HOUSE').Value,
                                          P.FieldByName('FLAT').Value,
                                          P.FieldByName('LOCALITY_PREFIX').Value,
                                          P.FieldByName('LOCALITY_NAME').Value),
                         P.FieldByName('PASSWORD').Value]);
            Flag:=ShowQuestion(S,mbYes)=mrYes;
          end;
          if Flag then begin
            with Provider do begin
              ParamByName('CLIENT_ID').Value:=P.FieldByName('CLIENT_ID').Value;
              ParamByName('PHONE').Value:=P.FieldByName('PHONE').Value;
              ParamByName('CLIENT_SURNAME').Value:=P.FieldByName('SURNAME').Value;
              ParamByName('CLIENT_NAME').Value:=P.FieldByName('NAME').Value;
              ParamByName('CLIENT_PATRONYMIC').Value:=P.FieldByName('PATRONYMIC').Value;
              ParamByName('CLIENT_FIRM_SMALL_NAME').Value:=P.FieldByName('FIRM_SMALL_NAME').Value;
              P1:=ParamByName('CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME');
              P1.Value:=(FormatEx(P1.ParamFormat,[P.FieldByName('SURNAME').Value,
                                                  P.FieldByName('NAME').Value,
                                                  P.FieldByName('PATRONYMIC').Value,
                                                  P.FieldByName('FIRM_SMALL_NAME').Value]));
              ParamByName('DESCRIPTION').Value:=P.FieldByName('ADDRESS_DESC').Value;
            end;
            FAddressFrame.LocalityId:=P.FieldByName('LOCALITY_ID').Value;
            FAddressFrame.StreetId:=P.FieldByName('STREET_ID').Value;
            FAddressFrame.House:=P.FieldByName('HOUSE').Value;
            FAddressFrame.Flat:=P.FieldByName('FLAT').Value;
            FAddressFrame.Porch:=P.FieldByName('PORCH').Value;
          end;
        end else begin
          with Provider do begin
            ParamByName('CLIENT_ID').Value:=Null;
            ParamByName('PHONE').Value:=Null;
            ParamByName('CLIENT_SURNAME').Value:=Null;
            ParamByName('CLIENT_NAME').Value:=Null;
            ParamByName('CLIENT_PATRONYMIC').Value:=Null;
            ParamByName('CLIENT_FIRM_SMALL_NAME').Value:=Null;
            ParamByName('CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME').Value:=Null;
          end;
        end;
      end;

      if VarIsNull(FAddressFrame.LocalityId) then
        FAddressFrame.SetDefaultLocality;

    finally
      P.Free;
      FAddressFrame.CanChange:=true;
      FAddressFrame.DetectZone;
      FAddressFrame.CanChange:=false;
      FAddressFrame.UpdateButtons(true);
      FAddressFrame.EnableChanges;
      SetDistanceByMap(false);
      FNeedClientChange:=true;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.SetClientDataByPhone;
var
  ParamPhone: TBisParam;

  function SetClientByProvider(ProviderName: String): Boolean;
  var
    P: TBisProvider;
    P1: TBisParam;
    Flag: Boolean;
    S: String;
  begin
    Result:=false;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:=ProviderName;
      with P.FieldNames do begin
        AddInvisible('CLIENT_ID');
        AddInvisible('USER_NAME');
        AddInvisible('SURNAME');
        AddInvisible('NAME');
        AddInvisible('PATRONYMIC');
        AddInvisible('LOCALITY_ID');
        AddInvisible('LOCALITY_PREFIX');
        AddInvisible('LOCALITY_NAME');
        AddInvisible('STREET_ID');
        AddInvisible('STREET_PREFIX');
        AddInvisible('STREET_NAME');
        AddInvisible('HOUSE');
        AddInvisible('FLAT');
        AddInvisible('PORCH');
        AddInvisible('ADDRESS_DESC');
        AddInvisible('FIRM_SMALL_NAME');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('PHONE',fcEqual,ParamPhone.Value).CheckCase:=true;
        Filters.Add('LOCKED',fcEqual,0);
      end;
      P.Open;
      if P.Active then begin
        Result:=not P.Empty;
        if Result then begin
          Flag:=true;
          if P.RecordCount>1 then
            Flag:=ShowWarningQuestion('������� ����� ������ �������. ������� ������� � ������?',mbYes)=mrYes;
          if Flag then begin
            S:=FormatEx('�����: %s'+#13+
                        '���: %s %s %s'+#13+
                        '�����������: %s'+#13+
                        '�����: %s'+#13,
                        [P.FieldByName('USER_NAME').Value,
                         P.FieldByName('SURNAME').Value,P.FieldByName('NAME').Value,P.FieldByName('PATRONYMIC').Value,
                         P.FieldByName('FIRM_SMALL_NAME').Value,
                         GetAddressString(P.FieldByName('STREET_PREFIX').Value,
                                          P.FieldByName('STREET_NAME').Value,
                                          P.FieldByName('HOUSE').Value,
                                          P.FieldByName('FLAT').Value,
                                          P.FieldByName('LOCALITY_PREFIX').Value,
                                          P.FieldByName('LOCALITY_NAME').Value)]);
            Flag:=ShowQuestion(S,mbYes)=mrYes;
          end;
          if Flag then begin
            with Provider do begin
              ParamByName('CLIENT_ID').Value:=P.FieldByName('CLIENT_ID').Value;
              ParamByName('CLIENT_USER_NAME').Value:=P.FieldByName('USER_NAME').Value;
              ParamByName('CLIENT_SURNAME').Value:=P.FieldByName('SURNAME').Value;
              ParamByName('CLIENT_NAME').Value:=P.FieldByName('NAME').Value;
              ParamByName('CLIENT_PATRONYMIC').Value:=P.FieldByName('PATRONYMIC').Value;
              ParamByName('CLIENT_FIRM_SMALL_NAME').Value:=P.FieldByName('FIRM_SMALL_NAME').Value;
              P1:=ParamByName('CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME');
              P1.Value:=(FormatEx(P1.ParamFormat,[P.FieldByName('SURNAME').Value,
                                                  P.FieldByName('NAME').Value,
                                                  P.FieldByName('PATRONYMIC').Value,
                                                  P.FieldByName('FIRM_SMALL_NAME').Value]));
              ParamByName('DESCRIPTION').Value:=P.FieldByName('ADDRESS_DESC').Value;
            end;
            FAddressFrame.LocalityId:=P.FieldByName('LOCALITY_ID').Value;
            FAddressFrame.StreetId:=P.FieldByName('STREET_ID').Value;
            FAddressFrame.House:=P.FieldByName('HOUSE').Value;
            FAddressFrame.Flat:=P.FieldByName('FLAT').Value;
            FAddressFrame.Porch:=P.FieldByName('PORCH').Value;
          end;
        end else begin
          with Provider do begin
            ParamByName('CLIENT_ID').Value:=Null;
            ParamByName('CLIENT_USER_NAME').Value:=Null;
            ParamByName('CLIENT_SURNAME').Value:=Null;
            ParamByName('CLIENT_NAME').Value:=Null;
            ParamByName('CLIENT_PATRONYMIC').Value:=Null;
            ParamByName('CLIENT_FIRM_SMALL_NAME').Value:=Null;
            ParamByName('CLIENT_SURNAME;CLIENT_NAME;CLIENT_PATRONYMIC;CLIENT_FIRM_SMALL_NAME').Value:=Null;
          end;
        end;
      end;
    finally
      P.Free;
    end;
  end;

var
  OldCursor: TCursor;  
begin
  Self.Update;
  ParamPhone:=Provider.ParamByName('PHONE');
  if (Mode in [emInsert]) and not ParamPhone.Empty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    FNeedClientChange:=false;
    FAddressFrame.DisableChanges;
    try
      if not SetClientByProvider('S_CLIENTS') then begin
        SetClientByProvider('S_CLIENT_PHONES');
      end;

      if VarIsNull(FAddressFrame.LocalityId) then
        FAddressFrame.SetDefaultLocality;

    finally
      FAddressFrame.CanChange:=true;
      FAddressFrame.DetectZone;
      FAddressFrame.CanChange:=false;
      FAddressFrame.UpdateButtons(true);
      FAddressFrame.EnableChanges;
      SetDistanceByMap(false);
      FNeedClientChange:=true;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.TimerCostGrossTimer(Sender: TObject);
begin
  FManualCalculate:=true;
  try
    TimerCostGross.Enabled:=false;
    Calculate(false,true);
  finally
    FManualCalculate:=false;
  end;
end;

procedure TBisTaxiOrderEditForm.TimerLoginTimer(Sender: TObject);
begin
  TimerLogin.Enabled:=false;
  SetClientDataByLogin;
  RefreshPhones;
  SetRouteHistory(true);
end;

procedure TBisTaxiOrderEditForm.TimerPhoneTimer(Sender: TObject);
begin
  TimerPhone.Interval:=1000;
  TimerPhone.Enabled:=false;
  if CheckPhoneBlack(false,true) then begin
    SetClientDataByPhone;
    RefreshPhones;
    SetRouteHistory(true);
  end;
end;

function TBisTaxiOrderEditForm.CanClientMessage: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
begin
  Result:=CanClientPhone;
  if Result then begin
    AClass:=TBisTaxiDataOutMessageInsertFormIface;
    Result:=Assigned(AClass) and IsClassParent(AClass,TBisDataEditFormIface);
    if Result then begin
      AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
      try
        AIface.Init;
        Result:=AIface.CanShow;
      finally
        AIface.Free;
      end;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.ClientMessage;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
  P1: TBisParam;
begin
  if CanClientMessage then begin
    AClass:=TBisTaxiDataOutMessageInsertFormIface;
    AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      with AIface.Params do begin
        ParamByName('ORDER_ID').Value:=Provider.ParamByName('ORDER_ID').Value;
        ParamByName('RECIPIENT_ID').Value:=Provider.Params.ParamByName('CLIENT_ID').Value;
        ParamByName('RECIPIENT_USER_NAME').Value:=Provider.Params.ParamByName('CLIENT_USER_NAME').Value;
        ParamByName('RECIPIENT_SURNAME').Value:=Provider.Params.ParamByName('CLIENT_SURNAME').Value;
        ParamByName('RECIPIENT_NAME').Value:=Provider.Params.ParamByName('CLIENT_NAME').Value;
        ParamByName('RECIPIENT_PATRONYMIC').Value:=Provider.Params.ParamByName('CLIENT_PATRONYMIC').Value;
        P1:=ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
        ParamByName('CONTACT').Value:=Provider.Params.ParamByName('PHONE').Value;
      end;
      AIface.ShowType:=ShowType;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

function TBisTaxiOrderEditForm.CanClientCall: Boolean;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  Result:=CanClientPhone;
  if Result then begin
    AIface:=TBisTaxiPhoneFormIface.Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.ClientCall;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  if CanClientPhone then begin
    AIface:=TBisTaxiPhoneFormIface(Core.FindIface(TBisTaxiPhoneFormIface));
    if Assigned(AIface) then begin
      with Provider do begin
        AIface.Dial(Provider.ParamByName('PHONE').AsString,
                    Provider.ParamByName('ORDER_ID').Value);
      end;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.ClientPhoneMenuItemCallClick(Sender: TObject);
begin
  ClientCall;
end;

procedure TBisTaxiOrderEditForm.ClientPhoneMenuItemMessageClick(Sender: TObject);
begin
  ClientMessage;
end;

procedure TBisTaxiOrderEditForm.PopupClientPhonePopup(Sender: TObject);
begin
  ClientPhoneMenuItemMessage.Enabled:=CanClientMessage;
  ClientPhoneMenuItemCall.Enabled:=CanClientCall;
end;

function TBisTaxiOrderEditForm.CanDriverMessage: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
begin
  Result:=CanDriverPhone;
  if Result then begin
    AClass:=TBisTaxiDataDriverOutMessageInsertFormIface;
    Result:=Assigned(AClass) and IsClassParent(AClass,TBisDataEditFormIface);
    if Result then begin
      AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
      try
        AIface.Init;
        Result:=AIface.CanShow;
      finally
        AIface.Free;
      end;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.DriverMessage;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
  P1: TBisParam;
begin
  if CanDriverMessage then begin
    AClass:=TBisTaxiDataDriverOutMessageInsertFormIface;
    AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      with AIface.Params do begin
        ParamByName('ORDER_ID').Value:=Provider.ParamByName('ORDER_ID').Value;
        ParamByName('RECIPIENT_ID').Value:=Provider.Params.ParamByName('DRIVER_ID').Value;
        ParamByName('RECIPIENT_USER_NAME').Value:=Provider.Params.ParamByName('DRIVER_USER_NAME').Value;
        ParamByName('RECIPIENT_SURNAME').Value:=Provider.Params.ParamByName('DRIVER_SURNAME').Value;
        ParamByName('RECIPIENT_NAME').Value:=Provider.Params.ParamByName('DRIVER_NAME').Value;
        ParamByName('RECIPIENT_PATRONYMIC').Value:=Provider.Params.ParamByName('DRIVER_PATRONYMIC').Value;
        P1:=ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
        ParamByName('CONTACT').Value:=Provider.Params.ParamByName('DRIVER_PHONE').Value;
      end;
      AIface.ShowType:=ShowType;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

function TBisTaxiOrderEditForm.CanDriverCall: Boolean;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  Result:=CanDriverPhone;
  if Result then begin
    AIface:=TBisTaxiPhoneFormIface.Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.DriverCall;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  if CanDriverCall then begin
    AIface:=TBisTaxiPhoneFormIface(Core.FindIface(TBisTaxiPhoneFormIface));
    if Assigned(AIface) then begin
      AIface.Dial(Provider.ParamByName('DRIVER_PHONE').AsString,
                  Provider.ParamByName('ORDER_ID').Value);
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.DriverPhoneMenuItemCallClick(Sender: TObject);
begin
  DriverCall;
end;
procedure TBisTaxiOrderEditForm.DriverPhoneMenuItemMessageClick(Sender: TObject);
begin
  DriverMessage;
end;

procedure TBisTaxiOrderEditForm.PopupDriverPhonePopup(Sender: TObject);
begin
  DriverPhoneMenuItemMessage.Enabled:=CanDriverMessage;
  DriverPhoneMenuItemCall.Enabled:=CanDriverCall;
end;

procedure TBisTaxiOrderEditForm.RouteHistoryAddressChange(Sender: TObject);
var
  Direction: Variant;
  ADirection: Integer;
  LocalityId: Variant;
  StreetId: Variant;
  House: Variant;
  Flat: Variant;
  Porch: Variant;
  Description: String;
  Route: TBisTaxiRoute;
begin
  if FRouteHistoryFrame.Provider.Active and
     not FRouteHistoryFrame.Provider.Empty then begin

    Direction:=FRouteHistoryFrame.Provider.FieldByName('DIRECTION').Value;
    if not VarIsNull(Direction) then begin

      LocalityId:=FRouteHistoryFrame.Provider.FieldByName('LOCALITY_ID').Value;
      StreetId:=FRouteHistoryFrame.Provider.FieldByName('STREET_ID').Value;
      House:=FRouteHistoryFrame.Provider.FieldByName('HOUSE').Value;
      Flat:=FRouteHistoryFrame.Provider.FieldByName('FLAT').Value;
      Porch:=FRouteHistoryFrame.Provider.FieldByName('PORCH').Value;
      Description:=FRouteHistoryFrame.Provider.FieldByName('DESCRIPTION').AsString;

      ADirection:=VarToIntDef(Direction,0);
      if ADirection=0 then begin
        FAddressFrame.DisableChanges;
        try
          FAddressFrame.LocalityId:=LocalityId;
          FAddressFrame.StreetId:=StreetId;
          FAddressFrame.House:=House;
          FAddressFrame.Flat:=Flat;
          FAddressFrame.Porch:=Porch;
          Provider.ParamByName('DESCRIPTION').Value:=Description;
        finally
          FAddressFrame.CanChange:=true;
          FAddressFrame.DetectZone;
          FAddressFrame.CanChange:=false;
          FAddressFrame.UpdateButtons(true);
          FAddressFrame.EnableChanges;
          SetDistanceByMap(false);
        end;
      end else begin
        if TabSetRoutes.TabIndex<>-1 then begin
          Route:=TBisTaxiRoute(TabSetRoutes.Tabs.Objects[TabSetRoutes.TabIndex]);
          if not VarIsNull(Route.Frame.StreetId) then
            Route:=AddRoute;
          Route.Frame.DisableChanges;
          try
            Route.Frame.LocalityId:=LocalityId;
            Route.Frame.StreetId:=StreetId;
            Route.Frame.House:=House;
            Route.Frame.Flat:=Flat;
            Route.Frame.Porch:=Porch;
          finally
            Route.Frame.CanChange:=true;
            Route.Frame.DetectZone;
            Route.Frame.CanChange:=false;
            Route.Frame.UpdateButtons(true);
            Route.Frame.EnableChanges;
            SetDistanceByMap(true);
          end;
        end;
      end;
      
    end;
  end;
end;

procedure TBisTaxiOrderEditForm.SetRouteHistory(TabChange: Boolean);
var
  ParamPhone: TBisParam;
  ParamClientId: TBisParam;
  HistoryExists: Boolean;
  i: Integer;
  Route: TBisTaxiRoute;
begin
  Self.Update;
  
  HistoryExists:=false;

  FRouteHistoryFrame.Provider.EmptyTable;
  FRouteHistoryFrame.LocalityId:=FAddressFrame.LocalityId;
  FRouteHistoryFrame.StreetId:=FAddressFrame.StreetId;
  FRouteHistoryFrame.House:=FAddressFrame.House;

  FRouteHistoryFrame.ColorFrom:=PanelAddress.Color;
  FRouteHistoryFrame.ColorTo:=PanelRoutes.Color;

  FRouteHistoryFrame.Routes.Clear;
  for i:=0 to FRoutes.Count-1 do begin
    Route:=FRoutes.Items[i];
    FRouteHistoryFrame.Routes.Add(Route.Frame.LocalityId,
                                  Route.Frame.StreetId,
                                  Route.Frame.House);
  end;

  ParamClientId:=Provider.ParamByName('CLIENT_ID');
  if ParamClientId.Empty then begin
    ParamPhone:=Provider.ParamByName('PHONE');
    if not ParamPhone.Empty then begin
      FRouteHistoryFrame.Phone:=ParamPhone.Value;
      FRouteHistoryFrame.ClientId:=Null;
      FRouteHistoryFrame.OpenRecords;
      HistoryExists:=FRouteHistoryFrame.Provider.Active and
                     not  FRouteHistoryFrame.Provider.Empty;
    end;
  end else begin
    FRouteHistoryFrame.Phone:=Null;
    FRouteHistoryFrame.ClientId:=ParamClientId.Value;
    FRouteHistoryFrame.OpenRecords;
    HistoryExists:=FRouteHistoryFrame.Provider.Active and
                   not FRouteHistoryFrame.Provider.Empty;
  end;

  Provider.ParamByName('SOURCE_NAME').Required:=not HistoryExists;

  if (Mode in [emInsert]) and
     TabChange and HistoryExists then begin

    TabSetAddressHistory.OnChange:=nil;
    try
      TabSetAddressHistory.TabIndex:=1;
      PanelAddressRoutes.Visible:=false;
      PanelRouteHistory.Visible:=true;
    finally
      TabSetAddressHistory.OnChange:=TabSetAddressHistoryChange;
    end;
  end;

end;

procedure TBisTaxiOrderEditForm.RefreshPhones;
var
  ParamClientId: TBisParam;
  ParamPhone: TBisParamComboBox;
  OldPhone: String;
  P: TBisProvider;
begin
  ComboBoxPhone.OnChange:=nil;
  ComboBoxPhone.Items.BeginUpdate;
  try
    ParamPhone:=TBisParamComboBox(Provider.ParamByName('PHONE'));
    OldPhone:=ParamPhone.AsString;
    ComboBoxPhone.Clear;
    
    ParamClientId:=Provider.ParamByName('CLIENT_ID');
    if not ParamClientId.Empty then begin
      P:=TBisProvider.Create(nil);
      try

        P.WithWaitCursor:=false;
        P.ProviderName:='GET_CLIENT_PHONES';
        P.FieldNames.Add('PHONE');
        P.Params.AddInvisible('CLIENT_ID').Value:=ParamClientId.Value;
        P.OpenWithExecute;
        if P.Active and not P.Empty then begin
          P.First;
          while not P.Eof do begin
            ComboBoxPhone.Items.Add(P.FieldByName('PHONE').AsString);
            P.Next;
          end;
        end;

      finally
        P.Free;
      end;
    end;

    ComboBoxPhone.Text:=OldPhone;
    ComboBoxPhone.SelStart:=Length(OldPhone);

  finally
    ComboBoxPhone.Items.EndUpdate;
    ComboBoxPhone.OnChange:=ComboBoxPhoneChange;
  end;
end;


end.

