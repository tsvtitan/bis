// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'uprintprogress.pas' rev: 6.00

#ifndef uprintprogressHPP
#define uprintprogressHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ComCtrls.hpp>	// Pascal unit
#include <MPHexEditorEx.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Uprintprogress
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TdlgPrintProgress;
class PASCALIMPLEMENTATION TdlgPrintProgress : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TButton* Button2;
	Stdctrls::TLabel* lbPrinting;
	Comctrls::TProgressBar* ProgressBar1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall Button2Click(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	int FFrom;
	int FTo;
	bool FCancel;
	Mphexeditorex::TMPHexEditorEx* FEditor;
	MESSAGE void __fastcall WMUser1(tagMSG &Msg);
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TdlgPrintProgress(Classes::TComponent* AOwner) : Forms::TForm(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TdlgPrintProgress(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TdlgPrintProgress(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TdlgPrintProgress(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TdlgPrintProgress* dlgPrintProgress;
extern PACKAGE bool __fastcall DoPrint(Mphexeditorex::TMPHexEditorEx* Editor, const int PageFrom, const int PageTo);

}	/* namespace Uprintprogress */
using namespace Uprintprogress;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// uprintprogress
