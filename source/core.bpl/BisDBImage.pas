unit BisDBImage;

interface

uses Windows, Classes, DB, DBCtrls, ExtCtrls;

type

  TBisDBImage=class(TImage)
  private
    FDataLink: TFieldDataLink;
    FBeginEdit: boolean;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure LoadImage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Field: TField read GetField;
  end;

implementation

uses BisPicture;

{ TBisDBImage }

constructor TBisDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink:=TFieldDataLink.Create;
  FDataLink.Control:=Self;
  FDataLink.OnDataChange:=DataChange;
  FDataLink.OnEditingChange:=EditingChange;
  FDataLink.OnUpdateData:=UpdateData;
end;

destructor TBisDBImage.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TBisDBImage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource)
  then
    DataSource:=nil;
end;

function TBisDBImage.GetDataField: string;
begin
  Result:=FDataLink.FieldName;
end;

function TBisDBImage.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource;
end;

function TBisDBImage.GetField: TField;
begin
  Result:=FDataLink.Field;
end;

procedure TBisDBImage.SetDataField(const Value: string);
begin
  FDataLink.FieldName:=Value;
end;

procedure TBisDBImage.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource:=Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TBisDBImage.LoadFromStream(Stream: TStream);
var
  FPicture: TBisPicture;
begin
  FPicture:=TBisPicture.Create;
  try
    FPicture.LoadFromStream(Stream);
    Picture.Assign(FPicture);
  finally
    FPicture.Free;
  end;
end;

procedure TBisDBImage.SaveToStream(Stream: TStream);
var
  FPicture: TBisPicture;
begin
  FPicture:=TBisPicture.Create;
  try
    FPicture.Assign(Picture);
    FPicture.SaveToStream(Stream);
  finally
    FPicture.Free;
  end;
end;

procedure TBisDBImage.LoadImage;
var
  BlobStream: TStream;
begin
  try
    BlobStream:=FDataLink.DataSet.CreateBlobStream(FDataLink.Field, bmRead);
    try
      LoadFromStream(BlobStream);
    finally
      BlobStream.Free;
    end;
  except
  end;
  EditingChange(Self);
end;

procedure TBisDBImage.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then begin
    if FBeginEdit then
    begin
      FBeginEdit:=False;
      Exit;
    end;
    if FDataLink.Field.IsBlob then
      LoadImage
    else
  end else begin
    if csDesigning in ComponentState then
      Text:=Name
    else
      Text:='';
  end;
end;

procedure TBisDBImage.EditingChange(Sender: TObject);
begin
  if FDataLink.Editing then begin
    if Assigned(FDataLink.DataSource)
      and (FDataLink.DataSource.State <> dsInsert)
    then
      FBeginEdit:=True;
  end;
end;

procedure TBisDBImage.UpdateData(Sender: TObject);
var
  BlobStream: TStream;
begin
  if FDataLink.Field.IsBlob then begin
    BlobStream:=FDataLink.DataSet.CreateBlobStream(FDataLink.Field,bmWrite);
    try
      SaveToStream(BlobStream);
    finally
      BlobStream.Free;
    end;
  end;  
end;

procedure TBisDBImage.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

end.
