{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXTableStoragePlatform;
interface
uses
  DBXTableStorage,
{$IFDEF CLR}
  DataTableStorage;
{$ELSE}
  DBXClientDataSetStorage;
{$ENDIF}
type
{$IFDEF CLR}
  TDBXTableStoragePlatform = TDataTableStorage;
{$ELSE}
  TDBXTableStoragePlatform = TDBXClientDataSetStorage;
{$ENDIF}

implementation

end.
