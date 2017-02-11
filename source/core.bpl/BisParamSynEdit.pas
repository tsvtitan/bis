unit BisParamSynEdit;

interface

uses Windows, Classes, Controls, StdCtrls, DB, 
     BisParam, BisControls;

type

  TBisParamSynEdit=class(TBisParam)
  private
    FSynEdit: TSynEdit;
    FLabelSynEdit: TLabel;
    FSynEditName: String;
    FLabelName: String;
    FOldSynEditChange: TNotifyEvent;
    FOldSynEditKeyDown: TKeyEvent;

    procedure SynEditChange(Sender: TObject);
    procedure SynEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
    function GetEmpty: Boolean; override;
    function GetSize: Integer; override;
    procedure SetSize(const Value: Integer); override;
    function GetCaption: String; override;
    function GetControl: TWinControl; override;
//    procedure SetEnabled(const Value: Boolean); override;
    procedure GetControls(List: TList); override;

  public
    constructor Create; override;
    procedure CopyFrom(Source: TBisParam; WithReset: Boolean=true); override;
    procedure LinkControls(Parent: TWinControl); override;

    property SynEdit: TSynEdit read FSynEdit write FSynEdit;
    property LabelSynEdit: TLabel read FLabelSynEdit;
    
    property SynEditName: String read FSynEditName write FSynEditName;
    property LabelName: String read FLabelName write FLabelName;
  end;

implementation

uses Variants, Graphics,
     BisUtils, BisConsts;


{ TBisParamSynEdit }

constructor TBisParamSynEdit.Create;
begin
  inherited Create;
  DataType:=ftString;
end;

procedure TBisParamSynEdit.CopyFrom(Source: TBisParam; WithReset: Boolean);
begin
  inherited CopyFrom(Source,WithReset);
  if Assigned(Source) and (Source is TBisParamSynEdit) then begin
    SynEditName:=TBisParamSynEdit(Source).SynEditName;
    LabelName:=TBisParamSynEdit(Source).LabelName;
  end;
end;

procedure TBisParamSynEdit.LinkControls(Parent: TWinControl);
var
  TempValue: Variant;
  Component: TComponent;
  Memo: TMemo;
begin
  if Assigned(Parent) then begin
    TempValue:=Value;
    Component:=DoFindComponent(FSynEditName);
    if Assigned(Component) and (Component is TMemo) then begin
      Memo:=TMemo(Component);
      FSynEdit:=ReplaceMemoToSynEdit(Memo);
      if Assigned(FSynEdit) then begin
        FOldSynEditChange:=FSynEdit.OnChange;
        FOldSynEditKeyDown:=FSynEdit.OnKeyDown;
        FSynEdit.OnChange:=SynEditChange;
        FSynEdit.OnKeyDown:=SynEditKeyDown;
  //      FSynEdit.MaxLength:=inherited GetSize;
        FSynEdit.Color:=iff(FSynEdit.Color=clBtnFace,ColorControlReadOnly,FSynEdit.Color);
        FLabelSynEdit:=TLabel(DoFindComponent(FLabelName));
        if Assigned(FLabelSynEdit) then
          FLabelSynEdit.FocusControl:=FSynEdit;
      end;
      Value:=TempValue;
    end;
  end;
  inherited LinkControls(Parent);
  if Assigned(FSynEdit) then begin
  end;
end;

function TBisParamSynEdit.GetValue: Variant;
var
  Stream: TMemoryStream;
  AValue: String;
begin
  Result:=inherited GetValue;
  if Assigned(FSynEdit) then begin
    Stream:=TMemoryStream.Create;
    try
      FSynEdit.Lines.SaveToStream(Stream);
      Stream.Position:=0;
      SetLength(AValue,Stream.Size);
      Stream.ReadBuffer(Pointer(AValue)^,Stream.Size);
      Result:=iff(not Empty,AValue,Result);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TBisParamSynEdit.SetValue(const AValue: Variant);
var
  Stream: TMemoryStream;
  S: String;
begin
  if not VarSameValue(Value,AValue) then begin
    if Assigned(FSynEdit) then begin
      Stream:=TMemoryStream.Create;
      FSynEdit.OnChange:=nil;
      try
        S:=VarToStrDef(AValue,'');
        Stream.WriteBuffer(Pointer(S)^,Length(S));
        Stream.Position:=0;
        FSynEdit.Lines.LoadFromStream(Stream);
      finally
        FSynEdit.OnChange:=SynEditChange;
        Stream.Free;
      end;
    end;
    inherited SetValue(AValue);
  end;
end;

function TBisParamSynEdit.GetCaption: String;
begin
  Result:=inherited GetCaption;
  if Assigned(FLabelSynEdit) then
    Result:=FLabelSynEdit.Caption;   
end;

function TBisParamSynEdit.GetControl: TWinControl;
begin
  Result:=FSynEdit;
end;

function TBisParamSynEdit.GetEmpty: Boolean;
begin
  if Assigned(FSynEdit) then
    Result:=FSynEdit.Lines.Text=''
  else
    Result:=inherited GetEmpty;
end;

function TBisParamSynEdit.GetSize: Integer;
begin
  Result:=inherited GetSize;
  if Assigned(FSynEdit) then
//    Result:=FSynEdit.MaxLength;
end;

procedure TBisParamSynEdit.GetControls(List: TList);
begin
  inherited GetControls(List);
  if Assigned(List) then
    List.Add(FLabelSynEdit);
end;

{procedure TBisParamSynEdit.SetEnabled(const Value: Boolean);
begin
  inherited SetEnabled(Value);
  if Assigned(FLabelSynEdit) then
    FLabelSynEdit.Enabled:=false;
end;}

procedure TBisParamSynEdit.SetSize(const Value: Integer);
begin
  if Size<>Value then
    if Assigned(FSynEdit) then
//      FSynEdit.MaxLength:=Value
    else
      inherited SetSize(Value);
end;

procedure TBisParamSynEdit.SynEditChange(Sender: TObject);
begin
  DoChange(Self);
  if Assigned(FOldSynEditChange) then
    FOldSynEditChange(Sender);
end;

procedure TBisParamSynEdit.SynEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DoKeyDown(Sender,Key,Shift);
  if Assigned(FOldSynEditKeyDown) then 
    FOldSynEditKeyDown(Sender,Key,Shift);
end;

end.
