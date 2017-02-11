unit BisTaxiCallResultFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,                                                                               
  BisFm, BisDialogFm;

type
  TRadioGroup=class(ExtCtrls.TRadioGroup)
  end;

  TBisTaxiCallResultForm = class(TBisDialogForm)
    RadioGroupCallResults: TRadioGroup;
    procedure RadioGroupCallResultsClick(Sender: TObject);
  private
    FNum: String;
    FOldCaption: String;
    procedure FillCallResults;
    procedure UpdateAutoSize;
    procedure UpdateOk;
    procedure SetNum(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CallResultId: Variant;

    property Num: String read FNum write SetNum;
  end;

var
  BisTaxiCallResultForm: TBisTaxiCallResultForm;

implementation

uses BisUtils, BisProvider, BisFilterGroups;

{$R *.dfm}

type
  TBisTaxiCallResultInfo=class(TObject)
    var CallResultId: Variant;
  end;

{ TBisTaxiCallResultForm }

constructor TBisTaxiCallResultForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOldCaption:=Caption;
  FillCallResults;
  UpdateAutoSize;
  UpdateOk;
end;

destructor TBisTaxiCallResultForm.Destroy;
begin
  ClearStrings(RadioGroupCallResults.Items);
  inherited Destroy;
end;

procedure TBisTaxiCallResultForm.UpdateAutoSize;
var
  i: Integer;
  MinW, MinH: Integer;
  W, H: Integer;
  MaxW: Integer;
  S: String;
begin
  MinW:=210;
  MinH:=150;
  MaxW:=0;
  H:=RadioGroupCallResults.Canvas.TextHeight('W')+5;
  H:=Height+RadioGroupCallResults.Items.Count*H;
  if H>MinH then
    Height:=H;
  for i:=0 to RadioGroupCallResults.Items.Count-1 do begin
    S:=RadioGroupCallResults.Items.Strings[i];
    W:=ButtonOk.Width+RadioGroupCallResults.Canvas.TextWidth(S);
    if W>MaxW then
      MaxW:=W;
  end;
  if MaxW>MinW then
    Width:=MaxW;
end;

procedure TBisTaxiCallResultForm.UpdateOk;
begin
  ButtonOk.Enabled:=not VarIsNull(CallResultId);
end;

procedure TBisTaxiCallResultForm.FillCallResults;
var
  P: TBisProvider;
  Obj: TBisTaxiCallResultInfo;
begin
  ClearStrings(RadioGroupCallResults.Items);
  P:=TBisProvider.Create(nil);
  try
    P.UseWaitCursor:=false;
    P.ProviderName:='S_CALL_RESULTS';
    P.FilterGroups.Add.Filters.Add('VISIBLE',fcEqual,1);
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active then begin
      P.First;
      while not P.Eof do begin
        Obj:=TBisTaxiCallResultInfo.Create;
        Obj.CallResultId:=P.FieldByName('CALL_RESULT_ID').Value;
        RadioGroupCallResults.Items.AddObject(P.FieldByName('NAME').AsString,Obj);
        P.Next;
      end;
      if RadioGroupCallResults.Items.Count>0 then begin
        RadioGroupCallResults.ItemIndex:=0;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiCallResultForm.RadioGroupCallResultsClick(Sender: TObject);
begin
  UpdateOk;
end;

procedure TBisTaxiCallResultForm.SetNum(const Value: String);
begin
  FNum := Value;
  Caption:=FormatEx('%s %s',[FOldCaption,FNum]);
end;

function TBisTaxiCallResultForm.CallResultId: Variant;
var
  Index: Integer;
  Obj: TBisTaxiCallResultInfo;
begin
  Result:=Null;
  Index:=RadioGroupCallResults.ItemIndex;
  if Index<>-1 then begin
    Obj:=TBisTaxiCallResultInfo(RadioGroupCallResults.Items.Objects[Index]);
    if Assigned(Obj) then
      Result:=Obj.CallResultId;
  end;
end;


end.
