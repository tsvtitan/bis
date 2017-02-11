unit BisTaxiDataZoneParksFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  VirtualTrees, VirtualDBTreeEx,
  BisFm, BisDataFrm, BisDataGridFm, BisFieldNames, BisFilterGroups, BisDataEditFm,
  BisProvider, BisDBTree, BisDataGridFrm;

type
  TBisTaxiDataZoneParksFrame=class(TBisDataGridFrame)
  private
    FZoneId: Variant;
    FZoneName: String;
    function GetNewParkName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    procedure FillProvider;
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
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
    Add('COST',ftFloat);
    Add('EXISTS',ftInteger);
    Add('NEW_PARK_NAME',ftString,350);
    Find('NEW_PARK_NAME').InternalCalcField:=true;
  end;
  with Provider.FieldNames do begin
    AddKey('PARK_ID');
    AddKey('ZONE_ID');
    AddInvisible('PARK_NAME');
    AddInvisible('PARK_DESCRIPTION');
    AddCalculate('NEW_PARK_NAME','�� �������',GetNewParkName,ftString,350,140);
    Add('DISTANCE','����������',70);
    Add('PERIOD','�����',60);
    Add('COST','���������',80).DisplayFormat:='#0.00';
    Add('EXISTS','�������������',10).Visible:=false;
  end;
  Provider.CreateTable();

  Grid.OnPaintText:=GridPaintText;

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

procedure TBisTaxiDataZoneParksFrame.FillProvider;
var
  P1: TBisProvider;
  P2: TBisProvider;
  Exists: Boolean;
  ParkId: Variant;
begin
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
    P1.Open;

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
    P2.Open;

    if P1.Active and not P1.IsEmpty and P2.Active then begin
      Provider.BeginUpdate;
      try
        Provider.EmptyTable;
        P1.First;
        while not P1.Eof do begin
          ParkId:=P1.FieldByName('PARK_ID').Value;
          Exists:=P2.Locate('PARK_ID',ParkId,[loCaseInsensitive]);

          Provider.Append;
          Provider.FieldByName('PARK_ID').Value:=ParkId;
          Provider.FieldByName('PARK_NAME').Value:=P1.FieldByName('NAME').Value;
          Provider.FieldByName('PARK_DESCRIPTION').Value:=P1.FieldByName('DESCRIPTION').Value;
          Provider.FieldByName('ZONE_ID').Value:=FZoneId;
          Provider.FieldByName('ZONE_NAME').Value:=FZoneName;
          if Exists then begin
            Provider.FieldByName('DISTANCE').Value:=P2.FieldByName('DISTANCE').Value;
            Provider.FieldByName('PERIOD').Value:=P2.FieldByName('PERIOD').Value;
            Provider.FieldByName('COST').Value:=P2.FieldByName('COST').Value;
          end;
          Provider.FieldByName('EXISTS').Value:=Integer(Exists);
          Provider.Post;

          P1.Next;
        end;
        Provider.First;
      finally
        Provider.EndUpdate;
      end;
    end;
  finally
    P1.Free;
  end;
end;

procedure TBisTaxiDataZoneParksFrame.OpenRecords;
begin
  inherited OpenRecords;
  FillProvider;
  DoUpdateCounters;
end;

procedure TBisTaxiDataZoneParksFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                   Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PBisDBTreeNode;
  Exists: Variant;
begin
  Data:=Grid.GetDBNodeData(Node);
  if Assigned(Data) and Assigned(Data.Values) then begin
    Exists:=Data.Values.GetValue('EXISTS');
    if not VarIsNull(Exists) then begin
      if Boolean(VarToIntDef(Exists,0)) then
        TargetCanvas.Font.Color:=clRed;
    end;
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
