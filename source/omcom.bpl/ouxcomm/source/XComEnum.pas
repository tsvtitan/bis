unit XComEnum;
(**************************************************************************
 *     This unit is part of XComDrv.                                      *
 *                                                                        *
 *     Communication ports enumerator                                     *
 *                                                                        *
 *     Author     : Alexander Grischenko, Latvia                          *
 *     Mail       : gralex@mailbox.riga.lv                                *
 *                                                                        *
 *     Version    : 1.0                                                   *
 *     Released   : 23 January, 2001                                      *
 *     Type       : Freeware                                              *
 *                                                                        *
 *     Target     : Delphi 4 - Delphi 5                                   *
 *                                                                        *
 *                                                                        *
 **************************************************************************)

{$H+,R-,B-}

interface

uses
  Windows, WinSpool, SysUtils, Classes;

type
  TPortOption  = (poCOM, poLPT, poFAX, poPrinters);
  TPortOptions = set of TPortOption;

function EnumNeededPorts(Ports:TStrings; PortOptions: TPortOptions): Boolean;
function EnumComPorts(Ports:TStrings): Boolean;

implementation
uses XComErr;

function EnumComPorts(Ports: TStrings): boolean;
begin
   Result := EnumNeededPorts(Ports, [poCOM]);
end;

function EnumNeededPorts(Ports: TStrings; PortOptions: TPortOptions): boolean;
var
  BytesNeeded, Returned, i: DWORD;
  PortsPtr, InfoPtr: PPortInfo1;
  TempStr: String;
begin
  Result := EnumPorts(
    nil, // this computer
    1,   // structure type 1 (port names only)
    nil, // no data needed
    0,   // info about structure size needed
    BytesNeeded,
    Returned);

  if (not Result) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
  begin
    GetMem(PortsPtr, BytesNeeded);  // Get needed memory
    try
      Result := EnumPorts(
        nil,
        1,
        Pointer(PortsPtr),
        BytesNeeded,
        BytesNeeded,
        Returned);

      InfoPtr := PortsPtr;
      Ports.Clear;
      for i := 0 to Returned - 1 do begin
        TempStr := InfoPtr^.pName;
        Inc(InfoPtr);

        // Remove last ':'
        if Copy(TempStr, 1, 2) <> '\\'
           then Delete(TempStr, Length(TempStr), 1);

        // check for COM
        if (poCOM in PortOptions) then
        begin
          if (Copy(TempStr, 1, 3)='COM') then
            Ports.Add(TempStr)
        end
        else

        // check for LPT
        if poLPT in PortOptions then
        begin
          if (Copy(TempStr, 1, 3)='LPT') then
            Ports.Add(TempStr);
        end
        else

        // check for network printers
        if poPrinters in PortOptions then
        begin
          if (Copy(TempStr, 1, 2)='\\') then
            Ports.Add(TempStr);
        end
        else

        // check for FAX
        if poFAX in PortOptions then
        begin
          if (pos('FAX',TempStr)>0) then
            Ports.Add(TempStr);
        end;
      end;

    finally
      FreeMem(PortsPtr);
    end;
  end;

  if not Result then XCommWin32Error(SEnumFailed, DEC_ENUMFAILED);
end;

end.
