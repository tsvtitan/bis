unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, VirtualButtonTree;

type
  TForm1 = class(TForm)
    VirtualButtonTree1: TVirtualButtonTree;
    procedure VirtualButtonTree1GetButtonInfo(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var ButtonRect: TRect;
      var HasButton: Boolean; var Caption: String);
    procedure VirtualButtonTree1ButtonClick(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.VirtualButtonTree1GetButtonInfo(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var ButtonRect: TRect;
  var HasButton: Boolean; var Caption: String);
begin
  if ((Column = 0) and (Node.Index mod 2 = 0)) xor ((Column = 1) and (Node.Index mod 2 = 1))  then
  begin
    HasButton := True;
    ButtonRect.Left := ButtonRect.Right - 30;
    ButtonRect.Right  := ButtonRect.Right - 10;
    ButtonRect.Top  := ButtonRect.Top + 2;
    ButtonRect.Bottom  := ButtonRect.Bottom - 2;
    Caption := IntToStr(Node.Index)
  end;
end;

procedure TForm1.VirtualButtonTree1ButtonClick(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
ShowMessage( 'Click Row: '+IntToStr(Node.Index)+' Column: '+IntToStr(Column) );

end;

end.
