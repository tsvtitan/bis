unit WI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$IFDEF VER120} ImgList,{$ENDIF}
  ComCtrls, StdCtrls, ExtCtrls, CheckLst;

type
  TfrmWI = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bRefresh: TButton;
    Panel3: TPanel;
    pc: TPageControl;
    bOK: TButton;
    img: TImageList;
    tsWindows: TTabSheet;
    tsProps: TTabSheet;
    Panel4: TPanel;
    tv: TTreeView;
    sb: TStatusBar;
    Panel5: TPanel;
    pcWin: TPageControl;
    tsWin: TTabSheet;
    lClass: TLabel;
    Label24: TLabel;
    lHandle: TLabel;
    Label26: TLabel;
    lProcess: TLabel;
    Bevel6: TBevel;
    Label33: TLabel;
    winIcon: TImage;
    Bevel7: TBevel;
    Label22: TLabel;
    lInst: TLabel;
    Label25: TLabel;
    lID: TLabel;
    Label28: TLabel;
    lProc: TLabel;
    Label23: TLabel;
    lParent: TLabel;
    Label27: TLabel;
    lData: TLabel;
    Label32: TLabel;
    lClient: TLabel;
    Label35: TLabel;
    lRect: TLabel;
    Label49: TLabel;
    lthread: TLabel;
    tsStyle: TTabSheet;
    BevelPanel7: TPanel;
    lws: TLabel;
    lbws: TListBox;
    Panel8: TPanel;
    lwes: TLabel;
    lbwes: TListBox;
    tsClass: TTabSheet;
    Label29: TLabel;
    latom: TLabel;
    Label31: TLabel;
    lcbytes: TLabel;
    Bevel8: TBevel;
    Label36: TLabel;
    Label38: TLabel;
    lcinst: TLabel;
    Label42: TLabel;
    lcwndproc: TLabel;
    Label44: TLabel;
    lwbytes: TLabel;
    Label30: TLabel;
    lhbkg: TLabel;
    Label37: TLabel;
    lhcur: TLabel;
    Label46: TLabel;
    lhicon: TLabel;
    Bevel10: TBevel;
    Bevel9: TBevel;
    BevelPanel8: TPanel;
    lcs: TLabel;
    lbcs: TListBox;
    eText: TEdit;
    eCName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmRefresh(Sender: TObject);
    procedure cmClose(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pcChanging(Sender: TObject; var AllowChange: Boolean);
  public
    procedure GetWinList;
    procedure GetWinInfo(AHandle :THandle);
  end;

var
  frmWI: TfrmWI;

implementation

{$R *.DFM}

uses MiTeC_Routines;

procedure TfrmWI.FormCreate(Sender: TObject);
begin
  pc.activepage:=tsWindows;
  pcwin.activepage:=tsWin;
  cmRefresh(nil);
end;

procedure TfrmWI.cmRefresh(Sender: TObject);
begin
  screen.cursor:=crhourglass;
  try
    GetWinList;
  finally
    screen.cursor:=crdefault;
  end;
end;

procedure TfrmWI.cmClose(Sender: TObject);
begin
  close;
end;

procedure TfrmWI.GetWinList;
var
  n :integer;
  cn,wt :string;
  wh :hwnd;
  root :ttreenode;
  p :pchar;

  procedure EnumChildWins(Awh :hwnd; ARoot :ttreenode);
  var
    node :ttreenode;
  begin
    while awh<>0 do begin
      getclassname(awh,p,n);
      cn:=strpas(p);
      getwindowtext(awh,p,n);
      wt:=strpas(p);
      node:=tv.items.addchild(aroot,'Window '+inttohex(awh,8)+' "'+wt+'" :'+cn);
      if iswindowvisible(awh) then
        node.imageindex:=2
      else
        node.imageindex:=1;
      node.selectedindex:=node.imageindex;
      enumchildwins(getwindow(awh,GW_CHILD),node);
      awh:=getwindow(awh,GW_HWNDNEXT);
    end;
  end;

begin
  n:=255;
  p:=stralloc(n);
  wh:=getdesktopwindow;
  getclassname(wh,p,n);
  cn:=strpas(p);
  getwindowtext(wh,p,n);
  wt:=strpas(p);
  tv.FullCollapse;
  tv.hide;
  tv.items.clear;
  root:=tv.items.add(nil,'Window '+inttohex(wh,8)+' "'+wt+'" :'+cn);
  enumchildwins(getwindow(wh,GW_CHILD),root);
  tv.items[0].makevisible;
  tv.selected:=tv.items[0];
  tv.selected.expand(false);
  tv.show;
  sb.panels[0].text:=inttostr(tv.items.count)+' windows';
end;

procedure TfrmWI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
end;

procedure TfrmWI.GetWinInfo(AHandle: THandle);
var
  pw :PWindow;
begin
  winIcon.Picture.Icon.Handle:=pw^.Icon;

  pw:=GetWindowInfo(AHandle);
  lclass.caption:=pw^.ClassName;
  etext.text:=pw^.Text;
  lhandle.caption:=inttohex(pw^.Handle,8);
  lthread.caption:=inttohex(pw^.Thread,8);
  lprocess.caption:=inttohex(pw^.Process,8);
  if pw^.Icon<>0 then
    winicon.picture.icon.handle:=pw^.Icon;
  lproc.caption:=inttohex(pw^.WndProc,8);
  linst.caption:=inttohex(pw^.Instance,8);
  lid.caption:=inttohex(pw^.ID,8);
  lparent.caption:=inttohex(pw^.ParentWin,8);
  ldata.caption:=inttohex(pw^.UserData,8);
  lrect.caption:=format('(%d,%d)-(%d,%d), %dx%d',[
                        pw^.rect.left,
                        pw^.rect.top,
                        pw^.rect.right,
                        pw^.rect.bottom,
                        pw^.rect.right-pw^.rect.left,
                        pw^.rect.bottom-pw^.rect.top
                        ]);
   lclient.caption:=format('(%d,%d)-(%d,%d), %dx%d',[
                           pw^.clientrect.left,
                           pw^.clientrect.top,
                           pw^.clientrect.right,
                           pw^.clientrect.bottom,
                           pw^.clientrect.right-pw^.clientrect.left,
                           pw^.clientrect.bottom-pw^.clientrect.top
                         ]);
  lws.caption:=' Styles: '+inttohex(pw^.Style,8);
  lbws.items.assign(pw^.Styles);
  lwes.caption:=' Extended Styles: '+inttohex(pw^.ExStyle,8);
  lbwes.items.assign(pw^.ExStyles);
  ecname.text:=pw^.ClassName;
  latom.caption:=inttohex(pw^.Atom,8);
  lcbytes.caption:=inttostr(pw^.ClassBytes)+' B';
  lwbytes.caption:=inttostr(pw^.WinBytes)+' B';
  lcwndproc.caption:=inttohex(pw^.ClassWndProc,8);
  lcinst.caption:=inttohex(pw^.ClassInstance,8);
  lhbkg.caption:=inttohex(pw^.Background,8);
  lhcur.caption:=inttohex(pw^.Cursor,8);
  lhicon.caption:=inttohex(pw^.Icon,8);
  lcs.caption:=' Styles: '+inttohex(pw^.ClassStyle,8);
  lbcs.items.assign(pw^.ClassStyles);
end;

procedure TfrmWI.pcChanging(Sender: TObject; var AllowChange: Boolean);
begin
  allowchange:=assigned(tv.selected);
  if allowchange then
    try
      screen.cursor:=crhourglass;
      getwininfo(strtoint('$'+copy(tv.selected.text,8,8)));
    finally
      screen.cursor:=crdefault;
    end;
end;

end.
