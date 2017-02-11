unit RouteParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GWXLib_TLB, StdCtrls, ComCtrls, RtVars;

type
  TRouteParamsForm = class(TForm)
    ProgressBar: TProgressBar;
    AbortBtn: TButton;
    AutoRecalc: TCheckBox;
    OptimizeOrder: TCheckBox;
    FixStart: TCheckBox;
    FixFinish: TCheckBox;
    VTypes: TComboBox;
    Label1: TLabel;
    CalcBtn: TButton;
    OptTime: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BtnVars: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AbortBtnClick(Sender: TObject);
    procedure VTypesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure OptimizeOrderClick(Sender: TObject);
    procedure FixStartClick(Sender: TObject);
    procedure FixFinishClick(Sender: TObject);
    procedure OptTimeChange(Sender: TObject);
    procedure BtnVarsClick(Sender: TObject);
  private
    VTypesStr: TStringList;
    pGWRoute: IGWRoute;
    stopped: boolean;
    isbusy: boolean;
  public
    FOnFormClose: procedure of object;
    FOnGetRouteResult: procedure(res: integer) of object;
    FOnRouteAddPoint: procedure of object;
    FOnRouteAddPointCoord: procedure(lat, lon: double) of object;
    procedure OnRouteProgress(ASender: TObject; PercentDone: Integer; var CanContinue: Integer);
    procedure SetGWRoute(rt: IGWRoute);
    procedure OnPointsChanged;
  end;

var
  RouteParamsForm: TRouteParamsForm;

implementation

{$R *.dfm}

procedure TRouteParamsForm.SetGWRoute(rt: IGWRoute);
var
 vt: string;
 sl: IGWStringList;
 ok: integer;
 it: string;
 prev, w: integer;
begin
  pGWRoute:=rt;
  if rt=nil then exit;

  if VTypes.ItemIndex>=0 then vt:=VTypes.Items[VTypes.ItemIndex]
  else vt:='';

  // getting vehicle types
  VTypesStr.Clear;
  VTypes.Items.Clear;
  sl:=rt.VehicleTypes as IGWStringList;
  ok:=sl.MoveFirst;
  prev:=-1;
  while ok<>0 do begin
    it:=sl.Item;
    VTypesStr.Add(it); // save original value
    if TryStrToInt(it, w) then begin // digit is max permitted weight*10
      if w=0 then it:='Motocars'
      else if w=255 then begin
        if prev=-1 then it:='All vehicles'
        else if prev=0 then it:='Lorries'
        else it:='Lorries > '+FormatFloat('#.#', prev/10)+' tons';
      end
      else begin
        if prev=-1 then it:='Motocars and lorries'
        else if prev=0 then it:='Lorries'
        else it:='Lorries more > '+FormatFloat('#.#', prev/10)+' and';
        it:=it+' < '+FormatFloat('#.#', w/10)+' tons';
      end;
      prev:=w;
    end;
    VTypes.Items.Add(it);
    ok:=sl.MoveNext;
  end;

  // set saved or the first available vehicle type
  if vt<>'' then begin
    w:=VTypes.Items.IndexOf(vt);
    if w<0 then w:=0;
  end
  else w:=0;
  VTypes.ItemIndex:=w;
  VTypesChange(Self);

  pGWRoute.OptimizeTimeRatio:=OptTime.Position/10;
  pGWRoute.ReorderPoints:=Ord(OptimizeOrder.Checked);

  sl:=nil;

//  sl:=rt.GetVariants as IGWStringList;
//  ok:=sl.MoveFirst;
//  ListBox1.Items.Clear;
//  while ok<>0 do begin
//    ListBox1.Items.Add(sl.Item);
//    ok:=sl.MoveNext;
//  end;
//  sl:=nil;

end;

procedure TRouteParamsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FOnFormClose) then FOnFormClose;
end;

procedure TRouteParamsForm.OnRouteProgress(ASender: TObject;
  PercentDone: Integer; var CanContinue: Integer);
begin
  ProgressBar.Position:=PercentDone;
  Application.ProcessMessages;
  if stopped then CanContinue:=0;
end;

procedure TRouteParamsForm.OnPointsChanged;
begin
  if AutoRecalc.Checked then CalcBtnClick(Self);
end;

procedure TRouteParamsForm.AbortBtnClick(Sender: TObject);
begin
  stopped:=true;
end;

procedure TRouteParamsForm.VTypesChange(Sender: TObject);
begin
 if (pGWRoute<>nil) and (VTypes.ItemIndex>=0) then
 pGWRoute.VehicleType:=VTypesStr[VTypes.ItemIndex];
 OnPointsChanged;
end;

procedure TRouteParamsForm.FormCreate(Sender: TObject);
begin
  VTypesStr:=TStringList.Create;
  isbusy:=false;
end;

procedure TRouteParamsForm.FormDestroy(Sender: TObject);
begin
  VTypesStr.Free;
end;

procedure TRouteParamsForm.CalcBtnClick(Sender: TObject);
var
  res: integer;
begin
  if isbusy then exit;
  isbusy:=true;

  stopped:=false;
  AbortBtn.Enabled:=true;
  CalcBtn.Enabled:=false;
  res:=pGWRoute.CalculateRoute; // 0 - error, 1 - partially, 2 - ok
  ProgressBar.Position:=0;
  CalcBtn.Enabled:=true;
  AbortBtn.Enabled:=false;
  if Assigned(FOnGetRouteResult) then FOnGetRouteResult(res);
  isbusy:=false;
end;

procedure TRouteParamsForm.OptimizeOrderClick(Sender: TObject);
begin
  pGWRoute.ReorderPoints:=Ord(OptimizeOrder.Checked);
  OnPointsChanged;
end;

procedure TRouteParamsForm.FixStartClick(Sender: TObject);
begin
  if Assigned(FOnRouteAddPoint) then FOnRouteAddPoint;
end;

procedure TRouteParamsForm.FixFinishClick(Sender: TObject);
begin
  if Assigned(FOnRouteAddPoint) then FOnRouteAddPoint;
end;

procedure TRouteParamsForm.OptTimeChange(Sender: TObject);
begin
 pGWRoute.OptimizeTimeRatio:=OptTime.Position/10;
 OnPointsChanged;
end;

procedure TRouteParamsForm.BtnVarsClick(Sender: TObject);
var
  tbl: IGWTable;
  p: integer;
  item: TListItem;
begin
  tbl:=pGWRoute.GetVariantsTable as IGWTable;
  RouteVariants.List.Items.Clear;

  if tbl<>nil then begin;
    p:=tbl.MoveFirst;
     while p>=0 do begin
       item:=RouteVariants.List.Items.Add;
       item.Caption:=tbl.getText(0);
       item.SubItems.Add(tbl.getText(1));
       p:=tbl.MoveNext;
     end;
  end;
  RouteVariants.ShowModal;
end;

end.
