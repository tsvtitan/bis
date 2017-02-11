unit BisKrieltDataQuestionsFrm;

interface                                                                                                 

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls, Contnrs,

  BisDataGridFrm, BisKrieltDataAnswersFm;

type
  TBisKrieltDataQuestionsFrameIfaces=class(TObjectList)
  public
    function FindAnswerById(QuestionId: Variant): TBisKrieltDataAnswersFormIface;
  end;

  TBisKrieltDataQuestionsFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    N18: TMenuItem;
    ToolButtonAnswers: TToolButton;
    ActionAnswers: TAction;
    MenuItemAnswers: TMenuItem;
    procedure ActionAnswersExecute(Sender: TObject);
    procedure ActionAnswersUpdate(Sender: TObject);
  private
    FIfaces: TBisKrieltDataQuestionsFrameIfaces;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanAnswers: Boolean;
    procedure Answers;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataQuestionsFrameIfaces }

function TBisKrieltDataQuestionsFrameIfaces.FindAnswerById(QuestionId: Variant): TBisKrieltDataAnswersFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisKrieltDataAnswersFormIface) then begin
      if VarSameValue(TBisKrieltDataAnswersFormIface(Obj).QuestionId,QuestionId) then begin
        Result:=TBisKrieltDataAnswersFormIface(Obj);
        exit;
      end; 
    end;
  end;
end;

{ TBisKrieltDataColumnsFrame }

constructor TBisKrieltDataQuestionsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisKrieltDataQuestionsFrameIfaces.Create;
end;

destructor TBisKrieltDataQuestionsFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataQuestionsFrame.ActionAnswersExecute(Sender: TObject);
begin
  Answers;
end;

procedure TBisKrieltDataQuestionsFrame.ActionAnswersUpdate(Sender: TObject);
begin
  ActionAnswers.Enabled:=CanAnswers;
end;

function TBisKrieltDataQuestionsFrame.CanAnswers: Boolean;
var
  Iface: TBisKrieltDataAnswersFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisKrieltDataAnswersFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisKrieltDataQuestionsFrame.Answers;
var
  Iface: TBisKrieltDataAnswersFormIface;
  QuestionId: Variant;
  QuestionNum: String;
  QuestionDateCreate: TDateTime;
begin
  if CanAnswers then begin
    QuestionId:=Provider.FieldByName('QUESTION_ID').Value;
    QuestionNum:=Provider.FieldByName('NUM').AsString;
    QuestionDateCreate:=Provider.FieldByName('DATE_CREATE').AsDateTime;
    Iface:=FIfaces.FindAnswerById(QuestionId);
    if not Assigned(Iface) then begin
      Iface:=TBisKrieltDataAnswersFormIface.Create(Self);
      Iface.QuestionId:=QuestionId;
      Iface.QuestionNum:=QuestionNum;
      Iface.QuestionDateCreate:=QuestionDateCreate;
      Iface.MaxFormCount:=1;
      Iface.FilterOnShow:=false;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.LoadOptions;
      Iface.FilterGroups.Add.Filters.Add('QUESTION_ID',fcEqual,QuestionId).CheckCase:=true;
    end;
    Iface.Caption:=FormatEx('%s => %s �� %s',[ActionAnswers.Hint,QuestionNum,DateTimeToStr(QuestionDateCreate)]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;    
  end;
end;

end.
