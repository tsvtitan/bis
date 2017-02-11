
{*******************************************************}
{                                                       }
{          MiTeC System Information Component           }
{                Detail Info Dialog                     }
{           version 5.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}


unit MSI_DetailDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, ComCtrls;

type
  TdlgMSI_Detail = class(TForm)
    ButtonPanel: TPanel;
    Panel: TPanel;
    bOK: TButton;
    Bevel1: TBevel;
    ClientPanel: TPanel;
    Notebook: TNotebook;
    Memo: TMemo;
    clb: TCheckListBox;
    lb: TListBox;
    lv: TListView;
    TitlePanel: TPanel;
    Image: TImage;
    procedure clbClickCheck(Sender: TObject);
  private
  public
  end;

var
  dlgMSI_Detail: TdlgMSI_Detail;

implementation

{$R *.DFM}

procedure TdlgMSI_Detail.clbClickCheck(Sender: TObject);
var
  OCC: TNotifyEvent;
  idx: integer;
  p: TPoint;
begin
  with TCheckListBox(Sender) do begin
    OCC:=OnClickCheck;
    OnClickCheck:=nil;
    GetCursorPos(p);
    p:=ScreenToClient(p);
    idx:=ItemAtPos(p,True);
    if idx>-1 then
      Checked[idx]:=not Checked[idx];
    OnClickCheck:=OCC;
  end;
end;

end.
