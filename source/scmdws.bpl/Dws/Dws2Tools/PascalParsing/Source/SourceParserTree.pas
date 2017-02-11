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

unit SourceParserTree;

interface

uses
  Classes,
  SysUtils,
{$IFDEF DELPHI6up}
  Types,
{$ELSE}
  Windows,
{$ENDIF}
  dws_mwSimplePasPar,
  dws_mwSimplePasParTypes,
  dws_mwPasLex,
  dws_mwPasLexTypes,
  dws_mwTreeList;

type
  TCodeTreeNode = class(TmwCodeTree)
  private
    FStackLevel: Integer;       // depth of the token on the tree
    FTokenKind: TptTokenKind;   // things like ptAbstract, ptAnd, ptAnsiComment, etc
    FStartPosXY: TPoint;        // point where tree node starts
    FEndPosXY: TPoint;          // point where tree node stops
    FDataPtr: Pointer;          // pointer to some data element (for users)
  public
    property StackLevel: Integer read FStackLevel write FStackLevel;
    property StartPosXY: TPoint read FStartPosXY write FStartPosXY;
    property EndPosXY: TPoint read FEndPosXY write FEndPosXY;
    property TokenKind: TptTokenKind read FTokenKind write FTokenKind;
    property DataPointer: Pointer read FDataPtr write FDataPtr;
  end;

  { fnSearchSubNodes = Search deeper in the tree
    fnSearchParentNodes = Search up from current depth to higher nodes }
  TFindNodeOption = (fnSearchSubNodes, fnSearchParentNodes);
  TFindNodeOptions = set of TFindNodeOption;
  TmwPasCodeInfoTypes = set of TmwPasCodeInfo;

  TCodeTreeMap = class
  private
    FRoot: TCodeTreeNode;
    FLexer: TmwPasLex;
    FCurrentNode: TCodeTreeNode;// current token (used when adding and leaving)
    FStackLevel: Integer;       // current stack depth
    FTotalCount: Integer;       // total count of nodes
    // shortcuts to major unit sections
    FUnitTop,
    FInterface,
    FImplementation: TCodeTreeNode;
    function CreateNewNode(CodeInfo: TmwPasCodeInfo): TCodeTreeNode;
  public
    constructor Create(ALexer: TmwPasLex);
    destructor Destroy; override;
    procedure Clear;
    { Push a token to the stack - procedures have a symbol context.
      Standard Begin..end blocks do not have a ParentSymbol. }
    procedure TokenEncounter(CodeInfo: TmwPasCodeInfo; const AData: string='');  // gets data from the Lexer
    { Pop a token off the stack }
    procedure TokenLeave;          // gets data from the Lexer
    //
    { blank ignores the string data }
    function FindNodeFrom(FromNode: TCodeTreeNode; CodeInfoType: TmwPasCodeInfo;
                          const NodeData: string; Options: TFindNodeOptions): TCodeTreeNode;
//    function FindNodeFrom(FromNode: TCodeTreeNode; CodeInfoType: TmwPasCodeInfo;
//                          const NodeData: string=''): TCodeTreeNode; overload;

    { Method search helper routines }
//---Method Declaration---
//   ciTypeDeclaration
//     ciClassType
//       ciClassMemberList
//         ciClassMethodOrProperty (level at which 'class procedure' is mapped
//           ciClassMethodHeading
//             ciClassProcedureHeading | ciClassFunctionHeading
//               ciProcedureMethodName | ciFunctionMethodName
//---ProcFunc Declaration---
//   ciInterfaceDeclaration
//     ciExportedHeading
//       ciProcedureHeading
//       ciFunctionHeading
//         ciFunctionProcedureName
//---Method/Plain Implementation---
//     ciProcedureDeclaration
//       ciProcedureMethodDeclaration | ciFunctionMethodDeclaration
//         ciObjectNameOfMethod
//         ciFunctionProcedureName
//---Type Declarations---
//   ciInterfaceDeclaration | ciDeclarationSection (when under implementation section) TokenKind = ptType
//     ciTypeSection
//       ciTypeDeclaration
//         ciTypeName
//         ciTypeKind|ciClassForward|ciClassType|
//           ciSimpleType (ciTypeKind)
//             ciEnumeratedType
//           ciStructuredType (ciTypeKind)
//             ciSetType
//           ciStructuredType (ciTypeKind)
//             ciRecordType

    // Chose not to 'overloaded' functions to better fascilitate use in DWS
    function FindParentType(FromNode: TCodeTreeNode; CodeTypes: TmwPasCodeInfoTypes;
                            const NodeData: string): TCodeTreeNode;
    function FindSubNodeType(FromNode: TCodeTreeNode; CodeTypes: TmwPasCodeInfoTypes;
                             const NodeData: string): TCodeTreeNode;

    function FindSearchableNode(FromNode: TCodeTreeNode; GoForward: Boolean): TCodeTreeNode;
    function FindFirst(RootNode: TCodeTreeNode; CodeType: TmwPasCodeInfo; const NodeData: string): TCodeTreeNode; overload;
    function FindFirst(RootNode: TCodeTreeNode; CodeTypes: TmwPasCodeInfoTypes; const NodeData: string): TCodeTreeNode; overload;
    function FindNext(FromNode, SearchRootNode: TCodeTreeNode; CodeType: TmwPasCodeInfo; const NodeData: string): TCodeTreeNode; overload;
    function FindNext(FromNode, SearchRootNode: TCodeTreeNode; CodeTypes: TmwPasCodeInfoTypes; const NodeData: string): TCodeTreeNode; overload;
    function GetDataForType(RootNode: TCodeTreeNode; CodeType: TmwPasCodeInfo): string;
    function GetDataForTypes(RootNode: TCodeTreeNode; CodeTypes: TmwPasCodeInfoTypes): string;
    function GetDataForNextType(FromNode, RootNode: TCodeTreeNode; CodeType: TmwPasCodeInfo): string;
    function CodeTypeFound(RootNode: TCodeTreeNode; CodeType: TmwPasCodeInfo): Boolean;
    //
    function FindTypeDeclaration(const ATypeName: string; CodeType: TmwPasCodeInfo; InterfaceSectionOnly: Boolean): TCodeTreeNode;
    function FindMethodDeclaration(const AClassName, AMethodName: string; InterfaceSectionOnly: Boolean=True): TCodeTreeNode;
    function FindMethodImplementation(const AClassName, AMethodName: string): TCodeTreeNode;
    function FindFuncProcDeclaration(const AName: string): TCodeTreeNode;
    function FindFuncProcImplementation(const AName: string): TCodeTreeNode;
    //
    property Root: TCodeTreeNode read FRoot write FRoot;
    property UnitSection: TCodeTreeNode read FUnitTop;
    property InterfaceSection: TCodeTreeNode read FInterface;
    property ImplementationSection: TCodeTreeNode read FImplementation;
    property TotalCount: Integer read FTotalCount;
  end;

  { Options for which node types should or should not be inlcuded.
    NOTE: Unit sections are always included. }
  TNodeIncludeOption = (ioJunk,           // include node that preceeds all 'junk' tokens (comments, spaces, control codes, etc)
                        ioComments,       // include comments
                        ioControlCodes,   // include spaces, CRLF, etc
                        ioSemiColons,     // include SemiColons
                        ioSpaces,         // include skipped spaces
                        ioVerbose,        // include higher level wrapped nodes (Not the actual declarations/etc)
                        ioSections,       // include higher level section nodes (const section, type section, etc.) should have their own nodes
                        ioInfoNodes);     // include nodes that are heirarchical without adding any real meaning
  TNodeIncludeOptions = set of TNodeIncludeOption;

  TSourceParserTree = class(TmwSimplePasPar)
  private
    FCodeNodeMap: TCodeTreeMap;
    FNodeOptions: TNodeIncludeOptions;
  protected
    procedure SkipJunk; override;
    procedure SEMICOLON; override;
    procedure AccessSpecifier; override;
    procedure AdditiveOperator; override;
    procedure ArrayConstant; override;
    procedure ArrayType; override;
    procedure AsmStatement; override;
    procedure Block; override;
    procedure CaseLabel; override;
    procedure CaseSelector; override;
    procedure CaseStatement; override;
    procedure CharString; override;
    procedure ClassField; override;
    procedure ClassForward; override;
    procedure ClassFunctionHeading; override;
    procedure ClassHeritage; override;
    procedure ClassMemberList; override;
    procedure ClassMemberType; override;
    procedure ClassMethodDirective; override;
    procedure ClassMethodHeading; override;
    procedure ClassMethodOrProperty; override;
    procedure ClassMethodResolution; override;
    procedure ClassProcedureHeading; override;
    procedure ClassProperty; override;
    procedure ClassReferenceType; override;
    procedure ClassType; override;
    procedure ClassVisibility; override;
    procedure CompoundStatement; override;
    procedure ConstantColon; override;
    procedure ConstantDeclaration; override;
    procedure ConstantEqual; override;
    procedure ConstantExpression; override;
    procedure ConstantName; override;
    procedure ConstantValue; override;
    procedure ConstantValueTyped; override;
    procedure ConstParameter; override;
    procedure ConstructorHeading; override;
    procedure ConstructorName; override;
    procedure ConstSection; override;
    procedure ContainsClause; override;
    procedure ContainsExpression; override;
    procedure ContainsIdentifier; override;
    procedure ContainsStatement; override;
    procedure DeclarationSection; override;
    procedure Designator; override;
    procedure DestructorHeading; override;
    procedure DestructorName; override;
    procedure Directive16Bit; override;
    procedure DirectiveBinding; override;
    procedure DirectiveCalling; override;
    procedure DispInterfaceForward; override;
    procedure EmptyStatement; override;
    procedure EnumeratedType; override;
    procedure ExceptBlock; override;
    procedure ExceptionBlockElseBranch; override;
    procedure ExceptionClassTypeIdentifier; override;
    procedure ExceptionHandler; override;
    procedure ExceptionHandlerList; override;
    procedure ExceptionIdentifier; override;
    procedure ExceptionVariable; override;
    procedure ExpliciteType; override;
    procedure ExportedHeading; override;
    procedure ExportsClause; override;
    procedure ExportsElement; override;
    procedure Expression; override;
    procedure ExpressionList; override;
    procedure ExternalDirective; override;
    procedure ExternalDirectiveThree; override;
    procedure ExternalDirectiveTwo; override;
    procedure Factor; override;
    procedure FieldDeclaration; override;
    procedure FieldList; override;
    procedure FileType; override;
    procedure FormalParameterList; override;
    procedure FormalParameterSection; override;
    procedure ForStatement; override;
    procedure ForwardDeclaration; override;
    procedure FunctionHeading; override;
    procedure FunctionMethodDeclaration; override;
    procedure FunctionMethodName; override;
    procedure FunctionProcedureBlock; override;
    procedure FunctionProcedureName; override;
    procedure IdentifierList; override;
    procedure IdentifierListEntry; override;
    procedure IfStatement; override;
    procedure ImplementationSection; override;
    procedure IncludeFile; override;
    procedure InheritedStatement; override;
    procedure InitializationSection; override;
    procedure InlineStatement; override;
    procedure InterfaceDeclaration; override;
    procedure InterfaceForward; override;
    procedure InterfaceGUID; override;
    procedure InterfaceHeritage; override;
    procedure InterfaceMemberList; override;
    procedure InterfaceSection; override;
    procedure InterfaceType; override;
    procedure LabelDeclarationSection; override;
    procedure LabeledStatement; override;
    procedure LabelId; override;
    procedure LibraryFile; override;
    procedure MainUsedUnitExpression; override;
    procedure MainUsedUnitName; override;
    procedure MainUsedUnitStatement; override;
    procedure MainUsesClause; override;
    procedure MultiplicativeOperator; override;
    procedure NewFormalParameterType; override;
    procedure Number; override;
    procedure ObjectConstructorHeading; override;
    procedure ObjectDestructorHeading; override;
    procedure ObjectField; override;
    procedure ObjectForward; override;
    procedure ObjectFunctionHeading; override;
    procedure ObjectHeritage; override;
    procedure ObjectMemberList; override;
    procedure ObjectMethodDirective; override;
    procedure ObjectMethodHeading; override;
    procedure ObjectNameOfMethod; override;
    procedure ObjectProperty; override;
    procedure ObjectPropertySpecifiers; override;
    procedure ObjectProcedureHeading; override;
    procedure ObjectType; override;
    procedure ObjectVisibility; override;
    procedure OldFormalParameterType; override;
    procedure OrdinalIdentifier; override;
    procedure OrdinalType; override;
    procedure OutParameter; override;
    procedure PackageFile; override;
    procedure ParameterFormal; override;
    procedure ParameterName; override;
    procedure ParameterNameList; override;
    procedure ParseFile; override;
    procedure PointerType; override;
    procedure ProceduralDirective; override;
    procedure ProceduralType; override;
    procedure ProcedureDeclarationSection; override;
    procedure ProcedureHeading; override;
    procedure ProcedureMethodDeclaration; override;
    procedure ProcedureMethodName; override;
    procedure ProgramBlock; override;
    procedure ProgramFile; override;
    procedure PropertyDirective; override;
    procedure PropertyImplements; override;
    procedure PropertyInterface; override;
    procedure PropertyName; override;
    procedure PropertyParameterConst; override;
    procedure PropertyParameterList; override;
    procedure PropertySpecifiers; override;
    procedure QualifiedIdentifier; override;
    procedure QualifiedIdentifierList; override;
    procedure RaiseStatement; override;
    procedure ReadAccessIdentifier; override;
    procedure RealIdentifier; override;
    procedure RealType; override;
    procedure RecordConstant; override;
    procedure RecordFieldConstant; override;
    procedure RecordType; override;
    procedure RecordVariant; override;
    procedure RelativeOperator; override;
    procedure RepeatStatement; override;
    procedure RequiresClause; override;
    procedure RequiresIdentifier; override;
    procedure ResolutionInterfaceName; override;
    procedure ResourceDeclaration; override;
    procedure ResourceIncluded(const aResName : string); override;
    procedure ReturnType; override;
    procedure SetConstructor; override;
    procedure SetElement; override;
    procedure SetType; override;
    procedure SimpleExpression; override;
    procedure SimpleStatement; override;
    procedure SimpleType; override;
    procedure SkipAnsiComment; override;
    procedure SkipBorComment; override;
    procedure SkipSlashesComment; override;
    procedure SkipSpace; override;
    procedure SkipCRLFco; override;
    procedure SkipCRLF; override;
    procedure Statement; override;
    procedure StatementList; override;
    procedure StorageExpression; override;
    procedure StorageIdentifier; override;
    procedure StorageDefault; override;
    procedure StorageNoDefault; override;
    procedure StorageSpecifier; override;
    procedure StorageStored; override;
    procedure StringIdentifier; override;
    procedure StringStatement; override;
    procedure StringType; override;
    procedure StructuredType; override;
    procedure SubrangeType; override;
    procedure TagField; override;
    procedure TagFieldName; override;
    procedure TagFieldTypeName; override;
    procedure Term; override;
    procedure TryStatement; override;
    procedure TypedConstant; override;
    procedure TypeDeclaration; override;
    procedure TypeId; override;
    procedure TypeKind; override;
    procedure TypeName; override;
    procedure TypeSection; override;
    procedure UnitFile; override;
    procedure UnitName; override;
    procedure UnitId; override;
    procedure UsedUnitName; override;
    procedure UsedUnitsList; override;
    procedure UsesClause; override;
    procedure VarAbsolute; override;
    procedure VarEqual; override;
    procedure VarDeclaration; override;
    procedure Variable; override;
    procedure VariableList; override;
    procedure VariableReference; override;
    procedure VariableTwo; override;
    procedure VariantIdentifier; override;
    procedure VariantSection; override;
    procedure VarName; override;
    procedure VarNameList; override;
    procedure VarParameter; override;
    procedure VarSection; override;
    procedure VisibilityAutomated; override;
    procedure VisibilityPrivate; override;
    procedure VisibilityProtected; override;
    procedure VisibilityPublic; override;
    procedure VisibilityPublished; override;
    procedure VisibilityUnknown; override;
    procedure WhileStatement; override;
    procedure WithStatement; override;
    procedure WriteAccessIdentifier; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run(UnitName: string; SourceStream: TMemoryStream); override;
    property CodeNodeMap: TCodeTreeMap read FCodeNodeMap write FCodeNodeMap;
  published
    property NodeOptions: TNodeIncludeOptions read FNodeOptions write FNodeOptions;
    { TODO : set option to only parse interface section? stop after that?? Only parse implementation? }
//    property ParseOptions: TParseOptions read FParseOptions write FParseOptions;
  end;

function NodeMatches(Node: TmwCodeTree; CodeTypes: TmwPasCodeInfoTypes; const NodeData: string): Boolean;

implementation

function NodeMatches(Node: TmwCodeTree; CodeTypes: TmwPasCodeInfoTypes; const NodeData: string): Boolean;
begin
  Result := False;
  if Node.CodeInfo in CodeTypes then
  begin
    // if searching by NodeData and it matches
    if (NodeData = '') or SameText(Node.Data, NodeData) then
      Result := True;
  end;
end;

{ TSourceParserTree }

procedure TSourceParserTree.AccessSpecifier;
begin
  FCodeNodeMap.TokenEncounter(ciAccessSpecifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.AdditiveOperator;
begin
  FCodeNodeMap.TokenEncounter(ciAdditiveOperator);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ArrayConstant;
begin
  FCodeNodeMap.TokenEncounter(ciArrayConstant);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ArrayType;
begin
  FCodeNodeMap.TokenEncounter(ciArrayType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.AsmStatement;
begin
  FCodeNodeMap.TokenEncounter(ciAsmStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Block;
begin
  FCodeNodeMap.TokenEncounter(ciBlock);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.CaseLabel;
begin
  FCodeNodeMap.TokenEncounter(ciCaseLabel);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.CaseSelector;
begin
  FCodeNodeMap.TokenEncounter(ciCaseSelector);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.CaseStatement;
begin
  FCodeNodeMap.TokenEncounter(ciCaseStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.CharString;
begin
  FCodeNodeMap.TokenEncounter(ciCharString);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassField;
begin
  FCodeNodeMap.TokenEncounter(ciClassField);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassForward;
begin
  FCodeNodeMap.TokenEncounter(ciClassForward);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassFunctionHeading;
begin
  FCodeNodeMap.TokenEncounter(ciClassFunctionHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassHeritage;
begin
  FCodeNodeMap.TokenEncounter(ciClassHeritage);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassMemberList;
begin
  FCodeNodeMap.TokenEncounter(ciClassMemberList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassMethodDirective;
begin
  FCodeNodeMap.TokenEncounter(ciClassMethodDirective);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassMethodHeading;
begin
  FCodeNodeMap.TokenEncounter(ciClassMethodHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassMethodOrProperty;
begin
//  if ioVerbose in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciClassMethodOrProperty);
  inherited;
//  if ioVerbose in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassMethodResolution;
begin
  FCodeNodeMap.TokenEncounter(ciClassMethodResolution);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassMemberType;
begin
  FCodeNodeMap.TokenEncounter(ciClassMemberType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassProcedureHeading;
begin
  FCodeNodeMap.TokenEncounter(ciClassProcedureHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassProperty;
begin
  FCodeNodeMap.TokenEncounter(ciClassProperty);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassReferenceType;
begin
  FCodeNodeMap.TokenEncounter(ciClassReferenceType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassType;
begin
  FCodeNodeMap.TokenEncounter(ciClassType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ClassVisibility;
begin
  // called for each class member (is really "CheckForClassVisibility")
  //FCodeNodeMap.TokenEncounter(ciClassVisibility);
  inherited;
  //FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.CompoundStatement;
begin
  FCodeNodeMap.TokenEncounter(ciCompoundStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstantColon;
begin
  FCodeNodeMap.TokenEncounter(ciConstantColon);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstantDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciConstantDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstantEqual;
begin
  FCodeNodeMap.TokenEncounter(ciConstantEqual);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstantExpression;
begin
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciConstantExpression);
  inherited;
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstantName;
begin
  FCodeNodeMap.TokenEncounter(ciConstantName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstantValue;
begin
  FCodeNodeMap.TokenEncounter(ciConstantValue);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstantValueTyped;
begin
  FCodeNodeMap.TokenEncounter(ciConstantValueTyped);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstParameter;
begin
  FCodeNodeMap.TokenEncounter(ciConstParameter);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstructorHeading;
begin
  FCodeNodeMap.TokenEncounter(ciConstructorHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstructorName;
begin
  FCodeNodeMap.TokenEncounter(ciConstructorName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ConstSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciConstSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ContainsClause;
begin
  FCodeNodeMap.TokenEncounter(ciContainsClause);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ContainsExpression;
begin
  FCodeNodeMap.TokenEncounter(ciContainsExpression);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ContainsIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciContainsIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ContainsStatement;
begin
  FCodeNodeMap.TokenEncounter(ciContainsStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

constructor TSourceParserTree.Create;
begin
  inherited Create;
  FCodeNodeMap := TCodeTreeMap.Create(Lexer);
  // by default, don't include generally useless filler (noJunk, noComments, noSemiColons, noControlCodes, noSpaces);
  FNodeOptions := [ioVerbose, ioSections, ioInfoNodes];
end;

procedure TSourceParserTree.DeclarationSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciDeclarationSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Designator;
begin
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciDesignator);
  inherited;
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

destructor TSourceParserTree.Destroy;
begin
//  FCodeNodeMap.Free;
  FCodeNodeMap.Free;
  inherited;
end;

procedure TSourceParserTree.DestructorHeading;
begin
  FCodeNodeMap.TokenEncounter(ciDestructorHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.DestructorName;
begin
  FCodeNodeMap.TokenEncounter(ciDestructorName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Directive16Bit;
begin
  FCodeNodeMap.TokenEncounter(ciDirective16Bit);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.DirectiveBinding;
begin
  FCodeNodeMap.TokenEncounter(ciDirectiveBinding);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.DirectiveCalling;
begin
  FCodeNodeMap.TokenEncounter(ciDirectiveCalling);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.DispInterfaceForward;
begin
  FCodeNodeMap.TokenEncounter(ciDispInterfaceForward);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.EmptyStatement;
begin
  FCodeNodeMap.TokenEncounter(ciEmptyStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.EnumeratedType;
begin
  FCodeNodeMap.TokenEncounter(ciEnumeratedType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExceptBlock;
begin
  FCodeNodeMap.TokenEncounter(ciExceptBlock);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExceptionBlockElseBranch;
begin
  FCodeNodeMap.TokenEncounter(ciExceptionBlockElseBranch);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExceptionClassTypeIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciExceptionClassTypeIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExceptionHandler;
begin
  FCodeNodeMap.TokenEncounter(ciExceptionHandler);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExceptionHandlerList;
begin
  FCodeNodeMap.TokenEncounter(ciExceptionHandlerList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExceptionIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciExceptionIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExceptionVariable;
begin
  FCodeNodeMap.TokenEncounter(ciExceptionVariable);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExpliciteType;
begin
  FCodeNodeMap.TokenEncounter(ciExpliciteType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExportedHeading;
begin
  FCodeNodeMap.TokenEncounter(ciExportedHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExportsClause;
begin
  FCodeNodeMap.TokenEncounter(ciExportsClause);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExportsElement;
begin
  FCodeNodeMap.TokenEncounter(ciExportsElement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Expression;
begin
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciExpression);
  inherited;
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExpressionList;
begin
  FCodeNodeMap.TokenEncounter(ciExpressionList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExternalDirective;
begin
  FCodeNodeMap.TokenEncounter(ciExternalDirective);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExternalDirectiveThree;
begin
  FCodeNodeMap.TokenEncounter(ciExternalDirectiveThree);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ExternalDirectiveTwo;
begin
  FCodeNodeMap.TokenEncounter(ciExternalDirectiveTwo);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Factor;
begin
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciFactor);
  inherited;
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FieldDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciFieldDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FieldList;
begin
  FCodeNodeMap.TokenEncounter(ciFieldList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FileType;
begin
  FCodeNodeMap.TokenEncounter(ciFileType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FormalParameterList;
begin
  FCodeNodeMap.TokenEncounter(ciFormalParameterList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FormalParameterSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciFormalParameterSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ForStatement;
begin
  FCodeNodeMap.TokenEncounter(ciForStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ForwardDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciForwardDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FunctionHeading;
begin
  FCodeNodeMap.TokenEncounter(ciFunctionHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FunctionMethodDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciFunctionMethodDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FunctionMethodName;
begin
  FCodeNodeMap.TokenEncounter(ciFunctionMethodName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FunctionProcedureBlock;
begin
  FCodeNodeMap.TokenEncounter(ciFunctionProcedureBlock);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.FunctionProcedureName;
begin
  FCodeNodeMap.TokenEncounter(ciFunctionProcedureName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.IdentifierList;
begin
  FCodeNodeMap.TokenEncounter(ciIdentifierList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.IdentifierListEntry;
begin
  FCodeNodeMap.TokenEncounter(ciIdentifierListEntry);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.IfStatement;
begin
  FCodeNodeMap.TokenEncounter(ciIfStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ImplementationSection;
begin
  FCodeNodeMap.TokenEncounter(ciImplementationSection);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.IncludeFile;
begin
  FCodeNodeMap.TokenEncounter(ciIncludeFile);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InheritedStatement;
begin
  FCodeNodeMap.TokenEncounter(ciInheritedStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InitializationSection;
begin
  FCodeNodeMap.TokenEncounter(ciInitializationSection);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InlineStatement;
begin
  FCodeNodeMap.TokenEncounter(ciInlineStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InterfaceDeclaration;
begin
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciInterfaceDeclaration);
  inherited;
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InterfaceForward;
begin
  FCodeNodeMap.TokenEncounter(ciInterfaceForward);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InterfaceGUID;
begin
  FCodeNodeMap.TokenEncounter(ciInterfaceGUID);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InterfaceHeritage;
begin
  FCodeNodeMap.TokenEncounter(ciInterfaceHeritage);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InterfaceMemberList;
begin
  FCodeNodeMap.TokenEncounter(ciInterfaceMemberList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InterfaceSection;
begin
  FCodeNodeMap.TokenEncounter(ciInterfaceSection);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.InterfaceType;
begin
  FCodeNodeMap.TokenEncounter(ciInterfaceType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.LabelDeclarationSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciLabelDeclarationSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.LabeledStatement;
begin
  FCodeNodeMap.TokenEncounter(ciLabeledStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.LabelId;
begin
  FCodeNodeMap.TokenEncounter(ciLabelId);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.LibraryFile;
begin
  FCodeNodeMap.TokenEncounter(ciLibraryFile);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.MainUsedUnitExpression;
begin
  FCodeNodeMap.TokenEncounter(ciMainUsedUnitExpression);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.MainUsedUnitName;
begin
  FCodeNodeMap.TokenEncounter(ciMainUsedUnitName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.MainUsedUnitStatement;
begin
  FCodeNodeMap.TokenEncounter(ciMainUsedUnitStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.MainUsesClause;
begin
  FCodeNodeMap.TokenEncounter(ciMainUsesClause);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.MultiplicativeOperator;
begin
  FCodeNodeMap.TokenEncounter(ciMultiplicativeOperator);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.NewFormalParameterType;
begin
  FCodeNodeMap.TokenEncounter(ciNewFormalParameterType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Number;
begin
  FCodeNodeMap.TokenEncounter(ciNumber);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectConstructorHeading;
begin
  FCodeNodeMap.TokenEncounter(ciObjectConstructorHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectDestructorHeading;
begin
  FCodeNodeMap.TokenEncounter(ciObjectDestructorHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectField;
begin
  FCodeNodeMap.TokenEncounter(ciObjectField);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectForward;
begin
  FCodeNodeMap.TokenEncounter(ciObjectForward);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectFunctionHeading;
begin
  FCodeNodeMap.TokenEncounter(ciObjectFunctionHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectHeritage;
begin
  FCodeNodeMap.TokenEncounter(ciObjectHeritage);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectMemberList;
begin
  FCodeNodeMap.TokenEncounter(ciObjectMemberList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectMethodDirective;
begin
  FCodeNodeMap.TokenEncounter(ciObjectMethodDirective);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectMethodHeading;
begin
  FCodeNodeMap.TokenEncounter(ciObjectMethodHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectNameOfMethod;
begin
  FCodeNodeMap.TokenEncounter(ciObjectNameOfMethod);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectProcedureHeading;
begin
  FCodeNodeMap.TokenEncounter(ciObjectProcedureHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectProperty;
begin
  FCodeNodeMap.TokenEncounter(ciObjectProperty);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectPropertySpecifiers;
begin
  FCodeNodeMap.TokenEncounter(ciObjectPropertySpecifiers);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectType;
begin
  FCodeNodeMap.TokenEncounter(ciObjectType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ObjectVisibility;
begin
  FCodeNodeMap.TokenEncounter(ciObjectVisibility);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.OldFormalParameterType;
begin
  FCodeNodeMap.TokenEncounter(ciOldFormalParameterType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.OrdinalIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciOrdinalIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.OrdinalType;
begin
  FCodeNodeMap.TokenEncounter(ciOrdinalType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.OutParameter;
begin
  FCodeNodeMap.TokenEncounter(ciOutParameter);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PackageFile;
begin
  FCodeNodeMap.TokenEncounter(ciPackageFile);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ParameterFormal;
begin
  FCodeNodeMap.TokenEncounter(ciParameterFormal);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ParameterName;
begin
  FCodeNodeMap.TokenEncounter(ciParameterName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ParameterNameList;
begin
  FCodeNodeMap.TokenEncounter(ciParameterNameList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ParseFile;
begin
  FCodeNodeMap.TokenEncounter(ciParseFile);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PointerType;
begin
  FCodeNodeMap.TokenEncounter(ciPointerType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProceduralDirective;
begin
  FCodeNodeMap.TokenEncounter(ciProceduralDirective);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProceduralType;
begin
  FCodeNodeMap.TokenEncounter(ciProceduralType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProcedureDeclarationSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciProcedureDeclarationSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProcedureHeading;
begin
  FCodeNodeMap.TokenEncounter(ciProcedureHeading);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProcedureMethodDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciProcedureMethodDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProcedureMethodName;
begin
  FCodeNodeMap.TokenEncounter(ciProcedureMethodName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProgramBlock;
begin
  FCodeNodeMap.TokenEncounter(ciProgramBlock);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ProgramFile;
begin
  FCodeNodeMap.TokenEncounter(ciProgramFile);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PropertyDirective;
begin
  FCodeNodeMap.TokenEncounter(ciPropertyDirective);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PropertyInterface;
begin
  FCodeNodeMap.TokenEncounter(ciPropertyInterface);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PropertyName;
begin
  FCodeNodeMap.TokenEncounter(ciPropertyName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PropertyParameterConst;
begin
  FCodeNodeMap.TokenEncounter(ciPropertyParameterConst);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PropertyParameterList;
begin
  FCodeNodeMap.TokenEncounter(ciPropertyParameterList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PropertySpecifiers;
begin
  FCodeNodeMap.TokenEncounter(ciPropertySpecifiers);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.QualifiedIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciQualifiedIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.QualifiedIdentifierList;
begin
  FCodeNodeMap.TokenEncounter(ciQualifiedIdentifierList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RaiseStatement;
begin
  FCodeNodeMap.TokenEncounter(ciRaiseStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ReadAccessIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciReadAccessIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RealIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciRealIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RealType;
begin
  FCodeNodeMap.TokenEncounter(ciRealType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RecordConstant;
begin
  FCodeNodeMap.TokenEncounter(ciRecordConstant);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RecordFieldConstant;
begin
  FCodeNodeMap.TokenEncounter(ciRecordFieldConstant);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RecordType;
begin
  FCodeNodeMap.TokenEncounter(ciRecordType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RecordVariant;
begin
  FCodeNodeMap.TokenEncounter(ciRecordVariant);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RelativeOperator;
begin
  FCodeNodeMap.TokenEncounter(ciRelativeOperator);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RepeatStatement;
begin
  FCodeNodeMap.TokenEncounter(ciRepeatStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RequiresClause;
begin
  FCodeNodeMap.TokenEncounter(ciRequiresClause);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.RequiresIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciRequiresIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ResolutionInterfaceName;
begin
  FCodeNodeMap.TokenEncounter(ciResolutionInterfaceName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ResourceDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciResourceDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ResourceIncluded(const aResName: string);
begin
  FCodeNodeMap.TokenEncounter(ciResourceIncluded, aResName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.ReturnType;
begin
  FCodeNodeMap.TokenEncounter(ciReturnType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Run(UnitName: string;
  SourceStream: TMemoryStream);
begin
  { Clear any existing information }
  FCodeNodeMap.Clear;
  inherited Run(UnitName, SourceStream);
end;

procedure TSourceParserTree.SEMICOLON;
begin
  if ioSemiColons in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSEMICOLON);
  inherited;
  if ioSemiColons in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SetConstructor;
begin
  FCodeNodeMap.TokenEncounter(ciSetConstructor);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SetElement;
begin
  FCodeNodeMap.TokenEncounter(ciSetElement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SetType;
begin
  FCodeNodeMap.TokenEncounter(ciSetType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SimpleExpression;
begin
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSimpleExpression);
  inherited;
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SimpleStatement;
begin
  FCodeNodeMap.TokenEncounter(ciSimpleStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SimpleType;
begin
  FCodeNodeMap.TokenEncounter(ciSimpleType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SkipAnsiComment;
begin
  if ioComments in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSkipAnsiComment);
  inherited;
  if ioComments in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SkipBorComment;
begin
  if ioComments in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSkipBorComment);
  inherited;
  if ioComments in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SkipCRLF;
begin
  if ioControlCodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSkipCRLF);
  inherited;
  if ioControlCodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SkipCRLFco;
begin
  if ioControlCodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSkipCRLFco);
  inherited;
  if ioControlCodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SkipJunk;
begin
  if ioJunk in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSkipJunk);
  inherited;
  if ioJunk in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SkipSlashesComment;
begin
  if ioComments in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSkipSlashesComment);
  inherited;
  if ioComments in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SkipSpace;
begin
  if ioSpaces in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciSkipSpace);
  inherited;
  if ioSpaces in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Statement;
begin
  FCodeNodeMap.TokenEncounter(ciStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StatementList;
begin
  FCodeNodeMap.TokenEncounter(ciStatementList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StorageDefault;
begin
  FCodeNodeMap.TokenEncounter(ciStorageDefault);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StorageExpression;
begin
  FCodeNodeMap.TokenEncounter(ciStorageExpression);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StorageIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciStorageIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StorageNoDefault;
begin
  FCodeNodeMap.TokenEncounter(ciStorageNoDefault);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StorageSpecifier;
begin
  FCodeNodeMap.TokenEncounter(ciStorageSpecifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StorageStored;
begin
  FCodeNodeMap.TokenEncounter(ciStorageStored);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StringIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciStringIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StringStatement;
begin
  FCodeNodeMap.TokenEncounter(ciStringStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StringType;
begin
  FCodeNodeMap.TokenEncounter(ciStringType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.StructuredType;
begin
  FCodeNodeMap.TokenEncounter(ciStructuredType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.SubrangeType;
begin
  FCodeNodeMap.TokenEncounter(ciSubrangeType);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TagField;
begin
  FCodeNodeMap.TokenEncounter(ciTagField);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TagFieldName;
begin
  FCodeNodeMap.TokenEncounter(ciTagFieldName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TagFieldTypeName;
begin
  FCodeNodeMap.TokenEncounter(ciTagFieldTypeName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Term;
begin
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciTerm);
  inherited;
  if ioInfoNodes in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TryStatement;
begin
  FCodeNodeMap.TokenEncounter(ciTryStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TypedConstant;
begin
  FCodeNodeMap.TokenEncounter(ciTypedConstant);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TypeDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciTypeDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TypeId;
begin
  FCodeNodeMap.TokenEncounter(ciTypeId);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TypeKind;
begin
  FCodeNodeMap.TokenEncounter(ciTypeKind);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TypeName;
begin
  FCodeNodeMap.TokenEncounter(ciTypeName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.TypeSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciTypeSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.UnitFile;
begin
  FCodeNodeMap.TokenEncounter(ciUnitFile);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.UnitName;
begin
  FCodeNodeMap.TokenEncounter(ciUnitName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.UnitId;
begin
  FCodeNodeMap.TokenEncounter(ciUnitId);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.UsedUnitName;
begin
  FCodeNodeMap.TokenEncounter(ciUsedUnitName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.UsedUnitsList;
begin
  FCodeNodeMap.TokenEncounter(ciUsedUnitsList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.UsesClause;
begin
  FCodeNodeMap.TokenEncounter(ciUsesClause);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VarAbsolute;
begin
  FCodeNodeMap.TokenEncounter(ciVarAbsolute);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VarDeclaration;
begin
  FCodeNodeMap.TokenEncounter(ciVarDeclaration);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VarEqual;
begin
  FCodeNodeMap.TokenEncounter(ciVarEqual);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.Variable;
begin
  FCodeNodeMap.TokenEncounter(ciVariable);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VariableList;
begin
  FCodeNodeMap.TokenEncounter(ciVariableList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VariableReference;
begin
  FCodeNodeMap.TokenEncounter(ciVariableReference);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VariableTwo;
begin
  FCodeNodeMap.TokenEncounter(ciVariableTwo);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VariantIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciVariantIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VariantSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciVariantSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VarName;
begin
  FCodeNodeMap.TokenEncounter(ciVarName);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VarNameList;
begin
  FCodeNodeMap.TokenEncounter(ciVarNameList);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VarParameter;
begin
  FCodeNodeMap.TokenEncounter(ciVarParameter);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VarSection;
begin
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenEncounter(ciVarSection);
  inherited;
  if ioSections in FNodeOptions then
    FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VisibilityAutomated;
begin
  FCodeNodeMap.TokenEncounter(ciVisibilityAutomated);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VisibilityPrivate;
begin
  FCodeNodeMap.TokenEncounter(ciVisibilityPrivate);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VisibilityProtected;
begin
  FCodeNodeMap.TokenEncounter(ciVisibilityProtected);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VisibilityPublic;
begin
  FCodeNodeMap.TokenEncounter(ciVisibilityPublic);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VisibilityPublished;
begin
  FCodeNodeMap.TokenEncounter(ciVisibilityPublished);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.VisibilityUnknown;
begin
  FCodeNodeMap.TokenEncounter(ciVisibilityUnknown);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.WhileStatement;
begin
  FCodeNodeMap.TokenEncounter(ciWhileStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.WithStatement;
begin
  FCodeNodeMap.TokenEncounter(ciWithStatement);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.WriteAccessIdentifier;
begin
  FCodeNodeMap.TokenEncounter(ciWriteAccessIdentifier);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

procedure TSourceParserTree.PropertyImplements;
begin
  FCodeNodeMap.TokenEncounter(ciPropertyImplements);
  inherited;
  FCodeNodeMap.TokenLeave;
end;

{ TCodeTreeMap }

procedure TCodeTreeMap.Clear;
begin
  FTotalCount := 0;
  FUnitTop := nil;
  FInterface := nil;
  FImplementation := nil;
  FRoot.Clear;
end;

function TCodeTreeMap.CodeTypeFound(RootNode: TCodeTreeNode; CodeType: TmwPasCodeInfo): Boolean;
begin
  Result := Assigned(FindFirst(RootNode, CodeType, ''));
end;

constructor TCodeTreeMap.Create(ALexer: TmwPasLex);
begin
  Assert(Assigned(ALexer), 'A Lexer must be provided.');
  FLexer := ALexer;
  FRoot := CreateNewNode(ciNotSpecifed);
  FCurrentNode := FRoot;
  FStackLevel := 0;
  FTotalCount := 0;
end;

function TCodeTreeMap.CreateNewNode(CodeInfo: TmwPasCodeInfo): TCodeTreeNode;
begin
  Inc(FTotalCount);

  // create a new Token
  Result := TCodeTreeNode.Create;
  try
    Result.TokenKind  := FLexer.TokenID;
    Result.CodeInfo   := CodeInfo;
    Result.StartPosXY        := FLexer.PosXY;
    Result.StartLineNumber   := Result.StartPosXY.Y;  // FLexer.LineNumber; (bad information)
    Result.StartLinePosition := Result.StartPosXY.X;  // FLexer.LinePos; (bad information)
    Result.Data              := FLexer.Token;
    Result.StackLevel  := FStackLevel;
  except
    FreeAndNil(Result);
  end;
end;

destructor TCodeTreeMap.Destroy;
begin
  Clear;
  FreeAndNil(FRoot);
  inherited;
end;

function TCodeTreeMap.FindFirst(RootNode: TCodeTreeNode; CodeTypes: TmwPasCodeInfoTypes;
  const NodeData: string): TCodeTreeNode;
var
  i: Integer;
begin
  Result := nil;
  { Cycle all the Root node's items. }
  for i := 0 to RootNode.Count - 1 do
  begin
    { If the node type matches, compare on name if desired. }
    if RootNode.Nodes[i].CodeInfo in CodeTypes then
      if (NodeData = '') or (CompareText(RootNode.Nodes[i].Data, NodeData) = 0) then
        Result := TCodeTreeNode(RootNode.Nodes[i]);
    { If not found, check in Child nodes. }
    if (not Assigned(Result)) and (RootNode.Nodes[i].Count > 0) then
      Result := FindFirst(TCodeTreeNode(RootNode.Nodes[i]), CodeTypes, NodeData);

    { If desired item was found, return it. }
    if Assigned(Result) then
      Break;
  end;
end;

function TCodeTreeMap.FindFirst(RootNode: TCodeTreeNode;
  CodeType: TmwPasCodeInfo; const NodeData: string): TCodeTreeNode;
var
  types: TmwPasCodeInfoTypes;
begin
  types := [];
  Include(types, CodeType);
  Result := FindFirst(RootNode, types, NodeData);
end;

function TCodeTreeMap.FindFuncProcDeclaration(const AName: string): TCodeTreeNode;
var
  i: Integer;
begin
  Result := nil;
  if not Assigned(FInterface) then EXIT;

  // start from interface section
  for i := 0 to FInterface.Count - 1 do
  begin
    with TCodeTreeNode(FInterface.Nodes[i]) do
    begin
      // Only look if it is for a procedure or function
      // may or may not include informational sections
      if (TokenKind in [ptProcedure, ptFunction]) and
         (CodeInfo in [ciInterfaceDeclaration, ciExportedHeading]) then
      begin
        Result := FindNodeFrom(TCodeTreeNode(FInterface.Nodes[i]), ciFunctionProcedureName, AName, [fnSearchSubNodes]);
        if Assigned(Result) then
        begin
          Result := TCodeTreeNode(Result.Parent);   // return the node that contains the name.
          Break;
        end;
      end;
    end;
  end;
end;

function TCodeTreeMap.FindFuncProcImplementation(const AName: string): TCodeTreeNode;
var
  i: Integer;
begin
  Result := nil;
  if not Assigned(FImplementation) then EXIT;

  // start from implementation section
  for i := 0 to FImplementation.Count - 1 do
  begin
    with TCodeTreeNode(FImplementation.Nodes[i]) do
    begin
      // Only look if it is for a procedure or function
      // may or may not include informational sections
      if (TokenKind in [ptProcedure, ptFunction]) and
         (CodeInfo in [ciDeclarationSection, ciProcedureDeclarationSection, ciProcedureMethodDeclaration, ciFunctionMethodDeclaration]) then
      begin
        Result := FindNodeFrom(TCodeTreeNode(FImplementation.Nodes[i]), ciFunctionProcedureName, AName, [fnSearchSubNodes]);
        if Assigned(Result) then
        begin
          Result := TCodeTreeNode(Result.Parent);   // return the node that contains the name.
          { Check to make sure the Func/Proc does not have an ObjectName (method implementation) }
          if Assigned(FindNodeFrom(Result, ciObjectNameOfMethod, '', [])) then // if found an Object specifier, not the result, return nil
            Result := nil
          else  // if no object specifier found, return result
            Break;
        end;
      end;
    end;
  end;
end;

function TCodeTreeMap.FindMethodDeclaration(const AClassName,
  AMethodName: string; InterfaceSectionOnly: Boolean): TCodeTreeNode;
var
  TypeNode: TCodeTreeNode;
begin
  { Classes can be defined below the interface section (in implementation). The
    InterfaceSectionOnly parameter determines if only the InterfaceSection is
    searched else it will search the whole tree. }
  Result := nil;
  TypeNode := FindTypeDeclaration(AClassName, ciClassType, InterfaceSectionOnly);
  // found the Class, look for the method
  if Assigned(TypeNode) then
  begin
    // Should only be one match. Overloading not supported with searches (FindNext would be needed)
    Result := FindFirst(TypeNode, [ciProcedureMethodName, ciFunctionMethodName], AMethodName);
    if Assigned(Result) then
      Result := FindParentType(Result, [ciClassMethodOrProperty], '');
  end;
end;

function TCodeTreeMap.FindMethodImplementation(const AClassName,
  AMethodName: string): TCodeTreeNode;
var
  i: Integer;
begin
  Result := nil;
  if not Assigned(FImplementation) then EXIT;

  // start from implementation section
  for i := 0 to FImplementation.Count - 1 do
  begin
    with TCodeTreeNode(FImplementation.Nodes[i]) do
    begin
      // Only look if it is for a procedure or function
      // may or may not include informational sections
      if (TokenKind in [ptProcedure, ptFunction]) and
         (CodeInfo in [ciDeclarationSection, ciProcedureDeclarationSection, ciProcedureMethodDeclaration, ciFunctionMethodDeclaration]) then
      begin
        Result := FindNodeFrom(TCodeTreeNode(FImplementation.Nodes[i]), ciFunctionProcedureName, AMethodName, [fnSearchSubNodes]);
        if Assigned(Result) then
        begin
          Result := TCodeTreeNode(Result.Parent);   // return the node that contains the name.
          { Check to make sure the Func/Proc has the correct ObjectName (method implementation) }
          if Assigned(FindNodeFrom(Result, ciObjectNameOfMethod, AClassName, [])) then // if Object specifier found, return it
            Break
          else  // if no object specifier found, return nil
            Result := nil;
        end;
      end; {if}
    end; {wtih}
  end; {for}
end;

function TCodeTreeMap.FindNext(FromNode, SearchRootNode: TCodeTreeNode; CodeTypes: TmwPasCodeInfoTypes;
  const NodeData: string): TCodeTreeNode;
var
  i: Integer;
  idx: Integer;
  SearchNode: TCodeTreeNode;
begin
  { FromNode = Where to begin searching from.
    SearchRootNode = Do not search beyond that point (ascending up parentage) }
  Result := nil;
  if FromNode = SearchRootNode then Exit;

  if Assigned(FromNode.Parent) then
    SearchNode := TCodeTreeNode(FromNode.Parent)    // start with parent
  else
    Exit;

  if not Assigned(SearchNode) then EXIT;

  { TODO -oMark : should this call "FindSearchableNode" first?? }

  idx := SearchNode.IndexOf(FromNode);
  if idx = -1 then Exit;

  { Cycle the SearchNode's items from the point after the FromNode. }
  for i := (idx + 1) to SearchNode.Count - 1 do
  begin
    { If the node type matches, compare on name if desired. }
    if SearchNode.Nodes[i].CodeInfo in CodeTypes then
      if (NodeData = '') or SameText(SearchNode.Nodes[i].Data, NodeData) then
        Result := TCodeTreeNode(SearchNode.Nodes[i]);

    { If not found, check in Child nodes. }
    if (not Assigned(Result)) and (SearchNode.Nodes[i].Count > 0) then
      Result := FindFirst(TCodeTreeNode(SearchNode.Nodes[i]), CodeTypes, NodeData);

    { If still not found, do a FindNext in Parent nodes. }
    if (not Assigned(Result)) and (Assigned(SearchNode.Parent) {and (SearchNode.Parent <> SearchRootNode)}) then
      Result := FindNext(SearchNode, SearchRootNode, CodeTypes, NodeData);

    { If desired item was found, return it. }
    if Assigned(Result) then
      Break;
  end;
end;

function TCodeTreeMap.FindNext(FromNode, SearchRootNode: TCodeTreeNode;
  CodeType: TmwPasCodeInfo; const NodeData: string): TCodeTreeNode;
var
  types: TmwPasCodeInfoTypes;
begin
  types := [];
  Include(types, CodeType);
  Result := FindNext(FromNode, SearchRootNode, types, NodeData);
end;

function TCodeTreeMap.FindNodeFrom(FromNode: TCodeTreeNode;
  CodeInfoType: TmwPasCodeInfo; const NodeData: string;
  Options: TFindNodeOptions): TCodeTreeNode;
var
  i: Integer;
begin
  Result := nil;
  if not Assigned(FromNode) then EXIT;

  for i := 0 to FromNode.Count - 1 do
  begin
    if NodeMatches(FromNode.Nodes[i], [CodeInfoType], NodeData) then
    begin
      Result := TCodeTreeNode(FromNode.Nodes[i]);
      Break;
    end;
    // this node is not it, cycle through sub-nodes
    if fnSearchSubNodes in Options then
    begin
      Result := FindNodeFrom(TCodeTreeNode(FromNode.Nodes[i]), CodeInfoType, NodeData, Options);
      if Assigned(Result) then
        Break;
    end;
  end;
end;

function TCodeTreeMap.FindParentType(FromNode: TCodeTreeNode;
  CodeTypes: TmwPasCodeInfoTypes; const NodeData: string): TCodeTreeNode;
var
  TestNode: TCodeTreeNode;
  Found: Boolean;
begin
  Result := nil;
  TestNode := FromNode;
  // while this node is not the one, move up the tree to search the parents
  repeat
    Found := NodeMatches(TestNode, CodeTypes, NodeData);
    if not Found then
      TestNode := TCodeTreeNode(TestNode.Parent);
  until Found or (TestNode = FRoot);
  { Return the node that was found } 
  if Found then
    Result := TestNode;
end;

function TCodeTreeMap.FindSearchableNode(FromNode: TCodeTreeNode; GoForward: Boolean): TCodeTreeNode;
var
  Node: TCodeTreeNode;
begin
  { Cycle up the tree to find a node that has more than one sub nodes. This
    node can be used for continued searches. }
  Node := FromNode;
  if GoForward then   // descend into sub nodes
  begin
    while Node.Count = 1 do   // only one child, go into child
      Node := TCodeTreeNode(Node.Nodes[0]);
  end
  // GoBackward
  else                // ascend into parents
  begin
    while Node.Parent.Count = 1 do   // only one child, go into child
      Node := TCodeTreeNode(Node.Parent.Nodes[0]);
  end;
  { Return node pointer }
  if Node.Count > 1 then
    Result := Node
  else
    Result := nil;
end;

function TCodeTreeMap.FindSubNodeType(FromNode: TCodeTreeNode;
  CodeTypes: TmwPasCodeInfoTypes; const NodeData: string): TCodeTreeNode;
var
  TestNode: TCodeTreeNode;
  Found: Boolean;
begin
  Result := nil;
  if FromNode = nil then
    TestNode := Root
  else
    TestNode := FromNode;
  // while this node is not the one, move up the tree to search the parents
  repeat
    Found := NodeMatches(TestNode, CodeTypes, NodeData);
    if not Found then
      TestNode := TCodeTreeNode(TestNode.Parent);
  until Found or (TestNode = FRoot) or (TestNode = nil);
  { Return the node that was found } 
  if Found then
    Result := TestNode;
end;

function TCodeTreeMap.FindTypeDeclaration(const ATypeName: string; CodeType: TmwPasCodeInfo; 
  InterfaceSectionOnly: Boolean): TCodeTreeNode;
var
  SearchRoot: TCodeTreeNode;
  Found: Boolean;
begin
  Result := nil;
  if InterfaceSectionOnly then
    SearchRoot := FInterface
  else
    SearchRoot := FRoot;
  if not Assigned(SearchRoot) then EXIT;

  Found := False;
  { Find the first type with the name being sought. }
  Result := FindFirst(SearchRoot, [ciTypeName], ATypeName);
  if Assigned(Result) then
  begin
    while not Found do
    begin
      Result := TCodeTreeNode(Result.Parent);   // return the node that contains the name.
      { Check to make sure the type is the desired type kind. (Class vs ClassForward, etc) }
      if Assigned(FindNodeFrom(Result, CodeType, '', [])) then // if desired CodeType found, we have it.
        Found := True
      else  // if CodeType not found, FindNext
        Result := FindNext(Result, SearchRoot, [ciTypeName], ATypeName);
    end;
  end;
end;

function TCodeTreeMap.GetDataForNextType(FromNode, RootNode: TCodeTreeNode;
  CodeType: TmwPasCodeInfo): string;
var
  node: TCodeTreeNode;
begin
  node := FindNext(FromNode, RootNode, CodeType, '');
  if Assigned(node) then
    Result := node.Data
  else
    Result := '';
end;

function TCodeTreeMap.GetDataForType(RootNode: TCodeTreeNode; CodeType: TmwPasCodeInfo): string;
var
  types: TmwPasCodeInfoTypes;
begin
  types := [];
  Include(types, CodeType);
  Result := GetDataForTypes(RootNode, types);
end;

function TCodeTreeMap.GetDataForTypes(RootNode: TCodeTreeNode;
  CodeTypes: TmwPasCodeInfoTypes): string;
var
  node: TCodeTreeNode;
begin
  node := FindFirst(RootNode, CodeTypes, '');
  if Assigned(node) then
    Result := node.Data
  else
    Result := '';
end;

procedure TCodeTreeMap.TokenEncounter(CodeInfo: TmwPasCodeInfo; const AData: string);
var
  NewNode: TCodeTreeNode;
begin
  Inc(FStackLevel);

  // create a new Token
  NewNode := CreateNewNode(CodeInfo);
  // if 'Data' is provided, override it with that
  if AData <> '' then
    NewNode.Data := AData;
  // test for section types, assign shortcut pointers for them
  if NewNode.CodeInfo = ciUnitFile then
    FUnitTop := NewNode
  else if NewNode.CodeInfo = ciInterfaceSection then
    FInterface := NewNode
  else if NewNode.CodeInfo = ciImplementationSection then
    FImplementation := NewNode;

  // Add it as a child of the current node
  FCurrentNode.Add(NewNode);

  // Make new token the current token
  FCurrentNode := NewNode;
end;

procedure TCodeTreeMap.TokenLeave;
begin
  Dec(FStackLevel);

  // Pop up the stack on the CurrentToken as well. Assign it to be the ParentNode (may set to nil)

  // set where the token block ends
  FCurrentNode.EndPosXY        := FLexer.PosXY;
  FCurrentNode.EndLineNumber   := FCurrentNode.EndPosXY.Y;  // FLexer.LineNumber; (bad information)
  FCurrentNode.EndLinePosition := FCurrentNode.EndPosXY.X;  // FLexer.LinePos; (bad information)

  // set the new CurrentToken
  FCurrentNode := TCodeTreeNode(FCurrentNode.Parent);
  // don't ever let it pop up too far to be nil
  if FCurrentNode = nil then
    FCurrentNode := FRoot;
end;

end.
