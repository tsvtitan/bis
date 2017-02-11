program Optimized;

uses
  Forms,
  OptimizedForm in 'OptimizedForm.pas' {fmOptimized};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmOptimized, fmOptimized);
  Application.Run;
end.
