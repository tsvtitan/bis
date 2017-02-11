unit accountsframe;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TAccountsFrm = class(TFrame)
    AccountList: TListView;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
