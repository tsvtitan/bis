unit BisParamPopupDataSelect;

interface

uses Classes, Controls, StdCtrls, DB,
     BisParam, BisControls;

type

  TBisParamPopupDataSelect=class(TBisParam)
  private
    FEditPopup: TEditPopup;
    FLabelEdit: TLabel;
    FEditName: String;
    FLabelName: String;
    FDataClass: TComponentClass;
    FAlias: String;
    FDataAlias: String;
    FDataClassName: String;
    FDataName: String;
    FDataIface: TComponent;
    FOldEditPopupChange: TNotifyEvent;
    procedure EditPopupChange(Sender: TObject);
    procedure EditPopupDropDown(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LinkControls(Parent: TWinControl); override;
    procedure CopyFrom(Source: TBisParam; WithReset: Boolean=true); override;

    property EditName: String read FEditName write FEditName;
    property LabelName: String read FLabelName write FLabelName;
    property EditPopup: TEditPopup read FEditPopup;
    property LabelEdit: TLabel read FLabelEdit;
    property DataClass: TComponentClass read FDataClass write FDataClass;
    property DataClassName: String read FDataClassName write FDataClassName;
    property Alias: String read FAlias write FAlias;
    property DataAlias: String read FDataAlias write FDataAlias;
    property DataName: String read FDataName write FDataName;
  end;

implementation

uses Variants, Graphics,
     BisUtils, BisConsts, BisDataFm, BisCore, BisDataFrm, BisFm;

{ TBisParamPopupDataSelect }

constructor TBisParamPopupDataSelect.Create;
begin
  inherited Create;
  FDataIface:=nil;
end;

destructor TBisParamPopupDataSelect.Destroy;
begin
  FreeAndNilEx(FDataIface);
  inherited Destroy;
end;

procedure TBisParamPopupDataSelect.CopyFrom(Source: TBisParam; WithReset: Boolean);
begin
  inherited CopyFrom(Source,WithReset);
  if Assigned(Source) and (Source is TBisParamPopupDataSelect) then begin
    EditName:=TBisParamPopupDataSelect(Source).EditName;
    LabelName:=TBisParamPopupDataSelect(Source).LabelName;
    DataClass:=TBisParamPopupDataSelect(Source).DataClass;
    DataClassName:=TBisParamPopupDataSelect(Source).DataClassName;
    Alias:=TBisParamPopupDataSelect(Source).Alias;
    DataAlias:=TBisParamPopupDataSelect(Source).DataAlias;
    DataName:=TBisParamPopupDataSelect(Source).DataName;
  end;
end;

procedure TBisParamPopupDataSelect.LinkControls(Parent: TWinControl);
var
  Component: TComponent;
  TempValue: Variant;
begin
  if Assigned(Parent) then begin
    TempValue:=Value;
    Component:=DoFindComponent(FEditName);
    if Assigned(Component) and (Component is TEdit) then
      FEditPopup:=ReplaceEditToEditPopup(TEdit(Component));
    if Assigned(FEditPopup) then begin
      FOldEditPopupChange:=FEditPopup.OnChange;
      FEditPopup.OnChange:=EditPopupChange;
      FEditPopup.OnDropDown:=EditPopupDropDown;
      FEditPopup.MaxLength:=inherited GetSize;
      FEditPopup.Color:=iff(FEditPopup.Color=clBtnFace,ColorControlReadOnly,FEditPopup.Color);
      FLabelEdit:=TLabel(DoFindComponent(FLabelName));
      if Assigned(FLabelEdit) then
        FLabelEdit.FocusControls.Add(FEditPopup);
      Value:=TempValue;
    end;
  end;
  inherited LinkControls(Parent);
  if Assigned(FEditPopup) then begin
  end;
end;

procedure TBisParamPopupDataSelect.EditPopupChange(Sender: TObject);
begin
  DoChange(Self);
  if Assigned(FOldEditPopupChange) then
    FOldEditPopupChange(Sender);
end;

procedure TBisParamPopupDataSelect.EditPopupDropDown(Sender: TObject);
var
  AClass: TComponentClass;
  ADataIface: TBisDataFormIface;
  ADataFrame: TBisDataFrame;
begin
  AClass:=FDataClass;
  if Assigned(FEditPopup) then begin
    if not Assigned(AClass) and Assigned(Core) then
      AClass:=Core.FindIfaceClass(FDataClassName);
    if Assigned(AClass) then begin
      if IsClassParent(AClass,TBisDataFormIface) then begin
        ADataIface:=TBisDataFormIface(FDataIface);
        if not Assigned(ADataIface) then begin
          ADataIface:=TBisDataFormIfaceClass(AClass).Create(FEditPopup.Owner);
          FDataIface:=ADataIface;
        end;
        if Assigned(ADataIface) then begin
          ADataFrame:=ADataIface.CreateDataFrame(false);
          if Assigned(ADataFrame) then begin
            ADataFrame.Align:=alClient;
            ADataFrame.Font:=FEditPopup.Font;
            ADataFrame.Ctl3D:=FEditPopup.Ctl3D;
            ADataFrame.ParentCtl3D:=false;
            ADataFrame.ParentFont:=false;
            ADataFrame.AsModal:=true;
//            ADataFrame.ShowType:=stDefault;
            FEditPopup.Control:=ADataFrame;
            ADataFrame.OpenRecords;
          end;
        end;
      end;
    end;
  end;
end;

end.
