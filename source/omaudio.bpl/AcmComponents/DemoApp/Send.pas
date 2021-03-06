unit Send;

{******************************************************************************
 *
 *  ACMComponents
 *
 *
 *  Copyright(C) 2004 Mattia Massimo dhalsimmax@tin.it
 *  This file is part of ACMCOMPONENTS
 *
 *  ACMCOMPONENTS are free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *****************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sockets, StdCtrls, Acm, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, IdGlobal, mmSystem, MSACM,
  WaveRecorders, WaveUtils, WaveACMDrivers;

type
  TSendFrmACMFormatChooser=class(TACMFormatChooser)

  end;

  TSendFrm = class(TForm)
    Label1: TLabel;
    BytesLbl: TLabel;
    Label3: TLabel;
    HostLbl: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FSock: TIdUdpClient;
    FACMIn: TACMIn;
    FChooser: TSendFrmACMFormatChooser;
    Bytes:Cardinal;
    FRecorder: TLiveAudioRecorder;
    procedure ACMIn1Data(Sender: TACMComponent; aDataPtr: Pointer;  aDataSize: Cardinal);
    procedure RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
    procedure RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: DWORD; var FreeIt: Boolean);
  public
    FFormat: PWaveFormatEx;
    FFormatSize: Integer;
    FDrivers: TWaveACMDrivers;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ApplyFormat(Format: PWaveFormatEx; FormatSize: Integer): Boolean;


    property Sock: TIdUdpClient read FSock;
  //  property ACMIn: TACMIn read FACMIn;
    property WaveFormat: PWaveFormatEx read FFormat;
    property Recorder: TLiveAudioRecorder read FRecorder; 
  end;

var
  SendFrm: TSendFrm;

implementation

{$R *.dfm}

{ TSendFrm }

constructor TSendFrm.Create(AOwner: TComponent);
var
  AFormat: TWaveACMDriverFormat;
  D: TBytes;
begin
  inherited Create(AOwner);

{  FChooser:=TSendFrmACMFormatChooser.Create(Self);

  FACMIn:=TACMIn.Create(Self);
  FACMIn.Active:=false;
  FACMIn.AutoBufferSize:=true;
  FACMIn.BufferSize:=acm_DefBufSize;
  FACMIn.DeviceID:=0;
  FACMIn.HeadersNum:=3;
  FACMIn.WaveFormatChooser:=FChooser;
  FACMIn.OnData:=ACMIn1Data;}

  SetLength(D,2);
  D[0]:=$40;
  D[1]:=$1;

  FDrivers:=TWaveACMDrivers.Create;

  AFormat:=FDrivers.FindFormat('Microsoft GSM 6.10','GSM 6.10',1,8000,0);
  if Assigned(AFormat) then begin
    GetMem(FFormat,AFormat.WaveFormatSize);
    Move(AFormat.WaveFormat^,FFormat^,AFormat.WaveFormatSize);
    FFormatSize:=AFormat.WaveFormatSize;
  end;

//  Move(Pointer(D)^,Pointer(Integer(FFormat)+SizeOf(FFormat^))^,2);



  FRecorder:=TLiveAudioRecorder.Create(nil);
  FRecorder.Active:=false;
  FRecorder.Async:=false;
  FRecorder.PCMFormat:=nonePCM;
  FRecorder.OnFormat:=RecorderFormat;
  FRecorder.OnData:=RecorderData;

  FSock:=TIdUdpClient.Create(Self);

  Bytes:=0;
end;

destructor TSendFrm.Destroy;
begin
  FSock.Active:=false;
  FSock.Free;

  Recorder.Free;
  
  if Assigned(FFormat) then begin
    FreeMem(FFormat,FFormatSize);
    FFormat:=nil;
  end;

  FDrivers.Free;
  
{  FACMIn.Active:=False;
  FACMIn.Free;

  FChooser.Free;}
  inherited Destroy;
end;

procedure TSendFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TSendFrm.RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: DWORD; var FreeIt: Boolean);
begin
  FSock.SendBuffer(FSock.Host,FSock.Port,RawToBytes(Buffer^,BufferSize));
  Bytes:=Bytes+BufferSize;
  BytesLbl.Caption:=Format('%u',[Bytes]);
  UpDate;
end;

procedure TSendFrm.RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
begin
  FreeIt:=false;
  if Assigned(FFormat) then
    pWaveFormat:=FFormat;
end;

procedure TSendFrm.ACMIn1Data(Sender: TACMComponent; aDataPtr: Pointer;
  aDataSize: Cardinal);
begin
{  FSock.SendBuffer(FSock.Host,FSock.Port,RawToBytes(aDataPtr^,aDataSize));
  Bytes:=Bytes+aDataSize;
  BytesLbl.Caption:=Format ('%u',[Bytes]);
  UpDate;}
end;

procedure TSendFrm.Button1Click(Sender: TObject);
begin
  Close;
end;

function TSendFrm.ApplyFormat(Format: PWaveFormatEx; FormatSize: Integer): Boolean;
begin
  Result:=false;
  if Assigned(Format) and (FormatSize>0) then begin
//    FChooser.UseFormat(Format,FormatSize);
   { if Assigned(FFormat) then begin
      FreeMem(FFormat,FFormatSize);
      FFormat:=nil;
    end;

    GetMem(FFormat,FormatSize);
    Move(Format^,FFormat^,FormatSize);
    FFormatSize:=FormatSize;  }

    Result:=true;
  end;
end;


end.
