{******************************************************************************}
{*        Copyright 1999-2001 by J.Friebel all rights reserved.               *}
{*        Autor           :  J�rg Friebel                                     *}
{*        Compiler        :  Delphi 4 / 5                                     *}
{*        System          :  Windows NT / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  17.02.2001                                       *}
{*        Version         :  1.1                                              *}
{*        EMail           :  tapi@delphiclub.de                               *}
{******************************************************************************}
{*                                                                            *}
{*    This File is free software; You can redistribute it and/or modify it    *}
{*    under the term of GNU Library General Public License as published by    *}
{*    the Free Software Foundation. This File is distribute in the hope       *}
{*    it will be useful "as is", but WITHOUT ANY WARRANTY OF ANY KIND;        *}
{*    See the GNU Library Public Licence for more details.                    *}
{*                                                                            *}
{******************************************************************************}
{*                                                                            *}
{*    Diese Datei ist Freie-Software. Sie k�nnen sie weitervertreiben         *}
{*    und/oder ver�ndern im Sinne der Bestimmungen der "GNU Library GPL"      *}
{*    der Free Software Foundation. Diese Datei wird,"wie sie ist",           *}
{*    zur Verf�gung gestellt, ohne irgendeine GEW�HRLEISTUNG                  *}
{*                                                                            *}
{******************************************************************************}
{*                          www.delphiclub.de                                 *}
{******************************************************************************}
unit TAPIThread;

interface

uses
  Classes,SyncObjs,Windows,TAPI;

{$INCLUDE TAPI.INC}

{$IFDEF TAPI20 }
type
  TTAPIThread = class(TThread)
  private
    FEvent:THandle;
    FAppH:HLineApp;
    FMessage:Pointer;
    FTimeOut:DWord;
  protected
    procedure Execute; override;
    procedure NotCallBack;virtual;
  public
    property TimeOut:DWord read FTimeOut write FTimeOut default 0;
    constructor Create(AppHandle:HLINEAPP;EventObj:THandle);virtual;
    destructor Destroy;override;
  end;

  TTAPIPhoneThread =class(TTAPIThread)
  protected
    procedure NotCallBack;override;
  public
    constructor Create(AppHandle:HLINEAPP;EventObj:THandle);override;
    destructor Destroy;override;
  end;
{$ENDIF}

implementation


uses SysUtils,TAPICallBack;

{ TAPIThread }

{$IFDEF TAPI20 }
constructor TTAPIThread.Create(AppHandle: HLINEAPP; EventObj: THandle);
begin
  inherited Create(False);
  FMessage:=AllocMem(SizeOf(TLineMessage));
  FAppH:=AppHandle;
  FEvent:=EventObj;
  FTimeOut:=0;
end;

destructor TTAPIThread.Destroy;
begin
  FreeMem(FMessage);
  inherited Destroy;
end;

procedure TTAPIThread.Execute;
begin
  while not Terminated do
  begin
    if WaitForSingleObject(FEvent,infinite)=WAIT_OBJECT_0 then
    begin
      Synchronize(NotCallBack);
    end;
  end;
end;

procedure TTAPIThread.NotCallBack;
begin
  if LineGetMessage(FAppH,PLINEMESSAGE(FMessage)^,FTimeOut)=0 then
  begin
    with PLineMessage(FMessage)^ do
      LineCallBack(hDevice,dwMessageID,dwCallbackInstance,dwParam1,dwParam2,dwParam3);
  end;
end;
{$ENDIF}

{ TTAPIPhoneThread }

{$IFDEF TAPI20 }
constructor TTAPIPhoneThread.Create(AppHandle: HLINEAPP;
  EventObj: THandle);
begin
  inherited Create(AppHandle,EventObj);
end;

destructor TTAPIPhoneThread.Destroy;
begin
  inherited Destroy;
end;

procedure TTAPIPhoneThread.NotCallBack;
begin
  if PhoneGetMessage(FAppH,PPhoneMessage(FMessage)^,FTimeOut)=0 then
  begin
    with PPhoneMessage(FMessage)^ do
      PhoneCallBack(hDevice,dwMessageID,dwCallbackInstance,dwParam1,dwParam2,dwParam3);
  end;
end;


{$ENDIF}
end.
