{******************************************************************************}
{*        Copyright 1999-2001 by J.Friebel all rights reserved.               *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 4 / 5                                     *}
{*        System          :  Windows NT / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  7.05.2002                                        *}
{*        Version         :  1.3                                              *}
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

unit TAPILineSelectDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TAPIDlg,TAPIAddress,StdCtrls,TAPIServices,TAPIDevices,TAPICall;

{$INCLUDE TAPI.INC}

type
  PLineDevItem = ^TLineDevItem;
  TLineDevItem = record
    DEVID: Word;
    DevName: String;
    NumAddr:DWORD;
    CbIndex:Integer;
  end;

type
  TDlgDeviceEvent=  procedure (Sender: TObject;var SelectedDev:TLineDevItem)of Object;
  TDlgAddressEvent= procedure (Sender: TObject;var SelectedDev:TLineDevItem)of Object;

type
  TTAPILineSelectDialog = class(TComponent)
  private
    { Private-Deklarationen }
    FSelectLineFeatures:TLineFeatures;
    FMediaMode:LongInt;
    FSelectDevice:TTAPILineDevice;
    FOldDeviceID:DWord;
    FOldAddressID:DWord;
    FOnDeviceChange:TDlgDeviceEvent;
    FOnAddressChange:TDlgAddressEvent;
    SelectDialog:TLineSelectDlg;
    FAddress: TTAPIAddress;
    procedure SetSelectMediaMode(const Value: TLineMediaModes);
    function GetMediaModes: TLineMediaModes;
    procedure SetSelectDevice(const Value: TTAPILineDevice);
    function GetSelectDevice: TTAPILineDevice;
    function GetService: TTAPILineService;
  protected
    { Protected-Deklarationen }
    procedure GetLines(cbLines:TComboBox);
    procedure GetAddresses(cbAddress:TComboBox);
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute:Boolean;
    procedure DeviceChange(Sender: TObject;var SelectedDev:TLineDevItem);
    procedure AddressChange(Sender: TObject;var SelectedDev:TLineDevItem);
    property SelectDevice:TTAPILineDevice read GetSelectDevice write SetSelectDevice;
    property Service:TTAPILineService read GetService;
  published
    { Published-Deklarationen }
    property Address:TTAPIAddress read FAddress write FAddress;
    property SelectMediaMode:TLineMediaModes read GetMediaModes write SetSelectMediaMode default [mmInteractiveVoice];
    property SelectLineFeatures:TLineFeatures read FSelectLineFeatures write FSelectLineFeatures default [lfMakeCall];
    property OnDeviceChange:TDlgDeviceEvent read FOnDeviceChange write FOnDeviceChange ;
    property OnAddressChange:TDlgAddressEvent read FOnAddressChange write FOnAddressChange;
  end;

type
  TTAPITranslateDialog = class(TComponent)
  private
     FAddress:TTAPIAddress;
     FCanonicalAddress:String;
  public
    function Execute:Boolean;
  published
    property Address:TTAPIAddress read FAddress write FAddress;
    property CanonicalAddress:String read FCanonicalAddress write FCanonicalAddress;
  end;



procedure Register;

implementation

uses TAPI,TAPIErr;

procedure Register;
begin
{$IFDEF TAPI30}
  RegisterComponents('TAPI30', [TTAPILineSelectDialog]);
  RegisterComponents('TAPI30', [TTAPITranslateDialog]);
{$ELSE}
{$IFDEF TAPI22}
  RegisterComponents('TAPI22', [TTAPILineSelectDialog]);
  RegisterComponents('TAPI22', [TTAPITranslateDialog]);
{$ELSE}
{$IFDEF TAPI21}
  RegisterComponents('TAPI21', [TTAPILineSelectDialog]);
  RegisterComponents('TAPI21', [TTAPITranslateDialog]);
{$ELSE}
{$IFDEF TAPI20}
  RegisterComponents('TAPI20', [TTAPILineSelectDialog]);
  RegisterComponents('TAPI20', [TTAPITranslateDialog]);
{$ELSE}
  RegisterComponents('TAPI', [TTAPILineSelectDialog]);
  RegisterComponents('TAPI', [TTAPITranslateDialog]);
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;


{ TTAPILineSelectDialog }

procedure TTAPILineSelectDialog.AddressChange(Sender: TObject;var SelectedDev:TLineDevItem);
begin
  FAddress.ID:=(Sender as TComboBox).ItemIndex;
  if Assigned(FOnAddressChange) then FOnAddressChange(Self,SelectedDev);
end;

constructor TTAPILineSelectDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SelectMediaMode:=[mmInteractiveVoice];
  FSelectLineFeatures:=[lfMakeCall];
end;

destructor TTAPILineSelectDialog.Destroy;
begin
  inherited Destroy;
end;

procedure TTAPILineSelectDialog.DeviceChange(Sender: TObject;
  var SelectedDev: TLineDevItem);
begin
  SelectDevice.ID:=SelectedDev.DEVID;
  GetAddresses(SelectDialog.ComboBox2);
  if Assigned(FOnDeviceChange) then FOnDeviceChange(Self,SelectedDev);
end;

function TTAPILineSelectDialog.Execute: Boolean;
var OldActive:Boolean;
    i:Integer;
    ALineDevItem:PLineDevItem;
begin
  OldActive:= FAddress.Line.Active;
  FOldDeviceID:=SelectDevice.ID;
  FOldAddressID:=FAddress.ID;
  If OldActive then FAddress.Line.Active:=False;
  Result:=False;
  SelectDialog:=TLineSelectDlg.Create(self);
  try
    with SelectDialog do
    begin
      ComboBox1.Clear;
      ComboBox2.Clear;
      GetLines(ComboBox1);
      if ComboBox1.Items.Count = -1  then
      begin
      end
      else
      begin
        for i:=0 to SelectDialog.List.Count-1 do
        begin
          ALineDevItem:=SelectDialog.List.Items[i];
          IF ALineDevItem.DEVID=FOldDeviceID then
          begin
            SelectDevice.ID:=FOldDeviceID;
            ComboBox1.ItemIndex:=ALineDevItem.CbIndex;
          end;
        end;

        GetAddresses(ComboBox2);
        ComboBox2.ItemIndex:=FAddress.ID;
        Result:=(ShowModal=IDOK);
        if Result=False then
        begin
          //Änderung Rückgänig machen
          SelectDevice.ID:=FOldDeviceID;
          FAddress.ID:=FOldAddressID;
        end;
      end;
    end;
  finally
    SelectDialog.Free;
  end;
  If OldActive then FAddress.Line.Active:=True;
end;



procedure TTAPILineSelectDialog.GetAddresses(cbAddress: TComboBox);
var i,ii:Integer;
    ACaps:TAddresscaps;
begin
  cbAddress.Clear;
  try
    ii:=0;
    while PLineDevItem(SelectDialog.List.Items[ii])^.DEVID<>SelectDevice.ID do
    Inc(II);
    for i:=0 to PLineDevItem(SelectDialog.List.Items[ii])^.NumAddr-1 do
    begin
      ACaps:=TAddressCaps.Create(Service.Handle,PLineDevItem(SelectDialog.List.Items[ii])^.DEVID,i,SelectDevice.APIVersion,0);
      if ACaps.Address='' then
      cbAddress.Items.Add('Adresse '+IntToStr(i))
      else cbAddress.Items.Add(ACaps.Address);
      ACaps.Free;
    end;
  except On EListError do
  end;
end;

procedure TTAPILineSelectDialog.GetLines(cbLines: TComboBox);
var i:Integer;
    LineName:String;
    ALineDevItem:PLineDevItem;
begin
  if Service.Active=False then Service.Active:=True;
  for i:=0 to Service.NumDevice-1 do
  begin
    New(ALineDevItem);
    try
      ALineDevItem^.DEVID:=i;
      SelectDevice.ID:=i;
      LineName:=SelectDevice.Caps.Name;
      ALineDevItem^.DevName:=LineName;
      ALineDevItem^.NumAddr:=SelectDevice.Caps.NumAddresses;
      if (SelectMediaMode <= SelectDevice.Caps.MediaModes) then
      begin
        if (SelectLineFeatures <= SelectDevice.Caps.LineFeatures) then
        begin
          ALineDevItem^.CbIndex:=CbLines.Items.Add(LineName);
          SelectDialog.List.Add(ALineDevItem);
        end;
      end;
    except
      on ELineError do Dispose(ALineDevItem);
    end;
  end;
end;



function TTAPILineSelectDialog.GetMediaModes: TLineMediaModes;
begin
  Result:=IntToMediaModes(FMediaMode);
  IF FMediaMode=0 then Result:=[mmUnknown];
end;

procedure TTAPILineSelectDialog.SetSelectDevice(
  const Value: TTAPILineDevice);
begin
  FSelectDevice:=Value;
end;

function TTAPILineSelectDialog.GetSelectDevice: TTAPILineDevice;
begin
  If Assigned(FSelectDevice)=False Then FSelectDevice:=FAddress.Line.Device;
  Result:= FSelectDevice;
end;

procedure TTAPILineSelectDialog.SetSelectMediaMode(
  const Value: TLineMediaModes);
begin
  FMediaMode:=MediaModesToInt(Value);
end;

function TTAPILineSelectDialog.GetService: TTAPILineService;
begin
  Result:=TTAPILineService(SelectDevice.Service);
end;


{ TTAPITranslateDialog }

function TTAPITranslateDialog.Execute:Boolean;
var R:Longint;
    AStr:LPCSTR;
begin
  Result:=True;
  with FAddress.Line do
  Begin
    AStr:=AllocMem(1000);
    StrCopy(AStr,Pchar(FCanonicalAddress+#0));
    R:=LineTranslateDialog(FAddress.Line.Device.Service.Handle,FAddress.Line.Device.ID,FAddress.Line.Device.APIVersion,TForm(Owner).Handle,AStr);
    FreeMem(AStr);
    if DWord(R)>DWord($80000000) then
    begin
      RaiseTAPILineError(R);
    end;
  end;
end;

end.
