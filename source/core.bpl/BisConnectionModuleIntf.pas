unit BisConnectionModuleIntf;

interface

uses BisObject, BisModuleIntf;

type

  IBisConnectionModule=interface(IBisModule)
  ['{0E59108E-49F9-4903-A13C-EF2743A3B054}']

    procedure SaveConnectionParams(Connection: TBisObject);
  end;

implementation

end.
