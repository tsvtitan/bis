unit BisSecureMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisFm, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls,
  Grids, DB, Menus, ClipBrd, DBGrids, Buttons,
  BisObject, BisCmdLine,
  BisLocalBase, BisIfaces, BisDBSynEdit, BisDBHexEdit, BisDBImage, BisDBTable,
  BisControls;

type
  TBisSecureMainForm = class(TBisForm)
    PanelTop: TPanel;
    LabelFile: TLabel;
    EditFile: TEdit;
    ButtonCreate: TButton;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    StatusBar: TStatusBar;
    PanelGrid: TPanel;
    PanelInfo: TPanel;
    Splitter: TSplitter;
    DataSource: TDataSource;
    CheckBoxCrypt: TCheckBox;
    LabelKey: TLabel;
    EditKey: TEdit;
    LabelHash: TLabel;
    EditHash: TEdit;
    LabelAlgorithm: TLabel;
    ComboBoxAlgorithm: TComboBox;
    ButtonNew: TButton;
    PopupMenuNew: TPopupMenu;
    LabelMode: TLabel;
    ComboBoxMode: TComboBox;
    MenuItemNetworkcard: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Grid: TDBGrid;
    GroupBoxValue: TGroupBox;
    PanelValue: TPanel;
    PageControl: TPageControl;
    TabSheetAsText: TTabSheet;
    PanelAsText: TPanel;
    TabSheetAsHex: TTabSheet;
    PanelAsHex: TPanel;
    TabSheetAsImage: TTabSheet;
    PanelAsImage: TPanel;
    TabSheetAsTable: TTabSheet;
    PanelAsTable: TPanel;
    PanelButtonValue: TPanel;
    ButtonLoadValue: TButton;
    ButtonSaveValue: TButton;
    ButtonClearValue: TButton;
    ButtonCreateHex: TButton;
    SaveDialogHex: TSaveDialog;
    TabSheetAsDocument: TTabSheet;
    PanelAsDocument: TPanel;
    ScrollBoxAsImage: TScrollBox;
    ButtonAction: TButton;
    PopupMenuActionText: TPopupMenu;
    PopupMenuActionImage: TPopupMenu;
    PopupMenuActionTable: TPopupMenu;
    PopupMenuActionDocument: TPopupMenu;
    PopupMenuActionHex: TPopupMenu;
    MenuItemTableCreate: TMenuItem;
    ButtonUtils: TButton;
    PopupMenuUtils: TPopupMenu;
    MenuItemUniqueID: TMenuItem;
    MenuItemDecodeLogFile: TMenuItem;
    N1: TMenuItem;
    MenuItemTableValue: TMenuItem;
    MenuItemTableValueLoad: TMenuItem;
    MenuItemTableValueSave: TMenuItem;
    MenuItemTableValueClear: TMenuItem;
    N2: TMenuItem;
    MenuItemTableRecord: TMenuItem;
    MenuItemTableRecordMoveUp: TMenuItem;
    MenuItemTableRecordMoveDown: TMenuItem;
    N3: TMenuItem;
    MenuItemTableValueTable: TMenuItem;
    N21: TMenuItem;
    MenuItemEncodeParam: TMenuItem;
    Button1: TButton;
    MenuItemBase64Encode: TMenuItem;
    btDownColumns: TBitBtn;
    btUpColumns: TBitBtn;
    MenuItemTableEdit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditKeyChange(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure PopupMenuNewPopup(Sender: TObject);
    procedure MenuItemUniqueIDClick(Sender: TObject);
    procedure CheckBoxCryptClick(Sender: TObject);
    procedure ButtonCreateClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonCreateHexClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ButtonClearValueClick(Sender: TObject);
    procedure ButtonLoadValueClick(Sender: TObject);
    procedure ButtonSaveValueClick(Sender: TObject);
    procedure MenuItemTableCreateClick(Sender: TObject);
    procedure ButtonActionClick(Sender: TObject);
    procedure ButtonUtilsClick(Sender: TObject);
    procedure MenuItemNetworkCardClick(Sender: TObject);
    procedure MenuItemDecodeLogFileClick(Sender: TObject);
    procedure MenuItemTableValueClearClick(Sender: TObject);
    procedure MenuItemTableValueLoadClick(Sender: TObject);
    procedure MenuItemTableValueSaveClick(Sender: TObject);
    procedure MenuItemTableRecordMoveUpClick(Sender: TObject);
    procedure MenuItemTableRecordMoveDownClick(Sender: TObject);
    procedure MenuItemTableValueTableClick(Sender: TObject);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure N21Click(Sender: TObject);
    procedure MenuItemEncodeParamClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MenuItemBase64EncodeClick(Sender: TObject);
    procedure btDownColumnsClick(Sender: TObject);
    procedure btUpColumnsClick(Sender: TObject);
    procedure MenuItemTableEditClick(Sender: TObject);
  private
    FActionMenu: TPopupMenu;
    FLocalBase: TBisLocalBase;
    FText: TBisDBSynEdit;
    FHex: TBisDBHexEdit;
    FImage: TBisDBImage;
    FTable: TBisDBTable;
    FSCopyHash: String;
    FSHash: String;
    FSKey: String;
    procedure FillNetworkCards;
    procedure LocalBaseDataSetNewRecord(DataSet: TDataSet);
    procedure PrepareLocalBaseDataSet;
    procedure FieldNameTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FieldNameTypeSetText(Sender: TField; const Text: string);
    procedure LocalBaseDataSetAfterScroll(DataSet: TDataSet);
    procedure LocalBaseDataSetBeforeScroll(DataSet: TDataSet);
    procedure ValueControlsEnabled(AEnabled: Boolean);
    procedure ClearAllPages;
    procedure ActivePageByType;
    procedure LoadFromKeyFile(FileName: String);
  public
    procedure Init; override;
  published
    property SCopyHash: String read FSCopyHash write FSCopyHash;
    property SHash: String read FSHash write FSHash;
    property SKey: String read FSKey write FSKey;   
  end;

  TBisSecureMainFormIface=class(TBisFormIface)
  private
    FKeyFile: String;
  public
    procedure Init; override;
    procedure ShowByCommand(Param: TBisCmdParam; const Command: String); override;
    procedure BeforeFormShow; override;
  end;

var
  BisSecureMainForm: TBisSecureMainForm;

implementation

{$R *.dfm}

uses IpTypes, IPFunctions, SynDBEdit,
     BisSecureConsts, BisCryptUtils, BisCrypter, BisUtils, BisConsts,
     BisMemoFm, BisDialogs,
     BisDBTableEditFm, BisCore, BisBase64, BisDBTableViewFm, BisSecureTableEditFm;

{ TBisSecureMainFormIface }

procedure TBisSecureMainFormIface.Init;
begin
  inherited Init;
  FormClass:=TBisSecureMainForm;
  AutoShow:=true;
  ApplicationCreateForm:=true;
end;

procedure TBisSecureMainFormIface.ShowByCommand(Param: TBisCmdParam; const Command: String);
begin
  FKeyFile:=Param.Next(Command);
  FKeyFile:=ExpandFileNameEx(FKeyFile);
  inherited ShowByCommand(Param,Command);
end;

procedure TBisSecureMainFormIface.BeforeFormShow;
begin
  inherited BeforeFormShow;
  if Assigned(LastForm) then begin
    with TBisSecureMainForm(LastForm) do
      LoadFromKeyFile(FKeyFile);
  end;
end;

{ TBisSecureMainForm }

procedure TBisSecureMainForm.FormCreate(Sender: TObject);
begin
  inherited;

  FLocalBase:=TBisLocalBase.Create(Self);
  FLocalBase.ExceptionEnabled:=true;
  FLocalBase.DataSet.OnNewRecord:=LocalBaseDataSetNewRecord;
  FLocalBase.DataSet.AfterScroll:=LocalBaseDataSetAfterScroll;
  FLocalBase.DataSet.BeforeScroll:=LocalBaseDataSetBeforeScroll;

  FText:=TBisDBSynEdit.Create(Self);
  FText.Parent:=PanelAsText;
  FText.Align:=alClient;
  FText.Gutter.Visible:=false;

  FImage:=TBisDBImage.Create(Self);
  FImage.Parent:=ScrollBoxAsImage;
  FImage.AutoSize:=true;

  FTable:=TBisDBTable.Create(Self);
  FTable.Parent:=PanelAsTable;
  FTable.Align:=alClient;

  FHex:=TBisDBHexEdit.Create(Self);
  FHex.Parent:=PanelAsHex;
  FHex.Align:=alClient;
  FHex.Font.Assign(FText.Font);
  FHex.BytesPerColumn:=1;
  FHex.ShowRuler:=true;
  FHex.DrawGridLines:=true;

  DataSource.DataSet:=FLocalBase.DataSet;

  PageControl.ActivePageIndex:=0;
  PageControlChange(nil);

  FSCopyHash:='Скопировать как хэш?';
  FSHash:='Хэш';
  FSKey:='Ключ';
end;

procedure TBisSecureMainForm.FormDestroy(Sender: TObject);
begin
  FHex.Free;
  FTable.Free;
  FImage.Free;
  FText.Free;
  FLocalBase.Free;
  inherited;
end;

procedure TBisSecureMainForm.GridDrawColumnCell(Sender: TObject;
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

procedure TBisSecureMainForm.Init;
begin
  inherited Init;
  OpenDialog.InitialDir:=ExtractFileDir(Core.CmdLine.FileName);
  SaveDialog.InitialDir:=OpenDialog.InitialDir;
  SaveDialogHex.InitialDir:=OpenDialog.InitialDir;
end;

procedure TBisSecureMainForm.EditKeyChange(Sender: TObject);
var
  FCrypter: TBisCrypter;
begin
  FCrypter:=TBisCrypter.Create;
  try
    FCrypter.DefaultHashAlgorithm:=DefaultHashAlgorithm;
    FCrypter.DefaultHashFormat:=DefaultHashFormat;
    EditHash.Text:=FCrypter.HashString(EditKey.Text);
  finally
    FCrypter.Free;
  end;
end;

procedure TBisSecureMainForm.ButtonNewClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt:=Point(ButtonNew.Left,ButtonNew.Top+ButtonNew.height);
  pt:=PanelTop.ClientToScreen(pt);
  PopupMenuNew.Popup(pt.X,pt.Y);
end;

procedure TBisSecureMainForm.PopupMenuNewPopup(Sender: TObject);
begin
  FillNetworkCards;
  MenuItemNetworkcard.Enabled:=MenuItemNetworkcard.Count>0;
  MenuItemTableValue.Enabled:=Assigned(FTable.SelectedField);
  MenuItemTableRecord.Enabled:=FTable.DataSet.Active and not FTable.DataSet.IsEmpty;
  MenuItemTableValueTable.Enabled:=MenuItemTableValue.Enabled and MenuItemTableRecord.Enabled and
                                   FTable.SelectedField.IsBlob;
end;

procedure TBisSecureMainForm.FillNetworkCards;
var
  PAdapter, PMem: PipAdapterInfo;
  OutBufLen: ULONG;
  S: string;
  Item: TMenuItem;
begin
  VVGetAdaptersInfo(PAdapter, OutBufLen);
  PMem:= PAdapter;
  try
    MenuItemNetworkcard.Clear;
    while Assigned(PAdapter) do begin
      S:=PAdapter.AdapterName;
      S:=PrepareClassID(S);
      Item:=TMenuItem.Create(nil);
      Item.Caption:=PAdapter.Description;
      Item.Hint:=S;
      Item.OnClick:=MenuItemNetworkCardClick;
      MenuItemNetworkcard.Add(Item);
      PAdapter:=PAdapter.Next;
    end;
  finally
    if Assigned(PAdapter) then
      FreeMem(PMem, OutBufLen);
  end;
end;

procedure TBisSecureMainForm.MenuItemNetworkCardClick(Sender: TObject);
var
  S: string;
begin
  with TMenuItem(Sender) do begin
    S:=Hint;
    EditKey.Text:='';
    EditHash.Text:=S;
  end;
end;

procedure TBisSecureMainForm.MenuItemUniqueIDClick(Sender: TObject);
var
  S: String;
begin
  S:=GetUniqueID;
  Clipboard.AsText:=S;
  if InputQuery(TMenuItem(Sender).Caption,FSCopyHash,S) then begin
    EditKey.Text:='';
    EditHash.Text:=S;
  end;
end;

procedure TBisSecureMainForm.CheckBoxCryptClick(Sender: TObject);
begin
  LabelKey.Enabled:=CheckBoxCrypt.Checked;
  EditKey.Enabled:=CheckBoxCrypt.Checked;
  EditKey.Color:=iff(CheckBoxCrypt.Checked,clWindow,clBtnFace);
  LabelHash.Enabled:=CheckBoxCrypt.Checked;
  EditHash.Enabled:=CheckBoxCrypt.Checked;
  EditHash.Color:=iff(CheckBoxCrypt.Checked,clWindow,clBtnFace);
  ButtonNew.Enabled:=CheckBoxCrypt.Checked;
  LabelAlgorithm.Enabled:=CheckBoxCrypt.Checked;
  ComboBoxAlgorithm.Enabled:=CheckBoxCrypt.Checked;
  ComboBoxAlgorithm.Color:=iff(CheckBoxCrypt.Checked,clWindow,clBtnFace);
  LabelMode.Enabled:=CheckBoxCrypt.Checked;
  ComboBoxMode.Enabled:=CheckBoxCrypt.Checked;
  ComboBoxMode.Color:=iff(CheckBoxCrypt.Checked,clWindow,clBtnFace);
  ButtonCreateHex.Enabled:=CheckBoxCrypt.Checked;
end;

procedure TBisSecureMainForm.ButtonCreateClick(Sender: TObject);
begin
  SaveDialog.FileName:='';
  SaveDialog.FilterIndex:=0;
  if SaveDialog.Execute then begin
    with FLocalBase do begin
      CreateEmpty;
      CrypterEnabled:=CheckBoxCrypt.Checked;
      CrypterKey:=EditHash.Text;
      CrypterAlgorithm:=TBisCipherAlgorithm(ComboBoxAlgorithm.ItemIndex);
      CrypterMode:=TBisCipherMode(ComboBoxMode.ItemIndex);
      SaveToFile(SaveDialog.FileName);
    end;
    EditFile.Text:=SaveDialog.FileName;
    PrepareLocalBaseDataSet;
  end;
end;

procedure TBisSecureMainForm.ButtonLoadClick(Sender: TObject);
begin
  OpenDialog.FileName:='';
  OpenDialog.InitialDir:=ExtractFileDir(EditFile.Text);
  OpenDialog.FilterIndex:=1;
  if OpenDialog.Execute then begin
    try
      DataSource.DataSet:=nil;
      FLocalBase.CreateEmpty;
      with FLocalBase do begin
        CrypterEnabled:=CheckBoxCrypt.Checked;
        CrypterKey:=EditHash.Text;
        CrypterAlgorithm:=TBisCipherAlgorithm(ComboBoxAlgorithm.ItemIndex);
        CrypterMode:=TBisCipherMode(ComboBoxMode.ItemIndex);
        LoadFromFile(OpenDialog.FileName);
      end;
      EditFile.Text:=OpenDialog.FileName;
      PrepareLocalBaseDataSet;
      DataSource.DataSet:=FLocalBase.DataSet;
    except
      on E: Exception do begin
        DataSource.DataSet:=nil;
        FLocalBase.DataSet.Close;
        ShowError(E.Message);
      end;
    end;
  end;
end;

procedure TBisSecureMainForm.ButtonSaveClick(Sender: TObject);
begin
  SaveDialog.FileName:=ExtractFileName(EditFile.Text);
  SaveDialog.InitialDir:=ExtractFileDir(EditFile.Text);
  SaveDialog.FilterIndex:=1;
  if FLocalBase.DataSet.Active and SaveDialog.Execute then begin
    with FLocalBase do begin
      if DataSet.State in [dsEdit, dsInsert] then
         DataSet.Post;
      CrypterEnabled:=CheckBoxCrypt.Checked;
      CrypterKey:=EditHash.Text;
      CrypterAlgorithm:=TBisCipherAlgorithm(ComboBoxAlgorithm.ItemIndex);
      CrypterMode:=TBisCipherMode(ComboBoxMode.ItemIndex);
      SaveToFile(SaveDialog.FileName);
    end;  
    EditFile.Text:=SaveDialog.FileName;
  end;
end;

procedure TBisSecureMainForm.ButtonCreateHexClick(Sender: TObject);
var
  ACryptInfo: TBisCryptInfo;
  S: String;
begin
  SaveDialog.FilterIndex:=1;
  if SaveDialogHex.Execute then begin
    SetCryptInfo(ACryptInfo,TBisCipherAlgorithm(ComboBoxAlgorithm.ItemIndex),
                 TBisCipherMode(ComboBoxMode.ItemIndex),EditHash.Text);
    CryptInfoSaveToFile(SaveDialogHex.FileName,ACryptInfo);
    S:=GetHashCryptInfo(ACryptInfo);
    if InputQuery(ButtonCreateHex.Caption,FSHash,S) then begin
      Clipboard.AsText:=S;
    end;
  end;
end;

procedure TBisSecureMainForm.LocalBaseDataSetNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName(SFieldType).AsInteger:=0;
end;

procedure TBisSecureMainForm.PrepareLocalBaseDataSet;
begin
  if FLocalBase.DataSet.Active then
    with FLocalBase.DataSet do begin
      FieldByName(SFieldType).OnGetText:=FieldNameTypeGetText;
      FieldByName(SFieldType).OnSetText:=FieldNameTypeSetText;
      FieldByName(SFieldType).Alignment:=taLeftJustify;
    end
  else
    with FLocalBase.DataSet do begin
      FieldByName(SFieldType).OnGetText:=nil;
      FieldByName(SFieldType).OnSetText:=nil;
      FieldByName(SFieldType).Alignment:=taLeftJustify;
    end;
end;

procedure TBisSecureMainForm.FieldNameTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text:='';
  if not FLocalBase.DataSet.IsEmpty then
    if (Sender.AsInteger>-1) and (Sender.AsInteger<Grid.Columns[2].PickList.Count) then begin
      Text:=Grid.Columns[2].PickList.Strings[Sender.AsInteger];
    end;
end;

procedure TBisSecureMainForm.FieldNameTypeSetText(Sender: TField; const Text: string);
var
  Index: Integer;
begin
  Index:=Grid.Columns[2].PickList.IndexOf(Text);
  if Index<>-1 then begin
    Sender.AsInteger:=Index;
    LocalBaseDataSetAfterScroll(FLocalBase.DataSet);
  end;
end;

procedure TBisSecureMainForm.ValueControlsEnabled(AEnabled: Boolean);
begin
  PageControl.Enabled:=AEnabled;
  ButtonLoadValue.Enabled:=AEnabled;
  ButtonSaveValue.Enabled:=AEnabled;
  ButtonClearValue.Enabled:=AEnabled;
end;

procedure TBisSecureMainForm.LocalBaseDataSetBeforeScroll(DataSet: TDataSet);
begin
  ClearAllPages;
end;

procedure TBisSecureMainForm.LocalBaseDataSetAfterScroll(DataSet: TDataSet);
var
  Index: Integer;
begin
  if DataSet.Active and not DataSet.IsEmpty then begin
    Index:=DataSet.FieldByName(SFieldType).AsInteger;
    if (Index>-1) and (Index<Grid.Columns[2].PickList.Count) then
      PageControl.ActivePageIndex:=Index
    else PageControl.ActivePage:=TabSheetAsText;
    ValueControlsEnabled(true);
  end else begin
    PageControl.ActivePage:=TabSheetAsText;
    ValueControlsEnabled(false);
  end;
  ActivePageByType;
end;

procedure TBisSecureMainForm.ButtonClearValueClick(Sender: TObject);
begin
  with FLocalBase do begin
    if DataSet.Active then begin
      DataSet.Edit;
      DataSet.FieldByName(SFieldValue).Value:=Null;
      DataSet.Post;
    end;
  end;
end;

procedure TBisSecureMainForm.ButtonLoadValueClick(Sender: TObject);
begin
  OpenDialog.FileName:='';
  case PageControl.TabIndex of
    0: OpenDialog.FilterIndex:=5;
    1: OpenDialog.FilterIndex:=3;
    2: OpenDialog.FilterIndex:=4;
    3: OpenDialog.FilterIndex:=5;
    4: OpenDialog.FilterIndex:=5;
  end;
  if OpenDialog.Execute then begin
    with FLocalBase do begin
      if DataSet.Active then begin
        DataSet.Edit;
        TBlobField(DataSet.FieldByName(SFieldValue)).LoadFromFile(OpenDialog.FileName);
        DataSet.Post;
      end;
    end;
  end;
end;

procedure TBisSecureMainForm.ButtonSaveValueClick(Sender: TObject);
begin
  SaveDialog.FileName:='';
  case PageControl.TabIndex of
    0: SaveDialog.FilterIndex:=5;
    1: SaveDialog.FilterIndex:=3;
    2: SaveDialog.FilterIndex:=4;
    3: SaveDialog.FilterIndex:=5;
    4: SaveDialog.FilterIndex:=5;
  end;
  if SaveDialog.Execute then begin
    with FLocalBase do begin
      if DataSet.State in [dsEdit, dsInsert] then
        DataSet.Post;
      if DataSet.Active then begin
        TBlobField(DataSet.FieldByName(SFieldValue)).SaveToFile(SaveDialog.FileName);
      end;
    end;
  end;
end;

procedure TBisSecureMainForm.ButtonUtilsClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt:=Point(ButtonUtils.Left,ButtonUtils.Top+ButtonUtils.height);
  pt:=PanelTop.ClientToScreen(pt);
  PopupMenuUtils.Popup(pt.X,pt.Y);
end;

procedure TBisSecureMainForm.ClearAllPages;
begin
  FText.DataSource:=nil;
  FText.DataField:='';
  FImage.DataSource:=nil;
  FImage.DataField:='';
  FTable.DataSource:=nil;
  FTable.DataField:='';
  FHex.DataSource:=nil;
  FHex.DataField:='';

  FActionMenu:=nil;
  ButtonAction.Enabled:=false;
end;

procedure TBisSecureMainForm.MenuItemDecodeLogFileClick(Sender: TObject);
var
  FCrypter: TBisCrypter;
  StrIn, StrOut: TStringList;
  i: Integer;
begin
  OpenDialog.FilterIndex:=2;
  if OpenDialog.Execute then begin
    StrIn:=TStringList.Create;
    StrOut:=TStringList.Create;
    FCrypter:=TBisCrypter.Create;
    try
      FCrypter.DefaultKey:=Trim(EditHash.Text);
      FCrypter.DefaultCipherAlgorithm:=TBisCipherAlgorithm(ComboBoxAlgorithm.ItemIndex);
      FCrypter.DefaultCipherMode:=TBisCipherMode(ComboBoxMode.ItemIndex);
      FCrypter.DefaultHashAlgorithm:=DefaultHashAlgorithm;
      FCrypter.DefaultHashFormat:=DefaultHashFormat;
      StrIn.LoadFromFile(OpenDialog.FileName);
      for i:=0 to StrIn.Count-1 do begin
        StrOut.Add(Base64ToStr(StrIn[i]));
        StrOut[i]:=FCrypter.DecodeString(StrOut[i]);
      end;
      SaveDialog.FilterIndex:=2;
      if SaveDialog.Execute then
        StrOut.SaveToFile(SaveDialog.FileName);
    finally
      FCrypter.Free;
      StrOut.Free;
      StrIn.Free;
    end;
  end;
end;

procedure TBisSecureMainForm.MenuItemEncodeParamClick(Sender: TObject);

  function EncodeParam(Key: String; AValue: String): String;
  var
    Crypter: TBisCrypter;
  begin
    Crypter:=TBisCrypter.Create;
    try
      Result:=Crypter.EncodeString(Key,AValue,
                                   TBisCipherAlgorithm(ComboBoxAlgorithm.ItemIndex),
                                   TBisCipherMode(ComboBoxMode.ItemIndex));
      Result:=StrToBase64(Result);
    finally
      Crypter.Free;
    end;
  end;

var
  S: String;
  Form: TBisMemoForm;
begin
  if FLocalBase.DataSet.Active and not FLocalBase.DataSet.Empty then
    if InputQuery(TMenuItem(Sender).Caption,FSKey,S) then begin
      Form:=TBisMemoForm.Create(nil);
      try
        Form.Init;
        Form.Memo.Lines.Text:=EncodeParam(S,FLocalBase.DataSet.FieldByName(SFieldValue).AsString);
        if Form.ShowModal=mrOk then begin
          FLocalBase.DataSet.Edit;
          FLocalBase.DataSet.FieldByName(SFieldValue).Value:=Trim(Form.Memo.Lines.Text);
          FLocalBase.DataSet.Post;
        end;
      finally
        Form.Free;
      end;
    end;
end;

procedure TBisSecureMainForm.MenuItemBase64EncodeClick(Sender: TObject);
var
  Form: TBisMemoForm;
begin
  Form:=TBisMemoForm.Create(nil);
  try
    Form.Init;
    Form.Caption:=TMenuItem(Sender).Caption;
    if Form.ShowModal=mrOk then begin
      Form.Memo.Lines.Text:=StrToBase64(Trim(Form.Memo.Lines.Text));
      if Form.ShowModal=mrOk then
        Clipboard.AsText:=Trim(Form.Memo.Lines.Text);
    end;
  finally
    Form.Free;
  end;
end;

procedure TBisSecureMainForm.ActivePageByType;
begin
  case PageControl.ActivePageIndex of
    0: begin
      FText.DataSource:=DataSource;
      FText.DataField:=SFieldValue;
      FActionMenu:=PopupMenuActionText;
    end;
    1: begin
      FImage.DataSource:=DataSource;
      FImage.DataField:=SFieldValue;
      FActionMenu:=PopupMenuActionImage;
    end;
    2: begin
      FTable.DataSource:=DataSource;
      FTable.DataField:=SFieldValue;
      FActionMenu:=PopupMenuActionTable;
    end;
    3: begin

    end;
    4: begin
      FHex.DataSource:=DataSource;
      FHex.DataField:=SFieldValue;
      FActionMenu:=PopupMenuActionHex;
    end;
  end;
  ButtonAction.Enabled:=Assigned(FActionMenu) and (FActionMenu.Items.Count>0);
end;

procedure TBisSecureMainForm.PageControlChange(Sender: TObject);
begin
  if FLocalBase.DataSet.State in [dsEdit, dsInsert] then
    FLocalBase.DataSet.Post;
  ClearAllPages;
  ActivePageByType;
end;


procedure TBisSecureMainForm.MenuItemTableCreateClick(Sender: TObject);
var
  Form: TBisDBTableEditForm;
begin
  Form:=TBisDBTableEditForm.Create(FTable.DataSet);
  try
    FLocalBase.DataSet.Edit;
    if Form.ShowModal=mrOk then begin
      with FLocalBase do begin
        DataSet.Post;
      end;
    end;
  finally
    Form.Free;
  end;
end;

procedure TBisSecureMainForm.MenuItemTableEditClick(Sender: TObject);
var
  Form: TBisSecureTableEditForm;
begin
  Form:=TBisSecureTableEditForm.Create(nil);
  try
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

procedure TBisSecureMainForm.MenuItemTableValueClearClick(Sender: TObject);
begin
  if Assigned(FTable.SelectedField) then begin
    FLocalBase.DataSet.Edit;
    FTable.DataSet.Edit;
    FTable.SelectedField.Clear;
    FTable.DataSet.Post;
    FLocalBase.DataSet.Post;
  end;
end;

procedure TBisSecureMainForm.MenuItemTableValueLoadClick(Sender: TObject);
var
  Ms: TMemoryStream;
  S: String;
begin
  OpenDialog.FileName:='';
  OpenDialog.FilterIndex:=5;
  if OpenDialog.Execute and
     Assigned(FTable.SelectedField) then begin
    Ms:=TMemoryStream.Create;
    try
      Ms.LoadFromFile(OpenDialog.FileName);
      SetLength(S,Ms.Size);
      Ms.ReadBuffer(Pointer(S)^,Ms.Size);
      FLocalBase.DataSet.Edit;
      FTable.DataSet.Edit;
      FTable.SelectedField.AsString:=S;
      FTable.DataSet.Post;
      FLocalBase.DataSet.Post;
    finally
      Ms.Free;
    end;
  end;
end;

procedure TBisSecureMainForm.MenuItemTableValueSaveClick(Sender: TObject);
var
  Ms: TMemoryStream;
  S: String;
begin
  SaveDialog.FileName:='';
  SaveDialog.FilterIndex:=5;
  if SaveDialog.Execute and
     Assigned(FTable.SelectedField) then begin
    Ms:=TMemoryStream.Create;
    try
      S:=FTable.SelectedField.AsString;
      Ms.WriteBuffer(Pointer(S)^,Length(S));
      Ms.SaveToFile(SaveDialog.FileName);
    finally
      Ms.Free;
    end;
  end;
end;

procedure TBisSecureMainForm.btDownColumnsClick(Sender: TObject);
begin
  if FLocalBase.DataSet.Active and not FLocalBase.DataSet.Empty then
    FLocalBase.DataSet.MoveData(false);
end;

procedure TBisSecureMainForm.btUpColumnsClick(Sender: TObject);
begin
  if FLocalBase.DataSet.Active and not FLocalBase.DataSet.Empty then
    FLocalBase.DataSet.MoveData(true);
end;

procedure TBisSecureMainForm.Button1Click(Sender: TObject);
begin
  Core.Audit.Enabled:=not Core.Audit.Enabled;
end;

procedure TBisSecureMainForm.ButtonActionClick(Sender: TObject);
var
  Pt: TPoint;
begin
  if Assigned(FActionMenu) then begin
    Pt:=Point(ButtonAction.Left,ButtonAction.Top+ButtonAction.height);
    Pt:=PanelButtonValue.ClientToScreen(Pt);
    FActionMenu.Popup(Pt.X,Pt.Y);
  end;
end;

procedure TBisSecureMainForm.MenuItemTableRecordMoveDownClick(Sender: TObject);
begin
  if FTable.DataSet.Active and 
     not FTable.DataSet.IsEmpty then begin
    FLocalBase.DataSet.Edit;
    FTable.DataSet.MoveData(false);
    FLocalBase.DataSet.Post;
  end;
end;

procedure TBisSecureMainForm.MenuItemTableRecordMoveUpClick(Sender: TObject);
begin
  if FTable.DataSet.Active and
     not FTable.DataSet.IsEmpty then begin
    FLocalBase.DataSet.Edit;
    FTable.DataSet.MoveData(true);
    FLocalBase.DataSet.Post;
  end;
end;

procedure TBisSecureMainForm.MenuItemTableValueTableClick(Sender: TObject);
var
  Ms: TMemoryStream;
  AForm: TBisDBTableViewForm;
begin
  if Assigned(FTable.SelectedField) and
     FTable.SelectedField.IsBlob then begin
    AForm:=TBisDBTableViewForm.Create(nil);
    Ms:=TMemoryStream.Create;
    try
      TBlobField(FTable.SelectedField).SaveToStream(Ms);
      Ms.Position:=0;
      AForm.DataSet.LoadFromStream(Ms);
      if AForm.ShowModal=mrOk then begin
        FLocalBase.DataSet.Edit;
        FTable.DataSet.Edit;
        Ms.Clear;
        AForm.DataSet.SaveToStream(Ms);
        Ms.Position:=0;
        TBlobField(FTable.SelectedField).LoadFromStream(Ms);
        FTable.DataSet.Post;
        FLocalBase.DataSet.Post;
      end;
    finally
      Ms.Free;
      AForm.Free;
    end;
  end;
end;

procedure TBisSecureMainForm.N21Click(Sender: TObject);
var
  Stream: TMemoryStream;
  AForm: TBisSecureTableEditForm;
begin
  if Assigned(FTable.SelectedField) and
     FTable.SelectedField.IsBlob then begin

    AForm:=TBisSecureTableEditForm.Create(nil);
    Stream:=TMemoryStream.Create;
    try
      if not FTable.SelectedField.IsNull then begin
        TBlobField(FTable.SelectedField).SaveToStream(Stream);
        Stream.Position:=0;
        AForm.TableEdit.DataSet.LoadFromStream(Stream);
        AForm.TableEdit.RefreshCount;
        AForm.TableEdit.SetColumnsColor;
      end;
      if AForm.ShowModal=mrOk then begin
        if AForm.TableEdit.DataSet.Active then begin
          Stream.Clear;
          AForm.TableEdit.DataSet.SaveToStream(Stream);
          Stream.Position:=0;
          FLocalBase.DataSet.Edit;
          FTable.DataSet.Edit;
          TBlobField(FTable.SelectedField).LoadFromStream(Stream);
          FTable.DataSet.Post;
          FLocalBase.DataSet.Post;
        end else begin
          FLocalBase.DataSet.Edit;
          FTable.DataSet.Edit;
          FTable.SelectedField.Value:=Null;
          FTable.DataSet.Post;
          FLocalBase.DataSet.Post;
        end;
      end;
    finally
      Stream.Free;
      AForm.Free;
    end;
  end;
end;

procedure TBisSecureMainForm.LoadFromKeyFile(FileName: String);
var
  ACryptInfo: TBisCryptInfo;
  Algorithm: TBisCipherAlgorithm;
  Mode: TBisCipherMode;
  Key: String;
begin
  if FileExists(FileName) then begin
    EditKey.OnChange:=nil;
    try
      FillChar(ACryptInfo,SizeOf(ACryptInfo),0);
      CryptInfoLoadFromFile(FileName,ACryptInfo);
      GetCryptInfo(ACryptInfo,Algorithm,Mode,Key);
      EditKey.Text:='';
      EditHash.Text:=Key;
      ComboBoxAlgorithm.ItemIndex:=Integer(Algorithm);
      ComboBoxMode.ItemIndex:=Integer(Mode);
    finally
      EditKey.OnChange:=EditKeyChange;
    end;
  end;
end;



end.
