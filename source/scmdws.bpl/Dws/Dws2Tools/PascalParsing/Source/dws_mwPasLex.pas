{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: mwPasLex.PAS, released August 17, 1999.

The Initial Developer of the Original Code is Martin Waldenburg
(Martin.Waldenburg@T-Online.de).
Portions created by Martin Waldenburg are Copyright (C) 1998, 1999, 2002 Martin
Waldenburg.
All Rights Reserved.

Contributor(s): James Jacobson _____________________________________.


Last Modified: Oktober 2002
Current Version: 3.1

Notes: This program is a very fast Pascal tokenizer. I'd like to invite the
Delphi community to develop it further and to create a fully featured Object
Pascal parser.

Modification history:

Known Issues:
-----------------------------------------------------------------------------}
{$A+}
{$I dws2.inc}

unit dws_mwPasLex;

interface

uses
{$IFNDEF VER140UP}
  Windows,
{$ENDIF}
{$IFDEF DELPHI6up}
  Types,
{$ELSE}
  Classes,
{$ENDIF}
  dws_mwPasLexTypes, dws_mwDirectiveLex;

type

  TmwBasePasLex = class;

  TmwLexEvent = procedure(Sender: TmwBasePasLex) of object;
  TmwLexAppTypeEvent = procedure(Sender: TmwBasePasLex; Value: TmwAppType) of object;
  TmwLexIfOptEvent = procedure(Sender: TmwBasePasLex; Value: TbdBooleanDirectives; Active: Boolean) of object;
  TmwLexSODirectEvent = procedure(Sender: TmwBasePasLex; Kind: TcdTokenKind; Value: String) of object;
  TmwLexNumberEvent = procedure(Sender: TmwBasePasLex; Value: Integer) of object;
  TmwLexStringEvent = procedure(Sender: TmwBasePasLex; Value: String) of object;
  TmwLexOnIncludeEvent = function(Sender: TmwBasePasLex; Value: String): PChar of object;
  TmwLexStringBooleanEvent = function(Sender: TmwBasePasLex; Value: String): Boolean of object;
  TmwLexExpressionEvent = function(Sender: TmwBasePasLex; ConstTypeOne: TcdTokenKind;
    ConstantOne: String; TypeOfRelation: TcdTokenKind; ConstTypeThree: TcdTokenKind; ConstantTwo: String): Boolean of object;
  TDirectiveSetEvent = procedure(Sender: TmwBasePasLex; Value: TbdBooleanDirectives; Activate: Boolean) of object;

  TmwBasePasLex = class(TObject)
  private
    fLexState: TmwLexState;
    fKeyHashTable: TmwPasHash;
    fOrigin: PChar;
    fProcTable: array[#0..#255] of procedure of object;
    Run: Integer;
    TempRun: Integer;
    fTokenPos: Integer;
    fLineNumber: Integer;
    FTokenID: TptTokenKind;
    fLinePos: Integer;
    fExID: TptTokenKind;
    fBooleanDirectives: TmwBooleanDirectives;
    fDirectiveLex: TmwDirectiveLex;
    FOnMessage: TMessageEvent;
    fOnCompDirect: TmwLexEvent;
    fOnElseDirect: TmwLexEvent;
    fOnEndIfDirect: TmwLexEvent;
    fOnIfDefDirect: TmwLexEvent;
    fOnIfNDefDirect: TmwLexEvent;
    fOnResourceDirect: TmwLexStringEvent;
    fOnIncludeDirect: TmwLexOnIncludeEvent;
    fOnDefineDirect: TmwLexStringEvent;
    fOnIfOptDirect: TmwLexIfOptEvent;
    fOnUnDefDirect: TmwLexStringEvent;
    fOnBooleanDirectiveChanged: TDirectiveSetEvent;
    fOnLinkDirect: TmwLexStringEvent;
    fOnExtensionDirect: TmwLexStringEvent;
    fOnInvalidDirect: TmwLexStringEvent;
    fOnLineEnd: TmwLexEvent;
    fOnMultiLineStart: TmwLexEvent;
    fOnMultiLineEnd: TmwLexEvent;
    FSkipCounter: Integer;
    FOnRecordAlignment: TmwLexNumberEvent;
    fOnAppType: TmwLexAppTypeEvent;
    FOnSODirective: TmwLexSODirectEvent;
    fDefinedList: TmwAssignAbleHash;
    fOnDescriptionDirect: TmwLexStringEvent;
    fOnDefined: TmwLexStringEvent;
    fOnDeclared: TmwLexStringBooleanEvent;
    fOnExpression: TmwLexExpressionEvent;
    fOnExternalsSymDirect: TmwLexStringEvent;
    fOnHPPEmitDirect: TmwLexStringEvent;
    fOnIfDirect: TmwLexEvent;
    fOnElseIfDirect: TmwLexEvent;
    fOnIfEndDirect: TmwLexEvent;
    fOnImageBaseDirect: TmwLexStringEvent;
    fOnMaxStackSizeDirect: TmwLexStringEvent;
    fOnMinStackSizeDirect: TmwLexStringEvent;
    fOnMinEnumSizeDirect: TmwLexStringEvent;
    fOnResourceReserveDirect: TmwLexStringEvent;
    fOnNoDefineDirect: TmwLexStringEvent;
    fOnNoIncludeDirect: TmwLexStringEvent;
    fUnitName: String;
    fStatusStack: TmwPasLexStatusStack;
    fOnSlashesComment: TmwLexEvent;

    function GetPosXY: TPoint; //jdj 7/18/1999
    procedure SetRunPos(Value: Integer);
    procedure MakeMethodTables;
    procedure AddressOpProc;
    procedure AsciiCharProc;
    procedure AnsiProc;
    procedure BorProc;
    procedure BraceCloseProc;
    procedure BraceOpenProc;
    procedure ColonProc;
    procedure CommaProc;
    procedure CRProc;
    procedure EqualProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure IntegerProc;
    procedure InternationalIdentProc;
    procedure LFProc;
    procedure LowerProc;
    procedure MinusProc;
    procedure NullProc;
    procedure NumberProc;
    procedure PlusProc;
    procedure PointerSymbolProc;
    procedure PointProc;
    procedure RoundCloseProc;
    procedure RoundOpenProc;
    procedure SemiColonProc;
    procedure SlashProc;
    procedure SpaceProc;
    procedure SquareCloseProc;
    procedure SquareOpenProc;
    procedure StarProc;
    procedure StringProc;
    procedure SymbolProc;
    procedure UnknownProc;
    function GetToken: string;
    function GetTokenLen: Integer;
    function GetLexState: Pointer;
    procedure SetLexState(const Value: Pointer);
    procedure InitLine;
    procedure ScannDirectives;
    function GetDirectiveParam: string;
    function GetStringContent: string;
    function GetIsJunk: Boolean;
    function GetIsSpace: Boolean;
    function GetGenID: TptTokenKind;
    procedure ProcessDirective;
    procedure SkipElseDirect;
    procedure SkipElseIfDirect;
    procedure SkipIfDefDirect;
    procedure SkipIfDirect;
    procedure SkipIfNDefDirect;
    procedure SkipIfOptDirect;
    procedure SetOnElseIfDirect(const Value: TmwLexEvent);
    procedure SetOnIfDirect(const Value: TmwLexEvent);
    procedure SetOnIfEndDirect(const Value: TmwLexEvent);
  protected
    function GetStatus: TmwPasLexStatus; virtual;
    procedure SetStatus(const Value: TmwPasLexStatus); virtual;
    procedure AtLineEnd(aLinePos: Integer);
    procedure SetLine(const Value: string); virtual;
    procedure SetOrigin(NewValue: PChar); virtual;
    procedure SetOnCompDirect(const Value: TmwLexEvent); virtual;
    procedure SetOnDefineDirect(const Value: TmwLexStringEvent); virtual;
    procedure SetOnElseDirect(const Value: TmwLexEvent); virtual;
    procedure SetOnEndIfDirect(const Value: TmwLexEvent); virtual;
    procedure SetOnIfDefDirect(const Value: TmwLexEvent); virtual;
    procedure SetOnIfNDefDirect(const Value: TmwLexEvent); virtual;
    procedure SetOnIfOptDirect(const Value: TmwLexIfOptEvent); virtual;
    procedure SetOnIncludeDirect(const Value: TmwLexOnIncludeEvent); virtual;
    procedure SetOnInvalidDirect(const Value: TmwLexStringEvent); virtual;
    procedure SetOnResourceDirect(const Value: TmwLexStringEvent); virtual;
    procedure SetOnUnDefDirect(const Value: TmwLexStringEvent); virtual;
    procedure SetOnLineEnd(const Value: TmwLexEvent);  virtual;
    procedure SetOnDeclared(const Value: TmwLexStringBooleanEvent); virtual;
    procedure SetOnDefined(const Value: TmwLexStringEvent); virtual;
    procedure SetOnExpression(const Value: TmwLexExpressionEvent); virtual;
    property  KeyHashTable: TmwPasHash read fKeyHashTable;
    property DLex: TmwDirectiveLex read FDirectiveLex;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Next;
    procedure NextID(ID: TptTokenKind);
    procedure NextNoJunk;
    procedure NextNoSpace;
    procedure Init;
    property LexState: Pointer read GetLexState write SetLexState;
    property DefinedList: TmwAssignAbleHash read fDefinedList;
    property DirectiveParam: string read GetDirectiveParam;
    property IsJunk: Boolean read GetIsJunk;
    property IsSpace: Boolean read GetIsSpace;
    property Line: string write SetLine;
    property LineNumber: Integer read fLineNumber;
    property LinePos: Integer read fLinePos;
    property Origin: PChar read fOrigin write SetOrigin;
    property PosXY: TPoint read GetPosXY; //jdj 7/18/1999
    property RunPos: Integer read Run write SetRunPos;
    property SkipCounter: Integer read FSkipCounter;
    property Token: string read GetToken;
    property TokenLen: Integer read GetTokenLen;
    property TokenPos: Integer read fTokenPos;
    property TokenID: TptTokenKind read FTokenID;
    property ExID: TptTokenKind read fExID;
    property GenID: TptTokenKind read GetGenID;
    property UnitName: String read fUnitName write fUnitName;
    property StringContent: string read GetStringContent;
    property Status: TmwPasLexStatus read GetStatus write SetStatus;
    property StatusStack: TmwPasLexStatusStack read fStatusStack;
    property OnApType: TmwLexAppTypeEvent read fOnAppType write fOnAppType;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
    property OnDeclared: TmwLexStringBooleanEvent read fOnDeclared write SetOnDeclared;
    property OnDefined: TmwLexStringEvent read fOnDefined write SetOnDefined;
    property OnExpression: TmwLexExpressionEvent read fOnExpression write SetOnExpression;
    property OnMultiLineStart: TmwLexEvent read fOnMultiLineStart write fOnMultiLineStart;
    property OnMultiLineEnd: TmwLexEvent read fOnMultiLineEnd write fOnMultiLineEnd;
    property OnSlashesComment: TmwLexEvent read fOnSlashesComment write fOnSlashesComment;
    property OnCompDirect: TmwLexEvent read fOnCompDirect write SetOnCompDirect;
    property OnDefineDirect: TmwLexStringEvent read fOnDefineDirect write SetOnDefineDirect;
    property OnBooleanDirectiveChanged: TDirectiveSetEvent read fOnBooleanDirectiveChanged;
    property OnDescriptionDirect: TmwLexStringEvent read fOnDescriptionDirect write fOnDescriptionDirect;
    property OnElseDirect: TmwLexEvent read fOnElseDirect write SetOnElseDirect;
    property OnEndIfDirect: TmwLexEvent read fOnEndIfDirect write SetOnEndIfDirect;
    property OnIfEndDirect: TmwLexEvent read fOnIfEndDirect write SetOnIfEndDirect;
    property OnExtensionDirect: TmwLexStringEvent read fOnExtensionDirect write fOnExtensionDirect;
    property OnExternalsSymDirect: TmwLexStringEvent read fOnExternalsSymDirect write fOnExternalsSymDirect;
    property OnHPPEmitDirect: TmwLexStringEvent read fOnHPPEmitDirect write fOnHPPEmitDirect;
    property OnElseIfDirect: TmwLexEvent read fOnElseIfDirect write SetOnElseIfDirect;
    property OnIfDirect: TmwLexEvent read fOnIfDirect write SetOnIfDirect;
    property OnIfDefDirect: TmwLexEvent read fOnIfDefDirect write SetOnIfDefDirect;
    property OnIfNDefDirect: TmwLexEvent read fOnIfNDefDirect write SetOnIfNDefDirect;
    property OnIfOptDirect: TmwLexIfOptEvent read fOnIfOptDirect write SetOnIfOptDirect;
    property OnImageBaseDirect: TmwLexStringEvent read fOnImageBaseDirect write fOnImageBaseDirect;
    property OnMinStackSizeDirect: TmwLexStringEvent read fOnMinStackSizeDirect write fOnMinStackSizeDirect;
    property OnMaxStackSizeDirect: TmwLexStringEvent read fOnMaxStackSizeDirect write fOnMaxStackSizeDirect;
    property OnMinEnumSizeDirect: TmwLexStringEvent read fOnMinEnumSizeDirect write fOnMinEnumSizeDirect;
    property OnResourceReserveDirect: TmwLexStringEvent read fOnResourceReserveDirect write fOnResourceReserveDirect;
    property OnNoDefineDirect: TmwLexStringEvent read fOnNoDefineDirect write fOnNoDefineDirect;
    property OnNoIncludeDirect: TmwLexStringEvent read fOnNoIncludeDirect write fOnNoIncludeDirect;

    property OnIncludeDirect: TmwLexOnIncludeEvent read fOnIncludeDirect write SetOnIncludeDirect;
    property OnInvalidDirect: TmwLexStringEvent read fOnInvalidDirect write SetOnInvalidDirect;
    property OnLineEnd: TmwLexEvent read fOnLineEnd write SetOnLineEnd;
    property OnLinkDirect: TmwLexStringEvent read fOnLinkDirect write fOnLinkDirect;
    property OnResourceDirect: TmwLexStringEvent read fOnResourceDirect write SetOnResourceDirect;
    property OnRecordAlignment: TmwLexNumberEvent read FOnRecordAlignment write FOnRecordAlignment;
    property OnSODirective: TmwLexSODirectEvent read FOnSODirective write FOnSODirective;
    property OnUnDefDirect: TmwLexStringEvent read fOnUnDefDirect write SetOnUnDefDirect;
  published
  end;

  TmwPasLex = class(TmwBasePasLex)
  private
    fAheadLex: TmwBasePasLex;
    fAheadEvents: Boolean;
    function GetAheadExID: TptTokenKind;
    function GetAheadGenID: TptTokenKind;
    function GetAheadToken: string;
    function GetAheadTokenID: TptTokenKind;
  protected
    procedure SetLine(const Value: string); override;
    procedure SetOrigin(NewValue: PChar); override;
    procedure SetOnCompDirect(const Value: TmwLexEvent); override;
    procedure SetOnDefineDirect(const Value: TmwLexStringEvent); override;
    procedure SetOnElseDirect(const Value: TmwLexEvent); override;
    procedure SetOnEndIfDirect(const Value: TmwLexEvent); override;
    procedure SetOnIfDefDirect(const Value: TmwLexEvent); override;
    procedure SetOnIfNDefDirect(const Value: TmwLexEvent); override;
    procedure SetOnIfOptDirect(const Value: TmwLexIfOptEvent); override;
    procedure SetOnIncludeDirect(const Value: TmwLexOnIncludeEvent); override;
    procedure SetOnLineEnd(const Value: TmwLexEvent);  override;
    procedure SetOnResourceDirect(const Value: TmwLexStringEvent); override;
    procedure SetOnUnDefDirect(const Value: TmwLexStringEvent); override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitAhead;
    procedure AheadNext;
    property AheadEvents: Boolean read fAheadEvents write fAheadEvents;
    property AheadLex: TmwBasePasLex read fAheadLex;
    property AheadToken: string read GetAheadToken;
    property AheadTokenID: TptTokenKind read GetAheadTokenID;
    property AheadExID: TptTokenKind read GetAheadExID;
    property AheadGenID: TptTokenKind read GetAheadGenID;
  end;

implementation

uses
  SysUtils;



procedure TmwBasePasLex.AddressOpProc;
begin
  case FOrigin[Run + 1] of
    '@':
      begin
        fTokenID := ptDoubleAddressOp;
        inc(Run, 2);
      end;
  else
    begin
      fTokenID := ptAddressOp;
      inc(Run);
    end;
  end;
end;

procedure TmwBasePasLex.AnsiProc;
begin
  fTokenID := ptAnsiComment;
  while fOrigin[Run] <> #0 do
    case fOrigin[Run] of
      #10:
        begin
          inc(Run);
          AtLineEnd(Run);
        end;

      #13:
        begin
          inc(Run);
          if FOrigin[Run] = #10 then
            inc(Run);
          AtLineEnd(Run);
        end;

      '*':
        if fOrigin[Run + 1] = ')' then
        begin
          inc(Run, 2);
          break;
        end
        else inc(Run);
    else inc(Run);
    end;
  if FOrigin[Run] = #0 then
  begin
    NullProc;
    if Assigned(FOnMessage) then
    FOnMessage(Self, 'Unexpected file end', PosXY.X, PosXY.Y);
  end;
end;

procedure TmwBasePasLex.AsciiCharProc;
begin
  fTokenID := ptAsciiChar;
  inc(Run);
  if FOrigin[Run] = '$' then
  begin
    inc(Run);
    while FOrigin[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do inc(Run);
  end else
  begin
    while FOrigin[Run] in ['0'..'9'] do
      inc(Run);
  end;
end;

procedure TmwBasePasLex.BraceCloseProc;
begin
  inc(Run);
  fTokenId := ptError;
  if Assigned(FOnMessage) then
    FOnMessage(Self, 'Illegal character', PosXY.X, PosXY.Y);
end;

procedure TmwBasePasLex.BorProc;
begin
  fTokenID := ptBorComment;
  while FOrigin[Run] <> #0 do
    case FOrigin[Run] of
      #10:
        begin
          inc(Run);
          AtLineEnd(Run);
        end;

      #13:
        begin
          inc(Run);
          if FOrigin[Run] = #10 then
            inc(Run);
          AtLineEnd(Run);
        end;

      '}':
        begin
          inc(Run);
          break;
        end;
    else inc(Run);
    end;
  if FOrigin[Run] = #0 then
  begin
    NullProc;
    if Assigned(FOnMessage) then
    FOnMessage(Self, 'Unexpected file end', PosXY.X, PosXY.Y);
  end;
end;

procedure TmwBasePasLex.BraceOpenProc;
begin
  case FOrigin[Run + 1] of
    '$':
      begin
        fTokenID := ptBorDirective;
        if assigned(fOnMultiLineStart) then fOnMultiLineStart(Self);
        inc(Run, 2);
        ScannDirectives;
        if assigned(fOnMultiLineEnd) then fOnMultiLineEnd(Self);
        if fTokenID = ptBorDirective then
        Next;
      end;
  else
    begin
      fTokenID := ptBorComment;
      if assigned(fOnMultiLineStart) then fOnMultiLineStart(Self);
      BorProc;
      if assigned(fOnMultiLineEnd) then fOnMultiLineEnd(Self);
      Next;
    end;
  end;
end;

procedure TmwBasePasLex.ColonProc;
begin
  case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := ptAssign;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptColon;
    end;
  end;
end;

procedure TmwBasePasLex.CommaProc;
begin
  inc(Run);
  fTokenID := ptComma;
end;

constructor TmwBasePasLex.Create;
begin
  inherited Create;
  fKeyHashTable:= TmwPasHash.Create;
  fStatusStack:= TmwPasLexStatusStack.Create;
  FDefinedList:= TmwAssignAbleHash.Create;
  FDirectiveLex:= TmwDirectiveLex.Create;
  fOrigin := nil;
  MakeMethodTables;
  fExID := ptUnKnown;
end; { Create }

procedure TmwBasePasLex.CRProc;
begin
  case FOrigin[Run + 1] of
    #10: inc(Run, 2);
  else inc(Run);
  end;
  AtLineEnd(Run);
  fTokenID := ptCRLF;
end;

destructor TmwBasePasLex.Destroy;
begin
  fKeyHashTable.Free;
  fStatusStack.Free;
  fOrigin := nil;
  FDirectiveLex.Free;
  inherited Destroy;
end; { Destroy }

procedure TmwBasePasLex.EqualProc;
begin
  inc(Run);
  fTokenID := ptEqual;
end;

function TmwBasePasLex.GetIsJunk: Boolean;
begin
  result := IsTokenIDJunk(FTokenID);
//  Result := fTokenID in [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo, ptSlashesComment, ptSpace]; //XM 20001210
end;

function TmwBasePasLex.GetIsSpace: Boolean;
begin
  Result := fTokenID in [ptCRLF, ptSpace];
end;

function TmwBasePasLex.GetLexState: Pointer;
begin
  Result := Pointer(fLexState);
end;

function TmwBasePasLex.GetPosXY: TPoint;
begin //jdj 7/18/1999
  Result := Point((FTokenPos - FLinePos), FLineNumber);
end;

function TmwBasePasLex.GetToken: string;
begin
  SetString(Result, (FOrigin + fTokenPos), GetTokenLen);
end;

function TmwBasePasLex.GetTokenLen: Integer;
begin
  Result := Run - fTokenPos;
end;

procedure TmwBasePasLex.GreaterProc;
begin
  case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := ptGreaterEqual;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptGreater;
    end;
  end;
end;

procedure TmwBasePasLex.IdentProc;
begin
  FTokenID:= ptIdentifier;
  fExID:= ptIdentifier;
  fKeyHashTable.HashRun(fOrigin, Run, FTokenID, fExID);
  if NonEnglishChars[fOrigin[Run]] then
  begin
    inc(Run);
    FTokenID:= ptIdentifier;
    fExID:= ptInternationalIdentifier;
    while Identifiers[fOrigin[Run]] do
      inc(Run);
  end;
end;

procedure TmwBasePasLex.IntegerProc;
begin
  inc(Run);
  fTokenID := ptIntegerConst;
  while FOrigin[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do
    inc(Run);
end;

procedure TmwBasePasLex.InternationalIdentProc;
begin
  inc(Run);
  fTokenId:= ptIdentifier;
  fExID:= ptInternationalIdentifier;
  while Identifiers[FOrigin[Run]] do
    inc(Run);
end;

procedure TmwBasePasLex.LFProc;
begin
  fTokenID := ptCRLF;
  inc(Run);
  AtLineEnd(Run);
end;

procedure TmwBasePasLex.LowerProc;
begin
  case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := ptLowerEqual;
      end;
    '>':
      begin
        inc(Run, 2);
        fTokenID := ptNotEqual;
      end
  else
    begin
      inc(Run);
      fTokenID := ptLower;
    end;
  end;
end;

procedure TmwBasePasLex.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      #1..#9, #11, #12, #14..#32:
        fProcTable[I] := SpaceProc;
      '#': fProcTable[I] := AsciiCharProc;
      '$': fProcTable[I] := IntegerProc;
      #39: fProcTable[I] := StringProc;
      '0'..'9': fProcTable[I] := NumberProc;
      'A'..'Z', 'a'..'z', '_':
        fProcTable[I] := IdentProc;
      'ª', 'µ', 'º', 'À'..'Ö', 'Ø'..'ö', 'ø'..'ÿ':
        fProcTable[I] := InternationalIdentProc;
      '{': fProcTable[I] := BraceOpenProc;
      '}': fProcTable[I] := BraceCloseProc;
      '!', '"', '%', '&', '('..'/', ':'..'@', '['..'^', '`', '~':
        begin
          case I of
            '(': fProcTable[I] := RoundOpenProc;
            ')': fProcTable[I] := RoundCloseProc;
            '*': fProcTable[I] := StarProc;
            '+': fProcTable[I] := PlusProc;
            ',': fProcTable[I] := CommaProc;
            '-': fProcTable[I] := MinusProc;
            '.': fProcTable[I] := PointProc;
            '/': fProcTable[I] := SlashProc;
            ':': fProcTable[I] := ColonProc;
            ';': fProcTable[I] := SemiColonProc;
            '<': fProcTable[I] := LowerProc;
            '=': fProcTable[I] := EqualProc;
            '>': fProcTable[I] := GreaterProc;
            '@': fProcTable[I] := AddressOpProc;
            '[': fProcTable[I] := SquareOpenProc;
            ']': fProcTable[I] := SquareCloseProc;
            '^': fProcTable[I] := PointerSymbolProc;
          else fProcTable[I] := SymbolProc;
          end;
        end;
    else fProcTable[I] := UnknownProc;
    end;
end;

procedure TmwBasePasLex.MinusProc;
begin
  inc(Run);
  fTokenID := ptMinus;
end;

procedure TmwBasePasLex.Next;
begin
  fExID := ptUnKnown;
  fTokenPos := Run;
  fProcTable[fOrigin[Run]];
end;

procedure TmwBasePasLex.NextID(ID: TptTokenKind);
begin
  repeat
    case fTokenID of
      ptNull: break;
    else Next;
    end;
  until fTokenID = ID;
end;

procedure TmwBasePasLex.NextNoJunk;
begin
  repeat
    Next;
  until not IsJunk;
end;

procedure TmwBasePasLex.NextNoSpace;
begin
  repeat
    Next;
  until not IsSpace;
end;

procedure TmwBasePasLex.NullProc;
var
  Temp: PmwPasLexStatus;
begin
  fTokenID := ptNull;
  if fStatusStack.Count > 0 then
  begin
    Temp:= fStatusStack.Pop;
    Status:= Temp^;
    Dispose(Temp);
    Next;
  end;
end;

procedure TmwBasePasLex.NumberProc;
begin
  inc(Run);
  fTokenID := ptIntegerConst;
  while FOrigin[Run] in ['0'..'9', '.', 'e', 'E'] do
  begin
    case FOrigin[Run] of
      '.':
        if FOrigin[Run + 1] = '.' then
          break
        else fTokenID := ptFloat
    end;
    inc(Run);
  end;
end;

procedure TmwBasePasLex.PlusProc;
begin
  inc(Run);
  fTokenID := ptPlus;
end;

procedure TmwBasePasLex.PointerSymbolProc;
begin
  inc(Run);
  fTokenID := ptPointerSymbol;
end;

procedure TmwBasePasLex.PointProc;
begin
  case FOrigin[Run + 1] of
    '.':
      begin
        inc(Run, 2);
        fTokenID := ptDotDot;
      end;
    ')':
      begin
        inc(Run, 2);
        fTokenID := ptSquareClose;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptPoint;
    end;
  end;
end;

procedure TmwBasePasLex.RoundCloseProc;
begin
  inc(Run);
  fTokenID := ptRoundClose;
end;

procedure TmwBasePasLex.RoundOpenProc;
begin
  inc(Run);
  case fOrigin[Run] of
    '*':
      begin
        if FOrigin[Run + 1] = '$' then
        begin
          fTokenID := ptAnsiDirective;
          if assigned(fOnMultiLineStart) then fOnMultiLineStart(Self);
          inc(Run, 2);
          ScannDirectives;
          if assigned(fOnMultiLineEnd) then fOnMultiLineEnd(Self);
          if fTokenID = ptAnsiDirective then
          Next;
        end else
          begin
            fTokenID := ptAnsiComment;
            if assigned(fOnMultiLineStart) then fOnMultiLineStart(Self);
            inc(Run);
            AnsiProc;
            if assigned(fOnMultiLineEnd) then fOnMultiLineEnd(Self);
            Next;
          end;
      end;
    '.':
      begin
        inc(Run);
        fTokenID := ptSquareOpen;
      end;
  else fTokenID := ptRoundOpen;
  end;
end;

procedure TmwBasePasLex.SemiColonProc;
begin
  inc(Run);
  fTokenID := ptSemiColon;
end;

procedure TmwBasePasLex.SlashProc;
begin
  case FOrigin[Run + 1] of
    '/':
      begin
        inc(Run, 2);
        fTokenID := ptSlashesComment;
        while FOrigin[Run] <> #0 do
        begin
          case FOrigin[Run] of
            #10, #13: break;
          end;
          inc(Run);
        end;
        if assigned(fOnSlashesComment) then
          fOnSlashesComment(Self);
        Next;
      end;
  else
    begin
      inc(Run);
      fTokenID := ptSlash;
    end;
  end;
end;

procedure TmwBasePasLex.SpaceProc;
begin
  inc(Run);
  fTokenID := ptSpace;
  while FOrigin[Run] in [#1..#9, #11, #12, #14..#32] do
    inc(Run);
end;

procedure TmwBasePasLex.SquareCloseProc;
begin
  inc(Run);
  fTokenID := ptSquareClose;
end;

procedure TmwBasePasLex.SquareOpenProc;
begin
  inc(Run);
  fTokenID := ptSquareOpen;
end;

procedure TmwBasePasLex.StarProc;
begin
  inc(Run);
  fTokenID := ptStar;
end;

procedure TmwBasePasLex.StringProc;
begin
  fTokenID := ptStringConst;
  repeat
    inc(Run);
    case FOrigin[Run] of
      #0, #10, #13:
        begin
          if Assigned(FOnMessage) then
            FOnMessage(Self, 'Unterminated string', PosXY.X, PosXY.Y);
          break;
        end;
      #39:
        begin
          while (FOrigin[Run] = #39) and (FOrigin[Run + 1] = #39) do
          begin
            inc(Run, 2);
          end;
        end;
    end;
  until FOrigin[Run] = #39;
  if FOrigin[Run] = #39 then
  begin
    inc(Run);
    if TokenLen = 3 then
    begin
      fTokenID := ptAsciiChar;
    end;
  end;
end;

procedure TmwBasePasLex.SymbolProc;
begin
  inc(Run);
  fTokenID := ptSymbol;
end;

procedure TmwBasePasLex.SkipIfDirect;
begin
  inc(FSkipCounter);
  while (FSkipCounter <> 0) and (FTokenID <> ptNull) do
    Next;
end;

procedure TmwBasePasLex.SkipElseDirect;
begin
  inc(FSkipCounter);
  while (FSkipCounter <> 0) and (FTokenID <> ptNull) do
    Next;
end;

procedure TmwBasePasLex.SkipElseIfDirect;
begin
  inc(FSkipCounter);
  while (FSkipCounter <> 0) and (FTokenID <> ptNull) do
    Next;
end;

procedure TmwBasePasLex.SkipIfDefDirect;
begin
  inc(FSkipCounter);
  while (FSkipCounter <> 0) and (FTokenID <> ptNull) do
    Next;
end;

procedure TmwBasePasLex.SkipIfNDefDirect;
begin
  inc(FSkipCounter);
  while (FSkipCounter <> 0) and (FTokenID <> ptNull) do
    Next;
end;

procedure TmwBasePasLex.SkipIfOptDirect;
begin
  inc(FSkipCounter);
  while (FSkipCounter <> 0) and (FTokenID <> ptNull) do
    Next;
end;

procedure TmwBasePasLex.ScannDirectives;
begin
  DLex.Init(FOrigin, Run, fTokenId);
  ProcessDirective;
end;

procedure TmwBasePasLex.ProcessDirective;

  procedure NextDirectiveToken;
  begin
    if DLex.TokenID <> cdAtEnd then
      DLex.Next;
    Run:= DLex.RunPos;
    if DLex.TokenID = cdCRLF then
      AtLineEnd(DLex.RunPos);
  end;

  procedure EatJunk;
  begin
    while DLex.TokenID in [cdSpace, cdCRLF] do
      NextDirectiveToken;
  end;

  procedure NextNonJunkDirectiveToken;
  begin
    NextDirectiveToken;
    EatJunk;
  end;

  function ExpectedDirectiveToken(Value: TcdTokenKind): Boolean;
  begin
    Result:= False;
    if DLex.TokenID = Value then
    begin
      Result:= True;
    end else
    begin
      if assigned(FOnMessage) then
        FOnMessage(Self, 'Expected: '+ cdTokenName(Value) + '   found: '+
                   cdTokenName(DLex.TokenID), PosXY.X, PosXY.Y);
    end;
  end;

  function ExpectedGenericToken(Value: TcdTokenKind): Boolean;
  begin
    Result:= False;
    if DLex.GenID = Value then
    begin
      Result:= True;
    end else
    begin
      if assigned(FOnMessage) then
        FOnMessage(Self, 'Expected: '+ cdTokenName(Value) + '   found: '+
                   cdTokenName(DLex.TokenID), PosXY.X, PosXY.Y);
    end;
  end;

  procedure FindDirectiveEnd;
  begin
    while DLex.TokenID <> cdNull do
    case DLex.TokenID of
      cdAtEnd:
        begin
          DLex.Next;
          break;
        end;
    else NextNonJunkDirectiveToken;
    end;
  end;

  procedure CheckDirectiveEnd;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdComma:
        begin
          NextNonJunkDirectiveToken;
          ProcessDirective;
        end;
      cdAtEnd:;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
        FindDirectiveEnd;
      end;
    end;
  end;

  procedure CheckConditionalDirectiveEnd;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdAtEnd:;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
        FindDirectiveEnd;
      end;
    end;
  end;

  procedure SetBooleanDirectives(const Value: TbdBooleanDirectives;
    Activate: Boolean);
  begin
    case Activate of
      True: Include(FBooleanDirectives, Value);
      False: Exclude(FBooleanDirectives, Value);
    end;
    if not(FLexState = lsSkipping) then
      if Assigned(fOnBooleanDirectiveChanged) then fOnBooleanDirectiveChanged(Self, Value, Activate);
    CheckDirectiveEnd;
  end;

  procedure CheckBooleanDirective(Value: TbdBooleanDirectives);
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdOff: SetBooleanDirectives(Value, False);
      cdOn: SetBooleanDirectives(Value, True);
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
        FindDirectiveEnd;
      end;
    end;
  end;
  
  function CheckIfOptDirective: Boolean;
  var
    OptDirective: TbdBooleanDirectives;
  begin
    NextNonJunkDirectiveToken;
    OptDirective:= bdUnKnown;
    if fLexState = lsSkipping then
      Result := False else
    case DLex.TokenID of
      cdAPlus:
        begin
          Result:= bdAlign in FBooleanDirectives;
          OptDirective:= bdAlign;
        end;
      cdAMinus:
        begin
          Result:= not(bdAlign in FBooleanDirectives);
          OptDirective:= bdAlign;
        end;
      cdCPlus:
        begin
          Result:= bdAssertions in FBooleanDirectives;
          OptDirective:= bdAssertions;
        end;
      cdCMinus:
        begin
          Result:= not(bdAssertions in FBooleanDirectives);
          OptDirective:= bdAssertions;
        end;
      cdBPlus:
        begin
          Result:= bdBoolEval in FBooleanDirectives;
          OptDirective:= bdBoolEval;
        end;
      cdBMinus:
        begin
          Result:= not(bdBoolEval in FBooleanDirectives);
          OptDirective:= bdBoolEval;
        end;
      cdDPlus:
        begin
          Result:= bdDebugInfo in FBooleanDirectives;
          OptDirective:= bdDebugInfo;
        end;
      cdDMinus:
        begin
          Result:= not(bdDebugInfo in FBooleanDirectives);
          OptDirective:= bdDebugInfo;
        end;
      cdXPlus:
        begin
          Result:= bdExtendedSyntax in FBooleanDirectives;
          OptDirective:= bdExtendedSyntax;
        end;
      cdXMinus:
        begin
          Result:= not(bdExtendedSyntax in FBooleanDirectives);
          OptDirective:= bdExtendedSyntax;
        end;
      cdGPlus:
        begin
          Result:= bdImportedData in FBooleanDirectives;
          OptDirective:= bdImportedData;
        end;
      cdGMinus:
        begin
          Result:= not(bdImportedData in FBooleanDirectives);
          OptDirective:= bdImportedData;
        end;
      cdIPlus:
        begin
          Result:= bdIOChecks in FBooleanDirectives;
          OptDirective:= bdIOChecks;
        end;
      cdIMinus:
        begin
          Result:= not(bdIOChecks in FBooleanDirectives);
          OptDirective:= bdIOChecks;
        end;
      cdLPlus:
        begin
          Result:= bdLocalSymbols in FBooleanDirectives;
          OptDirective:= bdLocalSymbols;
        end;
      cdLMinus:
        begin
          Result:= not(bdLocalSymbols in FBooleanDirectives);
          OptDirective:= bdLocalSymbols;
        end;
      cdHPlus:
        begin
          Result:= bdLongStrings in FBooleanDirectives;
          OptDirective:= bdLongStrings;
        end;
      cdHMinus:
        begin
          Result:= not(bdLongStrings in FBooleanDirectives);
          OptDirective:= bdLongStrings;
        end;
      cdMPlus:
        begin
          Result:= bdTypeInfo in FBooleanDirectives;
          OptDirective:= bdTypeInfo;
        end;
      cdMMinus:
        begin
          Result:= not(bdTypeInfo in FBooleanDirectives);
          OptDirective:= bdTypeInfo;
        end;
      cdPPlus:
        begin
          Result:= bdOpenStrings in FBooleanDirectives;
          OptDirective:= bdOpenStrings;
        end;
      cdPMinus:
        begin
          Result:= not(bdOpenStrings in FBooleanDirectives);
          OptDirective:= bdOpenStrings;
        end;
      cdOPlus:
        begin
          Result:= bdOptimization in FBooleanDirectives;
          OptDirective:= bdOptimization;
        end;
      cdOMinus:
        begin
          Result:= not(bdOptimization in FBooleanDirectives);
          OptDirective:= bdOptimization;
        end;
      cdQPlus:
        begin
          Result:= bdOverFlowChecks in FBooleanDirectives;
          OptDirective:= bdOverFlowChecks;
        end;
      cdQMinus:
        begin
          Result:= not(bdOverFlowChecks in FBooleanDirectives);
          OptDirective:= bdOverFlowChecks;
        end;
      cdRPlus:
        begin
          Result:= bdRangeChecks in FBooleanDirectives;
          OptDirective:= bdRangeChecks;
        end;
      cdRMinus:
        begin
          Result:= not(bdRangeChecks in FBooleanDirectives);
          OptDirective:= bdRangeChecks;
        end;
      cdYPlus:
        begin
          Result:= bdDefinitionInfo in FBooleanDirectives;
          OptDirective:= bdDefinitionInfo;
        end;
      cdYMinus:
        begin
          Result:= not(bdDefinitionInfo in FBooleanDirectives);
          OptDirective:= bdDefinitionInfo;
        end;
      cdSafeDivide:
        begin
          Result:= bdSafeDivide in FBooleanDirectives;
          OptDirective:= bdSafeDivide;
        end;
      cdTPlus:
        begin
          Result:= bdTypedAddress in FBooleanDirectives;
          OptDirective:= bdTypedAddress;
        end;
      cdTMinus:
        begin
          Result:= not(bdTypedAddress in FBooleanDirectives);
          OptDirective:= bdTypedAddress;
        end;
      cdVPlus:
        begin
          Result:= bdVarStringChecks in FBooleanDirectives;
          OptDirective:= bdVarStringChecks;
        end;
      cdVMinus:
        begin
          Result:= not(bdVarStringChecks in FBooleanDirectives);
          OptDirective:= bdVarStringChecks;
        end;
      cdUnknownPlus:
        begin
          Result:= bdUnknown in FBooleanDirectives;
          OptDirective:= bdUnknown;
        end;
      cdUnknownMinus:
        begin
          Result:= not(bdUnknown in FBooleanDirectives);
          OptDirective:= bdUnknown;
        end;
      cdWPlus:
        begin
          Result:= bdStackFrames in FBooleanDirectives;
          OptDirective:= bdStackFrames;
        end;
      cdWMinus:
        begin
          Result:= not(bdStackFrames in FBooleanDirectives);
          OptDirective:= bdStackFrames;
        end;
      cdJPlus:
        begin
          Result:= bdWriteAbleConst in FBooleanDirectives;
          OptDirective:= bdWriteAbleConst;
        end;
      cdJMinus:
        begin
          Result:= not(bdWriteAbleConst in FBooleanDirectives);
          OptDirective:= bdWriteAbleConst;
        end;
    else Result:= False;
    end;
    NextNonJunkDirectiveToken;
    if DLex.TokenID = cdAtEnd then
    begin
      if assigned(fOnIfOptDirect) then
        fOnIfOptDirect(Self, OptDirective, Result);
      case Result of
        False: SkipIfOptDirect;
      end;
    end else
    begin
      if assigned(fOnInvalidDirect) then
        fOnInvalidDirect(Self, Token);
      FindDirectiveEnd;
      case Result of
        False: SkipIfOptDirect;
      end;
    end;
  end;

  procedure CheckRecordAlignment(Value: Integer);
  begin
    if not(FLexState = lsSkipping) then
      if assigned(fOnRecordAlignment) then
        fOnRecordAlignment(Self, Value);
    CheckDirectiveEnd;
  end;

  procedure CheckAppType;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdConsole:
        begin
          if not(FLexState = lsSkipping) then
            if assigned(fOnAppType) then
              fOnAppType(Self, atConsole);
        end;
      cdGUI:
        begin
          if not(FLexState = lsSkipping) then
            if assigned(fOnAppType) then
              fOnAppType(Self, atGUI);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
      end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckSODirective(Value: TcdTokenKind);
  var
    Temp: Integer;
    S: String;
  begin
    NextNonJunkDirectiveToken;
    Temp:= DLex.TokenPos;
    case DLex.TokenID of
      cdStringConst:
        if not(FLexState = lsSkipping) then
        begin
          SetString(S, (FOrigin + Temp +1), Run - Temp -1);
          if assigned(fOnSODirective) then
            fOnSODirective(Self, Value, S);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckDefineDirective;
  var
    Temp: Integer;
    S: String;
  begin
    NextNonJunkDirectiveToken;
    Temp:= DLex.TokenPos;
    case DLex.GenID of
      cdIdentifier:
        begin
          if not(FLexState = lsSkipping) then
          begin
            SetString(S, (FOrigin + Temp), Run - Temp);
            FDefinedList.AddSorted(S);
            if assigned(fOnDefineDirect) then
              fOnDefineDirect(Self, S);
          end;
          NextNonJunkDirectiveToken;
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
      end;
    end;
    if DLex.TokenID <> cdAtEnd then
    begin
      if assigned(fOnInvalidDirect) then
        fOnInvalidDirect(Self, Token);
      FindDirectiveEnd;
    end;
  end;

  procedure CheckDescriptionDirective;
  var
    Temp: Integer;
    S: String;
  begin
    NextNonJunkDirectiveToken;
    Temp:= DLex.TokenPos;
    case DLex.TokenID of
      cdStringConst:
        if not(FLexState = lsSkipping) then
        begin
          SetString(S, (FOrigin + Temp +1), Run - Temp -1);
          if assigned(fOnDescriptionDirect) then
            fOnDescriptionDirect(Self,S);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckElseDirective;
  begin
    case fSkipCounter of
      0: fLexState:= lsSkipping;

      1:
        begin
          dec(fSkipCounter);
          fLexState:= lsNormal;
        end;
    else
      begin
        if fSkipCounter < 0 then
         if assigned(fOnMessage) then
           FOnMessage(Self, 'Else directive without condition', PosXY.X, PosXY.Y);
      end;
    end;
    if FLexState = lsSkipping then
    begin
      NextNonJunkDirectiveToken;
      if DLex.TokenID = cdAtEnd then
      begin
        SkipElseDirect;
      end else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
        FindDirectiveEnd;
        SkipElseDirect;
      end;

    end else
      begin
        if assigned(fOnElseDirect) then
          fOnElseDirect(Self);
        CheckConditionalDirectiveEnd;
      end;
  end;

  function CheckCondition: Boolean; forward;

  function CheckDeclared: Boolean;
  begin
    Result:= False;
    NextNonJunkDirectiveToken;
    if ExpectedDirectiveToken(cdRoundOpen) then
      NextNonJunkDirectiveToken;
    case DLex.GenID of
      cdIdentifier:
        begin
          if not(FLexState = lsSkipping) then
            if assigned(fOnDeclared) then
              Result:= fOnDeclared(Self, DLex.Token);
          NextNonJunkDirectiveToken;
          if ExpectedDirectiveToken(cdRoundClose) then
            NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdAnd:
              begin
                NextNonJunkDirectiveToken;
                Result:= Result and CheckCondition;
              end;
            cdOr:
              begin
                NextNonJunkDirectiveToken;
                Result:= Result or CheckCondition;
              end;
          end;
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
      end;
    end;;
  end;

  function CheckDefined: Boolean;
  begin
    Result:= False;
    NextNonJunkDirectiveToken;
    if ExpectedDirectiveToken(cdRoundOpen) then
      NextNonJunkDirectiveToken;
    case DLex.GenID of
      cdIdentifier:
        begin
          if not(FLexState = lsSkipping) then
            if assigned(fOnDefined) then
              fOnDefined(Self, DLex.Token);
          Result:= fDefinedList.Hash(DLex.Token);
          NextNonJunkDirectiveToken;
          if ExpectedDirectiveToken(cdRoundClose) then
            NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdAnd:
              begin
                NextNonJunkDirectiveToken;
                Result:= CheckCondition and Result;//jdj 10/29/2002
              end;
            cdOr:
              begin
                NextNonJunkDirectiveToken;
                Result:= CheckCondition or Result//jdj 10/29/2002
              end;
          end;
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
      end;
    end;;
  end;

  function CheckTypeOfConstant: TcdTokenKind;
  begin
    Result:= cdUnknown;
    case DLex.TokenID of
      cdNumber, cdFloat, cdStringConst:
        begin
          Result:= DLex.TokenID;
        end;
    else
      begin
        if DLex.GenID = cdIdentifier then Result:= cdIdentifier else
        begin
          if assigned(fOnInvalidDirect) then
            fOnInvalidDirect(Self, Token);
        end;
      end ;
    end;
  end;

  function CheckTypeOfRelation: TcdTokenKind;
  begin
    Result:= cdUnknown;
    case DLex.TokenID of
      cdEqual, cdNotEqual, cdLower, cdGreater, cdLowerEqual, cdGreaterEqual:
        begin
          Result:= DLex.TokenID;
        end;
    else
      begin
        begin
          if assigned(fOnInvalidDirect) then
            fOnInvalidDirect(Self, Token);
        end;
      end ;
    end;
  end;

  function CheckDirectiveExpression: Boolean;
  var
    ConstOne, ConstTwo: String;
    ConstTypeOne, RelationType, ConstTypeTwo: TcdTokenKind;
  begin
    Result:= False;
    case DLex.TokenID of
      cdRoundOpen:
        begin
          NextNonJunkDirectiveToken;
          Result:= CheckCondition;
          if ExpectedDirectiveToken(cdRoundClose) then
            NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdAnd:
              begin
                NextNonJunkDirectiveToken;
                Result:= Result and CheckCondition;
              end;
            cdOr:
              begin
                NextNonJunkDirectiveToken;
                Result:= Result or CheckCondition;
              end;
          end;
        end;
    else
      begin
        ConstTypeOne:= CheckTypeOfConstant;
        ConstOne:= DLex.Token;
        if ConstTypeOne <> cdUnknown then
          NextNonJunkDirectiveToken;
        RelationType:= CheckTypeOfRelation;
        if RelationType <> cdUnknown then
          NextNonJunkDirectiveToken;
        ConstTypeTwo:= CheckTypeOfConstant;
        ConstTwo:= DLex.Token;
        if (ConstTypeOne <> cdUnknown)
          and (ConstTypeTwo <> cdUnknown)
          and (RelationType <> cdUnknown) then
        begin
          if not(FLexState = lsSkipping) then
            if assigned(fOnExpression) then
              Result:= fOnExpression(Self, ConstTypeOne, ConstOne, RelationType,
                                   ConstTypeTwo, ConstTwo);
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdAnd:
              begin
                NextNonJunkDirectiveToken;
                Result:= Result and CheckCondition;
              end;
            cdOr:
              begin
                NextNonJunkDirectiveToken;
                Result:= Result or CheckCondition;
              end;
          end;
        end;
      end;
    end;
  end;

  function CheckCondition: Boolean;
  begin
    Result:= False;
    case DLex.TokenID of
      cdAtEnd, cdNull:;
      cdDeclared:
        begin
          Result:= CheckDeclared;
        end;
      cdDefined:
        begin
          Result:= CheckDefined;
        end;
      cdNumber, cdFloat, cdStringConst:
        begin
          Result:= CheckDirectiveExpression;
        end;
      cdRoundOpen: Result:= CheckDirectiveExpression;
    else
      begin
        case DLex.GenID of
          cdIdentifier:
            begin
              Result:= CheckDirectiveExpression;
            end;
        end;
      end;
    end;
  end;

  function CheckElseIfDirective: Boolean;
  begin
    NextNonJunkDirectiveToken;
    case fSkipCounter of
      0: fLexState:= lsSkipping;

      1:
        begin
          dec(fSkipCounter);
          fLexState:= lsNormal;
        end;
    else
      begin
        if fSkipCounter < 0 then
         if assigned(fOnMessage) then
           FOnMessage(Self, 'ElseIf directive without condition', PosXY.X, PosXY.Y);
      end;
    end;
    Result:= CheckCondition;
    if FLexState <> lsSkipping then
      if not Result then
        FLexState := lsSkipping;
    if FLexState = lsSkipping then
    begin
      NextNonJunkDirectiveToken;
      if DLex.TokenID = cdAtEnd then
      begin
        SkipElseIfDirect;
      end else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
        FindDirectiveEnd;
        SkipElseDirect;
      end;

    end else
      begin
        if not(FLexState = lsSkipping) then
          if assigned(fOnElseIfDirect) then
            fOnElseIfDirect(Self);
        CheckConditionalDirectiveEnd;
      end;
  end;

  procedure CheckEndIfDirective;
  begin
    NextNonJunkDirectiveToken;
    CheckConditionalDirectiveEnd;
    if not(FLexState = lsSkipping) then
      if assigned(fOnEndIfDirect) then
        fOnEndIfDirect(Self);
    if FLexState = lsSkipping then
      dec(fSkipCounter);
    if fSkipCounter = 0 then
      FLexState := lsNormal;
  end;

  procedure CheckIfEndDirective;
  begin
    NextNonJunkDirectiveToken;
    CheckConditionalDirectiveEnd;
    dec(fSkipCounter);
    if fSkipCounter = 0 then
      FLexState := lsNormal;
    if not(FLexState = lsSkipping) then
      if assigned(fOnIfEndDirect) then
        fOnIfEndDirect(Self);
  end;

  procedure CheckExtensionDirective;
  begin
    NextNonJunkDirectiveToken;
    if ExpectedGenericToken(cdIdentifier) then
    begin
      NextNonJunkDirectiveToken;
      if not(FLexState = lsSkipping) then
        if assigned(fOnExtensionDirect) then
          fOnExtensionDirect(Self, DLex.Token);
      CheckDirectiveEnd;
    end else
    begin
      if assigned(fOnInvalidDirect) then
        fOnInvalidDirect(Self, Token);
      FindDirectiveEnd;
    end;
  end;

  procedure CheckExternalSymDirective;
  begin
    NextNonJunkDirectiveToken;
    if ExpectedGenericToken(cdIdentifier) then
    begin
      if not(FLexState = lsSkipping) then
        if assigned(fOnExternalsSymDirect) then
          fOnExternalsSymDirect(Self, DLex.Token);
      NextNonJunkDirectiveToken;
      CheckDirectiveEnd;
    end else
    begin
      if assigned(fOnInvalidDirect) then
        fOnInvalidDirect(Self, Token);
      FindDirectiveEnd;
    end;
  end;

  procedure CheckHPPEmitDirective;
  var
    Temp: Integer;
    S: String;
  begin
    NextNonJunkDirectiveToken;
    Temp:= DLex.TokenPos;
    if ExpectedDirectiveToken(cdStringConst) then
    begin
      if not(FLexState = lsSkipping) then
      begin
        SetString(S, (FOrigin + Temp +1), Run - Temp -1);
        if assigned(fOnHPPEmitDirect) then
          fOnHPPEmitDirect(Self, S);
      end;
      NextNonJunkDirectiveToken;
      CheckDirectiveEnd;
    end else
    begin
      if assigned(fOnInvalidDirect) then
        fOnInvalidDirect(Self, Token);
      FindDirectiveEnd;
    end;
  end;

  function CheckIfDirective: Boolean;
  begin
    NextNonJunkDirectiveToken;
    Result:= CheckCondition;
    if FLexState <> lsSkipping then
      if not Result then
        FLexState := lsSkipping;
    if FLexState = lsSkipping then
    begin
      NextNonJunkDirectiveToken;
      if DLex.TokenID = cdAtEnd then
      begin
        SkipIfDirect;
      end else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
        FindDirectiveEnd;
        SkipIfDirect;
      end;

    end else
      begin
        if not(FLexState = lsSkipping) then
          if assigned(fOnIfDirect) then
            fOnIfDirect(Self);
        CheckConditionalDirectiveEnd;
      end;
  end;

  function CheckIfDefDirective: Boolean;
  begin
    Result:= False;
    NextNonJunkDirectiveToken;
    if ExpectedGenericToken(cdIdentifier) then
    begin
      if not(FLexState = lsSkipping) then
        if assigned(fOnIfDefDirect) then
          fOnIfDefDirect(Self);
      Result:= fDefinedList.Hash(DLex.Token);
      NextNonJunkDirectiveToken;
      CheckConditionalDirectiveEnd;
    end else
    begin
      if assigned(fOnInvalidDirect) then
        fOnInvalidDirect(Self, Token);
      FindDirectiveEnd;
    end;
    if not Result then
    begin
      FLexState:= lsSkipping;
      SkipIfDefDirect;
    end;
  end;

  function CheckIfNDefDirective: Boolean;
  begin
    Result:= False;
    NextNonJunkDirectiveToken;
    if ExpectedGenericToken(cdIdentifier) then
    begin
      if not(FLexState = lsSkipping) then
        if assigned(fOnIfNDefDirect) then
          fOnIfNDefDirect(Self);
      Result:= fDefinedList.Hash(DLex.Token);
      NextNonJunkDirectiveToken;
      CheckConditionalDirectiveEnd;
    end else
    begin
      if assigned(fOnInvalidDirect) then
        fOnInvalidDirect(Self, Token);
      FindDirectiveEnd;
    end;
    if Result then
    begin
      FLexState:= lsSkipping;
      SkipIfNDefDirect;
    end;
  end;

  procedure CheckImageBaseDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdNumber:
        begin
          if assigned(fOnImageBaseDirect) then
            fOnImageBaseDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckIncludeDirective;
  var
    IncludeOrigin: PChar;
    IncludeFileName: String;
    OldStatus: PmwPasLexStatus;
  begin
    IncludeOrigin:= nil;
    NextNonJunkDirectiveToken;
    case DLex.GenID of
      cdFileName, cdDefaultFile, cdIdentifier:
        IncludeFileName:= DLex.Token;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckConditionalDirectiveEnd;
    if assigned(fOnIncludeDirect) then
      IncludeOrigin:= fOnIncludeDirect(Self, IncludeFileName);
    if IncludeOrigin <> nil then
    begin
      New(OldStatus);
      OldStatus^:= Status;
      fStatusStack.Push(OldStatus);
      fExID := ptUnknown;
      fLineNumber := 0;
      fLinePos := 0;
      fOrigin := IncludeOrigin;
      Run := 0;
      fTokenPos := 0;
      fTokenID := ptUnknown;
      fUnitName := IncludeFileName;
    end;
  end;

  procedure CheckLinkDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdFileName, cdStringConst:
        begin
          if assigned(fOnLinkDirect) then
            fOnLinkDirect(Self, DLex.Token);
        end;
    else
      case DLex.GenID of
        cdIdentifier:
          begin
            if assigned(fOnLinkDirect) then
              fOnLinkDirect(Self, DLex.Token);
          end;
      else
        begin
          if assigned(fOnInvalidDirect) then
            fOnInvalidDirect(Self, Token);
         end;
      end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckMinMaxStackSizeDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdNumber:
        begin
          if assigned(fOnMinStackSizeDirect) then
            fOnMinStackSizeDirect(Self, DLex.Token);
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdComma:
              begin
                NextNonJunkDirectiveToken;
                case DLex.TokenID of
                  cdNumber:
                    begin
                      if assigned(fOnMaxStackSizeDirect) then
                        fOnMaxStackSizeDirect(Self, DLex.Token);
                     end;
                else
                  begin
                    if assigned(fOnInvalidDirect) then
                      fOnInvalidDirect(Self, Token);
                  end;
                end;
              end;
          else
            begin
              if assigned(fOnInvalidDirect) then
                fOnInvalidDirect(Self, Token);
             end;
          end;
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckMinStackSizeDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdNumber:
        begin
          if assigned(fOnMinStackSizeDirect) then
            fOnMinStackSizeDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckMaxStackSizeDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdNumber:
        begin
          if assigned(fOnMaxStackSizeDirect) then
            fOnMaxStackSizeDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckShortMinEnumSizeDirective(Value: String);
  begin
    if assigned(fOnMinEnumSizeDirect) then
      fOnMinEnumSizeDirect(Self, Value);
    CheckDirectiveEnd;
  end;

  procedure CheckMinEnumSizeDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdNumber:
        begin
          if assigned(fOnMinEnumSizeDirect) then
            fOnMinEnumSizeDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckNoDefineDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.GenID of
      cdIdentifier:
        begin
          if assigned(fOnNoDefineDirect) then
            fOnNoDefineDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckNoIncludeDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.GenID of
      cdIdentifier, cdFileName:
        begin
          if assigned(fOnNoIncludeDirect) then
            fOnNoIncludeDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure  CheckResourceReserveDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdNumber:
        begin
          if assigned(fOnResourceReserveDirect) then
            fOnResourceReserveDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure  CheckResourceDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.GenID of
      cdIdentifier, cdFileName, cdDefaultFile:
        begin
          if assigned(fOnResourceDirect) then
            fOnResourceDirect(Self, DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckSetPEFlagsDirective;
  begin
    NextNonJunkDirectiveToken;

  end;

  procedure CheckSetPEOptFlagsDirective;
  begin
    NextNonJunkDirectiveToken;

  end;

  procedure CheckUnDefDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.GenID of
      cdIdentifier:
        begin
          if assigned(fOnUnDefDirect) then
            fOnUnDefDirect(Self, DLex.Token);
          fDefinedList.Remove(DLex.Token);
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

  procedure CheckWarnDirective;
  begin
    NextNonJunkDirectiveToken;
    case DLex.TokenID of
      cdOff: SetBooleanDirectives(bdWarn, False);
      cdOn: SetBooleanDirectives(bdWarn, True);
      cdSymbol_Platform:
        begin
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdOff: SetBooleanDirectives(bdSymbol_Platform, False);
            cdOn: SetBooleanDirectives(bdSymbol_Platform, True);
          end;
        end;
      cdSymbol_Library:
        begin
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdOff: SetBooleanDirectives(bdSymbol_Library, False);
            cdOn: SetBooleanDirectives(bdSymbol_Library, True);
          end;
        end;
      cdSymbol_Deprecated:
        begin
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdOff: SetBooleanDirectives(bdSymbol_Deprecated, False);
            cdOn: SetBooleanDirectives(bdSymbol_Deprecated, True);
          end;
        end;
      cdUnit_Deprecated:
        begin
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdOff: SetBooleanDirectives(bdUnit_Deprecated, False);
            cdOn: SetBooleanDirectives(bdUnit_Deprecated, True);
          end;
        end;
      cdUnit_Library:
        begin
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdOff: SetBooleanDirectives(bdUnit_Library, False);
            cdOn: SetBooleanDirectives(bdUnit_Library, True);
          end;
        end;
      cdUnit_Platform:
        begin
          NextNonJunkDirectiveToken;
          case DLex.TokenID of
            cdOff: SetBooleanDirectives(bdUnit_Platform, False);
            cdOn: SetBooleanDirectives(bdUnit_Platform, True);
          end;
        end;
    else
      begin
        if assigned(fOnInvalidDirect) then
          fOnInvalidDirect(Self, Token);
       end;
    end;
    CheckDirectiveEnd;
  end;

begin
  fTokenPos:= DLex.TokenPos;
  case DLex.TokenID of
    cdAOne: CheckRecordAlignment(1);
    cdATwo:CheckRecordAlignment(2);
    cdAFour:CheckRecordAlignment(4);
    cdAEight: CheckRecordAlignment(8);
    cdAPlus: SetBooleanDirectives(bdAlign, True);
    cdApptype: CheckAppType;
    cdAMinus: SetBooleanDirectives(bdAlign, False);
    cdAlign: CheckBooleanDirective(bdAlign);
    cdCPlus: SetBooleanDirectives(bdAssertions, True);
    cdCMinus: SetBooleanDirectives(bdAssertions, False);
    cdAssertions: CheckBooleanDirective(bdAssertions);
    cdBPlus: SetBooleanDirectives(bdBoolEval, True);
    cdBMinus: SetBooleanDirectives(bdBoolEval, False);
    cdBooleval: CheckBooleanDirective(bdBooleval);
    cdSoPrefix:CheckSODirective(cdSoPrefix);
    cdSoSuffix: CheckSODirective(cdSoSuffix);
    cdSoVersion: CheckSODirective(cdSoVersion);
    cdSoName: CheckSODirective(cdSoName);
    cdDPlus: SetBooleanDirectives(bdDebugInfo, True);
    cdDMinus: SetBooleanDirectives(bdDebugInfo, False);
    cdDebugInfo: CheckBooleanDirective(bdDebugInfo);
    cdDefine: CheckDefineDirective;
    cdDenyPackageUnit: CheckBooleanDirective(bdDenyPackageUnit);
    cdDescription: CheckDescriptionDirective;
    cdDesignOnly: CheckBooleanDirective(bdDesignOnly);
    cdElse: CheckElseDirective;
    cdElseIf: CheckElseIfDirective;
    cdEndIf: CheckEndIfDirective;
    cdIfEnd: CheckIfEndDirective;
    cdE: CheckExtensionDirective;
    cdExtension:CheckExtensionDirective;
    cdObjExportAll: CheckBooleanDirective(bdObjExportAll);
    cdXPlus: SetBooleanDirectives(bdExtendedSyntax, True);
    cdXMinus: SetBooleanDirectives(bdExtendedSyntax, False);
    cdExtendedSyntax: CheckBooleanDirective(bdExtendedSyntax);
    cdExternalSym: CheckExternalSymDirective;
    cdHints: CheckBooleanDirective(bdHints);
    cdHPPEmit: CheckHPPEmitDirective;
    cdIf: CheckIfDirective;
    cdIfDef: CheckIfDefDirective;
    cdIfNDef: CheckIfNDefDirective;
    cdIfOpt: CheckIfOptDirective;
    cdImageBase:  CheckImageBaseDirective;
    cdImplicitBuild: CheckBooleanDirective(bdImplicitBuild);
    cdGPlus: SetBooleanDirectives(bdImportedData, True);
    cdGMinus: SetBooleanDirectives(bdImportedData, False);
    cdImportedData: CheckBooleanDirective(bdImportedData);
    cdI: CheckIncludeDirective;
    cdIPlus: SetBooleanDirectives(bdIOChecks, True);
    cdIMinus: SetBooleanDirectives(bdIOChecks, False);
    cdInclude:  CheckIncludeDirective;
    cdIOChecks: CheckBooleanDirective(bdIOChecks);
    cdL: CheckLinkDirective;
    cdLPlus: SetBooleanDirectives(bdLocalSymbols, True);
    cdLMinus: SetBooleanDirectives(bdLocalSymbols, False);
    cdLink: CheckLinkDirective;
    cdLocalSymbols: CheckBooleanDirective(bdLocalSymbols);
    cdHPlus: SetBooleanDirectives(bdLongStrings, True);
    cdHMinus: SetBooleanDirectives(bdLongStrings, False);
    cdLongStrings: CheckBooleanDirective(bdLongStrings);
  {$IfDef Linux}
    cdM: CheckResourceReserveDirective;
  {$EndIf}

  {$IfDef MsWindows}
    cdM: CheckMinMaxStackSizeDirective;
  {$EndIf}
  
    cdMPlus: SetBooleanDirectives(bdTypeInfo, True);
    cdMMinus: SetBooleanDirectives(bdTypeInfo, False);
    cdMinStackSize: CheckMinStackSizeDirective;
    cdMaxStackSize: CheckMaxStackSizeDirective;
    cdZOne: CheckShortMinEnumSizeDirective('1');
    cdZTwo: CheckShortMinEnumSizeDirective('2');
    cdZFour: CheckShortMinEnumSizeDirective('4');
    cdMinEnumSize: CheckMinEnumSizeDirective;
    cdPPlus: SetBooleanDirectives(bdOpenStrings, True);
    cdPMinus: SetBooleanDirectives(bdOpenStrings, False);
    cdOpenStrings: CheckBooleanDirective(bdOpenStrings);
    cdOPlus: SetBooleanDirectives(bdOptimization, True);
    cdOMinus: SetBooleanDirectives(bdOptimization, False);
    cdOptimization: CheckBooleanDirective(bdOptimization);
    cdQPlus: SetBooleanDirectives(bdOverflowChecks, True);
    cdQMinus: SetBooleanDirectives(bdOverflowChecks, False);
    cdOverFlowChecks: CheckBooleanDirective(bdOverFlowChecks);
    cdNoDefine: CheckNoDefineDirective;
    cdNoInclude: CheckNoIncludeDirective;
    cdR:  CheckResourceDirective;
    cdRPlus: SetBooleanDirectives(bdRangeChecks, True);
    cdRMinus: SetBooleanDirectives(bdRangeChecks, False);
    cdRangeChecks: CheckBooleanDirective(bdRangeChecks);
    cdRealCompatibility: CheckBooleanDirective(bdRealCompatibility);
    cdResourceReserve: CheckResourceReserveDirective;
    cdResource:  CheckResourceDirective;
    cdRunOnly: CheckBooleanDirective(bdRunOnly);
    cdTypeInfo: CheckBooleanDirective(bdTypeInfo);
    cdYPlus: SetBooleanDirectives(bdDefinitionInfo, True);
    cdYMinus: SetBooleanDirectives(bdDefinitionInfo, False);
    cdYD: SetBooleanDirectives(bdDefinitionInfo, True);
    cdReferenceInfo: CheckBooleanDirective(bdDefinitionInfo);
    cdDefinitionInfo: CheckBooleanDirective(bdDefinitionInfo);
    cdSafeDivide: CheckBooleanDirective(bdSafeDivide);
    cdSetPEFlags:  CheckSetPEFlagsDirective;
    cdSetPEOptFlags:   CheckSetPEOptFlagsDirective;
    cdTPlus: SetBooleanDirectives(bdTypedAddress, True);
    cdTMinus: SetBooleanDirectives(bdTypedAddress, False);
    cdTypedAddress: CheckBooleanDirective(bdTypedAddress);
    cdUnDef: CheckUnDefDirective;
    cdUPlus: SetBooleanDirectives(bdSafeDivide, True);
    cdUMinus: SetBooleanDirectives(bdSafeDivide, False);
    cdUnknownPlus: SetBooleanDirectives(bdUnknown, True);
    cdUnknownMinus: SetBooleanDirectives(bdUnknown, False);
    cdVPlus: SetBooleanDirectives(bdVarStringChecks, True);
    cdVMinus: SetBooleanDirectives(bdVarStringChecks, False);
    cdVarStringChecks: CheckBooleanDirective(bdVarStringChecks);
    cdWarn: CheckWarnDirective;
    cdWarnings: CheckBooleanDirective(bdWarnings);
    cdWeakPackageUnit: CheckBooleanDirective(bdWeakPackageUnit);
    cdWPlus: SetBooleanDirectives(bdStackFrames, True);
    cdWMinus: SetBooleanDirectives(bdStackFrames, False);
    cdStackFrames: CheckBooleanDirective(bdStackFrames);
    cdJPlus: SetBooleanDirectives(bdWriteableConst, True);
    cdJMinus: SetBooleanDirectives(bdWriteableConst, False);
    cdWriteableConst: CheckBooleanDirective(bdWriteableConst);
    cdUnknown:
      begin

      end;
  end;
end;

function TmwBasePasLex.GetDirectiveParam: string;
var
  EndPos: Integer;
  ParamLen: Integer;
begin
  EndPos:= 0;
  case fOrigin[fTokenPos] of
    '(':
      begin
        TempRun := FTokenPos + 3;
        EndPos := Run - 2;
      end;
    '{':
      begin
        TempRun := FTokenPos + 2;
        EndPos := Run - 1;
      end;
  end;
  while Identifiers[fOrigin[TempRun]] do
    inc(TempRun);
  while fOrigin[TempRun] in ['+', ',', '-'] do
  begin
    inc(TempRun);
    while Identifiers[fOrigin[TempRun]] do
      inc(TempRun);
    if (fOrigin[TempRun - 1] in ['+', ',', '-']) and (fOrigin[TempRun] = ' ')
      then inc(TempRun);
  end;
  if fOrigin[TempRun] = ' ' then inc(TempRun);
  ParamLen := EndPos - TempRun;
  SetString(Result, (FOrigin + TempRun), ParamLen);
  Result := UpperCase(Result);
end;

procedure TmwBasePasLex.Init;
begin
  fLexState := lsNormal;
  fLineNumber := 0;
  fLinePos := 0;
  Run := 0;
end;

procedure TmwBasePasLex.InitLine;
begin
  fLineNumber := 0;
  fLinePos := 0;
  Run := 0;
end;

procedure TmwBasePasLex.SetLexState(const Value: Pointer);
begin
  fLexState := TmwLexState(Value);
end;

procedure TmwBasePasLex.SetOrigin(NewValue: PChar);
begin
  fOrigin := NewValue;
  Init;
  Next;
end; { SetOrigin }

procedure TmwBasePasLex.SetRunPos(Value: Integer);
begin
  Run := Value;
  Next;
end;

function TmwBasePasLex.GetStatus: TmwPasLexStatus;
begin
  Result.LexState := fLexState;
  Result.ExID := fExID;
  Result.LineNumber := fLineNumber;
  Result.LinePos := fLinePos;
  Result.Origin := fOrigin;
  Result.RunPos := Run;
  Result.TokenPos := fTokenPos;
  Result.TokenID := fTokenID;
  Result.BooleanDirectives := FBooleanDirectives;
  Result.SkipCounter:= fSkipCounter;
  Result.UnitName := fUnitName;
end;

procedure TmwBasePasLex.SetStatus(const Value: TmwPasLexStatus);
begin
  fLexState := Value.LexState;
  fExID := Value.ExID;
  fLineNumber := Value.LineNumber;
  fLinePos := Value.LinePos;
  fOrigin := Value.Origin;
  Run := Value.RunPos;
  fTokenPos := Value.TokenPos;
  fTokenID := Value.TokenID;
  FBooleanDirectives:= Value.BooleanDirectives;
  fSkipCounter:= Value.SkipCounter;
  fUnitName:= Value.UnitName;
end;

procedure TmwBasePasLex.SetLine(const Value: string);
begin
  fOrigin := PChar(Value);
  InitLine;
  Next;
end;

function TmwBasePasLex.GetStringContent: string;
var
  TempString: string;
  sEnd: Integer;
begin
  if TokenID <> ptStringConst then
    Result := ''
  else
  begin
    TempString := Token;
    sEnd := Length(TempString);
    if TempString[sEnd] <> #39 then inc(sEnd);
    Result := Copy(TempString, 2, sEnd - 2);
    TempString := '';
  end;
end;

function TmwBasePasLex.GetGenID: TptTokenKind;
begin
  Result := fTokenID;
  if fTokenID = ptIdentifier then
    if fExID <> ptUnknown then Result := fExID;
end;

procedure TmwBasePasLex.SetOnCompDirect(const Value: TmwLexEvent);
begin
  fOnCompDirect := Value;
end;

procedure TmwBasePasLex.SetOnDefineDirect(const Value: TmwLexStringEvent);
begin
  fOnDefineDirect := Value;
end;

procedure TmwBasePasLex.SetOnElseDirect(const Value: TmwLexEvent);
begin
  fOnElseDirect := Value;
end;

procedure TmwBasePasLex.SetOnEndIfDirect(const Value: TmwLexEvent);
begin
  fOnEndIfDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfDefDirect(const Value: TmwLexEvent);
begin
  fOnIfDefDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfNDefDirect(const Value: TmwLexEvent);
begin
  fOnIfNDefDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfOptDirect(const Value: TmwLexIfOptEvent);
begin
  fOnIfOptDirect := Value;
end;

procedure TmwBasePasLex.SetOnIncludeDirect(const Value: TmwLexOnIncludeEvent);
begin
  fOnIncludeDirect := Value;
end;

procedure TmwBasePasLex.SetOnResourceDirect(const Value: TmwLexStringEvent);
begin
  fOnResourceDirect := Value;
end;

procedure TmwBasePasLex.SetOnUnDefDirect(const Value: TmwLexStringEvent);
begin
  fOnUnDefDirect := Value;
end;

procedure TmwBasePasLex.SetOnInvalidDirect(const Value: TmwLexStringEvent);
begin
  fOnInvalidDirect:= Value;
end;

procedure TmwBasePasLex.AtLineEnd(aLinePos: Integer);
begin
  inc(fLineNumber);
  fLinePos := aLinePos;
  if assigned(fOnLineEnd) then fOnLineEnd(Self);
end;

procedure TmwBasePasLex.SetOnLineEnd(const Value: TmwLexEvent);
begin
  fOnLineEnd := Value;
end;

procedure TmwBasePasLex.SetOnDeclared(const Value: TmwLexStringBooleanEvent);
begin
  fOnDeclared := Value;
end;

procedure TmwBasePasLex.SetOnDefined(const Value: TmwLexStringEvent);
begin
  fOnDefined := Value;
end;

procedure TmwBasePasLex.SetOnExpression(
  const Value: TmwLexExpressionEvent);
begin
  fOnExpression := Value;
end;

procedure TmwBasePasLex.SetOnElseIfDirect(const Value: TmwLexEvent);
begin
  fOnElseIfDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfDirect(const Value: TmwLexEvent);
begin
  fOnIfDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfEndDirect(const Value: TmwLexEvent);
begin
  fOnIfEndDirect := Value;
end;

procedure TmwBasePasLex.UnknownProc;
begin
  inc(Run);
  fTokenID := ptUnknown;
  if Assigned(FOnMessage) then
    FOnMessage(Self, 'Unknown Character', PosXY.X, PosXY.Y);
end;

{ TmwPasLex }

constructor TmwPasLex.Create;
begin
  inherited Create;
  fAheadLex := TmwBasePasLex.Create;
end;

destructor TmwPasLex.Destroy;
begin
  fAheadLex.Free;
  inherited Destroy;
end;

procedure TmwPasLex.SetOrigin(NewValue: PChar);
begin
  inherited SetOrigin(NewValue);
  fAheadLex.SetOrigin(NewValue);
end;

procedure TmwPasLex.SetLine(const Value: string);
begin
  inherited SetLine(Value);
  fAheadLex.SetLine(Value);
end;

procedure TmwPasLex.AheadNext;
begin
  fAheadLex.NextNoJunk;
end;

function TmwPasLex.GetAheadExID: TptTokenKind;
begin
  Result := fAheadLex.ExID;
end;

function TmwPasLex.GetAheadGenID: TptTokenKind;
begin
  Result := fAheadLex.GenID;
end;

function TmwPasLex.GetAheadToken: string;
begin
  Result := fAheadLex.Token;
end;

function TmwPasLex.GetAheadTokenID: TptTokenKind;
begin
  Result := fAheadLex.TokenID;
end;

procedure TmwPasLex.InitAhead;
begin
  fAheadLex.fStatusStack.Clear;
  fAheadLex.Status := Status;
  fAheadLex.DefinedList.Assign(fDefinedList);
  fAheadLex.Next;
  while fAheadLex.IsJunk do
    fAheadLex.Next;
end;

procedure TmwPasLex.SetOnCompDirect(const Value: TmwLexEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnCompDirect := Value;
end;

procedure TmwPasLex.SetOnDefineDirect(const Value: TmwLexStringEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnDefineDirect := Value;
end;

procedure TmwPasLex.SetOnElseDirect(const Value: TmwLexEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnElseDirect := Value;
end;

procedure TmwPasLex.SetOnEndIfDirect(const Value: TmwLexEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnEndIfDirect := Value;
end;

procedure TmwPasLex.SetOnIfDefDirect(const Value: TmwLexEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnIfDefDirect := Value;
end;

procedure TmwPasLex.SetOnIfNDefDirect(const Value: TmwLexEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnIfNDefDirect := Value;
end;

procedure TmwPasLex.SetOnIfOptDirect(const Value: TmwLexIfOptEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnIfOptDirect := Value;
end;

procedure TmwPasLex.SetOnIncludeDirect(const Value: TmwLexOnIncludeEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnIncludeDirect := Value;
end;

procedure TmwPasLex.SetOnResourceDirect(const Value: TmwLexStringEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnResourceDirect := Value;
end;

procedure TmwPasLex.SetOnUnDefDirect(const Value: TmwLexStringEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnUnDefDirect := Value;
end;

procedure TmwPasLex.SetOnLineEnd(const Value: TmwLexEvent);
begin
  inherited;
  if AheadEvents then
    AheadLex.OnLineEnd := Value;
end;

end.
