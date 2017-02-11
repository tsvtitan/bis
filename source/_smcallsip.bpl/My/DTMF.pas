unit DTMF;

// DTMF generator (c)2006 by Paul TOTH <tothpaul@free.fr>

// (based on caesar)
{
    caesar.c
    Multifrequency tone generator.
    Copyright (C) 2000 Martin Wellard

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    The author may be contacted as veghead@users.sourceforge.net
}
interface

uses
 Classes;

function GetDTMF(Freq,Event,Size:integer):string;

implementation

const
 EventsHz:array[0..15,0..1] of word=(
  (941, 1336), // 0
  (697, 1209), // 1
  (697, 1336), // 2     697Hz   1     2    3    A
  (697, 1477), // 3
  (770, 1209), // 4     770Hz   4     5    6    B
  (770, 1336), // 5
  (770, 1447), // 6     852Hz   7     8    9    C
  (852, 1209), // 7
  (852, 1336), // 8     941Hz   *     0    #    D
  (852, 1447), // 9
  (941, 1209), // *           1209  1336 1477 1633
  (941, 1477), // #            Hz    Hz   Hz   Hz
  (697, 1633), // A
  (770, 1633), // B
  (852, 1633), // C
  (941, 1633)  // D
 );

function fmod(a,b:single):single;
begin
 Result:=a-(b*int(a/b));
end;

function SINFUNC(f,nr:single):single;
begin
 Result:=sin(fmod( f*nr , 2*PI));
end;

function GetDTMF(Freq,Event,Size:integer):string;
const
// RATE=(2*PI)/8000;  // 8000Hz precomputed for SINFUNC
 AMP =90/100;
var
 RATE: Extended;
 i:integer;
 f1,f2:single;
 x:single;
 s:smallint;
begin
 Result:='';
 RATE:=(2*PI)/Freq;  // 8000Hz precomputed for SINFUNC
 if event>15 then exit;
 f1:=EventsHz[Event,0];
 f2:=EventsHz[Event,1];
 SetLength(Result,Size);
 for i:=0 to (Size-1) div 2 do begin
  x:=(SINFUNC(f1,i*RATE)*AMP
     +SINFUNC(f2,i*RATE)*AMP)*0.5;
  s:=round($7FFF*x);
  move(s,Result[2*i+1],2);
 end;
end;

end.

