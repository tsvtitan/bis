program SymDictContextMapDemo;

uses
  Forms,
  SymDictContextForm in 'SymDictContextForm.pas' {fmDictContxt};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Dict Context Demo';
  Application.CreateForm(TfmDictContxt, fmDictContxt);
  Application.Run;
end.
