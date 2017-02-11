{$ifdef FPC}         // FreePascal
  {$mode Delphi}
  {$define KBMMEMTABLE_DONT_SUPPORT_TIMESTAMPPOPULATION}
  {$define KBMMEMTABLE_SUPPORT_FT_FIXEDWIDECHAR}
  {$define KBMMEMTABLE_SUPPORT_FT_WIDEMEMO}
  {$define LEVEL4}
  {$define LEVEL5}
  {$define LEVEL6}
  {$define LEVEL7}
  {$define LEVEL9}
  {$define LEVEL10}
  {$define DELPHI}
{$endif}

{$ifdef VER100}      // Delphi 3
  {$define LEVEL3}
  {$define DELPHI}
{$endif}

{$ifdef VER110}      // C++ Builder 3
  {$define LEVEL3}
  {$define BCB}
{$endif}

{$ifdef VER120}      // Delphi 4
  {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
  {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
  {$define LEVEL4}
  {$define DELPHI}
{$endif}

{$ifdef VER125}      // C++ Builder 4
  {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
  {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
  {$define LEVEL4}
  {$define BCB}
{$endif}

{$ifdef VER130}      // Delphi 5 or Builder 5
  {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
  {$define KBMMEMTABLE_SUPPORT_EXPRESSIONPARSER}
  {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
  {$define LEVEL4}
  {$define LEVEL5}
  {$ifndef BCB}        // Delphi 5
    {$define DELPHI}
  {$else}              // Builder 5
    {$undef DELPHI}	     // ( Ensure Delphi off )
  {$endif}
{$endif}

{$ifdef VER140}      // Delphi/BCB 6 & Kylix 1/2/3.
  {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
  {$define KBMMEMTABLE_SUPPORT_EXPRESSIONPARSER}
  {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
  {$define LEVEL4}
  {$define LEVEL5}
  {$define LEVEL6}
  {$ifndef BCB}        // Delphi 6
    {$define DELPHI}
  {$else}              // Builder 6
    {$undef DELPHI}	     // ( Ensure Delphi off )
  {$endif}
  {$ifdef LINUX}
    {$ifdef CONDITIONALEXPRESSIONS}  // Figure out which Kylix.
      {$if Declared(CompilerVersion) and (CompilerVersion=14.10)}
        {$define KYLIX2}
	{$ifend}
      {$if Declared(CompilerVersion) and (CompilerVersion=14.50)}
        {$define KYLIX3}
	{$ifend}
    {$ELSE}
      {$define KYLIX1}
    {$endif}
  {$endif}
{$endif}

{$ifdef VER150}      // Delphi 7.
  {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
  {$define KBMMEMTABLE_SUPPORT_EXPRESSIONPARSER}
  {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
  {$define LEVEL4}
  {$define LEVEL5}
  {$define LEVEL6}
  {$define LEVEL7}
  {$ifndef BCB}        // Delphi 7
    {$define DELPHI}
  {$else}              // Builder 7
    {$undef DELPHI}	     // ( Ensure Delphi off )
  {$endif}
  {$ifdef LINUX}
    Sorry this level of Kylix not yet supported.
  {$endif}
{$endif}

{$ifdef VER170}      // Delphi 9.
  {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
  {$define KBMMEMTABLE_SUPPORT_EXPRESSIONPARSER}
  {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
  {$define LEVEL4}
  {$define LEVEL5}
  {$define LEVEL6}
  {$define LEVEL7}
  {$define LEVEL9}
  {$ifndef BCB}        // Delphi 9/BDS 2005
    {$define DELPHI}
  {$else}
    {$undef DELPHI}	     // ( Ensure Delphi off )
  {$endif}
  {$ifdef LINUX}
    Sorry this level of Kylix not yet supported.
  {$endif}
{$endif}

{$ifdef VER180}      // Delphi 10/BDS 2006.
  {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
  {$define KBMMEMTABLE_SUPPORT_EXPRESSIONPARSER}
  {$define KBMMEMTABLE_SUPPORT_FT_FIXEDWIDECHAR}
  {$define KBMMEMTABLE_SUPPORT_FT_WIDEMEMO}
  {$define KBMMEMTABLE_SUPPORT_FT_ORAINTERVAL}
  {$define KBMMEMTABLE_SUPPORT_FT_ORATIMESTAMP}
  {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
  {$define KBMMEMTABLE_USE_WSTRLEN}
  {$define LEVEL4}
  {$define LEVEL5}
  {$define LEVEL6}
  {$define LEVEL7}
  {$define LEVEL9}
  {$define LEVEL10}
  {$ifndef BCB}        // Delphi 10/BDS 2006
    {$define DELPHI}
  {$else}
    {$undef DELPHI}	     // ( Ensure Delphi off )
  {$endif}
  {$ifdef LINUX}
    Sorry this level of Kylix not yet supported.
  {$endif}
{$endif}

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 18.5} // Spacely / Delphi 2007 for Win32
    {$DEFINE SPACELY_UP}
    {$define KBMMEMTABLE_SUPPORT_NESTEDFIELDS}
    {$define KBMMEMTABLE_SUPPORT_EXPRESSIONPARSER}
    {$define KBMMEMTABLE_SUPPORT_FT_FIXEDWIDECHAR}
    {$define KBMMEMTABLE_SUPPORT_FT_WIDEMEMO}
    {$define KBMMEMTABLE_SUPPORT_FT_ORAINTERVAL}
    {$define KBMMEMTABLE_SUPPORT_FT_ORATIMESTAMP}
    {$define KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
    {$define KBMMEMTABLE_SUPPORT_FIELDFULLNAME}
    {$define KBMMEMTABLE_USE_WSTRLEN}
    {$define LEVEL4}
    {$define LEVEL5}
    {$define LEVEL6}
    {$define LEVEL7}
    {$define LEVEL9}
    {$define LEVEL10}
    {$DEFINE LEVEL11}
  {$IFEND}
  {$IF CompilerVersion >= 19.0} // CodeGear RAD Studio 2007 for Win32/.Net
    {$DEFINE HIGHLANDER_UP}
    {$DEFINE LEVEL12}
  {$IFEND}
  {$ifndef BCB}
    {$define DELPHI}
  {$else}
    {$undef DELPHI}	     // ( Ensure Delphi off )
  {$endif}
{$ENDIF}

{$ifdef CLR}
  {$undef KBMMEMTABLE_SUPPORT_SETBLOCKREADSIZE}
  {$define DOTNET}
  {$UNSAFECODE ON}
{$ENDIF}

{$ifdef LINUX}
  {$define CLX}
{$endif}

//***********************************************************************

{$ifndef DOTNET}
 {$ifdef LEVEL7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
 {$endif}
 {$ifdef LEVEL6}
  {$WARN SYMBOL_PLATFORM OFF}
 {$endif}
{$endif}

{$B-}    // Enable short circuit evaluation.

{$ifdef BCB}
{$ObjExportAll On}
{$ASSERTIONS ON}
{$endif}


