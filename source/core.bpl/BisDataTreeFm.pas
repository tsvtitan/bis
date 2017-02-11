unit BisDataTreeFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisDataFm, BisFm, BisDataFrm, BisDataTreeFrm, BisDataGridFm;

type
  TBisDataTreeForm = class(TBisDataGridForm)
  private
    function GetDataFrame: TBisDataTreeFrame;
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;

    property DataFrame: TBisDataTreeFrame read GetDataFrame;
  end;

  TBisDataTreeFormIface=class(TBisDataGridFormIface)
  private
    function GetLastForm: TBisDataTreeForm;
  protected
    procedure SetDataFrameProperties(DataFrame: TBisDataFrame); override;
  public
    constructor Create(AOwner: TComponent); override;
    property LastForm: TBisDataTreeForm read GetLastForm;
  end;

var
  BisDataTreeForm: TBisDataTreeForm;

implementation

{$R *.dfm}

{ TBisDataTreeFormIface }

constructor TBisDataTreeFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDataTreeForm;
end;

function TBisDataTreeFormIface.GetLastForm: TBisDataTreeForm;
begin
  Result:=TBisDataTreeForm(inherited LastForm);
end;

procedure TBisDataTreeFormIface.SetDataFrameProperties(DataFrame: TBisDataFrame);
begin
  inherited SetDataFrameProperties(DataFrame);
  if ChangeFrameProperties then begin
    if Assigned(DataFrame) then begin
{      DataFrame.Tree.KeyFieldNames:=FKeyFieldNames;
      DataFrame.Tree.ParentFieldNames:=FParentFieldNames;
      DataFrame.Tree.ViewFieldName:=FViewFieldName;}
    end;
  end;
end;

{ TBisDataTreeForm }

constructor TBisDataTreeForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisDataTreeForm.GetDataFrame: TBisDataTreeFrame;
begin
  Result:=TBisDataTreeFrame(inherited DataFrame);
end;

class function TBisDataTreeForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDataTreeFrame;
end;

end.
