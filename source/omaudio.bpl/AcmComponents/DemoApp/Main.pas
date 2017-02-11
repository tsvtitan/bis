unit Main;

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
  Dialogs, Acm, StdCtrls, Sockets, Buttons, XPMan;

type
  TMainFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    XPManifest1: TXPManifest;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation

uses SendDialog, Send, RecvDialog, recv;

{$R *.dfm}

procedure TMainFrm.Button3Click(Sender: TObject);

begin
  Application.Terminate;
end;

procedure TMainFrm.Button1Click(Sender: TObject);
begin
  SendDlg:=TSendDlg.Create (Application);
  If SendDlg.ShowModal = mrOk
    Then
      Begin
        SendFrm:=TSendFrm.Create (Application);
        If  SendFrm.ApplyFormat(SendDlg.GetWaveFormatEx,SendDlg.GetWaveFormatSize)
          Then
            Begin
              SendFrm.Sock.Active:=False;
//              SendFrm.Sock.BufferSize:=SendFrm.ACMIn.WaveFormatChooser.nAvgBytesPerSec*2;
              SendFrm.Sock.BufferSize:=SendFrm.WaveFormat.nAvgBytesPerSec*2;
              SendFrm.Sock.Host:= SendDlg.HostEdit.Text;
              SendFrm.Sock.Port:= StrToInt(SendDlg.PortEdit.Text);
              SendFrm.Sock.Active:=True;
              SendFrm.HostLbl.Caption:= SendDlg.HostEdit.Text+':'+SendDlg.PortEdit.Text;
              SendFrm.Recorder.DeviceID:=SendDlg.GetDeviceID;
              SendFrm.Recorder.Active:=True;
//              SendFrm.ACMIn.DeviceID:=SendDlg.GetDeviceID;
//              SendFrm.ACMIn.Active:=True;
              SendFrm.Show;
            End
          Else
            SendFrm.Free;
      End;
  SendDlg.Free;
end;

procedure TMainFrm.Button2Click(Sender: TObject);
begin
  RecvDlg:=TRecvDlg.Create (Application);
  If RecvDlg.ShowModal = mrOk
    Then
      Begin
        RecvFrm:=TRecvFrm.Create (Application);
        If RecvFrm.ApplyFormat(RecvDlg.GetWaveFormatEx,RecvDlg.GetWaveFormatSize)
          Then
            Begin
              RecvFrm.Sock.Active:=False;
              RecvFrm.Sock.BufferSize:=RecvFrm.ACMOut.WaveFormatChooser.nAvgBytesPerSec*2;
              RecvFrm.ACMOut.DeviceID:=RecvDlg.GetDeviceID;
              RecvFrm.ACMOut.Active:=True;
              RecvFrm.Sock.DefaultPort:= StrToint(RecvDlg.PortEdit.Text);
              RecvFrm.Sock.Active:=True;
              RecvFrm.HostLbl.Caption:= RecvDlg.PortEdit.Text;
              RecvFrm.Show;
            End
          Else
            RecvFrm.Free;
      End;
  RecvDlg.Free;
end;

end.
