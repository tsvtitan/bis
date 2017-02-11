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

unit IdObjs;

{$I IdCompilerDefines.inc}

interface

uses
{$IFDEF DotNet}
  {$IFDEF DotNetDistro}
  IdObjsFCL
  {$ELSE}
  Classes,
  SysUtils
  {$ENDIF}
{$ELSE}
  Classes,
  SysUtils
{$ENDIF};

type
{$IFDEF DotNetDistro}
  TIdBaseObject = &Object;
  TIdPersistent = TIdNetPersistent;
  TIdPersistentHelper = class helper (TIdNetPersistentHelper) for TIdPersistent
  public
    constructor Create; override;
  end;
  TIdNativeComponent = TIdNetNativeComponent;
  TIdNativeComponentHelper = class helper (TIdNetNativeComponentHelper) for TIdNativeComponent
  end;
  TIdNativeComponentState = TIdNetNativeComponentState;
  TIdOperation = TIdNetNativeOperation;
  TIdStrings = TIdStringsFCL;
  TIdStringList = TIdStringListFCL;
  TIdStream = TIdNetStream;
  TIdMemoryStream = TIdNetMemoryStream;
  TIdStringStream = TIdNetStringStream;
  TIdFileStream = TIdNetFileStream;
  TIdComponentName = TIdNetComponentName;
  TIdSeekOrigin = TIdNetSeekOrigin;
  TIdList = TIdNetList;
  TIdCollection = TIdNetCollection;
  TIdCollectionItem = TIdNetCollectionItem;
  TIdNativeThread = TIdNetThread;
  TIdThreadMethod = TIdNetThreadMethod;
  TIdNotifyEvent = TIdNetNotifyEvent;
  TIdThreadList = TIdNetThreadList;
  TidOwnedCollection = TIdNetOwnedCollection;
  TIdMultiReadExclusiveWriteSynchronizer = TIdNetMultiReadExclusiveWriteSynchronizer;
{$ELSE}
  {$IFDEF DELPHI5}
  TSeekOrigin = Word;
  {$ENDIF}
  {$IFDEF DOTNET}
  TIdNativeComponent = TComponent;
  TIdNativeComponentState = TComponentState;
  TIdNativeComponentHelper = class helper (TComponentHelper) for TIdNativeComponent
  end;
   TIdPersistent = TPersistent;
   TIdPersistantHelper = class helper(TPersistentHelper) for TIdPersistent
   end;
  {$ELSE}
     TIdPersistent = TPersistent;
    TIdNativeComponent = TComponent;
  {$ENDIF}
  TIdOperation = TOperation;
  TIdBaseObject = TObject;

  TIdStrings = Classes.TStrings;
  TIdStringList = Classes.TStringList;
  TIdStream = TStream;
  TIdComponentName = TComponentName;
  TIdMemoryStream = TMemoryStream;
  TIdStringStream = TStringStream;
  TIdFileStream = TFileStream;
  TIdSeekOrigin = TSeekOrigin;
  TIdList = TList;
  TIdCollection = TCollection;
  TIdCollectionItem = TCollectionItem;
  TIdNativeThread = TThread;
  TIdThreadMethod = TThreadMethod;
  TIdNotifyEvent = TNotifyEvent;
  TIdThreadList = TThreadList;
  TIdOwnedCollection = TOwnedCollection;
  TIdMultiReadExclusiveWriteSynchronizer = TMultiReadExclusiveWriteSynchronizer;
{$ENDIF}
  TIdComponentClass = class of TIdNativeComponent;

const
{$IFDEF DOTNET}
  IdFromBeginning   = TIdSeekOrigin.soBeginning;
  IdFromCurrent     = TIdSeekOrigin.soCurrent;
  IdFromEnd         = TIdSeekOrigin.soEnd;

  fmCreate          = $FFFF;
  fmOpenRead        = $0000;
  fmOpenWrite       = $0001;
  fmOpenReadWrite   = $0002;

  fmShareExclusive  = $0010;
  fmShareDenyWrite  = $0020;
  fmShareDenyNone   = $0040;
{$ELSE}
  {$IFDEF DELPHI5}
  soBeginning = soFromBeginning;
  soCurrent = soFromCurrent;
  soEnd = soFromEnd;
  {$ENDIF}

  IdFromBeginning   = TIdSeekOrigin(soBeginning);
  IdFromCurrent     = TIdSeekOrigin(soCurrent);
  IdFromEnd         = TIdSeekOrigin(soEnd);

  fmCreate          = $FFFF;
{$IFDEF LINUX}
  fmOpenRead        = O_RDONLY;
  fmOpenWrite       = O_WRONLY;
  fmOpenReadWrite   = O_RDWR;

  fmShareExclusive  = $0010;
  fmShareDenyWrite  = $0020;
  fmShareDenyNone   = $0030;
{$ENDIF}
{$IFDEF MSWINDOWS}
  fmOpenRead        = $0000;
  fmOpenWrite       = $0001;
  fmOpenReadWrite   = $0002;

  fmShareExclusive  = $0010;
  fmShareDenyWrite  = $0020;
  fmShareDenyNone   = $0040;
{$ENDIF}
{$ENDIF}
{$IFDEF DotNetDistro}
  tpIdLowest = tpIdNetLowest;
  tpIdBelowNormal = tpIdNetBelowNormal;
  tpIdNormal = tpIdNetNormal;
  tpIdAboveNormal = tpIdNetAboveNormal;
  tpIdHighest = tpIdNetHighest;
  csLoading = IdObjsFCL.csLoading;
  csDesigning = IdObjsFCL.csDesigning;
  opRemove = IdObjsFCL.opRemove;
{$ELSE}
  tpIdLowest = tpLowest;
  tpIdBelowNormal = tpLower;
  tpIdNormal = tpNormal;
  tpIdAboveNormal = tpHigher;
  tpIdHighest = tpHighest;
  csLoading = Classes.csLoading;
  csDesigning = Classes.csDesigning;
  opRemove = Classes.opRemove;
{$ENDIF}
  iddupIgnore = dupIgnore;
  iddupAccept = dupAccept;
  iddupError = dupError;


implementation

uses
  IdGlobal, IdSys;

{$IFDEF DotNetDistro}
{ TIdPersistentHelper }

constructor TIdPersistentHelper.Create;
begin
  inherited Create;
end;

{$ENDIF}

end.


