unit BisAudioDataSampleVoiceEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, DB,
  BisParam, BisDataEditFm,
  BisAudioWaveFrm,
  BisControls;                                                                                       

type
  TBisAudioDataSampleVoiceEditForm = class(TBisDataEditForm)
    LabelText: TLabel;
    EditText: TEdit;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    GroupBoxVoiceData: TGroupBox;
    PanelVoiceData: TPanel;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    FVoiceDataFrame: TBisAudioWaveFrame;
    FChanged: Boolean;
    procedure VoiceDataFrameClear(Frame: TBisAudioWaveFrame);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
    function ChangesExists: Boolean; override;
    procedure Execute; override;
  end;

  TBisAudioDataSampleVoiceEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisAudioDataSampleVoiceFilterFormIface=class(TBisAudioDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisAudioDataSampleVoiceInsertFormIface=class(TBisAudioDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisAudioDataSampleVoiceUpdateFormIface=class(TBisAudioDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisAudioDataSampleVoiceDeleteFormIface=class(TBisAudioDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisAudioDataSampleVoiceEditForm: TBisAudioDataSampleVoiceEditForm;

function GetTypeSampleByIndex(Index: Integer): String;
  
implementation

uses BisProvider, BisFilterGroups;

{$R *.dfm}

function GetTypeSampleByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='символы';
    1: Result:='слоги';
    2: Result:='слова';
    3: Result:='фразы';
  end;
end;

{ TBisAudioDataSampleVoiceEditFormIface }

constructor TBisAudioDataSampleVoiceEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisAudioDataSampleVoiceEditForm;
  with Params do begin
    AddKey('SAMPLE_VOICE_ID').Older('OLD_SAMPLE_VOICE_ID');
    AddInvisible('VOICE_DATA');
    AddComboBox('TYPE_SAMPLE','ComboBoxType','LabelType',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddEdit('SAMPLE_TEXT','EditText','LabelText',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
  end;
end;

{ TBisAudioDataSampleVoiceFilterFormIface }

constructor TBisAudioDataSampleVoiceFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр образцов голоса';
end;

{ TBisAudioDataSampleVoiceInsertFormIface }

constructor TBisAudioDataSampleVoiceInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SAMPLE_VOICE';
  Caption:='Создать образец голоса';
end;

{ TBisAudioDataSampleVoiceUpdateFormIface }

constructor TBisAudioDataSampleVoiceUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SAMPLE_VOICE';
  Caption:='Изменить образец голоса';
end;

{ TBisAudioDataSampleVoiceDeleteFormIface }

constructor TBisAudioDataSampleVoiceDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SAMPLE_VOICE';
  Caption:='Удалить образец голоса';
end;

{ TBisAudioDataSampleVoiceEditForm }

constructor TBisAudioDataSampleVoiceEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  for i:=0 to 3 do
    ComboBoxType.Items.Add(GetTypeSampleByIndex(i));

  FVoiceDataFrame:=TBisAudioWaveFrame.Create(nil);
  with FVoiceDataFrame do begin
    Parent:=PanelVoiceData;
    Align:=alClient;
    OnClear:=VoiceDataFrameClear;
    OnLoad:=VoiceDataFrameClear;
    OnAfterRecord:=VoiceDataFrameClear;
  end;

end;

destructor TBisAudioDataSampleVoiceEditForm.Destroy;
begin
  FVoiceDataFrame.Free;
  inherited Destroy;
end;

procedure TBisAudioDataSampleVoiceEditForm.Init;
begin
  inherited Init;
  FVoiceDataFrame.Init;
end;

procedure TBisAudioDataSampleVoiceEditForm.BeforeShow;
begin
  inherited BeforeShow;

  FVoiceDataFrame.BeforeShow;
  FVoiceDataFrame.Editable:=Mode in [emInsert,emDuplicate,emUpdate];
  FVoiceDataFrame.UpdateStates;
  if Mode in [emDelete,emFilter] then
    FVoiceDataFrame.EnableControls(false);

  UpdateButtonState;  
end;

procedure TBisAudioDataSampleVoiceEditForm.VoiceDataFrameClear(Frame: TBisAudioWaveFrame);
begin
  FChanged:=true;
  UpdateButtonState;
end;

procedure TBisAudioDataSampleVoiceEditForm.ChangeParam(Param: TBisParam);
var
  P: TBisProvider;
  Stream: TMemoryStream;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'SAMPLE_VOICE_ID') and not Param.Empty and not (Mode in [emDelete,emFilter]) then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_SAMPLE_VOICES';
      with P.FieldNames do begin
        AddInvisible('VOICE_DATA');
      end;
      P.FilterGroups.Add.Filters.Add('SAMPLE_VOICE_ID',fcEqual,Param.Value).CheckCase:=true;
      P.Open;
      if P.Active and not P.IsEmpty then begin
        Stream:=TMemoryStream.Create;
        try
          TBlobField(P.FieldByName('VOICE_DATA')).SaveToStream(Stream);
          Stream.Position:=0;
          FVoiceDataFrame.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisAudioDataSampleVoiceEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FChanged;
end;

procedure TBisAudioDataSampleVoiceEditForm.Execute;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    FVoiceDataFrame.SaveToStream(Stream);
    Stream.Position:=0;
    Provider.ParamByName('VOICE_DATA').LoadFromStream(Stream);
    inherited Execute;
  finally
    Stream.Free;
  end;
end;


end.
