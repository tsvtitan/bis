unit BisParamComboBoxDataSelect;

interface

uses Classes, Controls, DB, StdCtrls, Windows, Contnrs,
     BisFilterGroups, BisOrders, BisValues, 
     BisParam, BisParamInvisible, BisParamComboBox, BisControls;

type
  TBisParamComboBoxDataSelect=class;

  TBisParamComboBoxDataCheckValueEvent=procedure (Def: TBisParamComboBoxDataSelect; var NewValue: Variant; var CanSet: Boolean) of object;
  TBisParamComboBoxDataSelectAfterSelect=procedure (Def: TBisParamComboBoxDataSelect) of object;

  TBisParamComboBoxDataSelect=class(TBisParamInvisible)
  private
    FButtonName: String;
    FDataClass: TComponentClass;
    FAlias: String;
    FDataAlias: String;
    FParamComboBox: TBisParamComboBox;
    FButton: TButton;
    FOldButtonClick: TNotifyEvent;
    FDataName: String;
    FOnCheckValue: TBisParamComboBoxDataCheckValueEvent;
    FDataAliasDelim: String;
    FDataAliasFormat: String;
    FValues: TObjectList;
    FOnAfterSelect: TBisParamComboBoxDataSelectAfterSelect;
    FDataClassName: String;
    FAutoRefresh: Boolean;
    FFirstSelected: Boolean;
    FProviderName: String;
    FFilterGroups: TBisFilterGroups;
    FOrders: TBisOrders;

    procedure ParamComboBoxLinkControls(AParent: TWinControl);
    procedure ButtonClick(Sender: TObject);
    procedure DoCheckValue(var NewValue: Variant; var CanSet: Boolean);
    procedure DoAfterSelect;
    function GetValues: TBisValues;
  protected
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
//    procedure SetEnabled(const Value: Boolean); override;
    procedure GetControls(List: TList); override;
    function UseInFilter: Boolean; override;
    procedure GetFilters(Group: TBisFilterGroup); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisParam; WithReset: Boolean=true); override;
    procedure LinkControls(Parent: TWinControl); override;
    procedure Refresh; override;
    procedure Clear; override;
    function Select: Boolean;
    procedure RefreshValues(DataSet: TDataSet);

    property ButtonName: String read FButtonName write FButtonName;
    property DataClass: TComponentClass read FDataClass write FDataClass;
    property DataClassName: String read FDataClassName write FDataClassName;
    property ProviderName: String read FProviderName write FProviderName; 
    property Alias: String read FAlias write FAlias;
    property DataAlias: String read FDataAlias write FDataAlias;
    property Button: TButton read FButton;
    property DataName: String read FDataName write FDataName;
    property DataAliasDelim: String read FDataAliasDelim write FDataAliasDelim;
    property DataAliasFormat: String read FDataAliasFormat write FDataAliasFormat;
    property AutoRefresh: Boolean read FAutoRefresh write FAutoRefresh;
    property FirstSelected: Boolean read FFirstSelected write FFirstSelected;

    property FilterGroups: TBisFilterGroups read FFilterGroups;
    property Orders: TBisOrders read FOrders;
    property Values: TBisValues read GetValues;

    property OnCheckValue: TBisParamComboBoxDataCheckValueEvent read FOnCheckValue write FOnCheckValue;
    property OnAfterSelect: TBisParamComboBoxDataSelectAfterSelect read FOnAfterSelect write FOnAfterSelect;
  end;

implementation

uses Variants, SysUtils,
     BisDataFm, BisProvider, BisUtils, BisVariants, BisConsts, BisCore, BisDataSet;

type
  TBisParamComboBoxDataSelectValue=class(TObject)
  private
    FValue: Variant;
    FValues: TBisValues;
  public
    constructor Create;
    destructor Destroy; override;

    property Value: Variant read FValue write FValue;
    property Values: TBisValues read FValues;
  end;

{ TBisParamComboBoxDataSelectValue }

constructor TBisParamComboBoxDataSelectValue.Create;
begin
  inherited Create;
  FValues:=TBisValues.Create;
end;

destructor TBisParamComboBoxDataSelectValue.Destroy;
begin
  FValues.Free;
  inherited Destroy;
end;

  
{ TBisParamComboBoxDataSelect }

constructor TBisParamComboBoxDataSelect.Create;
begin
  inherited Create;
  FFilterGroups:=TBisFilterGroups.Create;
  FOrders:=TBisOrders.Create;
  FValues:=TObjectList.Create;
  FDataAliasDelim:=' ';
  FAutoRefresh:=true;
end;

destructor TBisParamComboBoxDataSelect.Destroy;
begin
  FValues.Free;
  FOrders.Free;
  FFilterGroups.Free;
  inherited Destroy;
end;

procedure TBisParamComboBoxDataSelect.Clear;
begin
  FValues.Clear;
  if Assigned(FParamComboBox) then begin
    FParamComboBox.Clear;
    FParamComboBox.DoChange(FParamComboBox);
  end;
  inherited Clear;
end;

procedure TBisParamComboBoxDataSelect.CopyFrom(Source: TBisParam; WithReset: Boolean);
begin
  inherited CopyFrom(Source,WithReset);
  if Assigned(Source) and (Source is TBisParamComboBoxDataSelect) then begin
    ButtonName:=TBisParamComboBoxDataSelect(Source).ButtonName;
    DataClass:=TBisParamComboBoxDataSelect(Source).DataClass;
    DataClassName:=TBisParamComboBoxDataSelect(Source).DataClassName;
    Alias:=TBisParamComboBoxDataSelect(Source).Alias;
    DataAlias:=TBisParamComboBoxDataSelect(Source).DataAlias;
    DataName:=TBisParamComboBoxDataSelect(Source).DataName;
    DataAliasDelim:=TBisParamComboBoxDataSelect(Source).DataAliasDelim;
    DataAliasFormat:=TBisParamComboBoxDataSelect(Source).DataAliasFormat;
    ProviderName:=TBisParamComboBoxDataSelect(Source).ProviderName;
    AutoRefresh:=TBisParamComboBoxDataSelect(Source).AutoRefresh;
    FirstSelected:=TBisParamComboBoxDataSelect(Source).FirstSelected;
    FilterGroups.CopyFrom(TBisParamComboBoxDataSelect(Source).FilterGroups);
    Orders.CopyFrom(TBisParamComboBoxDataSelect(Source).Orders);
  end;
end;

procedure TBisParamComboBoxDataSelect.ParamComboBoxLinkControls(AParent: TWinControl);
begin
  if Assigned(FParamComboBox) and Assigned(FParamComboBox.ComboBox) then begin
    FParamComboBox.ParamFormat:=FDataAliasFormat;
    if FAutoRefresh then
      Refresh;
  end;
end;

procedure TBisParamComboBoxDataSelect.LinkControls(Parent: TWinControl);
begin
  if Assigned(Parent) then begin
    FButton:=TButton(DoFindComponent(FButtonName));
    if Assigned(FButton) then begin
      FOldButtonClick:=FButton.OnClick;
      FButton.OnClick:=ButtonClick;
    end;
    FParamComboBox:=TBisParamComboBox(Find(FDataName));
    if Assigned(FParamComboBox) then begin
      FParamComboBox.ParamType:=ptUnknown;
      FParamComboBox.FilterEnabled:=false;
      FParamComboBox.OnLinkControls:=ParamComboBoxLinkControls;
    end;
  end;
  inherited LinkControls(Parent);
  if Assigned(FButton) then begin
  end;
end;

procedure TBisParamComboBoxDataSelect.RefreshValues(DataSet: TDataSet);

  procedure RefreshLocal;
  var
    Field: TField;
    List: TStringList;
    i: Integer;
    Args: TBisVariants;
    Obj: TBisParamComboBoxDataSelectValue;
    S: String;
    First: Boolean;
  begin
    if DataSet.Active and not DataSet.IsEmpty then begin
      DataSet.First;
      Field:=DataSet.FindField(Alias);
      if Assigned(Field) then begin
        List:=TStringList.Create;
        Args:=TBisVariants.Create;
        try

          if not Required then begin
            Obj:=TBisParamComboBoxDataSelectValue.Create;
            Obj.Value:=Null;
            for i:=0 to DataSet.Fields.Count-1 do begin
              Field:=DataSet.Fields[i];
              Obj.Values.Add(Field.FieldName,Null);
            end;
            FValues.Add(Obj);
            FParamComboBox.ComboBox.Items.AddObject('',Obj);
          end;

          GetStringsByString(DataAlias,';',List);
          while not DataSet.Eof do begin
            S:='';
            First:=true;
            Obj:=TBisParamComboBoxDataSelectValue.Create;
            Obj.Value:=DataSet.FieldByName(Alias).Value;
            for i:=0 to DataSet.Fields.Count-1 do begin
              Field:=DataSet.Fields[i];
              Obj.Values.Add(Field.FieldName,Field.Value);
            end;
            FValues.Add(Obj);
            Args.Clear;
            for i:=0 to List.Count-1 do begin
              Field:=DataSet.FindField(List[i]);
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
              FParamComboBox.ComboBox.Items.AddObject(S,Obj)
            else begin
              FParamComboBox.ComboBox.Items.AddObject(FormatEx(FDataAliasFormat,Args),Obj)
            end;
            DataSet.Next;
          end;
          if FFirstSelected and (FParamComboBox.ComboBox.Items.Count>0) then begin
            if Required then begin
              FParamComboBox.ComboBox.ItemIndex:=0;
              DefaultValue:=Value;
              FParamComboBox.DefaultValue:=FParamComboBox.Value;
              FParamComboBox.DoChange(FParamComboBox);
            end else begin
              if (FParamComboBox.ComboBox.Items.Count>1) then begin
                FParamComboBox.ComboBox.ItemIndex:=1;
                DefaultValue:=Value;
                FParamComboBox.DefaultValue:=FParamComboBox.Value;
                FParamComboBox.DoChange(FParamComboBox);
              end;
            end;
          end;

        finally
          Args.Free;
          List.Free;
        end;
      end;
    end;
  end;
  
begin
  if Assigned(FParamComboBox) and Assigned(FParamComboBox.ComboBox) then begin
    FParamComboBox.ComboBox.Items.BeginUpdate;
    try
      FValues.Clear;
      FParamComboBox.ComboBox.Clear;
      FParamComboBox.DoChange(FParamComboBox);
      RefreshLocal;
    finally
      FParamComboBox.ComboBox.Items.EndUpdate;
    end;
  end;
end;

procedure TBisParamComboBoxDataSelect.Refresh;
var
  AClass: TComponentClass;
  Iface: TBisDataFormIface;
  Provider: TBisProvider;
  Flag: Boolean;
begin
  if Assigned(FParamComboBox) and Assigned(FParamComboBox.ComboBox) then begin
    Provider:=TBisProvider.Create(nil);
    try
      Flag:=true;

      AClass:=FDataClass;
      if not Assigned(AClass) and Assigned(Core) then
        AClass:=Core.FindIfaceClass(FDataClassName);
      if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
        Iface:=TBisDataFormIfaceClass(AClass).Create(nil);
        try
          Iface.FilterGroups.CopyFrom(FFilterGroups,false);
          Iface.Init;
          Flag:=Iface.SelectInto(Provider,false);
        finally
          Iface.Free;
        end;
      end else begin
        if Trim(FProviderName)<>'' then begin
          Provider.ProviderName:=FProviderName;
          Provider.FilterGroups.CopyFrom(FFilterGroups,false);
          Provider.Orders.CopyFrom(FOrders);
          Provider.Open;
        end;
      end;

      if Flag then
        RefreshValues(Provider);

    finally
      Provider.Free;
    end;
  end;
end;

function TBisParamComboBoxDataSelect.Select: Boolean;
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
        Iface.FilterGroups.CopyFrom(FFilterGroups,false);
        Iface.LocateFields:=Alias;
        Iface.LocateValues:=Value;
        Iface.Init;
//        Iface.FilterOnShow:=FFilterOnShow;
        if Iface.SelectInto(Provider) then begin
          if Provider.Active and not Provider.IsEmpty then begin
            Field:=Provider.FindField(Alias);
            if Assigned(Field) then begin
              CanSet:=true;
              NewValue:=Field.Value;
              DoCheckValue(NewValue,CanSet);
              if CanSet then begin
                Value:=NewValue;
                if Assigned(FParamComboBox) then begin
                  List:=TStringList.Create;
                  Args:=TBisVariants.Create;
                  try
                    S:='';
                    First:=true;
                    GetStringsByString(DataAlias,';',List);
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
                      FParamComboBox.Value:=S
                    else begin
                      List.Clear;
                      GetStringsByString(FParamComboBox.ParamName,SFieldDelim,List);
                      for i:=0 to List.Count-1 do begin
                        Param:=Find(List[i]);
                        if Assigned(Param) and (Args.Count>i) then begin
                          Param.SetNewValue(Args.Items[i].Value);
                        end;
                      end;
                      FParamComboBox.Value:=FormatEx(FDataAliasFormat,Args);
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

procedure TBisParamComboBoxDataSelect.ButtonClick(Sender: TObject);
begin
  if Assigned(FOldButtonClick) then
    FOldButtonClick(Sender)
  else
    Select;
end;

procedure TBisParamComboBoxDataSelect.DoCheckValue(var NewValue: Variant;  var CanSet: Boolean);
begin
  if Assigned(FOnCheckValue) then
    FOnCheckValue(Self,NewValue,CanSet);
end;

procedure TBisParamComboBoxDataSelect.GetControls(List: TList);
begin
  inherited GetControls(List);
  if Assigned(List) then begin
    if Assigned(FParamComboBox) then begin
      List.Add(FParamComboBox.ComboBox);
      List.Add(FParamComboBox.LabelComboBox);
    end;
    List.Add(FButton);
  end;
end;

function TBisParamComboBoxDataSelect.GetValue: Variant;
var
  Index: Integer;
  Obj: TBisParamComboBoxDataSelectValue;
begin
  Result:=inherited GetValue;
  if Assigned(FParamComboBox) and Assigned(FParamComboBox.ComboBox) then begin
    Index:=FParamComboBox.ComboBox.ItemIndex;
    if Index<>-1 then begin
      Obj:=TBisParamComboBoxDataSelectValue(FParamComboBox.ComboBox.Items.Objects[Index]);
      if Assigned(Obj) then begin
        Result:=Obj.Value;
      end else
        Result:=Null;
    end else
      Result:=Null;
  end;
end;

function TBisParamComboBoxDataSelect.GetValues: TBisValues;
var
  Index: Integer;
begin
  Result:=nil;
  if Assigned(FParamComboBox) and Assigned(FParamComboBox.ComboBox) then begin
    Index:=FParamComboBox.ComboBox.ItemIndex;
    if Index<>-1 then begin
      Result:=TBisParamComboBoxDataSelectValue(FParamComboBox.ComboBox.Items.Objects[Index]).Values;
    end;
  end;
end;

{procedure TBisParamComboBoxDataSelect.SetEnabled(const Value: Boolean);
begin
  inherited SetEnabled(Value);
  if Assigned(FParamComboBox) then
    FParamComboBox.Enabled:=Value;
  if Assigned(FButton) then
    FButton.Enabled:=Value;
end;}

procedure TBisParamComboBoxDataSelect.SetValue(const AValue: Variant);
var
  i: Integer;
  Obj: TBisParamComboBoxDataSelectValue;
  Index: Integer;
begin
  if not VarSameValue(Value,AValue) then begin
    if Assigned(FParamComboBox) and Assigned(FParamComboBox.ComboBox) then begin
      Index:=-1;
      for i:=0 to FParamComboBox.ComboBox.Items.Count-1 do begin
        Obj:=TBisParamComboBoxDataSelectValue(FParamComboBox.ComboBox.Items.Objects[i]);
        if Assigned(Obj) and VarSameValue(Obj.Value,AValue) then begin
          Index:=i;
          break;
        end;
      end;
      FParamComboBox.ComboBox.ItemIndex:=Index;
      FParamComboBox.DefaultValue:=FParamComboBox.Value;
      FParamComboBox.DoChange(FParamComboBox);
    end;
    inherited SetValue(AValue);
  end;
end;

procedure TBisParamComboBoxDataSelect.DoAfterSelect;
begin
  if Assigned(FOnAfterSelect) then
    FOnAfterSelect(Self);
end;

function TBisParamComboBoxDataSelect.UseInFilter: Boolean;
begin
  Result:=Enabled and not Empty and Assigned(FParamComboBox);
end;

procedure TBisParamComboBoxDataSelect.GetFilters(Group: TBisFilterGroup);
var
  S: String;
  Filter: TBisFilter;
begin
  if Assigned(Group) and Assigned(FParamComboBox) then begin
    S:=FParamComboBox.Caption;
    if Trim(FParamComboBox.FilterCaption)<>'' then
      S:=FParamComboBox.FilterCaption;
    Group.GroupName:=S;
    Filter:=Group.Filters.Add(ParamName,fcEqual,Value);
    Filter.CheckCase:=true;
    Filter.Caption:=FParamComboBox.AsString;
  end;
end;


end.
