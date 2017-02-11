// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Kbmmemtabledesigner.pas' rev: 11.00

#ifndef KbmmemtabledesignerHPP
#define KbmmemtabledesignerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Designeditors.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Kbmmemtabledesigner
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TkbmMemTableDesigner;
class PASCALIMPLEMENTATION TkbmMemTableDesigner : public Designeditors::TComponentEditor 
{
	typedef Designeditors::TComponentEditor inherited;
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual AnsiString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
	void __fastcall TableDesigner(void);
	void __fastcall LoadPersistentFileBinary(void);
	void __fastcall LoadPersistentFileNormal(void);
	void __fastcall EmptyTable(void);
public:
	#pragma option push -w-inl
	/* TComponentEditor.Create */ inline __fastcall virtual TkbmMemTableDesigner(Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TComponentEditor(AComponent, ADesigner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TkbmMemTableDesigner(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Kbmmemtabledesigner */
using namespace Kbmmemtabledesigner;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Kbmmemtabledesigner
