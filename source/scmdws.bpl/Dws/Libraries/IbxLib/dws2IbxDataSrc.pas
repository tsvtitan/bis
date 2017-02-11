unit dws2IbxDataSrc;

interface

uses
  SysUtils, Classes, dws2Comp, dws2Symbols, dws2IbxModule, DB, IBQuery,
  IBCustomDataSet, IBDatabase;

type
  Tdws2IBXDataSrc = class(TComponent)
  private
    FIBXStatement: TIBCustomDataSet;
    FIBXLib: Tdws2IBXLib;

    FDeclaration: string;
    function AllCompAssigned: boolean;
    procedure SetIBXLib(AdwsLib: Tdws2IBXLib);
    function GetIBXStatement: TIBCustomDataSet;
    procedure SetIBXStatement(AStatement: TIBCustomDataSet);
    procedure AddPredefDataset;
    procedure RemovePredefDataset;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    dwsIBXStatementObj: TdwsIBXStatementObj;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitScriptInstance(var ExtObject: TObject);
  published
    property Declaration: string read FDeclaration write FDeclaration;
    property IBXLib: Tdws2IBXLib read FIBXLib write SetIBXLib;
    property IBXStatement: TIBCustomDataSet read GetIBXStatement write SetIBXStatement;
  end;

  Tdws2IBXDataBase = class(TComponent)
  private
    FDataBase: TIBDatabase;
    FIBXLib: Tdws2IBXLib;
    FDeclaration: string;
    function AllCompAssigned: boolean;
    procedure SetIBXLib(AdwsLib: Tdws2IBXLib);
    function GetIBXConnection: TIBDatabase;
    procedure SetIBXConnection(AConnection: TIBDatabase);
    procedure AddPredefDataBase;
    procedure RemovePredefDataBase;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    dwsIBXDataBaseObj: TdwsIBXDataBaseObj;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitScriptInstance(var ExtObject: TObject);
  published
    property Declaration: string read FDeclaration write FDeclaration;
    property IBXLib: Tdws2IBXLib read FIBXLib write SetIBXLib;
    property DataBase: TIBDatabase read GetIBXConnection write SetIBXConnection;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2IBXDataSrc]);
  RegisterComponents('DWS2', [Tdws2IBXDataBase]);
end;

// --------------------------------------------------------------
// -----------------   Tdws2IBXDataSrc    ---------------------
// --------------------------------------------------------------

constructor Tdws2IBXDataSrc.Create(AOwner: TComponent);
begin
  inherited;
  dwsIBXStatementObj := TdwsIBXStatementObj.Create;
end;

destructor Tdws2IBXDataSrc.Destroy;
begin
  RemovePredefDataset;
  if assigned(dwsIBXStatementObj) then
  begin
    dwsIBXStatementObj.IBXStatement := nil;
    dwsIBXStatementObj.Free;
  end;
  inherited;
end;

function Tdws2IBXDataSrc.AllCompAssigned: boolean;
begin
  result := Assigned(FIBXLib) and Assigned(FIBXStatement);
end;

procedure Tdws2IBXDataSrc.InitScriptInstance(var ExtObject: TObject);
begin
  //FIBXStatement.prepare;
  dwsIBXStatementObj.IBXStatement := FIBXStatement;
  ExtObject := dwsIBXStatementObj;
end;

procedure Tdws2IBXDataSrc.AddPredefDataset;
var
  PredefDataset: Tdws2Instance;
begin
  if AllCompAssigned and not (csDesigning in ComponentState) then
  begin
    PredefDataset := Tdws2Instance(FIBXLib.customIBXUnit.Instances.Add);
    if (FIBXStatement is TIBQuery) then
      PredefDataset.DataType := 'TQuery'
    else if (FIBXStatement is TIBDataSet) then
      PredefDataset.DataType := 'TDataSet';
    //else  if (FIBXStatement is TIBStatement) then
    //  PredefDataset.DataType := 'TStatement';

    PredefDataset.Name := Declaration;
    PredefDataset.AutoDestroyExternalObject := false;
    PredefDataset.OnInstantiate := InitScriptInstance;
    //    PredefDataset.OnCleanUp := CleanUp;
  end;
end;

procedure Tdws2IBXDataSrc.RemovePredefDataset;
var
  i: Integer;
begin
  if AllCompAssigned and not (csDesigning in ComponentState) then
    with FIBXLib.customIBXUnit.Variables do
    begin
      for i := 0 to count - 1 do
      begin
        if Tdws2Global(items[i]).name = Declaration then
        begin
          delete(i);
          exit;
        end;
      end;
    end;
end;

procedure Tdws2IBXDataSrc.SetIBXLib(AdwsLib: Tdws2IBXLib);
begin
  if AdwsLib <> FIBXLib then
  begin
    //    if Assigned(FIBXLib) then
    //      FIBXLib.RemoveFreeNotification(Self);
    if Assigned(AdwsLib) then
      AdwsLib.FreeNotification(Self);
    RemovePredefDataset;
    FIBXLib := AdwsLib;
    AddPredefDataset;
  end;
end;

procedure Tdws2IBXDataSrc.SetIBXStatement(AStatement: TIBCustomDataSet);
begin
  if AStatement <> FIBXStatement then
  begin
    //    if Assigned(FIBXStatement) then
    //      FIBXStatement.RemoveFreeNotification(Self);
    //    if Assigned(AStatement) then
    //      AStatement.FreeNotification(Self);
    RemovePredefDataset;
    FIBXStatement := AStatement;
    AddPredefDataset;
  end;
end;

function Tdws2IBXDataSrc.GetIBXStatement: TIBCustomDataSet;
begin
  Result := FIBXStatement;
end;

procedure Tdws2IBXDataSrc.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  // The FIBXStatement object notifies us that it's going to be removed
  if (Operation = opRemove) and (AComponent = FIBXStatement) then
    SetIBXStatement(nil);
  if (Operation = opRemove) and (AComponent = FIBXLib) then
    SetIBXLib(nil);
end;

// --------------------------------------------------------------
// -----------------   Tdws2IBXDataBase  ---------------------
// --------------------------------------------------------------

constructor Tdws2IBXDataBase.Create(AOwner: TComponent);
begin
  inherited;
  dwsIBXDataBaseObj := TdwsIBXDataBaseObj.Create;
end;

destructor Tdws2IBXDataBase.Destroy;
begin
  RemovePredefDataBase;
  if assigned(dwsIBXDataBaseObj) then
  begin
    dwsIBXDataBaseObj.IBXConnection := nil;
    dwsIBXDataBaseObj.free;
  end;
  inherited;
end;

function Tdws2IBXDataBase.AllCompAssigned: boolean;
begin
  result := Assigned(FIBXLib) and Assigned(FDataBase);
end;

procedure Tdws2IBXDataBase.InitScriptInstance(var ExtObject: TObject);
begin
  FDataBase.Connected := true;
  dwsIBXDataBaseObj.IBXConnection := FDataBase;
  ExtObject := dwsIBXDataBaseObj;
end;

procedure Tdws2IBXDataBase.AddPredefDataBase;
var
  PredefDataBase: Tdws2Instance;
begin
  if AllCompAssigned and not (csDesigning in ComponentState) then
  begin
    PredefDataBase := Tdws2Instance(FIBXLib.customIBXUnit.Instances.Add);
    PredefDataBase.DataType := 'TDataBase';
    PredefDataBase.Name := Declaration;
    PredefDataBase.AutoDestroyExternalObject := false;
    PredefDataBase.OnInstantiate := InitScriptInstance;
  end;
end;

procedure Tdws2IBXDataBase.RemovePredefDataBase;
var
  i: Integer;
begin
  if assigned(FIBXLib) and not (csDesigning in ComponentState) then
    with FIBXLib.customIBXUnit.Variables do
    begin
      for i := 0 to count - 1 do
      begin
        if Tdws2Global(items[i]).name = Declaration then
        begin
          delete(i);
          exit;
        end;
      end;
    end;
end;

procedure Tdws2IBXDataBase.SetIBXLib(AdwsLib: Tdws2IBXLib);
begin
  if AdwsLib <> FIBXLib then
  begin
    //    if Assigned(FIBXLib) then
    //      FIBXLib.RemoveFreeNotification(Self);
    if Assigned(AdwsLib) then
      AdwsLib.FreeNotification(Self);
    RemovePredefDataBase;
    FIBXLib := AdwsLib;
    AddPredefDataBase;
  end;
end;

procedure Tdws2IBXDataBase.SetIBXConnection(AConnection: TIBDatabase);
begin
  if AConnection <> FDataBase then
  begin
    //    if Assigned(FDataBase) then
    //      FDataBase.RemoveFreeNotification(Self);
    //    if Assigned(AConnection) then
    //      AConnection.FreeNotification(Self);
    //    RemovePredefDataset;
    FDataBase := AConnection;
    AddPredefDataBase;
  end;
end;

function Tdws2IBXDataBase.GetIBXConnection: TIBDatabase;
begin
  Result := FDataBase;
end;

procedure Tdws2IBXDataBase.Notification(AComponent: TComponent; Operation: TOperation);
begin
  // The FIBXConnection object notifies us that it's going to be removed
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataBase) then
    SetIBXConnection(nil);
  if (Operation = opRemove) and (AComponent = FIBXLib) then
    SetIBXLib(nil);
end;

end.

