unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, VirtualPropertyTree;

type
  TForm1 = class(TForm)
    VirtualPropertyTree1: TVirtualPropertyTree;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
     with VirtualPropertyTree1 do
     begin
          SetLength( Fields, 4 );
          with Fields[0] do
          begin
               Name := 'Rating';
               Category := 'Appearance';
               new( PInteger(Data) );
               DataType := dtCombo;

               PInteger(Data)^ := 0;

               SetLength( ComboData, 4 );
               ComboData[0] := '1';
               ComboData[1] := '2';
               ComboData[2] := '3';
               ComboData[3] := '4';
          end;

          with Fields[1] do
          begin
               Name := 'Encrypt. Rating';
               Category := 'Appearance';
               New( PInteger(Data) );
               DataType := dtInteger;

               PInteger(Data)^ := 1;

               MinValue := 1;
               MaxValue := MaxInt;
          end;

          with Fields[2] do
          begin
               Name := 'Hair color';
               Category := 'Behavior';
               new( PColor(Data) );
               DataType := dtColor;

               PColor(Data)^ := clYellow;
          end;

          with Fields[3] do
          begin
               Name := 'Description';
               Category := 'Behavior';
               new( PString(Data) );
               DataType := dtString;

               PString(Data)^ := 'The Tauri-Tok''Ra alliance will fall';
          end;

          RefreshFields;
     end;

end;

end.
