{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 28, 2003                                                  }
{                                                                      }
{    The Initial Developer of the Original Code is Mark Ericksen.      }
{    Portions created by Mark Ericksen Copyright (C) 2002, 2003        }
{    Mark Ericksen, United States of America.                          }
{    Rights Reserved.                                                  }
{                                                                      }
{    Contributor(s):                                                   }
{                                                                      }
{**********************************************************************}

{$I dws2.inc}

unit dws2PasGenerator;

interface

{ NOTE: dws2Symbols must be declared *after* TypeInfo. They both have a
        TMethodType types defined and the compiler can get confused.}
uses SysUtils, Classes, Windows, dws2Comp, TypInfo, dws2Symbols,
  dws2Exprs, Contnrs;

const
  cnstLocalUnitTableName = 'SymbolTable';

type
  TCodeGenOption = (coVarDeclaration, coOnlyNeededParams, coScriptCall,
                    coVarAssign, coVarRevAssign, coAssertWrappedObj,
                    coCreateWrapperCall, coIncludeCommentTags, coEmptyOnly);
  TCodeGenOptions = set of TCodeGenOption;

  Tdws2PascalCodeGenerator = class;

  TOnBuildSymbolEvent = procedure(Sender: Tdws2PascalCodeGenerator; ASymbol: TSymbol;
                                  const TableAddStmt: string; NewCode, NewVars: TStrings) of object;

  TFuncExecuteStyle = (esOnEval,           // Tdws2Unit function/method OnEval event
                       esOnAssignExtObj,   // Tdws2Unit method OnAssignExternalObject
                       esInternalFunc,     // style used for TInternalFunction object
                       esAnonymousFunc);   // style used for TAnonymousMethod/TAnonymousFunction objects

  TTypeReference = class(TObject)
  private
    FCount: Integer;
    FTypeSymbol: TSymbol;
  public
    constructor Create(ATypeSymbol: TSymbol);
    property TypeSymbol: TSymbol read FTypeSymbol write FTypeSymbol;
    property Count: Integer read FCount write FCount;
  end;

  TTypeReferences = class(TObject)
  private
    FList: TObjectList;
    FMaxCount: Integer;
    function GetItem(Index: Integer): TTypeReference;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    { Load the symbol references from the provided table. }
    procedure LoadReferencesFromTable(BaseTable: TSymbolTable);
    //
    { Adds the type or increments the count }
    function Add(ATypeSymbol: TSymbol): Integer;
    { Return the number of references recorded }
    function TypeCount(ATypeSymbol: TSymbol): Integer;
//    { Return the name to use for the variable. If not enough references }
//    function GetVarNameToUse(ATypeSymbol: TSymbol): string;
    { Return if a temporary variable is needed for the specified type symbol }
    function IsTempVarNeeded(ATypeSymbol: TSymbol): Boolean; overload;
    function IsTempVarNeeded(TypeReference: TTypeReference): Boolean; overload;
    { Return the index in the list based on search criteria }
    function IndexOf(TypeSymbol: TSymbol): Integer; overload;
    function IndexOf(TypeReference: TTypeReference): Integer; overload;
    { Return the TypeReference object with a matching TypeSymbol }
    function FindTypeReference(ATypeSymbol: TSymbol): TTypeReference;
    //
    { Threshold for references before a temporary variable is needed. }
    property MaxReferenceCount: Integer read FMaxCount write FMaxCount;
    { Provide read-only access to the items }
    property Items[Index: Integer]: TTypeReference read GetItem; default;
  end;

  Tdws2PascalCodeGenerator = class(TComponent)
  private
    FOptions: TCodegenOptions;
    FInitCode: TStrings;
    FImplCode: TStrings;
    FIntfCode: TStrings;
    FClassImpl: TStrings;
    FClassDecl: TStrings;
    //
    FIntfUsesNeeded: TStringList;   // list of uses required for the interface section
    FImplUsesNeeded: TStringList;   // list of uses required for the implementation section
    FOnBuildSymbolEvent: TOnBuildSymbolEvent;
    FVarPrefix: string;
    //
    FTypRef: TTypeReferences;
  protected
    FForwardedClasses: TObjectList; // list of TClassSymbols that have forward declarations
    FSortedSymbolList: TList;       // list is sorted based on declaration position in script.
    FFuncExecStyle: TFuncExecuteStyle;  // style to use when creating wrapped execution
    procedure LoadForwardedClasses(ADictionary: TSymbolDictionary);
    function ClassIsForwarded(AClass: TClassSymbol): Boolean;
    procedure _UnitBuildPasClassSymbolAsForward(AClass: TClassSymbol; const TableAddStmt: string;
                                           PasCode, PasVars: TStrings; CommentDecl: Boolean);
    procedure _UnitBuildVarAssignsForExternalTypes(ADictionary: TSymbolDictionary; PasCode: TStrings);
    procedure _UnitBuildTypeVarDeclarations(VarDecl: TStrings);

    function _UnitBuildPascalCodeToUseType(ATypeSymbol: TSymbol; AForceLookup: Boolean=False): string;
    function _UnitBuildLookupSymbolCode(ATypeSymbol: TSymbol): string;
    function _UnitGetTempVarName(ATypeSymbol: TSymbol): string;
    function _UnitGetCallableFuncClassName(AFunc: TFuncSymbol): string;

    // Used when assigning a type to a tempVar
    procedure _UnitAddTempAssignIfNeeded(aSym: TSymbol; PasCode: TStrings; OverrideAssignFrom: string='');
    procedure SortSymbolsByDeclaration(ADictionary: TSymbolDictionary);

    function GetExtObjectVarName: string;

    {:Build the function/method execution code that might be used as event code as defined by options}
    procedure BuildFunctionExecutionCode(AFunc: TFuncSymbol; CodeToUse: TStrings;
                                         AsNew: Boolean; OverrideWrapType: string=''); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {:Build code to recreate the symbols in the program as a complete named unit.}
    procedure BuildPasUnitFromScript(AProg: TProgram; const AUnitName: string);
    {:Build code to recreate the symbol in the form of an InternalFunction.}
    procedure BuildPasInternalFunction(AFunc: TFuncSymbol); dynamic;
    {:Build code to execute when Tdws2Unit function is executed.}
    procedure BuildUnitComponentExecEvent(AFunc: TFuncSymbol; CodeToUse: TStrings;
                                          AsNew: Boolean; OverrideWrapType: string=''); dynamic;

    {:Builds the pascal code required to execute the function/method.}
    procedure BuildPasFunctionExecClass(AFunc: TFuncSymbol; AExecStyle: TFuncExecuteStyle); dynamic;

    { TODO : Group all Unit related methods together. Expose the protected ones. Group them all together logically. Name in more uniform way? }

    {:Builds the pascal code required to create the symbol in code}
    function BuildPasCreatedSymbol(ASearchTable: TSymbolTable; ASymbol: TSymbol;
                                   const TableAddStmt: string;
                                   PasCode, PasVars: TStrings;
                                   OwningSymbol: TSymbol = nil): string; dynamic;

    { Class methods that can be used alone without instatiating the class. }

    {:Return if a parameter variable is needed for an OnEval event}
    class function ParamVarIsNeeded(AParam: TParamSymbol): Boolean;
    {:Return the name to be used on the Event}
    class function GetFunctionEventName(const AUnitName: string; AFuncSym: TFuncSymbol): string;
    {:Return the parameter as needed in Delphi event}
    class function GetParamAsText(AParam: TParamSymbol; UseDelphiVarName: Boolean;
                                  const VarPrefix: string=''): string;
    {:Return the set of parameters needed for the wrapped call}
    class function GetFullFuncParamText(AFunc: TFuncSymbol; AProperty: TPropertySymbol;
                                        OnlyNeededParamsUseNames: Boolean;
                                        const VarPrefix: string=''): string;
    {:Build variable assignements. Assumes same names as in script definition.}
    class procedure BuildFunctionParamAssigns(AFunc: TFuncSymbol; VarsNeeded, CodeNeeded: TStrings;
                                              OnlyNeededParams, ReassignVars: Boolean;
                                              const VarPrefix: string='');
    {:Build Delphi code required to copy Delphi variable values to script ones.}
    class procedure BuildDataCopyDelphiToDWS(const ASourceName: string; ATargetSymbol: TSymbol;
                                             VarsNeeded, CodeNeeded: TStrings;
                                             const VarPrefix: string; DepthLevel: Integer = 0);
    {:Build Delphi code required to scropt variable values to Delphi ones.}
    class procedure BuildDataCopyDWSToDelphi(ASourceSymbol: TSymbol; const ATargetName: string;
                                             VarsNeeded, CodeNeeded: TStrings;
                                             const VarPrefix: string; DepthLevel: Integer = 0);
    {:Determine if a particular symbol represents a "complex" type that requires
      intermediate variables in order to operate on them for copying data, etc.}
    class function IsComplexDataType(AType: TSymbol): Boolean;

    {:Build a wrapper call (assumes exact wrapping)}
    procedure BuildWrappedScriptCall(AFunc: TFuncSymbol; VarsNeeded, CodeNeeded: TStrings;
                                    OnlyNeededParamsUseNames, WantValidityAsserts: Boolean;
                                    const OverrideWrappedObjType: string;
                                    const VarPrefix: string='');
    {:Return if a Delphi variable is needed or if a script call is needed to reference script parameter}
    class function IsDelphiParamNeeded(AParam: TParamSymbol; OnlyNeededParamsUseName: Boolean): Boolean;
    {:Used in generating Delphi variable declaration code for a function}
    class procedure BuildDelphiVarDecl(AFunc: TFuncSymbol; Strings: TStrings;
                                       OnlyNeededParams: Boolean;
       {combine this with function param junk}                                const VarPrefix: string='');

    { TODO : Code this separately }
    //class function BuildOptimizeCode(


    // class interface declarations (can be placed by user)
    property ClassDeclarations: TStrings read FClassDecl;
    // class implementation declarations (can be placed by user)
    property ClassImplementations: TStrings read FClassImpl;
    // unit interface section needs
    property InterfaceCode: TStrings read FIntfCode;
    // unit implementation section needs
    property ImplementationCode: TStrings read FImplCode;
    // unit initialization needs
    property InitializationCode: TStrings read FInitCode;

  published
    // Options used when generating code
    property Options: TCodeGenOptions read FOptions write FOptions;
    property NewVarPrefix: string read FVarPrefix write FVarPrefix;
    // EVENTS
    property OnBuildSymbol: TOnBuildSymbolEvent read FOnBuildSymbolEvent write FOnBuildSymbolEvent;
  end;

type
  TInsertOption = (ioPlaceInside, ioReplace);

{:Insert Newtext where it is looking for StartWord and StopWord to insert based
  on the TInsertOption. }
function InsertText(Strings: TStrings; const NewText, StartWord, StopWord: string; InsertOption: TInsertOption): Boolean;
{:Compare two TSymbolPosition objects for their relative positions in the script}
function CompareSymbolPositions(Item1, Item2: Pointer): Integer;

resourcestring
//  resClassParamID  = '%s_Id';
  resClassParamObj = '%s_Obj';
  resVarDeclStmt   = '  %s: %s;';        // variable declaration statement
  resVarAssignStmt = '  %s := %s;';      // variable assignement statement
  resWrappedResult = 'wrapped_Result';   // intermediate variable name for function results
//  resResult_Array  = 'Result_Array';     // intermediate variable name for array result
//  resResult_Obj    = 'Result_Obj';       // intermediate variable name for object result
//  resResult_Rec    = 'Result_Rec';    // return record value

implementation

uses
  dws2Strings, dws2IDEUtils, dws2VCLIDEUtils;

const
  DWS_VarDecl        = 'DWS_VarDecl';
  DWS_ScriptCall     = 'DWS_ScriptCall';
  DWS_VarAssign      = 'DWS_VarAssign';
  DWS_VarRevAssign   = 'DWS_VarRevAssign';

  DWS_VarDecl_START      : string = '{'+DWS_VarDecl+'}';
  DWS_VarDecl_STOP       : string = '{/'+DWS_VarDecl+'}';
  DWS_ScriptCall_START   : string = '{'+DWS_ScriptCall;     // no trailing '}'
  DWS_ScriptCall_STOP    : string = '/'+DWS_ScriptCall+'}'; // no leading '{'
  DWS_VarAssign_START    : string = '{'+DWS_VarAssign+'}';
  DWS_VarAssign_STOP     : string = '{/'+DWS_VarAssign+'}';
  DWS_VarRevAssign_START : string = '{'+DWS_VarRevAssign+'}';
  DWS_VarRevAssign_STOP  : string = '{/'+DWS_VarRevAssign+'}';

{ Local function - convert function kind to string }
function GetFuncKindName(Value: TFuncKind): string;
begin
  Result := GetEnumName(TypeInfo(TFuncKind), Integer(Value));
end;

{ Test the pointer before trying to add the text. }
procedure SafeAddToList(List: TStrings; const aText: string);
begin
 if Assigned(List) then
   List.Add(aText);
end;


{-----------------------------------------------------------------------------
  Procedure: CompareSymbolPositions
  Author:    Mark Ericksen
  Date:      29-May-2003
  Arguments: Item1, Item2: Pointer
  Result:    Integer
  Purpose:   Use to sort a list of symbol positions to reflect the declaration
             order of the script. In the SymbolTable they get out of order when
             any forwards are used.
-----------------------------------------------------------------------------}
function CompareSymbolPositions(Item1, Item2: Pointer): Integer;
begin
  Result := TSymbolPosition(Item1).ScriptPos.Pos - TSymbolPosition(Item2).ScriptPos.Pos;
end;

{-----------------------------------------------------------------------------
  Procedure: InsertText
  Author:    Mark Ericksen
  Date:      09-Nov-2002
  Arguments: var AText: string; const StartWord, StopWord: string; InsertOption: TInsertTextType
  Result:    Boolean
  Purpose:   Insert text into the provided AText string. Option to insert
             between start and stop or replace them too. It returns if a change
             was made.
-----------------------------------------------------------------------------}
function InsertText(Strings: TStrings; const NewText, StartWord, StopWord: string; InsertOption: TInsertOption): Boolean;
var
  tmpString: string;
  StartPos, EndPos: Integer;
begin
  Result := False;
  tmpString := Strings.Text;
  // if the text is placed INSIDE the search words
  if InsertOption = ioPlaceInside then
  begin
    StartPos := Pos(StartWord, tmpString) + Length(StartWord);
    EndPos := Pos(StopWord, tmpString);
  end
  // if the text will REPLACE the search words
  else
  begin
    StartPos := Pos(StartWord, tmpString);
    EndPos := Pos(StopWord, tmpString) + Length(StopWord);
  end;
  // if found the position
  if (StartPos > 0) and (EndPos > 0) then
  begin
    Delete(tmpString, StartPos, EndPos-StartPos);
    Insert(NewText, tmpString, StartPos);
    Strings.Text := tmpString;    // write back the altered text
    Result := True;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: GetFunctionEventName
  Author:    Mark Ericksen
  Date:      13-Nov-2002
  Arguments: const AUnitName: string; AFuncSym: TFuncSymbol
  Result:    string
  Purpose:   Get name of method to assign to OnEval event.
-----------------------------------------------------------------------------}
class function Tdws2PascalCodeGenerator.GetFunctionEventName(const AUnitName: string; AFuncSym: TFuncSymbol): string;

    function IsConstructor: Boolean;
    begin
      if AFuncSym is TMethodSymbol then
        Result := TMethodSymbol(AFuncSym).Kind = fkConstructor
      else
        Result := False;
    end;

begin
  Result := '';
  //dws2Unit1ClassesTMyClass2MethodsGetThatSpecialNumberEval
  { Build it the way it is when the OnEval event is double-clicked }
  { Put Unit component name at front }
  if AUnitName <> '' then
    Result := AUnitName;

  { Put class name next }
  if AFuncSym is TMethodSymbol then
  begin
    Result := Result + 'Classes' + TMethodSymbol(AFuncSym).ClassSymbol.Name;
    if IsConstructor then
      Result := Result + 'Constructors'
    else
      Result := Result + 'Methods';
  end
  else
    Result := Result + 'Functions';

  { Function name + 'AssignExternalObject' }
  if IsConstructor then
    Result := Result + AFuncSym.Name + 'AssignExternalObject'
  { Function name + 'Eval' }
  else
    Result := Result + AFuncSym.Name + 'Eval';

//  { Build it in a more readable way }
//  { Put Unit component name at front }
//  if AUnitName <> '' then
//    Result := AUnitName + '_';
//
//  { Put class name next }
//  if AFuncSym is TMethodSymbol then
//    Result := Result + TMethodSymbol(AFuncSym).ClassSymbol.Name + '_';
//
//  { Function name + 'Eval' }
//  Result := Result + AFuncSym.Name + '_Eval';
end;

{-----------------------------------------------------------------------------
  Procedure: BuildDelphiVarDecl
  Author:    Mark Ericksen
  Date:      09-Nov-2002
  Arguments: Func: Tdws2Function; Strings: TStrings; OnlyNeededParams: Boolean
  Result:    None
  Purpose:   Build Delphi compatible code for variable declarations based on
             a script defined function (or method).
-----------------------------------------------------------------------------}
class procedure Tdws2PascalCodeGenerator.BuildDelphiVarDecl(AFunc: TFuncSymbol; Strings: TStrings;
                             OnlyNeededParams: Boolean; const VarPrefix: string);
var
  i: Integer;
  param: TParamSymbol;
  UseType: string;
begin
  Assert(AFunc <> nil);
  Assert(Strings <> nil);

{ TODO -oMark : Needed if the param type is an array or enumerated type. }
  for i := 0 to AFunc.Params.Count - 1  do
  begin
    param := TParamSymbol(AFunc.Params[i]);
    // build if not limited to var params. If limited, ensure this param qualifies
    if IsDelphiParamNeeded(param, OnlyNeededParams) then
    begin
      // param is a Class
      if param.Typ is TClassSymbol then
        Strings.Add(Format(resVarDeclStmt, [Format(resClassParamObj, [param.Name]), param.Typ.Name]))
      // param is an Array (need loop counting variable)
      else if param.Typ is TArraySymbol then
      begin
        Strings.Add('  i: Integer;');
        Strings.Add(Format(resVarDeclStmt, [VarPrefix+param.Name, param.Typ.Name]));
      end
      // everything else
      else
      begin
        { Get the parameters data type. Convert the simple 'float' to a 'double'.
          This will not convert complex types of objects, records, etc. }
        if SameText(param.Typ.Name, 'Float') then
          UseType := 'Double'
        else
          UseType := param.Typ.Name;
        { Write out this parameters variable declaration }
        Strings.Add(Format(resVarDeclStmt, [VarPrefix+param.Name, UseType]));
      end;
    end;
  end; {for}
  { If function has a result, look closer at the return type }
  if Assigned(AFunc.Result) then
  begin
    // if TRecordSymbol, create temp var for it
    if AFunc.Result.Typ is TRecordSymbol then
      Strings.Add(Format(resVarDeclStmt, [resWrappedResult, AFunc.Result.Typ.Name]))
    // if TArraySymbol, create temp var for it
    else if (AFunc.Result.Typ is TStaticArraySymbol) or (AFunc.Result.Typ is TDynamicArraySymbol) then
      Strings.Add(Format(resVarDeclStmt, [resWrappedResult, AFunc.Result.Typ.Name]))
    // if TClassSymbol, create temp vars for it
    else if (AFunc.Result.Typ is TClassSymbol) and (AFunc.Kind <> fkConstructor) then
    begin
      Strings.Add(Format(resVarDeclStmt, [resWrappedResult, AFunc.Result.Typ.Name]));
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: BuildWrappedScriptCall
  Author:    Mark Ericksen
  Date:      28-Dec-2002
  Arguments: AFuncSym: TFuncSymbol; Func: Tdws2Function; Strings: TStrings; OnlyNeededParamsUseNames: Boolean; const WrappedObjType, VarPrefix: string
  Result:    None
  Purpose:   Build a call to a function that mirrors the call in the script.
             WrappedObjType is only used if the Function is a Tdws2Method.
-----------------------------------------------------------------------------}
procedure Tdws2PascalCodeGenerator.BuildWrappedScriptCall(AFunc: TFuncSymbol; VarsNeeded, CodeNeeded: TStrings;
  OnlyNeededParamsUseNames, WantValidityAsserts: Boolean;
  const OverrideWrappedObjType, VarPrefix: string);

var
  Assignment: string;        // function assignment portion of wrapped call "Value := "
  WrappedCall: string;       // qualified function being wrapped "TClass.Method" or "FunctionName" or "PropertyName"
  WrappedName: string;       // name of wrapped call (function or property)
  WrappedObjType: string;    // name of object type to use when wrapping
  typeResultSym: TSymbol;
  WrapPropertySym: TPropertySymbol;
  { remove CallWrapFormat once a better way of class handling is found }
  CallWrapFormat: string;    // workaround handling for calling functions that return a class
  AssertStmt: string;        // generated statement for assertions
begin
  Assert(Assigned(VarsNeeded) and Assigned(CodeNeeded));
  { Get result type. NOTE: This is implemented differently on a Tdws2Method
    versus a Tdws2Function (a method will return '' when calling the
    Tdws2Function version) }
  typeResultSym := nil;
  Assignment := '';
  if Assigned(AFunc.Result) then
    typeResultSym := AFunc.Result.Typ.BaseType;

  // Determine wrapped object type. If not overridden, then the same type as script class...
  WrappedObjType := '';
  if AFunc is TMethodSymbol then
    if Assigned(TMethodSymbol(AFunc).ClassSymbol) then
    begin
      if OverrideWrappedObjType = '' then
        WrappedObjType := TMethodSymbol(AFunc).ClassSymbol.Name
      else
        WrappedObjType := OverrideWrappedObjType;
    end;

  CallWrapFormat := '%s';        // default to no special handling
  // Start out the function wrapping. If a function then assign result.
  if Assigned(typeResultSym) then
  begin
    // if return type is a complex result (not a constructor), assign to temp variable
    if IsComplexDataType(typeResultSym) and (AFunc.Kind <> fkConstructor) then
    begin
      VarsNeeded.Add('  '+resWrappedResult+': '+ typeResultSym.Name +';');
      Assignment := resWrappedResult + ' := ';
    end
    else
      Assignment := 'Info.Result := ';
  end;

  WrapPropertySym := GetPropertyForSymbol(AFunc);
  // Get wrapped calling name
  if Assigned(WrapPropertySym) then         // if is a property wrapper
    WrappedName := WrapPropertySym.Name     // property wrapper
  else
    WrappedName := AFunc.Name;           // function wrapper

  { Determine the 'name' to call on the wrapped object. }

  { Specially handle method Constructors and Destructors }
  // if a constructor, create the type and assign to the event's "ExtObject"
  case AFunc.Kind of
  fkConstructor :
    begin
      Assignment := Format('%s := ', [GetExtObjectVarName]);
      WrappedCall := Format('%s.%s', [WrappedObjType, WrappedName]);
      AssertStmt := '';      // don't add assertions, ExtObject *should* be nil
    end;
  fkDestructor  :
    begin
      Assignment := '';
      WrappedCall := Format('%s.Free', [GetExtObjectVarName]);
      AssertStmt := Format('  Assert(%s<>nil);', [GetExtObjectVarName]);
    end;
  else
    if AFunc is TMethodSymbol then
    begin
      { Class methods }
      if TMethodSymbol(AFunc).IsClassMethod then
      begin
        AssertStmt := '';    // no assertion because no instance to test
        // Regular object function/procedure/property thing (may be class procedure, treated the same here)
        WrappedCall := Format('%s.%s', [WrappedObjType, WrappedName]);
      end
      { Regular methods }
      else
      begin
        AssertStmt := Format('  Assert((%s<>nil) and (%s is %s));', [GetExtObjectVarName, GetExtObjectVarName, WrappedObjType]);
        // Regular object function/procedure/property thing (may be class procedure, treated the same here)
        WrappedCall := Format('%s(%s).%s', [WrappedObjType, GetExtObjectVarName, WrappedName]);
      end;
    end
    // Not a method, call the function normally
    else
      WrappedCall := WrappedName;
  end;{case}

  { Create object assertion tests, validate external object state }
  if WantValidityAsserts and (AssertStmt <> '') then
    CodeNeeded.Add(AssertStmt);
  // return the complete wrapped function call
  CodeNeeded.Add('  ' + Assignment +
              Format(CallWrapFormat, [WrappedCall +
                                      GetFullFuncParamText(AFunc,
                                                           WrapPropertySym,
                                                           OnlyNeededParamsUseNames,
                                                           VarPrefix)
                                      ]) +
              ';'
              );

  // Handle any special result processing
  { Function result if it has one }
  if IsComplexDataType(typeResultSym) and (AFunc.Kind <> fkConstructor) then
  begin
    CodeNeeded.Add('  // Copy complex result back to script');
    // if returning a class, register the returning object
    if typeResultSym is TClassSymbol then
      CodeNeeded.Add(Format('  Info.Result := Info.RegisterExternalObject(%s);', [resWrappedResult]))
    // other complex type (array, record, etc) copy the data back to script
    else
      BuildDataCopyDelphiToDWS(resWrappedResult, typeResultSym, VarsNeeded, CodeNeeded, VarPrefix);
  end;
end;


{-----------------------------------------------------------------------------
  Procedure: IsDelphiParamNeeded
  Author:    Mark Ericksen
  Date:      25-Dec-2002
  Arguments: AParam: TParamSymbol; OnlyNeededParamsUseName: Boolean
  Result:    Boolean
  Purpose:   Return if a Delphi variable is needed or if a script call is needed
             to reference script parameter
-----------------------------------------------------------------------------}
class function Tdws2PascalCodeGenerator.IsDelphiParamNeeded(AParam: TParamSymbol; OnlyNeededParamsUseName: Boolean): Boolean;
begin
  // If all params are using Delphi variables or the param is a 'var' param then use a delphi variable.
  Result := (not OnlyNeededParamsUseName) or
            ParamVarIsNeeded(AParam) or
            (AParam.Typ is TClassSymbol);      // classes require special fetching code
end;

{-----------------------------------------------------------------------------
  Procedure: GetParamAsText
  Author:    Mark Ericksen
  Date:      13-Nov-2002
  Arguments: AParam: TParamSymbol; OnlyVarParamUsesName: Boolean; const VarPrefix: string
  Result:    string
  Purpose:   Return the Delphi event use of a script parameter.
-----------------------------------------------------------------------------}
class function Tdws2PascalCodeGenerator.GetParamAsText(AParam: TParamSymbol; UseDelphiVarName: Boolean;
  const VarPrefix: string): string;
var
  paramType: TSymbol;
begin
  Result := '';
  paramType := AParam.Typ.BaseType;
  if UseDelphiVarName then
  begin
    // if a class, pass as class
    if paramType is TClassSymbol then
      Result := Format(resClassParamObj, [AParam.Name])   // return the variable name for the class instance
    else     // regular usage
      Result := VarPrefix + AParam.Name;
  end
  else
  // If not using a Delphi variable, get the value from the script object
  begin
    { TODO -oMark : Handle records and enumerated types }
    if IsComplexDataType(paramType) then
    begin
      if paramType is TClassSymbol then
        Result := Format('(Info.GetExternalObjForVar(''%s'') as %s)', [AParam.Name, AParam.Typ.Name])
      else
        Result := Format('Info.Vars[''%s'']', [AParam.Name]);
    end
    // if an enumeration, cast it as an integer and handle it as that
    else if paramType is TEnumerationSymbol then
      Result := Format('Integer(Info[''%s''])', [AParam.Name])
    else
      // if param hasn't been added through special processing, add it here.
      Result := Format('Info[''%s'']', [AParam.Name]);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: GetFullFuncParamText
  Author:    Mark Ericksen
  Date:      13-Nov-2002
  Arguments: AFunc: TFuncSymbol; AProperty: TPropertySymbol; OnlyNeededParamsUseNames: Boolean; const VarPrefix: string
  Result:    string
  Purpose:   Turn a functions parameters into valid Delphi event code. Will
             work with wrapped functions, methods and properties.
-----------------------------------------------------------------------------}
class function Tdws2PascalCodeGenerator.GetFullFuncParamText(AFunc: TFuncSymbol;
  AProperty: TPropertySymbol; OnlyNeededParamsUseNames: Boolean;
  const VarPrefix: string): string;
var
  i: Integer;
  PropAssignText: string;   // text assigned to property for set methods
  MaxIndex: Integer;
  paramSym: TParamSymbol;
begin
  Assert(Assigned(AFunc), 'GetFullFuncParamText - AFunc is nil');
  Result := '';
  PropAssignText := '';
  MaxIndex := AFunc.Params.Count-1;  // default is to get all params in continuous list

  // Wrapping a Property call
  if Assigned(AProperty) then
  begin
    { Determine how many params to continues list. If a SetValue property then
      the last parameter is used for the wrapped property assignement. }

    // is a property write accessor
    if SymbolIsPropertyWrite(AProperty, AFunc) then
    begin
      MaxIndex := AFunc.Params.Count-2;      // don't add the last parameter (needed for assignment)
      paramSym := TParamSymbol(AFunc.Params[MaxIndex+1]);
      PropAssignText := ' := ' + GetParamAsText(paramSym,
                                                IsDelphiParamNeeded(paramSym, OnlyNeededParamsUseNames),
                                                VarPrefix);
    end;
  end;

  // cycle function's parameters
  for i := 0 to MaxIndex do
  begin
    // comma separate the params
    if i > 0 then
      Result := Result + ', ';
    paramSym := TParamSymbol(AFunc.Params[i]);
    Result := Result + GetParamAsText(paramSym,
                                      IsDelphiParamNeeded(paramSym, OnlyNeededParamsUseNames),
                                      VarPrefix);
  end;

  // If for property then param list is in '[...]'
  if Assigned(AProperty) then
  begin
    if Result <> '' then
      Result := '[' + Result + ']';
  end
  // For procedure, surround with '(...)'
  else
  begin
    // return total set of params for the function call
    if Result <> '' then
      Result := '(' + Result + ')';
  end;

  // if wrapping a property assignment (write method of property) include assignement text
  if PropAssignText <> '' then
    Result := Result + PropAssignText;
end;

{-----------------------------------------------------------------------------
  Procedure: ParamVarIsNeeded
  Author:    Mark Ericksen
  Date:      20-Nov-2002
  Arguments: AParam: TParaSymbol
  Result:    Boolean
  Purpose:   Return if the param is 'needed' to be declared as a variable.
-----------------------------------------------------------------------------}
{ TTypeReference }

constructor TTypeReference.Create(ATypeSymbol: TSymbol);
begin
  FTypeSymbol := ATypeSymbol;
  if Assigned(FTypeSymbol) then
    FCount := 1
  else
    FCount := 0;
end;

{ TTypeReferences }

function TTypeReferences.Add(ATypeSymbol: TSymbol): Integer;
var
  ref: TTypeReference;
begin
  if Assigned(ATypeSymbol) then
  begin
    ref := FindTypeReference(ATypeSymbol);
    if not Assigned(ref) then
      FList.Add(TTypeReference.Create(ATypeSymbol))
    else
      ref.Count := ref.Count + 1;
  end;
end;

procedure TTypeReferences.Clear;
begin
  FList.Clear;
end;

constructor TTypeReferences.Create;
begin
  FList := TObjectList.Create(True);
  FMaxCount := 3;
end;

destructor TTypeReferences.Destroy;
begin
  FList.Free;
  inherited; 
end;

function TTypeReferences.FindTypeReference(ATypeSymbol: TSymbol): TTypeReference;
var
  idx: Integer;
begin
  idx := IndexOf(ATypeSymbol);
  if idx = -1 then
    Result := nil
  else
    Result := TTypeReference(FList[idx]);
end;

function TTypeReferences.IndexOf(TypeSymbol: TSymbol): Integer;
var
  i: Integer;
begin
  { Cycle the list. Find the first TypeReference that has the matching TypeSymbol }
  Result := -1;
  for i := 0 to FList.Count - 1 do
  begin
    if TTypeReference(FList[i]).TypeSymbol = TypeSymbol then
    begin
      Result := i;
      Break;
    end; 
  end;
end;

function TTypeReferences.IndexOf(TypeReference: TTypeReference): Integer;
begin
  Result := FList.IndexOf(TypeReference);
end;

function TTypeReferences.IsTempVarNeeded(ATypeSymbol: TSymbol): Boolean;
begin
  // look up type reference object first, then return if tempVar is needed
  Result := IsTempVarNeeded(FindTypeReference(ATypeSymbol));
end;

function TTypeReferences.IsTempVarNeeded(TypeReference: TTypeReference): Boolean;
begin
  // return if the references to the type are more than the threshold.
  if Assigned(TypeReference) then
    Result := TypeReference.Count > MaxReferenceCount
  else
    Result := False;
end;

procedure TTypeReferences.LoadReferencesFromTable(BaseTable: TSymbolTable);
var
  i: Integer;
  sym: TSymbol;
begin
  for i := 0 to BaseTable.Count - 1 do
  begin
    sym := BaseTable.Symbols[i];
    if not (sym is TUnitSymbol) then
    begin
      // if a variable, use the symbols type. If not a variable, the symbol is the type
      if sym is TValueSymbol then
        Self.Add(sym.Typ)
      else
      begin
        // Recurse into symbols that have their own tables
        if sym is TFuncSymbol then
        begin
          LoadReferencesFromTable(TFuncSymbol(sym).Params);
          Self.Add(TFuncSymbol(sym).Typ);    // add function result type
        end
        else if sym is TClassSymbol then
          LoadReferencesFromTable(TClassSymbol(sym).Members)
        else if sym is TRecordSymbol then
          LoadReferencesFromTable(TRecordSymbol(sym).Members)
        else if sym is TEnumerationSymbol then
          LoadReferencesFromTable(TEnumerationSymbol(sym).Elements);

        // Always add the symbol
        Self.Add(sym);
      end;
    end;
  end;
end;

function TTypeReferences.TypeCount(ATypeSymbol: TSymbol): Integer;
var
  ref: TTypeReference;
begin
  ref := FindTypeReference(ATypeSymbol);
  if Assigned(ref) then
    Result := ref.Count
  else
    Result := 0;
end;

function TTypeReferences.Count: Integer;
begin
  Result := FList.Count;
end;

function TTypeReferences.GetItem(Index: Integer): TTypeReference;
begin
  Result := TTypeReference(FList[Index]);
end;

{ Tdws2PascalCodeGenerator }

procedure Tdws2PascalCodeGenerator.BuildPasFunctionExecClass(AFunc: TFuncSymbol;
  AExecStyle: TFuncExecuteStyle);
var
  useClassName: string;
  funcCode: TStringList;
begin
  funcCode := TStringList.Create;
  try
    // Implementation logic (no params needed for implementation - make identical)
    funcCode.Add('begin');     // build as a stub to be completed in BuildFunctionExecutionCode()
    funcCode.Add('end;');
    FFuncExecStyle := AExecStyle;
    BuildFunctionExecutionCode(AFunc, funcCode, True);

    if FFuncExecStyle = esAnonymousFunc then
    begin
        { TODO -oMark :
  Remove the 'type' section declaration after reworking to put in the adapter script.
  Expose the result text in a string list... script would do...
  if TypeDeclarations.Count > 0 then
  begin
    Send('type');
    for i := 0 to TypeDeclarations.Count - 1 do
      Send(TypeDeclarations[i]);
  end; }
      { Build class declaration }
      useClassName := _UnitGetCallableFuncClassName(AFunc);
      // create type declaration for handling symbol execute events
      if AFunc is TMethodSymbol then
      begin
        FClassDecl.Add(Format('  %s = class(TAnonymousMethod, ICallable)', [useClassName]));
        FClassDecl.Add(       '    procedure Execute(var ExternalObject: TObject); override;');
      end
      else // regular function
      begin
        FClassDecl.Add(Format('  %s = class(TAnonymousFunction, ICallable)', [useClassName]));
        FClassDecl.Add(       '    procedure Execute; override;');
      end;
    //  IntfCode.Add(       '    procedure Initialize;');
    //  IntfCode.Add(       '    function Optimize(Expr: TExprBase): TExprBase;');
      FClassDecl.Add(       '  end;');
      FClassDecl.Add(       '');
      //
      FClassImpl.Add(Format('procedure %s.Execute;', [useClassName]));
      FClassImpl.AddStrings(funcCode);
      FClassImpl.Add('');   // add a separation space
    end
    else if FFuncExecStyle = esInternalFunc then
    begin
      { TODO -oMark : Move/convert internal function generation to be here. }
    end;
  finally
    funcCode.Free;
  end;
end;

function Tdws2PascalCodeGenerator.BuildPasCreatedSymbol(ASearchTable: TSymbolTable;
     ASymbol: TSymbol; const TableAddStmt: string;
     PasCode, PasVars: TStrings; OwningSymbol: TSymbol): string;

     procedure AddCreateComment(aSym: TSymbol);
     begin
        // Insert comment that documents symbol being added (scipt declaration style)
        SafeAddToList(PasCode, '');     // blank line for grouping
        SafeAddToList(PasCode, '  // '+SymbolToText(nil, aSym, [], [], nil));
     end;

const
  tempClassVar: string = 'ClassSym';
var
  i: Integer;
  tmpStr: string;
begin
  // TRecordSymbol
  if ASymbol is TRecordSymbol then
  begin
    AddCreateComment(ASymbol);
    SafeAddToList(PasVars,        '  rec: TRecordSymbol;');
    SafeAddToList(PasCode, Format('  rec := TRecordSymbol.Create(''%s'');', [ASymbol.Name]));
    SafeAddToList(PasCode, Format(TableAddStmt, ['rec']));
    _UnitAddTempAssignIfNeeded(ASymbol, PasCode, 'rec');
    // Add record members
    for i := 0 to TRecordSymbol(ASymbol).Members.Count - 1 do
      BuildPasCreatedSymbol(ASearchTable, TRecordSymbol(ASymbol).Members[i],
                            '  rec.AddMember(%s);', PasCode, PasVars, ASymbol);
  end
  // TDynamicArraySymbol
  else if ASymbol is TDynamicArraySymbol then
  begin
    AddCreateComment(ASymbol);
    SafeAddToList(PasCode, Format(TableAddStmt, [Format('TDynamicArraySymbol.Create(''%s'', %s);',
                                                        [ASymbol.Name,
                                                         _UnitBuildPascalCodeToUseType(ASymbol.Typ)])]));
    _UnitAddTempAssignIfNeeded(ASymbol, PasCode);
  end
  // TStaticArraySymbol
  else if ASymbol is TStaticArraySymbol then
  begin
    AddCreateComment(ASymbol);
    SafeAddToList(PasCode, Format(TableAddStmt, [Format('TStaticArraySymbol.Create(''%s'', %d, %d, %s);',
                                                        [ASymbol.Name,
                                                         TStaticArraySymbol(ASymbol).LowBound,
                                                         TStaticArraySymbol(ASymbol).Highbound,
                                                         _UnitBuildPascalCodeToUseType(ASymbol.Typ)])]));
    _UnitAddTempAssignIfNeeded(ASymbol, PasCode);
  end
  // TMemberSymbol (of record)
  else if ASymbol is TMemberSymbol then
  begin
    // 90% rule. Most records will have simple field types. This is sufficient for them
    { TODO -oMark : Could extend to operate for members of TClassSymbol and TRecordSymbol types. Would need to recurse other record symbols. }
    if OwningSymbol is TRecordSymbol then
      SafeAddToList(PasCode, Format(TableAddStmt, [Format('TMemberSymbol.Create(''%s'', %s)',
                                                          [ASymbol.Name,
                                                           _UnitBuildPascalCodeToUseType(ASymbol.Typ)])]));
  end
  // TClassSymbol
  else if ASymbol is TClassSymbol then
  begin
    SafeAddToList(PasVars, Format(resVarDeclStmt, [tempClassVar, ASymbol.ClassName]));

    // Create symbol and initialize
    AddCreateComment(ASymbol);
    // if forwarded, get the forwarded symbol, else create it new
    if ClassIsForwarded(TClassSymbol(ASymbol)) then
    begin
      SafeAddToList(PasCode, Format(resVarAssignStmt, [tempClassVar, _UnitBuildPascalCodeToUseType(ASymbol)]));
      SafeAddToList(PasCode, Format('  %s.IsForward := False;', [tempClassVar])); // the class is NOT a forward
    end
    else   // no forward, create new
    begin
      SafeAddToList(PasCode, Format('  %s := %s.Create(''%s'');', [tempClassVar, ASymbol.ClassName, ASymbol.Name]));
      SafeAddToList(PasCode, Format(TableAddStmt, [tempClassVar]));
      _UnitAddTempAssignIfNeeded(ASymbol, PasCode, tempClassVar);
    end;
    // find ancestor symbol
    SafeAddToList(PasCode, Format('  %s.InheritFrom(%s);', [tempClassVar, _UnitBuildPascalCodeToUseType(TClassSymbol(ASymbol).Parent)]));
    // Add all Fields
    SafeAddToList(PasCode,        '  // Fields');
    for i := 0 to TClassSymbol(ASymbol).Members.Count - 1 do
    begin
      if TClassSymbol(ASymbol).Members[i] is TFieldSymbol then
        BuildPasCreatedSymbol(ASearchTable, TClassSymbol(ASymbol).Members[i],
                              '  '+tempClassVar+'.AddField(%s);',
                              PasCode, PasVars, ASymbol);
    end;
    // Add Methods
    SafeAddToList(PasCode,        '  // Methods');
    for i := 0 to TClassSymbol(ASymbol).Members.Count - 1 do
    begin
      if TClassSymbol(ASymbol).Members[i] is TMethodSymbol then
        BuildPasCreatedSymbol(ASearchTable, TClassSymbol(ASymbol).Members[i],
                              '  '+tempClassVar+'.AddMethod(%s);',
                              PasCode, PasVars, ASymbol);
    end;
    // Add Properties (search for Read/Write within class member table
    SafeAddToList(PasCode,        '  // Properties');
    for i := 0 to TClassSymbol(ASymbol).Members.Count - 1 do
    begin
      if TClassSymbol(ASymbol).Members[i] is TPropertySymbol then
      begin
        BuildPasCreatedSymbol(ASearchTable, TClassSymbol(ASymbol).Members[i],
                              '  '+tempClassVar+'.AddProperty(%s);',
                              PasCode, PasVars, ASymbol);
        // if property is class default property, register it as such
        if TClassSymbol(ASymbol).DefaultProperty = TClassSymbol(ASymbol).Members[i] then
          SafeAddToList(PasCode, Format('  %s.DefaultProperty := %s.Members.FindLocal(''%s'');', [tempClassVar, tempClassVar, TClassSymbol(ASymbol).DefaultProperty.Name]));
      end;
    end;
  end
  // TFieldSymbol (of class)
  else if ASymbol is TFieldSymbol then
  begin
    // 90% rule. Most fields will have simple field types. This is sufficient for them
    if OwningSymbol is TClassSymbol then
    begin
      AddCreateComment(ASymbol);
      SafeAddToList(PasCode, Format(TableAddStmt, [Format('TFieldSymbol.Create(''%s'', %s)',
                                                          [ASymbol.Name,
                                                           _UnitBuildPascalCodeToUseType(ASymbol.Typ)])]));
    end;
  end
  // TPropertySymbol (of class)
  else if ASymbol is TPropertySymbol then
  begin
    // only add if in context of a class
    if (OwningSymbol is TClassSymbol) then
    begin
      AddCreateComment(ASymbol);
      SafeAddToList(PasVars,        '  prop: TPropertySymbol;');
      SafeAddToList(PasCode, Format('  prop := TPropertySymbol.Create(''%s'', %s);', [ASymbol.Name, _UnitBuildPascalCodeToUseType(ASymbol.Typ)]));
      // Add property symbol to class
      SafeAddToList(PasCode, Format(TableAddStmt, ['prop']));
      // Add property ArrayIndices
      for i := 0 to TPropertySymbol(ASymbol).ArrayIndices.Count - 1 do
      begin
        {NOTE: This is the 90% rule. This only builds simple type creation.
               More complex types that need more configuration after
               creation are not done here. For 90%+ uses this is sufficient. }
        BuildPasCreatedSymbol(ASearchTable, TPropertySymbol(ASymbol).ArrayIndices[i],
                              '  prop.ArrayIndices.AddSymbol(%s);',
                              PasCode, PasVars, ASymbol);
      end;
      // Add read/write symbols
      if Assigned(TPropertySymbol(ASymbol).ReadSym) then
        SafeAddToList(PasCode, Format('  prop.ReadSym := ClassSym.Members.FindLocal(''%s'');', [TPropertySymbol(ASymbol).ReadSym.Name]));
      if Assigned(TPropertySymbol(ASymbol).WriteSym) then
        SafeAddToList(PasCode, Format('  prop.WriteSym := ClassSym.Members.FindLocal(''%s'');', [TPropertySymbol(ASymbol).WriteSym.Name]));
    end;
  end
  // TMethodSymbol (before TFuncSymbol, TMethodSymbol is a TFuncSymbol descendant)
  else if ASymbol is TMethodSymbol then
  begin
    // only add in context of a class
    if OwningSymbol is TClassSymbol then
    begin
      { TODO -oMark : NOTE: Create needs to be different for class methods. Nil passed as class symbol? }
      AddCreateComment(ASymbol);
      SafeAddToList(PasVars,          '  meth: TMethodSymbol;');
      SafeAddToList(PasCode, Format(  '  meth := TMethodSymbol.Create(''%s'', %s, %s);',
                                    [ASymbol.Name,
                                     GetFuncKindName(TMethodSymbol(ASymbol).Kind),
                                     tempClassVar]));
      SafeAddToList(PasCode, Format(TableAddStmt, ['meth']));
      // method result type
      if TMethodSymbol(ASymbol).Typ = nil then
        SafeAddToList(PasCode,        '  meth.Typ := nil;')
      else
        SafeAddToList(PasCode, Format('  meth.Typ := %s;', [_UnitBuildPascalCodeToUseType(ASymbol.Typ)]));
      // Add parameters to function
      for i := 0 to TMethodSymbol(ASymbol).Params.Count - 1 do
      begin
        BuildPasCreatedSymbol(ASearchTable, TMethodSymbol(ASymbol).Params[i],
                                      '  meth.AddParam(%s);', PasCode, PasVars, ASymbol);
      end;
      // Add method attributes
      SafeAddToList(PasCode, Format(  '  meth.IsAbstract := %s;', [BoolToStr(TMethodSymbol(ASymbol).IsAbstract)]));
      SafeAddToList(PasCode, Format(  '  meth.IsVirtual := %s;', [BoolToStr(TMethodSymbol(ASymbol).IsVirtual)]));
      if TMethodSymbol(ASymbol).IsOverride then
        SafeAddToList(PasCode, Format('  meth.SetOverride(ClassSym.Parent.Members.FindSymbol(''%s'') as TMethodSymbol);', [TMethodSymbol(ASymbol).ParentMeth.Name]));
      if TMethodSymbol(ASymbol).IsOverlap then
        SafeAddToList(PasCode, Format('  meth.SetOverlap(ClassSym.Parent.Members.FindSymbol(''%s'') as TMethodSymbol);', [TMethodSymbol(ASymbol).ParentMeth.Name]));
      // Assign implementation interface
      SafeAddToList(PasCode, Format(  '  %s.Create(meth);',
                                    [_UnitGetCallableFuncClassName(TMethodSymbol(ASymbol))]));
    end;
  end
  // TFuncSymbol (not method)
  else if ASymbol is TFuncSymbol then
  begin
    AddCreateComment(ASymbol);
    SafeAddToList(PasVars,          '  func: TFuncSymbol;');
    SafeAddToList(PasCode, Format(  '  func := TFuncSymbol.Create(''%s'', %s, 0);', [ASymbol.Name, GetFuncKindName(TFuncSymbol(ASymbol).Kind)]));
    SafeAddToList(PasCode, Format(TableAddStmt, ['func']));
    // function result type
    if TFuncSymbol(ASymbol).Typ = nil then
      SafeAddToList(PasCode,        '  func.Typ := nil;')
    else
      SafeAddToList(PasCode, Format('  func.Typ := %s;', [_UnitBuildPascalCodeToUseType(ASymbol.Typ)]));
    // Add parameters to function
    for i := 0 to TFuncSymbol(ASymbol).Params.Count - 1 do
      BuildPasCreatedSymbol(ASearchTable, TFuncSymbol(ASymbol).Params[i],
                                    '  func.AddParam(%s);', PasCode, PasVars, ASymbol);
    // Assign implementation interface
    SafeAddToList(PasCode, Format(  '  %s.Create(func);',
                  [_UnitGetCallableFuncClassName(TFuncSymbol(ASymbol))]));
  end
  // TParamSymbol & TVarParamSymbol
  else if ASymbol is TParamSymbol then
  begin
    // add if in context of a function/method or a property (array property)
    if (OwningSymbol is TFuncSymbol) or (OwningSymbol is TPropertySymbol) then
    begin
      if ASymbol is TVarParamSymbol then
        tmpStr := Format('TVarParamSymbol.Create(''%s'', %s, %s)', [ASymbol.Name, _UnitBuildPascalCodeToUseType(ASymbol.Typ), BoolToStr(TVarParamSymbol(ASymbol).IsWritable)])
      else
        tmpStr := Format('TParamSymbol.Create(''%s'', %s)', [ASymbol.Name, _UnitBuildPascalCodeToUseType(ASymbol.Typ)]);
      // if has default value (need temp variable)
      if Length(TParamSymbol(ASymbol).DefaultValue) > 0 then
      begin
        SafeAddToList(PasVars,        '  parm: TParamSymbol;');
        SafeAddToList(PasCode, Format('  parm := %s;', [tmpStr]));
        SafeAddToList(PasCode, Format('  parm.SetDefault(%s);', [VariantToStr(TParamSymbol(ASymbol).DefaultValue)]));
        SafeAddToList(PasCode, Format(TableAddStmt, ['parm']));
      end
      else // don't need temp variable, add directly
        SafeAddToList(PasCode, Format(TableAddStmt, [tmpStr]));
    end;
  end
  // TEnumerationSymbol
  else if ASymbol is TEnumerationSymbol then
  begin
    AddCreateComment(ASymbol);
    SafeAddToList(PasVars,        '  enum: TEnumerationSymbol;');
    SafeAddToList(PasCode, Format('  enum := TEnumerationSymbol.Create(''%s'', %s);',
                                  [ASymbol.Name,
                                   _UnitBuildPascalCodeToUseType(ASearchTable.FindSymbol(SYS_INTEGER) as TTypeSymbol)])); // build code to find the integer symbol
    SafeAddToList(PasCode, Format(TableAddStmt, ['enum']));
    _UnitAddTempAssignIfNeeded(ASymbol, PasCode, 'enum');
    // Add elements
    for i := 0 to TEnumerationSymbol(ASymbol).Elements.Count - 1 do
      BuildPasCreatedSymbol(ASearchTable, TEnumerationSymbol(ASymbol).Elements[i],
                            '  enum.AddElement(%s);', PasCode, PasVars, ASymbol);
  end
  // TElementSymbol (of Enumeration)
  else if (ASymbol is TElementSymbol) then
  begin
    // Only add in context of an Enumeration symbol. Otherwise do not add.
    if OwningSymbol is TEnumerationSymbol then
      SafeAddToList(PasCode, Format(TableAddStmt, [Format('TElementSymbol.Create(''%s'', %s, %d, %s)',
                                                          [ASymbol.Name, _UnitBuildPascalCodeToUseType(ASymbol.Typ),
                                                           Integer(TElementSymbol(ASymbol).Data[0]),
                                                           BoolToStr(TElementSymbol(ASymbol).IsUserDef)])]));
  end
  // TConstSymbol (After TElementSymbol because it is an ancestor of elements)
  else if ASymbol is TConstSymbol then
  begin
    Assert(Length(TConstSymbol(ASymbol).Data) > 0);
    AddCreateComment(ASymbol);
    SafeAddToList(PasCode, Format(TableAddStmt, [Format('TConstSymbol.Create(''%s'', %s, %s)',
                                                        [ASymbol.Name,
                                                         _UnitBuildPascalCodeToUseType(ASymbol.Typ),
                                                         VariantToStr(TConstSymbol(ASymbol).Data[0])])]));
    _UnitAddTempAssignIfNeeded(ASymbol, PasCode);
  end
  // All other types
  else
  begin
    // all simple types that don't require special handling
    AddCreateComment(ASymbol);
    SafeAddToList(PasCode, Format(TableAddStmt, [Format('%s.Create(''%s'', %s)',
                                                        [ASymbol.ClassName,
                                                         ASymbol.Name,
                                                         _UnitBuildPascalCodeToUseType(ASymbol.Typ)])
                                                ]));
    _UnitAddTempAssignIfNeeded(ASymbol, PasCode);
  end;

  if Assigned(FOnBuildSymbolEvent) then
    FOnBuildSymbolEvent(Self, ASymbol, TableAddStmt, PasCode, PasVars);
end;

{-----------------------------------------------------------------------------
  Procedure: Tdws2PascalCodeGenerator.BuildPasUnitFromScript
  Author:    Mark Ericksen
  Date:      07-Mar-2003
  Arguments: AProg: TProgram; AUnitName: string
  Result:    None
  Purpose:   Generate Delphi code to create the symbols in the program but as
             static symbols available to the script and that wrap external types.
             This generates code only for symbols that are not in units. (script defined)
-----------------------------------------------------------------------------}
procedure Tdws2PascalCodeGenerator.BuildPasUnitFromScript(
  AProg: TProgram; const AUnitName: string);
const
  cnstUnitAddStmt = '  '+cnstLocalUnitTableName+'.AddSymbol(%s);';
var
  i: Integer;
  sym: TSymbol;
  UnitProcName: string;
  ProcVars,                 // 'var' declarations needed for the symbols to be created
  ProcImpl: TStringList;    // implementation code for creating symbols

begin
  Assert(Assigned(AProg));

  FFuncExecStyle := esAnonymousFunc;

  { Build a separate list of symbols sorted by declaration position in the script.
    It is irrespective of position of any forwards. }
  SortSymbolsByDeclaration(AProg.SymbolDictionary);

  { Determine which classes have forward declarations }
  //LoadForwardedSymbols(AProg.SymbolDictionary); //Others include functions. Recreate it as specified.
  LoadForwardedClasses(AProg.SymbolDictionary);

  { Cycle the program's top-level symbols. Count the number of references made
    to each one. }
  FTypRef.LoadReferencesFromTable(AProg.Table);

  ProcImpl := TStringList.Create;
  ProcVars := TStringList.Create;
  try
    ProcVars.Sorted := True;
    ProcVars.Duplicates := dupIgnore;               // ignore duplicates
    // Get name of procedure to create and register
    UnitProcName := Format('Create%sSymbols', [AUnitName]);

    // Generate variable declarations for types that will have temporary variables
    _UnitBuildTypeVarDeclarations(ProcVars);

    // Build variable assigns for symbols not declared in the script
    _UnitBuildVarAssignsForExternalTypes(AProg.SymbolDictionary, ProcImpl);

    // Build the class forwards. Cycle all forwarded classes first
    for i := 0 to FForwardedClasses.Count - 1 do
      _UnitBuildPasClassSymbolAsForward(TClassSymbol(FForwardedClasses[i]), cnstUnitAddStmt, ProcImpl, ProcVars, True);

{ TODO -omark -cForwards? : Do procedure forwards need to be created too? }

    // Cycle symbols from the sorted list so the order will be as defined in the script.
    for i := 0 to FSortedSymbolList.Count - 1 do
    begin
      sym := TSymbolPosition(FSortedSymbolList[i]).Symbol;
      if sym is TFuncSymbol then
        BuildPasFunctionExecClass(TFuncSymbol(sym), FFuncExecStyle);

      // create new unit symbol and register all with that
      if not (sym is TUnitSymbol) then    // skip unit symbols, they aren't being created here.
        BuildPasCreatedSymbol(AProg.Table, sym, cnstUnitAddStmt, ProcImpl, ProcVars);
    end; {for}


    // Create AddUnitSymbols() procedure
    if ProcVars.Count > 0 then   // if has vars, add that to definition
    begin
      FImplCode.Add('var');
      FImplCode.AddStrings(ProcVars);
    end;
    FImplCode.Add('begin');
    FImplCode.AddStrings(ProcImpl);
    FImplCode.Add('end;');

  finally
    ProcVars.Free;
    ProcImpl.Free;
  end;

  // Initialization section of code
  FInitCode.Add(Format('  RegisterInternalInitProc(%s);', [UnitProcName]));
end;

procedure Tdws2PascalCodeGenerator.BuildFunctionExecutionCode(
  AFunc: TFuncSymbol; CodeToUse: TStrings; AsNew: Boolean; OverrideWrapType: string);
(* For variable declarations, should it have some unique-type script prefix?
{DWS_VarDecl}
  PowerSourceTableName : string;
  HeaderFileName       : string;
  RawDataFileName      : string;
{/DWS_VarDecl}
begin
{DWS_ScriptCall
  function <FuncName>(PowerSourceTableName: string; HeaderFileName: string; RawDataFileName: string): ReturnType;
/DWS_ScriptCall}
{DWS_ParamAssign}
  PowerSourceTableName := Info['PowerSourceTableName'];
  HeaderFileName       := Info['HeaderFileName'];
  RawDataFileName      := Info['RawDataFileName'];
{/DWS_ParamAssign}
  Wrapped Function call (may have 'var' params
{DWS_ParamAssignRev}
  Info['PowerSourceTableName'] := PowerSourceTableName;
  Info['HeaderFileName']       := HeaderFileName;
  Info['RawDataFileName']      := RawDataFileName;
{/DWS_ParamAssignRev}
Optionally clear the event code? Super warning with it and default to "No". Replace the block with "begin..end" *)

{ If a wrapper, create minimal code. Only create Var declarations for any 'var'
  parameters in the script function (assumed to mirror). Then re-assign after the call.
  Create a code wrapper that type-casts the internal object to the specified type
  and calls a function identical to the one in the script. This 'wrapped' call will not
  be updated as it stands. }
var
  NewCode,
  varsNeeded: TStringList;
  codeNeeded: TStringList;
  PreText: string;
resourcestring
  resExistingCodeReq = 'Existing code is required.';
begin
  if not Assigned(CodeToUse) then
    raise Exception.Create(resExistingCodeReq);

  NewCode := TStringList.Create;
  varsNeeded := TStringList.Create;
  codeNeeded := TStringList.Create;
  try
    varsNeeded.Sorted := True;
    varsNeeded.Duplicates := dupIgnore;

    //-------------------------------------------
    //-- Clearing existing event code          --
    //-------------------------------------------
    if coEmptyOnly in FOptions then
    begin
      { TODO : Doesn't work reliably. Trying to find where 'var' is the end of the line. }
      {$IFDEF DELPHI6up}
        {$IFDEF WINDOWS}
        // if has var section, clear it
        InsertText(ExistingCode, 'begin', 'var'#13#10, 'begin', ioReplace);
        {$ENDIF}
        {$IFDEF LINUX}
        // if has var section, clear it
        InsertText(ExistingCode, 'begin', 'var'#10, 'begin', ioReplace);
        {$ENDIF}
      {$ELSE}
        // if has var section, clear it
        InsertText(CodeToUse, 'begin', 'var'#13#10, 'begin', ioReplace);
      {$ENDIF}

      // clear the begin..end section
      NewCode.Add('begin');
      InsertText(CodeToUse, NewCode.Text+'end;', 'begin', 'end;', ioReplace);
      EXIT;     // leave, do no more code generating
    end;{if coEmptyOnly}

    //-------------------------------------------
    //-- Setting up for a NEW procedure        --
    //-------------------------------------------
    if AsNew then
    begin
      { Create Variable Declarations (if new and desired, or not new) }
      BuildFunctionParamAssigns(AFunc, VarsNeeded, CodeNeeded,
                                coOnlyNeededParams in FOptions,
                                False, FVarPrefix);

      { Create script function comment }
      if coScriptCall in FOptions then
      begin
        if coIncludeCommentTags in FOptions then
        begin
          CodeNeeded.Add(DWS_ScriptCall_START);
          PreText := '';               // nothing preceeding the line
        end
        else
          PreText := '  //';           // no block comments, preceed with a line comment
        CodeNeeded.Add(Pretext + SymbolToText(nil, AFunc, [], [coIncludeContext], nil));
        if coIncludeCommentTags in FOptions then
          CodeNeeded.Add(DWS_ScriptCall_STOP);
      end;

      { Create wrapper call }
      if coCreateWrapperCall in FOptions then
      begin
        //NewCode.Add('');
        BuildWrappedScriptCall(AFunc, VarsNeeded, CodeNeeded,
                               coOnlyNeededParams in FOptions,
                               coAssertWrappedObj in FOptions,
                               OverrideWrapType, FVarPrefix)
      end;

      { Create variable reverse assignments }
      if coVarRevAssign in FOptions then
      begin
        // if there are any vars, create var section and put the declarations in
        if varsNeeded.Count > 0 then
        begin
          if coIncludeCommentTags in FOptions then
            CodeNeeded.Add(DWS_VarRevAssign_START);
          BuildFunctionParamAssigns(AFunc, varsNeeded, codeNeeded, coOnlyNeededParams in FOptions, True, FVarPrefix);
          if coIncludeCommentTags in FOptions then
            CodeNeeded.Add(DWS_VarRevAssign_STOP);
        end;
      end;

      { Output all the assembled parts }
      // if there any vars, create var section and put the declarations in
      if varsNeeded.Count > 0 then
      begin
        NewCode.Add('var');
        if coIncludeCommentTags in FOptions then
          NewCode.Add(DWS_VarDecl_START);
        NewCode.AddStrings(varsNeeded);
        if coIncludeCommentTags in FOptions then
          NewCode.Add(DWS_VarDecl_STOP);
      end;

      { Create procedure begin marker }
      NewCode.Add('begin');

      // output the code needed for the wrapping
      if CodeNeeded.Count > 0 then
      begin
        if coIncludeCommentTags in FOptions then
          NewCode.Add(DWS_VarAssign_START);
        NewCode.AddStrings(CodeNeeded);
        if coIncludeCommentTags in FOptions then
          NewCode.Add(DWS_VarAssign_STOP);
      end;

      { Write back the NewCode (replace existing begin..end block) }
      InsertText(CodeToUse, NewCode.Text+'end;', 'begin', 'end;', ioReplace);
    end
    //-------------------------------------------
    //-- Updating an EXISTING procedure. Only update found DWS comment sections.
    //-------------------------------------------
    else
    begin
      varsNeeded.Clear;
      codeNeeded.Clear;

      // generates the VarDeclaration and VarAssign code
      BuildFunctionParamAssigns(AFunc, varsNeeded, codeNeeded, coOnlyNeededParams in FOptions, False, FVarPrefix); // var for params
      { TODO : Need vars for wrapped result if reverse assignments are needed. }

      { Update Variable Declarations }
      if coVarDeclaration in FOptions then
      begin
        if varsNeeded.Count > 0 then
        begin
          varsNeeded.Add('');    // add extra line. Helps it format better
          { TODO : Do we need to ADD the 'var' section here? }
          InsertText(CodeToUse, varsNeeded.Text, DWS_VarDecl_START, DWS_VarDecl_STOP, ioPlaceInside);
        end;
      //else
        { TODO : Remove the tagged section if NOT checked and editing a existing unit. }
      end;

      { Update script function comment }
      if coScriptCall in FOptions then
      begin
        NewCode.Clear;
        NewCode.Add('');
        NewCode.Add(SymbolToText(nil, AFunc, [], [coIncludeContext], nil));
        InsertText(CodeToUse, NewCode.Text, DWS_ScriptCall_START, DWS_ScriptCall_STOP, ioPlaceInside);
      end;

      { Update the parameter assign code }
      if coVarAssign in FOptions then
      begin
        NewCode.Clear;
        if coIncludeCommentTags in FOptions then
          NewCode.Add(DWS_VarAssign_START);
        NewCode.AddStrings(CodeNeeded);
        if coIncludeCommentTags in FOptions then
          NewCode.Add(DWS_VarAssign_STOP);
        InsertText(CodeToUse, NewCode.Text, DWS_VarAssign_START, DWS_VarAssign_STOP, ioPlaceInside);
      end;

      { NOTE: The wrapper call is not updated. It may have been altered by the user. }

      { Update variable reverse assignments }
      if coVarRevAssign in FOptions then
      begin
        varsNeeded.Clear;
        codeNeeded.Clear;
        NewCode.Clear;
        NewCode.Add('');    // add extra line. Helps it format better
        BuildFunctionParamAssigns(AFunc, varsNeeded, codeNeeded, coOnlyNeededParams in FOptions, False, FVarPrefix);
        NewCode.AddStrings(codeNeeded);
        InsertText(CodeToUse, NewCode.Text, DWS_VarRevAssign_START, DWS_VarRevAssign_STOP, ioPlaceInside);
      end;
    end;
  finally
    varsNeeded.Free;
    codeNeeded.Free;
    NewCode.Free;
  end;
end;

constructor Tdws2PascalCodeGenerator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInitCode := TStringList.Create;
  FImplCode := TStringList.Create;
  FIntfCode := TStringList.Create;
  FClassImpl := TStringList.Create;
  FClassDecl := TStringList.Create;
  //
  FIntfUsesNeeded := TStringList.Create;
  FIntfUsesNeeded.Sorted := True;
  FIntfUsesNeeded.Duplicates := dupIgnore;

  FImplUsesNeeded := TStringList.Create;
  FImplUsesNeeded.Sorted := True;
  FImplUsesNeeded.Duplicates := dupIgnore;

  FOptions := [coVarDeclaration, coOnlyNeededParams, coScriptCall,
               coVarAssign, coVarRevAssign, coAssertWrappedObj,
               coCreateWrapperCall];
  FTypRef := TTypeReferences.Create;
  FForwardedClasses := TObjectList.Create(False);
  FSortedSymbolList := TList.Create;
  FVarPrefix := 'tmp_';
end;

destructor Tdws2PascalCodeGenerator.Destroy;
begin
  FInitCode.Free;
  FImplCode.Free;
  FIntfCode.Free;
  FClassImpl.Free;
  FClassDecl.Free;
  //
  FIntfUsesNeeded.Free;
  FImplUsesNeeded.Free;
  FTypRef.Free;
  FForwardedClasses.Free;
  FSortedSymbolList.Free;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: Tdws2PascalCodeGenerator.BuildPasInternalFunction
  Author:    Mark Ericksen
  Date:      May-2003
  Arguments: AFunc: TFuncSymbol
  Result:    None
  Purpose:   Build the pascal code needed to make the function/method symbol
             usable as a TInternalFunction.
-----------------------------------------------------------------------------}
procedure Tdws2PascalCodeGenerator.BuildPasInternalFunction(AFunc: TFuncSymbol);

      // Used for params and results
      function ParamToInternalFunctionCode(ASym: TSymbol): string;
      var
        prefix: string;
        typeName: string;
      begin
        // Determine name to use for the symbol type
        if (ASym = nil) or (ASym.Typ = nil) then
          typeName := ''''''
        else if ASym.Typ is TBaseSymbol then
          typeName := 'c' + ASym.Typ.Name
        else
          typeName := Format('''%s''', [ASym.Typ.Name]);

        // Determine code to use for describing parameters
        prefix := '';
        if ASym is TParamSymbol then
        begin
          if ASym is TVarParamSymbol then
            if TVarParamSymbol(ASym).IsWritable then
              prefix := '@';     // used to indicate 'var' parameter
          Result := Format('''%s'', %s', [prefix + ASym.Name, typeName]);
        end
        // not a param, a function result
        else
          Result := typeName;          // return function return type
      end;

const
  WrappedOpts: TCodeGenOptions = [coVarDeclaration, coOnlyNeededParams,
                                  coScriptCall, coVarAssign, coVarRevAssign,
                                  coAssertWrappedObj, coCreateWrapperCall];
var
  i: Integer;
  initParams, initResult: string;
  CanOptimize: Boolean;
  WrappedExecute: TStringList;
begin
  Assert(Assigned(AFunc));
  // Can optimize function if 0 or 1 parameters
  CanOptimize := (AFunc.Params.Count <= 1);

  FFuncExecStyle := esInternalFunc;

  // Class Declaration Code
  FClassDecl.Add(Format('  T%sFunc = class(TInternalFunction)', [AFunc.Name]));
  FClassDecl.Add(       '    procedure Execute; override;');
  if CanOptimize then
    FClassDecl.Add(     '    function Optimize(FuncExpr: TExprBase): TExprBase; override;');
  FClassDecl.Add(       '  end;');
  // Alternate expression for optimized usage
  if CanOptimize then
  begin
    FClassDecl.Add(Format('  T%sExpr = class(TUnaryOpExpr)', [AFunc.Name]));
    FClassDecl.Add(       '    function Eval: Variant; override;');
    FClassDecl.Add(       '  end;');
  end;

  WrappedExecute := TStringList.Create;
  try
    // Create the empty stub.
    WrappedExecute.Add(Format('procedure T%sFunc.Execute;', [AFunc.Name]));
    WrappedExecute.Add(       'begin');
    WrappedExecute.Add(       'end;');
    BuildFunctionExecutionCode(AFunc, WrappedExecute, True);
//    BuildEventCode(UnitFunc, AFunc, WrappedExecute, True, WrappedOpts, '', '');

    // Implementation Code
    FClassImpl.Add(Format('{ T%sFunc }', [AFunc.Name]));
    FClassImpl.Add('');
    FClassImpl.AddStrings(WrappedExecute);
    // Optimization code
    if CanOptimize then
    begin
      FClassImpl.Add(Format('function T%sFunc.Optimize(FuncExpr: TExprBase): TExprBase;', [AFunc.Name]));
      FClassImpl.Add(       'begin');
      FClassImpl.Add(       '  with FuncExpr as TFuncExpr do');
      FClassImpl.Add(       '  begin');
      FClassImpl.Add(       '    if Args[0] is TConstExpr then');
      FClassImpl.Add(       '      result := TConstExpr.Create(Prog, Pos, Prog.TypInteger,');
      FClassImpl.Add(Format('        %s(Args[0].Eval)', [AFunc.Name]));
      FClassImpl.Add(       '    else');
      FClassImpl.Add(Format('      result := T%sFuncExpr.Create(Prog, Pos, Args[0]);', [AFunc.Name]));
      FClassImpl.Add(       '    Args.Clear;');
      FClassImpl.Add(       '    Free;');
      FClassImpl.Add(       '  end;');
      FClassImpl.Add(       'end;');
      FClassImpl.Add(       '');
      FClassImpl.Add(Format('function T%sFuncExpr.Eval: Variant;', [AFunc.Name]));
      FClassImpl.Add(       'begin');
      FClassImpl.Add(Format('  result := %s(Expr.Eval);', [AFunc.Name]));
      FClassImpl.Add(       'end;');
    end;

    // determine parameter text
    initParams := '';
    for i := 0 to AFunc.Params.Count - 1 do
    begin
      if i > 0 then
        initParams := initParams + ', '; 
      initParams := initParams + ParamToInternalFunctionCode(AFunc.Params[i]);
    end;
    // determine function result text
    initResult := ParamToInternalFunctionCode(AFunc.Result);

    // Assemble pieces into initialization registration code
    FInitCode.Add(Format('  RegisterInternalFunction(T%sFunc, ''%s'', [%s], %s);', [AFunc.Name, AFunc.Name, initParams, initResult]));
  finally
    WrappedExecute.Free;
  end;
end;

class function Tdws2PascalCodeGenerator.ParamVarIsNeeded(AParam: TParamSymbol): Boolean;
var
  evalTyp: TSymbol;
begin
  evalTyp := AParam.Typ.BaseType; 

  Result := (evalTyp is TRecordSymbol) or
            (evalTyp is TArraySymbol) or  // Static and Dynamic arrays
            (
             (AParam is TVarParamSymbol) and
             TVarParamSymbol(AParam).IsWritable
            );
end;

procedure Tdws2PascalCodeGenerator.LoadForwardedClasses(ADictionary: TSymbolDictionary);
var
  i: Integer;
begin
  FForwardedClasses.Clear;
  for i := 0 to ADictionary.Count - 1 do
  begin
    if ADictionary[i].Symbol is TClassSymbol then
      if Assigned(ADictionary[i].FindUsage(suForward)) then
        FForwardedClasses.Add(ADictionary[i].Symbol);  // add class to forward list
  end;
end;

function Tdws2PascalCodeGenerator.ClassIsForwarded(AClass: TClassSymbol): Boolean;
begin
  // return if the class symbol is in the list of classes with forwards
  Result := FForwardedClasses.IndexOf(AClass) > -1;
end;

procedure Tdws2PascalCodeGenerator._UnitBuildPasClassSymbolAsForward(
  AClass: TClassSymbol; const TableAddStmt: string; PasCode, PasVars: TStrings; CommentDecl: Boolean);
begin
  SafeAddToList(PasVars, Format('  ClassSym: %s;', [AClass.ClassName]));
  SafeAddToList(PasCode,        '');
  if CommentDecl then
    SafeAddToList(PasCode, Format('  // type %s = class; (forward declaration)', [AClass.Name]));
  SafeAddToList(PasCode, Format('  ClassSym := TClassSymbol.Create(''%s'');', [AClass.Name]));
  // If temp var is being used, copy the ClassSym to that
  if FTypRef.IsTempVarNeeded(AClass) then
    SafeAddToList(PasCode, Format('  %s := ClassSym;', [_UnitGetTempVarName(AClass)]));
  SafeAddToList(PasCode,        '  ClassSym.IsForward := True;');
  PasCode.Add(Format(TableAddStmt, ['ClassSym']));
end;

procedure Tdws2PascalCodeGenerator.SortSymbolsByDeclaration(ADictionary: TSymbolDictionary);
var
  i: Integer;
  symPos: TSymbolPosition;
begin
  FSortedSymbolList.Clear;
  for i := 0 to ADictionary.Count - 1 do
  begin
    symPos := ADictionary[i].FindUsage(suDeclaration);
    if Assigned(symPos) then
      FSortedSymbolList.Add(symPos);
  end;
  FSortedSymbolList.Sort(CompareSymbolPositions)
end;

procedure Tdws2PascalCodeGenerator._UnitBuildVarAssignsForExternalTypes(
  ADictionary: TSymbolDictionary; PasCode: TStrings);
var
  i: Integer;
begin
  { Build variable assignements for types declared outside of the script but are referenced
    enough to need temporary variables. }
  for i := 0 to FTypRef.Count - 1 do
    if FTypRef.IsTempVarNeeded(FTypRef[i]) then
      // if symbol not declared in script then build early fetch of symbol
      if not Assigned(ADictionary.FindSymbolUsage(FTypRef[i].TypeSymbol, suDeclaration)) then
      begin
        PasCode.Add(Format(resVarAssignStmt,
                           [_UnitGetTempVarName(FTypRef[i].TypeSymbol),
                            _UnitBuildLookupSymbolCode(FTypRef[i].TypeSymbol)]));
      end;
end;

procedure Tdws2PascalCodeGenerator._UnitBuildTypeVarDeclarations(VarDecl: TStrings);
var
  i: Integer;
begin
  { Once the list is fully loaded, this will build the pascal code to declare
    all the variable types. }
  for i := 0 to FTypRef.Count - 1 do
    if FTypRef.IsTempVarNeeded(FTypRef[i]) then
      VarDecl.Add(Format(resVarDeclStmt, [_UnitGetTempVarName(FTypRef[i].TypeSymbol),
                                       FTypRef[i].TypeSymbol.ClassName]));
end;

function Tdws2PascalCodeGenerator._UnitBuildPascalCodeToUseType(ATypeSymbol: TSymbol; AForceLookup: Boolean): string;
begin
  { Return the code needed to use the type symbol in the generated code }
  Result := '';
  if FTypRef.IsTempVarNeeded(ATypeSymbol) then
    Result := _UnitGetTempVarName(ATypeSymbol);

  // if not yet assigned, use default handling.
  if (Result = '') or AForceLookup then
    Result := _UnitBuildLookupSymbolCode(ATypeSymbol);
end;

function Tdws2PascalCodeGenerator._UnitBuildLookupSymbolCode(ATypeSymbol: TSymbol): string;
begin
  // used like "UnitTable.FindSymbol('thing') as TYPE;" The 'as' performs a type check and makes assignements valid
  Result := Format('%s.FindSymbol(''%s'') as %s', [cnstLocalUnitTableName, ATypeSymbol.Name, ATypeSymbol.ClassName]);
//  Result := Format(cnstLocalUnitTableName{'UnitTable}+'.FindSymbol(''%s'') as %s', [ATypeSymbol.Name, ATypeSymbol.ClassName]);
end;

function Tdws2PascalCodeGenerator._UnitGetTempVarName(
  ATypeSymbol: TSymbol): string;
begin
  Result := 'typ_' + ATypeSymbol.Name;
end;

procedure Tdws2PascalCodeGenerator.BuildUnitComponentExecEvent(
  AFunc: TFuncSymbol; CodeToUse: TStrings; AsNew: Boolean;
  OverrideWrapType: string);
begin
  FFuncExecStyle := esOnEval;
  BuildFunctionExecutionCode(AFunc, CodeToUse, AsNew, OverrideWrapType);
end;

function Tdws2PascalCodeGenerator.GetExtObjectVarName: string;
begin
  case FFuncExecStyle of
  esOnEval : Result := 'ExtObject';
  esAnonymousFunc : Result := 'ExternalObject';
  else
    raise Exception.Create('Execution style does not support External objects.');
  end;
end;

procedure Tdws2PascalCodeGenerator._UnitAddTempAssignIfNeeded(
  aSym: TSymbol; PasCode: TStrings; OverrideAssignFrom: string);
var
  from: string;
begin
  // if the created type needs a temp variable, assign it here.
  if FTypRef.IsTempVarNeeded(aSym) then
  begin
    if OverrideAssignFrom <> '' then
      from := OverrideAssignFrom
    else
      from := _UnitBuildPascalCodeToUseType(aSym, True);
    SafeAddToList(PasCode, Format(resVarAssignStmt, [_UnitGetTempVarName(aSym), from]));
  end;
end;

function Tdws2PascalCodeGenerator._UnitGetCallableFuncClassName(AFunc: TFuncSymbol): string;
begin
  // Get the name of the class that implements a function ICallable interface
  if AFunc is TMethodSymbol then
    Result := Format('TMeth_%s_%s', [TMethodSymbol(AFunc).ClassSymbol.Name, AFunc.Name])
  else // regular function
    Result := Format('TFunc_%s', [AFunc.Name]);
end;

{-----------------------------------------------------------------------------
  Procedure: Tdws2PascalCodeGenerator.BuildDataCopyDelphiToDWS
  Author:    Mark Ericksen
  Date:      12-Aug-2003
  Arguments: const ASourceSymbol: string; ATargetSymbol: TSymbol; VarsNeeded, CodeNeeded: TStrings; DepthLevel: Integer
  Result:    None
  Purpose:
-----------------------------------------------------------------------------}
class procedure Tdws2PascalCodeGenerator.BuildDataCopyDelphiToDWS(
  const ASourceName: string; ATargetSymbol: TSymbol;
  VarsNeeded, CodeNeeded: TStrings; const VarPrefix: string; DepthLevel: Integer);
var
  x: Integer;
  RecSym: TRecordSymbol;
  ArrSym: TStaticArraySymbol;
  targetText: string;
  loopCounter: string;
  prefixText: string;
  targetType: TSymbol;
begin
  Assert(Assigned(VarsNeeded) and Assigned(CodeNeeded));

  // Based on depth of recursion. Keep the loop variables equal.
  loopCounter := 'x'+IntToStr(DepthLevel);
  // spaces needed for indentation for nesting
  prefixText := StringOfChar(' ', DepthLevel * 2);
  // If a parameter, get the code needed to get the value. Else a 'result'
  if ATargetSymbol is TParamSymbol then
  begin
    targetText := GetParamAsText(TParamSymbol(ATargetSymbol), True, VarPrefix);
    // get the declaration type that is being assigned to
    targetType := ATargetSymbol.Typ.BaseType;
  end
  else
  begin
    targetText := 'Info.Vars[''Result'']';
    targetType := ATargetSymbol;
  end;

  // Do it as "Info['<ATargetName>'] := <ASourceName>;"

  // if a record, copy out all members individually
  if targetType is TRecordSymbol then
  begin
    RecSym := TRecordSymbol(targetType);
    { TODO -oMark -crecord assigns : Add support for records where members are records? }
    CodeNeeded.Add(Format(  prefixText+'  with %s do begin', [targetText]));
    for x := 0 to RecSym.Members.Count - 1 do
      CodeNeeded.Add(Format(prefixText+'    Member[''%s''].Value := %s.%s;', [RecSym.Members[x].Name,
                                                                ASourceName,
                                                                RecSym.Members[x].Name]));
    CodeNeeded.Add(         prefixText+'  end;');
  end
  // if an array, copy elements individually
  else if targetType is TStaticArraySymbol then
  begin
    { TODO : This needs testing. Does NOT generate compilable code. }
    { TODO : GLScene uses matrices which are multi-dimensional arrays. Need to support copying that data. }
    ArrSym := TStaticArraySymbol(targetType);
    VarsNeeded.Add(Format(  prefixText+'  %s: Integer;', [loopCounter]));
    CodeNeeded.Add(Format(  prefixText+'  with %s do', [targetText]));
    CodeNeeded.Add(Format(  prefixText+'    for %s := %d to %d do', [loopCounter, ArrSym.LowBound, ArrSym.HighBound]));
    CodeNeeded.Add(Format(  prefixText+'      Element(%s).Value := %s[%s];', [loopCounter, ASourceName, loopCounter]));
  end
  // if a DynamicArray, copy elements individually
  else if targetType is TDynamicArraySymbol then
  begin
    { TODO : This needs testing. May not be compilable code. }
    { TODO : Need to declare a "Data" variable that can be passed to SetLength. Operate on it then assign at end to script object. }
    VarsNeeded.Add(Format(  prefixText+'  %s: Integer;', [loopCounter]));
    CodeNeeded.Add(Format(  prefixText+'  with %s do', [targetText]));
    CodeNeeded.Add(         prefixText+'  begin');
    CodeNeeded.Add(Format(  prefixText+'    SetLength(Data, Length(%s)-1);', [ASourceName]));
    CodeNeeded.Add(Format(  prefixText+'    for %s := Low(Data) to High(Data) do', [loopCounter]));
    CodeNeeded.Add(Format(  prefixText+'      Data[%s] := %s[i];', [loopCounter, ASourceName]));
    CodeNeeded.Add(         prefixText+'  end;');
  end
  { TODO -oMark -cMethod Wrapper :
If parameter is an object, then it should be like this:
<objectType>(Integer(Info['param'])) or
Pointer(Integer(Info['param']))
Now as <objectType>(Info.Vars['param'].ExternalObject)
}
//  // if a TClassSymbol, make sure it is registered with DWS (ignore constructors)
//  else if (AType is TClassSymbol) then
//    CodeNeeded.Add(Format('  %s := Info.RegisterExternalObject(%s);', [ATargetName, ASourceName]))
  // everything else
  else
    CodeNeeded.Add(Format(  prefixText+resVarAssignStmt, [targetText, ASourceName]));
end;

class procedure Tdws2PascalCodeGenerator.BuildDataCopyDWSToDelphi(
  ASourceSymbol: TSymbol; const ATargetName: string;
  VarsNeeded, CodeNeeded: TStrings; const VarPrefix: string; DepthLevel: Integer);
var
  x: Integer;
  RecSym: TRecordSymbol;
  ArrSym: TStaticArraySymbol;          
  sourceText: string;
  loopCounter: string;
  prefixText: string;
  sourceType: TSymbol;
begin
  Assert(Assigned(VarsNeeded) and Assigned(CodeNeeded));

  // Based on depth of recursion. Keep the loop variables equal.
  loopCounter := 'x'+IntToStr(DepthLevel);
  // spaces needed for indentation for nesting
  prefixText := StringOfChar(' ', DepthLevel * 2);
  // If a parameter, get the code needed to get the value. Else a 'result'
  if ASourceSymbol is TParamSymbol then
  begin
    sourceText := GetParamAsText(TParamSymbol(ASourceSymbol), False, VarPrefix);
    // get the declaration type that is being assigned to
    sourceType := ASourceSymbol.Typ.BaseType;
  end
  else
    raise Exception.Create('Unexpected assignment condition.');

  // Do it as "Info['<ATargetName>'] := <ASourceName>;"

  // if a record, copy out all members individually
  if sourceType is TRecordSymbol then
  begin
    RecSym := TRecordSymbol(sourceType);
    { TODO -oMark -crecord assigns : Add support for records where members are records? }
    CodeNeeded.Add(Format(  prefixText+'  with %s do begin', [sourceText]));
    for x := 0 to RecSym.Members.Count - 1 do
      CodeNeeded.Add(Format(prefixText+'    %s.%s := Member[''%s''].Value;', [ATargetName,
                                                                   RecSym.Members[x].Name,
                                                                   RecSym.Members[x].Name]));
    CodeNeeded.Add(         prefixText+'  end;');
  end
  // if an array, copy elements individually
  else if sourceType is TStaticArraySymbol then
  begin
    ArrSym := TStaticArraySymbol(sourceType);
    VarsNeeded.Add(Format(  prefixText+'  %s: Integer;', [loopCounter]));
    CodeNeeded.Add(Format(  prefixText+'  with %s do', [sourceText]));
    CodeNeeded.Add(Format(  prefixText+'    for %s := %d to %d do', [loopCounter, ArrSym.LowBound, ArrSym.HighBound]));
    CodeNeeded.Add(Format(  prefixText+'      %s[%s] := Element(%s).Value;', [ATargetName, loopCounter, loopCounter]));
  end
  // if a DynamicArray, copy elements individually
  else if sourceType is TDynamicArraySymbol then
  begin
    { TODO : This needs testing. May not be compilable code. }
//            how to copy the elements? Build ProgramInfo? Operate on Data?
    VarsNeeded.Add(Format(  prefixText+'  %s: Integer;', [loopCounter]));
    CodeNeeded.Add(Format(  prefixText+'  with %s do', [sourceText]));
    CodeNeeded.Add(         prefixText+'  begin');
    CodeNeeded.Add(Format(  prefixText+'    SetLength(%s, Length(Data)-1);', [ATargetName]));
    CodeNeeded.Add(Format(  prefixText+'    for %s := Low(%s) to High(%s) do', [loopCounter, sourceText, sourceText]));
    CodeNeeded.Add(Format(  prefixText+'      %s[%s] := Data[%s];', [ATargetName, loopCounter, loopCounter]));
    CodeNeeded.Add(         prefixText+'  end;');
  end
  // if a TClassSymbol, make sure it is registered with DWS (ignore constructors)
  else if (ASourceSymbol is TClassSymbol) then
    CodeNeeded.Add(Format(  prefixText+'  %s := %s(%s.ExternalObject);', [ATargetName, sourceType.Name, sourceText]))
//    CodeStrings.Add(Format('  %s := Info.RegisterExternalObject(%s);', [ATargetName, ASourceName]))
  // everything else
  else
    CodeNeeded.Add(Format(  prefixText+resVarAssignStmt, [ATargetName, sourceText]));
end;

{-----------------------------------------------------------------------------
  Procedure: Tdws2PascalCodeGenerator.BuildFunctionParamAssigns
  Author:    Mark Ericksen
  Date:      09-Aug-2003
  Arguments: AFunc: TFuncSymbol; VarsNeeded, CodeNeeded: TStrings; OnlyNeededParams, ReassignVars: Boolean; const VarPrefix: string
  Result:    None
  Purpose:   Used when creating Delphi Eval event code. Create variable
             assignements to get values out of script defined parameters.
             ReassignVars causes the variable to get assigned back to the
             script assigned one. This is useful after working with the variables
             and the altered values are needed in the script. (ie. a 'var' param)
-----------------------------------------------------------------------------}
class procedure Tdws2PascalCodeGenerator.BuildFunctionParamAssigns(
  AFunc: TFuncSymbol; VarsNeeded, CodeNeeded: TStrings; OnlyNeededParams,
  ReassignVars: Boolean; const VarPrefix: string);
var
  i: Integer;
  param: TParamSymbol;
  IsVarParam: Boolean;
  dataType: TSymbol;
  delphiVarName, scriptVarName: string;
begin
  Assert(Assigned(VarsNeeded) and Assigned(CodeNeeded));

{ TODO -oMark : Needed to complete support for enumerated types. }
  { Cycle through all the parameters }
  for i := 0 to AFunc.Params.Count - 1  do
  begin
    param := (AFunc.Params[i] as TParamSymbol);
    dataType := param.Typ.BaseType;

    if param is TVarParamSymbol then
      IsVarParam := TVarParamSymbol(param).IsWritable   // 'var Param: type'
    else
      IsVarParam := False;

    delphiVarName := GetParamAsText(param, True, VarPrefix);
    scriptVarName := GetParamAsText(param, False, VarPrefix);

    // build if want all params or it is needed
    if IsDelphiParamNeeded(param, OnlyNeededParams) then
    begin
      VarsNeeded.Add('  '+delphiVarName+': '+param.Typ.Name+';'); //use Param datatype. use alias name if it is one.
      // Do it as "Info['Name'] := Variable;"
      if ReassignVars then
      begin
        // only need content for ReassignVars if it is a 'var' param
        if IsVarParam then
          BuildDataCopyDelphiToDWS(scriptVarName, param, VarsNeeded, CodeNeeded, VarPrefix);
      end
      // Do it as "Variable := Info['Name'];"
      else
        BuildDataCopyDWSToDelphi(param, delphiVarName, VarsNeeded, CodeNeeded, VarPrefix);
    end; //Only if needed
  end; {for}
end;

class function Tdws2PascalCodeGenerator.IsComplexDataType(AType: TSymbol): Boolean;
begin
  Result := (AType is TClassSymbol) or (AType is TRecordSymbol) or (AType is TArraySymbol);
end;

end.

