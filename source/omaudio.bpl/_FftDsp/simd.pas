unit Simd;

// utilisation des instructions SIMD de l'architecture X86
// voir http://fr.wikipedia.org/wiki/Streaming_SIMD_Extensions
//
// programmation: voir http://softpixel.com/~cwright/programming/simd/cpuid.php
// instructions SSE: http://www.tommesani.com/Docs.html
//
// cpuid uses the value in eax, and returns data into eax, ebx, ecx, and edx.
// The eax input is known as the "Function" input.
// It can have values from 0x00000000 to 0x00000001, and 0x80000000 to 0x80000008.


// fonctions cpuid
// CPUID - Functions

// Function 0x00000000:

// Function 0 is used to get the Vendor String from the CPU.
// It also tells us the maximum function supported by cpuid.
// Every cpuid-supporting CPU will allow at least this function.
// When called, eax gets the maximum function call value.
// ebx gets the first 4 bytes of the Vendor String.
// edx gets the second 4 bytes of the Vendor String.
// ecx gets the last 4 bytes of the Vendor String.

// Function 0x0000001:

// Function 0x1 returns the Processor Family, Model, and Stepping information in eax.
// bits (eax) 	field
// 0-3	        Stepping number
// 4-7	        Model number
// 8-11	        Family number
// 12-13        Processor Type
// 16-19        Extended Model Number
// 20-27        Extended Family Number

// edx gets the Standard Feature Flags.
// bit (edx) 	feature
// 18	        PN
// 19	        CLFlush
// 23	        MMX
// 25	        SSE
// 26	        SSE2
// 28	        HTT

// bit          (ecx) 	feature
// 0	        SSE3

// passage de parametres:

// Under the register convention, up to three parameters are passed in CPU registers,
// and the rest (if any) are passed on the stack. The parameters are passed in order
// of declaration (as with the pascal convention), and the first three parameters
/// that qualify are passed in the EAX, EDX, and ECX registers, in that order.
// Real, method-pointer, variant, Int64, and structured types do not qualify as
// register parameters, but all other parameters do. If more than three parameters
// qualify as register parameters, the first three are passed in EAX, EDX, and ECX,
// and the remaining parameters are pushed onto the stack in order of declaration.
// For example, given the declaration
// procedure Test(A: Integer; var B: Char; C: Double; const D: string; E: Pointer);
// a call to Test passes A in EAX as a 32-bit integer, B in EDX as a pointer to a Char,
// and D in ECX as a pointer to a long-string memory block;
// C and E are pushed onto the stack as two double-words and a 32-bit pointer, in that order.

// Register saving conventions
// Procedures and functions must preserve the EBX, ESI, EDI, and EBP registers,
// but can modify the EAX, EDX, and ECX registers. When implementing a constructor
// or destructor in assembler, be sure to preserve the DL register.
// Procedures and functions are invoked with the assumption that the CPU's direction
// flag is cleared (corresponding to a CLD instruction) and must return with the
// direction flag cleared.


// tests:

{ performances en microsecondes pour Num = 8192

  SimdComplexMul : 290   (750 en delphi)
  SimdAdd        :  80
  SimdMove       :  16
  SimdZero       :  35  (47 en fillchar)
}

//----------------------------------------------------------------------------//
//                               Licence                                      //
// This program is free software; you can redistribute it and/or modify it    //
// under the terms of the GNU General Public License as published by the      //
// Free Software Foundation; either version 2 of the License, or (at your     //
// option) any later version. This program is distributed in the hope that    //
// it will be useful, but WITHOUT ANY WARRANTY; without even the implied      //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  //
// GNU General Public License for more details.                               //
//                                                                            //
// You should have received a copy of the GNU General Public License          //
// along with this program; if not, write to the Free Software Foundation,    //
// Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            //
//                                                                            //
//                                                                            //
//----------------------------------------------------------------------------//
//                                                                            //
// Ce programme est libre, vous pouvez le redistribuer et/ou le modifier      //
// selon les termes de la LICENCE PUBLIQUE GENERALE GNU publiee par la        //
// Free Software Foundation version 2.                                        //
//                                                                            //
// This unit is distribued under the terms of the GPL. You can read the       //
// terms of this licence in the "GPL.html" file given with this unit.         //
//                                                                            //
// Ce programme est distribue car potentiellement utile, mais SANS AUCUNE     //
// GARANTIE, ni explicite ni implicite, y compris les garanties de            //
// commercialisation ou d'adaptation dans un but specifique.                  //
// Reportez-vous a la Licence Publique Generale GNU pour plus de details.     //
//                                                                            //
// Vous devez avoir recu une copie de la Licence Publique Generale GNU        //
// en meme temps que ce programme("gpl.html").                                //
// si ce n'est pas le cas, ecrivez a la :                                     //
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA     //
// 02111-1307, Etats-Unis.                                                    //
//                                                                            //
//****************************************************************************//
//                                                                            //
// DISCLAIMER OF WARRANTY :                                                   //
//                                                                            //
//   BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY     //
// FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN   //
// OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES     //
// PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED //
// OR IMPLIED, INCLDUING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF       //
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS  //
// TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE     //
// PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,   //
// REPAIR OR CORRECTION.                                                      //
//                                                                            //
//   IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING    //
// WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR        //
// REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, //
// INCLDUING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING//
// OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLDUING BUT NOT LIMITED  //
// TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY   //
// YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER //
// PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE      //
// POSSIBILITY OF SUCH DAMAGES.                                               //
//                                                                            //
//****************************************************************************//


interface

uses Windows, SysUtils, dialogs, math;


const   MaxLength   = 65536*2;

type
  // TFloat is the basic library floating point type. Use single for single
  // precision (4 bytes) or double for more demanding, double precision (8 bytes)
  TFloat = single;

  // Complex numbers, with precision specified in TFloat (Types unit)
  TComplex = record
    Re: TFloat; // Real part
    Im: TFloat; // Imaginary part
  end;


  TSingleArray = array [0..MaxLength] of single;
  PSingleArray = ^TSingleArray;

  TDoubleArray = array [0..MaxLength] of double;
  PDoubleArray = ^TDoubleArray;

  TExtendedArray = array [0..MaxLength] of Extended;
  PExtendedArray = ^TExtendedArray;

  TPointerArray = array [0..MaxLength] of pointer;
  PPointerArray = ^TPointerArray;

  TLongWordArray = array [0..MaxLength] of LongWord;
  PLongWordArray = ^TLongWordArray;

  TLongintArray = array[0..MaxLength] of longint;
  PLongintArray = ^TLongintArray;

  TSmallintArray = array [0..MaxLength] of Smallint;
  PSmallintArray = ^TSmallintArray;

  TComplexArray = array [0..0] of TComplex;
  PComplexArray = ^TComplexArray;

function  SimdSingleArray(PArray: pointer; count: integer): PSingleArray;
function  SimdDoubleArray(PArray: pointer; count: integer): PDoubleArray;
function  SimdExtendedArray(PArray: pointer; count: integer): PExtendedArray;
function  SimdLongintArray(PArray: pointer; count: integer): PLongintArray;

procedure SimdAdd(const V1, V2, V3: PSingleArray; Num: integer);  // V1 + V2 -> V3
procedure SimdSub(const V1, V2, V3: PSingleArray; Num: integer);  // V1 - V2 -> V3
procedure SimdMul(const V1, V2, V3: PSingleArray; Num: integer);  // V1 * V2 -> V3
procedure SimdComplexMul(const V1_re, V1_im, V2_re, V2_im, V3_Re, V3_im, PVar: PSingleArray; Num: integer);
procedure SimdComplexMul2(const V1, V2, V3: PSingleArray; Num: integer);
procedure SimdDiv(const V1, V2, V3: PSingleArray; Num: integer);  // V1 / V2 -> V3
procedure SimdScale(const V1, V2: PSingleArray; Coeff: single; Num: integer);  // V1 * Coeff -> V2
procedure SimdMove(const V1, V2: PSingleArray; Num: integer);  // V1 -> V2
procedure SimdZero(const V1: PSingleArray; Num: integer);      // 0 -> V1
procedure GetCpuTicks(var T: int64); // far;register;aSSEmbler;
procedure GetCPUSpeed(var F: integer);
procedure InitTime;
procedure EndTime(var PT: integer);  // en microsecondes


var
  EnableSSE   : boolean = false;
  VX :  PSingleArray;
  _VX: pointer;
  CpuFreq, ProcessTime : integer;
  Tick1, Tick2: int64;
  PriorityClass, Priority: Integer;

implementation

procedure InitTime;
begin
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  GetCpuTicks(Tick1);
end;

procedure EndTime(var PT: integer);  // en microsecondes
begin
  GetCpuTicks(Tick2);
  PT := round((Tick2 - Tick1) / CpuFreq);
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
end;

procedure GetCpuTicks(var T: int64);
begin
 asm
  mov  ecx,eax
  dw $310F                 {RDTSC} {Read Time Stamp Counter}
  mov dword ptr [ecx],EAX;
  mov dword ptr [ecx+4],EDX;
 end;
end;

// donne la frequence CPU en mhz : CpuFreq
procedure GetCPUSpeed(var F: integer);
const
  DelayTime = 500;     // en millisecondes
var
  TimerHi, TimerLo: longword;
begin
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    dw 310Fh
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  F := round(TimerLo / (1000 * DelayTime));
end;


function SimdLongintArray(PArray: pointer; count: integer): PLongintArray;
var i : integer;
    Pvar: PLongintArray;
begin
  if (PArray <> nil)  then FreeMem(PArray);
  GetMem(PArray, (count * SizeOf(Longint)+16));
  Pvar := PLongintArray((integer(PArray) and $FFFFFFF0) + 16);
  result := Pvar;
  for i := 0 to count-1 do Pvar[i] := 0;
end;


function SimdSingleArray(PArray: pointer; count: integer): PSingleArray;
var i : integer;
    Pvar: PSingleArray;
begin
  if (PArray <> nil)  then FreeMem(PArray);
  if (count and $F) <> 0 then
    ShowMessage('SimdSingleArray: count doit etre multiple de 16');
  GetMem(PArray, (count * SizeOf(single)+16));
  Pvar := PSingleArray((integer(PArray) and $FFFFFFF0) + 16);
  result := Pvar;
  for i := 0 to count-1 do Pvar[i] := 0.0;
end;

function SimdDoubleArray(PArray: pointer; count: integer): PDoubleArray;
var i : integer;
    Pvar: PDoubleArray;
begin
  if (PArray <> nil)  then FreeMem(PArray);
  GetMem(PArray, (count * SizeOf(double)+16));
  Pvar := PdoubleArray((integer(PArray) and $FFFFFFF0) + 16);
  result := Pvar;
  for i := 0 to count-1 do Pvar[i] := 0.0;
end;

function SimdExtendedArray(PArray: pointer; count: integer): PExtendedArray;
var i : integer;
    Pvar: PExtendedArray;
begin
  if (PArray <> nil)  then FreeMem(PArray);
  GetMem(PArray, (count * SizeOf(Extended)+16));
  Pvar := PExtendedArray((integer(PArray) and $FFFFFFF0) + 16);
  result := Pvar;
  for i := 0 to count-1 do Pvar[i] := 0.0;
end;


// perfs 6 us en SIMD et 26 us en pascal
procedure SimdAdd(const V1, V2, V3: PSingleArray; Num: integer);  // V1 + V2 -> V3    Num multiple de 16
var i : integer;
begin
 // InitTime;
  if EnableSSE then
  asm

// the first three parameters are passed in EAX, EDX, and ECX,
// and the remaining parameters are pushed onto the stack in order of declaration

    push ebx
    mov ebx,[V1]
    mov edx,[V2]
    mov eax,[V3]
    mov ecx,[Num]

    shr ecx,4  // number of large iterations = number of elements / 16
    jz @EndAddLoop
  @AddLoop:

    movaps xmm0,[ebx]
    addps xmm0,[edx]
    movaps [eax],xmm0

    movaps xmm1,[ebx+16]
    addps xmm1,[edx+16]
    movaps [eax+16],xmm1

    movaps xmm2,[ebx+32]
    addps xmm2,[edx+32]
    movaps [eax+32],xmm2

    movaps xmm3,[ebx+48]
    addps xmm3,[edx+48]
    movaps [eax+48],xmm3

    add eax,64
    add edx,64
    add ebx,64

    dec ecx
    jnz @AddLoop

  @EndAddLoop:

    pop ebx
  end
  else for i := 0 to Num-1 do V3^[i] := V1^[i] + V2^[i];
 // EndTime(ProcessTime);
end;

procedure SimdSub(const V1, V2, V3: PSingleArray; Num: integer);  // V1 - V2 -> V3
var i : integer;
begin
  if EnableSSE then
  asm
    push ebx
    mov ebx,[V1]
    mov edx,[V2]
    mov eax,[V3]
    mov ecx,[Num]

    shr ecx,4  // number of large iterations = number of elements / 16
    jz @EndSubLoop
    @SubLoop:

    movaps xmm0,[ebx]
    subps xmm0,[edx]
    movaps [eax],xmm0

    movaps xmm1,[ebx+16]
    subps xmm1,[edx+16]
    movaps [eax+16],xmm1

    movaps xmm2,[ebx+32]
    subps xmm2,[edx+32]
    movaps [eax+32],xmm2

    movaps xmm3,[ebx+48]
    subps xmm3,[edx+48]
    movaps [eax+48],xmm3

    add eax,64
    add edx,64
    add ebx,64

    dec ecx
    jnz @SubLoop

   @EndSubLoop:

    pop ebx
  end
  else for i := 0 to Num-1 do V3^[i] := V1^[i] - V2^[i];
end;

procedure SimdMul(const V1, V2, V3: PSingleArray; Num: integer);  // V1 * V2 -> V3
var i : integer;
begin
  if EnableSSE then
  asm
    push ebx
    mov ebx,[V1]
    mov edx,[V2]
    mov eax,[V3]
    mov ecx,[Num]

    shr ecx,4  // number of large iterations = number of elements / 16
    jz @EndMulLoop
    @MulLoop:

    movaps xmm0,[ebx]
    mulps xmm0,[edx]
    movaps [eax],xmm0

    movaps xmm1,[ebx+16]
    mulps xmm1,[edx+16]
    movaps [eax+16],xmm1

    movaps xmm2,[ebx+32]
    mulps xmm2,[edx+32]
    movaps [eax+32],xmm2

    movaps xmm3,[ebx+48]
    mulps xmm3,[edx+48]
    movaps [eax+48],xmm3

    add eax,64
    add edx,64
    add ebx,64

    dec ecx
    jnz @MulLoop

   @EndMulLoop:

    pop ebx
  end
  else  for i := 0 to Num-1 do V3^[i] := V1^[i] * V2^[i];
end;

//   V3.Re := V1.Re * V2.Re - V1.Im * V2.Im;
//   V3.Im := V1.Im * V2.Re + V1.Re * V2.Im;

procedure SimdComplexMul(const V1_re, V1_im, V2_re, V2_im, V3_re, V3_im, PVar: PSingleArray; Num: integer);
var i : integer;
begin
  if EnableSSE then
  begin
    SimdMul(V1_re, V2_re, V3_re, Num);
    SimdMul(V1_im, V2_im, PVar,  Num);
    SimdSub(V3_re, PVar,  V3_re, Num);
    SimdMul(V1_im, V2_re, V3_im, Num);
    SimdMul(V1_re, V2_im, PVar,  Num);
    SimdAdd(V3_im, PVar,  V3_im, Num);
  end else
  for i := 0 to Num-1 do
  begin
    V3_re^[i] := V1_re^[i] * V2_re^[i] - V1_im^[i] * V2_im^[i];
    V3_im^[i] := V1_im^[i] * V2_re^[i] + V1_re^[i] * V2_im^[i];
  end;
end;

// selon format des datas pour fftooura
// perfs: 33 us en SIMD et 84 en pascal
procedure SimdComplexMul2(const V1, V2, V3: PSingleArray; Num: integer);
var i,j : integer;
begin
 // InitTime;
  // init des coeffs de calcul
  VX[0] := 1; VX[1] := 0; VX[2] := 1; VX[3] := 0;
  VX[4] := 0; VX[5] := 1; VX[6] := 0; VX[7] := 1;

  if EnableSSE then
  asm
    push ebx
    mov ebx,[VX]
    movaps xmm7,[ebx]      // xmm7 = (1,0,1,0)
    movaps xmm6,[ebx+16]   // xmm6 = (0,1,0,1)

    mov ebx,[V1]
    mov edx,[V2]
    mov eax,[V3]
    mov ecx,[Num]
    shr ecx,2              // (Num div 4)

    jz @EndMul2Loop
   @Mul2Loop:

    movaps xmm1,[ebx]      // xmm1 = (Re1[1], Im1[1], Re1[2], Im1[2])
    movaps xmm2,[edx]      // xmm2 = (Re2[1], Im2[1], Re2[2], Im2[2])
    movaps xmm3,xmm1
    mulps xmm3,xmm2        // xmm3 = (Re1[1]*Re2[1],Im1[1]*Im2[1],Re1[2]*Re2[2],Im1[2]*Im2[2])
    movaps xmm4,xmm1
    shufps xmm4,xmm4,$b1   // xmm4 = (Im1[1],Re1[1],Im1[2],Re1[2])
    mulps xmm4,xmm2        // xmm4 = (Im1[1]*Re2[1],Re1[1]*Im2[1],Im1[2]*Re2[2],Re1[2]*Im2[2])
    movaps xmm0,xmm3
    mulps xmm0,xmm7        // xmm3 = (Re1[1]*Re2[1],0,Re1[2]*Re2[2],0)
    shufps xmm3,xmm3,$b1   // xmm3 = (Im1[1]*Im2[1],Re1[1]*Re2[1],Im1[2]*Im2[2],Re1[2]*Re2[2])
    mulps xmm3,xmm7        // xmm3 = (Im1[1]*Im2[1],0,Im1[2]*Im2[2],0)
    subps xmm0,xmm3        // xmm0 = (Re1[1]*Re2[1]-Im1[1]*Im2[1],0,Re1[2]*Re2[2]-Im1[2]*Im2[2],0)
    movaps xmm3,xmm4
    mulps xmm3,xmm6        // xmm3 = (0,Im1[1]*Re2[1],0,Im1[2]*Re2[2])
    addps xmm0,xmm3
    shufps xmm4,xmm4,$b1
    mulps xmm4,xmm6        // xmm4 = (0,Re1[1]*Im2[1],0,Re1[2]*Im2[2])
    addps xmm0,xmm4        // xmm0 = (Re1[1]*Re2[1]-Im1[1]*Im2[1],Re1[1]*Im2[1]+Im1[1]*Re2[1],Re1[2]*Re2[2]-Im1[2]*Im2[2],Re1[2]*Im2[2]+Im1[2]*Re2[2])
    movaps [eax],xmm0

    add eax,16
    add edx,16
    add ebx,16

    dec ecx
    jnz @Mul2Loop

   @EndMul2Loop:

    pop ebx
  end  else
  for j := 1 to (Num div 2) -1 do
  begin
    i := 2*j;
    V3^[i]   := V1^[i] * V2^[i] - V1^[i+1] * V2^[i+1];
    V3^[i+1] := V1^[i+1] * V2^[i] + V1^[i] * V2^[i+1];
  end;
  V3^[0] := V1^[0] * V2^[0];
  V3^[1] := V1^[1] * V2^[1];
 // EndTime(ProcessTime);
end;


procedure SimdDiv(const V1, V2, V3: PSingleArray; Num: integer);  // V1 / V2 -> V3
var i : integer;
begin
  if EnableSSE then
  asm
    push ebx
    mov ebx,[V1]
    mov edx,[V2]
    mov eax,[V3]
    mov ecx,[Num]

    shr ecx,4  // number of large iterations = number of elements / 16
    jz @EndDivLoop
    @DivLoop:

    movaps xmm0,[ebx]
    divps xmm0,[edx]
    movaps [eax],xmm0

    movaps xmm1,[ebx+16]
    divps xmm1,[edx+16]
    movaps [eax+16],xmm1

    movaps xmm2,[ebx+32]
    divps xmm2,[edx+32]
    movaps [eax+32],xmm2

    movaps xmm3,[ebx+48]
    divps xmm3,[edx+48]
    movaps [eax+48],xmm3

    add eax,64
    add edx,64
    add ebx,64

    dec ecx
    jnz @DivLoop

   @EndDivLoop:

    pop ebx
  end
  else  for i := 0 to Num-1 do V3^[i] := V1^[i] / V2^[i];
end;

procedure SimdScale(const V1, V2: PSingleArray; Coeff: single; Num: integer); // V1 * Coeff -> V2
var i : integer;
begin
  if EnableSSE then
  begin
    for i := 0 to 15 do VX[i] := Coeff;
    asm
    push ebx
    mov ebx,[V1]
    mov eax,[V2]
    mov edx,[VX]
    mov ecx,[Num]

    shr ecx,4  // number of large iterations = number of elements / 16
    jz @EndSclLoop
    @SclLoop:

    movaps xmm4,[edx]
    movaps xmm0,[ebx]
    mulps xmm0,xmm4
    movaps [eax],xmm0

    movaps xmm1,[ebx+16]
    mulps xmm1,xmm4
    movaps [eax+16],xmm1

    movaps xmm2,[ebx+32]
    mulps xmm2,xmm4
    movaps [eax+32],xmm2

    movaps xmm3,[ebx+48]
    mulps xmm3,xmm4
    movaps [eax+48],xmm3

    add eax,64
    add ebx,64

    dec ecx
    jnz @SclLoop

   @EndSclLoop:

    pop ebx
    end;
  end else
    for i := 0 to Num-1 do V2^[i] := V1^[i] * Coeff;
end;

procedure SimdMove(const V1, V2: PSingleArray; Num: integer);
begin
  Move(V1^, V2^, Num * sizeof(single));
end;

procedure SimdZero(const V1: PSingleArray; Num: integer);
begin
 // InitTime;
  if EnableSSE then
  asm
    mov eax,[V1]
    mov ecx,[Num]

    // initialise les registres a zero
    xorps xmm0, xmm0;
    xorps xmm1, xmm1;
    xorps xmm2, xmm2;
    xorps xmm3, xmm3;

    shr ecx,4  // number of large iterations = number of elements / 16

    jz @EndZLoop

   @ZLoop:

    movaps [eax],xmm0
    movaps [eax+16],xmm1
    movaps [eax+32],xmm2
    movaps [eax+48],xmm3

    add eax,64
    dec ecx
    jnz @ZLoop

   @EndZLoop:

  end
  else fillchar(V1^, Num * sizeof(single), 0);
 // EndTime(ProcessTime);
end;


initialization

  EnableSSE := false;

  VX := SimdSingleArray(_VX,  16);

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority      := GetThreadPriority(GetCurrentThread);
  GetCPUSpeed(CpuFreq);

  try
    EnableSSE := false;
    asm
      mov eax, 1               // appel fonction 1 de cpuid  (test jeux d'instructions)
      cpuid                    // ou bien: db $0F,$A2  
      test edx,(1 shl 25)      // test SSE
      jnz @SSEFound
      mov EnableSSE,0
      jmp @END_SSE
    @SSEFound:
      mov EnableSSE,1
    @END_SSE:
    end;
  except
    EnableSSE := false;
  end;

end.
