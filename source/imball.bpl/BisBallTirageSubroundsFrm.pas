unit BisBallTirageSubroundsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  StdCtrls, ExtCtrls, Grids, DBGrids,

  BisDataGridFrm, BisDataEditFm;

type
  TBisBallTirageSubroundsFrame = class(TBisDataGridFrame)
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
     BisBallTirageSubroundEditFm;

{$R *.dfm}

{ TBisBallTirageSubroundsFrame }

constructor TBisBallTirageSubroundsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InsertClass:=TBisBallTirageSubroundInsertFormIface;
  UpdateClass:=TBisBallTirageSubroundUpdateFormIface;
  DeleteClass:=TBisBallTirageSubroundDeleteFormIface;

  with Provider do begin
    ProviderName:='S_SUBROUNDS';
    with FieldNames do begin
      AddKey('SUBROUND_ID');
      Add('NAME','Наименование',220);
      Add('PERCENT','Процент',50);
      Add('ROUND_NUM','Тур',30).Visible:=false;
      Add('PRIORITY','Порядок',50).Visible:=false;
    end;
    Orders.Add('ROUND_NUM');
    Orders.Add('PRIORITY');
  end;

end;

procedure TBisBallTirageSubroundsFrame.Init;
begin
  inherited Init;
end;

procedure TBisBallTirageSubroundsFrame.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TBisBallTirageSubroundsFrame.DoAfterDeleteRecord;
begin
  inherited DoAfterDeleteRecord;
  DoChange;
end;

procedure TBisBallTirageSubroundsFrame.DoAfterInsertRecord;
begin
  inherited DoAfterInsertRecord;
  DoChange;
end;

procedure TBisBallTirageSubroundsFrame.DoAfterUpdateRecord;
begin
  inherited DoAfterUpdateRecord;
  DoChange;
end;

function TBisBallTirageSubroundsFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord and not FReadOnly;
end;

function TBisBallTirageSubroundsFrame.CanDuplicateRecord: Boolean;
begin
  Result:=inherited CanDuplicateRecord and not FReadOnly;
end;

function TBisBallTirageSubroundsFrame.CanInsertRecord: Boolean;
begin
  Result:=inherited CanInsertRecord and not FReadOnly;
end;

function TBisBallTirageSubroundsFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord and not FReadOnly;
end;

procedure TBisBallTirageSubroundsFrame.OpenRecords;
begin
  Provider.FilterGroups.Clear;
  Provider.FilterGroups.Add.Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
  inherited OpenRecords;
end;

procedure TBisBallTirageSubroundsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) and (AIface is TBisBallTirageSubroundEditFormIface) then begin
    AIface.Params.ParamByName('TIRAGE_ID').SetNewValue(FTirageId);
  end;
end;


end.
