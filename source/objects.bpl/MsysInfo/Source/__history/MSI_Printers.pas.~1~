
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Printer Detection Part                  }
{           version 5.6 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Printers;

interface

uses
  SysUtils, Windows, Classes;

type
  TPrinters = class(TPersistent)
  private
    FPrinter: TStrings;
    FDI: integer;
    FPort: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property DefaultIndex: integer read FDI write FDI;
    property Names :TStrings read FPrinter write FPrinter stored false;
    property Ports: TStrings read FPort Write FPort stored False;
  end;

implementation

uses Printers, MiTeC_Routines;

{ TPrinters }

constructor TPrinters.Create;
begin
  FPrinter:=TStringList.Create;
  FPort:=TStringList.Create;
end;

destructor TPrinters.Destroy;
begin
  FPrinter.Free;
  FPort.Free;
  inherited;
end;

procedure TPrinters.GetInfo;
var
  i :integer;
  Device, Driver, Port: PChar;
  Mode: THandle;
begin
  try
    Device:=AllocMem(CCHDEVICENAME);
    Driver:=AllocMem(MAX_PATH);
    Port:=AllocMem(MAX_PATH);
    FPrinter.Clear;
    FPort.Clear;
    for i:=0 to Printer.Printers.count-1 do begin
      Printer.PrinterIndex:=i;
      Printer.GetPrinter(Device,Driver,Port,Mode);
      FPrinter.Add(Device);
      FPort.Add(Port);
    end;
    if Printer.Printers.count>0 then begin
      Printer.PrinterIndex:=-1;
      Printer.GetPrinter(Device,Driver,Port,Mode);
      FDI:=FPrinter.IndexOf(Device);
    end;

    FreeMem(Device);
    FreeMem(Port);
    FreeMem(Driver);

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TPrinters.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TPrinters.Report(var sl: TStringList);
var
  i: integer;
begin
  with sl do begin
    Add('[Printers]');
    Add(Format('Count=%d',[Self.Names.Count]));
    for i:=0 to Self.Names.Count-1 do
      Add(Format('%s on %s=%d',[Self.Names[i],Self.Ports[i],integer(DefaultIndex=i)]));
  end;
end;

end.
