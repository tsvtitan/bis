unit BisKrieltPresentationFrm;
                                                                                       
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls,

  BisDataGridFrm, BisDataEditFm;

type
  TBisKrieltPresentationFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    ToolButtonRefreshCurrent: TToolButton;
    ActionRefreshCurrent: TAction;
    N13: TMenuItem;
    procedure ActionRefreshCurrentUpdate(Sender: TObject);
    procedure ActionRefreshCurrentExecute(Sender: TObject);
  private
    FPresentationId: Variant;
    FPresentationName: String;
    FTableName: String;
  protected
    function CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface; override;
  public
    constructor Create(AOwner: TComponent); override;
    property PresentationId: Variant read FPresentationId write FPresentationId;
    property PresentationName: String read FPresentationName write FPresentationName;
    property TableName: String read FTableName write FTableName;

  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisKrieltPresentationEditFm;

{$R *.dfm}

{ TBisKrieltPresentationFrame }

constructor TBisKrieltPresentationFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltPresentationFrame.ActionRefreshCurrentExecute(
  Sender: TObject);
var
  P: TBisProvider;
  DS: TBisProvider;
  OldCursor: TCursor;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) and DS.Active then begin
    OldCursor:=Screen.Cursor;
    P:=TBisProvider.Create(nil);
    try
      Screen.Cursor:=crHourGlass;
      P.WithWaitCursor:=false;
      P.ProviderName:='R_PRESENTATION';
      P.Params.AddInvisible('PRESENTATION_ID').Value:=PresentationId;
      P.Execute;
      if P.Success then begin
        OpenRecords;
        ShowInfo(FormatEx('�������������: %s ������� ���������.',[PresentationName]));
      end;
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisKrieltPresentationFrame.ActionRefreshCurrentUpdate(
  Sender: TObject);
begin
  ActionRefreshCurrent.Enabled:=Trim(FPresentationId)<>'';
end;

function TBisKrieltPresentationFrame.CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface;
begin
  Result:=inherited CreateIface(AClass);
  if Assigned(Result) and (Result is TBisKrieltPresentationEditFormIface) then begin
    TBisKrieltPresentationEditFormIface(Result).PresentationId:=FPresentationId;
    TBisKrieltPresentationEditFormIface(Result).TableName:=FTableName;
  end;
end;

end.