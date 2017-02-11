unit BisUtilsFm;

interface

uses
  Windows, Messages, Variants, Classes, Graphics, Controls, Forms, StdCtrls,
  ComCtrls, ExtCtrls , Buttons, Menus, DB, Dialogs, DBCtrls,
  Grids, DBGrids, SysUtils, 

  BisSynEdit, BisDBSynEdit, 
  
  BisFm, BisIfaces, BisProvider, BisConnections, BisUtilsTableEditFrm, BisControls;

type
  TStatusBar=class(ComCtrls.TStatusBar)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisUtilsForm = class(TBisForm)
    StatusBar: TStatusBar;
    PageControl: TPageControl;
    TabSheetImport: TTabSheet;
    TabSheetTable: TTabSheet;
    PanelImportLeft: TPanel;
    PanelImportClient: TPanel;
    SplitterImport: TSplitter;
    Panel2: TPanel;
    ButtonImportLoad: TButton;
    ButtonImportSave: TButton;
    ButtonImportClear: TButton;
    ButtonImportUp: TBitBtn;
    ButtonImportDown: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    DataSourceImport: TDataSource;
    PopupMenuLoad: TPopupMenu;
    Sql1: TMenuItem;
    Query1: TMenuItem;
    Result1: TMenuItem;
    DBNavigator: TDBNavigator;
    DBGridImport: TDBGrid;
    N1: TMenuItem;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    EditBegin: TEdit;
    Label6: TLabel;
    EditEnd: TEdit;
    Label2: TLabel;
    MemoWordsFrom: TMemo;
    Label3: TLabel;
    MemoWordsDelim: TMemo;
    Splitter1: TSplitter;
    PageControlImport: TPageControl;
    TabSheetImportUnknown: TTabSheet;
    TabSheetImportScript: TTabSheet;
    TabSheetImportTable: TTabSheet;
    TabSheetImportFile: TTabSheet;
    Label1: TLabel;
    LabeledEditFile: TLabeledEdit;
    ProgressBar: TProgressBar;
    Label4: TLabel;
    EditStringFrom: TEdit;
    Label7: TLabel;
    EditStringTo: TEdit;
    N3: TMenuItem;
    N2: TMenuItem;
    TabSheetExport: TTabSheet;
    DBGridExport: TDBGrid;
    DBNavigator1: TDBNavigator;
    GroupBox2: TGroupBox;
    Splitter2: TSplitter;
    DBMemoExportValue: TDBMemo;
    DataSourceExport: TDataSource;
    Panel1: TPanel;
    ButtonExportLoad: TButton;
    ButtonExportSave: TButton;
    ButtonExportClear: TButton;
    ButtonExportUp: TBitBtn;
    ButtonExportDown: TBitBtn;
    LabelExportCount: TLabel;
    LabelPrefix: TLabel;
    EditPrefix: TEdit;
    procedure ButtonImportLoadClick(Sender: TObject);
    procedure ButtonImportSaveClick(Sender: TObject);
    procedure ButtonImportClearClick(Sender: TObject);
    procedure ButtonImportUpClick(Sender: TObject);
    procedure ButtonImportDownClick(Sender: TObject);
    procedure Sql1Click(Sender: TObject);
    procedure Query1Click(Sender: TObject);
    procedure Result1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure DBGridImportDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SplitterImportMoved(Sender: TObject);
    procedure ButtonExportLoadClick(Sender: TObject);
    procedure ButtonExportSaveClick(Sender: TObject);
    procedure ButtonExportClearClick(Sender: TObject);
    procedure ButtonExportUpClick(Sender: TObject);
    procedure ButtonExportDownClick(Sender: TObject);
  private
    FIndexImportType: Integer;
    FIndexExportType: Integer;
    FTableFrame: TBisUtilsTableEditFrame;
    FImportTableFrame: TBisUtilsTableEditFrame;
    FScriptMemo: TBisSynEdit;
    FScriptHighlighter: TBisSynSqlSyn;
    FImportProvider: TBisProvider;
    FExportProvider: TBisProvider;
    FMainFormEnabled: Boolean;
    FDBSynEditExport: TBisDBSynEdit;
    procedure RePositionProgressBar;
    procedure GetDirFiles(Dir: String; FileDirs: TStringList; OnlyFiles, StopFirst: Boolean);
    procedure LoadFromExportFile(const FileName: String);
    procedure LoadFromQueryFile(const FileName: String);
    procedure LoadFromImportFile(const FileName: String);
    procedure FillByStrings(Str: TStringList; const Description: String);
    function GetDescription(var Text: String; OldDesc: String): String;
    procedure FillImportTypes(PickList: TStrings);
    procedure FieldImportTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FieldImportTypeSetText(Sender: TField; const Text: string);
    procedure FillExportTypes(PickList: TStrings);
    procedure FieldExportTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FieldExportTypeSetText(Sender: TField; const Text: string);
    procedure ImportProviderAfterScroll(DataSet: TDataSet);
    procedure ImportProviderBeforeScroll(DataSet: TDataSet);
    procedure ImportProviderBeforePost(DataSet: TDataSet);
    procedure DisableEvent;
    procedure EnableEvent;
    procedure ExportProviderAfterPost(DataSet: TDataSet);
    procedure RefreshExportCount;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanShow: Boolean; override;

    property MainFormEnabled: Boolean read FMainFormEnabled write FMainFormEnabled;
  end;

  TBisUtilsFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisUtilsMainFormIface=class(TBisFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisUtilsForm: TBisUtilsForm;

implementation

{$R *.dfm}

uses TypInfo, FileCtrl, StrUtils,

     BisConsts, BisUtils;

{ TStatusBar }

constructor TStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csAcceptsControls];
end;

{ TBisMainFormIface }

constructor TBisUtilsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisUtilsForm;
//  Available:=true;
  Permissions.Enabled:=true;
end;

{ TBisUtilsMainFormIface }

constructor TBisUtilsMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisUtilsForm;
  ApplicationCreateForm:=true;
  AutoShow:=true;
end;

function TBisUtilsMainFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then
    TBisUtilsForm(LastForm).MainFormEnabled:=true;
end;


{ TBisUtilstForm }

type
  THackGrid=class(TCustomGrid)
  end;

constructor TBisUtilsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  PageControl.ActivePageIndex:=0;
  PageControlImport.ActivePageIndex:=0;
  ProgressBar.Parent:=StatusBar;
  ProgressBar.Visible:=false;
   
  FIndexImportType:=0;
  FImportProvider:=TBisProvider.Create(Self);
  with FImportProvider.FieldDefs do begin
    Add(SFieldType,ftInteger);
    Add(SFieldDescription,ftString,250);
    Add(SFieldValue,ftBlob);
  end;
  FImportProvider.CreateTable();
  with FImportProvider do begin
    FieldByName(SFieldType).OnGetText:=FieldImportTypeGetText;
    FieldByName(SFieldType).OnSetText:=FieldImportTypeSetText;
    FieldByName(SFieldType).Alignment:=taLeftJustify;
    AfterScroll:=ImportProviderAfterScroll;
    BeforeScroll:=ImportProviderBeforeScroll;
    BeforePost:=ImportProviderBeforePost;
  end;
  FillImportTypes(DBGridImport.Columns.Items[FIndexImportType].PickList);
  DataSourceImport.DataSet:=FImportProvider;

  THackGrid(DBGridImport).Options:=THackGrid(DBGridImport).Options-[goColMoving];

  FScriptHighlighter:=TBisSynSqlSyn.Create(Self);

  FScriptMemo:=TBisSynEdit.Create(Self);
  FScriptMemo.Parent:=TabSheetImportScript;
  FScriptMemo.Align:=alClient;
  FScriptMemo.Highlighter:=FScriptHighlighter;

  FImportTableFrame:=TBisUtilsTableEditFrame.Create(Self);
  FImportTableFrame.Parent:=TabSheetImportTable;
  FImportTableFrame.Align:=alClient;
  FImportTableFrame.Name:='ImportTableFrame';

  FIndexExportType:=0;
  FExportProvider:=TBisProvider.Create(Self);
  with FExportProvider.FieldDefs do begin
    Add(SFieldType,ftInteger);
    Add(SFieldDescription,ftString,250);
    Add(SFieldValue,ftBlob);
    Add(SFieldResult,ftBlob);
    Add(SFieldChecked,ftInteger);
  end;
  FExportProvider.AfterPost:=ExportProviderAfterPost;
  FExportProvider.AfterCancel:=ExportProviderAfterPost;
  FExportProvider.AfterDelete:=ExportProviderAfterPost;
  FExportProvider.CreateTable();
  with FExportProvider do begin
    FieldByName(SFieldType).OnGetText:=FieldExportTypeGetText;
    FieldByName(SFieldType).OnSetText:=FieldExportTypeSetText;
    FieldByName(SFieldType).Alignment:=taLeftJustify;
  end;
  FillExportTypes(DBGridExport.Columns.Items[FIndexImportType].PickList);
  DataSourceExport.DataSet:=FExportProvider;

  THackGrid(DBGridExport).Options:=THackGrid(DBGridExport).Options-[goColMoving];

  FDBSynEditExport:=TBisDBSynEdit.Create(Self);
  FDBSynEditExport.Parent:=DBMemoExportValue.Parent;
  FDBSynEditExport.Align:=alClient;
  FDBSynEditExport.TabOrder:=DBMemoExportValue.TabOrder;
  FDBSynEditExport.DataSource:=DBMemoExportValue.DataSource;
  FDBSynEditExport.DataField:=DBMemoExportValue.DataField;
  FDBSynEditExport.AlignWithMargins:=DBMemoExportValue.AlignWithMargins;
  FDBSynEditExport.Margins:=DBMemoExportValue.Margins;
  FDBSynEditExport.Highlighter:=FScriptHighlighter;

  FreeAndNilEx(DBMemoExportValue);

  FTableFrame:=TBisUtilsTableEditFrame.Create(Self);
  FTableFrame.Parent:=TabSheetTable;
  FTableFrame.Align:=alClient;
  FTableFrame.Name:='TableFrame';

  TabSheetImportUnknown.TabVisible:=false;
  TabSheetImportUnknown.Visible:=true;
  TabSheetImportScript.TabVisible:=false;
  TabSheetImportTable.TabVisible:=false;
  TabSheetImportFile.TabVisible:=false;

  SplitterImportMoved(nil);
end;

destructor TBisUtilsForm.Destroy;
begin
  FTableFrame.Free;
  FDBSynEditExport.Free;
  FExportProvider.Free;
  FImportTableFrame.Free;
  FScriptMemo.Free;
  FScriptHighlighter.Free;
  FImportProvider.Free;
  inherited;
end;

function TBisUtilsForm.CanShow: Boolean;
begin
  Result:=inherited CanShow;
  if Result then
    Result:=not FMainFormEnabled;
end;

procedure TBisUtilsForm.FieldImportTypeGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not FImportProvider.IsEmpty then
    if Sender.AsInteger in [0..DBGridImport.Columns.Items[FIndexImportType].PickList.Count-1] then
      Text:=DBGridImport.Columns.Items[FIndexImportType].PickList[Sender.AsInteger];
end;

procedure TBisUtilsForm.FieldImportTypeSetText(Sender: TField; const Text: string);
var
  Index: Integer;
begin
  Index:=DBGridImport.Columns.Items[FIndexImportType].PickList.IndexOf(Text);
  if Index in [0..DBGridImport.Columns.Items[FIndexImportType].PickList.Count-1] then begin
    Sender.AsInteger:=Index;
    ImportProviderAfterScroll(FImportProvider);
  end;
end;

procedure TBisUtilsForm.FillImportTypes(PickList: TStrings);
var
  i: Integer;
  PInfo: PTypeInfo;
  PData: PTypeData;
begin
  PickList.BeginUpdate;
  try
    PickList.Clear;
    PData:=nil;
    PInfo:=TypeInfo(TBisConnectionImportType);
    if Assigned(PInfo) then
      PData:=GetTypeData(PInfo);
    if Assigned(PData) then
      for i:=PData.MinValue to PData.MaxValue do begin
        PickList.Add(GetEnumName(PInfo,i));
      end;
  finally
    PickList.EndUpdate;
  end;
end;

procedure TBisUtilsForm.FieldExportTypeGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not FExportProvider.IsEmpty then
    if Sender.AsInteger in [0..DBGridExport.Columns.Items[FIndexExportType].PickList.Count-1] then
      Text:=DBGridExport.Columns.Items[FIndexExportType].PickList[Sender.AsInteger];
end;

procedure TBisUtilsForm.FieldExportTypeSetText(Sender: TField; const Text: string);
var
  Index: Integer;
begin
  Index:=DBGridExport.Columns.Items[FIndexExportType].PickList.IndexOf(Text);
  if Index in [0..DBGridExport.Columns.Items[FIndexExportType].PickList.Count-1] then begin
    Sender.AsInteger:=Index;
  end;
end;

procedure TBisUtilsForm.FillExportTypes(PickList: TStrings);
var
  i: Integer;
  PInfo: PTypeInfo;
  PData: PTypeData;
begin
  PickList.BeginUpdate;
  try
    PickList.Clear;
    PData:=nil;
    PInfo:=TypeInfo(TBisConnectionExportType);
    if Assigned(PInfo) then
      PData:=GetTypeData(PInfo);
    if Assigned(PData) then
      for i:=PData.MinValue to PData.MaxValue do begin
        PickList.Add(GetEnumName(PInfo,i));
      end;
  finally
    PickList.EndUpdate;
  end;
end;

{function TBisUtilsForm.GetDescription(var Text: String; OldDesc: String): String;
var
  Str: TStringList;
  Apos1,Apos2: Integer;
  S: String;
  Ret: String;
begin
  Result:=OldDesc;
  Ret:=Text;
  Str:=TStringList.Create;
  try
    Str.Text:=Trim(Text);
    if Str.Count>0 then begin
      Result:=iff(Trim(OldDesc)<>'',OldDesc,Str.Strings[0]);
      Str.Clear;
      Apos1:=-1;
      while Apos1<>0 do begin
        Apos1:=AnsiPos(EditBegin.Text,Ret);
        if Apos1>0 then begin
          Ret:=Copy(Ret,Apos1+Length(EditBegin.Text),Length(Ret));
          Apos2:=AnsiPos(EditEnd.Text,Ret);
          if Apos2>0 then begin
            S:=Copy(Ret,1,Apos2-1);
            Ret:=Copy(Ret,Apos2+Length(EditEnd.Text),Length(Ret));
            if (Trim(S)<>'') then begin
              if Trim(S)<>Trim(EditPrefix.Text) then
                Result:=Trim(S)
              else
                Ret:=Text;
              exit;
            end;
          end;
        end;
      end;
    end;
  finally
    Text:=Ret;
    Str.Free;
  end;
end;}

procedure TBisUtilsForm.GetDirFiles(Dir: String; FileDirs: TStringList;
  OnlyFiles, StopFirst: Boolean);
var
  AttrWord: Word;
  FMask: String;
  MaskPtr: PChar;
  Ptr: Pchar;
  FileInfo: TSearchRec;
  S: string;
begin
  if StopFirst then begin
    if FileDirs.Count>0 then
      exit;
  end;
  if not DirectoryExists(Dir) then exit;
  AttrWord :=faAnyFile+faReadOnly+faHidden+faSysFile+faVolumeID+faDirectory+faArchive;
  if SetCurrentDirectory(Pchar(Dir)) then begin
    FMask:='*.*';
    MaskPtr := PChar(FMask);
    while MaskPtr <> nil do begin
      Ptr := StrScan (MaskPtr, ';');
      if Ptr <> nil then
        Ptr^ := #0;
      if FindFirst(MaskPtr, AttrWord, FileInfo) = 0 then begin
        repeat
          S:=Dir+'\'+FileInfo.Name;
          if (FileInfo.Attr and faDirectory <> 0) then begin
            if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') and not OnlyFiles then begin
              with FileInfo.FindData do begin
                GetDirFiles(S,FileDirs,OnlyFiles,StopFirst);
                if not OnlyFiles then begin
                  FileDirs.Add(S);
                  if StopFirst then break;
                end;  
              end;
            end;
          end else begin
            with FileInfo.FindData do begin
              FileDirs.Add(S);
              if StopFirst then break;
            end;
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
  end;
end;

function TBisUtilsForm.GetDescription(var Text: String; OldDesc: String): String;
var
  Str: TStringList;
  Apos1,Apos2: Integer;
  S: String;
  Ret: String;
begin
  Result:=OldDesc;
  Ret:=Trim(Text);
  Str:=TStringList.Create;
  try
    Str.Text:=Ret;
    if Str.Count>0 then begin
      Result:=iff(Trim(OldDesc)<>'',OldDesc,Str.Strings[0]);
      Apos1:=-1;
      while Apos1<>0 do begin
        Apos1:=AnsiPos(EditBegin.Text,Result);
        if Apos1>0 then begin
          Ret:=Copy(Result,Apos1+Length(EditBegin.Text),Length(Result));
          Apos2:=AnsiPos(EditEnd.Text,Ret);
          if Apos2>0 then begin
            S:=Copy(Ret,1,Apos2-1);
            Ret:=Copy(Ret,Apos2+Length(EditEnd.Text),Length(Ret));
            if (Trim(S)<>'') then begin
              if Trim(S)<>Trim(EditPrefix.Text) then begin
                Result:=Trim(S);
                Str.Delete(0);
              end;
            end;
            exit;
          end;
        end;
      end;
    end;
  finally
    Text:=Str.Text;
    Str.Free;
  end;
end;

procedure TBisUtilsForm.FillByStrings(Str: TStringList;
  const Description: String);
var
  Text: string;
  j: Integer;
  AWord,ADesc: string;
  PosBegin, PosEnd, PosAppend: Integer;
  TempString,NewText: string;
  ChBack,ChNext: Char;
  IsAppend: Boolean;
  LastPos: Integer;
const
  GoodChars=[' ',#13,#10,#0];
begin
  ADesc:=Description;
  Text:=Trim(Str.Text);
  while true do begin
    ADesc:=GetDescription(Text,ADesc);
    LastPos:=Length(Text);
    for j:=0 to MemoWordsFrom.Lines.Count-1 do begin
      AWord:=MemoWordsFrom.Lines.Strings[j];
      PosBegin:=AnsiPos(AnsiUpperCase(AWord),AnsiUpperCase(Text));
      if PosBegin>0 then begin
        if LastPos>=PosBegin then
          LastPos:=PosBegin;
      end;
    end;
    PosBegin:=LastPos;
    if PosBegin>0 then begin
      Text:=Trim(Copy(Text,PosBegin,Length(Text)));
      PosAppend:=0;
      IsAppend:=false;
      NewText:=Text;
      while not IsAppend do begin
        for j:=0 to MemoWordsDelim.Lines.Count-1 do begin
          AWord:=MemoWordsDelim.Lines.Strings[j];
          PosEnd:=AnsiPos(AWord,NewText);
          if PosEnd>0 then begin
            ChBack:=NewText[PosEnd-1];
            ChNext:=NewText[PosEnd+Length(AWord)];
            if (ChBack in GoodChars) and (ChNext in GoodChars) then begin
              PosAppend:=PosAppend+PosEnd;
              IsAppend:=true;
              break;
            end else begin
              PosAppend:=PosAppend+PosEnd+Length(AWord)-1;
              NewText:=Copy(NewText,PosEnd+Length(AWord),Length(NewText));
            end;

          end;
        end;

        if not IsAppend then begin
          IsAppend:=true;
          PosAppend:=Length(NewText)+1;
        end;
      end;
      if IsAppend then begin
        TempString:=Trim(Copy(Text,1,PosAppend-1));
        Text:=Trim(Copy(Text,PosAppend+Length(AWord),Length(Text)));
        if Trim(TempString)<>'' then begin
          if Trim(EditStringFrom.Text)<>'' then
            TempString:=ReplaceText(TempString,EditStringFrom.Text,EditStringTo.Text);
          FImportProvider.Append;
          FImportProvider.FieldByName(SFieldType).AsInteger:=Integer(itScript);
          FImportProvider.FieldByName(SFieldValue).AsString:=TempString;
          FImportProvider.FieldByName(SFieldDescription).AsString:=ADesc;
          FImportProvider.Post;
          ADesc:='';
        end;
      end else begin
        if PosAppend>0 then begin
        end else break;
      end;
    end else break;
  end;
end;

procedure TBisUtilsForm.LoadFromQueryFile(const FileName: String);
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  FImportProvider.Last;
  FImportProvider.BeginUpdate(true);
  try
    P.LoadFromFile(FileName);
    P.Open;
    FImportProvider.CopyRecords(P);
  finally
    FImportProvider.EndUpdate(false);
    FImportProvider.Next;
    P.Free;
  end;
end;

procedure TBisUtilsForm.LoadFromExportFile(const FileName: String);
var
  P: TBisProvider;
  AResult: String;
  ADesc: String;
  Str: TStringList;
  ExportType: TBisConnectionExportType;
  Position: Integer;
begin
  P:=TBisProvider.Create(nil);
  FImportProvider.Last;
  FImportProvider.BeginUpdate(true);
  Str:=TStringList.Create;
  ProgressBar.Visible:=true;
  ProgressBar.Position:=0;
  try
    P.LoadFromFile(FileName);
    P.Open;
    if P.Active then begin
      Position:=1;
      ProgressBar.Max:=P.RecordCount;
      P.First;
      while not P.Eof do begin
        AResult:=P.FieldByName(SFieldResult).AsString;
        ADesc:=P.FieldByName(SFieldDescription).AsString;
        ExportType:=TBisConnectionExportType(P.FieldByName(SFieldType).AsInteger);
        Str.Clear;
        case ExportType of
          etScript: begin
            Str.Add(AResult);
            FillByStrings(Str,ADesc);
          end;
          etTable: begin
            FImportProvider.Append;
            FImportProvider.FieldByName(SFieldType).AsInteger:=Integer(itTable);
            FImportProvider.FieldByName(SFieldValue).AsString:=AResult;
            FImportProvider.FieldByName(SFieldDescription).AsString:=ADesc;
            FImportProvider.Post;
          end;
        end;
        ProgressBar.Position:=Position+1;
        Application.ProcessMessages;
        P.Next;
        Inc(Position);
      end;
    end;
  finally
    ProgressBar.Position:=0;
    ProgressBar.Visible:=false;
    Str.Free;
    FImportProvider.EndUpdate(false);
    FImportProvider.Next;
    P.Free;
  end;
end;

procedure TBisUtilsForm.LoadFromImportFile(const FileName: String);
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  try
    Str.LoadFromFile(FileName);
    FillByStrings(Str,'');
  finally
    Str.Free;
  end;
end;

procedure TBisUtilsForm.DisableEvent;
begin
  FImportProvider.AfterScroll:=nil;
  FImportProvider.BeforeScroll:=nil;
  FImportProvider.BeforePost:=nil;
end;

procedure TBisUtilsForm.EnableEvent;
begin
  FImportProvider.AfterScroll:=ImportProviderAfterScroll;
  FImportProvider.BeforeScroll:=ImportProviderBeforeScroll;
  FImportProvider.BeforePost:=ImportProviderBeforePost;
end;

procedure TBisUtilsForm.N1Click(Sender: TObject);
var
  FilesIn: TStringList;
  i: Integer;
  FileName: string;
  Directory: String;
begin
  Directory:=ExtractFileDir(Application.ExeName);
  if SelectDirectory('','',Directory) then begin
    FilesIn:=TStringList.Create;
    FImportProvider.DisableControls;
    DisableEvent;
    try
      ProgressBar.Visible:=true;
      ProgressBar.Position:=0;
      MemoWordsFrom.Lines.Text:=Trim(MemoWordsFrom.Lines.Text);
      MemoWordsDelim.Lines.Text:=Trim(MemoWordsDelim.Lines.Text);
      GetDirFiles(Directory,FilesIn,false,false);
      FilesIn.Sort;
      ProgressBar.Max:=FilesIn.Count;
      FImportProvider.EmptyTable;
      for i:=0 to FilesIn.Count-1 do begin
        FileName:=FilesIn.Strings[i];
        if FileExists(FileName) then begin
          LoadFromImportFile(FileName);
        end;
        ProgressBar.Position:=i+1;
        Application.ProcessMessages;
      end;
    finally
      FImportProvider.First;
      ImportProviderAfterScroll(FImportProvider);
      EnableEvent;
      FImportProvider.EnableControls;
      ProgressBar.Position:=0;
      ProgressBar.Visible:=false;
      FilesIn.Free;
    end;
  end;
end;

procedure TBisUtilsForm.Query1Click(Sender: TObject);
begin
  OpenDialog.FilterIndex:=1;
  if OpenDialog.Execute then begin
    DisableEvent;
    try
      LoadFromQueryFile(OpenDialog.FileName);
      ImportProviderAfterScroll(FImportProvider);
    finally
      EnableEvent;
    end;
  end;
end;

procedure TBisUtilsForm.RePositionProgressBar;
begin
  if ProgressBar.Visible then begin
    ProgressBar.Left:=1;
    ProgressBar.Width:=StatusBar.Panels.Items[0].Width-1;
    ProgressBar.Top:=2;
    ProgressBar.Height:=StatusBar.Height-2;
  end;
end;

procedure TBisUtilsForm.Result1Click(Sender: TObject);
begin
  OpenDialog.FilterIndex:=2;
  if OpenDialog.Execute then begin
    DisableEvent;
    try
      LoadFromExportFile(OpenDialog.FileName);
      ImportProviderAfterScroll(FImportProvider);
    finally
      EnableEvent;
    end;
  end;
end;

procedure TBisUtilsForm.SplitterImportMoved(Sender: TObject);
begin
  DBGridImport.Columns[1].Width:=SplitterImport.Left-DBGridImport.Columns[0].Width-40;
end;

procedure TBisUtilsForm.Sql1Click(Sender: TObject);
begin
  OpenDialog.FilterIndex:=3;
  if OpenDialog.Execute then begin
    DisableEvent;
    try
      LoadFromImportFile(OpenDialog.FileName);
      ImportProviderAfterScroll(FImportProvider);
    finally
      EnableEvent;
    end;
  end;
end;

procedure TBisUtilsForm.ButtonImportDownClick(Sender: TObject);
begin
  DisableEvent;
  try
    FImportProvider.MoveData(false);
    ImportProviderAfterScroll(FImportProvider);
  finally
    EnableEvent;
  end;
end;

procedure TBisUtilsForm.ButtonImportUpClick(Sender: TObject);
begin
  DisableEvent;
  try
    FImportProvider.MoveData(true);
    ImportProviderAfterScroll(FImportProvider);
  finally
    EnableEvent;
  end;
end;

procedure TBisUtilsForm.ButtonImportClearClick(Sender: TObject);
begin
  FImportProvider.EmptyTable;
  FScriptMemo.Clear;
  FImportTableFrame.DataSet.Close;
  PageControlImport.ActivePageIndex:=0;
end;

procedure TBisUtilsForm.ButtonImportLoadClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt:=Point(ButtonImportLoad.Left,ButtonImportLoad.Top+ButtonImportLoad.height);
  pt:=Panel2.ClientToScreen(pt);
  PopupMenuLoad.Popup(pt.X,pt.Y);
end;

procedure TBisUtilsForm.ButtonImportSaveClick(Sender: TObject);
begin
  SaveDialog.DefaultExt:='.imp';
  SaveDialog.FilterIndex:=1;
  if SaveDialog.Execute then begin
    ImportProviderBeforeScroll(FImportProvider);
    FImportProvider.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TBisUtilsForm.ImportProviderAfterScroll(DataSet: TDataSet);
var
  Index: Integer;
  Stream: TMemoryStream;
  OldCursor: TCursor;
begin
  if FImportProvider.Active and not FImportProvider.IsEmpty then begin
    OldCursor:=Screen.Cursor;
    FImportProvider.AfterScroll:=nil;
    try
      Screen.Cursor:=crHourGlass;
      Index:=FImportProvider.FieldByName(SFieldType).AsInteger;
      case TBisConnectionImportType(Index) of
        itScript: FScriptMemo.Lines.Text:=FImportProvider.FieldByName(SFieldValue).AsString;
        itTable: begin
          try
            Stream:=TMemoryStream.Create;
            try
              TBlobField(FImportProvider.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;
              FImportTableFrame.DBMemoValue.DataField:='';
              FImportTableFrame.DataSet.Close;
              if Stream.Size>0 then begin
                FImportTableFrame.DataSet.LoadFromStream(Stream);
                FImportTableFrame.EditTableName.Text:=FImportTableFrame.DataSet.TableName;
                if FImportTableFrame.DataSet.FieldCount>0 then
                  FImportTableFrame.DBMemoValue.DataField:=FImportTableFrame.DataSet.Fields[0].FieldName;
              end;
              FImportTableFrame.RefreshCount;
            finally
              Stream.Free;
            end;
          except
          end;
        end;
        itFile: LabeledEditFile.Text:=FImportProvider.FieldByName(SFieldValue).AsString;
      end;
      PageControlImport.ActivePageIndex:=Index;
    finally
      FImportProvider.AfterScroll:=ImportProviderAfterScroll;
      Screen.Cursor:=OldCursor;
    end;
  end else
    PageControlImport.ActivePageIndex:=0;
end;

procedure TBisUtilsForm.ImportProviderBeforeScroll(DataSet: TDataSet);
begin
  FImportProvider.BeforeScroll:=nil;
  try
    if FImportProvider.Active and not FImportProvider.IsEmpty then begin
      if not (FImportProvider.State in [dsEdit,dsInsert]) then begin
        FImportProvider.Edit;
      end;
      if (FImportProvider.State in [dsEdit]) then
        FImportProvider.Post;
    end;
  finally
    FImportProvider.BeforeScroll:=ImportProviderBeforeScroll;
  end;
end;

procedure TBisUtilsForm.StatusBarResize(Sender: TObject);
begin
  RePositionProgressBar;
end;

procedure TBisUtilsForm.ImportProviderBeforePost(DataSet: TDataSet);
var
  Index: TBisConnectionImportType;
  Stream: TMemoryStream;
  OldCursor: TCursor;
begin
  if FImportProvider.Active then begin
    OldCursor:=Screen.Cursor;
    FImportProvider.BeforePost:=nil;
    try
      Screen.Cursor:=crHourGlass;
      Index:=TBisConnectionImportType(FImportProvider.FieldByName(SFieldType).AsInteger);
      case Index of
        itUnknown: FImportProvider.FieldByName(SFieldValue).Value:=Null;
        itScript: FImportProvider.FieldByName(SFieldValue).Value:=FScriptMemo.Lines.Text;
        itTable: begin
          Stream:=TMemoryStream.Create;
          try
            if FImportTableFrame.DataSet.Active then begin
              FImportTableFrame.DataSet.TableName:=FImportTableFrame.EditTableName.Text;
              FImportTableFrame.DataSet.SaveToStream(Stream);
              Stream.Position:=0;
              TBlobField(FImportProvider.FieldByName(SFieldValue)).LoadFromStream(Stream);
            end;
          finally
            Stream.Free;
          end;
        end;
        itFile: FImportProvider.FieldByName(SFieldValue).Value:=LabeledEditFile.Text;
      end;
    finally
      FImportProvider.BeforePost:=ImportProviderBeforePost;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisUtilsForm.DBGridImportDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  OldBrush: TBrush;
  AGrid: TDbGrid;
begin
  AGrid:=TDbGrid(Sender);
  if not (gdFocused in State) and (gdSelected in State) then begin
    OldBrush:=TBrush.Create;
    OldBrush.Assign(AGrid.Canvas.Brush);
    try
      AGrid.Canvas.Brush.Color:=clGray;
      AGrid.Canvas.FillRect(Rect);
      AGrid.Canvas.Font.Color:=clHighlightText;
      AGrid.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
    finally
      AGrid.Canvas.Brush.Assign(OldBrush);
      OldBrush.Free;
    end;
  end else
    AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TBisUtilsForm.ButtonExportClearClick(Sender: TObject);
begin
  FExportProvider.EmptyTable;
  RefreshExportCount;
end;

procedure TBisUtilsForm.ButtonExportLoadClick(Sender: TObject);
var
  P: TBisProvider;
begin
  OpenDialog.FilterIndex:=2;
  if OpenDialog.Execute then begin
    P:=TBisProvider.Create(nil);
    FExportProvider.Last;
    FExportProvider.BeginUpdate(true);
    try
      P.LoadFromFile(OpenDialog.FileName);
      P.Open;
      FExportProvider.CopyRecords(P);
    finally
      FExportProvider.EndUpdate(false);
      FExportProvider.Next;
      P.Free;
    end;
    RefreshExportCount;
  end;
end;

procedure TBisUtilsForm.ButtonExportSaveClick(Sender: TObject);
begin
  SaveDialog.DefaultExt:='.exp';
  SaveDialog.FilterIndex:=2;
  if SaveDialog.Execute then begin
    if FExportProvider.State in [dsEdit,dsInsert] then
      FExportProvider.Post;
    FExportProvider.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TBisUtilsForm.ButtonExportUpClick(Sender: TObject);
begin
  FExportProvider.MoveData(true);
end;

procedure TBisUtilsForm.ButtonExportDownClick(Sender: TObject);
begin
  FExportProvider.MoveData(false);
end;

procedure TBisUtilsForm.ExportProviderAfterPost(DataSet: TDataSet);
begin
  RefreshExportCount;
end;

procedure TBisUtilsForm.RefreshExportCount;
var
  Count: Integer;
begin
  Count:=0;
  if FExportProvider.Active then
    Count:=FExportProvider.RecordCount;
  LabelExportCount.Caption:=FormatEx('�����: %d',[Count]);
  LabelExportCount.Update;
end;

end.
