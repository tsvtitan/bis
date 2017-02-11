unit BisOmStdSystem;

interface

uses Classes,
     BisScriptUnits, BisScriptTypes, BisScriptFuncs, BisScriptClass;

type
  TBisSystemScriptUnit=class(TBisScriptUnit)
  private
    function ClassTObjectMethodCreate(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
    function ClassTObjectMethodFree(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
    function ClassTObjectMethodClassName(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

uses Dialogs, SysUtils;

{ TBisSystemScriptUnit }

constructor TBisSystemScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UnitName:='System';

  Types.AddInteger('Integer');
  Types.AddFloat('Float');
  Types.AddString('String');
  Types.AddDateTime('TDateTime');
  Types.AddBoolean('Boolean');
  Types.AddVariant('Variant');

  Types.AddFloat('Extended','Float');
  Types.AddFloat('Currency','Float');
  Types.AddDateTime('TDate','TDateTime');
  Types.AddDateTime('TTime','TDateTime');

  with Types.AddClass('TObject',TObject) do begin
    Methods.AddConstructor('Create',ClassTObjectMethodCreate);
    Methods.AddProcedure('Free',ClassTObjectMethodFree);
    Methods.AddFunction('ClassName',ClassTObjectMethodClassName,'String');
  end;

end;

function TBisSystemScriptUnit.ClassTObjectMethodCreate(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
begin
  Obj:=TObject.Create;
end;

function TBisSystemScriptUnit.ClassTObjectMethodFree(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
begin
  FreeAndNil(Obj);
end;

function TBisSystemScriptUnit.ClassTObjectMethodClassName(Method: TBisScriptClassMethod; var Obj: TObject): Variant;
begin
  Result:=Obj.ClassName;
end;

end.
