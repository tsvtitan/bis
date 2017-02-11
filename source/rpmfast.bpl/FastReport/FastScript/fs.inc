
{******************************************}
{                                          }
{             FastScript v1.9              }
{               Include file               }
{                                          }
{ (c) 2003, 2004 by Alexander Tzyganenko,  }
{             Fast Reports, Inc            }
{                                          }
{******************************************}


{$R-} {- Range-Checking }
{$H+} {- Use long strings by default }
{$B-} {- Complete Boolean Evaluation }
{$T-} {- Typed @ operator }
{$P+} {- Open string params }

{$IFNDEF FPC}
  {$V-} {- Var-String Checking }
  {$X+} {- Extended syntax }
  {$J+} {- Writeable structured consts }
{$ENDIF}

{$IFDEF VER120}      // Delphi 4.0
  {$DEFINE Delphi4}
{$ENDIF}

{$IFDEF VER130}      // Delphi 5.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}         
{$ENDIF}

{$IFDEF VER140}      // Delphi 6.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
{$ENDIF}

{$IFDEF VER150}      // Delphi 7.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

{$IFDEF VER170}      // Delphi 9.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER180}      // Delphi 10.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER185}      // Delphi 11.0 (Spacely)
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER190}      // Delphi 11.0 (Highlander)
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER125}      // Borland C++ Builder 4.0
  {$DEFINE Delphi4}
  {$ObjExportAll on}
{$ENDIF}

{$IFDEF VER130}      // Borland C++ Builder 5.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER140}      // Borland C++ Builder 6.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER150}      // Borland C++ Builder 7.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF FPC} // Free pascal compiler
  {$MODE DELPHI}

  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
{$ELSE}
  {$IFDEF LINUX}      // KYLIX
    {$DEFINE Delphi4}
    {$DEFINE Delphi5}
    {$DEFINE Delphi6}
    {$DEFINE CLX}
    {$IFDEF BCB}
      {$DEFINE CLXCPP}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF FPC}
  {$DEFINE CROSS_COMPILE}
{$ENDIF}

{$IFDEF CLX}
  {$DEFINE CROSS_COMPILE}
{$ENDIF}

// Uncomment below line for CLX compilation
//{$DEFINE CLX}

// include ole dispatch module
{$IFNDEF CROSS_COMPILE}
  {$DEFINE OLE}
{$ENDIF}
