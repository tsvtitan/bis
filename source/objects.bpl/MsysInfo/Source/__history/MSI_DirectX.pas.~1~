
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               DirectX Detection Part                  }
{           version 5.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_DirectX;

interface

uses
  SysUtils, Windows, Classes;

type
  TDirectX = class(TPersistent)
  private
    FVersion: string;
    FDirect3D: TStrings;
    FDirectPlay: TStrings;
    FDirectMusic: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property Version :string read FVersion write FVersion stored false;
    property Direct3D :TStrings read FDirect3D write FDirect3D stored false;
    property DirectPlay :TStrings read FDirectPlay write FDirectPlay stored false;
    property DirectMusic :TStrings read FDirectMusic write FDirectMusic stored false;
  end;


implementation

uses
  Registry, MiTeC_Routines;

{ TDirectX }

constructor TDirectX.Create;
begin
  inherited;
  FDirect3D:=TStringlist.Create;
  FDirectPlay:=TStringlist.Create;
  FDirectMusic:=TStringlist.Create;
end;

destructor TDirectX.Destroy;
begin
  FDirect3D.Free;
  FDirectPlay.Free;
  FDirectMusic.Free;
  inherited;
end;

procedure TDirectX.GetInfo;
var
  bdata :pchar;
  sl :tstringlist;
  i :integer;
const
  rkDirectX = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectX';
    rvDXVersionNT = 'InstalledVersion';
    rvDXVersion95 = 'Version';
  rkDirect3D = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Direct3D\Drivers';
  rkDirectPlay = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectPlay\Services';
  rkDirectMusic = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectMusic\SoftwareSynths';
    rvDesc = 'Description';
begin
  try

  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKey(rkDirectX,false) then begin
      bdata:=stralloc(255);
      if ValueExists(rvDXVersion95) then
        FVersion:=ReadString(rvDXVersion95);
      if FVersion='' then
        if ValueExists(rvDXVersionNT) then
          try
            readbinarydata(rvDXVersionNT,bdata^,4);
            FVersion:=inttostr(lo(integer(bdata^)))+'.'+inttostr(hi(integer(bdata^)));
          except
            {$IFDEF D4PLUS}
            try
              readbinarydata(rvDXVersionNT,bdata^,8);
              FVersion:=inttostr(lo(integer(bdata^)))+'.'+inttostr(hi(integer(bdata^)));
            except
            end;
            {$ENDIF}
          end;
      closekey;
      strdispose(bdata);
    end;
    FDirect3D.Clear;
    FDirectPlay.Clear;
    FDirectMusic.Clear;
    sl:=tstringlist.create;
    if OpenKey(rkDirect3D,false) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if OpenKey(rkDirect3D+'\'+sl[i],false) then begin
          if ValueExists(rvDesc) then
            FDirect3D.Add(ReadString(rvDesc));
          closekey;
        end;
    end;
    if OpenKey(rkDirectPlay,false) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if OpenKey(rkDirectPlay+'\'+sl[i],false) then begin
          if ValueExists(rvDesc) then
            FDirectPlay.Add(ReadString(rvDesc));
          closekey;
        end;
    end;
    if OpenKey(rkDirectMusic,false) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if OpenKey(rkDirectMusic+'\'+sl[i],false) then begin
          if ValueExists(rvDesc) then
            FDirectMusic.Add(ReadString(rvDesc));
          closekey;
        end;
    end;
    sl.free;
    free;
  end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDirectX.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;


procedure TDirectX.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[DirectX]');
    if Version<>'' then begin
      Add(Format('Version=%s',[Version]));
      Add('[Direct3D]');
      StringsToRep(Direct3D,'Count','Device',sl);
      Add('[DirectPlay]');
      StringsToRep(DirectPlay,'Count','Device',sl);
      Add('[DirectMusic]');
      StringsToRep(DirectMusic,'Count','Device',sl);
    end;
  end;
end;


end.
