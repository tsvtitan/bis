unit BisKrieltDataParamEditFm;

interface                                                                                              

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type

  TBisKrieltDataParamType=(dptList,dptInteger,dptFloat,dptString,dptDate,dptDateTime,
                           dptImage,dptDocument,dptVideo,dptLink);
  TBisKrieltDataParamSorting=(dpsNone,dpsName,dpsPriority);

  TBisKrieltDataParamEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelParamType: TLabel;
    ComboBoxParamType: TComboBox;
    LabelMaxLength: TLabel;
    EditMaxLength: TEdit;
    LabelSorting: TLabel;
    ComboBoxSorting: TComboBox;
    CheckBoxLocked: TCheckBox;
    LabelDefault: TLabel;
    EditDefault: TEdit;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function CheckParam(Param: TBisParam): Boolean; override;
  end;

  TBisKrieltDataParamEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamFilterFormIface=class(TBisKrieltDataParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamInsertFormIface=class(TBisKrieltDataParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamUpdateFormIface=class(TBisKrieltDataParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamDeleteFormIface=class(TBisKrieltDataParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataParamEditForm: TBisKrieltDataParamEditForm;

function GetParamTypeByIndex(Index: Integer): String;

implementation

uses TypInfo;

{$R *.dfm}

function GetParamTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case TBisKrieltDataParamType(Index) of
    dptList: Result:='������';
    dptInteger: Result:='����� �����';
    dptFloat: Result:='����� � ������';
    dptString: Result:='������';
    dptDate: Result:='����';
    dptDateTime: Result:='���� � �����';
    dptImage: Result:='�����������';
    dptDocument: Result:='��������';
    dptVideo: Result:='�����';
    dptLink: Result:='������';
  end;
end;

{ TBisKrieltDataParamEditFormIface }

constructor TBisKrieltDataParamEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataParamEditForm;
  with Params do begin
    AddKey('PARAM_ID').Older('OLD_PARAM_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBox('PARAM_TYPE','ComboBoxParamType','LabelParamType',true);
    AddEditInteger('MAX_LENGTH','EditMaxLength','LabelMaxLength');
    AddComboBox('SORTING','ComboBoxSorting','LabelSorting');
    AddCheckBox('LOCKED','CheckBoxLocked');
    AddEdit('DEFAULT_VALUE','EditDefault','LabelDefault');
  end;
end;

{ TBisKrieltDataParamFilterFormIface }

constructor TBisKrieltDataParamFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataParamInsertFormIface }

constructor TBisKrieltDataParamInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PARAM';
end;

{ TBisKrieltDataParamUpdateFormIface }

constructor TBisKrieltDataParamUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PARAM';
end;

{ TBisKrieltDataParamDeleteFormIface }

constructor TBisKrieltDataParamDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PARAM';
end;

{ TBisKrieltDataParamEditForm }

constructor TBisKrieltDataParamEditForm.Create(AOwner: TComponent);
var
  i: Integer;
  PInfo: PTypeInfo;
  PData: PTypeData;
begin
  inherited Create(AOwner);

  ComboBoxParamType.Clear;
  PData:=nil;
  PInfo:=TypeInfo(TBisKrieltDataParamType);
  if Assigned(PInfo) then
    PData:=GetTypeData(PInfo);
  if Assigned(PData) then
    for i:=PData.MinValue to PData.MaxValue do begin
      ComboBoxParamType.Items.Add(GetParamTypeByIndex(i));
    end;
end;

function TBisKrieltDataParamEditForm.CheckParam(Param: TBisParam): Boolean;
var
  ParamType: TBisKrieltDataParamType;
  OldRequired: Boolean;
begin
  Result:=false;
  if Assigned(Param) then begin
    if AnsiSameText(Param.ParamName,'MAX_LENGTH') then begin
      OldRequired:=Param.Required;
      try
        ParamType:=TBisKrieltDataParamType(Provider.Params.ParamByName('PARAM_TYPE').AsInteger);
        Param.Required:=ParamType in [dptString,dptLink];
        Result:=inherited CheckParam(Param);
      finally
        Param.Required:=OldRequired;
      end;
    end else
      Result:=inherited CheckParam(Param);
  end;
end;

end.
