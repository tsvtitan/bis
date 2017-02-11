
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{              Memory Detection Part                    }
{           version 5.5 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Memory;

interface

uses
  SysUtils, Windows, Classes;

type
  TMemory = class(TPersistent)
  private
    FMaxAppAddress: integer;
    FVirtualTotal: integer;
    FPageFileFree: integer;
    FVirtualFree: integer;
    FPhysicalFree: integer;
    FAllocGranularity: integer;
    FMinAppAddress: integer;
    FMemoryLoad: integer;
    FPhysicalTotal: integer;
    FPageFileTotal: integer;
    FPageSize: integer;
    FGDIRes: Byte;
    FUserRes: Byte;
    FSystemRes: Byte;

    function GetSystemRes: Byte;
    function GetGDIRes: Byte;
    function GetUSERRes: Byte;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property PhysicalTotal :integer read FPhysicalTotal write FPhysicalTotal stored false;
    property PhysicalFree :integer read FPhysicalFree write FPhysicalFree stored false;
    property VirtualTotal :integer read FVirtualTotal write FVirtualTotal stored false;
    property VirtualFree :integer read FVirtualFree write FVirtualFree stored false;
    property PageFileTotal :integer read FPageFileTotal write FPageFileTotal stored false;
    property PageFileFree :integer read FPageFileFree write FPageFileFree stored false;
    property MemoryLoad :integer read FMemoryLoad write FMemoryLoad stored false;
    property AllocGranularity :integer read FAllocGranularity write FAllocGranularity stored false;
    property MaxAppAddress :integer read FMaxAppAddress write FMaxAppAddress stored false;
    property MinAppAddress :integer read FMinAppAddress write FMinAppAddress stored false;
    property PageSize :integer read FPageSize write FPageSize stored false;
// if you want to get these values you must change conditional define ONLYWIN9X in MiTeC_Def.inc    
    property Win9x_SystemRes: Byte read FSystemRes write FSystemRes stored false;
    property Win9x_GDIRes: Byte read FGDIRes write FGDIRes stored false;
    property Win9x_UserRes: Byte read FUserRes write FUserRes stored false;
  end;

implementation

uses MiTeC_Routines;

{$IFDEF ONLYWIN9X}
const
  cSystem = 0;
  cGDI = 1;
  cUSER = 2;

function LoadLibrary16(LibraryName: PChar): THandle; stdcall; external kernel32 index 35;
procedure FreeLibrary16(HInstance: THandle); stdcall; external kernel32 index 36;
function GetProcAddress16(Hinstance: THandle; ProcName: PChar): Pointer; stdcall; external kernel32 index 37;
procedure QT_Thunk; cdecl; external kernel32 name 'QT_Thunk';

var
  hInst16: THandle;
  SR: Pointer;

function GetFreeSysRes(SysRes: Word): Word;
var
  Thunks: Array[0..$20] of Word;
begin
  Thunks[0]:=hInst16;
  hInst16:=LoadLibrary16('user.exe');
  if hInst16<32 then
    raise Exception.Create('Can''t load USER.EXE!');
  FreeLibrary16(hInst16);
  SR:=GetProcAddress16(hInst16,'GetFreeSystemResources');
  if not Assigned(SR) then
    raise Exception.Create('Can''t get address of GetFreeSystemResources');
  asm
    push SysRes       // push arguments
    mov edx, SR       // load 16-bit procedure pointer
    call QT_Thunk     // call thunk
    mov Result, ax    // save the result
  end;
end;
{$ENDIF}

{ TMemory }

function TMemory.GetGDIRes: Byte;
begin
  {$IFDEF ONLYWIN9X}
  Result:=GetFreeSysRes(cGDI)
  {$ELSE}
  Result:=0;
  {$ENDIF}
end;

function TMemory.GetSystemRes: Byte;
begin
  {$IFDEF ONLYWIN9X}
  Result:=GetFreeSysRes(cSystem)
  {$ELSE}
  Result:=0;
  {$ENDIF}
end;

function TMemory.GetUSERRes: Byte;
begin
  {$IFDEF ONLYWIN9X}
  Result:=GetFreeSysRes(cUser)
  {$ELSE}
  Result:=0;
  {$ENDIF}
end;

procedure TMemory.GetInfo;
var
  SI :TSystemInfo;
  MS :TMemoryStatus;
begin
  try

  ZeroMemory(@MS,SizeOf(MS));
  MS.dwLength:=SizeOf(MS);
  GlobalMemoryStatus(MS);
  MemoryLoad:=MS.dwMemoryLoad;
  PhysicalTotal:=MS.dwTotalPhys;
  PhysicalFree:=MS.dwAvailPhys;
  VirtualTotal:=MS.dwTotalVirtual;
  VirtualFree:=MS.dwAvailVirtual;
  PageFileTotal:=MS.dwTotalPageFile;
  PageFileFree:=MS.dwAvailPageFile;
  ZeroMemory(@SI,SizeOf(SI));
  GetSystemInfo(SI);
  AllocGranularity:=SI.dwAllocationGranularity;
  MaxAppAddress:=DWORD(SI.lpMaximumApplicationAddress);
  MinAppAddress:=DWORD(SI.lpMinimumApplicationAddress);
  PageSize:=DWORD(SI.dwPageSize);
  FSystemRes:=GetSystemRes;
  FGDIRes:=GetGDIRes;
  FUserRes:=GetUserRes;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TMemory.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TMemory.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[Memory]');
    Add(FormatFloat('PhysMemTotal=0,##',PhysicalTotal));
    Add(FormatFloat('PhysMemFree=0,##',PhysicalFree));
    Add(FormatFloat('PageFileTotal=0,##',PageFileTotal));
    Add(FormatFloat('PageFileFree=0,##',PageFileFree));
    Add(FormatFloat('VirtMemTotal=0,##',VirtualTotal));
    Add(FormatFloat('VirtMemFree=0,##',VirtualFree));
    Add(FormatFloat('AllocGranularity=0,##',AllocGranularity));
    Add(Format('MinAppAddress=%x',[MinAppAddress]));
    Add(Format('MaxAppAddress=%x',[MaxAppAddress]));
    Add(FormatFloat('PageSize=0,##',PageSize));
  end;
end;


end.
