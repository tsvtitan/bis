unit BisScriptType;

interface

uses
     BisScriptSymbols;

type

  TBisScriptTypeKind=(stkUnknown,stkInteger,stkFloat,stkString,stkDateTime,stkBoolean,stkVariant,stkMethod,stkClass);

  TBisScriptType=class(TBisScriptSymbol)
  private
    FKind: TBisScriptTypeKind;
    FAncestor: String;
  public
    property Kind: TBisScriptTypeKind read FKind write FKind;
    property Ancestor: String read FAncestor write FAncestor;
  end;

  TBisScriptTypeClass=class of TBisScriptType;

  TBisScriptInteger=class(TBisScriptType)
  public
    constructor Create; override;
  end;

  TBisScriptFloat=class(TBisScriptType)
  public
    constructor Create; override;
  end;

  TBisScriptString=class(TBisScriptType)
  public
    constructor Create; override;
  end;

  TBisScriptDateTime=class(TBisScriptType)
  public
    constructor Create; override;
  end;

  TBisScriptBoolean=class(TBisScriptType)
  public
    constructor Create; override;
  end;

  TBisScriptVariant=class(TBisScriptType)
  public
    constructor Create; override;
  end;

implementation

{ TBisScriptInteger }

constructor TBisScriptInteger.Create;
begin
  inherited Create;
  FKind:=stkInteger;
end;

{ TBisScriptFloat }

constructor TBisScriptFloat.Create;
begin
  inherited Create;
  FKind:=stkFloat;
end;

{ TBisScriptString }

constructor TBisScriptString.Create;
begin
  inherited Create;
  FKind:=stkString;
end;

{ TBisScriptDateTime }

constructor TBisScriptDateTime.Create;
begin
  inherited Create;
  FKind:=stkDateTime;
end;

{ TBisScriptBoolean }

constructor TBisScriptBoolean.Create;
begin
  inherited Create;
  FKind:=stkBoolean;
end;

{ TBisScriptVariant }

constructor TBisScriptVariant.Create;
begin
  inherited Create;
  FKind:=stkVariant;
end;


end.
