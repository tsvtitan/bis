program VTIni;

uses 
  Forms, 
  Unit1 in 'Unit1.pas' {Form1}; 
  

{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Simple VT Descendants'; 
  Application.CreateForm(TForm1, Form1); 
  Application.Run 
end.              
