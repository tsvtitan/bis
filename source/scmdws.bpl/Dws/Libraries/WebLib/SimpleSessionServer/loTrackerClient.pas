unit loTrackerClient;

interface

uses
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient;

type
  TDataModule2 = class(TDataModule)
    client: TIdTCPClient;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.xfm}

procedure TDataModule2.DataModuleCreate(Sender: TObject);
begin
  DataModule2 := self;
end;

procedure TDataModule2.DataModuleDestroy(Sender: TObject);
begin
  DataModule2 := NIL;
end;

end.
