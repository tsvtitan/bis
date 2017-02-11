unit BisKrieltDataColumnsFm;
                                                                                                    
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataGridFm, BisFieldNames, BisDataFrm,
  BisKrieltDataPresentationEditFm;

type
  TBisKrieltDataColumnsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisKrieltDataColumnsFormIface=class(TBisDataGridFormIface)
  private
    FPresentationId: Variant;
    FPresentationName: String;
    FPresentationType: TBisKrieltDataPresentationType;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property PresentationId: Variant read FPresentationId write FPresentationId;
    property PresentationName: String read FPresentationName write FPresentationName;
    property PresentationType: TBisKrieltDataPresentationType read FPresentationType write FPresentationType;  
  end;

var
  BisKrieltDataColumnsForm: TBisKrieltDataColumnsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataColumnEditFm, BisKrieltDataColumnsFrm;

{ TBisKrieltDataColumnsFormIface }

constructor TBisKrieltDataColumnsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataColumnsForm;
  FilterClass:=TBisKrieltDataColumnFilterFormIface;
  InsertClass:=TBisKrieltDataColumnInsertFormIface;
  UpdateClass:=TBisKrieltDataColumnUpdateFormIface;
  DeleteClass:=TBisKrieltDataColumnDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_COLUMNS';
  with FieldNames do begin
    AddKey('COLUMN_ID');
    AddInvisible('PRESENTATION_ID');
    AddInvisible('VALUE_DEFAULT');
    AddInvisible('VISIBLE');
    AddInvisible('USE_DEPEND');
    AddInvisible('NOT_EMPTY');
    AddInvisible('ALIGN');
    AddInvisible('DESCRIPTION');
    Add('NAME','������������',150);
    Add('WIDTH','������',50);
    Add('PRIORITY','������� �����������',50);
    Add('SEARCH_PRIORITY','������� ������',50);
    Add('PRESENTATION_NAME','�������������',150);
  end;
  Orders.Add('PRIORITY');
end;

function TBisKrieltDataColumnsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataColumnsForm(Result) do begin
      TBisKrieltDataColumnsFrame(DataFrame).PresentationId:=FPresentationId;
      TBisKrieltDataColumnsFrame(DataFrame).PresentationName:=FPresentationName;
      TBisKrieltDataColumnsFrame(DataFrame).PresentationType:=FPresentationType;
    end;
  end;
end;

{ TBisKrieltDataColumnsForm }

class function TBisKrieltDataColumnsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataColumnsFrame;
end;

end.