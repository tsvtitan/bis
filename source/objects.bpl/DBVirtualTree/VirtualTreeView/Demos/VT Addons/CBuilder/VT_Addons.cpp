//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("VT_Addons.res");
USEUNIT("..\Source\VirtualTreesEx\VirtualTreesExReg.pas");
USEUNIT("..\Source\VirtualTreesEx\VirtualTreesEx.pas");
USERES("..\Source\VSTEdit\VSTEdit.dcr");
USEUNIT("..\Source\VSTEdit\VSTEdit.pas");
USERES("..\Source\VSTEdit\MFEdit.dcr");
USEUNIT("..\Source\VSTEdit\MFEdit.pas");
USERES("..\Source\VirtualDBTree\VirtualDBTree.dcr");
USEUNIT("..\Source\VirtualDBTree\VirtualDBTree.pas");
USERES("..\Source\VirtualDBTree\VirtualDBTreeEx.dcr");
USEUNIT("..\Source\VirtualDBTree\VirtualDBTreeEx.pas");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("VCLDB50.bpi");
USEPACKAGE("VirtualTreeView.bpi");
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
