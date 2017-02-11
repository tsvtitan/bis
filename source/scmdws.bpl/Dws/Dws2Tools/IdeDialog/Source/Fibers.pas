////////
///
//  Fibers.pas
//
//  A TThread-like wrapper for Windows fibers 
//
//  Copyright (c) 2003 Fabio Augusto Dal Castel
//
/////

unit Fibers;

interface

uses Windows, Classes;

type
  TFiber = class
  private
    FCreateSuspended: Boolean;
    FFreeOnTerminate: Boolean;
    FHandle: Pointer;
    FSuspended: Boolean;
    FTerminated: Boolean;

    FOnTerminate: TNotifyEvent;
  protected
    procedure DoTerminate; virtual;
    procedure Execute; virtual; abstract;
  public
    constructor Create(ACreateSuspended: Boolean);
    destructor Destroy; override;

    procedure AfterConstruction; override;
    procedure Resume;
    procedure Suspend;
    procedure Synchronize(AMethod: TThreadMethod);
    procedure Terminate;
    function WaitFor: LongWord;

    property FreeOnTerminate: Boolean read FFreeOnTerminate write FFreeOnTerminate;
    property Suspended: Boolean read FSuspended;
    property Terminated: Boolean read FTerminated;

    property OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
  end;

// This function doesn't exists ??? (Win 2000 Service Pack 3)
// function GetCurrentFiber: Pointer; stdcall; external kernel32 name 'GetCurrentFiber';

implementation

uses SysUtils;

var
  MainFiber: Pointer = nil;       // Handle to main fiber (created by InitializeFibers)

procedure FiberProc(AFiber: TFiber); stdcall;
begin
  try
    if not AFiber.Terminated then
      try
        AFiber.Execute;
      except
        // Catch any exception (ToDo: Create an exception handler like TThread)
      end;
  finally
    AFiber.Terminate;             // Set the Terminated flag
    SwitchToFiber(MainFiber);     // Return to main fiber to cleanup (see Resume)
  end;
end;

procedure InitializeFibers;
begin
  MainFiber := Pointer(ConvertThreadToFiber(nil));
end;

// --- TFiber ------------------------------------------------------------

constructor TFiber.Create(ACreateSuspended: Boolean);
begin
  inherited Create;
  if MainFiber = nil then              // Check for initialization
    InitializeFibers;

  // Create fiber in "suspended" state. If ACreateSuspended is FALSE
  //   the fiber will be activated ("resumed") in AfterConstruction
  FHandle := Pointer(CreateFiber(0, @FiberProc, Self));
  if FHandle = nil then
    raise Exception.Create('Error creating fiber.');

  FCreateSuspended := ACreateSuspended;
  FSuspended := True;
  FTerminated := False;
end;

destructor TFiber.Destroy;
begin
  DeleteFiber(FHandle);
  inherited Destroy;
end;

procedure TFiber.DoTerminate;
begin
  if Assigned(FOnTerminate) then
    FOnTerminate(Self);
end;

procedure TFiber.Resume;
begin
  // Must be called only in the main fiber context!

  if (not FTerminated) {and (GetCurrentFiber <> FHandle)} then
  begin
    FSuspended := False;
    SwitchToFiber(FHandle);            // This is the only fiber entry-point
  end;

  // There's three ways of hit this point:
  //   1) Calling Suspend within fiber context (within Execute method).
  //   2) Calling Resume of a Terminated fiber
  //   3) After FiberProc completion.
  //
  // In both cases, when FTerminated is TRUE we do the cleanup here
  if FTerminated then
  begin
    DoTerminate;
    if FFreeOnTerminate then
      Free;
  end;
end;

procedure TFiber.AfterConstruction;
begin
  inherited;
  if not FCreateSuspended then
    Resume;
end;

procedure TFiber.Suspend;
begin
  // Must be called only in the fiber context!

//  if (GetCurrentFiber <> MainFiber) then
  begin
    FSuspended := True;
    SwitchToFiber(MainFiber);
  end;
end;

procedure TFiber.Synchronize(AMethod: TThreadMethod);
begin
  // For TThread compatibility
  AMethod;
end;

procedure TFiber.Terminate;
begin
  FTerminated := True;
end;

function TFiber.WaitFor: LongWord;
begin
  // For TThread compatibility
  Result := 0;
end;

end.
