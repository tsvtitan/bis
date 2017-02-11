unit BisDBHexEdit;

interface

uses Classes, DB, DBCtrls, Windows,
     BisHexEdit;

type

  TBisDBHexEdit=class(TBisHexEdit)
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
    procedure LoadHex;
    procedure HexKeyPress(Sender: TObject; var Key: Char);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Changed; override;
    procedure Loaded; override;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Field: TField read GetField;
  end;

implementation

uses MPHexEditor;

{ TBisDBHexEdit }

constructor TBisDBHexEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink:=TFieldDataLink.Create;
  FDataLink.Control:=Self;
  FDataLink.OnDataChange:=DataChange;
  FDataLink.OnEditingChange:=EditingChange;
  FDataLink.OnUpdateData:=UpdateData;
  OnKeyPress:=HexKeyPress;
end;

destructor TBisDBHexEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TBisDBHexEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource)
  then
    DataSource:=nil;
end;

function TBisDBHexEdit.GetDataField: string;
begin
  Result:=FDataLink.FieldName;
end;

function TBisDBHexEdit.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource;
end;

function TBisDBHexEdit.GetField: TField;
begin
  Result:=FDataLink.Field;
end;

procedure TBisDBHexEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName:=Value;
end;

procedure TBisDBHexEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource:=Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TBisDBHexEdit.LoadHex;
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
    Modified:=false;
    UndoStorage.Clear;
  except
  end;
  EditingChange(Self);
end;

procedure TBisDBHexEdit.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then begin
    if FBeginEdit then
    begin
      FBeginEdit:=False;
      Exit;
    end;
    if FDataLink.Field.IsBlob then
      LoadHex
    else
  end else begin
    if csDesigning in ComponentState then
      Text:=Name
    else
      Text:='';
  end;
end;

procedure TBisDBHexEdit.EditingChange(Sender: TObject);
begin
  if FDataLink.Editing then begin
    if Assigned(FDataLink.DataSource)
      and (FDataLink.DataSource.State <> dsInsert)
    then
      FBeginEdit:=True;
  end;
end;

procedure TBisDBHexEdit.UpdateData(Sender: TObject);
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

procedure TBisDBHexEdit.Changed;
begin
  FDataLink.Modified;
  inherited;
end;

procedure TBisDBHexEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TBisDBHexEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key,Shift);
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;
end;

procedure TBisDBHexEdit.HexKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) then
  begin
    Key := #0;
  end;
  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;
end;


end.
