unit GsmSms;

{
*******************************************************************************
* Descriptions: GSM CODEC
* $Source: /cvsroot/fma/fma/uSMS.pas,v $
* $Locker:  $
*
* Todo:
*
* Sample test SMS messages: 
* - ���� � ���� �������� �����, ����� �� �������� �� ��������� �� ��������� �� ������.
* - But according to the late Douglas Adams in The Hitch-Hitchhiker's hiker's Guide to the Galaxy Trilogy,
*   "In the beginning the Universe was created. This has made a lot of people very angry and been widely
*   regarded as a bad move".
*
* Change Log:
* $Log: uSMS.pas,v $
*
}

interface

uses
  SysUtils, {TntSysUtils, }DateUtils, Dialogs, {TntDialogs, }StrUtils;

{ SMS Packet Format (PDU format) info:

  http://www.gsmfavorites.com/sms/packet-format/ }

type
  TGSMCodingScheme = (gcsDefault7Bit, gcs8BitOctets, gcs16bitUcs2, gcsUnknown);

  TSMSDecoder = class(TObject)
  private
    function ReverseOctets(Octets: String): String;
    function DecodeNumber(raw: String): String;
    function EncodeNumber(Number: String): String;
    function MakeCRLF(str: Widestring): WideString;
    function DecodeTimeStamp(raw: String): TDateTime;
  protected
    FPDU: String;
    FDataCoding: Integer;
  public
    property PDU: String read FPDU write FPDU;
  end;

  TSMS = class(TSMSDecoder)
  private
    FIsSMSSumit: Boolean;
    FValidityLen: Integer;
    FSMSCLen: Integer;
    FSenderLen: Integer;
    FSenderPos: Integer;
    FSMSDeliverStartPos: Integer;
    FMessage: WideString;
    FMessageRef: String;
    FAddress: String;
    FFlashSMS: Boolean;
    FRequestReply: Boolean;
    FMessageLength: Integer;
    FIsUDH: Boolean;
    FUDHI: String;
    FVPF: Byte;
    FStatusRequest: Boolean;
    FSizeOfPDU: integer;
    FDCS: TGSMCodingScheme;
    {}
    procedure Set_PDU(const Value: String);
    procedure Set_MessageRef(const Value: String);
    procedure Set_Message(const Value: WideString);
    procedure Set_UDHI(const Value: String);
    function Get_PDU: String;
    function Get_Message: WideString;
    function Get_Address: String;
    function Get_SMSC: String;
    function Get_TimeStamp: TDateTime;
    function Get_Validity: TDateTime;
    function Get_CodingScheme: TGSMCodingScheme;
  public
    function NewMessageRefPDU(NewRef: String): String;
    { tech.info }
    property PDU: String read Get_PDU write Set_PDU;
    property UDHI: String read FUDHI write Set_UDHI;
    property TPLength: integer read FSizeOfPDU;
    property TimeStamp: TDateTime read Get_TimeStamp;
    property MessageReference: String read FMessageRef write Set_MessageRef;
    property Validity: TDateTime read Get_Validity;
    { text }
    property Text: WideString read Get_Message write Set_Message;
    property TextEncoding: TGSMCodingScheme read Get_CodingScheme write FDCS;
    { numbers }
    property Number: String read Get_Address write FAddress;
    property SMSC: String read Get_SMSC;
    { flags }
    property StatusRequest: Boolean read FStatusRequest write FStatusRequest;
    property RequestReply: Boolean read FRequestReply write FRequestReply;
    property FlashSMS: Boolean read FFlashSMS write FFlashSMS;
    { other }
    property IsOutgoing: Boolean read FIsSMSSumit;
    property IsUDH: Boolean read FIsUDH;
  end;

  TSMSStatusReport = class(TSMSDecoder)
  private
    FSCAPresent, FIsUDH: boolean;
    FSCA, FUDHI: string;
    FStatus: byte;
    FSCATS, FDTS: TDateTime;
    FMessage: WideString;
    FMessageRef: string;
    FAddress: String;
    FDCS: TGSMCodingScheme;
    FUserNotified: Boolean;
    procedure Set_PDU(const Value: String);
    function Get_IsDelivered: boolean;
  public
    constructor Create(ExpectSCA: boolean = False);

    property PDU: string read FPDU write Set_PDU;
    property MessageReference: string read FMessageRef;
    property OriginalSentTime: TDateTime read FSCATS;
    property DischargeTime: TDateTime read FDTS;
    property Number: String read FAddress;
    property StatusCode: Byte read FStatus;
    property Delivered: Boolean read Get_IsDelivered;
    property Text: WideString read FMessage;
    property UDHI: String read FUDHI;
    property IsUDH: Boolean read FIsUDH;
    property SMSC: String read FSCA;
    property IsUserNotified: Boolean read FUserNotified write FUserNotified; // FMA only field
  end;

function GSMLongMsgData(PDU: string; var ARef, ATot, An: Integer): boolean;

function GSMCodingScheme(const Value: WideString): TGSMCodingScheme;

function GSMLength7Bit(const Value: WideString): integer;

function GSMDecode7Bit(Value: string): WideString;
function GSMEncode7Bit(const Value: WideString): string;

function GSMDecode8Bit(Value: string): WideString;
function GSMEncode8Bit(const Value: WideString): string;

function GSMDecodeUcs2(Value: string): WideString;
function GSMEncodeUcs2(const Value: WideString): string;

implementation

uses
//  gnugettext, gnugettexthelpers,
  cUnicodeCodecs,
  Windows{, Unit1, uLogger};

{ The 7 bit default alphabet as specified by GSM 03.38, see:

  http://www.unicode.org/Public/MAPPINGS/ETSI/GSM0338.TXT
  http://www.tvrelsat.com/sentinel/pdf/0338-700.pdf
  http://www.dreamfabric.com/sms/default_alphabet.html }

const
  Alphabet7Escape: byte = $1B; // 27

{ The ETSI GSM 03.38 specification shows an uppercase C-cedilla (code 199)
  glyph at 0x09. This may be the result of limited display
  capabilities for handling characters with descenders. However, the
  language coverage intent is clearly for the lowercase c-cedilla
  which has code 231 (see mapping 09th).
}
  Alphabet7Bit: array[0..127] of word = (
      {0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F}
{0}   64, 163,  36, 165, 232, 233, 249, 236, 242, 199,  10, 216, 248,  13, 197, 229,
{1} $394,  95,$3A6,$393,$39B,$3A9,$3A0,$3A8,$3A3,$398,$39E,  27, 198, 230, 223, 201,
{2}   32,  33,  34,  35, 164,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,
{3}   48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,
{4}  161,  65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
{5}   80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90, 196, 214, 209, 220, 167,
{6}  191,  97,  98,  99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
{7}  112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 228, 246, 241, 252, 224);


{ 7BIT helper functions }

function Unpack7Bit(const Value: string): string;
var
  i,j: Integer;
  x,leftover,octet: byte;
  c,septets: string;
begin
  Result := '';
  j := Round(Length(Value) / 2) - 1;
  septets := '';
  x := 1;
  leftover := 0;
  for i := 0 to j do begin
    c := copy(Value, (i*2)+1, 2);
    if not (c[1] in ['0'..'9','A'..'F']) then // do not localize
      break;
    if (Length(c) = 2) and not (c[2] in ['0'..'9','A'..'F']) then // do not localize
      Delete(c,2,1);
    octet := StrToInt('$' + c);
    septets := septets + Chr(((octet and ($FF shr x)) shl (x - 1)) or leftover);
    leftover := (octet and (not ($FF shr x))) shr (8 - x);
    x := x + 1;
    if x = 8 then begin
      if (i <> j) or (leftover <> 0) then
        septets := septets + Chr(leftover);
      x := 1;
      leftover := 0;
    end;
  end;
  Result := septets;
end;

function Pack7Bit(const Value: string): string;
var
  i,j: integer;
  x,nextChr: byte;
  septets,Octet: string;
begin
  Result := '';
  septets := Value;
  x := 0;
  j := length(septets);
  for i := 1 to j do begin
    if x < 7 then begin
      if i = j then
        nextChr := 0
      else
        nextChr := Ord(septets[i+1]);
      Octet := IntToHex(((nextChr and (not ($FF shl (x+1)))) shl (7-x)) or (Ord(septets[i]) shr x),2);
      Result := Result + Octet;
      x := x + 1;
    end
    else
      x := 0;
  end;
end;

function AlphabetIndex7Bit(AChar: WideChar): integer;
var
  i: integer;
  w: word;
begin
  Result := -1;
  w := Ord(AChar);
  for i := 0 to 127 do
    if Alphabet7Bit[i] = w then begin
      Result := i;
      break;
    end;
end;

function EscapeIndex7Bit(AChar: WideChar): integer;
begin
  case Ord(AChar) of
    12,27,91,92,93,94,123,124,125,126,8364:
      Result := Ord(AChar);
    else
      Result := -1;
  end;
end;

function Is7Bit(AChar: WideChar): boolean;
begin
  Result := (AlphabetIndex7Bit(AChar) <> -1) or (EscapeIndex7Bit(AChar) <> -1);
end;

function Encode7Bit(const Value: WideString): string;
var
  item: char;
  septets: string;
  i,j: integer;
  len: integer;
begin
  Result := '';
  septets := '';
  len := Length(Value);
  i := 1;
  while i <= len do begin
    j := AlphabetIndex7Bit(Value[i]);
    if j = -1 then begin
      { not in alphabet, so look for escape sequence }
      case EscapeIndex7Bit(Value[i]) of
         12: item := chr(10); { FORM FEED }
         27: item := chr(27); { next escape table }
         91: item := chr(60);
         92: item := chr(47);
         93: item := chr(62);
         94: item := chr(20);
        123: item := chr(40);
        124: item := chr(64);
        125: item := chr(41);
        126: item := chr(61);
       8364: item := chr(101); { Euro sign }
        else
          { 63 = '?' (FMA specific implementation) should we fail/error here? }
          item := chr(63);
      end;
      septets := septets + chr(Alphabet7Escape);
    end
    else
      { found in alphabet }
      item := chr(j);
    septets := septets + item;
    inc(i);
  end;
  Result := septets;
end;

{ 7BIT }

function GSMLength7Bit(const Value: WideString): integer;
begin
  Result := Length(Encode7Bit(Value));
end;

function GSMDecode7Bit(Value: string): WideString;
var
  i,j,k,len: integer;
  w: word;
begin
  Result := '';
  Value := Unpack7Bit(Value);
  len := Length(Value);
  i := 1;
  while i <= len do begin
    j := Byte(Value[i]);
    if j <= 127 then w := Alphabet7Bit[j]
      else w := 0; { should error here? }
    if j = Alphabet7Escape then begin
      inc(i);
      if i > len then break;
      {	The ESC character 0x1B is mapped to the no-break space character, unless it is part of a
        valid ESC sequence, to facilitate round-trip compatibility in the presence of unknown ESC
        sequences. }
      case Byte(Value[i]) of
        10: w := 12; { FORM FEED }
        20: w := 94;
        27: { Alphabet7Escape:
              This code value is reserved for the extension to another extension table. On receipt of this
              code, a receiving entity shall display a space until another extension table is defined. }
            w := 32;
        40: w := 123;
        41: w := 125;
        47: w := 92;
        60: w := 91;
        61: w := 126;
        62: w := 93;
        64: w := 124;
       101: w := 8364; { Euro sign }
       else begin
         { 63 = '?' (FMA specific implementation) }
         w := 63;
         // WE HAVE CONFLICT IN THE DOCS!!! A -or- B
         { A. http://www.unicode.org/Public/MAPPINGS/ETSI/GSM0338.TXT
           The ESC character 0x1B is mapped to the no-break space character, unless it is part of a
           valid ESC sequence, to facilitate compatibility in the presence of unknown ESC sequences. }
         //w := 32;
         { B. http://www.tvrelsat.com/sentinel/pdf/0338-700.pdf
           In the event that an MS receives a code where a symbol is not represented in the ESC table
           then the MS shall display the character shown in the main default 7 bit alphabet table. }
         //continue;
       end;  
      end; {case}
    end
    else begin
      { 0x00 is NULL (when followed only by 0x00 up to the end of (fixed byte length) message, possibly
        also up to FORM FEED.  But 0x00 is also the code for COMMERCIAL AT when some other character
        (CARRIAGE RETURN if nothing else) comes after the 0x00. }
      if (j = 0) and (i < len) and (Byte(Value[i+1]) = 0) then begin
        k := i+2;
        while (k <= len) and (Byte(Value[k]) = 0) do inc(k); // 0x00 up to the...
        if (k > len) or // ...end of (fixed byte length) message -or- FORM FEED
          ((k < len) and (Byte(Value[k]) = Alphabet7Escape) and ((Byte(Value[k+1]) = 10))) then begin
          i := k-1;
          w := 0; // NULL unicode char
        end;
      end;
    end;
    Result := Result + WideChar(w);
    inc(i);
  end;
end;

function GSMEncode7Bit(const Value: WideString): string;
begin
  Result := Pack7Bit(Encode7Bit(Value));
end;

{ 8BIT }

function GSMDecode8Bit(Value: string): WideString;
var
  i,Octet: integer;
begin
  Result := '';
  if (Length(Value) mod 2) <> 0 then
    Value := Value + '0';
  for i := 0 to (Length(Value) div 2) - 1 do begin
    Octet := StrToInt('$' + copy(Value, (i*2)+1, 2));
    Result := Result + WideChar(Octet);
  end;
end;

function GSMEncode8Bit(const Value: WideString): string;
var
  i,j: integer;
  w: word;
  Octet: string;
begin
  Result := '';
  j := length(Value);
  // all WideChars must be less than 256
  for i := 1 to j do begin
    w := Ord(Value[i]);
    if w > MAXBYTE then raise Exception.Create('Unable to use 8bit encoding!');
    Octet := IntToHex(w,2);
    Result := Result + Octet;
  end;
end;

{ UCS2 }

function GSMDecodeUcs2(Value: string): WideString;
var
  i,j: integer;
  c: TUCS2Codec;
  w: WideString;
  s: string;
begin
  Result := '';
  { Convert HEX string sequence to UCS2 }
  while (Length(Value) mod 4) <> 0 do
    Value := Value + '0';
  s := '';
  for i := 0 to Length(Value) div 4 - 1 do
    s := s + Char(StrToInt('$'+copy(Value,(i*4)+3,2))) +
             Char(StrToInt('$'+copy(Value,(i*4)+1,2)));
  c := TUCS2Codec.Create;
  try
    i := Length(s);
    SetLength(w,i); // reserve double sized memory
    c.Decode(@s[1],i,@w[1],i,i,j);
    { TODO: check if whole Value is processed (i == Length(s)?) }
    Result := Copy(w,1,j);
  finally
    c.Free;
  end;
end;

function GSMEncodeUcs2(const Value: WideString): string;
var
  i,j: integer;
  Wide: string;
begin
  Result := '';

  j := Length(Value);
  for i := 1 to j do begin
    Wide := IntToHex(Ord(Value[i]),4);
    Result := Result + Wide;
  end;
end;

{ UTF8 - found on internet - not used in fma ! }

function GSMDecodeUTF8(const Value: string): string;
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
      { find out the number of bytes used for this character }
      N:=0;
      for j:=1 to 8 do begin
        { start with the highest bit and count the "1" before "0" }
        if (byte(Value[i]) and (1 shl (8-j))) = 0 then Break;
        inc(N);
      end;
      HugeChar:=byte(Value[i]) and ($FF shr (N+1));
      for j:=1 to N-1 do begin
        HugeChar:=(HugeChar shl 6) or byte(byte(Value[i+j]) and $3F);
      end;
      Result:=Result+char(HugeChar);
      i:=i+N;
    end;
  end;
end;

function GSMEncodeUTF8(const Value: string): string; //only work on bytes 0..255
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

{ Country Codes
  ISO 3166 alphabetical list of country codes with the associated International Dialing Code

Type
  TCountryCode = record
    name,code: string;
  end;

Const
  CountryCodes = array[0..x,0..1] of string = ( //TCountryCode = (
    'Afghanistan (Islamic State of)','93',
    'Albania (Republic of)','355',
    'Algeria (People''s Democratic Republic of)','213',
    'American Samoa','684',
    'Andorra (Principality of)','376',
    'Angola (Republic of)','244',
    'Anguilla','1',
    'Antigua and Barbuda','1',
    'Argentine Republic','54',
    'Armenia (Republic of)','374',
    'Aruba','297',
    'Ascension','247',
    'Australia','61',
    'Australian External Territories','672',
    'Austria','43',
    'Azerbaijani Republic','994',
    'Bahamas (Commonwealth of the)','1',
    'Bahrain (State of)','973',
    'Bangladesh (People''s Republic of)','880',
    'Barbados','1',
    'Belarus (Republic of)','375',
    'Belgium','32',
    'Belize','501',
    'Benin (Republic of)','229',
    'Bermuda','1',
    'Bhutan (Kingdom of)','975',
    'Bolivia (Republic of)','591',
    'Bosnia and Herzegovina','387',
    'Botswana (Republic of)','267',
    'Brazil (Federative Republic of)','55',
    'British Virgin Islands','1',
    'Brunei Darussalam','673',
    'Bulgaria (Republic of)','359',
    'Burkina Faso','226',
    'Burundi (Republic of)','257',
    // TODO...
    'Cambodia (Kingdom of) 855
    'Cameroon (Republic of) 237
    'Canada 1
    'Cape Verde (Republic of) 238
    'Cayman Islands 1 
    'Central African Republic 236
    'Chad (Republic of) 235
    'Chile 56
    'China (People's Republic of) 86
    'Colombia (Republic of) 57 
    'Comoros 269 
    'Congo (Republic of the) 242 
    'Cook Islands 682
    'Costa Rica 506
    'C�te d'Ivoire (Republic of) 225
    'Croatia (Republic of) 385 
    'Cuba 53
    'Cyprus (Republic of) 357
    'Czech Republic 420
    'Democratic People's Republic of Korea 850
    'Democratic Republic of the Congo 243 
    'Denmark 45
    'Diego Garcia 246
    'Djibouti (Republic of) 253
    'Dominica (Commonwealth of) 1
    'Dominican Republic 1 
    'East Timor 670 
    'Ecuador 593
    'Egypt (Arab Republic of) 20
    'El Salvador (Republic of) 503 
    'Equatorial Guinea (Republic of) 240
    'Eritrea 291 
    'Estonia (Republic of) 372
    'Ethiopia 251
    'Falkland Islands (Malvinas) 500
    'Faroe Islands 298
    'Fiji (Republic of) 679 
    'Finland 358
    'France 33
    'French Guiana 594
    'French Polynesia 689
    'Gabonese Republic 241 
    'Gambia (Republic of the) 220
    'Georgia 995 
    'Germany (Federal Republic of) 49
    'Ghana 233 
    'Gibraltar 350
    'Greece 30 
    'Greenland (Denmark) 299
    'Grenada 1
    'Group of countries, shared code 388
    'Guadeloupe (French Department of) 590
    'Guam 1 
    'Guatemala (Republic of) 502
    'Guinea (Republic of) 224
    'Guinea-Bissau (Republic of) 245
    'Guyana 592
    'Haiti (Republic of) 509 
    'Honduras (Republic of) 504 
    'Hongkong 852 
    'Hungary (Republic of) 36
    'Iceland 354
    'India (Republic of) 91
    'Indonesia (Republic of) 62
    'International Freephone Service 800
    'Iran 98
    'Iraq (Republic of) 964
    'Ireland 353
    'Israel (State of) 972 
    'Italy 39
    'Jamaica 1
    'Japan 81
    'Jordan (Hashemite Kingdom of) 962
    'Kazakstan (Republic of) 7 
    'Kenya (Republic of) 254 
    'Kiribati (Republic of) 686 
    'Korea (Republic of) 82
    'Kuwait (State of) 965 
    'Kyrgyz Republic 996
    'Lao People's Democratic Republic 856 
    'Latvia (Republic of) 371
    'Lebanon 961
    'Lesotho (Kingdom of) 266
    'Liberia (Republic of) 231
    'Libya 218
    'Liechtenstein (Principality of) 423
    'Lithuania (Republic of) 370
    'Luxembourg 352
    'Macau 853
    'Macedonia 389 
    'Madagascar (Republic of) 261
    'Malawi 265 
    'Malaysia 60
    'Maldives (Republic of) 960 
    'Mali (Republic of) 223
    'Malta 356 
    'Marshall Islands (Republic of the) 692
    'Martinique (French Department of) 596
    'Mauritania (Islamic Republic of) 222
    'Mauritius (Republic of) 230
    'Mayotte 269 
    'Mexico 52
    'Micronesia (Federated States of) 691
    'Moldova (Republic of) 373
    'Monaco (Principality of) 377
    'Mongolia 976
    'Montserrat 1 
    'Morocco (Kingdom of) 212
    'Mozambique (Republic of) 258
    'Myanmar (Union of) 95 
    'Namibia (Republic of) 264
    'Nauru (Republic of) 674
    'Nepal 977
    'Netherlands (Kingdom of the) 31
    'Netherlands Antilles 599
    'New Caledonia 687
    'New Zealand 64 
    'Nicaragua 505
    'Niger (Republic of the) 227
    'Nigeria (Federal Republic of) 234
    'Niue 683
    'Northern Mariana Islands 1 
    'Norway 47 
    'Oman (Sultanate of) 968 
    'Pakistan (Islamic Republic of) 92
    'Palau (Republic of) 680 
    'Panama (Republic of) 507
    'Papua New Guinea 675 
    'Paraguay (Republic of) 595
    'Peru 51
    'Philippines (Republic of the) 63
    'Poland (Republic of) 48
    'Portugal 351
    'Puerto Rico 1
    'Qatar (State of) 974
    'Reserved 0
    'Reunion (French Department of) 262
    'Romania 40 
    'Russian Federation 7
    'Rwandese Republic 250 
    'Saint Helena 290
    'Saint Kitts and Nevis 1 
    'Saint Lucia 1
    'Saint Pierre and Miquelon 508 
    'Saint Vincent and the Grenadines 1
    'Samoa (Independent State of) 685
    'San Marino (Republic of) 378
    'Sao Tome and Principe 239
    'Saudi Arabia (Kingdom of) 966 
    'Senegal (Republic of) 221
    'Seychelles (Republic of) 248
    'Sierra Leone 232
    'Singapore (Republic of) 65
    'Slovak Republic 421
    'Slovenia (Republic of) 386
    'Solomon Islands 677 
    'Somali Democratic Republic 252
    'South Africa (Republic of) 27 
    'Spain 34
    'Spare code 422 
    'Spare code 671
    'Sri Lanka 94
    'Sudan (Republic of the) 249
    'Suriname (Republic of) 597
    'Swaziland (Kingdom of) 268 
    'Sweden 46
    'Switzerland (Confederation of) 41
    'Syrian Arab Republic 963
    'Tajikistan 992
    'Tanzania (United Republic of) 255 
    'Thailand 66
    'Togolese Republic 228 
    'Tokelau 690
    'Tonga (Kingdom of) 676 
    'Trinidad and Tobago 1
    'Tunisia 216 
    'Turkey 90
    'Turkmenistan 993
    'Turks and Caicos Islands 1
    'Tuvalu 688
    'Uganda (Republic of) 256 
    'Ukraine 380
    'United Arab Emirates 971
    'United Kingdom 44
    'United States 1
    'United States Virgin Islands 1 
    'Uruguay (Eastern Republic of) 598 
    'Uzbekistan (Republic of) 998
    'Vanuatu (Republic of) 678
    'Vatican City State 39
    'Vatican City State 379
    'Venezuela (Bolivarian Republic of) 58
    'Viet Nam (Socialist Republic of) 84
    'Wallis and Futuna 681
    'Yemen (Republic of) 967
    'Yugoslavia (Federal Republic of) 381
    'Zambia (Republic of) 260 
    'Zimbabwe (Republic of) 263
  end;
}

(*
  http://developer.apple.com/documentation/Darwin/Reference/ManPages/man3/Encode::Unicode.3pm.html

  Surrogate Pairs
  ---------------

       To say the least, surrogate pairs were the biggest mistake of the Uni-Unicode
       code Consortium.  But according to the late Douglas Adams in The Hitch-Hitchhiker's
       hiker's Guide to the Galaxy Trilogy, "In the beginning the Universe was
       created. This has made a lot of people very angry and been widely
       regarded as a bad move".  Their mistake was not of this magnitude so
       let's forgive them.

       (I don't dare make any comparison with Unicode Consortium and the
       Vogons here ;)  Or, comparing Encode to Babel Fish is completely appro-appropriate
       priate -- if you can only stick this into your ear :)

       Surrogate pairs were born when the Unicode Consortium finally admitted
       that 16 bits were not big enough to hold all the world's character
       repertoires.  But they already made UCS-2 16-bit.  What do we do?

       Back then, the range 0xD800-0xDFFF was not allocated.  Let's split that
       range in half and use the first half to represent the "upper half of a
       character" and the second half to represent the "lower half of a char-character".
       acter".  That way, you can represent 1024 * 1024 = 1048576 more charac-characters.
       ters.  Now we can store character ranges up to \x{10ffff} even with
       16-bit encodings.  This pair of half-character is now called a surro-surrogate
       gate pair and UTF-16 is the name of the encoding that embraces them.

       Here is a formula to ensurrogate a Unicode character \x{10000} and
       above;

         $hi = ($uni - 0x10000) / 0x400 + 0xD800;
         $lo = ($uni - 0x10000) % 0x400 + 0xDC00;

       And to desurrogate;

        $uni = 0x10000 + ($hi - 0xD800) * 0x400 + ($lo - 0xDC00);

       Note this move has made \x{D800}-\x{DFFF} into a forbidden zone!
*)

{

  http://www.unicode.org/unicode/faq/utf_bom.html#22

  A byte order mark (BOM) consists of the character code U+FEFF at the beginning of a data stream,
  where it can be used as a signature defining the byte order and encoding form, primarily of unmarked
  plaintext files. Under some higher level protocols, use of a BOM may be mandatory (or prohibited)
  in the Unicode data stream defined in that protocol.

  BOM can be used as a signature no matter how the Unicode text is transformed: UTF-16, UTF-8, UTF-7, etc.
  The exact bytes comprising the BOM will be whatever the Unicode character FEFF is converted into by
  that transformation format. In that form, the BOM serves to indicate both that it is a Unicode file,
  and which of the formats it is in. Examples:

      Bytes          Encoding Form
      ------------------------------------
      00 00 FE FF    UTF-32, big-endian
      FF FE 00 00    UTF-32, little-endian
      FE FF          UTF-16, big-endian
      FF FE          UTF-16, little-endian
      EF BB BF       UTF-8
}

function GSMCodingScheme(const Value: WideString): TGSMCodingScheme;
var
  i: Integer;
begin
  Result := gcsDefault7Bit;
  for i := 1 to Length(Value) do
    if not Is7Bit(Value[i]) then begin
      Result := gcsUnknown; // 7bit failed
      break;
    end;

  if Result = gcsUnknown then begin
    Result := gcs8BitOctets;
    for i := 1 to Length(Value) do
      if Ord(Value[i]) > 255 then begin
        Result := gcsUnknown; // 8bit failed
        break;
      end;
  end;

  if Result = gcsUnknown then
    Result := gcs16bitUcs2; // use UCS2 if other failed
end;

  { http://www.spallared.com/old%5Fnokia/nokia/smspdu/smspdu.htm
    http://www.gsmfavorites.com/sms/packet-format/ }

function GSMLongMsgData(PDU: string; var ARef, ATot, An: Integer): boolean;
var
  UDHI: string;
  pos, octet, udhil: Integer;
  sms: TSMS;
begin
  ARef := -1; ATot := -1; An := -1;
  sms := TSMS.Create;
  try
    sms.PDU := PDU;
    sms.Text; // Update PDU fields
    if sms.IsUDH then begin
      UDHI := sms.UDHI;
      udhil := StrToInt('$' + copy(UDHI, 1, 2));
      //ANALIZE UDHI
      UDHI := Copy(UDHI, 3, length(UDHI));
      while UDHI <> '' do begin
        //Get the octet for type
        octet := StrToInt('$' + Copy(UDHI, 1, 2));
        UDHI := Copy(UDHI, 3, length(UDHI));
        case octet of
          0: begin // SMS CONCATENATION WITH 8bit REF
               ARef := StrToInt('$' + Copy( UDHI, 3, 2));
               ATot := StrToInt('$' + Copy( UDHI, 5, 2));
               An := StrToInt('$' + Copy( UDHI, 7, 2));
             end;
          8: begin // SMS CONCATENATION WITH 16bit REF
               ARef := StrToInt('$' + Copy( UDHI, 3, 4));
               ATot := StrToInt('$' + Copy( UDHI, 7, 2));
               An := StrToInt('$' + Copy( UDHI, 9, 2));
             end;
        else begin
               pos := udhil + 1;
               UDHI := Copy(UDHI, pos * 2 + 1, length(UDHI));
             end;
        end;
      end;
    end;
  finally
    sms.Destroy;
    Result := ATot > 1;
  end;
end;

{ TSMSDecoder }

function TSMSDecoder.DecodeTimeStamp(raw: String): TDateTime;
var
  Year, Month, Day, Hour, Minute, Second: Integer;
  offset: integer;
begin
  // raw must have 7 octets
  try
    raw := ReverseOctets(raw);

    Year :=   StrToInt(copy(raw,  1, 2));
    Month :=  StrToInt(copy(raw,  3, 2));
    Day :=    StrToInt(copy(raw,  5, 2));
    Hour :=   StrToInt(copy(raw,  7, 2));
    Minute := StrToInt(copy(raw,  9, 2));
    Second := StrToInt(copy(raw, 11, 2));
    // TODO: 7th octet is TimeZone, decode it

    if year >= 90 then offset := 1900
    else offset := 2000;
    Result := EncodeDateTime(offset+Year, Month, Day, Hour, Minute, Second, 0);

  except
    On E: Exception do
      Result:=Now;
  end;
end;

function TSMSDecoder.DecodeNumber(raw: String): String;
var
  addrType: Integer;
begin
  try
    addrType := StrToInt('$' + copy(Raw, 1, 2));
    if ((addrType and $50) = $50) then begin
      //Result := Get7bit(copy(Raw, 3, length(Raw) - 2));
      Result := GSMDecode7Bit(copy(Raw, 3, length(Raw) - 2));
    end
    else begin
      Result := ReverseOctets(copy(Raw, 3, length(Raw) - 2));
      if (Result <> '') and (Result[length(Result)] = 'F') then
        Result := copy(Result, 1, length(Result) - 1); // do not localize
      if (Result <> '') and (((StrToInt('$' + copy(Raw, 1, 2)) and $70) shr 4) = 1) then
        Result := '+' + result;
    end;
  except
    Result := '';
  end;
end;

function TSMSDecoder.EncodeNumber(Number: String): String;
begin
  Result := '81'; // do not localize

  if (Number <> '') and (Number[1] = '+') then begin
    Result := '91'; // International Numner, ISDN/Telephone (E.164/E.163) // do not localize
    Number := copy(Number, 2, length(Number));
  end;

  Result := IntToHex(length(Number), 2) + Result;

  if length(Number) mod 2 > 0 then Number := Number + 'F'; // do not localize
  Result := Result + ReverseOctets(Number);
end;

{ TSMS }

function TSMS.Get_Message: WideString;
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

    { Sample PDU which is from Long SMS and doesn't contains UDHI!

      005143048101010000FFA00000000000005A20631A5F2683825650592E7F
      CB417774D90D2AE2E1ECB7BC2C0739DFE4B28B18A68741E939C89964BA1A
      8A16C898C697C9206B589E7ED7E7A07BDA4D7EDF41E4B2395C67D34173F4
      FB0E82BFE7697AFAED7635142D90318D2F9341D2329C1DCE83DE6E10F3ED
      3E83A6CD2948C47CBBCF2290B84EA7BFDDA0393D4C2FBB1A8A16C898C697
      C9
    }
    if FIsUDH then begin
      UDHILength := StrToInt('$' + copy(FPDU, startpos + 2, 2));
      UDHnull := '';

      FUDHI := copy(FPDU, startpos + 2, UDHILength * 2 + 2);

      //Replace UDH with NULL chars
      for i:=0 to UDHILength do
        UDHnull := UDHnull + '00';

      Delete(FPDU,startpos + 2,UDHILength * 2 + 2);
      Insert(UDHNull,FPDU,startpos + 2);
      //FPDU := AnsiReplaceStr(FPDU, FUDHI, UDHNull);
    end;

    // TP-User-Data-Length. Length of message. The TP-DCS field indicated 7-bit data, so the length here is the number
    // of septets. If the TP-DCS field were set to 8-bit data or Unicode, the length would be the number of octets.
    FMessageLength := StrToInt('$' + copy(FPDU, startpos, 2));

    if FDataCoding = 0 then begin
       str := copy(FPDU, startpos + 2, length(FPDU)); // process the rest of PDU data, will cut the message length later

       //Result := Get7bit(str);
       Result := GSMDecode7Bit(str);

       // here FMessageLength contains number of septets (decoded chars)
       if FIsUDH then
         Result := Copy(Result, ((UDHILength div 7) + UDHILength + 2) + 1, FMessageLength)
       else
         Result := Copy(Result, 1, FMessageLength);
    end
    else
    if FDataCoding = 1 then begin
       // here FMessageLength contains numbers of octets (encoded bytes)
       if FIsUDH then
         str := copy(FPDU, startpos + (UDHIlength+1)*2 + 2, (FMessageLength)*2)
       else
         str := copy(FPDU, startpos + 2, (FMessageLength)*2);

       //Result := Get8bit(str);
       Result := GSMDecode8Bit(str);

       {if FIsUDH then
         Result := Copy(Result, UDHILength + 1, Length(Result));}
    end
    else
    if FDataCoding = 2 then begin
       // here FMessageLength contains numbers of octets (encoded bytes)
       if FIsUDH then
         str := copy(FPDU, startpos + (UDHIlength+1)*2 + 2, (FMessageLength)*2)
       else
         str := copy(FPDU, startpos + 2, (FMessageLength)*2);

       //Result := GetUCS2(str);
       Result := GSMDecodeUcs2(str);

       {if FIsUDH then begin
         i := ((UDHILength + 1) mod 4) + 2;
         Result := Copy(Result, i, Length(Result));
       end;}
    end
    else Result := ('(Unsupported: Unknown coding scheme)');

    Result := MakeCRLF(Result);
  except
    Result := ('(Decoding Error)');
  end;
end;

function TSMS.Get_PDU: String;
var
  udhl: Integer;
  i,head,code: Integer;
  {
  j,x: Integer;
  Octet: String;
  nextChr: Byte;
  }
  pduAddr, pduMsgL, pduMsg: String;
  pduSMSC, pduFirst, pduMsgRef, pduPID, pduDCS, pduTPVP: String;
  AMessage: WideString;
  dcs: TGSMCodingScheme;
begin
  { WARNING! GetPDU generates only SMS-SUBMIT type pdu !! }
  AMessage := FMessage;
  udhl := 0;
  try
    { Convert Address (Destination No) }
    pduAddr := EncodeNumber(FAddress);

    { Detect Data Coding Scheme (DCS)
      The TP-Data-Coding-Scheme field, defined in GSM 03.40, indicates the data coding scheme of the
      TP-UD field, and may indicate a message class. Any reserved codings shall be assumed to be the
      GSM default alphabet (the same as codepoint 00000000) by a receiving entity. The octet is used
      according to a coding group which is indicated in bits 7..4. The octet is then coded as follows:
      Bits 7..4 - 00xx
        Bit 7 Bit 6
          0 0 General Data Coding indication
        Bit 5
          0 Text is uncompressed
          1 Text is compressed (TODO - add compression support)
        Bit 4
          0 Bits 1 and 0 are reserved and have no message class meaning
          1 Bits 1 and 0 have a message class meaning
      Bits 3..0 - xxxx
        Bit 3 Bit 2 Alphabet being used
          0 0 Default alphabet
          0 1 8 bit data
          1 0 UCS2 (16bit)
          1 1 Reserved
        Bit 1 Bit 0 Message class Description
          0 0 Class 0 Immediate display (alert)
          0 1 Class 1 ME specific
          1 0 Class 2 SIM specific
          1 1 Class 3 TE specific
      The special case of bits 7..0 being 0000 0000 indicates the Default Alphabet as in Phase 2
      http://www.dreamfabric.com/sms/dcs.html }
    if FDCS = gcsUnknown then
      dcs := GSMCodingScheme(AMessage)
    else
      dcs := FDCS;

    { TP-UDL. User data length, length of message. The TP-DCS field indicated  7-bit data, so the length
      here is the number of septets (10). If the TP-DCS  field were set to indicate 8-bit data or Unicode,
      the length would be the number of octets (9). }
    if dcs = gcsDefault7Bit then begin // 7-bit coding
      // Convert Message
      if FUDHI <> '' then begin
         udhl := StrToInt('$' + Copy(FUDHI,1,2));
         udhl := (udhl div 7) + udhl + 2;
         for i := 0 to udhl - 1 do begin
            AMessage := '@' + AMessage;
         end;
      end;
      {
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
      }
      pduMsg  := GSMEncode7Bit(AMessage);
      pduMsgL := IntToHex(GSMLength7Bit(AMessage), 2); // number of septets (see above)
      pduDCS  := '00'; { see Data Coding Scheme below }

      { Remove excessive 7-bit padding }
      if FUDHI <> '' then
         pduMsg := Copy(pduMsg, (udhl-1) * 2 + 1, length(pduMsg));
    end
    else
    if dcs = gcs8BitOctets then begin // 8-bit coding
      if FUDHI <> '' then begin
         udhl := StrToInt('$' + Copy(FUDHI,1,2));
         udhl := udhl + 1;
      end;
      {
      for i := 1 to length(AMessage) do begin
        pduMsg := pduMsg + IntToHex(ord(ConvertCharSet(Char(AMessage[i]), True)), 2);
      end;
      }
      pduMsg  := GSMEncode8Bit(AMessage);
      pduMsgL := IntToHex((length(pduMsg) div 2) + udhl,2); // number of octets
      pduDCS  := '04'; { see Data Coding Scheme below }
    end
    else
    if dcs = gcs16bitUcs2 then begin // UCS2 Coding
      if FUDHI <> '' then begin
         udhl := StrToInt('$' + Copy(FUDHI,1,2));
         udhl := udhl + 1;
      end;
      {
      for i := 1 to length(AMessage) do begin
        pduMsg := pduMsg + IntToHex(ord(AMessage[i]), 4);
      end;
      }
      pduMsg  := GSMEncodeUcs2(AMessage);
      pduMsgL := IntToHex((length(pduMsg) div 2) + udhl,2); // number of octets
      pduDCS  := '08'; { see Data Coding Scheme below }
    end
    else
      Abort; // dcs detection failed!

    code := StrToInt('$' + pduDCS);
    { Have a message class meaning Class 0 Immediate display (alert) }
    if FFlashSMS then code := code or $10;
    pduDCS := IntToHex(code, 2);

    { If the �len� field is set to Zero then use the default value of the Service Centre address set by
      the AT+CSCA command }
    pduSMSC := '00'; // hex

    { Protocol Data Unit Type (PDU Type). Here $11 means:
      VPF  bit4 bit3  Validity Period = 1 0
           0    0     VP field is not present
           0    1     Reserved
      ->   1    0     VP field present an integer represented (relative)
           1    1     VP field present an semi-octet represented (absolute)
      MTI  bit1 bit0  Message type = 0 1
           0    0     SMS-DELIVER (SMSC ==> MS)
           0    0     SMS-DELIVER REPORT (MS ==> SMSC, is generated automatically by the M20, after receiving a SMS-DELIVER)
      ->   0    1     SMS-SUBMIT (MS ==> SMSC)
           0    1     SMS-SUBMIT REPORT (SMSC ==> MS)
           1    0     SMS-STATUS REPORT (SMSC ==> MS)
           1    0     SMS-COMMAND (MS ==> SMSC)
           1    1     Reserved }
    pduFirst :=  '11'; // hex
    head := StrToInt('$' + pduFirst);
    { SRR  bit5
           0          A status report is not requested
           1          A status report is requested }
    if FStatusRequest then head := head or $20;
    { UDHI bit6
           0          The UD field contains only the short message
           1          The beginning of the UD field contains a header in addition of the short message }
    if FUDHI <> ''    then head := head or $40;
    { RP   bit7
           0          Reply Path parameter is not set in this PDU
           1          Reply Path parameter is set in this PDU }
    if FRequestReply  then head := head or $80;
    pduFirst := IntToHex(head, 2);

    { The MR field gives an integer (0..255) representation of a reference number of the SMS-SUBMIT
      submitted to the SMSC by the MS. }
    pduMsgRef := '00'; // Let the phone set Msg Ref itself
    if FMessageRef <> '' then pduMsgRef := FMessageRef;

    { The PID is the information element by which the Transport Layer either refers to the higher layer
      protocol being used, or indicates interworking with a certain type of telematic device.
      Here are some examples of PID codings:
      00H: The PDU has to be treat as a short message
      01H: The PDU has to be treat as a telex
      02H: The PDU has to be treat as group3 telefax
      03H: The PDU has to be treat as group4 telefax }
    pduPID := '00';

    { Validity Period set to 1 week }
    pduTPVP := 'AD'; // do not localize

    Result := pduFirst + pduMsgRef + pduAddr + pduPID + pduDCS + pduTPVP + pduMsgL;
    if FUDHI <> '' then begin
       Result := Result + FUDHI;
    end;
    Result := Result + pduMsg;

    FSizeOfPDU := Length(Result) div 2;

    Result := pduSMSC + Result;
  except
    on E: Exception do
      raise Exception.Create(Format(('Error encoding PDU: %s'), [E.Message]));
  end;
end;

function TSMS.Get_Address: String;
begin
  Result := DecodeNumber(copy(FPDU, FSenderPos, FSenderLen + 2));
end;

function TSMS.Get_SMSC: String;
begin
  if FSMSCLen > 0 then Result := DecodeNumber(copy(FPDU, 3, FSMSCLen))
  else Result := '';
end;

function TSMS.Get_TimeStamp: TDateTime;
begin
  if FIsSMSSumit then Result := 0
  else
    Result := DecodeTimeStamp(copy(FPDU, FSMSDeliverStartPos + FSenderLen + 10, 14));
end;

function TSMS.Get_Validity: TDateTime;
var
  TPVP: string;
  val: integer;
begin
  Result := 0;
  TPVP := Copy(FPDU, FSenderPos + FSenderLen + 6, FValidityLen);
  case FVPF of
    // 1: TODO: enhanced format support
    2:
    begin
      // we will use negative values to identify offset value
      val := StrToInt('$'+TPVP);
      case val of
        0..143: Result := (-1/24/12)*(val+1); // 5mins*(val-1)
        144..167: Result := (-1/2)+(-1/24/2)*(val-143); // 12h + 30mins*(val-143)
        168..196: Result := (-1)*(val-166); // (val-166)*1day
        197..255: Result := (-7)*(val-192); // (val-192)*1week
      end;
    end;
    3: Result := DecodeTimeStamp(TPVP); // absolute format
  end;
end;

function TSMSDecoder.ReverseOctets(Octets: String): String;
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

procedure TSMS.Set_PDU(const Value: String);
var
  PDUType, TPVPF: Byte;
  TPDCS: Integer;
  Offset: Integer;
begin
  {
  The following example shows how to send the message "hellohello" in the PDU mode from a Nokia 6110.

  AT+CMGF=0    'Set PDU mode
  AT+CSMS=0    'Check if modem supports SMS commands
  AT+CMGS=23   'Send message, 23 octets (excluding the two initial zeros)
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
    { !- hack -!
      -mhr: seems SE is sometimes using Address-Length == 1 when SMSC is ommited
      anyway this would mean that only Type-of-Address is present without the actual
      address which would be weird, so it shouldn't do any problems
    }
    if FSMSCLen = 2 then
      FSMSCLen := 0;
  except
    FSMSCLen := 0;
// tsv    Log.AddMessage('PDU ERROR (SMSCLen): '+Value, lsError); // do not localize debug
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
// tsv    Log.AddMessage('PDU ERROR (PDUType): '+Value, lsError); // do not localize debug
  end;
  FIsSMSSumit := (PDUType and 3) = 1;
  //Check there are Header Information
  FIsUDH := (PDUType and 64) = 64;
  // Get Validity Field Length
  FValidityLen := 0;
  Offset := 0;
  if FIsSMSSumit then begin
    FStatusRequest := (PDUType and 32) <> 0;
    TPVPF := (PDUType and $18) shr 3;
    FVPF := TPVPF;

    { VPF  bit4 bit3  Validity Period
           0    0     VP field is not present
           0    1     VP field present an semi-octet represented (enhanced)
           1    0     VP field present an integer represented (relative)
           1    1     VP field present an semi-octet represented (absolute)
    }
    case TPVPF of
      1: FValidityLen := 14; // enhanced format
      2: FValidityLen := 2;  // integer
      3: FValidityLen := 14; // semi-octets
    else FValidityLen := 0;  // not present
    end;

    Offset := 2;
  end;

  // Get Sender Field Length and Startpos
  FSenderPos := FSMSDeliverStartPos + Offset + 4;
  try
    FSenderLen := StrToInt('$' + copy(FPDU, FSenderPos - 2, 2)); // count of sender's number digits
  except
    FSenderLen := 0;
// tsv    Log.AddMessage('PDU ERROR (SenderLen): '+Value, lsError); // do not localize debug
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
// tsv    Log.AddMessage('PDU ERROR (TPDCS): '+Value, lsError); // do not localize debug
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

function TSMSDecoder.MakeCRLF(str: Widestring): WideString;
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

procedure TSMS.Set_MessageRef(const Value: String);
begin
  FMessageRef := Copy(Value,1,2);
  while Length(FMessageRef) < 2 do FMessageRef := '0' + FMessageRef;
end;

function TSMS.Get_CodingScheme: TGSMCodingScheme;
begin
  if FDCS = gcsUnknown then
    FDCS := GSMCodingScheme(Text);
  Result := FDCS;
end;

procedure TSMS.Set_Message(const Value: WideString);
begin
  FMessage := Value;
  FDCS := gcsUnknown;
end;

procedure TSMS.Set_UDHI(const Value: String);
begin
  FUDHI := Value;
  FIsUDH := FUDHI <> '';
end;

function TSMS.NewMessageRefPDU(NewRef: String): String;
var
  FSMSCLen,FSMSDeliverStartPos: integer;
  Value: String;
begin
  MessageReference := NewRef;
  Value := FPDU;

  FSMSCLen := StrToInt('$' + copy(Value, 1, 2)) * 2; // length in octets * 2 = number of chars

  FSMSDeliverStartPos := 3; // char number, first 2 represent FSMSCLen octet
  if FSMSCLen > 0 then FSMSDeliverStartPos := FSMSDeliverStartPos + FSMSCLen;

  Value[FSMSDeliverStartPos + 2] := FMessageRef[1];
  Value[FSMSDeliverStartPos + 3] := FMessageRef[2];

  Result := Value;
end;

{ TSMSStatusReport }

constructor TSMSStatusReport.Create(ExpectSCA: boolean);
begin
  inherited Create;
  FSCAPresent := ExpectSCA;
end;

procedure TSMSStatusReport.Set_PDU(const Value: String);
var
  PDUType, ParamID, UDLen, UDHLen, NextStartPos: Integer;
  SMSCLen, AddressLen, PDUTypeStartPos, SCTSStartPos, ParamIDStartPos: integer;
  MTI: byte;
  TPDCS, TPUD, UDHnull: string;
begin
  FPDU := Value;

  { read SCA if present, acording to documentation it should be there,
    but real life tests show that it's not (at least not on K750) }
  PDUTypeStartPos := 1;
  if FSCAPresent then begin 
    SMSCLen := StrToInt('$'+Copy(Value, 1, 2));
    FSCA := DecodeNumber(Copy(Value, 3, 2*SMSCLen));
    PDUTypeStartPos := SMSCLen * 2 + 3;
  end;

  { check if this is really STATUS-REPORT by TP-MTI field }
  PDUType := StrToInt('$'+Copy(Value, PDUTypeStartPos, 2));
  { there's also MMS bit, we're not using it atm }
  MTI := PDUType and 3;
  if MTI <> 2 then begin
    // maybe there is SCA, try that
    if not FSCAPresent then begin
      FSCAPresent := True;
      Set_PDU(Value);
    end
    else
      raise EConvertError.Create('Invalid SMS-STATUS-REPORT!');
    Exit;
  end;
// tsv  if (PDUType and 32) = 1 then Log.AddMessage('PDU Warning (TP-SRQ): Report of SMS-COMMAND', lsWarning);
  FIsUDH := PDUType and 64 <> 0;

  { Message reference }
  FMessageRef := Copy(Value, PDUTypeStartPos + 2, 2);

  { Destination address }
  AddressLen := StrToInt('$'+Copy(Value, PDUTypeStartPos + 4, 2));
  FAddress := DecodeNumber(Copy(Value, PDUTypeStartPos + 6, AddressLen+2));

  { Service center timestamp >
    Parameter identifying time when the SC received the previously sent SMS-SUBMIT }
  SCTSStartPos := PDUTypeStartPos + 8 + AddressLen;
  FSCATS := DecodeTimeStamp(Copy(Value, SCTSStartPos, 14));

  { Discharge timestamp >
    Parameter identifying the time associated with a particular TP-ST outcome
    = time of successful delivery OR time of last delivery attempt }
  FDTS := DecodeTimeStamp(Copy(Value, SCTSStartPos+14, 14));

  { Status itself }
  FStatus := Byte(StrToInt('$'+Copy(Value, SCTSStartPos+28, 2)));

  { TP-PI is optional, but mandatory if TP-PID/TP-DCS/TP-UDL follow}
  ParamIDStartPos := SCTSStartPos + 30;
  if Copy(Value, ParamIDStartPos, 2) <> '' then begin
    ParamID := StrToInt('$'+Copy(Value, ParamIDStartPos, 2));
    NextStartPos := ParamIDStartPos + 2;
    if ParamID and 1 <> 0 then begin
      // TP-PID is here, skip it
      NextStartPos := NextStartPos + 2;
    end;
    if ParamID and 2 <> 0 then begin
      // TP-DCS here
      TPDCS := Copy(Value, NextStartPos, 2);
      FDataCoding := (StrToInt('$'+TPDCS) and $0C) shr 2;
      if FDataCoding = 0 then FDCS := gcsDefault7Bit
      else if FDataCoding = 1 then FDCS := gcs8BitOctets
      else if FDataCoding = 2 then FDCS := gcs16bitUcs2
      else FDCS := gcsUnknown;
      NextStartPos := NextStartPos + 2;
    end;
    if ParamID and 4 <> 0 then begin
      // TP-UDL here
      UDHLen := 0;
      UDLen := StrToInt('$'+Copy(Value, NextStartPos, 2));
      Inc(NextStartPos,2);
      if FIsUDH then begin
        // rare, but UDH can be here
        UDHLen := StrToInt('$'+Copy(Value, NextStartPos, 2));
        FUDHI := Copy(Value, NextStartPos+2, 2*UDHLen);
        NextStartPos := NextStartPos + 2*(UDHLen+1);
        while UDHLen >= 0 do begin
          UDHnull := UDHnull + '00';
          Dec(UDHLen);
        end;
        UDHLen := Length(UDHnull) div 2;
      end;
      // TODO: check, will this work for 7bit-encoded reports?
      TPUD := Copy(Value, NextStartPos, UDLen*2- 2*(UDHLen));
      case FDCS of
        gcsDefault7Bit: FMessage := GSMDecode7Bit(IntToHex(UDLen,2)+UDHnull+TPUD);
        gcs8BitOctets: FMessage := GSMDecode8Bit(TPUD);
        gcs16bitUcs2: FMessage := GSMDecodeUcs2(TPUD);
        gcsUnknown: FMessage := ('(Unsupported: Unknown coding scheme)');
      end;
    end;
  end;
end;

function TSMSStatusReport.Get_IsDelivered: boolean;
begin
{
   bits 6-0
  Short message transaction completed
    0000000 Short message received by the SME
    0000001 Short message forwarded by the SC to the SME but the SC is
            unable to confirm delivery
    0000010 Short message replaced by the SC
  Reserved values
    0000011..0001111 Reserved
    0010000..0011111 Values specific to each SC
  Temporary error, SC still trying to transfer SM
    0100000 Congestion
    0100001 SME busy
    0100010 No response from SME
    0100011 Service rejected
    0100100 Quality of service not available
    0100101 Error in SME
    0100110..0101111 Reserved
    0110000..0111111 Values specific to each SC
  Permanent error, SC is not making any more transfer attempts
    1000000 Remote procedure error
    1000001 Incompatible destination
    1000010 Connection rejected by SME
    1000011 Not obtainable
    1000100 Quality of service not available
    1000101 No interworking available
    1000110 SM Validity Period Expired  ($46)
    1000111 SM Deleted by originating SME
    1001000 SM Deleted by SC Administration
    1001001 SM does not exist (The SM may have previously existed in the SC but the SC
            no longer has knowledge of it or the SM
            may never have previously existed in the SC)
    1001010..1001111 Reserved
  Temporary error, SC is not making any more transfer attempts
    1100000 Congestion
    1100001 SME busy
    1100010 No response from SME
    1100011 Service rejected
    1100100 Quality of service not available
    1100101 Error in SME
    1100110..1101001 Reserved
    1101010..1101111 Reserved
    1110000..1111111 Values specific to each SC
}
  // if FStatus >= 128 then Result := unknown;
  Result := FStatus = 0;
end;

end.