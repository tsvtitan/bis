{
  $Project$
  $Workfile$
  $Revision$
  $DateUTC$
  $Id$

  This file is part of the Indy (Internet Direct) project, and is offered
  under the dual-licensing agreement described on the Indy website.
  (http://www.indyproject.org/)

  Copyright:
   (c) 1993-2005, Chad Z. Hower and the Indy Pit Crew. All rights reserved.
}
{
  $Log$
}
{
{   Rev 1.2    2004.10.26 2:19:58 PM  czhower
{ Resolved alias conflict.
}
{
{   Rev 1.1    14/07/2004 21:37:26  CCostelloe
{ Changed Get/SetMessage to Get/SetIdMessage to avoid conflict under C++ with
{ Windows' GetMessage
}
{
{   Rev 1.0    11/13/2002 07:57:28 AM  JPMugaas
}
unit IdMessageCollection;

{*

  TIdMessageCollection: Contains a collection of IdMessages.

  2000-APR-14 Peter Mee: Converted to Indy.
  2001-MAY-03 Idan Cohen: Added Create and Destroy of TIdMessage.

  Originally by Peter Mee.
*}
interface

uses
  IdMessage,
  IdObjs,
  IdSys;

type
  TIdMessageItems = class of TIdMessageItem;

  TIdMessageItem = class(TIdCollectionItem)
  protected
    FAttempt: Integer;
    FQueued: Boolean;
  public
    Msg: TIdMessage;
    //
    property Attempt: Integer read FAttempt write FAttempt;
    property Queued: Boolean read FQueued write FQueued;
    constructor Create(Collection: TIdCollection); override;
    destructor Destroy; override;
  end;

  TIdMessageCollection = class(TIdCollection)
  private
    function GetIdMessage(index: Integer): TIdMessage;
    procedure SetIdMessage(index: Integer; const Value: TIdMessage);
  public
    function Add: TIdMessageItem;
    property Messages[index: Integer]: TIdMessage read GetIdMessage write SetIdMessage; Default;
  end;

implementation

uses
  IdGlobal;

function TIdMessageCollection.Add;
begin
  Result := TIdMessageItem(inherited Add);
end;

{ TIdMessageItem }

constructor TIdMessageItem.Create;
begin
  inherited;
  Msg := TIdMessage.Create(nil);
end;

destructor TIdMessageItem.Destroy;
begin
  Sys.FreeAndNil(Msg);
  inherited;
end;

function TIdMessageCollection.GetIdMessage(index: Integer): TIdMessage;
begin
     Result := TIdMessageItem(Items[index]).Msg;
end;

procedure TIdMessageCollection.SetIdMessage(index: Integer;
  const Value: TIdMessage);
begin
     //I think it should be freed before the new value is assigned or else the
     //pointer will be lost.
     TIdMessageItem(Items[index]).Msg.Free;
     TIdMessageItem(Items[index]).Msg := Value;
end;

end.
