unit BisTaxiDataSampleVoiceEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, DB,
  BisParam, BisDataEditFm,
  BisAudioWaveFrm,
  BisControls;                                                                                       

type
  TBisTaxiDataSampleVoiceEditForm = class(TBisDataEditForm)
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

  TBisTaxiDataSampleVoiceEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSampleVoiceFilterFormIface=class(TBisTaxiDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSampleVoiceInsertFormIface=class(TBisTaxiDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSampleVoiceUpdateFormIface=class(TBisTaxiDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSampleVoiceDeleteFormIface=class(TBisTaxiDataSampleVoiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataSampleVoiceEditForm: TBisTaxiDataSampleVoiceEditForm;

function GetTypeSampleByIndex(Index: Integer): String;
  
implementation

uses BisProvider, BisFilterGroups;

{$R *.dfm}

function GetTypeSampleByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='�������';
    1: Result:='�����';
    2: Result:='�����';
    3: Result:='�����';
  end;
end;

{ TBisTaxiDataSampleVoiceEditFormIface }

constructor TBisTaxiDataSampleVoiceEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataSampleVoiceEditForm;
  with Params do begin
    AddKey('SAMPLE_VOICE_ID').Older('OLD_SAMPLE_VOICE_ID');
    AddInvisible('VOICE_DATA');
    AddComboBox('TYPE_SAMPLE','ComboBoxType','LabelType',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddEdit('SAMPLE_TEXT','EditText','LabelText',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
  end;
end;

{ TBisTaxiDataSampleVoiceFilterFormIface }

constructor TBisTaxiDataSampleVoiceFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������� ������';
end;

{ TBisTaxiDataSampleVoiceInsertFormIface }

constructor TBisTaxiDataSampleVoiceInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SAMPLE_VOICE';
  Caption:='������� ������� ������';
end;

{ TBisTaxiDataSampleVoiceUpdateFormIface }

constructor TBisTaxiDataSampleVoiceUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SAMPLE_VOICE';
  Caption:='�������� ������� ������';
end;

{ TBisTaxiDataSampleVoiceDeleteFormIface }

constructor TBisTaxiDataSampleVoiceDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SAMPLE_VOICE';
  Caption:='������� ������� ������';
end;

{ TBisTaxiDataSampleVoiceEditForm }

constructor TBisTaxiDataSampleVoiceEditForm.Create(AOwner: TComponent);
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

destructor TBisTaxiDataSampleVoiceEditForm.Destroy;
begin
  FVoiceDataFrame.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataSampleVoiceEditForm.Init;
begin
  inherited Init;
  FVoiceDataFrame.Init;
end;

procedure TBisTaxiDataSampleVoiceEditForm.BeforeShow;
begin
  inherited BeforeShow;

  FVoiceDataFrame.BeforeShow;
  FVoiceDataFrame.Editable:=Mode in [emInsert,emDuplicate,emUpdate];
  FVoiceDataFrame.UpdateStates;
  if Mode in [emDelete,emFilter] then
    FVoiceDataFrame.EnableControls(false);

  UpdateButtonState;  
end;

procedure TBisTaxiDataSampleVoiceEditForm.VoiceDataFrameClear(Frame: TBisAudioWaveFrame);
begin
  FChanged:=true;
  UpdateButtonState;
end;

procedure TBisTaxiDataSampleVoiceEditForm.ChangeParam(Param: TBisParam);
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

function TBisTaxiDataSampleVoiceEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FChanged;
end;

procedure TBisTaxiDataSampleVoiceEditForm.Execute;
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
