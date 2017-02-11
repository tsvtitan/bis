program Events;

uses
  Forms,
  EventsMain in 'EventsMain.pas' {FEvents};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFEvents, FEvents);
  Application.Run;
end.
