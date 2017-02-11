{---------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: mwSimplePasPar.pas, released November 14, 1999.

The Initial Developer of the Original Code is Martin Waldenburg
(Martin.Waldenburg@T-Online.de).
Portions created by Martin Waldenburg are Copyright (C) 1998, 1999 Martin
Waldenburg.
All Rights Reserved.
Portions CopyRight by Robert Zierer.

Contributor(s): James Jacobson, Dean Hill, Vladimir Churbanov___________________.

Last Modified: 2001/02/23
Current Version: 1.02

Notes: This program is an early beginning of a Pascal parser.
I'd like to invite the Delphi community to develop it further and to create
a fully featured Object Pascal parser.

Modification history:

Greg Chapman on 20010522
Better handling of defaut array property
Separate handling of X and Y in property Pixels[X, Y: Integer through identifier "event"
corrected spelling of "ForwardDeclaration" 


James Jacobson on 20010223
semi colon before finalization fix

James Jacobson on 20010223
RecordConstant Fix


Martin waldenburg on 2000107
Even Faster lexer implementation !!!!

James Jacobson on 20010107
  Improper handling of the construct
      property TheName: Integer read FTheRecord.One.Two; (stop at second point)
      where one and two are "qualifiable" structures.


James Jacobson on 20001221
   Stops at the second const.
   property Anchor[const Section: string; const Ident:string]: string read
   changed TmwSimplePasPar.PropertyParameterList

On behalf of  Martin Waldenburg and James Jacobson
 Correction in array property Handling (Matin and James) 07/12/2000
 Use of ExId instead of TokenId in ExportsElements (James) 07/12/2000
 Reverting to old behavior in Statementlist [PtintegerConst put back in] (James) 07/12/2000

Xavier Masson InnerCircleProject : XM : 08/11/2000
  Integration of the new version delivered by Martin Waldenburg with the modification I made described just below

Xavier Masson InnerCircleProject : XM : 07/15/2000
  Added "states/events " for      spaces( SkipSpace;) CRLFco (SkipCRLFco) and
    CRLF (SkipCRLF) this way the parser can give a complete view on code allowing
    "perfect" code reconstruction.
    (I fully now that this is not what a standard parser will do but I think it is more usefull this way ;) )
    go to www.innercircleproject.com for more explanations or express your critisism ;)

previous modifications not logged sorry ;)

Known Issues:
-----------------------------------------------------------------------------}
{----------------------------------------------------------------------------
 Last Modified: 05/22/2001
 Current Version: 1.1
 official version
   Maintained by InnerCircle

   http://www.innercircleproject.org

 02/07/2001
   added property handling in Object types
   changed handling of forward declarations in ExportedHeading method
-----------------------------------------------------------------------------}
{$I dws2.inc}
unit dws_mwSimplePasPar;

interface

uses
  SysUtils, Classes,
{$IFDEF DELPHI6up}
  Types,
{$ELSE}
  Windows,
{$ENDIF}
  dws_mwPasLexTypes, dws_mwPasLex, dws_mwSimplePasParTypes;

type
  ESyntaxError = class(Exception)
  private //jdj 7/18/1999
    FPosXY: TPoint;
  protected

  public
    constructor Create(const Msg: string);
    constructor CreateFmt(const Msg: string; const Args: array of const);
    constructor CreatePos(const Msg: string; aPosXY: TPoint);
    property PosXY: TPoint read FPosXY write FPosXY;
  end;

type
  TmwSimplePasPar = class(TObject)
  private
    FOnMessage: TMessageEvent;
    fLexer: TmwPasLex;
    fOwnStream: Boolean;
    fStream: TMemoryStream;
    fInterfaceOnly: Boolean;
  protected
    fInRound: Boolean;
    procedure Expected(Sym: TptTokenKind); virtual;
    procedure ExpectedEx(Sym: TptTokenKind); virtual;
    procedure ExpectedFatal(Sym: TptTokenKind); virtual;
    procedure HandlePtCompDirect(Sender: TmwBasePasLex); virtual;
    procedure HandlePtDefineDirect(Sender: TmwBasePasLex; Value: String);virtual;
    procedure HandlePtElseDirect(Sender: TmwBasePasLex); virtual;
    procedure HandlePtEndIfDirect(Sender: TmwBasePasLex); virtual;
    procedure HandlePtIfDefDirect(Sender: TmwBasePasLex); virtual;
    procedure HandlePtIfNDefDirect(Sender: TmwBasePasLex); virtual;
    procedure HandlePtIfOptDirect(Sender: TmwBasePasLex; Value: TbdBooleanDirectives; Active: Boolean);virtual;
    function  HandlePtIncludeDirect(Sender: TmwBasePasLex; Value: String): PChar ;virtual;
    procedure HandlePtResourceDirect(Sender: TmwBasePasLex; Value: String);virtual;
    procedure HandlePtUndefDirect(Sender: TmwBasePasLex; Value: String);virtual;
    procedure NextToken; virtual;
    procedure SkipJunk; virtual;
    procedure TerminateStream; virtual;
    procedure SEMICOLON; virtual;
    function GetExID: TptTokenKind; virtual;
    function GetTokenID: TptTokenKind; virtual;
    function GetGenID: TptTokenKind; virtual;
    procedure AccessSpecifier; virtual;
    procedure AdditiveOperator; virtual;
    procedure ArrayConstant; virtual;
    procedure ArrayType; virtual;
    procedure AsmStatement; virtual;
    procedure Block; virtual;
    procedure CaseLabel; virtual;
    procedure CaseSelector; virtual;
    procedure CaseStatement; virtual;
    procedure CharString; virtual;
    procedure ClassField; virtual;
    procedure ClassForward; virtual;
    procedure ClassFunctionHeading; virtual;
    procedure ClassHeritage; virtual;
    procedure ClassMemberList; virtual;
    procedure ClassMethodDirective; virtual;
    procedure ClassMethodHeading; virtual;
    procedure ClassMethodOrProperty; virtual;
    procedure ClassMethodResolution; virtual;
    procedure ClassMemberType; virtual;
    procedure ClassProcedureHeading; virtual;
    procedure ClassProperty; virtual;
    procedure ClassReferenceType; virtual;
    procedure ClassType; virtual;
    procedure ClassVisibility; virtual;
    procedure CompoundStatement; virtual;
    procedure ConstantColon; virtual;
    procedure ConstantDeclaration; virtual;
    procedure ConstantEqual; virtual;
    procedure ConstantExpression; virtual;
    procedure ConstantName; virtual;
    procedure ConstantValue; virtual;
    procedure ConstantValueTyped; virtual;
    procedure ConstParameter; virtual;
    procedure ConstructorHeading; virtual;
    procedure ConstructorName; virtual;
    procedure ConstSection; virtual;
    procedure ContainsClause; virtual;
    procedure ContainsExpression; virtual;
    procedure ContainsIdentifier; virtual;
    procedure ContainsStatement; virtual;
    procedure DeclarationSection; virtual;
    procedure Designator; virtual;
    procedure DestructorHeading; virtual;
    procedure DestructorName; virtual;
    procedure Directive16Bit; virtual;
    procedure DirectiveBinding; virtual;
    procedure DirectiveCalling; virtual;
    procedure DispInterfaceForward; virtual;
    procedure EmptyStatement; virtual;
    procedure EnumeratedType; virtual;
    procedure ExceptBlock; virtual;
    procedure ExceptionBlockElseBranch; virtual;
    procedure ExceptionClassTypeIdentifier; virtual;
    procedure ExceptionHandler; virtual;
    procedure ExceptionHandlerList; virtual;
    procedure ExceptionIdentifier; virtual;
    procedure ExceptionVariable; virtual;
    procedure ExpliciteType; virtual;
    procedure ExportedHeading; virtual;
    procedure ExportsClause; virtual;
    procedure ExportsElement; virtual;
    procedure Expression; virtual;
    procedure ExpressionList; virtual;
    procedure ExternalDirective; virtual;
    procedure ExternalDirectiveThree; virtual;
    procedure ExternalDirectiveTwo; virtual;
    procedure Factor; virtual;
    procedure FieldDeclaration; virtual;
    procedure FieldList; virtual;
    procedure FileType; virtual;
    procedure FormalParameterList; virtual;
    procedure FormalParameterSection; virtual;
    procedure ForStatement; virtual;
    procedure ForwardDeclaration; virtual;  {GLC: corrected spelling}
    procedure FunctionHeading; virtual;
    procedure FunctionMethodDeclaration; virtual;
    procedure FunctionMethodName; virtual;
    procedure FunctionProcedureBlock; virtual;
    procedure FunctionProcedureName; virtual;
    procedure IdentifierList; virtual;
    procedure IdentifierListEntry; virtual;
    procedure IfStatement; virtual;
    procedure ImplementationSection; virtual;
    procedure IncludeFile; virtual;
    procedure InheritedStatement; virtual;
    procedure InitializationSection; virtual;
    procedure InlineStatement; virtual;
    procedure InterfaceDeclaration; virtual;
    procedure InterfaceForward; virtual;
    procedure InterfaceGUID; virtual;
    procedure InterfaceHeritage; virtual;
    procedure InterfaceMemberList; virtual;
    procedure InterfaceSection; virtual;
    procedure InterfaceType; virtual;
    procedure LabelDeclarationSection; virtual;
    procedure LabeledStatement; virtual;
    procedure LabelId; virtual;
    procedure LibraryFile; virtual;
    procedure MainUsedUnitExpression; virtual;
    procedure MainUsedUnitName; virtual;
    procedure MainUsedUnitStatement; virtual;
    procedure MainUsesClause; virtual;
    procedure MultiplicativeOperator; virtual;
    procedure NewFormalParameterType; virtual;
    procedure Number; virtual;
    procedure ObjectConstructorHeading; virtual;
    procedure ObjectDestructorHeading; virtual;
    procedure ObjectField; virtual;
    procedure ObjectForward; virtual;
    procedure ObjectFunctionHeading; virtual;
    procedure ObjectHeritage; virtual;
    procedure ObjectMemberList; virtual;
    procedure ObjectMethodDirective; virtual;
    procedure ObjectMethodHeading; virtual;
    procedure ObjectNameOfMethod; virtual;
    procedure ObjectProperty; virtual;
    procedure ObjectPropertySpecifiers; virtual;
    procedure ObjectProcedureHeading; virtual;
    procedure ObjectType; virtual;
    procedure ObjectVisibility; virtual;
    procedure OldFormalParameterType; virtual;
    procedure OrdinalIdentifier; virtual;
    procedure OrdinalType; virtual;
    procedure OutParameter; virtual;
    procedure PackageFile; virtual;
    procedure ParameterFormal; virtual;
    procedure ParameterName; virtual;
    procedure ParameterNameList; virtual;
    procedure ParseFile; virtual;
    procedure PointerType; virtual;
    procedure ProceduralDirective; virtual;
    procedure ProceduralType; virtual;
    procedure ProcedureDeclarationSection; virtual;
    procedure ProcedureHeading; virtual;
    procedure ProcedureMethodDeclaration; virtual;
    procedure ProcedureMethodName; virtual;
    procedure ProgramBlock; virtual;
    procedure ProgramFile; virtual;
    procedure PropertyDirective; virtual;
    procedure PropertyImplements; virtual;
    procedure PropertyInterface; virtual;
    procedure PropertyName; virtual;
    procedure PropertyParameterConst; virtual;
    procedure PropertyParameterList; virtual;
    procedure PropertySpecifiers; virtual;
    procedure QualifiedIdentifier; virtual;
    procedure QualifiedIdentifierList; virtual;
    procedure RaiseStatement; virtual;
    procedure ReadAccessIdentifier; virtual;
    procedure RealIdentifier; virtual;
    procedure RealType; virtual;
    procedure RecordConstant; virtual;
    procedure RecordFieldConstant; virtual;
    procedure RecordType; virtual;
    procedure RecordVariant; virtual;
    procedure RelativeOperator; virtual;
    procedure RepeatStatement; virtual;
    procedure RequiresClause; virtual;
    procedure RequiresIdentifier; virtual;
    procedure ResolutionInterfaceName; virtual;
    procedure ResourceDeclaration; virtual;
    procedure ResourceIncluded(const aResName : string); virtual;
    procedure ReturnType; virtual;
    procedure SetConstructor; virtual;
    procedure SetElement; virtual;
    procedure SetType; virtual;
    procedure SimpleExpression; virtual;
    procedure SimpleStatement; virtual;
    procedure SimpleType; virtual;
    procedure SkipAnsiComment; virtual;
    procedure SkipBorComment; virtual;
    procedure SkipSlashesComment; virtual;
    procedure SkipSpace; virtual; //XM Jul-2000
    procedure SkipCRLFco; virtual; //XM Jul-2000
    procedure SkipCRLF; virtual; //XM Jul-2000
    procedure Statement; virtual;
    procedure StatementList; virtual;
    procedure StorageExpression; virtual;
    procedure StorageIdentifier; virtual;
    procedure StorageDefault; virtual;
    procedure StorageNoDefault; virtual;
    procedure StorageSpecifier; virtual;
    procedure StorageStored; virtual;
    procedure StringIdentifier; virtual;
    procedure StringStatement; virtual;
    procedure StringType; virtual;
    procedure StructuredType; virtual;
    procedure SubrangeType; virtual;
    procedure TagField; virtual;
    procedure TagFieldName; virtual;
    procedure TagFieldTypeName; virtual;
    procedure Term; virtual;
    procedure TryStatement; virtual;
    procedure TypedConstant; virtual;
    procedure TypeDeclaration; virtual;
    procedure TypeId; virtual;
    procedure TypeKind; virtual;
    procedure TypeName; virtual;
    procedure TypeSection; virtual;
    procedure UnitFile; virtual;
    procedure UnitName; virtual;     // MAE 20030727
    procedure UnitId; virtual;
    procedure UsedUnitName; virtual;
    procedure UsedUnitsList; virtual;
    procedure UsesClause; virtual;
    procedure VarAbsolute; virtual;
    procedure VarEqual; virtual;
    procedure VarDeclaration; virtual;
    procedure Variable; virtual;
    procedure VariableList; virtual;
    procedure VariableReference; virtual;
    procedure VariableTwo; virtual;
    procedure VariantIdentifier; virtual;
    procedure VariantSection; virtual;
    procedure VarName; virtual;
    procedure VarNameList; virtual;
    procedure VarParameter; virtual;
    procedure VarSection; virtual;
    procedure VisibilityAutomated; virtual;
    procedure VisibilityPrivate; virtual;
    procedure VisibilityProtected; virtual;
    procedure VisibilityPublic; virtual;
    procedure VisibilityPublished; virtual;
    procedure VisibilityUnknown; virtual;
    procedure WhileStatement; virtual;
    procedure WithStatement; virtual;
    procedure WriteAccessIdentifier; virtual;
    property ExID: TptTokenKind read GetExID;
    property GenID: TptTokenKind read GetGenID;
    property TokenID: TptTokenKind read GetTokenID;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SynError(Error: TmwParseError); virtual;
    procedure Run(UnitName: string; SourceStream: TMemoryStream); virtual;
    property InterfaceOnly: Boolean read fInterfaceOnly write fInterfaceOnly;
    property Lexer: TmwPasLex read fLexer;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
  published
  end;

implementation

{ ESyntaxError }

constructor ESyntaxError.Create(const Msg: string);
begin
  FPosXY := Point(- 1, -1);
  inherited Create(Msg);
end;

constructor ESyntaxError.CreateFmt(const Msg: string; const Args: array of const);
begin
  FPosXY := Point(- 1, -1);
  inherited CreateFmt(Msg, Args);
end;

constructor ESyntaxError.CreatePos(const Msg: string; aPosXY: TPoint);
begin
  Message := Msg;
  FPosXY := aPosXY;
end;

{ TmwSimplePasPar }

const
  cnExpected = 'Expected ''%s'' found ''%s''';
//  cnOrExpected = 'Expected ''%s'' or ''%s'' found ''%s''';
  cnEndOfFile = 'end of file'; {jdj 7/22/1999}
//  cnIntegerOverflow = 'Integer constant too large'; {jdj 7/22/1999}

 {range checks a ptIntegerConst-slightly faster than StrToInt}
{function IsValidInteger(const S: string): Boolean; jdj 7/22/1999
var jdj removed 02/07/2001
  C: Integer;
  N: Integer;
begin
  Val(S, N, C);
  Result := (C = 0);
end;}


procedure TmwSimplePasPar.ForwardDeclaration;
begin {jdj added method 02/07/2001}
  NextToken;
  SEMICOLON;
end;

procedure TmwSimplePasPar.ObjectProperty;
begin {jdj added method 02/07/2001}
  Expected(ptProperty);
  PropertyName;
  case TokenID of
    ptColon:
      begin
        PropertyInterface;
        ObjectPropertySpecifiers;
      end;
    ptSquareOpen:
      begin
        PropertyInterface;
        ObjectPropertySpecifiers;
        if ExID = ptDefault then
          PropertyDirective;
      end;
  end;
end;

procedure TmwSimplePasPar.ObjectPropertySpecifiers;
begin {jdj added method 02/07/2001}
  if ExID = ptIndex then
    begin
      NextToken;
      ConstantExpression;
    end;
  while ExID in [ptRead, ptReadOnly, ptWrite, ptWriteOnly] do
    begin
      AccessSpecifier;
    end;
  while ExID in [ptDefault, ptNoDefault, ptStored] do
    begin
      StorageSpecifier;
    end;
  SEMICOLON;
end;

procedure TmwSimplePasPar.Run(UnitName: string; SourceStream: TMemoryStream);
begin
  fStream := nil;
  fOwnStream := False;
  if SourceStream = nil then
    begin
      fStream := TMemoryStream.Create;
      fOwnStream := True;
      fStream.LoadFromFile(UnitName);
    end
  else
    fStream := SourceStream;
  TerminateStream;
  fLexer.Origin := fStream.Memory;
  ParseFile;
  if fOwnStream then
    fStream.Free;
end;

constructor TmwSimplePasPar.Create;
begin
  inherited Create;
  fLexer := TmwPasLex.Create;
{  fLexer.OnCompDirect := HandlePtCompDirect;
  fLexer.OnDefineDirect := HandlePtDefineDirect;
  fLexer.OnElseDirect := HandlePtElseDirect;
  fLexer.OnEndIfDirect := HandlePtEndIfDirect;
  fLexer.OnIfDefDirect := HandlePtIfDefDirect;
  fLexer.OnIfNDefDirect := HandlePtIfNDefDirect;
  fLexer.OnIfOptDirect := HandlePtIfOptDirect;
  fLexer.OnIncludeDirect := HandlePtIncludeDirect; }
  fLexer.OnResourceDirect := HandlePtResourceDirect;
{  fLexer.OnUnDefDirect := HandlePtUndefDirect;}
end;

destructor TmwSimplePasPar.Destroy;
begin
  fLexer.Free;
  inherited Destroy;
end;

{next two check for ptNull and ExpectedFatal for an EOF Error}

procedure TmwSimplePasPar.Expected(Sym: TptTokenKind);
begin
  if Sym <> Lexer.TokenID then
    begin
      (*if TokenID = ptNull then
        ExpectedFatal(Sym) {jdj 7/22/1999}
      else*)
        if Assigned(FOnMessage) then
          FOnMessage(Self, Format(cnExpected, [TokenName(Sym), fLexer.Token]),
            fLexer.PosXY.X, fLexer.PosXY.Y);
    end
  else NextToken;
end;

procedure TmwSimplePasPar.ExpectedEx(Sym: TptTokenKind);
begin
  if Sym <> Lexer.ExID then
    begin
      if Lexer.TokenID = ptNull then
        ExpectedFatal(Sym) {jdj 7/22/1999}
      else
        if Assigned(FOnMessage) then
          FOnMessage(Self, Format(cnExpected, [TokenName(Sym), fLexer.Token]),
            fLexer.PosXY.X, fLexer.PosXY.Y);
    end
  else NextToken;
end;

{Replace Token with cnEndOfFile if TokenId = ptnull}

procedure TmwSimplePasPar.ExpectedFatal(Sym: TptTokenKind);
var
  tS: string;
begin
  if Sym <> Lexer.TokenID then
    begin
    {--jdj 7/22/1999--}
      if Lexer.TokenId = ptNull then
        tS := cnEndOfFile
      else
        tS := fLexer.Token;
    {--jdj 7/22/1999--}
      raise ESyntaxError.CreatePos(Format(cnExpected, [TokenName(Sym), tS]), fLexer.PosXY);
    end
  else NextToken;
end;

procedure TmwSimplePasPar.HandlePtCompDirect(Sender: TmwBasePasLex);
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000
  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtDefineDirect(Sender: TmwBasePasLex; Value: String);
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000

  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtElseDirect(Sender: TmwBasePasLex);
begin
  //  Sender.NextNoJunk;
  //Sender.Next;
  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtEndIfDirect(Sender: TmwBasePasLex);
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000

  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtIfDefDirect(Sender: TmwBasePasLex);
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000

  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtIfNDefDirect(Sender: TmwBasePasLex);
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000

  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtIfOptDirect(Sender: TmwBasePasLex; Value: TbdBooleanDirectives; Active: Boolean);
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000

  { ToDo }
end;

function  TmwSimplePasPar.HandlePtIncludeDirect(Sender: TmwBasePasLex; Value: String): PChar ;
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000
  Result := nil;
  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtResourceDirect(Sender: TmwBasePasLex; Value: String);
begin
  //  Sender.NextNoJunk;
  ResourceIncluded(Value);
  //Sender.Next; //XM Jul-2000

  { ToDo }
end;

procedure TmwSimplePasPar.HandlePtUndefDirect(Sender: TmwBasePasLex; Value: String);
begin
  //  Sender.NextNoJunk;
  //Sender.Next; //XM Jul-2000

  { ToDo }
end;

procedure TmwSimplePasPar.NextToken;
begin
  fLexer.Next;
  SkipJunk;
end;

procedure TmwSimplePasPar.SkipJunk;
begin
  if Lexer.IsJunk then
    begin
      repeat
          case TokenID of
            ptAnsiComment:
              begin
                SkipAnsiComment;
              end;
            ptBorComment:
              begin
                SkipBorComment;
              end;
            ptSlashesComment:
              begin
                SkipSlashesComment;
              end;
            ptSpace:
              begin
                SkipSpace; //XM Jul-2000
              end;
            ptCRLFCo:
              begin
                SkipCRLFco;
              end;
            ptCRLF:
              begin
                SkipCRLF;
              end;
            else
              begin
                Lexer.Next;
              end;
          end;
      until not Lexer.IsJunk;
    end;
end;

procedure TmwSimplePasPar.SkipAnsiComment;
begin
  Expected(ptAnsiComment);
  while TokenID in [ptAnsiComment] do Lexer.Next;
end;

procedure TmwSimplePasPar.SkipBorComment;
begin
  Expected(ptBorComment);
  while TokenID in [ptBorComment] do Lexer.Next;
end;

procedure TmwSimplePasPar.SkipSlashesComment;
begin
  Expected(ptSlashesComment);
end;

procedure TmwSimplePasPar.TerminateStream;
var
  aChar: Char;
begin
  fStream.Position := fStream.Size;
  aChar := #0;
  fStream.Write(aChar, 1);
end;

procedure TmwSimplePasPar.SEMICOLON;
begin 
  case Lexer.TokenID of
    ptElse, ptEnd, ptExcept, ptfinally, ptFinalization, ptRoundClose, ptUntil:; // jdj 2.23.20001 added ptFinalization
    else
      Expected(ptSemiColon);
  end;
end;

function TmwSimplePasPar.GetExID: TptTokenKind;
begin
  Result := fLexer.ExID;
end;

function TmwSimplePasPar.GetTokenID: TptTokenKind;
begin
  Result := fLexer.TokenID;
end;

function TmwSimplePasPar.GetGenID: TptTokenKind;
begin
  Result := fLexer.GenID;
end;

procedure TmwSimplePasPar.SynError(Error: TmwParseError);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Self, ParserErrorName(Error) + ' found ' + fLexer.Token, fLexer.PosXY.X,
      fLexer.PosXY.Y);

end;

(******************************************************************************
 This part is oriented at the official grammar of Delphi 4
 and parialy based on Robert Zierers Delphi grammar.
 For more information about Delphi grammars take a look at:
 http://www.stud.mw.tu-muenchen.de/~rz1/Grammar.html
******************************************************************************)

procedure TmwSimplePasPar.ParseFile;
begin
  SkipJunk;
  case GenID of
    ptLibrary:
      begin
        LibraryFile;
      end;
    ptPackage:
      begin
        PackageFile;
      end;
    ptProgram:
      begin
        ProgramFile;
      end;
    ptUnit:
      begin
        UnitFile;
      end;
    else
      begin
        IncludeFile;
      end;
  end;
end;

procedure TmwSimplePasPar.LibraryFile;
begin
  Expected(ptLibrary);
  Expected(ptIdentifier);
  SEMICOLON;
  ProgramBlock;
  Expected(ptPoint);
end;

procedure TmwSimplePasPar.PackageFile;
begin
  ExpectedEx(ptPackage);
  Expected(ptIdentifier);
  SEMICOLON;
  case ExID of
    ptRequires:
      begin
        RequiresClause;
      end;
  end;
  case ExID of
    ptContains:
      begin
        ContainsClause;
      end;
  end;
  Expected(ptEnd);
  Expected(ptPoint);
end;

procedure TmwSimplePasPar.ProgramFile;
begin
  Expected(ptProgram);
  Expected(ptIdentifier);
  if TokenID = ptRoundOpen then
    begin
      NextToken;
      IdentifierList;
      Expected(ptRoundClose);
    end;
  SEMICOLON;
  ProgramBlock;
  Expected(ptPoint);
end;

procedure TmwSimplePasPar.UnitFile;
begin
  Expected(ptUnit);
  //Expected(ptIdentifier);
  UnitName;            // MAE 20030727
  SEMICOLON;
  InterfaceSection;
  ImplementationSection;
  InitializationSection;
  Expected(ptPoint);
end;

procedure TmwSimplePasPar.UnitName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ProgramBlock;
begin
  if TokenID = ptUses then
    begin
      MainUsesClause;
    end;
  Block;
end;

procedure TmwSimplePasPar.MainUsesClause;
begin
  Expected(ptUses);
  MainUsedUnitStatement;
  while TokenID = ptComma do
    begin
      NextToken;
      MainUsedUnitStatement;
    end;
  SEMICOLON;
end;

procedure TmwSimplePasPar.MainUsedUnitStatement;
begin
  MainUsedUnitName;
  if Lexer.TokenID = ptIn then
    begin
      NextToken;
      MainUsedUnitExpression;
    end;
end;

procedure TmwSimplePasPar.MainUsedUnitName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.MainUsedUnitExpression;
begin
  ConstantExpression;
end;

procedure TmwSimplePasPar.UsesClause;
begin
  Expected(ptUses);
  UsedUnitsList;
  SEMICOLON;
end;

procedure TmwSimplePasPar.UsedUnitsList;
begin
  UsedUnitName;
  while TokenID = ptComma do
    begin
      NextToken;
      UsedUnitName;
    end;
end;

procedure TmwSimplePasPar.UsedUnitName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.Block;
begin
  while TokenID in [ptClass, ptConst, ptConstructor, ptDestructor, ptExports,
    ptFunction, ptLabel, ptProcedure, ptResourceString, ptThreadVar, ptType,
    ptVar] do
    begin
      DeclarationSection;
    end;
  case TokenID of
    ptAsm:
      begin
        AsmStatement;
      end;
    else
      begin
        CompoundStatement;
      end;
  end;
end;

procedure TmwSimplePasPar.DeclarationSection;
begin
  case TokenID of
    ptClass:
      begin
        ProcedureDeclarationSection;
      end;
    ptConst:
      begin
        ConstSection;
      end;
    ptConstructor:
      begin
        ProcedureDeclarationSection;
      end;
    ptDestructor:
      begin
        ProcedureDeclarationSection;
      end;
    ptExports:
      begin
        ExportsClause;
      end;
    ptFunction:
      begin
        ProcedureDeclarationSection;
      end;
    ptLabel:
      begin
        LabelDeclarationSection;
      end;
    ptProcedure:
      begin
        ProcedureDeclarationSection;
      end;
    ptResourceString:
      begin
        ConstSection;
      end;
    ptType:
      begin
        TypeSection;
      end;
    ptThreadVar:
      begin
        VarSection;
      end;
    ptVar:
      begin
        VarSection;
      end;
    else
      begin
        SynError(InvalidDeclarationSection);
      end;
  end;
end;

procedure TmwSimplePasPar.UnitId;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.InterfaceHeritage;
begin
  Expected(ptRoundOpen);
  IdentifierList;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.InterfaceGUID;
begin
  Expected(ptSquareOpen);
  CharString;
  Expected(ptSquareClose);
end;

procedure TmwSimplePasPar.AccessSpecifier;
begin
  case ExID of
    ptRead:
      begin
        NextToken;
        ReadAccessIdentifier;
      end;
    ptWrite:
      begin
        NextToken;
        WriteAccessIdentifier;
      end;
    ptReadOnly:
      begin
        NextToken;
      end;
    ptWriteOnly:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidAccessSpecifier);
      end;
  end;
end;

procedure TmwSimplePasPar.ReadAccessIdentifier;
begin
  QualifiedIdentifier;
  (* XM removed at Martin suggestion. Martin send a more general fix in QualifiedIdentifier
    //jdj 12/05/2000
    if (TokenID =  ptSquareOpen) then
      begin
        ConstantExpression;
      end;
    //jdj 12/05/2000*)
end;

procedure TmwSimplePasPar.WriteAccessIdentifier;
begin
  QualifiedIdentifier;
  (* XM removed at Martin suggestion. Martin send a more general fix in QualifiedIdentifier
   //jdj 12/05/2000
    if (TokenID =  ptSquareOpen) then
      begin
        ConstantExpression;
      end;
    //jdj 12/05/2000*)
end;

procedure TmwSimplePasPar.StorageSpecifier;
begin
  case ExID of
    ptStored:
      begin
        StorageStored;
      end;
    ptDefault:
      begin
        StorageDefault;
      end;
    ptNoDefault:
      begin
        StorageNoDefault;
      end
    else
      begin
        SynError(InvalidStorageSpecifier);
      end;
  end;
end;

procedure TmwSimplePasPar.StorageDefault;
begin
  ExpectedEx(ptDefault);
      StorageExpression;
end;

procedure TmwSimplePasPar.StorageNoDefault;
begin
  ExpectedEx(ptNoDefault);
end;

procedure TmwSimplePasPar.StorageStored;
begin
  ExpectedEx(ptStored);
  case TokenID of
    ptIdentifier:
      begin
        StorageIdentifier;
      end;
    else
      if TokenID <> ptSemiColon then
        begin
          StorageExpression;
        end;
  end;
end;

procedure TmwSimplePasPar.StorageExpression;
begin
  ConstantExpression;
end;

procedure TmwSimplePasPar.StorageIdentifier;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.PropertyParameterList;
//changed James Jacobson on 20001221
begin
  Expected(ptSquareOpen);
  if TokenID = ptConst then
    begin
      PropertyParameterConst;
    end;
  IdentifierList;
  Expected(ptColon);
  TypeId;
  while TokenID = ptSemiColon do
    begin
      SEMICOLON;
      if TokenID = ptConst then
        begin //jdj 12-21-2000
          PropertyParameterConst;
        end;
      IdentifierList;
      Expected(ptColon);
      TypeId;
    end;
  Expected(ptSquareClose);
end;

(*begin
  Expected(ptSquareOpen);
  if TokenID = ptConst then
  begin
    PropertyParameterConst;
  end;
  IdentifierList;
  Expected(ptColon);
  TypeId;
  while TokenID = ptSemiColon do
  begin
    SEMICOLON;
    IdentifierList;
    Expected(ptColon);
    TypeId;
  end;
  Expected(ptSquareClose);
end;*)

procedure TmwSimplePasPar.PropertyParameterConst;
begin
  Expected(ptConst);
end;

procedure TmwSimplePasPar.PropertyDirective;
begin
  ExpectedEx(ptDefault);
  SEMICOLON;
end;

procedure TmwSimplePasPar.PropertySpecifiers;
begin
  if ExID = ptIndex then
    begin
      NextToken;
      ConstantExpression;
    end;
  while ExID in [ptRead, ptReadOnly, ptWrite, ptWriteOnly] do
    begin
      AccessSpecifier;
    end;
  if ExID = ptDispId then
    begin
      NextToken;
      ConstantExpression;
    end;
  while ExID in [ptDefault, ptNoDefault, ptStored] do
    begin
      StorageSpecifier;
    end;
  if ExID = ptImplements then
    PropertyImplements;
  SEMICOLON;
end;

procedure TmwSimplePasPar.PropertyImplements;
begin
  NextToken;
  QualifiedIdentifierList;
end;

procedure TmwSimplePasPar.PropertyInterface;
begin
  if TokenID = ptSquareOpen then
    begin
      PropertyParameterList;
    end;
  Expected(ptColon);
  TypeID;
end;

procedure TmwSimplePasPar.ClassMethodHeading;
begin
  case TokenID of
    ptConstructor:
      begin
        ConstructorHeading;
      end;
    ptDestructor:
      begin
        DestructorHeading;
      end;
    ptFunction:
      begin
        Lexer.InitAhead;
        Lexer.AheadNext;
        case Lexer.AheadTokenID of
          PtPoint:
            begin
              ClassMethodResolution;
            end;
          else
            begin
              ClassFunctionHeading;
            end;
        end;
      end;
    ptProcedure:
      begin
        Lexer.InitAhead;
        Lexer.AheadNext;
        case Lexer.AheadTokenID of
          PtPoint:
            begin
              ClassMethodResolution;
            end;
          else
            begin
              ClassProcedureHeading;
            end;
        end;
      end;
    else SynError(InvalidClassMethodHeading);
  end;
end;

procedure TmwSimplePasPar.ClassFunctionHeading;
begin
  Expected(ptFunction);
  FunctionMethodName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  Expected(ptColon);
  ReturnType;
  SEMICOLON;
  if ExID = ptDispId then
    begin
      NextToken;
      ConstantExpression;
      SEMICOLON;
    end;
  ClassMethodDirective;
end;

procedure TmwSimplePasPar.FunctionMethodName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ClassProcedureHeading;
begin
  Expected(ptProcedure);
  ProcedureMethodName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  SEMICOLON;
  if ExID = ptDispId then
    begin
      NextToken;
      ConstantExpression;
      SEMICOLON;
    end;
  ClassMethodDirective;
end;

procedure TmwSimplePasPar.ProcedureMethodName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ClassMemberType;
begin
  NextToken;
end;

procedure TmwSimplePasPar.ClassMethodResolution;
begin
  case TokenID of
    ptFunction:
      begin
        NextToken;
      end;
    ptProcedure:
      begin
        NextToken;
      end;
  end;
  ResolutionInterfaceName;
  Expected(ptPoint);
  Expected(ptIdentifier);
  Expected(ptEqual);
  Expected(ptIdentifier);
  SEMICOLON;
end;

procedure TmwSimplePasPar.ResolutionInterfaceName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ConstructorHeading;
begin
  Expected(ptConstructor);
  ConstructorName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  SEMICOLON;
  ClassMethodDirective;
end;

procedure TmwSimplePasPar.ConstructorName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.DestructorHeading;
begin
  Expected(ptDestructor);
  DestructorName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  SEMICOLON;
  ClassMethodDirective;
end;

procedure TmwSimplePasPar.DestructorName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ClassMethodDirective;
begin
  while ExId in [ptAbstract, ptCdecl, ptDynamic, ptMessage, ptOverride,
    ptOverload, ptPascal, ptRegister, ptReintroduce, ptSafeCall, ptStdCall,
    ptVirtual] do
    begin
      ProceduralDirective;
      SEMICOLON;
    end;
end;

procedure TmwSimplePasPar.ObjectMethodHeading;
begin
  case TokenID of
    ptConstructor:
      begin
        ObjectConstructorHeading;
      end;
    ptDestructor:
      begin
        ObjectDestructorHeading;
      end;
    ptFunction:
      begin
        ObjectFunctionHeading;
      end;
    ptProcedure:
      begin
        ObjectProcedureHeading;
      end;
    else
      begin
        SynError(InvalidMethodHeading);
      end;
  end;
end;

procedure TmwSimplePasPar.ObjectFunctionHeading;
begin
  Expected(ptFunction);
  FunctionMethodName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  Expected(ptColon);
  ReturnType;
  if TokenID = ptSemiColon then SEMICOLON;
  ObjectMethodDirective;
end;

procedure TmwSimplePasPar.ObjectProcedureHeading;
begin
  Expected(ptProcedure);
  ProcedureMethodName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  if TokenID = ptSemiColon then SEMICOLON;
  ObjectMethodDirective;
end;

procedure TmwSimplePasPar.ObjectConstructorHeading;
begin
  Expected(ptConstructor);
  ConstructorName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  if TokenID = ptSemiColon then SEMICOLON;
  ObjectMethodDirective;
end;

procedure TmwSimplePasPar.ObjectDestructorHeading;
begin
  Expected(ptDestructor);
  DestructorName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  if TokenID = ptSemiColon then SEMICOLON;
  ObjectMethodDirective;
end;

procedure TmwSimplePasPar.ObjectMethodDirective;
begin
  while ExID in [ptAbstract, ptCdecl, ptDynamic, ptExport, ptExternal, ptFar,
    ptMessage, ptNear, ptPascal, ptRegister, ptSafeCall, ptStdCall, ptVirtual] do
    begin
      ProceduralDirective;
      if TokenID = ptSemiColon then SEMICOLON;
    end;
end;

procedure TmwSimplePasPar.Directive16Bit;
begin
  case ExID of
    ptNear:
      begin
        NextToken;
      end;
    ptFar:
      begin
        NextToken;
      end;
    ptExport:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidDirective16Bit);
      end;
  end;
end;

procedure TmwSimplePasPar.DirectiveBinding;
begin
  case ExID of
    ptVirtual:
      begin
        NextToken;
      end;
    ptDynamic:
      begin
        NextToken;
      end;
    ptMessage:
      begin
        NextToken;
        ConstantExpression;
      end;
    ptOverride:
      begin
        NextToken;
      end;
    ptOverload:
      begin
        NextToken;
      end;
    ptReintroduce:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidDirectiveBinding);
      end;
  end;
end;

procedure TmwSimplePasPar.ReturnType;
begin
  case TokenID of
    ptString:
      begin
        StringType;
      end;
    else
      begin
        TypeID;
      end;
  end;
end;

procedure TmwSimplePasPar.FormalParameterList;
begin
  Expected(ptRoundOpen);
  FormalParameterSection;
  while TokenID = ptSemiColon do
    begin
      SEMICOLON;
      FormalParameterSection;
    end;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.FormalParameterSection;
begin
  case TokenID of
    ptConst:
      begin
        ConstParameter;
      end;
    ptIdentifier:
      case ExID of
        ptOut: OutParameter;
        else
          ParameterFormal;
      end;
    ptIn:
      begin
        NextToken;
        ParameterFormal;
      end;
    ptVar:
      begin
        VarParameter;
      end;
  end;
end;

procedure TmwSimplePasPar.ConstParameter;
begin
  Expected(ptConst);
  ParameterNameList;
  case TokenID of
    ptColon:
      begin
        NextToken;
        NewFormalParameterType;
        if TokenID = ptEqual then
          begin
            NextToken;
            TypedConstant;
          end;
      end
  end;
end;

procedure TmwSimplePasPar.VarParameter;
begin
  Expected(ptVar);
  ParameterNameList;
  case TokenID of
    ptColon:
      begin
        NextToken;
        NewFormalParameterType;
      end
  end;
end;

procedure TmwSimplePasPar.OutParameter;
begin
  ExpectedEx(ptOut);
  ParameterNameList;
  case TokenID of
    ptColon:
      begin
        NextToken;
        NewFormalParameterType;
      end
  end;
end;

procedure TmwSimplePasPar.ParameterFormal;
begin
  case TokenID of
    ptIdentifier:
      begin
        ParameterNameList;
        Expected(ptColon);
        NewFormalParameterType;
        if TokenID = ptEqual then
          begin
            NextToken;
            TypedConstant;
          end;
      end;
    else
      begin
        SynError(InvalidParameter);
      end;
  end;
end;

procedure TmwSimplePasPar.ParameterNameList;
begin
  ParameterName;
  while TokenID = ptComma do
    begin
      NextToken;
      ParameterName;
    end;
end;

procedure TmwSimplePasPar.ParameterName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.NewFormalParameterType;
begin
  case TokenID of
    ptArray:
      begin
        NextToken;
        Expected(ptOf);
        case TokenID of
          ptConst: (*new in ObjectPascal80*)
            begin
              NextToken;
            end;
          else
            begin
              OldFormalParameterType;
            end;
        end;
      end;
    else
      begin
        OldFormalParameterType;
      end;
  end;
end;

procedure TmwSimplePasPar.OldFormalParameterType;
begin
  case TokenID of
    ptString:
      begin
        NextToken;
      end;
    else
      begin
        TypeID;
      end;
  end;
end;

procedure TmwSimplePasPar.FunctionMethodDeclaration;
begin
  Expected(ptFunction);
  Lexer.InitAhead;
  if Lexer.AheadTokenID = ptPoint then
    begin
      ObjectNameOfMethod;
      Expected(ptPoint);
    end;
  FunctionProcedureName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  case TokenID of
    ptSemiColon:
      begin
        FunctionProcedureBlock;
      end;
    else
      begin
        Expected(ptColon);
        ReturnType;
        FunctionProcedureBlock;
      end;
  end;
end;

procedure TmwSimplePasPar.ProcedureMethodDeclaration;
begin
  case TokenID of
    ptConstructor:
      begin
        NextToken;
      end;
    ptDestructor:
      begin
        NextToken;
      end;
    ptProcedure:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidProcedureMethodDeclaration);
      end;
  end;
  Lexer.InitAhead;
  if Lexer.AheadTokenID = ptPoint then
    begin
      ObjectNameOfMethod;
      Expected(ptPoint);
    end;
  FunctionProcedureName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  FunctionProcedureBlock;
end;

procedure TmwSimplePasPar.FunctionProcedureName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ObjectNameOfMethod;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.FunctionProcedureBlock;
var
  NoExternal: Boolean;
begin
  NoExternal := True;
  if TokenID = ptSemiColon then SEMICOLON;
  case ExID of
    ptForward:
      begin
        NextToken;
        SEMICOLON;
      end;
    else
      while ExID in [ptAbstract, ptCdecl, ptDynamic, ptExport, ptExternal, ptFar,
        ptMessage, ptNear, ptOverload, ptOverride, ptPascal, ptRegister,
        ptReintroduce, ptSafeCall, ptStdCall, ptVirtual] do
        begin
          case ExId of
            ptExternal:
              begin
                ProceduralDirective;
                if TokenID = ptSemiColon then SEMICOLON;
                NoExternal := False;
              end;
            else
              begin
                ProceduralDirective;
                if TokenID = ptSemiColon then SEMICOLON;
              end;
          end;
        end;
      if NoExternal then
        begin
          if ExId = ptAssembler then
            begin
              NextToken;
              SEMICOLON;
            end;
          case TokenID of
            ptAsm:
              begin
                AsmStatement;
              end;
            else
              begin
                Block;
              end;
          end;
          SEMICOLON;
        end;
  end;
end;

procedure TmwSimplePasPar.ExternalDirective;
begin
  ExpectedEx(ptExternal);
  case TokenID of
    ptSemiColon:
      begin
        SEMICOLON;
      end;
    else
      begin
        SimpleExpression;
        ExternalDirectiveTwo;
      end;
  end;
end;

procedure TmwSimplePasPar.ExternalDirectiveTwo;
begin
  case fLexer.ExID of
    ptIndex:
      begin
        NextToken;
      end;
    ptName:
      begin
        NextToken;
        SimpleExpression;
      end;
    ptSemiColon:
      begin
        SEMICOLON;
        ExternalDirectiveThree;
      end;
  end
end;

procedure TmwSimplePasPar.ExternalDirectiveThree;
begin
  case TokenID of
    ptMinus:
      begin
        NextToken;
      end;
  end;
  case TokenID of
    ptIdentifier, ptIntegerConst:
      begin
        NextToken;
      end;
  end;
end;

procedure TmwSimplePasPar.ForStatement;
begin
  Expected(ptFor);
  QualifiedIdentifier;
  Expected(ptAssign);
  Expression;
  case TokenID of
    ptTo:
      begin
        NextToken;
      end;
    ptDownTo:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidForStatement);
      end;
  end;
  Expression;
  Expected(ptDo);
  Statement;
end;

procedure TmwSimplePasPar.WhileStatement;
begin
  Expected(ptWhile);
  Expression;
  Expected(ptDo);
  Statement;
end;

procedure TmwSimplePasPar.RepeatStatement;
begin
  Expected(ptRepeat);
  StatementList;
  Expected(ptUntil);
  Expression;
end;

procedure TmwSimplePasPar.CaseStatement;
begin
  Expected(ptCase);
  Expression;
  Expected(ptOf);
  CaseSelector;
  while TokenID = ptSemiColon do
    begin
      SEMICOLON;
      case TokenID of
        ptElse, ptEnd:;
        else
          CaseSelector;
      end;
    end;
  if TokenID = ptElse then
    begin
      NextToken;
      StatementList;
      SEMICOLON;
    end;
  Expected(ptEnd);
end;

procedure TmwSimplePasPar.CaseSelector;
begin
  CaseLabel;
  while TokenID = ptComma do
    begin
      NextToken;
      CaseLabel;
    end;
  Expected(ptColon);
  case TokenID of
    ptSemiColon:;
    else
      Statement;
  end;
end;

procedure TmwSimplePasPar.CaseLabel;
begin
  ConstantExpression;
  if TokenID = ptDotDot then
    begin
      NextToken;
      ConstantExpression;
    end;
end;

procedure TmwSimplePasPar.IfStatement;
begin
  Expected(ptIf);
  Expression;
  Expected(ptThen);
  Statement;
  if TokenID = ptElse then
    begin
      NextToken;
      Statement;
    end;
end;

procedure TmwSimplePasPar.ExceptBlock;
begin
  case ExID of
    ptOn:
      begin
        ExceptionHandlerList;
        ExceptionBlockElseBranch
      end;
    else
      begin
        StatementList;
      end;
  end;
end;

procedure TmwSimplePasPar.ExceptionHandlerList;
begin
  while fLexer.ExID = ptOn do
    begin
      ExceptionHandler;
      SEMICOLON;
    end;
end;

procedure TmwSimplePasPar.ExceptionHandler;
begin
  ExpectedEx(ptOn);
  ExceptionIdentifier;
  Expected(ptDo);
  Statement;
end;

procedure TmwSimplePasPar.ExceptionBlockElseBranch;
begin
  case TokenID of
    ptElse:
      begin
        NextToken;
        StatementList;
      end;
  end;
end;

procedure TmwSimplePasPar.ExceptionIdentifier;
begin
  Lexer.InitAhead;
  case Lexer.AheadTokenID of
    ptPoint:
      begin
        ExceptionClassTypeIdentifier;
      end;
    else
      begin
        ExceptionVariable;
        case Lexer.TokenID of
          ptColon:
            begin
              NextToken;
              ExceptionClassTypeIdentifier;
            end;
        end;
      end;
  end;
end;

procedure TmwSimplePasPar.ExceptionClassTypeIdentifier;
begin
  QualifiedIdentifier;
end;

procedure TmwSimplePasPar.ExceptionVariable;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.InlineStatement;
begin
  Expected(ptInline);
  Expected(ptRoundOpen);
  Expected(ptIntegerConst);
  while(TokenID = ptSlash) do
    begin
      NextToken;
      Expected(ptIntegerConst);
    end;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.AsmStatement;
begin
  Expected(ptAsm);
  { should be replaced with a Assembler lexer }
  while TokenID <> ptEnd do
    case fLexer.TokenID of
      ptBegin, ptCase, ptEnd, ptIf, ptFunction, ptProcedure, ptRepeat, ptwhile: break;
      ptAddressOp:
        begin
          NextToken;
          NextToken;
        end;
      ptDoubleAddressOp:
        begin
          NextToken;
          NextToken;
        end;
      else NextToken;
    end;
  Expected(ptEnd);
end;

procedure TmwSimplePasPar.RaiseStatement;
begin
  Expected(ptRaise);
  case TokenID of
    ptAddressOp, ptDoubleAddressOp, ptIdentifier, ptPointerSymbol, ptRoundOpen:
      begin
        Designator;
      end;
  end;
  if ExID = ptAt then
    begin
      NextToken;
      Expression;
    end;
end;

procedure TmwSimplePasPar.TryStatement;
begin
  Expected(ptTry);
  StatementList;
  case TokenID of
    ptExcept:
      begin
        NextToken;
        ExceptBlock;
        Expected(ptEnd);
      end;
    ptFinally:
      begin
        NextToken;
        StatementList;
        Expected(ptEnd);
      end;
    else
      begin
        SynError(InvalidTryStatement);
      end;
  end;
end;

procedure TmwSimplePasPar.WithStatement;
begin
  Expected(ptWith);
  VariableList;
  Expected(ptDo);
  Statement;
end;

procedure TmwSimplePasPar.VariableList;
begin
  VariableReference; (* acessing func.recordfield not allowed here;as well as UNITNAMEID *)
  while fLexer.TokenID = ptComma do
    begin
      NextToken;
      VariableReference;
    end;
end;

procedure TmwSimplePasPar.StatementList;
begin {removed ptIntegerConst jdj-Put back in for labels}
  while TokenID in [ptAddressOp, ptAsm, ptBegin, ptCase, ptDoubleAddressOp,
    ptFor, ptGoTo, ptIdentifier, ptIf, ptInherited, ptInline, ptIntegerConst,
    ptPointerSymbol, ptRaise, ptRoundOpen, ptRepeat, ptSemiColon, ptString,
    ptTry, ptWhile, ptWith] do
    begin
      Statement;
      SEMICOLON;
    end;
end;

procedure TmwSimplePasPar.SimpleStatement;
begin
  case TokenID of
    ptAddressOp, ptDoubleAddressOp, ptIdentifier, ptPointerSymbol, ptRoundOpen:
      begin
        Designator;
        if TokenID = ptAssign then
          begin
            NextToken;
            if TokenID = ptInherited then
              begin
                NextToken;
              end;
            Expression;
          end;
      end;
    ptGoTo:
      begin
        NextToken;
        LabelId;
      end;
  end;
end;

procedure TmwSimplePasPar.Statement;
begin
  case TokenID of
    ptAsm:
      begin
        AsmStatement;
      end;
    ptBegin:
      begin
        CompoundStatement;
      end;
    ptCase:
      begin
        CaseStatement;
      end;
    ptFor:
      begin
        ForStatement;
      end;
    ptIf:
      begin
        IfStatement;
      end;
    ptIdentifier:
      begin
        fLexer.InitAhead;
        case Lexer.AheadTokenID of
          ptColon:
            begin
              LabeledStatement;
            end;
          else
            begin
              SimpleStatement;
            end;
        end;
      end;
    ptInherited:
      begin
        InheritedStatement;
      end;
    ptInLine:
      begin
        InlineStatement;
      end;
    ptIntegerConst:
      begin
        fLexer.InitAhead;
        case Lexer.AheadTokenID of
          ptColon:
            begin
              LabeledStatement;
            end;
          else
            begin
              SynError(InvalidLabeledStatement);
              fLexer.Next;
            end;
        end;
      end;
    ptRepeat:
      begin
        RepeatStatement;
      end;
    ptRaise:
      begin
        RaiseStatement;
      end;
    ptSemiColon:
      begin
        EmptyStatement;
      end;
    ptString:
      begin
        StringStatement;
      end;
    ptTry:
      begin
        TryStatement;
      end;
    ptWhile:
      begin
        WhileStatement;
      end;
    ptWith:
      begin
        WithStatement;
      end;
    else
      begin
        SimpleStatement;
      end;
  end;
end;

procedure TmwSimplePasPar.EmptyStatement;
begin
  { Nothing to do here.
    The semicolon will be removed in StatementList }
end;

procedure TmwSimplePasPar.InheritedStatement;
begin
  Expected(ptInherited);
  case TokenID of
    ptSemiColon:;
    else
      begin
        Statement;
      end;
  end;
end;

procedure TmwSimplePasPar.LabeledStatement;
begin
  case TokenID of
    ptIdentifier:
      begin
        NextToken;
        Expected(ptColon);
        Statement;
      end;
    ptIntegerConst:
      begin
        NextToken;
        Expected(ptColon);
        Statement;
      end;
    else
      begin
        SynError(InvalidLabeledStatement);
      end;
  end;
end;

procedure TmwSimplePasPar.StringStatement;
begin
  Expected(ptString);
  Statement;
end;

procedure TmwSimplePasPar.SetElement;
begin
  Expression;
  if TokenID = ptDotDot then
    begin
      NextToken;
      Expression;
    end;
end;

procedure TmwSimplePasPar.QualifiedIdentifier;
begin //mw 12/7/2000
  Expected(ptIdentifier);
  case TokenID of
    ptPoint:
      begin
        while TokenID = ptPoint do
          begin //jdj 1/7/2001
            NextToken;
            Expected(ptIdentifier);
            if (TokenID = ptSquareOpen) then
              begin
                ConstantExpression;
              end;
          end;
      end;
    ptSquareOpen:
      begin
        ConstantExpression;
      end;
  end;
(*  Expected(ptIdentifier); // old code for information removed in next versions
  case TokenID of
    ptPoint:
      begin
        NextToken;
        Expected(ptIdentifier);
        if (TokenID = ptSquareOpen) then
        begin
          ConstantExpression;
        end;
      end;
    ptSquareOpen: {MW 20001207}
      begin
        ConstantExpression;
      end;
  end;*)


end;

procedure TmwSimplePasPar.SetConstructor;
begin
  Expected(ptSquareOpen);
  SetElement;
  while TokenID = ptComma do
    begin
      NextToken;
      SetElement;
    end;
  Expected(ptSquareClose);
end;

procedure TmwSimplePasPar.Number;
begin
  case TokenID of
    ptFloat:
      begin
        NextToken;
      end;
    ptIntegerConst:
      begin
        NextToken;
      end;
    ptIdentifier:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidNumber);
      end;
  end;
end;

procedure TmwSimplePasPar.ExpressionList;
begin
  Expression;
  while TokenID = ptComma do
    begin
      NextToken;
      Expression;
    end;
end;

procedure TmwSimplePasPar.Designator;
begin
  VariableReference;
end;

procedure TmwSimplePasPar.MultiplicativeOperator;
begin
  case TokenID of
    ptAnd:
      begin
        NextToken;
      end;
    ptDiv:
      begin
        NextToken;
      end;
    ptMod:
      begin
        NextToken;
      end;
    ptShl:
      begin
        NextToken;
      end;
    ptShr:
      begin
        NextToken;
      end;
    ptSlash:
      begin
        NextToken;
      end;
    ptStar:
      begin
        NextToken;
      end;
    else
      begin SynError(InvalidMultiplicativeOperator);
      end;
  end;
end;

procedure TmwSimplePasPar.Factor;
begin
  case TokenID of
    ptAsciiChar, ptStringConst:
      begin
        CharString;
      end;
    ptAddressOp, ptDoubleAddressOp, ptIdentifier, ptInherited, ptPointerSymbol,
      ptRoundOpen:
      begin
        Designator;
      end;
    ptIntegerConst, ptFloat:
      begin
        Number;
      end;
    ptNil:
      begin
        NextToken;
      end;
    ptMinus:
      begin
        NextToken;
        Factor;
      end;
    ptNot:
      begin
        NextToken;
        Factor;
      end;
    ptPlus:
      begin
        NextToken;
        Factor;
      end;
    ptSquareOpen:
      begin
        SetConstructor;
      end;
    ptString:
      begin
        NextToken;
        Factor;
      end;
  end;
end;

procedure TmwSimplePasPar.AdditiveOperator;
begin
  if TokenID in [ptMinus, ptOr, ptPlus, ptXor] then
    begin
      case TokenID of
        ptMinus, ptPlus:
          begin
            while TokenID in [ptMinus, ptPlus] do
              case TokenID of
                ptMinus:
                  begin
                    NextToken;
                  end;
                ptPlus:
                  begin
                    NextToken;
                  end;
              end;
          end;
        ptOr:
          begin
            NextToken;
          end;
        ptXor:
          begin
            NextToken;
          end;
      end;
    end
  else
    begin
      SynError(InvalidAdditiveOperator);
    end;
end;

procedure TmwSimplePasPar.Term;
begin
  Factor;
  while TokenID in [ptAnd, ptDiv, ptMod, ptShl, ptShr, ptSlash, ptStar] do
    begin
      MultiplicativeOperator;
      Factor;
    end;
end;

procedure TmwSimplePasPar.RelativeOperator;
begin
  case TokenID of
    ptAs:
      begin
        NextToken;
      end;
    ptEqual:
      begin
        NextToken;
      end;
    ptGreater:
      begin
        NextToken;
      end;
    ptGreaterEqual:
      begin
        NextToken;
      end;
    ptIn:
      begin
        NextToken;
      end;
    ptIs:
      begin
        NextToken;
      end;
    ptLower:
      begin
        NextToken;
      end;
    ptLowerEqual:
      begin
        NextToken;
      end;
    ptNotEqual:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidRelativeOperator);
      end;
  end;
end;

procedure TmwSimplePasPar.SimpleExpression;
begin
  while TokenID in [ptMinus, ptPlus] do
    begin
      NextToken;
    end;
  Term;
  while TokenID in [ptMinus, ptOr, ptPlus, ptXor] do
    begin
      AdditiveOperator;
      Term;
    end;
end;

procedure TmwSimplePasPar.Expression;
begin
  SimpleExpression;
  case TokenID of
    ptEqual, ptGreater, ptGreaterEqual, ptLower, ptLowerEqual, ptIn, ptIs,
      ptNotEqual:
      begin
        RelativeOperator;
        SimpleExpression;
      end;
    ptColon:
      begin
        case fInRound of
          False:;
          True:
            while TokenID = ptColon do
              begin
                NextToken;
                SimpleExpression;
              end;
        end;
      end;
  end;
end;

procedure TmwSimplePasPar.VarDeclaration;
begin
  VarNameList;
  Expected(ptColon);
  TypeKind;
  case GenID of
    ptAbsolute:
      begin
        VarAbsolute;
      end;
    ptEqual:
      begin
        VarEqual;
      end;
  end;
end;

procedure TmwSimplePasPar.VarAbsolute;
begin
  ExpectedEx(ptAbsolute);
  ConstantValue;
end;

procedure TmwSimplePasPar.VarEqual;
begin
  Expected(ptEqual);
  ConstantValueTyped;
end;

procedure TmwSimplePasPar.VarNameList;
begin
  VarName;
  while TokenID = ptComma do
    begin
      NextToken;
      VarName;
    end;
end;

procedure TmwSimplePasPar.VarName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.DirectiveCalling;
begin
  case ExID of
    ptCdecl:
      begin
        NextToken;
      end;
    ptPascal:
      begin
        NextToken;
      end;
    ptRegister:
      begin
        NextToken;
      end;
    ptSafeCall:
      begin
        NextToken;
      end;
    ptStdCall:
      begin
        NextToken;
      end
    else
      begin
        SynError(InvalidDirectiveCalling);
      end;
  end;
end;

procedure TmwSimplePasPar.RecordVariant;
begin
  ConstantExpression;
  while(TokenID = ptComma) do
    begin
      NextToken;
      ConstantExpression;
    end;
  Expected(ptColon);
  Expected(ptRoundOpen);
  if TokenID = ptIdentifier then
    begin
      FieldList;
    end;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.VariantSection;
begin
  Expected(ptCase);
  TagField;
  Expected(ptOf);
  RecordVariant;
  while TokenID = ptSemiColon do
    begin
      SEMICOLON;
      case TokenID of
        ptElse, ptEnd:;
        else
          RecordVariant;
      end;
    end;
end;

procedure TmwSimplePasPar.TagField;
begin
  TagFieldName;
  case fLexer.TokenID of
    ptColon:
      begin
        NextToken;
        TagFieldTypeName;
      end;
  end;
end;

procedure TmwSimplePasPar.TagFieldName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.TagFieldTypeName;
begin
  QualifiedIdentifier;
end;

procedure TmwSimplePasPar.FieldDeclaration;
begin
  IdentifierList;
  Expected(ptColon);
  TypeKind;
end;

procedure TmwSimplePasPar.FieldList;
begin
  while TokenID = ptIdentifier do
    begin
      FieldDeclaration;
      SEMICOLON;
    end;
  if TokenID = ptCase then
    begin
      VariantSection;
    end;
  SEMICOLON;
end;

procedure TmwSimplePasPar.RecordType;
begin
  Expected(ptRecord);
  FieldList;
  Expected(ptEnd);
end;

procedure TmwSimplePasPar.FileType;
begin
  Expected(ptFile);
  if TokenID = ptOf then
    begin
      NextToken;
      TypeId;
    end;
end;

procedure TmwSimplePasPar.SetType;
begin
  Expected(ptSet);
  Expected(ptOf);
  OrdinalType;
end;

procedure TmwSimplePasPar.ArrayType;
begin
  Expected(ptArray);
  if TokenID = ptSquareOpen then
    begin
      NextToken;
      OrdinalType;
      while TokenID = ptComma do
        begin
          NextToken;
          OrdinalType;
        end;
      Expected(ptSquareClose);
    end;
  Expected(ptOf);
  TypeKind;
end;

procedure TmwSimplePasPar.EnumeratedType;
begin
  Expected(ptRoundOpen);
  IdentifierList;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.SubrangeType;
begin
  ConstantExpression;
  if TokenID = ptDotDot then
    begin
      NextToken;
      ConstantExpression;
    end;
end;

procedure TmwSimplePasPar.RealIdentifier;
begin
  case ExID of
    ptReal48:
      begin
        NextToken;
      end;
    ptReal:
      begin
        NextToken;
      end;
    ptSingle:
      begin
        NextToken;
      end;
    ptDouble:
      begin
        NextToken;
      end;
    ptExtended:
      begin
        NextToken;
      end;
    ptCurrency:
      begin
        NextToken;
      end;
    ptComp:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidRealIdentifier);
      end;
  end;
end;

procedure TmwSimplePasPar.RealType;
begin
  case TokenID of
    ptMinus:
      begin
        NextToken;
      end;
    ptPlus:
      begin
        NextToken;
      end;
  end;
  case TokenId of
    ptFloat:
      begin
        NextToken;
      end;
    else
      begin
        VariableReference;
      end;
  end;
end;

procedure TmwSimplePasPar.OrdinalIdentifier;
begin
  case ExID of
    ptBoolean:
      begin
        NextToken;
      end;
    ptByte:
      begin
        NextToken;
      end;
    ptBytebool:
      begin
        NextToken;
      end;
    ptCardinal:
      begin
        NextToken;
      end;
    ptChar:
      begin
        NextToken;
      end;
    ptDWord:
      begin
        NextToken;
      end;
    ptInt64:
      begin
        NextToken;
      end;
    ptInteger:
      begin
        NextToken;
      end;
    ptLongBool:
      begin
        NextToken;
      end;
    ptLongInt:
      begin
        NextToken;
      end;
    ptLongWord:
      begin
        NextToken;
      end;
    ptPChar:
      begin
        NextToken;
      end;
    ptShortInt:
      begin
        NextToken;
      end;
    ptSmallInt:
      begin
        NextToken;
      end;
    ptWideChar:
      begin
        NextToken;
      end;
    ptWord:
      begin
        NextToken;
      end;
    ptWordbool:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidOrdinalIdentifier);
      end;
  end;
end;

procedure TmwSimplePasPar.OrdinalType;
begin
  case TokenID of
    ptIdentifier:
      begin
        Lexer.InitAhead;
        case Lexer.AheadTokenID of
          ptPoint:
            begin
              Expression;
            end;
          ptRoundOpen:
            begin //jdj
              ConstantExpression;
            end;
          else
            begin
              TypeID;
            end;
        end;
      end;
    ptRoundOpen:
      begin
        EnumeratedType;
      end;
    ptSquareOpen:
      begin
        NextToken;
        SubrangeType;
        Expected(ptSquareClose);
      end;
    else
      begin
        Expression;
      end;
  end;
  if TokenID = ptDotDot then
    begin
      NextToken;
      ConstantExpression;
    end;
end;

procedure TmwSimplePasPar.VariableReference;
begin
  case TokenID of
    ptAddressOp:
      begin
        NextToken;
        variable;
      end;
    ptDoubleAddressOp:
      begin
        NextToken;
        variable;
      end;
    ptPointerSymbol:
      begin
        NextToken;
        case TokenID of
          ptRoundClose, ptSquareClose:;
          else
            begin
              variable;
            end;
        end;
      end;
    else variable;
  end;
end;

procedure TmwSimplePasPar.Variable; (* Attention: could also came from proc_call !! *)
begin
  case TokenID of
    ptInherited:
      begin
        NextToken;
        QualifiedIdentifier;
      end;
    ptPoint:
      begin
        VariableTwo;
      end;
    ptPointerSymbol:
      begin
        VariableTwo;
      end;
    ptRoundOpen:
      begin
        VariableTwo;
      end;
    ptSquareOpen:
      begin
        VariableTwo;
      end;
    else QualifiedIdentifier;
  end;
  VariableTwo;
  case TokenID of
    ptAs:
      begin
        NextToken;
        QualifiedIdentifier;
      end;
  end;
end;

procedure TmwSimplePasPar.VariableTwo;
begin
  case TokenID of
    ptPoint:
      begin
        NextToken;
        case TokenID of
          ptAddressOp, ptDoubleAddressOp, ptIdentifier:
            begin
              VariableReference;
            end;
          ptPointerSymbol, ptRoundOpen, ptSquareOpen:
            begin
              VariableTwo;
            end;
        end;
      end;
    ptPointerSymbol:
      begin
        NextToken;
        case TokenID of
          ptAddressOp, ptDoubleAddressOp, ptIdentifier:
            begin
              VariableReference;
            end;
          ptPoint, ptPointerSymbol, ptRoundOpen, ptSquareOpen:
            begin
              VariableTwo;
            end;
        end;
      end;
    ptRoundOpen:
      begin
        NextToken;
        fInRound := True;
        case TokenID of
          ptRoundClose:
            begin
              NextToken;
            end;
          else
            begin
              case TokenID of
                ptAddressOp, ptDoubleAddressOp:
                  begin
                    VariableReference;
                  end;
                ptPoint, ptPointerSymbol, ptRoundOpen, ptSquareOpen:
                  begin
                    VariableTwo;
                  end;
              end;
              fInRound := True;
              ExpressionList;
              fInRound := True;
              Expected(ptRoundClose);
              fInRound := False;
            end;
        end;
        case TokenID of
          ptAddressOp, ptDoubleAddressOp:
            begin
              VariableReference;
            end;
          ptPoint, ptPointerSymbol, ptRoundOpen, ptSquareOpen:
            begin
              VariableTwo;
            end;
        end;
      end;
    ptSquareOpen:
      begin
        Lexer.InitAhead;
        while Lexer.AheadTokenID <> ptSemiColon do
          begin
            case Lexer.AheadTokenID of
              ptBegin, ptClass, ptConst, ptEnd, ptDotDot, ptIn, ptNull, ptThreadVar, ptType,
                ptVar: break;
              else
                Lexer.AheadNext;
            end;
          end;
        case Lexer.AheadTokenID of
          ptDotDot:
            begin
              SubrangeType;
            end;
          else
            begin
              NextToken;
              case TokenID of
                ptSquareClose:
                  begin
                    NextToken;
                  end;
                else
                  begin
                    case TokenID of
                      ptAddressOp, ptDoubleAddressOp:
                        begin
                          VariableReference;
                        end;
                      ptPoint, ptPointerSymbol, ptRoundOpen, ptSquareOpen:
                        begin
                          VariableTwo;
                        end;
                    end;
                    ExpressionList;
                    Expected(ptSquareClose);
                  end;
              end;
              case TokenID of
                ptAddressOp, ptDoubleAddressOp:
                  begin
                    VariableReference;
                  end;
                ptPoint, ptPointerSymbol, ptRoundOpen, ptSquareOpen:
                  begin
                    VariableTwo;
                  end;
              end;

            end;
        end;
      end
  end;
end;

procedure TmwSimplePasPar.InterfaceType;
begin
  case TokenID of
    ptInterface:
      begin
        NextToken;
      end;
    ptDispInterface:
      begin
        NextToken;
      end
    else
      begin
        SynError(InvalidInterfaceType);
      end;
  end;
  case TokenID of
    ptEnd:
      begin
        NextToken; { Direct descendant without new members }
      end;
    ptRoundOpen:
      begin
        InterfaceHeritage;
        case TokenID of
          ptEnd:
            begin
              NextToken; { No new members }
            end;
          ptSemiColon:; { No new members }
          else
            begin
              if TokenID = ptSquareOpen then
                begin
                  InterfaceGUID;
                end;
              InterfaceMemberList;
              Expected(ptEnd);
            end;
        end;
      end;
    else
      begin
        if TokenID = ptSquareOpen then
          begin
            InterfaceGUID;
          end;
        InterfaceMemberList; { Direct descendant }
        Expected(ptEnd);
      end;
  end;
end;

procedure TmwSimplePasPar.InterfaceMemberList;
begin
  while TokenID in [ptFunction, ptProcedure, ptProperty] do
    begin
      ClassMethodOrProperty;
    end;
end;

procedure TmwSimplePasPar.ClassType;
begin
  Expected(ptClass);
  case TokenID of
    ptEnd:
      begin
        NextToken; { Direct descendant of TObject without new members }
      end;
    ptRoundOpen:
      begin
        ClassHeritage;
        case TokenID of
          ptEnd:
            begin
              NextToken; { No new members }
            end;
          ptSemiColon:; { No new members }
          else
            begin
              ClassMemberList;
              Expected(ptEnd);
            end;
        end;
      end;
    else
      begin
        ClassMemberList; { Direct descendant of TObject }
        Expected(ptEnd);
      end;
  end;
end;

procedure TmwSimplePasPar.ClassHeritage;
begin
  Expected(ptRoundOpen);
  QualifiedIdentifierList;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.ClassVisibility;
begin
  while ExID in [ptAutomated, ptPrivate, ptProtected, ptPublic, ptPublished] do
    begin
      Lexer.InitAhead;
      case Lexer.AheadExID of
        ptColon, ptComma:;
        else
          case ExID of
            ptAutomated:
              begin
                VisibilityAutomated;
              end;
            ptPrivate:
              begin
                VisibilityPrivate;
              end;
            ptProtected:
              begin
                VisibilityProtected;
              end;
            ptPublic:
              begin
                VisibilityPublic;
              end;
            ptPublished:
              begin
                VisibilityPublished;
              end;
          end;
      end;
    end;
end;

procedure TmwSimplePasPar.VisibilityAutomated;
begin
  ExpectedEx(ptAutomated);
end;

procedure TmwSimplePasPar.VisibilityPrivate;
begin
  ExpectedEx(ptPrivate);
end;

procedure TmwSimplePasPar.VisibilityProtected;
begin
  ExpectedEx(ptProtected);
end;

procedure TmwSimplePasPar.VisibilityPublic;
begin
  ExpectedEx(ptPublic);
end;

procedure TmwSimplePasPar.VisibilityPublished;
begin
  ExpectedEx(ptPublished);
end;

procedure TmwSimplePasPar.VisibilityUnknown;
begin
  //
end;

procedure TmwSimplePasPar.ClassMemberList;
begin
  ClassVisibility;
  while TokenID in [ptClass, ptConstructor, ptDestructor, ptFunction,
    ptIdentifier, ptProcedure, ptProperty] do
    begin
      while TokenID = ptIdentifier do
        begin
          ClassField;
          SEMICOLON;
          ClassVisibility;
        end;
      while TokenID in [ptClass, ptConstructor, ptDestructor, ptFunction,
        ptProcedure, ptProperty] do
        begin
          ClassMethodOrProperty;
        end;
      ClassVisibility;
    end;
end;

procedure TmwSimplePasPar.ClassMethodOrProperty;
begin
  if TokenID = ptClass then
    begin
      ClassMemberType;
    end;
  case TokenID of
    ptProperty:
      begin
        ClassProperty;
      end;
    else
      begin
        ClassMethodHeading;
      end;
  end;
end;

procedure TmwSimplePasPar.ClassProperty;
var IsArrayProperty: boolean;
begin
  Expected(ptProperty);
  PropertyName;
  case TokenID of
    ptColon, ptSquareOpen:
      begin
        IsArrayProperty:= TokenID = ptSquareOpen;
        PropertyInterface;
      end;
    else IsArrayProperty:= false;
  end;
  PropertySpecifiers;
  if IsArrayProperty then
    {check for default array property}
    case ExID of
      ptDefault:
        PropertyDirective;
    end;
end;

procedure TmwSimplePasPar.PropertyName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ClassField;
begin
  IdentifierList;
  Expected(ptColon);
  TypeKind;
end;

procedure TmwSimplePasPar.ObjectType;
begin
  Expected(ptObject);
  case TokenID of
    ptEnd:
      begin
        NextToken; { Direct descendant without new members }
      end;
    ptRoundOpen:
      begin
        ObjectHeritage;
        case TokenID of
          ptEnd:
            begin
              NextToken; { No new members }
            end;
          ptSemiColon:; { No new members }
          else
            begin
              ObjectMemberList;
              Expected(ptEnd);
            end;
        end;
      end;
    else
      begin
        ObjectMemberList; { Direct descendant }
        Expected(ptEnd);
      end;
  end;
end;

procedure TmwSimplePasPar.ObjectHeritage;
begin
  Expected(ptRoundOpen);
  QualifiedIdentifier;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.ObjectMemberList;
begin {jdj added ptProperty-call to ObjectProperty 02/07/2001}
  ObjectVisibility;
  while TokenID in [ptConstructor, ptDestructor, ptFunction, ptIdentifier,
    ptProcedure, ptProperty] do
    begin
      while TokenID = ptIdentifier do
        begin
          ObjectField;
          SEMICOLON;
          ObjectVisibility;
        end;
      while TokenID in [ptConstructor, ptDestructor, ptFunction, ptProcedure, ptProperty] do
        begin
          case TokenID of
            ptConstructor, ptDestructor, ptFunction, ptProcedure:
              ObjectMethodHeading;
            ptProperty:
              ObjectProperty;
          end;
        end;
      ObjectVisibility;
    end;
end;

procedure TmwSimplePasPar.ObjectVisibility;
begin
  while ExID in [ptPrivate, ptProtected, ptPublic] do
    begin
      Lexer.InitAhead;
      case Lexer.AheadExID of
        ptColon, ptComma:;
        else
          case ExID of
            ptPrivate:
              begin
                VisibilityPrivate;
              end;
            ptProtected:
              begin
                VisibilityProtected;
              end;
            ptPublic:
              begin
                VisibilityPublic;
              end;
          end;
      end;
    end;
end;

procedure TmwSimplePasPar.ObjectField;
begin
  IdentifierList;
  Expected(ptColon);
  TypeKind;
end;

procedure TmwSimplePasPar.ClassReferenceType;
begin
  Expected(ptClass);
  Expected(ptOf);
  TypeId;
end;

procedure TmwSimplePasPar.VariantIdentifier;
begin
  case ExID of
    ptOleVariant:
      begin
        NextToken;
      end;
    ptVariant:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidVariantIdentifier);
      end;
  end;
end;

procedure TmwSimplePasPar.ProceduralType;
var
  TheTokenID: TptTokenKind;
begin
  case TokenID of
    ptFunction:
      begin
        NextToken;
        if TokenID = ptRoundOpen then
          begin
            FormalParameterList;
          end;
        Expected(ptColon);
        ReturnType;
      end;
    ptProcedure:
      begin
        NextToken;
        if TokenID = ptRoundOpen then
          begin
            FormalParameterList;
          end;
      end;
    else
      begin
        SynError(InvalidProceduralType);
      end;
  end;
  if TokenID = ptOf then
    begin
      NextToken;
      Expected(ptObject);
    end;
  Lexer.InitAhead;
  case TokenID of
    ptSemiColon: TheTokenID := Lexer.AheadExID;
    else TheTokenID := ExID;
  end;
  while TheTokenID in [ptAbstract, ptCdecl, ptDynamic, ptExport, ptExternal, ptFar,
    ptMessage, ptNear, ptOverload, ptOverride, ptPascal, ptRegister,
    ptReintroduce, ptSafeCall, ptStdCall, ptVirtual] do
    begin
      if TokenID = ptSemiColon then SEMICOLON;
      ProceduralDirective;
      Lexer.InitAhead;
      case TokenID of
        ptSemiColon: TheTokenID := Lexer.AheadExID;
        else TheTokenID := ExID;
      end;
    end;
end;

procedure TmwSimplePasPar.StringIdentifier;
begin
  case ExID of
    ptAnsiString:
      begin
        NextToken;
      end;
    ptShortString:
      begin
        NextToken;
      end;
    ptWideString:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidStringIdentifier);
      end;
  end;
end;

procedure TmwSimplePasPar.StringType;
begin
  case TokenID of
    ptString:
      begin
        NextToken;
        if TokenID = ptSquareOpen then
          begin
            NextToken;
            ConstantExpression;
            Expected(ptSquareClose);
          end;
      end;
    else
      begin
        VariableReference;
      end;
  end;
end;

procedure TmwSimplePasPar.PointerType;
begin
  Expected(ptPointerSymbol);
  TypeId;
end;

procedure TmwSimplePasPar.StructuredType;
begin
  if TokenID = ptPacked then
    begin
      NextToken;
    end;
  case TokenID of
    ptArray:
      begin
        ArrayType;
      end;
    ptFile:
      begin
        FileType;
      end;
    ptRecord:
      begin
        RecordType;
      end;
    ptSet:
      begin
        SetType;
      end;
    else
      begin
        SynError(InvalidStructuredType);
      end;
  end;
end;

procedure TmwSimplePasPar.SimpleType;
begin
  case TokenID of
    ptMinus:
      begin
        NextToken;
      end;
    ptPlus:
      begin
        NextToken;
      end;
  end;
  case fLexer.TokenID of
    ptAsciiChar, ptIntegerConst:
      begin
        OrdinalType;
      end;
    ptFloat:
      begin
        RealType;
      end;
    ptIdentifier:
      begin
        fLexer.InitAhead;
        case Lexer.AheadTokenID of
          ptPoint, ptSemiColon:
            begin
              TypeID;
            end;
          else
            begin
              SimpleExpression;
              if fLexer.TokenID = ptDotDot then
                begin
                  NextToken;
                  SimpleExpression;
                end;
            end;
        end;
      end;
    ptRoundOpen:
      begin
        EnumeratedType;
      end;
    ptSquareOpen:
      begin
        SubrangeType;
      end;
    else
      begin
        VariableReference;
      end;
  end;
end;

procedure TmwSimplePasPar.RecordFieldConstant;
begin
  Expected(ptIdentifier);
  Expected(ptColon);
  TypedConstant;
end;

procedure TmwSimplePasPar.RecordConstant;
begin
  Expected(ptRoundOpen);
  RecordFieldConstant;
  while(TokenID = ptSemiColon) do
    begin
      SEMICOLON;
      if TokenId <> ptRoundClose then //jdj 2.23.2001
      RecordFieldConstant;
    end;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.ArrayConstant;
begin
  Expected(ptRoundOpen);
  TypedConstant;
  while(TokenID = ptComma) do
    begin
      NextToken;
      TypedConstant;
    end;
  Expected(ptRoundClose);
end;

procedure TmwSimplePasPar.ClassForward;
begin
  Expected(ptClass);
end;

procedure TmwSimplePasPar.DispInterfaceForward;
begin
  Expected(ptDispInterface);
end;

procedure TmwSimplePasPar.InterfaceForward;
begin
  Expected(ptInterface);
end;

procedure TmwSimplePasPar.ObjectForward;
begin
  Expected(ptObject);
end;

procedure TmwSimplePasPar.TypeDeclaration;
begin
  TypeName;
  Expected(ptEqual);
  if TokenID = ptType then
    begin
      ExpliciteType;
    end;
  Lexer.InitAhead;
  case TokenID of
    ptClass:
      begin
        case Lexer.AheadTokenID of
          ptOf:
            begin
              ClassReferenceType;
            end;
          ptSemiColon:
            begin
              ClassForward;
            end;
          else
            begin
              ClassType;
            end;
        end;
      end;
    ptInterface:
      begin
        case Lexer.AheadTokenID of
          ptSemiColon:
            begin
              InterfaceForward;
            end;
          else
            begin
              InterfaceType;
            end;
        end;
      end;
    ptDispInterface:
      begin
        case Lexer.AheadTokenID of
          ptSemiColon:
            begin
              DispInterfaceForward;
            end;
          else
            begin
              InterfaceType;
            end;
        end;
      end;
    ptObject:
      begin
        case Lexer.AheadTokenID of
          ptSemiColon:
            begin
              ObjectForward;
            end;
          else
            begin
              ObjectType;
            end;
        end;
      end;
    else
      begin
        TypeKind;
      end;
  end;
end;

procedure TmwSimplePasPar.TypeName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ExpliciteType;
begin
  Expected(ptType);
end;

procedure TmwSimplePasPar.TypeKind;
begin
  case TokenID of
    ptAsciiChar, ptFloat, ptIntegerConst, ptMinus, ptNil, ptPlus, ptRoundOpen,
      ptSquareOpen, ptStringConst:
      begin
        SimpleType;
      end;
    ptArray, ptFile, ptPacked, ptRecord, ptSet:
      begin
        StructuredType;
      end;
    ptFunction, ptProcedure:
      begin
        ProceduralType;
      end;
    ptIdentifier:
      begin
        Lexer.InitAhead;
        case Lexer.AheadTokenID of
          ptPoint, ptSemiColon:
            begin
              TypeId;
            end;
          else
            begin
              SimpleExpression;
              if Lexer.TokenID = ptDotDot then
                begin
                  NextToken;
                  SimpleExpression;
                end;
            end;
        end;
      end;
    ptPointerSymbol:
      begin
        PointerType;
      end;
    ptString:
      begin
        StringType;
      end;
    else
      begin
        SynError(InvalidTypeKind);
      end;
  end;
end;

procedure TmwSimplePasPar.TypedConstant;
begin
  case TokenID of
    ptRoundOpen:
      begin
        Lexer.InitAhead;
        while Lexer.AheadTokenID <> ptSemiColon do
          case Lexer.AheadTokenID of
            ptAnd, ptBegin, ptCase, ptColon, ptEnd, ptElse, ptIf, ptMinus, ptNull,
              ptOr, ptPlus, ptShl, ptShr, ptSlash, ptStar, ptWhile, ptWith,
              ptXor: break;
            ptRoundOpen:
              begin
                  repeat
                      case Lexer.AheadTokenID of
                        ptBegin, ptCase, ptEnd, ptElse, ptIf, ptNull, ptWhile, ptWith: break;
                        else
                          begin
                            case Lexer.AheadTokenID of
                              ptRoundClose:
                                begin
                                  NextToken;
                                  break;
                                end;
                              else Lexer.AheadNext;
                            end;
                          end;
                      end;
                  until Lexer.AheadTokenID = ptRoundClose;
              end;
            else Lexer.AheadNext;
          end;
        case Lexer.AheadTokenID of
          ptColon:
            begin
              RecordConstant;
            end;
          ptNull:;
          ptAnd, ptMinus, ptOr, ptPlus, ptShl, ptShr, ptSlash, ptStar, ptXor:
            begin
              ConstantExpression;
            end;
          else
            begin
              ArrayConstant;
            end;
        end;
      end;
    ptSquareOpen: (*empty; there mustn't be all fields of a record mentioned*)
      begin
        NextToken;
        if TokenID <> ptSquareClose then
          begin
            case TokenID of
              ptDotDot:
                begin
                  NextToken;
                  NextToken;
                end;
              else
                NextToken;
                case TokenID of
                  ptDotDot:
                    begin
                      NextToken;
                      NextToken;
                    end;
                end;
            end;
            while TokenID = ptComma do
              begin
                NextToken;
                NextToken;
                case TokenID of
                  ptDotDot:
                    begin
                      NextToken;
                      NextToken;
                    end;
                end;
              end;
            Expected(ptSquareClose);
          end
        else NextToken;
      end;
    else
      begin
        ConstantExpression;
      end;
  end;
end;

procedure TmwSimplePasPar.TypeId;
begin
  Lexer.InitAhead;
  if Lexer.AheadTokenID = ptPoint then
    begin
      UnitId;
      Expected(ptPoint);
    end;
  case GenID of
    ptBoolean, ptByte, ptChar, ptDWord, ptInt64, ptInteger, ptLongInt,
      ptLongWord, ptPChar, ptShortInt, ptSmallInt, ptWideChar, ptWord:
      begin
        OrdinalIdentifier;
      end;
    ptComp, ptCurrency, ptDouble, ptExtended, ptReal, ptReal48, ptSingle:
      begin
        RealIdentifier;
      end;
    ptAnsiString, ptShortString, ptWideString:
      begin
        StringIdentifier;
      end;
    ptOleVariant, ptVariant:
      begin
        VariantIdentifier;
      end;
    ptString:
      begin
        StringType;
      end;
    else
      begin
        Expected(ptIdentifier);
      end;
  end;
end;

procedure TmwSimplePasPar.ConstantExpression;
begin
  Expression;
end;

procedure TmwSimplePasPar.ResourceDeclaration;
begin
  Expected(ptIdentifier);
  Expected(ptEqual);
  CharString;
end;

procedure TmwSimplePasPar.ResourceIncluded(const aResName : string);
begin
end;

procedure TmwSimplePasPar.ConstantDeclaration;
begin
  ConstantName;
  case TokenID of
    ptEqual:
      begin
        ConstantEqual;
      end;
    ptColon:
      begin
        ConstantColon;
      end;
    else
      begin
        SynError(InvalidConstantDeclaration);
      end;
  end;
end;

procedure TmwSimplePasPar.ConstantColon;
begin
  Expected(ptColon);
  TypeKind;
  Expected(ptEqual);
  ConstantValueTyped;
end;

procedure TmwSimplePasPar.ConstantEqual;
begin
  Expected(ptEqual);
  ConstantValue;
end;

procedure TmwSimplePasPar.ConstantValue;
begin
  ConstantExpression;
end;

procedure TmwSimplePasPar.ConstantValueTyped;
begin
  TypedConstant;
end;

procedure TmwSimplePasPar.ConstantName;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.LabelId;
begin
  case TokenID of
    ptIntegerConst:
      begin
        NextToken;
      end;
    ptIdentifier:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidLabelId);
      end;
  end;
end;

procedure TmwSimplePasPar.ProcedureDeclarationSection;
begin
  if TokenID = ptClass then
    begin
      NextToken;
    end;
  case TokenID of
    ptConstructor:
      begin
        ProcedureMethodDeclaration;
      end;
    ptDestructor:
      begin
        ProcedureMethodDeclaration;
      end;
    ptProcedure:
      begin
        ProcedureMethodDeclaration;
      end;
    ptFunction:
      begin
        FunctionMethodDeclaration;
      end;
    else
      begin
        SynError(InvalidProcedureDeclarationSection);
      end;
  end;
end;

procedure TmwSimplePasPar.LabelDeclarationSection;
begin
  Expected(ptLabel);
  LabelId;
  while(TokenID = ptComma) do
    begin
      NextToken;
      LabelId;
    end;
  SEMICOLON;
end;

procedure TmwSimplePasPar.ProceduralDirective;
begin
  case ExID of
    ptAbstract:
      begin
        NextToken;
      end;
    ptCdecl, ptPascal, ptRegister, ptSafeCall, ptStdCall:
      begin
        DirectiveCalling;
      end;
    ptExport, ptFar, ptNear:
      begin
        Directive16Bit;
      end;
    ptExternal:
      begin
        ExternalDirective;
      end;
    ptDynamic, ptMessage, ptOverload, ptOverride, ptReintroduce, ptVirtual:
      begin
        DirectiveBinding;
      end;
    else
      begin
        SynError(InvalidProceduralDirective);
      end;
  end;
end;

procedure TmwSimplePasPar.ExportedHeading;
begin
  case TokenID of
    ptFunction:
      begin
        FunctionHeading;
      end;
    ptProcedure:
      begin
        ProcedureHeading;
      end;
    else
      begin
        SynError(InvalidExportedHeading);
      end;
  end;
  if TokenID = ptSemiColon then SEMICOLON;
  case ExID of
    ptForward:
      begin
        ForwardDeclaration; //jdj added 02/07/2001
//        NextToken;
//        SEMICOLON;
      end;
    ptAssembler:
      begin
        NextToken;
        SEMICOLON;
        if Exid = ptForward then
          ForwardDeclaration; //jdj added 02/07/2001
      end;
    else
      while ExID in [ptAbstract, ptCdecl, ptDynamic, ptExport, ptExternal, ptFar,
        ptMessage, ptNear, ptOverload, ptOverride, ptPascal, ptRegister,
        ptReintroduce, ptSafeCall, ptStdCall, ptVirtual] do
        begin
          ProceduralDirective;
          if TokenID = ptSemiColon then SEMICOLON;
        end;
      if ExId = ptForward then
        ForwardDeclaration; //jdj added 02/07/2001
  end;
end;

procedure TmwSimplePasPar.FunctionHeading;
begin
  Expected(ptFunction);
  FunctionProcedureName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
  Expected(ptColon);
  ReturnType;
end;

procedure TmwSimplePasPar.ProcedureHeading;
begin
  Expected(ptProcedure);
  FunctionProcedureName;
  if TokenID = ptRoundOpen then
    begin
      FormalParameterList;
    end;
end;

procedure TmwSimplePasPar.VarSection;
begin
  case TokenID of
    ptThreadVar:
      begin
        NextToken;
      end;
    ptVar:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidVarSection);
      end;
  end;
  while TokenID = ptIdentifier do
    begin
      VarDeclaration;
      SEMICOLON;
    end;
end;

procedure TmwSimplePasPar.TypeSection;
begin
  Expected(ptType);
  while TokenID = ptIdentifier do
    begin
      TypeDeclaration;
      if TokenId = ptEqual then //jdj 8/2/00
          TypedConstant;
      SEMICOLON;
    end;
end;

procedure TmwSimplePasPar.ConstSection;
begin
  case TokenID of
    ptConst:
      begin
        NextToken;
        while(TokenID = ptIdentifier) do
          begin
            ConstantDeclaration;
            SEMICOLON;
          end;
      end;
    ptResourceString:
      begin
        NextToken;
        while(TokenID = ptIdentifier) do
          begin
            ResourceDeclaration;
            SEMICOLON;
          end;
      end
    else
      begin
        SynError(InvalidConstSection);
      end;
  end;
end;

procedure TmwSimplePasPar.InterfaceDeclaration;
begin
  case TokenID of
    ptConst:
      begin
        ConstSection;
      end;
    ptFunction:
      begin
        ExportedHeading;
      end;
    ptProcedure:
      begin
        ExportedHeading;
      end;
    ptResourceString:
      begin
        ConstSection;
      end;
    ptType:
      begin
        TypeSection;
      end;
    ptThreadVar:
      begin
        VarSection;
      end;
    ptVar:
      begin
        VarSection;
      end;
    else
      begin
        SynError(InvalidInterfaceDeclaration);
      end;
  end;
end;

procedure TmwSimplePasPar.ExportsElement;
begin
  Expected(ptIdentifier);
  //  if TokenID = ptIndex then
  if FLexer.ExID = ptIndex then //jdj 20001207
    begin
      NextToken;
      Expected(ptIntegerConst);
    end;
  //  if TokenID = ptName then
  if FLexer.ExID = ptName then //jdj 20001207
    begin
      NextToken;
      CharString;
    end;
  //  if TokenID = ptResident then
  if FLexer.ExID = ptResident then //jdj 20001207
    begin
      NextToken;
    end;
end;

procedure TmwSimplePasPar.CompoundStatement;
begin
  Expected(ptBegin);
  StatementList;
  Expected(ptEnd);
end;

procedure TmwSimplePasPar.ExportsClause;
begin
  Expected(ptExports);
  ExportsElement;
  while TokenID = ptComma do
    begin
      NextToken;
      ExportsElement;
    end;
  SEMICOLON;
end;

procedure TmwSimplePasPar.ContainsClause;
begin
  ExpectedEx(ptContains);
  ContainsStatement;
  while TokenID = ptComma do
    begin
      NextToken;
      ContainsStatement;
    end;
  SEMICOLON;
end;

procedure TmwSimplePasPar.ContainsStatement;
begin
  ContainsIdentifier;
  if fLexer.TokenID = ptIn then
    begin
      NextToken;
      ContainsExpression;
    end;
end;

procedure TmwSimplePasPar.ContainsIdentifier;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.ContainsExpression;
begin
  ConstantExpression;
end;

procedure TmwSimplePasPar.RequiresClause;
begin
  ExpectedEx(ptRequires);
  RequiresIdentifier;
  while TokenID = ptComma do
    begin
      NextToken;
      RequiresIdentifier;
    end;
  SEMICOLON;
end;

procedure TmwSimplePasPar.RequiresIdentifier;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.InitializationSection;
begin
  case TokenID of
    ptInitialization:
      begin
        NextToken;
        StatementList;
        if TokenID = ptFinalization then
          begin
            NextToken;
            StatementList;
          end;
        Expected(ptEnd);
      end;
    ptFinalization : begin
                       //finalization without an initiaization section
                       NextToken;
                       StatementList;
                       Expected(ptEnd);
                     end;  
    ptBegin:
      begin
        CompoundStatement;
      end;
    ptEnd:
      begin
        NextToken;
      end;
    else
      begin
        SynError(InvalidInitializationSection);
      end;
  end;
end;

procedure TmwSimplePasPar.ImplementationSection;
begin
  Expected(ptImplementation);
  if TokenID = ptUses then
    begin
      UsesClause;
    end;
  while TokenID in [ptClass, ptConst, ptConstructor, ptDestructor, ptFunction,
    ptLabel, ptProcedure, ptResourceString, ptThreadVar, ptType, ptVar] do //ptResourceString added jdj
    begin
      DeclarationSection;
    end;
end;

procedure TmwSimplePasPar.InterfaceSection;
begin
  Expected(ptInterface);
  if TokenID = ptUses then
    begin
      UsesClause;
    end;
  while TokenID in [ptConst, ptFunction, ptResourceString, ptProcedure,
    ptThreadVar, ptType, ptVar] do
    begin
      InterfaceDeclaration;
    end;
end;

procedure TmwSimplePasPar.IdentifierList;
begin
  // MAE Changed to process IdentifierListEntry
  IdentifierListEntry;
  while(TokenID = ptComma) do
    begin
      NextToken;
      IdentifierListEntry;
    end;
end;

procedure TmwSimplePasPar.IdentifierListEntry;
begin
  Expected(ptIdentifier);
end;

procedure TmwSimplePasPar.QualifiedIdentifierList;
begin
  QualifiedIdentifier;
  while(TokenID = ptComma) do
    begin
      NextToken;
      QualifiedIdentifier;
    end;
end;

procedure TmwSimplePasPar.CharString;
begin //updated mw 2/22/00
  case TokenID of
    ptAsciiChar, ptIdentifier, ptRoundOpen, ptStringConst:
      while TokenID in
        [ptAsciiChar, ptIdentifier, ptPlus, ptRoundOpen, ptStringConst] do
        begin
          case TokenID of
            ptIdentifier, ptRoundOpen:
              begin
                VariableReference;
              end;
            else
              NextToken;
          end;
        end;
    else
      begin
        SynError(InvalidCharString);
      end;
  end;
end;

(*procedure TmwSimplePasPar.CharString;
begin
  case TokenID of
    ptAsciiChar, ptStringConst:
      while TokenID in [ptAsciiChar, ptPlus, ptStringConst] do
      begin
        case TokenID of
          ptPlus:
            begin
              NextToken;
              if TokenID = ptIdentifier then
              begin
                VariableReference;
              end;
            end;
        else
          begin
            NextToken;
          end;
        end;
      end;
    ptIdentifier:
      begin
        VariableReference;
        case TokenID of
          ptPlus:
            begin
              NextToken;
              while TokenID in [ptAsciiChar, ptPlus, ptStringConst] do
              begin
                case TokenID of
                  ptPlus:
                    begin
                      NextToken;
                      if TokenID = ptIdentifier then
                      begin
                        VariableReference;
                      end;
                    end;
                else
                  begin
                    NextToken;
                  end;
                end;
              end;
            end;
        end;
      end
  else
    begin
      SynError(InvalidCharString);
    end;
  end;
end;*)

procedure TmwSimplePasPar.IncludeFile;
begin
  while TokenID <> ptNull do
    case TokenID of
      ptClass:
        begin
          ProcedureDeclarationSection;
        end;
      ptConst:
        begin
          ConstSection;
        end;
      ptConstructor:
        begin
          ProcedureDeclarationSection;
        end;
      ptDestructor:
        begin
          ProcedureDeclarationSection;
        end;
      ptExports:
        begin
          ExportsClause;
        end;
      ptFunction:
        begin
          ProcedureDeclarationSection;
        end;
      ptIdentifier:
        begin
          Lexer.InitAhead;
          if Lexer.AheadTokenID in [ptColon, ptEqual] then
            begin
              ConstantDeclaration;
              if TokenID = ptSemiColon then SEMICOLON;
            end
          else NextToken;
        end;
      ptLabel:
        begin
          LabelDeclarationSection;
        end;
      ptProcedure:
        begin
          ProcedureDeclarationSection;
        end;
      ptResourceString:
        begin
          ConstSection;
        end;
      ptType:
        begin
          TypeSection;
        end;
      ptThreadVar:
        begin
          VarSection;
        end;
      ptVar:
        begin
          VarSection;
        end;
      else
        begin
          NextToken;
        end;
    end;
end;

procedure TmwSimplePasPar.SkipSpace; //XM Jul-2000
begin
  Expected(ptSpace);
  while TokenID in [ptSpace] do Lexer.Next;
end;

procedure TmwSimplePasPar.SkipCRLFco; //XM Jul-2000
begin
  Expected(ptCRLFCo);
  while TokenID in [ptCRLFCo] do Lexer.Next;
end;

procedure TmwSimplePasPar.SkipCRLF; //XM Jul-2000
begin
  Expected(ptCRLF);
  while TokenID in [ptCRLF] do Lexer.Next;
end;

end.

