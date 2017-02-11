{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: mwDirectiveLex.PAS, released March 2002.

The Initial Developer of the Original Code is Martin Waldenburg
(Martin.Waldenburg@T-Online.de).
Portions created by Martin Waldenburg are Copyright (C) 2002 Martin
Waldenburg.
All Rights Reserved.

Contributor(s): James Jacobson _____________________________________.


Last Modified: mm/dd/yyyy
Current Version: 1.0

Notes: This program is a very fast sub tokenizer for directives.
Modification history:

Known Issues:
-----------------------------------------------------------------------------}

unit dws_mwDirectiveLex;

interface

uses
  dws_mwPasLexTypes;

type
  TmwDirectiveLex = class(TObject)
  private
    fDirectiveHash: TmwDirectiveHash;
    fOrigin: PChar;
    Run: Integer;
    fTokenPos: Integer;
    FTokenID: TcdTokenKind;
    FState: TptTokenKind;
    function GetToken: string;
    function GetTokenLen: Integer;
    procedure SetOrigin(const Value: PChar);
    procedure SetRunPos(const Value: Integer);
    function GetAheadID: TcdTokenKind;
    procedure SetState(const Value: TptTokenKind);
    function GetGenID: TcdTokenKind;
  protected
    property DirectiveHash: TmwDirectiveHash read fDirectiveHash;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init(NewOrigin: PChar; NewRun: Integer; NewState: TptTokenKind);
    procedure Next;
    property AheadID: TcdTokenKind read GetAheadID;
    property GenID: TcdTokenKind read GetGenID;
    property Origin: PChar read fOrigin write SetOrigin;
    property RunPos: Integer read Run write SetRunPos;
    property State: TptTokenKind read FState write SetState;
    property Token: string read GetToken;
    property TokenLen: Integer read GetTokenLen;
    property TokenPos: Integer read fTokenPos;
    property TokenID: TcdTokenKind read FTokenID;
  published
  end;

implementation

{ TmwDirectiveLex }
constructor TmwDirectiveLex.Create;
begin
  inherited Create;
  fDirectiveHash:= TmwDirectiveHash.Create;
end;

destructor TmwDirectiveLex.Destroy;
begin
  fDirectiveHash.Free;
  inherited;
end;

function TmwDirectiveLex.GetAheadID: TcdTokenKind;
var
  OldRun, OldTokenPos: Integer;
begin
  OldRun:= Run;
  OldTokenPos:= fTokenPos;
  Next;
  Result:= fTokenID;
  Run:= OldRun;
  fTokenPos:=OldTokenPos;
end;

function TmwDirectiveLex.GetGenID: TcdTokenKind;
begin
  Result:= fTokenId;
  if Result in [cdA..cdWriteableConst, cdAnd, cdDeclared, cdDefined, cdOff, cdOn,
    cdOr, cdSymbol_Platform, cdSymbol_Library, cdSymbol_Deprecated, cdUnit_Deprecated, cdUnit_Library, cdUnit_Platform] then
    Result:= cdIdentifier;
end;


function TmwDirectiveLex.GetToken: string;
begin
  SetString(Result, (FOrigin + fTokenPos), GetTokenLen);
end;

function TmwDirectiveLex.GetTokenLen: Integer;
begin
  Result := Run - fTokenPos;
end;

procedure TmwDirectiveLex.Init(NewOrigin: PChar; NewRun: Integer; NewState: TptTokenKind);
begin
  FOrigin:= NewOrigin;
  Run := NewRun;
  FState:= NewState;
  fTokenID:= cdUnknown;
  Next;
end;

procedure TmwDirectiveLex.Next;
var
  QuoteCount: Integer;
begin
  fTokenID:= cdUnknown;
  fTokenPos:= Run;
  case fOrigin[Run] of
    #0: fTokenId:= cdNull;
    #1..#9, #11, #12, #14..#32:
      begin
        fTokenId := cdSpace;
        while fOrigin[Run] in [#1..#9, #11, #12, #14..#32] do
        inc(Run);
      end;
    #10:
      begin
        fTokenId := cdCRLF;
        inc(Run);
      end;
    #13:
      begin
        fTokenId := cdCRLF;
        inc(Run);
        if fOrigin[Run] = #10 then
        inc(Run);
      end;
    '$':
      begin
        inc(Run);
        fTokenId := cdNumber;
        while fOrigin[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do
        inc(Run);
      end;
    #39:
      begin
        fTokenId := cdStringConst;
        QuoteCount:= 1;
        inc(Run);
        repeat
          case fOrigin[Run] of
            #0,#10,#13:
              begin
                fTokenId := cdUnknown;
                break;
              end;
            #39:
              begin
                inc(QuoteCount);
                inc(Run);
                if (not Odd(QuoteCount)) and (fOrigin[Run] <> #39) then
                  break
                else
                  inc(Run);
              end;
          else inc(Run);
          end;
        until fOrigin[Run] = #39;
        if fOrigin[Run] = #39 then//jdj 10/29/2002<<<<<<<<<<Added
          inc(Run);
      end;

    '(':
      begin
        fTokenId := cdRoundOpen;
        inc(Run);
      end;
    ')':
      begin
        fTokenId := cdRoundClose;
        inc(Run);
      end;
    '*':
      begin
        inc(Run);
        case fOrigin[Run] of
          ')':
            begin
              fTokenId := cdAnsiEnd;
              inc(Run);
              if FState = ptAnsiDirective then
              fTokenId := cdAtEnd;
            end;
          '.':
            begin
              fTokenId := cdDefaultFile;
              inc(Run);
              while fOrigin[Run] in ['A'..'Z', 'a'..'z'] do
              inc(Run);
            end;
        end;
      end;
    ',':
      begin
        fTokenId := cdComma;
        inc(Run);
      end;
    '0'..'9':
      begin
        fTokenId := cdNumber;
        while fOrigin[Run] in ['0'..'9'] do
        inc(Run);
        if fOrigin[Run] = '.' then
        begin
          inc(Run);
          fTokenId := cdFloat;
          while fOrigin[Run] in ['0'..'9'] do
          inc(Run);
        end;
      end;
      '<':
        begin
          fTokenId := cdLower;
          inc(Run);
          case fOrigin[Run] of
            '=':
              begin
                fTokenId := cdLowerEqual;
                inc(Run);
              end;
            '>':
              begin
                fTokenId := cdNotEqual;
                inc(Run);
              end;
          end;
        end;
      '=':
        begin
          fTokenId := cdEqual;
          inc(Run);
        end;
      '>':
        begin
          fTokenId := cdGreater;
          inc(Run);
          case fOrigin[Run] of
            '=':
              begin
                fTokenId := cdGreaterEqual;
                inc(Run);
              end;
          end;
        end;
    '_', 'A'..'Z', 'a'..'z':
      begin
        fTokenId := cdIdentifier;
        fDirectiveHash.HashRun(fOrigin, Run, fTokenId);
        case fTokenId of
          cdA:
            begin
              case fOrigin[Run]of
                '1': fTokenId:= cdAOne;
                '2': fTokenId:= cdATwo;
                '4': fTokenId:= cdAFour;
                '8': fTokenId:= cdAEight;
                '+': fTokenId:= cdAPlus;
                '-': fTokenId:= cdAMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdB:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdBPlus;
                '-': fTokenId:= cdBMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdC:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdCPlus;
                '-': fTokenId:= cdCMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdD:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdDPlus;
                '-': fTokenId:= cdDMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdE:
            begin
              case fOrigin[Run]of
                #1..#9, #11, #12, #14..#32:;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdG:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdGPlus;
                '-': fTokenId:= cdGMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdH:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdHPlus;
                '-': fTokenId:= cdHMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdI:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdIPlus;
                '-': fTokenId:= cdIMinus;
                #1..#9, #11, #12, #14..#32:;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdJ:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdJPlus;
                '-': fTokenId:= cdJMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdL:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdLPlus;
                '-': fTokenId:= cdLMinus;
                #1..#9, #11, #12, #14..#32:;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdM:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdMPlus;
                '-': fTokenId:= cdMMinus;
                #1..#9, #11, #12, #14..#32:;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdO:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdOPlus;
                '-': fTokenId:= cdOMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdP:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdPPlus;
                '-': fTokenId:= cdPMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdQ:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdQPlus;
                '-': fTokenId:= cdQMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdR:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdRPlus;
                '-': fTokenId:= cdRMinus;
              else
                begin
                  fTokenId:= cdResource;
                end;
              end;
              inc(Run);
            end;
          cdT:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdTPlus;
                '-': fTokenId:= cdTMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdU:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdUPlus;
                '-': fTokenId:= cdUMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdV:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdVPlus;
                '-': fTokenId:= cdVMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdW:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdWPlus;
                '-': fTokenId:= cdWMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdX:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdXPlus;
                '-': fTokenId:= cdXMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdY:
            begin
              case fOrigin[Run]of
                '+': fTokenId:= cdYPlus;
                '-': fTokenId:= cdYMinus;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
          cdZ:
            begin
              case fOrigin[Run]of
                '1': fTokenId:= cdZOne;
                '2': fTokenId:= cdZTwo;
                '4': fTokenId:= cdZFour;
              else
                begin
                  dec(Run);
                  fTokenId:= cdUnknown;
                end;
              end;
              inc(Run);
            end;
        end;
        if GenId = cdIdentifier then
          case fOrigin[Run] of
            '.':
              begin
                inc(Run);
                fTokenId := cdFileName;
                while fOrigin[Run] in['0'..'9', '_', 'A'..'Z', 'a'..'z'] do
                inc(Run);
              end;
            '+':
              begin
                inc(Run);
                fTokenId := cdUnknownPlus;
              end;
            '-':
              begin
                inc(Run);
                fTokenId := cdUnknownMinus;
              end;
          end;
      end;
    '}':
      begin
        fTokenId := cdBorEnd;
        inc(Run);
        if FState = ptBorDirective then
          fTokenId := cdAtEnd;
      end;
  else
    begin
      fTokenId := cdUnknown;
      inc(Run);
    end;
  end;
end;

procedure TmwDirectiveLex.SetOrigin(const Value: PChar);
begin
  fOrigin := Value;
end;

procedure TmwDirectiveLex.SetRunPos(const Value: Integer);
begin
  Run := Value;
  fTokenId := cdUnknown;
  Next;
end;

procedure TmwDirectiveLex.SetState(const Value: TptTokenKind);
begin
  FState := Value;
end;


end.

