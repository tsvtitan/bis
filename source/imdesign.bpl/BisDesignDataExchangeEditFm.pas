unit BisDesignDataExchangeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisDesignDataExchangeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    GroupBoxSource: TGroupBox;
    LabelSource: TLabel;
    ComboBoxSource: TComboBox;
    ButtonScript: TButton;
    ButtonSourceBefore: TButton;
    ButtonSourceAfter: TButton;
    GroupBoxDestination: TGroupBox;
    LabelDestination: TLabel;
    ComboBoxDestination: TComboBox;
    ButtonDestinationBefore: TButton;
    ButtonDestinationAfter: TButton;
    CheckBoxEnabled: TCheckBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    procedure ButtonScriptClick(Sender: TObject);
  private
    FSDestinationNotEqualSource: String;
    procedure RefreshConnections(Strings: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    function CheckParam(Param: TBisParam): Boolean; override;
  published
    property SDestinationNotEqualSource: String read FSDestinationNotEqualSource write FSDestinationNotEqualSource;
  end;

  TBisDesignDataExchangeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataExchangeInsertFormIface=class(TBisDesignDataExchangeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataExchangeUpdateFormIface=class(TBisDesignDataExchangeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataExchangeDeleteFormIface=class(TBisDesignDataExchangeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataExchangeEditForm: TBisDesignDataExchangeEditForm;

implementation

{$R *.dfm}

uses BisMemoFm, BisCore, BisConnectionModules, BisConnections, BisDialogs;

{ TBisDesignDataExchangeEditFormIface }

constructor TBisDesignDataExchangeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataExchangeEditForm;
  with Params do begin
    AddKey('EXCHANGE_ID').Older('OLD_EXCHANGE_ID');
    AddInvisible('SCRIPT');
    AddInvisible('SOURCE_BEFORE');
    AddInvisible('SOURCE_AFTER');
    AddInvisible('DESTINATION_BEFORE');
    AddInvisible('DESTINATION_AFTER');
    AddEdit('NAME','EditName','LabelName',true);
    AddCheckBox('ENABLED','CheckBoxEnabled');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddComboBoxTextIndex('SOURCE','ComboBoxSource','LabelSource',true).FilterCaption:='��������:';
    AddComboBoxTextIndex('DESTINATION','ComboBoxDestination','LabelDestination',true).FilterCaption:='����������:';
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisDesignDataExchangeInsertFormIface }

constructor TBisDesignDataExchangeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_EXCHANGE';
end;

{ TBisDesignDataExchangeUpdateFormIface }

constructor TBisDesignDataExchangeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_EXCHANGE';
end;

{ TBisDesignDataExchangeDeleteFormIface }

constructor TBisDesignDataExchangeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_EXCHANGE';
end;

{ TBisDesignDataExchangeEditForm }

constructor TBisDesignDataExchangeEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RefreshConnections(ComboBoxSource.Items);
  RefreshConnections(ComboBoxDestination.Items);
  FSDestinationNotEqualSource:='��������� � �������� ������ ���� ��������.';
end;

procedure TBisDesignDataExchangeEditForm.RefreshConnections(Strings: TStrings);
var
  i,j: Integer;
  Module: TBisConnectionModule;
  Connection: TBisConnection;
begin
  if Assigned(Strings) and Assigned(Core) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to Core.ConnectionModules.Count-1 do begin
        Module:=Core.ConnectionModules.Items[i];
        if Module.Enabled then begin
          for j:=0 to Module.Connections.Count-1 do begin
            Connection:=Module.Connections.Items[j];
            Strings.AddObject(Connection.Caption,Connection);
          end;
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

procedure TBisDesignDataExchangeEditForm.BeforeShow;
begin
  inherited BeforeShow;

  if Mode in [emDelete,emFilter] then begin
    ButtonSourceBefore.Enabled:=false;
    ButtonSourceAfter.Enabled:=false;
    ButtonScript.Enabled:=false;
    ButtonDestinationBefore.Enabled:=false;
    ButtonDestinationAfter.Enabled:=false;
  end;

end;

procedure TBisDesignDataExchangeEditForm.ButtonScriptClick(Sender: TObject);
var
  Param: TBisParam;
  Form: TBisMemoForm;
begin
  Param:=nil;
  if Assigned(Sender) and (Sender is TButton) then begin
    if Sender=ButtonSourceBefore then Param:=Provider.Params.ParamByName('SOURCE_BEFORE');
    if Sender=ButtonSourceAfter then Param:=Provider.Params.ParamByName('SOURCE_AFTER');
    if Sender=ButtonScript then Param:=Provider.Params.ParamByName('SCRIPT');
    if Sender=ButtonDestinationBefore then Param:=Provider.Params.ParamByName('DESTINATION_BEFORE');
    if Sender=ButtonDestinationAfter then Param:=Provider.Params.ParamByName('DESTINATION_AFTER');
    if Assigned(Param) then begin
      Form:=TBisMemoForm.Create(nil);
      try
        Form.Init;
        Form.ButtonSort.Visible:=false;
        Form.Memo.Lines.Text:=Param.AsString;
        Form.MemoType:=mtSQL;
        Form.Caption:=TButton(Sender).Caption;
        if Form.ShowModal=mrOk then begin
          Param.Value:=Form.Memo.Lines.Text;
        end;
      finally
        Form.Free;
      end;
    end;
  end;
end;

function TBisDesignDataExchangeEditForm.CheckParam(Param: TBisParam): Boolean;
begin
  Result:=inherited CheckParam(Param);
  if Result and AnsiSameText(Param.ParamName,'DESTINATION') then begin
    if VarSameValue(Provider.Params.ParamByName('SOURCE').Value,Param.Value) then begin
      ShowError(FSDestinationNotEqualSource);
      ShowParam(Param);
      Result:=false;
    end;
  end;
end;


end.