unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dws2Comp, dws2StringResult, dws2Exprs, BrowserFrm,
  dws2Debugger, dws2Compiler, dws2Errors,
  dws2ComConnector, StdCtrls, dws2Symbols, ExtCtrls, dws2Functions, dws2Strings,
  BisProgram, BisSysUtilsUnit;

type
  TClick2Event=function: Boolean of object;
  
  TForm5 = class(TForm)
    Script1: TDelphiWebScriptII;
    Debugger1: Tdws2SimpleDebugger;
    Button1: TButton;
    Result: Tdws2StringResultType;
    Unit1: Tdws2Unit;
    Unit2: Tdws2Unit;
    Button2: TButton;
    GridPanel1: TGridPanel;
    MemoUnit1: TMemo;
    MemoUnit2: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    lbSymNames: TListBox;
    lbSymPositions: TListBox;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Unit1ClassesTNewFormConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure Unit1ClassesTNewFormMethodsFreeEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure Script1Include(const scriptName: string;
      var scriptSource: string);
    procedure Unit1FunctionsGetTest2Eval(Info: TProgramInfo);
    procedure Unit2FunctionsGetTest2Eval(Info: TProgramInfo);
    procedure Unit1InstancesSelfInstantiate(var ExtObject: TObject);
    procedure Unit1ClassesTComponentConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure Unit1ClassesTComponentMethodsFreeEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure Unit1ClassesTComponentMethodsSetNameEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure Unit1ClassesTComponentMethodsGetNameEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure Unit1ClassesTComponentMethodsSetNameInitExpr(Sender: TObject;
      Expr: TExprBase);
    procedure Unit1ClassesTComponentMethodsSetNameInitSymbol(Sender: TObject;
      Symbol: TSymbol);
    procedure Unit1ClassesTComponentMethodsClassNameEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Unit2ClassesTNewFormMethodsGetOnClickInitExpr(Sender: TObject;
      Expr: TExprBase);
    procedure Unit2ClassesTNewFormMethodsSetOnClickInitExpr(Sender: TObject;
      Expr: TExprBase);
    procedure Unit2ClassesTNewFormMethodsSetOnClickInitSymbol(Sender: TObject;
      Symbol: TSymbol);
    procedure Unit2ClassesTNewFormMethodsSetOnClickEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTNewFormMethodsShowModalEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTNewFormMethodsSetOnClick2Eval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTButtonMethodsSetOnClickEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTNewFormMethodsGetButtonEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Debugger1Debug(Prog: TProgram; Expr: TExpr);
    procedure lbSymNamesClick(Sender: TObject);
    procedure lbSymPositionsClick(Sender: TObject);
    procedure MemoUnit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoUnit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Unit2ClassesTComponentConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure Unit2ClassesTComponentMethodsClassNameEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2FunctionsShowMessageEval(Info: TProgramInfo);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Unit2ClassesTControlMethodsSetParentEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTControlMethodsGetParentEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTComponentMethodsGetOwnerEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTComponentMethodsFreeEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTControlMethodsSetOnClickEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTControlMethodsGetOnClickEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTControlMethodsSetOnMouseEnterEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2ClassesTControlMethodsSetOnMouseLeaveEval(Info: TProgramInfo;
      ExtObject: TObject; Expr: TExpr);
    procedure Unit2InstancesSelfTestInstantiate(var ExtObject: TObject);
    procedure Unit2FunctionsDateEval(Info: TProgramInfo);
  private
    FProgram: TBisProgram;
    FP2: TProgram;
    FOnClick2: TClick2Event;
  Ret: TFuncSymbol;
  Ret2: TFuncSymbol;
  clsSym: TClassSymbol;
  Method1: TMethod;
  Method2: TMethod;
  BrowserForm : TBrowserForm;
    procedure OnClick(Sender: TObject);
    function Click2Event: Boolean;
  public
    procedure BuildDictionaryList;
    function GetScriptName(ScriptPos: TScriptPos): string;
  published
    property OnClick2: TClick2Event read FOnClick2 write FOnClick2;
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses NewUnit, TypInfo;

type

  TTest=class(TObject)
  private
//    FInfo: TProgramInfo;

    FSymbol: TSymbol;
    FFuncExpr: TFuncExpr;
    FCaller: TProgram;
    FRoot: TProgram;

    FCallInfo: IInfo;
    FFunc: String;
  public
    constructor Create(AInfo: TProgramInfo);
    destructor Destroy; override;
    procedure DoOnNotifyEvent(Sender: TObject);
    procedure DoOnClick2(Sender1: TObject; Sender2: TObject);

  end;

constructor TTest.Create(AInfo: TProgramInfo);
begin
  inherited Create;
{  FCaller:=AInfo.Caller;
  FFuncExpr:=AInfo.FuncExpr;
  FSymbol:=TFuncCodeExpr(FFuncExpr.Args[0]).FuncExpr.FuncSym;
  TMethodStaticExpr(FFuncExpr).FuncSym.Params.AddSymbol(FSymbol);
  FRoot:=FCaller.Root;
  FCall:=AInfo.Method[FSymbol.Name];}
end;

destructor TTest.Destroy;
begin
  inherited Destroy;
end;

procedure TTest.DoOnNotifyEvent(Sender: TObject);
var
  V: Variant;
  Proc: TProgram;
  Info: TProgramInfo;
begin
//
//  FCallInfo.Call([V]);
{   if (FSymbol as ICallable) then begin
     //
   end;}
//  Prog:=TProgram.Create();
  if Assigned(FCaller) and Assigned(FCallInfo) then begin
    V:=FCaller.Root.Info.RegisterExternalObject(Sender,false,false);
    FCallInfo.Call([V]);
  {  Proc:=TProgram.Create(FCaller.RootTable,nil,0);
    Proc.ReadyToRun;
    Proc.BeginProgram();
    Proc.Table.AddSymbol(FSymbol);

//    Proc.Info.ScriptObj:=
    Proc.Info.Method[FFunc].Call([V]);
    Proc.EndProgram;
    Proc.Free;}

{    info := TProgramInfo.Create(TFuncSymbol(FSymbol).Params, FCaller.Root);
    try
      info.FuncSym := TFuncSymbol(FSymbol);
      info.FuncExpr:= FFuncExpr;

      if not (TFuncSymbol(FSymbol) as TMethodSymbol).IsClassMethod then
        info.ScriptObj := info.Vars['Self'].ScriptObj;

      Info.Table.AddSymbol(FSymbol);
//      Info.Method[FSymbol.Name].Call([V]);
      Info.Method[FSymbol.Name].Call;
    finally
      info.Free;
    end;}
  end;
end;

procedure TTest.DoOnClick2(Sender1: TObject; Sender2: TObject);
var
  V1, V2: Variant;
begin
  V1:=FCaller.Root.Info.RegisterExternalObject(Sender1,false,false);
  V2:=FCaller.Root.Info.RegisterExternalObject(Sender2,false,false);
  FCallInfo.Call([V1,V2]);
end;

procedure TForm5.OnClick(Sender: TObject);
begin
  if Assigned(FOnClick2) then
    if FOnClick2 then
      ShowMessage('NewClick');
end;

function TForm5.Click2Event: Boolean;
var
  S: String;
begin
  Result:=InputQuery('Caption',Self.Name,S);
end;

procedure TForm5.Debugger1Debug(Prog: TProgram; Expr: TExpr);
var
  i: Integer;
begin
  Memo2.Lines.Add(IntToStr(Expr.Pos.Pos));
        for i:=0 to Prog.Msgs.Count-1 do
          Memo3.Lines.Add(Prog.Msgs[i].AsInfo);
end;

procedure TForm5.Button1Click(Sender: TObject);
var
  i: Integer;
  methSym: TMethodSymbol;
  typeSym: TTypeSymbol;

  Ret: TFuncSymbol;
  Ret2: TFuncSymbol;
  PTI: PTypeData;
  Method1: TMethod;
  Method2: TMethod;
  BrowserForm : TBrowserForm;
  Error: sTRING;
begin
  Memo2.Lines.Clear;
  Memo3.Lines.Clear;

  PTI:=GetTypeData(TypeInfo(TNotifyEvent));
  if Assigned(PTI) then begin
    Method1.Code:=@TForm5.OnClick;
    Method1.Data:=Self;
    SetMethodProp(Self,'OnClick',Method1);

    Method2.Code:=@TForm5.Click2Event;
    Method2.Data:=Self;
    SetMethodProp(Self,'OnClick2',Method2);
  end;



   Ret:=TMethodSymbol.Create('TNotifyEvent',fkProcedure, TClassSymbol(Script1.Config.SystemTable.FindSymbol(SYS_TOBJECT)),-1);

{  Ret := TFuncSymbol.Create('', fkProcedure, -1);
  methSym := TMethodSymbol.Create('',fkProcedure, TClassSymbol(Script1.Config.SystemTable.FindSymbol(SYS_TOBJECT)),-1);
  methSym.Typ := Ret.Typ;
  methSym.Name:='TNotifyEvent';
// methSym.BaseType:=Script1.Config.SystemTable.FindSymbol(SYS_TMETHOD);
  Ret.Free;
  Ret:=methSym;}

  Ret2 := TFuncSymbol.Create('', fkProcedure, -1);
  methSym := TMethodSymbol.Create('',fkProcedure, TClassSymbol(Script1.Config.SystemTable.FindSymbol(SYS_TOBJECT)),-1);
  methSym.Typ := Ret.Typ;
  methSym.Name:='TNotifyEvent2';
// methSym.BaseType:=Script1.Config.SystemTable.FindSymbol(SYS_TMETHOD);
  Ret2.Free;
  Ret2:=methSym;

  clsSym:=TClassSymbol.Create('TButton');
  typeSym:=TTypeSymbol.Create('TDateTime',Script1.Config.SystemTable.FindSymbol(SYS_DATETIME));


  BrowserForm := TBrowserForm.Create(Application);

   Script1.Config.SystemTable.AddSymbol(Ret);
   Script1.Config.SystemTable.AddSymbol(Ret2);
   Script1.Config.SystemTable.AddSymbol(typeSym);
 //  Script1.Config.SystemTable.AddSymbol(clsSym);

{      Unit2.ExposeClassToUnit(TComponent,TObject,nil,'TObject');
      Unit2.ExposeClassToUnit(TControl,TComponent,nil,'TComponent');
      Unit2.ExposeClassToUnit(TWinControl,TControl,nil,'TControl');
      Unit2.ExposeClassToUnit(TButton,TWinControl,nil,'TWinControl');
      Unit2.ExposeClassToUnit(TNewForm,TWinControl,nil,'TWinControl');}

      Unit2.ExposeClassToUnit(TComponent,TObject,nil,'');
      Unit2.ExposeClassToUnit(TControl,TComponent,nil,'');
      Unit2.ExposeClassToUnit(TGraphicControl,TControl,nil,'');
      Unit2.ExposeClassToUnit(TLabel,TGraphicControl,nil,'');
      Unit2.ExposeClassToUnit(TWinControl,TControl,nil,'');
      Unit2.ExposeClassToUnit(TButton,TWinControl,nil,'');
      Unit2.ExposeClassToUnit(TNewForm,TWinControl,nil,'');

    FP2:=Script1.Compile(MemoUnit1.Lines.Text);
    if FP2.Msgs.HasErrors or FP2.Msgs.HasCompilerErrors or FP2.Msgs.HasExecutionErrors then begin
      Error:=Self.Caption+#13#10+FP2.Msgs.AsInfo;
      if FP2.Msgs.Msgs[0] is TScriptMsg then begin
        ShowMessage(Error);
      end;
    end;

    try



      FP2.SaveToFile(ExtractFilePath(Application.ExeName)+'test.prg');
      BuildDictionaryList;

  BrowserForm.SymbolTable := FP2.Table;
  BrowserForm.Show;

      FP2.Debugger:=Debugger1;
      FP2.BeginProgram();
      if FP2.ProgramState=psRunning then begin

        FP2.RunProgram(0);
//        FP2.Info.Func['Show'].Call;

        FP2.EndProgram;
      end;
        if FP2.Result is Tdws2DefaultResult then
          Memo2.Lines.Add(Tdws2DefaultResult(FP2.Result).Text);

        for i:=0 to FP2.Msgs.Count-1 do
          Memo3.Lines.Add(FP2.Msgs[i].AsInfo);


    finally
    end;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
      Script1.Config.SystemTable.Remove(Ret);
{      FP2.RootTable.Remove(Ret);
      Ret.Free;}
      Script1.Config.SystemTable.Remove(Ret2);
      Script1.Config.SystemTable.Remove(clsSym);
{      FP2.RootTable.Remove(Ret2);
      Ret2.Free;}
      FP2.Free;
      BrowserForm.Free;
end;

procedure TForm5.Script1Include(const scriptName: string;
  var scriptSource: string);
begin
  scriptSource:=MemoUnit2.Lines.Text;
end;

procedure TForm5.Unit1ClassesTComponentConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject:=TComponent.Create(nil);
end;

procedure TForm5.Unit1ClassesTComponentMethodsClassNameEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  Info.Result:=ExtObject.ClassName;
end;

procedure TForm5.Unit1ClassesTComponentMethodsFreeEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TForm5.Unit1ClassesTComponentMethodsGetNameEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  Info.Result:=TComponent(ExtObject).Name;
end;

procedure TForm5.Unit1ClassesTComponentMethodsSetNameEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  TComponent(ExtObject).Name:=Info['Value'];
end;

procedure TForm5.Unit1ClassesTComponentMethodsSetNameInitExpr(Sender: TObject;
  Expr: TExprBase);
begin
  //
end;

procedure TForm5.Unit1ClassesTComponentMethodsSetNameInitSymbol(Sender: TObject;
  Symbol: TSymbol);
begin
  //
end;

procedure TForm5.Unit1ClassesTNewFormConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  AComp: TComponent;
  Obj: TObject;
begin
  Obj:=Info.GetExternalObjForVar('AOwner');
  AComp:=TComponent(Obj);
  ExtObject:=TNewForm.Create(AComp);
  TNewForm(ExtObject).Info:=Info;
//  TNewForm(ExtObject).UnitName:=Unit1.UnitName;
end;

procedure TForm5.Unit1ClassesTNewFormMethodsFreeEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  ExtObject.Free;
end;

{procedure TForm5.Unit1ClassesTNewFormMethodsGetCaptionEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  Info['Result']:=TNewForm(ExtObject).Caption;
end;

procedure TForm5.Unit1ClassesTNewFormMethodsGetOnClickEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  Info['Result']:=TNewForm(ExtObject).NewOnClick;
end;

procedure TForm5.Unit1ClassesTNewFormMethodsSetCaptionEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  TNewForm(ExtObject).Caption:=Info['Value'];
end;

procedure TForm5.Unit1ClassesTNewFormMethodsSetOnClickEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  TNewForm(ExtObject).NewOnClick:=Info['Value'];
end;

procedure TForm5.Unit1ClassesTNewFormMethodsShowModalEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  TNewForm(ExtObject).ShowModal;
end;}

procedure TForm5.Unit1FunctionsGetTest2Eval(Info: TProgramInfo);
begin
  Info.Result:='Hi';
end;

procedure TForm5.Unit1InstancesSelfInstantiate(var ExtObject: TObject);
begin
  ExtObject:=Self;
end;

{procedure TForm5.Unit2ClassesTNewFormMethodsGetOnClickEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  if Assigned(TNewForm(ExtObject).OnClick) then
    TNewForm(ExtObject).OnClick(Info.ScriptObj.ExternalObject);
end;}

{procedure TForm5.Unit2ClassesTButtonConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
//  ExtObject:=TButton.Create(TComponent(Info.GetExternalObjForVar('AOwner')));
end;}

procedure TForm5.Unit2ClassesTButtonMethodsSetOnClickEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
var
  Test: TTest;
  Met: TMethod;
begin
  Test:=TTest.Create(Info);
  Test.FCaller:=Info.Caller;
  Test.FSymbol:=TFuncCodeExpr(Info.FuncExpr.Args[0]).FuncExpr.FuncSym;
  Info.Table.AddSymbol(Test.FSymbol);
  Test.FCallInfo:=Info.Method[Test.FSymbol.Name];
  Info.Table.Remove(Test.FSymbol);

  Met.Code:=@TTest.DoOnNotifyEvent;
  Met.Data:=Test;
  SetMethodProp(ExtObject,'OnClick',Met);
end;

procedure TForm5.Unit2ClassesTComponentConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  ACls: TPersistentClass;
  ASym: TClassSymbol;
begin
  ASym:=Info.ScriptObj.ClassSym;
  repeat
    ACls:=GetClass(ASym.Name);
    if not Assigned(ACls) then
      ASym:=ASym.Parent;
  until (ACls<>nil) and (ASym<>nil);

  if Assigned(ACls) then
    ExtObject:=TComponentClass(ACls).Create(TComponent(Info.GetExternalObjForVar('AOwner')));
end;

procedure TForm5.Unit2ClassesTComponentMethodsFreeEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  ExtObject.Free;
end;


procedure TForm5.Unit2ClassesTComponentMethodsClassNameEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  Info.Result:=TComponent(ExtObject).ClassName;
end;

procedure TForm5.Unit2ClassesTComponentMethodsGetOwnerEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  Info.Result:=Info.RegisterExternalObject(TComponent(ExtObject).Owner);
end;

procedure TForm5.Unit2ClassesTControlMethodsGetOnClickEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  //
end;

procedure TForm5.Unit2ClassesTControlMethodsGetParentEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  Info.Result:=Info.RegisterExternalObject(TControl(ExtObject).Parent);
end;

procedure TForm5.Unit2ClassesTControlMethodsSetOnClickEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
var
  Test: TTest;
  Met: TMethod;
begin
  Test:=TTest.Create(Info);
  Test.FCaller:=Info.Caller;
  Test.FSymbol:=TFuncCodeExpr(Info.FuncExpr.Args[0]).FuncExpr.FuncSym;
  Info.Table.AddSymbol(Test.FSymbol);
  Test.FCallInfo:=Info.Method[Test.FSymbol.Name];
  Info.Table.Remove(Test.FSymbol);

  Met.Code:=@TTest.DoOnNotifyEvent;
  Met.Data:=Test;
  SetMethodProp(ExtObject,'OnClick',Met);
end;

procedure TForm5.Unit2ClassesTControlMethodsSetOnMouseEnterEval(
  Info: TProgramInfo; ExtObject: TObject; Expr: TExpr);
var
  Test: TTest;
  Met: TMethod;
begin
  Test:=TTest.Create(Info);
  Test.FCaller:=Info.Caller;
  Test.FSymbol:=TFuncCodeExpr(Info.FuncExpr.Args[0]).FuncExpr.FuncSym;
  Info.Table.AddSymbol(Test.FSymbol);
  Test.FCallInfo:=Info.Method[Test.FSymbol.Name];
  Info.Table.Remove(Test.FSymbol);

  Met.Code:=@TTest.DoOnNotifyEvent;
  Met.Data:=Test;
  SetMethodProp(ExtObject,'OnMouseEnter',Met);
end;

procedure TForm5.Unit2ClassesTControlMethodsSetOnMouseLeaveEval(
  Info: TProgramInfo; ExtObject: TObject; Expr: TExpr);
var
  Test: TTest;
  Met: TMethod;
begin
  Test:=TTest.Create(Info);
  Test.FCaller:=Info.Caller;
  Test.FSymbol:=TFuncCodeExpr(Info.FuncExpr.Args[0]).FuncExpr.FuncSym;
  Info.Table.AddSymbol(Test.FSymbol);
  Test.FCallInfo:=Info.Method[Test.FSymbol.Name];
  Info.Table.Remove(Test.FSymbol);

  Met.Code:=@TTest.DoOnNotifyEvent;
  Met.Data:=Test;
  SetMethodProp(ExtObject,'OnMouseLeave',Met);
end;

procedure TForm5.Unit2ClassesTControlMethodsSetParentEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  TControl(ExtObject).Parent:=TWinControl(Info.Vars['Value'].ScriptObj.ExternalObject);
end;

procedure TForm5.Unit2ClassesTNewFormMethodsGetButtonEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  Info.Result:=Info.RegisterExternalObject(TNewForm(ExtObject).Button1);
end;

procedure TForm5.Unit2ClassesTNewFormMethodsGetOnClickInitExpr(Sender: TObject;
  Expr: TExprBase);
begin
  ShowMessage(Expr.ClassName);
end;

procedure TForm5.Unit2ClassesTNewFormMethodsSetOnClick2Eval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
var
  Test: TTest;
  Met: TMethod;
begin
  Test:=TTest.Create(Info);
  Test.FCaller:=Info.Caller;
  Test.FSymbol:=TFuncCodeExpr(Info.FuncExpr.Args[0]).FuncExpr.FuncSym;
  Info.Table.AddSymbol(Test.FSymbol);
  Test.FCallInfo:=Info.Method[Test.FSymbol.Name];
  Info.Table.Remove(Test.FSymbol);

  Met.Code:=@TTest.DoOnClick2;
  Met.Data:=Test;
  SetMethodProp(ExtObject,'OnClick2',Met);
end;

procedure TForm5.Unit2ClassesTNewFormMethodsSetOnClickEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
var
  Test: TTest;
  Met: TMethod;
begin
  Test:=TTest.Create(Info);
  Test.FFunc:=TFuncCodeExpr(Info.FuncExpr.Args[0]).FuncExpr.FuncSym.Name;
//  ShowMessage(Test.FFunc);
  Test.FSymbol:=TFuncCodeExpr(Info.FuncExpr.Args[0]).FuncExpr.FuncSym;
  Test.FFuncExpr:=Info.FuncExpr;
  Test.FCaller:=Info.Caller;
  Info.Table.AddSymbol(Test.FSymbol);
  Test.FCallInfo:=Info.Method[Test.FSymbol.Name];
  Info.Table.Remove(Test.FSymbol);
//  Test.FCaller.Table.AddSymbol(Test.FSymbol);
//  Test.FCaller.Table.AddSymbol(Test.FSymbol);

//  TMethodStaticExpr(Info.FuncExpr).FuncSym.Params.AddSymbol(Test.FSymbol);
//  Info.Table.AddSymbol(Test.FSymbol);
 /// Test.FCallInfo:=Info.Method[Test.FSymbol.Name];

  Met.Code:=@TTest.DoOnNotifyEvent;
  Met.Data:=Test;
//  ShowMessage(ExtObject.ClassName);
  SetMethodProp(ExtObject,'OnClick',Met);
end;

procedure TForm5.Unit2ClassesTNewFormMethodsSetOnClickInitExpr(Sender: TObject;
  Expr: TExprBase);
begin
//  ShowMessage(TFuncExpr(TMethodStaticExpr(Expr).Args[0]).FuncSym.Name);
 // ShowMessage(TFuncCodeExpr(TMethodStaticExpr(Expr).Args[0]).FuncExpr.FuncSym.Name);
end;

procedure TForm5.Unit2ClassesTNewFormMethodsSetOnClickInitSymbol(
  Sender: TObject; Symbol: TSymbol);
begin
  //
end;

procedure TForm5.Unit2ClassesTNewFormMethodsShowModalEval(Info: TProgramInfo;
  ExtObject: TObject; Expr: TExpr);
begin
  TNewForm(ExtObject).ShowModal;
end;

procedure TForm5.Unit2FunctionsDateEval(Info: TProgramInfo);
begin
  Info.Result:=Date;
end;

procedure TForm5.Unit2FunctionsGetTest2Eval(Info: TProgramInfo);
begin
  Info.Result:='Hi2';
end;



procedure TForm5.Unit2FunctionsShowMessageEval(Info: TProgramInfo);
begin
  ShowMessage(Info['Msg']);
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MemoUnit1.Lines.SaveToFile(ExtractFilePath(Application.ExeName)+'1.txt');
  MemoUnit2.Lines.SaveToFile(ExtractFilePath(Application.ExeName)+'2.txt');
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  FProgram:=TBisProgram.Create(nil);
  
  MemoUnit1.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'1.txt');
  MemoUnit2.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'2.txt');
end;

procedure TForm5.FormDestroy(Sender: TObject);
begin
  FProgram.Free;
end;

procedure TForm5.lbSymNamesClick(Sender: TObject);
var
  i: Integer;
  SymList: TSymbolPositionList;
  Sym: TSymbolPosition;
  TypeDisplay: string;
  Usages: TStringList;
begin
  { User selected a symbol. Show list of positions in script. }
  lbSymPositions.Items.Clear;

  Usages := TStringList.Create;
  try
    if lbSymNames.ItemIndex > -1 then begin
      SymList := TSymbolPositionList(lbSymNames.Items.Objects[lbSymNames.ItemIndex]);
      if Assigned(SymList) then
        for i := 0 to SymList.Count - 1 do begin
          Sym := SymList[i];
          Usages.Clear;
          if suForward in Sym.SymbolUsages then
            Usages.Add('Forward');
          if suDeclaration in Sym.SymbolUsages then
            Usages.Add('Declared');
          if suImplementation in Sym.SymbolUsages then
            Usages.Add('Implemented');
          if suReference in Sym.SymbolUsages then
            Usages.Add('Referenced');

          TypeDisplay := '';
          if Usages.Count > 0 then
            TypeDisplay := '('+Usages.CommaText+')';

          lbSymPositions.Items.AddObject(Format('Line %d : Col %d %s - [%s]',
                                                [Sym.ScriptPos.Line,
                                                 Sym.ScriptPos.Col,
                                                 TypeDisplay,
                                                 GetScriptName(Sym.ScriptPos)]),
                                         Sym);   // add pointer to symbol position
        end;
    end;
  finally
    Usages.Free;
  end;
end;

procedure TForm5.lbSymPositionsClick(Sender: TObject);
var
  SymPos: TSymbolPosition;
begin
  { On double-click of a Symbol position, put cursor at the script postion }
  if lbSymPositions.ItemIndex > -1 then
  begin
    // get object in the list
    SymPos := TSymbolPosition(lbSymPositions.Items.Objects[lbSymPositions.ItemIndex]);
    if Assigned(SymPos) then
    begin
      // validate position is in the main script

      // place cursor at the symbol's position
  {    ��
      Editor.CaretX := SymPos.ScriptPos.Col;
      Editor.CaretY := SymPos.ScriptPos.Line;
      ActiveControl := Editor;}
    end;
  end;
end;

procedure TForm5.MemoUnit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Caption:=IntToStr(MemoUnit1.CaretPos.Y+1);
end;

procedure TForm5.MemoUnit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Caption:=IntToStr(MemoUnit1.CaretPos.Y+1);
end;

procedure TForm5.BuildDictionaryList;
var
  i,j: Integer;
  SymList: TSymbolPositionList;
  Sym: TSymbolPosition;
  TypeDisplay: string;
  Usages: TStringList;
begin
  lbSymNames.Clear;
  lbSymPositions.Items.Clear;

  { Call for a compile. Will create Program. }
  for i := 0 to FP2.SymbolDictionary.Count - 1 do begin
    SymList := FP2.SymbolDictionary[i];
    lbSymNames.Items.AddObject(Format('%s = %s', [SymList.Symbol.Name,
                                                  SymList.Symbol.ClassName]),
                               SymList);
  Usages := TStringList.Create;
  try
      if Assigned(SymList) then
        for j := 0 to SymList.Count - 1 do begin
          Sym := SymList[j];
          Usages.Clear;
          if suForward in Sym.SymbolUsages then
            Usages.Add('Forward');
          if suDeclaration in Sym.SymbolUsages then
            Usages.Add('Declared');
          if suImplementation in Sym.SymbolUsages then
            Usages.Add('Implemented');
          if suReference in Sym.SymbolUsages then
            Usages.Add('Referenced');

          TypeDisplay := '';
          if Usages.Count > 0 then
            TypeDisplay := '('+Usages.CommaText+')';

          lbSymNames.Items.AddObject(Format('Line %d : Col %d %s - [%s]',
                                                [Sym.ScriptPos.Line,
                                                 Sym.ScriptPos.Col,
                                                 TypeDisplay,
                                                 GetScriptName(Sym.ScriptPos)]),
                                         Sym);   // add pointer to symbol position
        end;
  finally
    Usages.Free;
  end;
  end;
  lbSymNames.ItemIndex := 0;   // set to the first one
end;


function TForm5.GetScriptName(ScriptPos: TScriptPos): string;
var
  x: Integer;
begin
  // find index of script file
  x := FP2.SourceList.IndexOf(ScriptPos);
  if (x > -1) then
  begin
    Result := FP2.SourceList[x].NameReference;
    if Result = '' then
      Result := '(main module)';
  end
  else
    Result := '(unknown)';
end;

procedure TForm5.Button3Click(Sender: TObject);
begin
 { FProgram.Stop;
  FProgram.Units.Clear;
  FProgram.Units.AddClass(TBisSysUtilsUnit);
  FProgram.Start; }
end;


procedure TForm5.Unit2InstancesSelfTestInstantiate(var ExtObject: TObject);
begin
  ExtObject:=Self;
end;

end.
