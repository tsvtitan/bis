unit BisParamComboDataFrame;

interface

uses Classes, Controls, StdCtrls, DB,
     BisParam, BisPopupEdit, BisControls;

type

  TBisParamComboDataFrame=class(TBisParam)
  private
    FPopupEdit: TBisPopupEdit;
    FLabelPopupEdit: TLabel;
    FPopupEditName: String;
    FLabelName: String;
    FDataClass: TComponentClass;
    FAlias: String;
    FDataAlias: String;
    FDataClassName: String;
    FDataName: String;
    
  public
    constructor Create; override;
    procedure LinkControls(Parent: TWinControl); override;
    procedure CopyFrom(Source: TBisParam; WithReset: Boolean=true); override;

    property PopupEditName: String read FPopupEditName write FPopupEditName;
    property LabelName: String read FLabelName write FLabelName;
    property PopupEdit: TBisPopupEdit read FPopupEdit;

    property LabelPopupEdit: TLabel read FLabelPopupEdit;
    property DataClass: TComponentClass read FDataClass write FDataClass;
    property DataClassName: String read FDataClassName write FDataClassName;
    property Alias: String read FAlias write FAlias;
    property DataAlias: String read FDataAlias write FDataAlias;
    property DataName: String read FDataName write FDataName;
  end;

implementation

uses Variants, Graphics,
     BisUtils, BisConsts;

{ TBisParamComboDataFrame }

constructor TBisParamComboDataFrame.Create;
begin
  inherited Create;

end;

procedure TBisParamComboDataFrame.CopyFrom(Source: TBisParam; WithReset: Boolean);
begin
  inherited CopyFrom(Source,WithReset);
  if Assigned(Source) and (Source is TBisParamComboDataFrame) then begin
    DataClass:=TBisParamComboDataFrame(Source).DataClass;
    DataClassName:=TBisParamComboDataFrame(Source).DataClassName;
    Alias:=TBisParamComboDataFrame(Source).Alias;
    DataAlias:=TBisParamComboDataFrame(Source).DataAlias;
    DataName:=TBisParamComboDataFrame(Source).DataName;
  end;
end;

procedure TBisParamComboDataFrame.LinkControls(Parent: TWinControl);
var
  TempValue: Variant;
begin
  if Assigned(Parent) then begin
    TempValue:=Value;
    FPopupEdit:=TPopupEdit(DoFindComponent(FPopupEditName));
    if Assigned(FPopupEdit) then begin
{      FOldPopupEditChange:=FPopupEdit.OnChange;
      FPopupEdit.OnChange:=PopupEditChange;}
      FPopupEdit.MaxLength:=inherited GetSize;
      FPopupEdit.Color:=iff(FPopupEdit.Color=clBtnFace,ColorControlReadOnly,FPopupEdit.Color);
      FLabelPopupEdit:=TLabel(DoFindComponent(FLabelName));
      if Assigned(FLabelPopupEdit) then
        FLabelPopupEdit.FocusControl:=FPopupEdit;
    end;
    Value:=TempValue;
  end;
  inherited LinkControls(Parent);
  if Assigned(FPopupEdit) then begin
  end;
end;

end.