unit BisKrieltDataPresentationEditFm;
 
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, DB,
  BisDataEditFm, BisParam, BisControls;

type
  TBisKrieltDataPresentationType=(ptViewing,ptImport);

  TBisKrieltDataPresentationEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPresentationType: TLabel;
    ComboBoxPresentationType: TComboBox;
    LabelTableName: TLabel;
    EditTableName: TEdit;
    LabelSorting: TLabel;
    EditSorting: TEdit;
    LabelView: TLabel;
    LabelType: TLabel;
    LabelOperation: TLabel;
    LabelPublishing: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    EditType: TEdit;
    ButtonType: TButton;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    LabelConditions: TLabel;
    MemoConditions: TMemo;
    ButtonTableName: TButton;
    procedure ButtonTableNameClick(Sender: TObject);
  private
    function GetTableName: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisKrieltDataPresentationEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPresentationFilterFormIface=class(TBisKrieltDataPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPresentationInsertFormIface=class(TBisKrieltDataPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPresentationUpdateFormIface=class(TBisKrieltDataPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPresentationDeleteFormIface=class(TBisKrieltDataPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPresentationEditForm: TBisKrieltDataPresentationEditForm;

function GetPresentationTypeByIndex(Index: Integer): String;
  
implementation

uses TypInfo,
     BisProvider,
     BisKrieltDataViewsFm,
     BisKrieltDataTypesFm, BisKrieltDataOperationsFm, BisKrieltDataPublishingFm;

{$R *.dfm}

function GetPresentationTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case TBisKrieltDataPresentationType(Index) of
    ptViewing: Result:='��� ���������';
    ptImport: Result:='��� �������';
  end;
end;

{ TBisKrieltDataPresentationEditFormIface }

constructor TBisKrieltDataPresentationEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPresentationEditForm;
  with Params do begin
    AddKey('PRESENTATION_ID').Older('OLD_PRESENTATION_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddComboBox('PRESENTATION_TYPE','ComboBoxPresentationType','LabelPresentationType',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('TABLE_NAME','EditTableName','LabelTableName');
    AddEdit('SORTING','EditSorting','LabelSorting');
    AddEditDataSelect('PUBLISHING_ID','EditPublishing','LabelPublishing','ButtonPublishing',
                      TBisKrieltDataPublishingFormIface,'PUBLISHING_NAME',false,false,'','NAME');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisKrieltDataViewsFormIface,'VIEW_NAME',false,false,'','NAME');
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataTypesFormIface,'TYPE_NAME',false,false,'','NAME');
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataOperationsFormIface,'OPERATION_NAME',false,false,'','NAME');
    AddMemo('CONDITIONS','MemoConditions','LabelConditions',false);
  end;
end;

{ TBisKrieltDataPresentationFilterFormIface }

constructor TBisKrieltDataPresentationFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

{ TBisKrieltDataPresentationInsertFormIface }

constructor TBisKrieltDataPresentationInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PRESENTATION';
end;

{ TBisKrieltDataPresentationUpdateFormIface }

constructor TBisKrieltDataPresentationUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PRESENTATION';
end;

{ TBisKrieltDataPresentationDeleteFormIface }

constructor TBisKrieltDataPresentationDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PRESENTATION';
end;

{ TBisKrieltDataPresentationEditForm }

constructor TBisKrieltDataPresentationEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxPresentationType.Clear;
  for i:=0 to 1 do begin
    ComboBoxPresentationType.Items.Add(GetPresentationTypeByIndex(i));
  end;

end;

procedure TBisKrieltDataPresentationEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisKrieltDataPresentationEditForm.ChangeParam(Param: TBisParam);
var
  PresentationType: TBisKrieltDataPresentationType;
begin
  inherited ChangeParam(Param);
  if Assigned(Param) then begin
    if AnsiSameText(Param.ParamName,'PRESENTATION_TYPE') then begin
      if not Param.Empty then begin
        PresentationType:=Param.Value;
        Provider.Params.ParamByName('TABLE_NAME').Enabled:=PresentationType<>ptImport;
        Provider.Params.ParamByName('SORTING').Enabled:=PresentationType<>ptImport;
        Provider.Params.ParamByName('CONDITIONS').Enabled:=PresentationType<>ptImport;
      end;
    end;
  end;
end;

function TBisKrieltDataPresentationEditForm.GetTableName: String;
var
  P: TBisProvider;
begin
  Result:='';
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='GET_PRESENTATION_TABLE_NAME';
    P.Params.AddInvisible('TABLE_NAME',ptOutput);
    P.Execute;
    if P.Success then
      Result:=P.ParamByName('TABLE_NAME').AsString;
  finally
    P.Free;
  end;
end;

procedure TBisKrieltDataPresentationEditForm.ButtonTableNameClick(Sender: TObject);
begin
  Provider.ParamByName('TABLE_NAME').Value:=GetTableName;
end;


end.
