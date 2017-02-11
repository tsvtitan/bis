unit BisKrieltDataSubjectEditFm;

interface
                                                                                                           
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs, ImgList,
  BisFm, BisDataEditFm, BisParam, BisControls;

type
  TBisKrieltDataSubjectEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    OpenPictureDialog: TOpenPictureDialog;
    SavePictureDialog: TSavePictureDialog;
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure Execute; override;
    function ChangesExists: Boolean; override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataSubjectEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubjectInsertFormIface=class(TBisKrieltDataSubjectEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubjectInsertChildFormIface=class(TBisKrieltDataSubjectEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubjectUpdateFormIface=class(TBisKrieltDataSubjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubjectDeleteFormIface=class(TBisKrieltDataSubjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataSubjectEditForm: TBisKrieltDataSubjectEditForm;

implementation

uses BisProvider,
     BisFilterGroups, BisUtils, BisCore,
     BisKrieltDataSubjectsFm;

{$R *.dfm}

{ TBisKrieltDataSubjectEditFormIface }

constructor TBisKrieltDataSubjectEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataSubjectEditForm;
  with Params do begin
    with AddKey('SUBJECT_ID') do begin
      Older('OLD_SUBJECT_ID');
    end;
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisKrieltDataSubjectsFormIface,'PARENT_NAME',false,false,'Subject_ID','NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisKrieltDataSubjectInsertFormIface }

constructor TBisKrieltDataSubjectInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SUBJECT';
  Caption:='������� ����';
end;

function TBisKrieltDataSubjectInsertFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('PARENT_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('PARENT_NAME').Value);
      end;
    end;
  end;
end;

{ TBisKrieltDataSubjectInsertChildFormIface }

constructor TBisKrieltDataSubjectInsertChildFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SUBJECT';
  Caption:='������� �������';
end;


function TBisKrieltDataSubjectInsertChildFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('SUBJECT_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('NAME').Value);
      end;
    end;
  end;
end;

{ TBisKrieltDataSubjectUpdateFormIface }

constructor TBisKrieltDataSubjectUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SUBJECT';
  Caption:='�������� ����';
end;

{ TBisKrieltDataSubjectDeleteFormIface }

constructor TBisKrieltDataSubjectDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SUBJECT';
  Caption:='������� ����';
end;

{ TBisKrieltDataSubjectEditForm }

constructor TBisKrieltDataSubjectEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltDataSubjectEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

function TBisKrieltDataSubjectEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists;
end;

procedure TBisKrieltDataSubjectEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisKrieltDataSubjectEditForm.Execute;
begin
  inherited Execute;
end;

end.
