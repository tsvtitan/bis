unit RecvDialog;

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
  Dialogs, StdCtrls, mmSystem;

type
  TRecvDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    PortEdit: TEdit;
    ListBoxDrivers: TListBox;
    Label2: TLabel;
    ListBoxFormats: TListBox;
    Label3: TLabel;
    MemoDetails: TMemo;
    Label4: TLabel;
    ComboBoxDevices: TComboBox;
    Label5: TLabel;
    procedure ListBoxDriversClick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetWaveFormatEx: PWaveFormatEx;
    function GetWaveFormatSize: Integer;
    function GetDeviceID: HWaveOut;
  end;

var
  RecvDlg: TRecvDlg;

implementation

uses MSACM, Acm;

{$R *.dfm}

procedure FreeAndNilEx(var Obj);
var
  Temp: TObject;
begin
  if Pointer(Obj)<>nil then begin
    Temp:=TObject(Obj);
    try
      Temp.Free;
    except
    end;
    Pointer(Obj):=nil;
  end;
end;

procedure ClearStrings(Strings: TStrings);
var
  i: Integer;
  Obj: TObject;
begin
  if Assigned(Strings) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to Strings.Count-1 do begin
        Obj:=Strings.Objects[i];
        if Assigned(Obj) then
          FreeAndNilEx(Obj);
      end;
      Strings.Clear;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

type

  TAcmDriver=class(TObject)
  private
    FHandle: HACMDRIVERID;
    FCodec: Boolean;
    FConverter: Boolean;
    FFilter: Boolean;
    FHardware: Boolean;
    FAsync: Boolean;
    FLocal: Boolean;
    FDisabled: Boolean;

    FStruct: DWORD;
		FType: FOURCC;             // compressor type 'audc'
		FComp: FOURCC;             // sub-type (not used; reserved)
		FMid: WORD;               // manufacturer id
		FPid: WORD;               // product id
		FACM: DWORD;              // version of the ACM *compiled* for
		FDriver: DWORD;              // version of the driver
		FSupport: DWORD;              // misc. support flags
		FFormatTags: DWORD;              // total unique format tags supported
		FFilterTags: DWORD;              // total unique filter tags supported
		Ficon: HICON;              // handle to custom icon
		FShortName: String;
		FLongName: String;
		FCopyright: String;
		FLicensing: String;
		FFeatures: String;
  end;

  TAcmFormat=class(TObject)
  private
    FFormat: PWaveFormatEx;
    FSize: Integer;
  public
    constructor Create;
    destructor Destroy; override;

  end;

{ TAcmFormat }

constructor TAcmFormat.Create;
begin
  inherited Create;
  FFormat:=nil;
  FSize:=0;
end;

destructor TAcmFormat.Destroy;
begin
  if Assigned(FFormat) and (FSize>0) then begin
    FreeMem(FFormat,FSize);
    FFormat:=nil;
    FSize:=0;
  end;
  inherited Destroy;
end;

{ACMDRIVERDETAILS_SUPPORTF_CODEC - ��������, ��� ���� ������� ��������� � �������.
ACMDRIVERDETAILS_SUPPORTF_CONVERTER - ��������� �������������� ������.
ACMDRIVERDETAILS_SUPPORTF_FILTER - ������� ��� ���������� ������.
ACMDRIVERDETAILS_SUPPORTF_HARDWARE - ��� ���������� �������.
ACMDRIVERDETAILS_SUPPORTF_ASYNC - ������� ����� �������� � ����������� ������.
ACMDRIVERDETAILS_SUPPORTF_LOCAL - ��� ��������� �������.
ACMDRIVERDETAILS_SUPPORTF_DISABLED}

{ TSendDlg }

function EnumDriver(hadid : HACMDRIVERID; dwInstance : DWORD; fdwSupport : DWORD) : BOOL; stdcall;
var
  Form: TRecvDlg;
  S: String;
  Obj: TAcmDriver;
  padd: TACMDRIVERDETAILS;
begin
  Result:=false;
  Form:=TRecvDlg(dwInstance);
  if Assigned(Form) then begin

    Obj:=TAcmDriver.Create;
    Obj.FHandle:=hadid;
    Obj.FCodec:=(fdwSupport and ACMDRIVERDETAILS_SUPPORTF_CODEC)>0;
    Obj.FConverter:=(fdwSupport and ACMDRIVERDETAILS_SUPPORTF_CONVERTER)>0;
    Obj.FFilter:=(fdwSupport and ACMDRIVERDETAILS_SUPPORTF_FILTER)>0;
    Obj.FHardware:=(fdwSupport and ACMDRIVERDETAILS_SUPPORTF_HARDWARE)>0;
    Obj.FAsync:=(fdwSupport and ACMDRIVERDETAILS_SUPPORTF_ASYNC)>0;
    Obj.FLocal:=(fdwSupport and ACMDRIVERDETAILS_SUPPORTF_LOCAL)>0;
    Obj.FDisabled:=(fdwSupport and ACMDRIVERDETAILS_SUPPORTF_DISABLED)>0;

    FillChar(padd,SizeOf(padd),0);
    padd.cbStruct:=SizeOf(padd);

    if acmDriverDetails(hadid,padd,0)=MMSYSERR_NOERROR then begin

      Obj.FStruct:=padd.cbStruct;
		  Obj.FType:=padd.fccType;
		  Obj.FComp:=padd.fccComp;
		  Obj.FMid:=padd.wMid;
		  Obj.FPid:=padd.wPid;
		  Obj.FACM:=padd.vdwACM;
		  Obj.FDriver:=padd.vdwDriver;
		  Obj.FSupport:=padd.fdwSupport;
		  Obj.FFormatTags:=padd.cFormatTags;
		  Obj.FFilterTags:=padd.cFilterTags;
		  Obj.Ficon:=padd.hicon;
		  Obj.FShortName:=padd.szShortName;
		  Obj.FLongName:=padd.szLongName;
		  Obj.FCopyright:=padd.szCopyright;
		  Obj.FLicensing:=padd.szLicensing;
		  Obj.FFeatures:=padd.szFeatures;

    end;


    S:=Format('Handle=%d ShortName=%s',
              [Obj.FHandle,Obj.FShortName]);

    Form.ListBoxDrivers.AddItem(S,Obj);
    Result:=true;
  end;
end;


constructor TRecvDlg.Create(AOwner: TComponent);
{var
  Num: Integer;
  i: Integer;
  WaveCaps: TWaveOutCaps;} 
begin
  inherited Create(AOwner);

  acmDriverEnum(EnumDriver,DWord(Self),ACM_DRIVERENUMF_NOLOCAL or ACM_DRIVERENUMF_DISABLED);


 { Num:=waveOutGetNumDevs;
  for i:=0 to Num-1 do begin
    WaveInGetDevCaps(i,@WaveCaps,sizeof(WaveCaps));
    ComboBoxDevices.Items.Add(WaveCaps.szPName);
  end;}

end;

destructor TRecvDlg.Destroy;
begin
  ClearStrings(ListBoxFormats.Items);
  ClearStrings(ListBoxDrivers.Items);

  inherited Destroy;
end;

type
  TEnumFormatInfo=packed record
    Form: TRecvDlg;
    FormatTagDetails: TACMFORMATTAGDETAILS;
  end;
  PEnumFormatInfo=^TEnumFormatInfo;

function EnumFormat(hadid : HACMDRIVERID; const pafd : TACMFORMATDETAILS; dwInstance : DWORD; fdwSupport : DWORD) : BOOL; stdcall;
var
  Info: PEnumFormatInfo;
  S: String;
  Obj: TAcmFormat;
begin
  Result:=false;
  Info:=PEnumFormatInfo(dwInstance);
  if Assigned(Info) then begin
    with Info.Form.ListBoxFormats do begin
      S:=Format('Index=%d Tag=%d TagName=%s Support=%d Size=%d Format=%s',
                [pafd.dwFormatIndex,pafd.dwFormatTag,Info.FormatTagDetails.szFormatTag,pafd.fdwSupport,
                 SizeOf(pafd.pwfx^)+pafd.pwfx.cbSize,pafd.szFormat]);

      Obj:=TAcmFormat.Create;
      Obj.FSize:=SizeOf(pafd.pwfx^)+pafd.pwfx.cbSize;
      GetMem(Obj.FFormat,Obj.FSize);
      CopyMemory(Obj.FFormat,pafd.pwfx,Obj.FSize);

      AddItem(S,Obj);
      Result:=true;
    end;
  end;
end;

procedure TRecvDlg.ListBoxDriversClick(Sender: TObject);
var
  Index: Integer;
  Obj: TAcmDriver;
  pafd: TACMFORMATDETAILS;
  paftd : TACMFORMATTAGDETAILS;
  phad: HACMDRIVER;
  Ret: MMRESULT;
  wfx: TWaveFormatEx;
  EFI: TEnumFormatInfo;
  i: Integer;
begin
  MemoDetails.Clear;
  Index:=ListBoxDrivers.ItemIndex;
  if Index<>-1 then begin
    Obj:=TAcmDriver(ListBoxDrivers.Items.Objects[Index]);
    if Assigned(Obj) then begin
      with MemoDetails.Lines do begin
        Add(Format('Codec=%d',[Integer(Obj.FCodec)]));
        Add(Format('Converter=%d',[Integer(Obj.FConverter)]));
        Add(Format('Filter=%d',[Integer(Obj.FFilter)]));
        Add(Format('Hardware=%d',[Integer(Obj.FHardware)]));
        Add(Format('Async=%d',[Integer(Obj.FAsync)]));
        Add(Format('Local=%d',[Integer(Obj.FLocal)]));
        Add(Format('Disabled=%d',[Integer(Obj.FDisabled)]));
        Add(Format('Struct=%d',[Obj.FStruct]));
        Add(Format('Type=%d',[Obj.FType]));
        Add(Format('Comp=%d',[Obj.FComp]));
        Add(Format('Mid=%d',[Obj.FMid]));
        Add(Format('Pid=%d',[Obj.FPid]));
        Add(Format('ACM=%d',[Obj.FACM]));
        Add(Format('Driver=%d',[Obj.FDriver]));
        Add(Format('Support=%d',[Obj.FSupport]));
        Add(Format('FormatTags=%d',[Obj.FFormatTags]));
        Add(Format('FilterTags=%d',[Obj.FFilterTags]));
        Add(Format('icon=%d',[Obj.Ficon]));
        Add(Format('LongName=%s',[Obj.FLongName]));
        Add(Format('Copyright=%s',[Obj.FCopyright]));
        Add(Format('Licensing=%s',[Obj.FLicensing]));
        Add(Format('Features=%s',[Obj.FFeatures]));
      end;

      ClearStrings(ListBoxFormats.Items);
      Ret:=acmDriverOpen(phad,Obj.FHandle,0);
      if Ret=MMSYSERR_NOERROR then begin
        ListBoxFormats.Items.BeginUpdate;
        try
          for i:=0 to Obj.FFormatTags-1 do begin

            FillChar(paftd,SizeOf(paftd),0);
            paftd.cbStruct:=Sizeof(paftd);
            paftd.dwFormatTagIndex:=i;

            Ret:=acmFormatTagDetails(phad,paftd,ACM_FORMATTAGDETAILSF_INDEX);
            if Ret<>MMSYSERR_NOERROR then begin
              ListBoxFormats.Items.Add(SysErrorMessage(GetLastError));
            end else begin

              FillChar(pafd,SizeOf(pafd),0);
              pafd.cbStruct:=SizeOf(pafd);
              pafd.dwFormatTag:=paftd.dwFormatTag;

              FillChar(wfx,SizeOf(wfx),0);
              wfx.cbSize:=SizeOf(wfx);
              wfx.nChannels:=1;
              wfx.wFormatTag:=pafd.dwFormatTag;

              pafd.pwfx:=@wfx;

              acmMetrics(0,ACM_METRIC_MAX_SIZE_FORMAT,pafd.cbwfx);

              EFI.Form:=Self;
              EFI.FormatTagDetails:=paftd;

    //          Ret:=acmFormatEnum(phad,pafd,EnumFormat,Dword(Self),ACM_FORMATENUMF_SUGGEST);
              Ret:=acmFormatEnum(phad,pafd,EnumFormat,Dword(@EFI),ACM_FORMATENUMF_OUTPUT or ACM_FORMATENUMF_NCHANNELS or ACM_FORMATENUMF_WFORMATTAG);
              if Ret<>MMSYSERR_NOERROR then begin
                ListBoxFormats.Items.Add(SysErrorMessage(GetLastError));
              end;
            end;
          end;
        finally
          ListBoxFormats.Items.EndUpdate;
          acmDriverClose(phad,0);
        end;
      end;

    end;
  end;
end;

function TRecvDlg.GetDeviceID: HWaveOut;
var
  Index: Integer;
begin
//  Result:=Integer(WAVE_MAPPER);
  Result:=0;
  Index:=ComboBoxDevices.ItemIndex;
  if Index<>-1 then begin
    Result:=Index;
  end;
end;

function TRecvDlg.GetWaveFormatEx: PWaveFormatEx;
var
  Index: Integer;
  Obj: TAcmFormat;
begin
  Result:=nil;
  Index:=ListBoxFormats.ItemIndex;
  if Index<>-1 then begin
    Obj:=TAcmFormat(ListBoxFormats.Items.Objects[Index]);
    if Assigned(Obj) then
      Result:=Obj.FFormat;
  end;
end;

function TRecvDlg.GetWaveFormatSize: Integer;
var
  Index: Integer;
  Obj: TAcmFormat;
begin
  Result:=0;
  Index:=ListBoxFormats.ItemIndex;
  if Index<>-1 then begin
    Obj:=TAcmFormat(ListBoxFormats.Items.Objects[Index]);
    if Assigned(Obj) then
      Result:=Obj.FSize;
  end;
end;

(*function TRecvDlg.GetWaveFormatEx: PWaveFormatEx;
var
  Dlg: TACMDlg;
  Ret: MMRESULT;
begin
  Result:=nil;
  Dlg:=TACMDlg.Create(nil);
  try
    if Dlg.Execute then begin
      FillChar(Fwfx,SizeOf(Fwfx),0);
      Fwfx.cbSize:=Dlg.WaveFormatEx.cbSize;
      Fwfx.wFormatTag:=Dlg.WaveFormatEx.wFormatTag;
      Fwfx.nChannels:=Dlg.WaveFormatEx.nChannels;
      Fwfx.nSamplesPerSec:=Dlg.WaveFormatEx.nSamplesPerSec;
      Fwfx.nAvgBytesPerSec:=Dlg.WaveFormatEx.nAvgBytesPerSec;
      Fwfx.nBlockAlign:=Dlg.WaveFormatEx.nBlockAlign;
      Fwfx.wBitsPerSample:=Dlg.WaveFormatEx.wBitsPerSample;
{      Ret:=WaveInOpen(nil,GetDeviceID,@Fwfx,0,0,WAVE_FORMAT_DIRECT or WAVE_FORMAT_QUERY);
      if Ret=MMSYSERR_NOERROR then}
        Result:=@Fwfx;
    end;
  finally
    Dlg.Free;
  end;
end;*)


end.
