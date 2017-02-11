program Project1;

{%ToDo 'Project1.todo'}
{%DelphiDotNetAssemblyCompiler '$(SystemRoot)\microsoft.net\framework\v1.1.4322\System.Drawing.dll'}
{%DelphiDotNetAssemblyCompiler 'c:\programmer\fælles filer\borland shared\bds\shared assemblies\4.0\Borland.VclDbExpress.dll'}
{%DelphiDotNetAssemblyCompiler 'c:\programmer\fælles filer\borland shared\bds\shared assemblies\4.0\Borland.VclDbRtl.dll'}
{%DelphiDotNetAssemblyCompiler 'c:\programmer\fælles filer\borland shared\bds\shared assemblies\4.0\Borland.Delphi.dll'}
{%DelphiDotNetAssemblyCompiler 'c:\programmer\fælles filer\borland shared\bds\shared assemblies\4.0\Borland.VclRtl.dll'}
{%DelphiDotNetAssemblyCompiler '$(SystemRoot)\microsoft.net\framework\v1.1.4322\System.dll'}
{%DelphiDotNetAssemblyCompiler 'c:\programmer\fælles filer\borland shared\bds\shared assemblies\4.0\Borland.VclDSnap.dll'}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Unit1.TDemoDeltaHandler: kbmMemTable.TkbmCustomDeltaHandler};

{$R *.RES}

[System.STAThreadAttribute]

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

