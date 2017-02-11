unit BisScript;

interface

uses Classes,
     dws2Comp;

type
  TBisDelphiWebScriptII=class(TDelphiWebScriptII)
  end;

  TBisScript=class(TComponent)
  private
    FScript: TBisDelphiWebScriptII;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TBisScript }

constructor TBisScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScript:=
end;

destructor TBisScript.Destroy;
begin
  inherited Destroy;
end;

end.
