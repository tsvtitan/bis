unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  BisThreads, StdCtrls;

type
  TWaitForm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FThread: TBisWorkThread;
    { Private declarations }
  public
    property Thread: TBisWorkThread read FThread write FThread; 
  end;

var
  WaitForm: TWaitForm;

implementation

{$R *.dfm}

procedure TWaitForm.Button1Click(Sender: TObject);
begin
  if Assigned(FThread) then begin
    if FThread.FreeOnTerminate then
      FThread.Terminate
    else begin
      FThread.Terminate;
      FThread.WaitFor;
      FThread.Free;
    end;
    FThread:=nil;
  end;
end;

end.
