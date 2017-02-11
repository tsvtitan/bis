unit TestFFTdsp_main;

{ Ce programme teste la FFT en introduisant un signal de test et en comparant
le resultat obtenu avec le resultat attendu. Le calcul est effectue plusieurs
fois pour chaque dimension testee et elabore une moyenne du temps de traitement.}


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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FFTdsp, simd;


type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  V_real, V_imag, V_rsav, V_isav : PDoubleArray;
  P_real, P_imag, P_rsav, P_isav : pointer;


implementation

var
  VdspFFT : TdspFFT;
  V_fft_algorithm: string = 'FFTdsp';
  V_trig_algorithm: string = 'double';

{$R *.dfm}

procedure nothing(n: integer;V_real,V_imag: PDoubleArray);
begin
  ;
end;

function evalcv(vr1, vr2, vr3: variant): variant;
begin
  if vr1 then result := vr2 else result := vr3;
end;




procedure TForm1.Button1Click(Sender: TObject);
var
  n, iterations, i, k, j, logn, speed: longint;
  tk1,tk2 : int64;
  t1, t2, toverhead, re, im: double;
  ssq_errors: double;
  scale: double;

begin
  memo1.Clear;
  GetCpuSpeed(speed);

  // Creation de l'objet FFTdsp
  VdspFFT := TdspFFT.Create;



  // boucle de calcul de la dimension FFT de dimension 6 a 14
  // soit d'une taille de vecteur de 64 a 16384

  for logn := 6 to 14 do
  begin
    n := 1 shl logn;
    ssq_errors := 0;

    // initialisation de la FFT
    VdspFFT.InitFFT(logn);


    // reservation dynamique et raz de la memoire de la FFT (P_real et P_imag)
    // et des vecteurs de sauvegarde (P_rsav et P_isav)
    V_real := SimdDoubleArray(P_real, n);
    V_imag := SimdDoubleArray(P_imag, n);
    V_rsav := SimdDoubleArray(P_rsav, n);
    V_isav := SimdDoubleArray(P_isav, n);

    // calcul des donnees de chargement de la FFT
    V_rsav^[0] := 17.0;
    V_rsav^[n div 2] := 1.0;
    i := 1;
    while (i < n div 2) do
    begin
      V_rsav^[i]     := sin(17 * 3.14159265358979323846 * i / n) / sin(3.14159265358979323846 * i / n);
      V_rsav^[n - i] := sin(17 * 3.14159265358979323846 * i / n) / sin(3.14159265358979323846 * i / n);
      inc(i);
    end;
    for i := 0 to n-1 do V_isav[i] := 0.0;

    // calcul du nombre d'iteration
    iterations := 2 + 1024 * 1024 div n;
    scale := 1.0 / n;

    // date de depart a vide
    GetCpuTicks(tk1);
    t1 := tk1 / speed;

    // duree du traitement a vide (overhead)
    k := 0;
    while (k < iterations) do
    begin
      i := 0;
    // chargement des donnees de la FFT
      while (i < n) do
      begin
        VdspFFT.T_real^[i] := V_rsav^[i];
        VdspFFT.T_imag^[i] := V_isav^[i];
        inc(i);
      end;
      nothing(n,V_real,V_imag);
      inc(k);
    end;

    // date d'arrivee
    GetCpuTicks(tk2);
    t2 := tk2 / speed;
    toverhead := t2 - t1;

    // un petit coup pour reveiller la FFT

    VdspFFT.fft;


    // date de depart reel
    GetCpuTicks(tk1);
    t1 := tk1 / speed;
    k := 0;

    while (k < iterations) do
    begin
      i := 0;
      while (i < n) do
      begin
        VdspFFT.T_real^[i] := V_rsav^[i];
        VdspFFT.T_imag^[i] := V_isav^[i];
        inc(i);
      end;

      VdspFFT.fft;

      inc(k);
    end;
    // date d'arrivee reelle
    GetCpuTicks(tk2);
    t2 := tk2 / speed;


    ssq_errors := 0.0;

    // on calcule l'erreur quadratique moyenne entre le resultat obtenu (F_real et F_imag) et le resultat attendu
    i := 0;
    while (i < n) do
    begin
      // evalcv est la traduction en delphi de la fonction en langage C: "condition ? A : B"
      re := (evalcv((i < n div 2), VdspFFT.F_real^[i] ,VdspFFT.F_real^[n - i])) - (evalcv((((i) < 9) or ((i) > n - 9)),n,0));
      im := (evalcv((i < n div 2), VdspFFT.F_imag^[n - i],-VdspFFT.F_imag^[i])) - (0);
      ssq_errors := ssq_errors + (re * re + im * im);
      inc(i);
    end;

    i := 0;
    while ((1 shl i) < n) do inc(i);
    // calcul duree de la FFT
    tk1 :=  round((t2 - t1 - toverhead) / iterations);

    memo1.Lines.add(format('%-12s  %-8s , dim= %5d ,  t= %4d microsec,  erreur = %4.9f',
     [V_fft_algorithm,V_trig_algorithm,n,tk1, ssq_errors/iterations]));
     
    Application.ProcessMessages;
  end;
end;


procedure TForm1.FormShow(Sender: TObject);
begin
  P_real := nil;
  P_imag := nil;
  P_rsav := nil;
  P_isav := nil;
end;

end.