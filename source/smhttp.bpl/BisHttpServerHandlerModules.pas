unit BisHttpServerHandlerModules;

interface

uses Classes,
     BisObject, BisModules, BisDataSet, BisHttpServerHandlers;

type
  TBisHttpServerHandlerModule=class;

  TBisHttpServerHandlerModuleInitProc=procedure (AModule: TBisHttpServerHandlerModule); stdcall;

  TBisHttpServerHandlerModule=class(TBisModule)
  private
    FInitProc: TBisHttpServerHandlerModuleInitProc;
    FTable: TBisDataSet;
    FHandlers: TBisHttpServerHandlers;
    FHandlerClass: TBisHttpServerHandlerClass;
    procedure RefreshHandlers;
  protected
    procedure DoInitProc(AModule: TBisModule); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Unload; override;
    procedure Init; override;

    property HandlerClass: TBisHttpServerHandlerClass read FHandlerClass write FHandlerClass;
    property Handlers: TBisHttpServerHandlers read FHandlers;
  end;

  TBisHttpServerHandlerModules=class(TBisModules)
  private
    function GetItem(Index: Integer): TBisHttpServerHandlerModule;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    function FindHandler(const Host, Document: String; var OutPath,OutScript: string): TBisHttpServerHandler;

    property Items[Index: Integer]: TBisHttpServerHandlerModule read GetItem; default;
  end;

implementation

uses Windows, SysUtils, DB,
     BisConsts, BisLogger, BisUtils, BisHttpServerConsts, BisCrypter;

{ TBisHttpServerHandlerModule }

constructor TBisHttpServerHandlerModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandlers:=TBisHttpServerHandlers.Create(Self);
  FTable:=TBisDataSet.Create(Self);

end;

destructor TBisHttpServerHandlerModule.Destroy;
begin
  FHandlers.Free;
  FTable.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerModule.Init;
var
  Stream: TMemoryStream;
  AModules: TBisHttpServerHandlerModules;
  Field: TField;
begin
  inherited Init;
  if Assigned(Owner) and (Owner is TBisHttpServerHandlerModules) then begin
    AModules:=TBisHttpServerHandlerModules(Owner);
    FTable.Close;
    if AModules.Table.Active and not AModules.Table.IsEmpty then begin
      Field:=AModules.Table.FindField(SFieldHandlers);
      if Assigned(Field) and Field.IsBlob then begin
        Stream:=TMemoryStream.Create;
        try
          TBlobField(Field).SaveToStream(Stream);
          Stream.Position:=0;
          FTable.LoadFromStream(Stream);
          FTable.Open;
        finally
          Stream.Free;
        end;
      end;
    end;
  end;
end;

procedure TBisHttpServerHandlerModule.RefreshHandlers;
var
  AHandler: TBisHttpServerHandler;
  AEnabled: Boolean;
  AObjectName: String;
  Field: TField;
begin
  if FTable.Active and not FTable.IsEmpty then begin
    if Assigned(FHandlerClass) then begin
      FHandlers.Clear;
      FTable.First;
      while not FTable.Eof do begin
        AEnabled:=Boolean(FTable.FieldByName(SFieldEnabled).AsInteger);
        if AEnabled then begin
          AObjectName:=FTable.FieldByName(SFieldName).AsString+FHandlerClass.GetObjectName;
          AHandler:=FHandlers.AddClass(FHandlerClass,AObjectName);
          if Assigned(AHandler) then begin
            AHandler.Description:=FTable.FieldByName(SFieldDescription).AsString;
            AHandler.Enabled:=AEnabled;
            Field:=FTable.FindField(SFieldParams);
            if Assigned(Field) and Field.IsBlob then begin
              AHandler.Params.CopyFromDataSet(Field.AsString);
            end;
          end;
        end;
        FTable.Next;
      end;
    end;
  end;
end;

procedure TBisHttpServerHandlerModule.DoInitProc(AModule: TBisModule);
begin
  @FInitProc:=GetProcAddress(Module,PChar(SInitHttpServerHandlerModule));
  if Assigned(@FInitProc) then begin
    try
      FInitProc(Self);
      RefreshHandlers;
      FHandlers.Init;
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

procedure TBisHttpServerHandlerModule.Unload;
begin
  FHandlers.Clear;
  inherited Unload;
end;

{ TBisHttpServerHandlerModules }

function TBisHttpServerHandlerModules.GetItem(Index: Integer): TBisHttpServerHandlerModule;
begin
  Result:=TBisHttpServerHandlerModule(inherited Items[Index]);
end;

function TBisHttpServerHandlerModules.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisHttpServerHandlerModule;
end;

function TBisHttpServerHandlerModules.FindHandler(const Host, Document: String; var OutPath, OutScript: string): TBisHttpServerHandler;
var
  i: Integer;
  Item: TBisHttpServerHandlerModule;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled then begin
      Result:=Item.Handlers.FindHandler(Host,Document,OutPath,OutScript);
      if Assigned(Result) then
        break;
    end;
  end;
end;


end.
