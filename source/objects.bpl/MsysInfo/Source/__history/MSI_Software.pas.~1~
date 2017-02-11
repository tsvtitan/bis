
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{         Installed Software Detection Part             }
{           version 5.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Software;

interface

uses
  SysUtils, Windows, Classes;

type
  TSoftware = class(TPersistent)
  private
    FProducts: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property Installed: TStrings read FProducts write FProducts stored false;
  end;

implementation

uses Registry, MiTeC_Routines;

{ TSoftware }

constructor TSoftware.Create;
begin
  FProducts:=TStringList.Create;
end;

destructor TSoftware.Destroy;
begin
  FProducts.Free;
  inherited;
end;

procedure TSoftware.GetInfo;
const
  rk = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  rv = 'DisplayName';
var
  i: integer;
  sl: TStringList;
begin
  try

  FProducts.Clear;
  with TRegistry.Create do
    try
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKey(rk,False) then begin
        sl:=TStringList.Create;
        GetKeyNames(sl);
        CloseKey;
        for i:=0 to sl.Count-1 do
          if OpenKey(rk+'\'+sl[i],False) then begin
            if ValueExists(rv) then
              FProducts.Add(ReadString(rv));
            CloseKey;
          end;
        sl.Free;
      end;
    finally
      Free;
    end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TSoftware.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TSoftware.Report(var sl: TStringList);
begin
  sl.Add('[Installed Software]');
  StringsToRep(Installed,'Count','Item',sl);
end;

end.
