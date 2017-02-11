unit BisCsFtpClient;

interface

uses  Windows, Classes, ActiveX, ComObj, ShlObj;

const
 RUS_TIP_MENU = '��������� ����� � �������';
 RUS_NAME_MENU = '��������� � �������...';
 ENG_TIP_MENU = 'Send files to Banerov';
 ENG_NAME_MENU = 'Send to Banerov...';
 ComServerName = 'BisFtpClient';
 STAR = '*';
 DELIMITER = '\/:?"<>|';
 Class_ContextMenu: TGUID = '{84250F2E-7910-4261-96D4-045696B05E86}';

type
 TFileNameArray = array [0..MAX_PATH] of Char;

 TContextMenu = class(TComObject, IShellExtInit, IContextMenu)
  private
    FFileName: TFileNameArray;
    FListFile: array of TFileNameArray;
    procedure CreateListFile(strName: TFileNameArray);
    procedure FreeListFile;
    procedure LangSystem;
  protected
    { IShellExtInit }
    function IShellExtInit.Initialize = SEIInitialize; // Avoid compiler warning
    function SEIInitialize(pidlFolder: PItemIDList; lpdobj: IDataObject; hKeyProgID: HKEY): HResult; stdcall;
    { IContextMenu }
    function QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT;  pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HResult; stdcall;
  public
   destructor Destroy; override;
  end;

var
  TIP_MENU: String;
  NAME_MENU: String;
  MainBmp: THandle;

implementation

uses ComServ, SysUtils, ShellApi, Registry, IniFiles, Dialogs;

{$R bmp.res}

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

procedure GetExtensions(Filter: String; Extensions, Filters: TStrings);
var
  S: String;
  S1: String;
  Str: TStringList;
  i: Integer;
begin
  Str:=TStringList.Create;
  try
    Extensions.Clear;
    S:=Filter;
    GetStringsByString(S,'|',Str);
    for i:=0 to Str.Count-1 do begin
      if Odd(i) then begin
        S1:=Str[i];
        if Length(S1)>0 then begin
          if S1[1]='*' then
            S1:=Copy(S1,2,Length(S1));
          if Assigned(Extensions) then
            Extensions.Add(S1);
        end;
      end else
        if Assigned(Filters) then
          Filters.Add(Str[i]);
    end;
  finally
    Str.Free;
  end;
end;


type
  TContextMenuFactory = class(TComObjectFactory)
  public
    procedure UpdateRegistry(Register: Boolean); override;
  end;

destructor TContextMenu.Destroy;
begin
  FreeListFile;
  inherited;
end;

function TContextMenu.SEIInitialize(pidlFolder: PItemIDList;
                               lpdobj: IDataObject; hKeyProgID: HKEY): HResult;
var
  StgMedium: TStgMedium;
  FormatEtc: TFormatEtc;
  CountFiles: Integer;
  IndexFile: Integer;
begin
  if (lpdobj = nil) then begin Result := E_INVALIDARG; Exit; end;
  with FormatEtc do begin
    cfFormat:= CF_HDROP;
    ptd:= nil;
    dwAspect:= DVASPECT_CONTENT;
    lindex:= -1;
    tymed:= TYMED_HGLOBAL;

  end;
  Result := lpdobj.GetData(FormatEtc, StgMedium);
  if Failed(Result) then Exit;

  FFileName[0]:= #0;

  CountFiles:= DragQueryFile(StgMedium.hGlobal, $FFFFFFFF, nil, 0);
  if (CountFiles <> 0) then begin
    for IndexFile:= 0 to CountFiles - 1 do
     begin
      DragQueryFile(StgMedium.hGlobal, IndexFile, FFileName, SizeOf(FFileName));
      // Fills array name files
      CreateListFile(FFileName);
      // Clear filename
      FFileName[0] := #0;
     end;
    Result := NOERROR;
  end
  else begin
    FFileName[0] := #0;
    Result := E_FAIL;
  end;
  ReleaseStgMedium(StgMedium);
end;

function TContextMenu.QueryContextMenu(Menu: HMENU;
                       indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult;
begin
  Result := E_FAIL;
  LangSystem;
  if ((uFlags and $0000000F) = CMF_NORMAL) or ((uFlags and CMF_EXPLORE) <> 0) then begin
   InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst, PChar(NAME_MENU));
   SetMenuItemBitmaps(Menu,indexMenu,MF_BYPOSITION,MainBmp,MainBmp);
   Result:= 1;
  end;
end;

function TContextMenu.InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult;
var
  ConfigFile: String;
  IniFile: TMemIniFile;
  List: String;
  Str: TStringList;
  i: Integer;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  S, Dir: String;
  Ret: Boolean;
begin
  Result := E_FAIL;
  if (HiWord(Integer(lpici.lpVerb)) <> 0) then Exit;
  if (LoWord(lpici.lpVerb) <> 0) then begin Result:= E_INVALIDARG; Exit; end;

  ConfigFile:=ExtractFilePath(GetModuleName(HInstance))+'config.ini';
  if FileExists(ConfigFile) then begin
    IniFile:=TMemIniFile.Create(ConfigFile);
    Str:=TStringList.Create;
    try
      List:=IniFile.ReadString('FtpClientMainForm','List','');
      if not FileExists(List) then
        List:=ExtractFilePath(GetModuleName(HInstance))+List;

      Str.LoadFromFile(List);  
      for i:=0 to Length(FListFile)-1 do begin
        if Str.IndexOf(FListFile[i])=-1 then
          Str.Add(FListFile[i]);
      end;
      Str.SaveToFile(List);

      if Str.Count>0 then begin
        Dir:=ExtractFileDir(GetModuleName(HInstance));
        S:=ExtractFilePath(GetModuleName(HInstance))+'ftpclt.exe';

        FillChar(StartupInfo,SizeOf(TStartupInfo),0);
        with StartupInfo do begin
          cb:=SizeOf(TStartupInfo);
          wShowWindow:=SW_SHOWDEFAULT;
        end;
        Ret:=CreateProcess(nil,PChar(S),nil,nil,False,
                           NORMAL_PRIORITY_CLASS,nil,PChar(Dir),StartupInfo, ProcessInfo);
        if not Ret then
       //   ShowMessage(SysErrorMessage(GetLastError));
        
      end;

    finally
      Str.Free;
      IniFile.Free;
    end;
  end;
  FreeListFile;
end;

function TContextMenu.GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;
  pszName: LPSTR; cchMax: UINT): HRESULT;
begin
  if (idCmd = 0) then begin
    if (uType = GCS_HELPTEXT) then StrCopy(pszName, PChar(TIP_MENU));
    Result := NOERROR;
  end
  else Result := E_INVALIDARG;
end;

procedure TContextMenuFactory.UpdateRegistry(Register: Boolean);
var
  ClassID: string;
  ConfigFile: String;
  IniFile: TMemIniFile;
  Filter: String;
  Extensions,Filters: TStringList;
  i: Integer;
begin
  if Register then begin
    inherited UpdateRegistry(Register);
    ClassID := GUIDToString(Class_ContextMenu);
    ConfigFile:=ExtractFilePath(GetModuleName(HInstance))+'config.ini';
    if FileExists(ConfigFile) then begin
      IniFile:=TMemIniFile.Create(ConfigFile);
      Extensions:=TStringList.Create;
      Filters:=TStringList.Create;
      try
        Filter:=IniFile.ReadString('FtpClientMainForm','Filter','');
        GetExtensions(Filter,Extensions,Filters);
        if Extensions.Count>0 then begin
          for i:=0 to Extensions.Count-1 do begin
            CreateRegKey(Extensions[i], '', ComServerName);
          end;
          CreateRegKey(ComServerName+'\shellex', '', '');
          CreateRegKey(ComServerName+'\shellex\ContextMenuHandlers', '', '');
          CreateRegKey(ComServerName+'\shellex\ContextMenuHandlers\ContMenu', '', ClassID);
          if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
            with TRegistry.Create do
              try
                RootKey := HKEY_LOCAL_MACHINE;
                OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions', True);
                OpenKey('Approved', True);
                WriteString(ClassID, ComServerName);
              finally
                Free;
              end;
          end;
        end;
      finally
        Filters.Free;
        Extensions.Free;
        IniFile.Free;
      end;
    end;
  end else begin
    DeleteRegKey(ComServerName+'\shellex\ContextMenuHandlers\ContMenu');
    inherited UpdateRegistry(Register);
  end;
end;

procedure TContextMenu.CreateListFile(strName: TFileNameArray);
var
 SizeList: Integer;
begin
  SizeList:= Length(FListFile);
  if SizeList = 0 then
    SetLength(FListFile, 1)
  else
    SetLength(FListFile, SizeList + 1);
  FListFile[High(FListFile)]:= strName;
end;

procedure TContextMenu.FreeListFile;
begin
  if FListFile <> nil then Finalize(FListFile);
  FListFile:= nil;
end;

procedure TContextMenu.LangSystem;
begin
 if GetUserDefaultLangID = 1049 then begin
   NAME_MENU:= RUS_NAME_MENU;
   TIP_MENU:= RUS_TIP_MENU;
  end else begin
   NAME_MENU:= ENG_NAME_MENU;
   TIP_MENU:= ENG_TIP_MENU;
  end;
end;

initialization
  MainBmp := LoadImage(hInstance, 'MAIN_BMP', IMAGE_BITMAP, 0, 0,  LR_LOADMAP3DCOLORS);  //#80

  TContextMenuFactory.Create(ComServer, TContextMenu,
                             Class_ContextMenu, '', ComServerName, ciMultiInstance, tmApartment);
end.

