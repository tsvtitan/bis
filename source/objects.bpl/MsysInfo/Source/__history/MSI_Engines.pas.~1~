
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Engine Detection Part                   }
{           version 5.6 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Engines;

interface

uses
  SysUtils, Windows, Classes;

type
  TEngines = class(TPersistent)
  private
    FBDE: string;
    FODBC: string;
    FDAO: string;
    FADO: string;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property ODBC :string read FODBC write FODBC stored false;
    property BDE :string read FBDE write FBDE stored false;
    property DAO :string read FDAO write FDAO stored False;
    property ADO :string read FADO write FADO stored False;
  end;

implementation

uses Variants, Registry, MiTeC_Routines, COMObj;

{ TEngines }

procedure TEngines.GetInfo;
var
  s,s1 :string;
  OLEObj: OLEVariant;
const
  rkBDESettings = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Borland\Database Engine';
    rvBDEDLLPath = 'DLLPATH';
    fnBDEDLL = 'IDAPI32.DLL';
  rkODBCSettings = {HKEY_LOCAL_MACHINE\}'SOFTWARE\ODBC\ODBCINST.INI\ODBC Core\FileList';
    rvODBCCoreDLL = 'ODBC32.DLL';

  { OLE object table class string }
  daoEngine36 = 'DAO.DBEngine.36';
  daoEngine35 = 'DAO.DBEngine.35';
  daoEngine30 = 'DAO.DBEngine';

  adoEngine = 'adodb.connection';

  function GetOLEObject(CLSID: string): OLEVariant;
  begin
    try
      result:=GetActiveOLEObject(CLSID);
    except
      try
        result:=CreateOLEObject(CLSID);
      except
        result:=null;
      end;
    end;
  end;

begin
  try

  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKey(rkBDESettings,false) then begin
      if ValueExists(rvBDEDLLPath) then begin
        s:=ReadString(rvBDEDLLPath);
        FBDE:=readverinfo(s+'\'+fnBDEDLL,s1);
      end;
      closekey;
    end;
    if OpenKey(rkODBCSettings,false) then begin
      if ValueExists(rvODBCCoreDLL) then begin
        s:=ReadString(rvODBCCoreDLL);
        FODBC:=readverinfo(s,s1);
      end;
      closekey;
    end;
    free;
  end;

  OLEObj:=GetOLEObject(daoEngine36);
  if TVarData(OLEObj).VType<>varDispatch then
    OLEObj:=GetOLEObject(daoEngine35);
  if TVarData(OLEObj).VType<>varDispatch then
    OLEObj:=GetOLEObject(daoEngine30);
  if TVarData(OLEObj).VType=varDispatch then
    FDAO:=OLEObj.Version;
  OLEObj:=null;

  OLEObj:=GetOLEObject(adoEngine);
  if TVarData(OLEObj).VType=varDispatch then
    FADO:=OLEObj.Version;
  OLEObj:=null;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TEngines.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TEngines.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[ODBC]');
    if ODBC<>'' then
      Add(Format('Version=%s',[ODBC]));
    Add('[BDE]');
    if BDE<>'' then
      Add(Format('Version=%s',[BDE]));
    Add('[DAO]');
    if DAO<>'' then
      Add(Format('Version=%s',[DAO]));
    Add('[ADO]');
    if ADO<>'' then
      Add(Format('Version=%s',[ADO]));
  end;
end;


end.
