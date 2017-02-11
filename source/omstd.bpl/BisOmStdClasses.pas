unit BisOmStdClasses;

interface

uses Classes,
     BisScriptUnits, BisScriptTypes, BisScriptFuncs, BisScriptClass;
type
  TBisClassesScriptUnit=class(TBisScriptUnit)
  private
    function ClassTComponentMethodCreate(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses BisUtils;

{ TBisClassesScriptUnit }

constructor TBisClassesScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UnitName:='Classes';

  Depends.Add('System');

  Types.AddString('TComponentName');

  with Types.AddMethodProc('TNotifyEvent') do begin
    Params.Add('Sender','TObject');
  end;

  with Types.AddClass('TComponent',TComponent,'TObject') do begin
    with Methods.AddConstructor('Create',ClassTComponentMethodCreate) do begin
      Params.Add('AOwner','TComponent');
    end;
    Props.AddByClass;
  end;
end;

function TBisClassesScriptUnit.ClassTComponentMethodCreate(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
var
  AClass: TPersistentClass;
begin
  AClass:=GetClass(Method.Parent.Name);
  if Assigned(AClass) and IsClassParent(AClass,TComponent) then
    Obj:=TComponentClass(AClass).Create(TComponent(Method.Params[0].AsObject));
end;

initialization
  RegisterClass(TComponent);

end.
