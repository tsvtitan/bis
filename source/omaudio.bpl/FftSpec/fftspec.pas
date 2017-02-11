{ **************************************************************************** }
{ FileName............: FFTSpec.PAS                                            }
{ Project.............: FFT                                                    }
{ Author(s)...........: M.Majoor                                               }
{ Version.............: 2.00                                                   }
{ Last revision date..: 23 January, 2001                                       }
{ ---------------------------------------------------------------------------- }
{ Calculate FFT spectrum unit.                                                 }
{                                                                              }
{ Version  Date      Comment                                                   }
{ 1.00     19980502  - Initial release                                         }
{ 2.00     20010123  - Recompiled for Delphi 3 and made it up-to-date          }
{                    - Less fixed settings (more dynamic)                      }
{ **************************************************************************** }
unit FftSpec;

interface
type
  TSingleArray  = array[0..$FFFF] of single;                                      { Placeholder }
  PSingleArray  = ^TSingleArray;
  TSmallintArray = array[0..$FFFF] of smallint;                                    { Placeholder }
  FSmallintArray = ^TSmallintArray;
  TByteArray=array[0..$FFFF] of byte;
  PByteArray=^TByteArray;

  SpectrumWindows = (idRectangle, idBlackman, idCos2, idGaussian, idHamming, idKaiser, idTriangle);

var
  BlackmanAlpha : single;
  BlackmanBeta  : single;
  BlackmanGamma : single;
  GaussianAlpha : single;
  HammingAlpha  : single;
  KaiserAlpha   : single;

procedure Spectrum(WindowFunction: SpectrumWindows;
                   DataSize      : word;
                   RealIn        : PSingleArray;
                   RealOut       : PSingleArray); overload;
procedure Spectrum(WindowFunction: SpectrumWindows;
                   DataSize      : word;
                   RealIn        : FSmallintArray;
                   RealOut       : PSingleArray); overload;

procedure CalcWindowFunctions(DataSize: word);

var
  CoherentGain    : array[idRectangle..idTriangle] of single;

implementation
uses SysUtils;

var
   WindowingTables : array[idRectangle..idTriangle] of array[0..$FFFF] of single;
   ReversalBits    : array[0..$FFFF] of word;
   AlphaTable      : array[0..$FFFF] of single;
   BetaTable       : array[0..$FFFF] of single;


{ **************************************************************************** }
{ Params   : <X>       Value to calculate Bessel for                           }
{ Return   : <Result>  Bessel value                                            }
{                                                                              }
{ Descript : Return Bessel result for index X.                                 }
{ Notes    : Bessel is calculated using:                                       }
{            (x^0/1)+(x^2/4)+(x^4/64)+(x^6/2304)+(x^8/14745600).... -> 25 terms}
{            The 'top' numbers increase with 2 for each term or alternatively  }
{            termindex*2. Also it can be seen that the upperterm is everytime  }
{            sqr(x) larger for each term.                                      }
{            This in a way also applies to the bottom numbers. These are       }
{            calculated with:                                                  }
{              sqr( (termindex*2)*(termindex-1)*2) )                           }
{ **************************************************************************** }
function CalcBessel(X: single): single;
var
  PrevBTerm : single;                  { Previous bottom term = (termindex-1)*2 }
  BTerm     : single;                  { Bottom term }
  Terms     : integer;                 { Term loop }
  UTermMult : single;                  { Upper term multiplier }
  UTerm     : single;                  { Upper term }
  CalcResult: single;                  { Result of Bessel function }
begin
  UTermMult  := sqr(X);                { Multiplier upperterm value }
  UTerm      := UTermMult;
  PrevBTerm  := 1;
  CalcResult := 1.0;
  for Terms := 1 to 10 do              { Should be accurate enough }
  begin
    BTerm := (Terms * 2) * PrevBTerm;
    PrevBTerm := BTerm;
    BTerm := sqr(BTerm);
    CalcResult := CalcResult + (UTerm / BTerm);
    UTerm := UTerm * UTermMult;        { Upper term increments }
  end;
  Result := CalcResult;
end;


{ **************************************************************************** }
{ Params   : <Data>    Data to reverse                                         }
{            <NumBits> Number of bits to reverse                               }
{ Return   : <Result>  Reversed bit data                                       }
{                                                                              }
{ Descript : Reverse the bits from indicated bit index.                        }
{ Notes    :                                                                   }
{ **************************************************************************** }
function ReverseBits(Data, NumBits: word): word;
var
  Loop    : word;
  Reversed: word;
begin
  Reversed := 0;
  for Loop := 0 to NumBits-1 do
  begin
    Reversed := (Reversed shl 1) or (Data and $01);
    Data := Data shr 1;
  end;
  Result := Reversed;
end;


{ **************************************************************************** }
{ Params   : <WindowsFunction>  Windowing to perform                           }
{            <DataSize>         Number of data items                           }
{                               MUST be 2^x number (0, 2, 4, 8, 16, 32..)      }                    
{            <RealIn>           Data to process                                }
{ Return   : <RealOut>          Processed data                                 }
{                                                                              }
{ Descript : Calculate FFT followed by spectrum (using reals as input).        }
{ Notes    :                                                                   }
{ **************************************************************************** }
procedure Spectrum(WindowFunction: SpectrumWindows;
                   DataSize      : word;
                   RealIn        : PSingleArray;
                   RealOut       : PSingleArray); overload;
var
  i        : integer;
  j, k, n  : word;
  BlockSize: word;
  BlockEnd : word;
  Alpha    : single;
  Beta     : single;
  Delta_ar : single;
  tr, ti   : single;
  ar, ai   : single;
  ImagOut  : PSingleArray;                { Temporary buffer for imaginary data }
begin
  ImagOut := AllocMem(DataSize * sizeof(single));                              { Allocate and clear }
  try
    for i := 0 to DataSize-1
      do RealOut^[ReversalBits[i]] := RealIn^[i]*WindowingTables[WindowFunction][i];

    BlockEnd  := 1;
    BlockSize := 2;
    while BlockSize <= DataSize do
    begin
      Alpha := AlphaTable[BlockSize-2];
      Beta  := BetaTable [BlockSize-2];
      i := 0;
      while i < DataSize do
      begin
        ar := 1.0;                                           { cos(0) }
        ai := 0.0;                                           { sin(0) }
        j := i;
        for n := 0 to BlockEnd-1 do
        begin
          k  := j + BlockEnd;                                { K  = 0..DataSize-1 }
          tr := ar*RealOut^[k] - ai*ImagOut^[k];             { tr = appr. 0.5 * datainput in realout }
          ti := ar*ImagOut^[k] + ai*RealOut^[k];             { ti = appr. 0.5 * datainput in realout }
          RealOut^[k] := RealOut^[j] - tr;
          ImagOut^[k] := ImagOut^[j] - ti;
          RealOut^[j] := RealOut^[j] + tr;
          ImagOut^[j] := ImagOut^[j] + ti;
          delta_ar := Alpha*ar + Beta*ai;                    { delta_ar = 0..2 }
          ai := ai - (Alpha*ai - Beta*ar);                   { ai = 0..1 }
          ar := ar - Delta_ar;                               { ar = -1..1 }
          inc (j);
        end;
        inc(i, BlockSize);
      end;
      BlockEnd  := BlockSize;
      BlockSize := BlockSize shl 1;
    end;

    { At this point FFT is calculated, now calculate spectrum }
    for i := 0 to DataSize-1 do RealOut^[i] := sqrt (sqr(RealOut^[i]) + sqr(ImagOut^[i])) *
                                               CoherentGain[WindowFunction];
  finally
    FreeMem(ImagOut);
  end;
end;


{ **************************************************************************** }
{ Params   : <WindowsFunction>  Windowing to perform                           }
{            <DataSize>         Number of data items                           }
{                               MUST be 2^x number (0, 2, 4, 8, 16, 32..)      }
{            <RealIn>           Data to process                                }
{ Return   : <RealOut>          Processed data                                 }
{                                                                              }
{ Descript : Calculate FFT followed by spectrum (using integers as input).     }
{ Notes    :                                                                   }
{ **************************************************************************** }
procedure Spectrum(WindowFunction: SpectrumWindows;
                   DataSize      : word;
                   RealIn        : FSmallintArray;
                   RealOut       : PSingleArray); overload;
var
//  i        : smallint;
  i        : word;
  j, k, n  : word;
  BlockSize: word;
  BlockEnd : word;
  Alpha    : single;
  Beta     : single;
  Delta_ar : single;
  tr, ti   : single;
  ar, ai   : single;
  ImagOut  : PSingleArray;                { Temporary buffer for imaginary data }
begin
  ImagOut := AllocMem(DataSize * sizeof(single) );                             { Allocate and clear }
  try
    for i := 0 to DataSize-1
      do RealOut^[ReversalBits[i]] := WindowingTables[WindowFunction][i] * RealIn^[i];

    BlockEnd  := 1;
    BlockSize := 2;
    while BlockSize <= DataSize do
    begin
      Alpha := AlphaTable[BlockSize-2];
      Beta  := BetaTable [BlockSize-2];
      i := 0;
      while i < DataSize do
      begin
        ar := 1.0;                                           { cos(0) }
        ai := 0.0;                                           { sin(0) }
        j := i;
        for n := 0 to BlockEnd-1 do
        begin
          k  := j + BlockEnd;                                { K  = 0..DataSize-1 }
          tr := ar*RealOut^[k] - ai*ImagOut^[k];             { tr = appr. 0.5 * datainput in realout }
          ti := ar*ImagOut^[k] + ai*RealOut^[k];             { ti = appr. 0.5 * datainput in realout }
          RealOut^[k] := RealOut^[j] - tr;
          ImagOut^[k] := ImagOut^[j] - ti;
          RealOut^[j] := RealOut^[j] + tr;
          ImagOut^[j] := ImagOut^[j] + ti;
          Delta_ar := Alpha*ar + Beta*ai;                    { delta_ar = 0..2 }
          ai := ai - (Alpha*ai - Beta*ar);                   { ai = 0..1 }
          ar := ar - Delta_ar;                               { ar = -1..1 }
          inc (j);
        end;
        inc (i, BlockSize);
      end;
      BlockEnd  := BlockSize;
      BlockSize := BlockSize SHL 1;
    end;

    { At this point FFT is calculated, now calculate spectrum }
    for i := 0 to DataSize-1 do RealOut^[i] := sqrt (sqr(RealOut^[i]) + sqr(ImagOut^[i])) *
                                               CoherentGain[WindowFunction];
  finally
    FreeMem(ImagOut);
  end;
end;



{ **************************************************************************** }
{ Params   : <DataSize>  Number of data items                                  }
{                               MUST be 2^x number (0, 2, 4, 8, 16, 32..)      }                            
{ Return   : -                                                                 }
{                                                                              }
{ Descript : Calculate all reversal bits for largest possible size.            }
{ Notes    :                                                                   }
{ **************************************************************************** }
procedure CalcReversalBits(DataSize: word);
var
  Index: integer;
  NrBits: byte;
begin
  NrBits := 255;
  for Index := 0 to 15 do
  begin
    if ($01 shl Index) = DataSize then NrBits := Index;
  end;
  if NrBits=255 then NrBits := 1;
  for Index := 0 to DataSize-1
    do ReversalBits[Index] := ReverseBits(Index, NrBits);
end;


{ **************************************************************************** }
{ Params   : <DataSize>  Number of data items                                  }
{                               MUST be 2^x number (0, 2, 4, 8, 16, 32..)      }
{ Return   : -                                                                 }
{                                                                              }
{ Descript : Calculate Alpha table for largest possible size.                  }
{ Notes    :                                                                   }
{ **************************************************************************** }
procedure CalcAlphaTable(DataSize: word);
var
  Index: integer;
begin
  for Index := 2 to DataSize
    do AlphaTable[Index-2] := 2.0 * sqr( sin ( 0.5 * ((2*pi)/Index) ));
end;


{ **************************************************************************** }
{ Params   : <DataSize>  Number of data items                                  }
{                               MUST be 2^x number (0, 2, 4, 8, 16, 32..)      }                            
{ Return   : -                                                                 }
{                                                                              }
{ Descript : Calculate Beta table for largest possible size.                   }
{ Notes    :                                                                   }
{ **************************************************************************** }
procedure CalcBetaTable(DataSize: word);
var
  Index: integer;
begin
  for Index := 2 to DataSize
    do BetaTable[Index-2] := sin ( ((2*pi)/Index) );
end;


{ **************************************************************************** }
{ Params   : <DataSize>  Number of data items                                  }
{                               MUST be 2^x number (0, 2, 4, 8, 16, 32..)      }
{ Return   : -                                                                 }
{                                                                              }
{ Descript : Calculate windowing multipliers for largest possible size.        }
{ Notes    : Windowing functions:                                              }
{            range n = -N/2 to N/2-1        N = number of samples              }
{                                           n = sampleindex                    }
{            Blackman  : w(n)= alpha+beta*cos((2*pi*n)/N)+gamma*cos((4*pi*n)/N)}
{            CosineBell: w(n)= cos^2(pi*n/N) = 0.5(1+cos(2*pi*n/N))            }
{            Gaussian  : w(n)= exp(-0.5((alpha*n/(N/2))^2))                    }
{            Hamming   : w(n)= x + (1-alpha)cos(2*pi*i/N)                      }
{            Rectangle : w(n)= 1.0                                             }
{            Triangle  : w(n)= 1.0 - (|n|/(N/2))                               }
{            Kaiser    : w(n)= (Bessel( (pi*alpha*sqrt(1-(n/(N/2))^2))) /      }
{                              (Bessel(pi * alpha))                            }
{            Bessel(n) = Bessel function = 1 + (n^2/4) + (n^4/64) +            }
{                        (n^5/2304) + (n^8/14745600)  .... -> 25 terms         }
{ **************************************************************************** }
procedure CalcWindowFunctions(DataSize: word);
var
  Table     : SpectrumWindows;
  Index     : integer;
  CalcResult: single;
  HalfSize  : word;
begin
  if odd(DataSize) then Exit;
  HalfSize := DataSize div 2;
  for Table := idRectangle to idTriangle do                { All windowing functions }
  begin
    CoherentGain[Table] := 0;
    for Index := -HalfSize to HalfSize-1 do
    begin
      case Table of
        idRectangle: CalcResult := 1.0;
        idBlackman : CalcResult := BlackmanAlpha+BlackmanBeta*cos((2*pi*Index)/DataSize)+BlackmanGamma*cos((4*pi*Index)/DataSize);
        idCos2     : CalcResult := 0.5*(1+     cos((2*pi*Index)/DataSize));
        idGaussian : CalcResult := exp(-0.5*sqr((GaussianAlpha*Index)/HalfSize));
        idHamming  : CalcResult := HammingAlpha + (1-HammingAlpha)*cos((2*pi*Index)/DataSize);
        idTriangle : CalcResult := 1.0-(abs(Index)/HalfSize);
        idKaiser   : CalcResult := CalcBessel(pi*KaiserAlpha*sqrt(1-sqr(Index/HalfSize)))/CalcBessel(pi*KaiserAlpha);
        else         CalcResult := 0;
      end;
      WindowingTables[Table][Index+HalfSize] := CalcResult;
      CoherentGain   [Table] := CoherentGain[Table] + CalcResult;;
    end;
  end;
  for Table := idBlackman to idTriangle                    { Reference gain to idRectangle }
    do CoherentGain[Table] := CoherentGain[idRectangle] / CoherentGain[Table];
  CoherentGain[idRectangle] := 1.0;                        { Rectangle is reference }
  CalcReversalBits(DataSize);
  CalcAlphaTable(DataSize);
  CalcBetaTable(DataSize);

end;


initialization
  BlackmanAlpha := 0.42;
  BlackmanBeta  := 0.50;
  BlackmanGamma := 0.08;
  GaussianAlpha := 3.00;
  HammingAlpha  := 0.54;
  KaiserAlpha   := 3.00;

finalization

end.
