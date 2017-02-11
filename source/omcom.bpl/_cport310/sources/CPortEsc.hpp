// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Cportesc.pas' rev: 11.00

#ifndef CportescHPP
#define CportescHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Cportesc
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TEscapeResult { erChar, erCode, erNothing };
#pragma option pop

#pragma option push -b-
enum TEscapeCode { ecUnknown, ecNotCompleted, ecCursorUp, ecCursorDown, ecCursorLeft, ecCursorRight, ecCursorHome, ecCursorMove, ecReverseLineFeed, ecAppCursorLeft, ecAppCursorRight, ecAppCursorUp, ecAppCursorDown, ecEraseLineFrom, ecEraseScreenFrom, ecEraseLine, ecEraseScreen, ecSetTab, ecClearTab, ecClearAllTabs, ecIdentify, ecIdentResponse, ecQueryDevice, ecReportDeviceOK, ecReportDeviceFailure, ecQueryCursorPos, ecReportCursorPos, ecAttributes, ecSetMode, ecResetMode, ecReset, ecSaveCaretAndAttr, ecRestoreCaretAndAttr, ecSaveCaret, ecRestoreCaret, ecTest };
#pragma option pop

class DELPHICLASS TEscapeCodes;
class PASCALIMPLEMENTATION TEscapeCodes : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	char FCharachter;
	TEscapeCode FCode;
	AnsiString FData;
	Classes::TStrings* FParams;
	
public:
	__fastcall TEscapeCodes(void);
	__fastcall virtual ~TEscapeCodes(void);
	virtual TEscapeResult __fastcall ProcessChar(char Ch) = 0 ;
	virtual AnsiString __fastcall EscCodeToStr(TEscapeCode Code, Classes::TStrings* AParams) = 0 ;
	int __fastcall GetParam(int Num, Classes::TStrings* AParams);
	__property AnsiString Data = {read=FData};
	__property TEscapeCode Code = {read=FCode, nodefault};
	__property char Charachter = {read=FCharachter, nodefault};
	__property Classes::TStrings* Params = {read=FParams};
};


class DELPHICLASS TEscapeCodesVT52;
class PASCALIMPLEMENTATION TEscapeCodesVT52 : public TEscapeCodes 
{
	typedef TEscapeCodes inherited;
	
private:
	bool FInSequence;
	TEscapeCode __fastcall DetectCode(AnsiString Str);
	
public:
	virtual TEscapeResult __fastcall ProcessChar(char Ch);
	virtual AnsiString __fastcall EscCodeToStr(TEscapeCode Code, Classes::TStrings* AParams);
public:
	#pragma option push -w-inl
	/* TEscapeCodes.Create */ inline __fastcall TEscapeCodesVT52(void) : TEscapeCodes() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TEscapeCodes.Destroy */ inline __fastcall virtual ~TEscapeCodesVT52(void) { }
	#pragma option pop
	
};


class DELPHICLASS TEscapeCodesVT100;
class PASCALIMPLEMENTATION TEscapeCodesVT100 : public TEscapeCodes 
{
	typedef TEscapeCodes inherited;
	
private:
	bool FInSequence;
	bool FInExtSequence;
	TEscapeCode __fastcall DetectCode(AnsiString Str);
	TEscapeCode __fastcall DetectExtCode(AnsiString Str);
	
public:
	virtual TEscapeResult __fastcall ProcessChar(char Ch);
	virtual AnsiString __fastcall EscCodeToStr(TEscapeCode Code, Classes::TStrings* AParams);
public:
	#pragma option push -w-inl
	/* TEscapeCodes.Create */ inline __fastcall TEscapeCodesVT100(void) : TEscapeCodes() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TEscapeCodes.Destroy */ inline __fastcall virtual ~TEscapeCodesVT100(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Cportesc */
using namespace Cportesc;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Cportesc
