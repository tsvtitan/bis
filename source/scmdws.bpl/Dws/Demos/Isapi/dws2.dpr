library dws2;

uses
  WebBroker,
  ISAPIApp,
  dws2Module in 'dws2Module.pas' {dws2WebModule: TWebModule};

{$R *.RES}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  Application.Initialize;
  Application.CreateForm(Tdws2WebModule, dws2WebModule);
  Application.Run;
end.
