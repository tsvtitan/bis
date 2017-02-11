unit BisKrieltExportRtfFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, DBCtrls, ExtCtrls, DB, CheckLst, Menus, ActnPopup,
  BisFm, BisDataEditFm, BisProvider, BisControls;

type
  TBisKrieltExportRtfForm = class(TBisForm)
    LabelPublishing: TLabel;
    LabelView: TLabel;
    LabelType: TLabel;
    LabelOperation: TLabel;
    LabelDateBeginFrom: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    EditView: TEdit;
    ButtonView: TButton;
    EditType: TEdit;
    ButtonType: TButton;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    DateTimePickerBeginFrom: TDateTimePicker;
    LabelDateBeginTo: TLabel;
    DateTimePickerBeginTo: TDateTimePicker;
    PanelPreviewBottom: TPanel;
    ButtonExport: TButton;
    ButtonCancel: TButton;
    ButtonIssue: TButton;
    SaveDialog: TSaveDialog;
    GroupBoxPresentations: TGroupBox;
    CheckListBoxPresentations: TCheckListBox;
    PopupActionBar: TPopupActionBar;
    MenuItemCheckAll: TMenuItem;
    MenuItemUncheckAll: TMenuItem;
    CheckBoxRefresh: TCheckBox;
    N2: TMenuItem;
    MenuItemChange: TMenuItem;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonViewClick(Sender: TObject);
    procedure ButtonPublishingClick(Sender: TObject);
    procedure ButtonTypeClick(Sender: TObject);
    procedure ButtonOperationClick(Sender: TObject);
    procedure ButtonIssueClick(Sender: TObject);
    procedure ButtonExportClick(Sender: TObject);
    procedure CheckListBoxPresentationsClickCheck(Sender: TObject);
    procedure MenuItemCheckAllClick(Sender: TObject);
    procedure MenuItemUncheckAllClick(Sender: TObject);
    procedure EditPublishingKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopupActionBarPopup(Sender: TObject);
    procedure MenuItemChangeClick(Sender: TObject);
    procedure CheckListBoxPresentationsDblClick(Sender: TObject);
  private
    FPublishingId: Variant;
    FViewId: Variant;
    FTypeId: Variant;
    FOperationId: Variant;
    FIssueId: Variant;
    procedure RefreshPresentations;
    function GetCheckedCount: Integer;
    function RefreshPresentation(APresentationId: Variant): Boolean;
    procedure UpdateCheckListBox;
    procedure ExportToFile(const FileName: String);
    procedure PresentaionIfaceAfterExecute(Sender: TBisDataEditForm);
  public

    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltExportRtfFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltExportRtfForm: TBisKrieltExportRtfForm;

implementation

uses DateUtils, StrUtils,
     BisUtils, BisFilterGroups, BisDialogs,
     BisKrieltDataViewsFm, BisKrieltDataOperationsFm,
     BisKrieltDataPublishingFm, BisKrieltDataTypesFm, BisKrieltDataIssuesFm,
     BisKrieltDataPresentationEditFm, BisPeriodFm, BisRtfStream, BisVariants,
     BisParam;

{$R *.dfm}

type

  TPresentationInfo=class(TObject)
  var
    PresentationId: Variant;
    TableName: String;
    Pattern: String;
//    ExportMode: TBisKrieltDataPresentationExportMode;
    PublishingId: Variant;
    ViewId: Variant;
    TypeId: Variant;
    OperationId: Variant;
    Refreshed: Boolean;
  end;

{ TBisKrieltExportRtfFormIface }

constructor TBisKrieltExportRtfFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltExportRtfForm;
//  Available:=true;
  Permissions.Enabled:=true;
  OnlyOneForm:=false;
end;

{ TBisKrieltExportRtfForm }

constructor TBisKrieltExportRtfForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  FPublishingId:=Null;
  FViewId:=Null;
  FTypeId:=Null;
  FOperationId:=Null;
  FIssueId:=Null;
  DateTimePickerBeginFrom.Date:=DateOf(Date);
  DateTimePickerBeginTo.Date:=DateOf(Date);
  RefreshPresentations;
end;

procedure TBisKrieltExportRtfForm.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TBisKrieltExportRtfForm.ButtonOperationClick(Sender: TObject);
var
  AIface: TBisKrieltDataOperationsFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataOperationsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='OPERATION_ID';
    AIface.LocateValues:=FOperationId;
    if AIface.SelectInto(P) then begin
      FOperationId:=P.FieldByName('OPERATION_ID').Value;
      EditOperation.Text:=P.FieldByName('NAME').AsString;
      RefreshPresentations;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltExportRtfForm.ButtonPublishingClick(Sender: TObject);
var
  AIface: TBisKrieltDataPublishingFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataPublishingFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='PUBLISHING_ID';
    AIface.LocateValues:=FPublishingId;
    if AIface.SelectInto(P) then begin
      FPublishingId:=P.FieldByName('PUBLISHING_ID').Value;
      EditPublishing.Text:=P.FieldByName('NAME').AsString;
      RefreshPresentations;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltExportRtfForm.ButtonTypeClick(Sender: TObject);
var
  AIface: TBisKrieltDataTypesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataTypesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='TYPE_ID';
    AIface.LocateValues:=FTypeId;
    if AIface.SelectInto(P) then begin
      FTypeId:=P.FieldByName('TYPE_ID').Value;
      EditType.Text:=P.FieldByName('NAME').AsString;
      RefreshPresentations;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltExportRtfForm.ButtonViewClick(Sender: TObject);
var
  AIface: TBisKrieltDataViewsFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataViewsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='VIEW_ID';
    AIface.LocateValues:=FViewId;
    if AIface.SelectInto(P) then begin
      FViewId:=P.FieldByName('VIEW_ID').Value;
      EditView.Text:=P.FieldByName('NAME').AsString;
      RefreshPresentations;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltExportRtfForm.ButtonExportClick(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    UpdateCheckListBox;
    ExportToFile(SaveDialog.FileName);
  end;
end;

procedure TBisKrieltExportRtfForm.UpdateCheckListBox;
var
  i: Integer;
  Info: TPresentationInfo; 
begin
  for i:=0 to CheckListBoxPresentations.Items.Count-1 do begin
    Info:=TPresentationInfo(CheckListBoxPresentations.Items.Objects[i]);
    Info.Refreshed:=false;
  end;
end;

procedure TBisKrieltExportRtfForm.ButtonIssueClick(Sender: TObject);
var
  AIface: TBisKrieltDataIssuesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataIssuesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='ISSUE_ID';
    AIface.LocateValues:=FIssueId;
    AIface.FilterGroups.Add.Filters.Add('PUBLISHING_ID',fcEqual,FPublishingId);
    if AIface.SelectInto(P) then begin
      FIssueId:=P.FieldByName('ISSUE_ID').Value;
      DateTimePickerBeginFrom.Date:=DateOf(P.FieldByName('DATE_BEGIN').AsDateTime);
      DateTimePickerBeginTo.Date:=DateOf(P.FieldByName('DATE_END').AsDateTime);
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltExportRtfForm.RefreshPresentations;
var
  P: TBisProvider;
  Obj: TPresentationInfo;
  ATableName: String;
begin
  ClearStrings(CheckListBoxPresentations.Items);
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_PRESENTATIONS';
    with P.FieldNames do begin
      AddInvisible('PRESENTATION_ID');
      AddInvisible('NAME');
      AddInvisible('TABLE_NAME');
      AddInvisible('PATTERN');
      AddInvisible('EXPORT_MODE');
      AddInvisible('PUBLISHING_ID');
      AddInvisible('VIEW_ID');
      AddInvisible('TYPE_ID');
      AddInvisible('OPERATION_ID');
    end;
    if not VarIsNull(FPublishingId) or not VarIsNull(FViewId) or
       not VarIsNull(FTypeId) or not not VarIsNull(FOperationId) then begin
      with P.FilterGroups.Add do begin
        if not VarIsNull(FPublishingId) then Filters.Add('PUBLISHING_ID',fcEqual,FPublishingId);
        if not VarIsNull(FViewId) then Filters.Add('VIEW_ID',fcEqual,FViewId);
        if not VarIsNull(FTypeId) then Filters.Add('TYPE_ID',fcEqual,FTypeId);
        if not VarIsNull(FOperationId) then Filters.Add('OPERATION_ID',fcEqual,FOperationId);
        Filters.Add('PRESENTATION_TYPE',fcEqual,ptExportRtf);
        Filters.Add('TABLE_NAME',fcIsNotNull,Null);
      end;
    end;
    P.Open;
    if P.Active and not P.IsEmpty then begin
      P.First;
      while not P.Eof do begin
        ATableName:=P.FieldByName('TABLE_NAME').AsString;
        if Trim(ATableName)<>'' then begin
          Obj:=TPresentationInfo.Create;
          Obj.PresentationId:=P.FieldByName('PRESENTATION_ID').Value;
          Obj.Pattern:=P.FieldByName('PATTERN').AsString;
          Obj.TableName:=ATableName;
//          Obj.ExportMode:=TBisKrieltDataPresentationExportMode(P.FieldByName('EXPORT_MODE').AsInteger);
          Obj.PublishingId:=P.FieldByName('PUBLISHING_ID').Value;
          Obj.ViewId:=P.FieldByName('VIEW_ID').Value;
          Obj.TypeId:=P.FieldByName('TYPE_ID').Value;
          Obj.OperationId:=P.FieldByName('OPERATION_ID').Value;
          Obj.Refreshed:=false;
          CheckListBoxPresentations.Items.AddObject(P.FieldByName('NAME').AsString,Obj);
        end;
        P.Next;
      end;
    end;
  finally
    P.Free;
  end;
end;

function TBisKrieltExportRtfForm.GetCheckedCount: Integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to CheckListBoxPresentations.Count-1 do begin
    if CheckListBoxPresentations.Checked[i] then
      Inc(Result);
  end;
end;

procedure TBisKrieltExportRtfForm.PresentaionIfaceAfterExecute(Sender: TBisDataEditForm);
var
  Info: TPresentationInfo;
begin
  if CheckListBoxPresentations.ItemIndex<>-1 then begin
    Info:=TPresentationInfo(CheckListBoxPresentations.Items.Objects[CheckListBoxPresentations.ItemIndex]);
    if Assigned(Info) then begin
      if Sender.Provider.Success then begin
        with Sender.Provider.Params do begin
          Info.TableName:=ParamByName('TABLE_NAME').AsString;
          Info.Pattern:=ParamByName('PATTERN').AsString;
//          Info.ExportMode:=TBisKrieltDataPresentationExportMode(ParamByName('EXPORT_MODE').AsInteger);
          Info.PublishingId:=ParamByName('PUBLISHING_ID').Value;
          Info.ViewId:=ParamByName('VIEW_ID').Value;
          Info.TypeId:=ParamByName('TYPE_ID').Value;
          Info.OperationId:=ParamByName('OPERATION_ID').Value;
          Info.Refreshed:=false;
        end;
      end;
    end;
  end;
end;

procedure TBisKrieltExportRtfForm.MenuItemChangeClick(Sender: TObject);
var
  P: TBisProvider;
  Info: TPresentationInfo;
  Iface: TBisKrieltDataPresentationUpdateFormIface;
begin
  if CheckListBoxPresentations.ItemIndex<>-1 then begin
    Info:=TPresentationInfo(CheckListBoxPresentations.Items.Objects[CheckListBoxPresentations.ItemIndex]);
    if Assigned(Info) then begin
      P:=TBisProvider.Create(nil);
      Iface:=TBisKrieltDataPresentationUpdateFormIface.Create(nil);
      try
        P.ProviderName:='S_PRESENTATIONS';
        P.FilterGroups.Add.Filters.Add('PRESENTATION_ID',fcEqual,Info.PresentationId);
        P.Open;
        Iface.ParentProvider:=P;
        Iface.OnAfterExecute:=PresentaionIfaceAfterExecute;
        Iface.Init;
        Iface.Mode:=emUpdate;
        Iface.AsModal:=true;
        Iface.Execute;
      finally
        Iface.Free;
        P.Free;
      end;
    end;
  end;
end;

procedure TBisKrieltExportRtfForm.MenuItemCheckAllClick(Sender: TObject);
var
  i: Integer;
begin
  CheckListBoxPresentations.Items.BeginUpdate;
  try
    for i:=0 to CheckListBoxPresentations.Items.Count-1 do begin
      CheckListBoxPresentations.Checked[i]:=true;
    end;
  finally
    CheckListBoxPresentations.Items.EndUpdate;
  end;
end;

procedure TBisKrieltExportRtfForm.MenuItemUncheckAllClick(Sender: TObject);
var
  i: Integer;
begin
  CheckListBoxPresentations.Items.BeginUpdate;
  try
    for i:=0 to CheckListBoxPresentations.Items.Count-1 do begin
      CheckListBoxPresentations.Checked[i]:=false;
    end;
  finally
    CheckListBoxPresentations.Items.EndUpdate;
  end;
end;

procedure TBisKrieltExportRtfForm.PopupActionBarPopup(Sender: TObject);
begin
  MenuItemChange.Enabled:=CheckListBoxPresentations.ItemIndex<>-1;
end;

procedure TBisKrieltExportRtfForm.CheckListBoxPresentationsClickCheck(
  Sender: TObject);
begin
  ButtonExport.Enabled:=GetCheckedCount>0;
end;

procedure TBisKrieltExportRtfForm.CheckListBoxPresentationsDblClick(
  Sender: TObject);
begin
  MenuItemChangeClick(nil);
end;

procedure TBisKrieltExportRtfForm.EditPublishingKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_DELETE,VK_BACK]) and
     (TEdit(Sender).SelLength=Length(TEdit(Sender).Text)) then begin
    TEdit(Sender).Text:='';
    if Sender=EditPublishing then FPublishingId:=Null;
    if Sender=EditView then FViewId:=Null;
    if Sender=EditType then FTypeId:=Null;
    if Sender=EditOperation then FOperationId:=Null;
    RefreshPresentations;
  end;
end;

function TBisKrieltExportRtfForm.RefreshPresentation(APresentationId: Variant): Boolean;
var
  P: TBisProvider;
begin
  Result:=true;
  if CheckBoxRefresh.Checked then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='R_PRESENTATION';
      P.Params.AddInvisible('PRESENTATION_ID').Value:=APresentationId;
      P.Execute;
      Result:=P.Success;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisKrieltExportRtfForm.ExportToFile(const FileName: String);
var
  Stream: TBisRtfStream;
  Info: TPresentationInfo;
  FontPublishing: TFont;
  FontView: TFont;
  FontOperation: TFont;
  FontType: TFont;
  FontPresentation: TFont;
  FontRoom: TFont;
  FontRegion: TFont;
  AllCount: Integer;

type
  TExportPresentationFilter=(epfNone,epfKrasnoyark,epfOther);

const
  SKrasnoyarsk='Красноярск г.';
  SOther='другие нас.пункты';
  SFieldNamePoint='Нас.пункт3';
  SFieldNameRegion='Район3';
  SFieldNameRoom='Комнатность3';

  function GetFirst(S: String): String;
  var
    i: Integer;
  begin
    Result:='';
    for i:=1 to Length(S) do begin
      Result:=Result+S[i];
      if S[i] in [' ',','] then
        break;
    end;
  end;

  function TrimToOne(S: String): String;
  var
    I: Integer;
  begin
    Result:='';
    for i:=1 to Length(S) do begin
      if i=1 then begin
        Result:=S[i];
      end else begin
        if (S[i]<>' ') then
          Result:=Result+S[i]
        else
          if (S[i-1]<>' ') then
            Result:=Result+s[i];
      end;
    end;
  end;

  function DeleteLast(S: String): String;
  begin
    Result:=S;
    if Length(S)>1 then begin
      if S[Length(S)] in [','] then
        Result:=Copy(S,1,Length(S)-1);
    end;
    
  end;

  procedure ExportPresentation(APublishingId,AViewId,AOperationId,ATypeId: Variant;
                               AFilter: TExportPresentationFilter; Strings: TStringList;
                               AFilterGroups: TBisFilterGroups=nil);
  var
    P: TBisProvider;
    S,S1: String;
    i: Integer;
    Field: TField;
    V: String;
    TagFirst, TagLast: String;
    APos1, APos2: Integer;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:=Info.TableName;
      if Assigned(AFilterGroups) then
        P.FilterGroups.CopyFrom(AFilterGroups);
      with P.FilterGroups.Add do begin
        Filters.Add('PUBLISHING_ID',fcEqual,APublishingId);
        Filters.Add('VIEW_ID',fcEqual,AViewId);
        Filters.Add('TYPE_ID',fcEqual,ATypeId);
        Filters.Add('OPERATION_ID',fcEqual,AOperationId);
        Filters.Add('DATE_BEGIN',fcEqualGreater,DateOf(DateTimePickerBeginFrom.Date));
        Filters.Add('DATE_BEGIN',fcLess,DateOf(IncDay(DateTimePickerBeginTo.Date)));
        case AFilter of
          epfNone:;
          epfKrasnoyark: Filters.Add(SFieldNamePoint,fcEqual,SKrasnoyarsk);
          epfOther: Filters.Add(SFieldNamePoint,fcNotEqual,SKrasnoyarsk);
        end;
      end;
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          S:=Info.Pattern;
          for i:=0 to P.FieldCount-1 do begin
            Field:=P.Fields[i];
            V:=Trim(Field.AsString);
            TagFirst:='<'+Field.FieldName+'>';
            TagLast:='</'+Field.FieldName+'>';
            APos1:=-1;
            while APos1<>0 do begin
              APos1:=AnsiPos(TagFirst,S);
              APos2:=AnsiPos(TagLast,S);
              if (APos1>0) and (APos2>0) then begin
                S1:=Copy(S,APos1+Length(TagFirst),APos2-APos1-Length(TagFirst));
                if V<>'' then
                  S1:=ReplaceText(S1,'%',V)
                else S1:='';
                S:=Copy(S,1,APos1-1)+S1+Copy(S,APos2+Length(TagLast),Length(S));
              end;
            end;
          end;
          S:=TrimToOne(Trim(S));
          S:=DeleteLast(S);
          Strings.Add(S);
          P.Next;
        end;
      end;
    finally
      P.Free;
    end;
  end;

  procedure ExportPresentations(APublishingId,AViewId,AOperationId,ATypeId: Variant;
                                AFilter: TExportPresentationFilter; AFilterGroups: TBisFilterGroups=nil);
  var
    i: integer;
    Str: TStringList;
    S1,S2: String;
    Flag: Boolean;
  begin
    Str:=TStringList.Create;
    try
      for i:=0 to CheckListBoxPresentations.Items.Count-1 do begin
        Info:=TPresentationInfo(CheckListBoxPresentations.Items.Objects[i]);
        if CheckListBoxPresentations.Checked[i] then begin
          if not Info.Refreshed then
            Info.Refreshed:=RefreshPresentation(Info.PresentationId);
          Flag:=VarIsNull(Info.PublishingId) or VarIsNull(Info.ViewId) or VarIsNull(Info.TypeId) or VarIsNull(Info.OperationId);
          if not Flag then
            Flag:=VarSameValue(Info.PublishingId,APublishingId) and VarSameValue(Info.ViewId,AViewId) and
                  VarSameValue(Info.TypeId,ATypeId) and VarSameValue(Info.OperationId,AOperationId);
          if Flag then
            ExportPresentation(APublishingId,AViewId,AOperationId,ATypeId,AFilter,Str,AFilterGroups);
        end;
      end;
      Inc(AllCount,Str.Count);
      Str.Sort;
      for i:=0 to Str.Count-1 do begin
        S1:=GetFirst(Str[i]);
        S2:=Copy(Str[i],Length(S1)+1,Length(Str[i]));
        FontPresentation.Style:=[fsBold];
        Stream.CreateString(S1,FontPresentation,false);
        FontPresentation.Style:=[];
        Stream.CreateString(S2,FontPresentation,true);
      end;
    finally
      Str.Free;
    end;
  end;

  function GetFirstChecked: TPresentationInfo;
  var
    i: Integer;
  begin
    Result:=nil;
    for i:=0 to CheckListBoxPresentations.Items.Count-1 do begin
      if CheckListBoxPresentations.Checked[i] then begin
        Result:=TPresentationInfo(CheckListBoxPresentations.Items.Objects[i]);
        break;
      end;
    end;
  end;

  procedure ExportPresentationsByRegion(APublishingId,AViewId,AOperationId,ATypeId: Variant;
                                        AFilter: TExportPresentationFilter; AFilterGroups: TBisFilterGroups=nil);
  var
    P: TBisProvider;
    S: String;
    Export: String;
    FilterGroups: TBisFilterGroups;
  begin
    P:=TBisProvider.Create(nil);
    FilterGroups:=TBisFilterGroups.Create;
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_PARAM_VALUE_DEPENDS';
      with P.FieldNames do begin
        AddInvisible('WHAT_PARAM_VALUE_NAME');
        AddInvisible('WHAT_PARAM_VALUE_EXPORT');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('FROM_PARAM_ID',fcEqual,'E774322A3928ADC74A75A4E8815D6C4A'); // Населенный пункт
        Filters.Add('WHAT_PARAM_ID',fcEqual,'0538CA0399AB9FA9468D1A4741BA5090'); // Район населенного пункта
        Filters.Add('FROM_PARAM_VALUE_NAME',fcEqual,SKrasnoyarsk);
      end;
      P.Orders.Add('WHAT_PRIORITY');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          S:=P.FieldByName('WHAT_PARAM_VALUE_NAME').AsString;
          Export:=P.FieldByName('WHAT_PARAM_VALUE_EXPORT').AsString;
          if Trim(Export)='' then
            Stream.CreateString(S,FontRegion,true)
          else
            Stream.CreateString(Export,FontRegion,true);
          FilterGroups.Clear;
          if Assigned(AFilterGroups) then
            FilterGroups.CopyFrom(AFilterGroups);
          FilterGroups.Add.Filters.Add(SFieldNameRegion,fcEqual,S);
          ExportPresentations(APublishingId,AViewId,AOperationId,ATypeId,AFilter,FilterGroups);
          P.Next;
        end;
      end;
    finally
      FilterGroups.Free;
      P.Free;
    end;
  end;

  procedure ExportPresentationByRoomRegion(APublishingId,AViewId,AOperationId,ATypeId: Variant;
                                           AFilter: TExportPresentationFilter);
  var
    P: TBisProvider;
    S: String;
    Export: String;
    FilterGroups: TBisFilterGroups;
  begin
    P:=TBisProvider.Create(nil);
    FilterGroups:=TBisFilterGroups.Create;
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_PARAM_VALUES';
      with P.FieldNames do begin
        AddInvisible('NAME');
        AddInvisible('DESCRIPTION');
        AddInvisible('EXPORT');
      end;
      P.FilterGroups.Add.Filters.Add('PARAM_ID',fcEqual,'CE659B2F7353BD004164E11CF5B84711'); // Комнатность
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          S:=P.FieldByName('DESCRIPTION').AsString;
          Export:=P.FieldByName('EXPORT').AsString;
          Stream.CreateString(S,FontRoom,true);
          FilterGroups.Clear;
          if Trim(Export)='' then
            FilterGroups.Add.Filters.Add(SFieldNameRoom,fcEqual,P.FieldByName('NAME').AsString)
          else
            FilterGroups.Add.Filters.Add(SFieldNameRoom,fcEqual,Export);
          ExportPresentationsByRegion(APublishingId,AViewId,AOperationId,ATypeId,AFilter,FilterGroups);
          P.Next;
        end;
      end;
    finally
      FilterGroups.Free;
      P.Free;
    end;
  end;

  procedure ExportPresentationsByMode(APublishingId,AViewId,AOperationId,ATypeId: Variant;
                                      AFilter: TExportPresentationFilter);
  var
    First: TPresentationInfo;
  begin
    First:=GetFirstChecked;
    if Assigned(First) then begin
{      case First.ExportMode of
        pemNone: ExportPresentations(APublishingId,AViewId,AOperationId,ATypeId,AFilter);
        pemRegion: begin
          if AFilter=epfKrasnoyark then
            ExportPresentationsByRegion(APublishingId,AViewId,AOperationId,ATypeId,AFilter)
          else
            ExportPresentations(APublishingId,AViewId,AOperationId,ATypeId,AFilter);
        end;
        pemRoomRegion: begin
          if AFilter=epfKrasnoyark then
            ExportPresentationByRoomRegion(APublishingId,AViewId,AOperationId,ATypeId,AFilter)
          else
            ExportPresentations(APublishingId,AViewId,AOperationId,ATypeId,AFilter);
        end;
      end;}
    end;
  end;

  procedure ExportTypes(APublishingId,AViewId,AOperationId: Variant);
  var
    P: TBisProvider;
    S: String;
    ATypeId: Variant;
    ListNotDouble: TBisVariants;
  begin
    P:=TBisProvider.Create(nil);
    ListNotDouble:=TBisVariants.Create;
    try
      ListNotDouble.Add('05664883F8CDA186426C87A4438DD365'); // Земля за насел. пунктом
      P.ProviderName:='S_VIEW_TYPES';
      if not VarIsNull(FTypeId) then
        P.FilterGroups.Add.Filters.Add('TYPE_ID',fcEqual,FTypeId);
      P.FilterGroups.Add.Filters.Add('VIEW_ID',fcEqual,AViewId);
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          S:=P.FieldByName('TYPE_NAME').AsString;
          ATypeId:=P.FieldByName('TYPE_ID').Value;
          if not Assigned(ListNotDouble.Find(ATypeId)) then begin
            Stream.CreateString(Format('%s %s',[S,SKrasnoyarsk]),FontType,true);
            ExportPresentationsByMode(APublishingId,AViewId,AOperationId,ATypeId,epfKrasnoyark);
            Stream.CreateString(Format('%s %s',[S,SOther]),FontType,true);
            ExportPresentationsByMode(APublishingId,AViewId,AOperationId,ATypeId,epfOther);
          end else begin
            Stream.CreateString(S,FontType,true);
            ExportPresentationsByMode(APublishingId,AViewId,AOperationId,ATypeId,epfNone);
          end;
          P.Next;
        end;
      end;
    finally
      ListNotDouble.Free;
      P.Free;
    end;
  end;

  procedure ExportOperations(APublishingId,AViewId: Variant);
  var
    P: TBisProvider;
    S: String;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_OPERATIONS';
      if not VarIsNull(FOperationId) then
        P.FilterGroups.Add.Filters.Add('OPERATION_ID',fcEqual,FOperationId);
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          S:=P.FieldByName('NAME').AsString;
          Stream.CreateString(S,FontOperation,true);
          ExportTypes(APublishingId,AViewId,P.FieldByName('OPERATION_ID').Value);
          P.Next;
        end;
      end;
    finally
      P.Free;
    end;
  end;

  procedure ExportViews(APublishingId: Variant);
  var
    P: TBisProvider;
    S: String;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_VIEWS';
      if not VarIsNull(FViewId) then
        P.FilterGroups.Add.Filters.Add('VIEW_ID',fcEqual,FViewId);
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          S:=P.FieldByName('NAME').AsString;
          Stream.CreateString(S,FontView,true);
          ExportOperations(APublishingId,P.FieldByName('VIEW_ID').Value);
          P.Next;
        end;
      end;
    finally
      P.Free;
    end;
  end;

  procedure ExportPublishing;
  var
    P: TBisProvider;
    S: String;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_PUBLISHING';
      if not VarIsNull(FPublishingId) then
        P.FilterGroups.Add.Filters.Add('PUBLISHING_ID',fcEqual,FPublishingId);
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          S:=P.FieldByName('NAME').AsString;
          Stream.CreateString(S,FontPublishing,true);
          ExportViews(P.FieldByName('PUBLISHING_ID').Value);
          P.Next;
        end;
      end;
    finally
      P.Free;
    end;
  end;

var
  OldCursor: TCursor;
  Breaked: Boolean;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  Progress(0,0,0,Breaked);
  Stream:=TBisRtfStream.Create;
  FontPublishing:=TFont.Create;
  FontView:=TFont.Create;
  FontOperation:=TFont.Create;
  FontType:=TFont.Create;
  FontPresentation:=TFont.Create;
  FontRoom:=TFont.Create;
  FontRegion:=TFont.Create;
  try
    Stream.Open;
    Stream.CreateHeader;
    Stream.OpenBody;

    FontPublishing.Size:=18;
    FontPublishing.Name:='MS Sans Serif';
    FontPublishing.Color:=clBlue;
    FontPublishing.Style:=[];

    FontView.Size:=11;
    FontView.Name:='Times New Roman';
    FontView.Color:=clNavy;
    FontView.Style:=[fsBold];

    FontOperation.Size:=10;
    FontOperation.Name:='Times New Roman';
    FontOperation.Color:=clRed;
    FontOperation.Style:=[fsBold];

    FontType.Size:=8;
    FontType.Name:='Times New Roman';
    FontType.Color:=clMaroon;
    FontType.Style:=[fsBold];

    FontPresentation.Size:=8;
    FontPresentation.Name:='MS Sans Serif';
    FontPresentation.Color:=clGray;

    FontRoom.Size:=8;
    FontRoom.Name:='MS Sans Serif';
    FontRoom.Color:=clBlack;
    FontRoom.Style:=[fsBold];

    FontRegion.Size:=8;
    FontRegion.Name:='MS Sans Serif';
    FontRegion.Color:=clBlack;
    FontRegion.Style:=[];

    AllCount:=0;

    ExportPublishing;

    Stream.CloseBody;
    Stream.Close;
    Stream.SaveToFile(FileName);

  finally
    FontPublishing.Free;
    FontView.Free;
    FontOperation.Free;
    FontType.Free;
    FontPresentation.Free;
    FontRoom.Free;
    FontRegion.Free;
    Stream.Free;
    Progress(0,0,0,Breaked);
    Screen.Cursor:=OldCursor;
  end;

  ShowInfo(Format('Экспортировано %d записей.',[AllCount]));
end;

end.
