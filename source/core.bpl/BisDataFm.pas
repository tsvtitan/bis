unit BisDataFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ToolWin, ActnMan, DB, Menus,
  ActnCtrls, ActnMenus, XPStyleActnCtrls, ActnList,
  BisFm, BisDataFrm, BisChildFm, BisObject, BisFieldNames, BisFilterGroups,
  BisOrders, BisDataEditFm, BisParams, BisSizeGrip, BisDataSet;

type
  TBisDataFormIface=class;

  TBisDataForm = class(TBisForm)
    StatusBar: TStatusBar;
    PanelFrame: TPanel;
    PanelButton: TPanel;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    ActionList: TActionList;
    ActionOk: TAction;
    ActionClose: TAction;
    procedure ActionOkExecute(Sender: TObject);
    procedure ActionCloseExecute(Sender: TObject);
    procedure ActionOkUpdate(Sender: TObject);
  private
    FDataFrame: TBisDataFrame;
    FDataFrameClass: TBisDataFrameClass;
//    FSFormatPanelCountAll: String;
    FLocateFields: String;
    FLocateValues: Variant;
    FUpdateShortCut: TShortCut;
    FFilterOnShow: Boolean;
    FLastLocated: Boolean;
    FSizeGrip: TBisSizeGrip;
    FSOpenRecordsTime: String;

    procedure DataFrameUpdateCounters(Sender: TBisDataFrame);
    procedure DataFrameAfterOpenRecords(Sender: TBisDataFrame);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    class function GetDataFrameClass: TBisDataFrameClass; virtual;

    property LastLocated: Boolean read FLastLocated write FLastLocated;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure EnableControls(AEnabled: Boolean); override;
    function CanShow: Boolean; override;
    procedure BeforeShow; override;
    procedure AfterShow; override;
    function SelectInto(DataSet: TBisDataSet): Boolean; virtual;

    property DataFrame: TBisDataFrame read FDataFrame;
    property LocateFields: String read FLocateFields write FLocateFields;
    property LocateValues: Variant read FLocateValues write FLocateValues;
    property FilterOnShow: Boolean read FFilterOnShow write FFilterOnShow;
  published

//    property SFormatPanelCountAll: String read FSFormatPanelCountAll write FSFormatPanelCountAll;
    property SOpenRecordsTime: String read FSOpenRecordsTime write FSOpenRecordsTime;
  end;

  TBisDataFormClass=class of TBisDataForm;

  TBisDataFormIface=class(TBisFormIface)
  private
    FFieldNames: TBisFieldNames;
    FFilterGroups: TBisFilterGroups;
    FOrders: TBisOrders;
    FParams: TBisParams;
    FSPermissionInsert: String;
    FSPermissionUpdate: String;
    FProviderName: String;
    FInsertClasses: TBisDataEditFormIfaceClasses;
    FDuplicateClass: TBisDataEditFormIfaceClass;
    FUpdateClass: TBisDataEditFormIfaceClass;
    FDeleteClass: TBisDataEditFormIfaceClass;
    FSPermissionDelete: String;
    FSPermissionInformation: String;
    FViewClass: TBisDataEditFormIfaceClass;
    FMultiSelect: Boolean;
    FLocateFields: String;
    FLocateValues: Variant;
    FChoosed: Boolean;
    FFilterClass: TBisDataEditFormIfaceClass;
    FFilterOnShow: Boolean;
    FSPermissionReport: String;
    FChangeFrameProperties: Boolean;
    FDataFrame: TBisDataFrame;
//    FSPermissionFilter: String;

    function GetInsertClass: TBisDataEditFormIfaceClass;
    procedure SetInsertClass(const Value: TBisDataEditFormIfaceClass);
    function GetLastForm: TBisDataForm;
    function CanRefreshRecords(Sender: TBisDataFrame): Boolean;
    function CanInsertRecord(Sender: TBisDataFrame): Boolean;
    function CanUpdateRecord(Sender: TBisDataFrame): Boolean;
    function CanDeleteRecord(Sender: TBisDataFrame): Boolean;
    function CanInfoRecord(Sender: TBisDataFrame): Boolean;
    function CanReportRecords(Sender: TBisDataFrame): Boolean;
    function CanFilterRecords(Sender: TBisDataFrame): Boolean;

  protected
    function CreateForm: TBisForm; override;
    procedure SetDataFrameProperties(DataFrame: TBisDataFrame); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ShowInParent(Parent: TWinControl); override;
    procedure BeforeFormShow; override;
    function SelectInto(DataSet: TBisDataSet; AVisible: Boolean=true): Boolean; virtual;
    function CreateDataFrame(AsNew: Boolean=false): TBisDataFrame; virtual;

    property FieldNames: TBisFieldNames read FFieldNames;
    property FilterGroups: TBisFilterGroups read FFilterGroups;
    property Orders: TBisOrders read FOrders;
    property Params: TBisParams read FParams;

    property InsertClass: TBisDataEditFormIfaceClass read GetInsertClass write SetInsertClass;
    property InsertClasses: TBisDataEditFormIfaceClasses read FInsertClasses;
    property DuplicateClass: TBisDataEditFormIfaceClass read FDuplicateClass write FDuplicateClass;
    property UpdateClass: TBisDataEditFormIfaceClass read FUpdateClass write FUpdateClass;
    property DeleteClass: TBisDataEditFormIfaceClass read FDeleteClass write FDeleteClass;
    property FilterClass: TBisDataEditFormIfaceClass read FFilterClass write FFilterClass;
    property ViewClass: TBisDataEditFormIfaceClass read FViewClass write FViewClass;

    property LastForm: TBisDataForm read GetLastForm;

    property MultiSelect: Boolean read FMultiSelect write FMultiSelect;
    property LocateFields: String read FLocateFields write FLocateFields;
    property LocateValues: Variant read FLocateValues write FLocateValues;
    property Choosed: Boolean read FChoosed write FChoosed;
    property FilterOnShow: Boolean read FFilterOnShow write FFilterOnShow;

    property ChangeFrameProperties: Boolean read FChangeFrameProperties write FChangeFrameProperties; 
  published
    property ProviderName: String read FProviderName write FProviderName;
    property SPermissionInsert: String read FSPermissionInsert write FSPermissionInsert;
    property SPermissionUpdate: String read FSPermissionUpdate write FSPermissionUpdate;
    property SPermissionDelete: String read FSPermissionDelete write FSPermissionDelete;
    property SPermissionInformation: String read FSPermissionInformation write FSPermissionInformation;
    property SPermissionExport: String read FSPermissionReport write FSPermissionReport;
//    property SPermissionFilter: String read FSPermissionFilter write FSPermissionFilter;
  end;

  TBisDataFormIfaceClass=class of TBisDataFormIface;

var
  BisDataForm: TBisDataForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisConsts, BisCoreUtils, BisProvider;

{ TBisDataFormIface }

constructor TBisDataFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDataForm;
  OnlyOneForm:=false;
  ChangeFormCaption:=true;
  ShowType:=stMdiChild;
  FChangeFrameProperties:=true;
  FFieldNames:=TBisFieldNames.Create;
  FFilterGroups:=TBisFilterGroups.Create;
  FOrders:=TBisOrders.Create;
  FParams:=TBisParams.Create;
  FInsertClasses:=TBisDataEditFormIfaceClasses.Create;
  FSPermissionInsert:='��������';
  FSPermissionUpdate:='���������';
  FSPermissionDelete:='��������';
  FSPermissionInformation:='����������';
  FSPermissionReport:='�����';
//  FSPermissionFilter:='������';
end;

destructor TBisDataFormIface.Destroy;
begin
  FInsertClasses.Free;
  FParams.Free;
  FOrders.Free;
  FFilterGroups.Free;
  FFieldNames.Free;
  FreeAndNilEx(FDataFrame);
  inherited Destroy;
end;

function TBisDataFormIface.GetInsertClass: TBisDataEditFormIfaceClass;
begin
  Result:=FInsertClasses.FirstItem;
end;

function TBisDataFormIface.GetLastForm: TBisDataForm;
begin
  Result:=TBisDataForm(inherited LastForm);
end;

procedure TBisDataFormIface.SetInsertClass(const Value: TBisDataEditFormIfaceClass);
begin
  FInsertClasses.InsertToFirst(Value);
end;

procedure TBisDataFormIface.Init;
begin
  inherited Init;
  Permissions.AddDefault(FSPermissionInsert);
  Permissions.AddDefault(FSPermissionUpdate);
  Permissions.AddDefault(FSPermissionDelete);
  Permissions.AddDefault(FSPermissionInformation);
  Permissions.AddDefault(FSPermissionReport);
//  Permissions.AddDefault(FSPermissionFilter);
  TranslateFieldNames(FFieldNames,ClassType);
  TranslateFilterGroups(FFilterGroups,ClassType);
end;

procedure TBisDataFormIface.SetDataFrameProperties(DataFrame: TBisDataFrame);
begin
  if Assigned(DataFrame) then begin
  
    if FChangeFrameProperties then begin
      DataFrame.InsertClasses.CopyFrom(FInsertClasses);
      DataFrame.DuplicateClass:=FDuplicateClass;
      DataFrame.UpdateClass:=FUpdateClass;
      DataFrame.DeleteClass:=FDeleteClass;
      DataFrame.FilterClass:=FFilterClass;
      DataFrame.ViewClass:=FViewClass;

      DataFrame.Provider.ProviderName:=FProviderName;
      DataFrame.Provider.FieldNames.CopyFrom(FFieldNames);
      DataFrame.Provider.FilterGroups.CopyFrom(FFilterGroups);
      DataFrame.Provider.Orders.CopyFrom(FOrders);

    end;
    DataFrame.Caption:=Caption;
    DataFrame.MultiSelect:=FMultiSelect;
    DataFrame.OnCanRefreshRecords:=CanRefreshRecords;
    DataFrame.OnCanInsertRecord:=CanInsertRecord;
    DataFrame.OnCanDuplicateRecord:=CanInsertRecord;
    DataFrame.OnCanUpdateRecord:=CanUpdateRecord;
    DataFrame.OnCanDeleteRecord:=CanDeleteRecord;
    DataFrame.OnCanInfoRecord:=CanInfoRecord;
    DataFrame.OnCanReportRecords:=CanReportRecords;
    DataFrame.OnCanFilterRecords:=CanFilterRecords;
  end;
end;

function TBisDataFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    LastForm.LocateFields:=FLocateFields;
    LastForm.LocateValues:=FLocateValues;
    LastForm.ActionOk.Visible:=FChoosed;
    LastForm.FilterOnShow:=FFilterOnShow;
    with LastForm do begin
      SetDataFrameProperties(DataFrame);
    end;
  end;
end;

function TBisDataFormIface.CreateDataFrame(AsNew: Boolean=false): TBisDataFrame;
var
  AFormClass: TBisFormClass;
  AFrameClass: TBisDataFrameClass;
begin
  Result:=FDataFrame;
  if AsNew or not Assigned(Result) then begin
    FreeAndNilEx(FDataFrame);
    AFormClass:=FormClass;
    if Assigned(AFormClass) and IsClassParent(AFormClass,TBisDataForm) then begin
      AFrameClass:=TBisDataFormClass(AFormClass).GetDataFrameClass;
      if Assigned(AFrameClass) then begin
        FDataFrame:=AFrameClass.Create(Self);
        SetDataFrameProperties(FDataFrame);
        FDataFrame.Init;
        Result:=FDataFrame;
      end;
    end;
  end;
end;

procedure TBisDataFormIface.ShowInParent(Parent: TWinControl);
begin
  inherited ShowInParent(Parent);
  if Assigned(Parent) then begin

  end;
end;

procedure TBisDataFormIface.BeforeFormShow;
begin
  inherited BeforeFormShow;

end;

function TBisDataFormIface.SelectInto(DataSet: TBisDataSet; AVisible: Boolean): Boolean;
var
  AForm: TBisDataForm;
  P: TBisProvider;
begin
  Result:=false;
  if AVisible then begin
    if CanShow then begin
      FChoosed:=true;
      AForm:=TBisDataForm(CreateForm);
      if Assigned(AForm) then begin
        AForm.Init;
        if Assigned(AForm.DataFrame) then
          AForm.DataFrame.Provider.FilterGroups.CopyFrom(FFilterGroups,false);
        BeforeFormShow;
        Result:=AForm.SelectInto(DataSet);
        Forms.Remove(AForm);
      end;
    end;
  end else begin
    if Assigned(DataSet) then begin
      P:=TBisProvider.Create(nil);
      try
        P.UseWaitCursor:=false;
        P.ProviderName:=FProviderName;
        P.FieldNames.CopyFrom(FFieldNames);
        P.FilterGroups.CopyFrom(FFilterGroups,false);
        P.Orders.CopyFrom(FOrders);
        P.Open;
        if P.Active then begin
          DataSet.CreateTable(P);
          DataSet.CopyRecords(P);
          Result:=DataSet.Active and not P.Empty;
        end;
      finally
        P.Free;
      end;
    end;
  end;
end;

function TBisDataFormIface.CanRefreshRecords(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(SPermissionShow);
end;

function TBisDataFormIface.CanInsertRecord(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionInsert);
end;

function TBisDataFormIface.CanUpdateRecord(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionUpdate);
end;
function TBisDataFormIface.CanDeleteRecord(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionDelete);
end;

function TBisDataFormIface.CanInfoRecord(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionInformation);
end;

function TBisDataFormIface.CanReportRecords(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionReport);
end;

function TBisDataFormIface.CanFilterRecords(Sender: TBisDataFrame): Boolean;
begin
//  Result:=Permissions.Exists(FSPermissionFilter);
  Result:=true;
end;

{ TBisDataForm }

constructor TBisDataForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;
  TranslateClass:=TBisDataForm;

  FSizeGrip:=TBisSizeGrip.Create(Self);
  FSizeGrip.Parent:=PanelButton;

  FDataFrameClass:=GetDataFrameClass;
  if Assigned(FDataFrameClass) then begin
    FDataFrame:=FDataFrameClass.Create(Self);
    FDataFrame.Parent:=PanelFrame;
    FDataFrame.Align:=alClient;

{    FDataFrame.Provider.Threaded:=true;
    FDataFrame.Provider.UseShowWait:=true;
    FDataFrame.Provider.WaitInterval:=500;
    FDataFrame.Provider.WaitTimeout:=10;
    FDataFrame.Provider.WaitAsModal:=true;}

    FDataFrame.OnUpdateCounters:=DataFrameUpdateCounters;
    FDataFrame.OnAfterOpenRecords:=DataFrameAfterOpenRecords;
    FUpdateShortCut:=FDataFrame.ActionUpdate.ShortCut;
  end;

//  FSFormatPanelCountAll:='�����: %s';
  FSOpenRecordsTime:='����� ��������� ������� => %d msec';
end;

destructor TBisDataForm.Destroy;
begin
  FSizeGrip.Free;
  FreeAndNilEx(FDataFrame);
  inherited Destroy;
end;

procedure TBisDataForm.EnableControls(AEnabled: Boolean);
begin
  EnableControl(PanelFrame,AEnabled);
end;

class function TBisDataForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDataFrame;
end;

procedure TBisDataForm.Init;
begin
  inherited Init;
  if Assigned(DataFrame) then
    DataFrame.Init;
end;

procedure TBisDataForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key,Shift);
end;

procedure TBisDataForm.DataFrameUpdateCounters(Sender: TBisDataFrame);
begin
  if Assigned(Sender) then
    StatusBar.Panels[0].Text:=Sender.LabelCounter.Caption;
end;

procedure TBisDataForm.DataFrameAfterOpenRecords(Sender: TBisDataFrame);
begin
  FLastLocated:=FDataFrame.LocateRecord(FLocateFields,FLocateValues);
  LoggerWrite(FormatEx(FSOpenRecordsTime,[Sender.Provider.Period]));
end;

procedure TBisDataForm.ActionCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TBisDataForm.ActionOkExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TBisDataForm.ActionOkUpdate(Sender: TObject);
begin
  ActionOk.Enabled:=Assigned(DataFrame) and DataFrame.CanSelect;
end;

function TBisDataForm.CanShow: Boolean;
begin
  Result:=inherited CanShow and
          Assigned(FDataFrame);
  if Result then begin
    if FFilterOnShow and Assigned(FDataFrame) and FDataFrame.CanFilterRecords and
       not Delayed and (VarIsNull(FLocateValues) or VarIsEmpty(FLocateValues)) then begin

      FDataFrame.AsModal:=true;
      FDataFrame.ShowType:=ShowType;

      FDataFrame.FilterRecords;
      Result:=FDataFrame.LastFiltered;
    end;
  end;
end;

procedure TBisDataForm.BeforeShow;
begin
  inherited BeforeShow;

  StatusBar.Visible:=not AsModal;
  PanelButton.Visible:=AsModal;
  FSizeGrip.Visible:=AsModal;

  if PanelButton.Visible then
    PanelButton.Top:=StatusBar.Top-PanelButton.Height+1;

  if Assigned(FDataFrame) then begin

    FDataFrame.BeforeShow;

    FDataFrame.AsModal:=AsModal;
    FDataFrame.ShowType:=ShowType;
    if ActionOk.Visible and ActionOk.Enabled then begin
      FDataFrame.ActionUpdate.ShortCut:=0;
    end;

    FDataFrame.Caption:=Caption;

    if not FDataFrame.LastFiltered then begin
      FDataFrame.OpenRecords;
    end;

  end;
end;

procedure TBisDataForm.AfterShow;
begin
  inherited AfterShow;
end;

function TBisDataForm.SelectInto(DataSet: TBisDataSet): Boolean;
begin
  Result:=ShowModal=mrOk;
  if Result and Assigned(FDataFrame) then begin
    Result:=FDataFrame.SelectInto(DataSet);
  end;
end;


end.
