unit BisMessMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, Menus, ActnPopup, ImgList, ExtCtrls, ComCtrls, Contnrs,
  StdCtrls,
  BisMainFm, BisFm, BisDataFm, BisDataFrm, BisDataGridFrm,
  BisProgressEvents, BisControls;

type
  TStatusBar=class(ComCtrls.TStatusBar)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessTabSheet=class(TTabSheet)
  private
    FDataFrame: TBisDataFrame;
  public
    procedure Activate;
    procedure Resize; override;
    procedure Reposition;
    procedure Init;

    property DataFrame: TBisDataFrame read FDataFrame write FDataFrame;
  end;

  TBisMessTabSheets=class(TObjectList)
  private
    FPageControl: TPageControl;
    function GetItem(Index: Integer): TBisMessTabSheet;
  public
    function CreateTabSheet(DataIface: TBisDataFormIface; Caption: String; OnlyDelete: Boolean=false): TBisMessTabSheet;
    procedure Reposition;
    procedure Init;

    property Items[Index: Integer]: TBisMessTabSheet read GetItem;
    property PageControl: TPageControl read FPageControl write FPageControl;
  end;

  TBisMessMainForm = class(TBisMainForm)
    PageControl: TPageControl;
    StatusBar: TStatusBar;
    ProgressBar: TProgressBar;
    ApplicationEvents: TApplicationEvents;
    ButtonAbout: TButton;
    procedure PageControlChange(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
  private
    FTabSheets: TBisMessTabSheets;
    FOldTabIndex: Integer;
    FProgressEvent: TBisProgressEvent;
    FInMessages: TBisDataFormIface;
    FOutMessages: TBisDataFormIface;
    FPatterns: TBisDataFormIface;
    FCodes: TBisDataFormIface;
    FAccounts: TBisDataFormIface;
    FRoles: TBisDataFormIface;
    procedure RePositionProgressBar;
    procedure InternalProgress(const Min, Max, Position: Integer; var Breaked: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

  TBisMessMainFormIface=class(TBisMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessMainForm: TBisMessMainForm;

implementation

uses BisCore, BisUtils, BisMessConsts, BisMessDataInMessagesFm, BisMessDataOutMessagesFm,
     BisMessDataPatternMessagesFm, BisMessDataCodeMessagesFm,
     BisMessDataAccountsFm, BisMessDataRolesFm;

{$R *.dfm}

{ TStatusBar }

constructor TStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csAcceptsControls];
end;

{ TBisMessTabSheet }

procedure TBisMessTabSheet.Activate;
begin
  if Assigned(FDataFrame) then
    FDataFrame.OpenRecords;
end;

procedure TBisMessTabSheet.Init;
begin
  if Assigned(FDataFrame) then begin
    FDataFrame.Init;
  end;
end;

procedure TBisMessTabSheet.Reposition;
begin
  if Assigned(FDataFrame) then begin
    FDataFrame.RepositionControlBarControls;
  end;
end;

procedure TBisMessTabSheet.Resize;
begin
  inherited Resize;
  if Assigned(FDataFrame) then begin
    FDataFrame.ResizeToolbars;
  end;
end;

{ TBisMessTabSheets }

function TBisMessTabSheets.CreateTabSheet(DataIface: TBisDataFormIface; Caption: String; OnlyDelete: Boolean=false): TBisMessTabSheet;
var
  DataFrame: TBisDataFrame;
  TabSheet: TBisMessTabSheet;
begin
  Result:=nil;
  if Assigned(DataIface) then begin
    TabSheet:=TBisMessTabSheet.Create(PageControl.Owner);
    TabSheet.PageControl:=PageControl;
    TabSheet.Caption:=Caption;
    TabSheet.Name:='TabSheet'+IntToStr(Count+1);
    DataFrame:=DataIface.CreateDataFrame(false);
    if Assigned(DataFrame) then begin
      DataFrame.Parent:=TabSheet;
      DataFrame.Align:=alClient;
      DataFrame.AsModal:=true;
//      DataFrame.ShowType:=stNormal;
      DataFrame.LabelCounter.Visible:=true;
      DataFrame.ActionExport.Visible:=false;
      DataFrame.ActionView.Visible:=false;
      if OnlyDelete then begin
        DataFrame.ActionInsert.Visible:=false;
        DataFrame.ActionDuplicate.Visible:=false;
        DataFrame.ActionUpdate.Visible:=false;
      end;
{      if DataFrame is TBisDataGridFrame then
        TBisDataGridFrame(DataFrame).Grid.AutoResizeableColumns:=true;    }
    end;
    TabSheet.DataFrame:=DataFrame;
    Result:=TabSheet;
    inherited Add(TabSheet);
  end;
end;

function TBisMessTabSheets.GetItem(Index: Integer): TBisMessTabSheet;
begin
  Result:=TBisMessTabSheet(inherited Items[Index]);
end;

procedure TBisMessTabSheets.Init;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].Init;
  end;
end;

procedure TBisMessTabSheets.Reposition;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].Reposition;
  end;
end;

{ TBisMessMainFormIface }

constructor TBisMessMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessMainForm;
end;

{ TBisMessMainForm }

constructor TBisMessMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SizesStored:=true;
  CloseToTray:=false;

  FProgressEvent:=Core.ProgressEvents.Add(InternalProgress);
  ProgressBar.Parent:=StatusBar;

  FTabSheets:=TBisMessTabSheets.Create;
  FTabSheets.PageControl:=PageControl;

  FInMessages:=TBisMessDataInMessagesFormIface.Create(Self);
  FInMessages.Permissions.Enabled:=false;
  FInMessages.Init;
  FTabSheets.CreateTabSheet(FInMessages,'��������',true);

  FOutMessages:=TBisMessDataOutMessagesFormIface.Create(Self);
  FOutMessages.Permissions.Enabled:=false;
  FOutMessages.Init;
  FTabSheets.CreateTabSheet(FOutMessages,'���������');

  FPatterns:=TBisMessDataPatternMessagesFormIface.Create(Self);
  FPatterns.Permissions.Enabled:=false;
  FPatterns.Init;
  FTabSheets.CreateTabSheet(FPatterns,'�������');

  FCodes:=TBisMessDataCodeMessagesFormIface.Create(Self);
  FCodes.Permissions.Enabled:=false;
  FCodes.Init;
  FTabSheets.CreateTabSheet(FCodes,'����');

  FAccounts:=TBisMessDataAccountsFormIface.Create(Self);
  FAccounts.Permissions.Enabled:=false;
  FAccounts.Init;
  FTabSheets.CreateTabSheet(FAccounts,'������� ������');

  FRoles:=TBisMessDataRolesFormIface.Create(Self);
  FRoles.Permissions.Enabled:=false;
  FRoles.Init;
  FTabSheets.CreateTabSheet(FRoles,'����');

  FOldTabIndex:=-1;
end;

destructor TBisMessMainForm.Destroy;
begin
  FRoles.Free;
  FAccounts.Free;
  FCodes.Free;
  FPatterns.Free;
  FOutMessages.Free;
  FInMessages.Free;
  FTabSheets.Free;
  Core.ProgressEvents.Remove(FProgressEvent);
  inherited Destroy;
end;

procedure TBisMessMainForm.Init;
begin
  inherited Init;
  FTabSheets.Init; 
end;

procedure TBisMessMainForm.FormShow(Sender: TObject);
begin
  PageControlChange(nil);
end;

procedure TBisMessMainForm.ApplicationEventsHint(Sender: TObject);
begin
  StatusBar.Panels[1].Text:=Application.Hint;
end;

procedure TBisMessMainForm.PageControlChange(Sender: TObject);
var
  TabIndex: Integer;
  TabSheet: TBisMessTabSheet;
begin
  if IsMainForm then begin
    TabIndex:=PageControl.TabIndex;
    if (TabIndex in [0..FTabSheets.Count-1]) and (TabIndex<>FOldTabIndex) then begin
      Update;
      if TabIndex>-1 then begin
        TabSheet:=FTabSheets.Items[TabIndex];
        TabSheet.Reposition;
        TabSheet.Resize;
        TabSheet.Activate;
      end else begin
        //
      end;
      FOldTabIndex:=TabIndex;
    end;
  end;
end;

procedure TBisMessMainForm.InternalProgress(const Min, Max, Position: Integer; var Breaked: Boolean);
begin
  if IsMainForm then begin
    ProgressBar.Visible:=iff(Position>0,true,false);
    ProgressBar.Min:=Min;
    ProgressBar.Max:=Max;
    ProgressBar.Position:=Position;
    RePositionProgressBar;
    ProgressBar.Update;
    Update;
  end;
end;

procedure TBisMessMainForm.RePositionProgressBar;
begin
  if ProgressBar.Visible then begin
    ProgressBar.Left:=1;
    ProgressBar.Width:=StatusBar.Panels.Items[0].Width-1;
    ProgressBar.Top:=2;
    ProgressBar.Height:=StatusBar.Height-2;
  end;
end;

procedure TBisMessMainForm.StatusBarResize(Sender: TObject);
begin
  RePositionProgressBar;
end;

procedure TBisMessMainForm.ButtonAboutClick(Sender: TObject);
begin
  About;
end;


end.
