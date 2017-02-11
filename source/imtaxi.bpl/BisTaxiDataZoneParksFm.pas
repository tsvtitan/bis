unit BisTaxiDataZoneParksFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  VirtualTrees, 
  BisFm, BisDataFrm, BisDataGridFm, BisFieldNames, BisFilterGroups, BisDataEditFm,
  BisProvider, BisDBTree, BisDataGridFrm, BisDataSet;

type
  TBisTaxiDataZoneParksFrame=class(TBisDataGridFrame)
  private
    FZoneId: Variant;
    FZoneName: String;
    FParks: TBisDataSetCollectionItem;
    FZoneParks: TBisDataSetCollectionItem;
    procedure RefreshProvider(Parks,ZoneParks: TBisDataSet);
    function GetNewParkName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    procedure DoBeforeOpenRecords; override;
    procedure DoAfterOpenRecords; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;

    property ZoneId: Variant read FZoneId write FZoneId;
    property ZoneName: String read FZoneName write FZoneName;
  end;

  TBisTaxiDataZoneParksForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataZoneParksFormIface=class(TBisDataGridFormIface)
  private
    FZoneId: Variant;
    FZoneName: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ZoneId: Variant read FZoneId write FZoneId;
    property ZoneName: String read FZoneName write FZoneName;
  end;

var
  BisTaxiDataZoneParksForm: TBisTaxiDataZoneParksForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisOrders, BisCore, BisDialogs, BisTaxiDataZoneParkEditFm;

{ TBisTaxiDataZoneParksFrame }

constructor TBisTaxiDataZoneParksFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UpdateClass:=TBisTaxiDataZoneParkUpdateFormIface;
  DeleteClass:=TBisTaxiDataZoneParkDeleteFormIface;

  with Provider.FieldDefs do begin
    Add('PARK_ID',ftString,32);
    Add('ZONE_ID',ftString,32);
    Add('PARK_NAME',ftString,100);
    Add('PARK_DESCRIPTION',ftString,250);
    Add('ZONE_NAME',ftString,100);
    Add('DISTANCE',ftInteger);
    Add('PERIOD',ftInteger);
    Add('COST',ftBCD,2);
    Find('COST').Precision:=15;
    Add('EXISTS',ftInteger);
    Add('NEW_PARK_NAME',ftString,350);
    Find('NEW_PARK_NAME').InternalCalcField:=true;
  end;
  with Provider.FieldNames do begin
    AddKey('PARK_ID');
    AddKey('ZONE_ID');
    AddInvisible('PARK_NAME');
    AddInvisible('PARK_DESCRIPTION');
    AddCalculate('NEW_PARK_NAME','От стоянки',GetNewParkName,ftString,350,140);
    Add('DISTANCE','Расстояние',70);
    Add('PERIOD','Время',60);
    Add('COST','Стоимость',80).DisplayFormat:='#0.00';
    Add('EXISTS','Существование',10).Visible:=false;
  end;
  Provider.CreateTable();

  Grid.OnPaintText:=GridPaintText;

  FParks:=nil;
  FZoneParks:=nil;

  ActionFilter.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
end;

function TBisTaxiDataZoneParksFrame.GetNewParkName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
begin
  Result:=null;
  if DataSet.Active then begin
    Result:=FormatEx('%s - %s',[DataSet.FieldByName('PARK_NAME').AsString,DataSet.FieldByName('PARK_DESCRIPTION').AsString]);
  end;
end;

procedure TBisTaxiDataZoneParksFrame.DoBeforeOpenRecords;
var
  P1: TBisProvider;
  P2: TBisProvider;
begin
  inherited DoBeforeOpenRecords;

  Provider.CollectionAfter.Clear;

  FParks:=nil;
  FZoneParks:=nil;

  if not VarIsNull(FZoneId) then begin
    P1:=TBisProvider.Create(nil);
    P2:=TBisProvider.Create(nil);
    try

      P1.ProviderName:='S_PARKS';
      with P1.FieldNames do begin
        AddInvisible('PARK_ID');
        AddInvisible('NAME');
        AddInvisible('DESCRIPTION');
      end;
      P1.Orders.Add('PRIORITY');

      P2.ProviderName:='S_ZONE_PARKS';
      with P2.FieldNames do begin
        AddInvisible('PARK_ID');
        AddInvisible('PARK_NAME');
        AddInvisible('PARK_DESCRIPTION');
        AddInvisible('DISTANCE');
        AddInvisible('PERIOD');
        AddInvisible('COST');
      end;
      P2.FilterGroups.Add.Filters.Add('ZONE_ID',fcEqual,FZoneId);

      FParks:=Provider.CollectionAfter.AddDataSet(P1);
      FZoneParks:=Provider.CollectionAfter.AddDataSet(P2);

    finally
      P1.Free;
      P2.Free;
    end;
  end;

end;

procedure TBisTaxiDataZoneParksFrame.RefreshProvider(Parks,ZoneParks: TBisDataSet);
var
  Exists: Boolean;
  ParkId: Variant;
begin
  if Parks.Active and not Parks.IsEmpty and ZoneParks.Active then begin
    Provider.BeginUpdate;
    try
      Provider.EmptyTable;
      Parks.First;
      while not Parks.Eof do begin
        ParkId:=Parks.FieldByName('PARK_ID').Value;
        Exists:=ZoneParks.Locate('PARK_ID',ParkId,[loCaseInsensitive]);

        Provider.Append;
        Provider.FieldByName('PARK_ID').Value:=ParkId;
        Provider.FieldByName('PARK_NAME').Value:=Parks.FieldByName('NAME').Value;
        Provider.FieldByName('PARK_DESCRIPTION').Value:=Parks.FieldByName('DESCRIPTION').Value;
        Provider.FieldByName('ZONE_ID').Value:=FZoneId;
        Provider.FieldByName('ZONE_NAME').Value:=FZoneName;
        if Exists then begin
          Provider.FieldByName('DISTANCE').Value:=ZoneParks.FieldByName('DISTANCE').Value;
          Provider.FieldByName('PERIOD').Value:=ZoneParks.FieldByName('PERIOD').Value;
          Provider.FieldByName('COST').Value:=ZoneParks.FieldByName('COST').Value;
        end;
        Provider.FieldByName('EXISTS').Value:=Integer(Exists);
        Provider.Post;

        Parks.Next;
      end;
    finally
      Provider.EndUpdate;
    end;
  end;
end;

procedure TBisTaxiDataZoneParksFrame.DoAfterOpenRecords;
var
  D1,D2: TBisDataset;
begin
  if Assigned(FParks) and Assigned(FZoneParks) then begin
    D1:=TBisDataset.Create(nil);
    D2:=TBisDataset.Create(nil);
    try
      if FParks.GetDataSet(D1) and FZoneParks.GetDataSet(D2) then begin
        Provider.Close;
        Provider.CreateTable;
        RefreshProvider(D1,D2);
      end;
    finally
      D2.Free;
      D1.Free;
    end;
  end;
  inherited DoAfterOpenRecords;
end;

procedure TBisTaxiDataZoneParksFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

procedure TBisTaxiDataZoneParksFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                   Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Exists: Variant;
begin
  Exists:=Grid.GetNodeValue(Node,'EXISTS');
  if not VarIsNull(Exists) then begin
    if Boolean(VarToIntDef(Exists,0)) then
      TargetCanvas.Font.Color:=clRed;
  end;
end;

{ TBisTaxiDataZoneParksFormIface }

constructor TBisTaxiDataZoneParksFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataZoneParksForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

function TBisTaxiDataZoneParksFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisTaxiDataZoneParksForm(Result) do begin
      TBisTaxiDataZoneParksFrame(DataFrame).ZoneId:=FZoneId;
      TBisTaxiDataZoneParksFrame(DataFrame).ZoneName:=FZoneName;
    end;
  end;
end;

{ TBisTaxiDataZoneParksForm }

class function TBisTaxiDataZoneParksForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataZoneParksFrame;
end;

end.
