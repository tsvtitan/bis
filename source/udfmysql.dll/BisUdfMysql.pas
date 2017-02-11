unit BisUdfMysql;

interface

const
  STRING_RESULT = 0;
  REAL_RESULT = 1;
  INT_RESULT = 2;
  ROW_RESULT = 3;
  DECIMAL_RESULT= 4;

type
  my_bool = byte;
  uint = LongWord;
  ulong = LongWord;
  ppChar = ^pChar; // pointer to an array of pChars
  puint = ^uint; // pointer to an array of uints
  pUlong = ^ulong;

  ItemResult = STRING_RESULT..DECIMAL_RESULT;
  pItemResult = ^ItemResult;

  pByte = ^byte;
  pDouble = ^Double;

  ItemResultArr = array [1..1000] of integer; // ItemResult;
  CharArr = array [1..1000] of pChar;
  uintArr = array [1..1000] of uint;
  ByteArr = array [1..1000] of byte;
  Int64Arr = array [1..1000] of int64;

  pItemResultArr = ^ItemResultArr;
  pCharArr = ^CharArr;
  puintArr = ^uintArr;
  pByteArr = ^ByteArr;
  pInt64Arr= ^Int64Arr;

  pUDF_ARGS = ^UDF_ARGS;
  UDF_ARGS = packed record
    arg_count : uint; // Number of arguments
    arg_type : pItemResultArr; // Pointer to item_results
    args : pCharArr; // Pointer to argument
    lengths : puintArr; // Length of string arguments
    maybe_null: pByteArr; // Set to 1 for all maybe_null args
    attributes: pCharArr; // Pointer to attribute names
    attribute_lengths: puintArr;// Length of attribute arguments
  end;

// This holds information about the result

  pUDF_INIT = ^UDF_INIT;
  UDF_INIT = packed record
    maybe_null: my_bool; // 1 if function can return NULL
    decimals : uint; // for real functions
    max_length: uint; // For string functions
    ptr : pChar; // free pointer for function data
    const_item: my_bool; // 0 if result is independent of arguments
  end;


procedure Init;
procedure Done;

function GET_UNIQUE_ID(initid: PUDF_INIT; args: PUDF_ARGS; Aresult: PCHAR;
                        Alength: pCardinal; is_null: PChar; error: PChar): PChar; cdecl;
function GET_UNIQUE_ID_init(initid: PUDF_INIT; args: PUDF_ARGS; aMessage: PChar): my_bool; cdecl;
procedure GET_UNIQUE_ID_deinit(initid: PUDF_INIT); cdecl; 

implementation

uses ActiveX;

function PrepareClassID(S: string): string;
begin
  Result:=Copy(s, 26, 12)+Copy(s, 21, 4)+Copy(s, 16, 4)+Copy(s, 11, 4)+Copy(s, 2, 8);
end;

function CreateClassID: string;
var
  ClassID: TCLSID;
  P: PWideChar;
begin
  CoCreateGuid(ClassID);
  StringFromCLSID(ClassID, P);
  Result := P;
  CoTaskMemFree(P);
end;

function GET_UNIQUE_ID(initid: PUDF_INIT; args: PUDF_ARGS; Aresult: PCHAR;
                        Alength: pCardinal; is_null: PChar; error: PChar): PChar; cdecl;
var
  s: String;                        
begin
  s:=Copy(CreateClassID,1,37);
  Result:=PChar(PrepareClassID(s));
end;

function GET_UNIQUE_ID_init(initid: PUDF_INIT; args: PUDF_ARGS; aMessage: PChar): my_bool; cdecl;
begin
  initid.maybe_null:=0;
  initid.decimals:=0;
  initid.max_length:=65535;
  initid.ptr:=nil;
  initid.const_item:=1;
  Result:=0;
end;

procedure GET_UNIQUE_ID_deinit(initid: PUDF_INIT); cdecl;
begin
end;

procedure Init;
begin
end;

procedure Done;
begin
end;


end.
