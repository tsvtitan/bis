
{******************************************}
{                                          }
{             FastReport v4.0              }
{            Registration unit             }
{                                          }
{         Copyright (c) 1998-2007          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxRegDB;

{$I frx.inc}

interface


procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes, Forms, Controls,
{$IFNDEF Delphi6}
  DsgnIntf,
{$ELSE}
  DesignIntf, DesignEditors,
{$ENDIF}
  frxDBSet,
  frxCustomDB,
  frxCustomDBEditor,
  frxCustomDBRTTI,
  frxEditMD,
  frxEditQueryParams;


{-----------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents('FastReport 4.0', [TfrxDBDataset]);
end;

end.


//c6320e911414fd32c7660fd434e23c87