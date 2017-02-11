unit BisParamEditDataSelect;

interface

uses Classes, Controls, DB, StdCtrls, Windows,
     BisFilterGroups, BisVariants, BisValues,
     BisParam, BisParamInvisible, BisParamEdit, BisControls;

type
  TBisParamEditDataSelect=class;

  TBisParamEditDataSelectCheckValueEvent=procedure (Def: TBisParamEditDataSelect; var NewValue: Variant; var CanSet: Boolean) of object;
  TBisParamEditDataSelectAfterSelect=procedure (Def: TBisParamEditDataSelect) of object;

  TBisParamEditDataSelect=class(TBisParamInvisible)
  private
    FButtonName: String;
    FDataClass: TComponentClass;
    FAlias: String;
    FDataAlias: String;
    FParamEdit: TBisParamEdit;
    FButton: TButton;
    FOldButtonClick: TNotifyEvent;
    FOldEditKeyDown: TKeyEvent;
    FDataName: String;
    FFilterGroups: TBisFilterGroups;
    FDataAliasDelim: String;
    FFilterOnShow: Boolean;
    FDataAliasFormat: String;
    FOnCheckValue: TBisParamEditDataSelectCheckValueEvent;
    FOnAfterSelect: TBisParamEditDataSelectAfterSelect;
    FDataClassName: String;
    FValues: TBisValues;
    FDataCaption: String;

    procedure ParamEditLinkControls(AParent: TWinControl);
    procedure ButtonClick(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoCheckValue(var NewValue: Variant; var CanSet: Boolean);
    procedure DoAfterSelect;
    procedure SetDataAliasFormat(const Value: String);
  protected
  //  procedure SetEnabled(const Value: Boolean); override;
     procedure GetControls(List: TList); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisParam; WithReset: Boolean=true); override;
    procedure LinkControls(Parent: TWinControl); override;
    procedure Clear; override;

    function Select: Boolean;

    property ButtonName: String read FButtonName write FButtonName;
    property DataClass: TComponentClass read FDataClass write FDataClass;
    property DataClassName: String read FDataClassName write FDataClassName; 
    property Alias: String read FAlias write FAlias;
    property DataAlias: String read FDataAlias write FDataAlias;
    property Button: TButton read FButton;
    property DataName: String read FDataName write FDataName;
    property DataAliasDelim: String read FDataAliasDelim write FDataAliasDelim;
    property DataAliasFormat: String read FDataAliasFormat write SetDataAliasFormat;
    property FilterGroups: TBisFilterGroups read FFilterGroups;
    property FilterOnShow: Boolean read FFilterOnShow write FFilterOnShow;
    property DataCaption: String read FDataCaption write FDataCaption; 
    
    property Values: TBisValues read FValues;

    property OnCheckValue: TBisParamEditDataSelectCheckValueEvent read FOnCheckValue write FOnCheckValue;
    property OnAfterSelect: TBisParamEditDataSelectAfterSelect read FOnAfterSelect write FOnAfterSelect;
  end;

implementation

uses Variants, SysUtils,
     BisDataFm, BisProvider, BisUtils, BisConsts, BisCore, BisFm;

{ TBisParamEditDataSelect }

constructor TBisParamEditDataSelect.Create;
begin
  inherited Create;
  FFilterGroups:=TBisFilterGroups.Create;
  FValues:=TBisValues.Create;
  FDataAliasDelim:=' ';
end;

destructor TBisParamEditDataSelect.Destroy;
begin
  FValues.Free;
  FFilterGroups.Free;
  inherited Destroy;
end;

procedure TBisParamEditDataSelect.Clear;
begin
  inherited Clear;
  FValues.Clear;
end;

procedure TBisParamEditDataSelect.CopyFrom(Source: TBisParam; WithReset: Boolean);
begin
  inherited CopyFrom(Source,WithReset);
  if Assigned(Source) and (Source is TBisParamEditDataSelect) then begin
    ButtonName:=TBisParamEditDataSelect(Source).ButtonName;
    DataClass:=TBisParamEditDataSelect(Source).DataClass;
    DataClassName:=TBisParamEditDataSelect(Source).DataClassName;
    Alias:=TBisParamEditDataSelect(Source).Alias;
    DataAlias:=TBisParamEditDataSelect(Source).DataAlias;
    DataName:=TBisParamEditDataSelect(Source).DataName;
    DataAliasDelim:=TBisParamEditDataSelect(Source).DataAliasDelim;
    DataAliasFormat:=TBisParamEditDataSelect(Source).DataAliasFormat;
    FilterGroups.CopyFrom(TBisParamEditDataSelect(Source).FilterGroups);
    FilterOnShow:=TBisParamEditDataSelect(Source).FilterOnShow;
    DataCaption:=TBisParamEditDataSelect(Source).DataCaption;
  end;
end;

procedure TBisParamEditDataSelect.ParamEditLinkControls(AParent: TWinControl);
begin
  if Assigned(FParamEdit) and Assigned(FParamEdit.Edit) then begin
    FOldEditKeyDown:=FParamEdit.Edit.OnKeyDown;
    FParamEdit.Edit.OnKeyDown:=EditKeyDown;
    FParamEdit.ParamFormat:=FDataAliasFormat;
  end;
end;

procedure TBisParamEditDataSelect.LinkControls(Parent: TWinControl);
begin
  if Assigned(Parent) then begin
    FButton:=TButton(DoFindComponent(FButtonName));
    if Assigned(FButton) then begin
      FOldButtonClick:=FButton.OnClick;
      FButton.OnClick:=ButtonClick;
    end;   
    FParamEdit:=TBisParamEdit(Find(FDataName));
    if Assigned(FParamEdit) then begin
      FParamEdit.ParamType:=ptUnknown;
      FParamEdit.OnLinkControls:=ParamEditLinkControls;
    end;
  end;
  inherited LinkControls(Parent);
  if Assigned(FButton) then begin
  end;
end;

function TBisParamEditDataSelect.Select: Boolean;
var
  AClass: TComponentClass;
  Iface: TBisDataFormIface;
  Provider: TBisProvider;
  Field: TField;
  CanSet: Boolean;
  NewValue: Variant;
  List: TStringList;
  i: Integer;
  S: String;
  First: Boolean;
  Args: TBisVariants;
  Param: TBisParam;
begin
  Result:=false;
  AClass:=FDataClass;
  if not Assigned(AClass) and Assigned(Core) then
    AClass:=Core.FindIfaceClass(FDataClassName);
  if Assigned(AClass) then begin
    if IsClassParent(AClass,TBisDataFormIface) then begin
      Iface:=TBisDataFormIfaceClass(AClass).Create(nil);
      Provider:=TBisProvider.Create(nil);
      try
        FValues.Clear;
        Iface.FilterGroups.CopyFrom(FFilterGroups,false);
        Iface.LocateFields:=Alias;
        Iface.LocateValues:=Value;
        Iface.FilterOnShow:=FFilterOnShow;
//        Iface.ShowType:=stNormal;
        Iface.Init;
        Iface.Caption:=iff(Trim(FDataCaption)<>'',FDataCaption,Iface.Caption);
        if Iface.SelectInto(Provider) then begin
          if Provider.Active and not Provider.IsEmpty then begin
            Provider.First;
            Field:=Provider.FindField(Alias);
            if Assigned(Field) then begin
              CanSet:=true;
              NewValue:=Field.Value;
              DoCheckValue(NewValue,CanSet);
              if CanSet then begin
                Value:=NewValue;
                if Assigned(FParamEdit) then begin
                  List:=TStringList.Create;
                  Args:=TBisVariants.Create;
                  try
                    S:='';
                    First:=true;
                    for i:=0 to Provider.Fields.Count-1 do begin
                      Field:=Provider.Fields[i];
                      FValues.Add(Field.FieldName,Field.Value);
                    end;
                    GetStringsByString(DataAlias,SFieldDelim,List);
                    for i:=0 to List.Count-1 do begin
                      Field:=Provider.FindField(List[i]);
                      if Assigned(Field) then begin
                        Args.Add(Field.Value);
                        if First then
                          S:=VarToStrDef(Field.Value,'')
                        else
                          S:=S+FDataAliasDelim+VarToStrDef(Field.Value,'');
                        First:=false;
                      end;
                    end;
                    if Trim(FDataAliasFormat)='' then
                      FParamEdit.Value:=S
                    else begin
                      List.Clear;
                      GetStringsByString(FParamEdit.ParamName,SFieldDelim,List);
                      for i:=0 to List.Count-1 do begin
                        Param:=Find(List[i]);
                        if Assigned(Param) and (Args.Count>i) then begin
                          Param.SetNewValue(Args.Items[i].Value);
                        end;
                      end;
                      FParamEdit.Value:=FormatEx(FDataAliasFormat,Args);
                    end;
                    DoAfterSelect;
                  finally
                    Args.Free;
                    List.Free;
                  end;
                end;
                Result:=true;
              end;
            end;
          end;
        end;
      finally
        Provider.Free;
        Iface.Free;
      end;
    end;
  end;
end;

procedure TBisParamEditDataSelect.SetDataAliasFormat(const Value: String);
var
  Param: TBisParam;
begin
  FDataAliasFormat := Value;
  if Assigned(FParamEdit) then begin
    FParamEdit.ParamFormat:=Value;
  end else begin
    Param:=Find(FDataName);
    if Assigned(Param) then begin
      Param.ParamFormat:=Value;
    end;
  end;
end;

procedure TBisParamEditDataSelect.GetControls(List: TList);
begin
  inherited GetControls(List);
  if Assigned(List) then begin
    if Assigned(FParamEdit) then begin
      List.Add(FParamEdit.Edit);
      List.Add(FParamEdit.LabelEdit);
    end;
    List.Add(FButton);
  end;
end;

{procedure TBisParamEditDataSelect.SetEnabled(const Value: Boolean);
begin
  inherited SetEnabled(Value);
  if Assigned(FParamEdit) then
    FParamEdit.Enabled:=Value;
  if Assigned(FButton) then
    FButton.Enabled:=Value;

end;}

procedure TBisParamEditDataSelect.ButtonClick(Sender: TObject);
begin
  if Assigned(FOldButtonClick) then
    FOldButtonClick(Sender)
  else
    Select;  
end;

procedure TBisParamEditDataSelect.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(FParamEdit) and Assigned(FParamEdit.Edit) then begin
    case Key of
      VK_DELETE, VK_BACK: begin
        if (Shift=[]) and (FParamEdit.Edit.SelLength=Length(FParamEdit.Edit.Text)) then begin
          if not Required then begin

            Value:=Null;
            FParamEdit.Value:=Null;
          end;
        end;
      end;
      VK_UP: begin
        if (Shift=[ssAlt]) then
          if Assigned(FButton) and FButton.Enabled then
            FButton.Click;
      end;
    end;
  end;

  if Assigned(FOldEditKeyDown) then
    FOldEditKeyDown(Sender,Key,Shift);
end;

procedure TBisParamEditDataSelect.DoCheckValue(var NewValue: Variant;  var CanSet: Boolean);
begin
  if Assigned(FOnCheckValue) then
    FOnCheckValue(Self,NewValue,CanSet);
end;

procedure TBisParamEditDataSelect.DoAfterSelect;
begin
  if Assigned(FOnAfterSelect) then
    FOnAfterSelect(Self);
end;

end.
