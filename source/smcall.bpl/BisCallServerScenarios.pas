unit BisCallServerScenarios;

interface

uses Classes,
     BisDataSet, BisDataParams,
     BisAudioWave;

type

  TBisCallServerScenarioMenus=class;

  TBisCallServerScenarioMenuType=(sctMenu,sctCode,sctDial,sctReturn);
  TBisCallServerScenarioMenuEnd=(sceNothing,sceHangup,sceStep);

  TBisCallServerScenarioMenu=class(TBisDataValueParam)
  private
    FMenus: TBisCallServerScenarioMenus;
    FMenuType: TBisCallServerScenarioMenuType;
    FMenuEnd: TBisCallServerScenarioMenuEnd;
    FBefore: String;
    FAfter: String;
    FTimeout: Cardinal;
  protected
    procedure SetDataSet(DataSet: TBisDataSet); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisDataParam); override;

    property Menus: TBisCallServerScenarioMenus read FMenus;
    property MenuType: TBisCallServerScenarioMenuType read FMenuType;
    property MenuEnd: TBisCallServerScenarioMenuEnd read FMenuEnd;
    property Before: String read FBefore;
    property After: String read FAfter;
    property Timeout: Cardinal read FTimeout;
  end;

  TBisCallServerScenarioMenus=class(TBisDataValueParams)
  private
    FWave: TBisAudioWave;
    function GetItem(Index: Integer): TBisCallServerScenarioMenu;
  protected
    class function GetDataParamClass: TBisDataParamClass; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisDataParams); override;
    function Find(const Name: String): TBisCallServerScenarioMenu; reintroduce;
    function LockFind(const Name: String): TBisCallServerScenarioMenu;

    property Items[Index: Integer]: TBisCallServerScenarioMenu read GetItem; default;
    property Wave: TBisAudioWave read FWave;
  end;

  TBisCallServerScenarioStepType=(sstText,sstAudio,sstRepeat,sstHoldMusic);

  TBisCallServerScenarioStep=class(TBisDataValueParam)
  private
    FStepType: TBisCallServerScenarioStepType;
    FWave: TBisAudioWave;
    FTimeout: Cardinal;
  protected
    procedure SetDataSet(DataSet: TBisDataSet); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisDataParam); override;

    property StepType: TBisCallServerScenarioStepType read FStepType;
    property Timeout: Cardinal read FTimeout;
    property Wave: TBisAudioWave read FWave;
  end;

  TBisCallServerScenarioSteps=class(TBisDataValueParams)
  private
    function GetItem(Index: Integer): TBisCallServerScenarioStep;
  protected
    class function GetDataParamClass: TBisDataParamClass; override;
  public
    function Next(From: TBisCallServerScenarioStep): TBisCallServerScenarioStep;
    function LockNext(From: TBisCallServerScenarioStep): TBisCallServerScenarioStep;
    function First: TBisCallServerScenarioStep;
    function LockFirst: TBisCallServerScenarioStep;
    function Find(const Name: String): TBisCallServerScenarioStep; reintroduce;
    function LockFind(const Name: String): TBisCallServerScenarioStep;

    property Items[Index: Integer]: TBisCallServerScenarioStep read GetItem; default;
  end;

  TBisCallServerScenarioParams=class(TBisDataValueParams)
  public
    constructor Create; override;
    destructor Destroy; override;

    function GetHoldMusic(Wave: TBisAudioWave): Boolean;
    function MainMenuText: String;
    function MainMenuTimeout: Cardinal;
    function MessageTimeout: Cardinal;

  end;

  TBisCallServerScenario=class(TBisDataParam)
  private
    FSteps: TBisCallServerScenarioSteps;
    FMenus: TBisCallServerScenarioMenus;
    FParams: TBisCallServerScenarioParams;
  protected
    procedure SetDataSet(DataSet: TBisDataSet); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisDataParam); override;

    property Steps: TBisCallServerScenarioSteps read FSteps;
    property Menus: TBisCallServerScenarioMenus read FMenus;
    property Params: TBisCallServerScenarioParams read FParams;
  end;

  TBisCallServerScenarios=class(TBisDataParams)
  private
    function GetItem(Index: Integer): TBisCallServerScenario;
  protected
    class function GetDataParamClass: TBisDataParamClass; override;
  public
    function FindDefault(const Name: String): TBisCallServerScenario;
    property Items[Index: Integer]: TBisCallServerScenario read GetItem; default;
  end;


implementation

uses DB,
     BisConsts, BisCallServerConsts;

{ TBisCallServerScenarioMenu }

constructor TBisCallServerScenarioMenu.Create;
begin
  inherited Create;
  FMenus:=TBisCallServerScenarioMenus.Create;
  FTimeout:=0;
end;

destructor TBisCallServerScenarioMenu.Destroy;
begin
  FMenus.Free;
  inherited Destroy;
end;

procedure TBisCallServerScenarioMenu.SetDataSet(DataSet: TBisDataSet);
var
  Field: TField;
begin
  inherited SetDataSet(DataSet);

  FMenuType:=sctMenu;
  Field:=DataSet.FindField(SFieldType);
  if Assigned(Field) then
    FMenuType:=TBisCallServerScenarioMenuType(Field.AsInteger);

  FMenuEnd:=sceNothing;
  Field:=DataSet.FindField(SFieldEnd);
  if Assigned(Field) then
    FMenuEnd:=TBisCallServerScenarioMenuEnd(Field.AsInteger);

  FTimeout:=0;
  Field:=DataSet.FindField(SFieldTimeout);
  if Assigned(Field) then
    FTimeout:=Field.AsInteger;

  FBefore:='';
  Field:=DataSet.FindField(SFieldBefore);
  if Assigned(Field) then
    FBefore:=Field.AsString;

  FAfter:='';
  Field:=DataSet.FindField(SFieldAfter);
  if Assigned(Field) then
    FAfter:=Field.AsString;

  FMenus.Clear;
  if FMenuType=sctMenu then
    FMenus.CopyFromDataSet(AsString);

end;

procedure TBisCallServerScenarioMenu.CopyFrom(Source: TBisDataParam);
var
  ASource: TBisCallServerScenarioMenu;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisCallServerScenarioMenu) then begin
    ASource:=TBisCallServerScenarioMenu(Source);
    FBefore:=ASource.Before;
    FAfter:=ASource.After;
    FTimeout:=ASource.Timeout;
    FMenuType:=ASource.MenuType;
    FMenuEnd:=ASource.MenuEnd;
    FMenus.CopyFrom(ASource.Menus);
  end;
end;

{ TBisCallServerScenarioMenus }

constructor TBisCallServerScenarioMenus.Create;
begin
  inherited Create;
  FWave:=TBisAudioWave.Create;
end;

destructor TBisCallServerScenarioMenus.Destroy;
begin
  FWave.Free;
  inherited Destroy;
end;

class function TBisCallServerScenarioMenus.GetDataParamClass: TBisDataParamClass;
begin
  Result:=TBisCallServerScenarioMenu;
end;

function TBisCallServerScenarioMenus.GetItem(Index: Integer): TBisCallServerScenarioMenu;
begin
  Result:=TBisCallServerScenarioMenu(inherited Items[Index]);
end;

procedure TBisCallServerScenarioMenus.CopyFrom(Source: TBisDataParams);
var
  ASource: TBisCallServerScenarioMenus;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisCallServerScenarioMenus) then begin
    ASource:=TBisCallServerScenarioMenus(Source);
    FWave.Assign(ASource.Wave);
  end;

end;

function TBisCallServerScenarioMenus.Find(const Name: String): TBisCallServerScenarioMenu;
begin
  Result:=TBisCallServerScenarioMenu(inherited Find(Name));
end;

function TBisCallServerScenarioMenus.LockFind(const Name: String): TBisCallServerScenarioMenu;
begin
  Lock;
  try
    Result:=Find(Name); 
  finally
    UnLock;
  end;
end;

{ TBisCallServerScenarioStep }

constructor TBisCallServerScenarioStep.Create;
begin
  inherited Create;
  FWave:=TBisAudioWave.Create;
  FTimeout:=0;
end;

destructor TBisCallServerScenarioStep.Destroy;
begin
  FWave.Free;
  inherited Destroy;
end;

procedure TBisCallServerScenarioStep.SetDataSet(DataSet: TBisDataSet);
var
  Field: TField;
begin
  inherited SetDataSet(DataSet);

  FStepType:=sstText;
  Field:=DataSet.FindField(SFieldType);
  if Assigned(Field) then
    FStepType:=TBisCallServerScenarioStepType(Field.AsInteger);

  FTimeout:=0;
  Field:=DataSet.FindField(SFieldTimeout);
  if Assigned(Field) then
    FTimeout:=Field.AsInteger;
     
end;

procedure TBisCallServerScenarioStep.CopyFrom(Source: TBisDataParam);
var
  ASource: TBisCallServerScenarioStep;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisCallServerScenarioStep) then begin
    ASource:=TBisCallServerScenarioStep(Source);
    FStepType:=ASource.StepType;
    FTimeout:=ASource.Timeout;
  end;
end;

{ TBisCallServerScenarioSteps }

class function TBisCallServerScenarioSteps.GetDataParamClass: TBisDataParamClass;
begin
  Result:=TBisCallServerScenarioStep;
end;

function TBisCallServerScenarioSteps.GetItem(Index: Integer): TBisCallServerScenarioStep;
begin
  Result:=TBisCallServerScenarioStep(inherited Items[Index]);
end;

function TBisCallServerScenarioSteps.Next(From: TBisCallServerScenarioStep): TBisCallServerScenarioStep;
var
  i: Integer;
  Item: TBisCallServerScenarioStep;
  AFrom: TBisCallServerScenarioStep;
begin
  Result:=nil;
  AFrom:=From;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Assigned(AFrom) then begin
      if (Item=AFrom) then begin
        if (i+1)<=(Count-1) then begin
          Item:=Items[i+1];
          if Item.Enabled then begin
            Result:=Item;
            exit;
          end else
            AFrom:=Item;
        end;
      end;
    end else begin
      if Item.Enabled then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function TBisCallServerScenarioSteps.LockNext(From: TBisCallServerScenarioStep): TBisCallServerScenarioStep;
begin
  Lock;
  try
    Result:=Next(From); 
  finally
    UnLock;
  end;
end;

function TBisCallServerScenarioSteps.First: TBisCallServerScenarioStep;
begin
  Result:=Next(nil);
end;

function TBisCallServerScenarioSteps.LockFirst: TBisCallServerScenarioStep;
begin
  Lock;
  try
    Result:=First;
  finally
    UnLock;
  end;
end;

function TBisCallServerScenarioSteps.Find(const Name: String): TBisCallServerScenarioStep;
begin
  Result:=TBisCallServerScenarioStep(inherited Find(Name));
end;

function TBisCallServerScenarioSteps.LockFind(const Name: String): TBisCallServerScenarioStep;
begin
  Lock;
  try
    Result:=Find(Name);
  finally
    UnLock;
  end;
end;

{ TBisCallServerScenarioParams }

constructor TBisCallServerScenarioParams.Create;
begin
  inherited Create;
end;

destructor TBisCallServerScenarioParams.Destroy;
begin
  inherited Destroy;
end;

function TBisCallServerScenarioParams.GetHoldMusic(Wave: TBisAudioWave): Boolean;
var
  Param: TBisDataValueParam;
  Stream: TMemoryStream;
begin
  Result:=false;
  Param:=Find(SParamHoldMusic);
  if Assigned(Param) and Assigned(Wave) then begin
    Stream:=TMemoryStream.Create;
    try
      Param.SaveToStream(Stream);
      Stream.Position:=0;
      Wave.LoadFromStream(Stream);
      Result:=true;
    finally
      Stream.Free;
    end;
  end;
end;

function TBisCallServerScenarioParams.MainMenuText: String;
begin
  Result:=AsString(SParamMainMenuText);
end;

function TBisCallServerScenarioParams.MainMenuTimeout: Cardinal;
begin
  Result:=AsInteger(SParamMainMenuTimeout);
end;

function TBisCallServerScenarioParams.MessageTimeout: Cardinal;
begin
  Result:=AsInteger(SParamMessageTimeout);
end;

{ TBisCallServerScenario }

constructor TBisCallServerScenario.Create;
begin
  inherited Create;
  FSteps:=TBisCallServerScenarioSteps.Create;
  FMenus:=TBisCallServerScenarioMenus.Create;
  FParams:=TBisCallServerScenarioParams.Create;
end;

destructor TBisCallServerScenario.Destroy;
begin
  FParams.Free;
  FMenus.Free;
  FSteps.Free;
  inherited Destroy;
end;

procedure TBisCallServerScenario.SetDataSet(DataSet: TBisDataSet);
var
  Field: TField;
begin
  inherited SetDataSet(DataSet);

  FSteps.Clear;
  Field:=DataSet.FindField(SFieldSteps);
  if Assigned(Field) then
    FSteps.CopyFromDataSet(Field.AsString);

  FMenus.Clear;
  Field:=DataSet.FindField(SFieldMenus);
  if Assigned(Field) then
    FMenus.CopyFromDataSet(Field.AsString);

  FParams.Clear;
  Field:=DataSet.FindField(SFieldParams);
  if Assigned(Field) then begin
    FParams.CopyFromDataSet(Field.AsString);
    FParams.Change;
  end;

end;

procedure TBisCallServerScenario.CopyFrom(Source: TBisDataParam);
var
  ASource: TBisCallServerScenario;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisCallServerScenario) then begin
    ASource:=TBisCallServerScenario(Source);
    FSteps.CopyFrom(ASource.Steps);
    FMenus.CopyFrom(ASource.Menus);
    FParams.CopyFrom(ASource.Params);
  end;
end;


{ TBisCallServerScenarios }

function TBisCallServerScenarios.FindDefault(const Name: String): TBisCallServerScenario;
var
  i: Integer;
  Item: TBisCallServerScenario;
begin
  Result:=TBisCallServerScenario(Find(Name));
  if not Assigned(Result) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if Item.Enabled then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

class function TBisCallServerScenarios.GetDataParamClass: TBisDataParamClass;
begin
  Result:=TBisCallServerScenario;
end;

function TBisCallServerScenarios.GetItem(Index: Integer): TBisCallServerScenario;
begin
  Result:=TBisCallServerScenario(inherited Items[Index])
end;


end.
