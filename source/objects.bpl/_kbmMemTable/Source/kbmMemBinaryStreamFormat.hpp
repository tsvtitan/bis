// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Kbmmembinarystreamformat.pas' rev: 11.00

#ifndef KbmmembinarystreamformatHPP
#define KbmmembinarystreamformatHPP

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
#include <Kbmmemreseng.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Kbmmembinarystreamformat
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TkbmStreamFlagUsingIndex { sfSaveUsingIndex };
#pragma option pop

typedef Set<TkbmStreamFlagUsingIndex, sfSaveUsingIndex, sfSaveUsingIndex>  TkbmStreamFlagUsingIndexs;

#pragma option push -b-
enum TkbmStreamFlagDataTypeHeader { sfSaveDataTypeHeader, sfLoadDataTypeHeader };
#pragma option pop

typedef Set<TkbmStreamFlagDataTypeHeader, sfSaveDataTypeHeader, sfLoadDataTypeHeader>  TkbmStreamFlagDataTypeHeaders;

class DELPHICLASS TkbmCustomBinaryStreamFormat;
class PASCALIMPLEMENTATION TkbmCustomBinaryStreamFormat : public Kbmmemtable::TkbmCustomStreamFormat 
{
	typedef Kbmmemtable::TkbmCustomStreamFormat inherited;
	
private:
	Classes::TWriter* Writer;
	Classes::TReader* Reader;
	TkbmStreamFlagUsingIndexs FUsingIndex;
	TkbmStreamFlagDataTypeHeaders FDataTypeHeader;
	int FBuffSize;
	int FileVersion;
	bool InitIndexDef;
	int ProgressCnt;
	int StreamSize;
	void __fastcall SetBuffSize(int ABuffSize);
	
protected:
	virtual AnsiString __fastcall GetVersion();
	virtual void __fastcall BeforeSave(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall SaveDef(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall SaveData(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall AfterSave(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall BeforeLoad(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall LoadDef(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall LoadData(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall AfterLoad(Kbmmemtable::TkbmCustomMemTable* ADataset);
	virtual void __fastcall DetermineLoadFieldIndex(Kbmmemtable::TkbmCustomMemTable* ADataset, AnsiString ID, int FieldCount, int OrigIndex, int &NewIndex, Kbmmemtable::TkbmDetermineLoadFieldsSituation Situation);
	__property TkbmStreamFlagUsingIndexs sfUsingIndex = {read=FUsingIndex, write=FUsingIndex, nodefault};
	__property TkbmStreamFlagDataTypeHeaders sfDataTypeHeader = {read=FDataTypeHeader, write=FDataTypeHeader, nodefault};
	__property int BufferSize = {read=FBuffSize, write=SetBuffSize, nodefault};
	
public:
	__fastcall virtual TkbmCustomBinaryStreamFormat(Classes::TComponent* AOwner);
public:
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TkbmCustomBinaryStreamFormat(void) { }
	#pragma option pop
	
};


class DELPHICLASS TkbmBinaryStreamFormat;
class PASCALIMPLEMENTATION TkbmBinaryStreamFormat : public TkbmCustomBinaryStreamFormat 
{
	typedef TkbmCustomBinaryStreamFormat inherited;
	
__published:
	__property Version ;
	__property sfUsingIndex ;
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
	__property sfDataTypeHeader ;
	__property OnBeforeLoad ;
	__property OnAfterLoad ;
	__property OnBeforeSave ;
	__property OnAfterSave ;
	__property OnCompress ;
	__property OnDeCompress ;
	__property BufferSize ;
public:
	#pragma option push -w-inl
	/* TkbmCustomBinaryStreamFormat.Create */ inline __fastcall virtual TkbmBinaryStreamFormat(Classes::TComponent* AOwner) : TkbmCustomBinaryStreamFormat(AOwner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TkbmBinaryStreamFormat(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Kbmmembinarystreamformat */
using namespace Kbmmembinarystreamformat;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Kbmmembinarystreamformat
