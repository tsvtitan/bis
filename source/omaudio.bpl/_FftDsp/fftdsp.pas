unit FFTdsp;


{ pour utiliser la FFT ou l'iFFT (FFT inverse):

 1- Create d'une variable de type TdspFFT
 2- InitFFT avec l'ordre de la FFT (log 2 de la dimension ex: 10 pour dim=1024)
 3- renseigner les vecteurs de donnees T_real et T_Imag
 4- appel FFT
 5- resultats dans F-real et F_imag
 6- resutats dans Magnitude et Angle par l'appel  de CalcMagnitude
 ou
 3- renseigner les vecteurs de donnees F_real et F_Imag
 4- iFFT
 5- resultats dans T-real et T_imag

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

uses
  Windows, SysUtils, Classes, Dialogs, Math, Simd;


const   MaxLength   = 65535;

type

 // TDoubleArray = array [0..MaxLength] of double;
 // PDoubleArray = ^TDoubleArray;


  TdspFFT = class(TObject)
  private
    _T_real, _T_imag, _F_real, _F_imag, _Magnitude, _Angle, _TmpReal, _TmpImag, _BufWork: pointer;
//    TempArraySize:  word;
    fPower, fSizeFFT : integer;
    function IsPowerOfTwo ( x: word ): boolean;
    function NumberOfBitsNeeded ( PowerOfTwo: word ): word;
    function ReverseBits ( index, NumBits: word ): word;
  public
    T_real, T_imag, F_real, F_imag, TmpReal, TmpImag, Magnitude, Angle, BufWork:  PDoubleArray;
    constructor Create;
    procedure InitFFT(value: integer);
    procedure PerformFFT(Src_re, Src_im, Dst_re, Dst_im: PDoubleArray; inv : integer);
    procedure fft;
    procedure ifft;
    procedure CalcMagnitude;
    procedure InvMagnitude;
    procedure CalcFrequency (
      FrequencyIndex: word;     { must be in the range 0 .. SizeFFT-1 }
      var  F_realS: Double;
      var  F_imagS: Double );
    procedure Clear;
    property sPower : integer read fPower;
    property SizeFFT: integer read fSizeFFT;
  end;

implementation


constructor  TdspFFT.Create;
begin
  inherited  Create;
  TmpReal    := nil;
  TmpImag    := nil;
  T_real     := nil;
  T_imag     := nil;
  F_real     := nil;
  F_imag     := nil;
  Magnitude  := nil;
  Angle      := nil;
  _TmpReal   := nil;
  _TmpImag   := nil;
  _T_real    := nil;
  _T_imag    := nil;
  _F_real    := nil;
  _F_imag    := nil;
  _Magnitude := nil;
  _Angle     := nil;
  _BufWork   := nil;

  fSizeFFT := 0;
  InitFFT(6);
end;




procedure TdspFFT.Clear;
var i: integer;
begin
  for i := 0 to fSizeFFT-1 do
  begin
    T_real[i] := 0.0;
    T_imag[i] := 0.0;
    F_real[i] := 0.0;
    F_imag[i] := 0.0;
  end;
end;

procedure TdspFFT.InitFFT(Value: integer);
//var i : integer;
begin
  fPower := Value;
  if Value > 0 then fSizeFFT := 1 shl Value;

  // allocation dynamique de la memoire
  if fSizeFFT > 1 then
  begin
    try
      // Les vecteurs sont alignes sur des adresses multiples de 16
      TmpReal  := SimdDoubleArray(_TmpReal, fSizeFFT);
      TmpImag  := SimdDoubleArray(_TmpImag, fSizeFFT);
      T_real   := SimdDoubleArray(_T_real, fSizeFFT);
      T_imag   := SimdDoubleArray(_T_imag, fSizeFFT);
      F_real   := SimdDoubleArray(_F_real, fSizeFFT);
      F_imag   := SimdDoubleArray(_F_imag, fSizeFFT);
      Magnitude:= SimdDoubleArray(_Magnitude, fSizeFFT);
      Angle    := SimdDoubleArray(_Angle, fSizeFFT);
      BufWork  := SimdDoubleArray(_BufWork, 2* fSizeFFT);
    except
      on EOutOfMemory do
      begin
        fSizeFFT := 0;
        TmpReal      := nil;
        TmpImag      := nil;
        T_real       := nil;
        T_imag       := nil;
        F_real       := nil;
        F_imag       := nil;
        Magnitude    := nil;
        Angle        := nil;
        MessageDlg('Erreur initialisation DspFFT', mtError, [mbOk], 0);
        exit
      end;
    end;
  end;
end;

function TdspFFT.IsPowerOfTwo ( x: word ): boolean;
var   i, y:  word;
begin
    y := 2;
    for i := 1 to 15 do
    begin
        if x = y then
        begin
            IsPowerOfTwo := TRUE;
            exit;
        end;
        y := y SHL 1;
    end;
    IsPowerOfTwo := FALSE;
end;

function TdspFFT.NumberOfBitsNeeded ( PowerOfTwo: word ): word;
var     i: word;
begin
  Result:=0;
    for i := 0 to 16 do
    begin
        if (PowerOfTwo AND (1 SHL i)) <> 0 then
        begin
            NumberOfBitsNeeded := i;
            exit;
        end;
    end;
end;

function TdspFFT.ReverseBits ( index, NumBits: word ): word;
var     i, rev: word;
begin
    rev := 0;
    for i := 0 to NumBits-1 do
    begin
      rev := (rev SHL 1) OR (index AND 1);
      index := index SHR 1;
    end;
    ReverseBits := rev;
end;

procedure TdspFFT.PerformFFT(Src_re, Src_im, Dst_re, Dst_im: PDoubleArray; inv : integer);
var
    NumBits, i, j, k, n, BlockSize, BlockEnd{, mI}: word;
    delta_angle, delta_ar, {maxReal, maxImag, }AngleNumerator: Double;
    alpha, beta: Double;
    tr, ti, ar, ai: Double;
begin
    AngleNumerator := 2*PI*inv;
    NumBits := NumberOfBitsNeeded (fSizeFFT);
   // maxReal := 0.0;
    for i := 0 to fSizeFFT-1 do
    begin
        j := ReverseBits ( i, NumBits );
        Dst_re[j] := Src_re[i];
        Dst_im[j] := Src_im[i];
    end;
    BlockEnd := 1;
    BlockSize := 2;
    while BlockSize <= fSizeFFT do
    begin
        delta_angle := AngleNumerator / BlockSize;
        alpha := sin ( 0.5 * delta_angle );
        alpha := 2.0 * alpha * alpha;
        beta := sin ( delta_angle );
        i := 0;
        while i < fSizeFFT do begin
            ar := 1.0;    (* cos(0) *)
            ai := 0.0;    (* sin(0) *)
            j := i;
            for n := 0 to BlockEnd-1 do
            begin
                k := j + BlockEnd;
                tr := ar*Dst_re[k] - ai*Dst_im[k];
                ti := ar*Dst_im[k] + ai*Dst_re[k];
                Dst_re[k] := Dst_re[j] - tr;
                Dst_im[k] := Dst_im[j] - ti;
                Dst_re[j] := Dst_re[j] + tr;
                Dst_im[j] := Dst_im[j] + ti;
                delta_ar := alpha*ar + beta*ai;
                ai := ai - (alpha*ai - beta*ar);
                ar := ar - delta_ar;
                inc(j);
            end;
            i := i + BlockSize;
        end;
        BlockEnd  := BlockSize;
        BlockSize := BlockSize SHL 1;
    end;
    if (inv = -1) then
    begin
      for i := 0 to  SizeFFT - 1 do
      begin
        Dst_re[i] := Dst_re[i] / SizeFFT;
        Dst_im[i] := Dst_im[i] / SizeFFT;
      end;
    end;
end;

// l'entree est T_real et T_imag et la sortie F_real et F_imag
procedure TdspFFT.fft;
begin
  PerformFFT(T_real, T_imag, F_real, F_imag, 1);
end;


// l'entree est F_real et F_imag et la sortie  T_real et T_imag
procedure TdspFFT.ifft;
{var
  i: word;}
begin
  PerformFFT(F_real, F_imag, T_real, T_imag, -1);
end;


procedure TdspFFT.CalcFrequency (
    FrequencyIndex: word;   { doit etre dans la fourchette 0 .. fSizeFFT-1 }
    var  F_realS: Double;
    var  F_imagS: Double );
var
    k: word;
    cos1, cos2, cos3, theta, beta: Double;
    sin1, sin2, sin3: Double;
begin
    F_realS := 0.0;
    F_imagS := 0.0;
    theta := 2*PI * FrequencyIndex / fSizeFFT;
    sin1 := sin ( -2 * theta );
    sin2 := sin ( -theta );
    cos1 := cos ( -2 * theta );
    cos2 := cos ( -theta );
    beta := 2 * cos2;
    for k := 0 to fSizeFFT-1 do
    begin
      sin3 := beta*sin2 - sin1;
      sin1 := sin2;
      sin2 := sin3;
      cos3 := beta*cos2 - cos1;
      cos1 := cos2;
      cos2 := cos3;
      F_realS := F_realS + T_real[k]*cos3 - T_imag[k]*sin3;
      F_imagS := F_imagS + T_imag[k]*cos3 + T_real[k]*sin3;
    end;
end;

// permet de calculer l'amplitude et la phase de chaque frequence
procedure TdspFFT.CalcMagnitude;
var i : integer;
begin
  for i := 0 to fSizeFFT-1 do
  begin
    Magnitude[i] := sqrt ( F_real[i]*F_real[i] + F_imag[i]*F_imag[i] );
    Angle[i] := arctan2 ( F_imag[i], F_real[i] );
  end;
end;

// fait l'inverse
procedure TdspFFT.InvMagnitude;
var i : integer;
begin
  for i := 0 to fSizeFFT-1 do
  begin
    F_real[i] := magnitude[i] * cos(angle[i]);
    F_imag[i] := magnitude[i] * sin(angle[i]);
  end;
end;




end.
