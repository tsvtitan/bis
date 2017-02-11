// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Kbmmemtabledesform.pas' rev: 11.00

#ifndef KbmmemtabledesformHPP
#define KbmmemtabledesformHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Comctrls.hpp>	// Pascal unit
#include <Extctrls.hpp>	// Pascal unit
#include <Stdctrls.hpp>	// Pascal unit
#include <Bde.hpp>	// Pascal unit
#include <Dbtables.hpp>	// Pascal unit
#include <Typinfo.hpp>	// Pascal unit
#include <Grids.hpp>	// Pascal unit
#include <Dbgrids.hpp>	// Pascal unit
#include <Checklst.hpp>	// Pascal unit
#include <Imglist.hpp>	// Pascal unit
#include <Buttons.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Designeditors.hpp>	// Pascal unit
#include <Designintf.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Kbmmemtable.hpp>	// Pascal unit
#include <Kbmmemcsvstreamformat.hpp>	// Pascal unit
#include <Kbmmembinarystreamformat.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Kbmmemtabledesform
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrmKbmMemTableDesigner;
class PASCALIMPLEMENTATION TfrmKbmMemTableDesigner : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Dbtables::TSession* SES_Dummy;
	Comctrls::TTabSheet* tsBDEAlias;
	Stdctrls::TLabel* Label1;
	Stdctrls::TLabel* Label2;
	Comctrls::TListView* LTV_Alias;
	Comctrls::TListView* LTV_Tables;
	Comctrls::TStatusBar* StatusBar1;
	Dialogs::TOpenDialog* DLG_SelectFile;
	Db::TDataSource* DTS_DataDesign;
	Dialogs::TSaveDialog* DLG_SaveFile;
	Controls::TImageList* IMG_LTV_Tables;
	Controls::TImageList* IMG_LTV_Alias;
	Controls::TImageList* IMG_LTV_Fields;
	Comctrls::TPageControl* PGC_Options;
	Comctrls::TTabSheet* TBS_ActualStructure;
	Extctrls::TPanel* PAN_ActualStructure;
	Comctrls::TListView* LTV_Structure;
	Comctrls::TTabSheet* TBS_BorrowStructure;
	Extctrls::TPanel* PAN_BorrowStructure;
	Stdctrls::TButton* BTN_Refresh;
	Stdctrls::TButton* BTN_GetStructure;
	Comctrls::TPageControl* pcBorrowFrom;
	Comctrls::TTabSheet* tsTDataset;
	Comctrls::TListView* LTV_Datasets;
	Comctrls::TTabSheet* TBS_Data;
	Extctrls::TPanel* PAN_Data;
	Stdctrls::TLabel* LAB_Progress;
	Stdctrls::TRadioButton* RBT_FromFile;
	Stdctrls::TRadioButton* RBT_FromTable;
	Extctrls::TPanel* PAN_FromFile;
	Stdctrls::TLabel* Label3;
	Stdctrls::TEdit* EDT_File;
	Extctrls::TPanel* PAN_FromTable;
	Comctrls::TListView* LTV_FromTable;
	Stdctrls::TButton* BTN_Load;
	Stdctrls::TButton* BTN_SelectFileName;
	Stdctrls::TButton* BTN_Save;
	Comctrls::TProgressBar* PRO_Records;
	Stdctrls::TCheckBox* CHK_Binary;
	Stdctrls::TCheckBox* CHK_OnlyData;
	Comctrls::TTabSheet* TBS_Sorting;
	Extctrls::TPanel* PAN_Sort;
	Stdctrls::TLabel* Label4;
	Stdctrls::TLabel* Label5;
	Buttons::TSpeedButton* BTN_SEL_All;
	Buttons::TSpeedButton* BTN_SEL_Selected;
	Buttons::TSpeedButton* BTN_UNS_Selected;
	Buttons::TSpeedButton* BTN_UNS_All;
	Buttons::TSpeedButton* BTN_ORD_First;
	Buttons::TSpeedButton* BTN_ORD_Plus;
	Buttons::TSpeedButton* BTN_ORD_Minus;
	Buttons::TSpeedButton* BTN_ORD_Last;
	Stdctrls::TLabel* Label6;
	Comctrls::TListView* LTV_Existing;
	Comctrls::TListView* LTV_Sort;
	Stdctrls::TButton* BTN_Sort;
	Checklst::TCheckListBox* LTB_SortOptions;
	Comctrls::TTabSheet* TBS_DataDesign;
	Extctrls::TPanel* PAN_DataDesign;
	Dbgrids::TDBGrid* DBG_DataDesign;
	Stdctrls::TRadioButton* RBT_FromDataset;
	Extctrls::TPanel* PAN_FromDataset;
	Comctrls::TListView* LTV_FromDataset;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, Forms::TCloseAction &Action);
	void __fastcall LTV_AliasChange(System::TObject* Sender, Comctrls::TListItem* Item, Comctrls::TItemChange Change);
	void __fastcall LTV_TablesChange(System::TObject* Sender, Comctrls::TListItem* Item, Comctrls::TItemChange Change);
	void __fastcall BTN_GetStructureClick(System::TObject* Sender);
	void __fastcall RBT_FromFileClick(System::TObject* Sender);
	void __fastcall RBT_FromTableClick(System::TObject* Sender);
	void __fastcall LTV_FromTableChange(System::TObject* Sender, Comctrls::TListItem* Item, Comctrls::TItemChange Change);
	void __fastcall BTN_SelectFileNameClick(System::TObject* Sender);
	void __fastcall BTN_LoadClick(System::TObject* Sender);
	void __fastcall BTN_SaveClick(System::TObject* Sender);
	void __fastcall BTN_RefreshClick(System::TObject* Sender);
	void __fastcall LTV_ExistingChange(System::TObject* Sender, Comctrls::TListItem* Item, Comctrls::TItemChange Change);
	void __fastcall LTV_SortChange(System::TObject* Sender, Comctrls::TListItem* Item, Comctrls::TItemChange Change);
	void __fastcall BTN_SEL_AllClick(System::TObject* Sender);
	void __fastcall BTN_UNS_AllClick(System::TObject* Sender);
	void __fastcall BTN_SEL_SelectedClick(System::TObject* Sender);
	void __fastcall BTN_UNS_SelectedClick(System::TObject* Sender);
	void __fastcall BTN_ORD_LastClick(System::TObject* Sender);
	void __fastcall BTN_ORD_FirstClick(System::TObject* Sender);
	void __fastcall BTN_ORD_MinusClick(System::TObject* Sender);
	void __fastcall BTN_ORD_PlusClick(System::TObject* Sender);
	void __fastcall BTN_SortClick(System::TObject* Sender);
	void __fastcall LTV_DatasetsChange(System::TObject* Sender, Comctrls::TListItem* Item, Comctrls::TItemChange Change);
	void __fastcall RBT_FromDatasetClick(System::TObject* Sender);
	void __fastcall LTV_FromDatasetChange(System::TObject* Sender, Comctrls::TListItem* Item, Comctrls::TItemChange Change);
	
private:
	bool IsFilling;
	void __fastcall GetAliases(void);
	void __fastcall GetTables(AnsiString DatabaseName);
	void __fastcall LoadStructure(AnsiString TableName);
	void __fastcall GetDatasets(void);
	void __fastcall GetActualStructure(void);
	void __fastcall CheckAvailData(void);
	void __fastcall TransAll(Comctrls::TListView* Source, Comctrls::TListView* Dest);
	void __fastcall CopyItem(Comctrls::TListItem* SourceItem, Comctrls::TListView* Dest);
	void __fastcall StoreSortSetup(void);
	bool __fastcall SwapItems(Comctrls::TListItem* ItemFrom, Comctrls::TListItem* ItemTo);
	Comctrls::TListItem* __fastcall MoveItem(Comctrls::TListItem* Item, int DestinationIndex);
	void __fastcall SelectFull(Comctrls::TListItem* Item);
	Comctrls::TListItem* __fastcall DeleteItem(Comctrls::TListItem* Item);
	bool __fastcall IsInFieldNames(AnsiString FieldNames, AnsiString FieldName);
	void __fastcall CreateFields(void);
	
public:
	Designintf::_di_IDesigner Designer;
	Kbmmemtable::TkbmMemTable* MemTable;
	void __fastcall CopyDataSet(Db::TDataSet* Source, Db::TDataSet* Dest, bool Visual);
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TfrmKbmMemTableDesigner(Classes::TComponent* AOwner) : Forms::TForm(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrmKbmMemTableDesigner(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrmKbmMemTableDesigner(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TfrmKbmMemTableDesigner(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TfrmKbmMemTableDesigner* frmKbmMemTableDesigner;
#define KbmMemTableDesignerVersion "Designer - TkbmMemTable v.5.51"

}	/* namespace Kbmmemtabledesform */
using namespace Kbmmemtabledesform;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Kbmmemtabledesform
