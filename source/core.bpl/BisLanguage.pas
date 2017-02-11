unit BisLanguage;

interface

uses Classes, Contnrs, DB,
     BisObject, BisLocalBase, BisDataSet;

type

  TBisLanguage=class(TBisObject)
  private
    FDataSet: TBisDataSet;
    FLocalBase: TBisLocalBase;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load;
    function Translate(S: String): String;
//    function Add(S: String; Translation: String): Boolean;

    property LocalBase: TBisLocalBase read FLocalBase write FLocalBase;
  end;

implementation

uses SysUtils,
     BisConsts;

{ TBisLanguage }

constructor TBisLanguage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSet:=TBisDataSet.Create(nil);
end;

destructor TBisLanguage.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

procedure TBisLanguage.Load;
var
  S: String;
  Stream: TMemoryStream;
  DS: TBisDataSet;
  IndexDef: TIndexDef;
begin
  if Assigned(FLocalBase) and
     FLocalBase.BaseLoaded then begin
    Stream:=TMemoryStream.Create;
    try
      if FLocalBase.ReadParam(SParamDefaultLanguage,S) then begin
        if FLocalBase.ReadParam(SParamLanguages,Stream) then begin
          try
            DS:=TBisDataSet.Create(nil);
            try
              DS.LoadFromStream(Stream);
              if DS.Active and not DS.IsEmpty then begin
                if DS.Locate(SFieldName,S,[]) then begin
                  Stream.Clear;
                  TBlobField(DS.FieldByName(SFieldLanguage)).SaveToStream(Stream);
                  FDataSet.LoadFromStream(Stream);
                  IndexDef:=TIndexDef.Create(FDataSet.IndexDefs,'IDX',SFieldString,[ixCaseInsensitive]);
                  with FDataSet do begin
                    Indexes.Clear;
                    Indexes.Add(IndexDef);
                    Indexes.ReBuildAll;
                  end;
                  FDataSet.IndexName:='IDX';
                end;
              end;
            finally
              DS.Free;
            end;
          except
          end;
        end;
      end;
    finally                                                 
      Stream.Free;
    end;
  end;
end;

function TBisLanguage.Translate(S: String): String;
begin
  Result:=S;
  if FDataSet.Active and not FDataSet.IsEmpty then begin
    if FDataSet.FindKey([S]) then
      Result:=FDataSet.FieldByName(SFieldTranslation).AsString;
  end;
end;

{function TBisLanguage.Translate(S: String): String;
begin
  Result:=S;
  if FDataSet.Active and not FDataSet.IsEmpty then begin
    FDataSet.First;
    if FDataSet.Locate(SFieldString,S,[loCaseInsensitive]) then
      Result:=FDataSet.FieldByName(SFieldTranslation).AsString;
  end;
end;}

{function TBisLanguage.Add(S: String; Translation: String): Boolean;
begin
  Result:=false;
  if FDataSet.Active then begin
    FDataSet.Append;
    FDataSet.FieldByName(SFieldString).AsString:=S;
    FDataSet.FieldByName(SFieldTranslation).AsString:=Translation;
    FDataSet.Post;
  end;
end;}

end.
