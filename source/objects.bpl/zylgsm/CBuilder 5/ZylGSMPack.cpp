//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("ZylGSMPack.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("ZylGSM.pas");
USERES("ZylGSM.dcr");
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
