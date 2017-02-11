unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, VirtualTrees, VirtualGHFStringTree;

type
  TForm3 = class(TForm)
    VirtualGHFStringTree1: TVirtualGHFStringTree;
    VirtualGHFStringTree1_Footer: THeaderControl;
    VirtualGHFStringTree1_GroupHeader: THeaderControl;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

end.
