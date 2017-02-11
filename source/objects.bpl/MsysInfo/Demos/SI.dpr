program SI;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  WI in 'WI.PAS' {frmWI},
  PL in 'PL.pas' {frmPerfLib},
  CP in 'CP.pas' {dlgCounter: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'System Overview';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
