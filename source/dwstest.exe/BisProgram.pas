unit BisProgram;

interface

uses Classes, Contnrs,
     dws2Comp, dws2Compiler, dws2Symbols, dws2Exprs;

type
  TBisScript=class(TDelphiWebScriptII)
  end;

  TBisUnit=class(Tdws2Unit)
  end;

  TBisUnitClass=class of TBisUnit;

  TBisUnits=class(TObjectList)
  private
    function GetItems(Index: Integer): TBisUnit;
  public
    function AddClass(AClass: TBisUnitClass): TBisUnit;

    property Items[Index: Integer]: TBisUnit read GetItems;
  end;

  TBisSource=class(TStringList)
  end;

  TBisSources=class(TObjectList)
  
  end;

  TBisProgram=class(TComponent)
  private
    FProg: TProgram;
    FScript: TBisScript;
    FUnits: TBisUnits;
    FSource: TStringList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Stop;
    procedure Start;

    property Script: TBisScript read FScript;
    property Units: TBisUnits read FUnits;
    property Sources: TStringList read FSource;
  end;

implementation

{ TBisUnits }

function TBisUnits.GetItems(Index: Integer): TBisUnit;
begin
  Result:=TBisUnit(inherited Items[Index]);
end;

function TBisUnits.AddClass(AClass: TBisUnitClass): TBisUnit;
begin
  Result:=nil;
end;

{ TBisProgram }

constructor TBisProgram.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScript:=TBisScript.Create(Self);
  FUnits:=TBisUnits.Create;
  FProg:=nil;
  FSource:=TStringList.Create;
end;

destructor TBisProgram.Destroy;
begin
  if Assigned(FProg) then
    FProg.Free;
  FSource.Free;  
  FUnits.Free;
  FScript.Free;
  inherited Destroy;
end;

procedure TBisProgram.Stop;
begin
  if Assigned(FProg) then
    FProg.EndProgram;
end;

procedure TBisProgram.Start;
begin
  if not Assigned(FProg) then begin
    FProg:=FScript.Compile(FSource.Text);
    FProg.BeginProgram();
  end;
end;

end.
