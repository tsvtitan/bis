unit CP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TdlgCounter = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pc: TPageControl;
    tsGeneral: TTabSheet;
    Panel3: TPanel;
    Bevel3: TBevel;
    lType: TLabel;
    stLevel: TLabel;
    lScale: TLabel;
    lSize: TLabel;
    lName: TLabel;
    Label1: TLabel;
    Bevel1: TBevel;
    stName: TEdit;
    stType: TLabel;
    stScale: TLabel;
    stSize: TLabel;
    Memo: TMemo;
    tsObject: TTabSheet;
    Bevel2: TBevel;
    lCntr: TLabel;
    lLevel1: TLabel;
    lInst: TLabel;
    lPage: TLabel;
    lObjname: TLabel;
    Label7: TLabel;
    Bevel4: TBevel;
    lCtrs: TLabel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    lTime: TLabel;
    lFreq: TLabel;
    stLevel1: TLabel;
    stObjName: TLabel;
    stCntr: TLabel;
    stInst: TLabel;
    stPage: TLabel;
    Memo1: TMemo;
    stCtrs: TLabel;
    stTime: TLabel;
    stFreq: TLabel;
    Button1: TButton;
    lLevel: TLabel;
  private
    FCounter: TObject;
    FPerfLib: TObject;
  public
    property Counter: TObject read FCounter write FCounter;
    property PerfLib: TObject read FPerfLib write FPerfLib;
    procedure Refresh;
  end;

procedure ShowPropsDlg(APerfLib: TObject; AParameter: Variant);

implementation

uses MiTeC_Routines, MiTeC_PerfLibNT, MiTeC_PerfLib9x;

{$R *.DFM}

procedure ShowPropsDlg(APerfLib: TObject; AParameter: Variant);
var
  po: TPerfObject;
  p: PChar;
begin
  p:=nil;
  with TdlgCounter.Create(Application.Mainform) do begin
    FPerfLib:=APerfLib;
    if IsNT then begin
      if VarIsArray(AParameter) then begin
        po:=TPerfLibNT(FPerfLib).Objects[TPerfLibNT(FPerfLib).GetIndexByName(AParameter[1])];
        Counter:=po.Counters[po.GetCntrIndexByName(AParameter[0])];
      end else begin
        Counter:=TPerfLibNT(FPerfLib).Objects[TPerfLibNT(FPerfLib).GetIndexByName(AParameter)]
      end;
    end else begin
      p:=AllocMem(255);
      if VarIsArray(AParameter) then begin
        strpcopy(p,AParameter[1]+'\'+AParameter[0]);
        Counter:=TObject(p);
      end else begin
        strpcopy(p,AParameter);
        Counter:=TObject(p);
      end;
    end;
    Refresh;
    ShowModal;
    if Assigned(p) then
      FreeMem(p);
    Free;
  end;
end;

{ TpropCounter }

procedure TdlgCounter.Refresh;
var
  po: TPerfObject;
  sc,so: string;
  i: integer;
begin
  if IsNT then begin
    if Counter is TPerfCounter then begin
      pc.ActivePage:=tsGeneral;
      po:=TPerfCounter(Counter).ParentObject;
    end else begin
      pc.ActivePage:=tsObject;
      tsGeneral.TabVisible:=False;
      po:=TPerfObject(Counter);
    end;
    if Counter is TPerfCounter then
      with TPerfCounter(Counter) do begin
        stName.Text:=Name;
        stType.Caption:=GetCounterTypeStr(CounterType);
        stScale.Caption:=Format('%d',[DefaultScale]);
        stSize.Caption:=Format('%d',[CounterSize]);
        stLevel.Caption:=GetDetailLevelStr(DetailLevel);
        Memo.Text:=Description;
      end;
    with po do begin
      stObjName.Caption:=Name;
      stCntr.Caption:=Format('%d',[DefaultCounter]);
      stPage.Caption:=Format('%d',[CodePage]);
      stLevel1.Caption:=GetDetailLevelStr(DetailLevel);
      if InstanceCount>-1 then
        stInst.Caption:=Format('%d',[InstanceCount])
      else
        stInst.Caption:='0';
      stCtrs.Caption:=Format('%d',[CounterCount]);
      stTime.Caption:=FormatSeconds(PerfTime.QuadPart div timer100n,True,False,True);
      stFreq.Caption:=FormatFloat('#,#0',PerfFreq.QuadPart);
      Memo1.Text:=Description;
    end;
  end else begin
    sc:=StrPas(PChar(Counter));
    i:=Pos('\',sc);
    if i>0 then begin
      pc.ActivePage:=tsGeneral;
      so:=Copy(sc,1,i-1);
    end else begin
      pc.ActivePage:=tsObject;
      tsGeneral.TabVisible:=False;
      so:=sc;
    end;
    with TPerfLib9x(FPerfLib) do begin
      if i>0 then begin
        stName.Text:=SysDataName[sc];
        Memo.Text:=SysDataDesc[sc];
      end;
      stObjName.Caption:=SysDataName[so];
      Memo1.Text:=SysDataDesc[so];
    end;
  end;
end;

end.
