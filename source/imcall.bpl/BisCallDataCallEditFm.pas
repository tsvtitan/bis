unit BisCallDataCallEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup, Buttons,
  BisFm, BisDataFm, BisDataEditFm, BisParam,
  BisAudioWaveFrm,
  BisControls;                                                                                           

type
  TBisCallDataCallViewMode=(vmFull,vmIncoming,vmOutgoing);

  TBisCallDataCallEditForm = class(TBisDataEditForm)
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelDirection: TLabel;
    ComboBoxDirection: TComboBox;
    LabelCreator: TLabel;
    EditCreator: TEdit;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
    LabelCallResult: TLabel;
    ComboBoxCallResult: TComboBox;
    LabelTypeEnd: TLabel;
    ComboBoxTypeEnd: TComboBox;
    GroupBoxCaller: TGroupBox;
    LabelCaller: TLabel;
    EditCaller: TEdit;
    ButtonCaller: TButton;
    LabelCallerPhone: TLabel;
    EditCallerPhone: TEdit;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    GroupBoxAcceptor: TGroupBox;
    LabelAcceptor: TLabel;
    LabelAcceptorPhone: TLabel;
    EditAcceptor: TEdit;
    ButtonAcceptor: TButton;
    EditAcceptorPhone: TEdit;
    LabelDateFound: TLabel;
    DateTimePickerFound: TDateTimePicker;
    DateTimePickerFoundTime: TDateTimePicker;
    GroupBoxCallerAudio: TGroupBox;
    PanelCallerAudio: TPanel;
    GroupBoxAcceptorAudio: TGroupBox;
    PanelAcceptorAudio: TPanel;
    PanelCallerAudioExtra: TPanel;
    CheckBoxCallerAudioSync: TCheckBox;
    EditCallerAudioOffset: TEdit;
    UpDownCallerAudioOffset: TUpDown;
    procedure CheckBoxCallerAudioSyncClick(Sender: TObject);
  private
    FAudioChanged: Boolean;
    FCallerAudioFrame: TBisAudioWaveFrame;
    FAcceptorAudioFrame: TBisAudioWaveFrame;
    procedure AudioFrameClear(Frame: TBisAudioWaveFrame);
    procedure AudioFrameLoad(Frame: TBisAudioWaveFrame);
    procedure AudioFrameBeforePlay(Frame: TBisAudioWaveFrame);
    procedure AudioFrameAfterRecord(Frame: TBisAudioWaveFrame);
    procedure AudioFrameEvent(Frame: TBisAudioWaveFrame);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
    procedure Execute; override;
    procedure ChangeParam(Param: TBisParam); override;
    function ChangesExists: Boolean; override;
  end;

  TBisCallDataCallEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallViewFormIface=class(TBisCallDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallInsertFormIface=class(TBisCallDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallUpdateFormIface=class(TBisCallDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallDeleteFormIface=class(TBisCallDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallDataCallEditForm: TBisCallDataCallEditForm;

function GetDirectionByIndex(Index: Integer): String;
function GetTypeEndByIndex(Index: Integer): String;

implementation

uses DateUtils,
     BisUtils, BisCore, BisFilterGroups, BisParamEditDataSelect,
     BisProvider, BisIfaces, BisDataSet, BisDialogs,
     BisDesignDataAccountsFm,
     BisCallConsts, BisCallDataCallResultsFm;

{$R *.dfm}

function GetDirectionByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='��������';
    1: Result:='���������';
  end;
end;

function GetTypeEndByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='��������� ��������';
    1: Result:='��������� ����������';
    2: Result:='��������� �����������';
    3: Result:='�������� ��������';
    4: Result:='�������� ����������';
    5: Result:='�������� �����������';
    6: Result:='����� �������';
  end;
end;

{ TBisCallDataCallEditFormIface }

constructor TBisCallDataCallEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallDataCallEditForm;
  with Params do begin
    AddKey('CALL_ID').Older('OLD_CALL_ID');
    AddInvisible('LINE_ID');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddInvisible('ORDER_ID');
    AddInvisible('CALLER_AUDIO');
    AddInvisible('CALLER_USER_NAME');
    AddInvisible('CALLER_SURNAME');
    AddInvisible('CALLER_NAME');
    AddInvisible('CALLER_PATRONYMIC');
    AddInvisible('CALLER_DIVERSION');
    AddInvisible('ACCEPTOR_USER_NAME');
    AddInvisible('ACCEPTOR_SURNAME');
    AddInvisible('ACCEPTOR_NAME');
    AddInvisible('ACCEPTOR_PATRONYMIC');
    AddInvisible('ACCEPTOR_AUDIO');

    AddComboBoxIndex('DIRECTION','ComboBoxDirection','LabelDirection',true);
    with AddEditDataSelect('CALLER_ID','EditCaller','LabelCaller','ButtonCaller',
                           TBisDesignDataAccountsFormIface,'CALLER_USER_NAME;CALLER_SURNAME;CALLER_NAME;CALLER_PATRONYMIC',
                           false,false,'ACCOUNT_ID','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;

    AddEdit('CALLER_PHONE','EditCallerPhone','LabelCallerPhone');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
    AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                       TBisDesignDataAccountsFormIface,'CREATOR_USER_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddComboBoxDataSelect('CALL_RESULT_ID','ComboBoxCallResult','LabelCallResult','',
                          TBisCallDataCallResultsFormIface,'CALL_RESULT_NAME',false,false,'','NAME');

    with AddEditDataSelect('ACCEPTOR_ID','EditAcceptor','LabelAcceptor','ButtonAcceptor',
                           TBisDesignDataAccountsFormIface,'ACCEPTOR_USER_NAME;ACCEPTOR_SURNAME;ACCEPTOR_NAME;ACCEPTOR_PATRONYMIC',
                           false,false,'ACCOUNT_ID','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddEdit('ACCEPTOR_PHONE','EditAcceptorPhone','LabelAcceptorPhone');
    AddEditDateTime('DATE_FOUND','DateTimePickerFound','DateTimePickerFoundTime','LabelDateFound');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin');
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddComboBoxIndex('TYPE_END','ComboBoxTypeEnd','LabelTypeEnd');
  end;
end;

{ TBisCallDataCallViewFormIface }

constructor TBisCallDataCallViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ������';
end;

{ TBisCallDataCallInsertFormIface }

constructor TBisCallDataCallInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CALL';
  Caption:='������� �����';
end;

{ TBisCallDataCallUpdateFormIface }

constructor TBisCallDataCallUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CALL';
  Caption:='�������� �����';
end;

{ TBisCallDataCallDeleteFormIface }

constructor TBisCallDataCallDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CALL';
  Caption:='������� �����';
end;

{ TBisCallDataCallEditForm }

constructor TBisCallDataCallEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  FCallerAudioFrame:=TBisAudioWaveFrame.Create(nil);
  with FCallerAudioFrame do begin
    Parent:=PanelCallerAudio;
    Align:=alClient;
    OnClear:=AudioFrameClear;
    OnLoad:=AudioFrameLoad;
    OnBeforePlay:=AudioFrameBeforePlay;
    OnAfterRecord:=AudioFrameAfterRecord;
    OnEvent:=AudioFrameEvent;
  end;

  FAcceptorAudioFrame:=TBisAudioWaveFrame.Create(nil);
  with FAcceptorAudioFrame do begin
    Parent:=PanelAcceptorAudio;
    Align:=alClient;
    OnClear:=AudioFrameClear;
    OnLoad:=AudioFrameLoad;
    OnBeforePlay:=AudioFrameBeforePlay;
    OnAfterRecord:=AudioFrameAfterRecord;
  end;

  ComboBoxDirection.Clear;
  for i:=0 to 1 do
    ComboBoxDirection.Items.Add(GetDirectionByIndex(i));

  ComboBoxTypeEnd.Clear;
  for i:=0 to 6 do
    ComboBoxTypeEnd.Items.Add(GetTypeEndByIndex(i));

end;

destructor TBisCallDataCallEditForm.Destroy;
begin
  FAcceptorAudioFrame.Free;
  FCallerAudioFrame.Free;
  inherited Destroy;
end;

procedure TBisCallDataCallEditForm.Init;
begin
  inherited Init;
  FCallerAudioFrame.Init;
  FAcceptorAudioFrame.Init;
end;

procedure TBisCallDataCallEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;

  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    with Provider.Params do begin
      Find('LINE_ID').SetNewValue(GetUniqueID);
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_USER_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
    end;
  end;

  if not VarIsNull(Core.FirmId) and (Mode<>emFilter) then
    Provider.ParamByName('FIRM_ID').Enabled:=false;

  FCallerAudioFrame.BeforeShow;
  FCallerAudioFrame.Editable:=Mode in [emInsert,emDuplicate,emUpdate];
  FCallerAudioFrame.UpdateStates;
  if Mode in [emDelete,emFilter] then
    FCallerAudioFrame.EnableControls(false);

  CheckBoxCallerAudioSync.Enabled:=(Mode in [emView,emInsert,emDuplicate,emUpdate]) and not FCallerAudioFrame.Empty;
  EditCallerAudioOffset.Enabled:=CheckBoxCallerAudioSync.Enabled and CheckBoxCallerAudioSync.Checked;
  UpDownCallerAudioOffset.Enabled:=CheckBoxCallerAudioSync.Enabled and CheckBoxCallerAudioSync.Checked;

  FAcceptorAudioFrame.BeforeShow;
  FAcceptorAudioFrame.Editable:=Mode in [emInsert,emDuplicate,emUpdate];
  FAcceptorAudioFrame.UpdateStates;
  if Mode in [emDelete,emFilter] then
    FAcceptorAudioFrame.EnableControls(false);

  UpdateButtonState;
end;

procedure TBisCallDataCallEditForm.AudioFrameBeforePlay(Frame: TBisAudioWaveFrame);
begin
  if Frame=FCallerAudioFrame then begin
    Frame.EventTime:=UpDownCallerAudioOffset.Position;
  end;
end;

procedure TBisCallDataCallEditForm.AudioFrameEvent(Frame: TBisAudioWaveFrame);
begin
  if Frame=FCallerAudioFrame then begin
    if CheckBoxCallerAudioSync.Checked then begin
      FAcceptorAudioFrame.Stop;
      FAcceptorAudioFrame.Play;
    end;
  end;
end;

procedure TBisCallDataCallEditForm.AudioFrameAfterRecord(Frame: TBisAudioWaveFrame);
begin
  FAudioChanged:=true;
  UpdateButtonState;
end;

procedure TBisCallDataCallEditForm.AudioFrameClear(Frame: TBisAudioWaveFrame);
begin
  FAudioChanged:=true;
  UpdateButtonState;
end;

procedure TBisCallDataCallEditForm.AudioFrameLoad(Frame: TBisAudioWaveFrame);
begin
  FAudioChanged:=true;
  UpdateButtonState;
end;

procedure TBisCallDataCallEditForm.ChangeParam(Param: TBisParam);
var
  P: TBisProvider;
  Stream: TMemoryStream;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'CALL_ID') and
     not Param.Empty and
     not (Mode in [emDelete,emFilter]) then begin
     
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_CALLS';
      with P.FieldNames do begin
        AddInvisible('CALLER_AUDIO');
        AddInvisible('ACCEPTOR_AUDIO');
      end;
      P.FilterGroups.Add.Filters.Add('CALL_ID',fcEqual,Param.Value).CheckCase:=true;
      P.Open;
      if P.Active and not P.IsEmpty then begin
        Stream:=TMemoryStream.Create;
        try
          TBlobField(P.FieldByName('CALLER_AUDIO')).SaveToStream(Stream);
          Stream.Position:=0;
          FCallerAudioFrame.LoadFromStream(Stream);
          Stream.Clear;
          TBlobField(P.FieldByName('ACCEPTOR_AUDIO')).SaveToStream(Stream);
          Stream.Position:=0;
          FAcceptorAudioFrame.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisCallDataCallEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FAudioChanged;
end;

procedure TBisCallDataCallEditForm.CheckBoxCallerAudioSyncClick(Sender: TObject);
begin
  EditCallerAudioOffset.Enabled:=CheckBoxCallerAudioSync.Checked;
  UpDownCallerAudioOffset.Enabled:=CheckBoxCallerAudioSync.Checked;
end;

procedure TBisCallDataCallEditForm.Execute;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    FCallerAudioFrame.SaveToStream(Stream);
    Stream.Position:=0;
    Provider.ParamByName('CALLER_AUDIO').LoadFromStream(Stream);
    Stream.Clear;
    FAcceptorAudioFrame.SaveToStream(Stream);
    Stream.Position:=0;
    Provider.ParamByName('ACCEPTOR_AUDIO').LoadFromStream(Stream);
    inherited Execute;
  finally
    Stream.Free;
  end;
end;


end.
