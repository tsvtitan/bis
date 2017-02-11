// Copyright 2002 Joen Joensen.
//
// This unit is contributed to the DWS community. Under MPL licence.
// It enables the use of control scripts which "pauses"
// It was intended for opengl(GLScene) scripting,
// with a runall being called(between rendering) each 100 ms or so...
//
unit FiberLibrary;

interface

uses
  classes, dws2Comp, dws2Exprs, windows;

type
  TDWSFiberList = class
  private
    FOwnFiber: Pointer;
    FAction: Integer; // 0 = idle, 1 = running single, 2 = running all, 3 = start running all
    FActionProgress: Integer;
    FList: TList;
    FInternalFree: Integer;
    FDWS: TDelphiWebScriptII;
  protected
    procedure NextFiber;
  public
    constructor Create;
    destructor Destroy; override;

    procedure GenerateFiber;
    function StartDWSFiber(script: string; Data: TStrings = nil): Integer;
    procedure Terminate(ID: Integer);
    procedure TerminateAll;
    procedure RunAllFibers;
    procedure Run(ID: Integer);
    property DWS: TDelphiWebScriptII read FDWS write FDWS;
    property OwnFiber: Pointer read FOwnFiber write FOwnFiber;
  end;

  TDWSFiber = class
  private
    FOwner: TDWSFiberList;
    FTerminated: Boolean;
    FScript: string;
    FData: TStrings;
    FFiber: Pointer;
    procedure SetData(Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;

    property Fiber: Pointer read FFiber write FFiber;
    property Script: string read FScript write FScript;
    property Owner: TDWSFiberList read FOwner write FOwner;
    property Terminated: Boolean read FTerminated write FTerminated;
    property Data: TStrings read FData write SetData;
  end;

function GetFiberData(Info: TProgramInfo; name: string): string;
procedure SetFiberData(Info: TProgramInfo; name, value: string);
procedure NextFiber(Info: TProgramInfo);
procedure DWSFiberStartPoint;
procedure FiberMessage(MessageText: string);

implementation

var
  FiberLibraryInternal: TDWSFiber;
  // this is a non thread safe hack! could be replaced by the api function GetFiberData which is not in delphi?

procedure FiberMessage(MessageText: string);

begin
  MessageBox(0, PChar(MessageText), 'Fiber Message', 0); // only here for demo, its useless.
end;

procedure DWSFiberStartPoint;
var
  Data: TDWSFiber;
begin
  Data := FiberLibraryInternal;
  Data.Execute;
  Data.Terminated := True;
  Data.Owner.NextFiber;
end;

constructor TDWSFiber.Create;
begin
  FTerminated := False;
  FData := TStringList.Create;
end;

destructor TDWSFiber.Destroy;
begin
  FData.Free;
  inherited;
end;

procedure TDWSFiber.SetData(Value: TStrings);
begin
  if Assigned(Value) then
    FData.Assign(Value);
end;

procedure TDWSFiber.Execute;
var
  Prog: TProgram;
begin
  Prog := Owner.DWS.Compile(Script);
  try
    Prog.UserDef := Self;
    Prog.Execute;
  finally
    Prog.Free;
  end;
end;

constructor TDWSFiberList.Create;
begin
  FOwnFiber := nil;
  FAction := 0;
  FList := TList.Create;
  FInternalFree := 0;
end;

destructor TDWSFiberList.Destroy;
begin
  TerminateAll;
  FList.Free;
  inherited;
end;

procedure TDWSFiberList.GenerateFiber;
begin
  FOwnFiber := Pointer(ConvertThreadToFiber(nil));
end;

function TDWSFiberList.StartDWSFiber(script: string; Data: TStrings = nil): Integer;
var
  DWSFiber: TDWSFiber;
begin
  DWSFiber := TDWSFiber.Create;
  DWSFiber.Owner := Self;
  DWSFiber.Script := Script;
  DWSFiber.Data := Data;
  DWSFiber.Fiber := Pointer(CreateFiber(0, @DWSFiberStartPoint, Pointer(Data))); //why delphi returns a bool is beyond me
  if FInternalFree > 0 then
  begin
    Result := FList.IndexOf(nil);
    FList[Result] := DWSFiber;
    dec(FInternalFree);
  end
  else
    Result := FList.Add(DWSFiber);
end;

procedure TDWSFiberList.Terminate(ID: Integer);
var
  DWSFiber: TDWSFiber;
begin
  if (ID < 0) or (ID >= FList.Count) then
    Exit;
  DWSFiber := FList[ID];
  if Assigned(DWSFiber) then
  begin
    FList[ID] := nil;
    DeleteFiber(DWSFiber.Fiber);
    DWSFiber.Free;
    Inc(FInternalFree);
  end;
end;

procedure TDWSFiberList.TerminateAll;
var
  xc: Integer;
begin
  for xc := 0 to FList.Count - 1 do
  begin
    Terminate(xc);
  end;
  FList.Count := 0;
end;

procedure TDWSFiberList.RunAllFibers;
begin
  FAction := 3;
  FActionProgress := 0;
  NextFiber;
end;

procedure TDWSFiberList.Run(ID: Integer);
var
  DWSFiber: TDWSFiber;
begin
  if (ID < 0) or (ID >= FList.Count) then
    Exit;
  DWSFiber := FList[ID];
  if Assigned(DWSFiber) then
  begin
    if DWSFiber.Terminated then
    begin
      Terminate(ID);
    end
    else
    begin
      FAction := 1;
      FiberLibraryInternal := DWSFiber;
      SwitchToFiber(DWSFiber.Fiber);
    end;
  end;
end;

procedure TDWSFiberList.NextFiber;
var
  DWSFiber: TDWSFiber;
begin
  case FAction of
    1: SwitchToFiber(FOwnFiber);
    2, 3:
      begin
        while FActionProgress < FList.Count do
        begin
          DWSFiber := FList[FActionProgress];
          if Assigned(DWSFiber) then
          begin
            if DWSFiber.Terminated then
            begin
              Terminate(FActionProgress);
            end
            else
            begin
              inc(FActionProgress);
              FAction := 2;
              FiberLibraryInternal := DWSFiber;
              SwitchToFiber(DWSFiber.Fiber);
              Exit;
            end;
          end;
          inc(FActionProgress);
        end;
        if FAction = 2 then
          SwitchToFiber(FOwnFiber);
      end;
  else
    begin
      // THIS SHOULD NEVER HAPPEND
      SwitchToFiber(FOwnFiber); // better safe than sorry
    end;
  end;
end;

function GetFiberData(Info: TProgramInfo; name: string): string;
var
  UserDef: TObject;
begin
  UserDef := Info.Caller.Root.UserDef;
  Assert(UserDef is TDWSFiber, 'This function is for scripts executed by the TDWSFiberList.');

  Result := TDWSFiber(UserDef).FData.Values[name];
end;

procedure SetFiberData(Info: TProgramInfo; name, value: string);
var
  UserDef: TObject;
begin
  UserDef := Info.Caller.Root.UserDef;
  Assert(UserDef is TDWSFiber, 'This function is for scripts executed by the TDWSFiberList.');

  TDWSFiber(UserDef).FData.Values[name] := value;
end;

procedure NextFiber(Info: TProgramInfo);
var
  UserDef: TObject;
begin
  UserDef := Info.Caller.Root.UserDef;
  Assert(UserDef is TDWSFiber, 'This function is for scripts executed by the TDWSFiberList.');

  TDWSFiber(UserDef).Owner.NextFiber;
end;

end.

