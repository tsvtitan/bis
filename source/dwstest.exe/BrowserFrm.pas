unit BrowserFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, dws2Errors, dws2Exprs, dws2Symbols;

const
  DEF_CAPTION = 'DWS Browser';

type
  TBrowserForm = class(TForm)
    TopPanel: TPanel;
    SymList: TListView;
    BrowseBut: TButton;
    BackBut: TButton;
    HomeBut: TButton;
    procedure BrowseButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SymListDblClick(Sender: TObject);
    procedure BackButClick(Sender: TObject);
  protected
    FRootTab: TSymbolTable;
    Stack: TList;
    procedure BrowseSymTable(SymTable: TSymbolTable; ParSym: TSymbol);
    procedure SetRootTab(const Value: TSymbolTable);
    // Helpers
    function GetSymbolStr(s: TSymbol): string;
    function GetSymClassName(Sym: TSymbol): string;
    function GetFunctionStr(s: TFuncSymbol): string;
    function GetSymTable(Sym: TSymbol): TSymbolTable;
    procedure BrowseSymbol(Sym: TSymbol);
    procedure SelectSymbol(Sym: TSymbol);
  public
    property SymbolTable: TSymbolTable read FRootTab write SetRootTab;
  end;

var
  BrowserForm: TBrowserForm;

implementation

{$R *.dfm}

{ TBrowserForm }

procedure TBrowserForm.SetRootTab(const Value: TSymbolTable);
begin
  FRootTab := Value;
  BrowseSymTable(FRootTab, nil);
end;

procedure TBrowserForm.BrowseSymTable(SymTable: TSymbolTable;
  ParSym: TSymbol);
var
  st: TSymbolTable;
  s: TSymbol;
  i: integer;
  cn, n: string;
  SubCount: string;
  sl: TStringList;
  li: TListItem;
begin
  SymList.Selected := nil;

  if SymTable = nil then
  begin
    st := FRootTab;
    Caption := DEF_CAPTION;
  end
  else
  begin
    st := SymTable;
    Caption := DEF_CAPTION + ' - ' + GetSymbolStr(ParSym);
  end;

  SymList.Items.BeginUpdate;
  SymList.Items.Clear;

  // Use a String List to sort the symbols

  sl := TStringList.Create;

  for i := 0 to st.Count - 1 do
  begin
    s := st.Symbols[i];

    n := s.Name;
    if s is TUnitSymbol then
      n := '_1' + n; // To sort to the top
    if s is TClassSymbol then
      n := '_2' + n;
    if s is TRecordSymbol then
      n := '_3' + n;
    if s is TFuncSymbol then
      n := '_4' + n;

    sl.AddObject(n, s);
  end;

  if (ParSym is TFuncSymbol) = False then
    sl.Sorted := True;

  for i := 0 to sl.Count - 1 do
  begin
    s := sl.Objects[i] as TSymbol;

    cn := GetSymClassName(s);
    n := GetSymbolStr(s);

    // if (s is TUnitSymbol) and (n = 'StdOut') then continue;

    if s is TFuncSymbol then
    begin
      n := GetFunctionStr(TFuncSymbol(s));
    end;

    SubCount := '';
    if GetSymTable(s) <> nil then
      SubCount := IntToStr(GetSymTable(s).Count);

    li := SymList.Items.Add;
    li.Caption := cn;
    li.SubItems.Add(SubCount);
    li.SubItems.Add(n);
    li.Data := s;
  end;

  SymList.Items.EndUpdate;

  sl.Free;
end;

function TBrowserForm.GetSymbolStr(s: TSymbol): string;
begin
  Result := '';
  if s = nil then
    exit;

  Result := s.Name;

  if s.Typ <> nil then
    Result := Result + ': ' + s.Typ.Name;
end;

function TBrowserForm.GetSymClassName(Sym: TSymbol): string;
begin
  Result := Sym.ClassName;

  if Sym is TTypeSymbol then
    Result := 'Type';
  if Sym is TRecordSymbol then
    Result := 'Record';
  if Sym is TClassSymbol then
    Result := 'Class';
  if Sym is TUnitSymbol then
    Result := 'Unit';
  if Sym is TDataSymbol then
    Result := 'Variable';
  if Sym is TConstSymbol then
    Result := 'Constant';
  if Sym is TMemberSymbol then
    Result := 'Member';
  if Sym is TPropertySymbol then
    Result := 'Property';

  if Sym is TFuncSymbol then
  begin
    if TFuncSymbol(Sym).Result <> nil then
    begin
      Result := 'Function';
    end
    else
    begin
      Result := 'Procedure';
    end;
  end;
end;

function TBrowserForm.GetFunctionStr(s: TFuncSymbol): string;
var
  i: integer;
begin
  Result := s.Name;

  for i := 0 to s.Params.Count - 1 do
  begin
    if i = 0 then
      Result := Result + '(';

    if s.Params[i] is TVarParamSymbol then
      Result := Result + 'var ';

    Result := Result + GetSymbolStr(s.Params[i]);

    if i < s.Params.Count - 1 then
      Result := Result + '; ';
    if i = s.Params.Count - 1 then
      Result := Result + ')';
  end;

  if s.Result <> nil then
  begin
    Result := Result + ': ' + s.Result.Typ.Name;
  end;

  Result := Result + ';';

  if s is TMethodSymbol then
  begin
    if TMethodSymbol(s).IsVirtual then
      Result := Result + ' virtual;';
  end;
end;

function TBrowserForm.GetSymTable(Sym: TSymbol): TSymbolTable;
begin
  Result := nil;

  // This case is where a Parameter is a class, e.g. Bitmap: TBitmap.
  // We want to browse the type of the parameter.
  // Do this one first, so that the others can override it.
  if Sym.Typ <> nil then
  begin
    Result := GetSymTable(Sym.Typ);
  end;

  if Sym is TUnitSymbol then
  begin
    Result := TUnitSymbol(Sym).Table;
  end;

  if Sym is TClassSymbol then
  begin
    Result := TClassSymbol(Sym).Members;
  end;

  if Sym is TRecordSymbol then
  begin
    Result := TRecordSymbol(Sym).Members;
  end;

  if Sym is TFuncSymbol then
  begin
    Result := TFuncSymbol(Sym).Params;
  end;

  // If the symbol table is empty, don't allow browsing
  if Result <> nil then
    if Result.Count = 0 then
      Result := nil;
end;

procedure TBrowserForm.BrowseButClick(Sender: TObject);
var
  s: TSymbol;
begin
  if SymList.Selected = nil then
  begin
    ShowMessage('No Symbol Selected');
    exit;
  end;

  s := SymList.Selected.Data;

  BrowseSymbol(s);
end;

procedure TBrowserForm.BrowseSymbol(Sym: TSymbol);
var
  SymTab: TSymbolTable;
begin
  // Only browse symbols that have a SymbolTable

  SymTab := GetSymTable(Sym);
  if SymTab <> nil then
  begin
    Stack.Add(Sym);
    BrowseSymTable(SymTab, Sym);
  end;
end;

procedure TBrowserForm.FormCreate(Sender: TObject);
begin
  Stack := TList.Create;
  BrowserForm := self;
end;

procedure TBrowserForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Stack);
  BrowserForm := nil;
end;

procedure TBrowserForm.SymListDblClick(Sender: TObject);
begin
  BrowseButClick(nil);
end;

procedure TBrowserForm.BackButClick(Sender: TObject);
var
  PrevSym, Sym: TSymbol;
  SymTab: TSymbolTable;
begin
  if Stack.Count > 0 then
  begin
    PrevSym := Stack[Stack.Count - 1];
    Stack.Delete(Stack.Count - 1);

    if Stack.Count > 0 then
    begin
      Sym := Stack[Stack.Count - 1];
      SymTab := GetSymTable(Sym);
    end
    else
    begin
      Sym := nil;
      SymTab := nil;
    end;

    BrowseSymTable(SymTab, Sym);

    SelectSymbol(PrevSym);

    SymList.SetFocus;
  end;
end;

procedure TBrowserForm.SelectSymbol(Sym: TSymbol);
var
  i: integer;
begin
  SymList.Selected := nil;

  for i := 0 to SymList.Items.Count - 1 do
  begin
    if SymList.Items[i].Data = Sym then
      SymList.Selected := SymList.Items[i];
  end;
end;

end.

