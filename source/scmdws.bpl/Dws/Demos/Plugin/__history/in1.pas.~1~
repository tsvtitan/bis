unit in1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, dws2Exprs;

type
  TDataModule1 = class(TDataModule)
    dws2Unit1: Tdws2Unit;
    procedure dws2Unit1FunctionsHelloEval(Info: TProgramInfo);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.DFM}

procedure TDataModule1.dws2Unit1FunctionsHelloEval(Info: TProgramInfo);
begin
  Info['Result'] := 'World';
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  DataModule1 := Self;
end;

procedure TDataModule1.DataModuleDestroy(Sender: TObject);
begin
  DataModule1 := nil;
end;

end.

