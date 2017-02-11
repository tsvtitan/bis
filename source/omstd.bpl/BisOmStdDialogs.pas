unit BisOmStdDialogs;

interface

uses Classes,
     BisScriptUnits, BisScriptType, BisScriptTypes, BisScriptFuncs;

type
  TBisDialogsScriptUnit=class(TBisScriptUnit)
  private
    function FuncShowInfo(Func: TBisScriptFunc): Variant;
    function FuncShowQuestion(Func: TBisScriptFunc): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

uses SysUtils, Dialogs,
     BisDialogs;

{ TBisDialogsScriptUnit }

constructor TBisDialogsScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UnitName:='Dialogs';

  Depends.Add('System');
  Depends.Add('Classes');
  Depends.Add('Controls');
  Depends.Add('Forms');

  Types.AddInteger('TMsgDlgBtn','Integer');

  Vars.Add('mbYes',mbYes,'TMsgDlgBtn',True);
  Vars.Add('mbNo',mbNo,'TMsgDlgBtn',True);
  Vars.Add('mbOK',mbOK,'TMsgDlgBtn',True);
  Vars.Add('mbCancel',mbCancel,'TMsgDlgBtn',True);
  Vars.Add('mbAbort',mbAbort,'TMsgDlgBtn',True);
  Vars.Add('mbRetry',mbRetry,'TMsgDlgBtn',True);
  Vars.Add('mbIgnore',mbIgnore,'TMsgDlgBtn',True);
  Vars.Add('mbAll',mbAll,'TMsgDlgBtn',True);
  Vars.Add('mbNoToAll',mbNoToAll,'TMsgDlgBtn',True);
  Vars.Add('mbYesToAll',mbYesToAll,'TMsgDlgBtn',True);
  Vars.Add('mbHelp',mbHelp,'TMsgDlgBtn',True);

  with Funcs.AddProcedure('ShowInfo',FuncShowInfo) do begin
    Params.Add('Msg','String');
    Params.Add('UseTimer','Boolean',True);
  end;

  with Funcs.AddProcedure('ShowError',FuncShowInfo) do begin
    Params.Add('Msg','String');
    Params.Add('UseTimer','Boolean',True);
  end;

  with Funcs.AddProcedure('ShowWarning',FuncShowInfo) do begin
    Params.Add('Msg','String');
    Params.Add('UseTimer','Boolean',True);
  end;

  with Funcs.AddFunction('ShowQuestion',FuncShowQuestion,'Integer') do begin
    Params.Add('Msg','String');
    Params.Add('DefaultButton','TMsgDlgBtn',mbYes);
    Params.Add('UseTimer','Boolean',True);
  end;

end;

function TBisDialogsScriptUnit.FuncShowInfo(Func: TBisScriptFunc): Variant;
begin
  if AnsiSameText(Func.Name,'ShowInfo') then
    ShowInfo(Func.Params[0].AsString,Func.Params[1].AsBoolean)
  else if AnsiSameText(Func.Name,'ShowError') then
    ShowError(Func.Params[0].AsString,Func.Params[1].AsBoolean)
  else if AnsiSameText(Func.Name,'ShowWarning') then
    ShowWarning(Func.Params[0].AsString,Func.Params[1].AsBoolean)
end;

function TBisDialogsScriptUnit.FuncShowQuestion(Func: TBisScriptFunc): Variant;
begin
  Result:=ShowQuestion(Func.Params[0].AsString,TMsgDlgBtn(Func.Params[1].AsInteger),Func.Params[2].AsBoolean);
end;



end.
