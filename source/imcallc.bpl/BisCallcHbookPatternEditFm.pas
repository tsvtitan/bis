unit BisCallcHbookPatternEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisCallcHbookPatternEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPattern: TLabel;
    RichEditPattern: TRichEdit;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonClear: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisCallcHbookPatternEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPatternInsertFormIface=class(TBisCallcHbookPatternEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPatternUpdateFormIface=class(TBisCallcHbookPatternEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPatternDeleteFormIface=class(TBisCallcHbookPatternEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookPatternEditForm: TBisCallcHbookPatternEditForm;

implementation

{$R *.dfm}

{ TBisCallcHbookPatternEditFormIface }

constructor TBisCallcHbookPatternEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookPatternEditForm;
  with Params do begin
    AddKey('PATTERN_ID').Older('OLD_PATTERN_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddRichEdit('PATTERN','RichEditPattern','LabelPattern',true);
  end;
end;

{ TBisCallcHbookPatternInsertFormIface }

constructor TBisCallcHbookPatternInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PATTERN';
end;

{ TBisCallcHbookPatternUpdateFormIface }

constructor TBisCallcHbookPatternUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PATTERN';
end;

{ TBisCallcHbookPatternDeleteFormIface }

constructor TBisCallcHbookPatternDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PATTERN';
end;

{ TBisCallcHbookPatternEditForm }


procedure TBisCallcHbookPatternEditForm.ChangeParam(Param: TBisParam);
var
  AEmpty: Boolean;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'PATTERN') then begin
    AEmpty:=Param.Empty;
    ButtonLoad.Enabled:=AEmpty;
    ButtonSave.Enabled:=not AEmpty;
    ButtonClear.Enabled:=ButtonSave.Enabled;
  end;
end;


procedure TBisCallcHbookPatternEditForm.ButtonLoadClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('PATTERN');
  if Assigned(Param) then begin
    if OpenDialog.Execute then begin
      Param.LoadFromFile(OpenDialog.FileName);
      UpdateButtonState;
    end;
  end;
end;

procedure TBisCallcHbookPatternEditForm.ButtonSaveClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('PATTERN');
  if Assigned(Param) then begin
    SaveDialog.FileName:=EditName.Text;
    if SaveDialog.Execute then
      Param.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TBisCallcHbookPatternEditForm.ButtonClearClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('PATTERN');
  if Assigned(Param) then begin
    Param.Clear;
    UpdateButtonState;
  end;
end;

end.
