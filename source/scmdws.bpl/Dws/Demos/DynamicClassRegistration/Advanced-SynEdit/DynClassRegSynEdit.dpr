program DynClassRegSynEdit;

uses
  Forms,
  frmMain in 'frmMain.pas' {fmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
