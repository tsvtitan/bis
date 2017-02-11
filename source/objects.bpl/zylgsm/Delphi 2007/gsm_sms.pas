unit gsm_sms;

{
*******************************************************************************
* Descriptions: GSM/PDU Handing Class
* $Source: /cvsroot/fma/fma/gsm_sms.pas,v $
* $Locker:  $
*
* Todo:
*   - Add support for Icelandic character
*   - Rename unit as 'uGsmSMS.pas' for example
*
* Change Log:
* $Log: gsm_sms.pas,v $
* Revision 1.16.6.3  2005/01/25 16:03:05  z_stoichev
* Merged with 2.1 Beta 1 bugfixes
*
* Revision 1.16.6.2  2004/10/15 11:27:58  z_stoichev
* Bugfixes
*
* Revision 1.16.6.1  2004/10/14 16:43:23  z_stoichev
* Bugfixes
*
* Revision 1.16  2004/07/26 12:50:56  z_stoichev
* Force UCS-2 support
*
* Revision 1.15  2004/07/14 09:34:50  z_stoichev
* - Fixed GSM 7bit decoding end of text detection.
*
* Revision 1.14  2004/07/07 10:22:38  z_stoichev
* Added convert handling and debug msg
*
* Revision 1.13  2004/03/26 18:37:39  z_stoichev
* Build 0.1.0.35 RC5
*
* Revision 1.12  2004/03/12 16:56:10  z_stoichev
* Fixed Long SMS last character deleted.
*
* Revision 1.11  2004/03/04 16:53:47  z_stoichev
* Fixed append @ at message end.
*
* Revision 1.10  2004/01/27 15:52:07  z_stoichev
* Fixed prefix @@@@ on long sms.
* Added update refference field method.
*
* Revision 1.9  2004/01/23 12:50:02  z_stoichev
* Bugfixes, set get PDU, change Msg Refference
*
* Revision 1.8  2003/11/28 09:38:07  z_stoichev
* Merged with branch-release-1-1 (Fma 0.10.28c)
*
* Revision 1.7.2.2  2003/11/21 10:56:07  z_stoichev
* Fixed msg text cut in Fma.
*
* Revision 1.7.2.1  2003/10/27 07:22:53  z_stoichev
* Build 0.1.0 RC1 Initial Checkin.
*
* Revision 1.7  2003/10/24 12:22:03  z_stoichev
* Fixed UCS-2 issue with german special symbols.
*
* Revision 1.6  2003/10/21 09:15:37  z_stoichev
* Sending UTF8/UCS2 messages (cyrillic etc. support)
*
* Revision 1.5  2003/07/02 12:21:23  crino77
* fixed some bugs with UCS2 sms
*
* Revision 1.4  2003/02/14 07:23:48  crino77
* Add the MessageReference
* Add the UDHI support and request status
* Added FMessageLength:Integer; in private
* Modified GetMessage to prevent some char at the end of the message ;)
* Add support for Greek - Thanks to George Billios
*
* Revision 1.3  2003/01/30 04:15:57  warren00
* Updated with header comments
*
*
*
*******************************************************************************
}

interface

uses
  SysUtils, DateUtils, Dialogs, StrUtils;

type
  TSMS = class(TObject)
  private
    FIsSMSSumit: Boolean;
    FValidityLen: Integer;
    FSMSCLen: Integer;
    FSenderLen: Integer;
    FSenderPos: Integer;
    FPDU: String;
    FSMSDeliverStartPos: Integer;
    FMessage: WideString;
    FMessageRef: String;
    FAddress: String;
    FFlashSMS: Boolean;
    FRequestReply: Boolean;
    FDataCoding: Integer;
    FMessageLength: Integer;
    FIsUDH: Boolean;
    FUDHI: String;
    FStatusRequest: Boolean;
    FSizeOfPDU: integer;
    procedure SetPDU(const Value: String);
    function GetPDU: String;
    function ReverseOctets(Octets: String): String;
    function DecodeNumber(raw: String): String;
    function EncodeNumber(Number: String): String;
    function GetMessage: WideString;
    function GetAddress: String;
    function GetSMSC: String;
    function GetTimeStamp: TDateTime;
    function Get7bit(str: String): String;
    function Get8bit(str: String): String;
    function GetUCS2(str: String): WideString;
    function MakeCRLF(str: string): String;
    procedure Set_MessageRef(const Value: String);
  public
    dcs: Integer;
    function GetNewPDU(AMessageReference: String): String;
    property RequestReply: Boolean read FRequestReply write FRequestReply;
    property PDU: String read GetPDU write SetPDU;
    property UDHI: String read FUDHI write FUDHI;
    property MessageReference: String read FMessageRef write Set_MessageRef;
    property Text: WideString read GetMessage write FMessage;
    property Number: String read GetAddress write FAddress;
    property SMSC: String read GetSMSC;
    property FlashSMS: Boolean read FFlashSMS write FFlashSMS;
    property StatusRequest: Boolean read FStatusRequest write FStatusRequest;
    property IsOutgoing: Boolean read FIsSMSSumit;
    property IsUDH: Boolean read FIsUDH;
    property TimeStamp: TDateTime read GetTimeStamp;
    property TPLength: integer read FSizeOfPDU;
  end;

const
  DoStrictUCScheck: boolean = True;
  ForceUCSusage: boolean = False;

function CheckCodingType(str: WideString): Integer;
function ConvertCharSet(inputStr: String; toGSM: Boolean): String; overload; // from GSM mode only!
function ConvertCharSet(inputChr: Char; toGSM: Boolean = False): Char; overload;

{ implementation found on interget, might solve chinese utf8 problems ? 
function DecodeUTF8(const Value : string):string;
function EncodeUTF8(const Value : string):string;
}

implementation

uses Windows, Unit1;

{ UTF8 }

function DecodeUTF8(const Value : string):string;
var i, j : integer;
    N : integer;
    HugeChar : ULONG; //4 bytes
begin
  Result:='';
  i:=1;
  while i < Length(Value) do begin
    if byte(Value[i]) < $80 then begin
      Result:=Result+Value[i]; //no change required
      i:=i+1;
    end
    else begin
      //find out the number of bytes used for this character
      N:=0;
      for j:=1 to 8 do begin
      //start with the highest bit and cound the bumber
      //of "1" before "0"
        if (byte(Value[i]) and (1 shl (8-j))) = 0 then Break;
        inc(N);
      end;
      //ShowMessage('N:'+IntToStr(N));
      HugeChar:=byte(Value[i]) and ($FF shr (N+1));
      //ShowMessage('HugeChar:'+IntToStr(HugeChar));
      for j:=1 to N-1 do begin
        HugeChar:=(HugeChar shl 6) or byte(byte(Value[i+j]) and $3F);
      end;
      //ShowMessage('HugeChar:'+IntToStr(HugeChar));
      Result:=Result+char(HugeChar);
      i:=i+N;
    end;
  end;
end;

//only work on bytes 0..255
function EncodeUTF8(const Value : string):string;
var i : integer;
begin
  for i:=1 to Length(Value) do begin
    if byte(Value[i]) < $80 then begin
      Result:=Result+Value[i]; //no change required
    end
    else begin
      Result:=Result+char($C0{11000000} or (byte(Value[i]) shr 6))+
                     char($80{10000000} or (byte(Value[i]) and $3F{111111}));
    end;
  end;
end;

{ TSMS }

function TSMS.DecodeNumber(raw: String): String;
var
  addrType: Integer;
begin
  try
    addrType := StrToInt('$' + copy(Raw, 1, 2));
    if ((addrType and $50) = $50) then begin
      Result := Get7bit(copy(Raw, 3, length(Raw) - 2));
    end
    else begin
      Result := ReverseOctets(copy(Raw, 3, length(Raw) - 2));
      if Result[length(Result)] = 'F' then Result := copy(Result, 1, length(Result) - 1);
      if ((StrToInt('$' + copy(Raw, 1, 2)) and $70) shr 4) = 1 then Result := '+' + result;
    end;
  except
    Result := '';
  end;
end;

function TSMS.EncodeNumber(Number: String): String;
begin
  Result := '81';

  if Number[1] = '+' then begin
    Result := '91'; // International Numner, ISDN/Telephone (E.164/E.163)
    Number := copy(Number, 2, length(Number));
  end;

  Result := IntToHex(length(Number), 2) + Result;

  if length(Number) mod 2 > 0 then Number := Number + 'F';
  Result := Result + ReverseOctets(Number);
end;

function TSMS.Get7bit(str: String): String;
var
  i, j, x: Integer;
  leftover, octet: byte;
  c: string[2];
begin
  Result := '';
  x := 1;
  leftover := 0;
  j := Round(length(str) / 2) - 1;

  for i := 0 to j do begin
    try
      c := copy(str, (i*2)+1, 2);
      if not (Copy(c,1,1)[1] in ['0'..'9','A'..'F']) then
        break;
      if (Length(c) = 2) and not (Copy(c,2,1)[1] in ['0'..'9','A'..'F']) then
        Delete(c,2,1);
      octet := StrToInt('$' + c);
      Result := Result + chr(((octet and ($FF shr x)) shl (x - 1)) or leftover);
      leftover := (octet and (not ($FF shr x))) shr (8 - x);
      x := x + 1;
    except
    end;

    if x = 8 then begin
      { do not add extra @ at the end of text, bug 849905 fixed }
      if (i <> j) or (leftover <> 0) then
        Result := Result + chr(leftover);
      x := 1;
      leftover := 0;
    end;
  end;

  Result := ConvertCharSet(Result, false);
end;

function TSMS.Get8bit(str: String): String;
var
  i: Integer;
  octet: Integer;
begin
  Result := '';

  for i := 0 to Round(length(str) / 2) - 1 do begin
    octet := StrToInt('$' + copy(str, (i*2)+1, 2));
    Result := Result + chr(octet);
  end;

  Result := ConvertCharSet(Result, false);
end;

function TSMS.GetUCS2(str: String): WideString;
var
  i: Integer;
  octet: Integer;
begin
  Result := '';

  while (length(str) mod 4) <> 0 do str := str + '0';

  for i := 0 to (length(str) div 4) - 1 do begin
    octet := StrToInt('$' + copy(str, (i*4)+1, 4));
    Result := Result + Widechar(octet);
  end;
end;

function TSMS.GetMessage: WideString;
var
  startpos: Integer;
  str, UDHnull: String;
  UDHIlength, i :Integer;
  function RemoveTail00(s: string): string;
  var
    i: integer;
  begin
    i := Length(s);
    if i >= 2 then begin
      if Copy(s,i-1,2) = '00' then
        Delete(s,i-1,2);
    end;
    Result := s;
  end;
begin
  try
    Result := '';
    UDHILength := 0;

    startpos := FSMSDeliverStartPos + FSenderLen + FValidityLen + 12;
    if not FIsSMSSumit then startpos := startpos + 12;

    if FIsUDH then begin
      UDHILength := StrToInt('$' + copy(FPDU, startpos + 2, 2));

      FUDHI := copy(FPDU, startpos + 2, UDHILength * 2 + 2);
      //Replace UDH with NULL chars
      for i:=0 to UDHILength do begin
         UDHnull := UDHnull + '00';
      end;
      Delete(FPDU,startpos + 2,UDHILength * 2 + 2);
      Insert(UDHNull,FPDU,startpos + 2);
      //FPDU := AnsiReplaceStr(FPDU, FUDHI, UDHNull);
    end;

    // TP-User-Data-Length. Length of message. The TP-DCS field indicated 7-bit data, so the length here is the number
    // of septets. If the TP-DCS field were set to 8-bit data or Unicode, the length would be the number of octets.
    FMessageLength := StrToInt('$' + copy(FPDU, startpos, 2));

    if FDataCoding = 0 then begin
       str := copy(FPDU, startpos + 2, length(FPDU)); // process the rest of PDU data, will cut the message length later
       Result := Get7bit(str);
       // here FMessageLength contains number of septets (decoded chars)
       if FIsUDH then
         Result := Copy(Result, ((UDHILength div 7) + UDHILength + 2) + 1, FMessageLength)
       else
         Result := Copy(Result, 1, FMessageLength);
    end
    else if FDataCoding = 1 then begin
       // here FMessageLength contains numbers of octets (encoded bytes)
       str := copy(FPDU, startpos + 2, (FMessageLength)*2);
       Result := Get8bit(str);
       if FIsUDH then
         Result := Copy(Result, ((UDHILength div 7) + UDHILength + 2) + 1, Length(Result));
    end
    else if FDataCoding = 2 then begin
       // here FMessageLength contains numbers of octets (encoded bytes)
       str := copy(FPDU, startpos + 2, (FMessageLength)*2);
       Result := GetUCS2(str);
       if FIsUDH then begin
         i := ((UDHILength + 1) mod 4) + 2;
         Result := Copy(Result, i, Length(Result));
         { TODO: unicode support instead of copy? }
         //Result := WideCharLenToString(@Result[i], Length(Result) - i + 1);
       end;
    end
    else Result := '(Unsupported: Unknown coding scheme)';

    Result := MakeCRLF(Result);
  except
    Result := '(Decoding Error)';
  end;
end;

function TSMS.GetPDU: String;
var
  udhl: Integer;
  i, j, x, head: Integer;
  Octet: String;
  nextChr: Byte;

  pduAddr, pduMsgL, pduMsg: String;
  pduSMSC, pduFirst, pduMsgRef, pduPID, pduDCS, pduTPVP: String;
  AMessage: WideString;
begin
  AMessage := FMessage;
  udhl := 0;
  try
    // Convert Address (Destination No)
    pduAddr := EncodeNumber(FAddress);

    pduMsg := '';
    if (dcs = 0) or ((dcs = -1) and (CheckCodingType(AMessage) = 0)) then begin // 7-bit coding
      // Convert Message
      if FUDHI <> '' then begin
         udhl := StrToInt(Copy(FUDHI,1,2));
         udhl := (udhl div 7) + udhl + 2;
         for i:=0 to udhl - 1 do begin
            AMessage := '@' + AMessage;
         end;
      end;
      pduMsgL := IntToHex(length(AMessage), 2); // number of septets!! IT IS NOT NUMBER OF OCTETS IN 7-bit encoding mode!!

      x := 0;
      j := length(AMessage);
      for i := 1 to j do begin
        if x < 7 then begin
          if i = j then
            nextChr := 0
          else
            nextChr := Ord(ConvertCharSet(Char(AMessage[i+1]), True));

          Octet := IntToHex( ((nextChr and (not ($FF shl (x+1)))) shl (7-x)) or (Ord(ConvertCharSet(Char(AMessage[i]), True)) shr x) , 2);
          pduMsg := pduMsg + Octet;

          x := x + 1;
        end
        else x := 0;
      end;

      pduDCS := '00';
    end
    else if (dcs = 1) or ((dcs = -1) and (CheckCodingType(AMessage) = 1)) then begin // 8-bit coding
      if FUDHI <> '' then begin
         udhl := StrToInt(Copy(FUDHI,1,2));
         udhl := (udhl div 7) + udhl + 2;
         for i:=0 to udhl - 1 do begin
            AMessage := '@' + AMessage;
         end;
      end;
      for i := 1 to length(AMessage) do begin
        pduMsg := pduMsg + IntToHex(ord(ConvertCharSet(Char(AMessage[i]), True)), 2);
      end;
      pduMsgL := IntToHex(length(pduMsg) div 2,2); // number of octets

      pduDCS := '04';
    end
    else begin // UCS2 Coding
      if FUDHI <> '' then begin
         udhl := StrToInt(Copy(FUDHI,1,2));
         udhl := ((udhl + 1) mod 4) + 3;
         for i:=0 to udhl - 1 do begin
            AMessage := '@' + AMessage;
         end;
         udhl := udhl*2 + 1; // adjust udhl according to UCS2 coding 
      end;
      for i := 1 to length(AMessage) do begin
        pduMsg := pduMsg + IntToHex(ord(AMessage[i]), 4);
      end;
      pduMsgL := IntToHex(length(pduMsg) div 2,2); // number of octets

      pduDCS := '08';
    end;
    if FFlashSMS then pduDCS[1] := '1'; // i.e. '1x' depending of code scheme selected

    if FUDHI <> '' then begin
       pduMsg := Copy(pduMsg, (udhl-1) * 2 + 1, length(pduMsg));
    end;

    pduSMSC :=   '00'; // No SMSC Information
    pduFirst :=  '11'; // No Validity Field, SMS-Sumit, No UDH, No Status Request
    head := StrToInt('$' + pduFirst);
    if FStatusRequest then head := head or $20; //ADD Yes StatusRequest
    if FUDHI <> '' then head := head or $40;    //ADD Yes UDH
    if FRequestReply then head := head or $80;  //ADD Yes ReplyRequest

    pduFirst := IntToHex(head, 2);
    pduMsgRef := '00'; // Let the phone set Msg Ref itself
    if FMessageRef <> '' then pduMsgRef := FMessageRef;
    pduPID := '00';

    pduTPVP := 'FF';

    Result := pduFirst + pduMsgRef + pduAddr + pduPID + pduDCS + pduTPVP + pduMsgL;
    if FUDHI <> '' then begin
       Result := Result + FUDHI;
    end;
    Result := Result + pduMsg;

    FSizeOfPDU := Length(Result) div 2;

    Result := pduSMSC + Result;
  except
    raise Exception.Create('Error encoding PDU');
  end;
end;

function TSMS.GetAddress: String;
begin
  Result := DecodeNumber(copy(FPDU, FSenderPos, FSenderLen + 2));
end;

function TSMS.GetSMSC: String;
begin
  if FSMSCLen > 0 then Result := DecodeNumber(copy(FPDU, 3, FSMSCLen))
  else Result := '';
end;

function TSMS.GetTimeStamp: TDateTime;
var
  str: String;
  year, month, day, hour, minute, second: Integer;
begin
  if FIsSMSSumit then Result := 0
  else begin
    str := ReverseOctets(copy(FPDU, FSMSDeliverStartPos + FSenderLen + 10, 12));

    Year :=   StrToInt(copy(str,  1, 2));
    Month :=  StrToInt(copy(str,  3, 2));
    Day :=    StrToInt(copy(str,  5, 2));
    Hour :=   StrToInt(copy(str,  7, 2));
    Minute := StrToInt(copy(str,  9, 2));
    Second := StrToInt(copy(str, 11, 2));

    Result := EncodeDateTime(Year+2000, Month, Day, Hour, Minute, Second, 0);
  end;
end;

function TSMS.ReverseOctets(Octets: String): String;
var
  i: Integer;
  buffer: char;
begin
  i := 1;
  while i < length(Octets) do begin
    buffer := Octets[i];
    Octets[i] := Octets[i+1];
    Octets[i+1] := buffer;
    i := i + 2;
  end;

  result := Octets;
end;

procedure TSMS.SetPDU(const Value: String);
var
  PDUType, TPVPF: Byte;
  TPDCS: Integer;
  Offset: Integer;
begin
  {
  The following example shows how to send the message "hellohello" in the PDU mode from a Nokia 6110.

  AT+CMGF=0    //Set PDU mode
  AT+CSMS=0    //Check if modem supports SMS commands
  AT+CMGS=23  //Send message, 23 octets (excluding the two initial zeros)
  >0011000B916407281553F80000AA0AE8329BFD4697D9EC37<ctrl-z>

  There are 23 octets in this message (46 'characters'). The first octet ("00") doesn't count, it is only an indicator of the length of
  the SMSC information supplied (0). The PDU string consists of the following:

  Octet(s)            Description
  00                  Length of SMSC information. Here the length is 0, which means that the SMSC stored in the phone should be used.
                      Note: This octet is optional. On some phones this octet should be omitted! (Using the SMSC stored in phone is thus implicit)
  11                  First octet of the SMS-SUBMIT message.
  00                  TP-Message-Reference. The "00" value here lets the phone set the message reference number itself.
  0B                  Address-Length. Length of phone number (11)
  91                  Type-of-Address. (91 indicates international format of the phone number).
  6407281553F8        The phone number in semi octets (46708251358). The length of the phone number is odd (11), therefore a trailing
                      F has been added, as if the phone number were "46708251358F". Using the unknown format (i.e. the Type-of-Address
                      81 instead of 91) would yield the phone number octet sequence 7080523185 (0708251358). Note that this has the
                      length 10 (A), which is even.
  00                  TP-PID. Protocol identifier
  00                  TP-DCS. Data coding scheme.This message is coded according to the 7bit default alphabet. Having "04" instead of
                      "00" here, would indicate that the TP-User-Data field of this message should be interpreted as 8bit rather than
                      7bit (used in e.g. smart messaging, OTA provisioning etc).
  AA                  TP-Validity-Period. "AA" means 4 days. Note: This octet is optional, see bits 4 and 3 of the first octet
  0A                  TP-User-Data-Length. Length of message. The TP-DCS field indicated 7-bit data, so the length here is the number of
                      septets (10). If the TP-DCS field were set to 8-bit data or Unicode, the length would be the number of octets.
  E8329BFD4697D9EC37  TP-User-Data. These octets represent the message "hellohello". How to do the transformation from 7bit septets into
                      octets is shown here
  }
  FPDU := Value;

  // Check if PDU contain SMSC information
  try
    FSMSCLen := StrToInt('$' + copy(FPDU, 1, 2)) * 2; // length in octets * 2 = number of chars
  except
    FSMSCLen := 0;
  end;
  FSizeOfPDU := (Length(FPDU) - FSMSCLen) div 2 - 1; // number of chars - FSMSCLen's 2 chars

  FSMSDeliverStartPos := 3; // char number, first 2 represent FSMSCLen octet
  if FSMSCLen > 0 then FSMSDeliverStartPos := FSMSDeliverStartPos + FSMSCLen;

  // Check if SMS-Sumit or SMS-Deliver
  try
    {
    First octet of the SMS-DELIVER PDU
    The first octet of the SMS-DELIVER PDU has the following layout:

    Bit no  7        6        5        4        3        2       1       0
    Name    TP-RP    TP-UDHI  TP-SRI   (unused) (unused) TP-MMS  TP-MTI  TP-MTI

    Name    Meaning
    TP-RP   Reply path. Parameter indicating that reply path exists.
    TP-UDHI User data header indicator. This bit is set to 1 if the User Data field starts with a header
    TP-SRI  Status report indication. This bit is set to 1 if a status report is going to be returned to the SME
    TP-MMS  More messages to send. This bit is set to 0 if there are more messages to send
    TP-MTI  Message type indicator. Bits no 1 and 0 are both set to 0 to indicate that this PDU is an SMS-DELIVER
    }
    PDUType := StrToInt('$' + copy(FPDU, FSMSDeliverStartPos, 2));
  except
    PDUType := 0;
  end;
  FIsSMSSumit := (PDUType and 3) = 1;
  //Check there are Header Information
  FIsUDH := (PDUType and 64) = 64;
  // Get Validity Field Length
  FValidityLen := 0;
  Offset := 0;
  if FIsSMSSumit then begin
    TPVPF := (PDUType and $18) shr 3;

    case TPVPF of
      1: FValidityLen := 14;
      2: FValidityLen := 2;
      3: FValidityLen := 14;
    else FValidityLen := 0;
    end;

    Offset := 2;
  end;

  // Get Sender Field Length and Startpos
  FSenderPos := FSMSDeliverStartPos + Offset + 4;
  try
    FSenderLen := StrToInt('$' + copy(FPDU, FSenderPos - 2, 2)); // count of sender's number digits
  except
    FSenderLen := 0;
  end;
  if (FSenderLen mod 2) > 0 then FSenderLen := FSenderLen + 1;

  FMessageRef := Copy(FPDU, FSMSDeliverStartPos + 2, 2);
  try
    {
    The Type-of-Address octet indicates the format of a phone number. The most common value of this octet
    is 91 hex (10010001 bin), which indicates international format. A phone number in international format
    looks like 46708251358 (where the country code is 46). In the national (or unknown) format the same
    phone number would look like 0708251358. The international format is the most generic, and it has to
    be accepted also when the message is destined to a recipient in the same country as the MSC or as the SGSN.

    Using the unknown format (i.e. the Type-of-Address 81 instead of 91) would yield the phone number octet
    sequence 7080523185 (0708251358). Note that this has the length 10 (A), which is even. 
    }
    TPDCS := StrToInt('$' + copy(FPDU, FSenderPos + FSenderLen + 4, 2));
  except
    TPDCS := 0;
  end;
  {
    Should check DCS for $00abxxzz, where
      a = compression flag
      b = message class meaning
     xx = message data coding
     zz = message class

    So we are going to check bits 2 and 3 only ($00001100 = $C)
  }
  FDataCoding := (TPDCS and $0C) shr 2;
end;

//*const
//  Table: array[0..255] of byte =
// ( // 0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
//{0}   64, 163,  36, 165, 232, 233, 250, 236, 242, 199,  10, 216, 248,  13, 197, 229,
//{1}    0,  95,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 198, 230, 223, 202,
//{2}   32,  33,  34,  35, 164,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,
//{3}   48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,
//{4}  161,  65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
//{5}   80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90, 196, 214, 209, 220, 167,
//{6}  191,  97,  98,  99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
//{7}  112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 228, 246, 241, 252, 224,
//{8}    0,   0,   0,   0,   0,   0,   0,   0, 183,   0,   0,   0,   0,   0,   0,   0,
//{9}    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
//{A}    0, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172,   0, 174, 175,
//{B}  176, 177, 178, 179, 180, 181, 182,   0, 184, 185, 186, 187, 188, 189, 190, 191,
//{C}  192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207,
//{D}  208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223,
//{E}  224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
//{E}  240, 241, 242, 243, 244, 245, 246,   0,   0, 249, 250, 251, 252, 253, 254, 255
//  );

const
  Table: array[0..255] of byte =
  ( // 0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
{0}   64, 163,  36, 165, 232, 233, 250, 236, 242, 199,  10, 216, 248,  13, 197, 229,
{1}  196,  95, 214, 195, 203, 217, 208, 216, 211, 200, 206,   0, 198, 230, 223, 202,
{2}   32,  33,  34,  35, 164,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,
{3}   48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,
{4}  161,  65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
{5}   80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90, 196, 214, 209, 220, 167,
{6}  191,  97,  98,  99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
{7}  112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 228, 246, 241, 252, 224,
{8}    0,   0,   0,   0,   0,   0,   0,   0, 183,   0,   0,   0,   0,   0,   0,   0,
{9}    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
{A}    0, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172,   0, 174, 175,
{B}  176, 177, 178, 179, 180, 181, 182,   0, 184, 185, 186, 187, 188, 189, 190, 191,
{C}  192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207,
{D}  208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223,
{E}  224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
{E}  240, 241, 242, 243, 244, 245, 246,   0,   0, 249, 250, 251, 252, 253, 254, 255
  );

var
  GEscaped: Boolean;

function ConvertCharSet(inputChr: Char; toGSM: Boolean = False): Char;
var
  i: Integer;
  found: Boolean;
begin
  Result := inputChr;

  if toGSM then begin
    found := False;
    for i := 0 to 255 do begin
      if Table[i] = ord(inputChr) then begin
        Result := chr(i);
        found := True;
        break;
      end;
    end;

    if not found then begin
      case ord(inputChr) of
      12: Result := chr(10);
      91: Result := chr(60);
      92: Result := chr(47);
      93: Result := chr(62);
      94: Result := chr(20);
      123: Result := chr(40);
      124: Result := chr(64);
      125: Result := chr(41);
      126: Result := chr(61);
      164: Result := chr(101);
      else
        Result := chr(63);
      end;
    end;
  end
  else begin
    if ord(inputChr) = $1B then begin
      Result := chr(0);
      GEscaped := True;
    end
    else begin
      if GEscaped then begin
        GEscaped := false;
        case ord(inputChr) of
          10: Result := chr(12);
          20: Result := chr(94);
          40: Result := chr(123);
          41: Result := chr(125);
          47: Result := chr(92);
          60: Result := chr(91);
          61: Result := chr(126);
          62: Result := chr(93);
          64: Result := chr(124);
          101: Result := chr(164);
        else
          Result := chr(0);
        end;
      end
      else Result := chr(Table[Ord(inputChr)]);
    end;
  end;

end;

function ConvertCharSet(inputStr: String; toGSM: Boolean): String;
var
  i, v: Integer;
  escaped: Boolean;
begin
  Result := '';

  if toGSM then begin
    for i := 0 to length(inputStr) do
      Result := Result + ConvertCharSet(inputStr[i],toGSM);
  end
  else begin
    escaped := false;
    for i := 1 to length(inputStr) do begin
      v := ord(inputStr[i]);

      if escaped then begin
        escaped := false;
        case v of
          10: v := 12;
          20: v := 94;
          40: v := 123;
          41: v := 125;
          47: v := 92;
          60: v := 91;
          61: v := 126;
          62: v := 93;
          64: v := 124;
         101: v := 164;
        else
          v := 0;
        end;

        Result := Result + chr(v);
      end
      else begin
        if v <> $1B then Result := Result + chr(Table[v])
        else escaped := true;
      end;
    end;
  end;
end;



function TSMS.MakeCRLF(str: string): String;
var
  i: Integer;
  skipnext: boolean;
begin
  Result := '';
  skipnext := false;

  for i := 1 to length(str) do begin
    if skipnext then skipnext := false
    else begin
      // check if already CRLF paired
      if ((str[i] = #$0A) and (str[i+1] = #$0D)) or ((str[i] = #$0D) and (str[i+1] = #$0A)) then begin
        Result := Result + #$0D + #$0A;
        skipnext := true;
      end
      else if ((str[i] = #$0A) or (str[i] = #$0D)) then begin
        Result := Result + #$0D + #$0A;
      end
      else begin
        Result := Result + str[i];
      end;
    end;
  end;
end;

function CheckCodingType(str: WideString): Integer;
var
  str8bit: AnsiString;
  i: Integer;
begin
  Result := 0;
  str8bit := str;  
  if str8bit <> str then
    Result := 2
  else begin
    for i := 1 to length(str8bit) do begin
      { workaround for UCS-2 excoding of cyrilic (and other i18n) chars }
      if ForceUCSusage or (DoStrictUCScheck and (str8bit[i] in ['�'..'�','�'..'�'])) then begin
        Result := 2;
        break;
      end;
      if (ord(ConvertCharSet(str8bit[i], True)) and $80) = $80 then begin
        Result := 1;
        break;
      end;
    end;
  end;
end;

procedure TSMS.Set_MessageRef(const Value: String);
begin
  FMessageRef := Copy(Value,1,2);
  while Length(FMessageRef) < 2 do FMessageRef := '0' + FMessageRef;
end;

function TSMS.GetNewPDU(AMessageReference: String): String;
begin
  MessageReference := AMessageReference;

  FSMSCLen := StrToInt('$' + copy(FPDU, 1, 2)) * 2;
  FSizeOfPDU := (Length(FPDU) - FSMSCLen) div 2 - 1;

  FSMSDeliverStartPos := 3;
  if FSMSCLen > 0 then FSMSDeliverStartPos := FSMSDeliverStartPos + FSMSCLen;

  FPDU[FSMSDeliverStartPos + 2] := FMessageRef[1];
  FPDU[FSMSDeliverStartPos + 3] := FMessageRef[2];

  Result := FPDU;
end;

end.
