unit BisProviderTest;

interface

uses BisModules, BisProviderModules;

procedure InitProviderModule(AModule: TBisProviderModule); stdcall;

exports
  InitProviderModule;

implementation


uses Classes,
     BisProvider, BisDataSet, BisDialogs;

type

  TBisProviderTest=class(TBisProvider)
  public
    constructor Create(AOwner: TComponent); override;
    procedure Handle(DataSet: TBisDataSet); override;
  end;


procedure InitProviderModule(AModule: TBisProviderModule); stdcall;
begin
  AModule.Providers.AddClass(TBisProviderTest);
end;

{ TBisProviderTest }

constructor TBisProviderTest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='Test';
end;

procedure TBisProviderTest.Handle(DataSet: TBisDataSet);
begin
  if Assigned(DataSet) then
    ShowInfo(DataSet.ProviderName);
end;

end.
