{******************************************************************************}
{*        Copyright 1999-2001 by J.Friebel all rights reserved.               *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 4 / 5 / 6                                 *}
{*        System          :  Windows NT / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  11.05.2002                                       *}
{*        Version         :  1.0                                              *}
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

unit TAPIPhoneSelectDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TAPIPDlg,StdCtrls,TAPIServices,TAPIDevices,
  TAPIPhone;

{$INCLUDE TAPI.INC}

type
  PPhoneDevItem = ^TPhoneDevItem;
  TPhoneDevItem = record
    DEVID: DWord;
    DevName: String;
    CbIndex:Integer;
  end;

type
  TDlgPhoneDeviceEvent=  procedure (Sender: TObject;var SelectedDev:TPhoneDevItem) of object;

type
  TTAPIPhoneSelectDialog = class(TComponent)
  private
    { Private-Deklarationen }
    FSelectDevice:TTAPIPhoneDevice;
    FOldPhoneDeviceID:DWord;
    SelectDialog:TPhoneSelectDlg;
    FOnDeviceChange: TDlgPhoneDeviceEvent;
    {$IFDEF TAPI20}
    FSelectPhoneFeatures: TPhoneFeatures;
    {$ENDIF}
    FPhone: TTAPIPhone;
    procedure SetSelectDevice(const Value: TTAPIPhoneDevice);
    function GetSelectDevice: TTAPIPhoneDevice;
    function GetService: TTAPIPhoneService;
  protected
    { Protected-Deklarationen }
    procedure GetPhones(cbLines:TComboBox);
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute:Boolean;
    procedure DeviceChange(Sender: TObject;var SelectedDev:TPhoneDevItem);
    property Service:TTAPIPhoneService read GetService;
    property SelectDevice:TTAPIPhoneDevice read GetSelectDevice write SetSelectDevice;
  published
    { Published-Deklarationen }
    property Phone: TTAPIPhone read FPhone write FPhone;
    {$IFDEF TAPI20}
    property SelectPhoneFeatures:TPhoneFeatures read FSelectPhoneFeatures write FSelectPhoneFeatures default [];
    {$ENDIF}
    property OnDeviceChange:TDlgPhoneDeviceEvent read FOnDeviceChange write FOnDeviceChange ;
  end;

procedure Register;

implementation

uses TAPI,TAPIErr;

procedure Register;
begin
{$IFDEF TAPI30}
  RegisterComponents('TAPI30', [TTAPIPhoneSelectDialog]);
{$ELSE}
{$IFDEF TAPI22}
  RegisterComponents('TAPI22', [TTAPIPhoneSelectDialog]);
{$ELSE}
{$IFDEF TAPI21}
  RegisterComponents('TAPI21', [TTAPIPhoneSelectDialog]);
{$ELSE}
{$IFDEF TAPI20}
  RegisterComponents('TAPI20', [TTAPIPhoneSelectDialog]);
{$ELSE}
  RegisterComponents('TAPI', [TTAPIPhoneSelectDialog]);
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;

{ TTAPIPhoneSelectDialog }

constructor TTAPIPhoneSelectDialog.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TTAPIPhoneSelectDialog.Destroy;
begin
  inherited Destroy;
end;

procedure TTAPIPhoneSelectDialog.DeviceChange(Sender: TObject;
  var SelectedDev: TPhoneDevItem);
begin
  SelectDevice.ID:=SelectedDev.DEVID;
  if Assigned(FOnDeviceChange) then FOnDeviceChange(Sender,SelectedDev);
end;

function TTAPIPhoneSelectDialog.Execute: Boolean;
var OldActive:Boolean;
    i:Integer;
    APhoneDevItem:PPhoneDevItem;
begin
  OldActive:= FPhone.Active;
  FOldPhoneDeviceID:=FPhone.Device.ID;
  If OldActive then FPhone.Active:=False;
  Result:=False;
  SelectDialog:=TPhoneSelectDlg.Create(self);
  try
    with SelectDialog do
    begin
      ComboBox1.Clear;
      GetPhones(ComboBox1);
      if ComboBox1.Items.Count = -1  then
      begin
      end
      else
      begin
        for i:=0 to SelectDialog.List.Count-1 do
        begin
          APhoneDevItem:=SelectDialog.List.Items[i];
          IF APhoneDevItem.DEVID=FOldPhoneDeviceID then
          begin
            SelectDevice.ID:=FOldPhoneDeviceID;
            ComboBox1.ItemIndex:=APhoneDevItem.CbIndex;
          end;
        end;
        Result:=(ShowModal=IDOK);
        if Result=False then
        begin
          //Änderung Rückgänig machen
          SelectDevice.ID:=FOldPhoneDeviceID;
        end;
      end;
    end;
  finally
    SelectDialog.Free;
  end;
  If OldActive then FPhone.Active:=True;
end;

procedure TTAPIPhoneSelectDialog.GetPhones(cbLines: TComboBox);
var i:Integer;
    PhoneName:String;
    APhoneDevItem:PPhoneDevItem;
begin
  if Service.Active=False then Service.Active:=True;
  for i:=0 to Service.NumDevice-1 do
  begin
    New(APhoneDevItem);
    try
      APhoneDevItem^.DEVID:=i;
      SelectDevice.ID:=i;
      PhoneName:=SelectDevice.Caps.Name;
      APhoneDevItem^.DevName:=PhoneName;
      {$IFDEF TAPI20}
      if (SelectPhoneFeatures <= SelectDevice.Caps.PhoneFeatures) then
      begin
        APhoneDevItem^.CbIndex:=CbLines.Items.Add(PhoneName);
        SelectDialog.List.Add(APhoneDevItem);
      end;
      {$ELSE}
      APhoneDevItem^.CbIndex:=CbLines.Items.Add(PhoneName);
      SelectDialog.List.Add(APhoneDevItem);
      {$ENDIF}
    except
      on EPhoneError do Dispose(APhoneDevItem);
    end;
  end;
end;

function TTAPIPhoneSelectDialog.GetSelectDevice: TTAPIPhoneDevice;
begin
  If Assigned(FSelectDevice)=False then
  begin
    FSelectDevice:=FPhone.Device;
  end;
  Result:= FSelectDevice;
end;

function TTAPIPhoneSelectDialog.GetService: TTAPIPhoneService;
begin
  Result:=TTAPIPhoneService(SelectDevice.Service);
end;

procedure TTAPIPhoneSelectDialog.SetSelectDevice(
  const Value: TTAPIPhoneDevice);
begin
  if FSelectDevice <> Value then
  FSelectDevice:=Value;
end;

end.
 