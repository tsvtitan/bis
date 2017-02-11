unit BisConnectionModules;

interface

uses Classes, DB,
     BisObject, BisModules, BisConnections, BisDataSet,
     BisConnectionModuleIntf;

type
  TBisConnectionModule=class;

  TBisConnectionModuleInitProc=procedure (AModule: TBisConnectionModule); stdcall;

  TBisConnectionModule=class(TBisModule,IBisConnectionModule)
  private
    FInitProc: TBisConnectionModuleInitProc;
    FConnections: TBisConnections;
    FTable: TBisDataSet;
    FConnectionClass: TBisConnectionClass;
    procedure RefreshConnections;
    procedure SaveConnectionParams(Connection: TBisObject);
  protected
    procedure DoInitProc(AModule: TBisModule); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Unload; override;
    procedure Save; override;

    property Connections: TBisConnections read FConnections;
    property ConnectionClass: TBisConnectionClass read FConnectionClass write FConnectionClass;
  end;

  TBisConnectionModules=class(TBisModules)
  private
    function GetItem(Index: Integer): TBisConnectionModule;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    procedure Unload; override;
    function FindConnection(ObjectName: String): TBisConnection;
    function FindConnectionByCaption(Caption: String): TBisConnection;

    procedure CancelAll;

    property Items[Index: Integer]: TBisConnectionModule read GetItem;  default;
  end;

implementation

uses Windows, SysUtils,
     BisConsts, BisLogger, BisUtils;

{ TBisConnectionModule }

constructor TBisConnectionModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnections:=TBisConnections.Create(Self);
  FTable:=TBisDataSet.Create(Self);
end;

destructor TBisConnectionModule.Destroy;
begin
  FTable.Free;
  FConnections.Free;
  inherited Destroy;
end;

procedure TBisConnectionModule.Init;
var
  Stream: TMemoryStream;
  AModules: TBisConnectionModules;
  Field: TField;
begin
  inherited Init;
  if Assigned(Owner) and (Owner is TBisConnectionModules) then begin
    AModules:=TBisConnectionModules(Owner);
    FTable.Close;
    if AModules.Table.Active and not AModules.Table.IsEmpty then begin
      Stream:=TMemoryStream.Create;
      try
        Field:=AModules.Table.FindField(SFieldConnections);
        if Assigned(Field) and Field.IsBlob then begin
          TBlobField(Field).SaveToStream(Stream);
          Stream.Position:=0;
          if Stream.Size>0 then begin
            try
              FTable.LoadFromStream(Stream);
              FTable.Open;
            except
              on E: Exception do
                LoggerWrite(E.Message);
            end;
          end;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

procedure TBisConnectionModule.Save;
var
  Stream: TMemoryStream;
  AModules: TBisConnectionModules;
  Field: TField;
begin
  inherited Save;
  if Assigned(Owner) and (Owner is TBisConnectionModules) then begin
    AModules:=TBisConnectionModules(Owner);
    if FTable.Active and AModules.Table.Active and not AModules.Table.IsEmpty then begin
      Stream:=TMemoryStream.Create;
      try
        Field:=AModules.Table.FindField(SFieldConnections);
        if Assigned(Field) and Field.IsBlob then begin
          FTable.SaveToStream(Stream);
          Stream.Position:=0;
          TBlobField(Field).LoadFromStream(Stream);
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;


procedure TBisConnectionModule.RefreshConnections;
var
  Field: TField;
  AEnabled: Boolean;
  AConnection: TBisConnection;
  DS: TBisDataSet;
  AObjectName: String;
  Stream: TMemoryStream;
begin
  if FTable.Active and not FTable.IsEmpty then begin
    if Assigned(FConnectionClass) then begin
      FConnections.Clear;
      FTable.First;
      Field:=FTable.FindField(SFieldParams);
      while not FTable.Eof do begin
        AEnabled:=Boolean(FTable.FieldByName(SFieldEnabled).AsInteger);
        if AEnabled then begin
          AObjectName:=FTable.FieldByName(SFieldName).AsString+FConnectionClass.GetObjectName;
          AConnection:=FConnections.AddClass(FConnectionClass,AObjectName);
          if Assigned(AConnection) then begin
            AConnection.Module:=Self;
            AConnection.Caption:=FTable.FieldByName(SFieldCaption).AsString;
            AConnection.Description:=FTable.FieldByName(SFieldDescription).AsString;
            AConnection.Enabled:=AEnabled;
            if Assigned(Field) and Field.IsBlob then begin
              DS:=TBisDataSet.Create(nil);
              Stream:=TMemoryStream.Create;
              try
                TBlobField(Field).SaveToStream(Stream);
                Stream.Position:=0;
                DS.LoadFromStream(Stream);
                AConnection.Params.CopyFromDataSet(DS);
                AConnection.Params.Change;
              finally
                Stream.Free;
                DS.Free;
              end;
            end;
          end;
        end;
        FTable.Next;
      end;
    end;
  end;
end;

procedure TBisConnectionModule.SaveConnectionParams(Connection: TBisObject);
var
  AConnection: TBisConnection;
  AObjectName: String;
  Field: TField;
  DS: TBisDataSet;
  Stream: TMemoryStream;
  Saved: Boolean;
begin
  if Assigned(Connection) and (Connection is TBisConnection) then begin
    AConnection:=TBisConnection(Connection);
    if FTable.Active then begin

      Saved:=false;
      Field:=FTable.FindField(SFieldParams);
      FTable.First;
      while not FTable.Eof do begin
        AObjectName:=FTable.FieldByName(SFieldName).AsString+FConnectionClass.GetObjectName;
        if AnsiSameText(AObjectName,AConnection.ObjectName) and Assigned(Field) and Field.IsBlob then begin
          DS:=TBisDataSet.Create(nil);
          Stream:=TMemoryStream.Create;
          try
            TBlobField(Field).SaveToStream(Stream);
            Stream.Position:=0;
            DS.LoadFromStream(Stream);
            DS.EmptyTable;
            AConnection.Params.CopyToDataSet(DS);
            Stream.Position:=0;
            DS.SaveToStream(Stream);
            Stream.Position:=0;
            FTable.Edit;
            TBlobField(Field).LoadFromStream(Stream);
            FTable.Post;
            Saved:=true;
            break;
          finally
            Stream.Free;
            DS.Free;
          end;
        end;
        FTable.Next;
      end;

      if Saved then begin
        if Assigned(Owner) and (Owner is TBisConnectionModules) then begin
          TBisConnectionModules(Owner).SaveToLocalbase;
        end;
      end;

    end;
  end;
end;

procedure TBisConnectionModule.DoInitProc(AModule: TBisModule);
begin
  @FInitProc:=GetProcAddress(Module,PChar(SInitConnectionModule));
  if Assigned(@FInitProc) then begin
    try
      FInitProc(Self);
      RefreshConnections;
      FConnections.Init;
      LoggerWrite(FormatEx(SInitSuccess,[FileName]));
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SInitFailed,[FileName,E.Message]),ltError);
      end;
    end;
  end else begin
    LoggerWrite(FormatEx(SInitProcNotFound,[FileName]),ltError);
  end;
end;

procedure TBisConnectionModule.Unload;
begin
  FConnections.Clear;
  inherited Unload;
end;

{ TBisConnectionModules }

function TBisConnectionModules.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisConnectionModule;
end;

procedure TBisConnectionModules.Unload;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].Connections.Clear;
    Items[i].ConnectionClass:=nil;
  end;
  inherited Unload;
end;

procedure TBisConnectionModules.CancelAll;
var
  i: Integer;
  Module: TBisConnectionModule;
begin
  for i:=0 to Count-1 do begin
    Module:=Items[i];
    if Module.Enabled then
      Module.Connections.CancelAll;
  end;
end;

function TBisConnectionModules.FindConnection(ObjectName: String): TBisConnection;
var
  i: Integer;
  Module: TBisConnectionModule;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Module:=Items[i];
    if Module.Enabled then begin
      Result:=Module.Connections.Find(ObjectName);
      if Assigned(Result) then
        break;
    end;
  end;
end;

function TBisConnectionModules.FindConnectionByCaption(Caption: String): TBisConnection;
var
  i: Integer;
  Module: TBisConnectionModule;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Module:=Items[i];
    if Module.Enabled then begin
      Result:=Module.Connections.FindByCaption(Caption);
      if Assigned(Result) then
        break;
    end;
  end;
end;

function TBisConnectionModules.GetItem(Index: Integer): TBisConnectionModule;
begin
  Result:=TBisConnectionModule(inherited Items[Index]);
end;


end.
