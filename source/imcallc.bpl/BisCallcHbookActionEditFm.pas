unit BisCallcHbookActionEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookActionEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPurpose: TLabel;
    ComboBoxPurpose: TComboBox;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookActionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookActionInsertFormIface=class(TBisCallcHbookActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookActionUpdateFormIface=class(TBisCallcHbookActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookActionDeleteFormIface=class(TBisCallcHbookActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookActionEditForm: TBisCallcHbookActionEditForm;

function GetPurposeByIndex(Index: Integer): String;

implementation

{$R *.dfm}

function GetPurposeByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='Оператор';
    1: Result:='Делопроизводитель';
    2: Result:='Руководитель';
    3: Result:='Менеджер';
  end;
end;

{ TBisCallcHbookActionEditFormIface }

constructor TBisCallcHbookActionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookActionEditForm;
  with Params do begin
    AddKey('ACTION_ID').Older('OLD_ACTION_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddComboBox('PURPOSE','ComboBoxPurpose','LabelPurpose',true);
  end;
end;

{ TBisCallcHbookActionInsertFormIface }

constructor TBisCallcHbookActionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACTION';
end;

{ TBisCallcHbookActionUpdateFormIface }

constructor TBisCallcHbookActionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACTION';
end;

{ TBisCallcHbookActionDeleteFormIface }

constructor TBisCallcHbookActionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACTION';
end;

{ TBisCallcHbookActionEditForm }

constructor TBisCallcHbookActionEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  ComboBoxPurpose.Clear;
  for i:=0 to 3 do begin
    ComboBoxPurpose.Items.Add(GetPurposeByIndex(i));
  end;
end;

end.
