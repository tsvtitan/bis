
//------------------------------------------------------------------------------
// Compiler Version Information
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Windows
//------------------------------------------------------------------------------

{$IFDEF Win32}
{$IFNDEF MSWINDOWS}
{$DEFINE MSWINDOWS}
{$ENDIF}
{$ENDIF}

//------------------------------------------------------------------------------
// VERXXX to COMPILER_X, DELPHI_X and CPPB_X mappings
//------------------------------------------------------------------------------

{$IFDEF MSWINDOWS}

{$IFDEF VER180}
  {$DEFINE COMPILER_10}
  {$IFDEF BCB}
    {$DEFINE CPPB}
    {$DEFINE CPPB_10}
  {$ELSE}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_10}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER170}
  {$DEFINE COMPILER_9}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI_9}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE COMPILER_7}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI_7}
{$ENDIF}

{$IFDEF VER140}
  {$DEFINE COMPILER_6}
  {$IFDEF BCB}
    {$DEFINE CPPB}
    {$DEFINE CPPB_6}
  {$ELSE}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_6}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE COMPILER_5}
  {$IFDEF BCB}
    {$DEFINE CPPB}
    {$DEFINE CPPB_5}
  {$ELSE}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_5}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER125}
{$DEFINE COMPILER_4}
{$DEFINE CPPB}
{$DEFINE CPPB_4}
{$ENDIF}

{$IFDEF VER120}
{$DEFINE COMPILER_4}
{$DEFINE DELPHI}
{$DEFINE DELPHI_4}
{$ENDIF}

{$IFDEF VER110}
{$DEFINE COMPILER_3}
{$DEFINE CPPB}
{$DEFINE CPPB_3}
{$ENDIF}

{$IFDEF VER100}
{$DEFINE COMPILER_3}
{$DEFINE DELPHI}
{$DEFINE DELPHI_3}
{$ENDIF}

{$IFDEF VER93}
{$DEFINE COMPILER_2} // C++ Builder v1 compiler is really v2
{$DEFINE CPPB}
{$DEFINE CPPB_1}
{$ENDIF}

{$IFDEF VER90}
{$DEFINE COMPILER_2}
{$DEFINE DELPHI}
{$DEFINE DELPHI_2}
{$ENDIF}

{$IFDEF VER80}
{$DEFINE COMPILER_1}
{$DEFINE DELPHI}
{$DEFINE DELPHI_1}
{$ENDIF}

//------------------------------------------------------------------------------
// CPPB_X_UP from CPPB_X mappings
//------------------------------------------------------------------------------

{$IFDEF CPPB_1}
  {$DEFINE CPPB_1_UP}
{$ENDIF}

{$IFDEF CPPB_3}
  {$DEFINE CPPB_1_UP}
  {$DEFINE CPPB_3_UP}
{$ENDIF}

{$IFDEF CPPB_4}
  {$DEFINE CPPB_1_UP}
  {$DEFINE CPPB_3_UP}
  {$DEFINE CPPB_4_UP}
{$ENDIF}

{$IFDEF CPPB_5}
  {$DEFINE CPPB_1_UP}
  {$DEFINE CPPB_3_UP}
  {$DEFINE CPPB_4_UP}
  {$DEFINE CPPB_5_UP}
{$ENDIF}

{$IFDEF CPPB_10}
  {$DEFINE CPPB_1_UP}
  {$DEFINE CPPB_3_UP}
  {$DEFINE CPPB_4_UP}
  {$DEFINE CPPB_5_UP}
  {$DEFINE CPPB_10_UP}
{$ENDIF}

{$IFDEF CPPB_3_UP}
// C++ Builder requires this if you use Delphi components in run-time packages.
{$OBJEXPORTALL ON}
{$ENDIF}

{$ENDIF}

//------------------------------------------------------------------------------
// CLR - DotNet
//------------------------------------------------------------------------------

{$IFDEF CLR}

{$IFDEF VER160}
{$DEFINE COMPILER_8}
{$DEFINE DELPHI}
{$DEFINE DELPHI_8}
{$ENDIF}

{$ENDIF CLR}

//------------------------------------------------------------------------------
// Linux
//------------------------------------------------------------------------------

{$IFDEF LINUX}

{$IFDEF VER150}
{$DEFINE COMPILER_7}
{$DEFINE KYLIX}
{$DEFINE KYLIX_3}
{$ENDIF}

{$IFDEF VER140}
{$DEFINE COMPILER_6}
{$DEFINE KYLIX}
{$DEFINE KYLIX_2}
{$ENDIF}

{$IFDEF KYLIX_2}
{$DEFINE KYLIX_1_UP}
{$DEFINE KYLIX_2_UP}
{$ENDIF}

{$IFDEF KYLIX_3}
{$DEFINE KYLIX_1_UP}
{$DEFINE KYLIX_2_UP}
{$DEFINE KYLIX_3_UP}
{$ENDIF}

{$ENDIF}

//------------------------------------------------------------------------------
// DELPHI_X_UP from DELPHI_X mappings
//------------------------------------------------------------------------------

{$IFDEF DELPHI_1}
{$DEFINE DELPHI_1_UP}
{$ENDIF}

{$IFDEF DELPHI_2}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$ENDIF}

{$IFDEF DELPHI_3}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$DEFINE DELPHI_3_UP}
{$ENDIF}

{$IFDEF DELPHI_4}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$DEFINE DELPHI_3_UP}
{$DEFINE DELPHI_4_UP}
{$ENDIF}

{$IFDEF DELPHI_5}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$DEFINE DELPHI_3_UP}
{$DEFINE DELPHI_4_UP}
{$DEFINE DELPHI_5_UP}
{$ENDIF}

{$IFDEF DELPHI_6}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$DEFINE DELPHI_3_UP}
{$DEFINE DELPHI_4_UP}
{$DEFINE DELPHI_5_UP}
{$DEFINE DELPHI_6_UP}
{$ENDIF}

{$IFDEF DELPHI_7}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$DEFINE DELPHI_3_UP}
{$DEFINE DELPHI_4_UP}
{$DEFINE DELPHI_5_UP}
{$DEFINE DELPHI_6_UP}
{$DEFINE DELPHI_7_UP}
{$ENDIF}

{$IFDEF DELPHI_8}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$DEFINE DELPHI_3_UP}
{$DEFINE DELPHI_4_UP}
{$DEFINE DELPHI_5_UP}
{$DEFINE DELPHI_6_UP}
{$DEFINE DELPHI_7_UP}
{$DEFINE DELPHI_8_UP}
{$ENDIF}

{$IFDEF DELPHI_9}
{$DEFINE DELPHI_1_UP}
{$DEFINE DELPHI_2_UP}
{$DEFINE DELPHI_3_UP}
{$DEFINE DELPHI_4_UP}
{$DEFINE DELPHI_5_UP}
{$DEFINE DELPHI_6_UP}
{$DEFINE DELPHI_7_UP}
{$DEFINE DELPHI_8_UP}
{$DEFINE DELPHI_9_UP}
{$ENDIF}

{$IFDEF DELPHI_10}
  {$DEFINE DELPHI_1_UP}
  {$DEFINE DELPHI_2_UP}
  {$DEFINE DELPHI_3_UP}
  {$DEFINE DELPHI_4_UP}
  {$DEFINE DELPHI_5_UP}
  {$DEFINE DELPHI_6_UP}
  {$DEFINE DELPHI_7_UP}
  {$DEFINE DELPHI_8_UP}
  {$DEFINE DELPHI_9_UP}
  {$DEFINE DELPHI_10_UP}
{$ENDIF}

//------------------------------------------------------------------------------
// COMPIlER_X_UP from COMPILER_X mappings
//------------------------------------------------------------------------------

{$IFDEF COMPILER_1}
{$DEFINE COMPILER_1_UP}
{$ENDIF}

{$IFDEF COMPILER_2}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$ENDIF}

{$IFDEF COMPILER_3}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$DEFINE COMPILER_3_UP}
{$ENDIF}

{$IFDEF COMPILER_4}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$DEFINE COMPILER_3_UP}
{$DEFINE COMPILER_4_UP}
{$ENDIF}

{$IFDEF COMPILER_5}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$DEFINE COMPILER_3_UP}
{$DEFINE COMPILER_4_UP}
{$DEFINE COMPILER_5_UP}
{$ENDIF}

{$IFDEF COMPILER_6}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$DEFINE COMPILER_3_UP}
{$DEFINE COMPILER_4_UP}
{$DEFINE COMPILER_5_UP}
{$DEFINE COMPILER_6_UP}
{$ENDIF}

{$IFDEF COMPILER_7}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$DEFINE COMPILER_3_UP}
{$DEFINE COMPILER_4_UP}
{$DEFINE COMPILER_5_UP}
{$DEFINE COMPILER_6_UP}
{$DEFINE COMPILER_7_UP}
{$ENDIF}

{$IFDEF COMPILER_8}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$DEFINE COMPILER_3_UP}
{$DEFINE COMPILER_4_UP}
{$DEFINE COMPILER_5_UP}
{$DEFINE COMPILER_6_UP}
{$DEFINE COMPILER_7_UP}
{$DEFINE COMPILER_8_UP}
{$ENDIF}

{$IFDEF COMPILER_9}
{$DEFINE COMPILER_1_UP}
{$DEFINE COMPILER_2_UP}
{$DEFINE COMPILER_3_UP}
{$DEFINE COMPILER_4_UP}
{$DEFINE COMPILER_5_UP}
{$DEFINE COMPILER_6_UP}
{$DEFINE COMPILER_7_UP}
{$DEFINE COMPILER_8_UP}
{$DEFINE COMPILER_9_UP}
{$ENDIF}

{$IFDEF COMPILER_10}
  {$DEFINE COMPILER_1_UP}
  {$DEFINE COMPILER_2_UP}
  {$DEFINE COMPILER_3_UP}
  {$DEFINE COMPILER_4_UP}
  {$DEFINE COMPILER_5_UP}
  {$DEFINE COMPILER_6_UP}
  {$DEFINE COMPILER_7_UP}
  {$DEFINE COMPILER_8_UP}
  {$DEFINE COMPILER_9_UP}
  {$DEFINE COMPILER_10_UP}
{$ENDIF}


{$IFDEF COMPILER_6_UP}
{$DEFINE SUPPORTS_ENUMVALUE}
{$DEFINE SUPPORTS_VARARGS}
{$ENDIF COMPILER_6_UP}

//------------------------------------------------------------------------------
// Compiler Settings
//------------------------------------------------------------------------------

{$A+}
(* The $A directive controls alignment of fields in record types.

   In the {$A+} state, fields in record types that are declared without the
   packed modifier are aligned. In the {$A-} state, fields in record types
   are never aligned. Record type field alignment is described in the Object
   Pascal Language Guide.

   Regardless of the state of the $A directive, variables and typed constants
   are always aligned for optimal access. In the {$A+} state, execution
   will be faster. *)

{$B-}
(* The $B directive switches between the two different models of code
   generation for the and and or Boolean operators.

   In the {$B+} state, the compiler generates code for complete Boolean
   expression evaluation. This means that every operand of a Boolean
   expression built from the and and or operators is guaranteed to be
   evaluated, even when the result of the entire expression is already known.

   In the {$B-} state, the compiler generates code for short-circuit Boolean
   expression evaluation, which means that evaluation stops as soon as the
   result of the entire expression becomes evident in left to right order
   of evaluation. *)

{$H+}
(* The $H directive controls the meaning of the reserved word string when
   used alone in a type declaration. The generic type string can represent
   either a long, dynamically-allocated string (the fundamental type AnsiString)
   or a short, statically-allocated string (the fundamental type ShortString).

   By default {$H+}, Delphi defines the generic string type to be the long
   AnsiString. All components in the Visual Component Library are compiled
   in this state. If you write components, they should also use long strings,
   as should any code that receives data from VCL string-type properties.

   The {$H-} state is mostly useful for using code from versions of Object
   Pascal that used short strings by default. You can locally override the
   meaning of string-type definitions to ensure generation of short strings.
   You can also change declarations of short string types to string[255] or
   ShortString, which are unambiguous and independent of the $H setting. *)

{$J-}
(* The $J directive controls whether typed constants can be modified or not.
   In the {$J+} state, typed constants can be modified, and are in essence
   initialized variables. In the {$J-} state, typed constants are truly
   constant, and any attempt to modify a typed constant causes the compiler
   to report an error. *)

{$T+}
(* The $T directive controls the types of pointer values generated by the
   @ operator and the compatibility of pointer types.

   In the {$T-} state, the result of the @ operator is always an untyped
   pointer (Pointer) that is compatible with all other pointer types.
   When @ is applied to a variable reference in the {$T+} state, the result
   is a typed pointer that is compatible only with Pointer and with other
   pointers to the type of the variable. *)

{$IFDEF COMPILER_6_UP}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{$ENDIF}
(* Disables platform warnings for Delphi 6. *)

{$IFDEF COMPILER_7_UP}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$ENDIF}
(* Disables .NET warnings for Delphi 7. *)

{$X+}
(* The $X directive enables or disables Delphi's extended syntax. *)

{ }

