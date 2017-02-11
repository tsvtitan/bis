
{******************************************}
{                                          }
{             FastReport v4.0              }
{     Parent form for pop-up controls      }
{                                          }
{         Copyright (c) 1998-2007          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxPopupForm;

interface

{$I frx.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls
{$IFDEF Delphi6}
, Variants
{$ENDIF};
  

type
  TfrxPopupForm = class(TForm)
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frxPopupFormCloseTime: UInt = 0;


implementation

{$R *.DFM}


procedure TfrxPopupForm.FormDeactivate(Sender: TObject);
begin
  frxPopupFormCloseTime := GetTickCount;
  Close;
end;

procedure TfrxPopupForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.


//c6320e911414fd32c7660fd434e23c87