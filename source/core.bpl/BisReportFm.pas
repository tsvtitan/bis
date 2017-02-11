unit BisReportFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Contnrs,
  BisFm, 
  BisReportFrm;

type
  TBisReportForm = class(TBisForm)
    StatusBar: TStatusBar;
    PanelFrame: TPanel;
  private
    FReportFrameClass: TBisReportFrameClass;
    FReportFrame: TBisReportFrame;
  protected
    function GetReportFrameClass: TBisReportFrameClass; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function CanShow: Boolean; override;
    procedure BeforeShow; override;

    property ReportFrame: TBisReportFrame read FReportFrame;
  end;

  TBisReportFormIface=class(TBisFormIface)
  private
    FSPermissionUpdate: String;
    FReportId: Variant;
    FPattern: TComponent;
    FAsModal: Boolean;
    function GetLastForm: TBisReportForm;
    function CanRefreshReport(Sender: TBisReportFrame): Boolean;
    function CanEditPage(Sender: TBisReportFrame): Boolean;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeFormShow; override;
    procedure Execute; virtual;

    property LastForm: TBisReportForm read GetLastForm;

    property AsModal: Boolean read FAsModal write FAsModal;
    property ReportId: Variant read FReportId write FReportId;
    property Pattern: TComponent read FPattern write FPattern; 
  published
    property SPermissionUpdate: String read FSPermissionUpdate write FSPermissionUpdate;
  end;

  TBisReportFormIfaceClass=class of TBisReportFormIface;

  TBisReportFormIfaceClasses=class(TClassList)
  private
    function GetItem(Index: Integer): TBisReportFormIfaceClass;
    function GetFirstItem: TBisReportFormIfaceClass;
  public
    procedure InsertToFirst(Value: TBisReportFormIfaceClass);
    procedure CopyFrom(Source: TBisReportFormIfaceClasses; WithClear: Boolean=true);

    property Items[Index: Integer]: TBisReportFormIfaceClass read GetItem;
    property FirstItem: TBisReportFormIfaceClass read GetFirstItem;
  end;
  
var
  BisReportForm: TBisReportForm;

implementation

{$R *.dfm}

uses BisUtils, BisCore;

{ TBisReportFormIfaceClasses }

procedure TBisReportFormIfaceClasses.CopyFrom(Source: TBisReportFormIfaceClasses; WithClear: Boolean);
begin
  if WithClear then
    Clear;
  Assign(Source);
end;

function TBisReportFormIfaceClasses.GetFirstItem: TBisReportFormIfaceClass;
begin
  Result:=nil;
  if Count>0 then
    Result:=Items[0];
end;

function TBisReportFormIfaceClasses.GetItem(Index: Integer): TBisReportFormIfaceClass;
begin
  Result:=TBisReportFormIfaceClass(inherited Items[Index]);
end;

procedure TBisReportFormIfaceClasses.InsertToFirst(Value: TBisReportFormIfaceClass);
begin
  Insert(0,Value);
end;

{ TBisReportFormIface }

constructor TBisReportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisReportForm;
  OnlyOneForm:=false;
  ChangeFormCaption:=true;
  ShowType:=stMdiChild;
  Permissions.Enabled:=true;
  FReportId:=Null;
  FSPermissionUpdate:='Θημενενθε';
end;

destructor TBisReportFormIface.Destroy;
begin
  inherited Destroy;
end;

procedure TBisReportFormIface.Execute;
begin
  if FAsModal then begin
    ShowModal;
  end else begin
    if Core.EditIfaceAsModal then
      ShowModal
    else
      Show;
  end;
end;

function TBisReportFormIface.GetLastForm: TBisReportForm;
begin
  Result:=TBisReportForm(inherited LastForm);
end;

procedure TBisReportFormIface.Init;
begin
  inherited Init;
  Permissions.AddDefault(FSPermissionUpdate);
end;

function TBisReportFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    with LastForm do begin
      if Assigned(ReportFrame) then begin
        ReportFrame.OnCanRefreshReport:=CanRefreshReport;
        ReportFrame.OnCanEditPage:=CanEditPage;
      end;
    end;
  end;
end;

procedure TBisReportFormIface.BeforeFormShow;
begin
  inherited BeforeFormShow;
  if Assigned(LastForm) then begin
    with LastForm do begin
      if Assigned(ReportFrame) then begin
        ReportFrame.Caption:=Caption;
        ReportFrame.ReportId:=FReportId;
        ReportFrame.Pattern:=FPattern;
      end;
    end;
  end;
end;

function TBisReportFormIface.CanRefreshReport(Sender: TBisReportFrame): Boolean;
begin
  Result:=Permissions.Exists(SPermissionShow);
end;

function TBisReportFormIface.CanEditPage(Sender: TBisReportFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionUpdate);
end;

{ TBisReportForm }

constructor TBisReportForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;
  FReportFrameClass:=GetReportFrameClass;
  if Assigned(FReportFrameClass) then begin
    FReportFrame:=FReportFrameClass.Create(Self);
    FReportFrame.Parent:=PanelFrame;
    FReportFrame.Align:=alClient;
  end;
end;

destructor TBisReportForm.Destroy;
begin
  FreeAndNilEx(FReportFrame);
  inherited Destroy;
end;

function TBisReportForm.GetReportFrameClass: TBisReportFrameClass;
begin
  Result:=TBisReportFrame;
end;

procedure TBisReportForm.Init;
begin
  inherited Init;
  if Assigned(FReportFrame) then begin
    FReportFrame.Init;
  end;
end;

function TBisReportForm.CanShow: Boolean;
begin
  Result:=inherited CanShow and
          Assigned(FReportFrame);
  if Result and not Visible then begin
    FReportFrame.OpenReport;
    Result:=FReportFrame.ReportPrepared;
  end;

end;

procedure TBisReportForm.BeforeShow;
begin
  inherited BeforeShow;
{  if Assigned(FReportFrame) then begin
    FReportFrame.OpenReport;
  end;}
end;

end.
