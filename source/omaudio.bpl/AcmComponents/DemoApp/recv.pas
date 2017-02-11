unit recv;

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
  Dialogs, StdCtrls, Sockets, Acm, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer,IDSocketHandle, IdGlobal, mmSystem;

type

  TRecvFrmACMFormatChooser=class(TACMFormatChooser)

  end;

  TRecvFrm = class(TForm)
    Label3: TLabel;
    HostLbl: TLabel;
    Label1: TLabel;
    BytesLbl: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FSock: TIdUDPServer;
    FChooser: TRecvFrmACMFormatChooser;
    FACMOut: TACMOut;
    Bytes:Cardinal;
    procedure SockUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ApplyFormat(Format: PWaveFormatEx; FormatSize: Integer): Boolean;


    property Sock: TIdUDPServer read FSock;
    property ACMOut: TACMOut read FACMOut;
  end;

var
  RecvFrm: TRecvFrm;

implementation

{$R *.dfm}

constructor TRecvFrm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChooser:=TRecvFrmACMFormatChooser.Create(Self);

  FACMOut:=TACMOut.Create(Self);
  FACMOut.Active:=false;
  FACMOut.AutoBufferSize:=true;
  FACMOut.BufferSize:=acm_DefBufSize;
  FACMOut.DeviceID:=0;
  FACMOut.HeadersNum:=3;
  FACMOut.WaveFormatChooser:=FChooser;

  FSock:=TIdUDPServer.Create(Self);
  FSock.OnUDPRead:=SockUDPRead;

  Bytes:=0;
end;

destructor TRecvFrm.Destroy;
begin
  FSock.Active:=False;
  FSock.Free;
  FACMOut.Active:=false;
  FACMOut.Free;
  FChooser.Free;
  inherited Destroy;
end;

procedure TRecvFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TRecvFrm.Button1Click(Sender: TObject);
begin
  Close;
end;

//procedure TRecvFrm.SockUDPRead(Sender: TObject; AData: TStream; ABinding: TIdSocketHandle);
procedure TRecvFrm.SockUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  Stream: TStringStream;
begin
  Stream:=TStringStream.Create(BytesToString(AData));
  try


    FACMOut.PlayBack(Stream);
    Bytes:=Bytes+Stream.Size;
    BytesLbl.Caption:=Format ('%u',[Bytes]);
    UpDate;
  finally
    Stream.Free;
  end;
end;

function TRecvFrm.ApplyFormat(Format: PWaveFormatEx; FormatSize: Integer): Boolean;
begin
  Result:=false;
  if Assigned(Format) and (FormatSize>0) then begin
    FChooser.UseFormat(Format,FormatSize);
    Result:=true;
  end;
end;


end.
