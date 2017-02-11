unit BisAudioDataSampleVoicesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  WaveAcmDrivers,
  BisAudioWave,
  BisDataGridFrm;

type
  TBisAudioDataSampleVoicesFrame = class(TBisDataGridFrame)
    ActionLoad: TAction;
    ActionSave: TAction;
    N1: TMenuItem;
    MenuItemLoad: TMenuItem;
    MenuItemSave: TMenuItem;
    procedure ActionLoadExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionSaveUpdate(Sender: TObject);
    procedure ActionLoadUpdate(Sender: TObject);
  private
    FDrivers: TBisAudioACMDrivers;
    FInterrupted: Boolean;
    FProcessing: Boolean;
    procedure WaitCancel(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanClose: Boolean; override;

    function CanSave: Boolean;
    procedure Save;
    function CanLoad: Boolean;
    procedure Load;

  end;

implementation

{$R *.dfm}

uses FileCtrl, StrUtils,
     BisUtils, BisDialogs, BisFileDirs, BisWaitFm, BisProvider,
     BisAudioFormatFm, BisAudioConsts;

{ TBisAudioDataSampleVoicesFrame }
     
constructor TBisAudioDataSampleVoicesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrivers:=TBisAudioACMDrivers.Create;
end;

destructor TBisAudioDataSampleVoicesFrame.Destroy;
begin
  FDrivers.Free;
  inherited Destroy;
end;

procedure TBisAudioDataSampleVoicesFrame.ActionLoadExecute(Sender: TObject);
begin
  Load;
end;

procedure TBisAudioDataSampleVoicesFrame.ActionLoadUpdate(Sender: TObject);
begin
  ActionLoad.Enabled:=CanLoad;
end;

procedure TBisAudioDataSampleVoicesFrame.ActionSaveExecute(Sender: TObject);
begin
  Save;
end;

procedure TBisAudioDataSampleVoicesFrame.ActionSaveUpdate(Sender: TObject);
begin
  ActionSave.Enabled:=CanSave;
end;

procedure TBisAudioDataSampleVoicesFrame.WaitCancel(Sender: TObject);
begin
  FInterrupted:=true;
end;

function TBisAudioDataSampleVoicesFrame.CanClose: Boolean;
begin
  Result:=inherited CanClose and not FProcessing;
end;

function TBisAudioDataSampleVoicesFrame.CanLoad: Boolean;
begin
  Result:=Provider.Active and not FProcessing;
end;

procedure TBisAudioDataSampleVoicesFrame.Load;

  procedure InsertOrUpdate(Text: String; Stream: TStream; TypeSample,Priority: Integer);
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.UseWaitCursor:=false;
      P.UseShowWait:=false;
      P.UseShowError:=true;
      P.ProviderName:='IU_SAMPLE_VOICE';
      with P.Params do begin
        AddInvisible('SAMPLE_TEXT').Value:=Text;
        AddInvisible('VOICE_DATA').LoadFromStream(Stream);
        AddInvisible('TYPE_SAMPLE').Value:=TypeSample;
        AddInvisible('DESCRIPTION').Value:=Null;
        AddInvisible('PRIORITY').Value:=iff(Priority=-1,Null,Priority);
      end;
      P.Execute;
    finally
      P.Free;
    end;
  end;

  function ReplaceCodes(S: String): String;
  var
    i: Integer;
    H: String;
    S1: String;
  begin
    Result:=S;
    for i:=0 to 255 do begin
      H:='$'+IntToHex(i,2);
      S1:=Char(i);
      Result:=ReplaceText(Result,H,S1);
    end;
  end;

var
  Dir: String;
  Form: TBisAudioFormatForm;
  Wait: TBisWaitForm;
  FD: TBisFileDirs;
  Item: TBisFileDir;
  Masks: TStringList;
  i: Integer;
  Valid: Boolean;
  Text: String;
  TS,PR: Integer;
  TypeSample,Priority: Integer;
  Converter: TBisAudioWaveConverter;
  Ret: TModalResult;
  Stream: TMemoryStream;
  S1,S2,S3: String;
begin
  if CanLoad then begin
    if SelectDirectory(ActionLoad.Hint,'',Dir,[sdNewUI],Self) then begin
      Form:=TBisAudioFormatForm.Create(nil);
      Wait:=TBisWaitForm.Create(GetParentForm);
      FD:=TBisFileDirs.Create;
      Masks:=TStringList.Create;
      FProcessing:=true;
      try
        Form.Init;
        Form.Drivers:=FDrivers;
        Form.Format:=FDrivers.FindFormat('',SAudioFormat,1,8000,8);
        Ret:=Form.ShowModal;

        Wait.Init;
        Wait.Position:=poOwnerFormCenter;
        Wait.FormStyle:=fsStayOnTop;
        Wait.LabelStatus.EllipsisPosition:=epEndEllipsis;
        Wait.Show;
        Wait.OnCancel:=WaitCancel;

        FInterrupted:=false;

        Masks.Add('.wav');

        FD.Refresh(Dir,false,Masks);
        for i:=0 to FD.Count-1 do begin
          Item:=FD.Items[i];
          if not Item.IsDir then begin

            Valid:=Assigned(Item.Parent) and Item.Parent.IsDir;
            if Valid then
              Valid:=Assigned(Item.Parent.Parent) and Item.Parent.Parent.IsDir;

            if Valid then begin

              S3:=ExtractFileName(Item.Name);
              Text:=S3;
              Text:=ChangeFileExt(Text,'');
              Text:=ReplaceCodes(Text);

              TypeSample:=-1;
              S1:=ExtractFileName(Item.Parent.Parent.Name);
              if TryStrToInt(S1,TS) then
                TypeSample:=TS;

              Priority:=-1;
              S2:=ExtractFileName(Item.Parent.Name);
              if TryStrToInt(S2,PR) then
                Priority:=PR;

              Valid:=(Trim(Text)<>'') and (TypeSample in [0,1,2,3]);
              if Valid then begin
                Wait.LabelStatus.Caption:=S1+PathDelim+S2+PathDelim+S3;
                Wait.Update;

                Application.ProcessMessages;
                if FInterrupted then
                  break;

                if (Ret=mrOk) and Assigned(Form.Format) then begin
                  Converter:=TBisAudioWaveConverter.Create;
                  try
                    Converter.LoadFromFile(Item.Name);
                    if Converter.ConvertTo(Form.Format.WaveFormat) then begin
                      Converter.Stream.Position:=0;
                      InsertOrUpdate(Text,Converter.Stream,TypeSample,Priority);
                    end else begin
                      Stream:=TMemoryStream.Create;
                      try
                        Stream.LoadFromFile(Item.Name);
                        Stream.Position:=0;
                        InsertOrUpdate(Text,Stream,TypeSample,Priority);
                      finally
                        Stream.Free;
                      end;
                    end;
                  finally
                    Converter.Free;
                  end;
                end else begin
                  Stream:=TMemoryStream.Create;
                  try
                    Stream.LoadFromFile(Item.Name);
                    Stream.Position:=0;
                    InsertOrUpdate(Text,Stream,TypeSample,Priority); 
                  finally
                    Stream.Free;
                  end;
                end;  
              end;

            end;
          end;
        end;
        RefreshRecords;
      finally
        FProcessing:=false;
        Masks.Free;
        FD.Free;
        Wait.Free;
        Form.Free;
      end;
    end;
  end;
end;

function TBisAudioDataSampleVoicesFrame.CanSave: Boolean;
begin
  Result:=Provider.Active and not Provider.Empty and not FProcessing;
end;

procedure TBisAudioDataSampleVoicesFrame.Save;

  function ReplaceCodes(S: String): String;
  var
    i: Integer;
    Ch: Char;
    H: String;
  begin
    Result:=S;
    for i:=1 to Length(S) do begin
      Ch:=S[i];
      if Ch in ['"','*','.','/',':','?','\','|','<','>'] then begin
        H:='$'+IntToHex(Byte(Ch),2);
        Result:=ReplaceText(Result,Ch,H);
      end;
    end;
  end;

var
  Dir: String;
  Form: TBisAudioFormatForm;
  Wait: TBisWaitForm;
  Ret: TModalResult;
  Text: String;
  FileDir: String;
  FileName: String;
  S1,S2: String;
  Stream: TMemoryStream;
  Converter: TBisAudioWaveConverter;
  P: TBisProvider;
begin
  if CanSave then begin
    if SelectDirectory(ActionSave.Hint,'',Dir,[sdNewUI,sdNewFolder],Self) then begin
      Form:=TBisAudioFormatForm.Create(nil);
      Wait:=TBisWaitForm.Create(GetParentForm);
      P:=TBisProvider.Create(nil);
      FProcessing:=true;
      try
        Form.Init;
        Form.Drivers:=FDrivers;
        Form.Format:=FDrivers.FindFormat('',SAudioFormat,1,8000,8);
        Ret:=Form.ShowModal;

        Wait.Init;
        Wait.Position:=poOwnerFormCenter;
        Wait.FormStyle:=fsStayOnTop;
        Wait.LabelStatus.EllipsisPosition:=epEndEllipsis;
        Wait.LabelStatus.Caption:='Загрузка';
        Wait.Show;
        Wait.OnCancel:=WaitCancel;

        P.ProviderName:=Provider.ProviderName;
        P.FilterGroups.CopyFrom(Provider.FilterGroups);

        FInterrupted:=false;

        P.Open;
        if P.Active then begin
          P.First;
          while not P.Eof do begin
            Text:=P.FieldByName('SAMPLE_TEXT').AsString;
            Text:=ReplaceCodes(Text);
            Text:=Text+'.wav';

            S1:=P.FieldByName('TYPE_SAMPLE').AsString;
            S2:=P.FieldByName('PRIORITY').AsString;
            if Trim(S2)='' then S2:=' ';

            FileDir:=Dir+PathDelim+S1+PathDelim+S2;
            if CreateDirEx(FileDir) then begin

              Wait.LabelStatus.Caption:=S1+PathDelim+S2+PathDelim+Text;
              Wait.Update;

              FileName:=FileDir+PathDelim+Text;

              Stream:=TMemoryStream.Create;
              try
                TBlobField(P.FieldByName('VOICE_DATA')).SaveToStream(Stream);
                Stream.Position:=0;
                if (Ret=mrOk) and Assigned(Form.Format) then begin
                  Converter:=TBisAudioWaveConverter.Create;
                  try
                    Converter.LoadFromStream(Stream);
                    if Converter.ConvertTo(Form.Format.WaveFormat) then begin
                      Converter.Stream.Position:=0;
                      Converter.SaveToFile(FileName);
                    end else begin
                      Stream.Position:=0;
                      Stream.SaveToFile(FileName);
                    end;
                  finally
                    Converter.Free;
                  end;
                end else
                  Stream.SaveToFile(FileName);
              finally
                Stream.Free;
              end;

            end;
            P.Next;
          end;
        end;  
      finally
        FProcessing:=false;
        P.Free;
        Wait.Free;
        Form.Free;
      end;
    end;
  end;
end;

end.
