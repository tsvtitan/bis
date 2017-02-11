{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  19162: IdReply.pas
{
{   Rev 1.22    10/26/2004 8:43:00 PM  JPMugaas
{ Should be more portable with new references to TIdStrings and TIdStringList.
}
{
    Rev 1.21    6/11/2004 8:48:24 AM  DSiders
  Added "Do not Localize" comments.
}
{
{   Rev 1.20    2004.03.01 7:10:34 PM  czhower
{ Change for .net compat
}
{
{   Rev 1.19    2004.03.01 5:12:34 PM  czhower
{ -Bug fix for shutdown of servers when connections still existed (AV)
{ -Implicit HELP support in CMDserver
{ -Several command handler bugs
{ -Additional command handler functionality.
}
{
{   Rev 1.18    2004.02.29 8:16:54 PM  czhower
{ Bug fix to fix AV at design time when adding reply texts to CmdTCPServer.
}
{
{   Rev 1.17    2004.02.03 4:17:10 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.16    2004.01.29 12:02:32 AM  czhower
{ .Net constructor problem fix.
}
{
{   Rev 1.15    1/3/2004 8:06:20 PM  JPMugaas
{ Bug fix:  Sometimes, replies will appear twice due to the way functionality
{ was enherited.
}
{
{   Rev 1.14    1/1/2004 9:33:24 PM  BGooijen
{ the abstract class TIdReply was created sometimes, fixed that
}
{
{   Rev 1.13    2003.10.18 9:33:28 PM  czhower
{ Boatload of bug fixes to command handlers.
}
{
    Rev 1.12    10/15/2003 7:49:38 PM  DSiders
  Added IdResourceStringsCore to implementation uses clause.
}
{
    Rev 1.11    10/15/2003 7:46:42 PM  DSiders
  Added formatted resource string for the exception raised in
  TIdReply.SetCode.
}
{
{   Rev 1.10    2003.09.06 1:30:30 PM  czhower
{ Removed abstract modifier from a class method so that C++ Builder can compile
{ again.
}
{
{   Rev 1.9    2003.06.05 10:08:50 AM  czhower
{ Extended reply mechanisms to the exception handling. Only base and RFC
{ completed, handing off to J Peter.
}
{
{   Rev 1.8    2003.05.30 10:25:56 PM  czhower
{ Implemented IsEndMarker
}
{
{   Rev 1.7    2003.05.30 10:06:08 PM  czhower
{ Changed code property mechanisms.
}
{
{   Rev 1.6    5/26/2003 04:29:56 PM  JPMugaas
{ Removed GenerateReply and ParseReply.  Those are now obsolete duplicate
{ functions in the new design.
}
{
{   Rev 1.5    5/26/2003 12:19:54 PM  JPMugaas
}
{
{   Rev 1.4    2003.05.26 11:38:18 AM  czhower
}
{
{   Rev 1.3    2003.05.25 10:23:44 AM  czhower
}
{
    Rev 1.2    5/20/2003 12:43:46 AM  BGooijen
  changeable reply types
}
{
{   Rev 1.1    5/19/2003 05:54:58 PM  JPMugaas
}
{
{   Rev 1.0    5/19/2003 12:26:16 PM  JPMugaas
{ Base class for reply format objects.
}
unit IdReply;

interface

uses
  Classes,
  IdException,
  IdTStrings;

type
  TIdReplies = class;
  //TODO: a streamed write only property will be registered to convert old DFMs
  // into the new one for old TextCode and to ignore NumericCode which has been
  // removed
  TIdReply = class(TCollectionItem)
  protected
    FCode: string;
    FFormattedReply: TIdStrings;
    FReplyTexts: TIdReplies;
    FText: TIdStrings;
    //
    procedure AssignTo(ADest: TPersistent); override;
    function GetFormattedReplyStrings: TIdStrings; virtual;
    function CheckIfCodeIsValid(const ACode: string): Boolean; virtual;
    function GetDisplayName: string; override;
    function GetFormattedReply: TIdStrings; virtual;
    function GetNumericCode: Integer;
    procedure SetCode(const AValue: string);
    procedure SetFormattedReply(const AValue: TIdStrings); virtual; abstract;
    procedure SetText(const AValue: TIdStrings);
    procedure SetNumericCode(const AValue: Integer);
  public
    procedure Clear; virtual;
    // Both creates are necessary. This base one is called by the collection editor at design time
    constructor Create(
      ACollection: TCollection
      ); overload; override;
    constructor Create(
      ACollection: TCollection;
      AReplyTexts: TIdReplies
      ); reintroduce; overload; virtual;
    destructor Destroy; override;
    // Is not abstract because C++ cannot compile abstract class methods
    class function IsEndMarker(const ALine: string): Boolean; virtual;
    procedure RaiseReplyError; virtual; abstract;
    function ReplyExists: Boolean; virtual;
    procedure SetReply(const ACode: Integer; const AText: string);
     overload; virtual;
    procedure SetReply(const ACode: string; const AText: string);
     overload; virtual;
    procedure UpdateText;
    //
    property FormattedReply: TIdStrings read GetFormattedReply
     write SetFormattedReply;
    property NumericCode: Integer read GetNumericCode write SetNumericCode;
  published
    property Code: string read FCode write SetCode;
    property Text: TIdStrings read FText write SetText;
  end;

  TIdReplyClass = class of TIdReply;

  TIdReplies = class(TOwnedCollection)
  protected
    function GetItem(Index: Integer): TIdReply;
    procedure SetItem(Index: Integer; const Value: TIdReply);
  public
    function Add: TIdReply; overload;
    function Add(ACode: Integer; AText: string): TIdReply; overload;
    function Add(ACode: string; AText: string): TIdReply; overload;
    constructor Create(
      AOwner: TPersistent;
      const AReplyClass: TIdReplyClass
      ); reintroduce; virtual;
    function Find(
      ACode: string
      ): TIdReply;
      virtual;
    procedure UpdateText(AReply: TIdReply); virtual;
    //
    property Items[Index: Integer]: TIdReply read GetItem write SetItem; default;
  end;

  TIdRepliesClass = class of TIdReplies;
  EIdReplyError = class(EIdException);

implementation

uses
  IdGlobal, IdResourceStringsCore,
  SysUtils;

{ TIdReply }

procedure TIdReply.AssignTo(ADest: TPersistent);
var LR : TIdReply;
begin
  if ADest is TIdReply then begin
    LR := TIdReply(ADest);
    LR.Clear;
    LR.Text.Assign(Self.Text);
    LR.Code := Self.Code;
  end else begin
    inherited;
  end;
end;

procedure TIdReply.Clear;
begin
  FText.Clear;
  FCode := '';
end;

constructor TIdReply.Create(
  ACollection: TCollection;
  AReplyTexts: TIdReplies
  );
begin
  // Call other create to init items
  Create(ACollection);
  FReplyTexts := AReplyTexts;
end;

destructor TIdReply.Destroy;
begin
  FreeAndNil(FText);
  FreeAndNil(FFormattedReply);
  inherited;
end;

function TIdReply.GetDisplayName: string;
begin
  if Text.Count > 0 then begin
    Result := Code + ' ' + Text[0];
  end else begin
    Result := Code;
  end;
end;

function TIdReply.ReplyExists: Boolean;
begin
  Result := Code <> '';
end;

procedure TIdReply.SetNumericCode(const AValue: Integer);
begin
  FCode := IntToStr(AValue);
end;

procedure TIdReply.SetText(const AValue: TIdStrings);
begin
  FText.Assign(AValue);
end;

procedure TIdReply.SetReply(const ACode: Integer; const AText: string);
begin
  SetReply(IntToStr(ACode), AText);
end;

function TIdReply.GetNumericCode: Integer;
begin
  Result := StrToIntDef(Code, 0);
end;

procedure TIdReply.SetCode(const AValue: string);
var
  LMatchedReply: TIdReply;
begin
  EIdException.IfFalse(CheckIfCodeIsValid(AValue), Format(RSReplyInvalidCode, [AValue]));
  // Only check for duplicates if we are in a collection. NormalReply etc are not in collections
  // Also dont check FReplyTexts, as non members can be duplicates of members
  if Collection <> nil then begin
    LMatchedReply := TIdReplies(Collection).Find(AValue);
    EIdException.IfTrue((LMatchedReply <> nil) and (LMatchedReply <> Self)
     , 'Reply already exists for ' + AValue); {do not localize}
  end;
  FCode := AValue;
end;

procedure TIdReply.SetReply(const ACode, AText: string);
begin
  Code := ACode;
  FText.Text := AText;
end;

function TIdReply.CheckIfCodeIsValid(const ACode: string): Boolean;
begin
  Result := True;
end;

class function TIdReply.IsEndMarker(const ALine: string): Boolean;
begin
  Result := False;
end;

function TIdReply.GetFormattedReply: TIdStrings;
begin
  // Overrides must call GetFormattedReplyStrings instead. This is just a base implementation
  // This is done this way because otherise double generations can occur it more than one
  // ancestor overrides. Example: Reply--> RFC --> FTP. Calling inherited would cause both
  // FTP and RFC to generate.
  Result := GetFormattedReplyStrings;
end;

function TIdReply.GetFormattedReplyStrings: TIdStrings;
begin
  FFormattedReply.Clear;
  Result := FFormattedReply;
end;

constructor TIdReply.Create(ACollection: TCollection);
begin
  inherited;
  FFormattedReply := TIdStringList.Create;
  FText := TIdStringList.Create;
end;

procedure TIdReply.UpdateText;
begin
  FReplyTexts.UpdateText(Self);
end;

{ TIdReplies }

function TIdReplies.Add: TIdReply;
begin
  Result := TIdReply(inherited Add);
end;

function TIdReplies.Add(ACode: Integer; AText: string): TIdReply;
begin
  Result := Add(IntToStr(ACode), AText);
end;

function TIdReplies.Add(ACode, AText: string): TIdReply;
begin
  Result := Add;
  try
    Result.SetReply(ACode, AText);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

constructor TIdReplies.Create(AOwner: TPersistent; const AReplyClass:TIdReplyClass);
begin
  inherited Create(AOwner, AReplyClass);
end;

function TIdReplies.Find(
  ACode: string
  ): TIdReply;
var
  i: Integer;
begin
  Result := nil;
  // Never return match on ''
  if ACode <> '' then begin
    for i := 0 to Count - 1 do begin
      if Items[i].Code = ACode then begin
        Result := Items[i];
        Break;
      end;
    end;
  end;
end;

function TIdReplies.GetItem(Index: Integer): TIdReply;
begin
  Result := TIdReply(inherited Items[Index]);
end;

procedure TIdReplies.SetItem(Index: Integer; const Value: TIdReply);
begin
  inherited SetItem(Index, Value);
end;

procedure TIdReplies.UpdateText(AReply: TIdReply);
var
  LReply: TIdReply;
begin
  // If text is blank, get it from the ReplyTexts
  if AReply.Text.Count = 0 then begin
    LReply := Find(AReply.Code);
    if LReply <> nil then begin
      AReply.Text.Assign(LReply.Text);
    end;
  end;
end;

end.
