// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Kbmmemtable.pas' rev: 11.00

#ifndef KbmmemtableHPP
#define KbmmemtableHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Dbcommon.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Syncobjs.hpp>	// Pascal unit
#include <Masks.hpp>	// Pascal unit
#include <Variants.hpp>	// Pascal unit
#include <Fmtbcd.hpp>	// Pascal unit
#include <Sqltimst.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Kbmmemtable
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EMemTableError;
class PASCALIMPLEMENTATION EMemTableError : public Db::EDatabaseError 
{
	typedef Db::EDatabaseError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableError(const AnsiString Msg) : Db::EDatabaseError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Db::EDatabaseError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableError(int Ident)/* overload */ : Db::EDatabaseError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Db::EDatabaseError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableError(const AnsiString Msg, int AHelpContext) : Db::EDatabaseError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Db::EDatabaseError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableError(int Ident, int AHelpContext)/* overload */ : Db::EDatabaseError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Db::EDatabaseError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EMemTableFatalError;
class PASCALIMPLEMENTATION EMemTableFatalError : public EMemTableError 
{
	typedef EMemTableError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableFatalError(const AnsiString Msg) : EMemTableError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableFatalError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EMemTableError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableFatalError(int Ident)/* overload */ : EMemTableError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableFatalError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EMemTableError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableFatalError(const AnsiString Msg, int AHelpContext) : EMemTableError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableFatalError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EMemTableError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableFatalError(int Ident, int AHelpContext)/* overload */ : EMemTableError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableFatalError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EMemTableError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableFatalError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EMemTableInvalidRecord;
class PASCALIMPLEMENTATION EMemTableInvalidRecord : public EMemTableFatalError 
{
	typedef EMemTableFatalError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableInvalidRecord(const AnsiString Msg) : EMemTableFatalError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableInvalidRecord(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EMemTableFatalError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableInvalidRecord(int Ident)/* overload */ : EMemTableFatalError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableInvalidRecord(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EMemTableFatalError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableInvalidRecord(const AnsiString Msg, int AHelpContext) : EMemTableFatalError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableInvalidRecord(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EMemTableFatalError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableInvalidRecord(int Ident, int AHelpContext)/* overload */ : EMemTableFatalError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableInvalidRecord(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EMemTableFatalError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableInvalidRecord(void) { }
	#pragma option pop
	
};


class DELPHICLASS EMemTableIndexError;
class PASCALIMPLEMENTATION EMemTableIndexError : public EMemTableError 
{
	typedef EMemTableError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableIndexError(const AnsiString Msg) : EMemTableError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableIndexError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EMemTableError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableIndexError(int Ident)/* overload */ : EMemTableError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableIndexError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EMemTableError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableIndexError(const AnsiString Msg, int AHelpContext) : EMemTableError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableIndexError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EMemTableError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableIndexError(int Ident, int AHelpContext)/* overload */ : EMemTableError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableIndexError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EMemTableError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableIndexError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EMemTableDupKey;
class PASCALIMPLEMENTATION EMemTableDupKey : public EMemTableError 
{
	typedef EMemTableError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableDupKey(const AnsiString Msg) : EMemTableError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableDupKey(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EMemTableError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableDupKey(int Ident)/* overload */ : EMemTableError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableDupKey(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EMemTableError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableDupKey(const AnsiString Msg, int AHelpContext) : EMemTableError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableDupKey(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EMemTableError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableDupKey(int Ident, int AHelpContext)/* overload */ : EMemTableError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableDupKey(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EMemTableError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableDupKey(void) { }
	#pragma option pop
	
};


class DELPHICLASS EMemTableFilterError;
class PASCALIMPLEMENTATION EMemTableFilterError : public EMemTableError 
{
	typedef EMemTableError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableFilterError(const AnsiString Msg) : EMemTableError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableFilterError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EMemTableError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableFilterError(int Ident)/* overload */ : EMemTableError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableFilterError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EMemTableError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableFilterError(const AnsiString Msg, int AHelpContext) : EMemTableError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableFilterError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EMemTableError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableFilterError(int Ident, int AHelpContext)/* overload */ : EMemTableError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableFilterError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EMemTableError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableFilterError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EMemTableLocaleError;
class PASCALIMPLEMENTATION EMemTableLocaleError : public EMemTableError 
{
	typedef EMemTableError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableLocaleError(const AnsiString Msg) : EMemTableError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableLocaleError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EMemTableError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableLocaleError(int Ident)/* overload */ : EMemTableError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableLocaleError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EMemTableError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableLocaleError(const AnsiString Msg, int AHelpContext) : EMemTableError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableLocaleError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EMemTableError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableLocaleError(int Ident, int AHelpContext)/* overload */ : EMemTableError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableLocaleError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EMemTableError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableLocaleError(void) { }
	#pragma option pop
	
};


class DELPHICLASS EMemTableInvalidLocale;
class PASCALIMPLEMENTATION EMemTableInvalidLocale : public EMemTableLocaleError 
{
	typedef EMemTableLocaleError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EMemTableInvalidLocale(const AnsiString Msg) : EMemTableLocaleError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EMemTableInvalidLocale(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EMemTableLocaleError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EMemTableInvalidLocale(int Ident)/* overload */ : EMemTableLocaleError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EMemTableInvalidLocale(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EMemTableLocaleError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EMemTableInvalidLocale(const AnsiString Msg, int AHelpContext) : EMemTableLocaleError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EMemTableInvalidLocale(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EMemTableLocaleError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EMemTableInvalidLocale(int Ident, int AHelpContext)/* overload */ : EMemTableLocaleError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EMemTableInvalidLocale(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EMemTableLocaleError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EMemTableInvalidLocale(void) { }
	#pragma option pop
	
};


struct TkbmRecord;
typedef TkbmRecord *PkbmRecord;

typedef Db::TBookmarkFlag *PBookmarkFlag;

#pragma pack(push,4)
struct TkbmBookmark
{
	
public:
	TkbmRecord *Bookmark;
	Db::TBookmarkFlag Flag;
} ;
#pragma pack(pop)

typedef TkbmBookmark *PkbmBookmark;

#pragma pack(push,4)
struct TkbmUserBookmark
{
	
public:
	TkbmRecord *Bookmark;
	int DataID;
} ;
#pragma pack(pop)

typedef TkbmUserBookmark *PkbmUserBookmark;

typedef TList TkbmList;
;

#pragma option push -b-
enum TkbmifoOption { mtifoDescending, mtifoCaseInsensitive, mtifoPartial, mtifoIgnoreNull, mtifoIgnoreLocale };
#pragma option pop

typedef Set<TkbmifoOption, mtifoDescending, mtifoIgnoreLocale>  TkbmifoOptions;

#pragma pack(push,4)
struct TkbmRecord
{
	
public:
	int RecordNo;
	int RecordID;
	int UniqueRecordID;
	Byte Flag;
	Db::TUpdateStatus UpdateStatus;
	int TransactionLevel;
	int Tag;
	TkbmRecord *PrevRecordVersion;
	char *Data;
} ;
#pragma pack(pop)

typedef Db::TDateTimeRec *PDateTimeRec;

typedef Word *PWordBool;

#pragma option push -b-
enum TkbmMemTableStorageType { mtstDataSet, mtstStream, mtstBinaryStream, mtstFile, mtstBinaryFile };
#pragma option pop

#pragma option push -b-
enum TkbmMemTableUpdateFlag { mtufEdit, mtufAppend, mtufDontClear };
#pragma option pop

typedef Set<TkbmMemTableUpdateFlag, mtufEdit, mtufDontClear>  TkbmMemTableUpdateFlags;

typedef Set<Db::TFieldType, Db::ftUnknown, Db::ftOraInterval>  TkbmFieldTypes;

#pragma option push -b-
enum TkbmMemTableCompareOption { mtcoDescending, mtcoCaseInsensitive, mtcoPartialKey, mtcoIgnoreNullKey, mtcoIgnoreLocale, mtcoUnique, mtcoNonMaintained };
#pragma option pop

typedef Set<TkbmMemTableCompareOption, mtcoDescending, mtcoNonMaintained>  TkbmMemTableCompareOptions;

#pragma option push -b-
enum TkbmMemTableCopyTableOption { mtcpoStructure, mtcpoOnlyActiveFields, mtcpoProperties, mtcpoLookup, mtcpoCalculated, mtcpoAppend, mtcpoFieldIndex, mtcpoDontDisableIndexes, mtcpoIgnoreErrors, mtcpoStringAsWideString, mtcpoWideStringUTF8 };
#pragma option pop

typedef Set<TkbmMemTableCopyTableOption, mtcpoStructure, mtcpoWideStringUTF8>  TkbmMemTableCopyTableOptions;

class DELPHICLASS TkbmIndex;
typedef void __fastcall (__closure *TkbmOnFilterIndex)(Db::TDataSet* DataSet, TkbmIndex* Index, bool &Accept);

typedef char *PkbmVarLength;

typedef char * *PPkbmVarLength;

#pragma option push -b-
enum TkbmIndexType { mtitNonSorted, mtitSorted };
#pragma option pop

class DELPHICLASS TkbmFieldList;
class PASCALIMPLEMENTATION TkbmFieldList : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	int FCount;
	
public:
	int FieldOfs[256];
	int FieldNo[256];
	Db::TField* Fields[256];
	TkbmifoOptions Options[256];
	__fastcall virtual ~TkbmFieldList(void);
	int __fastcall Add(Db::TField* AField, TkbmifoOptions AValue);
	virtual void __fastcall Clear(void);
	int __fastcall IndexOf(Db::TField* Item);
	void __fastcall AssignTo(TkbmFieldList* AFieldList);
	void __fastcall MergeOptionsTo(TkbmFieldList* AFieldList);
	void __fastcall ClearOptions(void);
	__property int Count = {read=FCount, nodefault};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TkbmFieldList(void) : System::TObject() { }
	#pragma option pop
	
};


class DELPHICLASS TkbmCustomMemTable;
class DELPHICLASS TkbmCommon;
#pragma option push -b-
enum TkbmPerformance { mtpfFast, mtpfBalanced, mtpfSmall };
#pragma option pop

#pragma option push -b-
enum TkbmVersioningMode { mtvm1SinceCheckPoint, mtvmAllSinceCheckPoint };
#pragma option pop

#pragma option push -b-
enum TkbmCompareHow { chBreakNE, chBreakLT, chBreakGT, chBreakLTE, chBreakGTE };
#pragma option pop

#pragma option push -b-
enum TkbmIndexUpdateHow { mtiuhInsert, mtiuhEdit, mtiuhDelete };
#pragma option pop

class PASCALIMPLEMENTATION TkbmCommon : public System::TObject 
{
	typedef System::TObject inherited;
	
protected:
	Syncobjs::TCriticalSection* FLock;
	bool FStandalone;
	Classes::TList* FRecords;
	TkbmCustomMemTable* FOwner;
	int FFieldCount;
	int FFieldOfs[256];
	Byte FFieldFlags[256];
	int FLanguageID;
	int FSubLanguageID;
	int FSortID;
	int FDataID;
	int FLocaleID;
	int FBookmarkArraySize;
	int FFixedRecordSize;
	int FTotalRecordSize;
	int FDataRecordSize;
	int FCalcRecordSize;
	int FVarLengthRecordSize;
	int FStartCalculated;
	int FStartBookmarks;
	int FStartVarLength;
	int FVarLengthCount;
	bool FIsDataModified;
	int FAutoIncMin;
	int FAutoIncMax;
	int FDeletedCount;
	int FUniqueRecordID;
	int FRecordID;
	TkbmPerformance FPerformance;
	int FAttachMaxCount;
	Classes::TList* FAttachedTables;
	Classes::TList* FDeletedRecords;
	TkbmVersioningMode FVersioningMode;
	bool FEnableVersioning;
	int FTransactionLevel;
	bool FThreadProtected;
	PkbmRecord __fastcall _InternalCopyRecord(PkbmRecord SourceRecord, bool CopyVarLengths);
	void __fastcall _InternalCopyVarLength(PkbmRecord SourceRecord, PkbmRecord DestRecord, Db::TField* Field);
	void __fastcall _InternalCopyVarLengths(PkbmRecord SourceRec, PkbmRecord DestRec);
	void __fastcall _InternalMoveRecord(PkbmRecord SourceRecord, PkbmRecord DestRecord);
	void __fastcall _InternalTransferRecord(PkbmRecord SourceRecord, PkbmRecord DestRecord);
	void __fastcall _InternalFreeRecordVarLengths(PkbmRecord ARecord);
	void __fastcall _InternalClearRecord(PkbmRecord ARecord);
	void __fastcall _InternalAppendRecord(PkbmRecord ARecord);
	void __fastcall _InternalDeleteRecord(PkbmRecord ARecord);
	void __fastcall _InternalPackRecords(void);
	void __fastcall _InternalEmpty(void);
	int __fastcall _InternalCompareRecords(const TkbmFieldList* FieldList, const int MaxFields, const PkbmRecord KeyRecord, const PkbmRecord ARecord, const bool IgnoreNull, const bool Partial, const TkbmCompareHow How);
	void __fastcall SetStandalone(bool Value);
	bool __fastcall GetStandalone(void);
	void __fastcall SetAutoIncMin(int Value);
	int __fastcall GetAutoIncMin(void);
	void __fastcall SetAutoIncMax(int Value);
	int __fastcall GetAutoIncMax(void);
	void __fastcall SetPerformance(TkbmPerformance Value);
	TkbmPerformance __fastcall GetPerformance(void);
	void __fastcall SetVersioningMode(TkbmVersioningMode Value);
	TkbmVersioningMode __fastcall GetVersioningMode(void);
	void __fastcall SetEnableVersioning(bool Value);
	bool __fastcall GetEnableVersioning(void);
	void __fastcall SetCapacity(int Value);
	int __fastcall GetCapacity(void);
	int __fastcall GetTransactionLevel(void);
	bool __fastcall GetIsDataModified(void);
	void __fastcall SetIsDataModified(bool Value);
	void __fastcall ClearModifiedFlags(void);
	bool __fastcall GetModifiedFlag(int i);
	void __fastcall SetModifiedFlag(int i, bool Value);
	int __fastcall GetAttachMaxCount(void);
	void __fastcall SetAttachMaxCount(int Value);
	int __fastcall GetAttachCount(void);
	void __fastcall SetRecordID(int ARecordID);
	void __fastcall SetUniqueRecordID(int ARecordID);
	void __fastcall SetDeletedCount(int ACount);
	int __fastcall GetLanguageID(void);
	void __fastcall SetLanguageID(int Value);
	int __fastcall GetSortID(void);
	void __fastcall SetSortID(int Value);
	int __fastcall GetSubLanguageID(void);
	void __fastcall SetSubLanguageID(int Value);
	int __fastcall GetLocaleID(void);
	void __fastcall SetLocaleID(int Value);
	void __fastcall CalcLocaleID(void);
	int __fastcall GetUniqueDataID(void);
	
public:
	int __fastcall GetDeletedRecordsCount(void);
	int __fastcall GetFieldSize(Db::TFieldType FieldType, int Size);
	int __fastcall GetFieldDataOffset(Db::TField* Field);
	char * __fastcall GetFieldPointer(PkbmRecord ARecord, Db::TField* Field);
	PkbmRecord __fastcall _InternalAllocRecord(void);
	void __fastcall _InternalFreeRecord(PkbmRecord ARecord, bool FreeVarLengths, bool FreeVersions);
	__fastcall TkbmCommon(TkbmCustomMemTable* AOwner);
	__fastcall virtual ~TkbmCommon(void);
	void __fastcall Lock(void);
	void __fastcall Unlock(void);
	bool __fastcall GetFieldIsVarLength(Db::TFieldType FieldType, int Size);
	void * __fastcall CompressFieldBuffer(Db::TField* Field, const void * Buffer, int &Size);
	void * __fastcall DecompressFieldBuffer(Db::TField* Field, const void * Buffer, int &Size);
	void __fastcall AttachTable(TkbmCustomMemTable* ATable);
	void __fastcall DeAttachTable(TkbmCustomMemTable* ATable);
	void __fastcall LayoutRecord(const int AFieldCount);
	void __fastcall AppendRecord(PkbmRecord ARecord);
	void __fastcall DeleteRecord(PkbmRecord ARecord);
	void __fastcall PackRecords(void);
	int __fastcall RecordCount(void);
	int __fastcall DeletedRecordCount(void);
	void __fastcall Rollback(void);
	void __fastcall Commit(void);
	void __fastcall Undo(PkbmRecord ARecord);
	bool __fastcall IsAnyTableActive(void);
	void __fastcall CloseTables(TkbmCustomMemTable* Caller);
	void __fastcall RefreshTables(TkbmCustomMemTable* Caller);
	void __fastcall ResyncTables(void);
	void __fastcall EmptyTables(void);
	void __fastcall RebuildIndexes(void);
	void __fastcall MarkIndexesDirty(void);
	void __fastcall UpdateIndexes(void);
	void __fastcall ClearIndexes(void);
	void __fastcall ReflectToIndexes(const TkbmCustomMemTable* Caller, const TkbmIndexUpdateHow How, const PkbmRecord OldRecord, const PkbmRecord NewRecord, const int RecordPos, const bool DontVersion);
	void __fastcall IncTransactionLevel(void);
	void __fastcall DecTransactionLevel(void);
	__property int DataRecordSize = {read=FDataRecordSize, nodefault};
	__property Classes::TList* Records = {read=FRecords};
	__property int RecordID = {read=FRecordID, write=SetRecordID, nodefault};
	__property int UniqueRecordID = {read=FUniqueRecordID, write=SetUniqueRecordID, nodefault};
	__property int DeletedCount = {read=FDeletedCount, write=SetDeletedCount, nodefault};
	__property int AttachMaxCount = {read=GetAttachMaxCount, write=SetAttachMaxCount, nodefault};
	__property int AttachCount = {read=GetAttachCount, nodefault};
	__property bool Standalone = {read=GetStandalone, write=SetStandalone, nodefault};
	__property int AutoIncMin = {read=GetAutoIncMin, write=SetAutoIncMin, nodefault};
	__property int AutoIncMax = {read=GetAutoIncMax, write=SetAutoIncMax, nodefault};
	__property TkbmPerformance Performance = {read=GetPerformance, write=SetPerformance, nodefault};
	__property TkbmVersioningMode VersioningMode = {read=GetVersioningMode, write=SetVersioningMode, nodefault};
	__property bool EnableVersioning = {read=GetEnableVersioning, write=SetEnableVersioning, nodefault};
	__property int Capacity = {read=GetCapacity, write=SetCapacity, nodefault};
	__property bool IsDataModified = {read=GetIsDataModified, write=SetIsDataModified, nodefault};
	__property int TransactionLevel = {read=GetTransactionLevel, nodefault};
	__property bool FieldModified[int i] = {read=GetModifiedFlag, write=SetModifiedFlag};
	__property int LanguageID = {read=GetLanguageID, write=SetLanguageID, nodefault};
	__property int SortID = {read=GetSortID, write=SetSortID, nodefault};
	__property int SubLanguageID = {read=GetSubLanguageID, write=SetSubLanguageID, nodefault};
	__property int LocaleID = {read=GetLocaleID, write=SetLocaleID, nodefault};
};


class DELPHICLASS TkbmIndexes;
class PASCALIMPLEMENTATION TkbmIndexes : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	TkbmIndex* FRowOrderIndex;
	Classes::TStringList* FIndexes;
	TkbmCustomMemTable* FDataSet;
	
public:
	__fastcall TkbmIndexes(TkbmCustomMemTable* ADataSet);
	__fastcall virtual ~TkbmIndexes(void);
	void __fastcall Clear(void);
	void __fastcall Add(const Db::TIndexDef* IndexDef);
	void __fastcall AddIndex(const TkbmIndex* Index);
	void __fastcall DeleteIndex(const TkbmIndex* Index);
	void __fastcall ReBuild(const AnsiString IndexName);
	void __fastcall Delete(const AnsiString IndexName);
	TkbmIndex* __fastcall Get(const AnsiString IndexName);
	TkbmIndex* __fastcall GetIndex(const int Ordinal);
	void __fastcall Empty(const AnsiString IndexName);
	TkbmIndex* __fastcall GetByFieldNames(AnsiString FieldNames);
	void __fastcall EmptyAll(void);
	void __fastcall ReBuildAll(void);
	void __fastcall MarkAllDirty(void);
	void __fastcall CheckRecordUniqueness(const PkbmRecord ARecord, const PkbmRecord ActualRecord);
	void __fastcall ReflectToIndexes(const TkbmIndexUpdateHow How, const PkbmRecord OldRecord, const PkbmRecord NewRecord, const int RecordPos, const bool DontVersion);
	int __fastcall Search(const TkbmFieldList* FieldList, const PkbmRecord KeyRecord, const bool Nearest, const bool RespectFilter, const bool AutoAddIdx, int &Index, bool &Found);
	int __fastcall Count(void);
};


class DELPHICLASS TkbmCustomStreamFormat;
typedef void __fastcall (__closure *TkbmOnCompress)(TkbmCustomMemTable* Dataset, Classes::TStream* UnCompressedStream, Classes::TStream* CompressedStream);

typedef void __fastcall (__closure *TkbmOnDeCompress)(TkbmCustomMemTable* Dataset, Classes::TStream* CompressedStream, Classes::TStream* DeCompressedStream);

#pragma option push -b-
enum TkbmStreamFlagData { sfSaveData, sfLoadData };
#pragma option pop

typedef Set<TkbmStreamFlagData, sfSaveData, sfLoadData>  TkbmStreamFlagsData;

#pragma option push -b-
enum TkbmStreamFlagCalculated { sfSaveCalculated, sfLoadCalculated };
#pragma option pop

typedef Set<TkbmStreamFlagCalculated, sfSaveCalculated, sfLoadCalculated>  TkbmStreamFlagsCalculated;

#pragma option push -b-
enum TkbmStreamFlagLookup { sfSaveLookup, sfLoadLookup };
#pragma option pop

typedef Set<TkbmStreamFlagLookup, sfSaveLookup, sfLoadLookup>  TkbmStreamFlagsLookup;

#pragma option push -b-
enum TkbmStreamFlagNonVisible { sfSaveNonVisible, sfLoadNonVisible };
#pragma option pop

typedef Set<TkbmStreamFlagNonVisible, sfSaveNonVisible, sfLoadNonVisible>  TkbmStreamFlagsNonVisible;

#pragma option push -b-
enum TkbmStreamFlagBlobs { sfSaveBlobs, sfLoadBlobs };
#pragma option pop

typedef Set<TkbmStreamFlagBlobs, sfSaveBlobs, sfLoadBlobs>  TkbmStreamFlagsBlobs;

#pragma option push -b-
enum TkbmStreamFlagDef { sfSaveDef, sfLoadDef };
#pragma option pop

typedef Set<TkbmStreamFlagDef, sfSaveDef, sfLoadDef>  TkbmStreamFlagsDef;

#pragma option push -b-
enum TkbmStreamFlagIndexDef { sfSaveIndexDef, sfLoadIndexDef };
#pragma option pop

typedef Set<TkbmStreamFlagIndexDef, sfSaveIndexDef, sfLoadIndexDef>  TkbmStreamFlagsIndexDef;

#pragma option push -b-
enum TkbmStreamFlagFiltered { sfSaveFiltered };
#pragma option pop

typedef Set<TkbmStreamFlagFiltered, sfSaveFiltered, sfSaveFiltered>  TkbmStreamFlagsFiltered;

#pragma option push -b-
enum TkbmStreamFlagIgnoreRange { sfSaveIgnoreRange };
#pragma option pop

typedef Set<TkbmStreamFlagIgnoreRange, sfSaveIgnoreRange, sfSaveIgnoreRange>  TkbmStreamFlagsIgnoreRange;

#pragma option push -b-
enum TkbmStreamFlagIgnoreMasterDetail { sfSaveIgnoreMasterDetail };
#pragma option pop

typedef Set<TkbmStreamFlagIgnoreMasterDetail, sfSaveIgnoreMasterDetail, sfSaveIgnoreMasterDetail>  TkbmStreamFlagsIgnoreMasterDetail;

#pragma option push -b-
enum TkbmStreamFlagDeltas { sfSaveDeltas, sfLoadDeltas };
#pragma option pop

typedef Set<TkbmStreamFlagDeltas, sfSaveDeltas, sfLoadDeltas>  TkbmStreamFlagsDeltas;

#pragma option push -b-
enum TkbmStreamFlagDontFilterDeltas { sfSaveDontFilterDeltas };
#pragma option pop

typedef Set<TkbmStreamFlagDontFilterDeltas, sfSaveDontFilterDeltas, sfSaveDontFilterDeltas>  TkbmStreamFlagsDontFilterDeltas;

#pragma option push -b-
enum TkbmStreamFlagAppend { sfSaveAppend, sfSaveInsert };
#pragma option pop

typedef Set<TkbmStreamFlagAppend, sfSaveAppend, sfSaveInsert>  TkbmStreamFlagsAppend;

#pragma option push -b-
enum TkbmStreamFlagFieldKind { sfSaveFieldKind, sfLoadFieldKind };
#pragma option pop

typedef Set<TkbmStreamFlagFieldKind, sfSaveFieldKind, sfLoadFieldKind>  TkbmStreamFlagsFieldKind;

#pragma option push -b-
enum TkbmStreamFlagFromStart { sfLoadFromStart };
#pragma option pop

typedef Set<TkbmStreamFlagFromStart, sfLoadFromStart, sfLoadFromStart>  TkbmStreamFlagsFromStart;

#pragma option push -b-
enum TkbmDetermineLoadFieldsSituation { dlfBeforeLoad, dlfAfterLoadDef };
#pragma option pop

class PASCALIMPLEMENTATION TkbmCustomStreamFormat : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	Classes::TStream* FOrigStream;
	Classes::TStream* FWorkStream;
	void *FBookmark;
	TkbmOnCompress FOnCompress;
	TkbmOnDeCompress FOnDecompress;
	bool FWasFiltered;
	bool FWasRangeActive;
	bool FWasMasterLinkUsed;
	bool FWasEnableIndexes;
	bool FWasPersistent;
	TkbmStreamFlagsData FsfData;
	TkbmStreamFlagsCalculated FsfCalculated;
	TkbmStreamFlagsLookup FsfLookup;
	TkbmStreamFlagsNonVisible FsfNonVisible;
	TkbmStreamFlagsBlobs FsfBlobs;
	TkbmStreamFlagsDef FsfDef;
	TkbmStreamFlagsIndexDef FsfIndexDef;
	TkbmStreamFlagsFiltered FsfFiltered;
	TkbmStreamFlagsIgnoreRange FsfIgnoreRange;
	TkbmStreamFlagsIgnoreMasterDetail FsfIgnoreMasterDetail;
	TkbmStreamFlagsDeltas FsfDeltas;
	TkbmStreamFlagsDontFilterDeltas FsfDontFilterDeltas;
	TkbmStreamFlagsAppend FsfAppend;
	TkbmStreamFlagsFieldKind FsfFieldKind;
	TkbmStreamFlagsFromStart FsfFromStart;
	Classes::TNotifyEvent FOnBeforeSave;
	Classes::TNotifyEvent FOnAfterSave;
	Classes::TNotifyEvent FOnBeforeLoad;
	Classes::TNotifyEvent FOnAfterLoad;
	void __fastcall SetVersion(AnsiString AVersion);
	
protected:
	DynamicArray<int >  SaveFields;
	DynamicArray<int >  LoadFields;
	void __fastcall SetIgnoreAutoIncPopulation(TkbmCustomMemTable* ADataset, bool Value);
	virtual AnsiString __fastcall GetVersion();
	virtual void __fastcall DetermineSaveFields(TkbmCustomMemTable* ADataset);
	virtual void __fastcall BeforeSave(TkbmCustomMemTable* ADataset);
	virtual void __fastcall SaveDef(TkbmCustomMemTable* ADataset);
	virtual void __fastcall SaveData(TkbmCustomMemTable* ADataset);
	virtual void __fastcall Save(TkbmCustomMemTable* ADataset);
	virtual void __fastcall AfterSave(TkbmCustomMemTable* ADataset);
	virtual void __fastcall DetermineLoadFieldIDs(TkbmCustomMemTable* ADataset, Classes::TStringList* AList, TkbmDetermineLoadFieldsSituation Situation);
	virtual void __fastcall DetermineLoadFields(TkbmCustomMemTable* ADataset, TkbmDetermineLoadFieldsSituation Situation);
	virtual void __fastcall DetermineLoadFieldIndex(TkbmCustomMemTable* ADataset, AnsiString ID, int FieldCount, int OrigIndex, int &NewIndex, TkbmDetermineLoadFieldsSituation Situation);
	virtual void __fastcall BeforeLoad(TkbmCustomMemTable* ADataset);
	virtual void __fastcall LoadDef(TkbmCustomMemTable* ADataset);
	virtual void __fastcall LoadData(TkbmCustomMemTable* ADataset);
	virtual void __fastcall Load(TkbmCustomMemTable* ADataset);
	virtual void __fastcall AfterLoad(TkbmCustomMemTable* ADataset);
	__property Classes::TStream* WorkStream = {read=FWorkStream, write=FWorkStream};
	__property Classes::TStream* OrigStream = {read=FOrigStream, write=FOrigStream};
	__property TkbmStreamFlagsData sfData = {read=FsfData, write=FsfData, nodefault};
	__property TkbmStreamFlagsCalculated sfCalculated = {read=FsfCalculated, write=FsfCalculated, nodefault};
	__property TkbmStreamFlagsLookup sfLookup = {read=FsfLookup, write=FsfLookup, nodefault};
	__property TkbmStreamFlagsNonVisible sfNonVisible = {read=FsfNonVisible, write=FsfNonVisible, nodefault};
	__property TkbmStreamFlagsBlobs sfBlobs = {read=FsfBlobs, write=FsfBlobs, nodefault};
	__property TkbmStreamFlagsDef sfDef = {read=FsfDef, write=FsfDef, nodefault};
	__property TkbmStreamFlagsIndexDef sfIndexDef = {read=FsfIndexDef, write=FsfIndexDef, nodefault};
	__property TkbmStreamFlagsFiltered sfFiltered = {read=FsfFiltered, write=FsfFiltered, nodefault};
	__property TkbmStreamFlagsIgnoreRange sfIgnoreRange = {read=FsfIgnoreRange, write=FsfIgnoreRange, nodefault};
	__property TkbmStreamFlagsIgnoreMasterDetail sfIgnoreMasterDetail = {read=FsfIgnoreMasterDetail, write=FsfIgnoreMasterDetail, nodefault};
	__property TkbmStreamFlagsDeltas sfDeltas = {read=FsfDeltas, write=FsfDeltas, nodefault};
	__property TkbmStreamFlagsDontFilterDeltas sfDontFilterDeltas = {read=FsfDontFilterDeltas, write=FsfDontFilterDeltas, nodefault};
	__property TkbmStreamFlagsAppend sfAppend = {read=FsfAppend, write=FsfAppend, nodefault};
	__property TkbmStreamFlagsFieldKind sfFieldKind = {read=FsfFieldKind, write=FsfFieldKind, nodefault};
	__property TkbmStreamFlagsFromStart sfFromStart = {read=FsfFromStart, write=FsfFromStart, nodefault};
	__property AnsiString Version = {read=GetVersion, write=SetVersion};
	__property Classes::TNotifyEvent OnBeforeSave = {read=FOnBeforeSave, write=FOnBeforeSave};
	__property Classes::TNotifyEvent OnAfterSave = {read=FOnAfterSave, write=FOnAfterSave};
	__property Classes::TNotifyEvent OnBeforeLoad = {read=FOnBeforeLoad, write=FOnBeforeLoad};
	__property Classes::TNotifyEvent OnAfterLoad = {read=FOnAfterLoad, write=FOnAfterLoad};
	__property TkbmOnCompress OnCompress = {read=FOnCompress, write=FOnCompress};
	__property TkbmOnDeCompress OnDeCompress = {read=FOnDecompress, write=FOnDecompress};
	
public:
	__fastcall virtual TkbmCustomStreamFormat(Classes::TComponent* AOwner);
	virtual void __fastcall Assign(Classes::TPersistent* Source);
public:
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TkbmCustomStreamFormat(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TkbmState { mtstBrowse, mtstLoad, mtstSave, mtstEmpty, mtstPack, mtstCheckPoint, mtstSearch, mtstUpdate, mtstSort };
#pragma option pop

class DELPHICLASS TkbmCustomDeltaHandler;
typedef void __fastcall (__closure *TkbmDeltaHandlerGetValue)(TkbmCustomDeltaHandler* ADeltaHandler, Db::TField* AField, Variant &AValue);

class PASCALIMPLEMENTATION TkbmCustomDeltaHandler : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	TkbmDeltaHandlerGetValue FOnGetValue;
	TkbmCustomMemTable* FDataSet;
	void __fastcall CheckDataSet(void);
	Variant __fastcall GetValues(int Index);
	Variant __fastcall GetOrigValues(int Index);
	int __fastcall GetFieldCount(void);
	AnsiString __fastcall GetFieldNames(int Index);
	Db::TField* __fastcall GetFields(int Index);
	Variant __fastcall GetOrigValuesByName(AnsiString Name);
	Variant __fastcall GetValuesByName(AnsiString Name);
	int __fastcall GetRecordNo(void);
	int __fastcall GetUniqueRecordID(void);
	
protected:
	TkbmRecord *FPRecord;
	TkbmRecord *FPOrigRecord;
	virtual void __fastcall BeforeRecord(void);
	virtual void __fastcall InsertRecord(bool &Retry, Db::TUpdateStatus &State);
	virtual void __fastcall DeleteRecord(bool &Retry, Db::TUpdateStatus &State);
	virtual void __fastcall ModifyRecord(bool &Retry, Db::TUpdateStatus &State);
	virtual void __fastcall UnmodifiedRecord(bool &Retry, Db::TUpdateStatus &State);
	virtual void __fastcall AfterRecord(void);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation);
	
public:
	virtual void __fastcall Resolve(void);
	__property TkbmCustomMemTable* DataSet = {read=FDataSet, write=FDataSet};
	__property int FieldCount = {read=GetFieldCount, nodefault};
	__property Variant OrigValues[int i] = {read=GetOrigValues};
	__property Variant Values[int i] = {read=GetValues};
	__property Variant OrigValuesByName[AnsiString Name] = {read=GetOrigValuesByName};
	__property Variant ValuesByName[AnsiString Name] = {read=GetValuesByName};
	__property AnsiString FieldNames[int i] = {read=GetFieldNames};
	__property Db::TField* Fields[int i] = {read=GetFields};
	__property int RecNo = {read=GetRecordNo, nodefault};
	__property int UniqueRecID = {read=GetUniqueRecordID, nodefault};
	
__published:
	__property TkbmDeltaHandlerGetValue OnGetValue = {read=FOnGetValue, write=FOnGetValue};
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TkbmCustomDeltaHandler(Classes::TComponent* AOwner) : Classes::TComponent(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TkbmCustomDeltaHandler(void) { }
	#pragma option pop
	
};


typedef void __fastcall (__closure *TkbmOnCompareFields)(Db::TDataSet* DataSet, Db::TField* AFld, void * KeyField, void * AField, Db::TFieldType FieldType, TkbmifoOptions Options, bool &FullCompare, int &Result);

typedef void __fastcall (__closure *TkbmOnSave)(Db::TDataSet* DataSet, TkbmMemTableStorageType StorageType, Classes::TStream* Stream);

typedef void __fastcall (__closure *TkbmOnLoad)(Db::TDataSet* DataSet, TkbmMemTableStorageType StorageType, Classes::TStream* Stream);

#pragma option push -b-
enum TkbmProgressCode { mtpcLoad, mtpcSave, mtpcEmpty, mtpcPack, mtpcCheckPoint, mtpcSearch, mtpcCopy, mtpcUpdate, mtpcSort };
#pragma option pop

typedef Set<TkbmProgressCode, mtpcLoad, mtpcSort>  TkbmProgressCodes;

typedef void __fastcall (__closure *TkbmOnProgress)(Db::TDataSet* DataSet, int Percentage, TkbmProgressCode Code);

typedef void __fastcall (__closure *TkbmOnLoadRecord)(Db::TDataSet* DataSet, bool &Accept);

typedef void __fastcall (__closure *TkbmOnSaveRecord)(Db::TDataSet* DataSet, bool &Accept);

typedef void __fastcall (__closure *TkbmOnLoadField)(Db::TDataSet* DataSet, int FieldNo, Db::TField* Field);

typedef void __fastcall (__closure *TkbmOnSaveField)(Db::TDataSet* DataSet, int FieldNo, Db::TField* Field);

typedef void __fastcall (__closure *TkbmOnSetupField)(Db::TDataSet* DataSet, Db::TField* Field, Byte &FieldFlags);

typedef void __fastcall (__closure *TkbmOnSetupFieldProperties)(Db::TDataSet* DataSet, Db::TField* Field);

typedef void __fastcall (__closure *TkbmOnCompressField)(Db::TDataSet* DataSet, Db::TField* Field, const char * Buffer, int &Size, char * &ResultBuffer);

typedef void __fastcall (__closure *TkbmOnDecompressField)(Db::TDataSet* DataSet, Db::TField* Field, const char * Buffer, int &Size, char * &ResultBuffer);

class PASCALIMPLEMENTATION TkbmCustomMemTable : public Db::TDataSet 
{
	typedef Db::TDataSet inherited;
	
protected:
	int FTableID;
	TkbmCommon* FCommon;
	TkbmIndexes* FIndexes;
	TkbmCustomStreamFormat* FDefaultFormat;
	TkbmCustomStreamFormat* FCommaTextFormat;
	TkbmCustomStreamFormat* FPersistentFormat;
	TkbmCustomStreamFormat* FFormFormat;
	TkbmCustomStreamFormat* FAllDataFormat;
	TkbmRecord *FFilterRecord;
	TkbmRecord *FKeyRecord;
	TkbmRecord *FKeyBuffers[4];
	bool FIgnoreReadOnly;
	bool FIgnoreAutoIncPopulation;
	Db::TIndexDefs* FIndexDefs;
	TkbmIndex* FCurIndex;
	TkbmIndex* FSortIndex;
	bool FEnableIndexes;
	bool FAutoAddIndexes;
	bool FDesignActivation;
	bool FInterceptActive;
	bool FAutoUpdateFieldVariables;
	TkbmState FState;
	Dbcommon::TExprParser* FFilterParser;
	Db::TFilterOptions FFilterOptions;
	Db::TMasterDataLink* FMasterLink;
	bool FMasterLinkUsed;
	bool FIsOpen;
	int FRecNo;
	int FReposRecNo;
	int FInsertRecNo;
	bool FBeforeCloseCalled;
	bool FDuringAfterOpen;
	int FLoadLimit;
	int FLoadCount;
	bool FLoadedCompletely;
	int FSaveLimit;
	int FSaveCount;
	bool FSavedCompletely;
	TkbmCustomDeltaHandler* FDeltaHandler;
	TkbmRecord *FOverrideActiveRecordBuffer;
	Db::TUpdateStatusSet FStatusFilter;
	TkbmCustomMemTable* FAttachedTo;
	bool FAttachedAutoRefresh;
	Db::TField* FAutoIncField;
	bool FRecalcOnFetch;
	bool FReadOnly;
	bool FPersistent;
	AnsiString FPersistentFile;
	bool FPersistentSaved;
	bool FPersistentBackup;
	AnsiString FPersistentBackupExt;
	bool FStoreDataOnForm;
	Classes::TMemoryStream* FTempDataStorage;
	AnsiString FDummyStr;
	TkbmFieldList* FMasterIndexList;
	TkbmFieldList* FDetailIndexList;
	TkbmFieldList* FIndexList;
	bool FRecalcOnIndex;
	AnsiString FIndexFieldNames;
	AnsiString FDetailFieldNames;
	AnsiString FIndexName;
	AnsiString FSortFieldNames;
	bool FAutoReposition;
	bool FRangeIgnoreNullKeyValues;
	AnsiString FSortedOn;
	bool FRangeActive;
	TkbmMemTableCompareOptions FSortOptions;
	TkbmOnCompareFields FOnCompareFields;
	TkbmOnSave FOnSave;
	TkbmOnLoad FOnLoad;
	TkbmProgressCodes FProgressFlags;
	TkbmOnProgress FOnProgress;
	TkbmOnLoadRecord FOnLoadRecord;
	TkbmOnSaveRecord FOnSaveRecord;
	TkbmOnLoadField FOnLoadField;
	TkbmOnSaveField FOnSaveField;
	TkbmOnCompress FOnCompressBlobStream;
	TkbmOnDeCompress FOnDecompressBlobStream;
	TkbmOnSetupField FOnSetupField;
	TkbmOnSetupFieldProperties FOnSetupFieldProperties;
	TkbmOnCompressField FOnCompressField;
	TkbmOnDecompressField FOnDecompressField;
	Db::TDataSetNotifyEvent FBeforeInsert;
	TkbmOnFilterIndex FOnFilterIndex;
	bool FIsFiltered;
	void __fastcall _InternalBeforeInsert(Db::TDataSet* DataSet);
	PkbmRecord __fastcall GetActiveRecord(void);
	virtual void __fastcall _InternalFirst(void);
	virtual void __fastcall _InternalLast(void);
	virtual bool __fastcall _InternalNext(bool ForceUseFilter);
	virtual bool __fastcall _InternalPrior(bool ForceUseFilter);
	void __fastcall SetMasterFields(const AnsiString Value);
	void __fastcall SetDetailFields(const AnsiString Value);
	AnsiString __fastcall GetMasterFields();
	void __fastcall SetDataSource(Db::TDataSource* Value);
	virtual void __fastcall SetIsFiltered(void);
	__property bool IsFiltered = {read=FIsFiltered, nodefault};
	void __fastcall BuildFilter(Dbcommon::TExprParser* &AFilterParser, AnsiString AFilter, Db::TFilterOptions AFilterOptions);
	Variant __fastcall ParseFilter(Dbcommon::TExprParser* FilterExpr);
	void __fastcall FreeFilter(Dbcommon::TExprParser* &AFilterParser);
	void __fastcall DrawAutoInc(void);
	void __fastcall PostAutoInc(void);
	AnsiString __fastcall GetVersion();
	void __fastcall SetIndexFieldNames(AnsiString FieldNames);
	void __fastcall SetIndexName(AnsiString IndexName);
	void __fastcall SetIndexDefs(Db::TIndexDefs* Value);
	void __fastcall SetCommaText(AnsiString AString);
	AnsiString __fastcall GetCommaText();
	TkbmIndex* __fastcall GetIndexByName(AnsiString IndexName);
	Db::TField* __fastcall GetIndexField(int Index);
	void __fastcall SetIndexField(int Index, Db::TField* Value);
	void __fastcall SetAttachedTo(TkbmCustomMemTable* Value);
	void __fastcall SetRecordTag(int Value);
	int __fastcall GetRecordTag(void);
	bool __fastcall GetIsVersioning(void);
	void __fastcall SetStatusFilter(const Db::TUpdateStatusSet Value);
	void __fastcall SetDeltaHandler(TkbmCustomDeltaHandler* AHandler);
	void __fastcall SetAllData(const Variant &AVariant);
	Variant __fastcall GetAllData();
	int __fastcall GetAutoIncValue(void);
	int __fastcall GetAutoIncMin(void);
	void __fastcall SetAutoIncMinValue(int AValue);
	void __fastcall SetAutoUpdateFieldVariables(bool AValue);
	TkbmPerformance __fastcall GetPerformance(void);
	void __fastcall SetPerformance(TkbmPerformance AValue);
	TkbmVersioningMode __fastcall GetVersioningMode(void);
	void __fastcall SetVersioningMode(TkbmVersioningMode AValue);
	bool __fastcall GetEnableVersioning(void);
	void __fastcall SetEnableVersioning(bool AValue);
	bool __fastcall GetStandalone(void);
	void __fastcall SetStandalone(bool AValue);
	int __fastcall GetCapacity(void);
	void __fastcall SetCapacity(int AValue);
	bool __fastcall GetIsDataModified(void);
	void __fastcall SetIsDataModified(bool AValue);
	int __fastcall GetAttachMaxCount(void);
	void __fastcall SetAttachMaxCount(int AValue);
	int __fastcall GetAttachCount(void);
	void __fastcall SwitchToIndex(TkbmIndex* Index);
	bool __fastcall GetModifiedFlags(int i);
	TkbmIndexes* __fastcall GetIndexes(void);
	int __fastcall GetTransactionLevel(void);
	int __fastcall GetDeletedRecordsCount(void);
	int __fastcall GetLanguageID(void);
	void __fastcall SetLanguageID(int Value);
	int __fastcall GetSortID(void);
	void __fastcall SetSortID(int Value);
	int __fastcall GetSubLanguageID(void);
	void __fastcall SetSubLanguageID(int Value);
	int __fastcall GetLocaleID(void);
	void __fastcall SetLocaleID(int Value);
	virtual void __fastcall SetActive(bool Value);
	void __fastcall DoCheckInActive(void);
	virtual void __fastcall InternalOpen(void);
	virtual void __fastcall InternalClose(void);
	virtual void __fastcall InternalFirst(void);
	virtual void __fastcall InternalLast(void);
	virtual void __fastcall InternalAddRecord(void * Buffer, bool Append);
	virtual void __fastcall InternalDelete(void);
	virtual void __fastcall InternalInitRecord(char * Buffer);
	virtual void __fastcall InternalPost(void);
	virtual void __fastcall InternalCancel(void);
	virtual void __fastcall InternalEdit(void);
	virtual void __fastcall InternalInsert(void);
	virtual void __fastcall InternalInitFieldDefs(void);
	virtual void __fastcall InternalSetToRecord(char * Buffer);
	virtual void __fastcall CheckActive(void);
	virtual void __fastcall CheckInactive(void);
	virtual void __fastcall DoBeforeClose(void);
	virtual void __fastcall DoBeforeOpen(void);
	virtual void __fastcall DoAfterOpen(void);
	virtual void __fastcall DoAfterPost(void);
	virtual void __fastcall DoAfterDelete(void);
	virtual void __fastcall DoOnNewRecord(void);
	virtual void __fastcall DoBeforePost(void);
	virtual void __fastcall DoOnFilterRecord(Db::TDataSet* ADataset, bool &AFiltered);
	virtual bool __fastcall IsCursorOpen(void);
	virtual bool __fastcall GetCanModify(void);
	virtual Word __fastcall GetRecordSize(void);
	virtual int __fastcall GetRecordCount(void);
	virtual char * __fastcall AllocRecordBuffer(void);
	virtual void __fastcall FreeRecordBuffer(char * &Buffer);
	virtual void __fastcall CloseBlob(Db::TField* Field);
	virtual void __fastcall SetFieldData(Db::TField* Field, void * Buffer)/* overload */;
	virtual Db::TGetResult __fastcall GetRecord(char * Buffer, Db::TGetMode GetMode, bool DoCheck);
	virtual bool __fastcall FindRecord(bool Restart, bool GoForward);
	virtual int __fastcall GetRecNo(void);
	virtual void __fastcall SetRecNo(int Value);
	virtual bool __fastcall GetIsIndexField(Db::TField* Field);
	virtual Db::TBookmarkFlag __fastcall GetBookmarkFlag(char * Buffer);
	virtual void __fastcall SetBookmarkFlag(char * Buffer, Db::TBookmarkFlag Value);
	virtual void __fastcall GetBookmarkData(char * Buffer, void * Data);
	virtual void __fastcall SetBookmarkData(char * Buffer, void * Data);
	virtual void __fastcall InternalGotoBookmark(void * Bookmark);
	virtual void __fastcall InternalHandleException(void);
	virtual Db::TDataSource* __fastcall GetDataSource(void);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation);
	virtual void __fastcall SetFiltered(bool Value);
	virtual void __fastcall SetFilterText(const AnsiString Value);
	void __fastcall SetLoadedCompletely(bool Value);
	void __fastcall SetTableState(TkbmState AValue);
	void __fastcall CreateFieldDefs(void);
	virtual void __fastcall SetOnFilterRecord(const Db::TFilterRecordEvent Value);
	virtual void __fastcall DataEvent(Db::TDataEvent Event, int Info);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall DefineProperties(Classes::TFiler* Filer);
	void __fastcall ReadData(Classes::TStream* Stream);
	void __fastcall WriteData(Classes::TStream* Stream);
	void __fastcall InternalEmptyTable(void);
	void __fastcall PopulateField(PkbmRecord ARecord, Db::TField* Field, const Variant &AValue);
	void __fastcall PopulateRecord(PkbmRecord ARecord, AnsiString Fields, const Variant &Values);
	void __fastcall PopulateVarLength(PkbmRecord ARecord, Db::TField* Field, const void *Buffer, int Size);
	bool __fastcall InternalBookmarkValid(void * Bookmark);
	void __fastcall PrepareKeyRecord(int KeyRecordType, bool Clear);
	bool __fastcall FilterRange(PkbmRecord ARecord);
	bool __fastcall FilterMasterDetail(PkbmRecord ARecord);
	bool __fastcall FilterExpression(PkbmRecord ARecord, Dbcommon::TExprParser* AFilterParser);
	virtual void __fastcall MasterChanged(System::TObject* Sender);
	virtual void __fastcall MasterDisabled(System::TObject* Sender);
	virtual void __fastcall InternalSaveToStreamViaFormat(Classes::TStream* AStream, TkbmCustomStreamFormat* AFormat);
	virtual void __fastcall InternalLoadFromStreamViaFormat(Classes::TStream* AStream, TkbmCustomStreamFormat* AFormat);
	int __fastcall UpdateRecords(Db::TDataSet* Source, Db::TDataSet* Destination, AnsiString KeyFields, int Count, TkbmMemTableUpdateFlags Flags);
	int __fastcall LocateRecord(const AnsiString KeyFields, const Variant &KeyValues, Db::TLocateOptions Options);
	bool __fastcall CheckAutoInc(void);
	
public:
	int __fastcall __CalcFieldsSize(void);
	void __fastcall __ClearBuffers(void);
	void __fastcall __ClearCalcFields(char * Buffer);
	void __fastcall __GetCalcFields(char * Buffer);
	void __fastcall __SetBlockReadSize(int Value);
	Db::TDataSetState __fastcall __SetTempState(const Db::TDataSetState Value);
	void __fastcall __RestoreState(const Db::TDataSetState Value);
	__fastcall virtual TkbmCustomMemTable(Classes::TComponent* AOwner);
	__fastcall virtual ~TkbmCustomMemTable(void);
	virtual bool __fastcall BookmarkValid(void * Bookmark);
	virtual int __fastcall CompareBookmarks(void * Bookmark1, void * Bookmark2);
	virtual bool __fastcall GetFieldData(Db::TField* Field, void * Buffer)/* overload */;
	virtual void __fastcall SetBlockReadSize(int Value);
	virtual Db::TUpdateStatus __fastcall UpdateStatus(void);
	virtual Classes::TStream* __fastcall CreateBlobStream(Db::TField* Field, Db::TBlobStreamMode Mode);
	virtual bool __fastcall IsSequenced(void);
	void __fastcall SavePersistent(void);
	void __fastcall LoadPersistent(void);
	void __fastcall BuildFieldList(Db::TDataSet* Dataset, TkbmFieldList* List, const AnsiString FieldNames);
	Db::TField* __fastcall FindFieldInList(TkbmFieldList* List, AnsiString FieldName);
	bool __fastcall IsFieldListsEqual(TkbmFieldList* List1, TkbmFieldList* List2);
	bool __fastcall IsFieldListsBegin(TkbmFieldList* List1, TkbmFieldList* List2);
	void __fastcall SetFieldListOptions(TkbmFieldList* AList, TkbmifoOption AOptions, AnsiString AFieldNames);
	void __fastcall ClearModified(void);
	void __fastcall DestroyIndexes(void);
	void __fastcall CreateIndexes(void);
	bool __fastcall FilterRecord(PkbmRecord ARecord, bool ForceUseFilter);
	Db::TField* __fastcall CreateFieldAs(Db::TField* Field);
	bool __fastcall MoveRecord(int Source, int Destination);
	bool __fastcall MoveCurRecord(int Destination);
	Variant __fastcall GetVersionFieldData(Db::TField* Field, int Version);
	Db::TUpdateStatus __fastcall GetVersionStatus(int Version);
	int __fastcall GetVersionCount(void);
	Variant __fastcall SetVersionFieldData(Db::TField* Field, int AVersion, const Variant &AValue);
	Db::TUpdateStatus __fastcall SetVersionStatus(int AVersion, Db::TUpdateStatus AUpdateStatus);
	void __fastcall ResetAutoInc(void);
	virtual void __fastcall Progress(int Pct, TkbmProgressCode Code);
	virtual int __fastcall CopyRecords(Db::TDataSet* Source, Db::TDataSet* Destination, int Count, bool IgnoreErrors, bool WideStringAsUTF8);
	void __fastcall AssignRecord(Db::TDataSet* Source, Db::TDataSet* Destination);
	virtual void __fastcall Lock(void);
	virtual void __fastcall Unlock(void);
	void __fastcall UpdateFieldVariables(void);
	void __fastcall CopyFieldProperties(Db::TField* Source, Db::TField* Destination);
	void __fastcall CopyFieldsProperties(Db::TDataSet* Source, Db::TDataSet* Destination);
	bool __fastcall Exists(void);
	void __fastcall CreateTable(void);
	void __fastcall EmptyTable(void);
	void __fastcall CreateTableAs(Db::TDataSet* Source, TkbmMemTableCopyTableOptions CopyOptions);
	void __fastcall DeleteTable(void);
	void __fastcall PackTable(void);
	TkbmIndex* __fastcall AddIndex(const AnsiString Name, const AnsiString Fields, Db::TIndexOptions Options)/* overload */;
	TkbmIndex* __fastcall AddIndex(const AnsiString Name, const AnsiString Fields, Db::TIndexOptions Options, Db::TUpdateStatusSet AUpdateStatus)/* overload */;
	TkbmIndex* __fastcall AddFilteredIndex(const AnsiString Name, const AnsiString Fields, Db::TIndexOptions Options, AnsiString Filter, Db::TFilterOptions FilterOptions, TkbmOnFilterIndex FilterFunc = 0x0)/* overload */;
	TkbmIndex* __fastcall AddFilteredIndex(const AnsiString Name, const AnsiString Fields, Db::TIndexOptions Options, Db::TUpdateStatusSet AUpdateStatus, AnsiString Filter, Db::TFilterOptions FilterOptions, TkbmOnFilterIndex FilterFunc = 0x0)/* overload */;
	void __fastcall DeleteIndex(const AnsiString Name);
	void __fastcall UpdateIndexes(void);
	int __fastcall IndexFieldCount(void);
	virtual void __fastcall StartTransaction(void);
	virtual void __fastcall Commit(void);
	virtual void __fastcall Rollback(void);
	bool __fastcall TestFilter(const AnsiString AFilter, Db::TFilterOptions AFilterOptions);
	void __fastcall Undo(void);
	void __fastcall LoadFromFile(const AnsiString FileName);
	void __fastcall LoadFromStream(Classes::TStream* Stream);
	void __fastcall LoadFromFileViaFormat(const AnsiString FileName, TkbmCustomStreamFormat* AFormat);
	void __fastcall LoadFromStreamViaFormat(Classes::TStream* Stream, TkbmCustomStreamFormat* AFormat);
	void __fastcall SaveToFile(const AnsiString FileName);
	void __fastcall SaveToStream(Classes::TStream* Stream);
	void __fastcall SaveToFileViaFormat(const AnsiString FileName, TkbmCustomStreamFormat* AFormat);
	void __fastcall SaveToStreamViaFormat(Classes::TStream* Stream, TkbmCustomStreamFormat* AFormat);
	virtual void __fastcall LoadFromDataSet(Db::TDataSet* Source, TkbmMemTableCopyTableOptions CopyOptions);
	virtual void __fastcall SaveToDataSet(Db::TDataSet* Destination, TkbmMemTableCopyTableOptions CopyOptions = TkbmMemTableCopyTableOptions() );
	virtual void __fastcall UpdateToDataSet(Db::TDataSet* Destination, AnsiString KeyFields, TkbmMemTableUpdateFlags Flags)/* overload */;
	virtual void __fastcall UpdateToDataSet(Db::TDataSet* Destination, AnsiString KeyFields)/* overload */;
	void __fastcall SortDefault(void);
	void __fastcall Sort(TkbmMemTableCompareOptions Options);
	void __fastcall SortOn(const AnsiString FieldNames, TkbmMemTableCompareOptions Options);
	virtual Variant __fastcall Lookup(const AnsiString KeyFields, const Variant &KeyValues, const AnsiString ResultFields);
	Variant __fastcall LookupByIndex(const AnsiString IndexName, const Variant &KeyValues, const AnsiString ResultFields, bool RespFilter);
	virtual bool __fastcall Locate(const AnsiString KeyFields, const Variant &KeyValues, Db::TLocateOptions Options);
	void __fastcall SetKey(void);
	void __fastcall EditKey(void);
	bool __fastcall GotoNearest(void);
	bool __fastcall GotoKey(void);
	bool __fastcall FindKey(System::TVarRec const * KeyValues, const int KeyValues_Size);
	bool __fastcall FindNearest(System::TVarRec const * KeyValues, const int KeyValues_Size);
	void __fastcall ApplyRange(void);
	void __fastcall CancelRange(void);
	void __fastcall SetRange(System::TVarRec const * StartValues, const int StartValues_Size, System::TVarRec const * EndValues, const int EndValues_Size);
	void __fastcall SetRangeStart(void);
	void __fastcall SetRangeEnd(void);
	void __fastcall EditRangeStart(void);
	void __fastcall EditRangeEnd(void);
	void __fastcall CheckPoint(void);
	Db::TUpdateStatus __fastcall CheckPointRecord(int RecordIndex);
	Variant __fastcall GetRows(int Rows, const Variant &Start, const Variant &Fields);
	void __fastcall Reset(void);
	virtual void __fastcall GotoCurrent(TkbmCustomMemTable* DataSet);
	__property PkbmRecord OverrideActiveRecordBuffer = {read=FOverrideActiveRecordBuffer, write=FOverrideActiveRecordBuffer};
	__property bool PersistentSaved = {read=FPersistentSaved, write=FPersistentSaved, stored=false, nodefault};
	__property TkbmCustomMemTable* AttachedTo = {read=FAttachedTo, write=SetAttachedTo};
	__property bool AttachedAutoRefresh = {read=FAttachedAutoRefresh, write=FAttachedAutoRefresh, nodefault};
	__property TkbmPerformance Performance = {read=GetPerformance, write=SetPerformance, default=0};
	__property Filtered  = {default=0};
	__property Filter ;
	__property TkbmIndex* CurIndex = {read=FCurIndex};
	__property bool IgnoreAutoIncPopulation = {read=FIgnoreAutoIncPopulation, write=FIgnoreAutoIncPopulation, nodefault};
	__property int AttachMaxCount = {read=GetAttachMaxCount, write=SetAttachMaxCount, nodefault};
	__property int AttachCount = {read=GetAttachCount, nodefault};
	__property bool DesignActivation = {read=FDesignActivation, write=FDesignActivation, nodefault};
	__property int LanguageID = {read=GetLanguageID, write=SetLanguageID, nodefault};
	__property int SortID = {read=GetSortID, write=SetSortID, nodefault};
	__property int SubLanguageID = {read=GetSubLanguageID, write=SetSubLanguageID, nodefault};
	__property int LocaleID = {read=GetLocaleID, write=SetLocaleID, nodefault};
	__property TkbmCommon* Common = {read=FCommon};
	__property int AutoIncValue = {read=GetAutoIncValue, nodefault};
	__property int AutoIncMinValue = {read=GetAutoIncMin, write=SetAutoIncMinValue, default=0};
	__property bool AutoUpdateFieldVariables = {read=FAutoUpdateFieldVariables, write=SetAutoUpdateFieldVariables, nodefault};
	__property Variant AllData = {read=GetAllData, write=SetAllData};
	__property bool StoreDataOnForm = {read=FStoreDataOnForm, write=FStoreDataOnForm, default=0};
	__property AnsiString CommaText = {read=GetCommaText, write=SetCommaText};
	__property int Capacity = {read=GetCapacity, write=SetCapacity, nodefault};
	__property int DeletedRecordsCount = {read=GetDeletedRecordsCount, nodefault};
	__property AnsiString IndexFieldNames = {read=FIndexFieldNames, write=SetIndexFieldNames};
	__property AnsiString IndexName = {read=FIndexName, write=SetIndexName};
	__property bool EnableIndexes = {read=FEnableIndexes, write=FEnableIndexes, default=1};
	__property bool AutoAddIndexes = {read=FAutoAddIndexes, write=FAutoAddIndexes, default=0};
	__property bool AutoReposition = {read=FAutoReposition, write=FAutoReposition, default=0};
	__property AnsiString SortFields = {read=FSortFieldNames, write=FSortFieldNames};
	__property TkbmMemTableCompareOptions SortOptions = {read=FSortOptions, write=FSortOptions, nodefault};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, default=0};
	__property bool Standalone = {read=GetStandalone, write=SetStandalone, default=0};
	__property bool IgnoreReadOnly = {read=FIgnoreReadOnly, write=FIgnoreReadOnly, default=0};
	__property bool RangeActive = {read=FRangeActive, nodefault};
	__property bool RangeIgnoreNullKeyValues = {read=FRangeIgnoreNullKeyValues, write=FRangeIgnoreNullKeyValues, default=1};
	__property AnsiString PersistentFile = {read=FPersistentFile, write=FPersistentFile};
	__property bool Persistent = {read=FPersistent, write=FPersistent, default=0};
	__property bool PersistentBackup = {read=FPersistentBackup, write=FPersistentBackup, nodefault};
	__property AnsiString PersistentBackupExt = {read=FPersistentBackupExt, write=FPersistentBackupExt};
	__property TkbmProgressCodes ProgressFlags = {read=FProgressFlags, write=FProgressFlags, nodefault};
	__property int LoadLimit = {read=FLoadLimit, write=FLoadLimit, default=-1};
	__property int LoadCount = {read=FLoadCount, write=FLoadCount, nodefault};
	__property bool LoadedCompletely = {read=FLoadedCompletely, write=FLoadedCompletely, nodefault};
	__property int SaveLimit = {read=FSaveLimit, write=FSaveLimit, default=-1};
	__property int SaveCount = {read=FSaveCount, write=FSaveCount, nodefault};
	__property bool SavedCompletely = {read=FSavedCompletely, write=FSavedCompletely, nodefault};
	__property bool RecalcOnFetch = {read=FRecalcOnFetch, write=FRecalcOnFetch, default=1};
	__property bool IsFieldModified[int i] = {read=GetModifiedFlags};
	__property bool EnableVersioning = {read=GetEnableVersioning, write=SetEnableVersioning, default=0};
	__property TkbmVersioningMode VersioningMode = {read=GetVersioningMode, write=SetVersioningMode, default=0};
	__property bool IsVersioning = {read=GetIsVersioning, nodefault};
	__property Db::TUpdateStatusSet StatusFilter = {read=FStatusFilter, write=SetStatusFilter, nodefault};
	__property TkbmCustomDeltaHandler* DeltaHandler = {read=FDeltaHandler, write=SetDeltaHandler};
	__property TkbmIndexes* Indexes = {read=GetIndexes};
	__property TkbmIndex* IndexByName[AnsiString IndexName] = {read=GetIndexByName};
	__property Db::TIndexDefs* IndexDefs = {read=FIndexDefs, write=SetIndexDefs};
	__property Db::TField* IndexFields[int Index] = {read=GetIndexField, write=SetIndexField};
	__property bool RecalcOnIndex = {read=FRecalcOnIndex, write=FRecalcOnIndex, default=0};
	__property Db::TFilterOptions FilterOptions = {read=FFilterOptions, write=FFilterOptions, nodefault};
	__property AnsiString DetailFields = {read=FDetailFieldNames, write=SetDetailFields};
	__property AnsiString MasterFields = {read=GetMasterFields, write=SetMasterFields};
	__property Db::TDataSource* MasterSource = {read=GetDataSource, write=SetDataSource};
	__property int RecordTag = {read=GetRecordTag, write=SetRecordTag, nodefault};
	__property AnsiString Version = {read=GetVersion, write=FDummyStr};
	__property bool IsDataModified = {read=GetIsDataModified, write=SetIsDataModified, nodefault};
	__property int TransactionLevel = {read=GetTransactionLevel, nodefault};
	__property TkbmState TableState = {read=FState, write=FState, nodefault};
	__property TkbmCustomStreamFormat* DefaultFormat = {read=FDefaultFormat, write=FDefaultFormat};
	__property TkbmCustomStreamFormat* CommaTextFormat = {read=FCommaTextFormat, write=FCommaTextFormat};
	__property TkbmCustomStreamFormat* PersistentFormat = {read=FPersistentFormat, write=FPersistentFormat};
	__property TkbmCustomStreamFormat* FormFormat = {read=FFormFormat, write=FFormFormat};
	__property TkbmCustomStreamFormat* AllDataFormat = {read=FAllDataFormat, write=FAllDataFormat};
	__property TkbmOnLoadRecord OnLoadRecord = {read=FOnLoadRecord, write=FOnLoadRecord};
	__property TkbmOnLoadField OnLoadField = {read=FOnLoadField, write=FOnLoadField};
	__property TkbmOnSaveRecord OnSaveRecord = {read=FOnSaveRecord, write=FOnSaveRecord};
	__property TkbmOnSaveField OnSaveField = {read=FOnSaveField, write=FOnSaveField};
	__property TkbmOnCompress OnCompressBlobStream = {read=FOnCompressBlobStream, write=FOnCompressBlobStream};
	__property TkbmOnDeCompress OnDecompressBlobStream = {read=FOnDecompressBlobStream, write=FOnDecompressBlobStream};
	__property TkbmOnSetupField OnSetupField = {read=FOnSetupField, write=FOnSetupField};
	__property TkbmOnSetupFieldProperties OnSetupFieldProperties = {read=FOnSetupFieldProperties, write=FOnSetupFieldProperties};
	__property TkbmOnCompressField OnCompressField = {read=FOnCompressField, write=FOnCompressField};
	__property TkbmOnDecompressField OnDecompressField = {read=FOnDecompressField, write=FOnDecompressField};
	__property TkbmOnSave OnSave = {read=FOnSave, write=FOnSave};
	__property TkbmOnLoad OnLoad = {read=FOnLoad, write=FOnLoad};
	__property TkbmOnProgress OnProgress = {read=FOnProgress, write=FOnProgress};
	__property TkbmOnCompareFields OnCompareFields = {read=FOnCompareFields, write=FOnCompareFields};
	__property TkbmOnFilterIndex OnFilterIndex = {read=FOnFilterIndex, write=FOnFilterIndex};
	__property BeforeOpen ;
	__property AfterOpen ;
	__property BeforeClose ;
	__property AfterClose ;
	__property Db::TDataSetNotifyEvent BeforeInsert = {read=FBeforeInsert, write=FBeforeInsert};
	__property AfterInsert ;
	__property BeforeEdit ;
	__property AfterEdit ;
	__property BeforePost ;
	__property AfterPost ;
	__property BeforeCancel ;
	__property AfterCancel ;
	__property BeforeDelete ;
	__property AfterDelete ;
	__property BeforeScroll ;
	__property AfterScroll ;
	__property OnCalcFields ;
	__property OnDeleteError ;
	__property OnEditError ;
	__property OnFilterRecord ;
	__property OnNewRecord ;
	__property OnPostError ;
	__property Active  = {default=0};
	
/* Hoisted overloads: */
	
protected:
	inline void __fastcall  SetFieldData(Db::TField* Field, void * Buffer, bool NativeFormat){ TDataSet::SetFieldData(Field, Buffer, NativeFormat); }
	
public:
	inline bool __fastcall  GetFieldData(int FieldNo, void * Buffer){ return TDataSet::GetFieldData(FieldNo, Buffer); }
	inline bool __fastcall  GetFieldData(Db::TField* Field, void * Buffer, bool NativeFormat){ return TDataSet::GetFieldData(Field, Buffer, NativeFormat); }
	
};


class PASCALIMPLEMENTATION TkbmIndex : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	AnsiString FName;
	Classes::TList* FReferences;
	TkbmCustomMemTable* FDataSet;
	AnsiString FIndexFields;
	TkbmFieldList* FIndexFieldList;
	TkbmMemTableCompareOptions FIndexOptions;
	bool FOrdered;
	TkbmIndexType FType;
	bool FRowOrder;
	bool FInternal;
	int FIndexOfs;
	bool FIsView;
	bool FIsFiltered;
	bool FEnabled;
	Db::TUpdateStatusSet FUpdateStatus;
	Dbcommon::TExprParser* FFilterParser;
	TkbmOnFilterIndex FFilterFunc;
	void __fastcall InternalSwap(const int I, const int J);
	void __fastcall InternalInsertionSort(const int Lo, const int Hi);
	void __fastcall InternalFastQuickSort(const int L, const int R);
	void __fastcall SetEnabled(bool AValue);
	
protected:
	int __fastcall CompareRecords(const TkbmFieldList* AFieldList, const PkbmRecord KeyRecord, const PkbmRecord ARecord, const bool SortCompare, const bool Partial);
	void __fastcall FastQuickSort(const int L, const int R);
	int __fastcall BinarySearchRecordID(int FirstNo, int LastNo, const int RecordID, const bool Desc, int &Index);
	int __fastcall SequentialSearchRecordID(const int FirstNo, const int LastNo, const int RecordID, int &Index);
	int __fastcall BinarySearch(TkbmFieldList* FieldList, int FirstNo, int LastNo, const PkbmRecord KeyRecord, const bool First, const bool Nearest, const bool RespectFilter, int &Index, bool &Found);
	int __fastcall SequentialSearch(TkbmFieldList* FieldList, const int FirstNo, const int LastNo, const PkbmRecord KeyRecord, const bool Nearest, const bool RespectFilter, int &Index, bool &Found);
	int __fastcall FindRecordNumber(const char * RecordBuffer);
	bool __fastcall Filter(const PkbmRecord ARecord);
	
public:
	__fastcall TkbmIndex(AnsiString Name, TkbmCustomMemTable* DataSet, AnsiString Fields, TkbmMemTableCompareOptions Options, TkbmIndexType IndexType, bool Internal)/* overload */;
	__fastcall TkbmIndex(Db::TIndexDef* IndexDef, TkbmCustomMemTable* DataSet)/* overload */;
	__fastcall virtual ~TkbmIndex(void);
	int __fastcall Search(TkbmFieldList* FieldList, PkbmRecord KeyRecord, bool Nearest, bool RespectFilter, int &Index, bool &Found);
	int __fastcall SearchRecord(PkbmRecord KeyRecord, int &Index, bool RespectFilter);
	int __fastcall SearchRecordID(int RecordID, int &Index);
	void __fastcall Clear(void);
	void __fastcall LoadAll(void);
	void __fastcall ReSort(void);
	void __fastcall Rebuild(void);
	__property bool Enabled = {read=FEnabled, write=SetEnabled, nodefault};
	__property bool IsView = {read=FIsView, write=FIsView, nodefault};
	__property bool IsOrdered = {read=FOrdered, write=FOrdered, nodefault};
	__property bool IsFiltered = {read=FIsFiltered, write=FIsFiltered, nodefault};
	__property TkbmIndexType IndexType = {read=FType, write=FType, nodefault};
	__property TkbmMemTableCompareOptions IndexOptions = {read=FIndexOptions, write=FIndexOptions, nodefault};
	__property AnsiString IndexFields = {read=FIndexFields, write=FIndexFields};
	__property TkbmFieldList* IndexFieldList = {read=FIndexFieldList, write=FIndexFieldList};
	__property TkbmCustomMemTable* Dataset = {read=FDataSet, write=FDataSet};
	__property AnsiString Name = {read=FName, write=FName};
	__property Classes::TList* References = {read=FReferences, write=FReferences};
	__property bool IsRowOrder = {read=FRowOrder, write=FRowOrder, nodefault};
	__property bool IsInternal = {read=FInternal, write=FInternal, nodefault};
	__property int IndexOfs = {read=FIndexOfs, write=FIndexOfs, nodefault};
	__property Db::TUpdateStatusSet UpdateStatus = {read=FUpdateStatus, write=FUpdateStatus, nodefault};
};


typedef int TkbmLocaleID;

typedef DynamicArray<int >  kbmMemTable__31;

class DELPHICLASS TkbmStreamFormat;
class PASCALIMPLEMENTATION TkbmStreamFormat : public TkbmCustomStreamFormat 
{
	typedef TkbmCustomStreamFormat inherited;
	
__published:
	__property sfData ;
	__property sfCalculated ;
	__property sfLookup ;
	__property sfNonVisible ;
	__property sfBlobs ;
	__property sfDef ;
	__property sfIndexDef ;
	__property sfFiltered ;
	__property sfIgnoreRange ;
	__property sfIgnoreMasterDetail ;
	__property sfDeltas ;
	__property sfDontFilterDeltas ;
	__property sfAppend ;
	__property sfFieldKind ;
	__property sfFromStart ;
	__property Version ;
	__property OnBeforeLoad ;
	__property OnAfterLoad ;
	__property OnBeforeSave ;
	__property OnAfterSave ;
	__property OnCompress ;
	__property OnDeCompress ;
public:
	#pragma option push -w-inl
	/* TkbmCustomStreamFormat.Create */ inline __fastcall virtual TkbmStreamFormat(Classes::TComponent* AOwner) : TkbmCustomStreamFormat(AOwner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TkbmStreamFormat(void) { }
	#pragma option pop
	
};


class DELPHICLASS TkbmMemTable;
class PASCALIMPLEMENTATION TkbmMemTable : public TkbmCustomMemTable 
{
	typedef TkbmCustomMemTable inherited;
	
public:
	__property IgnoreReadOnly  = {default=0};
	
__published:
	__property Active  = {default=0};
	__property DesignActivation ;
	__property AttachedTo ;
	__property AttachedAutoRefresh ;
	__property AttachMaxCount ;
	__property AutoIncMinValue  = {default=0};
	__property AutoCalcFields  = {default=1};
	__property FieldDefs ;
	__property Filtered  = {default=0};
	__property DeltaHandler ;
	__property EnableIndexes  = {default=1};
	__property AutoAddIndexes  = {default=0};
	__property AutoReposition  = {default=0};
	__property IndexFieldNames ;
	__property IndexName ;
	__property IndexDefs ;
	__property RecalcOnIndex  = {default=0};
	__property RecalcOnFetch  = {default=1};
	__property SortFields ;
	__property SortOptions ;
	__property ReadOnly  = {default=0};
	__property Performance  = {default=0};
	__property Standalone  = {default=0};
	__property PersistentFile ;
	__property StoreDataOnForm  = {default=0};
	__property Persistent  = {default=0};
	__property PersistentBackup ;
	__property PersistentBackupExt ;
	__property ProgressFlags ;
	__property LoadLimit  = {default=-1};
	__property LoadedCompletely ;
	__property SaveLimit  = {default=-1};
	__property SavedCompletely ;
	__property EnableVersioning  = {default=0};
	__property VersioningMode  = {default=0};
	__property Filter ;
	__property FilterOptions ;
	__property MasterFields ;
	__property DetailFields ;
	__property MasterSource ;
	__property Version ;
	__property LanguageID ;
	__property SortID ;
	__property SubLanguageID ;
	__property LocaleID ;
	__property DefaultFormat ;
	__property CommaTextFormat ;
	__property PersistentFormat ;
	__property AllDataFormat ;
	__property FormFormat ;
	__property RangeIgnoreNullKeyValues  = {default=1};
	__property OnProgress ;
	__property OnLoadRecord ;
	__property OnLoadField ;
	__property OnSaveRecord ;
	__property OnSaveField ;
	__property OnCompressBlobStream ;
	__property OnDecompressBlobStream ;
	__property OnSetupField ;
	__property OnSetupFieldProperties ;
	__property OnCompressField ;
	__property OnDecompressField ;
	__property OnSave ;
	__property OnLoad ;
	__property OnCompareFields ;
	__property OnFilterIndex ;
	__property BeforeOpen ;
	__property AfterOpen ;
	__property BeforeClose ;
	__property AfterClose ;
	__property BeforeInsert ;
	__property AfterInsert ;
	__property BeforeEdit ;
	__property AfterEdit ;
	__property BeforePost ;
	__property AfterPost ;
	__property BeforeCancel ;
	__property AfterCancel ;
	__property BeforeDelete ;
	__property AfterDelete ;
	__property BeforeScroll ;
	__property AfterScroll ;
	__property BeforeRefresh ;
	__property AfterRefresh ;
	__property OnCalcFields ;
	__property OnDeleteError ;
	__property OnEditError ;
	__property OnFilterRecord ;
	__property OnNewRecord ;
	__property OnPostError ;
public:
	#pragma option push -w-inl
	/* TkbmCustomMemTable.Create */ inline __fastcall virtual TkbmMemTable(Classes::TComponent* AOwner) : TkbmCustomMemTable(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TkbmCustomMemTable.Destroy */ inline __fastcall virtual ~TkbmMemTable(void) { }
	#pragma option pop
	
};


class DELPHICLASS TkbmBlobStream;
class PASCALIMPLEMENTATION TkbmBlobStream : public Classes::TMemoryStream 
{
	typedef Classes::TMemoryStream inherited;
	
private:
	TkbmRecord *FWorkBuffer;
	TkbmRecord *FTableRecord;
	Db::TBlobField* FField;
	TkbmCustomMemTable* FDataSet;
	Db::TBlobStreamMode FMode;
	int FFieldNo;
	bool FModified;
	char *FpWorkBufferField;
	char *FpTableRecordField;
	char * *FpWorkBufferBlob;
	char * *FpTableRecordBlob;
	void __fastcall ReadBlobData(void);
	void __fastcall WriteBlobData(void);
	
public:
	__fastcall TkbmBlobStream(Db::TBlobField* Field, Db::TBlobStreamMode Mode);
	__fastcall virtual ~TkbmBlobStream(void);
	virtual int __fastcall Write(const void *Buffer, int Count);
	void __fastcall Truncate(void);
};


class DELPHICLASS TkbmThreadDataSet;
class PASCALIMPLEMENTATION TkbmThreadDataSet : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	Db::TDataSet* FDataset;
	int FLockCount;
	unsigned FSemaphore;
	bool __fastcall GetIsLocked(void);
	void __fastcall SetDataset(Db::TDataSet* ds);
	
protected:
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation);
	
public:
	__fastcall virtual TkbmThreadDataSet(Classes::TComponent* AOwner);
	__fastcall virtual ~TkbmThreadDataSet(void);
	Db::TDataSet* __fastcall TryLock(unsigned TimeOut);
	Db::TDataSet* __fastcall Lock(void);
	void __fastcall Unlock(void);
	__property bool IsLocked = {read=GetIsLocked, nodefault};
	
__published:
	__property Db::TDataSet* Dataset = {read=FDataset, write=SetDataset};
};


typedef AnsiString kbmMemTable__12[5];

//-- var, const, procedure ---------------------------------------------------
#define COMPONENT_VERSION "5.51"
static const Word KBM_MAX_FIELDS = 0x100;
static const Shortint kbmkbMin = 0x0;
static const Shortint kbmkbKey = 0x0;
static const Shortint kbmkbRangeStart = 0x1;
static const Shortint kbmkbRangeEnd = 0x2;
static const Shortint kbmkbMasterDetail = 0x3;
static const Shortint kbmkbMax = 0x3;
static const Shortint kbmffIndirect = 0x1;
static const Shortint kbmffCompress = 0x2;
static const Shortint kbmffModified = 0x4;
static const int kbmRecordIdent = 0x6a1b2c3e;
static const Shortint kbmBookmarkCurrent = 0x0;
static const Shortint kbmBookmarkFirst = 0x1;
static const Shortint kbmBookmarkLast = 0x2;
static const unsigned kbmGetRowsRest = 0xffffffff;
static const char kbmffNull = '\x0';
static const char kbmffUnknown = '\x1';
static const char kbmffData = '\x2';
#define kbmRowOrderIndex "__MT__ROWORDER"
#define kbmDefSortIndex "__MT__DEFSORT"
#define kbmAutoIndex "__MT__AUTO_"
static const Shortint kbmrfInTable = 0x1;
static const Shortint kbmrfDontCheckPoint = 0x2;
extern PACKAGE TkbmFieldTypes kbmSupportedFieldTypes;
extern PACKAGE TkbmFieldTypes kbmStringTypes;
extern PACKAGE TkbmFieldTypes kbmBinaryTypes;
extern PACKAGE TkbmFieldTypes kbmBlobTypes;
extern PACKAGE TkbmFieldTypes kbmNonBlobTypes;
extern PACKAGE TkbmFieldTypes kbmVarLengthNonBlobTypes;
#define NullVarLength (char *)(0x0)
extern PACKAGE AnsiString FieldKindNames[5];
extern PACKAGE Variant __fastcall StreamToVariant(Classes::TStream* stream);
extern PACKAGE void __fastcall VariantToStream(const Variant &AVariant, Classes::TStream* stream);
extern PACKAGE int __fastcall CompareFields(const void * KeyField, const void * AField, const Db::TFieldType FieldType, const int LocaleID, const TkbmifoOptions IndexFieldOptions, bool &FullCompare);
extern PACKAGE TkbmMemTableCompareOptions __fastcall IndexOptions2CompareOptions(Db::TIndexOptions AOptions);
extern PACKAGE Db::TIndexOptions __fastcall CompareOptions2IndexOptions(TkbmMemTableCompareOptions AOptions);

}	/* namespace Kbmmemtable */
using namespace Kbmmemtable;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Kbmmemtable
