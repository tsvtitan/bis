unit BisServerModuleIntf;

interface

uses BisObject, BisModuleIntf;

type

  IBisServerModule=interface(IBisModule)
  ['{B7968161-273B-442F-961E-970661EF1EE4}']

    procedure SaveServerParams(Server: TBisObject);
  end;

implementation

end.
