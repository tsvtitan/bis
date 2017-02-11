unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    od: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UMSystemInfo;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  H: THandle;
  AClass: TPersistentClass;
  AComponent: TFuck;
begin
  Od.InitialDir:=ExtractFileDir(Application.ExeName);
  if not Od.Execute then exit;
  H:=0;
  try
    H:=LoadPackage(Od.FileName);
    if H<>0 then begin
       AClass:=GetClass('TMSystemInfoEx');
       if Assigned(AClass) then begin
         AComponent:=TFuck(AClass.Create);
         with AComponent do begin
           try
             Memo1.Lines.Text:=GetSystemInfo; 
           finally
             FRee;
           end;
         end;
       end;
    end;
  finally
    if H<>0 then
      UnloadPackage(H);
  end;
end;

end.
