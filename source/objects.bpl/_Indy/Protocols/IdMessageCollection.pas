{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11681: IdMessageCollection.pas 
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
  Classes,
  IdMessage;

type
  TIdMessageItems = class of TIdMessageItem;

  TIdMessageItem = class(TCollectionItem)
  protected
    FAttempt: Integer;
    FQueued: Boolean;
  public
    Msg: TIdMessage;
    //
    property Attempt: Integer read FAttempt write FAttempt;
    property Queued: Boolean read FQueued write FQueued;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  end;

  TIdMessageCollection = class(TCollection)
  private
    function GetIdMessage(index: Integer): TIdMessage;
    procedure SetIdMessage(index: Integer; const Value: TIdMessage);
  public
    function Add: TIdMessageItem;
    property Messages[index: Integer]: TIdMessage read GetIdMessage write SetIdMessage; Default;
  end;

implementation

uses
  SysUtils, IdGlobal;

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
  FreeAndNil(Msg);
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
