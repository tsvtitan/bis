unit BisSystemInfo;

interface

uses Classes, Contnrs,
     BisCmdLine, BisCoreObjects;

type

  TBisSystemInfoType=(siCPU,siMemory,siOS,siDisk,siMachine,siNetwork,siDisplay,
                      siEngines,siDevices,siAPM,siDirectX,siMedia,siProcesses,
                      siModules,siPrinters,siSoftware,siStartup);
  TBisSystemInfoTypes=set of TBisSystemInfoType;

  TBisSystemInfo=class(TBisCoreObject)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Report(Strings: TStringList; Types: TBisSystemInfoTypes=[siCPU..siStartup]);
  end;

implementation

uses SysUtils, Windows, TypInfo, StrUtils,

     MSI_CPU, MSI_Memory, MSI_OS, MSI_Disk, MSI_Machine, MSI_Network, MSI_Display,
     MSI_Engines, MSI_Devices, MSI_APM, MSI_DirectX, MSI_Media, MSI_Processes,
     MSI_Printers, MSI_Software, MSI_Startup,

     BisModuleInfo;

{ TBisSystemInfo }

constructor TBisSystemInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisSystemInfo.Destroy;
begin
  inherited Destroy;
end;

procedure TBisSystemInfo.Report(Strings: TStringList; Types: TBisSystemInfoTypes=[siCPU..siStartup]);

  procedure AddDelim(T: TBisSystemInfoType);
  var
    S: String;
    P: PTypeInfo;
  begin
    Strings.Add('');
    P:=PTypeInfo(TypeInfo(TBisSystemInfoType));
    if Assigned(P) then begin
      S:=GetEnumName(P,Integer(T));
      S:=Copy(S,3,Length(S));
      Strings.Add(Format('%s %s %s',[DupeString('=',20),S,DupeString('=',20)]));
    end;
  end;

var
  i: Integer;
  FCPU: TCPU;
  FMemory: TMemory;
  FOS: TOperatingSystem;
  FDisk: TDisk;
  FMachine: TMachine;
  FNetwork: TNetwork;
  FDisplay: TDisplay;
  FEngines: TEngines;
  FDevices: TDevices;
  FAPM: TAPM;
  FDirectX: TDirectX;
  FMedia: TMedia;
  FProcesses: TProcesses;
  FPrinters: TPrinters;
  FSoftware: TSoftware;
  FStartup: TStartup;
  FModules: TBisModuleInfo;
begin
  for i:=Integer(siCPU) to Integer(siStartup) do begin
    if TBisSystemInfoType(i) in Types then begin
      AddDelim(TBisSystemInfoType(i));
      case TBisSystemInfoType(i) of

        siCPU: begin
          FCPU:=TCPU.Create;
          try
            FCPU.GetInfo;
            FCPU.Report(Strings);
          finally
            FCPU.Free;
          end;
        end;

        siMemory: begin
          FMemory:=TMemory.Create;
          try
            FMemory.GetInfo;
            FMemory.Report(Strings);
          finally
            FMemory.Free;
          end;
        end;

        siOS: begin
          FOS:=TOperatingSystem.Create;
          try
            FOS.GetInfo;
            FOS.Report(Strings);
          finally
            FOS.Free;
          end;
        end;

        siDisk: begin
          FDisk:=TDisk.Create;
          try
            FDisk.GetInfo;
            FDisk.NotCheckRemovable:=true;
            FDisk.Report(Strings);
          finally
            FDisk.Free;
          end;
        end;

        siMachine: begin
          FMachine:=TMachine.Create;
          try
            FMachine.GetInfo;
            FMachine.Report(Strings);
          finally
            FMachine.Free;
          end;
        end;

        siNetwork: begin
          FNetwork:=TNetwork.Create;
          try
            FNetwork.ExtendedReport:=false;
            FNetwork.GetInfo;
            FNetwork.Report(Strings);
          finally
            FNetwork.Free;
          end;
        end;

        siDisplay: begin
          FDisplay:=TDisplay.Create;
          try
            FDisplay.ExtendedReport:=false;
            FDisplay.GetInfo;
            FDisplay.Report(Strings);
          finally
            FDisplay.Free;
          end;
        end;

        siEngines: begin
          FEngines:=TEngines.Create;
          try
            FEngines.GetInfo;
            FEngines.Report(Strings);
          finally
            FEngines.Free;
          end;
        end;
      
        siDevices: begin
          FDevices:=TDevices.Create;
          try
            FDevices.GetInfo;
            FDevices.Report(Strings);
          finally
            FDevices.Free;
          end;
        end;

        siAPM: begin
          FAPM:=TAPM.Create;
          try
            FAPM.GetInfo;
            FAPM.Report(Strings);
          finally
            FAPM.Free;
          end;
        end;

        siDirectX: begin
          FDirectX:=TDirectX.Create;
          try
            FDirectX.GetInfo;
            FDirectX.Report(Strings);
          finally
            FDirectX.Free;
          end;
        end;

        siMedia: begin
          FMedia:=TMedia.Create;
          try
            FMedia.GetInfo;
            FMedia.Report(Strings);
          finally
            FMedia.Free;
          end;
        end;

        siProcesses: begin
          FProcesses:=TProcesses.Create;
          try
            FProcesses.GetInfo;
            FProcesses.Report(Strings);
          finally
            FProcesses.Free;
          end;
        end;

        siModules: begin
          FModules:=TBisModuleInfo.Create(GetModuleName(HInstance));
          try
            FModules.Report(Strings);
          finally
            FModules.Free;
          end;
        end;

        siPrinters: begin
          FPrinters:=TPrinters.Create;
          try
            FPrinters.GetInfo;
            FPrinters.Report(Strings);
          finally
            FPrinters.Free;
          end;
        end;

        siSoftware: begin
          FSoftware:=TSoftware.Create;
          try
            FSoftware.GetInfo;
            FSoftware.Report(Strings);
          finally
            FSoftware.Free;
          end;
        end;

        siStartup: begin
          FStartup:=TStartup.Create;
          try
            FStartup.GetInfo;
            FStartup.Report(Strings);
          finally
            FStartup.Free;
          end;
        end;

      end;
    end;  
  end;
end;

end.
