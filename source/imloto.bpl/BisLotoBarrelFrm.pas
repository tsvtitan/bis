unit BisLotoBarrelFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, DB, Contnrs, Buttons,
  BisFrm, BisControls;

type
  TBisLotoPrizeInfo=class(TObject)
  public
    var PrizeId: Variant;
    var Name: String;
    var Cost: Extended;
    var Priority: Integer;
  end;

  TBisLotoBarrelFrame=class;

  TBisLotoBarrelFrameActionEvent=procedure (Sender: TBisLotoBarrelFrame; WithStat: Boolean) of object;

  TBisLotoBarrelFrame = class(TBisFrame)
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
    LabelPrize: TLabel;
    ComboBoxPrize: TComboBox;
    PanelWait: TPanel;
    ButtonClear: TBitBtn;
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure EditBarrelNumChange(Sender: TObject);
    procedure ComboBoxPrizeChange(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    FTirageId: Variant;
    FRoundNum: Integer;
    FOnAction: TBisLotoBarrelFrameActionEvent;
    FRoundSum: Extended;
    FTicketCount: Integer;
    FProviderName: String;
    FLotteryList: TStringList;
    FMinCount: Integer;
    FWithPrize: Boolean;
    FLastPrizeId: Variant;
    FClearFromIndex: Integer;

    FDefaultPrize: String;
    FPrizeSumSuffix: String;
    FTicketCountSuffix: String;
    FTicketSumSuffix: String;

    procedure SetWithPrize(const Value: Boolean);
    function GetPrizeId: Variant;
    function GetPrizeCost: Variant;
    function GetLastBarrelNum: String;
    function GetPrizeName: String;
    function GetPrizeSumString: String;
    function GetTicketCountString: String;
    function GetTicketSumString: String;

  protected
    procedure DoAction(WithStat: Boolean);
    function GetBarrelNums: String; virtual;
    function GetTicketSum: Extended; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshPrizes; virtual;
    procedure RefreshBarrels(WithCursor: Boolean); virtual;
    procedure Refresh; virtual;
    procedure SetStatistics; virtual;
    procedure UpdateButtons;
    procedure UpdateScrollBars;
    procedure FirstState;
    function CanAdd: Boolean; virtual;
    procedure Add;
    function CanDelete: Boolean; virtual;
    procedure Delete;
    function CanClear: Boolean; virtual;
    procedure Clear;
    function CheckBarrelNum(BarrelNum: String): Boolean; virtual;
    function ExistsBarrelNum(BarrelNum: String): Boolean; virtual;

//    procedure PrepearOutput(Strings: TStrings); virtual;
//    procedure Output(Dir: String); virtual;
//    procedure Output(Dir: String; TirageNum, UsedCount, PrizeSum, JackpotSum: String); virtual;

    property PrizeId: Variant read GetPrizeId;
    property PrizeCost: Variant read GetPrizeCost;

    property TirageId: Variant read FTirageId write FTirageId;
    property RoundNum: Integer read FRoundNum write FRoundNum;
    property RoundSum: Extended read FRoundSum write FRoundSum;
    property TicketCount: Integer read FTicketCount write FTicketCount;
    property TicketSum: Extended read GetTicketSum;
    property ProviderName: String read FProviderName write FProviderName;

    property PrizeSumString: String read GetPrizeSumString;
    property TicketCountString: String read GetTicketCountString;
    property TicketSumString: String read GetTicketSumString;
    property LastBarrelNum: String read GetLastBarrelNum;
    property BarrelNums: String read GetBarrelNums;
    property PrizeName: String read GetPrizeName;

    property MinCount: Integer read FMinCount write FMinCount;
    property LotteryList: TStringList read FLotteryList;
    property WithPrize: Boolean read FWithPrize write SetWithPrize;

    property ClearFromIndex: Integer read FClearFromIndex write FClearFromIndex;

    property OnAction: TBisLotoBarrelFrameActionEvent read FOnAction write FOnAction;
  end;

procedure StringsSpecialSaveToStream(Str: TStrings; Stream: TStream);

implementation

uses DateUtils,
     BisProvider, BisFilterGroups, BisDialogs, BisCore, BisUtils, BisConsts,
     BisLotoConsts;

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

{ TBisLotoLotteryFrame }

constructor TBisLotoBarrelFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  EditPrizeSum.Color:=ColorControlReadOnly;
  EditTicketCount.Color:=ColorControlReadOnly;
  EditTicketSum.Color:=ColorControlReadOnly;

  EditPrizeSum.Alignment:=taRightJustify;
  EditTicketCount.Alignment:=taRightJustify;
  EditTicketSum.Alignment:=taRightJustify;

  ButtonDel.Enabled:=false;

  FLotteryList:=TStringList.Create;

  FirstState;

  FRoundSum:=0.0;
  FTirageId:=Null;
  FLastPrizeId:=Null;
  FClearFromIndex:=0;
  FDefaultPrize:=ConfigRead('DefaultPrize',FDefaultPrize);
  FPrizeSumSuffix:=ConfigRead('PrizeSumSuffix',FPrizeSumSuffix);
  FTicketCountSuffix:=ConfigRead('TicketCountSuffix',FTicketCountSuffix);
  FTicketSumSuffix:=ConfigRead('TicketSumSuffix',FTicketSumSuffix);

  EditBarrelNumChange(nil);
  SetWithPrize(false);
  
end;

destructor TBisLotoBarrelFrame.Destroy;
begin
  FLotteryList.Free;
  ClearStrings(ComboBoxPrize.Items);
  inherited Destroy;
end;

procedure TBisLotoBarrelFrame.DoAction(WithStat: Boolean);
begin
  if Assigned(FOnAction) then
    FOnAction(Self,WithStat);
end;

procedure TBisLotoBarrelFrame.EditBarrelNumChange(Sender: TObject);
begin
  ButtonAdd.Enabled:=CanAdd;
end;

function TBisLotoBarrelFrame.GetBarrelNums: String;
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

function TBisLotoBarrelFrame.GetLastBarrelNum: String;
begin
  Result:=SUnknownValue;
  if StringGrid.ColCount>2 then
    Result:=Trim(StringGrid.Cells[StringGrid.ColCount-2,1]);
end;

function TBisLotoBarrelFrame.GetPrizeCost: Variant;
var
  Obj: TBisLotoPrizeInfo;
begin
  Result:=Null;
  if ComboBoxPrize.ItemIndex<>-1 then begin
    Obj:=TBisLotoPrizeInfo(ComboBoxPrize.Items.Objects[ComboBoxPrize.ItemIndex]);
    if Assigned(Obj) then
      Result:=Obj.Cost;
  end;
end;

function TBisLotoBarrelFrame.GetPrizeId: Variant;
var
  Obj: TBisLotoPrizeInfo;
begin
  Result:=Null;
  if ComboBoxPrize.ItemIndex<>-1 then begin
    Obj:=TBisLotoPrizeInfo(ComboBoxPrize.Items.Objects[ComboBoxPrize.ItemIndex]);
    if Assigned(Obj) then
      Result:=Obj.PrizeId;
  end;
end;

function TBisLotoBarrelFrame.GetPrizeName: String;
var
  Obj: TBisLotoPrizeInfo;
begin
  Result:=SUnknownValue;
  if ComboBoxPrize.ItemIndex<>-1 then begin
    Obj:=TBisLotoPrizeInfo(ComboBoxPrize.Items.Objects[ComboBoxPrize.ItemIndex]);
    Result:=Obj.Name;
  end else begin
    if Trim(FDefaultPrize)<>'' then
      Result:=FDefaultPrize;
  end;
end;

function TBisLotoBarrelFrame.GetPrizeSumString: String;
begin
  Result:=SUnknownValue;
  if Trim(EditPrizeSum.Text)<>'' then
    Result:=Trim(EditPrizeSum.Text)+iff(Trim(FPrizeSumSuffix)<>'',' '+FPrizeSumSuffix,'');
end;

function TBisLotoBarrelFrame.GetTicketCountString: String;
begin
  Result:=SUnknownValue;
  if Trim(EditTicketCount.Text)<>'' then
    Result:=Trim(EditTicketCount.Text)+iff(Trim(FTicketCountSuffix)<>'',' '+FTicketCountSuffix,'');
end;

function TBisLotoBarrelFrame.GetTicketSumString: String;
begin
  Result:=SUnknownValue;
  if Trim(EditTicketSum.Text)<>'' then
    Result:=Trim(EditTicketSum.Text)+iff(Trim(FTicketSumSuffix)<>'',' '+FTicketSumSuffix,'');
end;

function TBisLotoBarrelFrame.GetTicketSum: Extended;
begin
  Result:=0.0;
  if TicketCount>0 then
    Result:=RoundSum/TicketCount;
end;

procedure TBisLotoBarrelFrame.ButtonAddClick(Sender: TObject);
begin
  if ShowQuestion(Format('%s - это правильный номер боченка?',
                         [Trim(EditBarrelNum.Text)]),mbNo)=mrYes then
    Add;
end;

procedure TBisLotoBarrelFrame.ButtonClearClick(Sender: TObject);
begin
  if ShowQuestion(Format('%s?',[ButtonClear.Hint]),mbNo)=mrYes then
    Clear;
end;

procedure TBisLotoBarrelFrame.ButtonDelClick(Sender: TObject);
begin
  if ShowQuestion(Format('%s?',[ButtonDel.Hint]),mbNo)=mrYes then
    Delete;
end;

procedure TBisLotoBarrelFrame.FirstState;
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
  StringGrid.Cells[0,1]:='№ бочонка';
  StringGrid.ColWidths[0]:=75;
  FLotteryList.Clear;
  UpdateScrollBars;
  FMinCount:=0;
  StringGrid.Repaint;
  UpdateButtons;
end;

procedure TBisLotoBarrelFrame.ComboBoxPrizeChange(Sender: TObject);
begin
  FLastPrizeId:=GetPrizeId;
  EditBarrelNum.SetFocus;
  RefreshBarrels(true);
  DoAction(true);
end;

procedure TBisLotoBarrelFrame.StringGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  OldFont: TFont;
  OldBrush: TBrush;
  S: String;
  W,H: Integer;
  X,Y: Integer;
  Pts: array[0..1] of TPoint;
begin
  OldFont:=TFont.Create;
  OldBrush:=TBrush.Create;
  try
    OldFont.Assign(StringGrid.Canvas.Font);
    OldBrush.Assign(StringGrid.Canvas.Brush);

    StringGrid.Canvas.Brush.Color:=clWindow;
    StringGrid.Canvas.Brush.Style:=bsSolid;
    StringGrid.Canvas.FillRect(Rect);

    if (ACol>0) and (ARow=1) then
      StringGrid.Canvas.Font.Style:=[fsBold]
    else begin
      StringGrid.Canvas.Brush.Color:=StringGrid.FixedColor;
      StringGrid.Canvas.Brush.Style:=bsSolid;
      StringGrid.Canvas.FillRect(Rect);
    end;
    if (ACol>0) and (ACol<(FMinCount+1)) and (ARow=1) then begin
      StringGrid.Canvas.Brush.Color:=StringGrid.FixedColor;
      StringGrid.Canvas.Brush.Style:=bsSolid;
      StringGrid.Canvas.FillRect(Rect);
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

procedure TBisLotoBarrelFrame.UpdateButtons;
begin
  ButtonAdd.Enabled:=CanAdd;
  ButtonDel.Enabled:=CanDelete;
  ButtonClear.Enabled:=CanClear;
end;

procedure TBisLotoBarrelFrame.UpdateScrollBars;
begin
  SendMessage(StringGrid.Handle,WM_HSCROLL,SB_RIGHT,0);
end;

procedure TBisLotoBarrelFrame.RefreshPrizes;
var
  P: TBisProvider;
  Obj: TBisLotoPrizeInfo;
  Index: Integer;
  PrizeIndex: Integer;
  S: String;
  FS: TFormatSettings;
begin
  ClearStrings(ComboBoxPrize.Items);
  if FWithPrize and not VarIsNull(FTirageId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_PRIZES';
      with P.FieldNames do begin
        AddInvisible('PRIZE_ID');
        AddInvisible('NAME');
        AddInvisible('COST');
        AddInvisible('PRIORITY');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
        Filters.Add('ROUND_NUM',fcEqual,FRoundNum).CheckCase:=true;
      end;
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active then begin
        FS.ThousandSeparator:=' ';
        PrizeIndex:=-1;
        ComboBoxPrize.Items.BeginUpdate;
        try
          P.First;
          while not P.Eof do begin
            Obj:=TBisLotoPrizeInfo.Create;
            Obj.PrizeId:=P.FieldByName('PRIZE_ID').Value;
            Obj.Name:=P.FieldByName('NAME').AsString;
            Obj.Cost:=P.FieldByName('COST').AsFloat;
            Obj.Priority:=P.FieldByName('PRIORITY').AsInteger;
            S:=FloatToStrF(Obj.Cost,ffNumber,15,0,FS);//+iff(Trim(FPrizeSumSuffix)<>'',' '+FPrizeSumSuffix,'');
            S:=Format('%s. %s = %s',[FormatFloat('#00',Obj.Priority),Obj.Name,S]);
            Index:=ComboBoxPrize.Items.AddObject(S,Obj);
            if VarSameValue(FLastPrizeId,Obj.PrizeId) then
              PrizeIndex:=Index;
            P.Next;
          end;
        finally
          if ComboBoxPrize.Items.Count>0 then begin
            if PrizeIndex<>-1 then
              ComboBoxPrize.ItemIndex:=PrizeIndex
            else
              ComboBoxPrize.ItemIndex:=0;
          end;
          ComboBoxPrize.Items.EndUpdate;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisLotoBarrelFrame.RefreshBarrels(WithCursor: Boolean);
var
  P: TBisProvider;
  FS: TFormatSettings;
begin
  FirstState;
  if not VarIsNull(FTirageId) then begin
//    EditPrizeSum.Text:=FormatFloat('#0',FRoundSum);
    FS.ThousandSeparator:=' ';
    EditPrizeSum.Text:=FloatToStrF(FRoundSum,ffNumber,15,0,FS);
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=WithCursor;
      P.ProviderName:='S_LOTTERY';
      with P.FieldNames do begin
        AddInvisible('LOTTERY_ID');
        AddInvisible('BARREL_NUM');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
        Filters.Add('ROUND_NUM',fcEqual,FRoundNum).CheckCase:=true;
        Filters.Add('PRIZE_ID',fcEqual,GetPrizeId).CheckCase:=true;
      end;
      P.Orders.Add('INPUT_DATE');
      P.Open;
      if P.Active then begin
        P.First;
        while not P.Eof do begin
          StringGrid.ColCount:=StringGrid.ColCount+1;
          StringGrid.Cells[StringGrid.ColCount-2,0]:=IntToStr(StringGrid.ColCount-2);
          StringGrid.Cells[StringGrid.ColCount-2,1]:=P.FieldByName('BARREL_NUM').AsString;
          StringGrid.Cells[StringGrid.ColCount-1,0]:='';
          StringGrid.Cells[StringGrid.ColCount-1,1]:='';
          FLotteryList.Add(P.FieldByName('LOTTERY_ID').AsString);
          P.Next;
        end;
        UpdateScrollBars;
        StringGrid.Repaint;
        UpdateButtons;
        DoAction(false);
        SetStatistics;
      end;
    finally
      P.Free;
    end;
  end else
    EditPrizeSum.Text:='';
end;

procedure TBisLotoBarrelFrame.Refresh;
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  try
    Screen.Cursor:=crHourGlass;
    RefreshPrizes;
    RefreshBarrels(false);
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

function TBisLotoBarrelFrame.CanAdd: Boolean;
begin
  Result:=(Trim(EditBarrelNum.Text)<>'') and not VarIsNull(FTirageId);
end;

function TBisLotoBarrelFrame.CheckBarrelNum(BarrelNum: String): Boolean;
begin
  Result:=true;
end;

function TBisLotoBarrelFrame.ExistsBarrelNum(BarrelNum: String): Boolean;
begin
  Result:=false;
end;

procedure TBisLotoBarrelFrame.Add;
var
  BarrelNum: String;

  function CheckLocal: Boolean;
  var
    Num: Integer;
  begin
    Result:=false;

    if BarrelNum='' then begin
      ShowError('Введите номер боченка.');
      EditBarrelNum.SetFocus;
      exit;
    end;

    if TryStrToInt(BarrelNum,Num) then
      BarrelNum:=IntToStr(Num);

    if not CheckBarrelNum(BarrelNum) then begin
      ShowError('Неправильный номер боченка.');
      EditBarrelNum.SetFocus;
      exit;
    end;

    if ExistsBarrelNum(BarrelNum) then begin
      ShowError('Такой номер боченка уже существует.');
      EditBarrelNum.SetFocus;
      exit;
    end;

    Result:=true;
  end;

var
  P: TBisProvider;
  Id: String;
  OldCursor: TCursor;
begin
  BarrelNum:=Trim(EditBarrelNum.Text);
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
        AddInvisible('ROUND_NUM').Value:=FRoundNum;
        AddInvisible('BARREL_NUM').Value:=BarrelNum;
        AddInvisible('INPUT_DATE').Value:=Core.ServerDate;
        AddInvisible('PRIZE_ID').Value:=GetPrizeId;
      end;
      P.Execute;
      if P.Success then begin
        StringGrid.ColCount:=StringGrid.ColCount+1;
        StringGrid.Cells[StringGrid.ColCount-2,0]:=IntToStr(StringGrid.ColCount-2);
        StringGrid.Cells[StringGrid.ColCount-2,1]:=BarrelNum;
        FLotteryList.Add(Id);
        UpdateScrollBars;
        StringGrid.Repaint;
        UpdateButtons;
        EditBarrelNum.Text:='';
        EditBarrelNum.SetFocus;
        DoAction(false);
        SetStatistics;
        DoAction(true);
      end;
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

function TBisLotoBarrelFrame.CanDelete: Boolean;
begin
  Result:=not VarIsNull(FTirageId) and (StringGrid.ColCount>(FMinCount+2)) and
          (FLotteryList.Count>0);
end;

procedure TBisLotoBarrelFrame.Delete;
var
  P: TBisProvider;
  BarrelNum: String;
  Id: String;
  OldCursor: TCursor;
begin
  if CanDelete then begin
    BarrelNum:=Trim(StringGrid.Cells[StringGrid.ColCount-2,1]);
    if BarrelNum<>'' then begin
      OldCursor:=Screen.Cursor;
      P:=TBisProvider.Create(nil);
      try
        Screen.Cursor:=crHourGlass;
        Id:=FLotteryList.Strings[FLotteryList.Count-1];
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
          SetStatistics;
          DoAction(true);
        end;
      finally
        P.Free;
        Screen.Cursor:=OldCursor;
      end;
    end;
  end;
end;

function TBisLotoBarrelFrame.CanClear: Boolean;
begin
  Result:=not VarIsNull(FTirageId) and (StringGrid.ColCount>(FMinCount+FClearFromIndex+2)) and
          (FLotteryList.Count>FMinCount+FClearFromIndex);
end;

procedure TBisLotoBarrelFrame.Clear;
var
  P: TBisProvider;
  i: Integer;
  Id: String;
  OldCursor: TCursor;
begin
  if CanClear then begin
    OldCursor:=Screen.Cursor;
    P:=TBisProvider.Create(nil);
    try
      Screen.Cursor:=crHourGlass;
      P.WithWaitCursor:=false;
      P.ProviderName:='D_LOTTERY';
      with P.Params do begin
        AddInvisible('OLD_LOTTERY_ID').Value:=FLotteryList.Strings[FLotteryList.Count-1];
      end;
      for i:=FMinCount+FClearFromIndex to FLotteryList.Count-2 do begin
        Id:=FLotteryList.Strings[i];
        P.PackageParams.Add.AddInvisible('OLD_LOTTERY_ID').Value:=Id;
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
        SetStatistics;
        DoAction(true);
      end;
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisLotoBarrelFrame.SetStatistics;
var
  P: TBisProvider;
  T: TTime;
  MSec: Integer;
  FS: TFormatSettings;
const
  Delay=500;
begin
  Update;
  if not VarIsNull(TirageId) and (Trim(FProviderName)<>'') then begin
    PanelWait.Visible:=StringGrid.ColCount>2;
    P:=TBisProvider.Create(nil);
    T:=Time;
    try
      PanelWait.Update;
      P.WithWaitCursor:=false;
      P.ProviderName:=FProviderName;
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('PRIZE_ID').Value:=PrizeId;
        AddInvisible('TICKET_COUNT',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        TicketCount:=P.Params.ParamByName('TICKET_COUNT').AsInteger;

{       EditTicketCount.Text:=IntToStr(TicketCount);
        EditTicketSum.Text:=FormatFloat('#0',TicketSum);}
        FS.ThousandSeparator:=' ';
        EditTicketCount.Text:=FloatToStrF(TicketCount,ffNumber,15,0,FS);
        EditTicketSum.Text:=FloatToStrF(TicketSum,ffNumber,15,0,FS);
      end;
      MSec:=MilliSecondsBetween(Time,T);
      if PanelWait.Visible and (MSec<Delay) then
        Sleep(Delay-MSec);
    finally
      P.Free;
      PanelWait.Visible:=false;
    end;
  end else begin
    EditTicketCount.Text:='';
    EditTicketSum.Text:='';
  end;
end;

procedure TBisLotoBarrelFrame.SetWithPrize(const Value: Boolean);
begin
  FWithPrize := Value;
  LabelPrize.Visible:=Value;
  ComboBoxPrize.Visible:=Value;
end;

{procedure TBisLotoBarrelFrame.PrepearOutput(Strings: TStrings);
begin
  if Assigned(Strings) then begin
    Strings.Add(PrizeName);
  end;
end;

procedure TBisLotoBarrelFrame.Output(Dir: String);
var
  Str: TStringList;
  FileStream: TFileStream;
  FileName: String;
begin
  if not VarIsNull(FTirageId) then begin
    Str:=TStringList.Create;
    try
      PrepearOutput(Str);
        
//      FileName:=IncludeTrailingPathDelimiter(Dir)+'round'+IntToStr(FRoundNum)+'.txt';
      FileName:=IncludeTrailingPathDelimiter(Dir)+'round.txt';

      FileStream:=TFileStream.Create(FileName,fmCreate);
      FileStream.Free;

      FileStream:=nil;
      try
        FileStream:=TFileStream.Create(FileName,fmOpenWrite or fmShareDenyNone);
        FileStream.Position:=0;

        StringsSpecialSaveToStream(Str,FileStream);
//        Str.SaveToStream(FileStream);

      finally
        if Assigned(FileStream) then
          FileStream.Free;
      end;

    finally
      Str.Free;
    end;
  end;
end;

{procedure TBisLotoBarrelFrame.PrepearOutput(Strings: TStrings);
var
  S: String;
  i: Integer;
begin
  if Assigned(Strings) then begin
    Strings.Add(IntToStr(FRoundNum));
    Strings.Add('');
    Strings.Add(EditPrizeSum.Text);
    Strings.Add('');
    Strings.Add(EditTicketCount.Text);
    Strings.Add('');
    Strings.Add(EditTicketSum.Text);
    Strings.Add('');
    if StringGrid.ColCount>2 then
      Strings.Add(Trim(StringGrid.Cells[StringGrid.ColCount-2,1]))
    else Strings.Add('');
    Strings.Add('');
    S:='';
    for i:=1 to StringGrid.ColCount-2 do begin
      if i=1 then
        S:=Trim(StringGrid.Cells[i,1])
      else S:=S+' '+Trim(StringGrid.Cells[i,1]);
    end;
    Strings.Add(S);
  end;
end;

procedure TBisLotoBarrelFrame.Output(Dir: String; TirageNum, UsedCount, PrizeSum, JackpotSum: String);
var
  Str: TStringList;
  FileStream: TFileStream;
  FileName: String;
begin
  if not VarIsNull(FTirageId) then begin
    Str:=TStringList.Create;
    try
      PrepearOutput(Str);

      FileName:=IncludeTrailingPathDelimiter(Dir)+'round'+IntToStr(FRoundNum)+'.txt';

      FileStream:=TFileStream.Create(FileName,fmCreate);
      FileStream.Free;

      FileStream:=nil;
      try
        FileStream:=TFileStream.Create(FileName,fmOpenWrite or fmShareDenyNone);
        FileStream.Position:=0;

        Str.SaveToStream(FileStream);

      finally
        if Assigned(FileStream) then
          FileStream.Free;
      end;

    finally
      Str.Free;
    end;
  end;
end;}

end.
