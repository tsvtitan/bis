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
{   Rev 1.4    10/26/2004 10:59:30 PM  JPMugaas
{ Updated ref.
}
{
    Rev 1.3    5/29/2004 10:02:20 AM  DSiders
  Corrected case in Create parameter.
}
{
{   Rev 1.2    2004.02.03 5:44:54 PM  czhower
{ Name changes
}
{
{   Rev 1.1    2004.01.21 1:04:52 PM  czhower
{ InitComponenet
}
{
{   Rev 1.0    11/14/2002 02:13:40 PM  JPMugaas
}
unit IdAuthenticationManager;

interface

Uses
  IdAuthentication,
  IdBaseComponent,
  IdSys,
  IdObjs,
  IdURI;

Type
  TIdAuthenticationItem = class(TIdCollectionItem)
  protected
    FURI: TIdURI;
    FParams: TIdStringList;
    procedure SetParams(const Value: TIdStringList);
    procedure SetURI(const Value: TIdURI);
  public
    constructor Create(ACollection: TIdCollection); override;
    destructor Destroy; override;

    property URL: TIdURI read FURI write SetURI;
    property Params: TIdStringList read FParams write SetParams;
  end;

  TIdAuthenticationCollection = class(TIdOwnedCollection)
  protected
    function GetAuthItem(AIndex: Integer): TIdAuthenticationItem;
    procedure SetAuthItem(AIndex: Integer;
      const Value: TIdAuthenticationItem);
  public
    function Add: TIdAuthenticationItem;
    constructor Create(AOwner: TIdPersistent);
    //
    property Items[AIndex: Integer]: TIdAuthenticationItem read GetAuthItem write SetAuthItem;
  end;

  TIdAuthenticationManager = class(TIdBaseComponent)
  protected
    FAuthentications: TIdAuthenticationCollection;
    //
    procedure InitComponent; override;
  public
    destructor Destroy; override;
    procedure AddAuthentication(AAuthtetication: TIdAuthentication; AURL: TIdURI);
    property Authentications: TIdAuthenticationCollection read FAuthentications;
  end;

implementation

uses
  IdGlobal;

{ TIdAuthenticationManager }

function TIdAuthenticationCollection.Add: TIdAuthenticationItem;
begin
  result := TIdAuthenticationItem.Create(self);
end;

constructor TIdAuthenticationCollection.Create(AOwner: TIdPersistent);
begin
  inherited Create(AOwner, TIdAuthenticationItem);
end;

function TIdAuthenticationCollection.GetAuthItem(
  AIndex: Integer): TIdAuthenticationItem;
begin
  result := TIdAuthenticationItem(inherited Items[AIndex]);
end;

procedure TIdAuthenticationCollection.SetAuthItem(AIndex: Integer;
  const Value: TIdAuthenticationItem);
begin
  if Items[AIndex] <> nil then begin
    Items[AIndex].Assign(Value);
  end;
end;

{ TIdAuthenticationManager }

procedure TIdAuthenticationManager.AddAuthentication(
  AAuthtetication: TIdAuthentication; AURL: TIdURI);
begin
  with Authentications.Add do begin
    URL.URI := AURL.URI;
    Params.Assign(AAuthtetication.Params);
  end;
end;

destructor TIdAuthenticationManager.Destroy;
begin
  Sys.FreeAndNil(FAuthentications);
  inherited Destroy;
end;

procedure TIdAuthenticationManager.InitComponent;
begin
  inherited InitComponent;
  FAuthentications := TIdAuthenticationCollection.Create(Self);
end;

{ TIdAuthenticationItem }

constructor TIdAuthenticationItem.Create(ACollection: TIdCollection);
begin
  inherited Create(ACollection);

  FURI := TIdURI.Create;
  FParams := TIdStringList.Create;
end;

destructor TIdAuthenticationItem.Destroy;
begin
  Sys.FreeAndNil(FURI);
  Sys.FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TIdAuthenticationItem.SetParams(const Value: TIdStringList);
begin
  FParams.Assign(Value);
end;

procedure TIdAuthenticationItem.SetURI(const Value: TIdURI);
begin
  FURI.URI := Value.URI;
end;

end.
