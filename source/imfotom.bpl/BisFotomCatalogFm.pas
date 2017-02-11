unit BisFotomCatalogFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ExtCtrls, ComCtrls, DB,
  BisDataFm, BisDataGridFm, BisFieldNames;

type
  TBisFotomCatalogForm = class(TBisDataGridForm)
  private
    FFieldNameBarcode: TBisFieldName;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;
  end;

var
  BisFotomCatalogForm: TBisFotomCatalogForm;

implementation

uses BisFotomConsts, BisDialogs, BisOrders;

{$R *.dfm}

{ TBisFotomCatalogForm }

constructor TBisFotomCatalogForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with DataFrame do begin
    ActionExport.Visible:=false;
    ActionFilter.Visible:=false; 
    ActionView.Visible:=false;
    ActionInsert.Visible:=false;
    ActionDuplicate.Visible:=false;
    ActionUpdate.Visible:=false;
    ActionDelete.Visible:=false;
    ToolBarEdit.Visible:=false;
    Grid.NumberVisible:=false;
    Grid.ChessVisible:=true;
    Grid.AutoResizeableColumns:=true;
    Grid.SearchEnabled:=true;
    with Provider.FieldNames do begin
      AddKey(SFieldID);
      AddInvisible(SFieldOwner);
      FFieldNameBarcode:=Add(SFieldBarcode,'�����-���',90);
      Add(SFieldCode,'���',110);
      Add(SFieldName,'������������',170);
      Add(SFieldProducer,'�������������',80);
      Add(SFieldCountry,'������',60);
    end;
  end;
end;

destructor TBisFotomCatalogForm.Destroy;
begin

  inherited Destroy;
end;

procedure TBisFotomCatalogForm.BeforeShow;
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    inherited BeforeShow;
    DataFrame.Grid.OrderByFieldName(FFieldNameBarcode,otAsc);
    if Trim(VarToStrDef(LocateValues,''))='' then
      DataFrame.FirstRecord;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

end.
