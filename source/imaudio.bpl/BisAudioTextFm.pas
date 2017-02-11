unit BisAudioTextFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ActnPopup, ActnList, ImgList, ToolWin, ExtCtrls,
  StdCtrls, DB, CheckLst, Contnrs,
  WaveUtils,
  VirtualTrees,
  BisFm, BisAudioWave, BisSynEdit, BisAudioTextPhrases, BisDbTree,
  BisAudioWaveFrm, BisControls;

type
  TCheckListBox=class(CheckLst.TCheckListBox)
  end;

  TBisAudioTextForm = class(TBisForm)
    StatusBar: TStatusBar;
    ImageList: TImageList;
    ActionList: TActionList;
    ActionLoad: TAction;
    ActionImport: TAction;
    ActionConnection: TAction;
    ActionImportCurrent: TAction;
    ActionInfo: TAction;
    Popup: TPopupActionBar;
    N1: TMenuItem;
    N5: TMenuItem;
    N2: TMenuItem;
    N6: TMenuItem;
    N3: TMenuItem;
    N8: TMenuItem;
    N7: TMenuItem;
    N4: TMenuItem;
    GroupBoxAudio: TGroupBox;
    PanelAudio: TPanel;
    GroupBoxText: TGroupBox;
    PanelText: TPanel;
    MemoText: TMemo;
    GroupBoxPhrases: TGroupBox;
    PanelSamples: TPanel;
    Timer: TTimer;
    PanelOptions: TPanel;
    LabelGap: TLabel;
    EditGap: TEdit;
    UpDownGap: TUpDown;
    TrackBarSpeed: TTrackBar;
    TreeView: TTreeView;
    procedure TimerTimer(Sender: TObject);
    procedure MemoTextChange(Sender: TObject);
    procedure EditGapChange(Sender: TObject);
    procedure MemoTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TrackBarSpeedChange(Sender: TObject);
  private
    FOldText: String;
    FAudioFrame: TBisAudioWaveFrame;
    FPCMFormat: TPCMFormat;
    FXmlHighlighter: TBisSynXmlSyn;
    FMemoText: TBisSynEdit;
    FTreeView: TVirtualStringTree;

    procedure TreeViewChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeViewFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeViewGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                              TextType: TVSTTextType; var CellText: WideString);
    procedure TreeViewGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                                    var Ghosted: Boolean; var ImageIndex: Integer);
    procedure AudioFrameBeforePlay(Frame: TBisAudioWaveFrame);
    procedure AudioFrameAfterPlay(Frame: TBisAudioWaveFrame);
    procedure RefreshTreeView;
    procedure BuildAudioStream;
    procedure SetSpeed;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
  end;

  TBisAudioTextFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisAudioTextForm: TBisAudioTextForm;

implementation

{$R *.dfm}

uses MMSystem,
     WaveStorage,
     BisProvider, BisUtils, BisParams, BisDataSet;

{ TBisAudioTextFormIface }

constructor TBisAudioTextFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisAudioTextForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stDefault;
end;

type
  TBisAudioNode=class(TObject)
  private
    FText: String;
    FTransform: TBisAudioWave;
    FOriginal: TBisAudioWave;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TBisAudioNodeData=record
    AudioNode: TBisAudioNode;
  end;
  PBisAudioNodeData=^TBisAudioNodeData;

{ TBisAudioNode }

constructor TBisAudioNode.Create;
begin
  inherited Create;
  FTransform:=TBisAudioWave.Create;
  FOriginal:=TBisAudioWave.Create;
end;

destructor TBisAudioNode.Destroy;
begin
  FOriginal.Free;
  FTransform.Free;
  inherited Destroy;
end;

{ TBisAudioTextForm }

constructor TBisAudioTextForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  FAudioFrame:=TBisAudioWaveFrame.Create(nil);
  with FAudioFrame do begin
    Parent:=PanelAudio;
    Align:=alClient;
    OnBeforePlay:=AudioFrameBeforePlay;
    OnAfterPlay:=AudioFrameAfterPlay;
  end;

  FPCMFormat:=FAudioFrame.PCMFormat;

  FXmlHighlighter:=TBisSynXmlSyn.Create(nil);

  FMemoText:=TBisSynEdit.Create(nil);
  FMemoText.Parent:=MemoText.Parent;
  FMemoText.Align:=MemoText.Align;
  FMemoText.Highlighter:=FXmlHighlighter;
  FMemoText.AlignWithMargins:=true;
  FMemoText.Margins.Assign(MemoText.Margins);
  FMemoText.RightEdge:=0;
  FMemoText.Gutter.Width:=0;
  FMemoText.WordWrap:=MemoText.WordWrap;
  FMemoText.OnChange:=MemoText.OnChange;
  FMemoText.OnKeyDown:=MemoText.OnKeyDown;

  MemoText.Free;
  MemoText:=nil;

  FTreeView:=TVirtualStringTree.Create(nil);
  FTreeView.Parent:=TreeView.Parent;
  FTreeView.Align:=TreeView.Align;
  FTreeView.Images:=TreeView.Images;
  FTreeView.TreeOptions.MiscOptions:=FTreeView.TreeOptions.MiscOptions+[toCheckSupport];
  FTreeView.NodeDataSize:=SizeOf(TBisAudioNodeData);
  FTreeView.OnChecked:=TreeViewChecked;
  FTreeView.OnFreeNode:=TreeViewFreeNode;
  FTreeView.OnGetImageIndex:=TreeViewGetImageIndex;
  FTreeView.OnGetText:=TreeViewGetText;

  TreeView.Free;
  TreeView:=nil;

end;

destructor TBisAudioTextForm.Destroy;
begin
  FTreeView.Free;
  FMemoText.Free;
  FXmlHighlighter.Free;
  FAudioFrame.Free;
  inherited Destroy;
end;

procedure TBisAudioTextForm.Init;
begin
  inherited Init;
  FAudioFrame.Init;
end;

procedure TBisAudioTextForm.BeforeShow;
begin
  inherited BeforeShow;
  FAudioFrame.BeforeShow;
  FAudioFrame.Editable:=true;
end;

procedure TBisAudioTextForm.TreeViewChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  BuildAudioStream;
end;

procedure TBisAudioTextForm.TreeViewFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PBisAudioNodeData;
begin
  if Assigned(Node) then begin
    Data:=Sender.GetNodeData(Node);
    if Assigned(Data) and Assigned(Data.AudioNode) then begin
      FreeAndNilEx(Data.AudioNode);
    end;
  end;
end;

procedure TBisAudioTextForm.TreeViewGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                                            TextType: TVSTTextType; var CellText: WideString);
var
  Data: PBisAudioNodeData;
begin
  if Assigned(Node) then begin
    Data:=Sender.GetNodeData(Node);
    if Assigned(Data) and Assigned(Data.AudioNode) then begin
      CellText:=Data.AudioNode.FText;
    end;
  end;
end;

procedure TBisAudioTextForm.TreeViewGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
                                                  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Assigned(Node) and (Kind in [ikNormal,ikSelected]) then begin
    if Node.Parent=Sender.RootNode then
      ImageIndex:=3
    else
      ImageIndex:=4;
  end;
end;

procedure TBisAudioTextForm.MemoTextChange(Sender: TObject);
begin
  FMemoText.Highlighter:=nil;
  try
    Timer.Enabled:=false;
    Timer.Enabled:=(Trim(FMemoText.Lines.Text)<>'') and (FOldText<>FMemoText.Lines.Text);
    FOldText:=FMemoText.Lines.Text;
  finally
    FMemoText.Highlighter:=FXmlHighlighter;
  end;
end;

procedure TBisAudioTextForm.MemoTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Timer.Enabled:=false;
end;

procedure TBisAudioTextForm.RefreshTreeView;

  procedure SetPhraseParams(DataSet: TBisDataSet; Phrase: TBisAudioTextPhrase);
  var
    Sample: TBisAudioTextSample;
    Stream: TMemoryStream;
  begin
    with DataSet do begin
      if Active and not Empty then begin
        Stream:=TMemoryStream.Create;
        try
          First;
          while not Eof do begin
            Sample:=Phrase.Samples.Add(FieldByName('SAMPLE_TEXT').AsString,
                                       TBisAudioTextSampleType(FieldByName('TYPE_SAMPLE').AsInteger));
            if Assigned(Sample) then begin
              Stream.Clear;
              TBlobField(FieldByName('VOICE_DATA')).SaveToStream(Stream);
              Stream.Position:=0;
              Sample.Wave.LoadFromStream(Stream);
            end;
            DataSet.Next;
          end;
        finally
          Stream.Free;
        end;
      end;
    end;
  end;

  procedure GetSampleVoices(Phrases: TBisAudioTextPhrases);
  var
    P: TBisProvider;
    i: Integer;
    C: TBisDataSetCollectionItem;
    List: TObjectList;
    DS: TBisDataSet;
  begin
    P:=TBisProvider.Create(Self);
    List:=TObjectList.Create(false);
    try
      P.UseShowWait:=true;
      P.UseWaitCursor:=true;
      P.WaitInterval:=Timer.Interval;
      P.WaitTimeout:=0;
      P.WaitStatus:='�������� ��������';
      P.ProviderName:='GET_SAMPLE_VOICES';
      for i:=0 to Phrases.Count-1 do begin
        if i=0 then
          P.Params.AddInvisible('IN_TEXT').Value:=Phrases[i].Text
        else begin
          C:=P.CollectionAfter.AddExecute;
          C.Params.AddInvisible('IN_TEXT').Value:=Phrases[i].Text;
          List.Add(C);
        end;
      end;
      P.OpenWithExecute;
      for i:=0 to Phrases.Count-1 do begin
        if i=0 then
          SetPhraseParams(P,Phrases[i])
        else begin
          if (i-1)<=(List.Count-1) then begin
            DS:=TBisDataSet.Create(nil);
            try
              TBisDataSetCollectionItem(List[i-1]).GetDataSet(DS);
              SetPhraseParams(DS,Phrases[i]);
            finally
              DS.Free;
            end;
          end;
        end;
      end;
    finally
      List.Free;
      P.Free;
    end;
  end;

var
  Phrases: TBisAudioTextPhrases;
  i,j: Integer;
  Phrase: TBisAudioTextPhrase;
  Sample: TBisAudioTextSample;
  Node,Child: PVirtualNode;
  NodeData: PBisAudioNodeData;
  Obj: TBisAudioNode;
begin
  Phrases:=TBisAudioTextPhrases.Create;
  FTreeView.OnChecked:=nil;
  try
    Phrases.Parse(Trim(FMemoText.Text));
    GetSampleVoices(Phrases);
    FTreeView.Clear;
    for i:=0 to Phrases.Count-1 do begin
      Phrase:=Phrases[i];
      Obj:=TBisAudioNode.Create;
      Obj.FText:=Phrase.Text;
      Obj.FOriginal.BeginRewritePCM(FPCMFormat);
      Obj.FOriginal.EndRewrite;
      Phrase.GetWave(Obj.FOriginal);
      Node:=FTreeView.AddChild(nil);
      NodeData:=FTreeView.GetNodeData(Node);
      NodeData.AudioNode:=Obj;
      FTreeView.CheckType[Node]:=ctCheckBox;
      FTreeView.CheckState[Node]:=csCheckedNormal;
      for j:=0 to Phrase.Samples.Count-1 do begin
        Sample:=Phrase.Samples[j];
        Obj:=TBisAudioNode.Create;
        Obj.FText:=Sample.Text;
        Child:=FTreeView.AddChild(Node);
        NodeData:=FTreeView.GetNodeData(Child);
        NodeData.AudioNode:=Obj;
        FTreeView.CheckState[Child]:=csUncheckedNormal;
      end;
    end;
  finally
    FTreeView.OnChecked:=TreeViewChecked;
    Phrases.Free;
  end;
end;

procedure TBisAudioTextForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:=false;
  RefreshTreeView;
  BuildAudioStream;
end;

procedure TBisAudioTextForm.TrackBarSpeedChange(Sender: TObject);
begin
  SetSpeed;
end;

procedure TBisAudioTextForm.EditGapChange(Sender: TObject);
begin
  BuildAudioStream;
end;

procedure TBisAudioTextForm.AudioFrameAfterPlay(Frame: TBisAudioWaveFrame);
begin
  EnableControl(PanelOptions,true);
end;

procedure TBisAudioTextForm.AudioFrameBeforePlay(Frame: TBisAudioWaveFrame);
begin
  EnableControl(PanelOptions,false);
end;

procedure TBisAudioTextForm.SetSpeed;
begin
  FAudioFrame.SpeedFactor:=TrackBarSpeed.Position*0.01+0.5;
end;

procedure TBisAudioTextForm.BuildAudioStream;
var
  AFormat: TPCMFormat;

  procedure SetLowFormat(ParentWave: TBisAudioWave);
  var
    Wave: TBisAudioWave;
    i: TPCMFormat;
  begin
    if not ParentWave.Empty then begin
      Wave:=TBisAudioWave.Create;
      try
        for i:=AFormat downto Mono8Bit8000Hz do begin
          if i in FAudioFrame.AvailableFormats then begin
            Wave.Assign(ParentWave);
            if Wave.ConvertToPCM(i) then begin
              if i<AFormat then
                AFormat:=i;
              exit;
            end;
          end;
        end;
      finally
        Wave.Free;
      end;
    end;
  end;

  function GetFirstChecked: TBisAudioNode;
  var
    Node: PVirtualNode;
    Data: PBisAudioNodeData;
  begin
    Result:=nil;
    Node:=FTreeView.GetFirstChecked;
    if Assigned(Node) then begin
      Data:=FTreeView.GetNodeData(Node);
      if Assigned(Data) then
        Result:=Data.AudioNode;
    end;
  end;

var
  AudioNode: TBisAudioNode;
  Node: PVirtualNode;
  Data: PBisAudioNodeData;
  Wave: TBisAudioWave;
  List: TList;
  i: Integer;
  Converted: Boolean;
  Position: Cardinal;
begin
  FAudioFrame.Clear;
  AFormat:=FPCMFormat;
  AudioNode:=GetFirstChecked;
  if Assigned(AudioNode) then
    SetLowFormat(AudioNode.FOriginal);
  if AFormat>nonePCM then begin
    Wave:=TBisAudioWave.Create;
    List:=TList.Create;
    try
      Node:=FTreeView.GetFirstChecked;
      while Assigned(Node) do begin
        Data:=FTreeView.GetNodeData(Node);
        if Assigned(Data) and Assigned(Data.AudioNode) then begin
          if Node.CheckState=csCheckedNormal then begin
            Data.AudioNode.FTransform.Assign(Data.AudioNode.FOriginal);
            Converted:=Data.AudioNode.FTransform.ConvertToPCM(AFormat);
            Node.CheckState:=iff(Converted,csCheckedNormal,csUncheckedNormal);
            if Converted then
              List.Add(Data.AudioNode);
          end;
        end;
        Node:=FTreeView.GetNextChecked(Node);
      end;
      if List.Count>0 then begin
        Wave.BeginRewritePCM(AFormat);
        Wave.EndRewrite;
        Position:=0;
        for i:=0 to List.Count-1 do begin
          AudioNode:=TBisAudioNode(List.Items[i]);
          if UpDownGap.Position>=0 then
            if (i>0) and (i<=(List.Count-1)) then begin
              Wave.InsertSilence(Position,UpDownGap.Position);
              Inc(Position,UpDownGap.Position);
            end;
          Wave.Insert(Position,AudioNode.FTransform);
          Inc(Position,AudioNode.FTransform.Length);
          if (UpDownGap.Position<0) and
             ((Position+Cardinal(UpDownGap.Position))>0) then
            if (i<=(List.Count-1)) then begin
              Inc(Position,UpDownGap.Position);
              Wave.Delete(Position,Abs(UpDownGap.Position));
            end;
        end;
        Wave.Stream.Position:=0;
        FAudioFrame.LoadFromStream(Wave.Stream);
        SetSpeed;
      end;
    finally
      List.Free;
      Wave.Free;
    end;
  end;
end;

end.
