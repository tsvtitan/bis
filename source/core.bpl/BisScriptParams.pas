unit BisScriptParams;

interface

uses Contnrs, Variants,
     BisScriptSymbols, BisScriptVars;

type
  TBisScriptParamKind=(spkNone,spkConst,spkVar);

  TBisScriptParam=class(TBisScriptVar)
  private
    FDefaultValue: Variant;
    FKind: TBisScriptParamKind;
    function GetDefaultExists: Boolean;
  public
    property Kind: TBisScriptParamKind read FKind;
    property DefaultValue: Variant read FDefaultValue;
    property DefaultExists: Boolean read GetDefaultExists;
  end;

  TBisScriptParams=class(TBisScriptVars)
  private
    function GetItem(Index: Integer): TBisScriptParam;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    function Find(Name: String): TBisScriptParam; reintroduce;

    function Add(Name: String; TypeName: String; Kind: TBisScriptParamKind=spkNone): TBisScriptParam; reintroduce; overload;
    function Add(Name: String; TypeName: String; DefaultValue: Variant;
                 Kind: TBisScriptParamKind=spkNone): TBisScriptParam; reintroduce; overload;

    procedure CopyFrom(Source: TBisScriptParams);

    property Items[Index: Integer]: TBisScriptParam read GetItem; default;
  end;

implementation

{ TBisScriptParam }

function TBisScriptParam.GetDefaultExists: Boolean;
begin
  Result:=not VarIsClear(FDefaultValue);
end;

{ TBisScriptParams }

function TBisScriptParams.Find(Name: String): TBisScriptParam;
begin
  Result:=TBisScriptParam(inherited Find(Name));
end;

function TBisScriptParams.GetItem(Index: Integer): TBisScriptParam;
begin
  Result:=TBisScriptParam(inherited Items[Index]);
end;

function TBisScriptParams.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptParam;
end;

function TBisScriptParams.Add(Name: String; TypeName: String; Kind: TBisScriptParamKind=spkNone): TBisScriptParam;
begin
  Result:=TBisScriptParam(inherited Add(Name,Null,TypeName));
  if Assigned(Result) then begin
    Result.FKind:=Kind;
  end;
end;

function TBisScriptParams.Add(Name: String; TypeName: String; DefaultValue: Variant;
                              Kind: TBisScriptParamKind=spkNone): TBisScriptParam;
begin
  Result:=Add(Name,TypeName,Kind);
  if Assigned(Result) then begin
    Result.FDefaultValue:=DefaultValue;
  end;
end;

procedure TBisScriptParams.CopyFrom(Source: TBisScriptParams);
var
  i: Integer;
  Param: TBisScriptParam;
  NewParam: TBisScriptParam;
begin
  Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Param:=Source.Items[i];

      NewParam:=Add(Param.Name,Param.TypeName,Param.Kind);
      if Assigned(NewParam) then begin
        NewParam.Description:=Param.Description;
        NewParam.Value:=Param.Value;
        NewParam.FDefaultValue:=Param.DefaultValue;
      end;

    end;
  end;
end;


end.
