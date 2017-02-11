{******************************************************************************}
{*        Copyright 1999-2001 by J.Friebel all rights reserved.               *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 4 / 5  / 6                                *}
{*        System          :  Windows NT / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  12.05.2002                                       *}
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
{*    Diese Datei ist Freie-Software. Sie können sie weitervertreiben         *}
{*    und/oder verändern im Sinne der Bestimmungen der "GNU Library GPL"      *}
{*    der Free Software Foundation. Diese Datei wird,"wie sie ist",           *}
{*    zur Verfügung gestellt, ohne irgendeine GEWÄHRLEISTUNG                  *}
{*                                                                            *}
{******************************************************************************}
{*                          www.delphiclub.de                                 *}
{******************************************************************************}
unit TAPIDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TAPILineConfigDlg;

{$INCLUDE TAPI.INC}

type
  TLineSelectDlg = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Button3: TButton;
    TAPILineConfigDlg1: TTAPILineConfigDlg;
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private-Deklarationen }
    FList:TList;
  public
    { Public-Deklarationen }
    property List:TList read FList write FList;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;

var
  LineSelectDlg: TLineSelectDlg;

implementation

{$R *.DFM}

uses TAPILineSelectDialog;

procedure TLineSelectDlg.ComboBox1Change(Sender: TObject);
var ND:TLineDevItem;
    ii:Integer;
begin
  If ComboBox1.ItemIndex=-1 then
  begin
    Button1.Enabled:=False;
    Button3.Enabled:=False;
  end
  else
  begin
    Button1.Enabled:=True;
    Button3.Enabled:=True;
  end;
  ii:=0;
  while ComboBox1.Text <>PLineDevItem(FList.Items[ii])^.DevName do
  Inc(ii);
  ND:=PLineDevItem(FList.Items[ii])^;
  ComboBox2.ItemIndex:=0;
  TTAPILineSelectDialog(Owner).AddressChange(ComboBox2,ND);
  TTAPILineSelectDialog(Owner).DeviceChange(ComboBox1,ND);
end;

constructor TLineSelectDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList:=Tlist.Create;
end;

destructor TLineSelectDlg.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TLineSelectDlg.Button1Click(Sender: TObject);
begin
  TAPILineConfigDlg1.Execute;
end;

procedure TLineSelectDlg.FormCreate(Sender: TObject);
begin
  Button3.Enabled:=False;
  TAPILineConfigDlg1.Device:=TTAPILineSelectDialog(Owner).SelectDevice;
end;

procedure TLineSelectDlg.FormShow(Sender: TObject);
begin
  If ComboBox1.ItemIndex=-1 then Button1.Enabled:=False;
end;

procedure TLineSelectDlg.ComboBox2Change(Sender: TObject);
var ND: TLineDevItem;
    i:Integer;
begin
  If ComboBox2.ItemIndex=-1 then
  begin
    Button1.Enabled:=False;
    Button3.Enabled:=False;
  end
  else
  begin
    Button1.Enabled:=True;
    Button3.Enabled:=True;
  end;
  I:=0;
  while ComboBox1.Text <>PLineDevItem(FList.Items[i])^.DevName do
  Inc(i);
  ND:=PLineDevItem(FList.Items[i])^;
  TTAPILineSelectDialog(Owner).AddressChange(ComboBox2,ND);
end;

end.
