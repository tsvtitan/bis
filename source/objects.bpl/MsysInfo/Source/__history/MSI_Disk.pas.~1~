
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Disk Detection Part                     }
{           version 5.5 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Disk;

interface

uses
  SysUtils, Windows, Classes, MiTeC_Routines;

type
  TDisk = class(TPersistent)
  private
    FDisk: TDiskSign;
    FMediaPresent: Boolean;
    FDriveType: TMediaType;
    FSectorsPerCluster: DWORD;
    FBytesPerSector: DWORD;
    FFreeClusters: DWORD;
    FTotalClusters: DWORD;
    FFileFlags: TFileFlags;
    FVolumeLabel: string;
    FSerialNumber: string;
    FFileSystem: string;
    FFreeSpace: int64;
    FCapacity: int64;
    FAvailDisks: string;
    FSerial: dword;
    FNotCheckRemovable: Boolean;
    function GetMediaPresent: Boolean;
  protected
    procedure SetDisk(const Value: TDiskSign);
  public
    procedure GetInfo;
    procedure Report_FileFlags(var AFileFlags :TStringList);
    procedure Report(var sl :TStringList);
    function GetCD :byte;
    property Serial :dword read FSerial write FSerial stored false;
    property NotCheckRemovable: Boolean read FNotCheckRemovable write FNotCheckRemovable;
  published
    property Drive :TDiskSign read FDisk write SetDisk stored false;
    property AvailableDisks :string read FAvailDisks write FAvailDisks stored false;
    property MediaPresent :Boolean read GetMediaPresent write FMediaPresent stored false;
    property MediaType :TMediaType read FDriveType write FDriveType stored false;
    property FileFlags :TFileFlags read FFileFlags write FFileFlags stored false;
    property FileSystem :string read FFileSystem write FFileSystem stored false;
    property FreeClusters :DWORD read FFreeClusters write FFreeClusters stored false;
    property TotalClusters :DWORD read FTotalClusters write FTotalClusters stored false;
    // FreeSpace and Capacity returns good results for Win95 OSR2, Win98, NT and 2000
    // for Win95 there can be bad sizes for drives over 2GB
    property FreeSpace :int64 read FFreeSpace write FFreeSpace stored false;
    property Capacity :int64 read FCapacity write FCapacity stored false;
    property SerialNumber :string read FSerialNumber write FSerialNumber stored false;
    property VolumeLabel :string read FVolumeLabel write FVolumeLabel stored false;
    property SectorsPerCluster :DWORD read FSectorsPerCluster write FSectorsPerCluster stored false;
    property BytesPerSector :DWORD read FBytesPerSector write FBytesPerSector stored false;
  end;

implementation

{ TDisk }

function TDisk.GetCD: byte;
var
  i :integer;
  root :pchar;
begin
  result:=0;
  root:=stralloc(255);
  for i:=1 to length(FAvailDisks) do begin
    strpcopy(root,copy(FAvailDisks,i,1)+':\');
    if getdrivetype(root)=drive_cdrom then begin
      result:=i;
      break;
    end;
  end;
  strdispose(root);
end;

procedure TDisk.Report_FileFlags;
begin
  with AFileFlags do begin
    Add(Format('Case Is Preserved=%d',[integer(fsCaseIsPreserved in FileFlags)]));
    Add(Format('Case Sensitive=%d',[integer(fsCaseSensitive in FileFlags)]));
    Add(Format('Unicode Stored On Disk=%d',[integer(fsUnicodeStoredOnDisk in FileFlags)]));
    Add(Format('Persistent Acls=%d',[integer(fsPersistentAcls in FileFlags)]));
    Add(Format('File Compression=%d',[integer(fsFileCompression in FileFlags)]));
    Add(Format('Volume Is Compressed=%d',[integer(fsVolumeIsCompressed in FileFlags)]));
    Add(Format('Long Filenames=%d',[integer(fsLongFileNames in FileFlags)]));
    Add(Format('Encrypted File System Support=%d',[integer(fsEncryptedFileSystemSupport in FileFlags)]));
    Add(Format('Object IDs Support=%d',[integer(fsObjectIDsSupport in FileFlags)]));
    Add(Format('Reparse Points Support=%d',[integer(fsReparsePointsSupport in FileFlags)]));
    Add(Format('Sparse Files Support=%d',[integer(fsSparseFilesSupport in FileFlags)]));
    Add(Format('Disk Quotas Support=%d',[integer(fsDiskQuotasSupport in FileFlags)]));
  end;
end;

procedure TDisk.GetInfo;
var
  i,n :integer;
  buf :pchar;
begin
  try

  buf:=stralloc(255);
  n:=GetLogicalDriveStrings(255,buf);
  FAvailDisks:='';
  for i:=0 to n do
    if buf[i]<>#0 then begin
      if (ord(buf[i]) in [$41..$5a]) or (ord(buf[i]) in [$61..$7a]) then
        FAvailDisks:=FAvailDisks+upcase(buf[i])
    end else
      if buf[i+1]=#0 then
        break;
  strdispose(buf);

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDisk.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;


function TDisk.GetMediaPresent :Boolean;
begin
  Result:=MiTeC_Routines.GetMediaPresent(FDisk);
end;

procedure TDisk.Report(var sl: TStringList);
var
  i :integer;
begin
  with sl do begin
    Add('[Disks]');
    Add(Format('Available=%s',[AvailableDisks]));
    for i:=1 to Length(AvailableDisks) do begin
      Drive:=copy(AvailableDisks,i,1)+':';
      Add(Format('[Disk%s]',[Drive]));
      Add(Format('VolumeLabel=%s',[VolumeLabel]));
      Add(Format('Type=%s',[GetMediaTypeStr(MediaType)]));
      if not FNotCheckRemovable and
         (MediaType<>dtRemovable) then
        Add(Format('UNC=%s',[ExpandUNCFilename(Drive)]));
      Add(Format('SerialNumber=%s',[SerialNumber]));
      {$IFDEF D4PLUS}
      Add(FormatFloat('Capacity=0,##',Capacity));
      Add(FormatFloat('FreeSpace=0,##',FreeSpace));
      {$ELSE}
      Add(FormatFloat('Capacity=0,##',Capacity.QuadPart));
      Add(FormatFloat('FreeSpace=0,##',FreeSpace.QuadPart));
      {$ENDIF}
      Add(FormatFloat('BytesPerSector=0',BytesPerSector));
      Add(FormatFloat('SectorPerCluster=0',SectorsPerCluster));
      Add(FormatFloat('FreeClusters=0,##',FreeClusters));
      Add(FormatFloat('TotalClusters=0,##',TotalClusters));
      Add(Format('[Disk%s_Flags]',[Drive]));
      Report_FileFlags(sl);
    end;
  end;
end;

procedure TDisk.SetDisk(const Value: TDiskSign);
var
  DI: TDiskInfo;
  Flags: TMediaTypeSet;
begin
  try

  FDisk:=Value;
  Flags:=[dtUnknown, dtNotExists, dtRemovable, dtFixed, dtRemote, dtCDROM, dtRAMDisk];
  if FNotCheckRemovable then
    Flags:=Flags-[dtRemovable];

  DI:=GetDiskInfo(Value,Flags);

  FDriveType:=DI.MediaType;
  FFileFlags:=DI.FileFlags;
  FCapacity:=DI.Capacity;
  FFreeSpace:=DI.FreeSpace;
  FBytesPerSector:=DI.BytesPerSector;
  FTotalClusters:=DI.TotalClusters;
  FFreeClusters:=DI.FreeClusters;
  FSectorsPerCluster:=DI.SectorsPerCluster;
  FVolumeLabel:=DI.VolumeLabel;
  FFileSystem:=DI.FileSystem;
  FSerialNumber:=DI.SerialNumber;
  FSerial:=DI.Serial;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDisk.SetDisk',MB_OK or MB_ICONERROR);
    end;
  end;
end;


end.
