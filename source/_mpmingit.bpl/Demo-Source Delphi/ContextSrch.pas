unit ContextSrch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GWXLib_TLB, ObjList;

type
  TContextSearchForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    GWControl: TGWControl;
    searchingContext: boolean;
    procedure onSearchAddress(const addr: string);
  public
    procedure ShowSearch(ctrl: TGWControl; byContext: boolean);
  end;

var
  ContextSearchForm: TContextSearchForm;

implementation

{$R *.dfm}


procedure TContextSearchForm.ShowSearch(ctrl: TGWControl; byContext: boolean);
var
  subj: string;
begin
  GWControl:=ctrl;
  searchingContext:=byContext;
  if byContext then subj:='context' else subj:='address';
  Caption:='Search by '+subj;
  Label1.Caption:='Enter '+subj+' for searching:';
  Show;
end;

procedure TContextSearchForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TContextSearchForm.Button1Click(Sender: TObject);
// ok button
var
  tbl:IGWTable;
  s: string;
begin
  s:=Edit1.Text;
  if s='' then exit;
  if searchingContext then begin
    tbl:=GWControl.Search(s) as IGWTable;
    ObjListForm.ShowTable(tbl, GWControl);
  end
  else onSearchAddress(s);
end;

procedure TContextSearchForm.onSearchAddress(const addr: string);
var
  Lat, Lon: double;
  x, y: integer;
  dc: HDC;
  r: TRect;
  pen, oldpen: HPEN;
begin
  if GWControl.SearchAddress(addr, Lat, Lon)=0 then exit;

  // set center by returned coordinates
  GWControl.SetGeoCenter(Lat,Lon);
  GWControl.Refresh;
  GWControl.Update;  // ensure that no pending WM_DRAW messages will occur
  GWControl.Geo2Dev(Lat, Lon, x, y);

  // drawing in device coordinates, (lat,lon) may not be in center
  dc:=GetDC(GWControl.Handle);
  r:=GWControl.ClientRect;
  pen:=CreatePen(PS_SOLID,1,clRed);
  oldpen:=SelectObject(dc,pen);
  MoveToEx(dc, r.Left, y, nil);
  LineTo(dc, r.Right, y);
  MoveToEx(dc, x, r.Top, nil);
  LineTo(dc, x, r.Bottom);
  SelectObject(dc,oldpen);
  DeleteObject(pen);
  ReleaseDC(GWControl.Handle,dc);
end;



end.
