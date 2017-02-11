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

unit IdStreamVCL;

interface
{$I IdCompilerDefines.inc}

uses
  Classes,
  IdGlobal;

type

  TIdStreamHelperVCL = class
  public
    class function ReadBytes(
          const AStream: TStream;
          var VBytes: TIdBytes;
          const ACount: Integer = -1;
          const AOffset: Integer = 0) : Integer; {$IFDEF DOTNET} static; {$ENDIF}
    class procedure Write(
          const AStream: TStream;
          const ABytes: TIdBytes;
          const ACount: Integer = -1); {$IFDEF DOTNET} static; {$ENDIF}
  end;

implementation

class function TIdStreamHelperVCL.ReadBytes(const AStream: TStream; var VBytes: TIdBytes;
  const ACount, AOffset: Integer): Integer;
var
 aActual:Integer;
begin
  Assert(AStream<>nil);
  Result:=0;

  if VBytes = nil then
  begin
    SetLength(VBytes, 0);
  end;
  //check that offset<length(buffer)? offset+count?
  //is there a need for this to be called with an offset into a nil buffer?

  aActual:=ACount;
  if aActual = -1 then begin
    aActual := AStream.Size - AStream.Position;
  end;

  //this prevents eg reading 0 bytes at Offset=10 from allocating memory
  if aActual=0 then begin
    Exit;
  end;

  if Length(VBytes) < (AOffset+aActual) then begin
    SetLength(VBytes, AOffset+aActual);
  end;

  Assert(VBytes<>nil);
  Result := AStream.Read(VBytes[AOffset], aActual);
end;

class procedure TIdStreamHelperVCL.Write(const AStream: TStream;const ABytes: TIdBytes;
  const ACount: Integer);
var
 aActual:Integer;
begin
  Assert(AStream<>nil);

  aActual:=ACount;
  //should we raise assert instead of this nil check?
  if ABytes <> nil then
  begin
    if aActual = -1 then
    begin
      aActual := Length(ABytes);
    end
    else
    begin
      aActual := Min(aActual, Length(ABytes));
    end;
    if aActual > 0 then
    begin
      AStream.Write(ABytes[0], aActual);
    end;
  end;
end;

end.

