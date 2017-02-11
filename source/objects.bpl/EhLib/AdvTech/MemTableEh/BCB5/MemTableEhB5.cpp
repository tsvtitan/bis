//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("MemTableEhB5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("BDEDataDriverEh.pas");
USEUNIT("DataDriverEh.pas");
USEUNIT("EhLibMTE.pas");
USEUNIT("IBXDataDriverEh.pas");
USEUNIT("MemTableDataEh.pas");
USEUNIT("MemTableDesignEh.pas");
USEFORMNS("MemTableEditEh.pas", Memtableediteh, MemTableDataForm);
USEFORMNS("MTCreateDataDriver.pas", Mtcreatedatadriver, fMTCreateDataDriver);
USEUNIT("MemTableEh.pas");
USERES("MemTableEh.dcr");
USEPACKAGE("vclx50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vcldbx50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("dclbde50.bpi");
USEPACKAGE("dcldb50.bpi");
USEPACKAGE("VCLIB50.bpi");
USEPACKAGE("EHLIBB50.bpi");
USEPACKAGE("dclado50.bpi");
USEPACKAGE("vclado50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
