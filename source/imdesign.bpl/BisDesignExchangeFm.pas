unit BisDesignExchangeFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ActnList, ImgList, ComCtrls, DB,
  VirtualTrees,
  BisFm, BisExecuteFm, BisDataSet, BisDbTree, BisFieldNames,
  BisDataTreeFrm;

type
  TBisDesignExchangeStepType=(estExchange,
                              estSourceConnect,estSourceBefore,estSourceBeforeStep,
                              estDestinationConnect,estDestinationBefore,estDestinationBeforeStep,
                              estExchangeScript,estExchangeScriptStep,
                              estDestinationAfter,estDestinationAfterStep,estDestinationDisconnect,
                              estSourceAfter,estSourceAfterStep,estSourceDisconnect);

  TBisDesignExchangeForm = class(TBisExecuteForm)
    DataSource: TDataSource;
    ActionInfo: TAction;
    ProgressBar: TProgressBar;
    procedure ActionInfoExecute(Sender: TObject);
    procedure ActionInfoUpdate(Sender: TObject);                                   
  private
    FPosition: Integer;
    FMax: Integer;
    FDataSet: TBisDataSet;
    FTemp: TBisDataSet;
    FTree: TBisDBTree;
    FSSourceConnect: String;
    FSSourceBefore: String;
    FSDestinationConnect: String;
    FSDestinationBefore: String;
    FSDestinationAfter: String;
    FSDestinationDisconnect: String;
    FSSourceAfter: String;
    FSSourceDisconnect: String;
    FSExchangeScript: String;
    FSDestinationNotEqualSource: String;
    FSDestinationNotFound: String;
    FSSourceNotFound: String;
    procedure RefreshDataSet;
    procedure SyncDataSet;
    procedure SyncProgress;
    procedure ParseScript(Script: String; DS: TBisDataSet; Begins: TStringList);
    procedure GridDblClick(Sender: TObject);
    procedure ProgressVisible(AVisible: Boolean);
    function GetPeriod(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    function Execute(Thread: TBisExecuteFormThread): Boolean; override;
    procedure DoEnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanStart: Boolean; override;
    procedure Start; override;
    function CanInfo: Boolean;
    procedure Info;
  published
    property SSourceConnect: String read FSSourceConnect write FSSourceConnect;
    property SSourceBefore: String read FSSourceBefore write FSSourceBefore;
    property SSourceAfter: String read FSSourceAfter write FSSourceAfter;
    property SSourceDisconnect: String read FSSourceDisconnect write FSSourceDisconnect;
    property SExchangeScript: String read FSExchangeScript write FSExchangeScript;
    property SDestinationConnect: String read FSDestinationConnect write FSDestinationConnect;
    property SDestinationBefore: String read FSDestinationBefore write FSDestinationBefore;
    property SDestinationAfter: String read FSDestinationAfter write FSDestinationAfter;
    property SDestinationDisconnect: String read FSDestinationDisconnect write FSDestinationDisconnect;
    property SDestinationNotEqualSource: String read FSDestinationNotEqualSource write FSDestinationNotEqualSource;
    property SDestinationNotFound: String read FSDestinationNotFound write FSDestinationNotFound;
    property SSourceNotFound: String read FSSourceNotFound write FSSourceNotFound;
  end;

  TBisDesignExchangeFormIface=class(TBisExecuteFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignExchangeForm: TBisDesignExchangeForm;

implementation

{$R *.dfm}

uses BisProvider, BisFilterGroups, BisConnections,
     BisCore, BisConnectionModules, BisUtils, BisLogger, BisMemoFm;

{ TBisDesignExchangeFormIface }

constructor TBisDesignExchangeFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignExchangeForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
end;

{ TBisDesignExchangeForm }

constructor TBisDesignExchangeForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SizesStored:=true;

  FDataSet:=TBisDataSet.Create(Self);
  with FDataSet.FieldDefs do begin
    Add('ID',ftString,32);
    Add('PARENT_ID',ftString,32);
    Add('TYPE',ftInteger);
    Add('NAME',ftString,250);
    Add('SOURCE',ftString,100);
    Add('DESTINATION',ftString,100);
    Add('SCRIPT',ftBlob);
    Add('FETCH_COUNT',ftInteger);
    Add('RESULT',ftBlob);
    Add('SUCCESS',ftInteger);
    Add('DATE_BEGIN',ftDateTime);
    Add('DATE_END',ftDateTime);
    Add('PERIOD',ftDateTime);
    Find('PERIOD').InternalCalcField:=true;
  end;
  with FDataSet.FieldNames do begin
    AddKey('ID');
    AddParentKey('PARENT_ID');
    Add('NAME','������������',200);
    with AddCalculate('PERIOD','�����',GetPeriod,ftDateTime,0,50) do begin
      Alignment:=daCenter;
      DisplayFormat:='hh:nn:ss';
    end;
    AddCheckBox('SUCCESS','�����',50).Alignment:=daCenter;
    Add('TYPE','���',0).Visible:=false;
  end;
  FDataSet.CreateTable();
  DataSource.DataSet:=FDataSet;

  FTemp:=TBisDataSet.Create(Self);
  FTemp.CreateTable(FDataSet);

  FTree:=TBisDBTree.Create(Self);
  FTree.Parent:=PanelControls;
  FTree.Align:=alClient;
  FTree.SortEnabled:=false;
  FTree.NavigatorVisible:=true;
  FTree.NumberVisible:=false;
  FTree.SearchEnabled:=true;
  FTree.SortColumnVisible:=true;
  FTree.ChessVisible:=false;
  FTree.GridEmulate:=false;
  FTree.RowVisible:=true;
  FTree.ReadOnly:=true;
  FTree.AutoResizeableColumns:=true;
  FTree.CopyFromFieldNames(FDataSet.FieldNames);
  FTree.GradientVisible:=true;
  FTree.OnDblClick:=GridDblClick;
  FTree.OnPaintText:=GridPaintText;
  FTree.DataSource:=DataSource;

  FSSourceConnect:='���������� � ���������� %s';
  FSSourceBefore:='��������� �������� �� ���������';
  FSSourceAfter:='��������� �������� �� ���������';
  FSSourceDisconnect:='������ ���������� � ����������';
  FSExchangeScript:='����� ������� ����� ������������';
  FSDestinationConnect:='���������� � ����������� %s';
  FSDestinationBefore:='��������� �������� �� ����������';
  FSDestinationAfter:='��������� �������� �� ����������';
  FSDestinationDisconnect:='������ ���������� � �����������';
  FSDestinationNotEqualSource:='��������� � �������� ������ ���� ��������.';
  FSDestinationNotFound:='���������� %s �� �������.';
  FSSourceNotFound:='�������� %s �� ������.';
  
  RefreshDataSet;
  FTemp.CopyFrom(FDataSet);

  ProgressVisible(false);
end;

destructor TBisDesignExchangeForm.Destroy;
begin
  Stop;
  FTree.Free;
  FTemp.Free;
  FDataSet.Free; 
  inherited Destroy;
end;

procedure TBisDesignExchangeForm.DoEnd;
begin
  ProgressVisible(false);
  inherited DoEnd;
end;

function TBisDesignExchangeForm.GetPeriod(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDateCreate: TField;
  FieldDateFound: TField;
begin
  Result:=Null;
  FieldDateCreate:=DataSet.FieldByName('DATE_BEGIN');
  FieldDateFound:=DataSet.FieldByName('DATE_END');
  if not VarIsNull(FieldDateCreate.Value) and not VarIsNull(FieldDateFound.Value) then begin
    Result:=FieldDateFound.AsDateTime-FieldDateCreate.AsDateTime;
  end;
end;

procedure TBisDesignExchangeForm.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                               Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Step: TBisDesignExchangeStepType;
begin
  Step:=TBisDesignExchangeStepType(FTree.GetNodeValue(Node,'TYPE'));
  if (Node<>Sender.FocusedNode) or ((Node=Sender.FocusedNode) and (Column<>Sender.FocusedColumn)) then begin
    case Step of
      estSourceConnect: TargetCanvas.Font.Color:=clBlue;
      estSourceBefore: TargetCanvas.Font.Color:=clRed;
      estSourceBeforeStep: TargetCanvas.Font.Color:=clGreen;
      estDestinationConnect: TargetCanvas.Font.Color:=clBlue;
      estDestinationBefore: TargetCanvas.Font.Color:=clRed;
      estDestinationBeforeStep: TargetCanvas.Font.Color:=clGreen;
      estExchangeScript: TargetCanvas.Font.Color:=clRed;
      estExchangeScriptStep: TargetCanvas.Font.Color:=clGreen;
      estDestinationAfter: TargetCanvas.Font.Color:=clRed;
      estDestinationAfterStep: TargetCanvas.Font.Color:=clGreen;
      estDestinationDisconnect: TargetCanvas.Font.Color:=clBlue;
      estSourceAfter: TargetCanvas.Font.Color:=clRed;
      estSourceAfterStep: TargetCanvas.Font.Color:=clGreen;
      estSourceDisconnect: TargetCanvas.Font.Color:=clBlue;
    end;
  end;
  case Step of
    estExchange: TargetCanvas.Font.Style:=[fsBold];
  end;
end;

procedure TBisDesignExchangeForm.GridDblClick(Sender: TObject);
begin
  Info;
end;

procedure TBisDesignExchangeForm.ActionInfoUpdate(Sender: TObject);
begin
  ActionInfo.Enabled:=CanInfo;
end;

function TBisDesignExchangeForm.CanStart: Boolean;
begin
  Result:=inherited CanStart and FDataSet.Active and not FDataSet.Empty;
end;

function TBisDesignExchangeForm.CanInfo: Boolean;
var
  FormType: TBisDesignExchangeStepType;
begin
  Result:=FDataSet.Active and not FDataSet.Empty;
  if Result then begin
    FormType:=TBisDesignExchangeStepType(FDataSet.FieldByName('TYPE').AsInteger);
    Result:=FormType in [estSourceConnect,estSourceBeforeStep,
                         estDestinationConnect,estDestinationBeforeStep,
                         estExchangeScriptStep,
                         estDestinationAfterStep,estDestinationDisconnect,
                         estSourceAfterStep,estSourceDisconnect];
    Result:=Result and
            ((Trim(FDataSet.FieldByName('RESULT').AsString)<>'') or (Trim(FDataSet.FieldByName('SCRIPT').AsString)<>''));
  end;
end;

procedure TBisDesignExchangeForm.Info;
var
  Form: TBisMemoForm;
  Script: String;
  Ret: String;
  S: String;
begin
  if CanInfo then begin
    Form:=TBisMemoForm.Create(nil);
    try
      Script:=FDataSet.FieldByName('SCRIPT').AsString;
      Ret:=FDataSet.FieldByName('RESULT').AsString;
      S:=Script;
      if Trim(S)<>'' then
        S:=S+iff(Trim(Ret)<>'',#13#10+Ret,'')
      else S:=Ret;
      Form.Caption:=FDataSet.FieldByName('NAME').AsString;
      Form.Memo.Lines.Text:=S;
      Form.Memo.WordWrap:=false;
      Form.MemoType:=mtSQL;
      Form.ButtonOk.Visible:=false;
      Form.ButtonSort.Visible:=false;
      Form.ShowModal;
    finally
      Form.Free;
    end;
  end;
end;

procedure TBisDesignExchangeForm.ActionInfoExecute(Sender: TObject);
begin
  Info;
end;

procedure TBisDesignExchangeForm.ParseScript(Script: String; DS: TBisDataSet; Begins: TStringList);

  function GetDescription(var Text: String): String;
  var
    Str: TStringList;
    Apos1,Apos2: Integer;
    S: String;
    Ret: String;
  const
    DescBegin='/*';
    DescEnd='*/';
    Prefix='PREFIX';
  begin
    Result:='';
    Ret:=Trim(Text);
    Str:=TStringList.Create;
    try
      Str.Text:=Ret;
      if Str.Count>0 then begin
        Result:=Trim(Str.Strings[0]);
        Apos1:=-1;
        while Apos1<>0 do begin
          Apos1:=AnsiPos(DescBegin,Result);
          if Apos1>0 then begin
            Ret:=Copy(Result,Apos1+Length(DescBegin),Length(Result));
            Apos2:=AnsiPos(DescEnd,Ret);
            if Apos2>0 then begin
              S:=Copy(Ret,1,Apos2-1);
              Ret:=Copy(Ret,Apos2+Length(DescEnd),Length(Ret));
              if (Trim(S)<>'') then begin
                if Trim(S)<>Prefix then begin
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

  function GetFetchCount(Desc: String; Default: Integer): Integer;
  var
    S: String;
    APos: Integer;
    Spaces: TStringList;
    Equals: TStringList;
  const
    FC='FC';
  begin
    Result:=Default;
    APos:=AnsiPos(FC,Desc);
    if APos>0 then begin
      S:=Copy(Desc,APos,Length(Desc));
      Spaces:=TStringList.Create;
      try
        GetStringsByString(S,' ',Spaces);
        if Spaces.Count>0 then begin
          S:=Trim(Spaces[0]);
          Equals:=TStringList.Create;
          try
            GetStringsByString(S,'=',Equals);
            if Equals.Count>1 then begin
              if AnsiSameText(Trim(Equals[0]),FC) then
                TryStrToInt(Trim(Equals[1]),Result);
            end;
          finally
            Equals.Free;
          end;
        end;
      finally
        Spaces.Free;
      end;
    end;
  end;

var
  Text: string;
  i: Integer;
  Word,Desc: string;
  PosBegin, PosEnd, PosAppend: Integer;
  Temp,NewText: string;
  ChBack,ChNext: Char;
  IsAppend: Boolean;
  LastPos: Integer;
  Delims: TStringList;
  FetchCount: Integer;
const
  GoodChars=[' ',#13,#10,#0];
begin
  Delims:=TStringList.Create;
  try
    Delims.Add('--');
    Desc:='';
    Text:=Trim(Script);
    while true do begin
      Desc:=GetDescription(Text);
      FetchCount:=GetFetchCount(Desc,1000);
      LastPos:=Length(Text);
      for i:=0 to Begins.Count-1 do begin
        Word:=Begins.Strings[i];
        PosBegin:=AnsiPos(AnsiUpperCase(Word),AnsiUpperCase(Text));
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
          for i:=0 to Delims.Count-1 do begin
            Word:=Delims.Strings[i];
            PosEnd:=AnsiPos(Word,NewText);
            if PosEnd>0 then begin
              ChBack:=NewText[PosEnd-1];
              ChNext:=NewText[PosEnd+Length(Word)];
              if (ChBack in GoodChars) and (ChNext in GoodChars) then begin
                PosAppend:=PosAppend+PosEnd;
                IsAppend:=true;
                break;
              end else begin
                PosAppend:=PosAppend+PosEnd+Length(Word)-1;
                NewText:=Copy(NewText,PosEnd+Length(Word),Length(NewText));
              end;
            end;
          end;
          if not IsAppend then begin
            IsAppend:=true;
            PosAppend:=Length(NewText)+1;
          end;
        end;
        if IsAppend then begin
          Temp:=Trim(Copy(Text,1,PosAppend-1));
          Text:=Trim(Copy(Text,PosAppend+Length(Word),Length(Text)));
          if Trim(Temp)<>'' then begin
            DS.Append;
            DS.FieldByName('VALUE').AsString:=Temp;
            DS.FieldByName('DESCRIPTION').AsString:=Desc;
            DS.FieldByName('FETCH_COUNT').AsInteger:=FetchCount;
            DS.Post;
          end;
        end else begin
          if PosAppend>0 then begin
          end else break;
        end;
      end else break;
    end;
  finally
    Delims.Free;
  end;
end;

procedure TBisDesignExchangeForm.ProgressVisible(AVisible: Boolean);
begin
  ProgressBar.Visible:=AVisible;
  if AVisible then begin
    PanelButtons.Height:=65;
  end else begin
    PanelButtons.Height:=40;
  end;
end;

procedure TBisDesignExchangeForm.RefreshDataSet;

  procedure SetImport(ParentId: String; FormType: TBisDesignExchangeStepType; Script: String);
  var
    Begins: TStringList;
    DS: TBisDataSet;
  begin
    if Trim(Script)<>'' then begin
      Begins:=TStringList.Create;
      DS:=TBisDataSet.Create(nil);
      try
        Begins.Add('CREATE');
        Begins.Add('DROP');
        Begins.Add('ALTER');
        Begins.Add('INSERT');
        Begins.Add('UPDATE');
        Begins.Add('DELETE');
        Begins.Add('COMMIT');
        Begins.Add('GRANT');
        Begins.Add('REVOKE');
        Begins.Add('DECLARE');
        Begins.Add('BEGIN');
        Begins.Add('EXEC');
        Begins.Add('EXECUTE');
        Begins.Add('CALL');
        with DS.FieldDefs do begin
          Add('VALUE',ftBlob);
          Add('DESCRIPTION',ftString,250);
          Add('FETCH_COUNT',ftInteger);
        end;
        DS.CreateTable();
        ParseScript(Script,DS,Begins);
        if DS.Active and not DS.Empty then begin
          DS.First;
          while not DS.Eof do begin
            FDataSet.Append;
            FDataSet.FieldByName('ID').Value:=GetUniqueID;
            FDataSet.FieldByName('PARENT_ID').Value:=ParentId;
            FDataSet.FieldByName('TYPE').Value:=FormType;
            FDataSet.FieldByName('NAME').Value:=DS.FieldByName('DESCRIPTION').AsString;
            FDataSet.FieldByName('SCRIPT').Value:=DS.FieldByName('VALUE').AsString;
            FDataSet.FieldByName('FETCH_COUNT').Value:=DS.FieldByName('FETCH_COUNT').AsInteger;
            FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
            FDataSet.Post;
            DS.Next;
          end;
        end;
      finally
        DS.Free;
        Begins.Free;
      end;
    end;
  end;

  procedure SetExchange(ParentId: String; Script: String);
  var
    Begins: TStringList;
    DS: TBisDataSet;
  begin
    if Trim(Script)<>'' then begin
      Begins:=TStringList.Create;
      DS:=TBisDataSet.Create(nil);
      try
        Begins.Add('SELECT');
        with DS.FieldDefs do begin
          Add('VALUE',ftBlob);
          Add('DESCRIPTION',ftString,250);
          Add('FETCH_COUNT',ftInteger);
        end;
        DS.CreateTable();
        ParseScript(Script,DS,Begins);
        if DS.Active and not DS.Empty then begin
          DS.First;
          while not DS.Eof do begin
            FDataSet.Append;
            FDataSet.FieldByName('ID').Value:=GetUniqueID;
            FDataSet.FieldByName('PARENT_ID').Value:=ParentId;
            FDataSet.FieldByName('TYPE').Value:=estExchangeScriptStep;
            FDataSet.FieldByName('NAME').Value:=DS.FieldByName('DESCRIPTION').AsString;
            FDataSet.FieldByName('SCRIPT').Value:=DS.FieldByName('VALUE').AsString;
            FDataSet.FieldByName('FETCH_COUNT').Value:=DS.FieldByName('FETCH_COUNT').AsInteger;
            FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
            FDataSet.Post;
            DS.Next;
          end;
        end;
      finally
        DS.Free;
        Begins.Free;
      end;
    end;
  end;

var
  P: TBisProvider;
  ExchangeId: String;
  Id: String;
  Script: String;
begin
  FTree.BeginUpdate;
  FDataSet.EmptyTable;
  FDataSet.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_EXCHANGES';
    with P.FieldNames do begin
      AddInvisible('NAME');
      AddInvisible('SCRIPT');
      AddInvisible('SOURCE');
      AddInvisible('SOURCE_BEFORE');
      AddInvisible('SOURCE_AFTER');
      AddInvisible('DESTINATION');
      AddInvisible('DESTINATION_BEFORE');
      AddInvisible('DESTINATION_AFTER');
    end;
    with P.FilterGroups.Add do begin
      Filters.Add('ENABLED',fcEqual,1);
    end;
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.Empty then begin
      P.First;
      while not P.Eof do begin
        ExchangeId:=GetUniqueID;
        FDataSet.Append;
        FDataSet.FieldByName('ID').Value:=ExchangeId;
        FDataSet.FieldByName('PARENT_ID').Value:=Null;
        FDataSet.FieldByName('TYPE').Value:=estExchange;
        FDataSet.FieldByName('NAME').Value:=P.FieldByName('NAME').Value;
        FDataSet.FieldByName('SOURCE').Value:=P.FieldByName('SOURCE').AsString;
        FDataSet.FieldByName('DESTINATION').Value:=P.FieldByName('DESTINATION').AsString;
        FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
        FDataSet.Post;

        FDataSet.Append;
        FDataSet.FieldByName('ID').Value:=GetUniqueID;
        FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
        FDataSet.FieldByName('TYPE').Value:=estSourceConnect;
        FDataSet.FieldByName('NAME').Value:=FormatEx(FSSourceConnect,[P.FieldByName('SOURCE').AsString]);
        FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
        FDataSet.Post;

        Script:=P.FieldByName('SOURCE_BEFORE').AsString;
        if Trim(Script)<>'' then begin
          Id:=GetUniqueID;
          FDataSet.Append;
          FDataSet.FieldByName('ID').Value:=Id;
          FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
          FDataSet.FieldByName('TYPE').Value:=estSourceBefore;
          FDataSet.FieldByName('NAME').Value:=FSSourceBefore;
          FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
          FDataSet.Post;
          SetImport(Id,estSourceBeforeStep,Script);
        end;

        FDataSet.Append;
        FDataSet.FieldByName('ID').Value:=GetUniqueID;
        FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
        FDataSet.FieldByName('TYPE').Value:=estDestinationConnect;
        FDataSet.FieldByName('NAME').Value:=FormatEx(FSDestinationConnect,[P.FieldByName('DESTINATION').AsString]);
        FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
        FDataSet.Post;

        Script:=P.FieldByName('DESTINATION_BEFORE').AsString;
        if Trim(Script)<>'' then begin
          Id:=GetUniqueID;
          FDataSet.Append;
          FDataSet.FieldByName('ID').Value:=Id;
          FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
          FDataSet.FieldByName('TYPE').Value:=estDestinationBefore;
          FDataSet.FieldByName('NAME').Value:=FSDestinationBefore;
          FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
          FDataSet.Post;
          SetImport(Id,estDestinationBeforeStep,Script);
        end;

        Script:=P.FieldByName('SCRIPT').AsString;
        if Trim(Script)<>'' then begin
          Id:=GetUniqueID;
          FDataSet.Append;
          FDataSet.FieldByName('ID').Value:=Id;
          FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
          FDataSet.FieldByName('TYPE').Value:=estExchangeScript;
          FDataSet.FieldByName('NAME').Value:=FSExchangeScript;
          FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
          FDataSet.Post;
          SetExchange(Id,Script);
        end;

        Script:=P.FieldByName('DESTINATION_AFTER').AsString;
        if Trim(Script)<>'' then begin
          Id:=GetUniqueID;
          FDataSet.Append;
          FDataSet.FieldByName('ID').Value:=Id;
          FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
          FDataSet.FieldByName('TYPE').Value:=estDestinationAfter;
          FDataSet.FieldByName('NAME').Value:=FSDestinationAfter;
          FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
          FDataSet.Post;
          SetImport(Id,estDestinationAfterStep,Script);
        end;

        FDataSet.Append;
        FDataSet.FieldByName('ID').Value:=GetUniqueID;
        FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
        FDataSet.FieldByName('TYPE').Value:=estDestinationDisconnect;
        FDataSet.FieldByName('NAME').Value:=FSDestinationDisconnect;
        FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
        FDataSet.Post;

        Script:=P.FieldByName('SOURCE_AFTER').AsString;
        if Trim(Script)<>'' then begin
          Id:=GetUniqueID;
          FDataSet.Append;
          FDataSet.FieldByName('ID').Value:=Id;
          FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
          FDataSet.FieldByName('TYPE').Value:=estSourceAfter;
          FDataSet.FieldByName('NAME').Value:=FSSourceAfter;
          FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
          FDataSet.Post;
          SetImport(Id,estSourceAfterStep,Script);
        end;

        FDataSet.Append;
        FDataSet.FieldByName('ID').Value:=GetUniqueID;
        FDataSet.FieldByName('PARENT_ID').Value:=ExchangeId;
        FDataSet.FieldByName('TYPE').Value:=estSourceDisconnect;
        FDataSet.FieldByName('NAME').Value:=FSSourceDisconnect;
        FDataSet.FieldByName('SUCCESS').Value:=Integer(False);
        FDataSet.Post;

        P.Next;
      end;
    end;
    FTree.RefreshNodes;
  finally
    FDataSet.EndUpdate;
    FTree.EndUpdate;
    FTree.First;
    P.Free;
  end;
end;

procedure TBisDesignExchangeForm.Start;
begin
  inherited Start;
  ProgressVisible(true);
end;

procedure TBisDesignExchangeForm.SyncDataSet;
begin
  if FDataSet.Active then begin
    if FDataSet.Locate('ID',FTemp.FieldByName('ID').Value,[]) then begin
      FDataSet.Edit;
      FDataSet.FieldByName('RESULT').Value:=FTemp.FieldByName('RESULT').Value;
      FDataSet.FieldByName('SUCCESS').Value:=FTemp.FieldByName('SUCCESS').Value;
      FDataSet.FieldByName('DATE_BEGIN').Value:=FTemp.FieldByName('DATE_BEGIN').Value;
      FDataSet.FieldByName('DATE_END').Value:=FTemp.FieldByName('DATE_END').Value;
      FDataSet.Post;
    end;
  end;
end;

procedure TBisDesignExchangeForm.SyncProgress;
begin
  ProgressBar.Position:=FPosition;
  ProgressBar.Max:=FMax;
  ProgressBar.Update;
end;

function TBisDesignExchangeForm.Execute(Thread: TBisExecuteFormThread): Boolean;

  procedure SetResult(S: String; Success: Boolean; DateBegin, DateEnd: Variant);
  begin
    FTemp.Edit;
    FTemp.FieldByName('RESULT').Value:=S;
    FTemp.FieldByName('SUCCESS').Value:=Integer(Success);
    FTemp.FieldByName('DATE_BEGIN').Value:=DateBegin;
    FTemp.FieldByName('DATE_END').Value:=DateEnd;
    FTemp.Post;
    if Trim(S)<>'' then
      LoggerWrite(S,iff(Success,ltInformation,ltError));
    if not Thread.Terminated then
      Thread.Synchronize(SyncDataSet);
  end;

  procedure SetResultById(Id: String; S: String; Success: Boolean; DateBegin, DateEnd: Variant);
  begin
    FTemp.BeginUpdate(true);
    try
      FTemp.Locate('ID',Id,[]);
      SetResult(S,Success,DateBegin,DateEnd);
    finally
      FTemp.EndUpdate;
    end;
  end;

  function NextStep: TBisDesignExchangeStepType;
  begin
    Result:=estExchange;
    FTemp.BeginUpdate(true);
    try
      if not FTemp.Eof then begin
        FTemp.Next;
        Result:=TBisDesignExchangeStepType(FTemp.FieldByName('TYPE').AsInteger);
      end;
    finally
      FTemp.EndUpdate;
    end;
  end;

var
  Source: TBisConnection;
  Destination: TBisConnection;

  function SourceExists: Boolean;
  begin
    Result:=Assigned(Source);// and Source.Enabled;
  end;

  function DestinationExists: Boolean;
  begin
    Result:=Assigned(Destination);// and Destination.Enabled;
  end;

  function Import(Connection: TBisConnection; Script: String): Boolean;
  var
    Stream: TMemoryStream;
  begin
    Result:=Assigned(Connection) {and Connection.Enabled }and Connection.Connected;
    if Result then begin
      Stream:=TMemoryStream.Create;
      try
        Stream.Write(Pointer(Script)^,Length(Script));
        Stream.Position:=0;
        Connection.Import(itScript,Stream);
        Result:=true;
      finally
        Stream.Free;
      end;
    end;
  end;

  function Exchange(Script: String; FetchCount: Variant): Boolean;
  var
    Stream: TMemoryStream;
    DS: TBisDataSet;
    Params: TBisConnectionExportParams;
    Flag: Boolean;
  begin
    Result:=SourceExists and Source.Connected and
            DestinationExists and Destination.Connected;
    if Result then begin
      Params:=TBisConnectionExportParams.Create;
      Stream:=TMemoryStream.Create;
      try
        Flag:=true;
        Params.FromPosition:=0;
        Params.FetchCount:=VarToIntDef(FetchCount,1000);
        while Flag do begin
          if Thread.Terminated then
            break;
          DS:=TBisDataSet.Create(nil);
          try
            Stream.Clear;
            Source.Export(etTable,Script,Stream,Params);
            Stream.Position:=0;
            DS.LoadFromStream(Stream);
            DS.Open;
            if DS.Active and not Thread.Terminated then begin
              Stream.Clear;
              DS.SaveToStream(Stream);
              Stream.Position:=0;
              Destination.Import(itTable,Stream);
              Flag:=Params.FetchCount<=DS.RecordCount;
              Params.FromPosition:=Params.FromPosition+Params.FetchCount;
            end else
              Flag:=false;
          finally
            DS.Free;
          end;
        end;
        Result:=True;
      finally
        Stream.Free;
        Params.Free;
      end;
    end;
  end;

var
  Flags: array[TBisDesignExchangeStepType] of Boolean;

  procedure SetFlags(Value: Boolean);
  var
    i: TBisDesignExchangeStepType;
  begin
    for i:=High(Flags) downto Low(Flags) do begin
      Flags[i]:=false;
      Flags[i]:=Value;
    end;
  end;

type
  TBisDesignExchangeArrDateStepType = array[TBisDesignExchangeStepType] of Variant;

  procedure SetDateNull(Arr: TBisDesignExchangeArrDateStepType);
  var
    i: TBisDesignExchangeStepType;
  begin
    for i:=Low(Arr) to High(Arr) do
      Arr[i]:=Null;
  end;

var
  S1, S2: String;
  ID: String;
  Script: String;
  Step: TBisDesignExchangeStepType;
  IDs: array[TBisDesignExchangeStepType] of String;
  Begins: TBisDesignExchangeArrDateStepType;
  FetchCount: Variant;
  Success: Boolean;
  D: TDateTime;
begin
  try
    SetFlags(true);
    SetDateNull(Begins);
    if Assigned(Core) and FTemp.Active and not FTemp.Empty then begin
      Source:=nil;
      Destination:=nil;
      FPosition:=0;
      FMax:=FTemp.RecordCount;
      Thread.Synchronize(SyncProgress);
      FTemp.First;
      while not FTemp.Eof do begin
        if Thread.Terminated then
          break;
        try
          ID:=FTemp.FieldByName('ID').AsString;
          Thread.Synchronize(SyncDataSet);

          Step:=TBisDesignExchangeStepType(FTemp.FieldByName('TYPE').AsInteger);
          Script:=FTemp.FieldByName('SCRIPT').AsString;
          FetchCount:=FTemp.FieldByName('FETCH_COUNT').Value;
          try
            Flags[Step]:=false;
            Begins[Step]:=Now;
            if Step=estExchange then begin
              IDs[Step]:=ID;
              S1:=FTemp.FieldByName('SOURCE').AsString;
              S2:=FTemp.FieldByName('DESTINATION').AsString;
              Source:=Core.ConnectionModules.FindConnectionByCaption(S1);
              Destination:=Core.ConnectionModules.FindConnectionByCaption(S2);
              if SourceExists then begin
                if DestinationExists then begin
                  if (Source<>Destination) then begin
                    Flags[Step]:=true;
                  end else
                    SetResult(FSDestinationNotEqualSource,false,Begins[Step],Now);
                end else
                  SetResult(FormatEx(FSDestinationNotFound,[S2]),false,Begins[Step],Now);
              end else
                SetResult(FormatEx(FSSourceNotFound,[S1]),false,Begins[Step],Now);
            end;
            case Step of
              estSourceConnect: begin
                if Flags[estExchange] then begin
                  Source.Connect;
                  Flags[Step]:=Source.Connected;
                  SetResult('',Flags[Step],Begins[Step],Now);
                end;
              end;
              estSourceBefore: begin
                IDs[Step]:=ID;
                Flags[Step]:=Flags[estSourceConnect];
              end;
              estSourceBeforeStep: begin
                if Flags[estSourceBefore] then begin
                  D:=Now;
                  Success:=Import(Source,Script);
                  SetResult('',Success,D,Now);
                end;
                if NextStep<>estSourceBeforeStep then
                  SetResultById(IDs[estSourceBefore],'',Flags[estSourceBefore],Begins[estSourceBefore],Now);
              end;
              estDestinationConnect: begin
                if Flags[estExchange] then begin
                  Destination.Connect;
                  Flags[Step]:=Destination.Connected;
                  SetResult('',Flags[Step],Begins[Step],Now);
                end;
              end;
              estDestinationBefore: begin
                IDs[Step]:=ID;
                Flags[Step]:=Flags[estDestinationConnect];
              end;
              estDestinationBeforeStep: begin
                if Flags[estDestinationBefore] then begin
                  D:=Now;
                  Success:=Import(Destination,Script);
                  SetResult('',Success,D,Now);
                end;
                if NextStep<>estDestinationBeforeStep then
                  SetResultById(IDs[estDestinationBefore],'',Flags[estDestinationBefore],Begins[estDestinationBefore],Now);
              end;
              estExchangeScript: begin
                IDs[Step]:=ID;
                Flags[Step]:=Flags[estSourceConnect] and Flags[estDestinationConnect] and
                                 Flags[estSourceBefore] and Flags[estDestinationBefore];
              end;
              estExchangeScriptStep: begin
                if Flags[estExchangeScript] then begin
                  D:=Now;
                  Success:=Exchange(Script,FetchCount);
                  SetResult('',Success,D,Now);
                end;  
                if NextStep<>estExchangeScriptStep then
                  SetResultById(IDs[estExchangeScript],'',Flags[estExchangeScript],Begins[estExchangeScript],Now);
              end;
              estDestinationAfter: begin
                IDs[Step]:=ID;
                Flags[Step]:=Flags[estExchangeScript];
              end;
              estDestinationAfterStep: begin
                if Flags[estExchangeScript] then begin
                  D:=Now;
                  Success:=Import(Destination,Script);
                  SetResult('',Success,D,Now);
                end;
                if NextStep<>estDestinationAfterStep then
                  SetResultById(IDs[estDestinationAfter],'',Flags[estDestinationAfter],Begins[estDestinationAfter],Now);
              end;
              estDestinationDisconnect: begin
                if Flags[estDestinationConnect] then begin
                  Destination.Disconnect;
                  Destination:=nil;
                  Flags[Step]:=true;
                  SetResult('',True,Begins[Step],Now);
                end;
              end;
              estSourceAfter: begin
                IDs[Step]:=ID;
                Flags[Step]:=Flags[estExchangeScript];
              end;
              estSourceAfterStep: begin
                if Flags[estSourceAfter] then begin
                  D:=Now;
                  Success:=Import(Source,Script);
                  SetResult('',Success,D,Now);
                end;
                if NextStep<>estSourceAfterStep then
                  SetResultById(IDs[estSourceAfter],'',Flags[estSourceAfter],Begins[estSourceAfter],Now);
              end;
              estSourceDisconnect: begin
                if Flags[estSourceConnect] then begin
                  Source.Disconnect;
                  Source:=nil;
                  Flags[Step]:=true;
                  SetResult('',True,Begins[Step],Now);
                end;
                if NextStep in [estSourceDisconnect,estExchange] then
                  SetResultById(IDs[estExchange],'',Flags[estExchange],Begins[estExchange],Now);
              end;
            end;
          except
            On E: Exception do begin
              Flags[estExchange]:=false;
              case Step of
                estSourceBeforeStep: Flags[estSourceBefore]:=false;
                estDestinationBeforeStep: Flags[estDestinationBefore]:=false;
                estExchangeScriptStep: Flags[estExchangeScript]:=false;
                estDestinationAfterStep: Flags[estDestinationAfter]:=false;
                estSourceAfterStep: Flags[estSourceAfter]:=false;
              end;
              SetResult(E.Message,false,Begins[Step],Now);
            end;
          end;
        finally
          Inc(FPosition);
          Thread.Synchronize(SyncProgress);
          FTemp.Next;
        end;
      end;
    end;
  finally
    Result:=Flags[estExchange];
  end;
end;

end.