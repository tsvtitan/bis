unit XComErr;
(**************************************************************************
 *     This unit is part of XComDrv.                                      *
 *                                                                        *
 *     Exception handling                                                 *
 **************************************************************************)

{$I XCOMSWITCH.INC}

interface

uses
  Windows, SysUtils;

resourcestring
  SInvalidBaudRate = '''%s'' is not a valid baud rate value.';
  SInvalidFlowControl = '''%s'' is not a valid flow control value.';
  SInvalidDataBits = '''%s'' is not a valid data bits value.';
  SInvalidParity = '''%s'' is not a valid parity value.';
  SInvalidStopBits = '''%s'' is not a valid stop bits value.';

  SDOpenError  = 'Cannot open device %s';
  SCommOpened = 'Device is allready opened.';
  SCommClosed = 'Device not opened.';
  SInvalidDCB = 'Unable to update device control block.';
  SInvalidIOSize = 'Unable to update IO buffers.';
  SInvalidTimeouts = 'Unable to update Timeouts.';
  SLockedSend = 'Device locked. Cannot perform send operations.';
  SLockedRead = 'Device locked. Cannot perform read operations.';
  SNoCommandState = 'Modem command state not present.';
  SNoDevice = 'Device not selected.';
  SEnumFailed = 'EnumPorts failed.'; // raise XCommWin32Error
  SReadError = 'Unable to read from port.'; // raise XCommWin32Error
  SSendError = 'Unable to write to port.'; //raise XCommWin32Error

const
  {Error codes}
  DEC_OPENERROR            = $FFFF;
  DEC_CLOSED               = $0001;
  DEC_OPENED               = $0002;
  DEC_INVALIDDCB           = $0003;
  DEC_LOCKEDSEND           = $0004;
  DEC_LOCKEDREAD           = $0005;
  DEC_INVALIDIOSIZE        = $0006;
  DEC_INVALIDTIMEOUTS      = $0007;
  DEC_NODEVICE             = $0008;  
  DEC_NOCOMMANDSTATE       = $0100;
  DEC_NOTCONNECTED         = $0101;
  DEC_READERROR            = $000A;
  DEC_SENDERROR            = $000B;
  DEC_ENUMFAILED           = $000C;

type
  EDeviceError = class ( Exception )
  public
    ErrorCode: integer;
    constructor CreateCode( const Msg: string; const Code: integer ); virtual;
  end;

procedure XCommError( const Ident: string; const Code: integer );
procedure XCommWin32Error( const Ident: string; const Code: integer );

implementation
{$IFDEF X_DEBUG}
uses Forms;

procedure MessageBox(const Text, Caption: string);
begin
  Application.MessageBox(PChar(Text), PChar(Caption), MB_OK or MB_ICONWARNING);
end;
{$ENDIF}

constructor EDeviceError.CreateCode( const Msg: string; const Code: integer );
begin
  Create(Msg);
  ErrorCode := Code;
end;

procedure XCommError( const Ident: string; const Code: integer );
begin
{$IFDEF X_DEBUG}
  MessageBox(Ident, 'TXComm');
{$ELSE}
  {$IFDEF EXC}
  raise EDeviceError.CreateCode(Ident, Code);
  {$ENDIF}
{$ENDIF}
end;

procedure XCommWin32Error( const Ident: string; const Code: integer );
{$IFDEF X_DEBUG}
begin
  MessageBox(Ident, 'TXComm');
{$ELSE}
  {$IFDEF EXC}
var ErrCode32: DWORD;
begin  
  ErrCode32 := GetLastError;
  raise EDeviceError.CreateCode(Format('%s (Win32 error %d: %s)',
     [Ident,ErrCode32,SysErrorMessage(ErrCode32)]), Code);
  {$ELSE}
begin    
  {$ENDIF}
{$ENDIF}
end;

end.
