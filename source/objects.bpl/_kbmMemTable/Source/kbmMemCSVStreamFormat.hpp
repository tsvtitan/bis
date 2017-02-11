// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Kbmmemcsvstreamformat.pas' rev: 11.00

#ifndef KbmmemcsvstreamformatHPP
#define KbmmemcsvstreamformatHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Kbmmemtable.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Dbcommon.hpp>	// Pascal unit
#include <Kbmmemreseng.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Kbmmemcsvstreamformat
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TkbmStreamFlagLocalFormat { sfSaveLocalFormat, sfLoadLocalFormat };
#pragma option pop

#pragma option push -b-
enum TkbmStreamFlagNoHeader { sfSaveNoHeader, sfLoadNoHeader };
#pragma option pop

#pragma option push -b-
enum TkbmStreamFlagQuoteOnlyStrings { sfSaveQuoteOnlyStrings };
#pragma option pop

#pragma option push -b-
enum TkbmStreamFlagPlaceholders { sfSavePlaceholders };
#pragma option pop

typedef Set<TkbmStreamFlagLocalFormat, sfSaveLocalFormat, sfLoadLocalFormat>  TkbmStreamFlagsLocalFormat;

typedef Set<TkbmStreamFlagNoHeader, sfSaveNoHeader, sfLoadNoHeader>  TkbmStreamFlagsNoHeader;

typedef Set<TkbmStreamFlagPlaceholders, sfSavePlaceholders, sfSavePlaceholders>  TkbmStreamFlagsPlaceHolders;

typedef Set<TkbmStreamFlagQuoteOnlyStrings, sfSaveQuoteOnlyStrings, sfSaveQuoteOnlyStrings>  TkbmStreamFlagsQuoteOnlyStrings;

typedef void __fastcall (__closure *TkbmOnFormatLoadField)(System::TObject* Sender, Db::TField* Field, bool &Null, AnsiString &Data);

typedef void __fastcall (__closure *TkbmOnFormatSaveField)(System::TObject* Sender, Db::TField* Field, bool &Null, AnsiString &Data);

class DELPHICLASS TkbmCustomCSVStreamFormat;
class PASCALIMPLEMENTATION TkbmCustomCSVStreamFormat : public Kbmmemtable::TkbmCustomStreamFormat 
{
	typedef Kbmmemtable::TkbmCustomStreamFormat inherited;
	
private:
	Kbmmemtable::TkbmCustomMemTable* FDataset;
	TkbmOnFormatLoadField FOnFormatLoadField;
	TkbmOnFormatSaveField FOnFormatSaveField;
	char Ods;
	char Oms;
	char Ots;
	char Oths;
	Byte Ocf;
	Byte Onf;
	AnsiString Osdf;
	AnsiString Ocs;
	char *buf;
	char *bufptr;
	int remaining_in_buf;
	AnsiString Line;
	AnsiString Word;
	char *lptr;
	char *elptr;
	int ProgressCnt;
	int StreamSize;
	char FCSVQuote;
	char FCSVFieldDelimiter;
	char FCSVRecordDelimiter;
	AnsiString FCSVTrueString;
	AnsiString FCSVFalseString;
	TkbmStreamFlagsLocalFormat FsfLocalFormat;
	TkbmStreamFlagsNoHeader FsfNoHeader;
	TkbmStreamFlagsPlaceHolders FsfPlaceHolders;
	TkbmStreamFlagsQuoteOnlyStrings FsfQuoteOnlyStrings;
	void __fastcall SetCSVFieldDelimiter(char Value);
	
protected:
	bool FDefLoaded;
	virtual bool __fastcall GetChunk(void);
	virtual bool __fastcall GetLine(void);
	virtual AnsiString __fastcall GetWord(bool &null);
	virtual AnsiString __fastcall GetVersion();
	virtual void __fastcall BeforeSave(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall SaveDef(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall SaveData(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall AfterSave(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall DetermineLoadFieldIDs(Kbmmemtable::TkbmCustomMemTable* ADataset, Classes::TStringList* AList, Kbmmemtable::TkbmDetermineLoadFieldsSituation Situation);
	virtual void __fastcall DetermineLoadFieldIndex(Kbmmemtable::TkbmCustomMemTable* ADataset, AnsiString ID, int FieldCount, int OrigIndex, int &NewIndex, Kbmmemtable::TkbmDetermineLoadFieldsSituation Situation);
	virtual void __fastcall BeforeLoad(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall LoadDef(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall LoadData(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall AfterLoad(Kbmmemtable::TkbmCustomMemTable* ADataset);
	__property TkbmOnFormatLoadField OnFormatLoadField = {read=FOnFormatLoadField, write=FOnFormatLoadField};
	__property TkbmOnFormatSaveField OnFormatSaveField = {read=FOnFormatSaveField, write=FOnFormatSaveField};
	__property char CSVQuote = {read=FCSVQuote, write=FCSVQuote, nodefault};
	__property char CSVFieldDelimiter = {read=FCSVFieldDelimiter, write=SetCSVFieldDelimiter, nodefault};
	__property char CSVRecordDelimiter = {read=FCSVRecordDelimiter, write=FCSVRecordDelimiter, nodefault};
	__property AnsiString CSVTrueString = {read=FCSVTrueString, write=FCSVTrueString};
	__property AnsiString CSVFalseString = {read=FCSVFalseString, write=FCSVFalseString};
	__property TkbmStreamFlagsLocalFormat sfLocalFormat = {read=FsfLocalFormat, write=FsfLocalFormat, nodefault};
	__property TkbmStreamFlagsNoHeader sfNoHeader = {read=FsfNoHeader, write=FsfNoHeader, nodefault};
	__property TkbmStreamFlagsPlaceHolders sfPlaceHolders = {read=FsfPlaceHolders, write=FsfPlaceHolders, nodefault};
	__property TkbmStreamFlagsQuoteOnlyStrings sfQuoteOnlyStrings = {read=FsfQuoteOnlyStrings, write=FsfQuoteOnlyStrings, nodefault};
	
public:
	__fastcall virtual TkbmCustomCSVStreamFormat(Classes::TComponent* AOwner);
	virtual void __fastcall Assign(Classes::TPersistent* Source);
public:
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TkbmCustomCSVStreamFormat(void) { }
	#pragma option pop
	
};


class DELPHICLASS TkbmCSVStreamFormat;
class PASCALIMPLEMENTATION TkbmCSVStreamFormat : public TkbmCustomCSVStreamFormat 
{
	typedef TkbmCustomCSVStreamFormat inherited;
	
__published:
	__property CSVQuote ;
	__property CSVFieldDelimiter ;
	__property CSVRecordDelimiter ;
	__property CSVTrueString ;
	__property CSVFalseString ;
	__property sfLocalFormat ;
	__property sfQuoteOnlyStrings ;
	__property sfNoHeader ;
	__property Version ;
	__property sfData ;
	__property sfCalculated ;
	__property sfLookup ;
	__property sfNonVisible ;
	__property sfBlobs ;
	__property sfDef ;
	__property sfIndexDef ;
	__property sfPlaceHolders ;
	__property sfFiltered ;
	__property sfIgnoreRange ;
	__property sfIgnoreMasterDetail ;
	__property sfDeltas ;
	__property sfDontFilterDeltas ;
	__property sfAppend ;
	__property sfFieldKind ;
	__property sfFromStart ;
	__property OnFormatLoadField ;
	__property OnFormatSaveField ;
	__property OnBeforeLoad ;
	__property OnAfterLoad ;
	__property OnBeforeSave ;
	__property OnAfterSave ;
	__property OnCompress ;
	__property OnDeCompress ;
public:
	#pragma option push -w-inl
	/* TkbmCustomCSVStreamFormat.Create */ inline __fastcall virtual TkbmCSVStreamFormat(Classes::TComponent* AOwner) : TkbmCustomCSVStreamFormat(AOwner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TkbmCSVStreamFormat(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE AnsiString __fastcall StringToCodedString(const AnsiString Source);
extern PACKAGE AnsiString __fastcall CodedStringToString(const AnsiString Source);
extern PACKAGE AnsiString __fastcall StringToBase64(const AnsiString Source);
extern PACKAGE AnsiString __fastcall Base64ToString(const AnsiString Source);

}	/* namespace Kbmmemcsvstreamformat */
using namespace Kbmmemcsvstreamformat;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Kbmmemcsvstreamformat
