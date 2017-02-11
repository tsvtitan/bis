{$WEAKPACKAGEUNIT ON}
unit CodeRedirect;

interface

type
  TCodeRedirect = class(TObject)
  private
    type
      TInjectRec = packed record
        Jump: Byte;
        Offset: Integer;
      end;

      PWin9xDebugThunk = ^TWin9xDebugThunk;
      TWin9xDebugThunk = packed record
        PUSH: Byte;
        Addr: Pointer;
        JMP: Byte;
        Offset: Integer;
      end;

      PAbsoluteIndirectJmp = ^TAbsoluteIndirectJmp;
      TAbsoluteIndirectJmp = packed record
        OpCode: Word;   //$FF25(Jmp, FF /4)
        Addr: ^Pointer;
      end;
  private
    FSourceProc: Pointer;
    FInjectRec: TInjectRec;
    function GetActualAddr(Proc: Pointer): Pointer;
  public
    constructor Create(const aProc, aNewProc: Pointer);
    procedure BeforeDestruction; override;
  end;

implementation

uses SysUtils, Windows;

function TCodeRedirect.GetActualAddr(Proc: Pointer): Pointer;

  function IsWin9xDebugThunk(AAddr: Pointer): Boolean;
  begin
    Result := (AAddr <> nil) and
              (PWin9xDebugThunk(AAddr).PUSH = $68) and
              (PWin9xDebugThunk(AAddr).JMP = $E9);
  end;

begin
  if Proc <> nil then begin
    if (Win32Platform <> VER_PLATFORM_WIN32_NT) and IsWin9xDebugThunk(Proc) then
      Proc := PWin9xDebugThunk(Proc).Addr;
    if (PAbsoluteIndirectJmp(Proc).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp(Proc).Addr^
    else
      Result := Proc;
  end else
    Result := nil;
end;

procedure TCodeRedirect.BeforeDestruction;
var n: DWORD;
begin
  inherited;
  if FInjectRec.Jump <> 0 then
    WriteProcessMemory(GetCurrentProcess, GetActualAddr(FSourceProc), @FInjectRec, SizeOf(FInjectRec), n);
end;

constructor TCodeRedirect.Create(const aProc, aNewProc: Pointer);
var OldProtect: Cardinal;
    P: pointer;
begin
  inherited Create;
  if Assigned(aProc)then begin
    FSourceProc := aProc;
    P := GetActualAddr(aProc);
    if VirtualProtect(P, SizeOf(TInjectRec), PAGE_EXECUTE_READWRITE, OldProtect) then begin
      FInjectRec := TInjectRec(P^);
      TInjectRec(P^).Jump := $E9;
      TInjectRec(P^).Offset := Integer(aNewProc) - (Integer(P) + SizeOf(TInjectRec));
      VirtualProtect(P, SizeOf(TInjectRec), OldProtect, @OldProtect);
      FlushInstructionCache(GetCurrentProcess, P, SizeOf(TInjectRec));
    end;
  end;
end;

end.
