unit kbmMemTable;

interface

{$include kbmMemTable.inc}

//=============================================================================
// If you have a valid commercial kbmMW developer license, uncomment the next
// line to gain significant amounts of speed.
//{$define HAVE_COMMERCIAL_KBMMW_LICENSE}
//=============================================================================

//=============================================================================
// Remove the remark on the next line if all records should be checked before use.
//{$define DO_CHECKRECORD}
//=============================================================================

//=============================================================================
// Comment the next line to use the standard Quicksort algorithm.
{$define USE_FAST_QUICKSORT}
//=============================================================================

//=============================================================================
// Uncomment the next line to use less optimized code.
{$define USE_SAFE_CODE}
//=============================================================================

{$IFDEF HAVE_COMMERCIAL_KBMMW_LICENSE}
 {$IFNDEF LINUX}
  {$IFNDEF DOTNET}
   {$DEFINE USE_FAST_STRINGCOMPARE}
   {$IFDEF LEVEL6}
    {$DEFINE USE_FAST_MOVE}
   {$ENDIF}
   {$DEFINE USE_FAST_LIST}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF BCB}
{$ObjExportAll On}
{$ASSERTIONS ON}
{$ENDIF}

uses
  SysUtils,
  Classes,
  DB,
  DBCommon
{$IFDEF LINUX}
  ,Types
  ,Libc
{$ELSE}
  ,Windows
{$ENDIF}
{$IFDEF LEVEL5}
  ,SyncObjs
  ,Masks
{$ENDIF}
{$IFDEF LEVEL6}
  ,variants
  ,fmtbcd
  ,SqlTimSt
{$ENDIF}
// If you get compile error here then its because HAVE_COMMERCIAL_KBMMW_LICENSE
// is defined further up without you actually having installed the Pro additions
// of kbmMemTable. The Pro edition is only available with kbmMW commercial edition.
// To fix, comment the {$DEFINE HAVE_COMMERCIAL_KBMMW_LICENSE} further up, or
// install kbmMemTable Pro addtions.
{$IFDEF USE_FAST_STRINGCOMPARE}
  ,kbmString
{$ENDIF}
{$IFDEF USE_FAST_LIST}
  ,kbmList
{$ENDIF}
{$IFDEF DOTNET}
  ,Borland.Vcl.Forms
  ,System.Runtime.InteropServices
{$ENDIF}
  ;

{$B-}    // Enable short circuit evaluation.
{$T-}    // Disable typechecking on @

const COMPONENT_VERSION = '5.51';

//=============================================================================
// Change this if you need more than 256 fields in a table.
const
     KBM_MAX_FIELDS=256;
//=============================================================================

//***********************************************************************

const
     // Key buffer types.
     kbmkbMin=0;
     kbmkbKey=0;
     kbmkbRangeStart=1;
     kbmkbRangeEnd=2;
     kbmkbMasterDetail=3;
     kbmkbMax=3;

     // Field flags.
     kbmffIndirect = $01;
     kbmffCompress = $02;
     kbmffModified = $04;

     // Record identifier.
     kbmRecordIdent=$6A1B2C3E;

     // Consts for GetRows
     kbmBookmarkCurrent = $00000000;
     kbmBookmarkFirst = $00000001;
     kbmBookmarkLast = $00000002;
     kbmGetRowsRest = $FFFFFFFF;

     // Const for field flags.
     kbmffNull    = #00;
     kbmffUnknown = #01;
     kbmffData    = #02;

     // Internal index names.
     kbmRowOrderIndex = '__MT__ROWORDER';
     kbmDefSortIndex  = '__MT__DEFSORT';
     kbmAutoIndex     = '__MT__AUTO_';

     // Record flags.
     kbmrfInTable          = $01;  // 0000 0001    Is record a work record or actually from the table.
     kbmrfDontCheckPoint   = $02;  // 0000 0010    Is record marked for not to checkpoint.

{$IFDEF LINUX}
     INFINITE = LongWord($FFFFFFFF);
{$ENDIF}

type
  // Define error classes and error groups.
  EMemTableError = class(EDataBaseError);

  EMemTableFatalError = class(EMemTableError);
  EMemTableInvalidRecord = class(EMemTableFatalError);

  EMemTableIndexError = class(EMemTableError);
  EMemTableDupKey = class(EMemTableError);

  EMemTableFilterError = class(EMemTableError);

  EMemTableLocaleError = class(EMemTableError);
  EMemTableInvalidLocale = class(EMemTableLocaleError);

  TkbmCustomMemTable = class;
  TkbmCustomDeltaHandler = class;

{$IFDEF DOTNET}
  PkbmRecord    = IntPtr; // TkbmRecord;
  PBookmarkFlag = IntPtr; // ^TBookmarkFlag;
{$ELSE}
  PkbmRecord    = ^TkbmRecord;
  PBookmarkFlag = ^TBookmarkFlag;
{$ENDIF}


{$IFDEF DOTNET}
  [StructLayout(LayoutKind.Sequential)]
{$ENDIF}
  TkbmBookmark=record
      Bookmark:PkbmRecord;
      Flag:TBookmarkFlag;
  end;

{$IFDEF DOTNET}
  PkbmBookmark = IntPtr;// TkbmBookmark;
{$ELSE}
  PkbmBookmark = ^TkbmBookmark;
{$ENDIF}

{$IFDEF DOTNET}
  [StructLayout(LayoutKind.Sequential)]
{$ENDIF}
  TkbmUserBookmark=record
      Bookmark:PkbmRecord;
      DataID:longint;
  end;

{$IFDEF DOTNET}
  PkbmUserBookmark = IntPtr; // TkbmUserBookmark;
{$ELSE}
  PkbmUserBookmark = ^TkbmUserBookmark;
{$ENDIF}

{$IFNDEF USE_FAST_LIST}
  TkbmList = TList;
{$ENDIF}

  // IndexFieldOptions.
  TkbmifoOption = (mtifoDescending,mtifoCaseInsensitive,mtifoPartial,mtifoIgnoreNull,mtifoIgnoreLocale);
  TkbmifoOptions = set of TkbmifoOption;

  TkbmIndex=class;

{$IFDEF DOTNET}
  [StructLayout(LayoutKind.Sequential)]
{$ENDIF}
  TkbmRecord=record
{$IFDEF DO_CHECKRECORD}
      StartIdent:longint;
{$ENDIF}

      RecordNo: integer;      // Will be set on every single getrecord call.
      RecordID: integer;
      UniqueRecordID: integer;

      Flag:byte;              // Record flags.
      UpdateStatus:TUpdateStatus;

      TransactionLevel:integer;
      Tag:longint;
      PrevRecordVersion:PkbmRecord;

      // Data starts at place pointed at by data, right after the end of TkbmRecord.
{$IFDEF DOTNET}
      Data:TValueBuffer;//           array of byte;
{$ELSE}
      Data:PChar;
{$ENDIF}

{$IFDEF DO_CHECKRECORD}
      EndIdent:longint;
{$ENDIF}
  end;

{
  Internal Data layout:
+------------+------------------------+-----------------------+------------------+----------------------+
| TkbmRecord | FIXED LENGTH DATA      | CALCULATED FIELDS     |Bookmark arrays   | VARIABLE LENGTH PTRS |
|            | FFixedRecordSize bytes | FCalcRecordSize bytes |FBookmarkArraySize| FVarLengthRecordSize |
+------------+------------------------+-----------------------+------------------+----------------------+
             ^                        ^                       ^                  ^
             GetFieldPointer          StartCalculated         StartBookmarks     StartVarLength

Blobsfields in the internal buffer are pointers to the blob data.
}

{$IFDEF DOTNET}
  PDateTimeRec = IntPtr;
  PWordBool    = IntPtr;
{$ELSE}
  PDateTimeRec=^TDateTimeRec;
  PWordBool=^WordBool;
{$ENDIF}

  TkbmMemTableStorageType = (mtstDataSet,mtstStream,mtstBinaryStream,mtstFile,mtstBinaryFile);

  TkbmMemTableUpdateFlag = (mtufEdit,mtufAppend,mtufDontClear);
  TkbmMemTableUpdateFlags = set of TkbmMemTableUpdateFlag;

  TkbmFieldTypes = set of TFieldType;

  TkbmMemTableCompareOption = (mtcoDescending,mtcoCaseInsensitive,mtcoPartialKey,mtcoIgnoreNullKey,mtcoIgnoreLocale,mtcoUnique,mtcoNonMaintained);
  TkbmMemTableCompareOptions = set of TkbmMemTableCompareOption;

  TkbmMemTableCopyTableOption = (mtcpoStructure,mtcpoOnlyActiveFields,mtcpoProperties,mtcpoLookup,mtcpoCalculated,mtcpoAppend,mtcpoFieldIndex,mtcpoDontDisableIndexes,
                                 mtcpoIgnoreErrors{$IFDEF LEVEL6},mtcpoStringAsWideString,mtcpoWideStringUTF8{$ENDIF});
  TkbmMemTableCopyTableOptions = set of TkbmMemTableCopyTableOption;

  TkbmOnFilterIndex = procedure(DataSet:TDataSet; Index:TkbmIndex; var Accept:boolean) of object;

{$IFDEF DOTNET}
  PkbmVarLength    = IntPtr;
  PPkbmVarLength   = PkbmVarLength;
{$ELSE}
  PkbmVarLength=PChar;
  PPkbmVarLength=^PkbmVarLength;
{$ENDIF}

  TkbmIndexType = (mtitNonSorted,mtitSorted);

  TkbmFieldList = class
  private
     FCount:integer;
  public
     FieldOfs:array [0..KBM_MAX_FIELDS-1] of integer;
     FieldNo:array [0..KBM_MAX_FIELDS-1] of integer;
     Fields:array [0..KBM_MAX_FIELDS-1] of TField;
     Options:array [0..KBM_MAX_FIELDS-1] of TkbmifoOptions;

     destructor Destroy; override;
     function Add(AField:TField; AValue:TkbmifoOptions):Integer;
     procedure Clear; virtual;
     function IndexOf(Item:TField): Integer;
     procedure AssignTo(AFieldList:TkbmFieldList);
     procedure MergeOptionsTo(AFieldList:TkbmFieldList); // Must be identical fieldlists.
     procedure ClearOptions;
     property Count: Integer read FCount;
  end;

  TkbmIndex = class
  private
     FName:             string;
     FReferences:       TkbmList;
     FDataSet:          TkbmCustomMemTable;
     FIndexFields:      string;
     FIndexFieldList:   TkbmFieldList;
     FIndexOptions:     TkbmMemTableCompareOptions;
     FOrdered:          boolean;
     FType:             TkbmIndexType;
     FRowOrder:         boolean;
     FInternal:         boolean;
     FIndexOfs:         integer;
     FIsView:           boolean;
     FIsFiltered:       boolean;
     FEnabled:          boolean;
     FUpdateStatus:     TUpdateStatusSet;
{$IFDEF LEVEL5}
     FFilterParser:     TExprParser;
{$ENDIF}
     FFilterFunc:       TkbmOnFilterIndex;

     procedure InternalSwap(const I,J:integer);
{$IFDEF USE_FAST_QUICKSORT}
     procedure InternalInsertionSort(const Lo,Hi:integer);
     procedure InternalFastQuickSort(const L,R:Integer);
{$ENDIF}
     procedure SetEnabled(AValue:boolean);
  protected
     function CompareRecords(const AFieldList:TkbmFieldList; const KeyRecord,ARecord:PkbmRecord; const SortCompare,Partial:boolean): Integer;
{$IFDEF USE_FAST_QUICKSORT}
     procedure FastQuickSort(const L,R:Integer);
{$ELSE}
     procedure QuickSort(L,R:Integer);
{$ENDIF}
     function BinarySearchRecordID(FirstNo,LastNo:integer; const RecordID:integer; const Desc:boolean; var Index:integer):integer;
     function SequentialSearchRecordID(const FirstNo,LastNo:integer; const RecordID:integer; var Index:integer):integer;
     function BinarySearch(FieldList:TkbmFieldList; FirstNo,LastNo:integer; const KeyRecord:PkbmRecord; const First,Nearest,RespectFilter:boolean; var Index:integer; var Found:boolean):integer;
     function SequentialSearch(FieldList:TkbmFieldList; const FirstNo,LastNo:integer; const KeyRecord:PkbmRecord; const Nearest,RespectFilter:boolean; var Index:integer; var Found:boolean):integer;
     function FindRecordNumber(const RecordBuffer:{$IFDEF DOTNET}TValueBuffer{$ELSE}PChar{$ENDIF}):integer;
     function Filter(const ARecord:PkbmRecord):boolean;

  public
     constructor Create(Name:string;DataSet:TkbmCustomMemtable; Fields:string; Options:TkbmMemTableCompareOptions; IndexType:TkbmIndexType; Internal:boolean); {$IFDEF LEVEL5}overload;{$ENDIF}
{$IFDEF LEVEL5}
     constructor Create(IndexDef:TIndexDef;DataSet:TkbmCustomMemtable); overload;
{$ELSE}
     constructor CreateByIndexDef(IndexDef:TIndexDef;DataSet:TkbmCustomMemtable);
{$ENDIF}

     destructor Destroy; override;

     function Search(FieldList:TkbmFieldList; KeyRecord:PkbmRecord; Nearest,RespectFilter:boolean; var Index:integer; var Found:boolean):integer;
     function SearchRecord(KeyRecord:PkbmRecord; var Index:integer; RespectFilter:boolean):integer;
     function SearchRecordID(RecordID:integer; var Index:integer):integer;
     procedure Clear;
     procedure LoadAll;
     procedure ReSort;
     procedure Rebuild;

     property Enabled:boolean read FEnabled write SetEnabled;
     property IsView:boolean read FIsView write FIsView;
     property IsOrdered:boolean read FOrdered write FOrdered;
     property IsFiltered:boolean read FIsFiltered write FIsFiltered;
     property IndexType:TkbmIndexType read FType write FType;
     property IndexOptions:TkbmMemTableCompareOptions read FIndexOptions write FIndexOptions;
     property IndexFields:string read FIndexFields write FIndexFields;
     property IndexFieldList:TkbmFieldList read FIndexFieldList write FIndexFieldList;
     property Dataset:TkbmCustomMemTable read FDataSet write FDataSet;
     property Name:string read FName write FName;
     property References:TkbmList read FReferences write FReferences;
     property IsRowOrder:boolean read FRowOrder write FRowOrder;
     property IsInternal:boolean read FInternal write FInternal;
     property IndexOfs:integer read FIndexOfs write FIndexOfs;
     property UpdateStatus:TUpdateStatusSet read FUpdateStatus write FUpdateStatus;
  end;

  TkbmIndexUpdateHow = (mtiuhInsert,mtiuhEdit,mtiuhDelete);

  TkbmIndexes = class
  private
     FRowOrderIndex:  TkbmIndex;
     FIndexes:        TStringList;
     FDataSet:        TkbmCustomMemTable;

  public
     constructor Create(ADataSet:TkbmCustomMemTable);
     destructor Destroy; override;

     procedure Clear;
     procedure Add(const IndexDef:TIndexDef);

     procedure AddIndex(const Index:TkbmIndex);
     procedure DeleteIndex(const Index:TkbmIndex);

     procedure ReBuild(const IndexName:string);
     procedure Delete(const IndexName:string);
     function Get(const IndexName:string):TkbmIndex;
     function GetIndex(const Ordinal:integer):TkbmIndex;
     procedure Empty(const IndexName:string);

     function GetByFieldNames(FieldNames:string):TkbmIndex;

     procedure EmptyAll;
     procedure ReBuildAll;
     procedure MarkAllDirty;

     procedure CheckRecordUniqueness(const ARecord,ActualRecord:PkbmRecord);
     procedure ReflectToIndexes(const How:TkbmIndexUpdateHow; const OldRecord,NewRecord:PkbmRecord; const RecordPos:integer; const DontVersion:boolean);
     function Search(const FieldList:TkbmFieldList; const KeyRecord:PkbmRecord; const Nearest,RespectFilter,AutoAddIdx:boolean; var Index:integer; var Found:boolean):integer;
     function  Count:integer;
  end;

  TkbmVersioningMode = (mtvm1SinceCheckPoint,mtvmAllSinceCheckPoint);

  TkbmProgressCode = (mtpcLoad,mtpcSave,mtpcEmpty,mtpcPack,mtpcCheckPoint,mtpcSearch,mtpcCopy,mtpcUpdate,mtpcSort);
  TkbmProgressCodes = set of TkbmProgressCode;

  TkbmState = (mtstBrowse,mtstLoad,mtstSave,mtstEmpty,mtstPack,mtstCheckPoint,mtstSearch,mtstUpdate,mtstSort);

  TkbmPerformance = (mtpfFast,mtpfBalanced,mtpfSmall);

  TkbmOnProgress = procedure(DataSet:TDataSet; Percentage:integer; Code:TkbmProgressCode) of object;
  TkbmOnLoadRecord = procedure(DataSet:TDataSet; var Accept:boolean) of object;
  TkbmOnLoadField = procedure(DataSet:TDataSet; FieldNo:integer; Field:TField) of object;
  TkbmOnSaveRecord = procedure(DataSet:TDataSet; var Accept:boolean) of object;
  TkbmOnSaveField = procedure(DataSet:TDataSet; FieldNo:integer; Field:TField) of object;
{$IFDEF DOTNET}
  TkbmOnCompressField = procedure(DataSet:TDataSet; Field:TField; const Buffer:IntPtr; var Size:longint; var ResultBuffer:IntPtr) of object;
  TkbmOnDecompressField = procedure(DataSet:TDataSet; Field:TField; const Buffer:IntPtr; var Size:longint; var ResultBuffer:IntPtr) of object;
  TkbmOnCompareFields = procedure(DataSet:TDataSet; AFld:TField; KeyField,AField:IntPtr; FieldType:TFieldType; Options:TkbmifoOptions; var FullCompare:boolean; var Result:integer) of object;
{$ELSE}
  TkbmOnCompressField = procedure(DataSet:TDataSet; Field:TField; const Buffer:PChar; var Size:longint; var ResultBuffer:PChar) of object;
  TkbmOnDecompressField = procedure(DataSet:TDataSet; Field:TField; const Buffer:PChar; var Size:longint; var ResultBuffer:PChar) of object;
  TkbmOnCompareFields = procedure(DataSet:TDataSet; AFld:TField; KeyField,AField:pointer; FieldType:TFieldType; Options:TkbmifoOptions; var FullCompare:boolean; var Result:integer) of object;
{$ENDIF}

  TkbmOnSave = procedure(DataSet:TDataSet; StorageType:TkbmMemTableStorageType; Stream:TStream) of object;
  TkbmOnLoad = procedure(DataSet:TDataSet; StorageType:TkbmMemTableStorageType; Stream:TStream) of object;
  TkbmOnSetupField = procedure(DataSet:TDataSet; Field:TField; var FieldFlags:byte) of object;
  TkbmOnSetupFieldProperties = procedure(DataSet:TDataSet; Field:TField) of object;

{$IFDEF LEVEL3}
  TUpdateStatusSet = set of TUpdateStatus;
{$ENDIF}

  TkbmLocaleID = integer;

  TkbmStreamFlagData                = (sfSaveData,sfLoadData);
  TkbmStreamFlagCalculated          = (sfSaveCalculated,sfLoadCalculated);
  TkbmStreamFlagLookup              = (sfSaveLookup,sfLoadLookup);
  TkbmStreamFlagNonVisible          = (sfSaveNonVisible,sfLoadNonVisible);
  TkbmStreamFlagBlobs               = (sfSaveBlobs,sfLoadBlobs);
  TkbmStreamFlagDef                 = (sfSaveDef,sfLoadDef);
  TkbmStreamFlagIndexDef            = (sfSaveIndexDef,sfLoadIndexDef);
  TkbmStreamFlagFiltered            = (sfSaveFiltered);
  TkbmStreamFlagIgnoreRange         = (sfSaveIgnoreRange);
  TkbmStreamFlagIgnoreMasterDetail  = (sfSaveIgnoreMasterDetail);
  TkbmStreamFlagDeltas              = (sfSaveDeltas, sfLoadDeltas);
  TkbmStreamFlagDontFilterDeltas    = (sfSaveDontFilterDeltas);
  TkbmStreamFlagAppend              = (sfSaveAppend,sfSaveInsert);
  TkbmStreamFlagFieldKind           = (sfSaveFieldKind,sfLoadFieldKind);
  TkbmStreamFlagFromStart           = (sfLoadFromStart);

  TkbmStreamFlagsData               = set of TkbmStreamFlagData;
  TkbmStreamFlagsCalculated         = set of TkbmStreamFlagCalculated;
  TkbmStreamFlagsLookup             = set of TkbmStreamFlagLookup;
  TkbmStreamFlagsNonVisible         = set of TkbmStreamFlagNonVisible;
  TkbmStreamFlagsBlobs              = set of TkbmStreamFlagBlobs;
  TkbmStreamFlagsDef                = set of TkbmStreamFlagDef;
  TkbmStreamFlagsIndexDef           = set of TkbmStreamFlagIndexDef;
  TkbmStreamFlagsFiltered           = set of TkbmStreamFlagFiltered;
  TkbmStreamFlagsIgnoreRange        = set of TkbmStreamFlagIgnoreRange;
  TkbmStreamFlagsIgnoreMasterDetail = set of TkbmStreamFlagIgnoreMasterDetail;
  TkbmStreamFlagsDeltas             = set of TkbmStreamFlagDeltas;
  TkbmStreamFlagsDontFilterDeltas   = set of TkbmStreamFlagDontFilterDeltas;
  TkbmStreamFlagsAppend             = set of TkbmStreamFlagAppend;
  TkbmStreamFlagsFieldKind          = set of TkbmStreamFlagFieldKind;
  TkbmStreamFlagsFromStart          = set of TkbmStreamFlagFromStart;

  TkbmOnCompress = procedure(Dataset:TkbmCustomMemTable; UnCompressedStream,CompressedStream:TStream) of object;
  TkbmOnDeCompress = procedure(Dataset:TkbmCustomMemTable; CompressedStream,DeCompressedStream:TStream) of object;

  TkbmDetermineLoadFieldsSituation = (dlfBeforeLoad,dlfAfterLoadDef);

  TkbmCustomStreamFormat = class(TComponent)
  private
     FOrigStream:TStream;
     FWorkStream:TStream;
     FBookmark:TBookmark;

     FOnCompress:TkbmOnCompress;
     FOnDecompress:TkbmOnDeCompress;

     FWasFiltered:boolean;
     FWasRangeActive:boolean;
     FWasMasterLinkUsed:boolean;
     FWasEnableIndexes:boolean;
     FWasPersistent:boolean;

     FsfData:                TkbmStreamFlagsData;
     FsfCalculated:          TkbmStreamFlagsCalculated;
     FsfLookup:              TkbmStreamFlagsLookup;
     FsfNonVisible:          TkbmStreamFlagsNonVisible;
     FsfBlobs:               TkbmStreamFlagsBlobs;
     FsfDef:                 TkbmStreamFlagsDef;
     FsfIndexDef:            TkbmStreamFlagsIndexDef;
     FsfFiltered:            TkbmStreamFlagsFiltered;
     FsfIgnoreRange:         TkbmStreamFlagsIgnoreRange;
     FsfIgnoreMasterDetail:  TkbmStreamFlagsIgnoreMasterDetail;
     FsfDeltas:              TkbmStreamFlagsDeltas;
     FsfDontFilterDeltas:    TkbmStreamFlagsDontFilterDeltas;
     FsfAppend:              TkbmStreamFlagsAppend;
     FsfFieldKind:           TkbmStreamFlagsFieldKind;
     FsfFromStart:           TkbmStreamFlagsFromStart;

     FOnBeforeSave:          TNotifyEvent;
     FOnAfterSave:           TNotifyEvent;
     FOnBeforeLoad:          TNotifyEvent;
     FOnAfterLoad:           TNotifyEvent;

     procedure SetVersion(AVersion:string);
  protected
{$IFDEF LEVEL4}
     SaveFields,
     LoadFields:array of integer;
{$ELSE}
     SaveFields,
     LoadFields:array [0..KBM_MAX_FIELDS] of integer;
     LoadFieldsCount,
     SaveFieldsCount:integer;
{$ENDIF}

     procedure SetIgnoreAutoIncPopulation(ADataset:TkbmCustomMemTable; Value:boolean);

     function  GetVersion:string; virtual;

     procedure DetermineSaveFields(ADataset:TkbmCustomMemTable); virtual;
     procedure BeforeSave(ADataset:TkbmCustomMemTable); virtual;
     procedure SaveDef(ADataset:TkbmCustomMemTable); virtual;
     procedure SaveData(ADataset:TkbmCustomMemTable); virtual;
     procedure Save(ADataset:TkbmCustomMemTable); virtual;
     procedure AfterSave(ADataset:TkbmCustomMemTable); virtual;

     procedure DetermineLoadFieldIDs(ADataset:TkbmCustomMemTable; AList:TStringList; Situation:TkbmDetermineLoadFieldsSituation); virtual;
     procedure DetermineLoadFields(ADataset:TkbmCustomMemTable; Situation:TkbmDetermineLoadFieldsSituation); virtual;
     procedure DetermineLoadFieldIndex(ADataset:TkbmCustomMemTable; ID:string; FieldCount:integer; OrigIndex:integer; var NewIndex:integer; Situation:TkbmDetermineLoadFieldsSituation); virtual;
     procedure BeforeLoad(ADataset:TkbmCustomMemTable); virtual;
     procedure LoadDef(ADataset:TkbmCustomMemTable); virtual;
     procedure LoadData(ADataset:TkbmCustomMemTable); virtual;
     procedure Load(ADataset:TkbmCustomMemTable); virtual;
     procedure AfterLoad(ADataset:TkbmCustomMemTable); virtual;

     property WorkStream:TStream read FWorkStream write FWorkStream;
     property OrigStream:TStream read FOrigStream write FOrigStream;

     property sfData:TkbmStreamFlagsData read FsfData write FsfData;
     property sfCalculated:TkbmStreamFlagsCalculated read FsfCalculated write FsfCalculated;
     property sfLookup:TkbmStreamFlagsLookup read FsfLookup write FsfLookup;
     property sfNonVisible:TkbmStreamFlagsNonVisible read FsfNonVisible write FsfNonVisible;
     property sfBlobs:TkbmStreamFlagsBlobs read FsfBlobs write FsfBlobs;
     property sfDef:TkbmStreamFlagsDef read FsfDef write FsfDef;
     property sfIndexDef:TkbmStreamFlagsIndexDef read FsfIndexDef write FsfIndexDef;
     property sfFiltered:TkbmStreamFlagsFiltered read FsfFiltered write FsfFiltered;
     property sfIgnoreRange:TkbmStreamFlagsIgnoreRange read FsfIgnoreRange write FsfIgnoreRange;
     property sfIgnoreMasterDetail:TkbmStreamFlagsIgnoreMasterDetail read FsfIgnoreMasterDetail write FsfIgnoreMasterDetail;
     property sfDeltas:TkbmStreamFlagsDeltas read FsfDeltas write FsfDeltas;
     property sfDontFilterDeltas:TkbmStreamFlagsDontFilterDeltas read FsfDontFilterDeltas write FsfDontFilterDeltas;
     property sfAppend:TkbmStreamFlagsAppend read FsfAppend write FsfAppend;
     property sfFieldKind:TkbmStreamFlagsFieldKind read FsfFieldKind write FsfFieldKind;
     property sfFromStart:TkbmStreamFlagsFromStart read FsfFromStart write FsfFromStart;
     property Version:string read GetVersion write SetVersion;

     property OnBeforeSave:TNotifyEvent read FOnBeforeSave write FOnBeforeSave;
     property OnAfterSave:TNotifyEvent read FOnAfterSave write FOnAfterSave;
     property OnBeforeLoad:TNotifyEvent read FOnBeforeLoad write FOnBeforeLoad;
     property OnAfterLoad:TNotifyEvent read FOnAfterLoad write FOnAfterLoad;
     property OnCompress:TkbmOnCompress read FOnCompress write FOnCompress;
     property OnDeCompress:TkbmOnDecompress read FOnDecompress write FOnDecompress;

  public
     constructor Create(AOwner:TComponent); override;
     procedure Assign(Source:TPersistent); override;
  end;

  TkbmStreamFormat = class(TkbmCustomStreamFormat)
  published
     property sfData;
     property sfCalculated;
     property sfLookup;
     property sfNonVisible;
     property sfBlobs;
     property sfDef;
     property sfIndexDef;
     property sfFiltered;
     property sfIgnoreRange;
     property sfIgnoreMasterDetail;
     property sfDeltas;
     property sfDontFilterDeltas;
     property sfAppend;
     property sfFieldKind;
     property sfFromStart;
     property Version;

     property OnBeforeLoad;
     property OnAfterLoad;
     property OnBeforeSave;
     property OnAfterSave;
     property OnCompress;
     property OnDeCompress;
  end;

  TkbmCompareHow = (chBreakNE,chBreakLT,chBreakGT,chBreakLTE,chBreakGTE);

  TkbmCommon = class
  protected
{$IFNDEF LEVEL5}
      FLock:                                  TRTLCriticalSection;
{$ELSE}
      FLock:                                  TCriticalSection;
{$ENDIF}
      FStandalone:                            boolean;
      FRecords:                               TkbmList;

      FOwner:                                 TkbmCustomMemTable;

      FFieldCount:                            integer;
      FFieldOfs:                              array [0..KBM_MAX_FIELDS-1] of integer;
      FFieldFlags:                            array [0..KBM_MAX_FIELDS-1] of byte;

      FLanguageID,
      FSubLanguageID,
      FSortID:                                integer;

      // Data identifier.
      FDataID:                                longint;

      // Setup from FLanguageID, FSubLanguageID and FSortID.
      FLocaleID:                              TkbmLocaleID;

      FBookmarkArraySize,
      FFixedRecordSize,
      FTotalRecordSize,
      FDataRecordSize,
      FCalcRecordSize,
      FVarLengthRecordSize,
      FStartCalculated,
      FStartBookmarks,
      FStartVarLength:                        longint;
      FVarLengthCount:                        integer;

      FIsDataModified:                        boolean;

      FAutoIncMin,
      FAutoIncMax:                            longint;

      // Holds the number of records marked as deleted but not yet removed (used during versioning of records).
      // Used for keeping track if any filtering should occur.
      FDeletedCount:                          longint;

      FUniqueRecordID:                        longint;
      FRecordID:                              longint;

      FPerformance:                           TkbmPerformance;

      FAttachMaxCount:                        integer;
      FAttachedTables:                        TList;

      // Holds a list of all actually deleted records for later reuse.
      FDeletedRecords:                        TkbmList;

      FVersioningMode:                        TkbmVersioningMode;
      FEnableVersioning:                      boolean;

      FTransactionLevel:                      longint;

      FThreadProtected:                       boolean;

{$IFDEF DO_CHECKRECORD}
      procedure _InternalCheckRecord(ARecord:PkbmRecord);
{$ENDIF}
      function _InternalCopyRecord(SourceRecord:PkbmRecord; CopyVarLengths:boolean):PkbmRecord;
      procedure _InternalCopyVarLength(SourceRecord,DestRecord:PkbmRecord; Field:TField);
      procedure _InternalCopyVarLengths(SourceRec,DestRec:PkbmRecord);
      procedure _InternalMoveRecord(SourceRecord,DestRecord:PkbmRecord);
      procedure _InternalTransferRecord(SourceRecord,DestRecord:PkbmRecord);
      procedure _InternalFreeRecordVarLengths(ARecord:PkbmRecord);
      procedure _InternalClearRecord(ARecord:PkbmRecord);
      procedure _InternalAppendRecord(ARecord:PkbmRecord);
      procedure _InternalDeleteRecord(ARecord:PkbmRecord);
      procedure _InternalPackRecords;
      procedure _InternalEmpty;
      function  _InternalCompareRecords(const FieldList:TkbmFieldList; const MaxFields:integer; const KeyRecord,ARecord:PkbmRecord; const IgnoreNull,Partial:boolean; const How:TkbmCompareHow): Integer;

      procedure SetStandalone(Value:boolean);
      function GetStandalone:boolean;
      procedure SetAutoIncMin(Value:longint);
      function GetAutoIncMin:longint;
      procedure SetAutoIncMax(Value:longint);
      function GetAutoIncMax:longint;
      procedure SetPerformance(Value:TkbmPerformance);
      function GetPerformance:TkbmPerformance;
      procedure SetVersioningMode(Value:TkbmVersioningMode);
      function GetVersioningMode:TkbmVersioningMode;
      procedure SetEnableVersioning(Value:boolean);
      function GetEnableVersioning:boolean;
      procedure SetCapacity(Value:longint);
      function GetCapacity:longint;
      function GetTransactionLevel:integer;
      function GetIsDataModified:boolean;
      procedure SetIsDataModified(Value:boolean);
      procedure ClearModifiedFlags;
      function GetModifiedFlag(i:integer):boolean;
      procedure SetModifiedFlag(i:integer; Value:boolean);
      function GetAttachMaxCount:integer;
      procedure SetAttachMaxCount(Value:integer);
      function GetAttachCount:integer;

      procedure SetRecordID(ARecordID:longint);
      procedure SetUniqueRecordID(ARecordID:longint);
      procedure SetDeletedCount(ACount:longint);

      function GetLanguageID:integer;
      procedure SetLanguageID(Value:integer);
      function GetSortID:integer;
      procedure SetSortID(Value:integer);
      function GetSubLanguageID:integer;
      procedure SetSubLanguageID(Value:integer);
      function GetLocaleID:TkbmLocaleID;
      procedure SetLocaleID(Value:TkbmLocaleID);

      procedure CalcLocaleID;
      function  GetUniqueDataID:longint;
  public
      function GetDeletedRecordsCount:integer;

      function GetFieldSize(FieldType:TFieldType; Size:longint):longint;
      function GetFieldDataOffset(Field:TField):integer;
      function GetFieldPointer(ARecord:PkbmRecord; Field:TField):{$IFDEF DOTNET}IntPtr{$ELSE}PChar{$ENDIF};

      function _InternalAllocRecord:PkbmRecord;
      procedure _InternalFreeRecord(ARecord:PkbmRecord; FreeVarLengths, FreeVersions:boolean);

      constructor Create(AOwner:TkbmCustomMemTable);
      destructor Destroy; override;
      procedure Lock;
      procedure Unlock;

      function GetFieldIsVarLength(FieldType:TFieldType; Size:longint):boolean;
{$IFDEF DOTNET}
      function CompressFieldBuffer(Field:TField; const Buffer:IntPtr; var Size:longint):IntPtr;
      function DecompressFieldBuffer(Field:TField; const Buffer:IntPtr; var Size:longint):IntPtr;
{$ELSE}
      function CompressFieldBuffer(Field:TField; const Buffer:pointer; var Size:longint):pointer;
      function DecompressFieldBuffer(Field:TField; const Buffer:pointer; var Size:longint):pointer;
{$ENDIF}

      procedure AttachTable(ATable:TkbmCustomMemTable);
      procedure DeAttachTable(ATable:TkbmCustomMemTable);
      procedure LayoutRecord(const AFieldCount:integer);

      procedure AppendRecord(ARecord:PkbmRecord);
      procedure DeleteRecord(ARecord:PkbmRecord);
      procedure PackRecords;
      function RecordCount:integer;
      function DeletedRecordCount:integer;
      procedure Rollback;
      procedure Commit;
      procedure Undo(ARecord:PkbmRecord);

      function IsAnyTableActive:boolean;
      procedure CloseTables(Caller:TkbmCustomMemTable);
      procedure RefreshTables(Caller:TkbmCustomMemTable);
      procedure ResyncTables;
      procedure EmptyTables;
      procedure RebuildIndexes;
      procedure MarkIndexesDirty;
      procedure UpdateIndexes;
      procedure ClearIndexes;
      procedure ReflectToIndexes(const Caller:TkbmCustomMemTable; const How:TkbmIndexUpdateHow; const OldRecord,NewRecord:PkbmRecord; const RecordPos:integer; const DontVersion:boolean);

      procedure IncTransactionLevel;
      procedure DecTransactionLevel;
      property DataRecordSize:longint read FDataRecordSize;
      property Records :TkbmList read FRecords;
      
      property RecordID : LongInt read FRecordID write SetRecordID;
      property UniqueRecordID: LongInt read FUniqueRecordID write SetUniqueRecordID;
      property DeletedCount: LongInt read FDeletedCount write SetDeletedCount;

      property AttachMaxCount:integer read GetAttachMaxCount write SetAttachMaxCount;
      property AttachCount:integer read GetAttachCount;
      property Standalone:boolean read GetStandalone write SetStandalone;
      property AutoIncMin:longint read GetAutoIncMin write SetAutoIncMin;
      property AutoIncMax:longint read GetAutoIncMax write SetAutoIncMax;
      property Performance:TkbmPerformance read GetPerformance write SetPerformance;
      property VersioningMode:TkbmVersioningMode read GetVersioningMode write SetVersioningMode;
      property EnableVersioning:boolean read GetEnableVersioning write SetEnableVersioning;
      property Capacity:longint read GetCapacity write SetCapacity;
      property IsDataModified:boolean read GetIsDataModified write SetIsDataModified;
      property TransactionLevel:integer read GetTransactionLevel;
      property FieldModified[i:integer]:boolean read GetModifiedFlag write SetModifiedFlag;
      property LanguageID:integer read GetLanguageID write SetLanguageID;
      property SortID:integer read GetSortID write SetSortID;
      property SubLanguageID:integer read GetSubLanguageID write SetSubLanguageID;
      property LocaleID:TkbmLocaleID read GetLocaleID write SetLocaleID;
  end;

  TkbmCustomMemTable = class(TDataSet)
  protected
        FTableID:                               integer;
        FCommon:                                TkbmCommon;
        FIndexes:                               TkbmIndexes;

        FDefaultFormat:                         TkbmCustomStreamFormat;
        FCommaTextFormat:                       TkbmCustomStreamFormat;
        FPersistentFormat:                      TkbmCustomStreamFormat;
        FFormFormat:                            TkbmCustomStreamFormat;
        FAllDataFormat:                         TkbmCustomStreamFormat;

        FFilterRecord:                          PkbmRecord;
        FKeyRecord:                             PkbmRecord;
        FKeyBuffers:                            array [kbmkbMin..kbmkbMax] of PkbmRecord;
        FIgnoreReadOnly:                        boolean;
        FIgnoreAutoIncPopulation:               boolean;

        FIndexDefs:                             TIndexDefs;
        FCurIndex:                              TkbmIndex;
        FSortIndex:                             TkbmIndex;
        FEnableIndexes:                         boolean;
        FAutoAddIndexes:                        boolean;

{$IFNDEF LEVEL3}
        FDesignActivation:                      boolean;
        FInterceptActive:                       boolean;
{$ENDIF}

        FAutoUpdateFieldVariables:              boolean;

        FState:                                 TkbmState;

{$IFDEF LEVEL5}
        FFilterParser:                          TExprParser;
{$ENDIF}
        FFilterOptions:                         TFilterOptions;

        FMasterLink:                            TMasterDataLink;
        FMasterLinkUsed:                        boolean;
        FIsOpen:                                Boolean;
        FRecNo:                                 longint;
        FReposRecNo:                            longint;
        FInsertRecNo:                           longint;

        FBeforeCloseCalled:                     boolean;
        FDuringAfterOpen:                       boolean;

        FLoadLimit:                             longint;
        FLoadCount:                             longint;
        FLoadedCompletely:                      boolean;

        FSaveLimit:                             longint;
        FSaveCount:                             longint;
        FSavedCompletely:                       boolean;

        FDeltaHandler:                          TkbmCustomDeltaHandler;

        FOverrideActiveRecordBuffer:            PkbmRecord;
        FStatusFilter:                          TUpdateStatusSet;

        FAttachedTo:                            TkbmCustomMemTable;
        FAttachedAutoRefresh:                   boolean;

        FAutoIncField:                          TField;

        FRecalcOnFetch:                         boolean;

        FReadOnly:                              boolean;

        FPersistent:                            boolean;
        FPersistentFile:                        TFileName;
        FPersistentSaved:                       boolean;
        FPersistentBackup:                      boolean;
        FPersistentBackupExt:                   string;

        FStoreDataOnForm:                       boolean;
        FTempDataStorage:                       TMemoryStream;

        FDummyStr:                              string;

        FMasterIndexList:                       TkbmFieldList;
        FDetailIndexList:                       TkbmFieldList;
        FIndexList:                             TkbmFieldList;
        FRecalcOnIndex:                         boolean;
        FIndexFieldNames:                       string;
        FDetailFieldNames:                      string;
        FIndexName:                             string;
        FSortFieldNames:                        string;
        FAutoReposition:                        boolean;
        FRangeIgnoreNullKeyValues:              boolean;

        FSortedOn:                              string;

        FRangeActive:                           boolean;
        FSortOptions:                           TkbmMemTableCompareOptions;

        FOnCompareFields:                       TkbmOnCompareFields;

        FOnSave:                                TkbmOnSave;
        FOnLoad:                                TkbmOnLoad;

        FProgressFlags:                         TkbmProgressCodes;
        FOnProgress:                            TkbmOnProgress;

        FOnLoadRecord:                          TkbmOnLoadRecord;
        FOnSaveRecord:                          TkbmOnSaveRecord;
        FOnLoadField:                           TkbmOnLoadField;
        FOnSaveField:                           TkbmOnSaveField;

        FOnCompressBlobStream:                  TkbmOnCompress;
        FOnDecompressBlobStream:                TkbmOnDecompress;

        FOnSetupField:                          TkbmOnSetupField;
        FOnSetupFieldProperties:                TkbmOnSetupFieldProperties;
        FOnCompressField:                       TkbmOnCompressField;
        FOnDecompressField:                     TkbmOnDecompressField;

        FBeforeInsert:                          TDatasetNotifyEvent;

        FOnFilterIndex:                         TkbmOnFilterIndex;

        // Performance optimized.
        FIsFiltered:                            boolean;

        procedure _InternalBeforeInsert(DataSet:TDataSet);

        function GetActiveRecord:PkbmRecord;

        procedure _InternalFirst; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure _InternalLast; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        function  _InternalNext(ForceUseFilter:boolean):boolean; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        function  _InternalPrior(ForceUseFilter:boolean):boolean; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};

        procedure SetMasterFields(const Value: string);
        procedure SetDetailFields(const Value: string);
        function GetMasterFields: string;
        procedure SetDataSource(Value: TDataSource);

        procedure SetIsFiltered; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        property IsFiltered:boolean read FIsFiltered;
{$IFDEF LEVEL5}
        procedure BuildFilter(var AFilterParser:TExprParser; AFilter:string; AFilterOptions:TFilterOptions);
        function ParseFilter(FilterExpr:TExprParser):variant;
        procedure FreeFilter(var AFilterParser:TExprParser);
{$ENDIF}
        procedure DrawAutoInc;
        procedure PostAutoInc;

        function GetVersion:string;
        procedure SetIndexFieldNames(FieldNames:string);
        procedure SetIndexName(IndexName:string);
        procedure SetIndexDefs(Value:TIndexDefs);
        procedure SetCommaText(AString: String);
        function GetCommaText: String;
        function GetIndexByName(IndexName:string):TkbmIndex;
        function GetIndexField(Index:integer):TField;
        procedure SetIndexField(Index:integer; Value:TField);
        procedure SetAttachedTo(Value:TkbmCustomMemTable);
        procedure SetRecordTag(Value:longint);
        function GetRecordTag:longint;
        function GetIsVersioning:boolean;
        procedure SetStatusFilter(const Value:TUpdateStatusSet);
        procedure SetDeltaHandler(AHandler:TkbmCustomDeltaHandler);
        procedure SetAllData(AVariant:variant);
        function GetAllData:variant;
        function GetAutoIncValue:longint;
        function GetAutoIncMin:longint;
        procedure SetAutoIncMinValue(AValue:longint);
        procedure SetAutoUpdateFieldVariables(AValue:boolean);
        function GetPerformance:TkbmPerformance;
        procedure SetPerformance(AValue:TkbmPerformance);
        function GetVersioningMode:TkbmVersioningMode;
        procedure SetVersioningMode(AValue:TkbmVersioningMode);
        function GetEnableVersioning:boolean;
        procedure SetEnableVersioning(AValue:boolean);
        function GetStandalone:boolean;
        procedure SetStandalone(AValue:boolean);
        function GetCapacity:longint;
        procedure SetCapacity(AValue:longint);
        function GetIsDataModified:boolean;
        procedure SetIsDataModified(AValue:boolean);
        function GetAttachMaxCount:integer;
        procedure SetAttachMaxCount(AValue:integer);
        function GetAttachCount:integer;

        procedure SwitchToIndex(Index:TkbmIndex);
        function GetModifiedFlags(i:integer):boolean;
        function GetIndexes:TkbmIndexes;
        function GetTransactionLevel:integer;
        function GetDeletedRecordsCount:integer;

        function GetLanguageID:integer;
        procedure SetLanguageID(Value:integer);
        function GetSortID:integer;
        procedure SetSortID(Value:integer);
        function GetSubLanguageID:integer;
        procedure SetSubLanguageID(Value:integer);
        function GetLocaleID:TkbmLocaleID;
        procedure SetLocaleID(Value:TkbmLocaleID);
{$IFDEF LEVEL4}
        procedure SetActive(Value:boolean); override;
{$ENDIF}

        procedure DoCheckInActive;

        // Protected stuff which needs to be supported in the TDataset ancestor to make things work.
        procedure InternalOpen; override;
        procedure InternalClose; override;
        procedure InternalFirst;override;
        procedure InternalLast;override;
        procedure InternalAddRecord(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}Pointer{$ENDIF}; Append: Boolean); override;
        procedure InternalDelete; override;
        procedure InternalInitRecord(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}); override;
        procedure InternalPost; override;
        procedure InternalCancel; override;
        procedure InternalEdit; override;
        {$IFNDEF LEVEL3}
        procedure InternalInsert; override;
        {$ENDIF}
        procedure InternalInitFieldDefs; override;
        procedure InternalSetToRecord(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}); override;
        procedure CheckActive; override;
        procedure CheckInactive; override;
        procedure DoBeforeClose; override;
        procedure DoBeforeOpen; override;
        procedure DoAfterOpen; override;
        procedure DoAfterPost; override;
        procedure DoAfterDelete; override;
        procedure DoOnNewRecord; override;
        procedure DoBeforePost; override;
        procedure DoOnFilterRecord(ADataset:TDataset; var AFiltered:boolean); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};

        function IsCursorOpen: Boolean; override;
        function GetCanModify: Boolean; override;
        function GetRecordSize: Word;override;
        function GetRecordCount: integer;override;
        function AllocRecordBuffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}; override;
        procedure FreeRecordBuffer(var Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}); override;
        procedure CloseBlob(Field: TField); override;
        procedure SetFieldData(Field: TField; Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}Pointer{$ENDIF}); override;
{$IFDEF LEVEL5}
 {$IFNDEF LEVEL10}
  {$IFNDEF DOTNET}
        procedure DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean); override;
  {$ELSE}
        procedure DataConvert(Field: TField; Source, Dest: TValueBuffer; ToNative: Boolean); override;
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFNDEF LEVEL4}
        function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
{$ENDIF}
        function GetRecord(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
        function FindRecord(Restart, GoForward: Boolean): Boolean; override;
        function GetRecNo: integer;override;
        procedure SetRecNo(Value: integer);override;
        function GetIsIndexField(Field: TField): Boolean; override;
        function GetBookmarkFlag(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}): TBookmarkFlag; override;
        procedure SetBookmarkFlag(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}; Value: TBookmarkFlag); override;
        procedure GetBookmarkData(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}; {$IFDEF DOTNET}var Bookmark:TBookmark{$ELSE}Data:Pointer{$ENDIF}); override;
        procedure SetBookmarkData(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF}; {$IFDEF DOTNET}const Bookmark:TBookmark{$ELSE}Data:Pointer{$ENDIF}); override;
        procedure InternalGotoBookmark({$IFDEF DOTNET}const Bookmark:TBookmark{$ELSE}Bookmark:Pointer{$ENDIF}); override;
        procedure InternalHandleException; override;
        function GetDataSource: TDataSource; override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure SetFiltered(Value:boolean); override;
        procedure SetFilterText(const Value:string); override;
        procedure SetLoadedCompletely(Value:boolean);
        procedure SetTableState(AValue:TkbmState);
        procedure CreateFieldDefs;
        procedure SetOnFilterRecord(const Value: TFilterRecordEvent); override;

{$IFDEF LEVEL5}
        procedure DataEvent(Event: TDataEvent; Info:{$IFDEF DOTNET}TObject{$ELSE}Longint{$ENDIF}); override;
{$ENDIF}
        procedure Loaded; override;

        // Internal lowlevel routines.
        procedure DefineProperties(Filer: TFiler); override;
        procedure ReadData(Stream:TStream);
        procedure WriteData(Stream:TStream);
        procedure InternalEmptyTable;

        procedure PopulateField(ARecord:PkbmRecord;Field:TField;AValue:Variant);
        procedure PopulateRecord(ARecord:PkbmRecord;Fields:string;Values:variant);
        procedure PopulateVarLength(ARecord:PkbmRecord;Field:TField;const Buffer; Size:Integer);
{$IFDEF DOTNET}
        function InternalBookmarkValid(Bookmark: IntPtr):boolean;
{$ELSE}
        function InternalBookmarkValid(Bookmark: Pointer):boolean;
{$ENDIF}
        procedure PrepareKeyRecord(KeyRecordType:integer; Clear:boolean);
        function FilterRange(ARecord:PkbmRecord): Boolean;
        function FilterMasterDetail(ARecord:PkbmRecord):boolean;
{$IFDEF LEVEL5}
        function FilterExpression(ARecord:PkbmRecord; AFilterParser:TExprParser):boolean;
{$ENDIF}
        procedure MasterChanged(Sender: TObject); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure MasterDisabled(Sender: TObject); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};

        // Internal medium level routines.
        procedure InternalSaveToStreamViaFormat(AStream:TStream; AFormat:TkbmCustomStreamFormat); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure InternalLoadFromStreamViaFormat(AStream:TStream; AFormat:TkbmCustomStreamFormat); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};

        function UpdateRecords(Source,Destination:TDataSet; KeyFields:string; Count:longint; Flags:TkbmMemTableUpdateFlags):longint;
        function LocateRecord(const KeyFields:string; const KeyValues:Variant; Options:TLocateOptions):integer;

        function CheckAutoInc:boolean;

{$IFDEF DOTNET}
        procedure SetBlockReadSize(Value: Integer); override;
{$ENDIF}
  public
        // Helper functions.
        function  __CalcFieldsSize:integer;
        procedure __ClearBuffers;
        procedure __ClearCalcFields(Buffer:{$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF});
        procedure __GetCalcFields(Buffer:{$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF});
        procedure __SetBlockReadSize(Value: Integer);
        function  __SetTempState(const Value: TDataSetState):TDataSetState;
        procedure __RestoreState(const Value: TDataSetState);


        // Public stuff which needs to be supported in the TDataset ancestor to make things work.
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        function BookmarkValid({$IFDEF DOTNET}const {$ENDIF}Bookmark: TBookmark): boolean; override;
        function CompareBookmarks({$IFDEF DOTNET}const {$ENDIF}Bookmark1, Bookmark2: TBookmark):Integer; override;
{$IFDEF LEVEL4}
        function GetFieldData(Field: TField; Buffer:{$IFDEF DOTNET}TValueBuffer{$ELSE}Pointer{$ENDIF}): Boolean; override;
 {$IFNDEF DOTNET}
        procedure SetBlockReadSize(Value: Integer); override;
 {$ENDIF}
        function UpdateStatus: TUpdateStatus; override;
{$ENDIF}

        function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
        function IsSequenced:Boolean; override;

        procedure SavePersistent;
        procedure LoadPersistent;

        // Public low level routines.
        procedure BuildFieldList(Dataset:TDataset; List:TkbmFieldList; const FieldNames: string);
        function FindFieldInList(List:TkbmFieldList; FieldName:String):TField;
        function IsFieldListsEqual(List1,List2:TkbmFieldList):boolean;
        function IsFieldListsBegin(List1,List2:TkbmFieldList):boolean;
        procedure SetFieldListOptions(AList:TkbmFieldList; AOptions:TkbmifoOption; AFieldNames:string);
        procedure ClearModified;
        procedure DestroyIndexes;
        procedure CreateIndexes;
        function FilterRecord(ARecord:PkbmRecord; ForceUseFilter:boolean):Boolean;

        // Public medium level routines.
        function CreateFieldAs(Field:TField):TField;
        function MoveRecord(Source, Destination: Integer): Boolean;
        function MoveCurRecord(Destination:Longint):Boolean;
        function GetVersionFieldData(Field:TField; Version:integer):variant;
        function GetVersionStatus(Version:integer):TUpdateStatus;
        function GetVersionCount:integer;
        function SetVersionFieldData(Field:TField; AVersion:integer; AValue:variant):variant;
        function SetVersionStatus(AVersion:integer; AUpdateStatus:TUpdateStatus):TUpdateStatus;

        procedure ResetAutoInc;
        procedure Progress(Pct:integer; Code:TkbmProgressCode); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        function CopyRecords(Source,Destination:TDataSet; Count:longint; IgnoreErrors:boolean{$IFDEF LEVEL6}; WideStringAsUTF8:boolean{$ENDIF}):longint; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure AssignRecord(Source,Destination:TDataSet);
        procedure Lock; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure Unlock; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure UpdateFieldVariables;

        procedure CopyFieldProperties(Source,Destination:TField);
        procedure CopyFieldsProperties(Source,Destination:TDataSet);

        // Public high level routines.
        function Exists:boolean;
        procedure CreateTable;
        procedure EmptyTable;
        procedure CreateTableAs(Source:TDataSet; CopyOptions:TkbmMemTableCopyTableOptions);
        procedure DeleteTable;
        procedure PackTable;

        function AddIndex(const Name, Fields: string; Options: TIndexOptions):TkbmIndex; {$IFDEF LEVEL5}overload;{$ENDIF}
{$IFDEF LEVEL5}
        function AddIndex(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet):TkbmIndex; overload;
{$ELSE}
        function AddIndex2(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet):TkbmIndex;
{$ENDIF}

        function AddFilteredIndex(const Name, Fields: string; Options: TIndexOptions; Filter:string; FilterOptions:TFilterOptions; FilterFunc:TkbmOnFilterIndex {$ifdef LEVEL5} = nil{$endif}):TkbmIndex; {$IFDEF LEVEL5}overload;{$ENDIF}
{$IFDEF LEVEL5}
        function AddFilteredIndex(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet; Filter:string; FilterOptions:TFilterOptions; FilterFunc:TkbmOnFilterIndex=nil):TkbmIndex; overload;
{$ELSE}
        function AddFilteredIndex2(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet; Filter:string; FilterOptions:TFilterOptions; FilterFunc:TkbmOnFilterIndex):TkbmIndex;
{$ENDIF}

        procedure DeleteIndex(const Name: string);
        procedure UpdateIndexes;
        function IndexFieldCount:Integer;
        procedure StartTransaction; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure Commit; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure Rollback; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
{$IFDEF LEVEL5}
        function  TestFilter(const AFilter:string; AFilterOptions:TFilterOptions):boolean;
{$ENDIF}
        procedure Undo;

        procedure LoadFromFile(const FileName: string);
        procedure LoadFromStream(Stream:TStream);
        procedure LoadFromFileViaFormat(const FileName:string; AFormat:TkbmCustomStreamFormat);
        procedure LoadFromStreamViaFormat(Stream: TStream; AFormat:TkbmCustomStreamFormat);
        procedure SaveToFile(const FileName: string);
        procedure SaveToStream(Stream: TStream);
        procedure SaveToFileViaFormat(const FileName:string; AFormat:TkbmCustomStreamFormat);
        procedure SaveToStreamViaFormat(Stream: TStream; AFormat:TkbmCustomStreamFormat);

        procedure LoadFromDataSet(Source:TDataSet; CopyOptions:TkbmMemTableCopyTableOptions); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure SaveToDataSet(Destination:TDataSet; CopyOptions:TkbmMemTableCopyTableOptions{$IFDEF LEVEL5} = []{$ENDIF}); {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
        procedure UpdateToDataSet(Destination:TDataSet; KeyFields:String; Flags:TkbmMemTableUpdateFlags); {$IFDEF LEVEL5} overload;{$ENDIF} {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
{$IFDEF LEVEL5}
        procedure UpdateToDataSet(Destination:TDataSet; KeyFields:String); overload; {$IFDEF BCB}dynamic{$ELSE}virtual{$ENDIF};
{$ENDIF}

        procedure SortDefault;
        procedure Sort(Options:TkbmMemTableCompareOptions);
        procedure SortOn(const FieldNames:string; Options:TkbmMemTableCompareOptions);
        function Lookup(const KeyFields: string; const KeyValues: Variant; const ResultFields: string): Variant; override;
        function LookupByIndex(const IndexName:string; const KeyValues:Variant;
                               const ResultFields:string; RespFilter:boolean):Variant;
        function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; override;
        procedure SetKey;
        procedure EditKey;
        function GotoNearest:boolean;
        function GotoKey:boolean;
        function FindKey(const KeyValues:array of const): Boolean;
        function FindNearest(const KeyValues:array of const): Boolean;
        procedure ApplyRange;
        procedure CancelRange;
        procedure SetRange(const StartValues, EndValues:array of const);
        procedure SetRangeStart;
        procedure SetRangeEnd;
        procedure EditRangeStart;
        procedure EditRangeEnd;
        procedure CheckPoint;
        function CheckPointRecord(RecordIndex:integer):TUpdateStatus;

{$IFNDEF LEVEL3}
        function GetRows(Rows:Integer; Start:Variant; Fields:Variant):Variant;
{$ENDIF}
        procedure Reset;
        procedure GotoCurrent(DataSet:TkbmCustomMemTable); virtual;

        property OverrideActiveRecordBuffer:PkbmRecord read FOverrideActiveRecordBuffer write FOverrideActiveRecordBuffer;

        property PersistentSaved:boolean read FPersistentSaved write FPersistentSaved stored false;
        property AttachedTo:TkbmCustomMemTable read FAttachedTo write SetAttachedTo;
        property AttachedAutoRefresh:boolean read FAttachedAutoRefresh write FAttachedAutoRefresh;

        property Performance:TkbmPerformance read GetPerformance write SetPerformance             default mtpfFast;

        property Filtered;
        property Filter;
        property CurIndex:TkbmIndex read FCurIndex;
        property IgnoreAutoIncPopulation:boolean read FIgnoreAutoIncPopulation write FIgnoreAutoIncPopulation;
        property AttachMaxCount:integer read GetAttachMaxCount write SetAttachMaxCount;
        property AttachCount:integer read GetAttachCount;
{$IFNDEF LEVEL3}
        property DesignActivation:boolean read FDesignActivation write FDesignActivation;
{$ENDIF}
        property LanguageID:integer read GetLanguageID write SetLanguageID;
        property SortID:integer read GetSortID write SetSortID;
        property SubLanguageID:integer read GetSubLanguageID write SetSubLanguageID;
        property LocaleID:TkbmLocaleID read GetLocaleID write SetLocaleID;
        property Common:TkbmCommon read FCommon;
        property AutoIncValue:longint read GetAutoIncValue;
        property AutoIncMinValue:longint read GetAutoIncMin write SetAutoIncMinValue              default 0;
        property AutoUpdateFieldVariables:boolean read FAutoUpdateFieldVariables write SetAutoUpdateFieldVariables;
        property AllData:variant read GetAllData write SetAllData;
        property StoreDataOnForm:boolean read FStoreDataOnForm write FStoreDataOnForm             default false;
        property CommaText:string read GetCommaText write SetCommaText;
        property Capacity:longint read GetCapacity write SetCapacity;
        property DeletedRecordsCount:integer read GetDeletedRecordsCount;
        property IndexFieldNames:string read FIndexFieldNames write SetIndexFieldNames;
        property IndexName:string read FIndexName write SetIndexName;
        property EnableIndexes:boolean read FEnableIndexes write FEnableIndexes                   default true;
        property AutoAddIndexes:boolean read FAutoAddIndexes write FAutoAddIndexes                default false;
        property AutoReposition:boolean read FAutoReposition write FAutoReposition                default false;
        property SortFields:string read FSortFieldNames write FSortFieldNames;
        property SortOptions:TkbmMemTableCompareOptions read FSortOptions write FSortOptions;
        property ReadOnly:boolean read FReadOnly write FReadOnly                                  default false;
        property Standalone:boolean read GetStandalone write SetStandalone                        default false;
        property IgnoreReadOnly:boolean read FIgnoreReadOnly write FIgnoreReadOnly                default false;
        property RangeActive:boolean read FRangeActive;
        property RangeIgnoreNullKeyValues:boolean read FRangeIgnoreNullKeyValues write FRangeIgnoreNullKeyValues default true;
        property PersistentFile:TFileName read FPersistentFile write FPersistentFile;
        property Persistent:boolean read FPersistent write FPersistent                            default false;
        property PersistentBackup:boolean read FPersistentBackup write FPersistentBackup;
        property PersistentBackupExt:string read FPersistentBackupExt write FPersistentBackupExt;
        property ProgressFlags:TkbmProgressCodes read FProgressFlags write FProgressFlags;
        property LoadLimit:integer read FLoadLimit write FLoadLimit                               default -1;
        property LoadCount:integer read FLoadCount write FLoadCount;
        property LoadedCompletely:boolean read FLoadedCompletely write FLoadedCompletely;
        property SaveLimit:integer read FSaveLimit write FSaveLimit                               default -1;
        property SaveCount:integer read FSaveCount write FSaveCount;
        property SavedCompletely:boolean read FSavedCompletely write FSavedCompletely;
        property RecalcOnFetch:boolean read FRecalcOnFetch write FRecalcOnFetch                   default true;
        property IsFieldModified[i:integer]:boolean read GetModifiedFlags;
        property EnableVersioning:boolean read GetEnableVersioning write SetEnableVersioning      default false;
        property VersioningMode:TkbmVersioningMode read GetVersioningMode write SetVersioningMode default mtvm1SinceCheckPoint;
        property IsVersioning:boolean read GetIsVersioning;
        property StatusFilter:TUpdateStatusSet read FStatusFilter write SetStatusFilter;
        property DeltaHandler:TkbmCustomDeltaHandler read FDeltaHandler write SetDeltaHandler;
        property Indexes:TkbmIndexes read GetIndexes;
        property IndexByName[IndexName:string]:TkbmIndex read GetIndexByName;
        property IndexDefs:TIndexDefs read FIndexDefs write SetIndexDefs;
        property IndexFields[Index:Integer]:TField read GetIndexField write SetIndexField;
        property RecalcOnIndex:boolean read FRecalcOnIndex write FRecalcOnIndex                   default false;
        property FilterOptions:TFilterOptions read FFilterOptions write FFilterOptions;
        property DetailFields: string read FDetailFieldNames write SetDetailFields;
        property MasterFields: string read GetMasterFields write SetMasterFields;
        property MasterSource: TDataSource read GetDataSource write SetDataSource;
        property RecordTag: longint read GetRecordTag write SetRecordTag;
        property Version:string read GetVersion write FDummyStr;
        property IsDataModified:boolean read GetIsDataModified write SetIsDataModified;
        property TransactionLevel:integer read GetTransactionLevel;
        property TableState:TkbmState read FState write FState;
        property DefaultFormat: TkbmCustomStreamFormat read FDefaultFormat write FDefaultFormat;
        property CommaTextFormat:TkbmCustomStreamFormat read FCommaTextFormat write FCommaTextFormat;
        property PersistentFormat:TkbmCustomStreamFormat read FPersistentFormat write FPersistentFormat;
        property FormFormat:TkbmCustomStreamFormat read FFormFormat write FFormFormat;
        property AllDataFormat:TkbmCustomStreamFormat read FAllDataFormat write FAllDataFormat;
        property OnLoadRecord:TkbmOnLoadRecord read FOnLoadRecord write FOnLoadRecord;
        property OnLoadField:TkbmOnLoadField read FOnLoadField write FOnLoadField;
        property OnSaveRecord:TkbmOnSaveRecord read FOnSaveRecord write FOnSaveRecord;
        property OnSaveField:TkbmOnSaveField read FOnSaveField write FOnSaveField;
        property OnCompressBlobStream:TkbmOnCompress read FOnCompressBlobStream write FOnCompressBlobStream;
        property OnDecompressBlobStream:TkbmOnDecompress read FOnDecompressBlobStream write FOnDecompressBlobStream;
        property OnSetupField:TkbmOnSetupField read FOnSetupField write FOnSetupField;
        property OnSetupFieldProperties:TkbmOnSetupFieldProperties read FOnSetupFieldProperties write FOnSetupFieldProperties;
        property OnCompressField:TkbmOnCompressField read FOnCompressField write FOnCompressField;
        property OnDecompressField:TkbmOnDecompressField read FOnDecompressField write FOnDecompressField;
        property OnSave:TkbmOnSave read FOnSave write FOnSave;
        property OnLoad:TkbmOnLoad read FOnLoad write FOnLoad;
        property OnProgress:TkbmOnProgress read FOnProgress write FOnProgress;
        property OnCompareFields:TkbmOnCompareFields read FOnCompareFields write FOnCompareFields;
        property OnFilterIndex:TkbmOnFilterIndex read FOnFilterIndex write FOnFilterIndex;
        property BeforeOpen;
        property AfterOpen;
        property BeforeClose;
        property AfterClose;
        property BeforeInsert:TDatasetNotifyEvent read FBeforeInsert write FBeforeInsert;
        property AfterInsert;
        property BeforeEdit;
        property AfterEdit;
        property BeforePost;
        property AfterPost;
        property BeforeCancel;
        property AfterCancel;
        property BeforeDelete;
        property AfterDelete;
        property BeforeScroll;
        property AfterScroll;
        property OnCalcFields;
        property OnDeleteError;
        property OnEditError;
        property OnFilterRecord;
        property OnNewRecord;
        property OnPostError;
        property Active;
  end;

  TkbmMemTable = class(TkbmCustomMemTable)
  public
        property IgnoreReadOnly;
  published
        property Active;
{$IFNDEF LEVEL3}
        property DesignActivation;
{$ENDIF}
        property AttachedTo;
        property AttachedAutoRefresh;
        property AttachMaxCount;
        property AutoIncMinValue;
        property AutoCalcFields;
        property FieldDefs;
        property Filtered;
        property DeltaHandler;
        property EnableIndexes;
        property AutoAddIndexes;
        property AutoReposition;
        property IndexFieldNames;
        property IndexName;
        property IndexDefs;
        property RecalcOnIndex;
        property RecalcOnFetch;
        property SortFields;
        property SortOptions;
        property ReadOnly;
        property Performance;
        property Standalone;
        property PersistentFile;
        property StoreDataOnForm;
        property Persistent;
        property PersistentBackup;
        property PersistentBackupExt;
        property ProgressFlags;
        property LoadLimit;
        property LoadedCompletely;
        property SaveLimit;
        property SavedCompletely;
        property EnableVersioning;
        property VersioningMode;
        property Filter;
        property FilterOptions;
        property MasterFields;
        property DetailFields;
        property MasterSource;
        property Version;
        property LanguageID;
        property SortID;
        property SubLanguageID;
        property LocaleID;
        property DefaultFormat;
        property CommaTextFormat;
        property PersistentFormat;
        property AllDataFormat;
        property FormFormat;
        property RangeIgnoreNullKeyValues;
        property OnProgress;
        property OnLoadRecord;
        property OnLoadField;
        property OnSaveRecord;
        property OnSaveField;
        property OnCompressBlobStream;
        property OnDecompressBlobStream;
        property OnSetupField;
        property OnSetupFieldProperties;
        property OnCompressField;
        property OnDecompressField;
        property OnSave;
        property OnLoad;
        property OnCompareFields;
        property OnFilterIndex;
        property BeforeOpen;
        property AfterOpen;
        property BeforeClose;
        property AfterClose;
        property BeforeInsert;
        property AfterInsert;
        property BeforeEdit;
        property AfterEdit;
        property BeforePost;
        property AfterPost;
        property BeforeCancel;
        property AfterCancel;
        property BeforeDelete;
        property AfterDelete;
        property BeforeScroll;
        property AfterScroll;
{$IFDEF LEVEL5}
        property BeforeRefresh;
        property AfterRefresh;
{$ENDIF}
        property OnCalcFields;
        property OnDeleteError;
        property OnEditError;
        property OnFilterRecord;
        property OnNewRecord;
        property OnPostError;
  end;

  TkbmBlobStream = class(TMemoryStream)
  private
    FWorkBuffer:PkbmRecord;
    FTableRecord:PkbmRecord;

    FField: TBlobField;
    FDataSet: TkbmCustomMemTable;
    FMode:TBlobStreamMode;
    FFieldNo: Integer;
    FModified: Boolean;

    // Internal work pointers.
{$IFDEF DOTNET}
    FpWorkBufferField:TValueBuffer;
    FpTableRecordField:TValueBuffer;
{$ELSE}
    FpWorkBufferField:PChar;
    FpTableRecordField:PChar;
{$ENDIF}

    FpWorkBufferBlob:PPkbmVarLength;
    FpTableRecordBlob:PPkbmVarLength;

    procedure ReadBlobData;
    procedure WriteBlobData;
  public
    constructor Create(Field: TBlobField; Mode: TBlobStreamMode);
    destructor Destroy; override;
{$IFDEF DOTNET}
    function Write(const Buffer: array of Byte; Offset, Count: Longint): Longint; override;
{$ELSE}
    function Write(const Buffer; Count: Longint): Longint; override;
{$ENDIF}
    procedure Truncate;
  end;

{$ifndef LINUX}
  TkbmThreadDataSet = class(TComponent)
  private
    FDataset:TDataset;
    FLockCount:integer;
    FSemaphore:THandle;
    function GetIsLocked:boolean;
    procedure SetDataset(ds:TDataset);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    function TryLock(TimeOut:DWORD):TDataset;
    function Lock:TDataset;
    procedure Unlock;
    property IsLocked:boolean read GetIsLocked;
  published
    property Dataset:TDataset read FDataset write SetDataset;
  end;
{$endif}

  // Handler which user must override to provide functionality when trying to update deltas on an external database.
  TkbmDeltaHandlerGetValue = procedure(ADeltaHandler:TkbmCustomDeltaHandler; AField:TField; var AValue:variant) of object;

  TkbmCustomDeltaHandler = class(TComponent)
  private
     FOnGetValue:TkbmDeltaHandlerGetValue;
     FDataSet:TkbmCustomMemTable;
     procedure CheckDataSet;
     function GetValues(Index:integer):Variant;
     function GetOrigValues(Index:integer):Variant;
     function GetFieldCount:integer;
     function GetFieldNames(Index:integer):string;
     function GetFields(Index:integer):TField;
     function GetOrigValuesByName(Name:string):Variant;
     function GetValuesByName(Name:string):Variant;
     function GetRecordNo:longint;
     function GetUniqueRecordID:longint;
  protected
     FPRecord,FPOrigRecord:PkbmRecord;

     procedure BeforeRecord; virtual;
     procedure InsertRecord(var Retry:boolean; var State:TUpdateStatus); virtual;
     procedure DeleteRecord(var Retry:boolean; var State:TUpdateStatus); virtual;
     procedure ModifyRecord(var Retry:boolean; var State:TUpdateStatus); virtual;
     procedure UnmodifiedRecord(var Retry:boolean; var State:TUpdateStatus); virtual;
     procedure AfterRecord; virtual;

     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
     procedure Resolve; virtual;
     property DataSet:TkbmCustomMemTable read FDataSet write FDataSet;
     property FieldCount:integer read GetFieldCount;
     property OrigValues[i:integer]:Variant read GetOrigValues;
     property Values[i:integer]:Variant read GetValues;
     property OrigValuesByName[Name:string]:Variant read GetOrigValuesByName;
     property ValuesByName[Name:string]:Variant read GetValuesByName;
     property FieldNames[i:integer]:string read GetFieldNames;
     property Fields[i:integer]:TField read GetFields;
     property RecNo:longint read GetRecordNo;
     property UniqueRecID:longint read GetUniqueRecordID;
  published
     property OnGetValue:TkbmDeltaHandlerGetValue read FOnGetValue write FOnGetValue;
  end;

{$IFNDEF LEVEL6}
  PPWideChar=^PWideChar;
{$ENDIF}

  function StreamToVariant(stream:TStream):variant;
  procedure VariantToStream(AVariant:variant; stream:TStream);

{$IFDEF DOTNET}
  function CompareFields(const KeyField,AField:TValueBuffer; const FieldType: TFieldType; const LocaleID:TkbmLocaleID; const IndexFieldOptions:TkbmifoOptions; var FullCompare:boolean):Integer;
{$ELSE}
  function CompareFields(const KeyField,AField:pointer; const FieldType: TFieldType; const LocaleID:TkbmLocaleID; const IndexFieldOptions:TkbmifoOptions; var FullCompare:boolean):Integer;
{$ENDIF}

  function IndexOptions2CompareOptions(AOptions:TIndexOptions):TkbmMemTableCompareOptions;
  function CompareOptions2IndexOptions(AOptions:TkbmMemTableCompareOptions):TIndexOptions;

const
  // All supported field types.
  kbmSupportedFieldTypes:TkbmFieldTypes=[ftString,ftSmallint,ftInteger,ftWord,ftBoolean,ftFloat
                                        ,ftCurrency,ftDate,ftTime,ftDateTime,ftAutoInc,ftBCD
{$IFDEF LEVEL6}
                                        ,ftFmtBCD,ftTimeStamp
{$ENDIF}
                                        ,ftBlob,ftMemo,ftGraphic,ftFmtMemo,ftParadoxOle,ftDBaseOle
                                        ,ftTypedBinary,ftBytes,ftVarBytes
{$IFNDEF LEVEL3}
                                        ,ftFixedChar,ftWideString,ftLargeInt,ftADT,ftArray
{$ENDIF}
{$IFDEF LEVEL5}
                                        ,ftOraBlob,ftOraClob,ftGUID
{$ENDIF}
{$IFDEF LEVEL6}
                                        ,ftTimeStamp,ftFmtBCD
{$ENDIF}
{$IFDEF LEVEL10}
                                        ,ftFixedWideChar,ftWideMemo,ftOraTimeStamp,ftOraInterval
{$ENDIF}
                                        ];

  // All field types which should be treated as strings during save and load.
  kbmStringTypes:TkbmFieldTypes=[ftString,ftMemo,ftFmtMemo
{$IFNDEF LEVEL3}
                                 ,ftWideString,ftFixedChar
{$ENDIF}
{$IFDEF LEVEL5}
                                 ,ftOraClob,ftGuid
{$ENDIF}
{$IFDEF LEVEL10}
                                 ,ftFixedWideChar,ftWideMemo,ftOraInterval
{$ENDIF}
                                ];
  // All field types which should be treated as binary types during save and load.
  kbmBinaryTypes:TkbmFieldTypes=[ftBlob,ftMemo,ftGraphic,ftFmtMemo,ftParadoxOle,ftDBaseOle,
                                 ftTypedBinary,ftVarBytes,ftBytes
{$IFDEF LEVEL5}
                                 ,ftOraBlob,ftOraClob
{$ENDIF}
                                 ];

  // All field types which should be treated as blobs.
  kbmBlobTypes:TkbmFieldTypes=[ftBlob,ftMemo,ftGraphic,ftFmtMemo,ftParadoxOle,ftDBaseOle,ftTypedBinary
{$IFDEF LEVEL5}
                               ,ftOraBlob,ftOraClob
{$ENDIF}
{$IFDEF LEVEL10}
                               ,ftWideMemo
{$ENDIF}
                              ];

  // All non blob field types.
  kbmNonBlobTypes:TkbmFieldTypes=[ftString,ftSmallint,ftInteger,ftWord,ftBoolean
                                 ,ftFloat,ftCurrency,ftDate,ftTime,ftDateTime
                                 ,ftAutoInc,ftBCD
{$IFDEF LEVEL6}
                                 ,ftFmtBCD,ftTimeStamp
{$ENDIF}
                                 ,ftBytes,ftVarBytes
{$IFDEF LEVEL5}
                                 ,ftGUID
{$ENDIF}
{$IFNDEF LEVEL3}
                                 ,ftWideString,ftFixedChar,ftLargeInt,ftADT,ftArray
{$ENDIF}
{$IFDEF LEVEL10}
                                 ,ftFixedWideChar,ftOraTimeStamp,ftOraInterval
{$ENDIF}
                                 ];

  // Field types which should be stored as a variable chunk of memory.
  // Blobs are automatically treated as variable length datatypes.
  kbmVarLengthNonBlobTypes:TkbmFieldTypes=[ftString,ftBytes,ftVarBytes
{$IFNDEF LEVEL3}
                                    ,ftWideString,ftFixedChar
{$ENDIF}
                                    ];

{$IFDEF DOTNET}
  NullVarLength=nil;
{$ELSE}
  NullVarLength=PkbmVarLength(0);
{$ENDIF}

{KBMDEL
  mtifoDescending=$01;
  mtifoCaseInsensitive=$02;
  mtifoPartial=$04;
  mtifoIgnoreNull=$08;
  mtifoIgnoreLocale=$10;
}

{$IFDEF LEVEL3}
  FieldTypeNames: array[TFieldType] of string = (
    'Unknown', 'String', 'SmallInt', 'Integer', 'Word', 'Boolean', 'Float',
    'Currency', 'BCD', 'Date', 'Time', 'DateTime', 'Bytes', 'VarBytes',
    'AutoInc', 'Blob', 'Memo', 'Graphic', 'FmtMemo', 'ParadoxOle',
    'dBaseOle', 'TypedBinary', 'Cursor');
{$ENDIF}

  FieldKindNames: array[0..4] of string = (
    'Data', 'Calculated', 'Lookup', 'InternalCalc', 'Aggregate');

{$IFDEF LEVEL3}
procedure Register;
{$ENDIF}

implementation

uses
  TypInfo, IniFiles,

{$IFDEF WIN32}
  Forms,
{$ENDIF}

{$IFDEF USE_FAST_MOVE}
  kbmMove,
{$ENDIF}

{$include kbmMemRes.inc}
  DBConsts;

{$IFDEF LEVEL5}
const
  // Field mappings needed for filtering. (What field type should be compared with what internal type).
  FldTypeMap: TFieldMap = (
    ord(ftUnknown),     // ftUnknown
    ord(ftString),      // ftString
    ord(ftSmallInt),    // ftSmallInt
    ord(ftInteger),     // ftInteger
    ord(ftWord),        // ftWord
    ord(ftBoolean),     // ftBoolean
    ord(ftFloat),       // ftFloat
    ord(ftFloat),       // ftCurrency
    ord(ftBCD),         // ftBCD
    ord(ftDate),        // ftDate
    ord(ftTime),        // ftTime
    ord(ftDateTime),    // ftDateTime
    ord(ftBytes),       // ftBytes
    ord(ftVarBytes),    // ftVarBytes
    ord(ftInteger),     // ftAutoInc
    ord(ftBlob),        // fBlob
    ord(ftBlob),        // ftMemo
    ord(ftBlob),        // ftGraphic
    ord(ftBlob),        // ftFmtMemo
    ord(ftBlob),        // ftParadoxOle
    ord(ftBlob),        // ftDBaseOle
    ord(ftBlob),        // ftTypedBinary
    ord(ftUnknown),     // ftCursor
    ord(ftString),      // ftFixedChar
    ord(ftWideString),  // ftWideString
    ord(ftLargeInt),    // ftLargeInt
    ord(ftADT),         // ftADT
    ord(ftArray),       // ftArray
    ord(ftUnknown),     // ftReference
    ord(ftUnknown),     // ftDataset
    ord(ftBlob),        // ftOraBlob
    ord(ftBlob),        // ftOraClob
    ord(ftUnknown),     // ftVariant
    ord(ftUnknown),     // ftInterface
    ord(ftUnknown),     // ftIDispatch
    ord(ftGUID)         // ftGUID
 {$IFDEF LEVEL6}
    ,ord(ftTimeStamp),  // ftTimeStamp
    ord(ftFmtBCD)       // ftFmtBCD
 {$ENDIF}
 {$IFDEF LEVEL10}
    ,ord(ftWideString), // ftFixedWideChar
    ord(ftWideString),  // ftWideMemo
    ord(ftTimeStamp),   // ftOraTimeStamp
    ord(ftString)       // ftOraInterval)
 {$ENDIF}
    );
{$ENDIF}

// -----------------------------------------------------------------------------------
// General procedures.
// -----------------------------------------------------------------------------------

{$IFDEF DOTNET}
procedure FillChar (var Buffer:IntPtr;Size:Int32;Value:Byte);
   var i:integer;
begin
   for i := 0 to Size -1 do
      Marshal.WriteByte(Buffer,i,Value);
end;

function GetInt16(const Buffer:IntPtr; var Value:smallint):IntPtr;
begin
     Value:=smallint(Marshal.ReadByte(Buffer,0))+
            (smallint(Marshal.ReadByte(Buffer,1)) shl 8);
     Result:=IntPtr(Integer(Buffer)+2);
end;

function PutInt16(const Buffer:IntPtr; const Value:smallint):IntPtr;
begin
     Marshal.WriteByte(Buffer,0,Value and $FF);
     Marshal.WriteByte(Buffer,1,(Value shr 8) and $FF);
     Result:=IntPtr(Integer(Buffer)+2);
end;

function GetInt32(const Buffer:IntPtr; var Value:integer):IntPtr;
begin
     Value:=integer(Marshal.ReadByte(Buffer,0))+
            (integer(Marshal.ReadByte(Buffer,1)) shl 8) +
            (integer(Marshal.ReadByte(Buffer,2)) shl 16) +
            (integer(Marshal.ReadByte(Buffer,3)) shl 24);
     Result:=IntPtr(Integer(Buffer)+4);
end;

function PutInt32(const Buffer:IntPtr; const Value:integer):IntPtr;
begin
     Marshal.WriteByte(Buffer,0,Value and $FF);
     Marshal.WriteByte(Buffer,1,(Value shr 8) and $FF);
     Marshal.WriteByte(Buffer,2,(Value shr 16) and $FF);
     Marshal.WriteByte(Buffer,3,(Value shr 24) and $FF);
     Result:=IntPtr(Integer(Buffer)+4);
end;

function GetLongint(const Buffer:IntPtr; var Value:longint):IntPtr;
begin
     Value:=longint(Marshal.ReadByte(Buffer,0))+
            (longint(Marshal.ReadByte(Buffer,1)) shl 8) +
            (longint(Marshal.ReadByte(Buffer,2)) shl 16) +
            (longint(Marshal.ReadByte(Buffer,3)) shl 24);
     Result:=IntPtr(Integer(Buffer)+4);
end;

function PutLongint(const Buffer:IntPtr; const Value:longint):IntPtr;
begin
     Marshal.WriteByte(Buffer,0,Value and $FF);
     Marshal.WriteByte(Buffer,1,(Value shr 8) and $FF);
     Marshal.WriteByte(Buffer,2,(Value shr 16) and $FF);
     Marshal.WriteByte(Buffer,3,(Value shr 24) and $FF);
     Result:=IntPtr(Integer(Buffer)+4);
end;

function PutInt64(const Buffer:IntPtr; const Value:int64):IntPtr;
begin
     Marshal.WriteByte(Buffer,0,Value and $FF);
     Marshal.WriteByte(Buffer,1,(Value shr 8) and $FF);
     Marshal.WriteByte(Buffer,2,(Value shr 16) and $FF);
     Marshal.WriteByte(Buffer,3,(Value shr 24) and $FF);
     Marshal.WriteByte(Buffer,4,(Value shr 32) and $FF);
     Marshal.WriteByte(Buffer,5,(Value shr 40) and $FF);
     Marshal.WriteByte(Buffer,6,(Value shr 48) and $FF);
     Marshal.WriteByte(Buffer,7,(Value shr 56) and $FF);
     Result:=IntPtr(Integer(Buffer)+8);
end;

function GetInt64(const Buffer:IntPtr; var Value:int64):IntPtr;
begin
     Value:=Int64(Marshal.ReadByte(Buffer,0))+
            (Int64(Marshal.ReadByte(Buffer,1)) shl 8) +
            (Int64(Marshal.ReadByte(Buffer,2)) shl 16) +
            (Int64(Marshal.ReadByte(Buffer,3)) shl 24) +
            (Int64(Marshal.ReadByte(Buffer,4)) shl 32) +
            (Int64(Marshal.ReadByte(Buffer,5)) shl 40) +
            (Int64(Marshal.ReadByte(Buffer,6)) shl 48) +
            (Int64(Marshal.ReadByte(Buffer,7)) shl 56);
     Result:=IntPtr(Integer(Buffer)+8);
end;

{
procedure MoveBuffer (Source,Dest:IntPtr;Size:Integer);
  var
     b:TBytes;
begin
   setlength (b,Size);
   try
     marshal.Copy(Source,b,0,Size);
     marshal.Copy(b,0,Dest,Size);
   finally
     setlength (b,0);
   end;
end;
}

{$ELSE}
function GetInt16(const Buffer:PChar; var Value:smallint):PChar;
begin
     Result:=Buffer;
     Value:=byte(Result[0])+
            (byte(Result[1]) shl 8);
     inc(Result,2);
end;

function PutInt16(const Buffer:PChar; const Value:smallint):PChar;
begin
     Result:=Buffer;
     Result^:=Char(Value and $FF); inc(Result);
     Result^:=Char((Value shr 8) and $FF); inc(Result);
end;

function GetInt32(const Buffer:PChar; var Value:integer):PChar;
begin
     Result:=Buffer;
     Value:=integer(byte(Result[0]))+
            (integer(byte(Result[1])) shl 8) +
            (integer(byte(Result[2])) shl 16) +
            (integer(byte(Result[3])) shl 24);
     inc(Result,4);
end;

function PutInt32(const Buffer:PChar; const Value:integer):PChar;
begin
     Result:=Buffer;
     Result^:=Char(Value and $FF); inc(Result);
     Result^:=Char((Value shr 8) and $FF); inc(Result);
     Result^:=Char((Value shr 16) and $FF); inc(Result);
     Result^:=Char((Value shr 24) and $FF); inc(Result);
end;

function GetLongInt(const Buffer:PChar; var Value:longint):PChar;
begin
     Result:=Buffer;
     Value:=longint(byte(Result[0]))+
            (longint(byte(Result[1])) shl 8) +
            (longint(byte(Result[2])) shl 16) +
            (longint(byte(Result[3])) shl 24);
     inc(Result,4);
end;

function PutLongInt(const Buffer:PChar; const Value:longint):PChar;
begin
     Result:=Buffer;
     Result^:=Char(Value and $FF); inc(Result);
     Result^:=Char((Value shr 8) and $FF); inc(Result);
     Result^:=Char((Value shr 16) and $FF); inc(Result);
     Result^:=Char((Value shr 24) and $FF); inc(Result);
end;

 {$IFNDEF LEVEL3}
function GetInt64(Buffer:PChar; var Value:int64):PChar;
begin
     Result:=Buffer;
     Value:=byte(Result[0])+
            (Int64(byte(Result[1])) shl 8) +
            (Int64(byte(Result[2])) shl 16) +
            (Int64(byte(Result[3])) shl 24) +
            (Int64(byte(Result[4])) shl 32) +
            (Int64(byte(Result[5])) shl 40) +
            (Int64(byte(Result[6])) shl 48) +
            (Int64(byte(Result[7])) shl 56);
     inc(Result,8);
end;

function PutInt64(const Buffer:PChar; const Value:int64):PChar;
begin
     Result:=Buffer;
     Result^:=Char(Value and $FF); inc(Result);
     Result^:=Char((Value shr 8) and $FF); inc(Result);
     Result^:=Char((Value shr 16) and $FF); inc(Result);
     Result^:=Char((Value shr 24) and $FF); inc(Result);
     Result^:=Char((Value shr 32) and $FF); inc(Result);
     Result^:=Char((Value shr 40) and $FF); inc(Result);
     Result^:=Char((Value shr 48) and $FF); inc(Result);
     Result^:=Char((Value shr 56) and $FF); inc(Result);
end;
 {$ENDIF}

{$ENDIF}


// Allocate a varlength.
function AllocVarLength(Size:longint):PkbmVarLength;
begin
{$IFDEF DOTNET}
     Result := Marshal.AllocHGlobal(Size+4);
     FillChar(Result,Size+4,0);
{$ELSE}
     GetMem(Result,Size+4);
     FillChar(Result^,Size+4,0);
{$ENDIF}
     PutInt32(Result,Size);
end;

// Get pointer to varlength data.
{$IFDEF DOTNET}
function GetVarLengthData(AVarLength:PkbmVarLength):IntPtr;
begin
     Result:=IntPtr(integer(AVarlength)+4);
end;
{$ELSE}
function GetVarLengthData(AVarLength:PkbmVarLength):PChar;
begin
     Result:=AVarLength+4;
end;
{$ENDIF}

// Get size of varlength data.
function GetVarLengthSize(AVarLength:PkbmVarLength):longint;
begin
     GetInt32(AVarLength,Result);
end;

// Allocate a varlength and populate it.
{$IFDEF DOTNET}
function AllocVarLengthAs(const Source:IntPtr; Size:integer):PkbmVarLength;
begin
     Result:=AllocVarLength(Size);
     CopyBuffer (Source,GetVarLengthData(Result),Size);
end;

{$ELSE}
function AllocVarLengthAs(const Source:PChar; Size:longint):PkbmVarLength;
begin
     Result:=AllocVarLength(Size);
 {$IFNDEF USE_FAST_MOVE}
     move(Source^,GetVarLengthData(Result)^,Size);
 {$ELSE}
     FastMove(Source^,GetVarLengthData(Result)^,Size);
 {$ENDIF}
end;
{$ENDIF}

// Duplicate varlength.
function CopyVarLength(AVarLength:PkbmVarLength):PkbmVarLength;
var
   sz:longint;
begin
     sz:=GetVarLengthSize(AVarLength);
     Result:=AllocVarLength(sz);
{$IFDEF DOTNET}
     CopyBuffer (GetVarLengthData(AVarLength),GetVarLengthData(Result),sz);
{$ELSE}
 {$IFNDEF USE_FAST_MOVE}
     Move(GetVarLengthData(AVarLength)^,GetVarLengthData(Result)^,sz);
 {$ELSE}
     FastMove(GetVarLengthData(AVarLength)^,GetVarLengthData(Result)^,sz);
 {$ENDIF}
{$ENDIF}
end;

{$IFDEF DEBUG}
// Dump varlength.
procedure DumpVarLength(AVarLength:PkbmVarLength);
var
   s:string;
   i:integer;
   sz:integer;
   p:PChar;
begin
     s:='VarLength '+inttohex(longint(AVarLength),8);
     OutputDebugString(PChar(s));
     s:=inttostr(byte(AVarLength[0]))+inttostr(byte(AVarLength[1]))+
        inttostr(byte(AVarLength[2]))+inttostr(byte(AVarLength[3]));
     s:='Size data='+s;
     OutputDebugString(PChar(s));
     sz:=GetVarLengthSize(AVarLength);
     s:=' Size='+inttostr(sz);
     OutputDebugString(PChar(s));
     p:=GetVarLengthData(AVarLength);
     s:='';
     for i:=0 to sz-1 do
         s:=s+p[i];
     s:=' Data='+s;
     OutputDebugString(PChar(s));
end;
{$ENDIF}

// Free a varlength.
procedure FreeVarLength(AVarLength:PkbmVarLength);
begin
{$IFDEF DOTNET}
     if (AVarLength <> nil) then Marshal.FreeHGlobal(AVarLength);
{$ELSE}
     if (AVarLength <> nil) then FreeMem(AVarLength);
{$ENDIF}
end;

{$IFDEF LEVEL4}

// Extract WideString from a buffer.
 {$IFDEF DOTNET}
function WideStringFromBuffer(ABuffer:TValueBuffer):WideString;
 {$ELSE}
function WideStringFromBuffer(ABuffer:pointer):WideString;
 {$ENDIF}
var
   sz:integer;
 {$IFDEF DOTNET}
   b:TBytes;
 {$ELSE}
   p:PChar;
 {$ENDIF}
begin
     Result:='JENS';
 {$IFDEF DOTNET}
     sz := Marshal.ReadInt32(aBuffer,0);
     setlength (b,sz);
     try
        marshal.Copy(intptr(integer(aBuffer)+sizeof(integer)),b,0,sz);
        Result := WideStringOf(b);
     finally
        setlength (b,0);
     end;
 {$ELSE}
     p:=PChar(ABuffer);
     sz:=PInteger(p)^;
     inc(p,sizeof(integer));
     SetLength(Result,sz div Sizeof(WideChar));
  {$IFNDEF USE_FAST_MOVE}
         Move(p^,Pointer(Result)^,sz);
  {$ELSE}
         FastMove(p^,Pointer(Result)^,sz);
  {$ENDIF}
 {$ENDIF}
end;

// Put WideString into a buffer.
 {$IFDEF DOTNET}
procedure WideStringToBuffer(AWideString:WideString; var ABuffer:TValueBuffer);
 {$ELSE}
procedure WideStringToBuffer(AWideString:WideString; ABuffer:pointer);
 {$ENDIF}
var
   sz:integer;
 {$IFDEF DOTNET}
   B: TBytes;
 {$ELSE}
   p:PChar;
 {$ENDIF}
begin
 {$IFDEF DOTNET}
      B := WideBytesOf (AWideString);
      sz := Length(B);
      try
        Marshal.WriteInt32 (aBuffer,sz);
        Marshal.Copy(B, 0, intptr(integer(ABuffer)+sizeof(integer) ), sz);
      finally
        SetLength(B, 0);
      end;
 {$ELSE}
       sz:=length(AWideString)*sizeof(WideChar);
       p:=PChar(ABuffer);
       PInteger(p)^:=sz;
       inc(p,sizeof(integer));

  {$IFNDEF USE_FAST_MOVE}
       Move(Pointer(AWideString)^,p^,sz);
  {$ELSE}
       FastMove(Pointer(AWideString)^,p^,sz);
  {$ENDIF}
 {$ENDIF}
end;
{$ENDIF} // LEVEL4

// Put contents of a stream into a variant.
{$IFDEF DOTNET}
function StreamToVariant(stream:TStream):variant;
var
   i:integer;
   b:byte;
begin
     stream.Seek(0,soBeginning);
     Result:=VarArrayCreate([0,stream.Size - 1],VarByte);
     try
        for i:=0 to stream.Size-1 do
        begin
             stream.ReadBuffer(b,1);
             Result[i]:=b;
        end;
     except
        Result:=Unassigned;
     end;
end;

// Get contents of a variant and put it in a stream.
procedure VariantToStream(AVariant:variant; stream:TStream);
var
   sz:integer;
   i:integer;
   b:integer;
begin
     // Check if variant contains data and is an array.
     if VarIsEmpty(AVariant) or VarIsNull(AVariant) or (not VarIsArray(AVariant)) then exit;

     sz:=VarArrayHighBound(AVariant,1);
     for i:=0 to sz-1 do
     begin
          b:=AVariant[i];
          stream.WriteBuffer(b,1);
     end;
end;
{$ELSE}
function StreamToVariant(stream:TStream):variant;
var
   p:PChar;
begin
     stream.Seek(0,{$ifdef LEVEL6}soBeginning{$else}0{$endif});
     Result:=VarArrayCreate([0,stream.Size - 1],VarByte);
     try
        p:=VarArrayLock(Result);
        try
           stream.ReadBuffer(p^,stream.Size);
        finally
           VarArrayUnlock(Result);
        end;
     except
        Result:=Unassigned;
     end;
end;

// Get contents of a variant and put it in a stream.
procedure VariantToStream(AVariant:variant; stream:TStream);
var
   p:PChar;
   sz:integer;
begin
     // Check if variant contains data and is an array.
     if VarIsEmpty(AVariant) or VarIsNull(AVariant) or (not VarIsArray(AVariant)) then exit;

     sz:=VarArrayHighBound(AVariant,1);
     p:=VarArrayLock(AVariant);
     try
        stream.WriteBuffer(p^,sz+1);
     finally
        VarArrayUnlock(AVariant);
     end;
end;
{$ENDIF}

// Compare two fields.
{$IFDEF DOTNET}
function CompareFields(const KeyField,AField:TValueBuffer; const FieldType: TFieldType; const LocaleID:TkbmLocaleID; const IndexFieldOptions:TkbmifoOptions; var FullCompare:boolean):Integer;
var
   p:TValueBuffer;
   b1,b2:TBytes;
   i641,i642:Int64;
   d1,d2:Double;
   si1,si2:smallint;
   dt1,dt2:System.DateTime;
   l,l1:integer;
   c:integer;
   li1,li2:longint;
   cur1,cur2:Currency;
   tssql1,tssql2:TSQLTimeStamp;
   s1,s2:string;
   w1,w2:WideString;
begin
     case FieldType of
       ftInteger,
       ftAutoInc:
          begin
             GetLongInt(KeyField,li1);
             GetLongInt(AField,li2);

             if li1=li2 then Result:=0
             else if li1<li2 then Result:=-1
             else Result:=1;
             FullCompare:=true;
//outputdebugstring(PChar(format('Key=%d, Rec=%d, Res=%d',[PLongint(KeyField)^,PLongint(AField)^,Result])));
          end;

{$IFDEF LEVEL10}
       ftOraInterval,
{$ENDIF}
       ftGUID,
       ftFixedChar,
       ftString:
          begin
               p:=nil;
               try
                  // If partial, cut to reference length. p1=reference field value, p2=tried field value.
                  p:=AField;
                  FullCompare:=not (mtifoPartial in IndexFieldOptions);
                  if not FullCompare then
                  begin

                       l := Marshal.PtrToStringAuto(KeyField).Length;
                       l1 := Marshal.PtrToStringAuto(p).Length;
                       FullCompare:=(l=l1);
                       if not FullCompare then
                       begin
                            if l>l1 then l:=l1;
                            p:=Marshal.AllocHGlobal(l+1);
                            CopyBuffer(AField,p,l);
                       end;
                  end;

                  if (mtifoIgnoreLocale in IndexFieldOptions) then
                  begin

                       if (mtifoCaseInsensitive in IndexFieldOptions) then
                          Result:=CompareText(Marshal.PtrToStringAuto(IntPtr(KeyField)),Marshal.PtrToStringAuto(IntPtr(p)))
                       else
                           Result:=CompareStr(Marshal.PtrToStringAuto(IntPtr(KeyField)),Marshal.PtrToStringAuto(IntPtr(p)));

                  end
                  else
                  begin
                       if (mtifoCaseInsensitive in IndexFieldOptions) then
                          c:=NORM_IGNORECASE
                       else
                           c:=0;
                       s1:=Marshal.PtrToStringAuto(IntPtr(KeyField));
                       s2:=Marshal.PtrToStringAuto(IntPtr(p));
                       Result:=CompareString(LocaleID,c,s1,Length(s1),s2,Length(s2));
                       if Result=0 then
                          raise EMemTableInvalidLocale.Create(kbmInvalidLocale);
                       Result:=Result-2;
                       if Result<=-1 then Result:=-1
                       else if Result>=1 then Result:=1
                       else Result:=0;
                  end;
               finally
                  if p<>AField then Marshal.FreeHGlobal(p);
               end;
          end;

{$IFDEF LEVEL10}
       ftFixedWideChar,
{$ENDIF}
       ftWideString:
          begin
               // If partial, cut to reference length. p1=reference field value, p2=tried field value.
               w1:=WideStringFromBuffer(KeyField);
               w2:=WideStringFromBuffer(AField);
               FullCompare:=not (mtifoPartial in IndexFieldOptions);

               if not FullCompare then
               begin
                    l:=Length(w2);
                    l1:=Length(w1);
                    FullCompare:=(l=l1);
                    if not FullCompare then
                    begin
                         if l>l1 then l:=l1;
                         w2:=copy(w2,1,l);
                    end;
               end;

               if (mtifoIgnoreLocale in IndexFieldOptions) then
               begin

                    if (mtifoCaseInsensitive in IndexFieldOptions) then
                       Result:=WideCompareText(w1,w2)
                    else
                        Result:=WideCompareStr(w1,w2);
               end
               else
               begin
                    if (mtifoCaseInsensitive in IndexFieldOptions) then
                       c:=NORM_IGNORECASE
                    else
                        c:=0;
                    s1:=Marshal.PtrToStringAuto(IntPtr(KeyField));
                    s2:=Marshal.PtrToStringAuto(IntPtr(p));
                    Result:=CompareString(LocaleID,c,s1,Length(s1),s2,Length(s2));
                    if Result=0 then
                       raise EMemTableInvalidLocale.Create(kbmInvalidLocale);
                    Result:=Result-2;
                    if Result<=-1 then Result:=-1
                    else if Result>=1 then Result:=1
                    else Result:=0;
               end;
          end;

       ftFloat,
       ftCurrency:
          begin
               GetInt64(KeyField,i641);
               GetInt64(AField,i642);
               d1:=BitConverter.Int64BitsToDouble(i641);
               d2:=BitConverter.Int64BitsToDouble(i642);
               if d1=d2 then
                  Result:=0
               else if d1<d2 then
                  Result:=-1
               else
                  Result := 1;
               FullCompare:=true;
          end;

       ftSmallint:
          begin
               GetInt16(KeyField,si1);
               GetInt16(AField,si2);
               if si1=si2 then
                  Result:=0
               else if si1<si2 then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

       ftLargeInt:
          begin
               GetInt64(KeyField,i641);
               GetInt64(AField,i642);
               if i641=i642 then
                  Result:=0
               else if i641<i642 then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

       ftDate:
          begin
               GetInt32(KeyField,l);
               GetInt32(AField,l1);
               dt1:=System.DateTime.Create(0).AddDays(l);
               dt2:=System.DateTime.Create(0).AddDays(l1);
               Result:=dt1.CompareTo(dt2);
               FullCompare:=true;
          end;

       ftTime:
          begin
               GetInt32(KeyField,l);
               GetInt32(AField,l1);
               dt1:=System.DateTime.Create(0).AddMilliseconds(l);
               dt2:=System.DateTime.Create(0).AddMilliseconds(l1);
               Result:=dt1.CompareTo(dt2);
               FullCompare:=true;
          end;

       ftDateTime:
          begin
               GetInt64(KeyField,i641);
               GetInt64(AField,i642);
               dt1:=System.DateTime.Create(0).AddMilliseconds(BitConverter.Int64BitsToDouble(i641));
               dt2:=System.DateTime.Create(0).AddMilliseconds(BitConverter.Int64BitsToDouble(i642));
               Result:=datetime.Compare(dt1,dt2);
               FullCompare:=true;
          end;

       ftWord:
          begin
               GetInt16(KeyField,si1);
               GetInt16(AField,si2);
               if word(si1)=word(si2) then
                  Result:=0
               else if word(si1)<word(si2) then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

       ftBoolean:
          begin
               GetInt16(KeyField,si1);
               GetInt16(AField,si2);
               if WordBool(si1)=WordBool(si2) then
                  Result:=0
               else if WordBool(si1)<WordBool(si2) then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

{$IFDEF LEVEL10}
       ftOraTimeStamp,
{$ENDIF}
       ftTimeStamp:
          begin
               tssql1:=TSQLTimeStamp(Marshal.PtrToStructure(KeyField,TypeOf(TSQLTimeStamp)));
               tssql2:=TSQLTimeStamp(Marshal.PtrToStructure(KeyField,TypeOf(TSQLTimeStamp)));
               Result:=tssql1.Year-tssql2.Year;
               if Result=0 then
                  Result:=tssql1.Month-tssql2.Month;
               if Result=0 then
                  Result:=tssql1.Day-tssql2.Day;
               if Result=0 then
                  Result:=tssql1.Hour-tssql2.Hour;
               if Result=0 then
                  Result:=tssql1.Hour-tssql2.Hour;
               if Result=0 then
                  Result:=tssql1.Minute-tssql2.Minute;
               if Result=0 then
                  Result:=tssql1.Second-tssql2.Second;
               if Result=0 then
                  Result:=tssql1.Fractions-tssql2.Fractions;
               if Result<0 then Result:=-1
               else if Result>0 then Result:=1;
               FullCompare:=true;
          end;

       ftBCD,
       ftFmtBCD:
          begin
               Result:=0;
               SetLength(B1,SizeOfTBCD);
               SetLength(B2,SizeOfTBCD);
               try
                  Marshal.Copy(keyfield,B1,0,SizeOfTBCD);
                  Marshal.Copy(keyfield,B2,0,SizeOfTBCD);
                  if (BCDToCurr(TBcd.FromBytes(B1),cur1 )) and (BCDToCurr(TBcd.FromBytes(B2),cur2 )) then
                  begin
                       if cur1<cur2 then Result:=-1
                       else if cur1>cur2 then Result:=1;
                  end;
               finally
                  SetLength(B1, 0);
                  SetLength(B2, 0);
               end;
               FullCompare:=true;
          end;
     else
         Result:=0;
     end;

     if (mtifoDescending in IndexFieldOptions) then Result:=-Result;
end;
{$ELSE}
function CompareFields(const KeyField,AField:pointer; const FieldType: TFieldType; const LocaleID:TkbmLocaleID; const IndexFieldOptions:TkbmifoOptions; var FullCompare:boolean):Integer;
var
   p:PChar;
   d:Double;
   l,l1:integer;
 {$IFNDEF LINUX}
   c:integer;
 {$ENDIF}
   li1,li2:longint;
   cur1,cur2:Currency;
 {$IFDEF LEVEL6}
   tssql1,tssql2:TSQLTimeStamp;
 {$ENDIF}
 {$IFDEF LEVEL4}
   w1,w2:WideString;
 {$ENDIF}
begin
     case FieldType of
       ftInteger,
       ftAutoInc:
          begin
             li1:=PLongint(KeyField)^;
             li2:=PLongInt(AField)^;
             if li1=li2 then Result:=0
             else if li1<li2 then Result:=-1
             else Result:=1;
             FullCompare:=true;
//outputdebugstring(PChar(format('Key=%d, Rec=%d, Res=%d',[PLongint(KeyField)^,PLongint(AField)^,Result])));
          end;

 {$IFDEF LEVEL10}
       ftOraInterval,
 {$ENDIF}
 {$IFDEF LEVEL5}
       ftGUID,
 {$ENDIF}
 {$IFNDEF LEVEL3}
       ftFixedChar,
 {$ENDIF}
       ftString:
          begin
               p:=nil;
               try
                  // If partial, cut to reference length. p1=reference field value, p2=tried field value.
                  p:=AField;
                  FullCompare:=not (mtifoPartial in IndexFieldOptions);
                  if not FullCompare then
                  begin
                       l:=StrLen(PChar(KeyField));
                       l1:=StrLen(p);
                       FullCompare:=(l=l1);
                       if not FullCompare then
                       begin
                            if l>l1 then l:=l1;
                            p:=StrAlloc(l+1);
                            StrLCopy(p,AField,l);
                       end;
                  end;

                  if (mtifoIgnoreLocale in IndexFieldOptions) then
                  begin

                       if (mtifoCaseInsensitive in IndexFieldOptions) then
 {$IFNDEF USE_FAST_STRINGCOMPARE}
                          Result:=CompareText(PChar(KeyField),p)
 {$ELSE}
                          Result:=kbmPCompStrIC(PChar(KeyField),p)
 {$ENDIF}
                       else
 {$IFNDEF USE_FAST_STRINGCOMPARE}
                            Result:=CompareStr(String(PChar(KeyField)),String(PChar(p)));
 {$ELSE}
                            Result:=kbmPCompStr(PChar(KeyField),p);
 {$ENDIF}

                  end
                  else
                  begin
 {$IFDEF LINUX}
                       if (mtifoCaseInsensitive in IndexFieldOptions) then
                          Result:=AnsiCompareText(string(KeyField),string(p))
                       else
                          Result:=AnsiCompareStr(string(KeyField),string(p));
 {$ELSE}
                       if (mtifoCaseInsensitive in IndexFieldOptions) then
                          c:=NORM_IGNORECASE
                       else
                           c:=0;
                       Result:=CompareString(LocaleID,c,PChar(KeyField),strlen(KeyField),p,strlen(p));
                       if Result=0 then
                          raise EMemTableInvalidLocale.Create(kbmInvalidLocale);
                       Result:=Result-2;
 {$ENDIF}
                       if Result<=-1 then Result:=-1
                       else if Result>=1 then Result:=1
                       else Result:=0;
                  end;
               finally
                  if p<>AField then StrDispose(p);
               end;
          end;

 {$IFDEF LEVEL4}
  {$IFDEF LEVEL10}
       ftFixedWideChar,
  {$ENDIF}
       ftWideString:
          begin
               // If partial, cut to reference length. p1=reference field value, p2=tried field value.
               w1:=WideStringFromBuffer(KeyField);
               w2:=WideStringFromBuffer(AField);
               FullCompare:=not (mtifoPartial in IndexFieldOptions);

               if not FullCompare then
               begin
                    l:=Length(w2);
                    l1:=Length(w1);
                    FullCompare:=(l=l1);
                    if not FullCompare then
                    begin
                         if l>l1 then l:=l1;
                         w2:=copy(w2,1,l);
                    end;
               end;

               if (mtifoIgnoreLocale in IndexFieldOptions) then
               begin

                    if (mtifoCaseInsensitive in IndexFieldOptions) then
  {$IFNDEF LEVEL6}
                       Result:=CompareStringW(LOCALE_USER_DEFAULT,NORM_IGNORECASE,PWideChar(w1),Length(w1),PWideChar(w2),Length(w2))
  {$ELSE}
                       Result:=WideCompareText(w1,w2)
  {$ENDIF}
                    else
  {$IFNDEF LEVEL6}
                         Result:=CompareStringW(LOCALE_USER_DEFAULT,0,PWideChar(w1),Length(w1),PWideChar(w2),Length(w2))
  {$ELSE}
                         Result:=WideCompareStr(w1,w2);
  {$ENDIF}
               end
               else
               begin
  {$IFDEF LINUX}
                    if (mtifoCaseInsensitive in IndexFieldOptions) then
                       Result:=WideCompareText(w1,w2)
                    else
                         Result:=WideCompareStr(w1,w2);
  {$ELSE}
                    if (mtifoCaseInsensitive in IndexFieldOptions) then
                       c:=NORM_IGNORECASE
                    else
                        c:=0;
                    Result:=CompareStringW(LocaleID,c,PWideChar(w1),Length(w1),PWideChar(w2),Length(w2));
                    if Result=0 then
                       raise EMemTableInvalidLocale.Create(kbmInvalidLocale);
                    Result:=Result-2;
  {$ENDIF}
                    if Result<=-1 then Result:=-1
                    else if Result>=1 then Result:=1
                    else Result:=0;
               end;
          end;
 {$ENDIF} // LEVEL4

       ftFloat,
       ftCurrency:
          begin
               if PDouble(KeyField)^=PDouble(AField)^ then
                  Result:=0
               else if PDouble(KeyField)^<PDouble(AField)^ then
                  Result:=-1
               else
                  Result := 1;
               FullCompare:=true;
          end;

       ftSmallint:
          begin
               if PSmallInt(KeyField)^=PSmallInt(AField)^ then
                  Result:=0
               else if PSmallInt(KeyField)^<PSmallInt(AField)^ then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

 {$IFNDEF LEVEL3}
       ftLargeInt:
          begin
               if PInt64(KeyField)^=PInt64(AField)^ then
                  Result:=0
               else if PInt64(KeyField)^<PInt64(AField)^ then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;
 {$ENDIF}

       ftDate:
          begin
               if PLongint(KeyField)^=PLongint(AField)^ then
                  Result:=0
               else if PLongint(KeyField)^<PLongint(AField)^ then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

       ftTime:
          begin
               if PLongint(KeyField)^=PLongint(AField)^ then
                  Result:=0
               else if PLongint(KeyField)^<PLongint(AField)^ then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

       ftDateTime:
          begin
               d:=PDateTimeRec(KeyField)^.DateTime-PDateTimeRec(AField)^.DateTime;
               if d<0.0 then
                  Result:=-1
               else if d>0.0 then
                  Result:=1
               else
                  Result:=0;
               FullCompare:=true;
          end;

       ftWord:
          begin
               if PWord(KeyField)^=PWord(AField)^ then
                  Result:=0
               else if PWord(KeyField)^<PWord(AField)^ then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

       ftBoolean:
          begin
               if PWordBool(KeyField)^=PWordBool(AField)^ then
                  Result:=0
               else if PWordBool(KeyField)^<PWordBool(AField)^ then
                  Result:=-1
               else
                  Result:=1;
               FullCompare:=true;
          end;

 {$IFDEF LEVEL6}
  {$IFDEF LEVEL10}
       ftOraTimeStamp,
  {$ENDIF}
       ftTimeStamp:
          begin
               tssql1:=PSQLTimeStamp(KeyField)^;
               tssql2:=PSQLTimeStamp(AField)^;
               Result:=tssql1.Year-tssql2.Year;
               if Result=0 then
                  Result:=tssql1.Month-tssql2.Month;
               if Result=0 then
                  Result:=tssql1.Day-tssql2.Day;
               if Result=0 then
                  Result:=tssql1.Hour-tssql2.Hour;
               if Result=0 then
                  Result:=tssql1.Hour-tssql2.Hour;
               if Result=0 then
                  Result:=tssql1.Minute-tssql2.Minute;
               if Result=0 then
                  Result:=tssql1.Second-tssql2.Second;
               if Result=0 then
                  Result:=tssql1.Fractions-tssql2.Fractions;
               if Result<0 then Result:=-1
               else if Result>0 then Result:=1;
               FullCompare:=true;
          end;
 {$ENDIF}

 {$IFDEF LEVEL5}
       ftBCD
  {$IFDEF LEVEL6}
       ,ftFmtBCD
  {$ENDIF}
          :
          begin
               Result:=0;
               if BcdToCurr(Pbcd(keyfield)^,cur1) and BcdToCurr(pbcd(afield)^,cur2) then
               begin
                    if cur1<cur2 then Result:=-1
                    else if cur1>cur2 then Result:=1;
               end;
               FullCompare:=true;
          end;
 {$ENDIF}
     else
         Result:=0;
     end;

     if (mtifoDescending in IndexFieldOptions) then Result:=-Result;
end;
{$ENDIF}

function IndexOptions2CompareOptions(AOptions:TIndexOptions):TkbmMemTableCompareOptions;
begin
     Result:=[];
     if ixUnique in AOptions then Result:=Result + [mtcoUnique];
     if ixDescending in AOptions then Result:=Result + [mtcoDescending];
     if ixCaseInsensitive in AOptions then Result:=Result + [mtcoCaseInsensitive];
{$IFNDEF LEVEL3}
     if ixNonMaintained in AOptions then Result:=Result + [mtcoNonMaintained];
{$ENDIF}
end;

function CompareOptions2IndexOptions(AOptions:TkbmMemTableCompareOptions):TIndexOptions;
begin
     Result:=[];
     if mtcoUnique in AOptions then Result:=Result + [ixUnique];
     if mtcoDescending in AOptions then Result:=Result + [ixDescending];
     if mtcoCaseInsensitive in AOptions then Result:=Result + [ixCaseInsensitive];
{$IFNDEF LEVEL3}
     if mtcoNonMaintained in AOptions then Result:=Result + [ixNonMaintained];
{$ENDIF}
end;

// -----------------------------------------------------------------------------------
// TkbmFieldList
// -----------------------------------------------------------------------------------
destructor TkbmFieldList.Destroy;
begin
     inherited;
end;

function TkbmFieldList.Add(AField:TField; AValue:TkbmifoOptions):Integer;
begin
     Result:=FCount;
     Fields[FCount]:=AField;
     Options[FCount]:=AValue;
     inc(FCount);
end;

procedure TkbmFieldList.Clear;
begin
     FCount:=0;
end;

function TkbmFieldList.IndexOf(Item:TField):integer;
var
   i:integer;
begin
     for i:=0 to FCount-1 do
     begin
          if Fields[i]=Item then
          begin
               Result:=i;
               exit;
          end;
     end;
     Result:=-1;
end;

procedure TkbmFieldList.AssignTo(AFieldList:TkbmFieldList);
var
   i:integer;
begin
     AFieldList.Clear;
     for i:=0 to Count-1 do
     begin
          AFieldList.Fields[i]:=Fields[i];
          AFieldList.Options[i]:=Options[i];
          AFieldList.FieldOfs[i]:=FieldOfs[i];
          AFieldList.FieldNo[i]:=FieldNo[i];
     end;
     AFieldList.FCount:=FCount;
end;

procedure TkbmFieldList.MergeOptionsTo(AFieldList:TkbmFieldList);
var
   i:integer;
   n:integer;
begin
     n:=FCount;
     if n>AFieldList.FCount then n:=AFieldList.FCount;
     for i:=0 to n-1 do
         AFieldList.Options[i]:=AFieldList.Options[i] + Options[i];
end;

procedure TkbmFieldList.ClearOptions;
var
   i:integer;
   n:integer;
begin
     n:=Count;
     for i:=0 to n-1 do
         Options[i]:=[];
end;

// -----------------------------------------------------------------------------------
// TkbmCommon
// -----------------------------------------------------------------------------------
// Lowlevel record handling routines.
// Allocate space for a record structure.
{$IFDEF DOTNET}
function TkbmCommon._InternalAllocRecord:PkbmRecord;
  var kbmRecord:TkbmRecord;
begin
     //Result:=PkbmRecord.Create;
     Result := Marshal.AllocHGlobal(FTotalRecordSize);
     kbmRecord:=TkbmRecord(Marshal.PtrToStructure(Result,TypeOf(TkbmRecord)));
     kbmRecord.Data:=IntPtr(integer(Result)+Sizeof(TkbmRecord));
{$IFDEF DO_CHECKRECORD}
     kbmRecord.StartIdent:=kbmRecordIdent;
     kbmRecord.EndIdent:=kbmRecordIdent;
{$ENDIF}
     Marshal.StructureToPtr(kbmRecord,Result,false);
     _InternalClearRecord(Result);
{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(Result);
{$ENDIF}

end;
{$ELSE}
function TkbmCommon._InternalAllocRecord:PkbmRecord;
begin
     GetMem(Result,FTotalRecordSize);
     Result^.Data:=PChar(Result)+Sizeof(TkbmRecord);
{$IFDEF DO_CHECKRECORD}
     Result^.StartIdent:=kbmRecordIdent;
     Result^.EndIdent:=kbmRecordIdent;
{$ENDIF}
     _InternalClearRecord(Result);
{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(Result);
{$ENDIF}
end;
{$ENDIF}

{$IFDEF DO_CHECKRECORD}
// Check record validity.
procedure TkbmCommon._InternalCheckRecord(ARecord:PkbmRecord);
begin
 {$IFDEF DOTNET}
     // Check record identifier.
     if (ARecord.StartIdent<>kbmRecordIdent) or (ARecord.EndIdent<>kbmRecordIdent) then
        raise EMemTableInvalidRecord.Create(kbmInvalidRecord+inttostr(integer(ARecord)));
 {$ELSE}
     // Check record identifier.
     if (ARecord^.StartIdent<>kbmRecordIdent) or (ARecord^.EndIdent<>kbmRecordIdent) then
        raise EMemTableInvalidRecord.Create(kbmInvalidRecord+inttostr(integer(ARecord)));
 {$ENDIF}
end;
{$ENDIF}

// Free var lengths in record.
{$IFDEF DOTNET}
procedure TkbmCommon._InternalFreeRecordVarLengths(ARecord:PkbmRecord);
var
   i:integer;
   pField,pVarLength:IntPtr;
   fld:TField;
begin
     // Delete varlengths if any defined.
     if FVarLengthCount>0 then
     begin
          // Browse fields to delete varlengths.
          for i:=0 to FFieldCount-1 do
          begin
               fld:=FOwner.Fields[i];
               if (fld.FieldNo>0) and ((FFieldFlags[fld.FieldNo-1] and kbmffIndirect)<>0) then
               begin
                    pField:=GetFieldPointer(ARecord,fld);
                    pVarLength:=PPkbmVarLength(integer(pField)+1);
                    if (Marshal.ReadIntPtr (pVarLength)<>nil) then
                    begin
                         FreeVarLength(Marshal.ReadIntPtr (pVarLength));
                         Marshal.WriteIntPtr (pVarLength,nil);
                         Marshal.WriteByte(pField,0,Byte(kbmffNull));
                    end;
               end;
          end;
     end;
end;
{$ELSE}
procedure TkbmCommon._InternalFreeRecordVarLengths(ARecord:PkbmRecord);
var
   i:integer;
   pVarLength:PPkbmVarLength;
   pField:PChar;
   fld:TField;
begin
     // Delete varlengths if any defined.
     if FVarLengthCount>0 then
     begin
          // Browse fields to delete varlengths.
          for i:=0 to FFieldCount-1 do
          begin
               fld:=FOwner.Fields[i];
               if (fld.FieldNo>0) and ((FFieldFlags[fld.FieldNo-1] and kbmffIndirect)<>0) then
               begin
                    pField:=GetFieldPointer(ARecord,fld);
                    pVarLength:=PPkbmVarLength(pField+1);
                    if (pVarLength^<>nil) then
                    begin
                         FreeVarLength(pVarLength^);
                         pVarLength^:=nil;
                         pField^:=kbmffNull;
                    end;
               end;
          end;
     end;
end;
{$ENDIF}

// Transfer temporary buffer record to storage record.
{$IFDEF DOTNET}
procedure TkbmCommon._InternalTransferRecord(SourceRecord,DestRecord:PkbmRecord);
var
   i:integer;
   pFieldSrc,pFieldDest:IntPtr;
   pVarLengthSrc,pVarLengthDest:PPkbmVarLength;
   fld:TField;
begin
     // Transfer varlengths.
     // Source varlengths will be freed, but null flag retained from storage.
     if FVarLengthCount>0 then
     begin
          // Browse fields to merge varlengths.
          for i:=0 to FFieldCount-1 do
          begin
               fld:=FOwner.Fields[i];
               if (fld.FieldNo>0) and ((FFieldFlags[fld.FieldNo-1] and kbmffIndirect)<>0) then
               begin
                    pFieldSrc:=GetFieldPointer(SourceRecord,fld);
                    pFieldDest:=GetFieldPointer(DestRecord,fld);
                    pVarLengthSrc:=PPkbmVarLength(integer(pFieldSrc)+1);
                    pVarLengthDest:=PPkbmVarLength(integer(pFieldDest)+1);

                    // If source varlength, move it.
                    if (Marshal.ReadIntPtr (pVarLengthSrc)<>nil) then
                    begin
                         // Check if destination allocated, free it.
                         if Marshal.ReadIntPtr (pVarLengthDest)<>nil then
                            FreeVarLength(Marshal.ReadIntPtr (pVarLengthDest));

                         Marshal.WriteIntPtr(pVarLengthDest,Marshal.ReadIntPtr(pVarLengthSrc) );
                         Marshal.WriteIntPtr (pVarLengthSrc,nil);
                    end

                    // Else if no source, check if indirect null.
                    else if (Marshal.ReadByte (pFieldSrc,0)=Byte(kbmffNull)) and (Marshal.ReadIntPtr (pVarLengthDest)<>nil) then
                    begin
                         FreeVarLength(Marshal.ReadIntPtr (pVarLengthDest));
                         Marshal.WriteIntPtr (pVarLengthDest,nil);
                         Marshal.WriteByte (pFieldDest,0,byte(kbmffNull));
                    end;
               end;
          end;
     end;

     // Move fixed part of record to storage.
     _InternalMoveRecord(SourceRecord,DestRecord);
end;
{$ELSE}
procedure TkbmCommon._InternalTransferRecord(SourceRecord,DestRecord:PkbmRecord);
var
   i:integer;
   pFieldSrc,pFieldDest:PChar;
   pVarLengthSrc,pVarLengthDest:PPkbmVarLength;
   fld:TField;
begin
     // Transfer varlengths.
     // Source varlengths will be freed, but null flag retained from storage.
     if FVarLengthCount>0 then
     begin
          // Browse fields to merge varlengths.
          for i:=0 to FFieldCount-1 do
          begin
               fld:=FOwner.Fields[i];
               if (fld.FieldNo>0) and ((FFieldFlags[fld.FieldNo-1] and kbmffIndirect)<>0) then
               begin
                    pFieldSrc:=GetFieldPointer(SourceRecord,fld);
                    pFieldDest:=GetFieldPointer(DestRecord,fld);
                    pVarLengthSrc:=PPkbmVarLength(pFieldSrc+1);
                    pVarLengthDest:=PPkbmVarLength(pFieldDest+1);

                    // If source varlength, move it.
                    if (pVarLengthSrc^<>nil) then
                    begin
                         // Check if destination allocated, free it.
                         if pVarLengthDest^<>nil then
                            FreeVarLength(pVarLengthDest^);
                         pVarLengthDest^:=pVarLengthSrc^;
                         pVarLengthSrc^:=nil;
                    end

                    // Else if no source, check if indirect null.
                    else if (pFieldSrc^=kbmffNull) and (pVarLengthDest^<>nil) then
                    begin
                         FreeVarLength(pVarLengthDest^);
                         pVarLengthDest^:=nil;
                         pFieldDest^:=kbmffNull;
                    end;
               end;
          end;
     end;

     // Move fixed part of record to storage.
     _InternalMoveRecord(SourceRecord,DestRecord);
end;
{$ENDIF}

// Deallocate space for a record.
{$IFDEF DOTNET}
procedure TkbmCommon._InternalFreeRecord(ARecord:PkbmRecord; FreeVarLengths,FreeVersions:boolean);
   var kbmRecord : TkbmRecord;
begin
     if ARecord=nil then exit;

{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(ARecord);
{$ENDIF}
     if FreeVarLengths then _InternalFreeRecordVarLengths(ARecord);

     // Free record data, incl. previous versioning records if any, but only if actual record in table.
     kbmRecord := TkbmRecord(Marshal.PtrToStructure  (ARecord,typeOf(TkbmRecord) ));
     with kbmRecord do
     begin
           if ((Flag and kbmrfInTable)<>0) and FreeVersions and (PrevRecordVersion<>nil) then
           begin
                _InternalFreeRecord(PrevRecordVersion,FreeVarLengths,true);
                PrevRecordVersion:=nil;
           end;
           Data:=nil;
     end;
     // Free record.
     Marshal.FreeHGlobal(ARecord);
end;
{$ELSE}
procedure TkbmCommon._InternalFreeRecord(ARecord:PkbmRecord; FreeVarLengths,FreeVersions:boolean);
begin
     if ARecord=nil then exit;

{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(ARecord);
{$ENDIF}
     if FreeVarLengths then _InternalFreeRecordVarLengths(ARecord);

     // Free record data, incl. previous versioning records if any, but only if actual record in table.
     with ARecord^ do
     begin
           if ((Flag and kbmrfInTable)<>0) and FreeVersions and (PrevRecordVersion<>nil) then
           begin
                _InternalFreeRecord(PrevRecordVersion,FreeVarLengths,true);
                PrevRecordVersion:=nil;
           end;
           Data:=nil;
     end;
     // Free record.
     FreeMem(ARecord);
end;
{$ENDIF}

// Clear record buffer.
{$IFDEF DOTNET}
procedure TkbmCommon._InternalClearRecord(ARecord:PkbmRecord);
  var kbmRecord:TkbmRecord;
begin
     kbmRecord := TkbmRecord (Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));
     kbmRecord.RecordNo:=-1;
     kbmRecord.RecordID:=-1;
     kbmRecord.UniqueRecordID:=-1;
     kbmRecord.Tag:=0;
     kbmRecord.PrevRecordVersion:=nil;
     kbmRecord.TransactionLevel:=-1;
     kbmRecord.UpdateStatus:=usUnmodified;
     kbmRecord.Flag:=0;
     FillChar(kbmRecord.Data,FDataRecordSize,0);
     Marshal.StructureToPtr (kbmRecord,ARecord,false);
end;
{$ELSE}
procedure TkbmCommon._InternalClearRecord(ARecord:PkbmRecord);
begin
{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(ARecord);
{$ENDIF}
     ARecord^.RecordNo:=-1;
     ARecord^.RecordID:=-1;
     ARecord^.UniqueRecordID:=-1;
     ARecord^.Tag:=0;
     ARecord^.PrevRecordVersion:=nil;
     ARecord^.TransactionLevel:=-1;
     ARecord^.UpdateStatus:=usUnmodified;
     ARecord^.Flag:=0;
     FillChar(ARecord^.Data^,FDataRecordSize,0);
end;
{$ENDIF}

// Allocate space for a duplicate record, and copy the info to it.
function TkbmCommon._InternalCopyRecord(SourceRecord:PkbmRecord;CopyVarLengths:boolean):PkbmRecord;
begin
{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(SourceRecord);
{$ENDIF}

     Result:=_InternalAllocRecord;
{$IFDEF DOTNET}
     with Result do
{$ELSE}
     with Result^ do
{$ENDIF}
     begin
          _InternalMoveRecord(SourceRecord,Result);
          if CopyVarLengths then _InternalCopyVarLengths(SourceRecord,Result);
     end;
end;

// Copy a var length from one record to another.
// If destination has a var length allready, it will be deleted.
{$IFDEF DOTNET}
procedure TkbmCommon._InternalCopyVarLength(SourceRecord,DestRecord:PkbmRecord; Field:TField);
var
   pFldSrc,pFldDest:IntPtr;
   pVarLenSrc,pVarLenDest:PPkbmVarLength;
   pVarLenClone:PkbmVarLength;
begin
     pFldSrc:=GetFieldPointer (SourceRecord,Field);
     pFldDest:=GetFieldPointer(DestRecord,Field);

     pVarLenSrc:=PPkbmVarLength(integer(pFldSrc)+1);
     pVarLenDest:=PPkbmVarLength(integer(pFldDest)+1);

     // Check if varlength in destination, then delete.
     if (Marshal.ReadIntPtr (pVarLenDest) <> nil) then
     begin
          FreeVarLength(Marshal.ReadIntPtr (pVarLenDest));
          Marshal.WriteIntPtr (pVarLenDest,nil);
          Marshal.WriteByte (pFldDest,byte (kbmffNull));  // Set field value to NULL.
     end;

     // Copy varlength from source to destination.
     if (marshal.ReadIntPtr (pVarLenSrc) <> nil) then
     begin
          pVarLenClone:=CopyVarLength(Marshal.ReadIntPtr (pVarLenSrc));
          Marshal.WriteIntPtr (pVarLenDest,pVarLenClone);
          Marshal.WriteByte (pFldDest,byte(kbmffData));  // Set field value to NOT NULL.
     end;

end;
{$ELSE}
procedure TkbmCommon._InternalCopyVarLength(SourceRecord,DestRecord:PkbmRecord; Field:TField);
var
   pFldSrc,pFldDest:PChar;
   pVarLenSrc,pVarLenDest:PPkbmVarLength;
   pVarLenClone:PkbmVarLength;
begin
     pFldSrc:=GetFieldPointer (SourceRecord,Field);
     pFldDest:=GetFieldPointer(DestRecord,Field);

     pVarLenSrc:=PPkbmVarLength(pFldSrc+1);
     pVarLenDest:=PPkbmVarLength(pFldDest+1);

     // Check if varlength in destination, then delete.
     if (pVarLenDest^ <> nil) then
     begin
          FreeVarLength(pVarLenDest^);
          pVarLenDest^:=nil;
          pFldDest^:=kbmffNull;  // Set field value to NULL.
     end;

     // Copy varlength from source to destination.
     if (pVarLenSrc^ <> nil) then
     begin
          pVarLenClone:=CopyVarLength(pVarLenSrc^);
          pVarLenDest^:=pVarLenClone;
          pFldDest^:=kbmffData;  // Set field value to NOT NULL.
     end;
end;
{$ENDIF}


// Copy var lengths from one record to another.
procedure TkbmCommon._InternalCopyVarLengths(SourceRec,DestRec:PkbmRecord);
var
   i:integer;
   fld:TField;
begin
     // Copy varlengths if any defined.
     if FVarLengthCount>0 then
     begin
          // Browse fields to copy varlengths.
          for i:=0 to FFieldCount-1 do
          begin
               fld:=FOwner.Fields[i];
               if (fld.FieldNo>0) and ((FFieldFlags[fld.FieldNo-1] and kbmffIndirect)<>0) then
                 _InternalCopyVarLength(SourceRec,DestRec,FOwner.Fields[i]);
          end;
     end;
end;

// Compression of a field buffer.
{$IFDEF DOTNET}
function TkbmCommon.CompressFieldBuffer(Field:TField; const Buffer:IntPtr; var Size:longint):IntPtr;
var
   sz:integer;
   ba:TBytes;
begin
     case Field.DataType of
        ftFixedChar,
        ftString:
          begin
               // Store the 0 even if its taking up one extra byte in all cases.
               // Simplifies decompression.
               SetLength(ba,Size);
               Marshal.Copy(Buffer,ba,0,Size);
               Size:=StringOf(ba).Length+1;
               SetLength(ba,0);
               Result:=Buffer;
          end;

 {$IFDEF LEVEL10}
        ftFixedWideChar,
 {$ENDIF}
        ftWideString:
          begin
               Size:=Marshal.ReadInt32(Buffer);
               inc(Size,4); // stringsize+4 bytes for length.
               Result:=Buffer;
          end;
        else
          begin
               Result:=Buffer;
          end;
     end;
end;
{$ELSE}
function TkbmCommon.CompressFieldBuffer(Field:TField; const Buffer:pointer; var Size:longint):pointer;
 {$IFDEF LEVEL4}
var
   p:PChar;
   sz:integer;
 {$ENDIF}
begin
     case Field.DataType of
 {$IFNDEF LEVEL3}
        ftFixedChar,
 {$ENDIF}
        ftString:
          begin
               // Store the 0 even if its taking up one extra byte in all cases.
               // Simplifies decompression.
               Size:=strlen(PChar(Buffer))+1;
               Result:=Buffer;
          end;

 {$IFDEF LEVEL4}
  {$IFDEF LEVEL10}
        ftFixedWideChar,
  {$ENDIF}
        ftWideString:
          begin
               p:=PChar(Buffer);
               sz:=PInteger(p)^;

               // Return actual size of the data rather than max size.
               Size:=sz+sizeof(Integer);
               Result:=Buffer;
          end;
 {$ENDIF}
        else
          begin
               Result:=Buffer;
          end;
     end;
end;
{$ENDIF}

// Decompression of a field buffer.
// Since we at the time only handles strings truncated at the 0 char,
// simply return the buffer and allready known size.

{$IFDEF DOTNET}
function TkbmCommon.DecompressFieldBuffer(Field:TField; const Buffer:IntPtr; var Size:longint):IntPtr;
{$ELSE}
function TkbmCommon.DecompressFieldBuffer(Field:TField; const Buffer:pointer; var Size:longint):pointer;
{$ENDIF}
begin
     Result:=Buffer;
end;

function TkbmCommon.GetDeletedRecordsCount:integer;
begin
     Result:=DeletedRecordCount;
end;

// Move contents of one record to another.
// If not to move varlength fields, copies field contents by fieldcontents.

{$IFDEF DOTNET}
procedure TkbmCommon._InternalMoveRecord(SourceRecord,DestRecord:PkbmRecord);
var
   i:integer;
   fld:TField;
   sourceRec,destRec:TkbmRecord;
begin

{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(SourceRecord);
     DestRecord^.StartIdent:=kbmRecordIdent;
     DestRecord^.EndIdent:=kbmRecordIdent;
{$ENDIF}

     sourceRec  := TkbmRecord (Marshal.PtrToStructure(SourceRecord,typeOf(TkbmRecord)));
     destRec := TkbmRecord (Marshal.PtrToStructure(DestRecord,  typeOf(TkbmRecord)));
     DestRec.RecordNo:=SourceRec.RecordNo;
     DestRec.RecordID:=SourceRec.RecordID;
     DestRec.UniqueRecordID:=SourceRec.UniqueRecordID;
     DestRec.UpdateStatus:=SourceRec.UpdateStatus;
     DestRec.PrevRecordVersion:=SourceRec.PrevRecordVersion;
     DestRec.TransactionLevel:=SourceRec.TransactionLevel;
     DestRec.Tag:=SourceRec.Tag;

     // Move fixed part of record, excluding varlengths.
     CopyBuffer (SourceRec.Data,DestRec.Data,FFixedRecordSize);
     Marshal.StructureToPtr(DestRec,DestRecord,false);

     // Copy varlengths null flags.
     if (FVarLengthCount>0) then
     begin
          // Browse fields to copy varlengths nullflags.
          for i:=0 to FFieldCount-1 do
          begin
               fld:=FOwner.Fields[i];
               if (fld.FieldNo>0) and ((FFieldFlags[fld.FieldNo-1] and kbmffIndirect)<>0) then
                  Marshal.WriteByte(GetFieldPointer (DestRecord,fld),Marshal.ReadByte(GetFieldPointer(SourceRecord,fld),0));
          end;
     end;

end;
{$ELSE}
procedure TkbmCommon._InternalMoveRecord(SourceRecord,DestRecord:PkbmRecord);
var
   i:integer;
   fld:TField;
begin
{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(SourceRecord);
     DestRecord^.StartIdent:=kbmRecordIdent;
     DestRecord^.EndIdent:=kbmRecordIdent;
{$ENDIF}
     DestRecord^.RecordNo:=SourceRecord^.RecordNo;
     DestRecord^.RecordID:=SourceRecord^.RecordID;
     DestRecord^.UniqueRecordID:=SourceRecord^.UniqueRecordID;
     DestRecord^.UpdateStatus:=SourceRecord^.UpdateStatus;
     DestRecord^.PrevRecordVersion:=SourceRecord^.PrevRecordVersion;
     DestRecord^.TransactionLevel:=SourceRecord^.TransactionLevel;
     DestRecord^.Tag:=SourceRecord^.Tag;

     // Move fixed part of record, excluding varlengths.
{$IFNDEF USE_FAST_MOVE}
     Move(SourceRecord^.Data^,DestRecord^.Data^,FFixedRecordSize);
{$ELSE}
     FastMove(SourceRecord^.Data^,DestRecord^.Data^,FFixedRecordSize);
{$ENDIF}

     // Copy varlengths null flags.
     if (FVarLengthCount>0) then
     begin
          // Browse fields to copy varlengths nullflags.
          for i:=0 to FFieldCount-1 do
          begin
               fld:=FOwner.Fields[i];
               if (fld.FieldNo>0) and ((FFieldFlags[fld.FieldNo-1] and kbmffIndirect)<>0) then
                  GetFieldPointer(DestRecord,fld)^ := GetFieldPointer(SourceRecord,fld)^;
          end;
     end;
end;
{$ENDIF} //dotnet

// Compare two records.

function TkbmCommon._InternalCompareRecords(const FieldList:TkbmFieldList; const MaxFields:integer; const KeyRecord,ARecord:PkbmRecord; const IgnoreNull,Partial:boolean; const How:TkbmCompareHow): Integer;
var
   i,o:integer;
{$IFDEF DOTNET}
   p1,p2:IntPtr;
   kRecord,akbmRecord:TkbmRecord;
{$ELSE}
   p1,p2:PChar;
{$ENDIF}
   sz1,sz2:longint;
   pv1,pv2:PkbmVarLength;
   fld:TField;
   n:integer;
   flags:byte;
   RecID:longint;
   ARec:PkbmRecord;
   ifo:TkbmifoOptions;
   FullCompare:boolean;
   fno:integer;
begin
{$IFDEF USE_SAFE_CODE}
     if (KeyRecord=nil) or (ARecord=nil) then exit;
{$ENDIF}

{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(KeyRecord);
     _InternalCheckRecord(ARecord);
{$ENDIF}

     n:=FieldList.Count;
     if (MaxFields>0) and (MaxFields<n) then n:=MaxFields;

     // Loop through all indexfields, left to right.
     FullCompare:=true;
     i:=0;
     while i<n do
     begin
          fld:=FieldList.Fields[i];
          ifo:=FieldList.Options[i];
          if How<>chBreakNE then Exclude(ifo,mtifoDescending); // $FF -
          if Partial then Include(ifo,mtifoPartial);

          // Get data for specified field for the two records.
          o:=FieldList.FieldOfs[i];
{$IFDEF DOTNET}
          kRecord:=TkbmRecord(Marshal.PtrToStructure(KeyRecord,typeOf(TkbmRecord)));
          akbmRecord:=TkbmRecord(Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));
          p1:=KRecord.Data;
          p2:=AkbmRecord.Data;
          p1:=IntPtr(integer(p1)+o);
          p2:=IntPtr(integer(p2)+o);
{$ELSE}
          p1:=KeyRecord^.Data;
          p2:=ARecord^.Data;
          inc(p1,o);
          inc(p2,o);
{$ENDIF}

          // Check if to ignore null field in key record.
{$IFDEF DOTNET}
          if (Marshal.ReadByte(p1,0)=Byte(kbmffNull)) and (IgnoreNull or (mtifoIgnoreNull in ifo)) then
{$ELSE}
          if (p1[0]=kbmffNull) and (IgnoreNull or (mtifoIgnoreNull in ifo)) then
{$ENDIF}
          begin
               inc(i);
               continue;
          end;

          // Check if both not null.
{$IFDEF DOTNET}
          if (Marshal.ReadByte(p1,0)<>Byte(kbmffNull)) and (Marshal.ReadByte(p2,0)<>Byte(kbmffNull)) then
{$ELSE}
          if (p1[0]<>kbmffNull) and (p2[0]<>kbmffNull) then
{$ENDIF}

          begin
               // Skip null flag.
{$IFDEF DOTNET}
               p1:=IntPtr(integer(p1)+1);
               p2:=IntPtr(integer(p2)+1);
{$ELSE}
               inc(p1);
               inc(p2);
{$ENDIF}

               // Check if indirect fields.
               fno:=FieldList.FieldNo[i];
               if (fno>0) then
               begin
                    flags:=FFieldFlags[fno-1];
                    if (flags and kbmffIndirect)<>0 then
                    begin
{$IFDEF DOTNET}
                         pv1 := Marshal.ReadIntPtr(p1);
{$ELSE}
                         pv1:=PPkbmVarLength(p1)^;
{$ENDIF}
                         if pv1=nil then
                         begin
                              // Find the record in the recordlist using the unique record id.
{$IFDEF DOTNET}
                              RecID:=KRecord.RecordID;
{$ELSE}
                              RecID:=KeyRecord^.RecordID;
{$ENDIF}
                              if (RecID>=0) then
                              begin
                                   ARec:=PkbmRecord(FRecords.Items[RecID]);
                                   p1:=GetFieldPointer(ARec,fld);
{$IFDEF DOTNET}
                                   p1 := IntPtr(integer(p1) + 1);
                                   pv1 := Marshal.ReadIntPtr(p1);
{$ELSE}
                                   inc(p1);
                                   pv1:=PPkbmVarLength(p1)^;
{$ENDIF}
                              end
                              // If by any chance no valid recordis is found, something is really rotten.
                              else raise EMemTableInvalidRecord.Create(kbmInvalidRecord);
                         end;
{$IFDEF DOTNET}
                         p1  := GetVarLengthData (pv1);
                         pv2 := Marshal.ReadIntPtr(p2);
{$ELSE}
                         p1:=GetVarLengthData (pv1);
                         pv2:=PPkbmVarLength(p2)^;
{$ENDIF}
                         if pv2=nil then
                         begin
                              // Find the record in the recordlist using the unique record id.
{$IFDEF DOTNET}
                              RecID:=AkbmRecord.RecordID;
{$ELSE}
                              RecID:=ARecord^.RecordID;
{$ENDIF}
                              if (RecID>=0) then
                              begin
                                   ARec:=PkbmRecord(FRecords.Items[RecID]);
                                   p2:=GetFieldPointer(ARec,fld);
{$IFDEF DOTNET}
                                   p2 := IntPtr(integer(p2)+1);
                                   pv2 := Marshal.ReadIntPtr(p2);
{$ELSE}
                                   inc(p2);
                                   pv2:=PPkbmVarLength(p2)^;
{$ENDIF}
                              end
                              // If by any chance no valid recordis is found, something is really rotten.
                              else raise EMemTableInvalidRecord.Create(kbmInvalidRecord);
                         end;
                         p2:=GetVarLengthData(pv2);

                         if (flags and kbmffCompress)<>0 then
                         begin
                              sz1:=GetVarLengthSize(pv1);
                              sz2:=GetVarLengthSize(pv2);
                              if (Assigned(FOwner.FOnDecompressField)) then
                              begin
                                   FOwner.FOnDecompressField (FOwner,fld,p1,sz1,p1);
                                   FOwner.FOnDecompressField(FOwner,fld,p2,sz2,p2);
                              end
                              else
                              begin
                                   p1:=DecompressFieldBuffer(fld,p1,sz1);
                                   p2:=DecompressFieldBuffer(fld,p2,sz2);
                              end;
                         end;
                    end;
               end;

               // Compare the fields.
               if (Assigned(FOwner.FOnCompareFields)) then
               begin
                    Result:=0;
                    FOwner.FOnCompareFields(FOwner,fld,p1,p2,fld.DataType,ifo,FullCompare,Result);
               end
               else
                   Result:=CompareFields(p1,p2,fld.DataType,FLocaleID,ifo,FullCompare);
          end
{$IFDEF DOTNET}
          else if (Marshal.ReadByte (p1,0)<>Byte(kbmffNull)) then
{$ELSE}
          else if (p1[0]<>kbmffNull) then
{$ENDIF}
          begin
               if mtifoDescending in ifo then Result:=-1 else Result:=1;
          end
{$IFDEF DOTNET}
          else if (Marshal.ReadByte (p2,0)<>Byte(kbmffNull)) then
{$ELSE}
          else if (p2[0]<>kbmffNull) then
{$ENDIF}
          begin
               if mtifoDescending in ifo then Result:=1 else Result:=-1;
          end
          else Result:=0;

          // Check type of comparison.
          case How of
               chBreakNE:
                  begin
                       if (Result<>0) or (not FullCompare) then break;
                  end;

               chBreakGTE:
                  begin
                       if Result>=0 then break;
                  end;

               chBreakLTE:
                  begin
                       if Result<=0 then break;
                  end;

               chBreakGT:
                  begin
                       if Result>0 then break;
                  end;

               chBreakLT:
                  begin
                       if Result<0 then break;
                  end;
          end;
          inc(i);
     end;
end;

// Append record to chain of records.
procedure TkbmCommon._InternalAppendRecord(ARecord:PkbmRecord);
begin
{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(ARecord);
{$ENDIF}

     AppendRecord(ARecord);
end;

// Delete record from chain.
procedure TkbmCommon._InternalDeleteRecord(ARecord:PkbmRecord);
begin
     if ARecord=nil then exit;

{$IFDEF DO_CHECKRECORD}
     _InternalCheckRecord(ARecord);
{$ENDIF}

     DeleteRecord(ARecord);
     _InternalFreeRecord(ARecord,true,true);
end;

// Pack records.
procedure TkbmCommon._InternalPackRecords;
begin
     PackRecords;
end;

// Purge all records.
procedure TkbmCommon._InternalEmpty;
var
   i:integer;
begin
     // Remove the records.
{$IFDEF DOTNET}
     for i:=0 to FRecords.Count-1 do
         _InternalFreeRecord (IntPtr(FRecords.Items[i]),true,true);
{$ELSE}
     for i:=0 to FRecords.Count-1 do
         _InternalFreeRecord (FRecords.Items[i],true,true);
{$ENDIF}

     FDeletedRecords.Clear;
     FRecordID:=0;
     FUniqueRecordID:=0;
     FRecords.Clear;
     FDataID:=GetUniqueDataID;
end;

function TkbmCommon.GetFieldSize(FieldType:TFieldType; Size:longint):longint;
begin
     case FieldType of
{$IFNDEF LEVEL3}
 {$IFDEF LEVEL10}
          ftFixedWideChar,
 {$ENDIF}
          ftWideString:         Result:=Size*sizeof(WideChar)+sizeof(integer); // 4 bytes length + 2 bytes/character
{$ENDIF}

{$IFDEF LEVEL10}
          ftOraInterval:        Result:=20+1; // 20 chars + zero end character.
{$ENDIF}
{$IFNDEF DOTNET}
          ftFixedChar,
{$ENDIF}
          ftString:             Result:=Size+1; // Size + zero end character.
{$IFDEF LEVEL5}
          ftGUID:               Result:=38+1; // 38 + zero end character.
{$ENDIF}
          ftBytes:              Result:=Size;
          ftVarBytes:           Result:=Size+SizeOf(Word);
          ftSmallInt:           Result:=SizeOf(SmallInt);
          ftInteger:            Result:=SizeOf(Integer);
{$IFNDEF LEVEL3}
          ftLargeInt:           Result:=SizeOf(Int64);
          ftADT,ftArray:        Result:=0;
{$ENDIF}
          ftWord:               Result:=SizeOf(Word);
          ftBoolean:            Result:=SizeOf(WordBool);
          ftFloat:              Result:=SizeOf(Double);
          ftCurrency:           Result:=SizeOf(Double);
          ftDate:               Result:=SizeOf(longint);
          ftTime:               Result:=SizeOf(longint);
          ftDateTime:           Result:=SizeOf(TDateTimeRec);
{$IFDEF LEVEL6}
 {$IFDEF LEVEL10}
          ftOraTimeStamp,
 {$ENDIF}
          ftTimeStamp:          Result:=SizeOf(TSQLTimeStamp);
{$ENDIF}
          ftAutoInc:            Result:=SizeOf(Integer);
          ftBlob:               Result:=0;
{$IFDEF LEVEL10}
          ftWideMemo:           Result:=0;
{$ENDIF}
          ftMemo:               Result:=0;
          ftGraphic:            Result:=0;
          ftFmtMemo:            Result:=0;
          ftParadoxOle:         Result:=0;
          ftDBaseOle:           Result:=0;
          ftTypedBinary:        Result:=0;
{$IFDEF LEVEL5}
          ftOraBlob,
          ftOraClob:            Result:=0;
{$ENDIF}
          ftBCD
{$IFDEF LEVEL6}
          ,ftFmtBCD
{$ENDIF}
                         :      Result:=34; // SizeOf(TBCD);
     else
          Result:=0;
     end;
end;


{$IFDEF DOTNET}
function TkbmCommon.GetFieldPointer(ARecord:PkbmRecord; Field:TField):IntPtr;
var
   rec:TkbmRecord;
{$ELSE}
function TkbmCommon.GetFieldPointer(ARecord:PkbmRecord; Field:TField):PChar;
var
{$ENDIF}
   n:integer;
begin
{$IFDEF USE_SAFE_CODE}
     Result:=nil;
     if ARecord=nil then exit;
{$ENDIF}

{$IFDEF DOTNET}
     rec:=TkbmRecord(Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));
     Result:=rec.Data;
{$ELSE}
     Result:=ARecord^.Data;
{$ENDIF}

{$IFDEF USE_SAFE_CODE}
     if Result=nil then exit;
{$ENDIF}
     n:=Field.FieldNo;
{$IFDEF DOTNET}
     if n>0 then
        Result := IntPtr (Integer(Result)+FFieldOfs[n-1])
     else
        Result := IntPtr (Integer(Result)+FStartCalculated+Field.Offset);
{$ELSE}
     if n>0 then
        inc (Result,FFieldOfs[n-1])
     else
        inc(Result,FStartCalculated+Field.Offset);
{$ENDIF}
end;

function TkbmCommon.GetFieldDataOffset(Field:TField):integer;
var
   n:integer;
begin
     n:=Field.FieldNo;
     if n>0 then
        Result:=FFieldOfs[n-1]
     else
        Result:=FStartCalculated+Field.Offset;
end;

constructor TkbmCommon.Create(AOwner:TkbmCustomMemTable);
begin
     inherited Create;
{$IFNDEF LEVEL5}
     InitializeCriticalSection(FLock);
{$ELSE}
     FLock:=TCriticalSection.Create;
{$ENDIF}

     // Setup owner of table.
     FOwner:=AOwner;

     // Create physical list of records.
     FRecords:=TkbmList.Create;

     // Create list of deleted but not purged records.
     FDeletedRecords:=TkbmList.Create;

     // Set default data id to a random number. (max 2 bytes).
     FDataID:=GetUniqueDataID;

     // Set defaults.
     FAutoIncMin:=0;
     FAutoIncMax:=0;
     FDeletedCount:=0;
     FUniqueRecordID:=0;
     FRecordID:=0;
     FPerformance:=mtpfFast;
     FVersioningMode:=mtvm1SinceCheckPoint;
     FEnableVersioning:=false;
     FTransactionLevel:=0;

{$IFDEF LINUX}
     LocaleID:=0;
{$ELSE}
     LocaleID:=LOCALE_USER_DEFAULT;
{$ENDIF}

     // Attached tables.
     FAttachMaxCount:=1;
     FAttachedTables:=TList.Create;
end;

destructor TkbmCommon.Destroy;
var
   i:integer;
   mt:TkbmCustomMemTable;
begin
     // Check if any tables attached to this, deattach them.
     for i:=0 to FAttachedTables.Count-1 do
     begin
          mt:=TkbmCustomMemTable(FAttachedTables.Items[i]);
          if mt<>nil then
          begin
               mt.Close;
               mt.AttachedTo:=nil;
          end;
     end;

     FAttachedTables.free;
     FDeletedRecords.free;
     FRecords.free;

{$IFNDEF LEVEL5}
     DeleteCriticalSection(FLock);
{$ELSE}
     FLock.Free;
{$ENDIF}
     inherited;
end;

function TkbmCommon.GetUniqueDataID:longint;
begin
     repeat
           Result:=random(1 shl 30 + 1);
     until Result<>FDataID;
end;

procedure TkbmCommon.ClearModifiedFlags;
var
   i:integer;
begin
     Lock;
     try
        // Clear all modification flags.
        for i:=0 to KBM_MAX_FIELDS-1 do
            FFieldFlags[i]:=FFieldFlags[i] and (high(byte)-kbmffModified);
     finally
        UnLock;
     end;
end;

function TkbmCommon.GetModifiedFlag(i:integer):boolean;
begin
     Lock;
     Result:=false;
     try
        if (i<0) or (i>=FFieldCount) then raise ERangeError.CreateFmt(kbmOutOfRange,[i]);
        Result:=(FFieldFlags[i] and kbmffModified)<>0;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetModifiedFlag(i:integer; Value:boolean);
begin
     Lock;
     try
        if (i<0) or (i>=FFieldCount) then raise ERangeError.CreateFmt(kbmOutOfRange,[i]);
        if Value then
           FFieldFlags[i]:=FFieldFlags[i] and kbmffModified
        else
           FFieldFlags[i]:=FFieldFlags[i] and (high(byte)-kbmffModified);
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetAttachMaxCount:integer;
begin
     Lock;
     try
        Result:=FAttachMaxCount;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetAttachCount:integer;
var
   i:integer;
begin
     Lock;
     Result:=0;
     try
        for i:=0 to FAttachedTables.Count-1 do
            if FAttachedTables.Items[i]<>nil then inc(Result);
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetAttachMaxCount(Value:integer);
begin
     if Value=FAttachMaxCount then exit;

     if Value<1 then
        raise ERangeError.Create(kbmInvArgument);

     if IsAnyTableActive then
        raise EMemTableError.Create(kbmTableMustBeClosed);

     Lock;
     try
        FAttachedTables.count:=Value;
        FAttachMaxCount:=Value;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetRecordID(ARecordID:longint);
begin
     Lock;
     try
        FRecordID:=ARecordID;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetUniqueRecordID(ARecordID:longint);
begin
     Lock;
     try
        FUniqueRecordID:=ARecordID;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetDeletedCount(ACount:longint);
begin
     Lock;
     try
        FDeletedCount:=ACount;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.CalcLocaleID;
var
   ALID:word;
begin
     Lock;
     try
        ALID:=(word(FSubLanguageID) shl 10) or word(FLanguageID);
        FLocaleID:=(FSortID shl 16) or ALID;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetLocaleID:integer;
begin
     Lock;
     try
        Result:=FLocaleID;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetLocaleID(Value:integer);
var
   ALID:word;
begin
     Lock;
     try
        FLocaleID:=Value;
        FSortID:=(FLocaleID shr 16) and $F;
        ALID:=FLocaleID and $FFFF;
        FLanguageID:=ALID and $FF;
        FSubLanguageID:=(ALID shr 10) and $FF;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetLanguageID:integer;
begin
     Lock;
     try
        Result:=FLanguageID;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetLanguageID(Value:integer);
begin
     Lock;
     try
        FLanguageID:=Value;
        CalcLocaleID;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetSortID:integer;
begin
     Lock;
     try
        Result:=FSortID;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetSortID(Value:integer);
begin
     Lock;
     try
        FSortID:=Value;
        CalcLocaleID;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetSubLanguageID:integer;
begin
     Lock;
     try
        Result:=FSubLanguageID;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetSubLanguageID(Value:integer);
begin
     Lock;
     try
        FSubLanguageID:=Value;
        CalcLocaleID;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.Lock;
begin
     if not FStandalone then
     begin
{$IFNDEF LEVEL5}
          EnterCriticalSection(FLock);
{$ELSE}
          FLock.Enter;
{$ENDIF}
     end;
end;

procedure TkbmCommon.Unlock;
begin
     if not FStandalone then
     begin
{$IFNDEF LEVEL5}
          LeaveCriticalSection(FLock);
{$ELSE}
          FLock.Leave;
{$ENDIF}
     end;
end;

// Rollback transaction.
procedure TkbmCommon.RollBack;
var
   i:integer;
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     // Loop through all records and discard newest current transactions.
     FIsDataModified:=false;
     for i:=0 to FRecords.count-1 do
     begin
          pRec:=PkbmRecord(FRecords.Items[i]);
          if pRec=nil then continue;

          // While same transaction level.
{$IFDEF DOTNET}
          Rec := TkbmRecord(Marshal.PtrToStructure (pRec,typeOf(TkbmRecord) ));
          while Rec.TransactionLevel=FTransactionLevel do
{$ELSE}
          while pRec^.TransactionLevel=FTransactionLevel do
{$ENDIF}
          begin
               // Check what happened with this version.
{$IFDEF DOTNET}
               case Rec.UpdateStatus of
{$ELSE}
               case pRec^.UpdateStatus of
{$ENDIF}
                    // Inserted, delete it again.
                    usInserted:
                      begin
                           _InternalFreeRecord(pRec,true,true);
{$IFDEF DOTNET}
                           FDeletedRecords.Add (IntPtr(i));
{$ELSE}
                           FDeletedRecords.Add(pointer(i));
{$ENDIF}
                           FRecords.Items[i]:=nil;
                           pRec:=nil;
                           break;
                      end;

                    // Marked for deletion or modified, change to older version.
                    usDeleted,
                    usModified:
                      begin
{$IFDEF DOTNET}
                           FRecords.Items[i]:= Rec.PrevRecordVersion;
{$ELSE}
                           FRecords.Items[i]:=pRec^.PrevRecordVersion;
{$ENDIF}
                           _InternalFreeRecord(pRec,true,false);
                      end;

                    // Done nothing. Skip.
                    usUnmodified: break;
               end;
{$IFDEF DOTNET}
               pRec:= IntPtr(FRecords.Items[i]);
{$ELSE}
               pRec:=FRecords.Items[i];
{$ENDIF}
          end;

          // Check if still modified, set modified flag.
{$IFDEF DOTNET}
          Rec := TkbmRecord(Marshal.PtrToStructure (pRec,typeOf(TkbmRecord) ));
          if (pRec<>nil) and (Rec.UpdateStatus<>usUnmodified) then FIsDataModified:=true;
{$ELSE}
          if (pRec<>nil) and (pRec^.UpdateStatus<>usUnmodified) then FIsDataModified:=true;
{$ENDIF}
     end;
end;

// Commit transaction.
procedure TkbmCommon.Commit;
var
   i:integer;
   pRec,pRec1:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     // Loop through all records and discard older transactions.
     for i:=0 to FRecords.count-1 do
     begin
          pRec:=PkbmRecord(FRecords.Items[i]);
          if pRec=nil then continue;

{$IFDEF DOTNET}
          // While same transaction level, use newest, discard rest.
          Rec := TkbmRecord (Marshal.PtrToStructure(pRec,typeOf(TkbmRecord)));
          if Rec.TransactionLevel<>FTransactionLevel then continue;

          // Keep newest version.
          pRec1:=Rec.PrevRecordVersion;
          if (pRec1<>nil) then _InternalFreeRecord(pRec1,true,true);
          Rec.PrevRecordVersion:=nil;
          if Rec.TransactionLevel=FTransactionLevel then dec(Rec.TransactionLevel);
          Marshal.StructureToPtr(Rec,PRec,false);
          FRecords.Items[i] := pRec;
{$ELSE}
          // While same transaction level, use newest, discard rest.
          if pRec^.TransactionLevel<>FTransactionLevel then continue;

          // Keep newest version.
          pRec1:=pRec^.PrevRecordVersion;
          if (pRec1<>nil) then _InternalFreeRecord(pRec1,true,true);
          pRec^.PrevRecordVersion:=nil;

          if pRec^.TransactionLevel=FTransactionLevel then dec(pRec^.TransactionLevel);
{$ENDIF}
     end;
end;

procedure TkbmCommon.Undo(ARecord:PkbmRecord);
var
   recid:integer;
   oRecord:PkbmRecord;
{$IFDEF DOTNET}
   ARec,oRec:TkbmRecord;
{$ENDIF}
begin
     if ARecord=nil then exit;

     Lock;
     try
{$IFDEF DOTNET}
        // Get the record pointer from the storage.
        ARec := TkbmRecord (Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));

        recid:=ARec.RecordID;
        if recid<0 then exit;
        ARecord:= IntPtr(FRecords.Items[recid]);
        ARec := TkbmRecord (Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));

        // Check what happened with this version.
        case ARec.UpdateStatus of

             // Inserted, delete it again.
             usInserted:
               begin
                    ReflectToIndexes(nil,mtiuhDelete,ARecord,nil,ARec.RecordNo,true);
                    exit;
               end;

             // Marked for deletion or modified, change to older version.
             usDeleted,usModified:
               begin
                    // Figure out what status the record had before.
                    oRecord:=ARec.PrevRecordVersion;
                    oRec := TkbmRecord (Marshal.PtrToStructure(oRecord,typeOf(TkbmRecord)));

                    // Free references to deleted record version.
                    ReflectToIndexes(nil,mtiuhDelete,ARecord,nil,-1,true);

                    // Reinsert previous record version.
                    ReflectToIndexes(nil,mtiuhInsert,nil,oRecord,oRec.RecordNo,true);

                    // Update physical record buffer.
                    FRecords.Items[recid]:=ARec.PrevRecordVersion;
               end;

             // Done nothing. Skip.
             usUnmodified: exit;
        end;
{$ELSE}
        // Get the record pointer from the storage.
        recid:=ARecord^.RecordID;
        if recid<0 then exit;
        ARecord:=FRecords.Items[recid];

        // Check what happened with this version.
        case ARecord^.UpdateStatus of

             // Inserted, delete it again.
             usInserted:
               begin
                    ReflectToIndexes(nil,mtiuhDelete,ARecord,nil,ARecord^.RecordNo,true);
                    exit;
               end;

             // Marked for deletion or modified, change to older version.
             usDeleted,usModified:
               begin
                    // Figure out what status the record had before.
                    oRecord:=ARecord^.PrevRecordVersion;

                    // Free references to deleted record version.
                    ReflectToIndexes(nil,mtiuhDelete,ARecord,nil,-1,true);

                    // Reinsert previous record version.
                    ReflectToIndexes(nil,mtiuhInsert,nil,oRecord,oRecord^.RecordNo,true);

                    // Update physical record buffer.
                    FRecords.Items[recid]:=ARecord^.PrevRecordVersion;
               end;

             // Done nothing. Skip.
             usUnmodified: exit;
        end;
{$ENDIF} // dotnet
     finally
        Unlock;
     end;
end;

// Return false if the field should be included as fixed size in the record.
function TkbmCommon.GetFieldIsVarLength(FieldType:TFieldType; Size:longint):boolean;
begin
     Result:=false;

     // No need to store small amounts of data or fixed length data indirectly.
     if (FieldType in kbmVarLengthNonBlobTypes) and (Size>12) then
     begin
          // If should be as fast as possible, dont go indirectly, else ok.
          if (FPerformance <> mtpfFast) then Result:=true;
     end
     else if (FieldType in kbmBlobTypes) then Result:=true;
end;

procedure TkbmCommon.SetStandalone(Value:boolean);
begin
     Lock;
     try
        if FAttachedTables.Count>1 then
           raise EMemTableError.Create(kbmChildrenAttached);
        FStandAlone:=Value;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetStandalone:boolean;
begin
     Result:=FStandalone;
end;

function TkbmCommon.RecordCount:integer;
begin
     Lock;
     try
        Result:=FRecords.Count;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.AppendRecord(ARecord:PkbmRecord);
var
   d,r:integer;
{$IFDEF DOTNET}
   ARec:TkbmRecord;
{$ENDIF}
begin
     Lock;
     try
{$IFDEF DOTNET}
        // Check if to reuse a deleted spot.
        if FDeletedRecords.Count>0 then
        begin
             d:=FDeletedRecords.Count-1;
             r:=Integer(FDeletedRecords.Items[d]);

             ARec := TkbmRecord(Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));

             // Put 'physical' record number into record.
             ARec.RecordID:=r;
             FDeletedRecords.Delete(d);

             // Put unique record number into record.
             ARec.UniqueRecordID:=FUniqueRecordID;
             inc(FUniqueRecordID);

             ARec.Flag:=(ARec.Flag or kbmrfIntable);
             Marshal.StructureToPtr(ARec,ARecord,false);
             FRecords.Items[r]:=ARecord;
        end
        else
        begin
             // Put 'physical' record number into record.
             ARec := TkbmRecord(Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));
             ARec.RecordID:=FRecordID;
             inc(FRecordID);

             // Put unique record number into record.
             ARec.UniqueRecordID:=FUniqueRecordID;
             inc(FUniqueRecordID);

             ARec.Flag:=(ARec.Flag or kbmrfIntable);
             Marshal.StructureToPtr(ARec,ARecord,false);
             FRecords.Add(ARecord);

             // Check if running out of valid bookmark ID's.
             // Very unlikely (needs inserting 2 billion records), but possible.
             if FUniqueRecordID>=2147483600 then
                raise EMemTableFatalError.Create(kbmOutOfBookmarks);
        end;

        if FEnableVersioning then
           ARec.UpdateStatus:=usInserted;
{$ELSE}
        // Check if to reuse a deleted spot.
        if FDeletedRecords.Count>0 then
        begin
             d:=FDeletedRecords.Count-1;
             r:=Integer(FDeletedRecords.Items[d]);

             // Put 'physical' record number into record.
             ARecord^.RecordID:=r;
             FDeletedRecords.Delete(d);

             // Put unique record number into record.
             ARecord^.UniqueRecordID:=FUniqueRecordID;
             inc(FUniqueRecordID);

             FRecords.Items[r]:=ARecord;
             ARecord^.Flag:=(ARecord^.Flag or kbmrfIntable);
        end
        else
        begin
             // Put 'physical' record number into record.
             ARecord^.RecordID:=FRecordID;
             inc(FRecordID);

             // Put unique record number into record.
             ARecord^.UniqueRecordID:=FUniqueRecordID;
             inc(FUniqueRecordID);

             ARecord^.Flag:=(ARecord^.Flag or kbmrfIntable);
             FRecords.Add(ARecord);

             // Check if running out of valid bookmark ID's.
             // Very unlikely (needs inserting 2 billion records), but possible.
             if FUniqueRecordID>=2147483600 then
                raise EMemTableFatalError.Create(kbmOutOfBookmarks);
        end;

        if FEnableVersioning then
           ARecord^.UpdateStatus:=usInserted;
{$ENDIF}
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.DeleteRecord(ARecord:PkbmRecord);
{$IFDEF DOTNET}
var
   ARec:TkbmRecord;
{$ENDIF}
begin
     Lock;
     try
{$IFDEF DOTNET}
        ARec := TkbmRecord (Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord)));
        FDeletedRecords.Add (TObject(ARec.RecordID));
        FRecords.Items[ARec.RecordID]:=nil;
{$ELSE}
        FDeletedRecords.Add (pointer(ARecord.RecordID));
        FRecords.Items[ARecord.RecordID]:=nil;
{$ENDIF}
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.PackRecords;
var
   i:integer;
{$IFDEF DOTNET}
   aRec:TkbmRecord;
   ARecord:PKBmRecord;
{$ENDIF}
begin
     Lock;
     try
        FRecords.Pack;
{$IFDEF DOTNET}
        for i:=0 to FRecords.Count-1 do
            if FRecords.Items[i]<>nil then
            begin
               ARecord := IntPtr(FRecords.Items[i]);
               aRec := TkbmRecord (Marshal.PtrToStructure(ARecord,TypeOf(TkbmRecord)));
               aRec.RecordID := i;
               Marshal.StructureToPtr(ARec,ARecord,false);
               FRecords.Items[i] := ARecord;
            end;
{$ELSE}
        for i:=0 to FRecords.Count-1 do
            if FRecords.Items[i]<>nil then PkbmRecord(FRecords.Items[i])^.RecordID:=i;
{$ENDIF}
        FDeletedRecords.Clear;
     finally
        Unlock;
     end;
end;

function TkbmCommon.DeletedRecordCount:integer;
begin
     Lock;
     try
        Result:=FDeletedRecords.Count;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetAutoIncMin(Value:longint);
begin
     Lock;
     try
        FAutoIncMin:=Value;
        if FAutoIncMax<FAutoIncMin then FAutoIncMax:=FAutoIncMin-1;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetAutoIncMax(Value:longint);
begin
     Lock;
     try
        FAutoIncMax:=Value;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetAutoIncMin:longint;
begin
     Result:=FAutoIncMin;
end;

function TkbmCommon.GetAutoIncMax:longint;
begin
     Result:=FAutoIncMax;
end;

procedure TkbmCommon.SetPerformance(Value:TkbmPerformance);
begin
     Lock;
     try
        FPerformance:=Value;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetPerformance:TkbmPerformance;
begin
     Result:=FPerformance;
end;

procedure TkbmCommon.SetVersioningMode(Value:TkbmVersioningMode);
begin
     Lock;
     try
        FVersioningMode:=Value;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetVersioningMode:TkbmVersioningMode;
begin
     Result:=FVersioningMode;
end;

procedure TkbmCommon.SetEnableVersioning(Value:boolean);
begin
     Lock;
     try
        FEnableVersioning:=Value;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetEnableVersioning:boolean;
begin
     Result:=FEnableVersioning;
end;

procedure TkbmCommon.SetCapacity(Value:longint);
begin
     Lock;
     try
//TODO KBM        FRecords.Capacity:=Value;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetCapacity:longint;
begin
     Lock;
     try
        Result:=FRecords.Capacity;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetIsDataModified:boolean;
begin
     Lock;
     try
        Result:=FIsDataModified;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.SetIsDataModified(Value:boolean);
begin
     Lock;
     try
        FIsDataModified:=Value;
     finally
        Unlock;
     end;
end;

function TkbmCommon.GetTransactionLevel:integer;
begin
     Lock;
     try
        Result:=FTransactionLevel;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.IncTransactionLevel;
begin
     Lock;
     try
        inc(FTransactionLevel);
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.DecTransactionLevel;
begin
     Lock;
     try
        if FTransactionLevel>0 then
           dec(FTransactionLevel);
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.DeAttachTable(ATable:TkbmCustomMemTable);
var
   i:integer;
begin
     Lock;
     try
        i:=FAttachedTables.IndexOf(ATable);
        if i>=0 then FAttachedTables.Items[i]:=nil; // Only mark as unused.
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.AttachTable(ATable:TkbmCustomMemTable);
var
   i:integer;
begin
     Lock;
     try
        // Look for unused spot.
        i:=FAttachedTables.IndexOf(nil);
        if i<0 then
        begin
             if IsAnyTableActive then
                raise EMemTableError.Create(kbmTableMustBeClosed);
             FAttachedTables.Add(ATable);
             ATable.FTableID:=FAttachedTables.Count-1;
             FAttachMaxCount:=FAttachedTables.Count;
        end
        else
        begin
             // Reuse spot.
             FAttachedTables.Items[i]:=ATable;
             ATable.FTableID:=i;
//             ClearBookmarkInfo(ATable.FTableID);
        end;
     finally
        Unlock;
     end;
end;

// Define recordlayout based on a table.
procedure TkbmCommon.LayoutRecord(const AFieldCount:integer);
  procedure EnumerateFieldDefs(SomeFieldDefs:TFieldDefs; var NbrFields:integer);
  var
     i:integer;
{$IFNDEF LEVEL3}
     j:integer;
{$ENDIF}
     sz:integer;
  begin
       with FOwner do
       begin
            for i:=0 to SomeFieldDefs.Count - 1 do
                with SomeFieldDefs[i] do
                begin
                     // Check if field type supported.
                     if not (DataType in kbmSupportedFieldTypes) then
                        raise EMemTableError.Create(kbminternalOpen1Err+
                              Name
                              {$IFNDEF LEVEL3}
                              +' ('+DisplayName+')'
                              {$ENDIF}
                              +Format(kbminternalOpen2Err,[integer(DataType)]));

                     // Determine if field is subject to being an indirect field.
                     if { (Fields[FieldNo-1].FieldKind=fkData) and  - Should not be needed since all fielddefs are datafields. }
                        GetFieldIsVarLength(DataType,Size) then
                     begin
                          FFieldFlags[NbrFields]:=FFieldFlags[NbrFields] or kbmffIndirect;

                          // Call user app. to allow override of default unless a blobtype.
                          if (Assigned(FOnSetupField)) and (not (Fields[FieldNo-1].DataType in kbmBlobTypes)) then
                             FOnSetupField(FOwner,Fields[FieldNo-1],FFieldFlags[NbrFields]);
                     end;

                     // If an indirect field (a varlength), dont set fieldofs at this time.
                     if (FFieldFlags[NbrFields] and kbmffIndirect)<>0 then
                     begin
                          FFieldOfs[NbrFields]:=-1;
                          inc(NbrFields);
                     end
                     else
                     begin
                          // Else normal fixed size field embedded in the record.
                          FFieldOfs[NbrFields]:=FFixedRecordSize;

{$IFNDEF LEVEL3}
                          // Check if arraytype field.
                          if ChildDefs.Count > 0 then
                          begin
                               inc(NbrFields);
                               sz:=GetFieldSize(DataType,Size)+1;
                               inc(FFixedRecordSize,sz);
                               if DataType = ftArray then
                                  for j:=1 to Size do EnumerateFieldDefs(ChildDefs,NbrFields)
                               else
                                   EnumerateFieldDefs(ChildDefs,NbrFields);
                          end
                          else
                          begin
                               // Look for fieldsize.
                               sz:=GetFieldSize(DataType,Size)+1;
                               inc(FFixedRecordSize,sz);
                               inc(NbrFields);
                          end;
{$ELSE}
                          // Look for fieldsize.
                          sz:=GetFieldSize(DataType,Size)+1;
                          inc(FFixedRecordSize,sz);
                          inc(NbrFields);
{$ENDIF}
                     end;
                end;
           end;
  end;

  procedure EnumerateVarLengthFieldDefs(SomeFieldDefs:TFieldDefs; var NbrFields:integer);
  var
     i:integer;
{$IFNDEF LEVEL3}
     j:integer;
{$ENDIF}
  begin
       with FOwner do
       begin
            for i:=0 to SomeFieldDefs.Count - 1 do
                with SomeFieldDefs[i] do
                begin
                     // Check if a varlength field (blobs and long strings f.ex.).
                     if (FFieldFlags[NbrFields] and kbmffIndirect)<>0 then
                     begin
                          // Check if to compress it.
                          if FPerformance=mtpfSmall then
                             FFieldFlags[NbrFields]:=FFieldFlags[NbrFields] or kbmffCompress;
                          FFieldOfs[NbrFields]:=FStartVarLength+FVarLengthCount*(SizeOf(PkbmVarLength)+1);
                          inc(FVarLengthCount);
                     end;
                     inc(NbrFields);

{$IFNDEF LEVEL3}
                     // Check if arraytype field. Adjust field counter.
                     if ChildDefs.Count > 0 then
                     begin
                          if DataType = ftArray then
                             for j:=1 to Size do EnumerateVarLengthFieldDefs(ChildDefs,NbrFields)
                          else
                              EnumerateVarLengthFieldDefs(ChildDefs,NbrFields);
                     end;
{$ENDIF}
                end;
       end;
  end;

var
   Temp:integer;
begin
     if FOwner.FieldDefs.Count<=0 then
        raise EMemTableError.Create(kbmVarReason2Err);

     // Calculate size of bookmark array in record.
     FBookmarkArraySize:=sizeof(TkbmBookmark)*FAttachMaxCount;

     // Calculate non blob field offsets into the record.
     FFixedRecordSize:=0;
     FFieldCount:=AFieldCount;
     Temp:=0;
     EnumerateFieldDefs(FOwner.FieldDefs,Temp);

     // Calculate some size variables.
     FStartCalculated:=FFixedRecordSize;
     FCalcRecordSize:=FOwner.__CalcFieldsSize;
     FStartBookmarks:=FStartCalculated+FCalcRecordSize;
     FStartVarLength:=FStartBookmarks+FBookmarkArraySize;

     // Calculate number of var length fields and their place in the record.
     FVarLengthCount:=0;                  // Know of no var length fields in the definition yet.
     Temp:=0;
     EnumerateVarLengthFieldDefs(FOwner.FieldDefs,Temp);
     FVarLengthRecordSize:=FVarLengthCount * (SizeOf(PkbmVarLength)+1);

     // Calculate total sizes in different variations.
     FFixedRecordSize:=FStartVarLength;
     FDataRecordSize:=FFixedRecordSize+FVarLengthRecordSize;
     FTotalRecordSize:=sizeof(TkbmRecord)+FDataRecordSize;

     FIsDataModified:=False;
     ClearModifiedFlags;
end;

function TkbmCommon.IsAnyTableActive:boolean;
var
   i:integer;
begin
     Result:=false;
     Lock;
     try
        for i:=0 to FAttachedTables.Count-1 do
        begin
             if (FAttachedTables.Items[i]<>nil) and (TkbmCustomMemTable(FAttachedTables.Items[i]).Active) then
             begin
                  Result:=true;
                  exit;
             end;
        end;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.CloseTables(Caller:TkbmCustomMemTable);
var
   i:integer;
begin
     Lock;
     try
        for i:=FAttachedTables.count-1 downto 0 do
            if (FAttachedTables.Items[i]<>nil) and (Caller<>TkbmCustomMemTable(FAttachedTables.Items[i])) then
               with TkbmCustomMemTable(FAttachedTables.Items[i]) do Close;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.RefreshTables(Caller:TkbmCustomMemTable);
var
   i:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.count-1 do
            if (FAttachedTables.Items[i]<>nil) and (Caller<>TkbmCustomMemTable(FAttachedTables.Items[i])) then
               with TkbmCustomMemTable(FAttachedTables.Items[i]) do
                    if Active and (State in [dsBrowse]) then Refresh;
     finally
            Unlock;
     end;
end;

procedure TkbmCommon.ResyncTables;
var
   i:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.count-1 do
            if (FAttachedTables.Items[i]<>nil) then
                with TkbmCustomMemTable(FAttachedTables.Items[i]) do
                     if Active then Resync([]);
     finally
        UnLock;
     end;
end;

procedure TkbmCommon.EmptyTables;
var
   i:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.count-1 do
            if (FAttachedTables.Items[i]<>nil) then
                with TkbmCustomMemTable(FAttachedTables.Items[i]) do
                     if Active then InternalEmptyTable;
        _InternalEmpty;
     finally
        UnLock;
     end;
end;

procedure TkbmCommon.RebuildIndexes;
var
   i:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.Count-1 do
            if (FAttachedTables.Items[i]<>nil) then
                with TkbmCustomMemTable(FAttachedTables.Items[i]) do
                     if Active then Indexes.ReBuildAll;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.MarkIndexesDirty;
var
   i:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.Count-1 do
            if (FAttachedTables.Items[i]<>nil) then
                with TkbmCustomMemTable(FAttachedTables.Items[i]) do
                     if Active then Indexes.MarkAllDirty;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.ClearIndexes;
var
   i:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.Count-1 do
            if (FAttachedTables.Items[i]<>nil) then
                with TkbmCustomMemTable(FAttachedTables.Items[i]) do
                     if Active then
                        Indexes.EmptyAll;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.UpdateIndexes;
var
   i:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.Count-1 do
            if (FAttachedTables.Items[i]<>nil) then
                with TkbmCustomMemTable(FAttachedTables.Items[i]) do
                     if Active then UpdateIndexes;
     finally
        Unlock;
     end;
end;

procedure TkbmCommon.ReflectToIndexes(const Caller:TkbmCustomMemTable; const How:TkbmIndexUpdateHow; const OldRecord,NewRecord:PkbmRecord; const RecordPos:integer; const DontVersion:boolean);
var
   i:integer;
   mt:TkbmCustomMemTable;
   rp:integer;
begin
     Lock;
     try
        for i:=0 to FAttachedTables.Count-1 do
        begin
             mt:=TkbmCustomMemTable(FAttachedTables.Items[i]);
             if mt=nil then continue;
             if mt<>Caller then rp:=-1
             else rp:=RecordPos;
             if mt.Active then
                mt.Indexes.ReflectToIndexes(How,OldRecord,NewRecord,rp,DontVersion);
        end;
     finally
        Unlock;
     end;
end;

// -----------------------------------------------------------------------------------
// TkbmIndex
// -----------------------------------------------------------------------------------
constructor TkbmIndex.Create(Name:string;DataSet:TkbmCustomMemtable; Fields:string; Options:TkbmMemTableCompareOptions; IndexType:TkbmIndexType; Internal:boolean);
begin
     inherited Create;

     FName:=Name;
     FIndexFields:=Fields;
     FDataSet:=DataSet;
     FType:=IndexType;
     FInternal:=Internal;
     FRowOrder:=false;
     FIsView:=false;
     FEnabled:=true;
{$IFDEF LEVEL5}
     FFilterParser:=nil;
{$ENDIF}
     FFilterFunc:=nil;
     FOrdered:=DataSet.FCommon.RecordCount<=0;
     FUpdateStatus:=[usInserted,usModified,usUnmodified];

     FReferences:=TkbmList.Create;

     // Build list of fields in index, and check them for validity.
     FIndexFieldList:=TkbmFieldList.create;
     FDataSet.BuildFieldList(FDataSet,FIndexFieldList,FIndexFields);

     FIndexOptions:=Options;
     if (mtcoDescending in Options) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoDescending,FIndexFields);
     if (mtcoCaseInsensitive in Options) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoCaseInsensitive,FIndexFields);
     if (mtcoPartialKey in Options) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoPartial,FIndexFields);
     if (mtcoIgnoreNullKey in Options) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoIgnoreNull,FIndexFields);
     if (mtcoIgnoreLocale in Options) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoIgnoreLocale,FIndexFields);
end;

{$IFDEF LEVEL5}
constructor TkbmIndex.Create(IndexDef:TIndexDef;DataSet:TkbmCustomMemtable);
{$ELSE}
constructor TkbmIndex.CreateByIndexDef(IndexDef:TIndexDef;DataSet:TkbmCustomMemtable);
{$ENDIF}
begin
     inherited Create;

     FName:=IndexDef.Name;
     FIndexFields:=IndexDef.Fields;
     FDataSet:=DataSet;
     FType:=mtitSorted;
     FInternal:=false;
     FRowOrder:=false;
     FIsView:=false;
     FEnabled:=true;
{$IFDEF LEVEL5}
     FFilterParser:=nil;
{$ENDIF}
     FFilterFunc:=nil;
     FOrdered:=DataSet.FCommon.RecordCount<=0;
     FUpdateStatus:=[usInserted,usModified,usUnmodified];

     FReferences:=TkbmList.Create;

     // Build list of fields in index, and check them for validity.
     FIndexFieldList:=TkbmFieldList.create;
     FDataSet.BuildFieldList(FDataSet,FIndexFieldList,IndexDef.Fields);

     FIndexOptions:=IndexOptions2CompareOptions(IndexDef.Options);

     if (mtcoDescending in FIndexOptions) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoDescending,FIndexFields);
     if (mtcoCaseInsensitive in FIndexOptions) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoCaseInsensitive,FIndexFields);
     if (mtcoPartialKey in FIndexOptions) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoPartial,FIndexFields);
     if (mtcoIgnoreNullKey in FIndexOptions) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoIgnoreNull,FIndexFields);
     if (mtcoIgnoreLocale in FIndexOptions) then FDataSet.SetFieldListOptions(FIndexFieldList,mtifoIgnoreLocale,FIndexFields);
end;

destructor TkbmIndex.Destroy;
begin
     Clear;
{$IFDEF LEVEL5}
     if FFilterParser<>nil then
     begin
          FFilterParser.Free;
          FFilterParser:=nil;
     end;
{$ENDIF}
     FReferences.free;
     FIndexFieldList.free;
     inherited;
end;

function TkbmIndex.Filter(const ARecord:PkbmRecord):boolean;
var
   OldOverride:PkbmRecord;
begin
     if not (IsFiltered or Assigned(FFilterFunc) or Assigned(FDataSet.OnFilterIndex){$IFDEF LEVEL5} or Assigned(FFilterParser){$ENDIF})then
     begin
          Result:=true;
          exit;
     end;

     OldOverride:=FDataSet.FOverrideActiveRecordBuffer;
     try
        FDataSet.FOverrideActiveRecordBuffer:=ARecord;

        // Call filtering function if defined.
        if Assigned(FFilterFunc) then
        begin
             FFilterFunc(FDataSet,self,Result);
             if not Result then exit;
        end;

        // Call users own filtering if specified.
        if Assigned(FDataSet.OnFilterIndex) then
        begin
             FDataSet.OnFilterIndex(FDataSet,self,Result);
             if not Result then exit;
        end;

{$IFDEF LEVEL5}
        // Check if filterstring active.
        if Assigned(FFilterParser) then
        begin
             Result:=FDataSet.FilterExpression(ARecord,FFilterParser);
             if not Result then exit;
        end;
{$ENDIF}
     finally
        FDataSet.FOverrideActiveRecordBuffer:=OldOverride;
     end;
end;

procedure TkbmIndex.SetEnabled(AValue:boolean);
begin
     FEnabled:=AValue;
     if (FEnabled) and (not FOrdered) then Rebuild;
end;

// Compare two arbitrary records for sort.
function TkbmIndex.CompareRecords(const AFieldList:TkbmFieldList; const KeyRecord,ARecord:PkbmRecord; const SortCompare,Partial:boolean): Integer;
const
     RetCodes: array[Boolean, Boolean] of ShortInt = ((2,-1),(1,0));
{$IFDEF DOTNET}
var
   KeyRec,ARec:TkbmRecord;
{$ENDIF}

begin
     with FDataSet do
     begin
          // Compare record contents.
          Result:=FCommon._InternalCompareRecords(AFieldList,-1,KeyRecord,ARecord,false,Partial,chBreakNE);

          // Couldnt compare them according to fieldcontents, will now compare according to recnum.
          if (Result=0) and SortCompare then
          begin
{$IFDEF DOTNET}
               KeyRec := TkbmRecord (Marshal.PtrToStructure(KeyRecord,typeOf(TkbmRecord) ));
               ARec := TkbmRecord (Marshal.PtrToStructure(ARecord,typeOf(TkbmRecord) ));

               Result:=RetCodes[KeyRec.RecordNo>=0,ARec.RecordNo>=0];
               if Result=2 then
                  Result:=KeyRec.RecordID - ARec.RecordID;
{$ELSE}
               Result:=RetCodes[KeyRecord^.RecordNo>=0,ARecord^.RecordNo>=0];
               if Result=2 then
                  Result:=KeyRecord.RecordID - ARecord.RecordID;
{$ENDIF}

               // If descending sort on first field, invert Result.
               if (mtifoDescending in AFieldList.Options[0]) then Result:=-Result;

          end;
     end;
end;

// Binary search routine on Record ID index.
// Non-recursive function.
function TkbmIndex.BinarySearchRecordID(FirstNo,LastNo:integer; const RecordID:integer; const Desc:boolean; var Index:integer):integer;
var
   Mid:integer;
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Index:=-1;

     while FirstNo<=LastNo do
     begin
          // Look in the center of the interval.
          Mid:=(LastNo+FirstNo+1) div 2;
          pRec:=PkbmRecord(FReferences.Items[Mid]);

          // Compare records.
{$IFDEF DOTNET}
          Rec := TkbmRecord (Marshal.PtrToStructure(pRec,typeOf(TkbmRecord)));
          Result:=RecordID - Rec.RecordID;
{$ELSE}
          Result:=RecordID - pRec^.RecordID;
{$ENDIF}

          // If found exactly.
          if Result=0 then
          begin
               Index:=Mid;
               exit;
          end;

          if Desc then Result:=-Result;

          // Not matching, dig deeper.

          // If the key is smaller than the middle record, look in the lower half segment.
          if Result<0 then
             LastNo:=Mid-1
          else
              FirstNo:=Mid+1;
     end;
     Result:=0;
end;

// Enhanced non recursive binary search.
function TkbmIndex.BinarySearch(FieldList:TkbmFieldList; FirstNo,LastNo:integer; const KeyRecord:PkbmRecord; const First,Nearest,RespectFilter:boolean; var Index:integer; var Found:boolean):integer;
var
   Mid:integer;
   PRec:PkbmRecord;

   procedure DoRespectFilter(ALimit:integer);
   var
      b:boolean;
   begin
{$IFDEF DOTNET}
        if (FirstNo<0) or (not RespectFilter) or (not FDataset.IsFiltered) or (FDataset.FilterRecord(PkbmRecord(FReferences.Items[FirstNo]),false)) then exit;
{$ELSE}
        if (FirstNo<0) or (not RespectFilter) or (not FDataset.IsFiltered) or (FDataset.FilterRecord(FReferences.Items[FirstNo],false)) then exit;
{$ENDIF}

        inc(FirstNo);
        while (FirstNo<=ALimit) do
        begin
             Result:=CompareRecords(FieldList,KeyRecord,PkbmRecord(FReferences.Items[FirstNo]),false,Nearest);
             b:=FDataset.FilterRecord(PkbmRecord(FReferences.Items[FirstNo]),false);

             // Check if acceptable record.
             if (b) and ((Result=0) or ((Nearest) and (Result<0))) then exit;

             // Look at next record.
             inc(FirstNo);
        end;
        Found:=false;
   end;
begin
     Result:=0;
     Found:=false;
     if FieldList=nil then FieldList:=FIndexFieldList;
     while FirstNo<=LastNo do
     begin
          Mid:=(FirstNo+LastNo) div 2;
//OutputDebugString(Pchar('Mid='+inttostr(Mid)));
          pRec:=PkbmRecord(FReferences.Items[Mid]);
          Result:=CompareRecords(FieldList,KeyRecord,pRec,false,false);
          if Result<0 then
             LastNo:=Mid-1
          else if Result>0 then
             FirstNo:=Mid+1
          else
          begin
               // Found record, now either backtrack or forward track.
               if First then
               begin
                    Dec(Mid);
                    while Mid>=0 do
                    begin
                         pRec:=PkbmRecord(FReferences.Items[Mid]);
                         Result:=CompareRecords(FieldList,KeyRecord,pRec,false,Nearest);
                         if Result<>0 then
                         begin
                              FirstNo:=Mid+1;
                              break;
                         end;
                         dec(Mid);
                    end;
               end

               else
               begin
                    inc(Mid);
                    while Mid<LastNo do
                    begin
                         pRec:=PkbmRecord(FReferences.Items[Mid]);
                         Result:=CompareRecords(FieldList,KeyRecord,pRec,false,Nearest);
                         if Result<>0 then
                         begin
                              FirstNo:=Mid-1;
                              break;
                         end;
                         inc(Mid);
                    end;
               end;

               // Finished searching.
               Result:=0;
               Found:=true;
               break;
          end;
     end;

     if FDataset.IsFiltered and (FirstNo>=0) and (FirstNo<FReferences.Count) then
        DoRespectFilter(LastNo);

     Index:=FirstNo;
end;

// Sequential search.
function TkbmIndex.SequentialSearch(FieldList:TkbmFieldList; const FirstNo,LastNo:integer; const KeyRecord:PkbmRecord; const Nearest,RespectFilter:boolean; var Index:integer; var Found:boolean):integer;
var
   i:integer;
   pRec:PkbmRecord;
//   desc:boolean;
begin
     // Loop for all records.
     if FieldList=nil then FieldList:=FIndexFieldList;
     Result:=0;
     Index:=-1;
     Found:=false;
//     desc:=(FieldList.Values[0] and mtifoDescending)<>0;

     for i:=FirstNo to LastNo do
     begin
          // Check if to recalc before compare.
          pRec:=PkbmRecord(FReferences.Items[i]);
          with FDataSet do
          begin
               // Call progress function.
               if (i mod 100) = 0 then
                 FDataSet.Progress(trunc((i-FirstNo)/(LastNo-FirstNo+1)*100),mtpcSearch);

               if FRecalcOnIndex then
               begin
                    // Fill calc fields part of buffer
                    __ClearCalcFields({$IFDEF DOTNET}pRec{$ELSE}PChar(pRec){$ENDIF});
                    __GetCalcFields({$IFDEF DOTNET}pRec{$ELSE}PChar(pRec){$ENDIF});
               end;
          end;

          // Check key record equal to record.
          Result:=CompareRecords(FieldList,KeyRecord,pRec,false,Nearest);

          // Check if found match but filtered.
          if (Result=0) and FDataset.IsFiltered and RespectFilter then
          begin
               if not FDataset.FilterRecord(pRec,false) then continue;
          end;

          // Check if nearest or match.
          if (Result=0) or (Nearest and (Result<0)) then
          begin
               Index:=i;
               Found:=true;
               exit;
          end;
     end;
     Index:=LastNo+1;
end;

// Sequential search for record ID.
function TkbmIndex.SequentialSearchRecordID(const FirstNo,LastNo:integer; const RecordID:integer; var Index:integer):integer;
var
   i:integer;
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     // Loop for all records.
     Result:=0;
     Index:=-1;
     for i:=FirstNo to LastNo do
     begin
          // Call progress function.
          if (i mod 100) = 0 then
            FDataSet.Progress(trunc((i-FirstNo)/(LastNo-FirstNo+1)*100),mtpcSearch);

          pRec:=PkbmRecord(FReferences.Items[i]);
{$IFDEF DOTNET}
          Rec:=TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
          Result:=RecordID - Rec.RecordID;
{$ELSE}
          Result:=RecordID - pRec^.RecordID;
{$ENDIF}

          if (Result=0) then
          begin
               Index:=i;
               exit;
          end;
     end;
end;

// Search.
// Aut. choose between indexed seq. search and indexed binary search.
function TkbmIndex.Search(FieldList:TkbmFieldList; KeyRecord:PkbmRecord; Nearest,RespectFilter:boolean; var Index:integer; var Found:boolean):integer;
var
   n:integer;
begin
     Index:=-1;

     // Lock the record list for our use, to make sure nobody alters it.
     FDataSet.Progress(0,mtpcSearch);
     FDataSet.FState:=mtstSearch;
     FDataSet.FCommon.Lock;
     try
        // Utilize best search method.
        n:=FReferences.Count;
        if n<=0 then
           Result:=0
        else if FOrdered and (not FRowOrder) and (n>20) then
            Result:=BinarySearch(FieldList,0,n-1,KeyRecord,true,Nearest,RespectFilter,Index,Found)
        else
           Result:=SequentialSearch(FieldList,0,n-1,KeyRecord,Nearest,RespectFilter,Index,Found);
     finally
        FDataSet.FCommon.Unlock;
        FDataSet.Progress(100,mtpcSearch);
        FDataSet.FState:=mtstBrowse;
     end;
end;

// Search for specific record in index.
function TkbmIndex.SearchRecord(KeyRecord:PkbmRecord; var Index:integer; RespectFilter:boolean):integer;
var
   First,Last:integer;
   i:integer;
   Found:boolean;
{$IFDEF DOTNET}
   KRec:TkbmRecord;
{$ENDIF}
begin
     Index:=-1;
     Result:=0;

     // Lock the record list for our use, to make sure nobody alters it.
     FDataSet.FCommon.Lock;
     FDataSet.Progress(0,mtpcSearch);
     try
        // Check if anything to search.
        if (FReferences.count>0) then
        begin
             // Assume whole range.
             First:=0;
             Last:=FReferences.count-1;

             // Try to minimize the sequential scan for record.
             if FOrdered and (FReferences.Count>5) then
             begin
                  i:=-1;
                  if FRowOrder then
                  begin
{$IFDEF DOTNET}
                       kRec := TkbmRecord (Marshal.PtrToStructure (KeyRecord,TypeOf(TkbmRecord)));
                       SearchRecordID(KRec.RecordID,Index);
{$ELSE}
                       SearchRecordID(KeyRecord^.RecordID,Index);
{$ENDIF}
                       if Index>=0 then exit;
                  end
                  else
                     BinarySearch(nil,0,FReferences.Count-1,KeyRecord,true,false,RespectFilter,i,Found);
                  if Found and (i>=0) then First:=i;
             end;

             // Sequential scan for correct record id from that point.
{$IFDEF DOTNET}
             kRec := TkbmRecord (Marshal.PtrToStructure (KeyRecord,TypeOf(TkbmRecord)));
             SequentialSearchRecordID(First,Last,KRec.RecordID,Index);
{$ELSE}
             SequentialSearchRecordID(First,Last,KeyRecord^.RecordID,Index);
{$ENDIF}
        end;
     finally
        FDataSet.FCommon.Unlock;
     end;
end;

// Search for specific record ID in row order index only.
function TkbmIndex.SearchRecordID(RecordID:integer; var Index:integer):integer;
begin
     // Try to look for it by binary search.
     // If records are inserted here and there in the index, they will not be sorted
     // as the roworderindex indicates the order the user has put the records in
     // using append and insert. But as a good guess, there should be a good chance
     // of finding a record by a binary search. If it wasnt found, we will try again
     // using a sequential search to be on the safe side.
     Index:=-1;
     Result:=0; // To fix bogus warning from compiler.

     // Lock the record list for our use, to make sure nobody alters it.
     FDataSet.FCommon.Lock;
     try
        if FOrdered and FRowOrder then
        begin
             Result:=BinarySearchRecordID(0,FReferences.Count-1,RecordID,false,Index);
             if Index<0 then
                Result:=BinarySearchRecordID(0,FReferences.Count-1,RecordID,true,Index);
        end;

        if Index<0 then
            Result:=SequentialSearchRecordID(0,FReferences.Count-1,RecordID,Index);
     finally
        FDataSet.FCommon.Unlock;
     end;
end;

// Routines used by FastQuicksort.
procedure TkbmIndex.InternalSwap(const I,J:integer);
var
   t:PkbmRecord;
begin
{$IFDEF DOTNET}
     t:=IntPtr(FReferences[I]);
     FReferences[I]:= FReferences[J];
     FReferences[J]:=t;
{$ELSE}
     t:=FReferences[I];
     FReferences[I]:=FReferences[J];
     FReferences[J]:=t;
{$ENDIF}
end;

{$IFDEF USE_FAST_QUICKSORT}
procedure TkbmIndex.InternalFastQuickSort(const L,R:Integer);
var
   I,J:integer;
   P:PkbmRecord;
begin
     if ((R-L)>4) then
//     if ((R-L)>0) then
     begin
          I:=(R+L) div 2;
          if CompareRecords(FIndexFieldList,PkbmRecord(FReferences[L]),PkbmRecord(FReferences[I]),true,false)>0 then
           InternalSwap(L,I);
          if CompareRecords(FIndexFieldList,PkbmRecord(FReferences[L]),PkbmRecord(FReferences[R]),true,false)>0 then
           InternalSwap(L,R);
          if CompareRecords(FIndexFieldList,PkbmRecord(FReferences[I]),PkbmRecord(FReferences[R]),true,false)>0 then
           InternalSwap(I,R);

          J:=R-1;
          InternalSwap(I,J);
          I:=L;
          P:=PkbmRecord(FReferences[J]);
          while true do
          begin
               Inc(I);
               Dec(J);
               while CompareRecords(FIndexFieldList,PkbmRecord(FReferences[I]),P,true,false) < 0 do Inc(I);
               while CompareRecords(FIndexFieldList,PkbmRecord(FReferences[J]),P,true,false) > 0 do Dec(J);
               if (J<I) then break;
               InternalSwap(I,J);
          end;
          InternalSwap(I,R-1);
          InternalFastQuickSort(L,J);
          InternalFastQuickSort(I+1,R);
     end;
end;

procedure TkbmIndex.InternalInsertionSort(const Lo,Hi:integer);
var
   I,J:integer;
   P:PkbmRecord;
begin
     for I:=Lo+1 to Hi do
     begin
          P:=PkbmRecord(FReferences.Items[I]);
          J:=I;
          while ((J>Lo) and (CompareRecords(FIndexFieldList,PkbmRecord(FReferences[J-1]),P,true,false)>0)) do
          begin
               FReferences[J]:=FReferences[J-1];
               dec(J);
          end;
          FReferences[J]:=P;
     end;
end;

// Sort the record refences using the Fast Quicksort algorithm.
procedure TkbmIndex.FastQuickSort(const L,R:Integer);
begin
     InternalFastQuickSort(L,R);
     InternalInsertionSort(L,R);
     FOrdered:=true;
end;
{$ELSE}

// Sort the record refences using the Quicksort algorithm.
procedure TkbmIndex.QuickSort(L,R:Integer);
var
   I,J:Integer;
   P:PkbmRecord;
begin
     repeat
           I:=L;
           J:=R;
           P:=PkbmRecord(FReferences.Items[(L + R) shr 1]);
           repeat
                 while CompareRecords(FIndexFieldList,PkbmRecord(FReferences[I]),P,true,false) < 0 do Inc(I);
                 while CompareRecords(FIndexFieldList,PkbmRecord(FReferences[J]),P,true,false) > 0 do Dec(J);
                 if I <= J then
                 begin
                      InternalSwap(I,J);
                      Inc(I);
                      Dec(J);
                 end;
           until I>J;
           if L<J then QuickSort(L,J);
           L:=I;
    until I>=R;
    FOrdered:=true;
end;
{$ENDIF}

procedure TkbmIndex.Clear;
begin
     FReferences.Clear;
     FOrdered:=false;
end;

{$IFDEF DOTNET}
function TkbmIndex.FindRecordNumber(const RecordBuffer:IntPtr):integer;
{$ELSE}
function TkbmIndex.FindRecordNumber(const RecordBuffer:PChar):integer;
{$ENDIF}
var
   i:integer;
begin
     for i:=0 to FReferences.Count-1 do
{$IFDEF DOTNET}
         if IntPtr(FReferences[i])=RecordBuffer then
{$ELSE}
         if PChar(FReferences[i])=RecordBuffer then
{$ENDIF}
         begin
              Result:=i;
              exit;
         end;
     Result:=-1;
end;

procedure TkbmIndex.LoadAll;
var
   i:integer;
   p:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Clear;
     FOrdered:=false;

     FDataSet.FCommon.Lock;
     try
        // Set capacity for references and recnolist.
        if not IsFiltered then
           FReferences.Capacity:=FDataSet.FCommon.RecordCount
        else
            FReferences.Capacity:=100;

        // Add the records.
        with FDataSet,FCommon do
        begin
             for i:=0 to FRecords.Count-1 do
             begin
                  p:=PkbmRecord(FRecords.Items[i]);
{$IFDEF DOTNET}
                  Rec:=TkbmRecord(Marshal.PtrToStructure (p,TypeOf(TkbmRecord)) );
{$ENDIF}
                  if p<>nil then
                  begin
{$IFDEF DOTNET}
                       if not (rec.UpdateStatus in FUpdateStatus) or
                          ((rec.UpdateStatus=usDeleted) and (not FDataSet.EnableVersioning)) then continue;
                       if not self.Filter (p) then continue;
{$ELSE}
                       if not (p^.UpdateStatus in FUpdateStatus) or
                          ((p^.UpdateStatus=usDeleted) and (not FDataSet.EnableVersioning)) then continue;
                       if not self.Filter(p) then continue;
{$ENDIF}
                       FReferences.Add(p);
                  end;
             end;
        end;
     finally
        FDataSet.FCommon.Unlock;
     end;
end;

procedure TkbmIndex.ReSort;
var
   i:integer;
begin
     // If not sorted, dont bother to sort the index.
     if FType=mtitNonSorted then
     begin
          if IsRowOrder then FOrdered:=true;
          exit;
     end;

     // Lock the record list for our use, to make sure nobody alters it.
     FDataSet.Progress(0,mtpcSort);
     FDataSet.FState:=mtstSort;
     FDataSet.FCommon.Lock;
     try
        // Sort the index.
{$IFDEF USE_FAST_QUICKSORT}
        FastQuickSort(0,FReferences.Count-1);
{$ELSE}
        QuickSort(0,FReferences.Count-1);
{$ENDIF}

        // If unique index, look for duplicates.
{$IFDEF DOTNET}
        if mtcoUnique in FIndexOptions then
           for i:=1 to FReferences.Count-1 do
               if CompareRecords(FIndexFieldList,IntPtr(FReferences[i-1]),IntPtr(FReferences[i]),false,false)=0 then
                  raise EMemTableDupKey.Create(kbmDupIndex);
{$ELSE}
        if mtcoUnique in FIndexOptions then
           for i:=1 to FReferences.Count-1 do
               if CompareRecords(FIndexFieldList,FReferences[i-1],FReferences[i],false,false)=0 then
                  raise EMemTableDupKey.Create(kbmDupIndex);
{$ENDIF}
     finally
        FDataSet.FCommon.Unlock;
        FDataSet.Progress(100,mtpcSort);
        FDataSet.FState:=mtstBrowse;
     end;
end;

procedure TkbmIndex.Rebuild;
begin
     if FDataset.Active then
     begin
          if not FIsView then LoadAll;
          if FReferences.Count>0 then
             ReSort
          else
             FOrdered:=true;
     end
     else
         FOrdered:=true;

     if (FDataSet.FCurIndex=self) and (FDataSet.FRecNo>=FReferences.Count) then
        FDataSet.FRecNo:=FReferences.Count-1;
end;

// -----------------------------------------------------------------------------------
// TkbmIndexes
// -----------------------------------------------------------------------------------
constructor TkbmIndexes.Create(ADataSet:TkbmCustomMemTable);
begin
     inherited Create;
     FIndexes:=TStringList.Create;
     FDataSet:=ADataSet;
end;

destructor TkbmIndexes.Destroy;
var
   i:integer;
begin
     for i:=0 to FIndexes.count-1 do
         TkbmList(FIndexes.Objects[i]).free;
     FIndexes.free;
     inherited;
end;

// Remove indexes.
procedure TkbmIndexes.Clear;
var
   i:integer;
   lIndex:TkbmIndex;
begin
     for i:=FIndexes.Count-1 downto 0 do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[i]);
          lIndex.Clear;
          if lIndex = FRowOrderIndex then continue;
          if lIndex = FDataSet.FCurIndex then FDataSet.FCurIndex:=FRowOrderIndex;
          if lIndex = FDataSet.FSortIndex then FDataSet.FSortIndex := nil;
          lIndex.free;
          FIndexes.delete(i);
     end;
end;

function TkbmIndexes.Count:integer;
begin
     Result:=FIndexes.Count;
end;

function TkbmIndexes.Get(const IndexName:string):TkbmIndex;
var
   i:integer;
   lIndex:TkbmIndex;
begin
     for i:=0 to FIndexes.Count-1 do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[i]);
          if (UpperCase(lIndex.FName) = UpperCase(IndexName)) then
          begin
               Result:=lIndex;
               exit;
          end;
     end;
     Result:=nil;
end;

function TkbmIndexes.GetIndex(const Ordinal:integer):TkbmIndex;
begin
     Result:=nil;
     if (Ordinal<0) or (Ordinal>=FIndexes.Count) then exit;
     Result:=TkbmIndex(FIndexes.Objects[Ordinal]);
end;

// Lookup first index on specified fieldnames.
function TkbmIndexes.GetByFieldNames(FieldNames:string):TkbmIndex;
var
   i:integer;
   lIndex:TkbmIndex;
begin
     Result:=nil;
     FieldNames:=UpperCase(FieldNames);
     for i:=0 to FIndexes.count-1 do
     begin
         lIndex:=TkbmIndex(FIndexes.Objects[i]);
         if (UpperCase(lIndex.FIndexFields) = FieldNames) then
         begin
              Result:=lIndex;
              break;
         end;
     end;
end;

procedure TkbmIndexes.AddIndex(const Index:TkbmIndex);
begin
     Index.FIndexOfs:=FIndexes.count;
     FIndexes.AddObject(Index.FName,Index);
end;

procedure TkbmIndexes.Add(const IndexDef:TIndexDef);
var
   lIndex:TkbmIndex;
begin
     if (IndexDef.Fields='') then
        raise EMemTableError.Create(kbmMissingNames);

{$IFDEF LEVEL5}
     lIndex:=TkbmIndex.Create(IndexDef,FDataSet);
{$ELSE}
     lIndex:=TkbmIndex.CreateByIndexDef(IndexDef,FDataSet);
{$ENDIF}
     AddIndex(lIndex);
end;

procedure TkbmIndexes.DeleteIndex(const Index:TkbmIndex);
var
   iIndex:integer;
   lIndex:TkbmIndex;
begin
     // Dont allow deletion of roworder index.
     if Index=FRowOrderIndex then exit;
     if Index=Index.FDataSet.FCurIndex then Index.FDataSet.FCurIndex:=FRowOrderIndex;

     for iIndex:=0 to FIndexes.count-1 do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[iIndex]);
          if lIndex=Index then
          begin
               FIndexes.delete(iIndex);
               break;
          end;
     end;

     // Renumber rest indexes.
     while (iIndex<FIndexes.count-1) do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[iIndex]);
          dec(lIndex.FIndexOfs);
          inc(iIndex);
     end;
end;

procedure TkbmIndexes.Delete(const IndexName:string);
var
   lIndex:TkbmIndex;
begin
     lIndex:=Get(IndexName);

     // Dont allow deletion of roworder index.
     if lIndex=FRowOrderIndex then exit;
     if lIndex=FDataSet.FCurIndex then FDataSet.FCurIndex:=FRowOrderIndex;
     DeleteIndex(lIndex);
end;

procedure TkbmIndexes.Empty(const IndexName:string);
var
   lIndex:TkbmIndex;
begin
     // Get reference to index reference list.
     lIndex:=Get(IndexName);
     lIndex.Clear;
end;

procedure TkbmIndexes.EmptyAll;
var
   i:integer;
   lIndex:TkbmIndex;
begin
     for i:=0 to FIndexes.Count-1 do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[i]);
          lIndex.Clear;
     end;
end;

procedure TkbmIndexes.ReBuild(const IndexName:string);
var
   lIndex:TkbmIndex;
begin
     // Get reference to index reference list.
     if not FDataSet.Active then exit;
     lIndex:=Get(IndexName);
     lIndex.Rebuild;


     if not FDataSet.Active then exit;
     lIndex:=Get(IndexName);
     if lIndex = nil then raise EMemTableInvalidLocale.Create(kbmInvalidLocale);
     lIndex.Rebuild;

end;

procedure TkbmIndexes.ReBuildAll;
var
   i:integer;
   lIndex:TkbmIndex;
begin
     for i:=0 to FIndexes.Count-1 do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[i]);
          lIndex.Rebuild;
     end;
end;

procedure TkbmIndexes.MarkAllDirty;
var
   iIndex:integer;
   lIndex:TkbmIndex;
begin
     for iIndex:=0 to FIndexes.Count-1 do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[iIndex]);
          lIndex.FOrdered:=false;
     end;
end;

// Search for keyrecord on specified fields.
// Aut. selects the optimal search method depending if an index is available.
// CurIndex is a reference to the current index, that is the one the Index value will refer
// to as a Result.
function TkbmIndexes.Search(const FieldList:TkbmFieldList; const KeyRecord:PkbmRecord; const Nearest,RespectFilter,AutoAddIdx:boolean; var Index:integer; var Found:boolean):integer;
var
   i:integer;
   s:string;
   pRec:PkbmRecord;
   idxFound:boolean;
   ix:TkbmIndex;
   fl:TkbmFieldList;
begin
     // Check for index to search on.
     Index:=-1;
     Found:=false;
     Result:=0;

     // Create merger of the options of the given and the index field list and use it.
     fl:=TkbmFieldList.Create;
     try
        if FDataSet.FCurIndex.FOrdered and (FDataSet.FCurIndex.FReferences.Count>20) then
        begin
             // Look for an index which can be used.
             idxFound:=false;
             for i:=FIndexes.Count-1 downto 0 do
                 if TkbmIndex(FIndexes.Objects[i]).FOrdered and
                    FDataSet.IsFieldListsBegin(TkbmIndex(FIndexes.Objects[i]).FIndexFieldList,FieldList) then
                 begin
                      idxFound:=true;
                      break;
                 end;

             // If no index found, optionally add one.
             if not idxFound and AutoAddIdx then
             begin
                  // Build new string of fieldnames for new index.
                  s:=FieldList.Fields[0].FieldName;
                  for i:=1 to FieldList.Count-1 do
                      s:=s+';'+FieldList.Fields[i].FieldName;

                  // Add new index.
                  FDataSet.AddIndex(kbmAutoIndex+s,s,[ixCaseInsensitive]);
                  idxFound:=true;
                  i:=FIndexes.Count-1;
             end;

             // If found an index to search on.
             if idxFound then
             begin
                  ix:=TkbmIndex(FIndexes.Objects[i]);

                  // Merge two fieldlists options.
                  FieldList.AssignTo(fl);
                  ix.FIndexFieldList.MergeOptionsTo(fl);

                  //ix.FIndexFieldList.AssignTo(fl);
                  //FieldList.MergeOptionsTo(fl);

                  // Search.
                  Result:=ix.Search(fl,KeyRecord,Nearest,RespectFilter,Index,Found);

                  // Check if found record.
                  if ((Result=0) or (Nearest and (Result<0))) and
                     (Index>=0) and (Index<ix.FReferences.Count) then
                  begin
                       // Check if it wasnt current index that was searched. Then have to research on current.
                       if FDataSet.FCurIndex<>ix then
                       begin
                            // Do 2nd search.
{$IFDEF DOTNET}
                            Result:=FDataSet.FCurIndex.SearchRecord(IntPtr(ix.References.Items[Index]),Index,RespectFilter);
{$ELSE}
                            Result:=FDataSet.FCurIndex.SearchRecord(ix.References.Items[Index],Index,RespectFilter);
{$ENDIF}
                          if Index>=ix.FReferences.Count then
                               Found:=false;
                       end;
                  end
                  else
                      Found:=false;
                  exit;
             end;
        end;

        // No compatible indexes found, do a sequential search on current index.
        with FDataSet.FCurIndex do
        begin
             // Use given fieldlist as base instead of index field list. Then merge indexfieldlist options in.
             FieldList.AssignTo(fl);
             FIndexFieldList.MergeOptionsTo(fl);

             i:=0;
             while i<FReferences.Count do
             begin
                  // Check if to recalc before compare.
                  pRec:=PkbmRecord(FReferences.Items[i]);
                  with FDataSet do
                  begin
                       if FRecalcOnIndex then
                       begin
                            //fill calc fields part of buffer
                            __ClearCalcFields({$IFDEF DOTNET}pRec{$ELSE}PChar(pRec){$ENDIF});
                            __GetCalcFields({$IFDEF DOTNET}pRec{$ELSE}PChar(pRec){$ENDIF});
                       end;
                  end;

                  // Check key record equal to record.
                  Result:=CompareRecords(fl,KeyRecord,pRec,false,Nearest);

                  // Check if found match but filtered.
                  if (Result=0) and FDataset.IsFiltered and RespectFilter then
                  begin
                       if not FDataset.FilterRecord(pRec,false) then
                       begin
                            inc(i);
                            continue;
                       end;
                  end;

                  // Check if nearest or match.
                  if (Result=0) or (Nearest and (Result<0)) then
                  begin
                       Index:=i;
                       Found:=true;
                       exit;
                  end;

                  inc(i);
             end;
        end;
     finally
        fl.Free;
     end;
end;

// Check a record for acceptance regarding indexdefinitions.
procedure TkbmIndexes.CheckRecordUniqueness(const ARecord,ActualRecord:PkbmRecord);
var
   i:integer;
   iResult:integer;
   lIndex:TkbmIndex;
   Found:boolean;
begin
     // If indexes not enabled, dont make uniqueness test.
     if not FDataSet.FEnableIndexes then exit;

     // Check all indexes for uniqueness.
     for i:=0 to FIndexes.Count-1 do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[i]);
          with lIndex do
          begin
               if not FEnabled then continue;
{$IFNDEF LEVEL3}
               if (mtcoNonMaintained in FIndexOptions) then continue;
{$ENDIF}

               // Check if unique index and duplicate key, complain.
{$IFDEF DOTNET}
               if (mtcoUnique in FIndexOptions)
                  and ((Search(nil,ARecord,false,false,iResult,Found)=0) and Found and (iResult>=0))
                  and (IntPtr(lIndex.FReferences[iResult]) <> ActualRecord) then
                  raise EMemTableDupKey.Create(kbmDupIndex);
{$ELSE}
               if (mtcoUnique in FIndexOptions)
                  and ((Search(nil,ARecord,false,false,iResult,Found)=0) and Found and (iResult>=0))
                  and (lIndex.FReferences[iResult] <> ActualRecord) then
                  raise EMemTableDupKey.Create(kbmDupIndex);
{$ENDIF}
          end;
     end;
end;

// Call this during insert, append, edit or delete of record to update the index lists.
// OldRecord contains a reference to the actual 'physical' record.
// NewRecord points to a buffer which contains the new value soon to be copied into OldRecord. (Edit)
// NewRecord is nil on append or insert since OldRecord allready will contain values.
// RecordPos specifies current FRecNo.
// Returns pos in current index for operation.
procedure TkbmIndexes.ReflectToIndexes(const How:TkbmIndexUpdateHow; const OldRecord,NewRecord:PkbmRecord; const RecordPos:integer; const DontVersion:boolean);
var
   i,ni:integer;
   lIndex:TkbmIndex;
   IsRowOrderIndex,IsCurIndex,IsIndexesEnabled:boolean;
   iInsert,iDelete:integer;
   DoAppend:boolean;
   Found:boolean;
   n,m:integer;
{$IFDEF DOTNET}
   nRec,oRec:TkbmRecord;
{$ENDIF}
begin
     // Loop through all indexes.
     ni:=FIndexes.Count-1;
     for i:=0 to ni do
     begin
          lIndex:=TkbmIndex(FIndexes.Objects[i]);

          IsRowOrderIndex:=(lIndex = FRowOrderIndex);
          IsCurIndex:=(lIndex = FDataSet.FCurIndex);
          IsIndexesEnabled:=FDataset.FEnableIndexes;

          with lIndex do
          begin
               // Check if to skip updating this index. Never skip if deleting on the current index.
               if {$IFNDEF LEVEL3}(mtcoNonMaintained in FIndexOptions) or {$ENDIF}
                  ((not (IsIndexesEnabled and lIndex.Enabled)) and ((How<>mtiuhDelete) or (not IsCurIndex))) then
               begin
                    // Roworder indexes will still be ordered during an edit with indexes disabled.
                    if (How<>mtiuhEdit) or (not IsRowOrder) then FOrdered:=false;
                    continue;
               end;
               FOrdered:=true;

               // Check how to update index.
               case How of
                    mtiuhEdit:
                       begin
                            // Is it the roworder index? Dont do anything since it wont change anything.
                            if IsRowOrderIndex then continue;

                            // Do not update indexes if key has not changed unless updatestatus filtering is enabled.
                            if (usModified in FUpdateStatus) and (lIndex.CompareRecords(lIndex.FIndexFieldList,OldRecord,NewRecord,false,false)=0) then
                            begin
{$IFDEF DOTNET}
                                 nRec := TkbmRecord (Marshal.PtrToStructure(NewRecord,TypeOf(TkbmRecord)));
                                 if IsCurIndex then FDataset.FReposRecNo:=NRec.RecordNo;
{$ELSE}
                                 if IsCurIndex then FDataset.FReposRecNo:=NewRecord.RecordNo;
{$ENDIF}
                                 continue;
                            end;

                            // Search the original position.
                            // Is it the current index, then use FRecNo, otherwise look for it.
                            if IsCurIndex and (RecordPos>=0) then
                               iDelete:=RecordPos
                            else
                            begin
                                 iDelete:=-1;
                                 SearchRecord(OldRecord,iDelete,false);
                            end;
                            // Check if didnt find original record in index, dont try to delete it.
                            // Situation can occur if several tables are attached together and
                            // one of the tables have filtered indexes, but the other not.
                            // Then changing a value in the non filtered index on one table will
                            // Result in a request to update the filtered index on the other table.
                            // And in that table, the record wont be found because it wasnt there in
                            // the first place because of the filter.
                            if iDelete>=0 then
                               FReferences.Delete(iDelete);

                            // Check if filtering.
                            if FIsFiltered and (not Filter(NewRecord)) then continue;

                            // Check if modified not allowed by updatestatus filter.
                            if not (usModified in FUpdateStatus) then continue;

                            // If any references left, look for nearest insertion place.
                            iInsert:=-1;
                            Search(nil,NewRecord,true,false,iInsert,Found);

                            // If found insertion place, insert.
                            if iInsert>=0 then
                               // Insert the reference at new place.
                               FReferences.Insert(iInsert,OldRecord)
                            else
                               // Add reference to list.
                               iInsert:=FReferences.Add(OldRecord);

                            if IsCurIndex then
                            begin
                                 FDataset.FReposRecNo:=iInsert;
{$IFDEF DOTNET}
                                 oRec := TkbmRecord (Marshal.PtrToStructure(OldRecord,typeOf(TkbmRecord)));
                                 ORec.RecordNo:=iInsert;
                                 Marshal.StructureToPtr(oRec,OldRecord,false);
{$ELSE}
                                 OldRecord^.RecordNo:=iInsert;
{$ENDIF}
                            end;
                       end;

                    mtiuhInsert:
                       begin
                            // Check if filtering.
                            if FIsFiltered and (not Filter(NewRecord)) then continue;

                            // Check if inserted not allowed by updatestatus filter.
                            if not (usInserted in FUpdateStatus) then continue;

                            // Is it the roworder index? Is it the same as the one we are looking at?
                            if IsRowOrderIndex then
                            begin
                                 if IsCurIndex then
                                 begin
                                      if RecordPos<0 then
                                         DoAppend:=true
                                      else
                                      begin
                                           iInsert:=RecordPos-1;
                                           DoAppend:=false;
                                      end;
                                 end
                                 else
                                 begin
                                      iInsert:=-1;
                                      DoAppend:=true;
                                 end;
                            end
                            else
                            begin
                                 n:=FReferences.Count;
                                 if n>0 then
                                 begin
                                      iInsert:=-1;
                                      m:=Search(nil,NewRecord,true,false,iInsert,Found);
                                      DoAppend:=(m>0) and (iInsert>=n-1)
                                 end
                                 else
                                     DoAppend:=true;
                            end;

                            // Figure out if to append or to insert to index.
                            if DoAppend then
                            begin
                                 // Append reference to index.
                                 iInsert:=FReferences.Add(NewRecord);
                            end
                            else
                            begin
                                 // Insert reference.
                                 if iInsert<0 then iInsert:=0;
                                 FReferences.Insert(iInsert,NewRecord);
                            end;

                            if IsCurIndex then
                            begin
                                 FDataset.FReposRecNo:=iInsert;
{$IFDEF DOTNET}
                                 nRec := TkbmRecord(Marshal.PtrToStructure(NewRecord,TypeOf(TkbmRecord)));
                                 NRec.RecordNo:=iInsert;
                                 Marshal.StructureToPtr(nRec,NewRecord,false);
{$ELSE}
                                 NewRecord^.RecordNo:=iInsert;
{$ENDIF}
                            end;
                       end;

                    mtiuhDelete:
                       begin
                            // Check if to leave deleted record in index (only a point if versioning.
                            if (usDeleted in FUpdateStatus) and (FDataSet.EnableVersioning) and (not DontVersion) then
                            begin
                                 // Check if this index contained original record or not.
                                 // If it didnt, we have to insert it now.

{$IFDEF DOTNET}
                                 oRec := TkbmRecord (Marshal.PtrToStructure(OldRecord,TypeOf(TkbmRecord)));
                                 if not (ORec.UpdateStatus in FUpdateStatus) then
{$ELSE}
                                 if not (OldRecord^.UpdateStatus in FUpdateStatus) then
{$ENDIF}
                                 begin

                                      // Check record ok due to other filters.
                                      if (not FIsFiltered) or Filter(OldRecord) then
                                      begin
                                           // Figure out where to place record in index.
                                           n:=FReferences.Count;
                                           if n>0 then
                                           begin
                                                iInsert:=-1;
                                                m:=Search(nil,OldRecord,true,false,iInsert,Found);
                                                DoAppend:=(m>0) and (iInsert>=n-1)
                                           end
                                           else
                                               DoAppend:=true;

                                           // Figure out if to append or to insert to index.
                                           if DoAppend then
                                           begin
                                                // Append reference to index.
                                                iInsert:=FReferences.Add(OldRecord);
                                           end
                                           else
                                           begin
                                                // Insert reference.
                                                if iInsert<0 then iInsert:=0;
                                                FReferences.Insert(iInsert,OldRecord);
                                           end;

                                           if IsCurIndex then
                                           begin
                                                FDataset.FReposRecNo:=iInsert;
{$IFDEF DOTNET}
                                                ORec := TkbmRecord (Marshal.PtrToStructure(OldRecord,TypeOf(TkbmRecord)));
                                                ORec.RecordNo:=iInsert;
                                                Marshal.StructureToPtr(ORec,OldRecord,false);
{$ELSE}
                                                OldRecord^.RecordNo:=iInsert;
{$ENDIF}
                                           end;
                                      end;
                                 end;
                                 // Dont remove it from this index.
                                 continue;
                            end;

                            if FReferences.Count>0 then
                            begin
                                 iDelete:=-1;

                                 // Is it the roworder index?
{$IFDEF DOTNET}
                                 oRec:=TkbmRecord (Marshal.PtrToStructure(OldRecord,TypeOf(TkbmRecord)));
                                 if IsRowOrderIndex then
                                    SearchRecordID(ORec.RecordID,iDelete)
                                 else
                                     SearchRecord(OldRecord,iDelete,false);
                                 if iDelete>=0 then
                                    FReferences.Delete(iDelete);
{$ELSE}
                                 if IsRowOrderIndex then
                                    SearchRecordID(OldRecord^.RecordID,iDelete)
                                 else
                                     SearchRecord(OldRecord,iDelete,false);
                                 if iDelete>=0 then
                                    FReferences.Delete(iDelete);
{$ENDIF}
                                 if IsCurIndex then FDataset.FReposRecNo:=iDelete;
                            end;
                       end;
               end;
          end;
     end;
end;

// -----------------------------------------------------------------------------------
// TkbmCustomMemTable
// -----------------------------------------------------------------------------------

constructor TkbmCustomMemTable.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     FTableID:=0;
     FCommon:=TkbmCommon.Create(self);

     // Now attach to the common tablestructure.
     FCommon.AttachTable(self);

     // Create indexlist.
     FIndexes:=TkbmIndexes.Create(self);

     // Add row order index to indexlist.
     with FIndexes do
     begin
          FRowOrderIndex:=TkbmIndex.Create(kbmRowOrderIndex,self,'',[],mtitNonSorted,true);
          FRowOrderIndex.FRowOrder:=true;
          AddIndex(FRowOrderIndex);
     end;

     // Default all load/save operations should load/save all records.
     FLoadLimit:=-1;
     FLoadCount:=-1;
     FLoadedCompletely:=false;
     FSaveLimit:=-1;
     FSaveCount:=-1;
     FSavedCompletely:=false;

     // Suppose standalone table.
     // If FAttachedTo points to another memtable, FRecords and FDeletedRecords will point
     // to the other tables FRecords and FDeletedRecords.
//     FAttachedChildren:=TThreadList.Create;
     FAttachedTo:=nil;
     FAttachedAutoRefresh:=true;

     FAutoReposition:=false;
{$IFNDEF LEVEL3}
     FDesignActivation:=true;
{$ENDIF}

     FRecNo:=-1;

     FPersistent:=false;
     FRecalcOnIndex:=false;
     FRecalcOnFetch:=true;
     FRangeIgnoreNullKeyValues:=true;

     FProgressFlags:=[mtpcSave,mtpcLoad,mtpcCopy];
     FState:=mtstBrowse;

     Inherited BeforeInsert:=_InternalBeforeInsert;

{$IFDEF LEVEL5}
     FFilterParser:=nil;
{$ENDIF}

     FIndexList:=TkbmFieldList.Create;
     FMasterIndexList:=TkbmFieldList.Create;
     FDetailIndexList:=TkbmFieldList.Create;
     FIndexDefs:=TIndexDefs.Create(Self);
     FSortIndex:=nil;
     FEnableIndexes:=true;
     FAutoAddIndexes:=false;

     FStoreDataOnForm:=false;
     FTempDataStorage:=nil;

     FAutoUpdateFieldVariables:=false;

     FMasterLink:=TMasterDataLink.Create(Self);
     FMasterLink.OnMasterChange:=MasterChanged;
     FMasterLink.OnMasterDisable:=MasterDisabled;
     FMasterLinkUsed:=true;
end;

destructor TkbmCustomMemTable.Destroy;
begin
     // Check if temporary data storage left over.
     if FTempDataStorage<>nil then FTempDataStorage.free;
     FTempDataStorage:=nil;

{$IFDEF LEVEL5}
     // Delete filterbuffers if assigned.
     FreeFilter(FFilterParser);
{$ENDIF}

     // Must be before deletion of records, otherwise it fails.
     inherited Destroy;

     // Delete allocated memory.
     FMasterLink.free;     FMasterLink:=nil;
     FIndexList.free;      FIndexList:=nil;
     FMasterIndexList.Free;FMasterIndexList:=nil;
     FDetailIndexList.Free;FDetailIndexList:=nil;

     // Dont delete shared data if attached to it.
     FCommon.DeAttachTable(Self);
     if FAttachedTo=nil then FCommon.free;

     // Free index definitions.
     FIndexDefs.free;      FIndexDefs:=nil;

     // Free indexreferences.
     FIndexes.free;
end;

procedure TkbmCustomMemTable.__ClearCalcFields(Buffer:{$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF});
begin
     ClearCalcFields(buffer);
end;

procedure TkbmCustomMemTable.__GetCalcFields(Buffer:{$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF});
begin
     GetCalcFields (Buffer);
end;

function TkbmCustomMemTable.__CalcFieldsSize:integer;
begin
     Result:=CalcFieldsSize;
end;

procedure TkbmCustomMemTable.__ClearBuffers;
begin
     ClearBuffers;
end;

function TkbmCustomMemTable.__SetTempState(const Value: TDataSetState): TDataSetState;
begin
     Result:=SetTempState(Value);
end;


procedure TkbmCustomMemTable.__RestoreState(const Value: TDataSetState);
begin
     RestoreState(Value);
end;

procedure TkbmCustomMemTable.__SetBlockReadSize(Value:integer);
begin
     SetblockReadSize(Value);
end;

procedure TkbmCustomMemTable.Lock;
begin
     FCommon.Lock;
     FCommon.FThreadProtected:=true;
end;

procedure TkbmCustomMemTable.Unlock;
begin
     FCommon.FThreadProtected:=false;
     FCommon.Unlock;
end;

procedure TkbmCustomMemTable.Loaded;
begin
{$IFNDEF LEVEL3}
     if not FDesignActivation then
        FInterceptActive:=true;
     try
        inherited Loaded;
     finally
        FInterceptActive:=false;
     end;
{$ELSE}
     inherited Loaded;
{$ENDIF}
end;

{$IFDEF LEVEL5}

procedure TkbmCustomMemTable.DataEvent(Event: TDataEvent; Info:{$IFDEF DOTNET}TObject{$ELSE}Longint{$ENDIF});
begin
     if FCommon.FThreadProtected then exit;
     inherited DataEvent(Event,Info);
end;
{$ENDIF}

{$IFDEF LEVEL4}
procedure TkbmCustomMemTable.SetActive(Value:boolean);
begin
     if FInterceptActive and Value then exit;
     if (not Value) and (Persistent) then SavePersistent; 
     inherited SetActive(Value);
end;
{$ENDIF}

procedure TkbmCustomMemTable._InternalBeforeInsert(DataSet:TDataSet);
begin
     FInsertRecNo:=GetRecNo;
     if Assigned(FBeforeInsert) then FBeforeInsert(DataSet);
end;

procedure TkbmCustomMemTable.Progress(Pct:integer; Code:TkbmProgressCode);
begin
     if Assigned(FOnProgress) and (Code in FProgressFlags) then FOnProgress(self,Pct,Code);
end;

// Get current component version.
function TkbmCustomMemTable.GetVersion:string;
begin
     Result:=COMPONENT_VERSION;
end;

// Handle saving and loading static data from the form.
procedure TkbmCustomMemTable.DefineProperties(Filer:TFiler);
begin
     inherited DefineProperties(Filer);
     Filer.DefineBinaryProperty('Data', ReadData, WriteData, FStoreDataOnForm);
end;

procedure TkbmCustomMemTable.ReadData(Stream:TStream);
begin
     if FTempDataStorage<>nil then
     begin
          FTempDataStorage.free;
          FTempDataStorage:=nil;
     end;
     FTempDataStorage:=TMemoryStream.Create;
     FTempDataStorage.LoadFromStream(Stream);
end;

procedure TkbmCustomMemTable.WriteData(Stream:TStream);
begin
     if Active then
        InternalSaveToStreamViaFormat(Stream,FFormFormat);
end;

// Update the properties if some component we are dependent on is removed.
procedure TkbmCustomMemTable.Notification(AComponent: TComponent; Operation: TOperation);
begin
     if Operation=opRemove then
     begin
          // Check if this table.
          if AComponent=self then
          begin
               // Close table.
//               if Active then SavePersistent;
               Close;
          end;
          if (FMasterLink<>nil) and (AComponent=FMasterLink.DataSource) then
             FMasterLink.DataSource:=nil;
          if AComponent=FDeltaHandler then
          begin
               (AComponent as TkbmCustomDeltaHandler).FDataSet:=nil;
               FDeltaHandler:=nil;
          end;
          if AComponent=FAttachedTo then FAttachedTo:=nil;
          if AComponent=FDefaultFormat then FDefaultFormat:=nil;
          if AComponent=FCommaTextFormat then FCommaTextFormat:=nil;
          if AComponent=FPersistentFormat then FPersistentFormat:=nil;
          if AComponent=FFormFormat then FFormFormat:=nil;
          if AComponent=FAllDataFormat then FAllDataFormat:=nil;
     end;
     inherited Notification(AComponent, Operation);
end;

// Set minimum autoinc value.
procedure TkbmCustomMemTable.SetAutoIncMinValue(AValue:longint);
begin
     FCommon.AutoIncMin:=AValue;
end;

function TkbmCustomMemTable.GetAutoIncValue:longint;
begin
     Result:=FCommon.AutoIncMax;
end;

function TkbmCustomMemTable.GetAutoIncMin:longint;
begin
     Result:=FCommon.AutoIncMin;
end;

procedure TkbmCustomMemTable.SetLoadedCompletely(Value:boolean);
begin
     FLoadedCompletely:=Value;
end;

procedure TkbmCustomMemTable.SetTableState(AValue:TkbmState);
begin
     FState:=AValue;
end;

// Set performance.
procedure TkbmCustomMemTable.SetPerformance(AValue:TkbmPerformance);
begin
     FCommon.Performance:=AValue;
end;

function TkbmCustomMemTable.GetPerformance:TkbmPerformance;
begin
     Result:=FCommon.Performance;
end;

// Set versioning mode.
procedure TkbmCustomMemTable.SetVersioningMode(AValue:TkbmVersioningMode);
begin
     FCommon.VersioningMode:=AValue;
end;

function TkbmCustomMemTable.GetVersioningMode:TkbmVersioningMode;
begin
     Result:=FCommon.VersioningMode;
end;

// Set versioning enabled.
procedure TkbmCustomMemTable.SetEnableVersioning(AValue:boolean);
begin
     FCommon.EnableVersioning:=AValue;
end;

function TkbmCustomMemTable.GetEnableVersioning:boolean;
begin
     Result:=FCommon.EnableVersioning;
end;

procedure TkbmCustomMemTable.SetStandalone(AValue:boolean);
begin
     FCommon.Lock;
     try
        if AValue=FCommon.Standalone then exit;

        // Check if open.
        if Active then
           raise EMemTableError.Create(kbmTableMustBeClosed);

        // Check if myself attached.
        if FAttachedTo<>nil then
           raise EMemTableError.Create(kbmIsAttached);

        FCommon.Standalone:=AValue;
     finally
        FCommon.Unlock;
     end;
end;

function TkbmCustomMemTable.GetStandalone:boolean;
begin
     Result:=FCommon.GetStandalone;
end;

procedure TkbmCustomMemTable.SetCapacity(AValue:longint);
begin
     FCommon.Capacity:=AValue;
end;

function TkbmCustomMemTable.GetCapacity:longint;
begin
     Result:=FCommon.Capacity;
end;

function TkbmCustomMemTable.GetAttachMaxCount:integer;
begin
     Result:=FCommon.AttachMaxCount;
end;

function TkbmCustomMemTable.GetAttachCount:integer;
begin
     Result:=FCommon.AttachCount;
end;

procedure TkbmCustomMemTable.SetAttachMaxCount(AValue:integer);
begin
     FCommon.AttachMaxCount:=AValue;
end;

function TkbmCustomMemTable.GetIsDataModified:boolean;
begin
     Result:=FCommon.IsDataModified;
end;

procedure TkbmCustomMemTable.SetIsDataModified(AValue:boolean);
begin
     FCommon.IsDataModified:=AValue;
end;

function TkbmCustomMemTable.GetTransactionLevel:integer;
begin
     Result:=FCommon.TransactionLevel;
end;

function TkbmCustomMemTable.GetIndexes:TkbmIndexes;
begin
     if assigned(FIndexes) then Result:=FIndexes
       else Result := nil;
end;

function TkbmCustomMemTable.GetDeletedRecordsCount:integer;
begin
     Result:=FCommon.GetDeletedRecordsCount;
end;

// Set transaction level.
procedure TkbmCustomMemTable.StartTransaction;
begin
     if not active then exit;
     if (not IsVersioning) or (VersioningMode <> mtvmAllSinceCheckPoint) then
        raise EMemTableError.Create(kbmTransactionVersioning);

     FCommon.IncTransactionLevel;
end;

// Rollback transaction.
procedure TkbmCustomMemTable.Rollback;
begin
     FCommon.Lock;
     try
        // Check if transaction started.
        if not active or (FCommon.FTransactionLevel<=0) then exit;
        Cancel;
        UpdateCursorPos;
        FCommon.RollBack;
        FCommon.DecTransactionLevel;
        FCommon.RebuildIndexes;
        CursorPosChanged;
        ClearBuffers;
        Refresh;
     finally
        FCommon.Unlock;
     end;
end;

// Commit transaction.
procedure TkbmCustomMemTable.Commit;
begin
     FCommon.Lock;
     try
        // Check if transaction started.
        if not active or (FCommon.FTransactionLevel<=0) then exit;
        FCommon.Commit;
        FCommon.DecTransactionLevel;
        FCommon.RebuildIndexes;
        Refresh;
     finally
        FCommon.Unlock;
     end;
end;

procedure TkbmCustomMemTable.Undo;
begin
     if not EnableVersioning then exit;
     FCommon.Undo(GetActiveRecord);
     Refresh;
end;

// Get number of versions of the current record.
function TkbmCustomMemTable.GetVersionCount:integer;
var
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Result:=1;

     FCommon.Lock;
     try
        if not Active then raise EMemTableError.Create(kbmNoCurrentRecord);
        pRec:=GetActiveRecord;
        if pRec=nil then raise EMemTableError.Create(kbmNoCurrentRecord);

{$IFDEF DOTNET}
        Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        while Rec.PrevRecordVersion<>nil do
        begin
             inc(Result);
             pRec:=Rec.PrevRecordVersion;
             Rec:=TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        end;
{$ELSE}
        while pRec^.PrevRecordVersion<>nil do
        begin
             inc(Result);
             pRec:=pRec^.PrevRecordVersion;
        end;
{$ENDIF}
     finally
        FCommon.Unlock;
     end;
end;

// Get data of a specific version of a record.
function TkbmCustomMemTable.GetVersionFieldData(Field:TField; Version:integer):variant;
var
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Result:=Null;
     FCommon.Lock;
     try
        if not Active then raise EMemTableError.Create(kbmNoCurrentRecord);
        pRec:=GetActiveRecord;
        if pRec=nil then raise EMemTableError.Create(kbmNoCurrentRecord);

{$IFDEF DOTNET}
        Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        while (Version>0) and (Rec.PrevRecordVersion<>nil) do
        begin
             dec(Version);
             pRec:=Rec.PrevRecordVersion;
             Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        end;
{$ELSE}
        while (Version>0) and (pRec^.PrevRecordVersion<>nil) do
        begin
             dec(Version);
             pRec:=pRec^.PrevRecordVersion;
        end;
{$ENDIF}

        FOverrideActiveRecordBuffer:=pRec;
        try
           Result:=Field.AsVariant;
        finally
           FOverrideActiveRecordBuffer:=nil;
        end;
     finally
        FCommon.Unlock;
     end;
end;

// Get TUpdateStatus of a specific version of a record.
function TkbmCustomMemTable.GetVersionStatus(Version:integer):TUpdateStatus;
var
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Result:=usUnmodified;
     FCommon.Lock;
     try
        if not Active then raise EMemTableError.Create(kbmNoCurrentRecord);
        pRec:=GetActiveRecord;
        if pRec=nil then raise EMemTableError.Create(kbmNoCurrentRecord);

{$IFDEF DOTNET}
        Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        while (Version>0) and (Rec.PrevRecordVersion<>nil) do
        begin
             dec(Version);
             pRec:=Rec.PrevRecordVersion;
             Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        end;
        Result:=Rec.UpdateStatus;
{$ELSE}
        while (Version>0) and (pRec^.PrevRecordVersion<>nil) do
        begin
             dec(Version);
             pRec:=pRec^.PrevRecordVersion;
        end;
        Result:=pRec^.UpdateStatus;
{$ENDIF}
     finally
        FCommon.Unlock;
     end;
end;

function TkbmCustomMemTable.SetVersionFieldData(Field:TField; AVersion:integer; AValue:variant):variant;
var
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Result:=Null;
     FCommon.Lock;
     try
        if not Active then raise EMemTableError.Create(kbmNoCurrentRecord);
        pRec:=GetActiveRecord;
        if pRec=nil then raise EMemTableError.Create(kbmNoCurrentRecord);

{$IFDEF DOTNET}
        Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        while (AVersion>0) and (Rec.PrevRecordVersion<>nil) do
        begin
             dec(AVersion);
             pRec:=Rec.PrevRecordVersion;
             Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        end;
{$ELSE}
        while (AVersion>0) and (pRec^.PrevRecordVersion<>nil) do
        begin
             dec(AVersion);
             pRec:=pRec^.PrevRecordVersion;
        end;
{$ENDIF}

        FOverrideActiveRecordBuffer:=pRec;
        try
           Result:=Field.Value;
           Field.Value:=AValue;
        finally
           FOverrideActiveRecordBuffer:=nil;
        end;
     finally
        FCommon.Unlock;
     end;
end;

function TkbmCustomMemTable.SetVersionStatus(AVersion:integer; AUpdateStatus:TUpdateStatus):TUpdateStatus;
var
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Result:=usUnmodified;
     FCommon.Lock;
     try
        if not Active then raise EMemTableError.Create(kbmNoCurrentRecord);
        pRec:=GetActiveRecord;
        if pRec=nil then raise EMemTableError.Create(kbmNoCurrentRecord);

{$IFDEF DOTNET}
        Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        while (AVersion>0) and (Rec.PrevRecordVersion<>nil) do
        begin
             dec(AVersion);
             pRec:= Rec.PrevRecordVersion;
             Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        end;

        Result:=Rec.UpdateStatus;
        Rec.UpdateStatus:=AUpdateStatus;
        Marshal.StructureToPtr(Rec,pRec,false);
{$ELSE}
        while (AVersion>0) and (pRec^.PrevRecordVersion<>nil) do
        begin
             dec(AVersion);
             pRec:=pRec^.PrevRecordVersion;
        end;

        Result:=pRec^.UpdateStatus;
        pRec^.UpdateStatus:=AUpdateStatus;
{$ENDIF}

     finally
        FCommon.Unlock;
     end;
end;

{$IFDEF LEVEL5}
function TkbmCustomMemTable.AddIndex(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet):TkbmIndex;
{$ELSE}
function TkbmCustomMemTable.AddIndex2(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet):TkbmIndex;
{$ENDIF}
var
   Index:TkbmIndex;
begin
     FIndexDefs.Add(Name,Fields,Options);
     FIndexDefs.Updated:=true;
     try
        Index:=TkbmIndex.Create(Name,self,Fields,IndexOptions2CompareOptions(Options),mtitSorted,false);
        Index.FUpdateStatus:=AUpdateStatus;
        Indexes.AddIndex(Index);
        UpdateIndexes;
        Result:=Index;
     except
        DeleteIndex(Name);
        UpdateIndexes;
        raise;
     end;
end;

{$IFDEF LEVEL5}
function TkbmCustomMemTable.AddFilteredIndex(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet; Filter:string; FilterOptions:TFilterOptions; FilterFunc:TkbmOnFilterIndex {$ifdef LEVEL5} = nil{$endif}):TkbmIndex;
{$ELSE}
function TkbmCustomMemTable.AddFilteredIndex2(const Name, Fields: string; Options: TIndexOptions; AUpdateStatus:TUpdateStatusSet; Filter:string; FilterOptions:TFilterOptions; FilterFunc:TkbmOnFilterIndex):TkbmIndex;
{$ENDIF}
var
   Index:TkbmIndex;
begin
     FIndexDefs.Add(Name,Fields,Options);
     FIndexDefs.Updated:=true;
     try
        Index:=TkbmIndex.Create(Name,self,Fields,IndexOptions2CompareOptions(Options),mtitSorted,false);
        Index.FIsFiltered:=true;
        Index.FUpdateStatus:=AUpdateStatus;
{$IFDEF LEVEL5}
        if Filter<>'' then
           BuildFilter(Index.FFilterParser,Filter,FilterOptions)
        else
            Index.FFilterParser:=nil;
{$ENDIF}
        Index.FFilterFunc:=FilterFunc;
        Indexes.AddIndex(Index);
        UpdateIndexes;
        Result:=Index;
     except
        DeleteIndex(Name);
        UpdateIndexes;
        raise;
     end;
end;

function TkbmCustomMemTable.AddIndex(const Name, Fields: string; Options: TIndexOptions):TkbmIndex;
begin
{$IFDEF LEVEL5}
     Result:=AddIndex(Name,Fields,Options,[usInserted,usModified,usUnmodified]);
{$ELSE}
     Result:=AddIndex2(Name,Fields,Options,[usInserted,usModified,usUnmodified]);
{$ENDIF}
end;

function TkbmCustomMemTable.AddFilteredIndex(const Name, Fields: string; Options: TIndexOptions; Filter:string; FilterOptions:TFilterOptions; FilterFunc:TkbmOnFilterIndex {$ifdef LEVEL6} = nil{$endif}):TkbmIndex;
begin
{$IFDEF LEVEL5}
     Result:=AddFilteredIndex(Name,Fields,Options,[usInserted,usModified,usUnmodified],Filter,FilterOptions,FilterFunc);
{$ELSE}
     Result:=AddFilteredIndex2(Name,Fields,Options,[usInserted,usModified,usUnmodified],Filter,FilterOptions,FilterFunc);
{$ENDIF}
end;

procedure TkbmCustomMemTable.DeleteIndex(const Name: string);
var
   i:integer;
{$IFNDEF LEVEL5}
   id:TIndexDefs;
{$ENDIF}
begin
{$IFDEF LEVEL5}
     i:=FIndexDefs.IndexOf(Name);
     if i>=0 then
     begin
          FIndexDefs.Delete(i);
          UpdateIndexes;
     end;
{$ELSE}
{$IFDEF LEVEL3}
     // D3 missing delete method. Need to rebuild indexdefs.
     id:=TIndexDefs.Create(self);
     try
        id.Assign(FIndexDefs);
        FIndexDefs.Clear;
        for i:=0 to id.Count-1 do
            if id.Items[i].Name<>Name then
               FIndexDefs.Add(id.Items[i].Name,id.Items[i].Fields,id.Items[i].Options);
     finally
        id.free;
     end;
{$ELSE}
     // D4 missing delete method. Need to rebuild indexdefs.
     id:=TIndexDefs.Create(self);
     try
        id.Assign(FIndexDefs);
        FIndexDefs.Clear;
        for i:=0 to id.Count-1 do
            if id.Items[i].Name<>Name then
               FIndexDefs.AddIndexDef.Assign(id.Items[i]);
     finally
        id.free;
     end;
{$ENDIF}
{$ENDIF}
     FIndexDefs.Updated:=true;
end;

procedure TkbmCustomMemTable.SwitchToIndex(Index:TkbmIndex);
var
   id:integer;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     if Index=FCurIndex then exit;

     id:=-1;
     if Active then
     begin
          CheckBrowseMode;
{$IFDEF DOTNET}
          Rec:=TkbmRecord(Marshal.PtrToStructure(ActiveBuffer,TypeOf(TkbmRecord)));
          id := Rec.RecordID;
{$ELSE}
          id:=PkbmRecord(ActiveBuffer)^.RecordID;
{$ENDIF}
     end;

//     CancelRange;
     if FCurIndex<>nil then UpdateCursorPos;

     if Index=nil then Index:=Indexes.FRowOrderIndex;

     // Check if index is updated. If not, update it.
     if not Index.FOrdered then Index.Rebuild;

     if Index.FInternal then
     begin
          FIndexFieldNames:='';
          FIndexName:='';
     end
     else
     begin
          FIndexFieldNames:=Index.FIndexFields;
          FIndexName:=Index.FName;
     end;
     FCurIndex:=Index;

     FCurIndex.FIndexFieldList.AssignTo(FIndexList);

     try
        // Repos recordno.
        if FRecNo>=FCurIndex.FReferences.Count then
           FRecNo:=FCurIndex.FReferences.Count-1;
        if Active and (FRecNo>=0) then
        begin
             FCurIndex.SearchRecordID(id,FRecNo);

             // Check if record accepted according to current filter. If not, seek first.
{$IFDEF DOTNET}
             if (FRecNo<0) or (FRecNo>=FCurIndex.FReferences.Count) or (not FilterRecord(IntPtr(FCurIndex.FReferences.Items[FRecNo]),false)) then
                First;
{$ELSE}
             if (FRecNo<0) or (FRecNo>=FCurIndex.FReferences.Count) or (not FilterRecord(FCurIndex.FReferences.Items[FRecNo],false)) then
                First;
{$ENDIF}
        end;
//        Refresh;
        Resync([]);
     except
        SetState(dsInactive);
        CloseCursor;
        raise;
     end;
end;

procedure TkbmCustomMemTable.SetIndexFieldNames(FieldNames:string);
var
   lIndex:TkbmIndex;
begin
     if Active then
     begin
          if FieldNames='' then
             SwitchToIndex(nil)
          else
          begin
               lIndex:=Indexes.GetByFieldNames(FieldNames);
               if lIndex<>nil then SwitchToIndex(lIndex);
          end;
     end
     else
         FIndexFieldNames:=FieldNames;
end;

procedure TkbmCustomMemTable.SetIndexName(IndexName:string);
var
   lIndex:TkbmIndex;
begin
     if Active then
     begin
          if IndexName='' then
             SwitchToIndex(nil)
          else
          begin
               lIndex:=Indexes.Get(IndexName);
               if lIndex<>nil then SwitchToIndex(lIndex);
          end;
     end
     else
         FIndexName:=IndexName;
end;

procedure TkbmCustomMemTable.SetIndexDefs(Value:TIndexDefs);
begin
     FIndexDefs.assign(Value);
end;

procedure TkbmCustomMemTable.SetAutoUpdateFieldVariables(AValue:boolean);
begin
     if FAutoUpdateFieldVariables<>AValue then
     begin
          FAutoUpdateFieldVariables:=AValue;
          if Active then UpdateFieldVariables;
     end;
end;

procedure TkbmCustomMemTable.UpdateFieldVariables;
var
   i:integer;
begin
     if Assigned(owner)
        and (ComponentCount>0)
        and (Owner.ComponentCount>0)
        and not (csDesigning in ComponentState) then
     begin
          for i:=Pred(FieldCount) downto 0 do
              if not Assigned(Owner.FindComponent(Name+Fields[i].FieldName)) then
              begin
                   Fields[i].Name:=Name+Fields[i].FieldName;
                   RemoveComponent(Fields[i]);
                   Owner.InsertComponent(Fields[i]);
              end;
     end;
end;

procedure TkbmCustomMemTable.SetRecordTag(Value:longint);
var
   p:PkbmRecord;
   r:longint;
{$IFDEF DOTNET}
   pRec:IntPtr;
   Rec:TkbmRecord;
{$ENDIF}
begin
     FCommon.Lock;
     try
        p:=GetActiveRecord;
        if p=nil then raise EMemTableError.Create(kbmNoCurrentRecord);
{$IFDEF DOTNET}
          Rec := TkbmRecord (Marshal.PtrToStructure(p,TypeOf(TkbmRecord)));
          r:=Rec.RecordID;
{$ELSE}
          r:=p^.RecordID;
{$ENDIF}
        if (r<0) or (r>=FCommon.FRecords.Count) then
           raise EMemTableError.Create(kbmNoCurrentRecord);

{$IFDEF DOTNET}
        pRec := IntPtr(FCommon.FRecords.Items[r]);
        Rec  := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord)));
        Rec.Tag:=Value;
        Marshal.StructureToPtr(Rec,pRec,false);
        FCommon.FRecords.Items[r] := pRec;

        Rec := TkbmRecord (Marshal.PtrToStructure(p,TypeOf(TkbmRecord)));
        Rec.Tag:=Value;
        Marshal.StructureToPtr(Rec,p,false);
{$ELSE}
        PkbmRecord(FCommon.FRecords.Items[r]).Tag:=Value;
        PkbmRecord(p).Tag:=Value;
{$ENDIF}
     finally
        FCommon.Unlock;
     end;
end;

function TkbmCustomMemTable.GetRecordTag:longint;
var
   p:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     Result:=0;
     FCommon.Lock;
     try
        p:=GetActiveRecord;
        if p=nil then raise EMemTableError.Create(kbmNoCurrentRecord);
{$IFDEF DOTNET}
        Rec := TkbmRecord (Marshal.PtrToStructure(p,TypeOf(TkbmRecord) ));
        Result:= Rec.Tag;
{$ELSE}
        Result:=p^.Tag;
{$ENDIF}
     finally
        FCommon.Unlock;
     end;
end;

function TkbmCustomMemTable.GetIsVersioning:boolean;
begin
     Result:=FCommon.EnableVersioning;
end;

procedure TkbmCustomMemTable.SetStatusFilter(const Value:TUpdateStatusSet);
begin
     CheckBrowseMode;
     UpdateCursorPos;
     if FStatusFilter<>value then
     begin
          FStatusFilter:=Value;
          SetIsFiltered;
          Refresh;
//          Resync([]);
     end;
end;

{$IFNDEF LEVEL3}
function TkbmCustomMemTable.UpdateStatus:TUpdateStatus;
var
   p:PkbmRecord;
 {$IFDEF DOTNET}
   Rec:TkbmRecord;
 {$ENDIF}
begin
     p:=GetActiveRecord;
 {$IFDEF DOTNET}
     if assigned(p) then
     begin
        Rec := TkbmRecord(Marshal.PtrToStructure(p,TypeOf(TkbmRecord)));
        Result:=Rec.UpdateStatus
     end
     else
         Result:=inherited UpdateStatus;
 {$ELSE}
     if assigned(p) then
        Result:=p^.UpdateStatus
     else
         Result:=inherited UpdateStatus;
 {$ENDIF}
end;
{$ENDIF}

procedure TkbmCustomMemTable.SetAttachedTo(Value:TkbmCustomMemTable);
var
   i:integer;
   fld:TField;
begin
     if Value=FAttachedTo then exit;
     if Value=self then
        raise EMemTableError.Create(kbmCantAttachToSelf);

     Close;

     // Check if attached to something, break the attachment.
     if FAttachedTo<>nil then
     begin
          FCommon.DeAttachTable(self);
          FAttachedTo:=nil;

          // Prepare local memorytable.
          FCommon:=TkbmCommon.Create(self);

          // Add row order index to indexlist.
          with Indexes do
          begin
               FRowOrderIndex:=TkbmIndex.Create(kbmRowOrderIndex,self,'',[],mtitNonSorted,true);
               FRowOrderIndex.FRowOrder:=true;
               AddIndex(FRowOrderIndex);
          end;

          FCommon.Standalone:=false;
     end;

     // Make the new attachment.
     if Value<>nil then
     begin
          // Check if trying to make 3 level attachment. Disallow.
          if Value.FAttachedTo<>nil then
             raise EMemTableError.Create(kbmCantAttachToSelf2);

          // If sort index used before, free it.
          if (FSortIndex<>nil) then
          begin
               Indexes.DeleteIndex(FSortIndex);
               FSortIndex.free;
               FSortIndex:=nil;
          end;

          // Prepare attached to memorytable.
          FCommon.Free;
          FCommon:=Value.FCommon;
          try
             FCommon.AttachTable(self);
          except
             // Prepare local memorytable.
             FCommon:=TkbmCommon.Create(self);
             raise;
          end;
          FAttachedTo:=Value;

          FCurIndex:=Indexes.FRowOrderIndex;

          try
             if (not Value.Active) and (csDesigning in ComponentState) then Value.InternalInitFieldDefs;
          except
          end;

          FieldDefs.Assign(Value.FieldDefs);

          // Make sure fields match attached fields.
          if not (csDesigning in ComponentState) then
          begin
               for i:=0 to FAttachedTo.FieldCount-1 do
               begin
{$IFDEF LEVEL3}
                    fld:=FindField(FAttachedTo.Fields[i].FieldName);
{$ELSE}
                    fld:=FindField(FAttachedTo.Fields[i].FullName);
{$ENDIF}
                    if fld=nil then
                    begin
                         fld:=CreateFieldAs(FAttachedTo.Fields[i]);
                         CopyFieldProperties(FAttachedTo.Fields[i], fld);
//                         fld.visible:=false;
                    end;
               end;
          end;
     end;
end;

// Set filtered property.
procedure TkbmCustomMemTable.SetFiltered(Value:boolean);
begin
     if Value=Filtered then exit;
     inherited SetFiltered(Value);
     if Active then
     begin
{$IFDEF LEVEL5}
          if Value and (FFilterParser=nil) and (Filter<>'') then
          begin
               SetFilterText(Filter);
               SetIsFiltered;
               exit;
          end;
{$ENDIF}
          SetIsFiltered;
          ClearBuffers;
          Refresh;
          First;
     end;
end;

// Parse a filterstring and build filter structure.
procedure TkbmCustomMemTable.SetFilterText(const Value:string);
begin
     inherited SetFilterText(Value);

{$IFDEF LEVEL5}
     // Remove old filter.
     FreeFilter(FFilterParser);
{$ENDIF}

     // If active, build filter.
     if Active then
     begin
{$IFDEF LEVEL5}
          BuildFilter(FFilterParser,Value,FFilterOptions);
{$ENDIF}
          SetIsFiltered;
          if Filtered then
          begin
               ClearBuffers;
               First;
               Refresh;
          end;
     end;
end;

procedure TkbmCustomMemTable.SetOnFilterRecord(const Value: TFilterRecordEvent);
begin
     inherited SetOnFilterRecord(Value);
     SetIsFiltered;
end;

// Set delta handler.
procedure TkbmCustomMemTable.SetDeltaHandler(AHandler:TkbmCustomDeltaHandler);
begin
     if FDeltaHandler<>nil then FDeltaHandler.FDataSet:=nil;
     if AHandler<>nil then AHandler.FDataSet:=self;
     FDeltaHandler:=AHandler;
end;

// Set the contents of a memtable from a variant.
procedure TkbmCustomMemTable.SetAllData(AVariant:variant);
var
   ms:TMemoryStream;
begin
     // Check if variant contains data.
     if VarIsEmpty(AVariant) or VarIsNull(AVariant) or (not VarIsArray(AVariant)) then exit;

     ms:=TMemoryStream.Create;
     try
        VariantToStream(AVariant,ms);

        EmptyTable;
        ms.Seek (0,{$IFDEF DOTNET}soBeginning{$ELSE}0{$ENDIF});
        LoadFromStreamViaFormat(ms,FAllDataFormat);
     finally
        ms.Free;
     end;
end;

function TkbmCustomMemTable.GetAllData:variant;
var
   ms:TMemoryStream;
begin
     Result:=Unassigned;
     if not Active then exit;

     ms:=TMemoryStream.Create;
     try
        SaveToStreamViaFormat(ms,FAllDataFormat);
        Result:=StreamToVariant(ms);
     finally
        ms.Free;
     end;
end;

function TkbmCustomMemTable.GetMasterFields: string;
begin
     Result:=FMasterLink.FieldNames;
end;

procedure TkbmCustomMemTable.SetMasterFields(const Value: string);
begin
     FMasterLink.FieldNames:=Value;

     // Build master field list.
     if Active and (FMasterLink.DataSource<>nil) and (FMasterLink.DataSource.DataSet<>nil) then
        BuildFieldList(FMasterLink.DataSource.DataSet,FMasterIndexList,FMasterLink.FieldNames);
end;

procedure TkbmCustomMemTable.SetDetailFields(const Value: string);
begin
     FDetailFieldNames:=Value;

     // Build detail field list.
     if Active then
        BuildFieldList(self,FDetailIndexList,FDetailFieldNames);
end;

function TkbmCustomMemTable.GetDataSource: TDataSource;
begin
     Result:=FMasterLink.DataSource;
end;

procedure TkbmCustomMemTable.SetDataSource(Value: TDataSource);
begin
     if IsLinkedTo(Value) then DatabaseError(kbmSelfRef{$IFNDEF LEVEL3}, Self{$ENDIF});
     FMasterLink.DataSource:=Value;
end;

procedure TkbmCustomMemTable.MasterChanged(Sender: TObject);
var
   i,n:integer;
   aList:TkbmFieldList;
begin
     SetIsFiltered;

     // Check if no fields defined for master/detail. Do nothing.
     if (FMasterLink.Fields.Count<=0) then exit;

     // check if to use detailfieldlist or indexfieldlist (backwards compability).
     if (FDetailIndexList.Count<=0) then
        aList:=FIndexList
     else
         aList:=FDetailIndexList;
     n:=aList.Count;
     if n<=0 then exit;
     if FMasterLink.Fields.Count<n then n:=FMasterLink.Fields.Count;

     // Check if not allocated master keybuffer.
     if FKeyBuffers[kbmkbMasterDetail]=nil then FKeyBuffers[kbmkbMasterDetail]:=FCommon._InternalAllocRecord;

     // Fill masterrecord with masterfield values.
     for i:=0 to n-1 do
         PopulateField(FKeyBuffers[kbmkbMasterDetail],aList.Fields[i],TField(FMasterLink.Fields.Items[i]).Value);

     // Reposition.
     CheckBrowseMode;
     First;
end;

procedure TkbmCustomMemTable.MasterDisabled(Sender: TObject);
begin
     SetIsFiltered;
     First;
end;

// SetKey, EditKey, FindKey, FindNearest, GotoKey, Ranges.

procedure TkbmCustomMemTable.PrepareKeyRecord(KeyRecordType:integer; Clear:boolean);
begin
     // If keybuffer not assigned, allocate for it.
     if not assigned(FKeyBuffers[KeyRecordType]) then FKeyBuffers[KeyRecordType]:=FCommon._InternalAllocRecord;

     // Switch keybuffer.
     FKeyRecord:=FKeyBuffers[KeyRecordType];
     if Clear then
     begin
          FCommon._InternalFreeRecordVarLengths(FKeyRecord);
          FCommon._InternalClearRecord(FKeyRecord);
     end;
end;

procedure TkbmCustomMemTable.SetKey;
begin
     PrepareKeyRecord(kbmkbKey,true);
     SetState(dsSetKey);
     DataEvent(deDataSetChange,{$IFDEF DOTNET}nil{$ELSE}0{$ENDIF});
end;

procedure TkbmCustomMemTable.EditKey;
begin
     PrepareKeyRecord(kbmkbKey,false);
     SetState(dsSetKey);
     DataEvent(deDataSetChange,{$IFDEF DOTNET}nil{$ELSE}0{$ENDIF});
end;

function TkbmCustomMemTable.GotoKey:boolean;
var
   Index:integer;
   found:boolean;
begin
     Result:=false;

     CheckBrowseMode;

     if not Assigned(FKeyBuffers[kbmkbKey]) then exit;

     SetState(dsBrowse);
     CursorPosChanged;

     // Prepare list of fields representing the keys to search for.
     FCurIndex.FIndexFieldList.AssignTo(FIndexList);

     PrepareKeyRecord(kbmkbKey,false);

     DisableControls;
     try
        // Locate record.
        Index:=-1;
        found:=false;
        FCurIndex.Search(nil,FKeyRecord,false,true,Index,found);
        if found then
        begin
             FRecNo:=Index;
             Result:=true;
             Resync([]);
             DoAfterScroll;
        end;
     finally
        EnableControls;
        SetFound(Result);
     end;
end;

function TkbmCustomMemTable.FindKey(const KeyValues:array of const):boolean;
var
   i,j,k:integer;
   fld:TField;
   SaveState:TDataSetState;
begin
     CheckBrowseMode;

     if FIndexFieldNames='' then raise EMemTableError.Create(kbmVarReason2Err);

     PrepareKeyRecord(kbmkbKey,true);

     SaveState:=SetTempState(dsSetKey);
     try
        // Fill values into keyrecord.
        FCurIndex.FIndexFieldList.AssignTo(FIndexList);
        j:=FIndexList.Count-1;
        k:=High(KeyValues);
        if k>=j then k:=j;
        for i:=0 to k do
        begin
             fld:=FIndexList.Fields[i];
{$IFDEF DOTNET}
             fld.AssignValue(variant(KeyValues[i]));
{$ELSE}
             fld.AssignValue(KeyValues[i]);
{$ENDIF}
        end;
     finally
        RestoreState(SaveState);
     end;

     // Goto key.
     Result:=GotoKey;
end;

function TkbmCustomMemTable.GotoNearest:boolean;
var
   Index:integer;
   Found:boolean;
begin
     Result:=false;
     CheckBrowseMode;

     if not Assigned(FKeyBuffers[kbmkbKey]) then exit;

     SetState(dsBrowse);
     CursorPosChanged;

     PrepareKeyRecord(kbmkbKey,false);

     DisableControls;
     try
        // Look for record.
        Index:=-1;
        FCurIndex.Search(FIndexList,FKeyRecord,true,true,Index,Found);
        if (Index>=0) then
        begin
             FRecNo:=Index;
             Result:=true;
             Resync([]);
             DoAfterScroll;
        end;

     finally
        EnableControls;
        SetFound(Result);
     end;
end;

function TkbmCustomMemTable.FindNearest(const KeyValues:array of const):boolean;
var
   i,j,k:integer;
   fld:TField;
   SaveState:TDataSetState;
begin
     CheckBrowseMode;

     // Fill values into keyrecord.
     PrepareKeyRecord(kbmkbKey,true);

     SaveState:=SetTempState(dsSetKey);
     try
        FCurIndex.FIndexFieldList.AssignTo(FIndexList);
        j:=FIndexList.Count-1;
        k:=High(KeyValues);
        if k>=j then k:=j;
        for i:=0 to k do
        begin
             fld:=FIndexList.Fields[i];
{$IFDEF DOTNET}
             fld.AssignValue(Variant(KeyValues[i]));
{$ELSE}
             fld.AssignValue(KeyValues[i]);
{$ENDIF}
        end;

     finally
        RestoreState(SaveState);
     end;

     Result:=GotoNearest;
end;

procedure TkbmCustomMemTable.SetRangeStart;
begin
     // Prepare setting key values in key records.
     FCurIndex.FIndexFieldList.AssignTo(FIndexList);

     SetState(dsSetKey);
     PrepareKeyRecord(kbmkbRangeStart,true);
     DataEvent(deDataSetChange,{$IFDEF DOTNET}nil{$ELSE}0{$ENDIF});
end;

procedure TkbmCustomMemTable.SetRangeEnd;
begin
     // Prepare setting key values in key records.
     FCurIndex.FIndexFieldList.AssignTo(FIndexList);

     SetState(dsSetKey);
     PrepareKeyRecord(kbmkbRangeEnd,true);
     DataEvent(deDataSetChange,{$IFDEF DOTNET}nil{$ELSE}0{$ENDIF});
end;

procedure TkbmCustomMemTable.EditRangeStart;
begin
     // Prepare setting key values in key records.
     FCurIndex.FIndexFieldList.AssignTo(FIndexList);

     SetState(dsSetKey);
     PrepareKeyRecord(kbmkbRangeStart,false);
     DataEvent(deDataSetChange,{$IFDEF DOTNET}nil{$ELSE}0{$ENDIF});
end;

procedure TkbmCustomMemTable.EditRangeEnd;
begin
     // Prepare setting key values in key records.
     FCurIndex.FIndexFieldList.AssignTo(FIndexList);

     SetState(dsSetKey);
     PrepareKeyRecord(kbmkbRangeEnd,false);
     DataEvent(deDataSetChange,{$IFDEF DOTNET}nil{$ELSE}0{$ENDIF});
end;

procedure TkbmCustomMemTable.ApplyRange;
begin
     SetState(dsBrowse);
     FRangeActive:=(FKeyBuffers[kbmkbRangeStart]<>nil) and (FKeyBuffers[kbmkbRangeEnd]<>nil);
     SetIsFiltered;
     if not IsEmpty then first;
end;

procedure TkbmCustomMemTable.CancelRange;
var
   n:integer;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     if not FRangeActive then exit;

{$IFDEF DOTNET}
     if ActiveBuffer<>nil then
     begin
         Rec:=TkbmRecord(Marshal.PtrToStructure(ActiveBuffer,TypeOf(TkbmRecord)));
         n:=Rec.RecordID
     end
     else
         n:=-1;
{$ELSE}
     if ActiveBuffer<>nil then
        n:=PkbmRecord(ActiveBuffer)^.RecordID
     else
         n:=-1;
{$ENDIF}

     FRangeActive:=false;

     if Active then
     begin
          if n<0 then First
          else FCurIndex.SearchRecordID(n,FRecNo);
          Resync([]);
     end;
end;

procedure TkbmCustomMemTable.SetRange(const StartValues, EndValues:array of const);
var
   i,j,k:integer;
   fld:TField;
begin
     CheckBrowseMode;

     // Prepare setting key values in key records.
     FCurIndex.FIndexFieldList.AssignTo(FIndexList);
     j:=FIndexList.Count-1;

     // Setup start key values.
     SetRangeStart;
     k:=High(StartValues);
     if k>=j then k:=j;
     for i:=0 to k do
     begin
          fld:=FIndexList.Fields[i];
          fld.Clear;
{$IFDEF DOTNET}
          fld.AssignValue(Variant(StartValues[i]));
{$ELSE}
          fld.AssignValue(StartValues[i]);
{$ENDIF}
     end;
     for i:=k+1 to j-1 do
     begin
          fld:=FIndexList.Fields[i];
          fld.Clear;
     end;

     // Setup end key values.
     SetRangeEnd;
     k:=High(EndValues);
     if k>=j then k:=j;
     for i:=0 to k do
     begin
          fld:=FIndexList.Fields[i];
          fld.Clear;
{$IFDEF DOTNET}
          fld.AssignValue(variant(EndValues[i]));
{$ELSE}
          fld.AssignValue(EndValues[i]);
{$ENDIF}
     end;
     for i:=k+1 to j-1 do
     begin
          fld:=FIndexList.Fields[i];
          fld.Clear;
     end;

     ApplyRange;
end;

procedure TkbmCustomMemTable.DrawAutoInc;
begin
     // Update autoinc if such a field is defined.
     if Assigned(FAutoIncField) and (not FIgnoreAutoIncPopulation) then
        PopulateField(GetActiveRecord,FAutoIncField,FCommon.AutoIncMax+1);
end;

procedure TkbmCustomMemTable.PostAutoInc;
var
{$IFDEF DOTNET}
   pai:intPtr;
{$ELSE}
   pai:PChar;
{$ENDIF}
   n:integer;
begin
     // If an autoinc field is specified, allways keep track of highest used number.
     if Assigned(FAutoIncField) then
     begin
{$IFDEF DOTNET}
          pai:=FCommon.GetFieldPointer(PkbmRecord(ActiveBuffer),FAutoIncField);
{$ELSE}
          pai:=PChar(FCommon.GetFieldPointer(PkbmRecord(ActiveBuffer),FAutoIncField));
{$ENDIF}
          FCommon.Lock;
          try
{$IFDEF DOTNET}
             n:=marshal.ReadInt32(IntPtr(Integer(pai)+1),0);
             if (marshal.ReadByte(pai,0)<>Byte(kbmffNull)) and (FCommon.FAutoIncMax<n) then FCommon.FAutoIncMax:=n;
{$ELSE}
             n:=PInteger(pai+1)^;
             if (pai[0]<>kbmffNull) and (FCommon.FAutoIncMax<n) then FCommon.FAutoIncMax:=n;
{$ENDIF}
          finally
             FCommon.Unlock;
          end;
     end;
end;

// Copy masterfields to detail table if a master/detail relation.
procedure TkbmCustomMemTable.DoOnNewRecord;
var
   i,n:integer;
   aList:TkbmFieldList;
begin
     // Copy link values from master to detail.
     if FMasterLink.Active and (FMasterLink.Fields.Count > 0) and ((FDetailIndexList.Count>0) or (FIndexList.Count>0)) then
     begin
          // check if to use detailfieldlist or indexfieldlist (backwards compability).
          if (FDetailIndexList.Count<=0) then
             aList:=FIndexList
          else
              aList:=FDetailIndexList;
          n:=FMasterLink.Fields.Count;
          if aList.Count<n then n:=aList.Count;

          for i:=0 to n-1 do
              Alist.Fields[i].Value := TField(FMasterLink.Fields[i]).Value;
     end;

{$IFDEF LEVEL4}
     // If a DefaultExpression exists, fill data with default
     for i:=0 to Fields.Count-1 do
         if (Fields[i].DataType<>ftLargeInt)  // Due to Borland not implementing full largeint support in variants.
            and (Fields[i].DefaultExpression<>'') then
                TField(Fields[i]).Value:=TField(Fields[i]).DefaultExpression;
{$ENDIF}

     inherited DoOnNewRecord;

     DrawAutoInc;
end;

// Update max. autoinc. value.
procedure TkbmCustomMemTable.DoBeforePost;
begin
     inherited DoBeforePost;
     PostAutoInc;
end;

procedure TkbmCustomMemTable.DoOnFilterRecord(ADataset:TDataset; var AFiltered:boolean);
begin
     if Assigned(OnFilterRecord) then OnFilterRecord(ADataset,AFiltered);
end;

procedure TkbmCustomMemTable.DestroyIndexes;
begin
     Indexes.Clear;
end;

procedure TkbmCustomMemTable.CreateIndexes;
var
   i:integer;
begin
     Indexes.Clear;

     for i:=0 to FIndexDefs.Count-1 do
         Indexes.Add(FIndexDefs.Items[i]);
end;

function TkbmCustomMemTable.GetIndexByName(IndexName:string):TkbmIndex;
begin
     Result:=Indexes.Get(IndexName);
end;

function TkbmCustomMemTable.IndexFieldCount:Integer;
begin
     Result:=FCurIndex.FIndexFieldList.Count;
end;

function TkbmCustomMemTable.GetIndexField(Index: Integer): TField;
begin
     if (Index<0) or (Index>=IndexFieldCount) then
        Result:=nil
     else
         Result:=FCurIndex.FIndexFieldList.Fields[Index];
end;

procedure TkbmCustomMemTable.SetIndexField(Index:Integer; Value:TField);
var
   s,a:string;
   i:integer;
   lIndex:TkbmIndex;
begin
     // Try to find a predefined index matching this and other specified fields.
     s:='';
     a:='';
     for i:=0 to FCurIndex.FIndexFieldList.count-1 do
         s:=s+a+FCurIndex.FIndexFieldList.Fields[i].FieldName;

     lIndex:=Indexes.GetByFieldNames(s);
     if lIndex<>nil then SwitchToIndex(lIndex);
end;

procedure TkbmCustomMemTable.UpdateIndexes;
var
   i,j:integer;
   lIndex:TkbmIndex;
   DoRefresh:boolean;
begin
     DoRefresh:=false;

     // Check if to delete any indexes.
     for i:=Indexes.Count-1 downto 0 do
     begin
          j:=FIndexDefs.IndexOf(Indexes.FIndexes.Strings[i]);
          if j<0 then
          begin
               lIndex:=TkbmIndex(Indexes.FIndexes.Objects[i]);
               if (lIndex = Indexes.FRowOrderIndex) or (lIndex = FSortIndex) then continue;
               Indexes.FIndexes.Delete(i);
               if lIndex = FCurIndex then
               begin
                    FCurIndex:=Indexes.FRowOrderIndex;
                    DoRefresh:=true;
//                    Resync([]);
                    FIndexFieldNames:='';
               end;
               lIndex.free;
          end;
     end;

     // Check if to add any indexes.
     for i:=0 to FIndexDefs.Count-1 do
     begin
          with FIndexDefs.Items[i] do
          begin
               j:=Indexes.FIndexes.IndexOf(FIndexDefs.Items[i].Name);
               if j<0 then
               begin
                    lIndex:=TkbmIndex.Create(Name,self,Fields,IndexOptions2CompareOptions(Options),mtitSorted,false);
                    Indexes.AddIndex(lIndex);
               end;
          end;
     end;

     // Check if to rebuild any indexes.
     for i:=0 to Indexes.Count-1 do
     begin
          lIndex:=TkbmIndex(Indexes.FIndexes.Objects[i]);
          if not lIndex.FOrdered then
          begin
               lIndex.Rebuild;
               if (lIndex = FCurIndex) and (Active) then DoRefresh:=true; // Resync([]);
          end;
     end;

     if DoRefresh then Refresh;
end;

function TkbmCustomMemTable.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
begin
     Result:=TkbmBlobStream.Create(Field as TBlobField, Mode);
end;

procedure TkbmCustomMemTable.CreateTable;
var
   i:Integer;
begin
     DoCheckInactive;

     // If no fielddefs existing, use the previously defined fields.
     if FieldDefs.Count = 0 then
        for i:=0 to FieldCount-1 do
            with Fields[i] do
                 if FieldKind = fkData then
                    FieldDefs.Add(FieldName, DataType, Size, Required);

     // Check if to many fielddefs in source.
     if FieldDefs.Count>KBM_MAX_FIELDS then
        raise EMemTableError.Create(kbmTooManyFieldDefs);

     // Remove previously defined fields and indexes.
     DestroyIndexes;
     DestroyFields;

     // Create fields and indexes.
     CreateFields;
     CreateIndexes;

     ResetAutoInc;
end;

// Create field as another field.
function TkbmCustomMemTable.CreateFieldAs(Field:TField):TField;
var
   cl:TFieldClass;
begin
     Result:=nil;

     if not (Field.DataType in kbmSupportedFieldTypes) then exit;
     cl:=TFieldClass(Field.ClassType);
     Result:=cl.Create(owner);
     Result.Size:=Field.Size;
     Result.FieldKind:=Field.FieldKind;
     Result.FieldName:=Field.FieldName;
     Result.Lookup:=Field.Lookup;
     Result.KeyFields:=Field.KeyFields;
     Result.LookupDataSet:=Field.LookupDataSet;
     Result.LookupResultField:=Field.LookupResultField;
     Result.LookupKeyFields:=Field.LookupKeyFields;
{$IFDEF LEVEL4}
     if Field is TBCDField then
        TBCDField(Result).Precision:=TBCDField(Field).Precision;
{$ENDIF}
     Result.DataSet:=self;
end;

// Create memory table as another dataset.
procedure TkbmCustomMemTable.CreateTableAs(Source:TDataSet; CopyOptions:TkbmMemTableCopyTableOptions);
{$IFNDEF LEVEL3}
  procedure AssignFieldDef(Src,Dest:TFieldDef);
  var
     i:integer;
  begin
       with Dest do
       begin
            if Collection <> nil then Collection.BeginUpdate;
            try
               // FieldNo is defaulted.
               Name := Src.Name;
               DataType := Src.DataType;
               Size := Src.Size;
               Precision := Src.Precision;
               Attributes := Src.Attributes;
               InternalCalcField := Src.InternalCalcField;
               if HasChildDefs then ChildDefs.Clear;
               if Src.HasChildDefs then
                 for i := 0 to Src.ChildDefs.Count - 1 do
                   AssignFieldDef(Src.ChildDefs[i],AddChild);
            finally
               if Collection <> nil then Collection.EndUpdate;
            end;
       end;
  end;
{$ENDIF}
var
   i:integer;
   fld:TField;
begin
     DoCheckInactive;

     if Source=nil then exit;

     // Add fields as they are defined in the other dataset.
     if not Source.Active then Source.FieldDefs.Update;

     // Check if to many fielddefs in source.
     if Source.FieldDefs.Count>KBM_MAX_FIELDS then
        raise EMemTableError.Create(kbmTooManyFieldDefs);

     FieldDefs.Clear;
{$IFNDEF LEVEL3}
     for i:=0 to Source.FieldDefs.Count-1 do
         AssignFieldDef(Source.FieldDefs.Items[i],FieldDefs.AddFieldDef);
{$ELSE}
     FieldDefs.Assign(Source.FieldDefs);
{$ENDIF}

     // Check which fielddefs we wont keep and potentially convert datatypes.
     for i:=FieldDefs.Count-1 downto 0 do
     begin
          // Remove non supported fieldsdefs.
          if not (FieldDefs.Items[i].DataType in kbmSupportedFieldTypes) then
             FieldDefs.Items[i].free

          // Remove nonactive fields.
          else if (mtcpoOnlyActiveFields in CopyOptions) and
                  (Source.FindField(FieldDefs.Items[i].Name)=nil) then
                      FieldDefs.Items[i].free

{$IFDEF LEVEL6}
          // Check if to convert string fields to widestring fields.
          else if (mtcpoStringAsWideString in CopyOptions) and
               (FieldDefs.Items[i].DataType in [ftString,ftFixedChar]) then
               FieldDefs.Items[i].DataType:=ftWideString

{$ENDIF}
          ;
     end;

     // Destroy existing fields.
     DestroyFields;
     if not Source.DefaultFields then CreateFields;

     // Copy lookup and calculated fields if specified.
     for i:=0 to Source.FieldCount-1 do
         if ((Source.Fields[i].FieldKind=fkLookup) and (mtcpoLookup in CopyOptions))
            or ((Source.Fields[i].FieldKind=fkCalculated) and (mtcpoCalculated in CopyOptions)) then
         begin
              fld:=CreateFieldAs(Source.Fields[i]);
              if mtcpoFieldIndex in CopyOptions then fld.Index:=Source.Fields[i].Index;
         end;

     // Copy fieldproperties from source.
     if mtcpoProperties in CopyOptions then CopyFieldsProperties(Source,self);

     ResetAutoInc;
end;

// Delete table.
procedure TkbmCustomMemTable.DeleteTable;
begin
     DoCheckInactive;
     DestroyFields;
end;

procedure TkbmCustomMemTable.CheckActive;
begin
     inherited CheckActive;
//     if not FCommon.IsAnyTableActive then
//        DatabaseError(SDataSetClosed{$IFNDEF LEVEL3},Self{$ENDIF});
end;

procedure TkbmCustomMemTable.CheckInActive;
begin
     inherited CheckInActive;
end;

procedure TkbmCustomMemTable.DoCheckInActive;
begin
     if FCommon.IsAnyTableActive then
        FCommon.CloseTables(nil)
end;

function TkbmCustomMemTable.GetModifiedFlags(i:integer):boolean;
begin
     Result:=false;
     FCommon.Lock;
     try
        if (i<0) or (i>=FieldCount) then raise ERangeError.CreateFmt(kbmOutOfRange,[i]);
        Result:=(FCommon.FFieldFlags[i] and kbmffModified)<>0;
     finally
        FCommon.Unlock;
     end;
end;

function TkbmCustomMemTable.GetLocaleID:integer;
begin
     Result:=FCommon.LocaleID;
end;

procedure TkbmCustomMemTable.SetLocaleID(Value:integer);
begin
     FCommon.LocaleID:=Value;
end;

function TkbmCustomMemTable.GetLanguageID:integer;
begin
     Result:=FCommon.LanguageID;
end;

procedure TkbmCustomMemTable.SetLanguageID(Value:integer);
begin
     FCommon.LanguageID:=Value;
end;

function TkbmCustomMemTable.GetSortID:integer;
begin
     Result:=FCommon.SortID;
end;

procedure TkbmCustomMemTable.SetSortID(Value:integer);
begin
     FCommon.SortID:=Value;
end;

function TkbmCustomMemTable.GetSubLanguageID:integer;
begin
     Result:=FCommon.SubLanguageID;
end;

procedure TkbmCustomMemTable.SetSubLanguageID(Value:integer);
begin
     FCommon.SubLanguageID:=Value;
end;

procedure TkbmCustomMemTable.CreateFieldDefs;
var
   i:integer;
begin
     FieldDefs.clear;
     for i:=0 to Fieldcount-1 do
     begin
          // Add fielddef.
          if Fields[i].FieldKind in [fkData,fkInternalCalc] then
             FieldDefs.Add(Fields[i].FieldName,Fields[i].DataType,Fields[i].Size,Fields[i].Required);
     end;
end;

procedure TkbmCustomMemTable.InternalOpen;
begin
     // Check if owner table is open.
     if (Self<>FCommon.FOwner) and (not FCommon.FOwner.Active) then FCommon.FOwner.Open;

     // Attach to common.
     FCommon.Lock;
     try   
        InternalInitFieldDefs;
        if Self=FCommon.FOwner then
        begin
             if DefaultFields then
             begin
                  if (Self=FCommon.FOwner) and (FieldDefs.Count<=0) then
                     raise EMemTableError.Create(kbmVarReason2Err);
                  CreateFields;
             end
             else
                 CreateFieldDefs;
             ResetAutoInc;
        end
        else
            if DefaultFields then CreateFields;

        // Setup size of bookmark as exposed to applications.
        // Bookmark contains record pointer + a 2 byte table identifier.
        BookmarkSize := sizeof(TkbmUserBookmark);

        BindFields(True);

        // If Im the owner then layout the records.
        if FCommon.FOwner=self then FCommon.LayoutRecord(FieldCount);

        FIsOpen:=True;
        FRecNo:=-1;
        FReposRecNo:=-1;

        // Prepare index.
        CreateIndexes;

        // Select roworder index. Designtime selected alternative index will be selected in AfterOpen.
        FCurIndex:=Indexes.FRowOrderIndex;

        // Build master field list.
        if (FMasterLink.FieldNames<>'') and (FMasterLink.DataSource<>nil) and (FMasterLink.DataSource.DataSet<>nil) then
           BuildFieldList(FMasterLink.DataSource.DataSet,FMasterIndexList,FMasterLink.FieldNames)
        else
            FMasterIndexList.Clear;

        // Build detail field list.
        if (FDetailFieldNames<>'') then
           BuildFieldList(Self,FDetailIndexList,FDetailFieldNames)
        else
            FDetailIndexList.Clear;

        ClearBuffers;

        // Set flag that before close has not yet been called (used by destructor).
        FBeforeCloseCalled:=false;
     finally
        FCommon.Unlock;
     end;
end;

procedure TkbmCustomMemTable.InternalClose;
var
   i:integer;
begin
     // Check if to call before close.
     if not FBeforeCloseCalled then DoBeforeClose;

     FCommon.Lock;
     try
        // Check if owner, close others and empty table.
        if FCommon.FOwner=self then
        begin
             EmptyTable;
             FCommon.CloseTables(self);
        end;
     finally
        FCommon.Unlock;
     end;

     FRecNo:=-1;

     // Remove all indexes (except roworderindex).
     DestroyIndexes;
     FCurIndex:=Indexes.FRowOrderIndex;

     FIsOpen:=False;
     BindFields(False);

     // Delete keybuffers if assigned.
     FKeyRecord:=nil;
     for i:=kbmkbMin to kbmkbMax do
         if Assigned(FKeyBuffers[i]) then
         begin
              FCommon._InternalFreeRecord(FKeyBuffers[i],true,false);
              FKeyBuffers[i]:=nil;
         end;

     if DefaultFields then DestroyFields;
end;

procedure TkbmCustomMemTable.ResetAutoInc;
begin
     FAutoIncField:=nil;
     FCommon.AutoIncMax:=FCommon.AutoIncMin-1;
     CheckAutoInc;
end;

function TkbmCustomMemTable.CheckAutoInc:boolean;
var
   i:integer;
begin
     Result:=False;
     for i:=0 to FieldCount-1 do
         if Fields[i].DataType=ftAutoInc then
         begin
              FAutoIncField:=Fields[i];
              Result:=True;
              break;
         end;
end;

procedure TkbmCustomMemTable.InternalInitFieldDefs;
begin
     // Check if attached to another table, use that tables definitions.
     if FAttachedTo<>nil then
     begin
          FAutoIncField:=FAttachedTo.FAutoIncField;
          FieldDefs.Assign(FAttachedTo.FieldDefs);
          exit;
     end;

     // If using predefined fields, generate fielddefs according to fields.
     if not DefaultFields then
        CreateFieldDefs;

     // Look for autoinc field if any.
     ResetAutoInc;
end;

{$IFDEF DOTNET}
function TkbmCustomMemTable.GetActiveRecord:PkbmRecord;
var
   RecID:integer;
   Rec:TkbmRecord;
begin
     FCommon.Lock;

     try
        // Check if to return a pointer to a specific buffer.
        if FOverrideActiveRecordBuffer<>nil then
        begin
             Result:=FOverrideActiveRecordBuffer;
             exit;
        end;

        // Else return depending on dataset state.
        case State of
             dsBrowse:              if IsEmpty then
                                       Result := nil
                                    else
                                       Result := PkbmRecord(ActiveBuffer);

             dsCalcFields:          Result := PkbmRecord(CalcBuffer);
             dsFilter:              Result:=FFilterRecord;

             dsEdit:                Result:=PkbmRecord(ActiveBuffer);

             dsInsert:              Result:=PkbmRecord(ActiveBuffer);
             dsNewValue,dsCurValue: Result:=PkbmRecord(ActiveBuffer);
             dsOldValue:            begin
                                         // Return database record as Result.
                                         // According to the description of TField.OldValue in the help files,
                                         // OldValue should return the original value of the field before the
                                         // field is posted to. After the post, the oldvalue=curvalue.
                                         // Since the data in the table has not been updated before the post,
                                         // and currently edited data is in the active workrecord only, accessing
                                         // the tahle record will return the original record.
                                         // CHANGED 25. FEB. 2002 KBM
                                         // To make it more compatible with the workings of TClientDataset,
                                         // it will instead return the original unchanged version of the record
                                         // if one exists.

                                         Rec := TkbmRecord(Marshal.PtrToStructure (ActiveBuffer, TypeOf(TkbmRecord) ));
                                         RecID:=Rec.RecordID;

                                         if (RecID>=0) then
                                         begin
                                              Result:=PkbmRecord(FCommon.FRecords.Items[RecID]);
                                              Rec   := TkbmRecord (Marshal.PtrToStructure(Result,TypeOf(TkbmRecord)));
                                              while Rec.PrevRecordVersion<>nil do
                                              begin
                                                  Result:=Rec.PrevRecordVersion;
                                                  Rec   := TkbmRecord (Marshal.PtrToStructure(Result,TypeOf(TkbmRecord)));
                                              end;
                                         end
                                         else
                                             Result:=PkbmRecord(ActiveBuffer);
                                    end;

             dsSetKey:              Result:=FKeyRecord;
             dsBlockRead:           Result:=PkbmRecord(ActiveBuffer);
        else
             Result:=nil;
        end;
     finally
        FCommon.Unlock;
     end;
end;
{$ELSE}
function TkbmCustomMemTable.GetActiveRecord:PkbmRecord;
var
   RecID:integer;
begin
     FCommon.Lock;

     try
        // Check if to return a pointer to a specific buffer.
        if FOverrideActiveRecordBuffer<>nil then
        begin
             Result:=FOverrideActiveRecordBuffer;
             exit;
        end;

        // Else return depending on dataset state.
        case State of
             dsBrowse:              if IsEmpty then
                                       Result := nil
                                    else
                                       Result := PkbmRecord(ActiveBuffer);

             dsCalcFields:          Result := PkbmRecord(CalcBuffer);
             dsFilter:              Result:=FFilterRecord;

             dsEdit:                Result:=PkbmRecord(ActiveBuffer);

             dsInsert:              Result:=PkbmRecord(ActiveBuffer);
             dsNewValue,dsCurValue: Result:=PkbmRecord(ActiveBuffer);
             dsOldValue:            begin
                                         // Return database record as Result.
                                         // According to the description of TField.OldValue in the help files,
                                         // OldValue should return the original value of the field before the
                                         // field is posted to. After the post, the oldvalue=curvalue.
                                         // Since the data in the table has not been updated before the post,
                                         // and currently edited data is in the active workrecord only, accessing
                                         // the tahle record will return the original record.
                                         // CHANGED 25. FEB. 2002 KBM
                                         // To make it more compatible with the workings of TClientDataset,
                                         // it will instead return the original unchanged version of the record
                                         // if one exists.
                                         RecID:=PkbmRecord(ActiveBuffer)^.RecordID;

                                         if (RecID>=0) then
                                         begin
                                              Result:=PkbmRecord(FCommon.FRecords.Items[RecID]);
                                              while Result^.PrevRecordVersion<>nil do
                                                    Result:=Result^.PrevRecordVersion;
                                         end
                                         else
                                             Result:=PkbmRecord(ActiveBuffer);
                                    end;

             dsSetKey:              Result:=FKeyRecord;
 {$IFDEF LEVEL4}
             dsBlockRead:           Result:=PkbmRecord(ActiveBuffer);
 {$ENDIF}
        else
             Result:=nil;
        end;
     finally
        FCommon.Unlock;
     end;
end;
{$ENDIF}


{$IFDEF DOTNET}
procedure TkbmCustomMemTable.DataConvert(Field: TField; Source, Dest: TValueBuffer; ToNative: Boolean);
var
   B:TBytes;
   wstr:WideString;
   sz:integer;
begin
     case Field.DataType of
 {$IFDEF LEVEL10}
          ftFixedWideChar,
          ftWideMemo,
 {$ENDIF}
          ftWideString:
            // If to convert to native internal storage.
            if ToNative then
               WideStringToBuffer (Marshal.PtrToStringUni(Source),Dest)
            else
            // convert from internal native storage to api value.
            begin
                 // Must size the receiving widestring.
                 wStr := WideStringFromBuffer(Source);
                 B := WideBytesOf (wStr);
                 sz:=Length(B);
                 Marshal.Copy (B, 0, Dest, sz);

                 // Write terminating 0.
                 Marshal.WriteByte(Dest,sz,0);
                 Marshal.WriteByte(Dest,sz+1,0);
            end;

          else
            inherited DataConvert(Field,Source,Dest,ToNative);
     end;
end;
{$ELSE}
 {$IFDEF LEVEL5}
  {$IFNDEF LEVEL10}
procedure TkbmCustomMemTable.DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean);
begin
     case Field.DataType of
          ftWideString:
            // If to convert to native internal storage.
            if ToNative then
               WideStringToBuffer(PWideString(Source)^,Dest)
            else
            // convert from internal native storage to api value.
            begin
                 // Must size the receiving widestring.
                 PWideString(Dest)^:=WideStringFromBuffer(Source);
            end;

          else
            inherited DataConvert(Field,Source,Dest,ToNative);
     end;
end;
  {$ENDIF}
 {$ENDIF}
{$ENDIF}


// Result is data in the buffer and a boolean return (true=not null, false=is null).
{$IFDEF DOTNET}
function TkbmCustomMemTable.GetFieldData(Field: TField; Buffer:{$IFDEF DOTNET}TValueBuffer{$ELSE}Pointer{$ENDIF}): Boolean;
var
   SourceBuffer:intPtr;
   cBuffer:intPtr;
   ARec:TkbmRecord;
   ActRec,CurRec:PkbmRecord;
   IsVarLength,IsCompressed:boolean;
   pVarLength:PkbmVarLength;
   RecID:longint;
   cSz:longint;
begin
     FCommon.Lock;
     try
        Result:=False;
        if not FIsOpen then exit;
        ActRec:=GetActiveRecord;
        if ActRec=nil then exit;
        SourceBuffer:=FCommon.GetFieldPointer(ActRec,Field);
        if SourceBuffer=nil then Exit;

        // Check if calculated field. At the same time check for if varlength field.
        if Field.FieldKind<>fkData then
        begin
             IsVarLength:=false;
             IsCompressed:=false;
        end
        else
        begin
             IsVarLength:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffIndirect)<>0;
             IsCompressed:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffCompress)<>0;
        end;

        // Return null status.
        Result:=Marshal.ReadByte(SourceBuffer,0)<>Byte(kbmffNull);
        if not Result then exit;

        // Check if varlength field, get the data indirectly. If no data avail. get the data from the db.
        if IsVarLength then
        begin
             pVarLength:=Marshal.ReadIntPtr(IntPtr(integer(SourceBuffer)+1));

             // If varlength field not populated, check if database original populated.
             if (pVarLength = nil) then
             begin
                  // Find the record in the recordlist using the unique record id.
                  ARec:=TkbmRecord (Marshal.PtrToStructure(ActRec,TypeOf(TkbmRecord)));
                  RecID:=ARec.RecordID;
                  if (RecID>=0) then
                  begin
                       CurRec:=PkbmRecord(FCommon.FRecords.Items[RecID]);
                       cBuffer:=FCommon.GetFieldPointer(CurRec,Field);
                       pVarLength:=Marshal.ReadIntPtr(IntPtr(integer(cBuffer)+1));
                  end

                  // If by any chance no valid record is found, something is really rotten.
                  else if Assigned(Buffer) then
                      raise EMemTableInvalidRecord.Create(kbmInvalidRecord);
             end;

             // Check if to get data or not. Blobfields dont return data.
             if (not (Field.DataType in kbmBlobTypes))
                and Assigned(Buffer) and (pVarLength<>nil) then
             begin
                  cBuffer:= GetVarLengthData (pVarLength);
                  cSz:=GetVarLengthSize(pVarLength);

                  // Check if compressed field, decompress buffer.
                  if IsCompressed then
                  begin
                       if Assigned(FCommon.FOwner.FOnDeCompressField) then
                          FCommon.FOwner.FOnDecompressField(self,Field,CBuffer,cSz,CBuffer)
                       else
                           CBuffer:=FCommon.DecompressFieldBuffer(Field,CBuffer,CSz);
                  end;

                  CopyBuffer(cBuffer,Buffer,cSz);
             end;
        end
        else
        begin
             if Assigned(Buffer) then
                CopyBuffer(IntPtr(integer(SourceBuffer)+1),Buffer,FCommon.GetFieldSize(Field.DataType,Field.Size));
        end;
     finally
        FCommon.Unlock;
     end;
end;
{$ELSE}
function TkbmCustomMemTable.GetFieldData(Field: TField; Buffer:{$IFDEF DOTNET}TValueBuffer{$ELSE}Pointer{$ENDIF}): Boolean;
var
   SourceBuffer:PChar;
   cBuffer:PChar;
   ActRec,CurRec:PkbmRecord;
   IsVarLength,IsCompressed:boolean;
   pVarLength:PkbmVarLength;
   RecID:longint;
   cSz:longint;
begin
     FCommon.Lock;
     try
        Result:=False;
        if not FIsOpen then exit;
        ActRec:=GetActiveRecord;
        if ActRec=nil then exit;
        SourceBuffer:=FCommon.GetFieldPointer(ActRec,Field);
        if SourceBuffer=nil then Exit;

        // Check if calculated field. At the same time check for if varlength field.
        if Field.FieldKind<>fkData then
        begin
             IsVarLength:=false;
             IsCompressed:=false;
        end
        else
        begin
             IsVarLength:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffIndirect)<>0;
             IsCompressed:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffCompress)<>0;
        end;

        // Return null status.
        Result:=SourceBuffer[0]<>kbmffNull;
        if not Result then exit;

        // Check if varlength field, get the data indirectly. If no data avail. get the data from the db.
        if IsVarLength then
        begin
             pVarLength:=PPkbmVarLength(SourceBuffer+1)^;

             // If varlength field not populated, check if database original populated.
             if (pVarLength = nil) then
             begin
                  // Find the record in the recordlist using the unique record id.
                  RecID:=ActRec^.RecordID;
                  if (RecID>=0) then
                  begin
                       CurRec:=PkbmRecord(FCommon.FRecords.Items[RecID]);
                       cBuffer:=FCommon.GetFieldPointer(CurRec,Field);
                       pVarLength:=PPkbmVarLength(cBuffer+1)^;
                  end

                  // If by any chance no valid recordis is found, something is really rotten.
                  else if Assigned(Buffer) then
                      raise EMemTableInvalidRecord.Create(kbmInvalidRecord);
             end;

             // Check if to get data or not. Blobfields dont return data.
             if (not (Field.DataType in kbmBlobTypes))
                and Assigned(Buffer) and (pVarLength<>nil) then
             begin
                  cBuffer:=GetVarLengthData(pVarLength);
                  cSz:=GetVarLengthSize(pVarLength);

                  // Check if compressed field, decompress buffer.
                  if IsCompressed then
                  begin
                       if Assigned(FCommon.FOwner.FOnDeCompressField) then
                          FCommon.FOwner.FOnDecompressField(self,Field,CBuffer,cSz,CBuffer)
                       else
                           CBuffer:=FCommon.DecompressFieldBuffer(Field,CBuffer,CSz);
                  end;

 {$IFNDEF USE_FAST_MOVE}
                      Move(cBuffer^,Buffer^,cSz);
 {$ELSE}
                      FastMove(cBuffer^,Buffer^,cSz);
 {$ENDIF}
             end;
        end
        else
        begin
             if Assigned(Buffer) then
             begin
 {$IFNDEF USE_FAST_MOVE}
                  Move(SourceBuffer[1], Buffer^, FCommon.GetFieldSize(Field.DataType,Field.Size));
 {$ELSE}
                  FastMove(SourceBuffer[1], Buffer^, FCommon.GetFieldSize(Field.DataType,Field.Size));
 {$ENDIF}
             end;
        end;
     finally
        FCommon.Unlock;
     end;
end;
{$ENDIF}

{$IFDEF DOTNET}
procedure TkbmCustomMemTable.SetFieldData(Field: TField; Buffer:TRecordBuffer);
var
   DestinationBuffer: IntPtr;
   cBuffer:IntPtr;
   ppVarLength:PPkbmVarLength;
   IsVarLength,IsCompressed:boolean;
   sz:longint;
   n:integer;
   cSz:longint;
begin
     if not FIsOpen then exit;

     FCommon.Lock;
     try
        if not (State in (dsWriteModes+[dsCalcFields])) then DatabaseError(kbmEditModeErr, Self);
        DestinationBuffer:=FCommon.GetFieldPointer(GetActiveRecord,Field);
        if DestinationBuffer=nil then Exit;

        if (not FIgnoreReadOnly) and ((FReadOnly or Field.ReadOnly) and (not (State in [dsSetKey,dsCalcFields]))) then
           DatabaseErrorFmt(kbmReadOnlyErr,[Field.DisplayName]);

        sz:=FCommon.GetFieldSize(Field.DataType,Field.Size);

        // Set the null value from the buffer.
        if assigned(Buffer) then
           Marshal.WriteByte(DestinationBuffer,Byte(kbmffData))
        else
           Marshal.WriteByte(DestinationBuffer,Byte(kbmffNull));
        DestinationBuffer:=IntPtr(integer(DestinationBuffer)+1);

        // Check if calculated field. At the same time check for if varlength field.
        if Field.FieldKind in [fkData,fkInternalCalc,fkCalculated] then Field.Validate(Buffer);
        if Field.FieldKind<>fkData then
        begin
             IsVarLength:=false;
             IsCompressed:=false;
        end
        else
        begin
             IsVarLength:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffIndirect)<>0;
             IsCompressed:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffCompress)<>0;
        end;

        // Check if varlength field, set the data indirectly.
        if IsVarLength then
        begin
             ppVarLength:=PPkbmVarLength(DestinationBuffer);
             // If varlength field populated, clear it out.

             if (Marshal.ReadIntPtr(ppVarLength) <> nil) then
             begin
                  FreeVarLength(Marshal.ReadIntPtr(ppVarLength));
                  Marshal.WriteIntPtr(ppVarLength,nil);
             end;

             // Check if to populate the varlength field.
             if Assigned(Buffer) then
             begin
                  cBuffer:=Buffer;
                  cSz:=sz;

                  // Check if to compress the data.
                  if IsCompressed then
                  begin
                       if Assigned(FCommon.FOwner.FOnCompressField) then
                          FCommon.FOwner.FOnCompressField(self,Field,Buffer,cSz,CBuffer)
                       else
                           CBuffer:=FCommon.CompressFieldBuffer(Field,Buffer,CSz);
                  end;

                  Marshal.WriteIntPtr(ppVarLength,AllocVarLengthAs(CBuffer,CSz) );
             end;
        end
        else
        begin
             if Assigned(Buffer) then
                CopyBuffer(Buffer,DestinationBuffer,sz);
        end;

        // Set modified flag.
        n:=Field.FieldNo-1;
        if (n>=0) then FCommon.FFieldFlags[n]:=FCommon.FFieldFlags[n] or kbmffModified;

        if not (State in [dsCalcFields, dsFilter, dsNewValue]) then
           DataEvent(deFieldChange, Field);
     finally
        FCommon.Unlock;
     end;
end;
{$ELSE}
procedure TkbmCustomMemTable.SetFieldData(Field: TField; Buffer:Pointer);
var
   DestinationBuffer: PChar;
   cBuffer:PChar;
   ppVarLength:PPkbmVarLength;
   IsVarLength,IsCompressed:boolean;
   sz:longint;
   n:integer;
   cSz:longint;
begin
     if not FIsOpen then exit;

     FCommon.Lock;
     try
        if not (State in (dsWriteModes+[dsCalcFields])) then DatabaseError(kbmEditModeErr{$IFNDEF LEVEL3}, Self{$ENDIF});
        DestinationBuffer:=FCommon.GetFieldPointer(GetActiveRecord,Field);
        if DestinationBuffer=nil then Exit;

        if (not FIgnoreReadOnly) and ((FReadOnly or Field.ReadOnly) and (not (State in [dsSetKey,dsCalcFields]))) then
           DatabaseErrorFmt(kbmReadOnlyErr,[Field.DisplayName]);

        sz:=FCommon.GetFieldSize(Field.DataType,Field.Size);

        // Set the null value from the buffer.
        if LongBool(Buffer) then DestinationBuffer^:=kbmffData
        else DestinationBuffer^:=kbmffNull;
        inc(DestinationBuffer);

        // Check if calculated field. At the same time check for if varlength field.
        if Field.FieldKind in [fkData,fkInternalCalc,fkCalculated] then Field.Validate(Buffer);
        if Field.FieldKind<>fkData then
        begin
             IsVarLength:=false;
             IsCompressed:=false;
        end
        else
        begin
             IsVarLength:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffIndirect)<>0;
             IsCompressed:=(FCommon.FFieldFlags[Field.FieldNo-1] and kbmffCompress)<>0;
        end;

        // Check if varlength field, set the data indirectly.
        if IsVarLength then
        begin
             ppVarLength:=PPkbmVarLength(DestinationBuffer);
             // If varlength field populated, clear it out.
             if (ppVarLength^ <> nil) then
             begin
                  FreeVarLength(ppVarLength^);
                  ppVarLength^:=nil;
             end;

             // Check if to populate the varlength field.
             if Assigned(Buffer) then
             begin
                  cBuffer:=Buffer;
                  cSz:=sz;

                  // Check if to compress the data.
                  if IsCompressed then
                  begin
                       if Assigned(FCommon.FOwner.FOnCompressField) then
                          FCommon.FOwner.FOnCompressField(self,Field,Buffer,cSz,CBuffer)
                       else
                           CBuffer:=FCommon.CompressFieldBuffer(Field,Buffer,CSz);
                  end;

                  ppVarLength^:=AllocVarLengthAs(CBuffer,CSz);
             end;
        end
        else
        begin
             if Assigned(Buffer) then
             begin
 {$IFNDEF USE_FAST_MOVE}
                  Move(Buffer^,DestinationBuffer^,sz);
 {$ELSE}
                  FastMove(Buffer^,DestinationBuffer^,sz);
 {$ENDIF}
             end;

        end;

        // Set modified flag.
        n:=Field.FieldNo-1;
        if (n>=0) then FCommon.FFieldFlags[n]:=FCommon.FFieldFlags[n] or kbmffModified;

        if not (State in [dsCalcFields, dsFilter, dsNewValue]) then
           DataEvent(deFieldChange, Longint(Field));
     finally
        FCommon.Unlock;
     end;
end;
{$ENDIF}

function TkbmCustomMemTable.IsCursorOpen: Boolean;
begin
     Result:=FIsOpen;
end;

function TkbmCustomMemTable.GetCanModify: Boolean;
begin
     Result:=not FReadOnly;
end;

function TkbmCustomMemTable.GetRecordSize: Word;
begin
     Result:=FCommon.FTotalRecordSize;
end;

{$IFDEF DOTNET}
function TkbmCustomMemTable.AllocRecordBuffer:TRecordBuffer;
begin
     Result:=IntPtr(FCommon._InternalAllocRecord);
end;

procedure TkbmCustomMemTable.FreeRecordBuffer(var Buffer:TRecordBuffer);
begin
     FCommon._InternalFreeRecord (Buffer,false,false);
     Buffer := nil;
end;

procedure TkbmCustomMemTable.SetBlockReadSize(Value:integer);
begin
     if Value <> BlockReadSize then
     begin
          if (Value > 0) or (Value < -1) then
          begin
               inherited SetBlockReadSize(Value);
               BlockReadNext;
          end
          else
          begin
               Value:=0;
               inherited SetBlockReadSize(Value);

               CursorPosChanged;
               Resync([]);
          end;
     end;
end;
{$ELSE}
function TkbmCustomMemTable.AllocRecordBuffer:PChar;
begin
     Result:=PChar(FCommon._InternalAllocRecord);
end;

procedure TkbmCustomMemTable.FreeRecordBuffer(var Buffer:PChar);
begin
     FCommon._InternalFreeRecord(PkbmRecord(Buffer),false,false);
     Buffer:=nil;
end;

 {$IFDEF LEVEL4}
procedure TkbmCustomMemTable.SetBlockReadSize(Value:integer);
  {$IFNDEF LEVEL5}
var
   DoNext: Boolean;
  {$ENDIF}
begin
     if Value <> BlockReadSize then
     begin
          if (Value > 0) or (Value < -1) then
          begin
               inherited SetBlockReadSize(Value);
               BlockReadNext;
          end
          else
          begin
  {$IFNDEF LEVEL5}
               DoNext:=Value=-1;
  {$ENDIF}
               Value:=0;
               inherited SetBlockReadSize(Value);

  {$IFNDEF LEVEL5}
               if DoNext then
                  Next
               else
               begin
  {$ENDIF}
                    CursorPosChanged;
                    Resync([]);
  {$IFNDEF LEVEL5}
               end;
  {$ENDIF}
          end;
     end;
end;
 {$ENDIF}
{$ENDIF}

{$IFDEF DOTNET}
// Fill one field with contents of a variant.
procedure TkbmCustomMemTable.PopulateField(ARecord:PkbmRecord; Field:TField; AValue:Variant);
var
   p:IntPtr;
   NumericBuffer:IntPtr;
   pValue:IntPtr;
   CBuffer:IntPtr;
   bytes:TBytes;
   s:string;
   fn:integer;
   si:smallint;
   bcd:TBcd;
   c:Currency;
   ws:WideString;
   i:integer;
   d:double;
   dt:TDateTime;
   ts:TTimeStamp;
   dtr:TDateTimeRec;
   flags:byte;
   sz:longint;
   CSz:longint;
   ppVarLength:PPkbmVarLength;
   tssql:TSQLTimeStamp;
begin
  NumericBuffer:=Marshal.AllocHGlobal(64);
  try
     p:=FCommon.GetFieldPointer(ARecord,Field);
     sz:=FCommon.GetFieldSize(Field.DataType,Field.Size);

     FCommon.Lock;
     try
        // Populate with null?
        if VarIsNull(AValue) or VarIsEmpty(AValue) then
        begin
             Marshal.WriteByte(p,0,byte(kbmffNull));

             fn:=Field.FieldNo-1;
             if fn>=0 then
             begin
                  flags:=FCommon.FFieldFlags[fn];
                  if (flags and kbmffIndirect)<>0 then
                  begin
                       p:=IntPtr(integer(p)+1);
                       ppVarLength:=PPkbmVarLength(p);

                       // If varlength field populated, clear it out.
                       if (Marshal.ReadIntPtr(ppVarLength) <> nil) then
                       begin
                            FreeVarLength(Marshal.ReadIntPtr(ppVarLength));
                            Marshal.WriteIntPtr(ppVarLength,nil);
                       end;
                       exit;
                  end;
             end;

             for i:=1 to sz-1 do
                 Marshal.WriteByte(p,i,0);
             exit;
        end;

        // Populate with value.
        Marshal.WriteByte(p,0,byte(kbmffData));
        with Field do
        begin
             pValue:=nil;
             case DataType of
 {$IFDEF LEVEL10}
                  ftFixedWideChar,
 {$ENDIF}
                  ftWideString:
                      begin
                           ws:=AValue;
                           WideStringToBuffer(ws,pValue);
                           i:=length(ws);
                           sz:=i*sizeof(WideChar)+sizeof(Integer);
                      end;

{$IFDEF LEVEL10}
                  ftOraInterval,
{$ENDIF}
                  ftFixedChar,
                  ftGUID,
                  ftString:
                      begin
                           s:=AValue.ToString;
                           if TStringField(Field).Transliterate then
                              DataSet.Translate(s,s,True);
                           pValue:=Marshal.StringToHGlobalAnsi(s);
                           sz:=s.Length;
                      end;

                  ftSmallint:
                      begin
                           si:=AValue;
                           pValue:=NumericBuffer;
                           PutInt16(pValue,si);
                      end;

                  ftLargeInt:
                      begin
                           pValue:=NumericBuffer;
                           PutInt64(pValue,AValue);
                      end;

                  ftInteger,
                  ftAutoInc:
                      begin
                           pValue:=NumericBuffer;
                           PutInt32(pValue,AValue);
                      end;

                  ftBCD:
                      begin
                           c:=AValue;
                           i:=TBCDField(Field).Precision;
                           if i<=TBCDField(Field).Size then i:=TBCDField(Field).Size+1;
                           CurrToBCD(c,bcd,i,TBCDField(Field).Size);
                           bytes:=TBcd.ToBytes(bcd);
                           Marshal.StructureToPtr(bcd,pValue,false);
                      end;

                  ftDate:
                      begin
                           if VarType(AValue) in [varDate,varDouble,varSingle,varInteger] then
                              dt:=AValue
                           else
                              dt:=StrToDateTime(VarToStr(AValue));
                           ts:=DateTimeToTimeStamp(dt);
                           dtr.Date:=ts.Date;
                           pValue:=marshal.allochglobal(sizeof(ttimestamp));
                           Marshal.StructureToPtr(dtr,pValue,false);
                      end;

                  ftTime:
                      begin
                           if VarType(AValue) in [varDate,varDouble,varSingle,varInteger] then
                              dt:=AValue
                           else
                              dt:=StrToDateTime(VarToStr(AValue));
                           ts:=DateTimeToTimeStamp(dt);
                           dtr.Time:=ts.Time;
                           pValue:=marshal.allochglobal(sizeof(ttimestamp));
                           Marshal.StructureToPtr(dtr,pValue,false);
                      end;

                  ftDateTime:
                      begin
                           if VarType(AValue) in [varDate,varDouble,varSingle,varInteger] then
                              dt:=AValue
                           else
                              dt:=StrToDateTime(VarToStr(AValue));
                           ts:=DateTimeToTimeStamp(dt);
                           dtr.DateTime:=TimeStampToMSecs(ts);
                           pValue:=marshal.allochglobal(sizeof(ttimestamp));
                           Marshal.StructureToPtr(dtr,pValue,false);
                      end;

{$IFDEF LEVEL10}
                  ftOraTimeStamp,
{$ENDIF}
                  ftTimeStamp:
                      begin
                           tssql:=VarToSQLTimeStamp(AValue);
                           pValue:=marshal.allochglobal(sizeof(ttimestamp));
                           Marshal.StructureToPtr(tssql,pValue,false);
                      end;

                  ftWord:
                      begin
                           pValue:=NumericBuffer;
                           PutInt16(pValue,AValue);
                      end;

                  ftBoolean:
                      begin
                           pValue:=NumericBuffer;
                           PutInt16(pValue,AValue);
                      end;

                  ftFloat,
                  ftCurrency:
                      begin
                           pValue:=NumericBuffer;
                           PutInt64(pValue,BitConverter.DoubleToInt64Bits(d));
                      end;
             end;

             // If anything to store.
             if (pValue<>nil) then
             begin
                  // Check if varlength field, set the data indirectly.
                  p:=IntPtr(integer(p)+1);
                  fn:=Field.FieldNo-1;
                  if fn>=0 then      // Calculated fields are never varlengths.
                  begin
                       flags:=FCommon.FFieldFlags[fn];
                       if (flags and kbmffIndirect)<>0 then
                       begin
                            ppVarLength:=PPkbmVarLength(p);

                            // If varlength field populated, clear it out.
                            if (Marshal.ReadIntPtr(ppVarLength) <> nil) then
                            begin
                                 FreeVarLength(Marshal.ReadIntPtr(ppVarLength));
                                 Marshal.WriteIntPtr(ppVarLength,nil);
                            end;

                            // Check if to populate the varlength field.
                            cBuffer:=pValue;
                            cSz:=sz;

                            // Check if to compress the data.
                            if (flags and kbmffCompress)<>0 then
                            begin
                                 if Assigned(FOnCompressField) then
                                    FCommon.FOwner.FOnCompressField(self,Field,pValue,cSz,CBuffer)
                                 else
                                     CBuffer:=FCommon.CompressFieldBuffer(Field,pValue,CSz);
                            end;
                            Marshal.WriteIntPtr(ppVarLength,AllocVarLengthAs(CBuffer,CSz));
                       end
                       else
                           CopyBuffer(pValue,p,sz);
                       FCommon.FFieldFlags[fn]:=FCommon.FFieldFlags[fn] or kbmffModified;
                  end
                  else
                      CopyBuffer(pValue,p,sz);
             end;
        end;
     finally
        FCommon.Unlock;
     end;
  finally
     Marshal.FreeHGlobal(NumericBuffer);
  end;
end;
{$ELSE}
// Fill one field with contents of a variant.
procedure TkbmCustomMemTable.PopulateField(ARecord:PkbmRecord; Field:TField; AValue:Variant);
var
   p:PChar;
   pValue:PChar;
   CBuffer:PChar;
   s:array of Char;
   fn:integer;
   si:smallint;
{$IFDEF LEVEL5}
   bcd:TBcd;
   c:Currency;
{$ENDIF}
{$IFNDEF LEVEL3}
   li:Int64;
   ws:WideString;
{$ENDIF}
   i:integer;
   w:word;
   wb:WordBool;
   d:double;
   dt:TDateTime;
   ts:TTimeStamp;
   dtr:TDateTimeRec;
   flags:byte;
   sz:longint;
   CSz:longint;
   ppVarLength:PPkbmVarLength;
{$IFDEF LEVEL6}
   tssql:TSQLTimeStamp;
{$ENDIF}
begin
     p:=FCommon.GetFieldPointer(ARecord,Field);
     sz:=FCommon.GetFieldSize(Field.DataType,Field.Size);

     FCommon.Lock;
     try
        // Populate with null?
        if VarIsNull(AValue) or VarIsEmpty(AValue) then
        begin
             p[0]:=kbmffNull;
             fn:=Field.FieldNo-1;
             if fn>=0 then
             begin
                  flags:=FCommon.FFieldFlags[fn];
                  if (flags and kbmffIndirect)<>0 then
                  begin
                       inc(p);
                       ppVarLength:=PPkbmVarLength(p);

                       // If varlength field populated, clear it out.
                       if (ppVarLength^ <> nil) then
                       begin
                            FreeVarLength(ppVarLength^);
                            ppVarLength^:=nil;
                       end;
                       exit;
                  end;
             end;
             FillChar(p[1],sz, 0);
             exit;
        end;

        // Populate with value.
        p[0]:=kbmffData;
        with Field do
        begin
             pValue:=nil;
             case DataType of
 {$IFNDEF LEVEL3}
  {$IFDEF LEVEL10}
                  ftFixedWideChar,
  {$ENDIF}
                  ftWideString:
                      begin
                           ws:=AValue;
                           i:=length(ws);
                           sz:=i*sizeof(WideChar)+sizeof(Integer);
                           SetLength(s,sz);
                           WideStringToBuffer(ws,@s[0]);
                           pValue:=PChar(@s[0]);
                      end;
 {$ENDIF}

{$IFDEF LEVEL10}
                  ftOraInterval,
{$ENDIF}
                  ftFixedChar,
{$IFDEF LEVEL5}
                  ftGUID,
{$ENDIF}
                  ftString:
                      begin
                           SetLength(s,dsMaxStringSize);
                           StrLCopy(@s[0],PChar(VarToStr(AValue)),DataSize);
                           if TStringField(Field).Transliterate then
                              DataSet.Translate(@s[0],@s[0],True);
                           pValue:=@s[0];
                      end;

                  ftSmallint:
                      begin
                           si:=AValue;
                           pValue:=PChar(@si);
                      end;
{$IFNDEF LEVEL3}
                  ftLargeInt:
                      begin
                           li:=AValue;
                           pValue:=PChar(@li);
                      end;
{$ENDIF}
                  ftInteger,
                  ftAutoInc:
                      begin
                           i:=AValue;
                           pValue:=PChar(@i);
                      end;

{$IFDEF LEVEL5}
                  ftBCD:
                      begin
                           c:=AValue;
                           i:=TBCDField(Field).Precision;
                           if i<=TBCDField(Field).Size then i:=TBCDField(Field).Size+1;
                           CurrToBCD(c,bcd,i,TBCDField(Field).Size);
                           pValue:=PChar(@bcd);
                      end;
{$ENDIF}

                  ftDate:
                      begin
                           if VarType(AValue) in [varDate,varDouble,varSingle,varInteger] then
                              dt:=AValue
                           else
                              dt:=StrToDateTime(VarToStr(AValue));
                           ts:=DateTimeToTimeStamp(dt);
                           dtr.Date:=ts.Date;
                           pValue:=PChar(@dtr);
                      end;

                  ftTime:
                      begin
                           if VarType(AValue) in [varDate,varDouble,varSingle,varInteger] then
                              dt:=AValue
                           else
                              dt:=StrToDateTime(VarToStr(AValue));
                           ts:=DateTimeToTimeStamp(dt);
                           dtr.Time:=ts.Time;
                           pValue:=PChar(@dtr);
                      end;

                  ftDateTime:
                      begin
                           if VarType(AValue) in [varDate,varDouble,varSingle,varInteger] then
                              dt:=AValue
                           else
                              dt:=StrToDateTime(VarToStr(AValue));
                           ts:=DateTimeToTimeStamp(dt);
                           dtr.DateTime:=TimeStampToMSecs(ts);
                           pValue:=PChar(@dtr);
                      end;
{$IFDEF LEVEL6}
 {$IFDEF LEVEL10}
                  ftOraTimeStamp,
 {$ENDIF}
                  ftTimeStamp:
                      begin
                           tssql:=VarToSQLTimeStamp(AValue);
                           pValue:=PChar(@tssql);
                      end;
{$ENDIF}

                  ftWord:
                      begin
                           w:=AValue;
                           pValue:=PChar(@w);
                      end;

                  ftBoolean:
                      begin
                           wb:=AValue;
                           pValue:=PChar(@wb);
                      end;

                  ftFloat,
                  ftCurrency:
                      begin
                           d:=AValue;
                           pValue:=PChar(@d);
                      end;
             end;

             // If anything to store.
             if (pValue<>nil) then
             begin
                  // Check if varlength field, set the data indirectly.
                  inc(p);
                  fn:=Field.FieldNo-1;
                  if fn>=0 then      // Calculated fields are never varlengths.
                  begin
                       flags:=FCommon.FFieldFlags[fn];
                       if (flags and kbmffIndirect)<>0 then
                       begin
                            ppVarLength:=PPkbmVarLength(p);

                            // If varlength field populated, clear it out.
                            if (ppVarLength^ <> nil) then
                            begin
                                 FreeVarLength(ppVarLength^);
                                 ppVarLength^:=nil;
                            end;

                            // Check if to populate the varlength field.
                            cBuffer:=pValue;
                            cSz:=sz;

                            // Check if to compress the data.
                            if (flags and kbmffCompress)<>0 then
                            begin
                                 if Assigned(FOnCompressField) then
                                    FCommon.FOwner.FOnCompressField(self,Field,pValue,cSz,CBuffer)
                                 else
                                     CBuffer:=FCommon.CompressFieldBuffer(Field,pValue,CSz);
                            end;

                            ppVarLength^:=AllocVarLengthAs(CBuffer,CSz);
                       end
                       else
 {$IFNDEF USE_FAST_MOVE}
                           Move(pValue^,p^,sz);
 {$ELSE}
                           FastMove(pValue^,p^,sz);
 {$ENDIF}
                       FCommon.FFieldFlags[fn]:=FCommon.FFieldFlags[fn] or kbmffModified;
                  end
                  else
 {$IFNDEF USE_FAST_MOVE}
                      Move(pValue^,p^,sz);
 {$ELSE}
                      FastMove(pValue^,p^,sz);
 {$ENDIF}
             end;
        end;
     finally
        FCommon.Unlock;
     end;
end;
{$ENDIF}

{$IFDEF DOTNET}
// Populate a varlength field with a value.
procedure TkbmCustomMemTable.PopulateVarLength(ARecord:PkbmRecord;Field:TField;const Buffer;Size:integer);
var
   pField:IntPtr;
   pVarLength:PPkbmVarLength;
begin
     pField:=FCommon.GetFieldPointer(ARecord,Field);
     if pField=nil then exit;

     pVarLength:=PPkbmVarLength(IntPtr(integer (pField)+1));

     if Marshal.ReadIntPtr (pVarLength)<>nil then
     begin
          FreeVarLength(Marshal.ReadIntPtr (pVarLength));
          Marshal.WriteIntPtr (pVarLength,nil);
     end;

     Marshal.WriteIntPtr (pVarLength,AllocVarLength(Size));

     if Size<>0 then
     begin
          Marshal.WriteByte(pField,0,Byte(kbmffData));
          CopyBuffer (IntPtr(Buffer),GetVarLengthData(Marshal.ReadIntPtr (pVarLength)),Size);
     end
     else
        Marshal.WriteByte(pField,0,byte(kbmffNull));
end;
{$ELSE}
// Populate a varlength field with a value.
procedure TkbmCustomMemTable.PopulateVarLength(ARecord:PkbmRecord;Field:TField;const Buffer;Size:integer);
var
   pField:PChar;
   pVarLength:PPkbmVarLength;
begin
     pField:=FCommon.GetFieldPointer(ARecord,Field);
     if pField=nil then exit;

     pVarLength:=PPkbmVarLength(pField+1);
     if pVarLength^<>nil then
     begin
          FreeVarLength(pVarLength^);
          pVarLength^:=nil;
     end;

     pVarLength^:=AllocVarLength(Size);

     if Size<>0 then
     begin
          pField[0]:=kbmffData;
 {$IFNDEF USE_FAST_MOVE}
          Move(Buffer, GetVarLengthData(pVarLength^)^,Size);
 {$ELSE}
          FastMove(Buffer, GetVarLengthData(pVarLength^)^,Size);
 {$ENDIF}
     end
     else
         pField[0]:=kbmffNull;
end;
{$ENDIF}

// Fill record with values for specified fields.
procedure TkbmCustomMemTable.PopulateRecord(ARecord:PkbmRecord; Fields:string; Values:variant);
var
   FieldList:TkbmFieldList;
   i:integer;
   n:integer;
begin
     FieldList := TkbmFieldList.Create;
     try
        BuildFieldList(self,FieldList,Fields);

        n:=VarArrayDimCount(Values);
        if n>1 then raise EMemTableError.Create(kbmVarArrayErr);
        if (n=0) and (FieldList.count>1) then raise EMemTableError.Create(kbmVarReason1Err);
        if FieldList.Count<1 then raise EMemTableError.Create(kbmVarReason2Err);

        // Single value.
        if n=0 then
        begin
             PopulateField(ARecord,FieldList.Fields[0],Values);
             exit;
        end;

        // Several values.
        for i:=0 to FieldList.Count-1 do
        begin
             PopulateField(ARecord,FieldList.Fields[i],Values[i]);
        end;
     finally
        FieldList.free;
     end;
end;

procedure TkbmCustomMemTable.InternalFirst;
begin
     _InternalFirst;
end;

procedure TkbmCustomMemTable.InternalLast;
begin
     _InternalLast;
end;

procedure TkbmCustomMemTable._InternalFirst;
begin
     FRecNo:=-1;
end;

procedure TkbmCustomMemTable._InternalLast;
begin
     FRecNo:=FCurIndex.FReferences.Count;
end;

function TkbmCustomMemTable._InternalNext(ForceUseFilter:boolean):boolean;
var
   pRec:PkbmRecord;
   r:longint;
begin
     // If not filtered.
     if not (ForceUseFilter or IsFiltered) then
     begin
          Result:=(FRecNo<FCurIndex.FReferences.Count-1);
          if Result then Inc(FRecNo);
          exit;
     end;

     // Handle filtering.
     r:=FRecNo+1;
     Result:=false;
     while r<FCurIndex.FReferences.Count do
     begin
          pRec:=PkbmRecord(FCurIndex.FReferences.Items[r]);
          if FilterRecord(pRec,ForceUseFilter) then
          begin
               Result:=true;
               FRecNo:=r;
               break;
          end;
          inc(r);
     end;
end;

function TkbmCustomMemTable._InternalPrior(ForceUseFilter:boolean):boolean;
var
   pRec:PkbmRecord;
begin
     // If not filtered.
     if not (ForceUseFilter or IsFiltered) then
     begin
          Result:=(FRecNo>0);
          if Result then Dec(FRecNo);
          exit;
     end;

     // Handle filtering.
     Result:=false;
     while FRecNo>0 do
     begin
          Dec(FRecNo);
          pRec:=PkbmRecord(FCurIndex.FReferences.Items[FRecNo]);
          if FilterRecord(pRec,ForceUseFilter) then
          begin
               Result:=true;
               break;
          end;
     end;
end;

{$IFDEF DOTNET}
// Getrecord fetches valid nonfiltered record.
// Only fixed record contents are copied to the buffer.
// All varchars are only referenced to record in recordlist.
// All versions are only referenced to recordversions in recordlist.
function TkbmCustomMemTable.GetRecord(Buffer:TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
var
   pRec:PkbmRecord;
   Rec,RecB:TkbmRecord;
   bkMark:TkbmBookmark;
   pbmData:PkbmBookmark;
begin
     case GetMode of
          gmCurrent: begin
                          if FRecNo>=FCurIndex.FReferences.Count then Result:=grEOF
                          else if FRecNo<0 then Result:=grBOF
                          else
                          begin
                               Result:=grOK;
                               if IsFiltered then
                               begin
                                    pRec:=PkbmRecord(FCurIndex.FReferences.Items[FRecNo]);
                                    if not FilterRecord(pRec,false) then Result:=grEOF;
                               end;
                          end;
                     end;
          gmNext:    begin
                          if _InternalNext(false) then Result:=grOK
                          else Result:=grEOF;
                     end;
          gmPrior:   begin
                          if _InternalPrior(false) then Result:=grOK
                          else Result:=grBOF;
                     end;
          else
              Result:=grOK;
     end;
     if Result=grOk then
     begin
          pRec:=PkbmRecord(FCurIndex.FReferences.Items[FRecNo]);

          FCommon._InternalFreeRecordVarLengths (Buffer);
          FCommon._InternalClearRecord(Buffer);

          // Move record contents to avoid copying all versions and varlengths just for scrolling through records.
          FCommon._InternalMoveRecord(pRec,Buffer);

          //fill information part of buffer
          Rec := TkbmRecord (Marshal.PtrToStructure(Buffer,typeOf(TkbmRecord)) );

          with Rec do
          begin
               RecordNo:=FRecNo;
               RecB := TkbmRecord (Marshal.PtrToStructure (pRec,TypeOf(TkbmRecord)));

               RecordID:=RecB.RecordID;
               UniqueRecordID:= RecB.UniqueRecordID;

               // Setup bookmark data.
               pbmData:=PkbmBookmark(IntPtr(integer(Data)+FCommon.FStartBookmarks));

               //Marshal.StructureToPtr(pbmData,p,false);
               pbmData := PkbmBookmark(IntPtr(integer(pbmData)+ FTableID*sizeof(IntPtr)));

               //inc(pbmData,FTableID);
               bkMark := TkbmBookmark(Marshal.PtrToStructure(pbmData,TypeOf(TkbmBookmark)));
               bkMark.Bookmark:=pRec;
               bkMark.Flag:=bfCurrent;
               Flag:=Flag and (not (kbmrfIntable));
               Marshal.StructureToPtr(bkMark,pbmData,false);
               Marshal.StructureToPtr(Rec,Buffer,false);
          end;
          if FRecalcOnFetch then
             GetCalcFields(Buffer);

     end
     else
         if (GetMode=gmCurrent) then Result:=grError;
end;
{$ELSE}
// Getrecord fetches valid nonfiltered record.
// Only fixed record contents are copied to the buffer.
// All varchars are only referenced to record in recordlist.
// All versions are only referenced to recordversions in recordlist.
function TkbmCustomMemTable.GetRecord(Buffer:PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
var
   pRec:PkbmRecord;
   pbmData:PkbmBookmark;
begin
     case GetMode of
          gmCurrent: begin
                          if FRecNo>=FCurIndex.FReferences.Count then Result:=grEOF
                          else if FRecNo<0 then Result:=grBOF
                          else
                          begin
                               Result:=grOK;
                               if IsFiltered then
                               begin
                                    pRec:=PkbmRecord(FCurIndex.FReferences.Items[FRecNo]);
                                    if not FilterRecord(pRec,false) then Result:=grEOF;
                               end;
                          end;
                     end;
          gmNext:    begin
                          if _InternalNext(false) then Result:=grOK
                          else Result:=grEOF;
                     end;
          gmPrior:   begin
                          if _InternalPrior(false) then Result:=grOK
                          else Result:=grBOF;
                     end;
          else
              Result:=grOK;
     end;
     if Result=grOk then
     begin
          pRec:=PkbmRecord(FCurIndex.FReferences.Items[FRecNo]);

          // Fill record part of buffer
          FCommon._InternalFreeRecordVarLengths(PkbmRecord(Buffer));
          FCommon._InternalClearRecord(PkbmRecord(Buffer));

          // Move record contents to avoid copying all versions and varlengths just for scrolling through records.
          FCommon._InternalMoveRecord(pRec,PkbmRecord(Buffer));

          //fill information part of buffer
          with PkbmRecord(Buffer)^ do
          begin
               RecordNo:=FRecNo;
               RecordID:=pRec^.RecordID;
               UniqueRecordID:=pRec^.UniqueRecordID;

               // Setup bookmark data.
               pbmData:=PkbmBookmark(Data+FCommon.FStartBookmarks);
               inc(pbmData,FTableID);
               pbmData^.Bookmark:=pRec;
               pbmData^.Flag:=bfCurrent;

               Flag:=Flag and (not (kbmrfIntable));
          end;
          if FRecalcOnFetch then
             GetCalcFields(Buffer);

     end
     else
         if (GetMode=gmCurrent) then Result:=grError;
end;
{$ENDIF}

function TkbmCustomMemTable.FindRecord(Restart, GoForward: Boolean): Boolean;
var
   Status:boolean;
begin
     CheckBrowseMode;
     DoBeforeScroll;
     SetFound(False);
     UpdateCursorPos;
     CursorPosChanged;

     if GoForward then
     begin
          if Restart then _InternalFirst;
          Status := _InternalNext(true);
     end else
     begin
          if Restart then _InternalLast;
          Status := _InternalPrior(true);
     end;

     if Status then
     begin
          Resync([rmExact, rmCenter]);
          SetFound(True);
     end;
     Result := Found;
     if Result then DoAfterScroll;
end;

{$IFDEF LEVEL5}
// Free filter buffers.
procedure TkbmCustomMemTable.FreeFilter(var AFilterParser:TExprParser);
begin
     if Assigned(AFilterParser) then
     begin
          AFilterParser.free;
          AFilterParser:=nil;
     end;
end;

// Parse filterstring and build new filter.
// Filter operators supported:
// = < > <> <= >= AND OR NULL
// Field Operator Constant Eg: Field1>32 and Field2='ABC'
procedure TkbmCustomMemTable.BuildFilter(var AFilterParser:TExprParser; AFilter:string; AFilterOptions:TFilterOptions);
begin
     if AFilterParser<>nil then
     begin
          AFilterParser.free;
          AFilterParser:=nil;
     end;

     AFilter:=Trim(AFilter);
     if AFilter='' then exit;

     AFilterParser:=TExprParser.Create(self,AFilter,AFilterOptions,[poExtSyntax],'',nil,FldTypeMap);
end;

 {$IFDEF DOTNET}
// Parse build filter.
function TkbmCustomMemTable.ParseFilter(FilterExpr:TExprParser):variant;

  function VIsNull(AVariant:Variant):Boolean;
  begin
       Result:=VarIsNull(AVariant) or VarIsEmpty(AVariant);
  end;
var
   //iVersion,iTotalSize,iNodes,iNodeStart:Word;
   iLiteralStart:Word;

{$WARNINGS OFF}
   function ParseNode(pfdStart,pfd:IntPtr):variant;
   var
      b:WordBool;
      i,z:integer;
      year,mon,day,hour,min,sec,msec:word;

      iClass:NODEClass;
      iOperator:TCANOperator;
      pArg1,pArg2:IntPtr;
      b1:TBytes;
      Arg1,Arg2:variant;
      tstr:string;

      FieldName:String;
      DataType:TFieldType;
      DataOfs:integer;

      ts:TTimeStamp;
      dt:TDateTime;
      cdt:Comp;
      bcd:TBCD;
      cur:Currency;

      PartLength:word;
      IgnoreCase:word;
      S1,S2:string;
   type
      PDouble=^Double;
      PTimeStamp=^TTimeStamp;
      PComp=^Comp;
      PWordBool=^WordBool;
      PBCD=^TBCD;
   begin
        // Get node class.
        iClass := NODEClass(Marshal.ReadInt32(pfd,0));
        iOperator:=TCANOperator(Marshal.ReadInt32 (pfd,4));
        pfd := intPtr (integer(pfd)+CANHDRSIZE);

        //ShowMessage(Format('Class=%d, Operator=%d',[ord(iClass),ord(iOperator)]));

        // Check class.
        case iClass of
            nodeFIELD:
               begin
                    case iOperator of
                         coFIELD2:
                           begin
//                                FieldNo:=PWord(@pfd[0])^ - 1;
                                DataOfs:=iLiteralStart+ Word(Marshal.ReadInt32 (pfd,2));
                                pArg1:=pfdStart;
                                pArg1 := IntPtr(integer(pArg1)+DataOfs);
                                FieldName:=pArg1.ToString;
                                Result:=FieldByName(FieldName).Value;
                           end;
                         else
                             raise EMemTableFilterError.CreateFmt(kbmUnknownOperator,[ord(iOperator)]);
                    end;
               end;

            nodeCONST:
               begin
                    case iOperator of
                         coCONST2:
                           begin
                                DataType:=TFieldType(Word( marshal.ReadInt16 (pfd,0) ));
                                // DataSize:=PWord(@pfd[2])^;
                                DataOfs:=iLiteralStart+Word( marshal.ReadInt16 (pfd,4));
                                pArg1:=pfdStart;
                                pArg1 := IntPtr(integer(PArg1)+DataOfs);

                                // Check type.
                                case DataType of
                                     ftSmallInt, ftWord: Result:= Word( marshal.ReadInt16 (pArg1,0));
                                     ftInteger, ftAutoInc: Result:=Integer( marshal.ReadInt32 (pArg1,0));
                                     ftFloat, ftCurrency: Result:= BitConverter.Int64BitsToDouble(Marshal.ReadInt64(pArg1,0));
{$IFDEF LEVEL10}
                                     ftFixedWideChar,
{$ENDIF}
                                     ftGUID,
                                     ftWideString: Result:= WideString(pArg1.ToString );
                                     ftString,
{$IFDEF LEVEL10}
                                     ftOraInterval,
{$ENDIF}
                                     ftFixedChar: Result:= (pArg1.ToString);
                                     ftDate:
                                       begin
                                            ts.Date:= Integer( marshal.ReadInt32 (pArg1,0));
                                            ts.Time:=0;
                                            dt:=TimeStampToDateTime(ts);
                                            Result:=dt;
                                       end;
                                     ftTime:
                                       begin
                                            ts.Date:=0;
                                            ts.Time:=Integer( marshal.ReadInt32 (pArg1,0));
                                            dt:=TimeStampToDateTime(ts);
                                            Result:=dt;
                                       end;
                                     ftDateTime:
                                       begin
                                            cdt:=(Marshal.ReadInt64(pArg1,0));// PDouble(pArg1)^;
                                            ts:=MSecsToTimeStamp(cdt);
                                            dt:=TimeStampToDateTime(ts);
                                            Result:=dt;
                                       end;
                                     ftBoolean: Result:=WordBool( Marshal.ReadInt16 (pArg1,0));
{$IFDEF LEVEL10}
                                     ftOraTimeStamp,
{$ENDIF}
                                     ftTimeStamp: Result:=VarSQLTimeStampCreate (TSQLTimeStamp(Marshal.PtrToStructure(pArg1, TypeOf(TSQLTimeStamp))));
                                     ftBCD,
                                     ftFmtBCD:
                                       begin
                                            SetLength (b1,SizeOfTBCD);
                                            try
                                              Marshal.Copy(pArg1, B1, 0, SizeOfTBCD);
                                              bcd := TBcd.FromBytes(B1);
                                              BCDToCurr(bcd,Cur);
                                              Result:=Cur;
                                            finally
                                              SetLength (b1,0);
                                            end;
                                       end;

                                     else
                                         raise EMemTableFilterError.CreateFmt(kbmUnknownFieldType,[ord(DataType)]);
                                end;
                           end;
                    end;
               end;

            nodeUNARY:
               begin
                    pArg1:=pfdStart;
                    pArg1 := IntPtr (integer(pArg1)+CANEXPRSIZE+ Word( marshal.ReadInt16 (pfd,0)));

                    case iOperator of
                         coISBLANK,coNOTBLANK:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                b:=VIsNull(Arg1);
                                if iOperator=coNOTBLANK then b:=not b;
                                Result:=Variant(b);
                           end;

                         coNOT:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if VIsNull(Arg1) then
                                   Result:=Null
                                else
                                   Result:=Variant(not Arg1);
                           end;

                         coMINUS:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if not VIsNull(Arg1) then
                                   Result:=-Arg1
                                else
                                    Result:=Null;
                           end;

                         coUPPER:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if not VIsNull(Arg1) then
                                   Result:=UpperCase(Arg1)
                                else
                                    Result:=Null;
                           end;

                         coLOWER:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if not VIsNull(Arg1) then
                                   Result:=LowerCase(Arg1)
                                else
                                    Result:=Null;
                           end;
                    end;
               end;

            nodeBINARY:
               begin
                    // Get Loper and Roper pointers to buffer.
                    pArg1:=pfdStart;
                    pArg1 := IntPtr(integer(pArg1) + CANEXPRSIZE+ Word( marshal.ReadInt16 (pfd,0)));
                    pArg2:=pfdStart;
                    pArg2 :=  IntPtr(integer(pArg2) + CANEXPRSIZE+Word( marshal.ReadInt16 (pfd,2)));

                    // Check operator for what to do.
                    case iOperator of
                         coEQ:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 = Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coNE:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 <> Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coGT:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 > Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coGE:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 >= Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coLT:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 < Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coLE:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 <= Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coOR:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 or Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coAND:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 and Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coADD:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 + Arg2);
                                exit;
                           end;

                         coSUB:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 - Arg2);
                                exit;
                           end;

                         coMUL:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 * Arg2);
                                exit;
                           end;

                         coDIV:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 / Arg2);
                                exit;
                           end;

                         coMOD,coREM:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 mod Arg2);
                                exit;
                           end;

                         coIN:
                           begin
                                Arg1:=ParseNode(PfdStart,pArg1);
                                Arg2:=ParseNode(PfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then
                                begin
                                     Result:=false;
                                     exit;
                                end;

                                if VarIsArray(Arg2) then
                                begin
                                     b:=false;
                                     for i:=0 to VarArrayHighBound(Arg2,1) do
                                     begin
                                          if VarIsEmpty(Arg2[i]) then break;
                                          b:=(Arg1=Arg2[i]);
                                          if b then break;
                                     end;
                                end
                                else
                                    b:=(Arg1=Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coLike:
                           begin
                                Arg1:=ParseNode(PfdStart,pArg1);
                                Arg2:=ParseNode(PfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then
                                begin
                                     Result:=false;
                                     exit;
                                end;
                                b:=MatchesMask (Arg1.ToString,Arg2.ToString);
                                Result:=Variant(b);
                                exit;
                           end;

                         else
                             raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;

            nodeCOMPARE:
               begin
                    IgnoreCase:=Word( marshal.ReadInt16 (pfd,0));
                    PartLength:=Word( Marshal.ReadInt16 (pfd,2));
                    pArg1:=IntPtr(integer(pfdStart)+  CANEXPRSIZE+Word( Marshal.ReadInt16 (pfd,4)));
                    pArg2:=IntPtr(integer(pfdStart)+CANEXPRSIZE+Word( Marshal.ReadInt16 (pfd,6)));
                    Arg1:=ParseNode(pfdStart,pArg1);
                    Arg2:=ParseNode(pfdStart,pArg2);
                    if VIsNull(Arg1) or VIsNull(Arg2) then
                    begin
                         Result:=false;
                         exit;
                    end;

                    S1:=Arg1;
                    S2:=Arg2;
                    if IgnoreCase=1 then
                    begin
                         S1:=AnsiUpperCase(S1);
                         S2:=AnsiUpperCase(S2);
                    end;
                    if PartLength>0 then
                    begin
                         S1:=Copy(S1,1,PartLength);
                         S2:=Copy(S2,1,PartLength);
                    end;

                    case iOperator of
                         coEQ:
                            begin
                                 b:=(S1 = S2);
                                 Result:=Variant(b);
                                 exit;
                            end;

                         coNE:
                            begin
                                 b:=(S1 <> S2);
                                 Result:=Variant(b);
                                 exit;
                            end;

                         coLIKE:
                            begin
                                 b:=MatchesMask(pArg1.ToString,pArg2.ToString);
                                 Result:=Variant(b);
                                 exit;
                            end;

                         else
                             raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;

            nodeFUNC:
               begin
                    case iOperator of
                         coFUNC2:
                            begin
                                 pArg1:=pfdStart;
                                 pArg1 := IntPtr(integer(pArg1)+iLiteralStart+ Word( Marshal.ReadInt16 (pfd,0)));
                                 //pArg1:= AnsiUpperCase(pArg1.ToString);  // Function name
                                 pArg2:=pfdStart;
                                 pArg2 := IntPtr(integer(pArg2) + CANEXPRSIZE + Word( Marshal.ReadInt16 (pfd,2))); // Pointer to Value or Const

                                 if pArg1.ToString.ToUpper ='UPPER' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=UpperCase(VarToStr(Arg2));
                                 end

                                 else if pArg1.ToString.ToUpper='LOWER' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=LowerCase(VarToStr(Arg2));
                                 end

                                 else if pArg1.ToString.ToUpper='SUBSTRING' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then
                                      begin
                                           Result:=Null;
                                           exit;
                                      end;

                                      Result:=Arg2;
                                      try
                                         Marshal.WriteByte (pArg1,0,(Result[0]));
                                         //pArg1:=pChar(VarToStr(Result[0]));
                                      except
                                         on EVariantError do // no Params for "SubString"
                                            raise EMemTableFilterError.CreateFmt(kbmInvMissParam,[pArg1]);
                                      end;

                                      i:=Result[1];
                                      z:=Result[2];
                                      if (z=0) then
                                      begin
                                           if (Pos(',',Result[1])>0) then  // "From" and "To" entered without space!
                                              z:=StrToInt(Copy(Result[1],Pos(',',Result[1])+1,Length(Result[1])))
                                           else                            // No "To" entered so use all

                                              z:=Length(pArg1.ToString);
                                      end;
                                      Result:=Copy (pArg1.ToString,i,z);
                                 end

                                 else if pArg1.ToString.ToUpper='TRIM' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=Trim(VarToStr(Arg2));
                                 end

                                 else if pArg1.ToString.ToUpper='TRIMLEFT' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=TrimLeft(VarToStr(Arg2));
                                 end

                                 else if pArg1.ToString.ToUpper='TRIMRIGHT' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=TrimRight(VarToStr(Arg2));
                                 end

                                 else if pArg1.ToString.ToUpper='GETDATE' then
                                    Result:=Now

                                 else if pArg1.ToString.ToUpper='YEAR' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeDate (strToDateTime (Arg2.ToString),year,mon,day);
                                           Result:=year;
                                      end;
                                 end


                                 else if pArg1.ToString.ToUpper='MONTH' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeDate(StrToDateTime(Arg2.ToString),year,mon,day);
                                           Result:=mon;
                                      end;
                                 end

                                 else if pArg1.ToString.ToUpper='DAY' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeDate(StrToDateTime(Arg2.ToString),year,mon,day);
                                           Result:=day;
                                      end;
                                 end

                                 else if pArg1.ToString.ToUpper='HOUR' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeTime(StrToDateTime(Arg2.ToString),hour,min,sec,msec);
                                           Result:=hour;
                                      end;
                                 end

                                 else if pArg1.ToString.ToUpper='MINUTE' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeTime(StrToDateTime(Arg2.ToString),hour,min,sec,msec);
                                           Result:=min;
                                      end;
                                 end

                                 else if pArg1.ToString.ToUpper='SECOND' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeTime(StrToDateTime(Arg2.ToString),hour,min,sec,msec);
                                           Result:=sec;
                                      end;
                                 end

                                 else if pArg1.ToString.ToUpper='DATE' then  // Format DATE('datestring','formatstring')
                                 begin                      // or     DATE(datevalue)
                                      Result:=ParseNode(pfdStart,pArg2);
                                      if VarIsArray(Result) then
                                      begin
                                           try
                                              Marshal.WriteByte(pArg1,0,Result[0]);
                                              //pArg1:=VarToStr(Result[0]));
                                              Marshal.WriteByte(pArg2,0,Result[1]);
                                              //pArg2:=VarToStr(Result[1]));
                                           except
                                              on EVariantError do // no Params for DATE
                                                 raise EMemTableFilterError.CreateFmt(kbmInvMissParam,[pArg1]);
                                           end;

                                           tstr:=ShortDateFormat;
                                           try
                                              ShortDateFormat:=pArg2.ToString;
                                              Result:=StrToDate(pArg1.ToString);
                                           finally
                                              ShortDateFormat:=tstr;
                                           end;
                                      end
                                      else
                                          Result:=longint(trunc(StrToDateTime(Result)));
                                 end

                                 else if pArg1.ToString.ToUpper='TIME' then  // Format TIME('timestring','formatstring')
                                 begin                      // or     TIME(datetimevalue)
                                      Result:=ParseNode(pfdStart,pArg2);
                                      if VarIsArray(Result) then
                                      begin
                                           try
                                              pArg1 := IntPtr(Result[0]);
                                              //pArg1:=(VarToStr(Result[0]));
                                              //pArg2:=PChar(VarToStr(Result[1]));
                                              pArg2 := IntPtr (Result[1]);
                                           except
                                              on EVariantError do // no Params for TIME
                                                 raise EMemTableFilterError.CreateFmt(kbmInvMissParam,[pArg1]);
                                           end;

                                           tstr:=ShortTimeFormat;
                                           try
                                              ShortTimeFormat:=pArg2.ToString;
                                              Result:=StrToTime(pArg1.ToString);
                                           finally
                                              ShortTimeFormat:=tstr;
                                           end;
                                      end
                                      else
                                          Result:=Frac(StrToDateTime(Result));
                                 end

                                 else
                                    raise EMemTableFilterError.CreateFmt(kbmInvFunction,[pArg1]);
                            end;
                         else
                            raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;

            nodeLISTELEM:
               begin
                    case iOperator of
                         coLISTELEM2:
                            begin
                                 Result:=VarArrayCreate([0,50],VarVariant); // Create VarArray for ListElements Values
                                 i:=0;
                                 pArg1:=pfdStart;
                                 pArg1 := IntPtr (integer(pArg1)+CANEXPRSIZE+ Word( marshal.ReadInt16 (pfd,(i*2))));
                                 repeat
                                       Arg1:=ParseNode(PfdStart,parg1);
                                       if VarIsArray(Arg1) then
                                       begin
                                            z:=0;
                                            while not VarIsEmpty(Arg1[z]) do
                                            begin
                                                 Result[i+z]:=Arg1[z];
                                                 inc(z);
                                            end;
                                       end
                                       else
                                          Result[i]:=Arg1;

                                       inc(i);
                                       pArg1 := pfdStart;
                                       pArg1 := IntPtr (integer(pArg1)+CANEXPRSIZE+ Word( marshal.ReadInt16 (pfd,(i*2))));
                                 until NODEClass(Marshal.ReadInt32(pArg1,0))<>NodeListElem;

                                 // Only one or no Value so don't return as VarArray
                                 if i<2 then
                                 begin
                                      if VIsNull(Result[0]) then
                                         Result:=Null
                                      else
                                          Result:=VarAsType(Result[0],varString);
                                 end;
                            end;
                         else
                            raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;
        else
            raise EMemTableFilterError.CreateFmt('iClass '+kbmOutOfRange,[ord(iClass)]);
        end;
   end;
 {$WARNINGS ON}

var
   pfdStart,pfd:IntPtr;
begin
     marshal.WriteByte(pfdStart,FilterExpr.FilterData[0]);
     pfd:=pfdStart;

     iLiteralStart:=word(marshal.ReadInt16 (pfd,8));
     pfd := IntPtr(integer (pfd)+10);

     // Show header.
     Result:=ParseNode(pfdStart,pfd);
end;

 {$ELSE}

// Parse build filter.
function TkbmCustomMemTable.ParseFilter(FilterExpr:TExprParser):variant;

  function VIsNull(AVariant:Variant):Boolean;
  begin
       Result:=VarIsNull(AVariant) or VarIsEmpty(AVariant);
  end;
var
   //iVersion,iTotalSize,iNodes,iNodeStart:Word;
   iLiteralStart:Word;

   function ParseNode(pfdStart,pfd:PChar):variant;
   var
      b:WordBool;
      i,z:integer;
      year,mon,day,hour,min,sec,msec:word;

      iClass:NODEClass;
      iOperator:TCANOperator;
      pArg1,pArg2:PChar;
      Arg1,Arg2:variant;
      tstr:string;

      //     FieldNo:integer;
      FieldName:String;
      DataType:TFieldType;
      DataOfs:integer;
      //     DataSize:integer;

      ts:TTimeStamp;
      dt:TDateTime;
      cdt:Comp;
      bcd:TBCD;
      cur:Currency;

      PartLength:word;
      IgnoreCase:word;
      S1,S2:string;
   type
      PDouble=^Double;
      PTimeStamp=^TTimeStamp;
      PComp=^Comp;
      PWordBool=^WordBool;
      PBCD=^TBCD;
   begin
        // Get node class.
        iClass:=NODEClass(PInteger(@pfd[0])^);
        iOperator:=TCANOperator(PInteger(@pfd[4])^);
        inc(pfd,CANHDRSIZE);

        //ShowMessage(Format('Class=%d, Operator=%d',[ord(iClass),ord(iOperator)]));

        // Check class.
        case iClass of
            nodeFIELD:
               begin
                    case iOperator of
                         coFIELD2:
                           begin
//                                FieldNo:=PWord(@pfd[0])^ - 1;
                                DataOfs:=iLiteralStart+PWord(@pfd[2])^;
                                pArg1:=pfdStart;
                                inc(pArg1,DataOfs);
                                FieldName:=String(pArg1);
                                Result:=FieldByName(FieldName).Value;
                           end;
                         else
                             raise EMemTableFilterError.CreateFmt(kbmUnknownOperator,[ord(iOperator)]);
                    end;
               end;

            nodeCONST:
               begin
                    case iOperator of
                         coCONST2:
                           begin
                                DataType:=TFieldType(PWord(@pfd[0])^);
                                // DataSize:=PWord(@pfd[2])^;
                                DataOfs:=iLiteralStart+PWord(@pfd[4])^;
                                pArg1:=pfdStart;
                                inc(pArg1,DataOfs);

                                // Check type.
                                case DataType of
                                     ftSmallInt, ftWord: Result:=PWord(pArg1)^;
                                     ftInteger, ftAutoInc: Result:=PInteger(pArg1)^;
                                     ftFloat, ftCurrency: Result:=PDouble(pArg1)^;
{$IFDEF LEVEL10}
                                     ftFixedWideChar,
{$ENDIF}
                                     ftGUID,
                                     ftWideString: Result:=PWideString(pArg1)^;
{$IFDEF LEVEL10}
                                     ftOraInterval,
{$ENDIF}
                                     ftString,
                                     ftFixedChar: Result:=String(pArg1);
                                     ftDate:
                                       begin
                                            ts.Date:=PInteger(pArg1)^;
                                            ts.Time:=0;
                                            dt:=TimeStampToDateTime(ts);
                                            Result:=dt;
                                       end;
                                     ftTime:
                                       begin
                                            ts.Date:=0;
                                            ts.Time:=PInteger(pArg1)^;;
                                            dt:=TimeStampToDateTime(ts);
                                            Result:=dt;
                                       end;
                                     ftDateTime:
                                       begin
                                            cdt:=PDouble(pArg1)^;
                                            ts:=MSecsToTimeStamp(cdt);
                                            dt:=TimeStampToDateTime(ts);
                                            Result:=dt;
                                       end;
                                     ftBoolean: Result:=PWordBool(pArg1)^;
  {$IFDEF LEVEL6}
   {$IFDEF LEVEL10}
                                     ftOraTimeStamp,
   {$ENDIF}
                                     ftTimeStamp: Result:=VarSQLTimeStampCreate(PSQLTimeStamp(pArg1)^);
  {$ENDIF}
                                     ftBCD
  {$IFDEF LEVEL6}
                                     ,ftFmtBCD
  {$ENDIF}
                                     :
                                       begin
                                            bcd:=PBCD(pArg1)^;
                                            BCDToCurr(bcd,Cur);
                                            Result:=Cur;
                                       end;

                                     else
                                         raise EMemTableFilterError.CreateFmt(kbmUnknownFieldType,[ord(DataType)]);
                                end;
                           end;
                    end;
               end;

            nodeUNARY:
               begin
                    pArg1:=pfdStart;
                    inc(pArg1,CANEXPRSIZE+PWord(@pfd[0])^);

                    case iOperator of
                         coISBLANK,coNOTBLANK:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                b:=VIsNull(Arg1);
                                if iOperator=coNOTBLANK then b:=not b;
                                Result:=Variant(b);
                           end;

                         coNOT:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if VIsNull(Arg1) then
                                   Result:=Null
                                else
                                   Result:=Variant(not Arg1);
                           end;

                         coMINUS:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if not VIsNull(Arg1) then
                                   Result:=-Arg1
                                else
                                    Result:=Null;
                           end;

                         coUPPER:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if not VIsNull(Arg1) then
                                   Result:=UpperCase(Arg1)
                                else
                                    Result:=Null;
                           end;

                         coLOWER:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                if not VIsNull(Arg1) then
                                   Result:=LowerCase(Arg1)
                                else
                                    Result:=Null;
                           end;
                    end;
               end;

            nodeBINARY:
               begin
                    // Get Loper and Roper pointers to buffer.
                    pArg1:=pfdStart;
                    inc(pArg1,CANEXPRSIZE+PWord(@pfd[0])^);
                    pArg2:=pfdStart;
                    inc(pArg2,CANEXPRSIZE+PWord(@pfd[2])^);

                    // Check operator for what to do.
                    case iOperator of
                         coEQ:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 = Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coNE:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 <> Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coGT:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 > Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coGE:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 >= Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coLT:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 < Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coLE:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 <= Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coOR:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 or Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coAND:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then b:=false
                                else b:=(Arg1 and Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coADD:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 + Arg2);
                                exit;
                           end;

                         coSUB:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 - Arg2);
                                exit;
                           end;

                         coMUL:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 * Arg2);
                                exit;
                           end;

                         coDIV:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 / Arg2);
                                exit;
                           end;

                         coMOD,coREM:
                           begin
                                Arg1:=ParseNode(pfdStart,pArg1);
                                Arg2:=ParseNode(pfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then Result:=Null
                                else Result:=(Arg1 mod Arg2);
                                exit;
                           end;

                         coIN:
                           begin
                                Arg1:=ParseNode(PfdStart,pArg1);
                                Arg2:=ParseNode(PfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then
                                begin
                                     Result:=false;
                                     exit;
                                end;

                                if VarIsArray(Arg2) then
                                begin
                                     b:=false;
                                     for i:=0 to VarArrayHighBound(Arg2,1) do
                                     begin
                                          if VarIsEmpty(Arg2[i]) then break;
                                          b:=(Arg1=Arg2[i]);
                                          if b then break;
                                     end;
                                end
                                else
                                    b:=(Arg1=Arg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         coLike:
                           begin
                                Arg1:=ParseNode(PfdStart,pArg1);
                                Arg2:=ParseNode(PfdStart,pArg2);
                                if VIsNull(Arg1) or VIsNull(Arg2) then
                                begin
                                     Result:=false;
                                     exit;
                                end;
                                pArg1:=pChar(VarToStr(Arg1));
                                pArg2:=pChar(VarToStr(Arg2));
                                b:=MatchesMask(pArg1,pArg2);
                                Result:=Variant(b);
                                exit;
                           end;

                         else
                             raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;

            nodeCOMPARE:
               begin
                    IgnoreCase:=PWord(@pfd[0])^;
                    PartLength:=PWord(@pfd[2])^;
                    pArg1:=pfdStart+CANEXPRSIZE+PWord(@pfd[4])^;
                    pArg2:=pfdStart+CANEXPRSIZE+PWord(@pfd[6])^;
                    Arg1:=ParseNode(pfdStart,pArg1);
                    Arg2:=ParseNode(pfdStart,pArg2);
                    if VIsNull(Arg1) or VIsNull(Arg2) then
                    begin
                         Result:=false;
                         exit;
                    end;

                    S1:=Arg1;
                    S2:=Arg2;
                    if IgnoreCase=1 then
                    begin
                         S1:=AnsiUpperCase(S1);
                         S2:=AnsiUpperCase(S2);
                    end;
                    if PartLength>0 then
                    begin
                         S1:=Copy(S1,1,PartLength);
                         S2:=Copy(S2,1,PartLength);
                    end;

                    case iOperator of
                         coEQ:
                            begin
                                 b:=(S1 = S2);
                                 Result:=Variant(b);
                                 exit;
                            end;

                         coNE:
                            begin
                                 b:=(S1 <> S2);
                                 Result:=Variant(b);
                                 exit;
                            end;

                         coLIKE:
                            begin
                                 pArg1:=pChar(VarToStr(ParseNode(pfdStart,pArg1)));
                                 pArg2:=pChar(VarToStr(ParseNode(pfdStart,pArg2)));
                                 b:=MatchesMask(pArg1,pArg2);
                                 Result:=Variant(b);
                                 exit;
                            end;

                         else
                             raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;

            nodeFUNC:
               begin
                    case iOperator of
                         coFUNC2:
                            begin
                                 pArg1:=pfdStart;
                                 inc(pArg1,iLiteralStart+PWord(@pfd[0])^);
                                 pArg1:=pChar(AnsiUpperCase(pArg1));  // Function name
                                 pArg2:=pfdStart;
                                 inc(pArg2,CANEXPRSIZE+PWord(@pfd[2])^); // Pointer to Value or Const

                                 if pArg1='UPPER' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=UpperCase(VarToStr(Arg2));
                                 end

                                 else if pArg1='LOWER' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=LowerCase(VarToStr(Arg2));
                                 end

                                 else if pArg1='SUBSTRING' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then
                                      begin
                                           Result:=Null;
                                           exit;
                                      end;

                                      Result:=Arg2;
                                      try
                                         pArg1:=pChar(VarToStr(Result[0]));
                                      except
                                         on EVariantError do // no Params for "SubString"
                                            raise EMemTableFilterError.CreateFmt(kbmInvMissParam,[pArg1]);
                                      end;

                                      i:=Result[1];
                                      z:=Result[2];
                                      if (z=0) then
                                      begin
                                           if (Pos(',',Result[1])>0) then  // "From" and "To" entered without space!
                                              z:=StrToInt(Copy(Result[1],Pos(',',Result[1])+1,Length(Result[1])))
                                           else                            // No "To" entered so use all
                                              z:=Length(pArg1);
                                      end;
                                      Result:=Copy(pArg1,i,z);
                                 end

                                 else if pArg1='TRIM' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=Trim(VarToStr(Arg2));
                                 end

                                 else if pArg1='TRIMLEFT' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=TrimLeft(VarToStr(Arg2));
                                 end

                                 else if pArg1='TRIMRIGHT' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else Result:=TrimRight(VarToStr(Arg2));
                                 end

                                 else if pArg1='GETDATE' then
                                    Result:=Now

                                 else if pArg1='YEAR' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeDate(VarToDateTime(Arg2),year,mon,day);
                                           Result:=year;
                                      end;
                                 end


                                 else if pArg1='MONTH' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeDate(VarToDateTime(Arg2),year,mon,day);
                                           Result:=mon;
                                      end;
                                 end

                                 else if pArg1='DAY' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeDate(VarToDateTime(Arg2),year,mon,day);
                                           Result:=day;
                                      end;
                                 end

                                 else if pArg1='HOUR' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeTime(VarToDateTime(Arg2),hour,min,sec,msec);
                                           Result:=hour;
                                      end;
                                 end

                                 else if pArg1='MINUTE' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeTime(VarToDateTime(Arg2),hour,min,sec,msec);
                                           Result:=min;
                                      end;
                                 end

                                 else if pArg1='SECOND' then
                                 begin
                                      Arg2:=ParseNode(pfdStart,pArg2);
                                      if VIsNull(Arg2) then Result:=Null
                                      else
                                      begin
                                           DecodeTime(VarToDateTime(Arg2),hour,min,sec,msec);
                                           Result:=sec;
                                      end;
                                 end

                                 else if pArg1='DATE' then  // Format DATE('datestring','formatstring')
                                 begin                      // or     DATE(datevalue)
                                      Result:=ParseNode(pfdStart,pArg2);
                                      if VarIsArray(Result) then
                                      begin
                                           try
                                              pArg1:=PChar(VarToStr(Result[0]));
                                              pArg2:=PChar(VarToStr(Result[1]));
                                           except
                                              on EVariantError do // no Params for DATE
                                                 raise EMemTableFilterError.CreateFmt(kbmInvMissParam,[pArg1]);
                                           end;

                                           tstr:=ShortDateFormat;
                                           try
                                              ShortDateFormat:=pArg2;
                                              Result:=StrToDate(pArg1);
                                           finally
                                              ShortDateFormat:=tstr;
                                           end;
                                      end
                                      else
                                          Result:=longint(trunc(VarToDateTime(Result)));
                                 end

                                 else if pArg1='TIME' then  // Format TIME('timestring','formatstring')
                                 begin                      // or     TIME(datetimevalue)
                                      Result:=ParseNode(pfdStart,pArg2);
                                      if VarIsArray(Result) then
                                      begin
                                           try
                                              pArg1:=PChar(VarToStr(Result[0]));
                                              pArg2:=PChar(VarToStr(Result[1]));
                                           except
                                              on EVariantError do // no Params for TIME
                                                 raise EMemTableFilterError.CreateFmt(kbmInvMissParam,[pArg1]);
                                           end;

                                           tstr:=ShortTimeFormat;
                                           try
                                              ShortTimeFormat:=pArg2;
                                              Result:=StrToTime(pArg1);
                                           finally
                                              ShortTimeFormat:=tstr;
                                           end;
                                      end
                                      else
                                          Result:=Frac(VarToDateTime(Result));
                                 end

                                 else
                                    raise EMemTableFilterError.CreateFmt(kbmInvFunction,[pArg1]);
                            end;
                         else
                            raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;

            nodeLISTELEM:
               begin
                    case iOperator of
                         coLISTELEM2:
                            begin
                                 Result:=VarArrayCreate([0,50],VarVariant); // Create VarArray for ListElements Values
                                 i:=0;
                                 pArg1:=pfdStart;
                                 inc(pArg1,CANEXPRSIZE+PWord(@pfd[i*2])^);

                                 repeat
                                       Arg1:=ParseNode(PfdStart,parg1);
                                       if VarIsArray(Arg1) then
                                       begin
                                            z:=0;
                                            while not VarIsEmpty(Arg1[z]) do
                                            begin
                                                 Result[i+z]:=Arg1[z];
                                                 inc(z);
                                            end;
                                       end
                                       else
                                          Result[i]:=Arg1;

                                       inc(i);
                                       pArg1:=pfdStart;
                                       inc(pArg1,CANEXPRSIZE+PWord(@pfd[i*2])^);
                                 until NODEClass(PInteger(@pArg1[0])^)<>NodeListElem;

                                 // Only one or no Value so don't return as VarArray
                                 if i<2 then
                                 begin
                                      if VIsNull(Result[0]) then
                                         Result:=Null
                                      else
                                          Result:=VarAsType(Result[0],varString);
                                 end;
                            end;
                         else
                            raise EMemTableFilterError.CreateFmt(kbmOperatorNotSupported,[ord(iOperator)]);
                    end;
               end;
        else
            raise EMemTableFilterError.CreateFmt('iClass '+kbmOutOfRange,[ord(iClass)]);
        end;
   end;
  {$WARNINGS ON}

var
   pfdStart,pfd:PChar;
begin
     pfdStart:=@FilterExpr.FilterData[0];
     pfd:=pfdStart;

     // Get header.
     //     iVersion:=PWord(@pfd[0])^;
     //     iTotalSize:=PWord(@pfd[2])^;
     //     iNodes:=PWord(@pfd[4])^;
     //     iNodeStart:=PWord(@pfd[6])^;
     iLiteralStart:=PWord(@pfd[8])^;
     inc(pfd,10);

     // Show header.
{
     ShowMessage(Format('Version=%d, TotalSize=%d, Nodes=%d, NodeStart=%d, LiteralStart=%d',
        [iVersion,iTotalSize,iNodes,iNodeStart,iLiteralStart]));

     s:='';
     for i:=0 to FFilterParser.DataSize-1 do
     begin
          b:=FFilterParser.FilterData[i];
          if (b>=32) and (b<=127) then s1:=chr(b)
          else s1:=' ';
          s:=s+Format('%d=%0.2x%s ',[i,FFilterParser.FilterData[i],s1]);
     end;
     ShowMessage(s);
}
     Result:=ParseNode(pfdStart,pfd);
end;
 {$ENDIF} // DOTNET
{$ENDIF} // LEVEL5

// Filter record according to filterexpression.
function TkbmCustomMemTable.FilterExpression(ARecord:PkbmRecord;AFilterParser:TExprParser):boolean;
var
   noderes:variant;
   oldrec:PkbmRecord;
begin
     oldrec:=FOverrideActiveRecordBuffer;
     try
        FOverrideActiveRecordBuffer:=ARecord;
        noderes:=ParseFilter(AFilterParser);
        Result:=(WordBool(noderes)=true);
     finally
        FOverrideActiveRecordBuffer:=oldrec;
     end;
//     ShowMessage(Format('noderes=%d Result=%d',[integer(noderes),ord(Result)]));
end;

// Is any record filtering applied.
// Could be master/detail or userdefined filter.
procedure TkbmCustomMemTable.SetIsFiltered;
begin
     FCommon.Lock;
     try
        FIsFiltered:=(FStatusFilter<>[]) or
             ((FCommon.FDeletedCount>0) and not (usDeleted in FStatusFilter)) or
             (Filtered and ({$IFDEF LEVEL5}Assigned(FFilterParser) or {$ENDIF}Assigned(OnFilterRecord)))
             or (FMasterLinkUsed and Assigned(FMasterLink.DataSource) and (FMasterLink.FieldNames<>'') and ((FDetailIndexList.Count>0) or (FIndexList.Count>0)))
             or (FRangeActive);
     finally
        FCommon.Unlock;
     end;
end;

// Filter record according to master table.
function TkbmCustomMemTable.FilterMasterDetail(ARecord:PkbmRecord):boolean;
var
   aList:TkbmFieldList;
begin
     if (FDetailIndexList.Count<=0) then
        aList:=FIndexList
     else
         aList:=FDetailIndexList;
     Result:=FCommon._InternalCompareRecords(aList,FMasterLink.Fields.Count,FKeyBuffers[kbmkbMasterDetail],ARecord,false,false,chBreakNE)=0;
end;

// Filter record according to range.
function TkbmCustomMemTable.FilterRange(ARecord:PkbmRecord): Boolean;
begin
     Result:=(FCommon._InternalCompareRecords(FIndexList,-1,FKeyBuffers[kbmkbRangeStart],ARecord,FRangeIgnoreNullKeyValues,false,chBreakGT)<=0)
             and (FCommon._InternalCompareRecords(FIndexList,-1,FKeyBuffers[kbmkbRangeEnd],ARecord,FRangeIgnoreNullKeyValues,false,chBreakLT)>=0);
end;

// Filter records in general for
// master/detail, range and userdefined filter.
function TkbmCustomMemTable.FilterRecord(ARecord:PkbmRecord; ForceUseFilter:boolean): Boolean;
var
   SaveState: TDatasetState;
{$IFDEF DOTNET}
   aRec:TkbmRecord;
{$ENDIF}
label
   L_Exit;
begin
     Result:=True;
     if not (ForceUseFilter or IsFiltered) then Exit;

     // Check if record is deleted, but versioning.
{$IFDEF DOTNET}
     ARec := TkbmRecord (Marshal.PtrToStructure(ARecord,TypeOf(TkbmRecord) ) );
     if ((FStatusFilter<>[]) and not (ARec.UpdateStatus in FStatusFilter)) then
     begin
          Result:=False;
          exit;
     end;
{$ELSE}
     if ((FStatusFilter<>[]) and not (ARecord^.UpdateStatus in FStatusFilter)) then
     begin
          Result:=False;
          exit;
     end;
{$ENDIF}

     // Now we will apply the filters on the record.
     SaveState:=SetTempState(dsFilter);
     FFilterRecord:=ARecord;

     // Check if to recalc before compare.
     if FRecalcOnIndex then
     begin
          __ClearCalcFields({$IFDEF DOTNET}ARecord{$ELSE}PChar(ARecord){$ENDIF});
          __GetCalcFields({$IFDEF DOTNET}ARecord{$ELSE}PChar(ARecord){$ENDIF});
     end;

     // Check if range filtering.
     if FRangeActive then
     begin
          Result:=FilterRange(ARecord);
          if not Result then goto L_exit;
     end;

     // Check if master/detail filtering.
     if FMasterLinkUsed and Assigned(FMasterLink.DataSource) and (FMasterLink.FieldNames<>'') and ((FDetailIndexList.Count>0) or (FIndexList.Count>0)) then
     begin
          Result:=FilterMasterDetail(ARecord);
          if not Result then goto L_Exit;
     end;

     // Check filters.
     if ForceUseFilter or Filtered then
     begin
          // Call users own filtering if specified.
          DoOnFilterRecord(self,Result);
          if not Result then goto L_Exit;

{$IFDEF LEVEL5}
          // Check if filterstring active.
          if Assigned(FFilterParser) then
          begin
               Result:=FilterExpression(ARecord,FFilterParser);
               if not Result then goto L_exit;
          end;
{$ENDIF}
     end;

L_Exit:
     // Finished filtering.
     RestoreState(SaveState);
end;

{$IFDEF LEVEL5}
// Test an user filter against to the current record
function TkbmCustomMemTable.TestFilter(const AFilter:string; AFilterOptions:TFilterOptions):boolean;
var
   parser: TExprParser;
begin
     Result:=Active;
     if (AFilter='') or not Active then exit;
     parser:=nil;
     try
        BuildFilter(parser,AFilter,AFilterOptions);
        Result:=FilterExpression(GetActiveRecord,parser);
     finally
        if parser<>nil then FreeFilter(parser);
     end;
end;
{$ENDIF}

{$IFDEF DOTNET}
procedure TkbmCustomMemTable.InternalSetToRecord(Buffer:TRecordBuffer);
var
   pb:PkbmRecord;
   pbUser:PkbmUserBookmark;
   pbmData:PkbmBookmark;
   bkMark:TkbmUserBookmark;
   Rec:TkbmRecord;
begin
     if Buffer=nil then exit;
     Rec:=TkbmRecord(Marshal.PtrToStructure(Buffer,typeOf(TkbmRecord)));
     if Rec.RecordNo<>-1 then
     begin
          FRecNo:= Rec.RecordNo;
          exit;
     end;

     // If record number not readily available search for it.
//     Rec:=TkbmRecord (Marshal.PtrToStructure (Buffer,TypeOf (TkbmRecord) ) );
     pbmData:=PkbmBookmark(integer(Rec.Data) + FCommon.FStartBookmarks);
     pbmData:=IntPtr(integer(pbmData)+FTableID*sizeof(IntPtr));
     InternalGotoBookmark(pbmData);
end;
{$ELSE}
procedure TkbmCustomMemTable.InternalSetToRecord(Buffer:PChar);
var
   pb:PkbmRecord;
   pbUser:PkbmUserBookmark;
   pbmData:PkbmBookmark;
begin
     if Buffer=nil then exit;
     pbUser:=PkbmUserBookmark(@Buffer);
     pb:=pbUser^.Bookmark;
     if pb=nil then exit;
     if pb.RecordNo<>-1 then
     begin
          FRecNo:=pb.RecordNo;
          exit;
     end;

     // If record number not readily available search for it.
     pbmData:=PkbmBookmark(PkbmRecord(Buffer).Data+FCommon.FStartBookmarks);
     inc(pbmData,FTableID);
     InternalGotoBookmark(pbmData);
end;
{$ENDIF}

function TkbmCustomMemTable.GetRecordCount: integer;
var
   SaveState: TDataSetState;
   SavePosition: integer;
{$IFDEF DOTNET}
   TempBuffer: IntPtr;
{$ELSE}
   TempBuffer: PChar;
{$ENDIF}
begin
     if not Active then DatabaseError(SDatasetClosed{$IFNDEF LEVEL3}, Self{$ENDIF});

     if not IsFiltered then Result:=FCurIndex.FReferences.Count
     else
     begin
          Result:=0;
          SaveState:=SetTempState(dsBrowse);
          SavePosition:=FRecNo;
{$IFDEF DOTNET}
          TempBuffer := (FCommon._InternalAllocRecord);
{$ELSE}
          TempBuffer:=PChar(FCommon._InternalAllocRecord);
{$ENDIF}
          try
             InternalFirst;
             while GetRecord(TempBuffer,gmNext,True)=grOk do Inc(Result);
          finally
             RestoreState(SaveState);
             FRecNo:=SavePosition;
{$IFDEF DOTNET}
             FCommon._InternalFreeRecord(PkbmRecord(TempBuffer),false,false);
{$ELSE}
             FCommon._InternalFreeRecord(PkbmRecord(TempBuffer),false,false);
{$ENDIF}
          end;
     end;
end;

{$IFDEF DOTNET}
function TkbmCustomMemTable.GetRecNo: integer;
var
   Rec:TkbmRecord;
begin
     Rec:=TkbmRecord (Marshal.PtrToStructure(ActiveBuffer,TypeOF(TkbmRecord)));
     if (State=dsInactive) or (ActiveBuffer=nil) or IsEmpty or (Rec.RecordNo<0) then Result:=-1
     else Result:= rec.RecordNo+1;
end;
{$ELSE}
function TkbmCustomMemTable.GetRecNo: integer;
begin
     if (State=dsInactive) or (ActiveBuffer=nil) or IsEmpty or (PkbMRecord(ActiveBuffer)^.RecordNo<0) then Result:=-1
     else Result:=PkbmRecord(ActiveBuffer)^.RecordNo+1;
end;
{$ENDIF}

procedure TkbmCustomMemTable.SetRecNo(Value: Integer);
var
   r:integer;
begin
     CheckActive;
     r:=GetRecNo;
     if Value=r then exit;
     if (Value<1) or (Value>FCurIndex.FReferences.Count) then exit;

     if not IsFiltered then
     begin
          DoBeforeScroll;
          FRecNo:=Value-1;
          DoAfterScroll;
          Resync([]);
     end
     else
     begin
          MoveBy(Value-r);
     end;
     CursorPosChanged;
end;

{$IFDEF DOTNET}
procedure TkbmCustomMemTable.InternalAddRecord(Buffer:TRecordBuffer; Append: Boolean);
var
   pRec,pCopyRec:PkbmRecord;
   CopyRec:TkbmRecord;
   where:integer;
begin
     pRec:=Buffer;

     // Check record acceptance.
     Indexes.CheckRecordUniqueness(pRec,nil);

     // Copy the reference record.
     pCopyRec:=FCommon._InternalCopyRecord(pRec,true);

     // Update indexes and add physical record.
     where:=FRecNo;
     if Append then where:=-1;
     FCommon.ReflectToIndexes(self,mtiuhInsert,nil,pCopyRec,where,false);

     // Append the reference record.
     CopyRec := TkbmRecord (Marshal.PtrToStructure (pCopyRec,typeOF(TkbmRecord)) );
     CopyRec.TransactionLevel:=TransactionLevel;
     CopyRec.Flag:=CopyRec.Flag or kbmrfInTable;
     Marshal.StructureToPtr(CopyRec,pCopyRec,false);
     IsDataModified:=true;

     FCommon._InternalAppendRecord(pCopyRec);
end;
{$ELSE}
procedure TkbmCustomMemTable.InternalAddRecord(Buffer:Pointer; Append: Boolean);
var
   pRec,pCopyRec:PkbmRecord;
   where:integer;
begin
     pRec:=PkbmRecord(Buffer);

     // Check record acceptance.
     Indexes.CheckRecordUniqueness(pRec,nil);

     // Copy the reference record.
     pCopyRec:=FCommon._InternalCopyRecord(pRec,true);

     // Update indexes and add physical record.
     where:=FRecNo;
     if Append then where:=-1;
     FCommon.ReflectToIndexes(self,mtiuhInsert,nil,pCopyRec,where,false);

     // Append the reference record.
     pCopyRec^.TransactionLevel:=TransactionLevel;
     pCopyRec^.Flag:=pCopyRec^.Flag or kbmrfInTable;
     IsDataModified:=true;

     FCommon._InternalAppendRecord(pCopyRec);
end;
{$ENDIF}

{$IFDEF DOTNET}
procedure TkbmCustomMemTable.InternalDelete;
var
   pRec,pDelRec:PkbmRecord;
   Rec:TkbmRecord;
begin
     FCommon.Lock;
     try
        pRec:=PkbmRecord(FCurIndex.FReferences.Items[FRecNo]);

        // Update indexes.
        FCommon.ReflectToIndexes(self,mtiuhDelete,pRec,nil,FRecNo,false);

        // Check if versioning. Dont delete the record. Only mark it as so.
        if IsVersioning then
        begin
             pDelRec:=FCommon._InternalCopyRecord(pRec,true);
             Rec := TkbmRecord (Marshal.PtrToStructure(pRec,TypeOf(TkbmRecord) ) );
             Rec.PrevRecordVersion:=pDelRec;
             Rec.UpdateStatus:=usDeleted;
             Rec.TransactionLevel:=TransactionLevel;
             Marshal.StructureToPtr(Rec,PRec,false);
             inc(FCommon.FDeletedCount);
        end
        else
        begin
             FCommon._InternalDeleteRecord(pRec);

             // After deleted last record, reset state of the table to empty.
             if (FCommon.FRecords.Count=0) then FCommon._InternalEmpty;
        end;

        IsDataModified:=true;
     finally
        FCommon.Unlock;
     end;
end;
{$ELSE}
procedure TkbmCustomMemTable.InternalDelete;
var
   pRec,pDelRec:PkbmRecord;
begin
     FCommon.Lock;
     try
        pRec:=PkbmRecord(FCurIndex.FReferences.Items[FRecNo]);

        // Update indexes.
        FCommon.ReflectToIndexes(self,mtiuhDelete,pRec,nil,FRecNo,false);

        // Check if versioning. Dont delete the record. Only mark it as so.
        if IsVersioning then
        begin
             pDelRec:=FCommon._InternalCopyRecord(pRec,true);
             pRec^.PrevRecordVersion:=pDelRec;
             pRec^.UpdateStatus:=usDeleted;
             pRec^.TransactionLevel:=TransactionLevel;
             inc(FCommon.FDeletedCount);
        end
        else
        begin
             FCommon._InternalDeleteRecord(pRec);

             // After deleted last record, reset state of the table to empty.
             if (FCommon.FRecords.Count=0) then FCommon._InternalEmpty;
        end;

//Removed Aug. 4. to solve grid reposition problem.        ClearBuffers;
        IsDataModified:=true;
     finally
        FCommon.Unlock;
     end;
end;
{$ENDIF}


procedure TkbmCustomMemTable.InternalInitRecord(Buffer: {$IFDEF DOTNET}TRecordBuffer{$ELSE}PChar{$ENDIF});
begin
     // Clearout record contents.
     FCommon._InternalClearRecord(PkbmRecord(Buffer));
end;

{$IFDEF DOTNET}
procedure TkbmCustomMemTable.InternalPost;
var
   pActRec,pNewRec,pRec:PkbmRecord;
   ARec,PrevRec:TkbmRecord;
begin
     inherited InternalPost;    // Otherwise the requiredfieldscheck will not happen.

     FCommon.Lock;
     try
        pActRec:=PkbmRecord(ActiveBuffer);

        if State = dsEdit then
        begin
             // Get reference to record to modify.
             pRec:=IntPtr(FCurIndex.FReferences[FRecNo]);

             // Check that record does not violate index.
             Indexes.CheckRecordUniqueness(pActRec,pRec);

             // Check if to update version.
             if Modified then
             begin
                  ARec := TkbmRecord (Marshal.PtrToStructure(pActRec,typeOf(TkbmRecord)));
                  ARec.UpdateStatus:=UsModified;
                  if IsVersioning then
                  begin
                       // Check if only to keep original record since checkpoint.
                       if (FCommon.FVersioningMode=mtvmAllSinceCheckPoint) or
                          ((FCommon.FVersioningMode=mtvm1SinceCheckPoint) and (ARec.PrevRecordVersion=nil)) then
                       begin
                            ARec.PrevRecordVersion:=FCommon._InternalCopyRecord(pRec,True);
                            PrevRec := TkbmRecord (Marshal.PtrToStructure(ARec.PrevRecordVersion,typeOf(TkbmRecord)));
                            PrevRec.Flag := PrevRec.Flag or kbmrfInTable;
                            Marshal.StructureToPtr(PrevRec,ARec.PrevRecordVersion,false);
                       end;
                  end;
                  IsDataModified:=true;
                  Marshal.StructureToPtr(ARec,pActRec,false);
             end;

             // Update index.
             FCommon.ReflectToIndexes(self,mtiuhEdit,pRec,pActRec,FRecNo,false);

             // Alter the physical record.
             FCommon._InternalTransferRecord(pActRec,pRec);
             ARec := TkbmRecord (Marshal.PtrToStructure(pRec,typeOf(TkbmRecord)));
             ARec.Flag:=ARec.Flag or kbmrfInTable;
             ARec.TransactionLevel:=TransactionLevel;
             Marshal.StructureToPtr(ARec,pRec,false);
        end
        else  // dsInsert.
        begin
             // Check record acceptance.
             Indexes.CheckRecordUniqueness(pActRec,nil);

             // New record. Allocate room for it and copy the reference record.
             pNewRec:=FCommon._InternalCopyRecord(pActRec,true);
             FCommon._InternalFreeRecordVarLengths(pActRec);

             // Add the physical record.
             FCommon._InternalAppendRecord(pNewRec);
             ARec := TkbmRecord (Marshal.PtrToStructure(pNewRec,typeOf(TkbmRecord) ));
             ARec.TransactionLevel:=TransactionLevel;
             ARec.Flag:=ARec.Flag or kbmrfInTable;
             marshal.structureToPtr (ARec,pNewRec,false);

             // Add to index.
             // If BOF bookmark flag set, then append, dont insert.
             if GetBookmarkFlag(pNewRec)=bfEOF then
                FCommon.ReflectToIndexes(self,mtiuhInsert,nil,pNewRec,-1,false)
             else
                FCommon.ReflectToIndexes(self,mtiuhInsert,nil,pNewRec,FInsertRecNo,false);


             IsDataModified:=true;
        end;
        FCommon.ClearModifiedFlags;
     finally
        FCommon.Unlock;
     end;
end;
{$ELSE}
procedure TkbmCustomMemTable.InternalPost;
var
   pActRec,pNewRec,pRec:PkbmRecord;
begin
{$IFDEF LEVEL6}
     inherited InternalPost;    // Otherwise the requiredfieldscheck will not happen.
{$ENDIF}

     FCommon.Lock;
     try
        pActRec:=PkbmRecord(ActiveBuffer);

        if State = dsEdit then
        begin
             // Get reference to record to modify.
             pRec:=FCurIndex.FReferences[FRecNo];

             // Check that record does not violate index.
             Indexes.CheckRecordUniqueness(pActRec,pRec);

             // Check if to update version.
             if Modified then
             begin
                  pActRec^.UpdateStatus:=UsModified;
                  if IsVersioning then
                  begin
                       // Check if only to keep original record since checkpoint.
                       if (FCommon.FVersioningMode=mtvmAllSinceCheckPoint) or
                          ((FCommon.FVersioningMode=mtvm1SinceCheckPoint) and (pActRec^.PrevRecordVersion=nil)) then
                       begin
                            pActRec^.PrevRecordVersion:=FCommon._InternalCopyRecord(pRec,True);
                            pActRec^.PrevRecordVersion^.Flag:=pActRec^.PrevRecordVersion^.Flag or kbmrfInTable;
                       end;
                  end;
                  IsDataModified:=true;
             end;

             // Update index.
             FCommon.ReflectToIndexes(self,mtiuhEdit,pRec,pActRec,FRecNo,false);

             // Alter the physical record.
             FCommon._InternalTransferRecord(pActRec,pRec);
             pRec^.Flag:=pRec^.Flag or kbmrfInTable;
             pRec^.TransactionLevel:=TransactionLevel;
        end
        else  // dsInsert.
        begin
             // Check record acceptance.
             Indexes.CheckRecordUniqueness(pActRec,nil);

             // New record. Allocate room for it and copy the reference record.
             pNewRec:=FCommon._InternalCopyRecord(pActRec,true);
             FCommon._InternalFreeRecordVarLengths(pActRec);

             // Add the physical record.
             FCommon._InternalAppendRecord(pNewRec);
             pNewRec^.TransactionLevel:=TransactionLevel;
             pNewRec^.Flag:=pNewRec^.Flag or kbmrfInTable;

             // Add to index.
             // If BOF bookmark flag set, then append, dont insert.
             if GetBookmarkFlag(PChar(pNewRec))=bfEOF then
                FCommon.ReflectToIndexes(self,mtiuhInsert,nil,pNewRec,-1,false)
             else
                FCommon.ReflectToIndexes(self,mtiuhInsert,nil,pNewRec,FInsertRecNo,false);

             IsDataModified:=true;
        end;
        FCommon.ClearModifiedFlags;
     finally
        FCommon.Unlock;
     end;
end;
{$ENDIF}

procedure TkbmCustomMemTable.InternalEdit;
begin
     inherited InternalEdit;
end;

{$IFNDEF LEVEL3}
procedure TkbmCustomMemTable.InternalInsert;
begin
     inherited InternalInsert;
end;
{$ENDIF}

procedure TkbmCustomMemTable.InternalCancel;
begin
     inherited InternalCancel;
     FCommon.ClearModifiedFlags;
end;

// Bookmark handling.

{$IFDEF DOTNET}
procedure TkbmCustomMemTable.SetBookmarkFlag(Buffer:TRecordBuffer; Value:TBookmarkFlag);
var
   pbmData:PkbmBookmark;
   Rec:TkbmRecord;
   bkMark:TkbmBookmark;
begin
     Rec:=TkbmRecord (Marshal.PtrToStructure(Buffer,typeOf(TkbmRecord)));
     pbmData:=PkbmBookmark(integer(Rec.Data)+FCommon.FStartBookmarks);
     pbmData:=IntPtr(integer(pbmData)+FTableID*sizeof(IntPtr));
     bkMark:=TkbmBookmark(Marshal.PtrToStructure(pbmData,typeOf(TkbmBookmark)));
     bkMark.Flag:=Value;
     Marshal.StructureToPtr(bkMark,pbmData,false);
end;

function TkbmCustomMemTable.GetBookmarkFlag(Buffer:TRecordBuffer): TBookmarkFlag;
var
   pbmData:PkbmBookmark;
   Rec:TkbmRecord;
   bkMark:TkbmBookmark;
begin
     Rec:=TkbmRecord (Marshal.PtrToStructure(Buffer,typeOf(TkbmRecord)));
     pbmData:=PkbmBookmark(integer(Rec.Data)+FCommon.FStartBookmarks);
     pbmData:=IntPtr(integer(pbmData)+FTableID*sizeof(IntPtr));
     bkMark:=TkbmBookmark (Marshal.PtrToStructure(pbmData,typeOf (TkbmBookmark) ));
     Result:=bkMark.Flag
end;

procedure TkbmCustomMemTable.GetBookmarkData(Buffer:TRecordBuffer; var Bookmark:TBookmark);
var
   pbmData:PkbmBookmark;
   pbmUser:PkbmUserBookmark;
   Rec:TkbmRecord;
   bmUser:TkbmUserBookmark;
   bmData:TkbmBookmark;
begin
     Rec:=TkbmRecord (Marshal.PtrToStructure(Buffer,typeOf(TkbmRecord)));
     pbmData:=PkbmBookmark(integer(Rec.Data)+FCommon.FStartBookmarks);
     pbmData:=IntPtr(integer(pbmData)+FTableID*sizeof(IntPtr));
     pbmUser:=PkbmUserBookmark(Bookmark);

     bmData:=TkbmBookmark (Marshal.PtrToStructure(pbmData,typeOf(TkbmBookmark) ));
     bmUser:=TkbmUserBookmark (Marshal.PtrToStructure(pbmUser,typeOf(TkbmUserBookmark)));
     bmUser.Bookmark:=bmData.Bookmark;
     bmUser.DataID:=FCommon.FDataID;

     Marshal.StructureToPtr(bmData,pbmData,false);
     Marshal.StructureToPtr(bmUser,pBmUser,false);
end;

procedure TkbmCustomMemTable.SetBookmarkData(Buffer:TRecordBuffer; const Bookmark:TBookmark);
var
   pbmData:PkbmBookmark;
   pbmUser:PkbmUserBookmark;
   Rec:TkbmRecord;
   bmUser:TkbmUserBookmark;
   bmData:TkbmBookmark;
begin
     Rec:=TkbmRecord(Marshal.PtrToStructure(Buffer,typeOf(TkbmRecord)));
     pbmData:=PkbmBookmark(integer(Rec.Data)+FCommon.FStartBookmarks);
     pbmData:=IntPtr(integer(pbmData)+FTableID*sizeof(IntPtr));
     pbmUser:=PkbmUserBookmark(Bookmark);

     bmData:=TkbmBookmark(Marshal.PtrToStructure(pbmData,typeOf(TkbmBookmark)));
     bmUser:=TkbmUserBookmark(Marshal.PtrToStructure(pbmUser,typeOf(TkbmUserBookmark)));

     bmData.Bookmark:=bmUser.Bookmark;
     Marshal.StructureToPtr(bmUser,pBmUser,false);
     Marshal.StructureToPtr(bmData,pbmData,false);
end;


// Check if a bookmarkpointer is actually valid.
function TkbmCustomMemTable.InternalBookmarkValid(Bookmark:IntPtr):boolean;
var
   bmUser:TkbmUserBookmark;
   Rec:TkbmRecord;
   p:PkbmRecord;
   pbmUser:PkbmUserBookmark;
begin
     Result:=Bookmark<>nil;
     if Result then
     begin
          pbmUser:=Bookmark;
          bmUser:=TkbmUserBookmark(Marshal.PtrToStructure(Bookmark,typeOf(TkbmUserBookmark)));

          Result:=(pbmUser<>nil) and (bmUser.DataID=FCommon.FDataID);
          if Result then
          begin
               p:=PkbmRecord(bmUser.Bookmark);
               if p<>nil then
               begin
                    Rec:=TkbmRecord (Marshal.PtrToStructure(p,typeOf(TkbmRecord)));
                    Result:=(Rec.Data<>nil);
               end
               else
                   Result:=false
          end;
     end;
end;

function TkbmCustomMemTable.BookmarkValid(const Bookmark: TBookmark): boolean;
begin
     Result:=InternalBookmarkValid(Bookmark);
end;

function TkbmCustomMemTable.CompareBookmarks(const Bookmark1, Bookmark2: TBookmark):Integer;
const
     RetCodes:array[Boolean, Boolean] of ShortInt = ((2,-1),(1,0));
var
   pUser1,pUser2:PkbmUserBookmark;
   p1,p2:PkbmRecord;
   User1,User2:TkbmUserBookmark;
   r1,r2:TkbmRecord;
begin
     // Check for invalid/uninitialized bookmarks
     if not (BookMarkValid(Bookmark1) and BookMarkValid(Bookmark2)) then
     begin
          Result:=0;
          exit;
     end;

     // Check contents of bookmark.
     pUser1:=PkbmUserBookmark(Bookmark1);
     pUser2:=PkbmUserBookmark(Bookmark2);
     User1:=TkbmUserBookmark(Marshal.PtrToStructure(pUser1,typeOf(TkbmUserBookmark)));
     User2:=TkbmUserBookmark(Marshal.PtrToStructure(pUser2,typeOf(TkbmUserBookmark)));
     p1:=User1.Bookmark;
     r1:=TkbmRecord(Marshal.PtrToStructure(p1,TypeOf(TkbmRecord)));
     p2:=User2.Bookmark;
     r2:=TkbmRecord(Marshal.PtrToStructure(p2,TypeOf(TkbmRecord)));

     // Compare record contents.
     FCommon.Lock;
     try
        if FCurIndex=FIndexes.FRowOrderIndex then
           Result:=r1.RecordID - r2.RecordID
        else
        begin
             Result:=FCurIndex.CompareRecords(FCurIndex.FIndexFieldList,p1,p2,true,false);
             if Result=0 then Result:=r1.RecordNo-r2.RecordNo;
             if Result=0 then Result:=r1.RecordID-r2.RecordID;
        end;
     finally
        FCommon.Unlock;
     end;

     // Convert to -1,0,1 range.
     if Result<0 then Result:=-1
     else if Result>0 then Result:=1;
end;

procedure TkbmCustomMemTable.InternalGotoBookmark(const Bookmark:TBookmark);
var
   i:integer;
   pb:PkbmRecord;
   pbUser:PkbmUserBookmark;
   bUser:TkbmUserBookmark;
begin
     if Bookmark=nil then
        raise EMemTableError.CreateFmt(kbmBookmErr,[-200]);

     pbUser:=PkbmUserBookmark(Bookmark);
     bUser :=TkbmUserBookmark(Marshal.PtrToStructure(pbUser,TypeOf(TkbmUserBookmark)));
     pb:=bUser.Bookmark;

     if pb=nil then exit;
     FCommon.Lock;
     try
        FCurIndex.SearchRecord(pb,i,true);
        if (i>=0) then FRecNo:=i;
     finally
        FCommon.Unlock;
     end;
end;

{$ELSE}

procedure TkbmCustomMemTable.SetBookmarkFlag(Buffer:PChar; Value: TBookmarkFlag);
var
   pbmData:PkbmBookmark;
begin
     pbmData:=PkbmBookmark(PkbmRecord(Buffer).Data+FCommon.FStartBookmarks);
     inc(pbmData,FTableID);
     pbmData^.Flag:=Value;
end;

function TkbmCustomMemTable.GetBookmarkFlag(Buffer:PChar): TBookmarkFlag;
var
   pbmData:PkbmBookmark;
begin
     pbmData:=PkbmBookmark(PkbmRecord(Buffer).Data+FCommon.FStartBookmarks);
     inc(pbmData,FTableID);
     Result:=pbmData^.Flag;
end;

procedure TkbmCustomMemTable.GetBookmarkData(Buffer:PChar; Data:Pointer);
var
   pbmData:PkbmBookmark;
   pbmUser:PkbmUserBookmark;
begin
     pbmData:=PkbmBookmark(PkbmRecord(Buffer)^.Data+FCommon.FStartBookmarks);
     inc(pbmData,FTableID);

     pbmUser:=PkbmUserBookmark(Data);
     pbmUser^.Bookmark:=pbmData^.Bookmark;
     pbmUser^.DataID:=FCommon.FDataID;
end;

procedure TkbmCustomMemTable.SetBookmarkData(Buffer:PChar; Data:Pointer);
var
   pbmData:PkbmBookmark;
   pbmUser:PkbmUserBookmark;
begin
     pbmData:=PkbmBookmark(PkbmRecord(Buffer)^.Data+FCommon.FStartBookmarks);
     inc(pbmData,FTableID);
     pbmUser:=PkbmUserBookmark(Data);
     pbmData^.Bookmark:=pbmUser^.Bookmark;
end;

// Check if a bookmarkpointer is actually valid.
function TkbmCustomMemTable.InternalBookmarkValid(Bookmark:Pointer):boolean;
var
   p:PkbmRecord;
   pbmUser:PkbmUserBookmark;
begin
     Result:=Bookmark<>nil;
     if Result then
     begin
          pbmUser:=PkbmUserBookmark(Bookmark);
          Result:=(pbmUser<>nil) and (pbmUser^.DataID=FCommon.FDataID);
          if Result then
          begin
               p:=PkbmRecord(pbmUser^.Bookmark);
               Result:=(p<>nil) and (p^.Data<>nil);
          end;
     end;
end;

function TkbmCustomMemTable.BookmarkValid(Bookmark: TBookmark): boolean;
begin
     Result:=InternalBookmarkValid(Bookmark);
end;

function TkbmCustomMemTable.CompareBookmarks(Bookmark1, Bookmark2: TBookmark):Integer;
const
     RetCodes: array[Boolean, Boolean] of ShortInt = ((2,-1),(1,0));
var
   pUser1,pUser2:PkbmUserBookmark;
   p1,p2:PkbmRecord;
begin
     // Check for invalid/uninitialized bookmarks
     if not (BookMarkValid(Bookmark1) and BookMarkValid(Bookmark2)) then
     begin
          Result:=0;
          exit;
     end;

     // Check contents of bookmark.
     pUser1:=PkbmUserBookmark(Bookmark1);
     pUser2:=PkbmUserBookmark(Bookmark2);
     p1:=pUser1^.Bookmark;
     p2:=pUser2^.Bookmark;

     // Compare record contents.
     FCommon.Lock;
     try
        if FCurIndex=FIndexes.FRowOrderIndex then
           Result:=p1^.RecordID - p2^.RecordID
        else
        begin
             Result:=FCurIndex.CompareRecords(FCurIndex.FIndexFieldList,p1,p2,true,false);
             if Result=0 then Result:=p1^.RecordNo-p2^.RecordNo;
             if Result=0 then Result:=p1^.RecordID-p2^.RecordID;
        end;
     finally
        FCommon.Unlock;
     end;

     // Convert to -1,0,1 range.
     if Result<0 then Result:=-1
     else if Result>0 then Result:=1;
end;

procedure TkbmCustomMemTable.InternalGotoBookmark(Bookmark:Pointer);
var
   i:integer;
   pb:PkbmRecord;
   pbUser:PkbmUserBookmark;
begin
     if Bookmark=nil then
        raise EMemTableError.CreateFmt(kbmBookmErr,[-200]);

     pbUser:=PkbmUserBookmark(Bookmark);
     pb:=pbUser^.Bookmark;

     if pb=nil then exit;
     FCommon.Lock;
     try
        FCurIndex.SearchRecord(pb,i,true);
        if (i>=0) then FRecNo:=i;
     finally
        FCommon.Unlock;
     end;
end;
{$ENDIF}

procedure TkbmCustomMemTable.InternalHandleException;
begin
{$IFDEF CLX}
     if Assigned(Classes.ApplicationHandleException) then
        Classes.ApplicationHandleException(Self);
{$ELSE}
       Application.HandleException(Self);
{$ENDIF}
end;

procedure TkbmCustomMemTable.SaveToFileViaFormat(const FileName:string; AFormat:TkbmCustomStreamFormat);
var
   Stream: TStream;
begin
     CheckActive;
     if not Assigned(AFormat) then
        raise EMemTableError.Create(kbmNoFormat);

     if (sfSaveAppend in AFormat.sfAppend) and FileExists(FileName) then
     begin
          Stream := TFileStream.Create(FileName,fmOpenReadWrite + fmShareDenyWrite);
          Stream.Seek(0,soFromEnd);
     end
     else
         Stream := TFileStream.Create(FileName,fmCreate);
     try
        if (assigned(FOnSave)) then FOnSave(self,mtstFile,Stream);
        InternalSaveToStreamViaFormat(Stream,AFormat);
     finally
        Stream.Free;
     end;
end;

procedure TkbmCustomMemTable.SaveToFile(const FileName:string);
begin
     SaveToFileViaFormat(FileName,FDefaultFormat);
end;

procedure TkbmCustomMemTable.SaveToStreamViaFormat(Stream:TStream; AFormat:TkbmCustomStreamFormat);
begin
     CheckActive;
     if (assigned(FOnSave)) then FOnSave(self,mtstStream,Stream);
     InternalSaveToStreamViaFormat(Stream,AFormat);
end;

procedure TkbmCustomMemTable.SaveToStream(Stream:TStream);
begin
     SaveToStreamViaFormat(Stream,FDefaultFormat);
end;

procedure TkbmCustomMemTable.CloseBlob(Field:TField);
var
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   pField:IntPtr;
{$ELSE}
   pField:PChar;
{$ENDIF}
   pBlob:PPkbmVarLength;
begin
     if (FRecNo<0) or (FRecNo>=FCurIndex.FReferences.Count) or (not (State in [dsEdit,dsInactive])) then
     begin
          if Field.DataType in kbmBlobTypes then
          begin
               pRec:=PkbmRecord(ActiveBuffer);
               pField:=FCommon.GetFieldPointer(pRec,Field);
{$IFDEF DOTNET}
               pBlob:=PPkbmVarLength(IntPtr(integer(pField)+1));
               Marshal.WriteByte(pFIeld,0,byte(kbmffNull));
               Marshal.WriteIntPtr(pBlob,nil);
{$ELSE}
               pBlob:=PPkbmVarLength(pField+1);
               pField[0]:=kbmffNull;
               pBlob^:=nil;
{$ENDIF}
          end;
     end;
end;


procedure TkbmCustomMemTable.InternalSaveToStreamViaFormat(AStream:TStream; AFormat:TkbmCustomStreamFormat);
begin
     if not Assigned(AFormat) then raise EMemTableError.Create(kbmNoFormat);

     with AFormat do
     begin
          FOrigStream:=AStream;
          FWorkStream:=nil;
          try
             BeforeSave(self);
             try
                Save(self);
             finally
                AfterSave(self);
             end;
          finally
             FWorkStream:=nil;
             FOrigStream:=nil;
          end;
     end;
end;

procedure TkbmCustomMemTable.InternalLoadFromStreamViaFormat(AStream:TStream; AFormat:TkbmCustomStreamFormat);
begin
     if not Assigned(AFormat) then raise EMemTableError.Create(kbmNoFormat);

     with AFormat do
     begin
          FOrigStream:=AStream;
          FWorkStream:=nil;
          try
             BeforeLoad(self);
             Load(self);
          finally
             AfterLoad(self);
             FOrigStream:=nil;
             FWorkStream:=nil;
          end;
     end;
end;

procedure TkbmCustomMemTable.LoadFromFileViaFormat(const FileName: string; AFormat:TkbmCustomStreamFormat);
var
   Stream: TStream;
begin
     Stream := TFileStream.Create(FileName, fmOpenRead+fmShareDenyWrite);
     try
        if assigned(FOnLoad) then FOnLoad(self,mtstFile,Stream);
        InternalLoadFromStreamViaFormat(Stream,AFormat);
     finally
        Stream.Free;
     end;
end;

procedure TkbmCustomMemTable.LoadFromFile(const FileName:string);
begin
     LoadFromFileViaFormat(FileName,FDefaultFormat);
end;

procedure TkbmCustomMemTable.LoadFromStreamViaFormat(Stream:TStream; AFormat:TkbmCustomStreamFormat);
begin
     if assigned(FOnLoad) then FOnLoad(self,mtstStream,Stream);
     InternalLoadFromStreamViaFormat(Stream,AFormat);
end;

procedure TkbmCustomMemTable.LoadFromStream(Stream:TStream);
begin
     if assigned(FOnLoad) then FOnLoad(self,mtstStream,Stream);
     InternalLoadFromStreamViaFormat(Stream,FDefaultFormat);
end;

procedure TkbmCustomMemTable.InternalEmptyTable;
var
   OldState:TkbmState;
begin
     OldState:=FState;
     FState:=mtstEmpty;
     try
        CheckBrowseMode;
        ClearBuffers;
{$IFDEF DOTNET}
        DataEvent(deDataSetChange, nil);
{$ELSE}
        DataEvent(deDataSetChange, 0);
{$ENDIF}
        FIndexes.EmptyAll;
        FRecNo:=-1;
        FReposRecNo:=-1;
     finally
        FState:=OldState;
     end;
end;

procedure TkbmCustomMemTable.EmptyTable;
begin
     Progress(0,mtpcEmpty);
     DisableControls;
     try
        FCommon.EmptyTables;
     finally
        EnableControls;
        Progress(100,mtpcEmpty);
     end;
end;

procedure TkbmCustomMemTable.PackTable;
begin
     Cancel;
     Commit;
     CheckPoint;
     Progress(0,mtpcPack);
     FState:=mtstPack;
     DisableControls;
     try
        ClearBuffers;
        FCommon._InternalPackRecords;
        First;
     finally
        EnableControls;
        Progress(100,mtpcPack);
        FState:=mtstBrowse;
     end;
end;

// Checkpoint a single record.
// Throws away old version records, and actually removes delete marked records.
function TkbmCustomMemTable.CheckPointRecord(RecordIndex:integer):TUpdateStatus;
var
   ARecord:PkbmRecord;
{$IFDEF DOTNET}
   ARec:TkbmRecord;
{$ENDIF}
begin
{$IFDEF DOTNET}
     ARecord:=PkbmRecord(FCommon.FRecords.Items[RecordIndex]);
{$ELSE}
     ARecord:=FCommon.FRecords.Items[RecordIndex];
{$ENDIF}
     if ARecord=nil then
     begin
          Result:=usUnmodified;
          exit;
     end;
{$IFDEF DOTNET}
     // Check if allow to checkpoint.
     ARec := TkbmRecord (Marshal.PtrToStructure(ARecord,TypeOf(TkbmRecord)));


     if (ARec.Flag and kbmrfDontCheckPoint)=kbmrfDontCheckPoint then
     begin
          Result:=ARec.UpdateStatus;
          exit;
     end;

     // Check if versioning data, remove them.
     if ARec.PrevRecordVersion<>nil then
     begin
          FCommon._InternalFreeRecord(ARec.PrevRecordVersion,true,true);
          ARec.PrevRecordVersion:=nil
     end;

     // Check if deleted record, delete it real this time.
     if ARec.UpdateStatus=usDeleted then
     begin
          FCommon.ReflectToIndexes(self,mtiuhDelete,ARecord,nil,RecordIndex,false);
          FCommon._InternalDeleteRecord(ARecord);
          Result:=usDeleted;
     end
     else
     begin
          // Reset status flags.
          ARec.UpdateStatus:=usUnModified;
          ARec.Flag:=ARec.Flag and (not kbmrfDontCheckPoint);
          Result:=ARec.UpdateStatus;
          Marshal.StructureToPtr(ARec,ARecord,false);
     end;
{$ELSE}
     // Check if allow to checkpoint.
     if (ARecord^.Flag and kbmrfDontCheckPoint)=kbmrfDontCheckPoint then
     begin
          Result:=ARecord^.UpdateStatus;
          exit;
     end;

     // Check if versioning data, remove them.
     if ARecord^.PrevRecordVersion<>nil then
     begin
          FCommon._InternalFreeRecord(ARecord^.PrevRecordVersion,true,true);
          ARecord^.PrevRecordVersion:=nil
     end;

     // Check if deleted record, delete it real this time.
     if ARecord^.UpdateStatus=usDeleted then
     begin
          FCommon.ReflectToIndexes(self,mtiuhDelete,ARecord,nil,RecordIndex,false);
          FCommon._InternalDeleteRecord(ARecord);
          Result:=usDeleted;
     end
     else
     begin
          // Reset status flags.
          ARecord^.UpdateStatus:=usUnModified;
          ARecord^.Flag:=ARecord^.Flag and (not kbmrfDontCheckPoint);
          Result:=ARecord^.UpdateStatus;
     end;
{$ENDIF}
end;


// Define checkpoint for versioning.
// Throws away old version records, and actually removes delete marked records.
procedure TkbmCustomMemTable.CheckPoint;
var
   i:integer;
   oEnableVersioning:boolean;
   ProgressCnt:integer;
begin
     if FAttachedTo<>nil then raise EMemTableError.Create(kbmCantCheckpointAttached);
     UpdateCursorPos;

     // Make sure operations are really happening and not just versioned.
     FCommon.FIsDataModified:=false;
     Progress(0,mtpcCheckPoint);
     ProgressCnt:=0;
     FCommon.Lock;
     try
        oEnableVersioning:=FCommon.FEnableVersioning;
        FCommon.FEnableVersioning:=false;
        FState:=mtstCheckPoint;
        ClearBuffers;
        for i:=FCommon.FRecords.Count-1 downto 0 do
        begin
             inc(ProgressCnt);
             ProgressCnt:=ProgressCnt mod 100;
             if ProgressCnt=0 then Progress(trunc(i/FCommon.FRecords.Count * 100),mtpcCheckPoint);
             if CheckpointRecord(i)<>usUnModified then
                FCommon.FIsDataModified:=true;
        end;

        FCommon.FDeletedCount:=0;
        FCommon.FEnableVersioning:=oEnableVersioning;
     finally
        FCommon.Unlock;
        First;
        Progress(100,mtpcCheckPoint);
        FState:=mtstBrowse;
     end;
end;

procedure TkbmCustomMemTable.SetCommaText(AString: String);
var
   stream:TMemoryStream;
begin
     EmptyTable;
     stream:=TMemoryStream.Create;
     try
{$IFDEF DOTNET}
        stream.Write(PlatformBytesOf(aString),length(AString));
{$ELSE}
        stream.Write(Pointer(AString)^,length(AString));
{$ENDIF}
        stream.Seek(0,soFromBeginning);
        LoadFromStreamViaFormat(stream,FCommaTextFormat);
     finally
        stream.free;
     end;
end;

function TkbmCustomMemTable.GetCommaText: String;
var
   stream:TMemoryStream;
   sz:integer;
{$IFNDEF DOTNET}
   p:PChar;
{$ENDIF}
begin
     Result:='';
     stream:=TMemoryStream.Create;
     try
        SaveToStreamViaFormat(stream,FCommaTextFormat);
        stream.Seek(0,soFromBeginning);
        sz:=stream.Size;
{$IFDEF DOTNET}
        Result:=BitConverter.ToString(stream.Memory,0,sz);
{$ELSE}
        p:=stream.Memory;
        setstring(Result,p,sz);
{$ENDIF}
     finally
        stream.free;
     end;
end;

// Save persistent table.
procedure TkbmCustomMemTable.SavePersistent;
var
   TempFile:string;
   BackupFile : String;
begin
     if not Active then exit;

     // If persistent, save info to file.
     if (not FPersistentSaved) and (not (csDesigning in ComponentState))
        and FPersistent and (FPersistentFile<>'') and (FPersistentFormat<>nil) then
     begin
          TempFile:=ChangeFileExt(FPersistentFile,'.$$$');
          SaveToFileViaFormat(TempFile,FPersistentFormat);
          if FPersistentBackup then
          begin
               BackupFile:=ChangeFileExt(FPersistentFile,FPersistentBackupExt);
               try
                  SysUtils.DeleteFile(BackupFile);
               except
               end;
               SysUtils.RenameFile(FPersistentFile,BackupFile);
          end
          else
          begin
               try
                  SysUtils.DeleteFile(FPersistentFile);
               except
               end;
          end;
          SysUtils.RenameFile(TempFile,FPersistentFile);
          FPersistentSaved:=true;
     end;
end;

// Check if persistent file exists... ala does the table exist in storage.
function TkbmCustomMemTable.Exists:boolean;
begin
     Result:=FileExists(FPersistentFile);
end;

// Load persistent table.
procedure TkbmCustomMemTable.LoadPersistent;
begin
     if FPersistent and (FPersistentFile<>'') and FileExists(FPersistentFile) then
     begin
          FPersistent:=false;
          try
             LoadFromFileViaFormat(FPersistentFile,FPersistentFormat);
             first;
          finally
             FPersistent:=true;
          end;
     end;
     FPersistentSaved:=false;
end;

// Sneak in before the table is closed.
procedure TkbmCustomMemTable.DoBeforeClose;
begin
     // Check if not in browse mode.
     if (State in [dsEdit,dsInsert]) then Cancel;

     if not FBeforeCloseCalled then
        inherited DoBeforeClose;
//     SavePersistent;
     FBeforeCloseCalled:=true;
end;

// Sneak in before the table is opened.
procedure TkbmCustomMemTable.DoBeforeOpen;
begin
     inherited DoBeforeOpen;
end;

// Sneak in after the table is opened.
procedure TkbmCustomMemTable.DoAfterOpen;
begin
     // DoAfterOpen is not reentrant. Thus prevent that situation.
     if FDuringAfterOpen then exit;

     FDuringAfterOpen:=true;
     try
        Indexes.MarkAllDirty;
        UpdateIndexes;

        // Switch index.
        if FIndexFieldNames<>'' then
           SetIndexFieldNames(FIndexFieldNames)
        else if FIndexName<>'' then
           SetIndexName(FIndexName);

        // If to load data from form, do it.
        if FTempDataStorage<>nil then
        begin
             if FStoreDataOnForm then LoadFromStreamViaFormat(FTempDataStorage,FFormFormat);
             FTempDataStorage.free;
             FTempDataStorage:=nil;
        end;

        // If persistent, read info from file.
        LoadPersistent;

{$IFDEF LEVEL5}
        // If filtering, build filter.
        if Filter<>'' then BuildFilter(FFilterParser,Filter,FFilterOptions);
{$ENDIF}
        SetIsFiltered;

        inherited DoAfterOpen;
     finally
        FDuringAfterOpen:=false;
        if FAutoUpdateFieldVariables then UpdateFieldVariables;
     end;
end;

// Sneak in after a post to update attached tables.
procedure TkbmCustomMemTable.DoAfterPost;
begin
     if FAttachedAutoRefresh then
        FCommon.RefreshTables(Self);

     // Check if to reposition.
     if FAutoReposition and (FReposRecNo>=0) then
     begin
          FRecNo:=FReposRecNo;
          FReposRecNo:=-1;
          Resync([]);
     end;

     inherited DoAfterPost;
end;

// Sneak in after a delete to update attached tables.
procedure TkbmCustomMemTable.DoAfterDelete;
begin
     if FAttachedAutoRefresh then
        FCommon.RefreshTables(self);

     FReposRecNo:=-1; // Nothing to reposition to.
     inherited DoAfterDelete;
end;

// Locate record.
// If the keyfields are the same as sorted fields and the table is currently sorted,
// it will make a fast binary search. Otherwise it will make a sequential search.
// Binary searches dont take partial record in account.
function TkbmCustomMemTable.LocateRecord(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions):Integer;
var
   KeyFieldsList:TkbmFieldList;
   KeyRecord:PkbmRecord;
   i:integer;
   Index:integer;
   Found:boolean;
begin
     Result := -1;
     I := VarArrayDimCount(KeyValues);
     if I > 1 then
        raise EMemTableError.Create(kbmVarArrayErr);

     CheckBrowseMode;
     CursorPosChanged;

     // Prepare list of fields representing the keys to search for.
     KeyFieldsList := TkbmFieldList.Create;
     try
        BuildFieldList(self,KeyFieldsList, KeyFields);

        // Setup key options.
        if loCaseInsensitive in Options then SetFieldListOptions(KeyFieldsList,mtifoCaseInsensitive,KeyFields);
        if loPartialKey in Options then SetFieldListOptions(KeyFieldsList,mtifoPartial,KeyFields);

        // Populate a keyrecord.
        KeyRecord:=FCommon._InternalAllocRecord;
        try
           // Fill it with values.
           PopulateRecord(KeyRecord,KeyFields,KeyValues);

           // Locate record.
           Index:=-1;
           Indexes.Search(KeyFieldsList,KeyRecord,false,true,FAutoAddIndexes,Index,Found);
           if Found then
              Result:=Index;

        finally
           // Free reference record.
           FCommon._InternalFreeRecord(KeyRecord,true,false);
        end;

     finally
        KeyFieldsList.Free;
     end;
end;

function TkbmCustomMemTable.Lookup(const KeyFields: string; const KeyValues: Variant; const ResultFields: string): Variant;
var
   n:integer;
begin
     Result := Null;
     n:=LocateRecord(KeyFields, KeyValues, []);
     SetFound(n>=0);
     if n>=0 then
     begin
          SetTempState(dsCalcFields);
          try
{$IFDEF DOTNET}
             CalculateFields(IntPtr(FCurIndex.FReferences[n]));
{$ELSE}
             CalculateFields(PChar(FCurIndex.FReferences[n]));
{$ENDIF}
             Result := FieldValues[ResultFields];
          finally
             RestoreState(dsBrowse);
          end;
     end;
end;

function TkbmCustomMemTable.LookupByIndex(const IndexName:string; const KeyValues:Variant;
                                          const ResultFields:string; RespFilter:boolean):Variant;
var
   i:integer;
   idx:TkbmIndex;
   KeyFieldsList:TkbmFieldList;
   KeyRecord:PkbmRecord;
   f:boolean;
begin
     Result:=null;
     idx:=GetIndexByName(IndexName);
     if idx=nil then exit;

     if VarArrayDimCount(KeyValues)>1 then
        raise EMemTableError.Create(kbmVarArrayErr);

     CheckBrowseMode;
     CursorPosChanged;

     // Prepare list of fields representing the keys to search for.
     KeyFieldsList := TkbmFieldList.Create;
     try
        BuildFieldList(self, KeyFieldsList, idx.IndexFields);

        // Populate a keyrecord.
        KeyRecord := FCommon._InternalAllocRecord;
        try
           // Fill it with values.
           PopulateRecord(KeyRecord,idx.IndexFields,KeyValues);

           // Locate record.
           i:=-1;
           if not((idx.Search(KeyFieldsList,KeyRecord,false,RespFilter,i,f)=0) and (i>=0)) then
              i:=-1;
        finally
           // Free reference record.
           FCommon._InternalFreeRecord(KeyRecord,true,false);
     end;
     finally
        KeyFieldsList.Free;
     end;

     SetFound(f);
     if f then
     begin
          SetTempState(dsCalcFields);
          try
{$IFDEF DOTNET}
             CalculateFields(IntPtr((idx.FReferences[i])));
{$ELSE}
             CalculateFields(PChar(idx.FReferences[i]));
{$ENDIF}
             Result:=FieldValues[ResultFields];
          finally
             RestoreState(dsBrowse);
          end;
     end;
end;

function TkbmCustomMemTable.Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
var
   n:integer;
begin
     DoBeforeScroll;
     n:=LocateRecord(KeyFields, KeyValues, Options);
     Result:=(n>=0);
     SetFound(Result);
     if n>=0 then
     begin
          FRecNo:=n;
          Resync([rmExact, rmCenter]);
          DoAfterScroll;
     end;
end;

// Copy properties from one field to another.
procedure TkbmCustomMemTable.CopyFieldProperties(Source,Destination:TField);
begin
     // Did we get valid parameters.
     if (Source=nil) or (Destination=nil) or (Source=Destination) then exit;

     // Copy general properties.
     with Source do
     begin
          Destination.EditMask:=EditMask;
          Destination.DisplayWidth:=DisplayWidth;
          Destination.DisplayLabel:=DisplayLabel;
          Destination.Required:=Required;
          Destination.ReadOnly:=ReadOnly;
          Destination.Visible:=Visible;
          Destination.DefaultExpression:=DefaultExpression;
          Destination.Alignment:=Alignment;
{$IFDEF LEVEL5}
          Destination.ProviderFlags:=ProviderFlags;
{$ENDIF}
     end;

     // Copy field type specific properties.
     if Source is TNumericField then
        with TNumericField(Source) do
        begin
             TNumericField(Destination).DisplayFormat:=DisplayFormat;
             TNumericField(Destination).EditFormat:=EditFormat;
        end;

     if Source is TIntegerField then
        with TIntegerField(Source) do
        begin
             TIntegerField(Destination).MaxValue:=MaxValue;
             TIntegerField(Destination).MinValue:=MinValue;
        end;

     if Source is TDateTimeField then
        with TDateTimeField(Source) do
             TDateTimeField(Destination).DisplayFormat:=DisplayFormat;

     if Source is TBooleanField then
        with TBooleanField(Source) do
             TBooleanField(Destination).DisplayValues:=DisplayValues;

     if Source is TStringField then
        with TStringField(Source) do
             TStringField(Destination).Transliterate:=Transliterate;

     if Source is TFloatField then
        with TFloatField(Source) do
        begin
             TFloatField(Destination).MaxValue:=MaxValue;
             TFloatField(Destination).MinValue:=MinValue;
             TFloatField(Destination).Precision:=Precision;
             TFloatField(Destination).currency:=currency;
        end;

     if Source is TBCDField then
        with TBCDField(Source) do
        begin
             TBCDField(Destination).MaxValue:=MaxValue;
             TBCDField(Destination).MinValue:=MinValue;
             TBCDField(Destination).currency:=currency;
        end;

     if Source is TBlobField then
        with TBlobField(Source) do
        begin
             TBlobField(Destination).BlobType:=BlobType;
             TBlobField(Destination).Transliterate:=Transliterate;
        end;

     // Call eventhandler if needed.
     if Assigned(FOnSetupFieldProperties) then FOnSetupFieldProperties(self,Destination);
end;

// Copy properties from source to destination.
// Handles different fieldorder between the two datasets.
procedure TkbmCustomMemTable.CopyFieldsProperties(Source,Destination:TDataSet);
var
   i:integer;
   fc:integer;
   f:TField;
begin
     // Did we get valid parameters.
     if (Source=nil) or (Destination=nil) or (Source=Destination) then exit;

     // Copy constraints from source to destination.
     fc:=Destination.FieldCount-1;
     for i:=0 to fc do
     begin
          // Find matching fieldnames on both sides. If fieldname not found, dont copy it.
          f:=Source.FindField(Destination.Fields[i].FieldName);
          if f=nil then continue;
          CopyFieldProperties(f, Fields[i]);
     end;
end;

// Copy records from source to destination.
// Handles different fieldorder between the two datasets.
// Returns the number of records copied.
function TkbmCustomMemTable.CopyRecords(Source,Destination:TDataSet;Count:longint; IgnoreErrors:boolean{$IFDEF LEVEL6}; WideStringAsUTF8:boolean{$ENDIF}):longint;
var
   i:integer;
   fc:integer;
   f:TField;
   fsrc,fdst:TField;
   fi:array [0..KBM_MAX_FIELDS-1] of integer;
   Accept:boolean;
   RecCnt:integer;
   ProgressCnt:integer;
   cpAutoInc:boolean;
begin
     Result:=0;

     // Did we get valid parameters.
     if (Source=nil) or (Destination=nil) or (Source=Destination) then exit;

     // Build name index relations between destination and source dataset.
     fc:=Destination.FieldCount-1;
     Progress(0,mtpcCopy);
     for i:=0 to fc do
     begin
          // Check if not a datafield or not a supported field, dont copy it.
          case Destination.Fields[i].FieldKind of
               fkLookup: fi[i]:=-2; // Dont copy, dont clearout.
               fkData,fkInternalCalc,fkCalculated:
                 begin
                      // If unknown datatype, dont copy, just leave untouched.
                      if not (Destination.Fields[i].DataType in (kbmSupportedFieldTypes)) then
                      begin
                           fi[i]:=-1;
                           continue;
                      end;

                      // Check if to copy autoinc from source.
                      if Destination.Fields[i].DataType=ftAutoInc then
                      begin
                           cpAutoInc:=Destination.isEmpty;
                           if not cpAutoInc then
                           begin
                                fi[i]:=-1;
                                continue;
                           end;
                      end;

                      // Find matching fieldnames on both sides. If fieldname not found, dont copy it, just clearout.
                      f:=Source.FindField(Destination.Fields[i].FieldName);
                      if f=nil then
                      begin
                           fi[i]:=-1;
                           continue;
                      end;

{ Commented out to allow copying non datafields.
                      // If not a datafield just clearout.
                      if f.FieldKind<>fkData then
                      begin
                           fi[i]:=-1;
                           continue;
                      end;
}

                      // Else copy the field.
                      fi[i]:=f.Index;
                 end;
          else
              // Other fieldkind, dont copy, just clearout.
              fi[i]:=-1;
          end;
     end;

     // Check number of records in source.
     if Assigned(FOnProgress) then
     begin
          RecCnt:=Source.RecordCount;
          if (RecCnt<=0) then Progress(50,mtpcCopy);
     end
     else RecCnt:=-1;

     // Copy data.
     FLoadedCompletely:=true;
     if (RecCnt<=0) then Progress(50,mtpcCopy);
     ProgressCnt:=0;
     while not Source.EOF do
     begin
          // Update progress.
          if (RecCnt>0) then
          begin
               inc(ProgressCnt);
               if (ProgressCnt mod 100)=0 then Progress(trunc(ProgressCnt/RecCnt*100),mtpcCopy);
          end;

          // Check acceptance of record.
          Accept:=true;
          if Assigned(FOnSaveRecord) and (Source=self) then FOnSaveRecord(Self,Accept);
          if not Accept then
          begin
               Source.Next;
               continue;
          end;

          Destination.Append;
          for i:=0 to fc do
          begin
               try
                  if fi[i]>=0 then
                  begin
                       fsrc:=Source.Fields[fi[i]];
                       fdst:=Destination.Fields[i];

                       if Assigned(FOnSaveField) and (Source=self) then FOnSaveField(Self,i,fsrc);

                       if fsrc.IsNull then
                          fdst.Clear
                       else
{$IFDEF LEVEL5}
                       if fsrc.DataType=ftLargeint then
                          fdst.AsString:=fsrc.AsString

 {$IFDEF LEVEL6}
                       // Check if to do automatic UTF8 conversion.
                       else if WideStringAsUTF8 and ((fsrc.DataType in [ftWideString{$IFDEF LEVEL10},ftWideMemo,ftFixedWideChar{$ENDIF}]) or (fdst.DataType in [ftWideString{$IFDEF LEVEL10},ftWideMemo,ftFixedWideChar{$ENDIF}])) then
                       begin
  {$IFDEF DOTNET}
                            if fsrc.DataType=fdst.DataType then
                               fdst.Value:=fsrc.Value
//                            else if fsrc.DataType in [ftString,ftFixedChar] then
//                               fdst.Value:= UTF8Decode(fsrc.AsString)
//                            else if fdst.DataType in [ftString,ftFixedChar] then
//                               fdst.AsString:=UTF8Encode(fsrc.Value)
//                            else
//                               fdst.Value:=fsrc.Value;
  {$ELSE}
                            if fsrc.DataType=fdst.DataType then
                               fdst.Value:=fsrc.Value
                            else if fsrc.DataType in [ftString,ftFixedChar] then
                               fdst.Value:=UTF8Decode(fsrc.AsString)
                            else if fdst.DataType in [ftString,ftFixedChar] then
                               fdst.AsString:=UTF8Encode(fsrc.Value)
                            else
                               fdst.Value:=fsrc.Value;
  {$ENDIF}
                       end
 {$ENDIF}

                       // Special error handling for ftOraClob and ftOraBlob fields
                       else if ((fsrc is TBlobField) and (TBlobField(fsrc).BlobType in [ftOraClob,ftOraBlob])) then
                       begin
                            try
                               fdst.AsString:=fsrc.AsString;
                            except
                               on E: Exception do
                               begin
                                 // swallow the BDE error, check classname not to import BDE classes.
                                 if E.ClassName='EDBEngineError' then
                                    // ***IMPACT ALERT***
                                    // this leaves the field defined but empty this breaks previous
                                    // functionality where this and subsequent fields just weren't
                                    // defined at all
                                    fdst.Clear
                                 else
                                    raise E;
                               end;
                            end
                       end
                       else
{$ENDIF}
                       if fsrc.ClassType<>fdst.ClassType then
                          fdst.AsString:=fsrc.AsString
                       else
                          fdst.Value:=fsrc.Value;
                       if Assigned(FOnLoadField) and (Destination=self) then FOnLoadField(Self,i,fdst);
                  end;
               except
                  if not IgnoreErrors then raise;
               end;
          end;

          Accept:=true;
          if Assigned(FOnLoadRecord) and (Destination=self) then FOnLoadRecord(Self,Accept);
          if Accept then
          begin
               try
                  Destination.Post;
               except
                  if not IgnoreErrors then raise;
               end;
               inc(Result);
               if (Count>0) and (Result>=Count) then
               begin
                    FLoadedCompletely:=Source.EOF;
                    break;
               end;
          end
          else Destination.Cancel;

          Source.next;
     end;
     Progress(100,mtpcCopy);
end;

// Assign the contents of active record in source to active record in destination.
// Handles different fieldorder between the two datasets.
procedure TkbmCustomMemTable.AssignRecord(Source,Destination:TDataSet);
var
   i:integer;
   fc:integer;
   f,sf:TField;
   fi:array [0..KBM_MAX_FIELDS-1] of integer;
   Accept:boolean;
begin
     // Did we get valid parameters.
     if (Source=nil) or (Destination=nil) or (Source=Destination) then exit;

     // Build name index relations between destination and source dataset.
     fc:=Destination.FieldCount-1;
     Progress(0,mtpcCopy);
     for i:=0 to fc do
     begin
          // Check if not a datafield or not a supported field, dont copy it.
          case Destination.Fields[i].FieldKind of
               fkLookup: fi[i]:=-2; // Dont copy, dont clearout.
               fkData,fkInternalCalc,fkCalculated:
                 begin
                      // If unknown datatype or autoinc field, dont copy, just leave untouched.
                      if not (Destination.Fields[i].DataType in (kbmSupportedFieldTypes)) then
                      begin
                           fi[i]:=-1;
                           continue;
                      end;

                      // Find matching fieldnames on both sides. If fieldname not found, dont copy it, just clearout.
                      f:=Source.FindField(Destination.Fields[i].FieldName);
                      if f=nil then
                      begin
                           fi[i]:=-1;
                           continue;
                      end;

{ Commented out to allow copying non datafields.
                      // If not a datafield just clearout.
                      if f.FieldKind<>fkData then
                      begin
                           fi[i]:=-1;
                           continue;
                      end;
}

                      // Else copy the field.
                      fi[i]:=f.Index;
                 end;
          else
              // Other fieldkind, dont copy, just clearout.
              fi[i]:=-1;
          end;
     end;

     // Determine if to copy.
     Accept:=true;
     if Assigned(FOnSaveRecord) and (Source=self) then FOnSaveRecord(Self,Accept);
     if not Accept then exit;

     // Copy data.
     Destination.Edit;
     for i:=0 to fc do
     begin
          if Assigned(FOnSaveField) and (Source=self) then FOnSaveField(Self,i,Source.Fields[i]);
          if fi[i]>=0 then
          begin
               sf:=Source.Fields[fi[i]];
               f:=Destination.Fields[i];

               if sf.IsNull then
                  f.Clear
               else
               begin
{$IFNDEF LEVEL3}
                    if sf.DataType=ftLargeInt then
                       f.AsString:=sf.AsString
                    else
{$ENDIF}
                        f.Value:=sf.Value;
               end;

          end;
          if Assigned(FOnLoadField) and (Destination=self) then FOnLoadField(Self,i,Destination.Fields[i]);
     end;

     // Determine if to post.
     if Assigned(FOnLoadRecord) and (Destination=self) then FOnLoadRecord(Self,Accept);
     if Accept then Destination.post
     else Destination.Cancel;

     Progress(100,mtpcCopy);
end;

// Update destination with records not matching or existing in source.
function TkbmCustomMemTable.UpdateRecords(Source,Destination:TDataSet; KeyFields:string; Count:Integer; Flags:TkbmMemTableUpdateFlags): longint;
var
   i:integer;
   fc:integer;
   f:TField;
   fi:array [0..KBM_MAX_FIELDS-1] of integer;
   Accept,DoUpdate:boolean;
   KeyValues:Variant;
   KeyFieldsList:TkbmFieldList;
   RecCnt:integer;
   ProgressCnt:integer;
begin
     Progress(0,mtpcUpdate);
     FState:=mtstUpdate;
     KeyFieldsList := TkbmFieldList.Create;
     try
        BuildFieldList(self,KeyFieldsList, KeyFields);
        if KeyFieldsList.Count > 1 then
           KeyValues:=VarArrayCreate([0, KeyFieldsList.Count-1 ], varVariant)
        else
            KeyValues:=null;
        Result:=0;

        // Did we get valid parameters.
        if (Source=nil) or (Destination=nil) or (Source=Destination) then exit;

        // Build name index relations between destination and source dataset.
        fc:=Destination.FieldCount-1;
        for i:=0 to fc do
        begin
             // Check if not a datafield or not a supported field, dont copy it.
             case Destination.Fields[i].FieldKind of
                  fkLookup: fi[i]:=-2; // Dont copy, dont clearout.
                  fkData,fkInternalCalc,fkCalculated:
                    begin
                         // If unknown datatype, dont copy, just clearout.
                         if not (Destination.Fields[i].DataType in (kbmSupportedFieldTypes)) then
                         begin
                              fi[i]:=-1;
                              continue;
                         end;

                         // Find matching fieldnames on both sides. If fieldname not found, dont copy it, just clearout.
                         f:=Source.FindField(Destination.Fields[i].FieldName);
                         if f=nil then
                         begin
                              fi[i]:=-1;
                              continue;
                         end;

                         // Else copy the field.
                         fi[i]:=f.Index;
                    end;
             else
                 // Other fieldkind, dont copy, just clearout.
                 fi[i]:=-1;
             end;

             // Check if not to clear out afterall.
             if (mtufDontClear in Flags) and (fi[i]=-1) then fi[i]:=-2;
        end;

        // Copy data.
        Source.First;
        RecCnt:=Source.RecordCount;
        if (RecCnt<=0) then Progress(50,mtpcCopy);
        ProgressCnt:=0;
        while not Source.EOF do
        begin
             // Update progress.
             if (RecCnt>0) then
             begin
                  inc(ProgressCnt);
                  if (ProgressCnt mod 100)=0 then Progress(trunc(ProgressCnt/RecCnt*100),mtpcCopy);
             end;

             Accept:=true;
             if Assigned(FOnSaveRecord) and (Source=self) then FOnSaveRecord(Self,Accept);
             if not Accept then
             begin
                  Source.Next;
                  continue;
             end;

             // Convert variant array of values to a list of values.
             if KeyFieldsList.Count > 1 then
             begin
                  for i:=0 to KeyFieldsList.count-1 do
                      KeyValues[i]:=KeyFieldsList.Fields[i].AsVariant;
             end
             else
                 KeyValues:=KeyFieldsList.Fields[0].AsVariant;

             // Look for record in dest. dataset to determine if to append or update record.
             DoUpdate:=true;
             if not Destination.Locate(KeyFields,KeyValues,[]) then
             begin
                  if (mtufAppend in Flags) then
                     Destination.Append
                  else
                      DoUpdate:=false;
             end
             else
             begin
                  if (mtufEdit in Flags) then
                     Destination.Edit
                  else
                      DoUpdate:=false;
             end;

             if DoUpdate then
             begin
                  // Update record fields.
                  for i:=0 to fc do
                  begin
                       if Assigned(FOnSaveField) and (Source=self) then FOnSaveField(Self,i,Source.Fields[i]);
                       if fi[i]>=0 then
                       begin
                            if Source.Fields[fi[i]].IsNull then
                               Destination.Fields[i].Clear
                            else
                                Destination.Fields[i].AsString:=Source.Fields[fi[i]].AsString;
                       end;
                       if Assigned(FOnLoadField) and (Destination=self) then FOnLoadField(Self,i,Destination.Fields[i]);
                  end;

                  Accept:=true;
                  if Assigned(FOnLoadRecord) and (Destination=self) then FOnLoadRecord(Self,Accept);
                  if Accept then
                  begin
                       Destination.Post;
                       inc(Result);
                       if (Count>0) and (Result>=Count) then break;
                  end
                  else Destination.Cancel;
             end;

             Source.next;
        end;

     finally
        KeyFieldsList.Free;
        Progress(100,mtpcUpdate);
        FState:=mtstBrowse;
     end;
end;

procedure TkbmCustomMemTable.UpdateToDataSet(Destination:TDataSet; KeyFields:string; Flags:TkbmMemTableUpdateFlags);
var
   DestActive:boolean;
   DestDisabled:boolean;
begin
     CheckBrowseMode;

     if Destination=self then exit;

     if (assigned(FOnSave)) then FOnSave(self,mtstDataSet,nil);

     // Remember state of destination.
     DestActive:=Destination.Active;
     DestDisabled:=Destination.ControlsDisabled;

     // Dont update controls while appending to destination
     if not DestDisabled then Destination.DisableControls;
     DisableControls;
     try
        try
           // Open destination
           if not DestActive then Destination.Open;
           Destination.CheckBrowseMode;
           Destination.UpdateCursorPos;

           // Open this if not opened.
           Open;
           CheckBrowseMode;

           // Move to first record in this.
           First;
           UpdateRecords(self,Destination,KeyFields,-1,Flags);
        finally
           Destination.First;
        end;
     finally
        EnableControls;
        if not DestActive then Destination.Close;
        if not DestDisabled then Destination.EnableControls;
     end;
end;

{$IFDEF LEVEL5}
procedure TkbmCustomMemTable.UpdateToDataSet(Destination:TDataSet; KeyFields:string);
begin
     UpdateToDataSet(Destination,KeyFields,[mtufEdit,mtufAppend]);
end;
{$ENDIF}

// Fill the memorytable with data from another dataset.
procedure TkbmCustomMemTable.LoadFromDataSet(Source:TDataSet; CopyOptions:TkbmMemTableCopyTableOptions);
var
   SourceActive:boolean;
   SourceDisabled:boolean;
   OldMasterSource:TDataSource;
   OldFiltered:boolean;
   OldEnableIndexes:boolean;
   BM:TBookmark;
   IgnoreErrors:boolean;
{$IFDEF LEVEL6}
   widestringasutf8:boolean;
//   stringaswidestring:boolean;
{$ENDIF}
begin
     if Source=self then exit;

     // Check if specified append together with structure. Not allowed.
     if (mtcpoAppend in CopyOptions) and ((mtcpoStructure in CopyOptions) or (mtcpoProperties in CopyOptions)) then
        raise EMemTableError.Create(kbmCannotMixAppendStructure);

     FState:=mtstLoad;

     if (assigned(FOnLoad)) then FOnLoad(self,mtstDataSet,nil);

     // If not to append, close this table.
     if (mtcpoStructure in CopyOptions) then
        Close
     else
         if not (mtcpoAppend in CopyOptions) then EmptyTable;

     // Remember state of source.
     SourceActive:=Source.Active;
     SourceDisabled:=Source.ControlsDisabled;

     // Remember state of this.
     OldFiltered:=Filtered;
     OldMasterSource:=MasterSource;
     OldEnableIndexes:=EnableIndexes;
     if not (mtcpoDontDisableIndexes in CopyOptions) then EnableIndexes:=false;

{$IFDEF LEVEL6}
//     stringaswidestring:=(mtcpoStringAsWideString in CopyOptions);
     widestringasutf8:=(mtcpoWideStringUTF8 in CopyOptions);
{$ENDIF}

     IgnoreErrors:=mtcpoIgnoreErrors in CopyOptions;
     FIgnoreReadOnly:=true;

     // Dont update controls while scrolling through source.
     if not SourceDisabled then Source.DisableControls;
     DisableControls;
     try
        if not SourceActive then Source.Open;
        try                                  // Not all datasets support this.
           BM:=Source.GetBookmark;
        except
           BM:=nil;
        end;
        try

           // Dont want to check filtering while copying.
           Filtered := False;
           MasterSource:=nil;

           // Open source.
           Source.CheckBrowseMode;
           try
              Source.UpdateCursorPos;      // Not all datasets supports this.
           except
           end;

           // Create this memorytable as a copy of the other one.
           if mtcpoStructure in CopyOptions then CreateTableAs(Source,CopyOptions);
           if not Active then Open;

           // Copy fieldproperties from source after open to also copy properties of default fields.
           if (not (mtcpoAppend in CopyOptions)) and (mtcpoProperties in CopyOptions) then
              CopyFieldsProperties(Source,self);

           CheckBrowseMode;

           // Move to first record in source.
           if not Source.BOF then Source.First;
           FLoadCount:=CopyRecords(Source,self,FLoadLimit,IgnoreErrors{$IFDEF LEVEL6},widestringasutf8{$ENDIF});
           First;
        finally
           EnableIndexes:=OldEnableIndexes;
           FCommon.MarkIndexesDirty;
           FCommon.UpdateIndexes;
           try
              Source.GotoBookmark(BM);                     // Not all datasets supports this.
           except
           end;
           try                                             // Not all datasets supports this.
              if BM<>nil then Source.FreeBookmark(BM);
           except
           end;
        end;
     finally
        FIgnoreReadOnly:=false;
        if not SourceActive then Source.Close;
        if not SourceDisabled then Source.EnableControls;
        Filtered:=OldFiltered;
        MasterSource:=OldMasterSource;
        EnableControls;
        UpdateCursorPos;
        CursorPosChanged;
        FState:=mtstBrowse;
     end;
end;

// Append the data in this memory table to another dataset.
procedure TkbmCustomMemTable.SaveToDataSet(Destination:TDataSet; CopyOptions:TkbmMemTableCopyTableOptions{$IFDEF LEVEL5} = []{$ENDIF});
var
   DestActive:boolean;
   DestDisabled:boolean;
   IgnoreErrors:boolean;
{$IFDEF LEVEL6}
   widestringasutf8:boolean;
//   stringaswidestring:boolean;
{$ENDIF}
begin
     if Destination=self then exit;

     IgnoreErrors:=mtcpoIgnoreErrors in CopyOptions;
{$IFDEF LEVEL6}
//     stringaswidestring:=(mtcpoStringAsWideString in CopyOptions);
     widestringasutf8:=(mtcpoWideStringUTF8 in CopyOptions);
{$ENDIF}

     FState:=mtstSave;
     if (assigned(FOnSave)) then FOnSave(self,mtstDataSet,nil);

     // Remember state of destination.
     DestActive:=Destination.Active;
     DestDisabled:=Destination.ControlsDisabled;

     // Dont update controls while appending to destination
     if not DestDisabled then Destination.DisableControls;
     DisableControls;

     try
        // Open destination
        if not DestActive then Destination.Open;
        try
           Destination.CheckBrowseMode;
           Destination.UpdateCursorPos;

           // Open this if not opened.
           Open;
           CheckBrowseMode;

           // Move to first record in this.
           First;
           FSaveCount:=CopyRecords(self,Destination,FSaveLimit,IgnoreErrors{$IFDEF LEVEL6},widestringasutf8{$ENDIF});
        finally
           Destination.First;
        end;

     finally
        EnableControls;
        if not DestActive then Destination.Close;
        if not DestDisabled then Destination.EnableControls;
        FState:=mtstBrowse;
     end;
end;

function TkbmCustomMemTable.IsSequenced: Boolean;
begin
     Result:=not Filtered;
end;

// Record rearranging.

// Move record from one place in table to another.
// Only rearranges the roworder index.
function TkbmCustomMemTable.MoveRecord(Source, Destination: Integer): Boolean;
{ TODO : should be ok }

var
{$IFDEF DOTNET}
   p: IntPtr;
{$ELSE}
   p: Pointer;
{$ENDIF}
begin
     Result := False;
     if FCurIndex<>Indexes.FRowOrderIndex then exit;

     {Because property RecNo has values 1..FRecords.Count
      and FRecNo has values 0..FRecords.Count - 1}
     Dec(Source);
     Dec(Destination);

     if (Source <> Destination) and (Source > -1) and (Source < FCurIndex.FReferences.Count)
        and (Destination > -1) and (Destination < FCurIndex.FReferences.Count) then
     begin
{$IFDEF DOTNET}
          p:=IntPtr(FCurIndex.FReferences[Source]);
{$ELSE}
          p:=FCurIndex.FReferences[Source];
{$ENDIF}
          if Destination>Source then Dec(Destination);
          FCurIndex.FReferences.Delete(Source);
          FCurIndex.FReferences.Insert(Destination,p);
          Result:=true;
     end;
end;


// Move record to the specified destination.
function TkbmCustomMemTable.MoveCurRecord(Destination: Integer): Boolean;
begin
     Result := MoveRecord(RecNo,Destination);
end;

// Sorting.

// Callback function for TDataset to know if specified field is an index.
function TkbmCustomMemTable.GetIsIndexField(Field:TField):Boolean;
begin
     Result:=FIndexList.IndexOf(Field)>=0;
end;

// Compare two field lists.
// Returns true if they are exactly equal, otherwise false.
function TkbmCustomMemTable.IsFieldListsEqual(List1,List2:TkbmFieldList):boolean;
var
   i:integer;
begin
     Result:=false;

     if List1.Count<>List2.Count then exit;

     for i:=0 to List1.Count-1 do
         if (List1.Fields[i]<>List2.Fields[i]) {or (List1.Options[i]<>List2.Options[i])} then exit;
     Result:=true;
end;

// Compare two field lists.
// Returns true if list2 is contained in list1, otherwise false.
function TkbmCustomMemTable.IsFieldListsBegin(List1,List2:TkbmFieldList):boolean;
var
   i:integer;
begin
     Result:=false;

     if List1.Count<List2.Count then exit;

     for i:=List2.Count-1 downto 0 do
         if List1.Fields[i]<>List2.Fields[i] then exit;
     Result:=true;
end;

// Build field list from list of fieldnames.
// fld1;fld2;fld3...
// Each field can contain options:
// fldname:options
// Options can be either C for Caseinsensitive or D for descending or a combination.
procedure TkbmCustomMemTable.BuildFieldList(Dataset:TDataset; List:TkbmFieldList; const FieldNames:string);
var
   p,p1:integer;
   fld:TField;
   s,sname,sopt:string;
   opt:TkbmifoOptions;
begin
     List.Clear;
     p:=1;
     while p<=length(FieldNames) do
     begin
          // Extract fieldname and options from list of fields.
          s:=ExtractFieldName(FieldNames,p);
          p1:=pos(':',s);
          Opt:=[];
          if p1<=0 then sname:=s
          else
          begin
               sname:=copy(s,1,p1-1);
               sopt:=uppercase(copy(s,p1+1,length(s)));
               if pos('C',sopt)>0 then Include(opt,mtifoCaseInsensitive);
               if pos('D',sopt)>0 then Include(opt,mtifoDescending);
               if pos('N',sopt)>0 then Include(opt,mtifoIgnoreNull);
               if pos('P',sopt)>0 then Include(opt,mtifoPartial);
               if pos('L',sopt)>0 then Include(opt,mtifoIgnoreLocale);
          end;
          fld:=Dataset.FieldByName(sname);
          if (fld.FieldKind in [fkData,fkInternalCalc,fkCalculated,fkLookup]) and (fld.DataType in (kbmSupportedFieldTypes-kbmBinaryTypes)) then
             List.Add(fld,opt)
          else
              DatabaseErrorFmt(kbmIndexErr,[fld.DisplayName]);
          if fld.FieldKind=fkCalculated then FRecalcOnIndex:=true;
     end;

     // Update field record offsets in list.
     for p:=0 to List.Count-1 do
     begin
          fld:=TField(List.Fields[p]);
          List.FieldOfs[p]:=FCommon.GetFieldDataOffset(fld);
          List.FieldNo[p]:=fld.FieldNo;
     end;
end;

// Find field from list.
function TkbmCustomMemTable.FindFieldInList(List:TkbmFieldList; FieldName:string):TField;
var
   fld:TField;
   i:Integer;
begin
     Result:=nil;
     for i:=0 to List.Count-1 do
     begin
          fld:=List.Fields[i];
          if fld.FieldName = FieldName then
          begin
               Result:=fld;
               break;
          end;
     end;
end;

// Setup options for specific fields in the fieldlist.
procedure TkbmCustomMemTable.SetFieldListOptions(AList:TkbmFieldList; AOptions:TkbmifoOption; AFieldNames:string);
var
   i,j:integer;
   lst:TkbmFieldList;
   b:boolean;
begin
     // Set flags.
     lst:=TkbmFieldList.Create;
     try
        BuildFieldList(self,lst,AFieldNames);
        for i:=0 to AList.count-1 do
        begin
             b:=false;
             for j:=0 to lst.count-1 do
                if lst.Fields[j]=AList.Fields[i] then
                begin
                     b:=true;
                     break;
                end;

             if b then
                Include(AList.Options[i],AOptions)
             else
                Exclude(AList.Options[i],AOptions);
        end;
     finally
        lst.Free;
     end;
end;

// Sort using specified sortfields and options.
procedure TkbmCustomMemTable.SortDefault;
begin
     Sort(FSortOptions);
end;

// Do sort on specified sortfields.
procedure TkbmCustomMemTable.Sort(Options:TkbmMemTableCompareOptions);
var
   OldRange:boolean;
begin
     if not Active then exit;
     CheckBrowseMode;

     OldRange:=FRangeActive;
     FRangeActive:=false;
     try
        // Check if old sort index defined, remove it.
        if FSortIndex<>nil then
        begin
             Indexes.DeleteIndex(FSortIndex);
             FSortIndex.free;
             FSortIndex:=nil;
        end;

        // Is any sort fields setup.
        if (Trim(FSortFIeldNames)<>'') then
        begin
             // Now add a new index.
             FSortIndex:=TkbmIndex.Create(kbmDefSortIndex,self,FSortFieldNames,Options,mtitSorted,true);
             Indexes.AddIndex(FSortIndex);
             FSortIndex.Rebuild;
        end
        else
            FSortIndex:=nil;
        SwitchToIndex(FSortIndex);
     finally
        FRangeActive:=OldRange;
     end;
end;

// Do sort on specifed fieldnames.
procedure TkbmCustomMemTable.SortOn(const FieldNames:string; Options:TkbmMemTableCompareOptions);
var
   OldRange:boolean;
begin
     if not Active then exit;
     CheckBrowseMode;
     FSortedOn:=FieldNames;

     OldRange:=FRangeActive;
     FRangeActive:=false;

     // Reset curindex to make sure to set it to something afterwards.
     FCurIndex:=nil;
     try

        // Check if old sort index defined, remove it.
        if FSortIndex<>nil then
        begin
             Indexes.DeleteIndex(FSortIndex);
             FSortIndex.free;
             FSortIndex:=nil;
        end;

        // If specifying new fields to sort on, create index on those fields, otherwise select roworderindex.
        if (Trim(FieldNames)<>'') then
        begin
             // Now add a new index.
             FSortIndex:=TkbmIndex.Create(kbmDefSortIndex,self,FieldNames,Options,mtitSorted,true);
             Indexes.AddIndex(FSortIndex);
             FSortIndex.Rebuild;
        end
        else
            FSortIndex:=nil;
        SwitchToIndex(FSortIndex);
     finally
        if FCurIndex=nil then SwitchToIndex(FIndexes.FRowOrderIndex);
        FRangeActive:=OldRange;
     end;
end;

{$IFNDEF LEVEL3}
// Get specified rows as a variant.
function TkbmCustomMemTable.GetRows(Rows:Integer; Start:Variant; Fields:Variant):Variant;
var
   FldList:TkbmFieldList;
   FldCnt,RowCnt,RealCnt:integer;
   i,j:integer;
   FRows:array of array of variant;
begin
     Result:=Unassigned;

     // If Start parameter is Unassigned or kbmBookMarkCurrent
     // retrieving starts at current position.
     // If it is assigned anything other than the bookmark consts
     // a valid TBookmark is assumed (casted to LongInt when called)
     if not VarIsEmpty(Start) then
     begin
          if Start=kbmBookMarkLast then Last // doesnt make too much sense...
          else if Start=kbmBookMarkFirst then First
          else
            try
 {$IFDEF DOTNET}
               GoToBookMark (IntPtr(integer(Start)))
 {$ELSE}
               GoToBookMark(Pointer(LongInt(Start)))
 {$ENDIF}
            except
            end; // raise?
     end;

     // If Rows parameter matches kbmGetRowsRest the table is scanned to the end.
     if Rows=Integer(kbmGetRowsRest) then
        RowCnt:=GetRecordCount-GetRecNo+1
     else
        RowCnt:=Rows;

     FldList:=TkbmFieldList.Create;
     try
        // Fields parameter can be
        // - single fieldname
        // - single fieldpos
        // - array of fieldnames
        // - array of fieldpos
        // - Unassigned (=all fields)
        if VarIsEmpty(Fields) then
        begin
             for i:=0 to pred(self.Fields.Count) do
               FldList.Add(self.Fields[i],[]);
        end
        else if VarIsArray(Fields) then
        begin
             if VarType(Fields[0])=varInteger then
                for i:=0 to VarArrayHighBound(Fields,1) do
                    FldList.Add(FieldByNumber(Fields[i]),[])
             else
                for i:=0 to VarArrayHighBound(Fields,1) do
                    FldList.Add(FieldByName(VarToStr(Fields[i])),[]);
        end
        else
        begin
             if VarType(Fields)=varInteger then
                FldList.Add(FieldByNumber(Fields),[])
             else
                FldList.Add(FieldByName(VarToStr(Fields)),[]);
        end;

        RealCnt:=0;
        FldCnt:=FldList.Count;
        SetLength(FRows,FldCnt,RowCnt);

        for j:=0 to pred(RowCnt) do
        begin
             for i:=0 to pred(FldCnt) do
             begin
                  // TBlobField.AsVariant doesnt return NULL for empty blobs
                  if FldList.Fields[i].IsNull then
                     FRows[i,j]:=Null
                  else
                     FRows[i,j]:=FldList.Fields[i].AsVariant;
             end;
             inc(RealCnt);
             Next;
             if EOF then Break;
        end;
     finally
        FldList.Free;
     end;

     if RealCnt<>RowCnt then
       SetLength(FRows,FldCnt,RealCnt);
 {$IFDEF DOTNET}
     Result:=variant(FRows);
 {$ELSE}
     Result:=FRows;
 {$ENDIF}
end;
{$ENDIF}

procedure TkbmCustomMemTable.ClearModified;
begin
     FCommon.ClearModifiedFlags;
     SetIsDataModified(false);
end;

procedure TkbmCustomMemTable.Reset;
begin
     Close;
     IndexName:='';
     MasterFields:='';
     IndexFieldNames:='';
     SetDataSource(nil);
     Indexes.Clear;
{$IFNDEF LEVEL3}
     Fields.Clear;
{$ENDIF}
     FIndexDefs.Clear;
     FieldDefs.Clear;
     FIndexDefs.Update;
     FieldDefs.Update;
     Filtered:=false;
     ClearModified;
end;

procedure TkbmCustomMemTable.GotoCurrent(DataSet:TkbmCustomMemTable);
var
   id:integer;
   iRecNo:integer;
   pRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
     pRec:=PkbmRecord(DataSet.ActiveBuffer);
     if pRec=nil then exit;

{$IFDEF DOTNET}
     Rec:=TkbmRecord(Marshal.PtrToStructure(pRec,typeOf(TkbmRecord)));
     id:=Rec.RecordID;
{$ELSE}
     id:=pRec^.RecordID;
{$ENDIF}

     CurIndex.SearchRecordID(id,iRecNo);
     if (iRecNo<0) or (iRecNo>=CurIndex.References.Count)
{$IFDEF DOTNET}
        or (not FilterRecord(PkbmRecord(CurIndex.References.Items[iRecNo]),false))
{$ELSE}
        or (not FilterRecord(CurIndex.References.Items[iRecNo],false))
{$ENDIF}
        then
           raise Exception.Create('Record not found');
     RecNo:=iRecNo;
end;

// -----------------------------------------------------------------------------------
// TkbmBlobStream
// -----------------------------------------------------------------------------------

// On create, make a stream access to the specified blobfield in the current record.
constructor TkbmBlobStream.Create(Field:TBlobField;Mode:TBlobStreamMode);
var
   RecID:longint;
{$IFDEF DOTNET}
   Rec:TkbmRecord;
{$ENDIF}
begin
{$IFDEF DOTNET}
     inherited Create;
{$ENDIF}

     // Remember proposed field and mode.
     FMode:=Mode;
     FField:=Field;
     FFieldNo:=FField.FieldNo;
     FDataSet:=TkbmCustomMemTable(FField.DataSet);

     // Dont want other to mess with out blob while we are using it.
     FDataSet.FCommon.Lock;
     try
          // If a write mode, check if allowed to write.
          if Mode<>bmRead then
          begin
               if (not FDataSet.FIgnoreReadOnly) and (FField.ReadOnly) then DatabaseErrorFmt(kbmReadOnlyErr,[FField.DisplayName]);
               if not (FDataSet.State in [dsEdit, dsInsert]) then DatabaseError(kbmEditModeErr);
          end;

          // Get pointers to work buffer.
          FWorkBuffer:=PkbmRecord(FDataSet.GetActiveRecord);
          if FWorkBuffer=nil then exit;
{$IFDEF DOTNET}
          FpWorkBufferField:=FDataset.FCommon.GetFieldPointer (FWorkBuffer,FField);
          FpWorkBufferBlob:=PPkbmVarLength (IntPtr(integer(FpWorkBufferField)+1));
          Rec := TkbmRecord (Marshal.PtrToStructure(FWorkBuffer,typeOf(TkbmRecord)));
          RecID:=Rec.RecordID;
{$ELSE}
          FpWorkBufferField:=FDataset.FCommon.GetFieldPointer(FWorkBuffer,FField);
          FpWorkBufferBlob:=PPkbmVarLength(FpWorkBufferField+1);
          RecID:=FWorkBuffer^.RecordID;
{$ENDIF}

          // Get pointers to table record buffer.
          if (RecID>=0) then
          begin
               FTableRecord:=PkbmRecord(FDataSet.FCommon.FRecords.Items[RecID]);
               FpTableRecordField:=FDataSet.FCommon.GetFieldPointer(FTableRecord,FField);
{$IFDEF DOTNET}
               FpTableRecordBlob:=PPkbmVarLength (IntPtr(integer(FpTableRecordField)+1));
{$ELSE}
               FpTableRecordBlob:=PPkbmVarLength(FpTableRecordField+1);
{$ENDIF}
          end
          else
          begin
               // In case of a totally new non posted record.
               FTableRecord:=nil;
               FpTableRecordField:=nil;
               FpTableRecordBlob:=nil;
          end;

          // Write mode, truncate blob.
          if Mode=bmWrite then
               Truncate
          else
              // Read the blob data into the memorystream.
              ReadBlobData;
     finally
        FDataSet.FCommon.Unlock;
     end;
end;


// On destroy, update the blobfield in the current record if the blob has changed.
destructor TkbmBlobStream.Destroy;
begin
     try
        if FModified then
        begin
             WriteBlobData;
             FField.Modified:=true;
{$IFDEF DOTNET}
             FDataSet.DataEvent (deFieldChange,FField);
{$ELSE}
             FDataSet.DataEvent(deFieldChange,Longint(FField));
{$ENDIF}
        end;
     except
{$IFDEF CLX}
        if Assigned(Classes.ApplicationHandleException) then
           Classes.ApplicationHandleException(Self);
{$ELSE}
        Application.HandleException(Self);
{$ENDIF}
     end;

     inherited Destroy;
end;

// Move the contents of the memorystream into the blob.
procedure TkbmBlobStream.WriteBlobData;
var
   Blob:PkbmVarLength;
   Stream:TMemoryStream;
   sz:longint;
{$IFDEF DOTNET}
   pmem:intPtr;
{$ENDIF}
begin
     // Check if old blob in workbuffer, free it.
{$IFDEF DOTNET}
     if (FpWorkBufferBlob<>nil) and (Marshal.ReadIntPtr (FpWorkBufferBlob)<>nil) then
     begin
          FreeVarLength(Marshal.ReadIntPtr (FpWorkBufferBlob));
          Marshal.WriteIntPtr (FpWorkBufferBlob,nil);
     end;
{$ELSE}
     if (FpWorkBufferBlob<>nil) and (FpWorkBufferBlob^<>nil) then
     begin
          FreeVarLength(FpWorkBufferBlob^);
          FpWorkBufferBlob^:=nil;
     end;
{$ENDIF}

     // If to compress the blob data, do it.
     if Assigned(FDataSet.FOnCompressBlobStream) then
     begin
          Stream:=TMemoryStream.Create;
          try
             FDataSet.FOnCompressBlobStream(FDataSet,self,Stream);
             sz:=Stream.Size;
             if sz>0 then
{$IFDEF DOTNET}
             begin
                pMem := marshal.AllocHGlobal(sz);
                try
                  Marshal.Copy (self.Memory,0,pMem,sz);
                  Blob:=AllocVarLengthAs(pMem,sz)
                finally
                  marshal.FreeHGlobal(pMem);
                end;
             end
{$ELSE}
                Blob:=AllocVarLengthAs(Stream.Memory,sz)
{$ENDIF}
             else
                Blob:=nil;
          finally
             Stream.free;
          end;
     end
     else
     begin
          sz:=self.Size;

          // Otherwise just save raw data to the inmemory blob.
          if sz>0 then
{$IFDEF DOTNET}
          begin
             pMem := marshal.AllocHGlobal(self.Size);
             try
               Marshal.Copy (self.Memory,0,pMem,self.Size);
               Blob:=AllocVarLengthAs(pMem,self.Size);
             finally
               marshal.FreeHGlobal(pMem);
             end;
          end
{$ELSE}
             Blob:=AllocVarLengthAs(self.Memory,self.Size)
{$ENDIF}
          else
             Blob:=nil;
     end;

     // Update with new allocation.
{$IFDEF DOTNET}
     Marshal.WriteIntPtr(FpWorkBufferBlob,Blob);
{$ELSE}
     FpWorkBufferBlob^:=Blob;
{$ENDIF}

     // Set Null flag in work record.
{$IFDEF DOTNET}
     if Blob<>nil then
       Marshal.WriteByte(FpWorkBufferField,0,Byte(kbmffData))
     else
       Marshal.WriteByte(FpWorkBufferField,0,Byte(kbmffNull))
{$ELSE}
     if Blob<>nil then FpWorkBufferField[0]:=kbmffData
     else FpWorkBufferField[0]:=kbmffNull;
{$ENDIF}
end;


// Move the contents of the blob into the memory stream.
procedure TkbmBlobStream.ReadBlobData;
var
   Blob:PkbmVarLength;
   Stream:TMemoryStream;
   sz:longint;
begin
     // Get blob.
{$IFDEF DOTNET}
     Blob := Marshal.ReadIntPtr(FpWorkBufferBlob);
{$ELSE}
     Blob:=FpWorkBufferBlob^;
{$ENDIF}
     if Blob=nil then
     begin
          // Check if to read from table (not null).
{$IFDEF DOTNET}
          if ( marshal.ReadByte (FpWorkBufferField,0)<>byte(kbmffNull)) then
             Blob:=  Marshal.ReadIntPtr (FpTableRecordBlob)
          else
              // Nothing to read. Null blob.
              exit;
{$ELSE}
          if (FpWorkBufferField[0]<>kbmffNull) then
             Blob:=FpTableRecordBlob^
          else
              // Nothing to read. Null blob.
              exit;
{$ENDIF}
     end;

     // Get size of blob.
     sz:=GetVarLengthSize(Blob);

     // If to decompress stream, save the blob in a memory stream and decompress it.
     if Assigned(FDataSet.FOnDeCompressBlobStream) then
     begin
          Stream:=TMemoryStream.Create;
          try
             Stream.SetSize(sz);
{$IFDEF DOTNET}
                 Marshal.Copy (GetVarLengthData(Blob),Stream.Memory,0,sz);
{$ELSE}
 {$IFNDEF USE_FAST_MOVE}
                 Move(GetVarLengthData(Blob)^,Stream.Memory^,sz);
 {$ELSE}
                 FastMove(GetVarLengthData(Blob)^,Stream.Memory^,sz);
 {$ENDIF}
{$ENDIF}
             FDataSet.FOnDecompressBlobStream(FDataSet,Stream,self);
          finally
             Stream.free;
          end;
     end
     else
     begin
          // Copy the data to the stream.
          self.SetSize(sz);
{$IFDEF DOTNET}
          Marshal.Copy (GetVarLengthData(Blob),self.Memory,0,sz);
{$ELSE}
 {$IFNDEF USE_FAST_MOVE}
          Move(GetVarLengthData(Blob)^,self.Memory^,sz);
 {$ELSE}
          FastMove(GetVarLengthData(Blob)^,self.Memory^,sz);
 {$ENDIF}
{$ENDIF}
     end;
     self.Position:=0;
end;


{$IFDEF DOTNET}
function TkbmBlobStream.Write(const Buffer: array of Byte; Offset, Count: Longint): Longint;
{$ELSE}
function TkbmBlobStream.Write(const Buffer;Count:Longint): Longint;
{$ENDIF}
begin
{$IFDEF DOTNET}
     Result:=inherited Write(Buffer,Offset,Count);
{$ELSE}
     Result:=inherited Write(Buffer,Count);
{$ENDIF}
     if (FMode=bmWrite) or (FMode=bmReadWrite) then FModified:=true;
end;

// Null a blob.
procedure TkbmBlobStream.Truncate;
begin
     Clear;
{$IFDEF DOTNET}
     // If blob allocated in workbuffer, remove allocation.
     if Marshal.ReadIntPtr (FpWorkBufferBlob)<>nil then
     begin
          FreeVarLength(Marshal.ReadIntPtr (FpWorkBufferBlob));
          Marshal.WriteIntPtr (FpWorkBufferBlob,nil);
     end;
     marshal.WriteByte (FpWorkBufferField,0,byte(kbmffNull));
{$ELSE}
     // If blob allocated in workbuffer, remove allocation.
     if FpWorkBufferBlob^<>nil then
     begin
          FreeVarLength(FpWorkBufferBlob^);
          FpWorkBufferBlob^:=nil;
     end;
     FpWorkBufferField[0]:=kbmffNull;
{$ENDIF}

     FModified:=true;
end;

{$IFNDEF LINUX}
// -----------------------------------------------------------------------------------
// TkbmThreadDataSet
// -----------------------------------------------------------------------------------

constructor TkbmThreadDataSet.Create(AOwner:TComponent);
begin
     inherited Create(AOwner);
     FLockCount:=0;
{$IFDEF DOTNET}
     FSemaphore:=CreateSemaphore(nil,1,1,null);
{$ELSE}
     FSemaphore:=CreateSemaphore(nil,1,1,nil);
{$ENDIF}
end;

destructor TkbmThreadDataSet.Destroy;
begin
     CloseHandle(FSemaphore);
     inherited;
end;

// Take control of the attached dataset.
// Wait for as much as TimeOut msecs to get the control.
// Setting TimeOut to INFINITE (DWORD($FFFFFFFF)) will make the lock wait for ever.
function TkbmThreadDataSet.TryLock(TimeOut:DWORD):TDataset;
var
   n:DWORD;
begin
     // Wait for critical section.
     inc(FLockCount);
     n:=WaitForSingleObject(FSemaphore,TimeOut);
     if (n=WAIT_TIMEOUT) or (n=WAIT_FAILED) then
     begin
          Result:=nil;
          dec(FLockCount);
          exit;
     end;
     Result:=FDataset;
end;

function TkbmThreadDataSet.Lock:TDataset;
begin
     Result:=TryLock(INFINITE);
end;

procedure TkbmThreadDataSet.Unlock;
begin
     dec(FLockCount);
     ReleaseSemaphore(FSemaphore,1,nil);
end;

procedure TkbmThreadDataSet.Notification(AComponent: TComponent; Operation: TOperation);
var
   WasLocked:boolean;
begin
     if (Operation=opRemove) and (AComponent=FDataSet) then
     begin
          WasLocked:=IsLocked;
          while IsLocked do Unlock;
          FDataset:=nil;
          if WasLocked then raise EMemTableError.Create(kbmDatasetRemoveLockedErr);
     end;
     inherited Notification(AComponent,Operation);
end;

procedure TkbmThreadDataSet.SetDataset(ds:TDataset);
begin
     if IsLocked then raise EMemTableError.Create(kbmSetDatasetLockErr);
     FDataSet:=ds;
end;

function TkbmThreadDataSet.GetIsLocked:boolean;
begin
     Result:=(FLockCount>0);
end;
{$ENDIF}

// -----------------------------------------------------------------------------------
// Handler for resolving delta's. Must be overridden to be usable.
// -----------------------------------------------------------------------------------

procedure TkbmCustomDeltaHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
     inherited Notification(AComponent,Operation);
     if (Operation=opRemove) and (AComponent=FDataset) then FDataset:=nil;
end;

procedure TkbmCustomDeltaHandler.CheckDataSet;
begin
     if FDataSet=nil then raise EMemTableError.Create(kbmDeltaHandlerAssign);
end;

procedure TkbmCustomDeltaHandler.Resolve;
var
   i:integer;
   pRec,pOrigRec:PkbmRecord;
{$IFDEF DOTNET}
   Rec,OrigRec:TkbmRecord;
{$ENDIF}
   st:TUpdateStatus;
   oAttachedAutoRefresh:boolean;
   Retry:boolean;
begin
     CheckDataSet;
     oAttachedAutoRefresh:=FDataSet.FAttachedAutoRefresh;
     FDataSet.FAttachedAutoRefresh:=false;
     FDataSet.FCommon.Lock;
     try
        // Do not refresh views _while_ resolving. Wait until afterwards.

        for i:=0 to FDataSet.FCommon.FRecords.Count-1 do
        begin
             // Check status of record.
             pRec:=PkbmRecord(FDataSet.FCommon.FRecords.Items[i]);
             if pRec=nil then continue;

             // Find oldest version.
             pOrigRec:=pRec;
{$IFDEF DOTNET}
             OrigRec := TkbmRecord (Marshal.PtrToStructure(pOrigRec,typeOf(TkbmRecord)));

             while OrigRec.PrevRecordVersion<>nil do
             begin
                pOrigRec:=OrigRec.PrevRecordVersion;
                OrigRec := TkbmRecord (Marshal.PtrToStructure(pOrigRec,typeOf(TkbmRecord)));
             end;

             // Check what status to react on.
             Rec := TkbmRecord (Marshal.PtrToStructure(pRec,typeOf(TkbmRecord)));
             if Rec.UpdateStatus=usDeleted then
             begin
                  // Dont resolve inserts that were deleted again.
                  if OrigRec.UpdateStatus=usInserted then st:=usUnmodified
                  else st:=usDeleted;
             end
             else if OrigRec.UpdateStatus=usInserted then st:=usInserted
             else st:=Rec.UpdateStatus;
{$ELSE}
             while pOrigRec^.PrevRecordVersion<>nil do
                   pOrigRec:=pOrigRec^.PrevRecordVersion;


             // Check what status to react on.
             if pRec^.UpdateStatus=usDeleted then
             begin
                  // Dont resolve inserts that were deleted again.
                  if pOrigRec^.UpdateStatus=usInserted then st:=usUnmodified
                  else st:=usDeleted;
             end
             else if pOrigRec^.UpdateStatus=usInserted then st:=usInserted
             else st:=pRec^.UpdateStatus;
{$ENDIF}
             FPRecord:=pRec;
             FPOrigRecord:=pOrigRec;

             BeforeRecord;
             try
                repeat
                  Retry:=false;
                  case st of
                       usDeleted:    DeleteRecord(Retry,st);
                       usInserted:   InsertRecord(Retry,st);
                       usModified:   ModifyRecord(Retry,st);
                       usUnModified: UnmodifiedRecord(Retry,st);
                  end;
                until not Retry;
             finally
                AfterRecord;
             end;
        end;
     finally
        FDataSet.FCommon.Unlock;

        // Check if to refresh other tables.
        FDataSet.FAttachedAutoRefresh:=oAttachedAutoRefresh;
        if FDataset.FAttachedAutoRefresh then
           FDataSet.FCommon.RefreshTables(nil);
     end;
end;

procedure TkbmCustomDeltaHandler.BeforeRecord;
begin
end;

procedure TkbmCustomDeltaHandler.InsertRecord(var Retry:boolean; var State:TUpdateStatus);
begin
end;

procedure TkbmCustomDeltaHandler.DeleteRecord(var Retry:boolean; var State:TUpdateStatus);
begin
end;

procedure TkbmCustomDeltaHandler.ModifyRecord(var Retry:boolean; var State:TUpdateStatus);
begin
end;

procedure TkbmCustomDeltaHandler.UnmodifiedRecord(var Retry:boolean; var State:TUpdateStatus);
begin
end;

procedure TkbmCustomDeltaHandler.AfterRecord;
begin
end;

function TkbmCustomDeltaHandler.GetFieldCount:integer;
begin
     CheckDataSet;
     Result:=FDataSet.FieldCount;
end;

function TkbmCustomDeltaHandler.GetOrigValues(Index:integer):Variant;
begin
     CheckDataSet;
     FDataSet.FOverrideActiveRecordBuffer:=FPOrigRecord;
     try
        if FDataSet.Fields[Index].IsNull then
           Result:=Null
        else
            Result:=FDataSet.Fields[Index].AsVariant;
     finally
        FDataSet.FOverrideActiveRecordBuffer:=nil;
     end;
end;

function TkbmCustomDeltaHandler.GetValues(Index:integer):Variant;
begin
     CheckDataSet;
     FDataSet.FOverrideActiveRecordBuffer:=FPRecord;
     try
        if FDataSet.Fields[Index].IsNull then
           Result:=Null
        else
            Result:=FDataSet.Fields[Index].AsVariant;

        if Assigned(FOnGetValue) then FOnGetValue(self,FDataSet.Fields[Index],Result);
     finally
        FDataSet.FOverrideActiveRecordBuffer:=nil;
     end;
end;

function TkbmCustomDeltaHandler.GetOrigValuesByName(Name:string):Variant;
var
   fld:TField;
begin
     CheckDataSet;
     FDataSet.FOverrideActiveRecordBuffer:=FPOrigRecord;
     try
        fld:=FDataSet.FieldByName(Name);
        if fld.IsNull then
           Result:=Null
        else
            Result:=fld.AsVariant;
     finally
        FDataSet.FOverrideActiveRecordBuffer:=nil;
     end;
end;

function TkbmCustomDeltaHandler.GetValuesByName(Name:string):Variant;
var
   fld:TField;
begin
     CheckDataSet;
     FDataSet.FOverrideActiveRecordBuffer:=FPRecord;
     try
        fld:=FDataSet.FieldByName(Name);
        if fld.IsNull then
           Result:=Null
        else
            Result:=fld.AsVariant;
        if Assigned(FOnGetValue) then FOnGetValue(self,fld,Result);
     finally
        FDataSet.FOverrideActiveRecordBuffer:=nil;
     end;
end;

function TkbmCustomDeltaHandler.GetFieldNames(Index:integer):string;
begin
     CheckDataSet;
     Result:=FDataSet.Fields[Index].FieldName;
end;

function TkbmCustomDeltaHandler.GetFields(Index:integer):TField;
begin
     CheckDataSet;
     Result:=FDataSet.Fields[Index];
end;

function TkbmCustomDeltaHandler.GetRecordNo:longint;
{$IFDEF DOTNET}
var
   Rec:TkbmRecord;
{$ENDIF}
begin
{$IFDEF DOTNET}
     Rec := TkbmRecord (Marshal.PtrToStructure(FPRecord,typeOf(TkbmRecord)));
     Result:=Rec.RecordNo+1;
{$ELSE}
     Result:=FPRecord^.RecordNo+1;
{$ENDIF}
end;

function TkbmCustomDeltaHandler.GetUniqueRecordID:longint;
{$IFDEF DOTNET}
var
   Rec:TkbmRecord;
{$ENDIF}
begin
{$IFDEF DOTNET}
     Rec := TkbmRecord (Marshal.PtrToStructure(FPRecord,typeOf(TkbmRecord)));
     Result:=Rec.UniqueRecordID;
{$ELSE}
     Result:=FPRecord^.UniqueRecordID;
{$ENDIF}
end;

// TkbmCustomStreamFormat
//*******************************************************************

constructor TkbmCustomStreamFormat.Create(AOwner:TComponent);
begin
     inherited Create(AOwner);
     sfData:=[sfSaveData,sfLoadData];
     sfCalculated:=[];
     sfLookup:=[];
     sfNonVisible:=[sfSaveNonVisible,sfLoadNonVisible];
     sfBlobs:=[sfSaveBlobs,sfLoadBlobs];
     sfDef:=[sfSaveDef,sfLoadDef];
     sfIndexDef:=[sfSaveIndexDef,sfLoadIndexDef];
     sfFiltered:=[sfSaveFiltered];
     sfIgnoreRange:=[sfSaveIgnoreRange];
     sfIgnoreMasterDetail:=[sfSaveIgnoreMasterDetail];
     sfDeltas:=[];
     sfDontFilterDeltas:=[];
     sfAppend:=[];
     sfFieldKind:=[sfSaveFieldKind];
     sfFromStart:=[sfLoadFromStart];
//     FAutoReposition:=true;
end;

procedure TkbmCustomStreamFormat.Assign(Source:TPersistent);
begin
     if Source is TkbmCustomStreamFormat then
     begin
          sfData:=TkbmCustomStreamFormat(Source).sfData;
          sfCalculated:=TkbmCustomStreamFormat(Source).sfCalculated;
          sfLookup:=TkbmCustomStreamFormat(Source).sfLookup;
          sfNonVisible:=TkbmCustomStreamFormat(Source).sfNonVisible;
          sfBlobs:=TkbmCustomStreamFormat(Source).sfBlobs;
          sfDef:=TkbmCustomStreamFormat(Source).sfDef;
          sfIndexDef:=TkbmCustomStreamFormat(Source).sfIndexDef;
          sfFiltered:=TkbmCustomStreamFormat(Source).sfFiltered;
          sfIgnoreRange:=TkbmCustomStreamFormat(Source).sfIgnoreRange;
          sfIgnoreMasterDetail:=TkbmCustomStreamFormat(Source).sfIgnoreMasterDetail;
          sfDeltas:=TkbmCustomStreamFormat(Source).sfDeltas;
          sfDontFilterDeltas:=TkbmCustomStreamFormat(Source).sfDontFilterDeltas;
          sfAppend:=TkbmCustomStreamFormat(Source).sfAppend;
          sfFieldKind:=TkbmCustomStreamFormat(Source).sfFieldKind;
          sfFromStart:=TkbmCustomStreamFormat(Source).sfFromStart;
          exit;
     end;
     inherited Assign(Source);
end;

procedure TkbmCustomStreamFormat.SetIgnoreAutoIncPopulation(ADataset:TkbmCustomMemTable; Value:boolean);
begin
     ADataset.FIgnoreAutoIncPopulation:=value;
end;

procedure TkbmCustomStreamFormat.SetVersion(AVersion:string);
begin
end;

function  TkbmCustomStreamFormat.GetVersion:string;
begin
     Result:='1.00';
end;

procedure TkbmCustomStreamFormat.DetermineSaveFields(ADataset:TkbmCustomMemTable);
var
   i:integer;
   nf:integer;
begin
     // Setup flags for fields to save.
     with ADataset do
     begin
          nf:=Fieldcount;
{$IFDEF LEVEL4}
          SetLength(SaveFields,nf);
{$ELSE}
          SaveFieldsCount:=nf;
{$ENDIF}

          for i:=0 to nf-1 do
          begin
               // Default dont save this field.
               SaveFields[i]:=-1;

               // If a blob field, only save if specified.
               if (Fields[i].DataType in kbmBlobTypes) then
               begin
                    if not (sfSaveBlobs in sfBlobs) then continue;
                    SaveFields[i]:=i;
               end;

               // Only save fields of specific types.
               case Fields[i].FieldKind of
                    fkData,fkInternalCalc: if sfSaveData in sfData then SaveFields[i]:=i;
                    fkCalculated: if sfSaveCalculated in sfCalculated then SaveFields[i]:=i;
                    fkLookup: if sfSaveLookup in sfLookup then SaveFields[i]:=i;
                    else SaveFields[i]:=-1;
               end;

               // If not to save invisible fields, dont.
               if not (Fields[i].Visible or (sfSaveNonVisible in sfNonVisible)) then SaveFields[i]:=-1;
          end;
     end;
end;

procedure TkbmCustomStreamFormat.DetermineLoadFields(ADataset:TkbmCustomMemTable; Situation:TkbmDetermineLoadFieldsSituation);
var
   i,j,nf:integer;
   lst:TStringList;
begin
     // Setup flags for fields to save.
     lst:=TStringList.Create;
     try
        with ADataset do
        begin
             lst.Clear;
             DetermineLoadFieldIDs(ADataset,lst,Situation);
             nf:=lst.Count;
{$IFDEF LEVEL4}
             SetLength(LoadFields,nf);
{$ELSE}
             LoadFieldsCount:=nf;
{$ENDIF}

             for i:=0 to nf-1 do
             begin
                  // Default dont load this field.
                  LoadFields[i]:=-1;

                  // Let child component make initial desision of what to load and order.
                  DetermineLoadFieldIndex(ADataset,lst.Strings[i],nf,i,LoadFields[i],Situation);

                  // Only load fields of specific types.
                  j:=LoadFields[i];
                  if j>=0 then
                  begin
                       case Fields[j].FieldKind of
                            fkData,fkInternalCalc: if not (sfLoadData in sfData) then LoadFields[i]:=-1;
                            fkCalculated: if not (sfLoadCalculated in sfCalculated) then LoadFields[i]:=-1;
                            fkLookup: if not (sfLoadLookup in sfLookup) then LoadFields[i]:=-1;
                            else LoadFields[i]:=-1;
                       end;

                       // If a blob field, only load if specified.
                       if (Fields[j].DataType in kbmBlobTypes) and (not (sfLoadBlobs in sfBlobs)) then LoadFields[i]:=-1;

                       // If not to load invisible fields, dont.
                       if not (Fields[j].Visible or (sfLoadNonVisible in sfNonVisible)) then LoadFields[i]:=-1;
                  end;
             end;
        end;
     finally
        lst.Free;
     end;
end;

procedure TkbmCustomStreamFormat.BeforeSave(ADataset:TkbmCustomMemTable);
begin
     with ADataset do
     begin
          DisableControls;

          Common.Lock;
          TableState:=mtstSave;
          Progress(0,mtpcSave);

          FWasFiltered:=Filtered;
          FWasRangeActive:=FRangeActive;
          FWasMasterLinkUsed:=FMasterLinkUsed;

          if Filtered and (sfSaveFiltered in sfFiltered) then Filtered:=false;
          if FMasterLinkUsed and (sfSaveIgnoreMasterDetail in sfIgnoreMasterDetail) then FMasterLinkUsed:=false;
          if RangeActive and (sfSaveIgnoreRange in sfIgnoreRange) then FRangeActive:=false;

          // If to compress stream, create memory stream to save to instead.
          if Assigned(FOnCompress) then
             FWorkStream:=TMemoryStream.Create
          else
             FWorkStream:=FOrigStream;

          // Check if to append. If not truncate stream.
          if (sfSaveAppend in sfAppend) then
             FWorkStream.Seek(0,soFromEnd)
          else if not (sfSaveInsert in sfAppend) then
          begin
               FWorkStream.Size:=0;
               FWorkStream.Position:=0;
          end;

          // Determine fields to save.
          DetermineSaveFields(ADataset);

          SetIsFiltered;
     end;
end;

procedure TkbmCustomStreamFormat.AfterSave(ADataset:TkbmCustomMemTable);
begin
     try
        // If to compress stream do the compression to the dest stream.
        if Assigned(FOnCompress) then
           FOnCompress(ADataset,FWorkStream,FOrigStream);

        with ADataset do
        begin
             FMasterLinkUsed:=true;
             FRangeActive:=FWasRangeActive;
             Filtered:=FWasFiltered;

             TableState:=mtstBrowse;
             Progress(100,mtpcSave);
             Common.Unlock;

             SetIsFiltered;
             EnableControls;
        end;
     finally
        if FWorkStream<>FOrigStream then
        begin
             FWorkStream.Free;
             FWorkStream:=nil;
        end;
     end;
end;

procedure TkbmCustomStreamFormat.SaveDef(ADataset:TkbmCustomMemTable);
begin
end;

procedure TkbmCustomStreamFormat.SaveData(ADataset:TkbmCustomMemTable);
begin
end;

procedure TkbmCustomStreamFormat.Save(ADataset:TkbmCustomMemTable);
begin
     if Assigned(FOnBeforeSave) then FOnBeforeSave(self);
     SaveDef(ADataset);
     SaveData(ADataset);
     if Assigned(FOnAfterSave) then FOnAfterSave(self);
end;

procedure TkbmCustomStreamFormat.BeforeLoad(ADataset:TkbmCustomMemTable);
begin
     with ADataset do
     begin
          // Dont let persistence react on internal open/close statements.
          DisableControls;

          Common.Lock;

          TableState:=mtstLoad;

          FWasPersistent:=FPersistent;
          FWasEnableIndexes:=FEnableIndexes;

          FPersistent:=false;
          FEnableIndexes:=false;

          FIgnoreReadOnly:=true;
          FIgnoreAutoIncPopulation:=true;

          if Active and (RecordCount>0) and FAutoReposition then
             FBookmark:=GetBookmark
          else
             FBookmark:=nil;
          Progress(0,mtpcLoad);

          // If to decompress stream, create memory stream to load from instead.
          if Assigned(OnDecompress) then
          begin
               FWorkStream:=TMemoryStream.Create;
               if sfLoadFromStart in sfFromStart then
                  FOrigStream.Position:=0;
               OnDecompress(ADataset,FOrigStream,FWorkStream);
               FWorkStream.Position:=0;
          end
          else
          begin
               FWorkStream:=FOrigStream;
               if sfLoadFromStart in sfFromStart then
                  FWorkStream.Position:=0;
          end;

          // Determine fields to load.
          DetermineLoadFields(ADataset,dlfBeforeLoad);
     end;
end;

procedure TkbmCustomStreamFormat.AfterLoad(ADataset:TkbmCustomMemTable);
begin
     try
        with ADataset do
        begin
             // Dont let persistence react on internal open/close statements.
             FPersistent:=FWasPersistent;
             FEnableIndexes:=FWasEnableIndexes;

             FIgnoreReadOnly:=false;
             FIgnoreAutoIncPopulation:=false;

             Common.MarkIndexesDirty;
             Common.RebuildIndexes;
             Common.Unlock;

             __ClearBuffers;

             if FAutoReposition then
             begin

                  if Assigned(FBookmark) then
                  begin
                       if BookmarkValid(FBookmark) then
                          GotoBookmark(FBookmark)
                       else
                           First;
                       FreeBookmark(FBookmark);
                       FBookmark:=nil;
                  end
                  else
                    if Active then
                      First;
             end
             else
               if Active then
                   First;

             EnableControls;

             Progress(100,mtpcLoad);
             TableState:=mtstBrowse;
//             if FAutoReposition then Refresh;
             if FAutoUpdateFieldVariables then UpdateFieldVariables;
             Refresh;
        end;
     finally
        if FWorkStream<>FOrigStream then
        begin
             FWorkStream.Free;
             FWorkStream:=nil;
        end;
     end;
end;

procedure TkbmCustomStreamFormat.LoadDef(ADataset:TkbmCustomMemTable);
begin
end;

procedure TkbmCustomStreamFormat.LoadData(ADataset:TkbmCustomMemTable);
begin
end;

procedure TkbmCustomStreamFormat.Load(ADataset:TkbmCustomMemTable);
begin
     if Assigned(FOnBeforeLoad) then FOnBeforeLoad(self);
     LoadDef(ADataset);
     DetermineLoadFields(ADataset,dlfAfterLoadDef); // Give another chance. LoadDef might have changed something,
{$IFDEF LEVEL4}
     if Length(LoadFields)<=0 then
{$ELSE}
     if LoadFieldsCount<=0 then
{$ENDIF}
        raise EMemTableError.Create('Couldnt determine field count for load.');
     LoadData(ADataset);
     if Assigned(FOnAfterLoad) then FOnAfterLoad(self);
end;

procedure TkbmCustomStreamFormat.DetermineLoadFieldIDs(ADataset:TkbmCustomMemTable; AList:TStringList; Situation:TkbmDetermineLoadFieldsSituation);
var
   i:integer;
begin
     AList.Clear;
     for i:=0 to ADataset.FieldCount-1 do
         AList.Add(ADataset.Fields[i].DisplayName);
end;

procedure TkbmCustomStreamFormat.DetermineLoadFieldIndex(ADataset:TkbmCustomMemTable; ID:string; FieldCount:integer; OrigIndex:integer; var NewIndex:integer; Situation:TkbmDetermineLoadFieldsSituation);
begin
     // Default dont load anything.
end;

// -----------------------------------------------------------------------------------
// Registration for Delphi 3 / C++ Builder 3
// -----------------------------------------------------------------------------------

{$IFDEF LEVEL3}
procedure Register;
begin
     RegisterComponents('kbmMemTable', [TkbmMemTable,TkbmThreadDataSet]);
end;
{$ENDIF}

end.




