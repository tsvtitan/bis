unit BisUtils;

interface

uses Classes;

function Iff(IsTrue: Boolean; ValueTrue, ValueFalse: Variant): Variant;
procedure FreeAndNilEx(var Obj);
function IsClassParent(AClassIn: TClass; AClassParent: TClass): Boolean;
procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
function ParseBetween(const S, LDelim, RDelim: String; var Value: String): Boolean;

implementation

uses SysUtils;

function Iff(IsTrue: Boolean; ValueTrue, ValueFalse: Variant): Variant;
begin
  if IsTrue then Result:=ValueTrue
  else Result:=ValueFalse;
end;

procedure FreeAndNilEx(var Obj);
var
  Temp: TObject;
begin
  if Pointer(Obj)<>nil then begin
    Temp:=TObject(Obj);
    try
      Temp.Free;
    except
    end;
    Pointer(Obj):=nil;
  end;
end;

function IsClassParent(AClassIn: TClass; AClassParent: TClass): Boolean;
var
  AncestorClass: TClass;
begin
  AncestorClass := AClassIn;
  while (AncestorClass <> AClassParent) do
  begin
    if AncestorClass=nil then begin Result:=false; exit; end;
    AncestorClass := AncestorClass.ClassParent;
  end;
  Result:=true;
end;

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

function ParseBetween(const S, LDelim, RDelim: String; var Value: String): Boolean;
var
  APos: Integer;
  S1: String;
begin
  APos:=AnsiPos(LDelim,S);
  if APos>0 then begin
    Value:=Copy(S,1,APos-1);
    S1:=Copy(S,APos+Length(LDelim),Length(S));
    APos:=AnsiPos(RDelim,S1);
    if APos>0 then begin
      Value:=Copy(S1,1,APos-1);
    end else
      Value:=S1;
  end else
    Value:=S;
  Result:=Value<>'';
end;

end.
