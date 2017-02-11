{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13744: IdBlockCipherIntercept.pas 
{
{   Rev 1.4    5/12/2003 12:30:58 AM  GGrieve
{ Get compiling again with DotNet Changes
}
{
{   Rev 1.3    10/12/2003 1:49:26 PM  BGooijen
{ Changed comment of last checkin
}
{
{   Rev 1.2    10/12/2003 1:43:24 PM  BGooijen
{ Changed IdCompilerDefines.inc to Core\IdCompilerDefines.inc
}
{
{   Rev 1.0    11/14/2002 02:13:56 PM  JPMugaas
}
unit IdBlockCipherIntercept;

{-----------------------------------------------------------------------------
 UnitName: IdBlockCipherIntercept
 Author:   Andrew P.Rybin [magicode@mail.ru]
 Creation: 27.02.2002
 Version:  0.9.0b
 Purpose:  Secure communications
 History:
-----------------------------------------------------------------------------}

{$I Core\IdCompilerDefines.inc}

interface

uses
  Classes,
  IdCoreGlobal,
  IdException,
  IdIntercept;

const
  IdBlockCipherBlockSizeDefault = 16;

  IdBlockCipherBlockSizeMax     = 256;
  // why 256? not any block ciphers that can - or should - be used beyond this
  // length. You can extend this if you like. But the longer it is, the
  // more network traffic is wasted

type
  TIdBlockCipherIntercept = class;

  // OnSend and OnRecieve Events will always be called with a blockSize Data
  TIdBlockCipherIntercept = class(TIdConnectionIntercept)
  protected
    FBlockSize: Integer;
    FIncoming : TIdBytes;
    procedure Decrypt (var VData : TIdBytes); virtual;
    procedure Encrypt (Var VData : TIdBytes); virtual;
    procedure SetBlockSize(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;

    procedure Receive(var VBuffer: TIdBytes); override; //Decrypt
    procedure Send(var VBuffer: TIdBytes); override; //Encrypt
    procedure CopySettingsFrom (ASrcBlockCipherIntercept: TIdBlockCipherIntercept); // warning: copies Data too
    //
  published
    property  BlockSize: Integer read FBlockSize write SetBlockSize default IdBlockCipherBlockSizeDefault;
  End; //TIdBlockCipherIntercept

  EIdBlockCipherInterceptException = EIdException; {block length}

IMPLEMENTATION

Uses
  IdResourceStrings,
  SysUtils;

{ TIdBlockCipherIntercept }

const
  bitLongTail = $80; //future: for IdBlockCipherBlockSizeMax>256

constructor TIdBlockCipherIntercept.Create(AOwner: TComponent);
Begin
  inherited Create(AOwner);
  FBlockSize := IdBlockCipherBlockSizeDefault;
  SetLength(FIncoming, 0);
End;//Create

procedure TIdBlockCipherIntercept.Encrypt(var VData : TIdBytes);
Begin
  if Assigned(FOnSend) then begin
    FOnSend(Self, VData);
  end;//ex: EncryptAES(LTempIn, ExpandedKey, LTempOut);
End;//Encrypt

procedure TIdBlockCipherIntercept.Decrypt(var VData : TIdBytes);
Begin
  if Assigned(FOnReceive) then begin
    FOnReceive(self, VData);
  end;//ex: DecryptAES(LTempIn, ExpandedKey, LTempOut);
End;//Decrypt

procedure TIdBlockCipherIntercept.Send(var VBuffer: TIdBytes);
var
  LSrc : TIdBytes;
  LTemp : TIdBytes;
  LCount : Integer;
Begin
  if Length(VBuffer) = 0 then
    exit;

  LSrc := VBuffer;
  SetLength(VBuffer, ((Length(LSrc) + FBlockSize - 2) div (FBlockSize - 1)) * FBLockSize);
  SetLength(LTemp, FBlockSize);

  for LCount := 0 to Length(LSrc) div (FBlockSize - 1) do
    begin
    CopyTIdBytes(LSrc, lCount * (FBlockSize - 1), LTemp, 0, FBlockSize - 1);
    LTemp[FBlockSize - 1] := FBlockSize - 1;
    Encrypt(LTemp);
    CopyTIdBytes(LTemp, 0, VBuffer, LCount * FBlockSize, FBLockSize);
    end;

  if Length(LSrc) Mod (FBlockSize - 1) > 0 then
    begin
    CopyTIdBytes(LSrc, length(LSrc) - (Length(LSrc) Mod (FBlockSize - 1)), LTemp, 0, Length(LSrc) Mod (FBlockSize - 1));
    LTemp[FBlockSize - 1] := Length(LSrc) Mod (FBlockSize - 1);
    Encrypt(LTemp);
    CopyTIdBytes(LTemp, 0, VBuffer, Length(VBuffer) - FBlockSize, FBLockSize);
    end;
End;//Send

procedure TIdBlockCipherIntercept.Receive(var VBuffer: TIdBytes);
var
  LCount : integer;
  LTemp : TIdBytes;
  LPos : Integer;
Begin
  LCount := Length(FIncoming);
  SetLength(FIncoming, Length(FIncoming) + Length(VBuffer));
  CopyTIdBytes(VBuffer, 0, FIncoming, LCount, length(VBuffer));
  SetLength(LTemp, FBlockSize);

  if Length(FIncoming) < FBlockSize then
    begin
    SetLength(VBuffer, 0)
    end
  else
    begin
    // the length of ABuffer when we have finished is currently unknown, but must be less than
    // the length of FIncoming. We will reserve this much, then reallocate at the end
    SetLength(VBuffer, Length(FIncoming));
    LPos := 0;

    for LCount := 0 to Length(FIncoming) div FBLockSize do
      begin
      CopyTIdBytes(FIncoming, LCount * FBlockSize, LTemp, 0, FBlockSize);
      Decrypt(LTemp);
      if (LTemp[FBlocksize-1] = 0) or (LTemp[FBlocksize-1] >= FBlockSize) then
        raise EIdBlockCipherInterceptException.Create(RSBlockIncorrectLength+' ('+inttostr(LTemp[FBlocksize-1])+')');
      CopyTIdBytes(LTemp, 0, VBuffer, LPos, LTemp[FBlocksize-1]);
      inc(LPos, LTemp[FBlocksize-1]);
      end;
    if Length(FIncoming) mod FBlockSize > 0 then
      begin
      CopyTIdBytes(FIncoming, Length(FIncoming) - (Length(FIncoming) mod FBlockSize), FIncoming, 0, Length(FIncoming) mod FBlockSize);
      SetLength(FIncoming, Length(FIncoming) mod FBlockSize);
      end
    else
      begin
      SetLength(FIncoming, 0);
      end;
    SetLength(VBuffer, LPos);
    end;
End;//Receive

procedure TIdBlockCipherIntercept.CopySettingsFrom(ASrcBlockCipherIntercept: TIdBlockCipherIntercept);
Begin
  SELF.FBlockSize := ASrcBlockCipherIntercept.FBlockSize;
  SELF.FData:= ASrcBlockCipherIntercept.FData; // not sure that this is actually safe
  SELF.FOnConnect := ASrcBlockCipherIntercept.FOnConnect;
  SELF.FOnDisconnect:= ASrcBlockCipherIntercept.FOnDisconnect;
  SELF.FOnReceive := ASrcBlockCipherIntercept.FOnReceive;
  SELF.FOnSend := ASrcBlockCipherIntercept.FOnSend;
End;//

procedure TIdBlockCipherIntercept.SetBlockSize(const Value: Integer);
Begin
  if (Value>0) and (Value<=IdBlockCipherBlockSizeMax) then begin
    FBlockSize := Value;
  end;
End;//

END.
