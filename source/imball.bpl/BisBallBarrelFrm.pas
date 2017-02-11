unit BisBallBarrelFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, DB, Contnrs, Buttons, 
  BisFrm, BisControls;

type
  TBisBallBarrelFrame=class;

  TBisBallSubroundPosition=(spFirst,spIntermediate,spLast);

  TBisBallSubround=class(TObject)
  private
    FSubroundId: Variant;
    FPercent: Extended;
    FTicketCount: Integer;
    FPosition: TBisBallSubroundPosition;
  public
    property SubroundId: Variant read FSubroundId write FSubroundId;
    property Percent: Extended read FPercent write FPercent;
    property TicketCount: Integer read FTicketCount write FTicketCount;
    property Position: TBisBallSubroundPosition read FPosition write FPosition;
  end;

  TBisBallBarrelFrameActionEvent=procedure (Sender: TBisBallBarrelFrame; WithStat: Boolean) of object;
  TBisBallBarrelFrameNextEvent=procedure (Sender: TBisBallBarrelFrame) of object;

  TBisBallBarrelFrame = class(TBisFrame)
    GroupBoxBarrel: TGroupBox;
    PanelBurrel: TPanel;
    StringGrid: TStringGrid;
    LabelBarrelNum: TLabel;
    EditBarrelNum: TEdit;
    ButtonAdd: TBitBtn;
    ButtonDel: TBitBtn;
    PanelInfo: TPanel;
    LabelPrizeSum: TLabel;
    LabelTicketCount: TLabel;
    LabelTicketSum: TLabel;
    EditPrizeSum: TEdit;
    EditTicketCount: TEdit;
    EditTicketSum: TEdit;
    PanelWait: TPanel;
    ButtonClear: TBitBtn;
    LabelSubround: TLabel;
    ComboBoxSubrounds: TComboBox;
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure EditBarrelNumChange(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ComboBoxSubroundsChange(Sender: TObject);
  private
    FTirageId: Variant;
    FRoundNum: Integer;
    FOnAction: TBisBallBarrelFrameActionEvent;
    FRoundSum: Extended;
    FTicketCount: Integer;
    FProviderName: String;
    FLotteryList: TObjectList;
    FMinCount: Integer;
    FClearFromIndex: Integer;
    FRoundColor: TColor;
    FAutoCalc: Boolean;
    FAutoMove: Boolean;
    FOnNext: TBisBallBarrelFrameNextEvent;
    FCalculating: Boolean;

    function GetLastBarrelNum: String;
    function GetSubroundId: Variant;
    function GetSubround: TBisBallSubround; overload;
    procedure SetActualSubround;
    procedure Next;
    procedure NextSubround(Subround: TBisBallSubround);
  protected
    procedure DoAction(WithStat: Boolean);
    function GetBarrelNums: String; virtual;
    function GetTicketSum: Extended; virtual;
    function GetTicketCount: Integer; virtual;
    function GetRoundSum: Extended; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshSubrounds(WithCursor: Boolean); virtual;
    procedure RefreshBarrels(WithCursor: Boolean); virtual;
    procedure RefreshWinnings(WithCursor: Boolean); virtual;
    procedure Refresh; virtual;
    procedure SetStatistics(WithCursor: Boolean); virtual;
    procedure UpdateButtons;
    procedure UpdateScrollBars;
    procedure UpdateStatistics;
    procedure FirstState;
    function CanAdd: Boolean; virtual;
    procedure Add;
    function CanDelete: Boolean; virtual;
    procedure Delete;
    function CanClear: Boolean; virtual;
    procedure Clear;
    function CheckBarrelNum(BarrelNum: String): Boolean; virtual;
    function ExistsBarrelNum(BarrelNum: String): Boolean; virtual;
    function GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor; virtual;
    function GetSubround(ASubroundId: Variant): Integer; overload;

    property TirageId: Variant read FTirageId write FTirageId;
    property RoundNum: Integer read FRoundNum write FRoundNum;
    property RoundSum: Extended read GetRoundSum write FRoundSum;
    property TicketCount: Integer read GetTicketCount write FTicketCount;
    property TicketSum: Extended read GetTicketSum;
    property SubroundId: Variant read GetSubroundId;

    property ProviderName: String read FProviderName write FProviderName;

    property LastBarrelNum: String read GetLastBarrelNum;
    property BarrelNums: String read GetBarrelNums;

    property MinCount: Integer read FMinCount write FMinCount;
    property LotteryList: TObjectList read FLotteryList;
    property Calculating: Boolean read FCalculating;

    property ClearFromIndex: Integer read FClearFromIndex write FClearFromIndex;

    property RoundColor: TColor read FRoundColor write FRoundColor;
    property AutoCalc: Boolean read FAutoCalc write FAutoCalc;
    property AutoMove: Boolean read FAutoMove write FAutoMove;

    property OnAction: TBisBallBarrelFrameActionEvent read FOnAction write FOnAction;
    property OnNext: TBisBallBarrelFrameNextEvent read FOnNext write FOnNext;
  end;

procedure StringsSpecialSaveToStream(Str: TStrings; Stream: TStream);

implementation

uses DateUtils,
     BisProvider, BisFilterGroups, BisDialogs, BisCore, BisUtils, BisConsts,
     BisBallConsts;

{$R *.dfm}

procedure StringsSpecialSaveToStream(Str: TStrings; Stream: TStream);
var
  i: Integer;
  S: String;
begin
  if Assigned(Str) and Assigned(Stream) then begin
    S:='';
    for i:=0 to Str.Count-1 do begin
      if i<>Str.Count-1 then
        S:=S+Str[i]+Str.LineBreak
      else
        S:=S+Str[i];
    end;
    Stream.Write(Pointer(S)^,Length(S));
  end;
end;

type
  TBisBallLottery=class(TObject)
  private
    FSubroundId: Variant;
    FLotteryId: Variant;
    FRoundNum: Integer;
    FColor: TColor;
    FBarrelNum: String;
  public
    property LotteryId: Variant read FLotteryId write FLotteryId;
    property SubroundId: Variant read FSubroundId write FSubroundId;
    property RoundNum: Integer read FRoundNum write FRoundNum;
    property Color: TColor read FColor write FColor;
    property BarrelNum: String read FBarrelNum write FBarrelNum; 
  end;

{ TBisBallLotteryFrame }

constructor TBisBallBarrelFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  EditPrizeSum.Color:=ColorControlReadOnly;
  EditTicketCount.Color:=ColorControlReadOnly;
  EditTicketSum.Color:=ColorControlReadOnly;

  EditPrizeSum.Alignment:=taRightJustify;
  EditTicketCount.Alignment:=taRightJustify;
  EditTicketSum.Alignment:=taRightJustify;

  ButtonDel.Enabled:=false;

  FLotteryList:=TObjectList.Create;

  FirstState;

  FRoundSum:=0.0;
  FTirageId:=Null;
  FClearFromIndex:=0;
  FAutoCalc:=false;

  EditBarrelNumChange(nil);

end;

destructor TBisBallBarrelFrame.Destroy;
begin
  ClearStrings(ComboBoxSubrounds.Items);
  FLotteryList.Free;
  inherited Destroy;
end;

procedure TBisBallBarrelFrame.DoAction(WithStat: Boolean);
begin
  if Assigned(FOnAction) then
    FOnAction(Self,WithStat);
end;

procedure TBisBallBarrelFrame.EditBarrelNumChange(Sender: TObject);
begin
  ButtonAdd.Enabled:=CanAdd;
end;

function TBisBallBarrelFrame.GetBarrelNums: String;
var
  S,S1: String;
  i: Integer;
begin
  S:=SUnknownValue;
  if StringGrid.ColCount>2 then begin
    S:='';
    for i:=1 to StringGrid.ColCount-2 do begin
      S1:=Trim(StringGrid.Cells[i,1]);
      if Length(S1)=1 then
        S1:=' '+S1;
      if i=1 then
        S:=S1
      else S:=S+' '+S1;
    end;
  end;
  Result:=S;
end;

function TBisBallBarrelFrame.GetLastBarrelNum: String;
begin
  Result:=SUnknownValue;
  if StringGrid.ColCount>2 then
    Result:=Trim(StringGrid.Cells[StringGrid.ColCount-2,1]);
end;

function TBisBallBarrelFrame.GetSubround: TBisBallSubround;
var
  Index: Integer;
begin
  Result:=nil;
  Index:=ComboBoxSubrounds.ItemIndex;
  if Index<>-1 then begin
    Result:=TBisBallSubround(ComboBoxSubrounds.Items.Objects[Index]);
  end;
end;

function TBisBallBarrelFrame.GetSubroundId: Variant;
var
  Obj: TBisBallSubround;
begin
  Result:=Null;
  Obj:=GetSubround;
  if Assigned(Obj) then
    Result:=Obj.SubroundId;
end;

function TBisBallBarrelFrame.GetTicketSum: Extended;
begin
  Result:=0.0;
  if TicketCount>0 then
    Result:=RoundSum/TicketCount;
end;

function TBisBallBarrelFrame.GetTicketCount: Integer;
var
  Obj: TBisBallSubround;
begin
  Result:=FTicketCount;
  Obj:=GetSubround;
  if Assigned(Obj) then
    Result:=Obj.TicketCount;
end;

function TBisBallBarrelFrame.GetRoundSum: Extended;
var
  Obj: TBisBallSubround;
begin
  Result:=FRoundSum;
  Obj:=GetSubround;
  if Assigned(Obj) then
    Result:=Obj.Percent*Result/100;
end;

procedure TBisBallBarrelFrame.ButtonAddClick(Sender: TObject);
begin
{  if ShowQuestion(Format('%s - ��� ���������� �����?',
                         [Trim(EditBarrelNum.Text)]),mbNo)=mrYes then}
  Add;
end;

procedure TBisBallBarrelFrame.ButtonClearClick(Sender: TObject);
begin
  if ShowQuestion(Format('%s?',[ButtonClear.Hint]),mbNo)=mrYes then
    Clear;
end;

procedure TBisBallBarrelFrame.ButtonDelClick(Sender: TObject);
begin
  if ShowQuestion(Format('%s?',[ButtonDel.Hint]),mbNo)=mrYes then
    Delete;
end;

procedure TBisBallBarrelFrame.FirstState;
var
  i: Integer;
begin
  for i:=StringGrid.ColCount-2 downto 0 do begin
    StringGrid.Cells[i,0]:='';
    StringGrid.Cells[i,1]:='';
  end;
  StringGrid.RowCount:=2;
  StringGrid.ColCount:=2;
  StringGrid.FixedCols:=1;
  StringGrid.Cells[0,1]:='�';
  StringGrid.ColWidths[0]:=30;
  FLotteryList.Clear;
  UpdateScrollBars;
  FMinCount:=0;
  StringGrid.Repaint;
  UpdateButtons;
end;

procedure TBisBallBarrelFrame.ComboBoxSubroundsChange(Sender: TObject);
var
  OldCalc, OldMove: Boolean;
begin
  OldCalc:=FAutoCalc;
  OldMove:=FAutoMove;
  try
    FAutoCalc:=false;
    FAutoMove:=false;
    EditBarrelNum.SetFocus;
    RefreshBarrels(true);
    DoAction(true);
  finally
    FAutoMove:=OldMove;
    FAutoCalc:=OldCalc;
  end;
end;

procedure TBisBallBarrelFrame.StringGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  OldFont: TFont;
  OldBrush: TBrush;
  S: String;
  W,H: Integer;
  X,Y: Integer;
  Pts: array[0..1] of TPoint;
//  ARoundNum: Integer;
  Obj: TBisBallLottery;
begin
  OldFont:=TFont.Create;
  OldBrush:=TBrush.Create;
  try
    OldFont.Assign(StringGrid.Canvas.Font);
    OldBrush.Assign(StringGrid.Canvas.Brush);

    StringGrid.Canvas.Brush.Color:=clWindow;
    StringGrid.Canvas.Brush.Style:=bsSolid;
    StringGrid.Canvas.FillRect(Rect);

    if (ACol>0) and (ARow=1) then begin
      StringGrid.Canvas.Font.Style:=[fsBold];
    end else begin
      StringGrid.Canvas.Brush.Color:=StringGrid.FixedColor;
      StringGrid.Canvas.Brush.Style:=bsSolid;
      StringGrid.Canvas.FillRect(Rect);
    end;

    if (ACol>0) and (ACol<(FMinCount+1)) and (ARow=1) and (FLotteryList.Count>0) then begin
      Obj:=TBisBallLottery(FLotteryList.Items[ACol-1]);
      StringGrid.Canvas.Brush.Color:=Obj.Color;
      StringGrid.Canvas.Brush.Style:=bsSolid;
      StringGrid.Canvas.FillRect(Rect);
{      ARoundNum:=Integer(StringGrid.Objects[ACol,ARow]);
      if ARoundNum=0 then
        StringGrid.Canvas.Brush.Color:=StringGrid.FixedColor
      else begin
        case ARoundNum of
          1: StringGrid.Canvas.Brush.Color:=$00AEAEFF;
          2: StringGrid.Canvas.Brush.Color:=$00C4FFC4;
          3: StringGrid.Canvas.Brush.Color:=$00FFC1C1;
          4: begin

          end;
        end;
      end;
      StringGrid.Canvas.Brush.Style:=bsSolid;
      StringGrid.Canvas.FillRect(Rect);}
    end;

    S:=StringGrid.Cells[ACol,ARow];
    W:=StringGrid.Canvas.TextWidth(S);
    H:=StringGrid.Canvas.TextHeight(S);
    X:=Rect.Left+((Rect.Right-Rect.Left) div 2 - W div 2);
    Y:=Rect.Top+((Rect.Bottom-Rect.Top) div 2 - H div 2);
    StringGrid.Canvas.TextOut(X,Y,S);
    if (ACol=0) and (ARow=0) then begin
      Pts[0]:=Rect.TopLeft;
      Pts[1]:=Rect.BottomRight;
      StringGrid.Canvas.Pen.Color:=clSilver;
      StringGrid.Canvas.Polyline(Pts);
    end;
    if (ACol=0) and (ARow=1) then begin
      Pts[0]:=Point(Rect.Right,Rect.Top);
      Pts[1]:=Point(Rect.Right,Rect.Bottom);
      StringGrid.Canvas.Pen.Color:=clSilver;
      StringGrid.Canvas.Polyline(Pts);
    end;

  finally
    StringGrid.Canvas.Font.Assign(OldFont);
    StringGrid.Canvas.Brush.Assign(OldBrush);
    OldFont.Free;
    OldBrush.Free;
  end;
end;

procedure TBisBallBarrelFrame.UpdateButtons;
begin
  ButtonAdd.Enabled:=CanAdd;
  ButtonDel.Enabled:=CanDelete;
  ButtonClear.Enabled:=CanClear;
end;

procedure TBisBallBarrelFrame.UpdateScrollBars;
begin
  SendMessage(StringGrid.Handle,WM_HSCROLL,SB_RIGHT,0);
end;

function TBisBallBarrelFrame.GetSubround(ASubroundId: Variant): Integer;
var
  i: Integer;
  Item: TBisBallSubround;
begin
  Result:=-1;
  for i:=0 to ComboBoxSubrounds.Items.Count-1 do begin
    Item:=TBisBallSubround(ComboBoxSubrounds.Items.Objects[i]);
    if VarSameValue(Item.SubroundId,ASubroundId) then begin
      Result:=i;
      exit;
    end;
  end;
end;

function TBisBallBarrelFrame.GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor;
begin
  Result:=StringGrid.FixedColor;
  if FRoundNum>ARoundNum then begin
    case ARoundNum of
      1: Result:=$00AEAEFF;
      2: Result:=$00C4FFC4;
      3: Result:=$00FFC1C1;
      4: Result:=$00FF80FF; 
    end;
  end;
end;

procedure TBisBallBarrelFrame.RefreshSubrounds(WithCursor: Boolean);
var
  P: TBisProvider;
  Obj: TBisBallSubround;
begin
  ClearStrings(ComboBoxSubrounds.Items);
  if not VarIsNull(FTirageId) and
     LabelSubround.Visible and ComboBoxSubrounds.Visible then begin
    ComboBoxSubrounds.Items.BeginUpdate;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=WithCursor;
      P.ProviderName:='S_SUBROUNDS';
      with P.FieldNames do begin
        Add('SUBROUND_ID');
        Add('NAME');
        Add('PERCENT');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
        Filters.Add('ROUND_NUM',fcEqual,FRoundNum);
      end;
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active and not P.Empty then begin
        P.First;
        while not P.Eof do begin
          Obj:=TBisBallSubround.Create;
          Obj.SubroundId:=P.FieldByName('SUBROUND_ID').Value;
          Obj.Percent:=P.FieldByName('PERCENT').AsFloat;
          Obj.TicketCount:=0;
          if P.Bof then
            Obj.Position:=spFirst
          else
            Obj.Position:=spIntermediate;
          ComboBoxSubrounds.Items.AddObject(P.FieldByName('NAME').AsString,Obj);
          P.Next;
          if P.Eof then
            Obj.Position:=spLast
        end;
        if ComboBoxSubrounds.Items.Count>0 then begin
          ComboBoxSubrounds.ItemIndex:=0;
        end;
      end;
    finally
      P.Free;
      ComboBoxSubrounds.Items.EndUpdate;
    end;
  end;
end;

procedure TBisBallBarrelFrame.RefreshBarrels(WithCursor: Boolean);
var
  P: TBisProvider;
  ARoundNum: Integer;
  ASubroundId: Variant;
  FS: TFormatSettings;
  Obj: TBisBallLottery;
  Index: Integer;
begin
  FirstState;
  if not VarIsNull(TirageId) then begin
    FS.ThousandSeparator:=' ';
    FS.DecimalSeparator:=DecimalSeparator;
    FS.CurrencyFormat:=CurrencyFormat;
    FS.CurrencyDecimals:=CurrencyDecimals;
    FS.CurrencyString:=CurrencyString;
    
    EditPrizeSum.Text:=FloatToStrF(RoundSum,ffCurrency,15,2,FS);
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=WithCursor;
      P.ProviderName:='S_LOTTERY';
      with P.FieldNames do begin
        AddInvisible('LOTTERY_ID');
        AddInvisible('ROUND_NUM');
        AddInvisible('SUBROUND_ID');
        AddInvisible('BARREL_NUM');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('TIRAGE_ID',fcEqual,TirageId).CheckCase:=true;
        Filters.Add('ROUND_NUM',fcEqualLess,FRoundNum);
      end;
      P.Orders.Add('ROUND_NUM');
      P.Orders.Add('SUBROUND_PRIORITY');
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active then begin
        P.First;
        while not P.Eof do begin
          ARoundNum:=P.FieldByName('ROUND_NUM').AsInteger;
          ASubroundId:=P.FieldByName('SUBROUND_ID').Value;
          Index:=GetSubround(ASubroundId);
          if Index<=ComboBoxSubrounds.ItemIndex then begin
            if (ARoundNum<>RoundNum) or (Index<>ComboBoxSubrounds.ItemIndex) then
              MinCount:=MinCount+1;
            StringGrid.ColCount:=StringGrid.ColCount+1;
            StringGrid.Cells[StringGrid.ColCount-2,0]:=IntToStr(StringGrid.ColCount-2);
            StringGrid.Cells[StringGrid.ColCount-2,1]:=P.FieldByName('BARREL_NUM').AsString;
            StringGrid.Cells[StringGrid.ColCount-1,0]:='';
            StringGrid.Cells[StringGrid.ColCount-1,1]:='';
            Obj:=TBisBallLottery.Create;
            Obj.LotteryId:=P.FieldByName('LOTTERY_ID').Value;
            Obj.SubroundId:=ASubroundId;
            Obj.RoundNum:=ARoundNum;
            Obj.BarrelNum:=P.FieldByName('BARREL_NUM').AsString;
            Obj.Color:=GetLotteryColor(ARoundNum,ASubroundId);
            FLotteryList.Add(Obj);
          end;
          P.Next;
        end;
        UpdateButtons;
        StringGrid.Repaint;
        UpdateScrollBars;
        DoAction(false);
        if FAutoCalc then
          SetStatistics(WithCursor)
        else
          UpdateStatistics;
      end;
    finally
      P.Free;
    end;
  end else
    EditPrizeSum.Text:='';
end;

procedure TBisBallBarrelFrame.RefreshWinnings(WithCursor: Boolean);
var
  P: TBisProvider;
  ASubroundId: Variant;
  Index: Integer;
  Obj: TBisBallSubround;
begin
  if not VarIsNull(FTirageId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=WithCursor;
      P.ProviderName:='S_WINNINGS';
      with P.FieldNames do begin
        AddInvisible('SUBROUND_ID');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
        Filters.Add('ROUND_NUM',fcEqual,FRoundNum);
      end;
      P.Orders.Add('SUBROUND_PRIORITY');
      P.Orders.Add('LOTTERY_PRIORITY');
      P.Open;
      if P.Active then begin
        P.First;
        FTicketCount:=0;
        while not P.Eof do begin
          ASubroundId:=P.FieldByName('SUBROUND_ID').Value;
          Index:=GetSubround(ASubroundId);
          if Index<>-1 then begin
            Obj:=TBisBallSubround(ComboBoxSubrounds.Items.Objects[Index]);
            if Assigned(Obj) then
              Obj.TicketCount:=Obj.TicketCount+1;
          end else
            FTicketCount:=FTicketCount+1;
          P.Next;
        end;
      end;
    finally                                         
      P.Free;
    end;
  end;                                      
end;

procedure TBisBallBarrelFrame.SetActualSubround;
var
  i: Integer;
  Obj: TBisBallSubround;
  Index: Integer;
begin
  Index:=-1;
  Obj:=nil;
  for i:=ComboBoxSubrounds.Items.Count-1 downto 0 do begin
    Obj:=TBisBallSubround(ComboBoxSubrounds.Items.Objects[i]);
    if Obj.TicketCount>0 then begin
      Index:=i;
      break;
    end;
  end;
  if (Index>=0) then begin
    if Obj.Position<>spLast then
      ComboBoxSubrounds.ItemIndex:=Index+1
    else
      ComboBoxSubrounds.ItemIndex:=Index;
  end;
end;

procedure TBisBallBarrelFrame.Refresh;
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  try
    Screen.Cursor:=crHourGlass;
    RefreshSubrounds(false);
    RefreshWinnings(false);
    SetActualSubround;    
    RefreshBarrels(false);
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

function TBisBallBarrelFrame.CanAdd: Boolean;
begin
  Result:=(Trim(EditBarrelNum.Text)<>'') and not VarIsNull(FTirageId);
end;

function TBisBallBarrelFrame.CheckBarrelNum(BarrelNum: String): Boolean;
var
  Num: Integer;
begin
  Result:=true;
  if Result then begin
    Result:=TryStrToInt(BarrelNum,Num);
    if Result then
      Result:=(Num>0) and (Num<78);
  end;
end;

function TBisBallBarrelFrame.ExistsBarrelNum(BarrelNum: String): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not Result then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_LOTTERY';
      P.FieldNames.Add('PRIORITY');
      with P.FilterGroups.Add do begin
        Filters.Add('TIRAGE_ID',fcEqual,TirageId).CheckCase:=true;
//        Filters.Add('SUBROUND_ID',fcEqual,GetSubroundId).CheckCase:=true;
        Filters.Add('BARREL_NUM',fcEqual,BarrelNum).CheckCase:=true;
      end;
      P.Open;
      Result:=P.Active and not P.Empty;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisBallBarrelFrame.Add;
var
  BarrelNum: String;

  function CheckLocal: Boolean;
  var
    SubroundId: Variant;
  begin
    Result:=false;

    if BarrelNum='' then begin
      ShowError('������� �����.');
      EditBarrelNum.SetFocus;
      exit;
    end;

    if LabelSubround.Visible and ComboBoxSubrounds.Visible then begin
      SubroundId:=GetSubroundId;
      if VarIsNull(SubroundId) then begin
        ShowError('�������� ������.');
        ComboBoxSubrounds.SetFocus;
        exit;
      end;
    end;

    if not CheckBarrelNum(BarrelNum) then begin
      ShowError('������������ �����.');
      EditBarrelNum.SetFocus;
      exit;
    end;

    if ExistsBarrelNum(BarrelNum) then begin
      ShowError('����� ����� ��� ����������.');
      EditBarrelNum.SetFocus;
      exit;
    end;

    Result:=true;
  end;

var
  P: TBisProvider;
  Id: String;
  OldCursor: TCursor;
  Obj: TBisBallLottery;
begin
  BarrelNum:=Trim(EditBarrelNum.Text);
  if Length(BarrelNum)=1 then
    BarrelNum:='0'+BarrelNum;
  if CanAdd and CheckLocal then begin
    OldCursor:=Screen.Cursor;
    P:=TBisProvider.Create(nil);
    try
      Screen.Cursor:=crHourGlass;
      Id:=GetUniqueID;
      P.ProviderName:='I_LOTTERY';
      with P.Params do begin
        AddInvisible('LOTTERY_ID').Value:=Id;
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('SUBROUND_ID').Value:=GetSubroundId;
        AddInvisible('PRIORITY').Value:=StringGrid.ColCount-1;
        AddInvisible('ROUND_NUM').Value:=FRoundNum;
        AddInvisible('BARREL_NUM').Value:=BarrelNum;
      end;
      P.Execute;
      if P.Success then begin
        StringGrid.ColCount:=StringGrid.ColCount+1;
        StringGrid.Cells[StringGrid.ColCount-2,0]:=IntToStr(StringGrid.ColCount-2);
        StringGrid.Cells[StringGrid.ColCount-2,1]:=BarrelNum;
        Obj:=TBisBallLottery.Create;
        Obj.LotteryId:=Id;
        Obj.SubroundId:=GetSubroundId;
        Obj.RoundNum:=FRoundNum;
        Obj.Color:=GetLotteryColor(Obj.RoundNum,Obj.SubroundId);
        Obj.BarrelNum:=BarrelNum;
        FLotteryList.Add(Obj);
        UpdateScrollBars;
        StringGrid.Repaint;
        UpdateButtons;
        EditBarrelNum.Text:='';
        EditBarrelNum.SetFocus;
        DoAction(false);
        if FAutoCalc then
          SetStatistics(false)
        else
          UpdateStatistics;  
        DoAction(true);
      end;
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

function TBisBallBarrelFrame.CanDelete: Boolean;
begin
  Result:=not VarIsNull(FTirageId) and (StringGrid.ColCount>(FMinCount+2)) and
          (FLotteryList.Count>0);
end;

procedure TBisBallBarrelFrame.Delete;
var
  P: TBisProvider;
  BarrelNum: String;
  Id: String;
  OldCursor: TCursor;
  Obj: TBisBallLottery;
begin
  if CanDelete then begin
    BarrelNum:=Trim(StringGrid.Cells[StringGrid.ColCount-2,1]);
    if BarrelNum<>'' then begin
      OldCursor:=Screen.Cursor;
      P:=TBisProvider.Create(nil);
      try
        Screen.Cursor:=crHourGlass;
        Obj:=TBisBallLottery(FLotteryList.Items[FLotteryList.Count-1]);
        Id:=Obj.LotteryId;
        P.WithWaitCursor:=false;
        P.ProviderName:='D_LOTTERY';
        with P.Params do begin
          AddInvisible('OLD_LOTTERY_ID').Value:=Id;
        end;
        P.Execute;
        if P.Success then begin
          StringGrid.ColCount:=StringGrid.ColCount-1;
          StringGrid.Cells[StringGrid.ColCount-1,0]:='';
          StringGrid.Cells[StringGrid.ColCount-1,1]:='';
          FLotteryList.Delete(FLotteryList.Count-1);
          UpdateScrollBars;
          StringGrid.Repaint;
          UpdateButtons;
          EditBarrelNum.Text:='';
          EditBarrelNum.SetFocus;
          DoAction(false);
          if FAutoCalc then
            SetStatistics(false)
          else
            UpdateStatistics;  
          DoAction(true);
        end;
      finally
        P.Free;
        Screen.Cursor:=OldCursor;
      end;
    end;
  end;
end;

function TBisBallBarrelFrame.CanClear: Boolean;
begin
  Result:=not VarIsNull(FTirageId) and (StringGrid.ColCount>(FMinCount+FClearFromIndex+2)) and
          (FLotteryList.Count>FMinCount+FClearFromIndex);
end;

procedure TBisBallBarrelFrame.Clear;
var
  P: TBisProvider;
  i: Integer;
  OldCursor: TCursor;
  Obj: TBisBallLottery;
begin
  if CanClear then begin
    OldCursor:=Screen.Cursor;
    P:=TBisProvider.Create(nil);
    try
      Screen.Cursor:=crHourGlass;
      P.WithWaitCursor:=false;
      P.ProviderName:='D_LOTTERY';
      with P.Params do begin
        Obj:=TBisBallLottery(FLotteryList.Items[FLotteryList.Count-1]);
        AddInvisible('OLD_LOTTERY_ID').Value:=Obj.LotteryId;
      end;
      for i:=FMinCount+FClearFromIndex to FLotteryList.Count-2 do begin
        Obj:=TBisBallLottery(FLotteryList.Items[i]);
        P.PackageAfter.Add.AddInvisible('OLD_LOTTERY_ID').Value:=Obj.LotteryId;
      end;
      P.Execute;
      if P.Success then begin
        for i:=StringGrid.ColCount-2 downto (FMinCount+FClearFromIndex+1) do begin
          StringGrid.ColCount:=StringGrid.ColCount-1;
          StringGrid.Cells[i,0]:='';
          StringGrid.Cells[i,1]:='';
          FLotteryList.Delete(FLotteryList.Count-1);
        end;
        UpdateScrollBars;
        StringGrid.Repaint;
        UpdateButtons;
        EditBarrelNum.Text:='';
        EditBarrelNum.SetFocus;
        DoAction(false);
        if FAutoCalc then
          SetStatistics(false)
        else
          UpdateStatistics;  
        DoAction(true);
      end;
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisBallBarrelFrame.Next;
begin
  if Assigned(FOnNext) then
    FOnNext(Self);
end;

procedure TBisBallBarrelFrame.NextSubround(Subround: TBisBallSubround);
var
  Index: Integer;
begin
  if Assigned(Subround) then begin
    Index:=ComboBoxSubrounds.ItemIndex;
    if Index<ComboBoxSubrounds.Items.Count then begin
      ComboBoxSubrounds.OnChange:=nil;
      try
        ComboBoxSubrounds.ItemIndex:=Index+1;
        ComboBoxSubroundsChange(nil);
      finally
        ComboBoxSubrounds.OnChange:=ComboBoxSubroundsChange;
      end;
    end;
  end;
end;

procedure TBisBallBarrelFrame.SetStatistics(WithCursor: Boolean);
var
  P: TBisProvider;
  T: TTime;
  MSec: Integer;
  Obj: TBisBallSubround;
const
  Delay=500;
begin
  FCalculating:=true;
  try
    Update;
    if not VarIsNull(TirageId) and (Trim(FProviderName)<>'') then begin
      PanelWait.Visible:=StringGrid.ColCount>2;
      P:=TBisProvider.Create(nil);
      T:=Time;
      try
        PanelWait.Update;
        P.WithWaitCursor:=WithCursor;
        P.ProviderName:=FProviderName;
        with P.Params do begin
          AddInvisible('TIRAGE_ID').Value:=FTirageId;
          AddInvisible('SUBROUND_ID').Value:=GetSubroundId;
          AddInvisible('TICKET_COUNT',ptOutput);
        end;
        P.Execute;
        if P.Success then begin
          FTicketCount:=P.Params.ParamByName('TICKET_COUNT').AsInteger;
          Obj:=GetSubround;
          if Assigned(Obj) then begin
            Obj.TicketCount:=FTicketCount;
            UpdateStatistics;
            if (FTicketCount>0) and FAutoMove then begin
              case Obj.Position of
                spFirst,spIntermediate: NextSubround(Obj);
                spLast: Next;
              end;
            end;
          end else begin
            UpdateStatistics;
            if (FTicketCount>0) and FAutoMove then
              Next;
          end;
        end;
        MSec:=MilliSecondsBetween(Time,T);
        if PanelWait.Visible and (MSec<Delay) then
          Sleep(Delay-MSec);
      finally
        P.Free;
        PanelWait.Visible:=false;
      end;
    end else begin
      UpdateStatistics;
    end;
  finally
    FCalculating:=false;
  end;
end;

procedure TBisBallBarrelFrame.UpdateStatistics;
var
  FS: TFormatSettings;
  OldCaption: String;
begin
  if not VarIsNull(TirageId) then begin
    FS.ThousandSeparator:=' ';
    FS.DecimalSeparator:=DecimalSeparator;
    FS.CurrencyFormat:=CurrencyFormat;
    FS.CurrencyDecimals:=CurrencyDecimals;
    FS.CurrencyString:=CurrencyString;

    EditTicketCount.Text:=FloatToStrF(TicketCount,ffNumber,15,0,FS);
    EditTicketSum.Text:=FloatToStrF(TicketSum,ffCurrency,15,2,FS);

    if TicketCount>0 then begin
      PanelWait.Color:=clRed;
      PanelWait.Font.Color:=clYellow;
      OldCaption:=PanelWait.Caption;
      try
        PanelWait.Caption:='�������� �������!';
        PanelWait.Update;
        Sleep(1000);
      finally
        PanelWait.Caption:=OldCaption;
        PanelWait.Font.Color:=clWindowText;
        PanelWait.Color:=clSilver;
      end;
    end;

  end else begin
    EditTicketCount.Text:='';
    EditTicketSum.Text:='';
  end;
end;


end.
