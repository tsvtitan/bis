unit BisLotoTiragePrizesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  StdCtrls, ExtCtrls, Grids, DBGrids,

  BisDataGridFrm, BisDataEditFm;

type
  TBisLotoTiragePrizesFrame = class(TBisDataGridFrame)
  private
    FTirageId: Variant;
    FReadOnly: Boolean;
    FOnChange: TNotifyEvent;

    procedure DoChange;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;

    procedure DoAfterInsertRecord; override;
    procedure DoAfterUpdateRecord; override;
    procedure DoAfterDeleteRecord; override;

  public
    constructor Create(AOwner: TComponent); override;

    function CanInsertRecord: Boolean; override;
    function CanDuplicateRecord: Boolean; override;
    function CanUpdateRecord: Boolean; override;
    function CanDeleteRecord: Boolean; override;

    procedure Init; override;
    procedure OpenRecords; override;

    property TirageId: Variant read FTirageId write FTirageId;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;  
  end;

implementation

uses BisFilterGroups,
     BisLotoTiragePrizeEditFm;

{$R *.dfm}

{ TBisLotoTiragePrizesFrame }

constructor TBisLotoTiragePrizesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InsertClass:=TBisLotoTiragePrizeInsertFormIface;
  UpdateClass:=TBisLotoTiragePrizeUpdateFormIface;
  DeleteClass:=TBisLotoTiragePrizeDeleteFormIface;

  with Provider do begin
    ProviderName:='S_PRIZES';
    with FieldNames do begin
      AddKey('PRIZE_ID');
      Add('ROUND_NUM','Тур',30);
      Add('PRIORITY','Порядок',50);
      Add('NAME','Наименование',220);
      Add('COST','Стоимость',100);
    end;
    Orders.Add('ROUND_NUM');
    Orders.Add('PRIORITY');
  end;

end;

procedure TBisLotoTiragePrizesFrame.Init;
begin
  inherited Init;
end;

procedure TBisLotoTiragePrizesFrame.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TBisLotoTiragePrizesFrame.DoAfterDeleteRecord;
begin
  inherited DoAfterDeleteRecord;
  DoChange;
end;

procedure TBisLotoTiragePrizesFrame.DoAfterInsertRecord;
begin
  inherited DoAfterInsertRecord;
  DoChange;
end;

procedure TBisLotoTiragePrizesFrame.DoAfterUpdateRecord;
begin
  inherited DoAfterUpdateRecord;
  DoChange;
end;

function TBisLotoTiragePrizesFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord and not FReadOnly;
end;

function TBisLotoTiragePrizesFrame.CanDuplicateRecord: Boolean;
begin
  Result:=inherited CanDuplicateRecord and not FReadOnly;
end;

function TBisLotoTiragePrizesFrame.CanInsertRecord: Boolean;
begin
  Result:=inherited CanInsertRecord and not FReadOnly;
end;

function TBisLotoTiragePrizesFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord and not FReadOnly;
end;

procedure TBisLotoTiragePrizesFrame.OpenRecords;
begin
  Provider.FilterGroups.Clear;
  Provider.FilterGroups.Add.Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
  inherited OpenRecords;
end;

procedure TBisLotoTiragePrizesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) and (AIface is TBisLotoTiragePrizeEditFormIface) then begin
    AIface.Params.ParamByName('TIRAGE_ID').SetNewValue(FTirageId);
  end;
end;


end.
