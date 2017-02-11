unit BisSupportReasonsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs,
  BisFm, BisDialogFm;

type
  TGroupBox=class(StdCtrls.TGroupBox)
  end;

  TBisSupportReasonsForm = class(TBisDialogForm)
    GroupBoxReasons: TGroupBox;
    EditOther: TEdit;
    procedure RadioGroupReasonsClick(Sender: TObject);
    procedure EditOtherChange(Sender: TObject);
  private
    FTitle: String;
    FOldCaption: String;
    FRadioButtons: TObjectList;
    FSReasonOther: String;
    FRadioButtonOther: TRadioButton;
    procedure UpdateOk;
//    procedure UpdateAutoSize;
    procedure SetTitle(const Value: String);
    procedure RadioButtonClick(Sender: TObject);
    procedure EnableOther(AEnabled: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Reason: String;
    procedure SetReasons(Reasons: TStrings);

    property Title: String read FTitle write SetTitle;
  published
    property SReasonOther: String read FSReasonOther write FSReasonOther;
  end;

var
  BisSupportReasonsForm: TBisSupportReasonsForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiCallResultForm }

constructor TBisSupportReasonsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SizeGrip.Visible:=true;
  FOldCaption:=Caption;
  FRadioButtons:=TObjectList.Create;
  EnableOther(false);
  UpdateOk;
  FSReasonOther:='������ �������:';
end;

destructor TBisSupportReasonsForm.Destroy;
begin
  FRadioButtons.Free;
  inherited Destroy;
end;

procedure TBisSupportReasonsForm.EnableOther(AEnabled: Boolean);
begin
  EditOther.Enabled:=AEnabled;
  EditOther.Color:=iff(AEnabled,clWindow,clBtnFace);
end;

procedure TBisSupportReasonsForm.RadioButtonClick(Sender: TObject);
begin
  if Sender=FRadioButtonOther then
    EnableOther(true)
  else
    EnableOther(false);
  UpdateOk;  
end;

procedure TBisSupportReasonsForm.SetReasons(Reasons: TStrings);
var
 ATabOrder: TTabOrder;

  function AddRadioButton(S: String; ATop,ALeft,AWidth: Integer): TRadioButton;
  begin
    Result:=TRadioButton.Create(Self);
    FRadioButtons.Add(Result);
    Result.Parent:=GroupBoxReasons;
    Result.Top:=ATop;
    Result.Left:=ALeft;
    Result.Width:=AWidth;
    Result.Caption:=S;
    Result.Checked:=false;
    Result.WordWrap:=false;
    Result.TabOrder:=ATabOrder;
    Result.OnClick:=RadioButtonClick;
    Inc(ATabOrder);
  end;

var
  RadioButton: TRadioButton;
  S: String;
  ATop,ALeft: Integer;
  AHeight, AWidth: Integer;
  H,W: Integer;
  dH,dW: Integer;
  i: Integer;
begin
  EditOther.Visible:=false;
  FRadioButtons.Clear;
  if Assigned(Reasons) then begin

    ATop:=18;
    ALeft:=10;
    AHeight:=Height;
    AWidth:=Width;
    H:=AHeight;
    dH:=5;
    dW:=20;
    ATabOrder:=0;


    EditOther.Anchors:=[akLeft,akTop];

    for i:=0 to Reasons.Count-1 do begin
      S:=Reasons[i];
      if Trim(S)<>'' then begin
        W:=GroupBoxReasons.Canvas.TextWidth(S)+dW;
        RadioButton:=AddRadioButton(S,ATop,ALeft,W);
        ATop:=RadioButton.Top+RadioButton.Height+dH;
        if (W+dW*2)>AWidth then
          AWidth:=W+dW*2;

        Inc(H,RadioButton.Height);
        Inc(H,dH);
      end;
    end;

    W:=GroupBoxReasons.Canvas.TextWidth(FSReasonOther)+dW;
    FRadioButtonOther:=AddRadioButton(FSReasonOther,ATop,ALeft,W);
    if (W+dW*2)>AWidth then
      AWidth:=W+dW*2;

    FRadioButtonOther.Checked:=FRadioButtons.Count=1;

    Inc(H,FRadioButtonOther.Height);
    Inc(H,dH);
    ATop:=FRadioButtonOther.Top+FRadioButtonOther.Height+dH;

    Width:=AWidth;

    EditOther.Visible:=true;
    EditOther.Left:=FRadioButtonOther.Left+dH*3;
    EditOther.Top:=ATop;
    EditOther.Width:=GroupBoxReasons.ClientWidth-EditOther.Left-dH*2;
    EditOther.TabOrder:=ATabOrder;
    EditOther.Anchors:=[akLeft,akTop,akRight];

 {   if FRadioButtons.Count>1 then
      Inc(H,EditOther.Height+dH);  }

    if H>AHeight then
      AHeight:=H;

    Height:=AHeight;

    Constraints.MinHeight:=Height;
    Constraints.MinWidth:=Width;

  end;
end;

procedure TBisSupportReasonsForm.UpdateOk;
begin
  ButtonOk.Enabled:=Trim(Reason)<>'';
end;

procedure TBisSupportReasonsForm.RadioGroupReasonsClick(Sender: TObject);
begin
  UpdateOk;
end;

procedure TBisSupportReasonsForm.EditOtherChange(Sender: TObject);
begin
  UpdateOk;
end;

function TBisSupportReasonsForm.Reason: String;
var
  i: Integer;
  Item: TRadioButton;
begin
  Result:='';
  for i:=0 to FRadioButtons.Count-1 do begin
    Item:=TRadioButton(FRadioButtons.Items[i]);
    if Item.Checked then begin
      if Item<>FRadioButtonOther then
        Result:=Item.Caption
      else
        Result:=Trim(EditOther.Text);
      exit;
    end;
  end;
end;

procedure TBisSupportReasonsForm.SetTitle(const Value: String);
begin
  FTitle := Value;
  if Trim(FTitle)<>'' then
    Caption:=FormatEx('%s (%s)',[FOldCaption,FTitle]);
end;

end.
