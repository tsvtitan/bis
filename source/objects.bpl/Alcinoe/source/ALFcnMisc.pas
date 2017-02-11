{*************************************************************
www:          http://sourceforge.net/projects/alcinoe/              
Author(s):    St�phane Vander Clock (svanderclock@delphinaute.com)
Sponsor(s):   Arkadia SA (http://www.arkadia.com)
							Delphinaute.com (http://www.delphinaute.com)
							
product:      Alcinoe Misc functions
Version:      3.50

Description:  Alcinoe Misc Functions

Legal issues: Copyright (C) 1999-2008 by Arkadia Software Engineering

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :     09/01/2005: correct then AlEmptyDirectory function
              25/05/2006: Move some function to AlFcnFile
Link :

Please send all your feedback to svanderclock@delphinaute.com
**************************************************************}
unit ALFcnMisc;

interface

uses Windows,
     sysutils;

Function AlBoolToInt(Value:Boolean):Integer;
Function ALMediumPos(LTotal, LBorder, LObject : integer):Integer;
Function ALIsInteger (const S : String) : Boolean;
Function ALIsSmallInt (const S : String) : Boolean;
Function AlStrToBool(Value:String):Boolean;
Function ALMakeKeyStrByGUID: String;
function AlIsValidEmail(const Value: string): boolean;
function AlLocalDateTimeToGMTDateTime(Const aLocalDateTime: TDateTime): TdateTime;

implementation

uses SysConst,
     ALFcnString;

{******************************************}
Function AlBoolToInt(Value:Boolean):Integer;
Begin
  If Value then result := 1
  else result := 0;
end;

{***************************************************************}
Function ALMediumPos(LTotal, LBorder, LObject : integer):Integer;
Begin
  result := (LTotal - (LBorder*2) - LObject) div 2 + LBorder;
End;

{************************************************}
Function ALIsInteger (const S : String) : Boolean;
var i : Integer;
Begin
 Result := TryStrToInt(S, I);
End;

{*************************************************}
Function ALIsSmallInt (const S : String) : Boolean;
var i : Integer;
Begin
 Result := TryStrToInt(S, I) and (i <= 32767) and (I >= -32768);
End;

{*****************************************}
Function AlStrToBool(Value:String):Boolean;
Begin
  Result := False;
  TryStrtoBool(Value,Result);
end;

{***********************************}
Function  ALMakeKeyStrByGUID: String;
Var aGUID: TGUID;
Begin
  CreateGUID(aGUID);
  Result := GUIDToString(aGUID);
  Delete(Result,1,1);
  Delete(Result,Length(result),1);
End;

{****************************************************}
function AlIsValidEmail(const Value: string): boolean;

 {----------------------------------------------}
 function CheckAllowed(const s: string): boolean;
 var i: integer;
 begin
   Result:= false;
   for i:= 1 to Length(s) do begin
     // illegal char in s -> no valid address
     if not (s[i] in ['a'..'z','A'..'Z','0'..'9','_','-','.']) then Exit;
   end;
   Result:= true;
 end;

var i: integer;
    namePart, serverPart: string;
begin
  Result:= false;
  i:= AlCharPos('@', Value);
  if (i = 0) or (ALpos('..', Value) > 0) then Exit;
  namePart:= AlCopyStr(Value, 1, i - 1);
  serverPart:= AlCopyStr(Value, i + 1, Length(Value));
  if (Length(namePart) = 0)         // @ or name missing
    or ((Length(serverPart) < 4))   // name or server missing or
    then Exit;                      // too short
  i:= AlCharPos('.', serverPart);
  // must have dot and at least 2 places from end
  if (i <= 1) or (i > (Length(serverPart) - 2)) then Exit;
  Result:= CheckAllowed(namePart) and CheckAllowed(serverPart);
end;

{********************************************************************************}
function AlLocalDateTimeToGMTDateTime(Const aLocalDateTime: TDateTime): TdateTime;

  {--------------------------------------------}
  function InternalCalcTimeZoneBias : TDateTime;
  const Time_Zone_ID_DayLight = 2;
  var TZI: TTimeZoneInformation;
      TZIResult: Integer;
      aBias : Integer;
  begin
    TZIResult := GetTimeZoneInformation(TZI);
    if TZIResult = -1 then Result := 0
    else begin
      if TZIResult = Time_Zone_ID_DayLight then aBias := TZI.Bias + TZI.DayLightBias
      else aBias := TZI.Bias + TZI.StandardBias;
      Result := EncodeTime(Abs(aBias) div 60, Abs(aBias) mod 60, 0, 0);
      if aBias < 0 then Result := -Result;
    end;
  end;

begin
  Result := aLocalDateTime + InternalCalcTimeZoneBias;
end;

end.
