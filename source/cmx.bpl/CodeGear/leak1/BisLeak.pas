unit BisLeak;

interface

uses Windows, PsAPI, SysUtils, Classes, Contnrs;

type
  TBisLeak=class(TObject)
  private
    FName: String;
    FBytesStart: Integer;
    FAllBytes: Integer;
    FTimeStart: TDateTime;
    FAllTime: TDateTime;
    FCount: Integer;
  public
    property Name: String read FName;
    property BytesStart: Integer read FBytesStart;
    property AllBytes: Integer read FAllBytes;
    property TimeStart: TDateTime read FTimeStart;
    property AllTime: TDateTime read FAllTime;
    property Count: Integer read FCount;
  end;

  TBisLeaks=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisLeak;
    procedure LoggerWrite(S: String);
    function Add(Name: String): TBisLeak;
  public
    function Find(Name: String): TBisLeak;
    procedure Init;
    procedure Done;
    procedure Start(Name: String);
    procedure Stop(Name: String);

    property Items[Index: Integer]: TBisLeak read GetItem;
  end;
     
var
  Leaks: TBisLeaks;

procedure InitLeaks;
procedure DoneLeaks;

procedure StartLeak(Name: String);
procedure StopLeak(Name: String);

implementation

var
 &File: TFileStream=nil;

function GetWorkingSetSize: Integer;
var
  pmc: TProcessMemoryCounters;
begin
  Result:=0;
  pmc.cb:=SizeOf(pmc);
  FillChar(pmc,SizeOf(pmc),0);
  if GetProcessMemoryInfo(GetCurrentProcess, @pmc, SizeOf(pmc)) then
    Result:=pmc.WorkingSetSize;
end;

procedure InitLeaks;
begin
  Leaks.Init;
end;

procedure StartLeak(Name: String);
begin
  Leaks.Start(Name);
end;

procedure StopLeak(Name: String);
begin
  Leaks.Stop(Name);
end;

procedure DoneLeaks;
begin
  Leaks.Done;
end;

{ TBisLeaks }

function TBisLeaks.Find(Name: String): TBisLeak;
var
  Item: TBisLeak;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Name,Name) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisLeaks.GetItem(Index: Integer): TBisLeak;
begin
  Result:=TBisLeak(inherited Items[Index]);
end;

procedure TBisLeaks.LoggerWrite(S: String);
begin
  if Assigned(&File) then begin
    S:=S+#13;
    &File.Write(Pointer(S)^,Length(S));
  end;
end;

function TBisLeaks.Add(Name: String): TBisLeak;
begin
  Result:=nil;
  if not Assigned(Find(Name)) then begin
    Result:=TBisLeak.Create;
    Result.FName:=Name;
    Result.FAllBytes:=0;
    Result.FAllTime:=0.0;
    Result.FCount:=0;
    inherited Add(Result);
  end;
end;

procedure TBisLeaks.Init;
begin
  Clear;
  LoggerWrite('Init at '+DateTimeToStr(Now)+' =================');
end;

procedure TBisLeaks.Done;
var
  i: Integer;
  Item: TBisLeak;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    LoggerWrite(Format('%s Count=%d Time=%s Bytes=%d',[Item.Name,Item.Count,FormatDateTime('hh:nn:ss.zzz',Item.AllTime),Item.AllBytes]));
  end;
  LoggerWrite('Done at '+DateTimeToStr(Now)+' =================');
end;

procedure TBisLeaks.Start(Name: String);
var
  Leak: TBisLeak;
begin
  Leak:=Find(Name);
  if not Assigned(Leak) then
    Leak:=Add(Name);
  if Assigned(Leak) then begin
    Leak.FBytesStart:=GetWorkingSetSize;
    Leak.FTimeStart:=Now;
    Leak.FCount:=Leak.FCount+1;
  end;
end;

procedure TBisLeaks.Stop(Name: String);
var
  Leak: TBisLeak;
begin
  Leak:=Find(Name);
  if Assigned(Leak) then begin
    Leak.FAllBytes:=Leak.FAllBytes+(GetWorkingSetSize-Leak.FBytesStart);
    Leak.FAllTime:=Leak.FAllTime+(Now-Leak.FTimeStart);
  end;
end;

initialization
{  &File:=TFileStream.Create('leaks.log',fmCreate);
  FreeAndNil(&File);
  &File:=TFileStream.Create('leaks.log',fmOpenWrite or fmShareDenyNone);}
  Leaks:=TBisLeaks.Create;

finalization
  Leaks.Free;
//  FreeAndNil(&File);


end.
