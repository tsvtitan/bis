unit BisAudioUtils;

interface

uses Classes,
     BisAudioWave, BisAudioTextPhrases;

procedure GetAudioTextPhrases(const Text: String; Phrases: TBisAudioTextPhrases);
procedure GetAudioPhrasesWave(Phrases: TBisAudioTextPhrases; Wave: TBisAudioWave);
procedure GetAudioTextWave(const Text: String; Wave: TBisAudioWave);

implementation

uses SysUtils, DB, Contnrs,
     BisDataSet, BisProvider;

procedure GetAudioTextPhrases(const Text: String; Phrases: TBisAudioTextPhrases);

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

  procedure GetPhrases(Phrases: TBisAudioTextPhrases);
  var
    P: TBisProvider;
    i: Integer;
    C: TBisDataSetCollectionItem;
    List: TObjectList;
    DS: TBisDataSet;
  begin
    P:=TBisProvider.Create(nil);
    List:=TObjectList.Create(false);
    try
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
  S: String;
begin
  S:=Trim(Text);
  if (S<>'') and Assigned(Phrases) then begin
    Phrases.Parse(S);
    GetPhrases(Phrases);
  end;
end;

procedure GetAudioPhrasesWave(Phrases: TBisAudioTextPhrases; Wave: TBisAudioWave);
var
  i: Integer;
  Item: TBisAudioTextPhrase;
  W: TBisAudioWave;
begin
  if Assigned(Phrases) and Assigned(Wave) and Wave.Valid then begin
    for i:=0 to Phrases.Count-1 do begin
      Item:=Phrases[i];
      W:=TBisAudioWave.Create;
      try
        W.BeginRewrite(Wave.WaveFormat);
        W.EndRewrite;
        if Item.GetWave(W) then
          Wave.Insert(Wave.Length,W);
      finally
        W.Free;
      end;
    end;
  end;
end;

procedure GetAudioTextWave(const Text: String; Wave: TBisAudioWave);
var
  Phrases: TBisAudioTextPhrases;
begin
  Phrases:=TBisAudioTextPhrases.Create;
  try
    GetAudioTextPhrases(Text,Phrases);
    GetAudioPhrasesWave(Phrases,Wave);
  finally
    Phrases.Free;
  end;
end;

end.
