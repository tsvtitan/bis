{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: mwPasLexTypes.Pas, released August 17, 1999.

The Initial Developer of the Original Code is Martin Waldenburg
(Martin.Waldenburg@T-Online.de).
Portions created by Martin Waldenburg are Copyright (C) 1998, 1999, 2002 Martin
Waldenburg.
All Rights Reserved.

Contributor(s): James Jacobson _____________________________________.


Last Modified: Oktober 2002
Current Version: 1.1

Notes: This program is a very fast Pascal tokenizer. I'd like to invite the
Delphi community to develop it further and to create a fully featured Object
Pascal parser.

Modification history:

Known Issues:
-----------------------------------------------------------------------------}
{$A+}
unit dws_mwPasLexTypes;

interface

uses
  SysUtils, Classes, TypInfo, Contnrs;

var
  NonEnglishChars: array[#0..#255] of ByteBool;
  StandardIdentifiers: array[#0..#255] of ByteBool;
  Identifiers: array[#0..#255] of ByteBool;
  CompTable: array[#0..#255] of Char;
  mwInsensitiveHashTable: array[#0..#255] of byte;



type

  TMessageEvent = procedure(Sender: TObject; const Msg: string; X, Y: Integer) of object; //jdj 7/16/1999

  TmwAppType = (atConsole, atGUI);
  
  TmwLexState = (
    lsNormal,
    lsSkipping);

  TptTokenKind = (
    ptAbsolute,
    ptAbstract,
    ptAddressOp,
    ptAmpersand,
    ptAnd,
    ptAnsiComment,
    ptAnsiDirective,
    ptAnsiString,
    ptArray,
    ptAs,
    ptAsciiChar,
    ptAsm,
    ptAssembler,
    ptAssign,
    ptAt,
    ptAutomated,
    ptBegin,
    ptBoolean,
    ptBorComment,
    ptBorDirective,
    ptBraceClose,
    ptBraceOpen,
    ptByte,
    ptByteBool,
    ptCardinal,
    ptCase,
    ptCdecl,
    ptChar,
    ptClass,
    ptClassForward,
    ptClassFunction,
    ptClassProcedure,
    ptColon,
    ptComma,
    ptComp,
    ptCompDirect,
    ptConst,
    ptConstructor,
    ptContains,
    ptCRLF,
    ptCRLFCo,
    ptCurrency,
    ptDefault,
    ptDeprecated,
    ptDestructor,
    ptDispid,
    ptDispinterface,
    ptDiv,
    ptDo,
    ptDotDot,
    ptDouble,
    ptDoubleAddressOp,
    ptDownto,
    ptDWORD,
    ptDynamic,
    ptElse,
    ptEnd,
    ptEqual,
    ptError,
    ptExcept,
    ptExperimental,
    ptExport,
    ptExports,
    ptExtended,
    ptExternal,
    ptFar,
    ptFile,
    ptFinalization,
    ptFinally,
    ptFloat,
    ptFor,
    ptForward,
    ptFunction,
    ptGoto,
    ptGreater,
    ptGreaterEqual,
    ptHelper,
    ptIdentifier,
    ptIf,
    ptImplementation,
    ptImplements,
    ptIn,
    ptIndex,
    ptInherited,
    ptInitialization,
    ptInline,
    ptInt64,
    ptInteger,
    ptIntegerConst,
    ptInterface,
    ptInternationalIdentifier,
    ptIs,
    ptKeyWord,
    ptLabel,
    ptLibrary,
    ptLongBool,
    ptLongint,
    ptLongword,
    ptLower,
    ptLowerEqual,
    ptMessage,
    ptMinus,
    ptMod,
    ptName,
    ptNear,
    ptNil,
    ptNodefault,
    ptNone,
    ptNot,
    ptNotEqual,
    ptNull,
    ptObject,
    ptOf,
    ptOleVariant,
    ptOn,
    ptOr,
    ptOut,
    ptOverload,
    ptOverride,
    ptPackage,
    ptPacked,
    ptPascal,
    ptPlatform,
    ptPChar,
    ptPlus,
    ptPoint,
    ptPointerSymbol,
    ptPrivate,
    ptProcedure,
    ptProgram,
    ptProperty,
    ptProtected,
    ptPublic,
    ptPublished,
    ptRaise,
    ptRead,
    ptReadonly,
    ptReal,
    ptReal48,
    ptRecord,
    ptRegister,
    ptReintroduce,
    ptRepeat,
    ptRequires,
    ptResident,
    ptResourcestring,
    ptRoundClose,
    ptRoundOpen,
    ptSafeCall,
    ptSemiColon,
    ptSet,
    ptShl,
    ptShortint,
    ptShortString,
    ptShr,
    ptSingle,
    ptSlash,
    ptSlashesComment,
    ptSmallint,
    ptSpace,
    ptSquareClose,
    ptSquareOpen,
    ptStar,
    ptStdcall,
    ptStored,
    ptString,
    ptStringConst,
    ptStringresource,
    ptSymbol,
    ptThen,
    ptThreadvar,
    ptTo,
    ptTry,
    ptType,
    ptUnit,
    ptUnknown,
    ptUntil,
    ptUses,
    ptVar,
    ptVarargs,
    ptVariant,
    ptVirtual,
    ptWhile,
    ptWideChar,
    ptWideString,
    ptWith,
    ptWord,
    ptWordBool,
    ptWrite,
    ptWriteonly,
    ptXor);


  TcdTokenKind = (
    cdNull,
    cdA,
    cdAOne,
    cdATwo,
    cdAFour,
    cdAEight,
    cdAPlus,
    cdAMinus,
    cdAlign,
    cdApptype,
    cdC,
    cdCPlus,
    cdCMinus,
    cdConsole,
    cdAssertions,
    cdB,
    cdBPlus,
    cdBMinus,
    cdBooleval,
    cdSoPrefix,
    cdSoSuffix,
    cdSoVersion,
    cdSoName,
    cdD,
    cdDPlus,
    cdDMinus,
    cdDebugInfo,
    cdDefaultFile,
    cdDefine,
    cdDenyPackageUnit,
    cdDescription,
    cdDesignOnly,
    cdElse,
    cdElseIf,
    cdEndIf,
    cdE,
    cdExtension,
    cdObjExportAll,
    cdX,
    cdXPlus,
    cdXMinus,
    cdExtendedSyntax,
    cdExternalSym,
    cdHints,
    cdHPPEmit,
    cdIf,
    cdIfDef,
    cdIfNDef,
    cdIfOpt,
    cdIfEnd,
    cdImplicitBuild,
    cdG,
    cdGPlus,
    cdGMinus,
    cdGUI,
    cdImportedData,
    cdI,
    cdIPlus,
    cdIMinus,
    cdImageBase,
    cdInclude,
    cdIOChecks,
    cdL,
    cdLPlus,
    cdLMinus,
    cdLink,
    cdLocalSymbols,
    cdH,
    cdHPlus,
    cdHMinus,
    cdLongStrings,
    cdM,
    cdMPlus,
    cdMMinus,
    cdMinStackSize,
    cdMaxStackSize,
    cdZ,
    cdZOne,
    cdZTwo,
    cdZFour,
    cdMinEnumSize,
    cdP,
    cdPPlus,
    cdPMinus,
    cdOpenStrings,
    cdO,
    cdOPlus,
    cdOMinus,
    cdOptimization,
    cdQ,
    cdQPlus,
    cdQMinus,
    cdOverFlowChecks,
    cdNoDefine,
    cdNoInclude,
    cdR,
    cdRPlus,
    cdRMinus,
    cdRangeChecks,
    cdRealCompatibility,
    cdRecordAlignment,
    cdResourceReserve,
    cdResource,
    cdRunOnly,
    cdTypeInfo,
    cdY,
    cdYPlus,
    cdYMinus,
    cdYD,
    cdReferenceInfo,
    cdDefinitionInfo,
    cdSafeDivide,
    cdSetPEFlags,
    cdSetPEOptFlags,
    cdT,
    cdTPlus,
    cdTMinus,
    cdTypedAddress,
    cdU,
    cdUPlus,
    cdUMinus,
    cdUnDef,
    cdV,
    cdVPlus,
    cdVMinus,
    cdVarStringChecks,
    cdWarn,
    cdWarnings,
    cdWeakPackageUnit,
    cdW,
    cdWPlus,
    cdWMinus,
    cdStackFrames,
    cdJ,
    cdJPlus,
    cdJMinus,
    cdWriteableConst,
    {------------------}
    cdUnknownPlus,
    cdUnknownMinus,
    {------------------}
    cdAnd,
    cdAtEnd,
    cdAnsiEnd,
    cdBorEnd,
    cdComma,
    cdCRLF,
    cdDeclared,
    cdDefined,
    cdEqual,
    cdFileName,
    cdFloat,
    cdGreater,
    cdGreaterEqual,
    cdIdentifier,
    cdLower,
    cdLowerEqual,
    cdNotEqual,
    cdNumber,
    cdOff,
    cdOn,
    cdOr,
    cdRoundOpen,
    cdRoundClose,
    cdSpace,
    cdStringConst,
    cdSymbol_Platform,
    cdSymbol_Library,
    cdSymbol_Deprecated,
    cdUnit_Deprecated,
    cdUnit_Library,
    cdUnit_Platform,
    cdUnknown);

  TbdBooleanDirectives = (
    bdAlign,
    bdAssertions,
    bdBooleval,
    bdDebugInfo,
    bdDenyPackageUnit,
    bdDesignOnly,
    bdObjExportAll,
    bdExtendedSyntax,
    bdHints,
    bdImplicitBuild,
    bdImportedData,
    bdIOChecks,
    bdLocalSymbols,
    bdLongStrings,
    bdOpenStrings,
    bdOptimization,
    bdOverFlowChecks,
    bdRangeChecks,
    bdRealCompatibility,
    bdRunOnly,
    bdTypeInfo,
//    bdReferenceInfo,
    bdDefinitionInfo,
    bdSafeDivide,
    bdTypedAddress,
    bdVarStringChecks,
    bdWarn,
    bdWarnings,
    bdWeakPackageUnit,
    bdStackFrames,
    bdWriteableConst,
    bdSymbol_Platform,
    bdSymbol_Library,
    bdSymbol_Deprecated,
    bdUnit_Deprecated,
    bdUnit_Library,
    bdUnit_Platform,
    bdUnKnown);

  TmwBooleanDirectives = Set of TbdBooleanDirectives;

  PmwPasLexStatus = ^TmwPasLexStatus;
  TmwPasLexStatus = record
    LexState: TmwLexState;
    ExID: TptTokenKind;
    LineNumber: Integer;
    LinePos: Integer;
    Origin: PChar;
    RunPos: Integer;
    TokenPos: Integer;
    TokenID: TptTokenKind;
    BooleanDirectives: TmwBooleanDirectives;
    SkipCounter: Integer;
    UnitName: String;
  end;

  TmwLexStream = class(TMemoryStream)
  public
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SetTerminator;
  end;

  TmwPasLexStatusStack = class(TStack)
  public
    destructor Destroy; override;
    procedure Clear;
  end;

  TmwLexHashStringItem = class(TObject)
    HashValue: Cardinal;
    Key: String;
  end;

  TmwPasHashItem = class(TmwLexHashStringItem)
    Id: TptTokenKind;
    ExId: TptTokenKind;
  end;

  TmwDirectiveHashItem = class(TmwLexHashStringItem)
    Id: TcdTokenKind;
  end;

  PmwLexHashStringItemList = ^TmwLexHashStringItemList;
  TmwLexHashStringItemList = array[0..0] of TmwLexHashStringItem;

  TmwLexHashStrings = class(TObject)
  private
    FList: PmwLexHashStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    procedure SetCapacity(const NewCapacity: Integer);
    function GetItems(const Index: Integer): TmwLexHashStringItem;
    function SorCompare(const Item1, Item2: TmwLexHashStringItem): Integer;
  protected
    Sorted: Boolean;
    procedure AddItem(const Item: TmwLexHashStringItem);
    function CompareValue(const Value1, Value2: Cardinal): Integer;
    function CompareString(const S1, S2: String): Boolean; virtual;
    function ComparePChar(const P1: PChar; const Len: Integer; const S: String): Boolean; virtual;
    function CreateNewItem: Pointer; virtual;
    procedure Delete(const Index: Integer);
    function Expand: Integer;
    function HashOf(const Key: string): Cardinal; virtual;
    function HashOfPointer(var Len: Integer; const P: PChar): Cardinal; virtual;
    procedure Insert(Index: Integer; const Item: TmwLexHashStringItem);
  public
    destructor Destroy; override;
    procedure QuickSort;
    procedure AddItemSorted(const Item: TmwLexHashStringItem);
    procedure AddSorted(const S: String);
    procedure AddString(const S: String);
    procedure Clear; virtual;
    function Hash(const S: String): Boolean;
    function IndexOf(const S: String): Integer;
    function Remove(const S: String): Integer;
    property Capacity: Integer read FCapacity;
    property Count: Integer read FCount;
    property Items[const Index: Integer]: TmwLexHashStringItem read GetItems; default;
    property List: PmwLexHashStringItemList read FList;
  end;

  TmwPasHash = class(TmwLexHashStrings)
  protected
    function CreateNewItem: Pointer; override;
    procedure Init;
  public
    constructor Create;
    procedure Add(const S: String; anId, anExId: TptTokenKind);
    procedure HashRun(const P: PChar; var Running: Integer; var anId, anExId: TptTokenKind);
  end;

  TmwDirectiveHash = class(TmwLexHashStrings)
  protected
    function CreateNewItem: Pointer; override;
    procedure Init;
  public
    constructor Create;
    procedure Add(const S: String; anId: TcdTokenKind);
    procedure HashRun(const P: PChar; var Running: Integer; var anId: TcdTokenKind);
  end;

  TmwAssignAbleHash = class(TmwLexHashStrings)
    procedure Assign(HashList: TmwAssignAbleHash);
  end;

function TokenName(Value: TptTokenKind): string;
function cdTokenName(Value: TcdTokenKind): string;
function ptTokenName(Value: TptTokenKind): string;
function IsTokenIDJunk(const aTokenID : TptTokenKind ) :Boolean; //XM 20001210

implementation

procedure MakeIdentTable;
var
  I: Char;
  C: array[0..1] of Char;
  S: String;
begin
  C[1]:= #0;
  for I := #0 to #255 do
  begin
    case I of
      '0'..'9', '_', 'A'..'Z', 'a'..'z':
        begin
          Identifiers[I]:= True;
          StandardIdentifiers[I]:= True;
        end;
    else
      begin
        Identifiers[I]:= False;
        StandardIdentifiers[I]:= False;
      end;
    end;

    case I of
      'ª', 'µ', 'º', 'À'..'Ö', 'Ø'..'ö', 'ø'..'ÿ':
      begin
        Identifiers[I]:= True;
        NonEnglishChars[I]:= True;
      end;
    else NonEnglishChars[I]:= False;
    end;

    begin
      C[0]:= I;
      S:= AnsiUpperCase(C);
      case S <> '' of
        True: mwInsensitiveHashTable[I] := Ord(S[1]);
        False: mwInsensitiveHashTable[I] := Ord(I);
      end;
    end;
  end;
end;

function TokenName(Value: TptTokenKind): string;
begin //jdj 7/18/1999
  Result := Copy(ptTokenName(Value), 3, MaxInt);
end;

function ptTokenName(Value: TptTokenKind): string;
begin
  result := GetEnumName(TypeInfo(TptTokenKind), Integer(Value));
end;

function cdTokenName(Value: TcdTokenKind): string;
begin
  result := GetEnumName(TypeInfo(TcdTokenKind), Integer(Value));
end;

function IsTokenIDJunk(const aTokenID : TptTokenKind ) :boolean; //XM 20001210
begin
  Result := aTokenID in [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo, ptSlashesComment, ptSpace];
end;

{ TmwLexStream }

procedure TmwLexStream.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TmwLexStream.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  SetTerminator;
end;

procedure TmwLexStream.SetTerminator;
var
  Terminator: Char;
  OldSize: Integer;
begin
  Position:= Size;
  Terminator:= #0;
  OldSize:= Size;
  write(Terminator, 1);
  SetSize(OldSize);
end;

{ TmwPasLexStatusStack }

procedure TmwPasLexStatusStack.Clear;
var
  I: Integer;
begin
  for I:= 0 to Count -1 do
    Dispose(List[I]);
end;

destructor TmwPasLexStatusStack.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{ TmwLexHashStrings }

procedure TmwLexHashStrings.AddItem(const Item: TmwLexHashStringItem);
begin
  Insert(fCount, Item);
end;

procedure TmwLexHashStrings.AddItemSorted(
  const Item: TmwLexHashStringItem);
var
  Val, First, Last, Temp: Integer;
  Larger: ByteBool;
begin
  if Count > 2000 then
  begin
    Sorted:= False;
    AddItem(Item);
    Exit;
  end;
  Val:= HashOf(Item.Key);
  Item.HashValue := Val;
  Larger:= False;
  Temp:= 0;
  if FCount > 0 then
  begin
    if not sorted then QuickSort;
    First:=0;
    Last:= FCount-1;
    while First<=Last do
    begin
      Temp:=(First+Last)shr 1;
      Case CompareValue(Val, fList[Temp].HashValue) of
        -1:
          begin
            Last:=Temp-1;
            Larger:=False;
          end;
        0:
          begin
            Larger:=False;
            break;
          end;
        1:
          begin
            First:=Temp+1;
            Larger:=True;
          end;
      end;
    end;
    Case Larger of
      True: Insert(Temp+1, Item);
      False: Insert(Temp, Item);
    end;
  end else
    begin
      Sorted:= True;
      Insert(0, Item);
    end;
end;

procedure TmwLexHashStrings.AddSorted(const S: String);
var
  Item: TmwLexHashStringItem;
begin
  Item:= CreateNewItem;
  Item.Key:= S;
  AddItemSorted(Item);
end;

procedure TmwLexHashStrings.AddString(const S: String);
var
  Item: TmwLexHashStringItem;
begin
  Sorted:= False;
  Item:= CreateNewItem;
  Item.Key:= S;
  Item.HashValue:= HashOf(S);
  AddItem(Item);
end;

procedure TmwLexHashStrings.Clear;
var
  I: Integer;
begin
  if fCount = 0 then exit;
  for I:= 0 to fCount -1 do
    fList[I].Free;
  ReallocMem(FList, 0);
  fCount:= 0;
  fCapacity:= 0;
end;

function TmwLexHashStrings.ComparePChar(const P1: PChar; const Len: Integer;
  const S: String): Boolean;
var
  I: Integer;
  P2: PChar;
begin
  if Len <> Length(S) then
  begin
    Result:= False;
    Exit;
  end;
  P2:= PChar(S);
  Result:= True;
  for I:= Len -1 downto 0 do
  if mwInsensitiveHashTable[P1[I]] <>  mwInsensitiveHashTable[P2[I]] then
  begin
    Result:= False;
    break;
  end;
end;

function TmwLexHashStrings.CompareString(const S1, S2: String): Boolean;
begin
  Result:= SameText(S1, S2);
end;

function TmwLexHashStrings.CompareValue(const Value1, Value2: Cardinal): Integer;
begin
  Result:= 0;
  if Value1 < Value2 then Result:= -1 else
  if Value1 > Value2 then Result:= 1;
end;

function TmwLexHashStrings.CreateNewItem: Pointer;
begin
  Result:= TmwLexHashStringItem.Create;
end;

procedure TmwLexHashStrings.Delete(const Index: Integer);
begin
  if (Index <= 0) and (Index < FCount) then
  begin
    FList[Index].Free;
    dec(FCount);
    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index],
        (FCount - Index) * SizeOf(TmwLexHashStringItem));
  end;
end;

destructor TmwLexHashStrings.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TmwLexHashStrings.Expand: Integer;
begin
  Result:= 1 + fCount + fCount div 10;
  SetCapacity(Result);
end;

function TmwLexHashStrings.GetItems(const Index: Integer): TmwLexHashStringItem;
begin
  if (Index >= 0) and(Index < fCount) then
    Result:= fList[Index]
  else
    Result:= nil;
end;

function TmwLexHashStrings.Hash(const S: String): Boolean;
begin
  Result:= Indexof(S) <> -1;
end;

function TmwLexHashStrings.HashOf(const Key: string): Cardinal;
{modified version of HashDKC3 posted to  delphi.language.basm}
var
  P, P2: PChar;
begin
  P:= PChar(Key);
  P2:= P + Length(Key);
  Result := 0;
  while P < P2 do
  begin
    Result := Result shl 10 - Result shl 5 - Result + mwInsensitiveHashTable[P^];
    inc(P);
  end;
end;

function TmwLexHashStrings.HashOfPointer(var Len: Integer; const P: PChar): Cardinal;
{modified version of HashDKC3 posted to  delphi.language.basm}
begin
  Result:= 0;
  Len:= 0;
  while Identifiers[P[Len]] do
  begin
    Result := Result shl 10 - Result shl 5 - Result + mwInsensitiveHashTable[P[Len]];
    inc(Len);
  end;
end;

function TmwLexHashStrings.IndexOf(const S: String): Integer;
var
  Value: Cardinal;
  First, Last, Temp: Integer;
begin
  if not sorted then QuickSort;
  Result:= -1;
  Value:= HashOf(s);
  First:= 0;
  Last:= Count -1;
  Temp:= 0;
  while First <= Last do
  begin
    Temp:= (First + Last) div 2;
    case CompareValue(Value, fList[Temp].HashValue) of
      1: First:= Temp +1;
      0:
        begin
          Result:= Temp;
          break;
        end;
      -1: Last:= Temp-1;
    end;
  end;
  if Result <> -1 then
  begin
    Result:= -1;
    First:= Temp;
    repeat
      if CompareString(S, fList[First].Key) then
      begin
        Result:= First;
        Exit;
      end;
      dec(First);
    until (First < 0) or (CompareValue(Value, fList[First].HashValue) <> 0);
    Last:= Temp +1;
    if Last = Count then Exit;
    repeat
      if CompareString(S, fList[Last].Key) then
      begin
        Result:= Last;
        Exit;
      end;
      inc(Last);
    until (Last >= Count) or (CompareValue(Value, fList[Last].HashValue) <> 0);
  end;
end;

procedure TmwLexHashStrings.Insert(Index: Integer; const Item: TmwLexHashStringItem);
begin
  if fCount = fCapacity then
    Expand;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TmwLexHashStringItem));
  FList^[Index] := Item;
  inc(FCount);
end;

{ Based on a non-recursive QuickSort from the SWAG-Archive.
  ( TV Sorting Unit by Brad Williams ) }
procedure TmwLexHashStrings.QuickSort;
var
  Left, Right, SubArray, SubLeft, SubRight: LongInt;
  Temp, Pivot: TmwLexHashStringItem;
  Stack: array[1..32]of record First, Last: LongInt;
  end;
begin
  if fCount < 2 then Exit;
  SubArray:=1;
  Stack[SubArray].First:=0;
  Stack[SubArray].Last:=Count-1;
  repeat
    Left:=Stack[SubArray].First;
    Right:=Stack[SubArray].Last;
    Dec(SubArray);
    repeat
      SubLeft:=Left;
      SubRight:=Right;
      Pivot:=fList[(Left+Right)shr 1];
      repeat
        while SorCompare(fList[SubLeft], Pivot)<0 do Inc(SubLeft);
        while SorCompare(fList[SubRight], Pivot)>0 do Dec(SubRight);
        IF SubLeft<=SubRight then
        begin
          Temp:=fList[SubLeft];
          fList[SubLeft]:=fList[SubRight];
          fList[SubRight]:=Temp;
          Inc(SubLeft);
          Dec(SubRight);
        end;
      until SubLeft>SubRight;
      IF SubLeft<Right then
      begin
        Inc(SubArray);
        Stack[SubArray].First:=SubLeft;
        Stack[SubArray].Last:=Right;
      end;
      Right:=SubRight;
    until Left>=Right;
  until SubArray=0;
  Sorted:= True;
end; { QuickSort }

function TmwLexHashStrings.Remove(const S: String): Integer;
begin
  Result:= IndexOf(S);
  if Result <> -1 then
    Delete(Result);
end;

procedure TmwLexHashStrings.SetCapacity(const NewCapacity: Integer);
begin
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * SizeOf(Pointer));
    FCapacity := NewCapacity;
  end;
end;

function TmwLexHashStrings.SorCompare(const Item1, Item2: TmwLexHashStringItem): Integer;
begin
  Result:= 0;
  if Item1.HashValue < Item2.HashValue then Result:= -1 else
  if Item1.HashValue > Item2.HashValue then Result:= 1;
end;

{ TmwPasHash }

procedure TmwPasHash.Add(const S: String; anId, anExId: TptTokenKind);
var
  Item: TmwPasHashItem;
begin
  Item:= CreateNewItem;
  Item.Key:= S;
  Item.Id:= anId;
  Item.ExId:= anExId;
  Item.HashValue:= HashOf(S);
  AddItem(Item);
end;

constructor TmwPasHash.Create;
begin
  inherited Create;
  Init;
end;

function TmwPasHash.CreateNewItem: Pointer;
begin
  Result:= TmwPasHashItem.Create;
end;

procedure TmwPasHash.HashRun(const P: PChar; var Running: Integer; var anId, anExId: TptTokenKind);
var
  TempRun: Integer;
  Value: Cardinal;
  First, Last, Temp, Len, Index: Integer;
begin
  Value:= 0;
  TempRun:= Running;
  while StandardIdentifiers[P[Running]] do
  begin
    Value := Value shl 10 - Value shl 5 - Value + mwInsensitiveHashTable[P[Running]];
    inc(Running);
  end;
  Len:= Running - TempRun;
  Index:= -1;
  First:= 0;
  Last:= Count -1;
  Temp:= 0;
  while First <= Last do
  begin
    Temp:= (First + Last) div 2;
    case CompareValue(Value, fList[Temp].HashValue) of
      1: First:= Temp +1;
      0:
        begin
          Index:= Temp;
          break;
        end;
      -1: Last:= Temp-1;
    end;
  end;
  if Index <> -1 then
  begin
    First:= Temp;
    repeat
      if ComparePChar((P + TempRun), Len, fList[First].Key) then
      begin
        anId:= TmwPasHashItem(fList[First]).Id;
        anExId:= TmwPasHashItem(fList[First]).ExId;
        Exit;
      end;
      dec(First);
    until (First < 0) or (CompareValue(Value, fList[First].HashValue) <> 0);
    Last:= Temp +1;
    if Last = Count then Exit;
    repeat
      if ComparePChar((P + TempRun), Len, fList[Last].Key) then
      begin
        anId:= TmwPasHashItem(fList[First]).Id;
        anExId:= TmwPasHashItem(fList[First]).ExId;
        Exit;
      end;
      inc(Last);
    until (Last >= Count) or (CompareValue(Value, fList[Last].HashValue) <> 0);
  end;
end;

procedure TmwPasHash.Init;
begin
  Add('If', ptIf, ptKeyWord);
  Add('Do', ptDo, ptKeyWord);
  Add('And', ptAnd, ptKeyWord);
  Add('As', ptAs, ptKeyWord);
  Add('Of', ptOf, ptKeyWord);
  Add('At', ptIdentifier, ptAt);
  Add('End', ptEnd, ptKeyWord);
  Add('In', ptIn, ptKeyWord);
  Add('Far', ptIdentifier, ptFar);
  Add('Cdecl', ptIdentifier, ptCdecl);
  Add('Read', ptIdentifier, ptRead);
  Add('Case', ptCase, ptKeyWord);
  Add('Is', ptIs, ptKeyWord);
  Add('On', ptIdentifier, ptOn);
  Add('Char', ptIdentifier, ptChar);
  Add('File', ptFile, ptKeyWord);
  Add('Label', ptLabel, ptKeyWord);
  Add('Mod', ptMod, ptKeyWord);
  Add('Or', ptOr, ptKeyWord);
  Add('Name', ptIdentifier, ptName);
  Add('Asm', ptAsm, ptKeyWord);
  Add('Nil', ptNil, ptKeyWord);
  Add('To', ptTo, ptKeyWord);
  Add('Div', ptDiv, ptKeyWord);
  Add('Real', ptIdentifier, ptReal);
  Add('Real48', ptIdentifier, ptReal48);
  Add('Begin', ptBegin, ptKeyWord);
  Add('Near', ptIdentifier, ptNear);
  Add('For', ptFor, ptKeyWord);
  Add('Shl', ptShl, ptKeyWord);
  Add('Packed', ptPacked, ptKeyWord);
  Add('Var', ptVar, ptKeyWord);
  Add('Else', ptElse, ptKeyWord);
  Add('Int64', ptIdentifier, ptInt64);
  Add('Set', ptSet, ptKeyWord);
  Add('Package', ptIdentifier, ptPackage);
  Add('Shr', ptShr, ptKeyWord);
  Add('PChar', ptIdentifier, ptPChar);
  Add('Then', ptThen, ptKeyWord);
  Add('Comp', ptIdentifier, ptComp);
  Add('Not', ptNot, ptKeyWord);
  Add('Byte', ptIdentifier, ptByte);
  Add('Raise', ptRaise, ptKeyWord);
  Add('Pascal', ptIdentifier, ptPascal);
  Add('Class', ptClass, ptKeyWord);
  Add('Object', ptObject, ptKeyWord);
  Add('Index', ptIdentifier, ptIndex);
  Add('Out', ptIdentifier, ptOut);
  Add('While', ptWhile, ptKeyWord);
  Add('Xor', ptXor, ptKeyWord);
  Add('Goto', ptGoto, ptKeyWord);
  Add('Safecall', ptIdentifier, ptSafecall);
  Add('Double', ptIdentifier, ptDouble);
  Add('Word', ptIdentifier, ptWord);
  Add('With', ptWith, ptKeyWord);
  Add('Dispid', ptIdentifier, ptDispid);
  Add('Cardinal', ptIdentifier, ptCardinal);
  Add('Public', ptIdentifier, ptPublic);
  Add('Array', ptArray, ptKeyWord);
  Add('Try', ptTry, ptKeyWord);
  Add('Record', ptRecord, ptKeyWord);
  Add('Inline', ptInline, ptKeyWord);
  Add('Boolean', ptIdentifier, ptBoolean);
  Add('DWORD', ptIdentifier, ptDWORD);
  Add('Uses', ptUses, ptKeyWord);
  Add('Unit', ptUnit, ptKeyWord);
  Add('Repeat', ptRepeat, ptKeyWord);
  Add('Single', ptIdentifier, ptSingle);
  Add('Type', ptType, ptKeyWord);
  Add('Default', ptIdentifier, ptDefault);
  Add('Message', ptIdentifier, ptMessage);
  Add('Dynamic', ptIdentifier, ptDynamic);
  Add('WideChar', ptIdentifier, ptWideChar);
  Add('Stdcall', ptIdentifier, ptStdcall);
  Add('Const', ptConst, ptKeyWord);
  Add('Except', ptExcept, ptKeyWord);
  Add('Write', ptIdentifier, ptWrite);
  Add('Until', ptUntil, ptKeyWord);
  Add('Integer', ptIdentifier, ptInteger);
  Add('Finally', ptFinally, ptKeyWord);
  Add('Extended', ptIdentifier, ptExtended);
  Add('Stored', ptIdentifier, ptStored);
  Add('Interface', ptInterface, ptInterface);
  Add('Abstract', ptIdentifier, ptAbstract);
  Add('Library', ptLibrary, ptKeyWord);
  Add('Forward', ptIdentifier, ptForward);
  Add('Variant', ptIdentifier, ptVariant);
  Add('String', ptString, ptKeyWord);
  Add('Program', ptProgram, ptKeyWord);
  Add('Downto', ptDownto, ptKeyWord);
  Add('Private', ptIdentifier, ptPrivate);
  Add('Longint', ptIdentifier, ptLongint);
  Add('Inherited', ptInherited, ptInherited);
  Add('LongBool', ptIdentifier, ptLongBool);
  Add('Overload', ptIdentifier, ptOverload);
  Add('Resident', ptIdentifier, ptResident);
  Add('Assembler', ptIdentifier, ptAssembler);
  Add('Readonly', ptIdentifier, ptReadonly);
  Add('Contains', ptIdentifier, ptContains);
  Add('Absolute', ptIdentifier, ptAbsolute);
  Add('ByteBool', ptIdentifier, ptByteBool);
  Add('Override', ptIdentifier, ptOverride);
  Add('Published', ptIdentifier, ptPublished);
  Add('Threadvar', ptThreadvar, ptKeyWord);
  Add('Export', ptIdentifier, ptExport);
  Add('Nodefault', ptIdentifier, ptNodefault);
  Add('External', ptIdentifier, ptExternal);
  Add('Automated', ptIdentifier, ptAutomated);
  Add('Smallint', ptIdentifier, ptSmallint);
  Add('Register', ptIdentifier, ptRegister);
  Add('Function', ptFunction, ptKeyWord);
  Add('Virtual', ptIdentifier, ptVirtual);
  Add('WordBool', ptIdentifier, ptWordBool);
  Add('Procedure', ptProcedure, ptKeyWord);
  Add('Protected', ptIdentifier, ptProtected);
  Add('Currency', ptIdentifier, ptCurrency);
  Add('Longword', ptIdentifier, ptLongword);
  Add('Requires', ptIdentifier, ptRequires);
  Add('Exports', ptExports, ptKeyWord);
  Add('OleVariant', ptIdentifier, ptOleVariant);
  Add('Shortint', ptIdentifier, ptShortint);
  Add('Implements', ptIdentifier, ptImplements);
  Add('WideString', ptIdentifier, ptWideString);
  Add('Dispinterface', ptDispinterface, ptKeyWord);
  Add('AnsiString', ptIdentifier, ptAnsiString);
  Add('Reintroduce', ptIdentifier, ptReintroduce);
  Add('Property', ptProperty, ptProperty);
  Add('Finalization', ptFinalization, ptKeyWord);
  Add('Writeonly', ptIdentifier, ptWriteonly);
  Add('Destructor', ptDestructor, ptKeyWord);
  Add('Constructor', ptConstructor, ptKeyWord);
  Add('Implementation', ptImplementation, ptKeyWord);
  Add('ShortString', ptIdentifier, ptShortString);
  Add('Initialization', ptInitialization, ptKeyWord);
  Add('Resourcestring', ptResourcestring, ptKeyWord);
  Add('Stringresource', ptIdentifier, ptStringresource);
  Add('Deprecated', ptIdentifier, ptDeprecated);
  Add('Experimental', ptIdentifier, ptExperimental);
  Add('Helper', ptIdentifier, ptHelper);
  Add('Platform', ptIdentifier, ptPlatform);
  Add('Varargs', ptIdentifier, ptVarargs);


  QuickSort;
end;

{ TmwDirectiveHash }

procedure TmwDirectiveHash.Add(const S: String; anId: TcdTokenKind);
var
  Item: TmwDirectiveHashItem;
begin
  Item:= CreateNewItem;
  Item.Key:= S;
  Item.Id:= anId;
  Item.HashValue:= HashOf(S);
  AddItem(Item);
end;

constructor TmwDirectiveHash.Create;
begin
  inherited Create;
  Init;
end;

function TmwDirectiveHash.CreateNewItem: Pointer;
begin
  Result:= TmwDirectiveHashItem.Create;
end;

procedure TmwDirectiveHash.HashRun(const P: PChar; var Running: Integer;
  var anId: TcdTokenKind);
var
  TempRun: Integer;
  Value: Cardinal;
  First, Last, Temp, Len, Index: Integer;
begin
  Value:= 0;
  TempRun:= Running;
  while StandardIdentifiers[P[Running]] do
  begin
    Value := Value shl 10 - Value shl 5 - Value + mwInsensitiveHashTable[P[Running]];
    inc(Running);
  end;
  Len:= Running - TempRun;
  Index:= -1;
  First:= 0;
  Last:= Count -1;
  Temp:= 0;
  while First <= Last do
  begin
    Temp:= (First + Last) div 2;
    case CompareValue(Value, fList[Temp].HashValue) of
      1: First:= Temp +1;
      0:
        begin
          Index:= Temp;
          break;
        end;
      -1: Last:= Temp-1;
    end;
  end;
  if Index <> -1 then
  begin
    First:= Temp;
    repeat
      if ComparePChar((P + TempRun), Len, fList[First].Key) then
      begin
        anId:= TmwDirectiveHashItem(fList[First]).Id;
        Exit;
      end;
      dec(First);
    until (First < 0) or (CompareValue(Value, fList[First].HashValue) <> 0);
    Last:= Temp +1;
    if Last = Count then Exit;
    repeat
      if ComparePChar((P + TempRun), Len, fList[Last].Key) then
      begin
        anId:= TmwDirectiveHashItem(fList[First]).Id;
        Exit;
      end;
      inc(Last);
    until (Last >= Count) or (CompareValue(Value, fList[Last].HashValue) <> 0);
  end;
end;

procedure TmwDirectiveHash.Init;
begin
  Add('A', cdA);
  Add('B', cdB);
  Add('C', cdC);
  Add('D', cdD);
  Add('E', cdE);
  Add('G', cdG);
  Add('H', cdH);
  Add('I', cdI);
  Add('J', cdJ);
  Add('L', cdL);
  Add('M', cdM);
  Add('O', cdO);
  Add('P', cdP);
  Add('Q', cdQ);
  Add('R', cdR);
  Add('T', cdT);
  Add('U', cdU);
  Add('V', cdV);
  Add('W', cdW);
  Add('X', cdX);
  Add('Y', cdY);
  Add('Z', cdZ);
  Add('And', cdAnd);
  Add('Off', cdOff);
  Add('YD', cdYD);
  Add('On', cdOn);
  Add('If', cdIf);
  Add('IfDef', cdIfDef);
  Add('Or', cdOr);
  Add('GUI', cdGUI);
  Add('EndIf', cdEndIf);
  Add('IfEnd', cdIfEnd);
  Add('Else', cdElse);
  Add('Define', cdDefine);
  Add('Align', cdAlign);
  Add('IfNDef', cdIfNDef);
  Add('Link', cdLink);
  Add('Defined', cdDefined);
  Add('UnDef', cdUnDef);
  Add('Declared', cdDeclared);
  Add('ElseIf', cdElseIf);
  Add('ImageBase', cdImageBase);
  Add('IfOpt', cdIfOpt);
  Add('SoName', cdSoName);
  Add('Include', cdInclude);
  Add('Hints', cdHints);
  Add('NoDefine', cdNoDefine);
  Add('IOChecks', cdIOChecks);
  Add('DebugInfo', cdDebugInfo);
  Add('Console', cdConsole);
  Add('Booleval', cdBooleval);
  Add('HPPEmit', cdHPPEmit);
  Add('RangeChecks', cdRangeChecks);
  Add('NoInclude', cdNoInclude);
  Add('Apptype', cdApptype);
  Add('SafeDivide', cdSafeDivide);
  Add('Resource', cdResource);
  Add('Warn', cdWarn);
  Add('Warnings', cdWarnings);
  Add('TypeInfo', cdTypeInfo);
  Add('SetPEFlags', cdSetPEFlags);
  Add('SoPrefix', cdSoPrefix);
  Add('StackFrames', cdStackFrames);
  Add('RunOnly', cdRunOnly);
  Add('SoSuffix', cdSoSuffix);
  Add('ReferenceInfo', cdReferenceInfo);
  Add('DesignOnly', cdDesignOnly);
  Add('Extension', cdExtension);
  Add('ImportedData', cdImportedData);
  Add('Description', cdDescription);
  Add('SoVersion', cdSoVersion);
  Add('Assertions', cdAssertions);
  Add('ImplicitBuild', cdImplicitBuild);
  Add('TypedAddress', cdTypedAddress);
  Add('LocalSymbols', cdLocalSymbols);
  Add('MinEnumSize', cdMinEnumSize);
  Add('WeakPackageUnit', cdWeakPackageUnit);
  Add('DefinitionInfo', cdDefinitionInfo);
  Add('MinStackSize', cdMinStackSize);
  Add('ObjExportAll', cdObjExportAll);
  Add('MaxStackSize', cdMaxStackSize);
  Add('LongStrings', cdLongStrings);
  Add('DenyPackageUnit', cdDenyPackageUnit);
  Add('ExternalSym', cdExternalSym);
  Add('OpenStrings', cdOpenStrings);
  Add('SetPEOptFlags', cdSetPEOptFlags);
  Add('OverFlowChecks', cdOverFlowChecks);
  Add('WriteableConst', cdWriteableConst);
  Add('Optimization', cdOptimization);
  Add('VarStringChecks', cdVarStringChecks);
  Add('ExtendedSyntax', cdExtendedSyntax);
  Add('RealCompatibility', cdRealCompatibility);
  Add('ResourceReserve', cdResourceReserve);

  QuickSort;
end;

{ TmwAssignAbleHash }

procedure TmwAssignAbleHash.Assign(HashList: TmwAssignAbleHash);
var
  I: Integer;
begin
  if HashList <> nil then
  for I:= 0 to HashList.FCount -1 do
    AddSorted(HashList.FList[I].Key);
end;

initialization
  MakeIdentTable;
end.

