unit BisFileDirs;

interface

uses Windows, Classes, SysUtils, Contnrs;

type

  TBisFileDir=class(TObject)
  private
    FIsDir: Boolean;
    FName: String;
    FParent: TBisFileDir;
    FSize: Int64;
    FAttribute: Integer;
    FCreationTime: TDateTime;
    FLastAccessTime: TDateTime;
    FLastWriteTime: TDateTime;
  public
    property Name: String read FName;
    property IsDir: Boolean read FIsDir;
    property Parent: TBisFileDir read FParent;
    property Size: Int64 read FSize;
    property Attribute: Integer read FAttribute;
    property CreationTime: TDateTime read FCreationTime;
    property LastAccessTime: TDateTime read FLastAccessTime;
    property LastWriteTime: TDateTime read FLastWriteTime; 
  end;

  TBisFileDirs=class(TObjectList)
  private
    function AddFileDir(Name: String; IsDir: Boolean; FileInfo: TSearchRec; Parent: TBisFileDir): TBisFileDir;
    function GetItem(Index: Integer): TBisFileDir;
  public
    procedure Refresh(const Dir: String; OneLevel: Boolean; Masks: TStrings=nil; Parent: TBisFileDir=nil); overload;

    property Items[Index: Integer]: TBisFileDir read GetItem; default;
  end;


implementation

{ TBisFileDirs }

function TBisFileDirs.AddFileDir(Name: String; IsDir: Boolean; FileInfo: TSearchRec; Parent: TBisFileDir): TBisFileDir;

  function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
  var
    LocalFileTime: TFileTime;
    TimeExt: Integer;
  begin
    FileTimeToLocalFileTime(FileTime,LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime,LongRec(TimeExt).Hi, LongRec(TimeExt).Lo);
    Result:=FileDateToDateTime(TimeExt);
  end;

begin
  Result:=TBisFileDir.Create;
  Result.FName:=Name;
  Result.FIsDir:=IsDir;
  Result.FParent:=Parent;
  Result.FSize:=FileInfo.Size;
  Result.FAttribute:=FileInfo.Attr;
  Result.FCreationTime:=FileTimeToDateTime(FileInfo.FindData.ftCreationTime);
  Result.FLastAccessTime:=FileTimeToDateTime(FileInfo.FindData.ftLastAccessTime);
  Result.FLastWriteTime:=FileTimeToDateTime(FileInfo.FindData.ftLastWriteTime);
  inherited Add(Result);
end;

function TBisFileDirs.GetItem(Index: Integer): TBisFileDir;
begin
  Result:=TBisFileDir(inherited Items[Index]);
end;

procedure TBisFileDirs.Refresh(const Dir: String; OneLevel: Boolean; Masks: TStrings=nil; Parent: TBisFileDir=nil);
var
  AttrWord: Word;
  FMask: String;
  MaskPtr: PChar;
  Ptr: Pchar;
  FileInfo: TSearchRec;
  Item: TBisFileDir;
  S: string;
  Flag: Boolean;
  Ext: String;
begin
  if not DirectoryExists(Dir) then exit;
  AttrWord:=faAnyFile+faReadOnly+faHidden+faSysFile+faVolumeID+faDirectory+faArchive;
  if SetCurrentDirectory(Pchar(Dir)) then begin
    FMask:='*.*';
    try
      MaskPtr:=PChar(FMask);
      while MaskPtr <> nil do begin
        Ptr:=StrScan(MaskPtr, ';');
        if Ptr <> nil then
          Ptr^ := #0;
        if FindFirst(MaskPtr,AttrWord,FileInfo) = 0 then  begin
          repeat
            S:=Dir+PathDelim+FileInfo.Name;
            if FileInfo.Attr and faDirectory <> 0 then begin
              if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') then begin
                Item:=AddFileDir(S,true,FileInfo,Parent);
                if not OneLevel then
                  Refresh(S,OneLevel,Masks,Item);
              end;
            end else begin
              Flag:=true;
              if Assigned(Masks) and (Masks.Count>0) then begin
                Ext:=ExtractFileExt(S);
                Flag:=Masks.IndexOf(Ext)<>-1;
              end;
              if Flag then
                AddFileDir(S,false,FileInfo,Parent);
            end;
          until FindNext(FileInfo) <> 0;
          FindClose(FileInfo);
        end;
        if Ptr <> nil then begin
          Ptr^ := ';';
          Inc (Ptr);
        end;
        MaskPtr := Ptr;
      end;
    finally

    end;
  end;
end;

end.
