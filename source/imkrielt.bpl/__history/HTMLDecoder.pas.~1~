unit HTMLDecoder;
    {*****************************************************************************************************}
    {**************                                                                     ******************}
    {**************                 Progsan Internet User Agent Components              ******************}
    {**************                     Implements HTML 4.01 DOM API                    ******************}
    {**************                     SUPPORTS HTTP 1.1 [RFC 2616]                    ******************}
    {**************                                                                     ******************}
    {**************          Author : Erdal Payat [ epayat@progsan.com ]                ******************}
    {**************       Copyright Progsan® Software Gmbh All Rights Reserved          ******************}
    {**************                                                                     ******************}
    {**************                    http://www.progsan.com                           ******************}
    {**************                                                                     ******************}
    {*****************************************************************************************************}
interface

{$HINTS OFF}
uses classes,windows,Sysutils,contnrs,wininet,PRInternetAccess,IdGlobal,IdURI;
resourcestring
  sEventParsingDocument       = 'Parsing Document...';
  sEventBuildingDocument      = 'Building Document...';                              
  sEventProcessingMetaRefresh = 'Sleeping %d / %d seconds...';
  sEventDocDownloaded         = 'HTML Document downlaod complete.';
  sExceptionNotImplemented    = '%s not yet implemented in %s class';
  sExceptionInvalidBodyElement= 'Invalid Body Element.';
  sExceptionCouldNotFindTable = 'cannot find Table Object for Table Row tag : %s';

  SCannotConvert           = 'Unicode code point $%x has no equivalent in %s';
  SCannotConvertUCS4       = 'Cannot convert $%8.8X to %s';
  SHighSurrogateNotFound   = 'High surrogate not found';
  SInvalidCodePoint        = '$%x is not a valid %s code point';
  SInvalidEncoding         = 'Invalid %s encoding';
  SLongStringConvertError  = 'Long string conversion error';
  SLowSurrogateNotFound    = 'Low surrogate not found';
  SSurrogateNotAllowed     = 'Surrogate value $%x found in %s. Values between $D800 and $DFFF are reserved for use with UTF-16';
  SEncodingOutOfRange      = '%s encoding out of range';
  SUTF8Error               = 'UTF-8 error %d';

type
  TUTF8Error = (
      UTF8ErrorNone,
      UTF8ErrorInvalidEncoding,
      UTF8ErrorIncompleteEncoding,
      UTF8ErrorInvalidBuffer,
      UTF8ErrorOutOfRange );

  THTMLSpecChItem=array[1..2] of string;
const
  MAX_ALLOWED_PROBLEM_FIXES = 64; // max number of allowed problem fixes to prevent deadlock
  c_MAX_RECURSION_COUNT = 16;//  Max number  of allowed recursions to prevent deadlock
  ERROR_HTML_PARSING_UNKNOWN_EXCEPTION   = $1000;
  ERROR_HTML_PARSING_MISSING_END_TAG     = $1001;
  ERROR_HTML_PARSING_MISSING_BEGIN_TAG   = $1002;
  ERROR_HTML_PARSING_INVALID_PARENT      = $1003;
  c_HTMLSpecChIds : array[byte] of string =(
    {?} '&#00;',  // '---'    //Unused
    {?} '&#01;',  // '---'    //Unused
    {?} '&#02;',  // '---'    //Unused
    {?} '&#03;',  // '---'    //Unused
    {?} '&#04;',  // '---'    //Unused
    {?} '&#05;',  // '---'    //Unused
    {?} '&#06;',  // '---'    //Unused
    {?} '&#07;',  // '---'    //Unused
    {?} '&#08;',  // '---'    //Unused
    {?} '&#09;',  // '---'    //Horizontal tab
    {?} '&#10;',  // '---'    //Line feed
    {?} '&#11;',  // '---'    //Unused
    {?} '&#12;',  // '---'    //Unused
    {?} '&#13;',  // '---'    //Carriage Return
    {?} '&#14;',  // '---'    //Unused
    {?} '&#15;',  // '---'    //Unused
    {?} '&#16;',  // '---'    //Unused
    {?} '&#17;',  // '---'    //Unused
    {?} '&#18;',  // '---'    //Unused
    {?} '&#19;',  // '---'    //Unused
    {?} '&#20;',  // '---'    //Unused
    {?} '&#21;',  // '---'    //Unused
    {?} '&#22;',  // '---'    //Unused
    {?} '&#23;',  // '---'    //Unused
    {?} '&#24;',  // '---'    //Unused
    {?} '&#25;',  // '---'    //Unused
    {?} '&#26;',  // '---'    //Unused
    {?} '&#27;',  // '---'    //Unused
    {?} '&#28;',  // '---'    //Unused
    {?} '&#29;',  // '---'    //Unused
    {?} '&#30;',  // '---'    //Unused
    {?} '&#31;',  // '---'    //Unused
    {?} '&#32;',  // '---'    //Unused
    {?} '&#33;',  // '---'    //Unused
    {"} '&#34;',  // '&quot;' //Quotation mark
    {#} '&#35;',  // '---'    //Number sign
    { } '&#36;',  // '---'    //Dollar sign
    {%} '&#37;',  // '---'    //Percent sign
    {&} '&#38;',  // '&amp;'  //Ampersand
    {'} '&#39;',  // '---'    //Apostrophe
    {(} '&#40;',  // '---'    //Left parenthesis
    {)} '&#41;',  // '---'    //Right parenthesis
    {*} '&#42;',  // '---'    //Asterisk
    {+} '&#43;',  // '---'    //Plus sign
    {,} '&#44;',  // '---'    //Comma
    {-} '&#45;',  // '---'    //Hyphen
    {.} '&#46;',  // '---'    //Period (fullstop)
    {/} '&#47;',  // '---'    //Solidus (slash)
    {0} '&#48;',  // '---'    //Digit 0
    {1} '&#49;',  // '---'    //Digit 1
    {2} '&#50;',  // '---'    //Digit 2
    {3} '&#51;',  // '---'    //Digit 3
    {4} '&#52;',  // '---'    //Digit 4
    {5} '&#53;',  // '---'    //Digit 5
    {6} '&#54;',  // '---'    //Digit 6
    {7} '&#55;',  // '---'    //Digit 7
    {8} '&#56;',  // '---'    //Digit 8
    {9} '&#57;',  // '---'    //Digit 9
    {:} '&#58;',  // '---'    //Colon
    {;} '&#59;',  // '---'    //Semicolon
    {<} '&#60;',  // '&lt;'   //Less than
    {=} '&#61;',  // '---'    //Equals sign
    {>} '&#62;',  // '&gt;'   //Greater than
    {?} '&#63;',  // '---'    //Question mark
    {@} '&#64;',  // '---'    //Commercial at
    {A} '&#65;',  // '---'    //Capital A
    {B} '&#66;',  // '---'    //Capital B
    {C} '&#67;',  // '---'    //Capital C
    {D} '&#68;',  // '---'    //Capital D
    {E} '&#69;',  // '---'    //Capital E
    {F} '&#70;',  // '---'    //Capital F
    {G} '&#71;',  // '---'    //Capital G
    {H} '&#72;',  // '---'    //Capital H
    {I} '&#73;',  // '---'    //Capital I
    {J} '&#74;',  // '---'    //Capital J
    {K} '&#75;',  // '---'    //Capital K
    {L} '&#76;',  // '---'    //Capital L
    {M} '&#77;',  // '---'    //Capital M
    {N} '&#78;',  // '---'    //Capital N
    {O} '&#79;',  // '---'    //Capital O
    {P} '&#80;',  // '---'    //Capital P
    {Q} '&#81;',  // '---'    //Capital Q
    {R} '&#82;',  // '---'    //Capital R
    {S} '&#83;',  // '---'    //Capital S
    {T} '&#84;',  // '---'    //Capital T
    {U} '&#85;',  // '---'    //Capital U
    {V} '&#86;',  // '---'    //Capital V
    {W} '&#87;',  // '---'    //Capital W
    {X} '&#88;',  // '---'    //Capital X
    {Y} '&#89;',  // '---'    //Capital Y
    {Z} '&#90;',  // '---'    //Capital Z
    {[} '&#91;',  // '---'    //Left square bracket
    {\} '&#92;',  // '---'    //Reverse solidus (backslash)
    {]} '&#93;',  // '---'    //Right square bracket
    {^} '&#94;',  // '---'    //Caret
    {_} '&#95;',  // '---'    //Horizontal bar (underscore)
    {`} '&#96;',  // '---'    //Acute accent
    {a} '&#97;',  // '---'    //Small a
    {b} '&#98;',  // '---'    //Small b
    {c} '&#99;',  // '---'    //Small c
    {d} '&#100;',  // '---'   //Small d
    {e} '&#101;',  // '---'   //Small e
    {f} '&#102;',  // '---'   //Small f
    {g} '&#103;',  // '---'   //Small g
    {h} '&#104;',  // '---'   //Small h
    {i} '&#105;',  // '---'   //Small i
    {j} '&#106;',  // '---'   //Small j
    {k} '&#107;',  // '---'   //Small k
    {l} '&#108;',  // '---'   //Small l
    {m} '&#109;',  // '---'   //Small m
    {n} '&#110;',  // '---'   //Small n
    {o} '&#111;',  // '---'   //Small o
    {p} '&#112;',  // '---'   //Small p
    {q} '&#113;',  // '---'   //Small q
    {r} '&#114;',  // '---'   //Small r
    {s} '&#115;',  // '---'   //Small s
    {t} '&#116;',  // '---'   //Small t
    {u} '&#117;',  // '---'   //Small u
    {v} '&#118;',  // '---'   //Small v
    {w} '&#119;',  // '---'   //Small w
    {x} '&#120;',  // '---'   //Small x
    {y} '&#121;',  // '---'   //Small y
    {z} '&#122;',  // '---'   //Small z
    { } '&#123;',  // '---'   //Left curly brace
    {|} '&#124;',  // '---'   //Vertical bar
    { } '&#125;',  // '---'   //Right curly brace
    {~} '&#126;',  // '---'   //Tilde
    {} '&#127;',  // '---'   //Unused
    {€} '&#128;',  // '&euro;'   //Euro
    {?} '&#129;',  // '---'   //Unused
    {?} '&#130;',  // '---'   //Unused
    {?} '&#131;',  // '---'   //Unused
    {?} '&#132;',  // '---'   //Unused
    {?} '&#133;',  // '---'   //Unused
    {?} '&#134;',  // '---'   //Unused
    {?} '&#135;',  // '---'   //Unused
    {?} '&#136;',  // '---'   //Unused
    {?} '&#137;',  // '---'   //Unused
    {?} '&#138;',  // '---'   //Unused
    {?} '&#139;',  // '---'   //Unused
    {?} '&#140;',  // '---'   //Unused
    {?} '&#141;',  // '---'   //Unused
    {?} '&#142;',  // '---'   //Unused
    {?} '&#143;',  // '---'   //Unused
    {?} '&#144;',  // '---'   //Unused
    {?} '&#145;',  // '---'   //Unused
    {?} '&#146;',  // '---'   //Unused
    {?} '&#147;',  // '---'   //Unused
    {?} '&#148;',  // '---'   //Unused
    {?} '&#149;',  // '---'   //Unused
    {-} '&#150;',  // '---'   // minus sign
    {?} '&#151;',  // '---'   //Unused
    {?} '&#152;',  // '---'   //Unused
    {?} '&#153;',  // '---'   //Unused
    {?} '&#154;',  // '---'   //Unused
    {?} '&#155;',  // '---'   //Unused
    {?} '&#156;',  // '---'   //Unused
    {?} '&#157;',  // '---'   //Unused
    {?} '&#158;',  // '---'   //Unused
    {?} '&#159;',  // '---'   //Unused
    { } '&#160;',  // '&nbsp;'    //Nonbreaking space
    {¡} '&#161;',  // '&iexcl;'   //Inverted exclamation
    {¢} '&#162;',  // '&cent;'    //Cent sign
    {£} '&#163;',  // '&pound;'   //Pound sterling
    {¤} '&#164;',  // '&curren;'  //General currency sign
    {¥} '&#165;',  // '&yen;'     //Yen sign
    {¦} '&#166;',  // '&brkbar;'  //Broken vertical bar
    {§} '&#167;',  // '&sect;'    //Section sign
    {¨} '&#168;',  // '&uml;'     //Diæresis / Umlaut
    {©} '&#169;',  // '&copy;'    //Copyright
    {ª} '&#170;',  // '&ordf;'    //Feminine ordinal
    {«} '&#171;',  // '&laquo;'   //Left angle quote, guillemot left
    {¬} '&#172;',  // '&not       //Not sign
    {­} '&#173;',  // '&shy;'     //Soft hyphen
    {®} '&#174;',  // '&reg;'     //Registered trademark
    {¯} '&#175;',  // '&macr;'    //Macron accent
    {°} '&#176;',  // '&deg;'     //Degree sign
    {±} '&#177;',  // '&plusmn;'  //Plus or minus
    {²} '&#178;',  // '&sup2;'    //Superscript two
    {³} '&#179;',  // '&sup3;'    //Superscript three
    {´} '&#180;',  // '&acute;'   //Acute accent
    {µ} '&#181;',  // '&micro;'   //Micro sign
    {¶} '&#182;',  // '&para;'    //Paragraph sign
    {·} '&#183;',  // '&middot;'  //Middle dot
    {¸} '&#184;',  // '&cedil;'   //Cedilla
    {¹} '&#185;',  // '&sup1;'    //Superscript one
    {º} '&#186;',  // '&ordm;'    //Masculine ordinal
    {»} '&#187;',  // '&raquo;'   //Right angle quote, guillemot right
    {¼} '&#188;',  // '&frac14;'  //Fraction one-fourth
    {½} '&#189;',  // '&frac12;'  //Fraction one-half
    {¾} '&#190;',  // '&frac34;'  //Fraction three-fourths
    {¿} '&#191;',  // '&iquest;'  //Inverted question mark
    {À} '&#192;',  // '&Agrave;'  //Capital A, grave accent
    {Á} '&#193;',  // '&Aacute;'  //Capital A, acute accent
    {Â} '&#194;',  // '&Acirc;'   //Capital A, circumflex
    {Ã} '&#195;',  // '&Atilde;'  //Capital A, tilde
    {Ä} '&#196;',  // '&Auml;'    //Capital A, diæresis / umlaut
    {Å} '&#197;',  // '&Aring;'   //Capital A, ring
    {Æ} '&#198;',  // '&AElig;'   //Capital AE ligature
    {Ç} '&#199;',  // '&Ccedil;'  //Capital C, cedilla
    {È} '&#200;',  // '&Egrave;'  //Capital E, grave accent
    {É} '&#201;',  // '&Eacute;'  //Capital E, acute accent
    {Ê} '&#202;',  // '&Ecirc;'   //Capital E, circumflex
    {Ë} '&#203;',  // '&Euml;'    //Capital E, diæresis / umlaut
    {Ì} '&#204;',  // '&Igrave;'  //Capital I, grave accent
    {Í} '&#205;',  // '&Iacute;'  //Capital I, acute accent
    {Î} '&#206;',  // '&Icirc;'   //Capital I, circumflex
    {Ï} '&#207;',  // '&Iuml;'    //Capital I, diæresis / umlaut
    {Ð} '&#208;',  // '&ETH;'     //Capital Eth, Icelandic
    {Ñ} '&#209;',  // '&Ntilde;'  //Capital N, tilde
    {Ò} '&#210;',  // '&Ograve;'  //Capital O, grave accent
    {Ó} '&#211;',  // '&Oacute;'  //Capital O, acute accent
    {Ô} '&#212;',  // '&Ocirc;'   //Capital O, circumflex
    {Õ} '&#213;',  // '&Otilde;'  //Capital O, tilde
    {Ö} '&#214;',  // '&Ouml;'    //Capital O, diæresis / umlaut
    {×} '&#215;',  // '&times;'   //Multiply sign
    {Ø} '&#216;',  // '&Oslash;'  //Capital O, slash
    {Ù} '&#217;',  // '&Ugrave;'  //Capital U, grave accent
    {Ú} '&#218;',  // '&Uacute;'  //Capital U, acute accent
    {Û} '&#219;',  // '&Ucirc;'   //Capital U, circumflex
    {Ü} '&#220;',  // '&Uuml;'    //Capital U, diæresis / umlaut
    {Ý} '&#221;',  // '&Yacute;'  //Capital Y, acute accent
    {Þ} '&#222;',  // '&THORN;'   //Capital Thorn, Icelandic
    {ß} '&#223;',  // '&szlig;'   //Small sharp s, German sz
    {à} '&#224;',  // '&agrave;'  //Small a, grave accent
    {á} '&#225;',  // '&aacute;'  //Small a, acute accent
    {â} '&#226;',  // '&acirc;'   //Small a, circumflex
    {ã} '&#227;',  // '&atilde;'  //Small a, tilde
    {ä} '&#228;',  // '&auml;'    //Small a, diæresis / umlaut
    {å} '&#229;',  // '&aring;'   //Small a, ring
    {æ} '&#230;',  // '&aelig;'   //Small ae ligature
    {ç} '&#231;',  // '&ccedil;'  //Small c, cedilla
    {è} '&#232;',  // '&egrave;'  //Small e, grave accent
    {é} '&#233;',  // '&eacute;'  //Small e, acute accent
    {ê} '&#234;',  // '&ecirc;'   //Small e, circumflex
    {ë} '&#235;',  // '&euml;'    //Small e, diæresis / umlaut
    {ì} '&#236;',  // '&igrave;'  //Small i, grave accent
    {í} '&#237;',  // '&iacute;'  //Small i, acute accent
    {î} '&#238;',  // '&icirc;'   //Small i, circumflex
    {ï} '&#239;',  // '&iuml;'    //Small i, diæresis / umlaut
    {ð} '&#240;',  // '&eth;'     //Small eth, Icelandic
    {ñ} '&#241;',  // '&ntilde;'  //Small n, tilde
    {ò} '&#242;',  // '&ograve;'  //Small o, grave accent
    {ó} '&#243;',  // '&oacute;'  //Small o, acute accent
    {ô} '&#244;',  // '&ocirc;'   //Small o, circumflex
    {õ} '&#245;',  // '&otilde;'  //Small o, tilde
    {ö} '&#246;',  // '&ouml;'    //Small o, diæresis / umlaut
    {÷} '&#247;',  // '&divide;'  //Division sign
    {ø} '&#248;',  // '&oslash;'  //Small o, slash
    {ù} '&#249;',  // '&ugrave;'  //Small u, grave accent
    {ú} '&#250;',  // '&uacute;'  //Small u, acute accent
    {û} '&#251;',  // '&ucirc;'   //Small u, circumflex
    {ü} '&#252;',  // '&uuml;'    //Small u, diæresis / umlaut
    {ý} '&#253;',  // '&yacute;'  //Small y, acute accent
    {þ} '&#254;',  // '&thorn;'   //Small thorn, Icelandic
    {ÿ} //'&#255;',  // '&yuml;'    //Small y, diæresis / umlaut
    {€} '&#8364;'  // '&euro;'    //EURO (€)
  );

  c_HTMLSpecChNames : array[byte] of string =(
    {?} {'&#00;'}  '---'    //Unused
    {?} {'&#01;'} ,'---'    //Unused
    {?} {'&#02;'} ,'---'    //Unused
    {?} {'&#03;'} ,'---'    //Unused
    {?} {'&#04;'} ,'---'    //Unused
    {?} {'&#05;'} ,'---'    //Unused
    {?} {'&#06;'} ,'---'    //Unused
    {?} {'&#07;'} ,'---'    //Unused
    {?} {'&#08;'} ,'---'    //Unused
    {?} {'&#09;'} ,'---'    //Horizontal tab
    {?} {'&#10;'} ,'---'    //Line feed
    {?} {'&#11;'} ,'---'    //Unused
    {?} {'&#12;'} ,'---'    //Unused
    {?} {'&#13;'} ,'---'    //Carriage Return
    {?} {'&#14;'} ,'---'    //Unused
    {?} {'&#15;'} ,'---'    //Unused
    {?} {'&#16;'} ,'---'    //Unused
    {?} {'&#17;'} ,'---'    //Unused
    {?} {'&#18;'} ,'---'    //Unused
    {?} {'&#19;'} ,'---'    //Unused
    {?} {'&#20;'} ,'---'    //Unused
    {?} {'&#21;'} ,'---'    //Unused
    {?} {'&#22;'} ,'---'    //Unused
    {?} {'&#23;'} ,'---'    //Unused
    {?} {'&#24;'} ,'---'    //Unused
    {?} {'&#25;'} ,'---'    //Unused
    {?} {'&#26;'} ,'---'    //Unused
    {?} {'&#27;'} ,'---'    //Unused
    {?} {'&#28;'} ,'---'    //Unused
    {?} {'&#29;'} ,'---'    //Unused
    {?} {'&#30;'} ,'---'    //Unused
    {?} {'&#31;'} ,'---'    //Unused
    {?} {'&#32;'} ,'---'    //Unused
    {?} {'&#33;'} ,'---'    //Unused
    {"} {'&#34;'} ,'&quot;' //Quotation mark
    {#} {'&#35;'} ,'---'    //Number sign
    { } {'&#36;'} ,'---'    //Dollar sign
    {%} {'&#37;'} ,'---'    //Percent sign
    {&} {'&#38;'} ,'&amp;'  //Ampersand
    {'} {'&#39;'} ,'---'    //Apostrophe
    {(} {'&#40;'} ,'---'    //Left parenthesis
    {)} {'&#41;'} ,'---'    //Right parenthesis
    {*} {'&#42;'} ,'---'    //Asterisk
    {+} {'&#43;'} ,'---'    //Plus sign
    {,} {'&#44;'} ,'---'    //Comma
    {-} {'&#45;'} ,'---'    //Hyphen
    {.} {'&#46;'} ,'---'    //Period (fullstop)
    {/} {'&#47;'} ,'---'    //Solidus (slash)
    {0} {'&#48;'} ,'---'    //Digit 0
    {1} {'&#49;'} ,'---'    //Digit 1
    {2} {'&#50;'} ,'---'    //Digit 2
    {3} {'&#51;'} ,'---'    //Digit 3
    {4} {'&#52;'} ,'---'    //Digit 4
    {5} {'&#53;'} ,'---'    //Digit 5
    {6} {'&#54;'} ,'---'    //Digit 6
    {7} {'&#55;'} ,'---'    //Digit 7
    {8} {'&#56;'} ,'---'    //Digit 8
    {9} {'&#57;'} ,'---'    //Digit 9
    {:} {'&#58;'} ,'---'    //Colon
    {;} {'&#59;'} ,'---'    //Semicolon
    {<} {'&#60;'} ,'&lt;'   //Less than
    {=} {'&#61;'} ,'---'    //Equals sign
    {>} {'&#62;'} ,'&gt;'   //Greater than
    {?} {'&#63;'} ,'---'    //Question mark
    {@} {'&#64;'} ,'---'    //Commercial at
    {A} {'&#65;'} ,'---'    //Capital A
    {B} {'&#66;'} ,'---'    //Capital B
    {C} {'&#67;'} ,'---'    //Capital C
    {D} {'&#68;'} ,'---'    //Capital D
    {E} {'&#69;'} ,'---'    //Capital E
    {F} {'&#70;'} ,'---'    //Capital F
    {G} {'&#71;'} ,'---'    //Capital G
    {H} {'&#72;'} ,'---'    //Capital H
    {I} {'&#73;'} ,'---'    //Capital I
    {J} {'&#74;'} ,'---'    //Capital J
    {K} {'&#75;'} ,'---'    //Capital K
    {L} {'&#76;'} ,'---'    //Capital L
    {M} {'&#77;'} ,'---'    //Capital M
    {N} {'&#78;'} ,'---'    //Capital N
    {O} {'&#79;'} ,'---'    //Capital O
    {P} {'&#80;'} ,'---'    //Capital P
    {Q} {'&#81;'} ,'---'    //Capital Q
    {R} {'&#82;'} ,'---'    //Capital R
    {S} {'&#83;'} ,'---'    //Capital S
    {T} {'&#84;'} ,'---'    //Capital T
    {U} {'&#85;'} ,'---'    //Capital U
    {V} {'&#86;'} ,'---'    //Capital V
    {W} {'&#87;'} ,'---'    //Capital W
    {X} {'&#88;'} ,'---'    //Capital X
    {Y} {'&#89;'} ,'---'    //Capital Y
    {Z} {'&#90;'} ,'---'    //Capital Z
    {[} {'&#91;'} ,'---'    //Left square bracket
    {\} {'&#92;'} ,'---'    //Reverse solidus (backslash)
    {]} {'&#93;'} ,'---'    //Right square bracket
    {^} {'&#94;'} ,'---'    //Caret
    {_} {'&#95;'} ,'---'    //Horizontal bar (underscore)
    {`} {'&#96;'} ,'---'    //Acute accent
    {a} {'&#97;'} ,'---'    //Small a
    {b} {'&#98;'} ,'---'    //Small b
    {c} {'&#99;'} ,'---'    //Small c
    {d} {'&#100;'} ,'---'   //Small d
    {e} {'&#101;'} ,'---'   //Small e
    {f} {'&#102;'} ,'---'   //Small f
    {g} {'&#103;'} ,'---'   //Small g
    {h} {'&#104;'} ,'---'   //Small h
    {i} {'&#105;'} ,'---'   //Small i
    {j} {'&#106;'} ,'---'   //Small j
    {k} {'&#107;'} ,'---'   //Small k
    {l} {'&#108;'} ,'---'   //Small l
    {m} {'&#109;'} ,'---'   //Small m
    {n} {'&#110;'} ,'---'   //Small n
    {o} {'&#111;'} ,'---'   //Small o
    {p} {'&#112;'} ,'---'   //Small p
    {q} {'&#113;'} ,'---'   //Small q
    {r} {'&#114;'} ,'---'   //Small r
    {s} {'&#115;'} ,'---'   //Small s
    {t} {'&#116;'} ,'---'   //Small t
    {u} {'&#117;'} ,'---'   //Small u
    {v} {'&#118;'} ,'---'   //Small v
    {w} {'&#119;'} ,'---'   //Small w
    {x} {'&#120;'} ,'---'   //Small x
    {y} {'&#121;'} ,'---'   //Small y
    {z} {'&#122;'} ,'---'   //Small z
    { } {'&#123;'} ,'---'   //Left curly brace
    {|} {'&#124;'} ,'---'   //Vertical bar
    { } {'&#125;'} ,'---'   //Right curly brace
    {~} {'&#126;'} ,'---'   //Tilde
    {} {'&#127;'} ,'---'   //Unused
    {€} {'&#128;'} ,'&euro;'   //Euro
    {?} {'&#129;'} ,'---'   //Unused
    {?} {'&#130;'} ,'---'   //Unused
    {?} {'&#131;'} ,'---'   //Unused
    {?} {'&#132;'} ,'---'   //Unused
    {?} {'&#133;'} ,'---'   //Unused
    {?} {'&#134;'} ,'---'   //Unused
    {?} {'&#135;'} ,'---'   //Unused
    {?} {'&#136;'} ,'---'   //Unused
    {?} {'&#137;'} ,'---'   //Unused
    {?} {'&#138;'} ,'---'   //Unused
    {?} {'&#139;'} ,'---'   //Unused
    {?} {'&#140;'} ,'---'   //Unused
    {?} {'&#141;'} ,'---'   //Unused
    {?} {'&#142;'} ,'---'   //Unused
    {?} {'&#143;'} ,'---'   //Unused
    {?} {'&#144;'} ,'---'   //Unused
    {?} {'&#145;'} ,'---'   //Unused
    {?} {'&#146;'} ,'---'   //Unused
    {?} {'&#147;'} ,'---'   //Unused
    {?} {'&#148;'} ,'---'   //Unused
    {?} {'&#149;'} ,'---'   //Unused
    {-} {'&#150;'} ,'-'     //minus sign
    {?} {'&#151;'} ,'---'   //Unused
    {?} {'&#152;'} ,'---'   //Unused
    {?} {'&#153;'} ,'---'   //Unused
    {?} {'&#154;'} ,'---'   //Unused
    {?} {'&#155;'} ,'---'   //Unused
    {?} {'&#156;'} ,'---'   //Unused
    {?} {'&#157;'} ,'---'   //Unused
    {?} {'&#158;'} ,'---'   //Unused
    {?} {'&#159;'} ,'---'   //Unused
    { } {'&#160;'} ,'&nbsp;'    //Nonbreaking space
    {¡} {'&#161;'} ,'&iexcl;'   //Inverted exclamation
    {¢} {'&#162;'} ,'&cent;'    //Cent sign
    {£} {'&#163;'} ,'&pound;'   //Pound sterling
    {¤} {'&#164;'} ,'&curren;'  //General currency sign
    {¥} {'&#165;'} ,'&yen;'     //Yen sign
    {¦} {'&#166;'} ,'&brkbar;'  //Broken vertical bar
    {§} {'&#167;'} ,'&sect;'    //Section sign
    {¨} {'&#168;'} ,'&uml;'     //Diæresis / Umlaut
    {©} {'&#169;'} ,'&copy;'    //Copyright
    {ª} {'&#170;'} ,'&ordf;'    //Feminine ordinal
    {«} {'&#171;'} ,'&laquo;'   //Left angle quote, guillemot left
    {¬} {'&#172;'} ,'&not;'     //Not sign
    {­} {'&#173;'} ,'&shy;'     //Soft hyphen
    {®} {'&#174;'} ,'&reg;'     //Registered trademark
    {¯} {'&#175;'} ,'&macr;'    //Macron accent
    {°} {'&#176;'} ,'&deg;'     //Degree sign
    {±} {'&#177;'} ,'&plusmn;'  //Plus or minus
    {²} {'&#178;'} ,'&sup2;'    //Superscript two
    {³} {'&#179;'} ,'&sup3;'    //Superscript three
    {´} {'&#180;'} ,'&acute;'   //Acute accent
    {µ} {'&#181;'} ,'&micro;'   //Micro sign
    {¶} {'&#182;'} ,'&para;'    //Paragraph sign
    {·} {'&#183;'} ,'&middot;'  //Middle dot
    {¸} {'&#184;'} ,'&cedil;'   //Cedilla
    {¹} {'&#185;'} ,'&sup1;'    //Superscript one
    {º} {'&#186;'} ,'&ordm;'    //Masculine ordinal
    {»} {'&#187;'} ,'&raquo;'   //Right angle quote, guillemot right
    {¼} {'&#188;'} ,'&frac14;'  //Fraction one-fourth
    {½} {'&#189;'} ,'&frac12;'  //Fraction one-half
    {¾} {'&#190;'} ,'&frac34;'  //Fraction three-fourths
    {¿} {'&#191;'} ,'&iquest;'  //Inverted question mark
    {À} {'&#192;'} ,'&Agrave;'  //Capital A, grave accent
    {Á} {'&#193;'} ,'&Aacute;'  //Capital A, acute accent
    {Â} {'&#194;'} ,'&Acirc;'   //Capital A, circumflex
    {Ã} {'&#195;'} ,'&Atilde;'  //Capital A, tilde
    {Ä} {'&#196;'} ,'&Auml;'    //Capital A, diæresis / umlaut
    {Å} {'&#197;'} ,'&Aring;'   //Capital A, ring
    {Æ} {'&#198;'} ,'&AElig;'   //Capital AE ligature
    {Ç} {'&#199;'} ,'&Ccedil;'  //Capital C, cedilla
    {È} {'&#200;'} ,'&Egrave;'  //Capital E, grave accent
    {É} {'&#201;'} ,'&Eacute;'  //Capital E, acute accent
    {Ê} {'&#202;'} ,'&Ecirc;'   //Capital E, circumflex
    {Ë} {'&#203;'} ,'&Euml;'    //Capital E, diæresis / umlaut
    {Ì} {'&#204;'} ,'&Igrave;'  //Capital I, grave accent
    {Í} {'&#205;'} ,'&Iacute;'  //Capital I, acute accent
    {Î} {'&#206;'} ,'&Icirc;'   //Capital I, circumflex
    {Ï} {'&#207;'} ,'&Iuml;'    //Capital I, diæresis / umlaut
    {Ð} {'&#208;'} ,'&ETH;'     //Capital Eth, Icelandic
    {Ñ} {'&#209;'} ,'&Ntilde;'  //Capital N, tilde
    {Ò} {'&#210;'} ,'&Ograve;'  //Capital O, grave accent
    {Ó} {'&#211;'} ,'&Oacute;'  //Capital O, acute accent
    {Ô} {'&#212;'} ,'&Ocirc;'   //Capital O, circumflex
    {Õ} {'&#213;'} ,'&Otilde;'  //Capital O, tilde
    {Ö} {'&#214;'} ,'&Ouml;'    //Capital O, diæresis / umlaut
    {×} {'&#215;'} ,'&times;'   //Multiply sign
    {Ø} {'&#216;'} ,'&Oslash;'  //Capital O, slash
    {Ù} {'&#217;'} ,'&Ugrave;'  //Capital U, grave accent
    {Ú} {'&#218;'} ,'&Uacute;'  //Capital U, acute accent
    {Û} {'&#219;'} ,'&Ucirc;'   //Capital U, circumflex
    {Ü} {'&#220;'} ,'&Uuml;'    //Capital U, diæresis / umlaut
    {Ý} {'&#221;'} ,'&Yacute;'  //Capital Y, acute accent
    {Þ} {'&#222;'} ,'&THORN;'   //Capital Thorn, Icelandic
    {ß} {'&#223;'} ,'&szlig;'   //Small sharp s, German sz
    {à} {'&#224;'} ,'&agrave;'  //Small a, grave accent
    {á} {'&#225;'} ,'&aacute;'  //Small a, acute accent
    {â} {'&#226;'} ,'&acirc;'   //Small a, circumflex
    {ã} {'&#227;'} ,'&atilde;'  //Small a, tilde
    {ä} {'&#228;'} ,'&auml;'    //Small a, diæresis / umlaut
    {å} {'&#229;'} ,'&aring;'   //Small a, ring
    {æ} {'&#230;'} ,'&aelig;'   //Small ae ligature
    {ç} {'&#231;'} ,'&ccedil;'  //Small c, cedilla
    {è} {'&#232;'} ,'&egrave;'  //Small e, grave accent
    {é} {'&#233;'} ,'&eacute;'  //Small e, acute accent
    {ê} {'&#234;'} ,'&ecirc;'   //Small e, circumflex
    {ë} {'&#235;'} ,'&euml;'    //Small e, diæresis / umlaut
    {ì} {'&#236;'} ,'&igrave;'  //Small i, grave accent
    {í} {'&#237;'} ,'&iacute;'  //Small i, acute accent
    {î} {'&#238;'} ,'&icirc;'   //Small i, circumflex
    {ï} {'&#239;'} ,'&iuml;'    //Small i, diæresis / umlaut
    {ð} {'&#240;'} ,'&eth;'     //Small eth, Icelandic
    {ñ} {'&#241;'} ,'&ntilde;'  //Small n, tilde
    {ò} {'&#242;'} ,'&ograve;'  //Small o, grave accent
    {ó} {'&#243;'} ,'&oacute;'  //Small o, acute accent
    {ô} {'&#244;'} ,'&ocirc;'   //Small o, circumflex
    {õ} {'&#245;'} ,'&otilde;'  //Small o, tilde
    {ö} {'&#246;'} ,'&ouml;'    //Small o, diæresis / umlaut
    {÷} {'&#247;'} ,'&divide;'  //Division sign
    {ø} {'&#248;'} ,'&oslash;'  //Small o, slash
    {ù} {'&#249;'} ,'&ugrave;'  //Small u, grave accent
    {ú} {'&#250;'} ,'&uacute;'  //Small u, acute accent
    {û} {'&#251;'} ,'&ucirc;'   //Small u, circumflex
    {ü} {'&#252;'} ,'&uuml;'    //Small u, diæresis / umlaut
    {ý} {'&#253;'} ,'&yacute;'  //Small y, acute accent
    {þ} {'&#254;'} ,'&thorn;'   //Small thorn, Icelandic
    {ÿ} {'&#255;'} //,'&yuml;'    //Small y, diæresis / umlaut
    {€} {'&#8364;'},'&euro;'    //EURO (€)
  );


type

  THTMLFormMethods =(fmPost,fmGet);
  THTMLFormControlTypes = (fctEdit, fctMemo, fctCheckox, fctRaido, fctButton,fctComboBox,fctListBox);
  TDoubleTagSubTypes    = (beBegin,beEnd);
  THTMLTagTypes = (htDocType,
                   htHtml,
                   htHead,
                   htBody,
                   htMeta,
                   htTitle,
                   htHeaderLink,
                   htFont,
                   htBold,
                   htForm,
                   htP,
                   htBr,
                   htInput,
                   htInputHidden,
                   htTextArea,
                   htScript,
                   htNoScript,
                   htDiv,
                   htTableCol,
                   htTableBody,
                   htTableRow,
                   htTable,
                   htImage,
                   htAnchor,
                   htSpan,
                   htCenter,
                   htStyle,
                   htOption,
                   htSelect,
                   htH1,
                   htH2,
                   htH3,
                   htH4,
                   htH5,
                   htH6,
                   htSup,
                   htArea,
                   htMap,
                   htNoBr,
                   htTH,
                   htLabel,
                   htI,
                   htBlockQuote,
                   htCite,
                   htDel,
                   htLegend,
                   htQ,
                   htKbd,
                   htDfn,
                   htStrike,
                   htIns,
                   htSamp,
                   htAcronym,
                   htXMP,
                   htAddress,
                   htSmall,
                   htStrong,
                   htPre,
                   htLeft,
                   htU,
                   htLi,
                   htUl,
                   htPlainText,
                   htNoFrames,
                   htFrameSet,
                   htFrame,
                   htCode,
                   htHR,
                   htEm,
                   htIFrame,
                   htBgSound,
                   htDL,
                   htDD,
                   htDT,
                   htTableFoot,
                   htTableHead,
                   htWBR,
                   htBase,
                   htBasefont,
                   htColGroup,
                   htCol,
                   htCaption,
                   htDir,
                   htMenu,
                   htOl,
                   htObject,
                   htEmbed,
                   htApplet,
                   htParam,
                   htComment,
                   htCodeFormat_LF,
                   htCodeFormat_CR,
                   htCodeFormat_TAB,
                   htCodeFormat_CRLF,
                   htUnknown);
  THTMLTagTypeSet=set of THTMLTagtypes;
  THTMLChildParentDistance = array [0..32] of THTMLTagTypes;
  TCharSet = set of Char;
const
  UriProtocolSchemeAllowedChars : TCharSet = ['a'..'z','0'..'9','+','-','.'];
  // constructor tags can be present in a document only one time, another instances will be ignored!
  c_HTMLConstructorTags:set of THTMLTagTypes = [htDocType,htHTML,htHead,htBody,htFrameSet];
  c_HTMLDoubleTags:set of THTMLTagTypes = [htHtml,htHead,htBody,htTitle,htFont,htBold,htForm,
                                           htTextArea,htScript,htNoScript,htDiv,htAnchor,
                                           htTableCol,htTH,htTableRow, htCaption, htTable,  htSpan,
                                           htCenter,htStyle,htSelect,
                                           //htOption,{!!!important note : normally Option is declared as optional but in our concept it must be double tag}
                                           htH1,htH2,htH3,htH4,htH5,htH6,
                                           htSup,htMap,htLabel,
                                           htP, {!!!important note : normally p is declared as optional but in our concept it must be double tag}
                                           htTableBody,{!!!important note : normally TableBody is declared as optional but in our concept it must be double tag}
                                           htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,
                                           htStrong,htPre,htU,htUl,htOl,htMenu,htDir,htNoFrames,htFrameSet,htIFrame,htCode,htEm,
                                           htObject,htEmbed,htApplet,htDl];
  c_HTMLOptionalDoubleTags:set of THTMLTagTypes = [htLi, htNoBr, htOption,
                                                   htTableFoot, htTableHead, htBgSound, htDD,
                                                   htDT, htWBR, htColGroup];
  c_HTMLEmptyTags      :set of THTMLTagTypes = [htMeta,{!!!important note : normally meta is declared as optional but in our concept it must be single tag}
                                            htDocType,htHeaderLink, htBr, htInput, htImage, htArea,htFrame,
                                            htHR, htBase, htBasefont, htCol, htParam,htInputHidden];
  c_HTMLCDataTags      :set of THTMLTagTypes = [htScript,htStyle];//Between begin and end of this tags, assumed as CData sections
  c_HTMLCodeFormatTags :set of THTMLTagTypes = [htCodeFormat_LF, htCodeFormat_CR, htCodeFormat_TAB, htCodeFormat_CRLF];

  c_HTMLHeaderTags     :set of THTMLTagTypes = [htBase, htHeaderLink, htTitle, htMeta,htBasefont, HtBgSound];
  c_HTMLTableTags      :set of THTMLTagTypes = [htTableRow,htCaption,htTableHead,htTableBody,htTableFoot,htColGroup,htCol];
  c_HTMLTableRowTags   :set of THTMLTagTypes = [htTableCol, htTH];
  c_HTMLTableRowParents:set of THTMLTagTypes = [htTable, htTableBody,htTableFoot, htTableHead];

  c_HTMLValidParents   :array[THTMLTagTypes] of set of THTMLTagTypes= (
                   {htDocType}    [],
                   {htHtml}       [htDocType],
                   {htHead}       [htHtml],
                   {htBody}       [htHtml,htNoFrames],
                   {htMeta}       [htHead],
                   {htTitle}      [htHead],
                   {htHeaderLink} [htHead],
                   {htFont}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htBold}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htForm}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTable,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htP}          [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htBr}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htInput}      [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htInputHidden}[],
                   {htTextArea}   [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htScript}     [htHTML,htHead,htBody,htTitle,htNoFrames,htObject,htForm,htTable,htTableRow,htTableBody,htTableHead,htTableFoot,htSelect,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htNoScript}   [htHTML,htHead,htBody,htTitle,htNoFrames,htObject,htForm,htTable,htTableRow,htTableBody,htTableHead,htTableFoot,htSelect,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htDiv}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htTableCol}   [htTableRow,htForm],
                   {htTableBody}  [htTable,htForm],
                   {htTableRow}   [htTable,htTableBody,htForm],
                   {htTable}      [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htImage}      [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htAnchor}     [htBody,htObject,htForm,htLi,htDD,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htSpan}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htCenter}     [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htStyle}      [htHead],
                   {htOption}     [htSelect],
                   {htSelect}     [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htH1}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htH2}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htH3}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htH4}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htH5}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htH6}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htSup}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htArea}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htMap}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htNoBr}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htTH}         [htTableRow],
                   {htLabel}      [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htI}          [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htBlockQuote} [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],

                   {htCite}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htDel}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htLegend}     [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htQ}          [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htKbd}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htDfn}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htStrike}     [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htIns}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htSamp}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htAcronym}    [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htXMP}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htAddress}    [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htSmall}      [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],

                   {htStrong}     [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htPre}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htLeft}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htU}          [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htLi}         [htDir,htMenu,htOl,htUL],
                   {htUl}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htPlainText}  [htBody,htTitle,htObject,htNoBr,htForm,htOption, htTextArea, htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htNoFrames}   [htFrameSet],
                   {htFrameSet}   [htHTML],
                   {htFrame}      [htFrameSet],
                   {htCode}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htHR}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htEm}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htIFrame}     [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htBgSound}    [htHead],
                   {htDL}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htDD}         [htDL],
                   {htDT}         [htDL],
                   {htTableFoot}  [htTable,htTableBody],
                   {htTableHead}  [htTable,htTableBody],
                   {htWBR}        [htNoBr],
                   {htBase}       [htHead],
                   {htBasefont}   [htHead],
                   {htColGroup}   [htTable,htTableBody],
                   {htCol}        [htColGroup],
                   {htCaption}    [htTable],
                   {Dir}          [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {Menu}         [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {Ol}           [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {Object}       [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {Embed}        [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htApplet}     [htBody,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htParam}      [htObject,htEmbed,htApplet],
                   {htComment} //   [htDocType,htHTML,htHead,htBody,htScript,htTitle,htNoFrames,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htLi,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htComment}      [],//which means valid everywhere
                   {htCodeFormat_LF}  [],//which means valid everywhere
                   {htCodeFormat_CR}  [],//which means valid everywhere
                   {htCodeFormat_TAB} [],//which means valid everywhere
                   {htCodeFormat_CRLF}[],

                   {htUnknown}    [htBody,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm]

                   );
  c_HTMLValidChilds   :array[THTMLTagTypes] of set of THTMLTagTypes= (
                   {htDocType}    [htComment,htHTML],
                   {htHtml}       [htComment,htHead,htBody,htFrameSet],
                   {htHead}       [htComment,htBase, htHeaderLink, htTitle, htMeta,htStyle, htBasefont, HtBgSound],
                   {htBody}       [htObject,htEmbed,htScript,htFrameSet,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htMeta}       [],
                   {htTitle}      [htComment,htPlainText],
                   {htHeaderLink} [],
                   {htFont}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htBold}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htForm}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htP}          [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htBr}         [],
                   {htInput}      [],
                   {htInputHidden}[],
                   {htTextArea}   [htPlainText],
                   {htScript}     [htComment],
                   {htNoScript}   [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htDiv}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htTableCol}   [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htTableBody}  [htComment,htTableRow,htTableHead,htTableFoot,htColGroup,htCaption],
                   {htTableRow}   [htComment,htTableCol,htTH],
                   {htTable}      [htComment,htTableBody,htTableRow,htTableHead,htTableFoot,htColGroup,htCaption],
                   {htImage}      [],
                   {htAnchor}     [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htSpan}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htCenter}     [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htStyle}      [],
                   {htOption}     [htComment,htPlainText],
                   {htSelect}     [htComment,htOption],
                   {htH1}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htH2}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htH3}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htH4}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htH5}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htH6}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htSup}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htArea}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htMap}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htNoBr}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htTH}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htLabel}      [],
                   {htI}          [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htBlockQuote} [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],

                   {htCite}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htDel}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htLegend}     [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htQ}          [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htKbd}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htDfn}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htStrike}     [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htIns}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htSamp}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htAcronym}    [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htXMP}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htAddress}    [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htSmall}      [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],

                   {htStrong}     [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htPre}        [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htLeft}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htU}          [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htLi}         [],
                   {htUl}         [htComment,htLi],
                   {htPlainText}  [],
                   {htNoFrames}   [htComment,htBody],
                   {htFrameSet}   [htComment,htFrame,htNoFrames],
                   {htFrame}      [],
                   {htCode}       [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htHR}         [],
                   {htEm}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htIFrame}     [],
                   {htBgSound}    [],
                   {htDL}         [htComment,htDD,htDT],
                   {htDD}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htDT}         [htComment,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htTableFoot}  [htComment,htTableRow],
                   {htTableHead}  [htComment,htTableRow],
                   {htWBR}        [],
                   {htBase}       [],
                   {htBasefont}   [],
                   {htColGroup}   [htComment,htCol],
                   {htCol}        [],
                   {htCaption}    [],
                   {Dir}          [htComment,htLi],
                   {Menu}         [htComment,htLi],
                   {Ol}           [htComment,htLi],
                   {Object}       [htComment,htParam,htObject,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {Embed}        [htComment,htParam,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htApplet}     [htComment,htParam,htEmbed,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown],
                   {htParam}      [],
                   {htComment}    [],
                   {htCodeFormat_LF}  [],//which means valid everywhere
                   {htCodeFormat_CR}  [],//which means valid everywhere
                   {htCodeFormat_TAB} [],//which means valid everywhere
                   {htCodeFormat_CRLF}[],
                   {htUnknown}    [htComment,htFont,htBold,htForm,htP,htBr,htInput,htTextArea,htScript,htNoScript,htDiv,htTable,htImage,htAnchor,htSpan,htCenter,htSelect,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htArea,htMap,htNoBr,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htLeft,htU,htUl,htPlainText,htCode,htHR,htEm,htIFrame,htDL,htWBR,htDir,htMenu,htOl,htUnknown]

                   );

  c_HTMLDefaultParents   :array[THTMLTagTypes] of set of THTMLTagTypes= (
                   {htDocType}    [],
                   {htHtml}       [htDocType],
                   {htHead}       [htHtml],
                   {htBody}       [htHtml,htNoFrames],
                   {htMeta}       [htHead],
                   {htTitle}      [htHead],
                   {htHeaderLink} [htHead],
                   {htFont}       [htBody,htTableCol,htLi],
                   {htBold}       [htBody,htTableCol,htLi],
                   {htForm}       [htBody,htTableCol,htLi],
                   {htP}          [htBody,htTableCol,htLi],
                   {htBr}         [htBody,htTableCol,htLi],
                   {htInput}      [htBody,htTableCol,htLi],
                   {htInputHidden}[htForm,htBody,htTableCol,htLi],
                   {htTextArea}   [htBody,htTableCol,htLi],
                   {htScript}     [htHTML,htHead,htBody,htTitle,htNoFrames,htObject,htForm,htSelect,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htNoScript}   [htBody,htTableCol,htLi],
                   {htDiv}        [htBody,htTableCol,htLi],
                   {htTableCol}   [htTableRow],
                   {htTableBody}  [htTable],
                   {htTableRow}   [htTable,htTableBody],
                   {htTable}      [htBody,htTableCol,htLi],
                   {htImage}      [htBody,htTableCol,htLi],
                   {htAnchor}     [htBody,htTableCol,htLi],
                   {htSpan}       [htBody,htTableCol,htLi],
                   {htCenter}     [htBody,htTableCol,htLi],
                   {htStyle}      [htHead],
                   {htOption}     [htSelect],
                   {htSelect}     [htBody,htTableCol,htLi],
                   {htH1}         [htBody,htTableCol,htLi],
                   {htH2}         [htBody,htTableCol,htLi],
                   {htH3}         [htBody,htTableCol,htLi],
                   {htH4}         [htBody,htTableCol,htLi],
                   {htH5}         [htBody,htTableCol,htLi],
                   {htH6}         [htBody,htTableCol,htLi],
                   {htSup}        [htBody,htTableCol,htLi],
                   {htArea}       [htBody,htTableCol,htLi],
                   {htMap}        [htBody,htTableCol,htLi],
                   {htNoBr}       [htBody,htTableCol,htLi],
                   {htTH}         [htTableRow],
                   {htLabel}      [htBody,htTableCol,htLi],
                   {htI}          [htBody,htTableCol,htLi],
                   {htBlockQuote} [htBody,htTableCol,htLi],

                   {htCite}       [htBody,htTableCol,htLi],
                   {htDel}        [htBody,htTableCol,htLi],
                   {htLegend}     [htBody,htTableCol,htLi],
                   {htQ}          [htBody,htTableCol,htLi],
                   {htKbd}        [htBody,htTableCol,htLi],
                   {htDfn}        [htBody,htTableCol,htLi],
                   {htStrike}     [htBody,htTableCol,htLi],
                   {htIns}        [htBody,htTableCol,htLi],
                   {htSamp}       [htBody,htTableCol,htLi],
                   {htAcronym}    [htBody,htTableCol,htLi],
                   {htXMP}        [htBody,htTableCol,htLi],
                   {htAddress}    [htBody,htTableCol,htLi],
                   {htSmall}      [htBody,htTableCol,htLi],

                   {htStrong}     [htBody,htTableCol,htLi],
                   {htPre}        [htBody,htTableCol,htLi],
                   {htLeft}       [htBody,htTableCol,htLi],
                   {htU}          [htBody,htTableCol,htLi],
                   {htLi}         [htDir,htMenu,htOl,htUL],
                   {htUl}         [htBody,htTableCol,htLi],
                   {htPlainText}  [htBody,htTableCol,htLi,htTitle,htOption,htNoBr],
                   {htNoFrames}   [htFrameSet],
                   {htFrameSet}   [htHTML],
                   {htFrame}      [htFrameSet],
                   {htCode}       [htBody,htTableCol,htLi],
                   {htHR}         [htBody,htTableCol,htLi],
                   {htEm}         [htBody,htTableCol,htLi],
                   {htIFrame}     [htBody,htTableCol,htLi],
                   {htBgSound}    [htHead],
                   {htDL}         [htBody,htTableCol,htLi],
                   {htDD}         [htDL],
                   {htDT}         [htDL],
                   {htTableFoot}  [htTable,htTableBody],
                   {htTableHead}  [htTable,htTableBody],
                   {htWBR}        [htBody,htTableCol,htLi],
                   {htBase}       [htHead],
                   {htBasefont}   [htHead],
                   {htColGroup}   [htTable,htTableBody],
                   {htCol}        [htColGroup],
                   {htCaption}    [htTable],
                   {Dir}          [htBody,htTableCol,htLi],
                   {Menu}         [htBody,htTableCol,htLi],
                   {Ol}           [htBody,htTableCol,htLi],
                   {Object}       [htBody,htTableCol,htLi],
                   {Embed}        [htBody,htTableCol,htLi],
                   {htApplet}     [htBody,htTableCol,htLi],
                   {htParam}      [htObject,htEmbed,htApplet],
                   {htComment} //   [htDocType,htHTML,htHead,htBody,htScript,htTitle,htNoFrames,htObject,htForm,htP,htFont,htBold,htNoScript,htDiv,htAnchor,htTableCol,htTH,htSpan,htCenter,htH1,htH2,htH3,htH4,htH5,htH6,htSup,htMap,htLabel,htI,htBlockQuote,htCite,htDel,htLegend,htQ,htKbd,htDfn,htStrike,htIns,htSamp,htAcronym,htXMP,htAddress,htSmall,htStrong,htPre,htU,htCode,htEm],
                   {htComment}    [],//which means valid everywhere
                   {htCodeFormat_LF}  [],//which means valid everywhere
                   {htCodeFormat_CR}  [],//which means valid everywhere
                   {htCodeFormat_TAB} [],//which means valid everywhere
                   {htCodeFormat_CRLF}[],
                   {htUnknown}    [htBody,htTableCol,htLi]
                   );


  c_HTMLTagIds :array[THTMLTagTypes] of string = (
  {htDocType}       '!doctype',
  {htHtml}          'html',
  {htHead}          'head',
  {htBody}          'body',
  {htMeta}          'meta',
  {htTitle}         'title',
  {htHeaderLink}    'link',
  {htFont}          'font',
  {htBold}          'b',
  {htForm}          'form',
  {htP}             'p',
  {htBr}            'br',
  {htInput}         'input',
  {htInputHidden}   'input',
  {htTextArea}      'textarea',
  {htScript}        'script',
  {htNoScript}      'noscript',
  {htDiv}           'div',
  {htTableCol}      'td',
  {htTableBody}     'tbody',
  {htTableRow}      'tr',
  {htTable}         'table',
  {htImage}         'img',
  {htAnchor}        'a',
  {htSpan}          'span',
  {htCenter}        'center',
  {htStyle}         'style',
  {htOption}        'option',
  {htSelect}        'select',
  {htH1}            'h1',
  {htH2}            'h2',
  {htH3}            'h3',
  {htH4}            'h4',
  {htH5}            'h5',
  {htH6}            'h6',
  {htSup}           'sup',
  {htArea}          'area',
  {htMap}           'map',
  {htNoBr}          'nobr',
  {htTH}            'th',
  {htLabel}         'label',
  {htI}             'i',
  {htBlockQuote}    'blockquote',

  {htCite}          'cite',
  {htDel}           'del',
  {htLegend}        'legend',
  {htQ}             'q',
  {htKbd}           'kbd',
  {htDfn}           'dfn',
  {htStrike}        'strike',
  {htIns}           'ins',
  {htSamp}          'samp',
  {htAcronym}       'acronym',
  {htXMP}           'xmp',
  {htAddress}       'address',
  {htSmall}         'small',

  {htStrong}        'strong',
  {htPre}           'pre',
  {htLeft}          'left',
  {htU}             'u',
  {htLi}            'li',
  {htUl}            'ul',
  {htPlainText}     'plaintext',
  {htNoFrames}      'noframes',
  {htFrameSet}      'frameset',
  {htFrame}         'frame',
  {htCode}          'code',
  {htHR}            'hr',
  {htEm}            'em',
  {htIFrame}        'iframe',
  {htBgSound}       'bgsound',
  {htDL}            'dl',
  {htDD}            'dd',
  {htDT}            'dt',
  {htTableFoot}     'tfoot',
  {htTableHead}     'thead',
  {htWBR}           'wbr',
  {htBase}          'base',
  {htBasefont}      'basefont',
  {htColGroup}      'colgroup',
  {htCol}           'col',
  {htCaption}       'caption',
  {htDir}           'dir',
  {htMenu}          'menu',
  {htOl}            'ol',
  {htObject}        'object',
  {htEmbed}         'embed',
  {htApplet}        'applet',
  {htParam}         'param',
  {htComment}       '!--',
  {htCodeFormat_LF}  '#lf',//which means valid everywhere
  {htCodeFormat_CR}  '#cr',//which means valid everywhere
  {htCodeFormat_TAB} '#tab',//which means valid everywhere
  {htCodeFormat_CRLF}'#crlf',
  {htUnknown}       '');

  c_HTMLFormMethods :array[THTMLFormMethods] of string =('post','get');

type
  TTagStrTypes = (tstBegin,tstEnd, tstBoth);

  THTMLReadyStates = (
    rsUnInitialized , // The object is not initialized with data.
    rsLoading,        // The object is currently loading its data.
    rsInteractive,    // The object can be interacted with even though it is not fully loaded.
    rsComplete        // The control is completely loaded.
  );
  TSGMLTagParsingStates = (
    stpCDATA,
    stpWhiteSpace,
    stpTagCmd,
    stpTagCmdExpect,
    stpAttrName,
    stpAttrNameExpect,
    stpAttrVal,
    stpAttrValExpect,
    stpTagEndExpect,
    stpCommentBeginExpect,
    stpComment,
    stpCommentEndExpect,
    stpCDATABlockExpected,
    stpCDATABlock,
    stpCDATABlockEndExpected
  );

  THTMLParsedTag = class;
  THTMLParser    = class;
  THTMLParsedTagCollection  = class;

  THTMLCustomCollectionItem = class;
  THTMLCustomCollection     = class;
  THTMLListItemsCollection  = class;
  THTMLListItemElement      = class;

  THTMLFramesCollection  = class;
  THTMLDOMNode           = class;
  THTMLHeader            = class;
  THTMLFont              = class;
  THTMLBold              = class;
  THTMLTable             = class;
  THTMLRow               = class;
  THTMLCell              = class;
  THTMLAnchor            = class;
  THTMLTables            = class;
  THTMLDecoder           = class;
  THTMLForm              = class;
  THTMLImage             = class;
  THTMLDocument          = class;
  THTMLWindow            = class;
  THTMLLocation          = class;
  THTMLOmNavigator       = class;
  THTMLSelect            = class;
  THTMLElementCollection = class;
  THTMLElement           = class;
  THTMLFrame             = class;
  THTMLFrameSet          = class;
  THTMLParametricObject  = class;
  THTMLParam             = class;
  THTMLObject            = class;
  THTMLEmbed             = class;
  THTMLStyleElement      = class;
  THTMLScript            = class;


  THTMLOnLoadedEvent           = procedure (Document:THTMLDocument;Sender:THTMLElement) of object;
  THTMLOnReadyStateChangeEvent = procedure (Document:THTMLDocument;Sender:THTMLElement;NewState:THTMLReadyStates) of object;
  THTMLOnParseErrorEvent       = procedure (Sender:THTMLParsedTag; ErrorMsg:string;ErrCode:integer;Line,Column:integer;var cancelParsing:boolean) of object;

  TmyPersistent= class(TPersistent)
  public
    function GetOwner: TPersistent;override;
  end;
  TmyComponent = class(TComponent)
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
  end;
  THTMLElementClasses    = class of THTMLElement;
  THTMLData = class (TPersistent)
  private
    FHRef_Url:string;
  public
    property HRef_Url:string read FHRef_Url write FHRef_Url;
  end;
  THTMLStringData=class(THTMLData)
  private
    FText:string;
    //FFont:TFont;
  public
    property Text:string read FText write FText;
    //property Font:TFont read FFont write FFont;
    Constructor Create;
    destructor Destroy;override;
  end;
  TTagStacks        = array [low(THTMLTagTypes)..high(THTMLTagTypes)] of integer;
  TTagSubType       = set of TDoubleTagSubTypes;




  THTMLParsedTag = class (TObject)
  private
    fTagStr         : string;
    fTagCmd         : string;
    fTagType        : THTMLTagTypes;
    fTagSubType     : TTagSubType;
    fSourceRow      : dword;
    fSourceCol      : dword;
    //fFwdStacks      : TTagStacks;
    //fRwdStacks      : TTagStacks;

    fIsBeginTag     : boolean;
    fIsEndTag       : boolean;
    fIsDoubleTag    : boolean;
    fIsOptionalTag  : boolean;
    fIsSIngleTag    : boolean;

    fBeginTag       : THTMLParsedTag;
    fEndTag         : THTMLParsedTag;
    fParentTag      : THTMLParsedTag;
    fChilds         : THTMLParsedTagCollection;
    fAttributes     : TStringList;
    fOwner          : THTMLParser;
    fDistFromParent : THTMLChildParentDistance;
    fDistFromParCnt : smallint;
    fCodeFormattingChars : string;

  protected
    procedure setTagStr(aTagStr:string);
    function  getIsValidTag:boolean;
    procedure setBeginTag (aTag:THTMLParsedTag);
    procedure setEndTag   (aTag:THTMLParsedTag);
    procedure setParentTag(aTag:THTMLParsedTag);
    function  getPrevTag:THTMLParsedTag;
    function  getNextTag:THTMLParsedTag;
    function  getTagIndex:integer;
    procedure setTagIndex(NewIndex:integer);
    {
    function  getIsBeginTag:boolean;
    function  getIsEndTag:boolean;
    function  getIsDoubleTag:boolean;
    function  getIsSingleTag:boolean;
    function  getIsOptionalTag:boolean;
    }
    function  getIsBegun:boolean; //return true if BeginTag assigned
    function  getIsClosed:boolean;//return true if endtag assigned
    function  getIsParentValid:boolean;
    function  isCodeFormatTag:boolean;
    function  get_TagType:THTMLTagTypes;
    procedure CalculateHiearchicDistanceFromCurrentParent;
  public
    //1.Level Props
    property Owner         : THTMLParser read fOwner;
    property Attributes    : TStringList read fAttributes;
    property TagStr        : string read fTagStr write setTagStr;
    property TagType       : THTMLTagTypes read get_TagType;
    property TagSubType    : TTagSubType read fTagSubType;
    property TagIndex      : integer read getTagIndex write setTagIndex;
    property SourceRow     : dword read fSourceRow;
    property SourceCol     : dword read fSourceCol;
    property isValidTag    : boolean read getIsValidTag;
    {
    property isBeginTag    : boolean read getIsBeginTag;
    property isEndTag      : boolean read getIsEndTag;
    property isDoubleTag   : boolean read getIsDoubleTag;
    property isSingleTag   : boolean read getIsSingleTag;
    property isOptionalTag : boolean read getIsOptionalTag;
    }
    property isBeginTag    : boolean read fIsBeginTag;
    property isEndTag      : boolean read fIsEndTag;
    property isDoubleTag   : boolean read fIsDoubleTag;
    property isSingleTag   : boolean read fIsSingleTag;
    property isOptionalTag : boolean read fIsOptionalTag;

    property CodeFormattingChars :string read fCodeFormattingChars write fCodeFormattingChars;

    //2.Level Props
    //property FwdTagStacks  : TTagStacks read fFwdStacks write fFwdStacks;
    //property RwdTagStacks  : TTagStacks read fRwdStacks write fRwdStacks;

    //3.Level Props
    property BeginTag      : THTMLParsedTag read fBeginTag  write setBeginTag;
    property EndTag        : THTMLParsedTag read fEndTag    write setEndTag;
    property isBegun       : boolean read getIsBegun;
    property isClosed      : boolean read getIsClosed;

    //4.Level Props
    property ParentTag          : THTMLParsedTag read fParentTag write setParentTag;
    property isParentValid      : boolean read getIsParentValid;
    property DistanceFromParent : THTMLChildParentDistance read fDistFromParent;// if the parent is invalid this array includes tag types that need to be created to reach nearest valid path to current parent
    property DistFromParentCount: smallint read fDistFromParCnt; //determines number of items in DistanceFromParent array.
    property PrevTag            : THTMLParsedTag read getPrevTag;
    property NextTag            : THTMLParsedTag read getNextTag;
    property Childs             : THTMLParsedTagCollection read fChilds;

    //function  StacksDiff(aTagType:THTMLTagTypes):integer;
    function  CheckAsChild (ParsedTagToExamine:THTMLParsedTag):boolean; //returns true if given tag is a valid child to this
    function  CheckAsParent(ParsedTagToExamine:THTMLParsedTag):boolean; //returnd true if given tag is a valid parent to this
    procedure init;
    function  CreateElement(Document:THTMLDocument;parentElement:THTMLElement):THTMLElement;
    constructor Create(aOwner:THTMLParser;aTagStr:string;aSourceRow:dword;aSourceCol:dword);overload;
    constructor Create(aOwner:THTMLParser);overload;
    destructor  Destroy;override;
  end;
  THTMLParsedTagCollection = class (TObjectList)
  private
  protected
    function  getItem(index:integer):THTMLParsedTag;
    procedure setItem(index:integer;aParsedTag:THTMLParsedTag);
  public
    property items[index:integer]:THTMLParsedTag read getItem write setItem;default;
  end;
  THTMLLinePos=record
    row:dword;
    col:dword;
  end;

  {
  THTMLLinePosObj = class(TObject)
  private
    fCol:dword;
    fRow:dword;
  public
    property Col:dword read fCol;
    property Row:dword read fRow;
    constructor Create(CurrentRow,CurrentCol:dword);
  end;
  }
  THTMLParser = class (TPersistent)
  private
    fDocument      : THTMLDocument;
    fTreeRoot      : THTMLParsedTag;
    fParsedTags    : THTMLParsedTagCollection;
    fOnParsingError: THTMLOnParseErrorEvent;
    fSourceLines   : TStringList;
    fParsedHTML    : TStringList;
    fReport        : TStringList;
    fFixProblems   : boolean;
    fFwdTagStacks  : array [low(THTMLTagTypes)..high(THTMLTagTypes)] of THTMLParsedTagCollection;
    fRwdTagStacks  : array [low(THTMLTagTypes)..high(THTMLTagTypes)] of THTMLParsedTagCollection;
    bTime,eTime    : TDatetime;
  protected
    destoying:boolean;
    property  TreeRoot:THTMLParsedTag read fTreeRoot;
    procedure parse_TagStr(bTag:THTMLParsedTag);
    procedure ParseHTMLCode(RemoveControlChars:boolean);
    procedure ParseTagLines;//creates ParsedTagLines Collection (fills 1.level props only)
    procedure CalculateTagLineProps;//Fills all 2.level props of tag lines
    procedure MatchTags; //Locates Begin & end tags and connects them together (fills 3.Level props)
    procedure CheckForMissingTags; //Fixes Unclosed or Unbegun tag problems
    procedure CheckMinRequirements; //Examines that all the main html tags exist in document. ie HTML, HEAD BODY, etc
    procedure BuildTree;//(fills 4.Level props)
    procedure CheckTree;//Examines Hierarchic problems.ie examines Child-Parent Relationships
    function  getParsedHTMLSource:string;//Returns Parsed & Fixed HTML Code
    function  CreateTag(
                 aTagCmd:string;
                 aTagStr:string;
                 Attributes:TStrings;
                 aCodeFormattingChars:string;
                 aTagSubType:TTagSubType;
                 CurrRow:dword;
                 CurrCol:dword):THTMLParsedTag;overload;
    function  CreateTag(
                 pTagCmd:pchar;
                 pTagStr:pchar;
                 Attributes:TStrings;
                 lTagCmd:byte;
                 lTagStr:word;
                 pCodeFormattingChars:pchar;
                 lCodeFormattingChars:byte;
                 aTagSubType:TTagSubType;
                 CurrRow:dword;
                 CurrCol:dword;
                 isComment:boolean):THTMLParsedTag;overload;

    procedure StartTimer;
    procedure AddToReport(s:string);
  public
    property Document:THTMLDocument read fDocument;
    property ParsedTags:THTMLParsedTagCollection read fParsedTags write fParsedTags;
    property FixedParsedHTML:string read getParsedHTMLSource;
    procedure CreateElements(Document:THTMLDocument);
    constructor Create(HTMLCode:string;FixProblems:boolean;aDocument:THTMLDocument);
    destructor  destroy;override;
  published
    property OnParsingError:THTMLOnParseErrorEvent read fOnParsingError write fOnParsingError;
  end;

  THTMLStyle = class (TPersistent)
  private
    fStyleHTML    : string;
    fAttributes   : TStringList;
    fOwnerElement : THTMLElement;
  protected
    procedure ParseStyleHTML;
    function  getStyleText:string;
    procedure setStyleText(NewStyleText:string);

    function  getAttributeCount:integer;
    function  getStringAttrByName(AttrName:string):string;
    procedure setStringAttrByName(AttrName, AttrValue:string);
    function  getStringAttrByIndex(index:integer):string;
    procedure setStringAttrByIndex(index:integer; AttrValue:string);
    function  getIntegerAttr(AttrName:String):Integer;
    procedure setIntegerAttr(AttrName:String; AttrValue:Integer);
    function  getBooleanAttr(AttrName:String):Boolean;
    procedure setBooleanAttr(AttrName:String; AttrValue:Boolean);

    procedure Set_fontFamily(const p: String);
    function  Get_fontFamily: String;
    procedure Set_fontStyle(const p: String);
    function  Get_fontStyle: String;
    procedure Set_fontVariant(const p: String);
    function  Get_fontVariant: String;
    procedure Set_fontWeight(const p: String);
    function  Get_fontWeight: String;
    procedure Set_fontSize(p: String);
    function  Get_fontSize: String;
    procedure Set_font(const p: String);
    function  Get_font: String;
    procedure Set_color(p: string);
    function  Get_color: string;
    procedure Set_background(const p: String);
    function  Get_background: String;
    procedure Set_backgroundColor(p: String);
    function  Get_backgroundColor: String;
    procedure Set_backgroundImage(const p: String);
    function  Get_backgroundImage: String;
    procedure Set_backgroundRepeat(const p: String);
    function  Get_backgroundRepeat: String;
    procedure Set_backgroundAttachment(const p: String); 
    function  Get_backgroundAttachment: String; 
    procedure Set_backgroundPosition(const p: String);
    function  Get_backgroundPosition: String;
    procedure Set_backgroundPositionX(p: String);
    function  Get_backgroundPositionX: String;
    procedure Set_backgroundPositionY(p: String);
    function  Get_backgroundPositionY: String; 
    procedure Set_wordSpacing(p: String);
    function  Get_wordSpacing: String; 
    procedure Set_letterSpacing(p: String);
    function  Get_letterSpacing: String;
    procedure Set_textDecoration(const p: String);
    function  Get_textDecoration: String;
    procedure Set_textDecorationNone(p: Boolean);
    function  Get_textDecorationNone: Boolean;
    procedure Set_textDecorationUnderline(p: Boolean);
    function  Get_textDecorationUnderline: Boolean; 
    procedure Set_textDecorationOverline(p: Boolean);
    function  Get_textDecorationOverline: Boolean;
    procedure Set_textDecorationLineThrough(p: Boolean);
    function  Get_textDecorationLineThrough: Boolean;
    procedure Set_textDecorationBlink(p: Boolean);
    function  Get_textDecorationBlink: Boolean;
    procedure Set_verticalAlign(p: String);
    function  Get_verticalAlign: String;
    procedure Set_textTransform(const p: String);
    function  Get_textTransform: String; 
    procedure Set_textAlign(const p: String);
    function  Get_textAlign: String;
    procedure Set_textIndent(p: String);
    function  Get_textIndent: String; 
    procedure Set_lineHeight(p: String);
    function  Get_lineHeight: String;
    procedure Set_marginTop(p: String);
    function  Get_marginTop: String;
    procedure Set_marginRight(p: String);
    function  Get_marginRight: String;
    procedure Set_marginBottom(p: String);
    function  Get_marginBottom: String;
    procedure Set_marginLeft(p: String);
    function  Get_marginLeft: String;
    procedure Set_margin(const p: String);
    function  Get_margin: String;
    procedure Set_paddingTop(p: String);
    function  Get_paddingTop: String;
    procedure Set_paddingRight(p: String);
    function  Get_paddingRight: String;
    procedure Set_paddingBottom(p: String); 
    function  Get_paddingBottom: String; 
    procedure Set_paddingLeft(p: String);
    function  Get_paddingLeft: String;
    procedure Set_padding(const p: String);
    function  Get_padding: String;
    procedure Set_border(const p: String);
    function  Get_border: String;
    procedure Set_borderTop(const p: String);
    function  Get_borderTop: String;
    procedure Set_borderRight(const p: String); 
    function  Get_borderRight: String;
    procedure Set_borderBottom(const p: String);
    function  Get_borderBottom: String;
    procedure Set_borderLeft(const p: String);
    function  Get_borderLeft: String;
    procedure Set_borderColor(const p: String);
    function  Get_borderColor: String;
    procedure Set_borderTopColor(p: String);
    function  Get_borderTopColor: String;
    procedure Set_borderRightColor(p: String);
    function  Get_borderRightColor: String; 
    procedure Set_borderBottomColor(p: String);
    function  Get_borderBottomColor: String; 
    procedure Set_borderLeftColor(p: String); 
    function  Get_borderLeftColor: String;
    procedure Set_borderWidth(const p: String);
    function  Get_borderWidth: String;
    procedure Set_borderTopWidth(p: String);
    function  Get_borderTopWidth: String; 
    procedure Set_borderRightWidth(p: String);
    function  Get_borderRightWidth: String;
    procedure Set_borderBottomWidth(p: String);
    function  Get_borderBottomWidth: String;
    procedure Set_borderLeftWidth(p: String);
    function  Get_borderLeftWidth: String;
    procedure Set_borderStyle(const p: String);
    function  Get_borderStyle: String;
    procedure Set_borderTopStyle(const p: String);
    function  Get_borderTopStyle: String;
    procedure Set_borderRightStyle(const p: String);
    function  Get_borderRightStyle: String;
    procedure Set_borderBottomStyle(const p: String);
    function  Get_borderBottomStyle: String;
    procedure Set_borderLeftStyle(const p: String);
    function  Get_borderLeftStyle: String;
    procedure Set_width(p: String);
    function  Get_width: String;
    procedure Set_height(p: String);
    function  Get_height: String; 
    procedure Set_styleFloat(const p: String);
    function  Get_styleFloat: String;
    procedure Set_clear(const p: String);
    function  Get_clear: String;
    procedure Set_display(const p: String);
    function  Get_display: String;
    procedure Set_visibility(const p: String);
    function  Get_visibility: String; 
    procedure Set_listStyleType(const p: String);
    function  Get_listStyleType: String;
    procedure Set_listStylePosition(const p: String);
    function  Get_listStylePosition: String;
    procedure Set_listStyleImage(const p: String);
    function  Get_listStyleImage: String; 
    procedure Set_listStyle(const p: String);
    function  Get_listStyle: String;
    procedure Set_whiteSpace(const p: String);
    function  Get_whiteSpace: String;
    procedure Set_top(p: String);
    function  Get_top: String;
    procedure Set_left(p: String);
    function  Get_left: String;
    function  Get_position: String; 
    procedure Set_zIndex(p: String);
    function  Get_zIndex: String;
    procedure Set_overflow(const p: String);
    function  Get_overflow: String; 
    procedure Set_pageBreakBefore(const p: String);
    function  Get_pageBreakBefore: String;
    procedure Set_pageBreakAfter(const p: String);
    function  Get_pageBreakAfter: String;
    procedure Set_cssText(const p: String);
    function  Get_cssText: String;
    procedure Set_pixelTop(p: Integer);
    function  Get_pixelTop: Integer;
    procedure Set_pixelLeft(p: Integer);
    function  Get_pixelLeft: Integer;
    procedure Set_pixelWidth(p: Integer);
    function  Get_pixelWidth: Integer;
    procedure Set_pixelHeight(p: Integer);
    function  Get_pixelHeight: Integer;
    procedure Set_posTop(p: Single);
    function  Get_posTop: Single;
    procedure Set_posLeft(p: Single);
    function  Get_posLeft: Single;
    procedure Set_posWidth(p: Single);
    function  Get_posWidth: Single;
    procedure Set_posHeight(p: Single);
    function  Get_posHeight: Single;
    procedure Set_cursor(const p: String);
    function  Get_cursor: String;
    procedure Set_clip(const p: String);
    function  Get_clip: String;
    procedure Set_filter(const p: String);
    function  Get_filter: String;
  public
    property StyleText:string read getStyleText write setStyleText;
    property AttributeByName[index:string]:string read getStringAttrByName write setStringAttrByName;
    property AttributeByIndex[index:integer]:string read getStringAttrByIndex write setStringAttrByIndex;
    property AttributeCount:integer read getAttributeCount;
    property fontFamily: String read Get_fontFamily write Set_fontFamily;
    property fontStyle: String read Get_fontStyle write Set_fontStyle;
    property fontVariant: String read Get_fontVariant write Set_fontVariant;
    property fontWeight: String read Get_fontWeight write Set_fontWeight;
    property fontSize: String read Get_fontSize write Set_fontSize;
    property font: String read Get_font write Set_font;
    property color: string read Get_color write Set_color;
    property background: String read Get_background write Set_background;
    property backgroundColor: String read Get_backgroundColor write Set_backgroundColor;
    property backgroundImage: String read Get_backgroundImage write Set_backgroundImage;
    property backgroundRepeat: String read Get_backgroundRepeat write Set_backgroundRepeat;
    property backgroundAttachment: String read Get_backgroundAttachment write Set_backgroundAttachment;
    property backgroundPosition: String read Get_backgroundPosition write Set_backgroundPosition;
    property backgroundPositionX: String read Get_backgroundPositionX write Set_backgroundPositionX;
    property backgroundPositionY: String read Get_backgroundPositionY write Set_backgroundPositionY;
    property wordSpacing: String read Get_wordSpacing write Set_wordSpacing;
    property letterSpacing: String read Get_letterSpacing write Set_letterSpacing;
    property textDecoration: String read Get_textDecoration write Set_textDecoration;
    property textDecorationNone: Boolean read Get_textDecorationNone write Set_textDecorationNone;
    property textDecorationUnderline: Boolean read Get_textDecorationUnderline write Set_textDecorationUnderline;
    property textDecorationOverline: Boolean read Get_textDecorationOverline write Set_textDecorationOverline;
    property textDecorationLineThrough: Boolean read Get_textDecorationLineThrough write Set_textDecorationLineThrough;
    property textDecorationBlink: Boolean read Get_textDecorationBlink write Set_textDecorationBlink;
    property verticalAlign: String read Get_verticalAlign write Set_verticalAlign;
    property textTransform: String read Get_textTransform write Set_textTransform;
    property textAlign: String read Get_textAlign write Set_textAlign;
    property textIndent: String read Get_textIndent write Set_textIndent;
    property lineHeight: String read Get_lineHeight write Set_lineHeight;
    property marginTop: String read Get_marginTop write Set_marginTop;
    property marginRight: String read Get_marginRight write Set_marginRight;
    property marginBottom: String read Get_marginBottom write Set_marginBottom;
    property marginLeft: String read Get_marginLeft write Set_marginLeft;
    property margin: String read Get_margin write Set_margin;
    property paddingTop: String read Get_paddingTop write Set_paddingTop;
    property paddingRight: String read Get_paddingRight write Set_paddingRight;
    property paddingBottom: String read Get_paddingBottom write Set_paddingBottom;
    property paddingLeft: String read Get_paddingLeft write Set_paddingLeft;
    property padding: String read Get_padding write Set_padding;
    property border: String read Get_border write Set_border;
    property borderTop: String read Get_borderTop write Set_borderTop;
    property borderRight: String read Get_borderRight write Set_borderRight;
    property borderBottom: String read Get_borderBottom write Set_borderBottom;
    property borderLeft: String read Get_borderLeft write Set_borderLeft;
    property borderColor: String read Get_borderColor write Set_borderColor;
    property borderTopColor: String read Get_borderTopColor write Set_borderTopColor;
    property borderRightColor: String read Get_borderRightColor write Set_borderRightColor;
    property borderBottomColor: String read Get_borderBottomColor write Set_borderBottomColor;
    property borderLeftColor: String read Get_borderLeftColor write Set_borderLeftColor;
    property borderWidth: String read Get_borderWidth write Set_borderWidth;
    property borderTopWidth: String read Get_borderTopWidth write Set_borderTopWidth;
    property borderRightWidth: String read Get_borderRightWidth write Set_borderRightWidth;
    property borderBottomWidth: String read Get_borderBottomWidth write Set_borderBottomWidth;
    property borderLeftWidth: String read Get_borderLeftWidth write Set_borderLeftWidth;
    property borderStyle: String read Get_borderStyle write Set_borderStyle;
    property borderTopStyle: String read Get_borderTopStyle write Set_borderTopStyle;
    property borderRightStyle: String read Get_borderRightStyle write Set_borderRightStyle;
    property borderBottomStyle: String read Get_borderBottomStyle write Set_borderBottomStyle;
    property borderLeftStyle: String read Get_borderLeftStyle write Set_borderLeftStyle;
    property width: String read Get_width write Set_width;
    property height: String read Get_height write Set_height;
    property styleFloat: String read Get_styleFloat write Set_styleFloat;
    property clear: String read Get_clear write Set_clear;
    property display: String read Get_display write Set_display;
    property visibility: String read Get_visibility write Set_visibility;
    property listStyleType: String read Get_listStyleType write Set_listStyleType;
    property listStylePosition: String read Get_listStylePosition write Set_listStylePosition;
    property listStyleImage: String read Get_listStyleImage write Set_listStyleImage;
    property listStyle: String read Get_listStyle write Set_listStyle;
    property whiteSpace: String read Get_whiteSpace write Set_whiteSpace;
    property top: String read Get_top write Set_top;
    property left: String read Get_left write Set_left;
    property position: String read Get_position;
    property zIndex: String read Get_zIndex write Set_zIndex;
    property overflow: String read Get_overflow write Set_overflow;
    property pageBreakBefore: String read Get_pageBreakBefore write Set_pageBreakBefore;
    property pageBreakAfter: String read Get_pageBreakAfter write Set_pageBreakAfter;
    property cssText: String read Get_cssText write Set_cssText;
    property pixelTop: Integer read Get_pixelTop write Set_pixelTop;
    property pixelLeft: Integer read Get_pixelLeft write Set_pixelLeft;
    property pixelWidth: Integer read Get_pixelWidth write Set_pixelWidth;
    property pixelHeight: Integer read Get_pixelHeight write Set_pixelHeight;
    property posTop: Single read Get_posTop write Set_posTop;
    property posLeft: Single read Get_posLeft write Set_posLeft;
    property posWidth: Single read Get_posWidth write Set_posWidth;
    property posHeight: Single read Get_posHeight write Set_posHeight;
    property cursor: String read Get_cursor write Set_cursor;
    property clip: String read Get_clip write Set_clip;
    property filter: String read Get_filter write Set_filter;
    constructor Create(AOwnerElement:THTMLElement);
  end;

  (***************  Collection Class Definitions ******************)
  THTMLCustomCollectionItem = class (TObject)
  private
  protected
  public
  end;

  THTMLCustomCollection = class (TPersistent)
  private
  protected
  public
  end;

  THTMLNodeCollection = class (THTMLCustomCollection)
  private
    fOwner:THTMLDOMNode;
    fElements:TObjectList;
  protected
    function  getItem(Index: Integer): THTMLDOMNode;
    procedure setItem(Index: Integer; Value: THTMLDOMNode);
    function  getCount:integer;
  public
    property Count :integer read getCount;//deplhi notation
    property Length:integer read getCount;//w3c notation
    function  InsertItem(Item: THTMLDOMNode):integer;
    procedure RemoveItem(Item: THTMLDOMNode);
    procedure Clear(DestroyItems:boolean);
    function IndexOf(Item:THTMLDOMNode):integer;
    constructor Create(aOwner:THTMLDOMNode);
    destructor destroy;override;
  published
    property OwnerNode:THTMLDOMNode read fOwner;
  end;

  THTMLElementCollection = class (THTMLNodeCollection)
  private
  protected
    function  getItem(Index: Integer): THTMLElement;
    procedure setItem(Index: Integer; Value: THTMLElement);
  public
    property Items[Index: Integer]: THTMLElement read GetItem write SetItem;default;
  published
  end;

  THTMLFramesCollection = class (THTMLNodeCollection)
  private
  protected
    function  getItem(Index: Integer): THTMLFrame;
    procedure setItem(Index: Integer; Value: THTMLFrame);
  public
    property Items[Index: Integer]: THTMLFrame read GetItem write SetItem;default;
  published
  end;

  THTMLStyleSheetsCollection = class (THTMLNodeCollection)
  private
  protected
    function  getItem(Index: Integer): THTMLStyleElement;
    procedure setItem(Index: Integer; Value: THTMLStyleElement);
  public
    property Items[Index: Integer]: THTMLStyleElement read GetItem write SetItem;default;
  published
  end;

  THTMLScriptsCollection = class (THTMLNodeCollection)
  private
  protected
    function  getItem(Index: Integer): THTMLScript;
    procedure setItem(Index: Integer; Value: THTMLScript);
  public
    property Items[Index: Integer]: THTMLScript read GetItem write SetItem;default;
  published
  end;

  THTMLCellCollection = class(THTMLNodeCollection)
  private
    FRow:THTMLRow;
  protected
    function  getCell(Index:integer):THTMLCell;
    procedure setCell(Index:integer;aCell:THTMLCell);
  public
    property  items[index:integer]:THTMLCell read GetCell write SetCell;default;
    property  Row:THTMLRow read fRow write fRow;
    function  IndexOf(ACell:THTMLCell):integer;
    constructor Create(aOwner:THTMLRow);
  end;

  THTMLParamsCollection = class (THTMLNodeCollection)
  private
  protected
    function  getParam(Index:integer):THTMLParam;
    procedure setParam(Index:integer;aParam:THTMLParam);
  public
    property  items[index:integer]:THTMLParam read getParam write setParam;default;
    function  IndexOf(AParam:THTMLParam):integer;
    constructor Create(aOwner:THTMLParametricObject);
  end;

  THTMLRowCollection = class (THTMLNodeCollection)
  private
    fTable:THTMLTable;
  protected
    function  getRow(Index:integer):THTMLRow;
    procedure setRow(Index:integer;aRow:THTMLRow);
  public
    property  items[index:integer]:THTMLRow read getRow write setRow;default;
    property  Table:THTMLTable read fTable write fTable;
    function  IndexOf(ARow:THTMLRow):integer;
    constructor Create(aOwner:THTMLTable);
  end;

  THTMLTableCollection = class (THTMLNodeCollection)
  private
    fDocument:THTMLDocument;
  protected
    function  getTable(Index:integer):THTMLTable;
    procedure setTable(Index:integer;aTable:THTMLTable);
  public
    property  items[index:integer]:THTMLTable read getTable write setTable;default;
    property  Document:THTMLDocument read fDocument write fDocument;
    function  IndexOf(aTable:THTMLTable):integer;
    constructor Create(aOwner:THTMLDocument);
  end;

  THTMLAnchorCollection = class (THTMLNodeCollection)
  private
    fDocument:THTMLDocument;
  protected
    function  getAnchor(Index:integer):THTMLAnchor;
    procedure setAnchor(Index:integer;aAnchor:THTMLAnchor);
  public
    property  items[index:integer]:THTMLAnchor read getAnchor write setAnchor;default;
    property  Document:THTMLDocument read fDocument write fDocument;
    function  IndexOf(aAnchor:THTMLAnchor):integer;
    constructor Create(aOwner:THTMLDocument);
  end;

  THTMLFormCollection = class (THTMLNodeCollection)
  private
    fDocument:THTMLDocument;
  protected
    function  getForm(Index:integer):THTMLForm;
    procedure setForm(Index:integer;aForm:THTMLForm);
  public
    property  items[index:integer]:THTMLForm read getForm write setForm;default;
    property  Document:THTMLDocument read fDocument write fDocument;
    function  IndexOf(aForm:THTMLForm):integer;
    constructor Create(aOwner:THTMLDocument);
  end;

  THTMLImageCollection = class (THTMLNodeCollection)
  private
    fDocument:THTMLDocument;
  protected
    function  getImage(Index:integer):THTMLImage;
    procedure setImage(Index:integer;aImage:THTMLImage);
  public
    property  items[index:integer]:THTMLImage read getImage write setImage;default;
    property  Document:THTMLDocument read fDocument write fDocument;
    function  IndexOf(aImage:THTMLImage):integer;
    constructor Create(aOwner:THTMLDocument);
  end;



  THTMLDOMNode = class (THTMLCustomCollectionItem)
  private
    fTagstr          : string;
    FAllElementCollection    : THTMLElementCollection;
    FChildElementCollection  : THTMLElementCollection;
    FParentElementCollection : THTMLElementCollection;
    fCodeFormattingCharsB    : string;
    fCodeFormattingCharsE    : string;
    fDocument : THTMLDocument;
    function  GetIndex: Integer;
  protected
    fSourceLineBegin : integer;
    fSourceLineEnd  : integer;
    procedure SetTagStr(NewTagStr:string);virtual;
    property CodeFormattingCharsB:string read fCodeFormattingCharsB write fCodeFormattingCharsB;
    property CodeFormattingCharsE:string read fCodeFormattingCharsE write fCodeFormattingCharsE;
    procedure Changed(AllItems: Boolean);
    function  getParentNode:THTMLDOMNode;
    procedure setParentNode(NewParent:THTMLDOMNode);
    function  GetOwner: TPersistent;
    function  GetDisplayName: string; virtual;
    procedure SetParentElementCollection(Value: THTMLElementCollection); virtual;
    procedure SetIndex(Value: Integer); virtual;
    procedure SetDisplayName(const Value: string); virtual;
    function  getDocument:THTMLDocument;virtual;
    procedure setDocument(aDocument:THTMLDocument);virtual;
    function  getChildCount:integer;
    procedure AddToAllArray(itemToAdd:THTMLDomNode);virtual;
    procedure RemoveFromAllArray(itemToRemove:THTMLDomNode);virtual;
  public
    property Document   : THTMLDocument read getDocument write setDocument;
    property Owner      : THTMLElementCollection read FParentElementCollection write SetParentElementCollection;
    property ParentNode :THTMLDOMNode read getParentNode write setParentNode;
    property All        : THTMLElementCollection read FAllElementCollection;
    property Childs     : THTMLElementCollection read FChildElementCollection;
    property ChildCount :integer read getChildCount;
    property Index      : Integer read GetIndex write SetIndex;
    property DisplayName: string read GetDisplayName write SetDisplayName;
    property SourceLineBegin : integer read fSourceLineBegin write fSourceLineBegin;
    property SourceLineEnd   : integer read fSourceLineEnd   write fSourceLineEnd;

    function  AddChildNode(aChildNode:THTMLDOMNode):integer;virtual;//adds a child node to childs and all array of this and returns its position in childs array
    procedure RemoveChildNode(aChildNode:THTMLDOMNode);virtual;// removes given child from childs and all array
    function GetNamePath: string;

    constructor Create(aDocument:THTMLDocument;OwnerCollection: THTMLElementCollection); virtual;
    destructor  Destroy; override;
  published
    property TagStr : string read FTagStr write SetTagStr;//need to be carefull while directly changing raw tag string!!!
  end;

  THTMLElement = class (THTMLDOMNode)
  private
    fTagType         : THTMLTagTypes;
    fTagName         : string;
    fParentTag       : THTMLElement;
    fStyle           : THTMLStyle;
    fInnerHTML       : string;
    fParsedInnerHTML : TStringList;
    fTagClosed       : boolean;
    fFont            : THTMLFont;
    fNeedToParseInnerHTML : boolean;
  protected
    fIdentifier: string; //must be defined on constructor
    fLineBegin : integer; //must be defined on constructor
    fLineEnd   : integer; //must be defined on constructor
    Props      :TStringList;
    fExtendedLineCount : integer;
    property LineBegin : integer read FLineBegin write FLineBegin;
    property LineEnd   : integer read FLineEnd write FLineEnd;
    property TagClosed : boolean read fTagClosed write fTagClosed;

    function  getName:string;
    procedure SetName(NewName:string);

    procedure SetParentTag(NewParent:THTMLElement);
    function  getParentElement:THTMLElement;
    procedure setParentElement(NewParent:THTMLElement);
    function  GetChildTag(index:integer):THTMLElement;
    procedure SetChildTag (index:integer;ATag:THTMLElement);
    procedure AddChildTag(ATag:THTMLElement);
    procedure RemoveChildTag(ATag:THTMLElement);
    //procedure ExtractPropValues;virtual;
    function  GetTagClass(TagStr:string):THTMLElementClasses;virtual;
    function  GetTagCmd(TagStr:string):string;virtual;
    //procedure ExtractPropsFromTag(TagStr:string;var TagCmd:String;Props:TStrings);virtual;

    function  getBelongTo:THTMLElementCollection;
    function  GetTagName:string;
    function  getTagType:THTMLTagTypes;virtual;
    function  Get_className:string;
    procedure Set_className(NewValue:string);
    function  getId:string;
    procedure SetId(NewValue:string);
    function  getTypeProp:string;
    procedure setTypeProp(p:string);
    function  Get_title:string;
    procedure Set_title(NewValue:string);
    function  Get_onhelp:string;
    procedure Set_onhelp(NewValue:string);
    function  Get_onclick:string;
    procedure Set_onclick(NewValue:string);
    function  Get_ondblclick:string;
    procedure Set_ondblclick(NewValue:string);
    function  Get_onkeydown:string;
    procedure Set_onkeydown(NewValue:string);
    function  Get_onkeyup:string;
    procedure Set_onkeyup(NewValue:string);
    function  Get_onkeypress:string;
    procedure Set_onkeypress(NewValue:string);
    function  Get_onmouseout:string;
    procedure Set_onmouseout(NewValue:string);
    function  Get_onmouseover:string;
    procedure Set_onmouseover(NewValue:string);
    function  Get_onmousemove:string;
    procedure Set_onmousemove(NewValue:string);
    function  Get_onmousedown:string;
    procedure Set_onmousedown(NewValue:string);
    function  Get_onmouseup:string;
    procedure Set_onmouseup(NewValue:string);

    function  GetFormattedTagStr(IndentCount:integer;Indent_Ch:char;TagStrType:TTagStrTypes):string;virtual;

    function  Get_innerHTML:string;virtual;
    procedure Set_innerHTML(NewValue:string);virtual;
    function  Get_innerText:string;virtual;
    procedure Set_innerText(NewValue:string);virtual;
    function  Get_outerHTML:string;virtual;
    procedure Set_outerHTML(NewValue:string);virtual;
    function  Get_outerText:string;virtual;
    procedure Set_outerText(NewValue:string);virtual;
    function  getPlainText:string;virtual;
    procedure setPlainText(NewText:string);virtual;
    function  GetClosingTagPos(curr_pos:integer;aTagType:THTMLTagTypes):integer;
    function  RequestOutBoundSource(RequesterChild:THTMLElement;RequestedTagBeginAt:integer;RequestedTagType:THTMLTagTypes;var ExtraSourceLines:string):boolean;
    function  getExtendedLineCount:integer;
    property  ExtendedLineCount:integer read getExtendedLineCount write fExtendedLineCount;
  public
    function getAttribute(AttrName:string):string;
    procedure setAttribute(AttrName:string;AttrValue:string);
    property NeedToParseInnerHTML:boolean read fNeedToParseInnerHTML write fNeedToParseInnerHTML;
    property Attributes[index:string]:string read getAttribute write setAttribute;
    property ChildTags [Index:integer]: THTMLElement read GetChildTag write SetChildTag;
    property Font:THTMLFont read fFont write fFont;
    function children(index:integer):THTMLElement;overload;


    //Common Html Element Attributes
    property belongTo:THTMLElementCollection read getBelongTo;
    property parentElement:THTMLElement read getParentElement;
    property TagName:string read GetTagName;
    property Style:THTMLStyle read fStyle;
    function CreateChildElement(tagStr:string):THTMLElement;overload;
    function CreateChildElement(ParsedTag:THTMLParsedTag):THTMLElement;overload;

    function ChildElementCount:integer;
    function IndexOfChildTag(ATag:THTMLElement):integer;
    function getTagTypeFromClass:THTMLTagTypes;virtual;
    function AllTagText:string;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor destroy;override;
  published

    property TagType:THTMLTagTypes read getTagType;
    property Identifier :string read fIdentifier;
    property Id:string read getId write SetId;
    property Name : string read getName write SetName;
    property class_Name: string read Get_className write Set_className;
    property TypeProp : string read getTypeProp write setTypeProp;
    property PlainText: string read getPlainText write setPlainText;
    property title: string read Get_title write Set_title;
    //main operation properties use carefully!
    property innerHTML: String read Get_innerHTML write Set_innerHTML;
    property innerText: String read Get_innerText write Set_innerText;
    property outerHTML: String read Get_outerHTML write Set_outerHTML;
    property outerText: String read Get_outerText write Set_outerText;

    //common events
    property onhelp: string read Get_onhelp write Set_onhelp;
    property onclick: string read Get_onclick write Set_onclick;
    property ondblclick: string read Get_ondblclick write Set_ondblclick;
    property onkeydown: string read Get_onkeydown write Set_onkeydown;
    property onkeyup: string read Get_onkeyup write Set_onkeyup;
    property onkeypress: string read Get_onkeypress write Set_onkeypress;
    property onmouseout: string read Get_onmouseout write Set_onmouseout;
    property onmouseover: string read Get_onmouseover write Set_onmouseover;
    property onmousemove: string read Get_onmousemove write Set_onmousemove;
    property onmousedown: string read Get_onmousedown write Set_onmousedown;
    property onmouseup: string read Get_onmouseup write Set_onmouseup;

  end;
  THTMLTag = class (THTMLElement) //for backward compability
  end;

  THTMLLoadableElement = class(THTMLElement)
  private
    fLoader     : TInternetConnection;
    fBuffer     : TStream;
    fOnLoad     : THTMLOnLoadedEvent;
  protected
    property  Buffer:TStream read fBuffer;

    function  InternalCreateStream:TStream;virtual;abstract;     // derived classes MUST provide a suitable stream to download data.
    function  InternalGetLocationHRef:string;virtual;abstract;   // derived classes MUST proviode href to load resource.In most cases, this is  equivalent to "SRC" property of element.
    function  InternalParse:boolean;virtual;abstract;            // derived classes MUST provide parser to validate and create object model.
    function  getLoader:TInternetConnection;virtual;
    procedure setLoader(p:TInternetConnection);virtual;

    function  getReadyState:THTMLReadyStates;virtual;
    function  getOnLoaded:THTMLOnLoadedEvent;virtual;
    procedure setOnLoaded(p:THTMLOnLoadedEvent);virtual;
    function  getOnReadyStateChange:THTMLOnReadyStateChangeEvent;virtual;
    procedure setOnReadyStateChange(p:THTMLOnReadyStateChangeEvent);virtual;
  public
    procedure Load;virtual;
    procedure Parse;virtual;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor destroy;override;
  published
    property ReadyState:THTMLReadyStates read getReadyState;
    property OnLoaded:THTMLOnLoadedEvent read getOnLoaded write setOnLoaded;
    property OnReadyStateChange:THTMLOnReadyStateChangeEvent read getOnReadyStateChange write setOnReadyStateChange;
  end;

  THTMLScript = class (THTMLLoadableElement)
  private
    fRawCode    : TStrings;
    fParsedCode : TStrings;
  protected
    function  Get_outerHTML:string;override;
    function  Get_outerText:string;override;
    function  Get_innerText:string;override;
    function  Get_innerHTML:string;override;

    function  getSrc:string;
    procedure setSrc(p:string);
    function  getEvent:string;
    procedure setEvent(p:string);
    function  gethtmlFor:string;
    procedure sethtmlFor(p:string);
    function  getLanguage :string;
    procedure setLanguage(p:string);
    function  get_Type:string;
    procedure set_Type(p:string);
  public
    procedure Load;override;
    procedure Parse;override;
    Procedure Execute;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor Destroy;override;
  published
    property Src:string read getSrc write setSrc;
    property Event:string read getEvent write setEvent;
    property htmlFor:string read gethtmlFor write sethtmlFor;
    property Language:string read getLanguage write setLanguage;
    property _Type:string read get_Type write set_Type;
  end;

  THTMLStyleElement = class (THTMLElement)
  private
  protected
    function  Get_outerHTML:string;override;
    function  Get_outerText:string;override;
    function  Get_innerText:string;override;
    function  Get_innerHTML:string;override;
    function  getDisabled:boolean;
    procedure setDisabled(p:boolean);
    function  getMedia:string;
    procedure setMedia(p:string);
    function  getType:string;
    procedure setType(p:string);
    function  get_href:string;
  public
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor destroy;override;
  published
    property Disabled:boolean read getDisabled write setDisabled;
    property Media:string read getMedia write setMedia;
    property _Type:string read getType write setType;
    property href:string read get_href;
  end;

  THTMLLink = class (THTMLLoadableElement)
  private
    fStyleSheet: THTMLStyleElement;
  protected
    function  InternalCreateStream:TStream;override;
    function  InternalGetLocationHRef:string;override;
    function  InternalParse:boolean;override;
    function  get_disabled:boolean;
    procedure set_disabled(p:boolean);
    function  get_media:string;
    procedure set_media(p:string);
    function  get_rel:string;
    procedure set_rel(p:string);
    function  get_type:string;
    procedure set_type(p:string);
    function  get_onload:string;
    procedure set_onload(p:string);
    function  get_onerror:string;
    procedure set_onerror(p:string);
    function  get_styleSheet:THTMLStyleElement;
    procedure set_styleSheet(p:THTMLStyleElement);
    function  get_hRef:string;
    procedure set_hRef(p:string);
  public
    property styleSheet:THTMLStyleElement read get_styleSheet write set_styleSheet;
  published
    property disabled:boolean read get_disabled write set_disabled;
    property hRef:string read get_hRef write set_hRef;
    property Media:string read get_media write set_media;
    property rel:string read get_rel write set_rel;
    property _type:string read get_type write set_type;
    property onload:string read get_onload write set_onload;
    property onerror:string read get_onerror write set_onerror;
  end;


  THTMLPlainText = class (THTMLElement)
  protected
    function getTagType:THTMLTagTypes;override;
    function  Get_outerHTML:string;override;
    function  Get_innerHTML:string;override;
    function  Get_outerText:string;override;
    function  Get_innerText:string;override;
    procedure Set_innerHTML(NewValue:string);override;
    function  getPlainText:string;override;
    procedure setPlainText(NewText:string);override;
  public
  end;
  THTMLComment = class (THTMLElement)
  private
  protected
    function  getTagType:THTMLTagTypes;override;
    function  Get_outerHTML:string;override;
    function  Get_outerText:string;override;
    function  Get_innerText:string;override;
    function  Get_innerHTML:string;override;
  public
  published
  end;

  THTMLImage=class(THTMLLoadableElement)
  private
    //FGraphic:TGraphic;
  protected
    function  getSrc:string;
    procedure setSrc(p:string);
    function getAlt:string;
    procedure setAlt(p:string);
  public
    //property Graphic:TGraphic read FGraphic write FGraphic;
    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;//dont forget to create TGraphic
    destructor Destroy;override;
  published
    property src:string read getSrc write setSrc;
    property Alt:string read getAlt write setAlt;
  end;
  THTMLhtml = class (THTMLElement)
  end;
  THTMLTitle = class (THTMLElement)
  end;
  THTMLText = class (THTMLElement)
  end;
  THTMLFont = class (THTMLText)
  private
    //FFont:TFont;
  public
    constructor create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor Destroy;override;
  published
    //property Font:TFont read FFont write FFont;
  end;
  THTMLBold  = class (THTMLFont)
  end;
  THTMLParagraph = class (THTMLElement)
  end;
  THTMLBreak = class (THTMLElement)
  end;
  THTMLDiv = class (THTMLElement)
  end;
  THTMLTableBody =class (THTMLElement)
  end;
  THTMLAnchor = class (THTMLElement)
  private
  protected
    //procedure ExtractPropValues;override;
    function  getHRef:string;
    procedure setHref(ahRef:string);
    function  getTarget:string;
    procedure setTarget(aTarget:string);
  public
    procedure Click;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor  destroy;override;
  published
    property Href:string read getHRef write setHref;
    property Target:string read getTarget write setTarget;
  end;
  THTMLSpan = class (THTMLElement)
  end;
  THTMLCenter = class (THTMLElement)
  end;



  THTMLh1 = class (THTMLElement)
  end;
  THTMLh2 = class (THTMLElement)
  end;
  THTMLh3 = class (THTMLElement)
  end;
  THTMLh4 = class (THTMLElement)
  end;
  THTMLh5 = class (THTMLElement)
  end;
  THTMLh6 = class (THTMLElement)
  end;

  THTMLSup = class (THTMLElement)
  end;
  THTMLArea = class (THTMLElement)
  end;
  THTMLMap = class (THTMLElement)
  end;
  THTMLNoBr = class (THTMLElement)
  end;
  THTMLi = class (THTMLElement)
  end;
  THTMLblockquote = class (THTMLElement)
  end;

  THTMLCite = class (THTMLElement)
  end;
  THTMLDel = class (THTMLElement)
  end;
  THTMLLegend = class (THTMLElement)
  end;
  THTMLQ = class (THTMLElement)
  end;
  THTMLKbd = class (THTMLElement)
  end;
  THTMLDfn = class (THTMLElement)
  end;
  THTMLStrike = class (THTMLElement)
  end;
  THTMLIns = class (THTMLElement)
  end;
  THTMLSamp = class (THTMLElement)
  end;
  THTMLAcronym = class (THTMLElement)
  end;
  THTMLXMP = class (THTMLElement)
  end;
  THTMLAddress = class (THTMLElement)
  end;
  THTMLSmall = class (THTMLElement)
  end;

  THTMLStrong = class (THTMLElement)
  end;
  THTMLPre= class (THTMLElement)
  end;
  THTMLLeft= class (THTMLElement)
  end;

  THTMLListownerElement = class(THTMLELement)
  private
    fItems:THTMLListItemsCollection;
  protected
    function  getItem(index:integer):THTMLListItemElement;virtual;
    procedure setItem(index:integer;aItem: THTMLListItemElement);virtual;
    function  AddItem(aItem: THTMLListItemElement):integer;virtual;
    procedure RemoveItem(aItem:THTMLListItemElement);virtual;
  public
    property items[index:integer]:THTMLListItemElement read getItem write setItem;
    function itemCount:integer;virtual;
    function indexOf(aItem:THTMLListItemElement):integer;virtual;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor Destroy;override;
  end;

  THTMLListItemElement = class(THTMLElement)
  private
    fListOwner:THTMLListownerElement;
  protected
    function findListOwner(el:THTMLElement):THTMLListownerElement;
  public
    property ListOwner:THTMLListownerElement read fListOwner;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor Destroy;override;
  end;

  THTMLu   = class (THTMLElement)
  end;

  THTMLListItemsCollection = class(THTMLNodeCollection)
  private
    FListOwner:THTMLListOwnerElement;
  protected
    function  getListItem(Index:integer):THTMLListItemElement;
    procedure setListItem(Index:integer;aItem:THTMLListItemElement);
  public
    property  items[index:integer]:THTMLListItemElement read GetListItem write SetListItem;default;
    property  ListOwner:THTMLListOwnerElement read fListOwner write fListOwner;
    function  IndexOf(AItem:THTMLListItemElement):integer;
    constructor Create(aOwner:THTMLListOwnerElement);
  end;

  THTMLli  = class (THTMLListItemElement)
  end;

  THTMLul  = class (THTMLListownerElement)
  private
  public
  end;
  THTMLEm  = class (THTMLElement)
  end;
  THTMLDl  = class (THTMLElement)
  end;
  THTMLDd  = class (THTMLElement)
  end;
  THTMLDt  = class (THTMLElement)
  end;
  THTMLDir = class (THTMLElement)
  end;
  THTMLMenu= class (THTMLElement)
  end;
  THTMLOl  = class (THTMLListownerElement)
  end;
  THTMLWbr = class (THTMLElement)
  end;
  THTMLBase = class (THTMLElement)
  private
  protected
    function  getHRef:string;
    procedure sethRef(p: string);
    function  getTarget:string;
    procedure setTarget(p: string);
  public
    property hRef:string read getHRef write setHRef;
    property Target:string read getTarget write setTarget;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor Destroy;override;
  end;
  THTMLBaseFont = class(THTMLElement)
  private
  protected
    function  getColor:string;
    procedure setColor(p: string);
    function  getFace:string;
    procedure setFace(p: string);
    function  getSize:string;
    procedure setSize(p: string);
  public
    property Color:string read getColor write setColor;
    property Face:string read getFace write setFace;
    property Size:string read getSize write setSize;
  end;
  THTMLMeta = class (THTMLElement)
  private
  protected
    //procedure ExtractPropValues;override;
    function  getHeader:THTMLHeader;
    procedure SetHeader(aHeader:THTMLHeader);
    function  getContent:string;
    procedure setContent(aContent:string);
    function  getHttpEquiv:string;
    procedure setHttpEquiv(aHttpEquiv:string);
    function  getURL:string;
    procedure setURL(aURL:string);

  public
    property Header:THTMLHeader read getHeader write SetHeader;
    constructor create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor Destroy;override;
  published
    property Name;
    property Content:string read getContent write setContent;
    property HttpEquiv:string read getHttpEquiv write setHttpEquiv;
    property URL:string read getURL write setURL;
  end;
  THTMLVariable = class(THTMLMeta)
  end;



  THTMLNoScript = class (THTMLElement)
  end;
  THTMLCode = class(THTMLElement)
  end;
  THTMLHR =class(THTMLElement)
  end;
  THTMLBgSound = class (THTMLElement)
  end;

  THTMLVariables = class (THTMLElementCollection)
  private
  protected
  public
  published
  end;

  THTMLCustomControl = class (THTMLElement)
  private
    FParent : THTMLCustomControl;
    FChildObjects : TObjectList;
   protected
    procedure SetParent(NewParent:THTMLCustomControl);
    function GetChildObject(index:integer):THTMLCustomControl;
    procedure SetChildObject (index:integer;AObject:THTMLCustomControl);
    procedure AddChildObject(AObject:THTMLCustomControl);
    procedure RemoveChildObject(AObject:THTMLCustomControl);
  public
    property Parent:THTMLCustomControl read FParent write SetParent;
    property ChildObjects [Index:integer]: THTMLCustomControl read GetChildObject write SetChildObject;
    function ChildObjectCount:integer;
    function IndexOfChildObject(AObject:THTMLCustomControl):integer;
    constructor create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor Destroy;override;
  published
    property Name;

  end;
  THTMLControl = class (THTMLCustomControl)
  private
  protected
    function  getWidth:string;
    procedure setWidth(aWidth:string);
    function  getHeight:string;
    procedure setHeight(aHeight:string);
    function  getAlign:string;
    procedure setAlign(aAlign:string);
    function  getVAlign:string;
    procedure setVAlign(aVAlign:string);
    function  getPixelWidth:integer;
    procedure setPixelWidth(p:integer);
    function  getPixelHeight:integer;
    procedure setPixelHeight(p:integer);
  public
  published
    property Width:string read getWidth write setWidth;
    property Height:string read getHeight write setHeight;
    property Align:string read getAlign write setAlign;
    property vAlign:string read getVAlign write setVAlign;
    property pixelWidth:integer read getPixelWidth write setPixelWidth;
    property pixelHeight:integer read getPixelHeight write setPixelHeight;
  end;

  THTMLParam = class (THTMLElement)
  private
  protected
    function  getValue:string;
    procedure setValue(p:string);
  public
    constructor create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor Destroy;override;
  published
    property name;
    property Value:string read getValue write setValue;
  end;

  THTMLParametricObject = class (THTMLControl)
  private
    fParamsCollection:THTMLParamsCollection;
  protected
    function  getSrc:string;
    procedure setSrc(p: string);
    function  getCode:string;
    procedure setCode(p:string);
    function  getCodeBase:string;
    procedure setCodeBase(p:string);
  public
    property Src:string read getSrc write setSrc;
    property Code:string read getCode write setCode;
    property CodeBase:string read getCodeBase write setCodeBase;
    property Params:THTMLParamsCollection read fParamsCollection;
    constructor Create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor Destroy;override;
  published
  end;

  THTMLObject = class (THTMLParametricObject)
  private
  protected
  public
  published
  end;
  THTMLEmbed = class (THTMLParametricObject)
  private
  protected
  public
  published
  end;
  THTMLApplet = class (THTMLParametricObject)
  private
  protected
  public
  published
  end;

  THTMLCell=class(THTMLCustomControl)
  private
    FRow:THTMLRow;
    //FData:THTMLData;
    Fcolspan:integer;
    Fcol:integer;
  protected
    function GetColumnIndex:integer;
    //procedure ExtractPropValues;override;
    procedure SetRow(ARow:THTMLRow);
    function  findRow(AParentTag:THTMLDOMNode):THTMLRow;
  public
     property Row:THTMLRow read FRow write SetRow;
     property ColSpan:integer read Fcolspan write Fcolspan;
     property ColumnIndex:Integer read GetColumnIndex;
     //property Data:THTMLData read FData write FData;
     constructor Create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);Override;
     destructor Destroy;override;
  published
    property Column:integer read Fcol write Fcol;
  end;
  THTMLth = class (THTMLCell)
  end;

  THTMLRow=class(THTMLCustomControl)
  private
    FCellCollection:THTMLCellCollection;
    FTable:THTMLTable;
  protected
    function FindTable(AParentTag:THTMLDOMNode):THTMLTable;
    //procedure ExtractPropValues;override;
    function GetRowOrder:integer;
    procedure SetTable(ATable:THTMLTable);
    Procedure AddCell(ACell:THtmlCell);
    procedure RemoveCell(ACell:THTMLCell);
  public
    property RowOrder:integer read GetRowOrder;
    property Table:THTMLTable read FTable write SetTable;
    property cells:THTMLCellCollection read FCellCollection;
    function CellCount:integer;

    function IndexOfCell(ACell:THTMLCell):integer;
    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor destroy;override;

  published
  end;
  THTMLTableFoot = class (THTMLCustomControl)
  private
    fTable:THTMLTable;
  protected
  public
    property Table:THTMLTable read FTable write fTable;
  end;
  THTMLColHead = class (THTMLCustomControl)
  private
    fTable:THTMLTable;
  protected
  public
    property Table:THTMLTable read FTable write fTable;
  end;
  THTMLTableHead = class (THTMLObject)
  private
    fTable:THTMLTable;
  protected
  public
    property Table:THTMLTable read FTable write fTable;
  end;
  THTMLColGroup = class (THTMLElement)
  private
    fTable:THTMLTable;
  protected
  public
    property Table:THTMLTable read FTable write fTable;
  end;
  THTMLCol = class (THTMLElement)
  private
    fTable:THTMLTable;
  protected
  public
    property Table:THTMLTable read FTable write fTable;
  end;
  THTMLCaption = class (THTMLObject)
  private
    fTable:THTMLTable;
  protected
  public
    property Table:THTMLTable read FTable write fTable;
  end;

  THTMLTable=class(THTMLControl)
  private
    fRowCollection:THTMLRowCollection;
  protected
    //procedure ExtractPropValues;override;
    Procedure AddRow(ARow:THTMLRow);
    procedure RemoveRow(ARow:THTMLRow);
    function  getCellPadding:integer;
    procedure setCellPadding(aCP:integer);
    function  getCellSpacing:integer;
    procedure setCellSpacing(aCS:integer);
    function  getBorder:string;
    procedure setBorder(aBorder:string);
    function  getBackground:string;
    procedure setBackground(p: string);
    function  getBgColor:string;
    procedure setBgColor(p: string);
    function  getBorderColor: string;
    procedure setBorderColor(p: string);
    function  getBorderColorLight: string;
    procedure setBorderColorLight(p:string);
    function  getBorderColorDark: string;
    procedure setBorderColorDark(p:string);
    function  getAlign: string;
    procedure setAlign(p: string);
  public
    property Rows:THTMLRowCollection read fRowCollection;
    function RowCount:integer;
    function IndexOfRow(ARow:THTMLRow):integer;
    function RowByName(RowName:string):THTMLRow;
    function CellByName(CellName:string):THTMLCell;
    constructor Create (OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection); override;
    destructor Destroy;override;
  published
    property Name;
    property cellPadding:integer read getCellPadding write setCellPadding;
    property cellSpacing:integer read getCellSpacing write setCellSpacing;
    property border:string read getBorder write setBorder;
    property background: string read getBackground write setBackground;
    property bgColor: string read getBgColor write setBgColor;
    property borderColor: string read getborderColor write setBorderColor;
    property borderColorLight: string read getBorderColorLight write setBorderColorLight;
    property borderColorDark: string read getBorderColorDark write setBorderColorDark;
    property align: string read getAlign write setAlign;
  end;
  THTMLTables = class (THTMLElementCollection)
  private
    FDecoder:THTMLDecoder;
  protected
    function GetTable(index:integer):THTMLTable;
    procedure SetTable(index:integer;ATable:THTMLTable);
  public
    property Items[index:integer]:THTMLTable read GetTable write SetTable;
    property Decoder:THTMLDecoder read fDecoder write fDecoder;
    Constructor Create(aOwner:THTMLElement);
    destructor Destroy;override;
  end;
  {HTML Form Controls}
  THTMLFormControl = class (THTMLCustomControl)
  private
    fControlType:THTMLFormControlTypes;
    //fValue:string;
    fTabOrder:integer;
    fForm:THTMLForm;
  protected
    procedure SetTabOrder(ATabOrder:integer);
    function GetValue:string;virtual;
    procedure SetValue(AValue:string);virtual;
    //procedure ExtractPropValues;override;
    procedure SetForm(AForm:THTMLForm);
    function FindForm(AParentTag:THTMLDOMNode):THTMLForm;

  public
    property Form:THTMLForm read fForm write SetForm;
    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor Destroy;override;
  published
    property ControlType:THTMLFormControlTypes read fControlType;
    property TabOrder:integer read fTabOrder write SetTabOrder;

    property Value:string read GetValue write SetValue;     //Sets or retrieves the default or selected value of the control.
  end;
  THTMLInputControl = class (THTMLFormControl)
  private
  protected
    function  getAccept:string;
    procedure setAccept(p:string);
    function  getAlign:string;
    procedure setAlign(p:string);
    function  getAlt:string;
    procedure setAlt(p:string);
    function  getComplete:boolean; //Retrieves whether the object is fully loaded.
    function  getDynSRC:string;
    procedure setDynSRC(p:string);
    function  gethSpace:string;
    procedure sethSpace(p:string);
    function  getLoop:integer;
    procedure setLoop(p:integer);
    function  getLowSRC:string;
    procedure setLowSRC(p:string);
    function  getStart:string;
    procedure setStart(p:string);
    function  getUseMAP:string;
    procedure setUseMAP(p:string);
    function  getVSpace:string;
    procedure setVSPace(p:string);
  public
    property Accept:string read getAccept write setAccept;   //Sets or retrieves a comma-separated list of content types.
    property Align:string read getAlign write setAlign;      //Sets or retrieves how the object is aligned with adjacent text
    property Alt:string read getAlt write setAlt;            //Sets or retrieves a text alternative to the graphic.
    property Complete:boolean read getComplete;              //Retrieves whether the object is fully loaded.
    property DynSRC:string read getDynSRC write setDynSRC;   //Sets or retrieves the address of a video clip or VRML world to display in the window.
    property hSpace:string read gethSpace write sethSpace;   //Sets or retrieves the horizontal margin for the object.
    property Loop:integer read getLoop write setLoop;        //Sets or retrieves the number of times a sound or video clip will loop when activated.
    property LowSRC:string read getLowSRC write setLowSRC;   //Sets or retrieves a lower resolution image to display.
    property Start:string read getStart write setStart;      //Sets or retrieves when a video clip file should begin playing.
    property UseMAP:string read getUseMAP write setUseMAP;   //Sets or retrieves the URL, often with a bookmark extension (#name), to use as a client-side image map.
    property VSpace:string read getVSpace write setVSPace;   //Sets or retrieves the vertical margin for the object.
  end;

  THTMLEditBox = class (THTMLInputControl)
  private
  protected
    function  getSize:integer;
    procedure setSize(p:integer);
    function  get_maxLength:integer;
    procedure set_maxLength(p:integer);
  public
    property size:integer read getSize write setSize;
    property maxLength:integer read get_maxLength write set_maxLength;
  end;
  THTMLPasswordEdit = class (THTMLEditBox)
  private
  protected
  public
  end;

{  THTMLFileUploader = class (THTMLEditBox)
  private
  protected
  public
  end;
}
  THTMLHiddenFormVar = class (THTMLInputControl)
  private
  protected
  public
  end;

  THTMLImageControl = class (THTMLInputControl)
  private
  protected
    procedure parseValue(var x,y:integer);
    function  getX:integer;
    procedure setX(p:integer);
    function  getY:integer;
    procedure setY(p:integer);
    function  getSrc:string;
    procedure setSrc(p:string);
  public
    property x:integer read getX write setX;
    property y:integer read getY write setY;
    property src:string read getSrc write setSrc;
  end;

  THTMLOption = class (THTMLElement)
  private
    FSelect : THTMLSelect;
  protected
    function  GetText:string;
    procedure SetText(AText:string);
    function  getValue:string;
    procedure setValue(aValue:string);
    function  getSelected:boolean;
    procedure setSelected(NewValue:boolean);
    function FindSelect(AParentTag:THTMLDOMNode):THTMLSelect;    
    //procedure ExtractPropValues;override;
  public
    property Selected:boolean read getSelected Write setSelected;
    property Value:string read getValue write setValue;
    property Text:String read GetText write SetText;
    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor Destroy;override;

  end;

  THTMLSelect = class (THTMLFormControl)
  private
    fOptions:TObjectList;
  protected
    //procedure ExtractPropValues;override;

    function GetOption(index:integer):THTMLOption;virtual;
    procedure SetOption(index:integer;AOption:THTMLOption);virtual;
    function GetValue:string;override;
    procedure SetValue(AValue:string);override;
    function GetSelText:string;
    procedure SetSelText(AValue:string);

  public
    property SelectedText:string read GetSelText write SetSelText;
    property Options[index:integer]:THTMLOption read GetOption write SetOption;
    procedure AddOption(AOption:THTMLOption);virtual;
    procedure RemoveOption(AOption:THTMLOption);virtual;

    function OptionCount:integer;virtual;
    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor Destroy;override;
  end;

  THTMLLabel = class (THTMLCustomControl)
  private
  protected
  public
  published
  end;
  THTMLEdit = class(THTMLInputControl)
  private
  protected
  public
  published
  end;
  THTMLCustomButton = class(THTMLInputControl)
  private
  protected
  public
  published
  end;

  THTMLButton = class(THTMLCustomButton)
  private
  protected
  public
  published
  end;
  THTMLResetButton = class(THTMLCustomButton)
  private
  protected
  public
  published
  end;
  THTMLSubmitButton = class (THTMLCustomButton)
  private
  protected
  public
  published
  end;

  THTMLCheckBox = class(THTMLInputControl)
  private
  protected
    //procedure ExtractPropValues;override;
    function  getChecked:boolean;
    procedure setChecked(NewValue:boolean);
  public
  published
    property Checked:boolean read getChecked write setChecked;
  end;
  THTMLComboBox = class(THTMLInputControl)
  private
  protected
  public
  published

  end;
  THTMLRadioButton = class(THTMLInputControl)
  private
    fSelected:boolean;
  protected
  public
  published
    property Selected:boolean read fSelected write fSelected;
  end;
  THTMLListBox = class(THTMLInputControl)
  private
  protected
  public
  published
  end;
  THTMLMemo = class(THTMLFormControl)
  private
  protected
    function GetValue:string;override;
    procedure SetValue(AValue:string);override;
  public
  published
  end;
  THTMLFile = class(THTMLFormControl)
  private
    //fFileStream:TFileStream;
    fFilename:string;
  protected
    function GetValue:string;override;
    procedure SetValue(AValue:string);override;
  public
     property fileName:string read fFileName write fFileName;
     destructor Destroy;override;
  published
  end;

  THTMLFormControls = class (THTMLElementCollection)
  private
  protected
  public
  published
  end;

  THTMLForm = class (THTMLElement)
  private
    fFormElements:THTMLElementCollection;
    fCheckBoxes:TObjectList;
    fFileName:string;
  protected
    function  GetMethod:THTMLFormMethods;
    procedure SetMethod(AMethod:THTMLFormMethods);
    function GetAction:string;
    procedure SetAction(AAction:string);
    //procedure ExtractPropValues;override;
    procedure SetControl(index:integer;AControl:THTMLFormControl);
    function GetControl(index:integer):THTMLFormControl;
    procedure AddControl(AControl:THTMLFormControl);
    procedure RemoveControl(AControl:THTMLFormControl);
    function GetCheckBox(index:integer):THTMLCheckBox;
    procedure SetCheckBox(index:integer;ACheckBox:THTMLCheckBox);

    procedure Set_dir(const p: string);
    function  Get_dir: string;
    procedure Set_encoding(const p: string);
    function  Get_encoding: string;
    function  getEncType:string;
    procedure setEncType(p: string);
    function  Get_elements: THTMLElementCollection;
    procedure Set_target(const p: string);
    function  Get_target: string;
    procedure Set_onsubmit(p: string);
    function  Get_onsubmit: string;
    procedure Set_onreset(p: string);
    function  Get_onreset: string;
  public
    property dir: string read Get_dir write Set_dir;
    property encoding: string read Get_encoding write Set_encoding;
    property elements: THTMLElementCollection read Get_elements;
    property target: string read Get_target write Set_target;
    property onsubmit: string read Get_onsubmit write Set_onsubmit;
    property onreset: string read Get_onreset write Set_onreset;

    property Controls[index:integer]:THTMLFormControl read GetControl write SetControl;
    property UploadFilename:string read fFilename write fFilename;
    function ControlCount:integer;
    property CheckBoxes[index:integer]:THTMLCheckBox read GetCheckBox write SetCheckBox;
    function CheckBoxCount:integer;
    function IndexOfControl(AControl:THTMLFormControl):integer;
    function ControlByName(ControlName:string):THTMLFormControl;
    function FindControl(ControlName:string):THTMLFormControl;
    Function GetPostVariables:string;
    procedure preparePostData(parser1:THTMLDecoder);

    procedure submit;overload;
    procedure submit(parser:THTMLDecoder);overload;
    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor destroy;override;
  published
    property Name;
    property action : string read GetAction write SetAction;
    property EncType: string read getEncType write setEncType;
    property Method:THTMLFormMethods read GetMethod write SetMethod;
  end;
  THTMLHeader = class (THTMLCustomControl)
  private
    FTitle : string;
    fVariables : TObjectList;
    fRefreshURL: string;
    fRefreshInterval:integer;
  protected
    function GetTitle:string;
    procedure SetTitle(ATitle:string);
    //procedure ExtractPropValues;override;
    procedure AddVariable(aVar:THTMLMeta);
    procedure RemoveVariable(aVar:THTMLMeta);
    function GetVariable(index:integer):THTMLMeta;
    procedure SetVariable(index:integer;aVar:THTMLMeta);
    function  getRefreshURL:string;
    function  getRefreshInterval:integer;
    procedure setRefreshInterval(p:integer);
  public
    property Variables[index:integer] : THTMLMeta read GetVariable write SetVariable;
    property RefreshURL:string read getRefreshURL write fRefreshURL;
    property RefreshInterval:integer read getRefreshInterval write setRefreshInterval;
    function VariableCount:integer;
    constructor create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor destroy;override;
  published
    property Title : string read GetTitle write SetTitle;
  end;
  THTMLBody = class (THTMLCustomControl)
  private
    FTopMargin : integer;
    FLeftMargin : integer;
  protected
  public
    property TopMargin : integer read FTopMargin write FTopMargin;
    property LeftMargin : integer read FLeftMargin write FLeftMargin;

    constructor create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor destroy;override;
  published
  end;
  THTMLNoFrames = class (THTMLElement)
  private
  protected
  public
  published
  end;
  THTMLFrameSet =class (THTMLElement)
  private
    fFrameCollection:THTMLFramesCollection;
  protected
    //procedure ExtractPropValues;override;
    function GetFrame(index:integer):THTMLFrame;
    procedure SetFrame(index:integer; aFrame:THTMLFrame);
    procedure AddFrame(aFrame:THTMLFrame);
    procedure RemoveFrame(aFrame:THTMLFrame);

    function  getFrameSpacing:string;
    procedure setFrameSpacing(p: string);
    function  getFrameBorder:string;
    procedure setFrameBorder(p: string);
    function  getBorder:string;
    procedure setBorder(p: string);
    function  getRows:string;
    procedure setfRows(p: string);
    function  getWidth:string;
    procedure setWidth(p: string);
  public
    property frames:THTMLFramesCollection read fFrameCollection;
    property FrameSpacing:string read getFrameSpacing write setFrameSpacing;
    property FrameBorder:string read getFrameBorder write setFrameBorder;
    property Border:string read getBorder write setBorder;
    property Rows:string read getRows write setfRows;
    property width:string read getWidth write setWidth;
    function Count:integer;
    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor destroy;override;
  end;

  THTMLFrame = class (THTMLElement)
  private
    fFrameSet:THTMLFrameSet;
    fFrameDocument:THTMLDocument;
  protected
    //procedure ExtractPropValues;override;
    procedure SetFrameSet(AFrameSet:THTMLFrameSet);
    function  getSrc:string;
    procedure setSrc(p: string);
    function  getScrolling:string;
    procedure setScrolling(p:string);
    function  Get_outerHTML:string;override;
    function  Get_innerHTML:string;override;
    function  getAutoLoadInnerFrames:boolean;
    procedure setAutoLoadInnerFrames(p:boolean);
    function  getAutoParseInnerFrames:boolean;
    procedure setAutoParseInnerFrames(p:boolean);
    function  getLoaded:boolean;


  public
    property FrameSet:THTMLFrameSet read fFrameSet write SetFrameSet;
    property FrameDoc:THTMLDocument read fFrameDocument;
    property Src:string read getSrc write setSrc;
    property Scrolling:string read getScrolling write setScrolling;
    procedure Load;
    procedure Parse;
    constructor Create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);override;
    destructor destroy;override;
  published
    property Loaded:boolean read getLoaded;
    property AutoLoadInnerFrames:boolean read getAutoLoadInnerFrames write setAutoLoadInnerFrames;
    property AutoParseInnerFrames:boolean read getAutoParseInnerFrames write setAutoParseInnerFrames;
  end;

  THTMLIFrame = class (THTMLFrame)
  end;
  THTMLMimeTypesCollection = class (THTMLCustomCollection)
  end;
  THTMLPluginsCollection = class (THTMLCustomCollection)
  end;
  THTMLOpsProfile = class (TPersistent)
  end;
  THTMLImageElementFactory = class (TPersistent)
  end;
  THTMLOmHistory = class (TPersistent)
  end;
  THTMLEventObj = class (TPersistent)
  end;
  THTMLScreen = class (TPersistent)
  end;
  THTMLOptionElementFactory = class (TPersistent)
  end;
  THTMLOmNavigator = class (TPersistent)
  private
  protected
    function  Get_appCodeName: string;
    function  Get_appName: string;
    function  Get_appVersion: string;
    function  Get_userAgent: string;
    function  Get_cookieEnabled: boolean;
    function  Get_javaEnabled: boolean;
    function  Get_taintEnabled: boolean;
    function  Get_mimeTypes: THTMLMimeTypesCollection;
    function  Get_plugins: THTMLPluginsCollection;
    function  Get_opsProfile: THTMLOpsProfile;
    function  Get_toString: string;
    function  Get_cpuClass: string;
    function  Get_systemLanguage: string;
    function  Get_browserLanguage: string;
    function  Get_userLanguage: string;
    function  Get_platform: string;
    function  Get_appMinorVersion: string;
    function  Get_connectionSpeed: Integer;
    function  Get_onLine: string;
    function  Get_userProfile: THTMLOpsProfile;
  public
    property appCodeName: string read Get_appCodeName;
    property appName: string read Get_appName;
    property appVersion: string read Get_appVersion;
    property userAgent: string read Get_userAgent;
    property mimeTypes: THTMLMimeTypesCollection read Get_mimeTypes;
    property plugins: THTMLPluginsCollection read Get_plugins;
    property cookieEnabled: boolean read Get_cookieEnabled;
    property javaEnabled:boolean read Get_javaEnabled;
    property taintEnabled: boolean read Get_taintEnabled;
    property opsProfile: THTMLOpsProfile read Get_opsProfile;
    property cpuClass: string read Get_cpuClass;
    property systemLanguage: string read Get_systemLanguage;
    property browserLanguage: string read Get_browserLanguage;
    property userLanguage: string read Get_userLanguage;
    property platform_: string read Get_platform;
    property appMinorVersion: string read Get_appMinorVersion;
    property connectionSpeed: Integer read Get_connectionSpeed;
    property onLine: string read Get_onLine;
    property userProfile: THTMLOpsProfile read Get_userProfile;
  end;
  THTMLWindow = class(THTMLFramesCollection)
  private
  protected
    function  Get_frames: THTMLFramesCollection;
    procedure Set_defaultStatus(const p: string);
    function  Get_defaultStatus: string;
    procedure Set_status(const p: string);
    function  Get_status: string;
    function  Get_Image: THTMLImageElementFactory;
    function  Get_location: THTMLLocation;
    function  Get_history: THTMLOmHistory;
    procedure Set_opener(p: string);
    function  Get_opener: string;
    function  Get_navigator: THTMLOmNavigator;
    procedure Set_name(const p: string);
    function  Get_name: string;
    function  Get_parent: THTMLWindow;
    function  Get_self: THTMLWindow;
    function  Get_top: THTMLWindow;
    function  Get_window: THTMLWindow;
    procedure Set_onfocus(p: string);
    function  Get_onfocus: string;
    procedure Set_onblur(p: string);
    function  Get_onblur: string;
    procedure Set_onload(p: string);
    function  Get_onload: string;
    procedure Set_onbeforeunload(p: string);
    function  Get_onbeforeunload: string;
    procedure Set_onunload(p: string);
    function  Get_onunload: string;
    procedure Set_onhelp(p: string);
    function  Get_onhelp: string;
    procedure Set_onerror(p: string);
    function  Get_onerror: string;
    procedure Set_onresize(p: string);
    function  Get_onresize: string;
    procedure Set_onscroll(p: string);
    function  Get_onscroll: string;
    function  Get_document: THTMLDocument;
    function  Get_event: THTMLEventObj;
    function  Get__newEnum: IUnknown;
    function  Get_screen: THTMLScreen;
    function  Get_Option: THTMLOptionElementFactory;
    function  Get_closed: boolean;
    function  Get_external: IDispatch;
    function  Get_clientInformation: THTMLOmNavigator;
    procedure Set_offscreenBuffering(p: string);
    function  Get_offscreenBuffering: string;

  public
    procedure close;
    function  open(const url: string; const name: string; const features: string;
                   replace: boolean): THTMLWindow;
    procedure navigate(const url: string);

    function  setTimeout(const expression: string; msec: Integer; var language: string): Integer;
    procedure clearTimeout(timerID: Integer);
    procedure alert(const message: string);
    function  confirm(const message: string): boolean;
    function  prompt(const message: string; const defstr: string): string;
    function  showModalDialog(const dialog: string; var varArgIn: string;
                              var varOptions: string): string;
    procedure showHelp(const helpURL: string; helpArg: string; const features: string);
    procedure focus;
    procedure blur;
    procedure scroll(x: Integer; y: Integer);

    function  setInterval(const expression: string; msec: Integer; var language: string): Integer;
    procedure clearInterval(timerID: Integer);
    function  execScript(const code: string; const language: string): string;
    function  toString: string;
    procedure scrollBy(x: Integer; y: Integer);
    procedure scrollTo(x: Integer; y: Integer);
    procedure moveTo(x: Integer; y: Integer);
    procedure moveBy(x: Integer; y: Integer);
    procedure resizeTo(x: Integer; y: Integer);
    procedure resizeBy(x: Integer; y: Integer);
    property frames: THTMLFramesCollection read Get_frames;
    property defaultStatus: string read Get_defaultStatus write Set_defaultStatus;
    property status: string read Get_status write Set_status;
    property Image: THTMLImageElementFactory read Get_Image;
    property location: THTMLLocation read Get_location;
    property history: THTMLOmHistory read Get_history;
    property opener: string read Get_opener write Set_opener;
    property navigator: THTMLOmNavigator read Get_navigator;
    property name: string read Get_name write Set_name;
    property parent: THTMLWindow read Get_parent;
    property self: THTMLWindow read Get_self;
    property top: THTMLWindow read Get_top;
    property window: THTMLWindow read Get_window;
    property onfocus: string read Get_onfocus write Set_onfocus;
    property onblur: string read Get_onblur write Set_onblur;
    property onload: string read Get_onload write Set_onload;
    property onbeforeunload: string read Get_onbeforeunload write Set_onbeforeunload;
    property onunload: string read Get_onunload write Set_onunload;
    property onhelp: string read Get_onhelp write Set_onhelp;
    property onerror: string read Get_onerror write Set_onerror;
    property onresize: string read Get_onresize write Set_onresize;
    property onscroll: string read Get_onscroll write Set_onscroll;
    property document: THTMLDocument read Get_document;
    property event: THTMLEventObj read Get_event;
    property _newEnum: IUnknown read Get__newEnum;
    property screen: THTMLScreen read Get_screen;
    property Option: THTMLOptionElementFactory read Get_Option;
    property closed: boolean read Get_closed;
    property clientInformation: THTMLOmNavigator read Get_clientInformation;
    property offscreenBuffering: string read Get_offscreenBuffering write Set_offscreenBuffering;
    property external_: IDispatch read Get_external;
  end;
  THTMLLocation = class(TPersistent)
  private
    //fCurrentHRef : string;
    fSession     : TInternetSession;
    fConnection  : TInternetConnection;
    fLoader      : TCustomInternetRequest;
    fDocument    : THTMLDocument;

    fPostBuffer  : string;
    fFilename    : string;
    fReferrerIn  : string;
    fReferrerOut : string;
  protected
    procedure Set_href(const p: string);      //Sets the entire URL as a string and Causes new url to be loaded.This will replace current document with new one!
    function  Get_href: string;               //Retrieves the entire URL as a string.
    procedure Set_protocol(const p: string);  //Sets the protocol portion of a URL.
    function  Get_protocol: string;           //Retireves the protocol portion of a URL.
    procedure Set_host(const p: string);      //Sets the hostname and port number of the location or URL.
    function  Get_host: string;               //Retrieves the hostname and port number of the location or URL.
    procedure Set_hostname(const p: string);  //Sets the host name part of the location or URL.
    function  Get_hostname: string;           //Retrieves the host name part of the location or URL.
    procedure Set_port(const p: string);      //Sets the port number associated with a URL.
    function  Get_port: string;               //Retrieves the port number associated with a URL.
    procedure Set_pathname(const p: string);  //Sets the file name or path specified by the object.
    function  Get_pathname: string;           //Retrieves the file name or path specified by the object.
    procedure Set_search(const p: string);    //Sets the substring of the href property that follows the question mark.
    function  Get_search: string;             //Retrieves the substring of the href property that follows the question mark.
    procedure Set_hash(const p: string);      //Sets the subsection of the THTMLAnchor.href property that follows the number sign (#).
    function  Get_hash: string;               //Retrieves the subsection of the THTMLAnchor.href property that follows the number sign (#).
    function  getReferrer:string;
    procedure setReferrer(p:string);
    // event hooks
    procedure doOnLoaded(Sender:TObject;hInet:HINTERNET; Stream:TStream);

    //event properties helpers
    function  getOnProgress:TInternetOnProgressEvent;
    procedure setOnProgress(p:TInternetOnProgressEvent);
    function  getOnRedirect:TInternetOnRedirectEvent;
    procedure setOnRedirect(p:TInternetOnRedirectEvent);
    //function  getOnResume:TOnResumeEvent;
    //procedure setOnResume(p:TOnResumeEvent);
    //function  getBeginningTransAction:TBeginningTransActionEvent;
    //procedure setBeginningTransAction(p:TBeginningTransActionEvent);
    //function  getOnResponse:TOnResponseEvent;
    //procedure setOnResponse(p:TOnResponseEvent);
    //function  getOnAuthenticate:TAuthenticateEvent;
    //procedure setOnAuthenticate(p:TAuthenticateEvent);
    //function  getOnComplete:TOnCompleteEvent;
    //procedure setOnComplete(p:TOnCompleteEvent);
    //function  getOnData:TOnDataEvent;
    //procedure setOnData(p:TOnDataEvent);
    //function  getGetwindow:TGetWindowEvent;
    //procedure setGetwindow(p:TGetWindowEvent);
    //function  getOnSecurityProblem:TOnSecurityProblemEvent;
    //procedure setOnSecurityProblem(p:TOnSecurityProblemEvent);

  public
    property  Connection:TInternetConnection read fConnection write fconnection;
    property  Loader   : TCustomInternetRequest read fLoader write fLoader;    //TCP/IP Communucation Interface of object
    //property  Buffer : TMemoryStream read fBuffer;
    property  Document : THTMLDocument read fDocument write fDocument;
    procedure reload(flag: Boolean);               //Reloads the current page.
    procedure replace(const bstr: string);         //Replaces the current document by loading another document at the specified URL.
    procedure Assign_(const bstr: string);         //Loads a new HTML document.
    function  toString: string;                    //Retrieves a string representation of the object.
    constructor Create(aDocument:THTMLDocument);   //Creates new instance of THTMLLocation Object;
    destructor  Destroy;override;                  //Releases this instance of THTMLLocation Object;
  published
    property referrer : string read getReferrer write setReferrer;     //Sets or Retrieves referrer of current location. After each navigation this property will be cleared. Typically this property set by THTMLAnchor element if its click method called.
    property href: string read Get_href write Set_href;                //Sets or retrieves the entire URL as a string and Causes new url to be loaded this will replace current document with new one!
    property protocol: string read Get_protocol write Set_protocol;    //Sets or retrieves the protocol portion of a URL.
    property host: string read Get_host write Set_host;                //Sets or retrieves the hostname and port number of the location or URL.
    property hostname: string read Get_hostname write Set_hostname;    //Sets or retrieves the host name part of the location or URL.
    property port: string read Get_port write Set_port;                //Sets or retrieves the port number associated with a URL.
    property pathname: string read Get_pathname write Set_pathname;    //Sets or retrieves the file name or path specified by the object.
    property search: string read Get_search write Set_search;          //Sets or retrieves the substring of the THTMLAnchor.href property that follows the question mark.
    property hash: string read Get_hash write Set_hash;                //Sets or retrieves the subsection of the THTMLAnchor.href property that follows the number sign (#).
    property PostBuffer: string read fPostBuffer write fPostBuffer;    //Used to post forms datas. If this property contains data, then next request method will be post and after each request this buffer will be cleared.
    property Filename:string read fFileName write fFilename;           //Used to post (upload) a file.
    //events
    property OnProgress: TInternetOnProgressEvent read getOnProgress write setOnProgress;
    property OnRedirect:TInternetOnRedirectEvent read getOnRedirect write setOnRedirect;
    //property OnResume: TOnresumeEvent read getOnResume write setOnResume;
    //property OnBeginningTransaction: TBeginningTransActionEvent read getBeginningTransAction write setBeginningTransAction;
    //property OnResponse: TOnResponseEvent read getOnResponse write setOnResponse;
    //property OnAuthenticate: TAuthenticateEvent read getOnAuthenticate write setOnAuthenticate;
    //property OnComplete: TOnCompleteEvent read getOnComplete write setOnComplete;
    //property OnData: TOnDataEvent read getOnData write setOnData;
    //property OnGetWindow: TGetWindowEvent read getGetwindow write setGetwindow;
    //property OnSecurityProblem: TOnSecurityProblemEvent read getOnSecurityProblem write setOnSecurityProblem;

  end;

  THTMLDocument = class (THTMLElement)
  private
    fDecoder          : THTMLDecoder;
    fHeader           : THTMLHeader;
    fBody             : THTMLBody;
    fFormCollection   : THTMLFormCollection;
    fTableCollection  : THTMLTableCollection;
    fAnchorCollection : THTMLAnchorCollection;
    fImageCollection  : THTMLImageCollection;
    fFrameCollection  : THTMLFramesCollection;
    fStylesCollection : THTMLStyleSheetsCollection;
    fScriptsCollection: THTMLScriptsCollection;
    fonParseError     : THTMLOnParseErrorEvent;
    fFrameSet         : THTMLFrameSet;
    fParser           : THTMLParser;
    fLocation         : THTMLLocation;
    fCookieHandling   : THTTPCookieHandlingTypes;
    fEditMode         : boolean;
    fAutoLoad         : boolean;
    fAutoParse        : boolean;
    fAutoLoadFrames   : boolean;
    fAutoParseFrames  : boolean;
    fRawHTML          : TStrings;
    fTrytoFixProblems : boolean;
    fProduceXMLCompatibleHTML : boolean;
    fReFormatOutputHTML       : boolean;
    fAddParsingErrorComments  : boolean;
    fParsed           : boolean;
  protected
    fOldOnLoaded        : TInternetOnLoadedEvent;
    function  GetFormattedTagStr(IndentCount:integer;Indent_Ch:char;TagStrType:TTagStrTypes):string;override;
    function  GetHeader:THTMLHeader;
    function  GetBody:THTMLBody;
    function  GetTitle:string;
    procedure SetHeader(AHeader:THTMLHeader);
    procedure SetBody(ABody:THTMLBody);
    procedure SetTitle(ATitle:string);
    procedure AddTable(ATable:THTMLTable);
    procedure RemoveTable(ATable:THTMLTable);
    procedure AddForm(AForm:THTMLForm);
    procedure RemoveForm(AForm:THTMLForm);
    procedure AddAnchor(aAnchor:THTMLAnchor);
    procedure RemoveAnchor(aAnchor:THTMLAnchor);
    procedure AddImage(aImage:THTMLImage);
    procedure RemoveImage(aImage:THTMLImage);
    procedure AddStyleSheet(aStyleSheet:THTMLStyleElement);
    procedure RemoveStyleSheet(aStyleSheet:THTMLStyleElement);
    procedure AddScript(aScript:THTMLScript);
    procedure RemoveScript(aScript:THTMLScript);

    function  getBaseHRef:string;
    procedure setBaseHRef(p: string);
    procedure doProgress(StatusText:string; Progress,ProgressMax:dword);

    function  Get_parentWindow:THTMLWindow;
    function  Get_styleSheets:THTMLStyleSheetsCollection;
    function  Get_onbeforeupdate:string;
    procedure Set_onbeforeupdate(p:string);
    function  Get_onerrorupdate:string;
    procedure Set_onerrorupdate(p:string);
    procedure Set_onreadystatechange(p: string);
    function  Get_onreadystatechange: string;
    procedure Set_onafterupdate(p: string);
    function  Get_onafterupdate: string;
    procedure Set_onrowexit(p: string);
    function  Get_onrowexit: string;
    procedure Set_onrowenter(p: string);
    function  Get_onrowenter: string;
    procedure Set_ondragstart(p: string);
    function  Get_ondragstart: string;
    procedure Set_onselectstart(p: string);
    function  Get_onselectstart: string;

    procedure Set_alinkColor(p: string);
    function  Get_alinkColor: string;
    procedure Set_bgColor(p: string);
    function  Get_bgColor: string;
    procedure Set_fgColor(p: string);
    function  Get_fgColor: string;
    procedure Set_linkColor(p: string);
    function  Get_linkColor: string;
    procedure Set_vlinkColor(p: string);
    function  Get_vlinkColor: string;
    function  Get_referrer: string;
    procedure Set_referrer(p: string);
    function  Get_location: THTMLLocation;
    procedure Set_location(p: THTMLLocation);
    function  Get_lastModified: string;
    procedure Set_url(const p: string);
    function  Get_url: string;
    procedure Set_domain(const p: string);
    function  Get_domain: string;
    //procedure Set_cookies(const p: THTTPCookies);
    function  Get_cookies: THTTPCookies;
    procedure Set_expando(p: boolean);
    function  Get_expando: boolean;
    procedure Set_charset(const p: string);
    function  Get_charset: string;
    function  Get_contentType: string;
    procedure Set_contentType (p: string);
    procedure Set_defaultCharset(const p: string);
    function  Get_defaultCharset: string;
    function  Get_mimeType: string;
    function  Get_fileSize: string;
    function  Get_fileCreatedDate: string;
    function  Get_fileModifiedDate: string;
    function  Get_fileUpdatedDate: string;
    function  Get_security: string;
    function  Get_protocol: string;
    function  Get_nameProp: string;
    function  getCookieHandling:THTTPCookieHandlingTypes;
    procedure setCookieHandling(p:THTTPCookieHandlingTypes);
    function  getOnProgress: TInternetOnProgressEvent;
    procedure setOnProgress(p:TInternetOnProgressEvent);
    function  getOnRedirect:TInternetOnRedirectEvent;
    procedure setOnRedirect(p:TInternetOnRedirectEvent);
    function  getEditMode:boolean;
    procedure setEditMode(p:boolean);
    function  getAutoLoadFrames:boolean;
    procedure setAutoLoadFrames(p:boolean);
    function  getAutoParseFrames:boolean;
    procedure setAutoParseFrames(p:boolean);
    function  getAutoLoad:boolean;
    procedure setAutoLoad(p:boolean);
    function  getAutoParse:boolean;
    procedure setAutoParse(p:boolean);
    function  getRawHTML:TStrings;
    procedure setRawHTML(p:TStrings);
    function  getLoaded:boolean;
    function  getProduceXMLCompatibleHTML:boolean;
    procedure setProduceXMLCompatibleHTML(p:boolean);
  public
    //Main Parts of Document
    property Header: THTMLHeader read GetHeader write SetHeader;
    property Body  : THTMLBody read GetBody write SetBody;
    //Collections
    property Anchors     : THTMLAnchorCollection read fAnchorCollection;
    property Tables      : THTMLTableCollection  read fTableCollection;
    property Forms       : THTMLFormCollection   read fFormCollection;
    property Images      : THTMLImageCollection  read fImageCollection;
    property Frames      : THTMLFramesCollection  read fFrameCollection write fFrameCollection;
    property styleSheets : THTMLStyleSheetsCollection read Get_styleSheets;
    property scripts     : THTMLScriptsCollection read fScriptsCollection;
    //Extensions to HTML 4.02 W3C DOM Standart
    property FrameSet:THTMLFrameSet read fFrameSet write fFrameSet;
    function TableCount:integer;
    function FormCount:integer;
    function TableByName(TableName:string):THTMLTable;
    function FormByName(FormName:string):THTMLForm;
    function getElementById(id:string):THTMLElement;
    function getAbsoluteURL(relativeURL:string):string;
    procedure ConvertToLocalFile(var fileName:string);
    procedure SaveToFile(fileName:string);
    procedure ProcessMetaRefresh;
    procedure Load;
    procedure Parse;
    procedure LoadFrames(Parse:boolean);
    procedure ParseFrames;
    procedure LoadHTML(HtmlCode:string;TrytoFixProblems:boolean);
    //end of extensions
    property alinkColor: string read Get_alinkColor write Set_alinkColor;
    property bgColor: string read Get_bgColor write Set_bgColor;
    property fgColor: string read Get_fgColor write Set_fgColor;
    property linkColor: string read Get_linkColor write Set_linkColor;
    property vlinkColor: string read Get_vlinkColor write Set_vlinkColor;
    property referrer: string read Get_referrer write Set_referrer;
    property location: THTMLLocation read Get_location write Set_location;
    property lastModified: string read Get_lastModified;
    property url: string read Get_url write Set_url;
    property domain: string read Get_domain write Set_domain;
    property cookies: THTTPCookies read Get_cookies {write Set_cookies};
    property expando: Boolean read Get_expando write Set_expando;
    property charset: string read Get_charset write Set_charset;
    property contentType:string read get_contentType write Set_contentType;
    property defaultCharset: string read Get_defaultCharset write Set_defaultCharset;
    property mimeType: string read Get_mimeType;
    property fileSize: string read Get_fileSize;
    property fileCreatedDate: string read Get_fileCreatedDate;
    property fileModifiedDate: string read Get_fileModifiedDate;
    property fileUpdatedDate: string read Get_fileUpdatedDate;
    property security: string read Get_security;
    property protocol: string read Get_protocol;
    property nameProp: string read Get_nameProp;

    property BaseHRef: string read getBaseHRef write setBaseHRef;
    property parentWindow: THTMLWindow read Get_parentWindow;
    property onbeforeupdate: string read Get_onbeforeupdate write Set_onbeforeupdate;
    property onerrorupdate: string read Get_onerrorupdate write Set_onerrorupdate;

    constructor Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);override;
    destructor destroy;override;
  published
    property Decoder:THTMLDecoder read fDecoder write fDecoder;
    property Parsed:boolean read fParsed;
    property ProduceXMLCompatibleHTML:boolean read getProduceXMLCompatibleHTML write setProduceXMLCompatibleHTML;
    property ReFormatOutputHTML:boolean read fReFormatOutputHTML write fReFormatOutputHTML;
    property AddParsingErrorComments:boolean read fAddParsingErrorComments write fAddParsingErrorComments;
    property Loaded: boolean read getLoaded;
    property Title : string read GetTitle write SetTitle;
    property CookieHandling:THTTPCookieHandlingTypes read getCookieHandling write setCookieHandling;
    property EditMode:boolean read getEditMode write setEditMode;
    property AutoLoad:boolean read getAutoLoad write setAutoLoad;
    property AutoParse:boolean read getAutoParse write setAutoParse;
    property AutoLoadFrames:boolean read getAutoLoadFrames write setAutoLoadFrames;
    property AutoParseFrames:boolean read getAutoParseFrames write setAutoParseFrames;
    property RawHTML:TStrings read getRawHTML write setRawHTML;
    property TrytoFixProblems:boolean read fTrytoFixProblems write fTrytoFixProblems;

    property onreadystatechange: string read Get_onreadystatechange write Set_onreadystatechange;
    property onafterupdate: string read Get_onafterupdate write Set_onafterupdate;
    property onrowexit: string read Get_onrowexit write Set_onrowexit;
    property onrowenter: string read Get_onrowenter write Set_onrowenter;
    property ondragstart: string read Get_ondragstart write Set_ondragstart;
    property onselectstart: string read Get_onselectstart write Set_onselectstart;

    property onParseError: THTMLOnParseErrorEvent read fonParseError write fonParseError;
    property OnProgress : TInternetOnProgressEvent read getOnProgress write setOnProgress;
    property OnRedirect : TInternetOnRedirectEvent read getOnRedirect write setOnRedirect;
  end;

  THTMLDecoder=class(TComponent)
  private
    fUseFontTagsAsParent: boolean;
    fUseSeperateTextTags: boolean;
    fRemoveControlChars : boolean;
    FCode               : TStrings;
    FParsedCode         : TStrings;
    fHTMLDocument       : THTMLDocument;
    fURL                : string;
    fTempHttpRequest    : TCustomInternetRequest;

  protected
    function  GetParsedCode:TStrings;
    //Procedure ExtractPropsFromTag(TagStr:string;var TagCmd:String;Props:TStrings);
    function  GetTagClass(TagStr:string):THTMLElementClasses;
    Function  GetTagCmd(TagStr:string):string;
    procedure OnHTMLCodeChange(Sender:TObject);
    function  getURL:string;
    procedure setURL(p:string);
    function  getCurrentUser:string;
    procedure setCurrentUser(p:string);
    function  getCookieHandling:THTTPCookieHandlingTypes;
    procedure setCookieHandling(p:THTTPCookieHandlingTypes);
    function  getOnProgress:TInternetOnProgressEvent;
    procedure setOnProgress(p:TInternetOnProgressEvent);
    function  getOnRedirect:TInternetOnRedirectEvent;
    procedure setOnRedirect(p:TInternetOnRedirectEvent);
    function  getTrytoFixProblems:boolean;
    procedure setTrytoFixProblems(p:boolean);

    function  getOnParsingError:THTMLOnParseErrorEvent;
    procedure setOnParsingError(p:THTMLOnParseErrorEvent);
    function  getAddParsingErrorComments:boolean;
    procedure setAddParsingErrorComments(p:boolean);
    function  getReFormatOutputHTML:boolean;
    procedure setReFormatOutputHTML(p:boolean);
    function  getHttpRequest:TCustomInternetRequest;
    procedure SetHttpRequest(p:TCustomInternetRequest);
    procedure Loaded;override;

  public
    property Document:THTMLDocument read fHTMLDocument write fHTMLDocument;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure GetObjects(AObjectType:THTMLElementClasses;ObjectList:TList);
    function GetTextTag(TextToSearch:string;Exact:boolean):THTMLElement;overload;
    function GetTextTag(StartFrom:integer;TextToSearch:string;Exact:boolean):THTMLElement;overload;
    function GetTextTag(StartFrom:integer;TextToSearch:string;Exact:boolean;Recursive:boolean):THTMLElement;overload;
    procedure ConvertToLocalFile(var fileName:string);
    procedure ProcessMetaRefresh;
  published
     property HttpRequest:TCustomInternetRequest read getHttpRequest write SetHttpRequest;
     property AddParsingErrorComments:boolean read getAddParsingErrorComments write setAddParsingErrorComments;
     property ReFormatOutputHTML:boolean read getReFormatOutputHTML write setReFormatOutputHTML;
     property UseFontTagsAsParent:boolean read fUseFontTagsAsParent write fUseFontTagsAsParent;
     property UseSeperateTextTags:boolean read fUseSeperateTextTags write fUseSeperateTextTags;
     property RemoveControlChars :boolean read fRemoveControlChars  write fRemoveControlChars;
     property URL:string read getURL write setURL;
     property CurrentUser:string read getCurrentUser write setCurrentUser;
     property CookieHandling:THTTPCookieHandlingTypes read getCookieHandling write setCookieHandling;
     property TrytoFixProblems:boolean read getTrytoFixProblems write setTrytoFixProblems;
     property OnProgress : TInternetOnProgressEvent read getOnProgress write setOnProgress;
     property OnRedirect : TInternetOnRedirectEvent read getOnRedirect write setOnRedirect;
     property OnParsingError:THTMLOnParseErrorEvent read getOnParsingError write setOnParsingError;
  end;

const
  c_HTMLElementClasses :array[THTMLTagTypes] of TClass = (
        {htDocType}      THTMLDocument,
        {htHtml}         THTMLhtml,
        {htHead}         THTMLHeader,
        {htBody}         THTMLBody,
        {htMeta}         THTMLMeta,
        {htTitle}        THTMLTitle,
        {htHeaderLink}   THTMLLink,
        {htFont}         THTMLFont,
        {htBold}         THTMLBold,
        {htForm}         THTMLForm,
        {htP}            THTMLParagraph,
        {htBr}           THTMLBreak,
        {htInput}        THTMLInputControl,
        {htInputHidden}  THTMLHiddenFormVar,
        {htTextArea}     THTMLMemo,
        {htScript}       THTMLScript,
        {htNoScript}     THTMLNoScript,
        {htDiv}          THTMLDiv,
        {htTableCol}     THTMLCell,
        {htTableBody}    THTMLTableBody,
        {htTableRow}     THTMLRow,
        {htTable}        THTMLTable,
        {htImage}        THTMLImage,
        {htAnchor}       THTMLAnchor,
        {htSpan}         THTMLSpan,
        {htCenter}       THTMLCenter,
        {htStyle}        THTMLStyleElement,
        {htOption}       THTMLOption,
        {htSelect}       THTMLSelect,
        {htH1}           THTMLh1,
        {htH2}           THTMLh2,
        {htH3}           THTMLh3,
        {htH4}           THTMLh4,
        {htH5}           THTMLh5,
        {htH6}           THTMLh6,
        {htSup}          THTMLSup,
        {htArea}         THTMLArea,
        {htMap}          THTMLMap,
        {htNoBr}         THTMLNoBr,
        {htTH}           THTMLth,
        {htLabel}        THTMLlabel,
        {htI}            THTMLi,
        {htBlockQuote}   THTMLblockquote,

        {htCite}         THTMLCite,
        {htDel}          THTMLDel,
        {htLegend}       THTMLLegend,
        {htQ}            THTMLQ,
        {htKbd}          THTMLKbd,
        {htDfn}          THTMLDfn,
        {htStrike}       THTMLStrike,
        {htIns}          THTMLIns,
        {htSamp}         THTMLSamp,
        {htAcronym}      THTMLAcronym,
        {htXMP}          THTMLXmp,
        {htAddress}      THTMLAddress,
        {htSmall}        THTMLSmall,

        {htStrong}       THTMLStrong,
        {htPre}          THTMLPre,
        {htLeft}         THTMLLeft,
        {htU}            THTMLu,
        {htLi}           THTMLli,
        {htUl}           THTMLul,
        {htPlainText}    THTMLText,
        {htNoFrames}     THTMLNoFrames,
        {htFrameSet}     THTMLFrameSet,
        {htFrame}        THTMLFrame,
        {htCode}         THTMLCode,
        {htHR}           THTMLHR,
        {htEm}           THTMLEm,
        {htIFrame}       THTMLIFrame,
        {htBgSound}      THTMLBgSound,
        {htDL}           THTMLDl,
        {htDD}           THTMLDd,
        {htDT}           THTMLDt,
        {htTableFoot}    THTMLTableFoot,
        {htTableHead}    THTMLTableHead,
        {htWBR}          THTMLWbr,
        {htBase}         THTMLBase,
        {htBasefont}     THTMLBaseFont,
        {htColGroup}     THTMLColGroup,
        {htCol}          THTMLCol,
        {htCaption}      THTMLCaption,
        {htDir}          THTMLDir,
        {htMenu}         THTMLMenu,
        {htOl}           THTMLOl,
        {htObject}       THTMLObject,
        {htEmbed}        THTMLEmbed,
        {htApplet}       THTMLApplet,
        {htParam}        THTMLParam,
        {htComment}      THTMLComment,
        {htCodeFormat_LF}  THTMLElement,
        {htCodeFormat_CR}  THTMLElement,
        {htCodeFormat_TAB} THTMLElement,
        {htCodeFormat_CRLF}THTMLElement,
        {htUnkown}       THTMLElement);



procedure Register;

procedure AddBodyEndTag(ParsedHTML:TStrings);forward;
var
  TrytoFixProblems:boolean;

implementation

procedure Register;
begin
  RegisterComponents('Internet',[THTMLDecoder]);
end;

{Utilities}
{                                                                              }
{ US-ASCII String functions                                                    }
{                                                                              }
function IsUSASCIIString(const S: AnsiString): Boolean;
var I : Integer;
    P : PAnsiChar;
begin
  P := Pointer(S);
  For I := 1 to Length(S) do
    if Ord(P^) >= $80 then
      begin
        Result := False;
        exit;
      end
    else
      Inc(P);
  Result := True;
end;
{                                                                              }
{ UTF-8 character conversion functions                                         }
{                                                                              }

{ UTF8ToUCS4Char returns UTF8ErrorNone if a valid UTF-8 sequence was decoded   }
{ (and Ch contains the decoded UCS4 character and SeqSize contains the size    }
{ of the UTF-8 sequence). If an incomplete UTF-8 sequence is encountered, the  }
{ function returns UTF8ErrorIncompleteEncoding and SeqSize > Size. If an       }
{ invalid UTF-8 sequence is encountered, the function returns                  }
{ UTF8ErrorInvalidEncoding and SeqSize (<= Size) is the size of the            }
{ invalid sequence, and Ch may be the intended character.                      }
function UTF8ToUCS4Char(const P: PChar; const Size: Integer;
    out SeqSize: Integer; out Ch: UCS4Char): TUTF8Error;
var C, D : Byte;
    V    : LongWord;
    I    : Integer;
begin
  if not Assigned(P) or (Size <= 0) then
    begin
      SeqSize := 0;
      Ch := 0;
      Result := UTF8ErrorInvalidBuffer;
      exit;
    end;
  C := Ord(P^);
  if C < $80 then
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorNone;
      exit;
    end;
  // multi-byte characters always start with 11xxxxxx ($C0)
  // following bytes always start with 10xxxxxx ($80)
  if C and $C0 = $80 then
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorInvalidEncoding;
      exit;
    end;
  if C and $20 = 0 then // 2-byte sequence
    begin
      SeqSize := 2;
      V := C and $1F;
    end else
  if C and $10 = 0 then // 3-byte sequence
    begin
      SeqSize := 3;
      V := C and $0F;
    end else
  if C and $08 = 0 then // 4-byte sequence (max needed for Unicode $0-$1FFFFF)
    begin
      SeqSize := 4;
      V := C and $07;
    end else
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorInvalidEncoding;
      exit;
    end;
  if Size < SeqSize then // incomplete
    begin
      Ch := C;
      Result := UTF8ErrorIncompleteEncoding;
      exit;
    end;
  For I := 1 to SeqSize - 1 do
    begin
      D := Ord(P[I]);
      if D and $C0 <> $80 then // following byte must start with 10xxxxxx
        begin
          SeqSize := 1;
          Ch := C;
          Result := UTF8ErrorInvalidEncoding;
          exit;
        end;
      V := (V shl 6) or (D and $3F); // decode 6 bits
    end;
  Ch := V;
  Result := UTF8ErrorNone;
end;

function UTF8ToWideChar(const P: PChar; const Size: Integer;
    out SeqSize: Integer; out Ch: WideChar): TUTF8Error;
var Ch4 : UCS4Char;
begin
  Result := UTF8ToUCS4Char(P, Size, SeqSize, Ch4);
  if Ch4 > $FFFF then
    begin
      Result := UTF8ErrorOutOfRange;
      Ch := #$0000;
    end else
    Ch := WideChar(Ch4);
end;

function UTF8StringToLongString(const S: String): String;
var P       : PChar;
    Q       : PChar;
    L, M, I : Integer;
    C       : WideChar;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if IsUSASCIIString(S) then // optimize for US-ASCII strings
    begin
      Result := S;
      exit;
    end;
  // Decode UTF-8
  P := Pointer(S);
  SetLength(Result, L); // maximum size
  Q := Pointer(Result);
  M := 0;
  Repeat
    UTF8ToWideChar(P, L, I, C);
    Assert(I > 0, 'I > 0');
    //if Ord(C) > $FF then
    //  raise EConvertError.Create(SLongStringConvertError);
    Q^ := Char(Ord(C));
    Inc(Q);
    Inc(M);
    Inc(P, I);
    Dec(L, I);
  Until L <= 0;
  SetLength(Result, M); // actual size
end;

function getFormMethod(MethodTypeStr:string):THTMLFormMethods;
var i:THTMLFormMethods;
begin
  result:=low(THTMLFormMethods);
  for i:=low(THTMLFormMethods) to high(THTMLFormMethods) do
    if compareText(c_HTMLFormMethods[i],MethodTypeStr)=0 then
    begin
      result:=i;
      break;
    end;
end;

function TranslateHtmlChar(HtmlChar:string):char;
var
  i:byte;
begin
(*  these are synonyms
{¦} '&#166;',  // '&brvbar;'  //Broken vertical bar
{¨} '&#168;',  // '&die;'     //Diæresis / Umlaut
{¯} '&#175;',  // '&hibar;'   //Macron accent
{ü} '&uuml;'
{ä} '&auml;'
{ö} '&ouml;'
*)
  result:=' ';
  for i:=1 to 255 do
  begin
    if (compareStr(c_HTMLSpecChIds[i],HtmlChar)=0) or (compareStr(c_HTMLSpecChNames[i],HtmlChar)=0) then
    begin
      if i=128 then
        result:='€'
      else
      if i=150 then
        result:='-'
      else
        result:=char(i);
      break;
    end;
  end;
end;
function DecodeHTMLText(RawHTMLText:string):string;
var
  i,t:integer;
  p:pchar;
  res,rs:pchar;
  s:string;
begin
  p:=pchar(RawHTMLText);
  getMem(res,length(RawHTMLText)+100);
  rs:=res;
  result:='';
  try
    while p^<>#0 do
      if p^='&' then
      begin
        s:='&';
        for i:=1 to 10 do
        begin
          s:=s+pchar(p+i)^;
          if pchar(p+i)^=';' then
            break;
        end;
        t:=pos(';',s);
        if t>0 then
        begin
          s:=copy(s,1,t);
          p:=p+length(s);
          res^:=TranslateHtmlChar(s);
          inc(res);
        end
        else
        begin
           res^:=p^;
           inc(res);
           inc(p);
        end;
      end
      else
      begin
       res^:=p^;
       inc(res);
       inc(p);
      end;
    //inc(res);
    res^:=#0;
    //OemTochar(rs,rs);
    result:=string(rs);

  finally
    freeMem(rs,length(RawHTMLText)+100);
  end;
end;


function isTag(tagStr:string):boolean;
begin
  result:=false;
  if length(tagStr)>1 then
    if tagStr[1]='<' then
      result:=true;
end;
var
  vHTMLSortedTagNames:array[byte] of string;
  vHTMLSortedTagIds:array[byte] of THTMLTagTypes;
function GetTagType(TagName:string):THTMLTagTypes;
  function qFind(bPos,ePos:integer;var res:THTMLTagTypes):boolean;
  var
    m:integer;
    comp_b:integer;
    comp_m:integer;
    comp_e:integer;

  begin
    result:=false;
    m:=bPos+((ePos-bPos) div 2);
    begin
      comp_b:=CompareText(TagName,vHTMLSortedTagNames[bPos]);
      comp_m:=CompareText(TagName,vHTMLSortedTagNames[m]);
      comp_e:=CompareText(TagName,vHTMLSortedTagNames[ePos]);
      if comp_b=0 then
      begin
        res:=vHTMLSortedTagIds[bPos];
        result:=true;
        exit;
      end
      else
      if comp_m=0 then
      begin
        res:=vHTMLSortedTagIds[m];
        result:=true;
        exit;
      end
      else
      if comp_e=0 then
      begin
        res:=vHTMLSortedTagIds[ePos];
        result:=true;
        exit;
      end
      else
      if m<>bPos then
      begin
        if (comp_m<0) and (comp_b>0) then
          result:=qFind(bPos,m-1,res)
        else
         if (comp_e<0) then
           result:=qFind(m+1,ePos,res);
      end;
    end;
  end;
begin
  if not qFind(integer(low(THTMLTagTypes)),integer(high(THTMLTagTypes)),result) then
    result:=htUnknown;
  {result:=htUnknown;
  if  qFind(integer(low(THTMLTagTypes)),integer(high(THTMLTagTypes)),result) then
  begin
    result:=result;
  end
  else
  for i:=low(THTMLTagTypes) to high(THTMLTagTypes) do
    if CompareText(c_HTMLTagIds[i],TagName)=0 then
    begin
      result:=i;
      break;
    end;
  }
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Find the count'th occurence of the s string in the t string.              }
{ If count < 0 then look from the back                                      }
function Posn(const s , t : String; Count : Integer) : Integer;
var
    i, h, Last : Integer;
    u          : String;
begin
    u := t;
    if Count > 0 then begin
        Result := Length(t);
        for i := 1 to Count do begin
            h := Pos(s, u);
            if h > 0 then
                u := Copy(u, h + 1, Length(u))
            else begin
                u := '';
                Inc(Result);
            end;
        end;
        Result := Result - Length(u);
    end
    else if Count < 0 then begin
        Last := 0;
        for i := Length(t) downto 1 do begin
            u := Copy(t, i, Length(t));
            h := Pos(s, u);
            if (h <> 0) and ((h + i) <> Last) then begin
                Last := h + i - 1;
                Inc(count);
                if Count = 0 then
                    break;
            end;
        end;
        if Count = 0 then
            Result := Last
        else
            Result := 0;
    end
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

procedure ParseURL(const url : String;var Proto, User, Pass, Host, Port, Path : String);
var
    p, q, i : Integer;
    s       : String;
    CurPath : String;
begin
    CurPath := Path;
    proto   := '';
    User    := '';
    Pass    := '';
    Host    := '';
    Port    := '';
    Path    := '';

    if Length(url) < 1 then
        Exit;

    { Handle path beginning with "./" or "../".          }
    { This code handle only simple cases !               }
    { Handle path relative to current document directory }
    if (Copy(url, 1, 2) = './') then begin
        p := Posn('/', CurPath, -1);
        if p > Length(CurPath) then
            p := 0;
        if p = 0 then
            CurPath := '/'
        else
            CurPath := Copy(CurPath, 1, p);
        Path := CurPath + Copy(url, 3, Length(url));
        Exit;
    end
    { Handle path relative to current document parent directory }
    else if (Copy(url, 1, 3) = '../') then begin
        p := Posn('/', CurPath, -1);
        if p > Length(CurPath) then
            p := 0;
        if p = 0 then
            CurPath := '/'
        else
            CurPath := Copy(CurPath, 1, p);

        s := Copy(url, 4, Length(url));
        { We could have several levels }
        while TRUE do begin
            CurPath := Copy(CurPath, 1, p-1);
            p := Posn('/', CurPath, -1);
            if p > Length(CurPath) then
                p := 0;
            if p = 0 then
                CurPath := '/'
            else
                CurPath := Copy(CurPath, 1, p);
            if (Copy(s, 1, 3) <> '../') then
                break;
            s := Copy(s, 4, Length(s));
        end;

        Path := CurPath + Copy(s, 1, Length(s));
        Exit;
    end;

    p := pos('://',url);
    q := p;
    if p <> 0 then begin
        S := Copy(url, 1, p - 1);
        for i := 1 to Length(S) do begin
            if not (S[i] in UriProtocolSchemeAllowedChars) then begin
                q := i;
                Break;
            end;
        end;
        if q < p then begin
            p     := 0;
            proto := 'http';
        end;
    end;
    if p = 0 then begin
        if (url[1] = '/') then begin
            { Relative path without protocol specified }
            proto := 'http';
            p     := 1;
            if (Length(url) > 1) and (url[2] <> '/') then begin
                { Relative path }
                Path := Copy(url, 1, Length(url));
                Exit;
            end;
        end
        else if lowercase(Copy(url, 1, 5)) = 'http:' then begin
            proto := 'http';
            p     := 6;
            if (Length(url) > 6) and (url[7] <> '/') then begin
                { Relative path }
                Path := Copy(url, 6, Length(url));
                Exit;
            end;
        end
        else if lowercase(Copy(url, 1, 7)) = 'mailto:' then begin
            proto := 'mailto';
            p := pos(':', url);
        end;
    end
    else begin
        proto := Copy(url, 1, p - 1);
        inc(p, 2);
    end;
    s := Copy(url, p + 1, Length(url));

    p := pos('/', s);
    q := pos('?', s);
    if (q > 0) and ((q < p) or (p = 0)) then
        p := q;
    if p = 0 then
        p := Length(s) + 1;
    Path := Copy(s, p, Length(s));
    s    := Copy(s, 1, p-1);

    p := Posn(':', s, -1);
    if p > Length(s) then
        p := 0;
    q := Posn('@', s, -1);
    if q > Length(s) then
        q := 0;
    if (p = 0) and (q = 0) then begin   { no user, password or port }
        Host := s;
        Exit;
    end
    else if q < p then begin  { a port given }
        Port := Copy(s, p + 1, Length(s));
        Host := Copy(s, q + 1, p - q - 1);
        if q = 0 then
            Exit; { no user, password }
        s := Copy(s, 1, q - 1);
    end
    else begin
        Host := Copy(s, q + 1, Length(s));
        s := Copy(s, 1, q - 1);
    end;
    p := pos(':', s);
    if p = 0 then
        User := s
    else begin
        User := Copy(s, 1, p - 1);
        Pass := Copy(s, p + 1, Length(s));
    end;
end;

function ParseTagStr(const TagStr:string;var TagType:THTMLTagTypes;var isClosingTag:boolean;Attributes:TStrings):boolean;
var
  t:integer;
  tagname:string;
  s:string;
begin
  result:=Copy(trimleft(trimright(tagstr)),1,1)='<';
  if not result then //not valid tag cancel!
    exit;
  isClosingTag:=false;
  if length(TagStr)>2 then
    isClosingTag:=(CompareText(Copy(Tagstr,1,2),'</')=0);
  try
    t:=pos(' ',TagStr);
    if t=0 then
      t:=pos('/>', TagStr);
    if t=0 then
      t:=pos('>', TagStr);
    if t>0 then
    begin
      if isClosingTag then
        tagname:=copy(Tagstr,3,t-3)
      else
        tagname:=copy(Tagstr,2,t-2);
      TagType:=GetTagType(TagName);
      if assigned(Attributes) then
      begin
        s:=StringReplace(TagStr,'<','',[rfReplaceAll, rfIgnoreCase]);
        s:=StringReplace(s,'>','',[rfReplaceAll, rfIgnoreCase]);
        s:=StringReplace(s,tagname,'',[rfReplaceAll, rfIgnoreCase]);
        s:=StringReplace(s,' ',#$D+#$A,[rfReplaceAll, rfIgnoreCase]);
        Attributes.Text:=s;
        t:=Attributes.IndexOf(tagname);
        if t>-1 then
          Attributes.delete(t);
      end;
      result:=true;
    end;
  except on e:exception do
    result:=false;
  end;
end;
procedure getTagCounts(ParsedHTML:TStrings;tagType:THTMLTagTypes;var beginCount:integer;var endCount:integer);
var
  i : integer;
  cur_tag_type:THTMLTagTypes;
  isClosingTag: boolean;
begin
  beginCount:=0;
  endCount:=0;
  for i:=0 to ParsedHTML.Count-1 do
  begin
    if ParseTagStr(ParsedHtml[i],cur_tag_type,isClosingTag,nil) then
    begin
      if cur_tag_type=tagType then
      case isClosingTag of
        false:inc(beginCount);
        true :inc(endCount);
      end;
    end;
  end;
end;
function getInnerHTML(ParsedHTMLCode:TStrings;startPos,endPos:integer):string;
var i:integer;
begin
  result:='';
  if endPos>ParsedHTMLCode.Count-1 then
    endPos:=ParsedHTMLCode.Count-1;//be always secure!!
  for i:=startPos to endPos do
  begin
    result:=result+ParsedHTMLCode[i]+#$D+#$A;
  end;
end;

function GetTagPos(ParsedHTML:TStrings;tagType:THTMLTagTypes;subTagType:TDoubleTagSubTypes):integer;
var
  i:integer;
  cur_tag_type:THTMLTagTypes;
  isClosingTag:boolean;
begin
  result:=-1;
  for i:=0 to ParsedHTML.Count-1 do
  begin
    if ParseTagStr(ParsedHtml[i],cur_tag_type,isClosingTag,nil) then
    if cur_tag_type=tagType then
      if integer(isClosingTag)=integer(subTagType) then
      begin
        result:=i;
        break;
      end;
  end;
end;

procedure AddHtmlBeginTag(ParsedHTML:TStrings);
begin
  ParsedHTML.Insert(0,'<html>');
end;
procedure AddHtmlEndTag(ParsedHTML:TStrings);
begin
  ParsedHTML.add('</html>');
end;

procedure AddHeadBeginTag(ParsedHTML:TStrings);
var
  i:integer;
  cur_tag_type:THTMLTagTypes;
  isClosingTag:boolean;
begin
  for i:=0 to ParsedHTML.Count-1 do
  begin
    if ParseTagStr(ParsedHtml[i],cur_tag_type,isClosingTag,nil) then
    if cur_tag_type=htHTML then
      if not isClosingTag then
        if (ParsedHTML.count-1)>=i+1 then
          ParsedHTML.Insert(i+1,'<head>')
        else
          ParsedHTML.Add('<head>');
  end;
end;
procedure AddHeadEndTag(ParsedHTML:TStrings);
var
  i:integer;
  body_start_pos:integer;
  body_end_pos:integer;
  head_start_pos:integer;
  curr_tag_type:THTMLTagTypes;
  isClosingTag:boolean;
  pos_found:boolean;
begin
  //must be before where body section start but the question is whether the body start tag exists?
  body_start_pos:=GetTagPos(ParsedHTML,htBody,beBegin);
  if body_start_pos=-1 then
  begin//there is no body Start tag. which means we have big problem
    //only <base>, <link>, <title>, <meta>, <basefont>, <bgsound> tags are valid in header
    head_start_pos:=GetTagPos(ParsedHTML,htHead,beBegin);
    if head_start_pos>-1 then
    begin //it must be, otherwise, in other words "AddHeadBeginTag" has also a bug
      body_end_pos:=GetTagPos(ParsedHTML,htBody,beEnd);
      if body_end_pos=-1 then //try to fix
      begin
        AddBodyEndTag(ParsedHTML);
        body_end_pos:=GetTagPos(ParsedHTML,htHtml,beEnd);
      end;
      if body_end_pos=-1 then //My God!!there is no way so basicly use end of the document
        body_end_pos:=ParsedHTML.Count-1;
      pos_found:=false;
      for i:=head_start_pos+1 to body_end_pos-1 do
      begin
        if ParseTagStr(ParsedHTML[i],curr_tag_type,isClosingTag,nil) then
        begin
          if (not (curr_tag_type in c_HTMLHeaderTags)) and (curr_tag_type<>htScript) then
          begin
            pos_found:=true;
            body_start_pos:=i;
            break;
          end;
        end;
      end;
      if pos_found then
      begin
        if body_start_pos<ParsedHTML.count then
          ParsedHTML.Insert(body_start_pos,'<body>')
        else
          ParsedHTML.add('<body>');
      end;
    end;
  end;
  if body_start_pos>0 then
     ParsedHTML.Insert(body_start_pos,'</head>');
end;

procedure AddTitleBeginTag(ParsedHTML:TStrings);
var
  head_begin_pos,title_end_pos,i:integer;
  isClosingTag,done:boolean;
  cur_tag_type:THTMLTagTypes;
begin
  //learn where title ended
  title_end_pos:=GetTagPos(ParsedHTML,htTitle,beEnd);
  head_begin_pos:=GetTagPos(ParsedHTML,htHead,beBegin);
  done:=false;
  //walk back until first tag occurance or head started
  for i:=title_end_pos-1 downto head_begin_pos+1 do
  begin
    if ParseTagStr(ParsedHtml[i],cur_tag_type,isClosingTag,nil) then
    begin
      ParsedHTML.Insert(i+1,'<title>');
      break;
      done:=true;//well done!
    end;
  end;
  if not done then//default add just after where head section started
    ParsedHTML.Insert(head_begin_pos+1,'<title>');
end;
procedure AddTitleEndTag(ParsedHTML:TStrings);
var
  head_end_pos,title_begin_pos,i:integer;
  isClosingTag,done:boolean;
  cur_tag_type:THTMLTagTypes;
begin
  //learn where title ended
  title_begin_pos:=GetTagPos(ParsedHTML,htTitle,beBegin);
  head_end_pos:=GetTagPos(ParsedHTML,htHead,beEnd);
  if head_end_pos=-1 then
  begin
    AddHeadEndTag(ParsedHtml);
    head_end_pos:=GetTagPos(ParsedHTML,htHead,beEnd);
    if head_end_pos=-1 then //try where body begin
      head_end_pos:=GetTagPos(ParsedHTML,htBody,beBegin);
    if head_end_pos=-1 then //there is no way use end of the document
      head_end_pos:=ParsedHTML.Count-1;
  end;
  done:=false;
  //walk forwad until first tag occurance or head ended
  for i:=title_begin_pos+1 to head_end_pos-1 do
  begin
    if ParseTagStr(ParsedHtml[i],cur_tag_type,isClosingTag,nil) then
    begin
      ParsedHTML.Insert(i+1,'</title>');
      break;
      done:=true;//well done!
    end;
  end;
  if not done then//default add just after where head section started
    ParsedHTML.Insert(head_end_pos,'</title>');
end;

procedure AddBodyBeginTag(ParsedHTML:TStrings);
var
  head_end_tag:integer;
begin
  head_end_tag:=GetTagPos(ParsedHTML,htHead,beEnd);
  if head_end_tag>-1 then
    ParsedHTML.insert(head_end_tag+1,'<body>')
  else
    AddHeadEndTag(ParsedHTML);//this will also place <body> tag if necessary!!!
end;
procedure AddBodyEndTag(ParsedHTML:TStrings);
var
  index_to_place:integer;
begin
  index_to_place:=GetTagPos(ParsedHTML,htHTML,beEnd);
  if index_to_place=-1 then
  begin
    AddHtmlEndTag(ParsedHTML);
    index_to_place:=GetTagPos(ParsedHTML,htHTML,beEnd);
    if index_to_place=-1 then
      index_to_place:=ParsedHTML.Count-1;
  end;
  if index_to_place>0 then
  begin
    if index_to_place<ParsedHTML.Count then
      ParsedHTML.insert(index_to_place-1,'</body>')
    else
      ParsedHTML.add('</body>');
  end;
end;
procedure AddBlockBeginTags(ParsedHTML:TStrings;tagType:THTMLTagTypes;ValidChildParents:THTMLTagTypeSet;ValidTags:THTMLTagTypeSet;DefaultChildTag:THTMLTagTypes);
var
  i:integer;
  curr_tag_type:THTMLTagTypes;
  isClosing:boolean;
  prev_tag_type:THTMLTagTypes;
  PrevIsClosing:boolean;
  next_tag_type:THTMLTagTypes;
  nextIsClosing:boolean;
  ce_tagType:THTMLTagTypes;
  ce_IsClosing:boolean;

  done:boolean;
  ParentIsValid:boolean;
  function getChildTagStr:string;
  var k:integer;
  begin
    result:=c_HTMLTagIds[DefaultChildTag];
    for k:=i+1 to ParsedHTML.Count-1 do
    begin
      if ParseTagStr(ParsedHTML[k],ce_tagType,ce_isClosing,nil) then
      begin
        if ce_IsClosing and (ce_tagType=tagType) then
          break;//no any valid child end tag found!.use default which is already assigned to result...
        if ce_IsClosing and (ce_tagType in ValidTags) then
        begin  //good we have found a valid child end tag use this type
          result:=c_HTMLTagIds[ce_tagType];
          break;
        end;
      end;
    end;
  end;
begin
  for i:=0 to ParsedHTML.Count-1 do
  begin
    done:=false;
    ParentIsValid:=false;
    if ParseTagStr(ParsedHTML[i],curr_tag_type,isClosing,nil) then
    if not isClosing then
    begin
      if curr_tag_type in ValidTags then //check previous tag is a valid parent?
      begin
       if i>0 then
       begin
         if ParseTagStr(ParsedHTML[i-1],prev_tag_type,PrevIsClosing,nil) then
         begin
           if (not PrevIsClosing) and (not (prev_tag_type in ValidChildParents)) then
           begin
             if i>1 then
             if ParseTagStr(ParsedHTML[i-2],prev_tag_type,PrevIsClosing,nil) then
             if (not PrevIsClosing) and (prev_tag_type in ValidChildParents) then
             begin
               done:=true;
               ParsedHTML.Exchange(i-1,i-2);
             end;
             if not done then
             begin
               ParsedHTML.Insert(i,format('<%s>',[c_HTMLTagIds[tagType]]));
               //done:=true;
             end;
           end
           else
           begin
             if (PrevIsClosing) and (not (prev_tag_type in ValidTags)) then
             begin
               ParsedHTML.Insert(i,format('<%s>',[c_HTMLTagIds[tagType]]));
               //done:=true;
             end;
           end;
         end;
       end;
      end
      else
      if curr_tag_type=tagType then
      begin
         //check is that the next tag valid?
         if i<ParsedHTML.Count-1 then
         begin
           if ParseTagStr(ParsedHTML[i+1],next_tag_type,NextIsClosing,nil) then
           begin
             if (not isClosing) and (next_tag_type=htForm) then
             begin
               if i<ParsedHTML.Count-2 then
                 if ParseTagStr(ParsedHTML[i+2],next_tag_type,NextIsClosing,nil) then
                 if (not isClosing) and (next_tag_type in ValidTags) then
                 begin
                   ParsedHTML.Exchange(i,i+1);
                   ParentIsValid:=true;
                 end
             end
             else
             if (not isClosing) and (next_tag_type in ValidTags) then
               ParentIsValid:=true;
           end;
         end;
         if not ParentIsValid then
         begin
            if i<ParsedHTML.Count-1 then
              ParsedHTML.Insert(i+1,format('<%s>',[getChildTagStr]))
            else
              ParsedHTML.Add(format('<%s>',[getChildTagStr]));
         end;
      end;
    end;
  end;
end;
procedure AddCellBeginTag(ParsedHTML:TStrings);
var
  i:integer;
  tagType:THTMLTagTypes;
  isClosing:boolean;
  next_tagType:THTMLTagTypes;
  next_isClosing:boolean;
  ce_tagType:THTMLTagTypes;
  ce_isClosing:boolean;
  endTagFound:boolean;

  procedure checkNextIsCellBegin;
  var k:integer;
  begin
    if  not (next_tagType in [htTableCol, htTH]) then
    begin
      //try to find a cell end tag
      endTagFound:=false;
      for k:=i+1 to ParsedHTML.Count-1 do
      begin
        if ParseTagStr(ParsedHTML[k],ce_tagType,ce_isClosing,nil) then
        if ce_isClosing and (ce_tagType in [htTableRow,htTableBody,htTableFoot,htTable]) then
        begin
          endTagFound:=false;
          break;
        end;
        if ce_isClosing and (ce_tagType =next_tagType) then
        begin
          endTagFound:=true;
          break;
        end;
      end;
      if not endTagFound then
        ParsedHTML.Insert(i+1,format('<%s>',[c_HTMLTagIds[next_tagType]]))
      else
        ParsedHTML.Insert(i+1,'<td>');//use default
    end;
  end;
  procedure checkNextIsRowEnd;
  begin
    if not (next_tagType in [htTableRow]) then
    begin
      ParsedHTML.Exchange(i,i+1);

    end;
  end;
begin
  AddBlockBeginTags(ParsedHTML,htTable,c_HTMLTableRowParents,c_HTMLTableTags,htTableRow);//fix tables
  AddBlockBeginTags(ParsedHTML,htTableRow,[htTableRow],c_HTMLTableRowTags,htTableCol); //fix rows
  for i:=0 to ParsedHTML.Count-1 do
  begin
    if ParseTagStr(ParsedHTML[i],tagType,isClosing,nil) then
    if isClosing and (tagType in [htTableCol, htTH]) then
    begin
      if i<ParsedHTML.Count-1 then
      begin
        if ParseTagStr(ParsedHTML[i+1],next_tagType,next_isClosing,nil) then
        begin//next tag must be <td>, <th> or </tr> in this context
          case  next_isClosing of
            false:{expected tag <td>,<th>} checkNextIsCellBegin;
            true :{expected tag </tr>    } checkNextIsRowEnd;
          end;
        end;
      end
      else  //we another problem that cell already closed but document also ended. so we need at least </tr> and </table>
      begin
      end;
    end
    else
    if (not isClosing) and (tagType in [htTableRow]) then
    begin //next tag must be <td> or <th>
      if i<ParsedHTML.Count-1 then
      begin
        if ParseTagStr(ParsedHTML[i+1],next_tagType,next_isClosing,nil) then
        begin//next tag must be <td>, <th> or </tr> in this context
          case  next_isClosing of
            false:{expected tag <td>,<th>} checkNextIsCellBegin;
            true :
              begin
                ParsedHTML.Insert(i+1,'<td>');//use default
                ParsedHTML.Insert(i+2,'</td>');//use default
              end;
          end;
        end;
      end
      else  //we another problem that cell already closed but document also ended. so we need at least </tr> and </table>
      begin
      end;
    end;

  end;
end;
procedure FixHTMLHierarchy(ParsedHTML:TStrings);
const
  max_items = 1204*8;//max 8 K Lines
  type
    TTag_data = record
      fwd : Smallint;
      rwd : Smallint;
      dif : Smallint;
      tag_type   : THTMLTagTypes;
      blockStart : dword;
      blockEnd   : dword;
      parent     : THTMLTagTypes;
      parent_pos : integer;
      isParentValid:boolean;
      isClosing:boolean;
  end;
var
  tagstr :string;
  j,k : integer;
  tag_array :array [0..max_items] of TTag_data;
  fwd_tag_stacks:array [low(THTMLTagTypes)..high(THTMLTagTypes)] of integer;
  rwd_tag_stacks:array [low(THTMLTagTypes)..high(THTMLTagTypes)] of integer;
  currTagType:THTMLTagTypes;
  last_parent:THTMLTagTypes;
  last_parent_pos:integer;
  isClosing:boolean;
  fixed_error_count:word;
  procedure BuildArrays;
  var
    i:integer;
    valid_parent:THTMLTagTypes;

    procedure ResetArrays;
    var
      t: THTMLTagTypes;
      i: integer;
    begin
      for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
      begin
        fwd_tag_stacks[t]:=0;
        rwd_tag_stacks[t]:=0;
      end;
      for i:=0 to ParsedHTML.Count-1 do
      begin
        //reset stacks
        tag_array [i].fwd:=0;
        tag_array [i].rwd:=0;
        tag_array [i].dif:=0;
        tag_array [i].tag_type     := htUnknown;
        tag_array[i].blockStart    := 0;
        tag_array[i].blockEnd      := 0;
        tag_array [i].parent       := htUnknown;
        tag_array [i].parent_pos   := 0;
        tag_array [i].isParentValid:= false;
        tag_array [i].isClosing    := false;
      end;
    end;

    procedure CheckForProblem_1;
    begin
      if (tag_array[i].tag_type in c_HTMLDoubleTags) and (last_parent<>tag_array[i].tag_type) then
      begin
        //(sit 1) this means current closing tag belong to a forgotten begin tag
        //or (sit 2) current(last)parent has no closing tag which is expected here!!
        //so if current closing tag is parent of last parent then (sit 2) else (sit 1)
        if tag_array[i].tag_type<>htForm then //ignore forms
        begin
          if tag_array[i].tag_type=tag_array[last_parent_pos].parent then //(sit 2)
          begin
            tagstr:=format('</%s>',[c_HTMLTagIds[last_parent]]);
            ParsedHTML.Insert(i,tagstr);
            inc(fixed_error_count);
            if fixed_error_count<64000 then  //number of 64K error is too much.so dont allow to kind of dead-lock!!!
              BuildArrays;//Re-Calculate Arrays!
            exit;
          end
          else
          begin
            if last_parent in c_HTMLValidParents[tag_array[i].tag_type] then
            begin
              tagstr:=format('<%s>',[c_HTMLTagIds[tag_array[i].tag_type]]);
              ParsedHTML.Insert(last_parent_pos+1,tagstr);
              inc(fixed_error_count);
              if fixed_error_count<64000 then  //number of 64K error is too much.so dont allow to kind of dead-lock!!!
                BuildArrays;//Re-Calculate Arrays!
              exit;
            end;
          end;
        end;
      end;
    end;

    procedure CheckForValidParentProblem;
    var
      k:integer;
      t:THTMLTagTypes;
    begin
      if not tag_array[i].isParentValid then
      for k:=tag_array[i].parent_pos downto 0 do
      begin
        if tag_array[i].parent_pos=tag_array[tag_array[i].parent_pos].parent_pos then//dead link!
          break;
        if not tag_array[i].isParentValid then
        if tag_array[i].tag_type<>htForm then //ignore forms
        begin
          tag_array[i].parent:=tag_array[tag_array[i].parent_pos].parent;
          tag_array[i].parent_pos:=tag_array[tag_array[i].parent_pos].parent_pos;
          tag_array[i].isParentValid:=(tag_array[i].parent in c_HTMLValidParents[tag_array[i].tag_type]);
          if (tag_array[i].isParentValid) then
          begin //the parent that is pointed by  last_parent_pos need to be closed here!
            tagstr:=format('</%s>',[c_HTMLTagIds[last_parent]]);
            ParsedHTML.Insert(i,tagstr);
            inc(fixed_error_count);
            if fixed_error_count<64000 then  //number of 64K error is too much.so dont allow to kind of dead-lock!!!
              BuildArrays;//Re-Calculate Arrays!
            exit;
          end;
        end
        else
          break;
      end;
      if not tag_array[i].isParentValid then
      begin //which means there is missing valid parent tag.we need to add a valid parent tag at the position of last_parent_pos+1
        valid_parent:=htUnknown;
        for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
          if t in c_HTMLValidParents[tag_array[i].tag_type] then
          begin
            valid_parent:=t;
            break;
          end;
        if (t<>htUnknown) and (t<>htDocType) then
        begin
          tagstr:=format('<%s>',[c_HTMLTagIds[valid_parent]]);
          if valid_parent in c_HTMLValidChilds[last_parent] then
            ParsedHTML.Insert(last_parent_pos+1,tagstr)
          else
            if valid_parent in c_HTMLValidChilds[tag_array[tag_array[i].parent_pos].parent] then
              ParsedHTML.Insert(last_parent_pos,tagstr);
          inc(fixed_error_count);
          if fixed_error_count<64000 then  //number of 64K error is too much.so dont allow to kind of dead-lock!!!
            BuildArrays;//Re-Calculate Arrays!
          exit;
        end;
      end;
    end;

  begin
    last_parent:=htUnknown;
    last_parent_pos:=0;
    //valid_parent:=htUnknown;
    if fixed_error_count>40 then //prevent hanging up
      exit;
    ResetArrays;
    for i:=0 to ParsedHTML.Count-1 do
    begin
      if ParseTagStr(ParsedHTML[i], currTagType, isClosing, nil) then
      begin
        if currTagType=htForm then //ignore forms
          continue;
        tag_array[i].isClosing:=isClosing;
        tag_array[i].tag_type:=currTagType;
        if isClosing then
        begin
          CheckForProblem_1;
          tag_array[i].parent:=tag_array[last_parent_pos].parent;
          tag_array[i].parent_pos:=tag_array[last_parent_pos].parent_pos;
        end
        else
        begin
          tag_array[i].parent:=last_parent;
          tag_array[i].parent_pos:=last_parent_pos;
        end;
        tag_array[i].isParentValid:=tag_array[i].parent in c_HTMLValidParents[tag_array[i].tag_type];
        CheckForValidParentProblem;
        if isClosing then
        begin
          if last_parent=tag_array[i].tag_type then
          begin
            last_parent:=tag_array[last_parent_pos].parent;
            last_parent_pos:=tag_array[last_parent_pos].parent_pos;
          end
          else//which means an invalid closing tag according to current block groups
          begin
            //showmessage('invalid or wrong closing tag :'+ParsedHTML[i]);
          end;
          dec(fwd_tag_stacks[currTagType]);
        end
        else
        begin
          tag_array[i].blockStart:=i;
          if not (currTagType in c_HTMLEmptyTags) then
            inc(fwd_tag_stacks[currTagType]);
          if (currTagType in c_HTMLDoubleTags) then
          begin
            last_parent:=currTagType;
            last_parent_pos:=i;
          end;
        end;
        tag_array[i].fwd:=fwd_tag_stacks[currTagType];
      end
    end;
    for i:=ParsedHTML.Count-1 downto 0 do
    begin
      if ParseTagStr(ParsedHTML[i], currTagType, isClosing, nil) then
      begin
        if isClosing then
        begin
          if not (currTagType in c_HTMLEmptyTags) then
             inc(rwd_tag_stacks[currTagType]);
        end
        else dec(rwd_tag_stacks[currTagType]);
        tag_array[i].rwd:=rwd_tag_stacks[currTagType];
        tag_array[i].dif:=tag_array[i].fwd-tag_array[i].rwd;
      end;
    end;

  end;
begin
  fixed_error_count:=0;
  //delete non tag datas at the beginning!
  while ParsedHTML.Count>0 do
    if ParseTagStr(ParsedHTML[0],currTagType,isClosing,nil) then
      break
    else
      ParsedHTML.delete(0);
  if not isClosing then
  if currTagType<>htHTML then
  case currTagType of
    htBody:begin
            ParsedHTML.Insert(0,'<html>');
            ParsedHTML.Insert(0,'<head>');
            ParsedHTML.Insert(0,'</head>');
           end;
    htHead:begin
            ParsedHTML.Insert(0,'<html>');
           end;
    htMeta:begin
            ParsedHTML.Insert(0,'<html>');
            ParsedHTML.Insert(0,'<head>');
           end;
    htTitle:begin
            ParsedHTML.Insert(0,'<html>');
            ParsedHTML.Insert(0,'<head>');
           end;
    else
            ParsedHTML.Insert(0,'<html>');
  end;

  BuildArrays;
  //check for symptoms step forward
    //known symptoms:
    //  rwd = -1 , dif = 2 means unclosed block has began, the last dif = 2 ist place to required end tag; after correction need to re-calc arrays!
  j:=0;
  while j<=ParsedHTML.Count-1 do
  begin
    if (tag_array[j].rwd = -1) and (tag_array[j].dif = 2) then
    begin
      for k:=ParsedHTML.Count-1 downto 0 do
      begin
        if (tag_array[k].parent_pos=tag_array[j].parent_pos) and
           (tag_array[k].parent=tag_array[j].parent) and
           (tag_array[k].dif=2) and
           (tag_array[k].tag_type=tag_array[j].tag_type) then
        begin
          tagstr:=format('<%s>',[c_HTMLTagIds[tag_array[j].tag_type]]);
          ParsedHTML.Insert(k,tagstr);
          break;
        end;
      end;
      break;
    end;
    inc(j);
  end;

end;
procedure TryToFixErrors(ParsedHTML:TStrings;fixedErrors:word);
var
  beginCount,endCount:integer;
  t:THTMLTagTypes;
  i:integer;
 // missing_tag_count:integer;
  //mostRelevantLineNumber:integer;
  procedure CheckHTMLExists;
  begin
    if ((t=htHTML) and (beginCount=0) and (endCount=0)) then
    begin //oh My God. there is no html identifier tags!!!who has written such html page!!!
      if ParsedHTML.Count>0 then
      begin
        ParsedHTML.insert(0,'<html>');
        ParsedHTML.add('</html>');
      end
      else
      begin
        ParsedHTML.add('<html>');
        ParsedHTML.add('</html>');
      end;
    end;
  end;
  procedure CheckHeadExisits;
  begin
    if ((t=htHead) and (beginCount=0) and (endCount=0)) then
    begin //oh My God. there is no head identifier tags!!!who has written such html page!!!
        i:=GetTagPos(ParsedHTML,htHTML,beBegin);
        if i>-1 then
        begin
          ParsedHTML.insert(i+1,'<head>');
          ParsedHTML.insert(i+2,'</head>');
        end;
    end;
  end;
  procedure CheckBodyExists;
  begin
    if ((t=htBody) and (beginCount=0) and (endCount=0)) then
    begin //oh My God. there is no body!!!who has written such html page!!!
        i:=GetTagPos(ParsedHTML,htHead,beEnd);
        if i>-1 then
          ParsedHTML.insert(i+1,'<body>');
        i:=GetTagPos(ParsedHTML,htHTML,beEnd);
        if i>-1 then
          ParsedHTML.insert(i,'</body>');
    end;
  end;
begin

  for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
  begin
    if t in c_HTMLDoubleTags then
    begin
      if (t=htHtml) or (t=htHead) or (t=htBody) then
      begin
        getTagCounts(ParsedHTML,t,beginCount,endCount);
        //CheckHTMLExists;
        //CheckHeadExisits;
        CheckBodyExists;
      end;
      if t=htBody then
        FixHTMLHierarchy(ParsedHTML);
      (*
      Case t of
        htTableRow : AddBlockBeginTags(ParsedHTML,htTableRow,[htTableRow],c_HTMLTableRowTags,htTableCol);
        htTable    : AddBlockBeginTags(ParsedHTML,htTable,c_HTMLTableRowParents,c_HTMLTableTags,htTableBody);
        htTableBody: AddBlockBeginTags(ParsedHTML,htTableBody,[htTable],[htTable],htTableRow);
      end;
      *)
      getTagCounts(ParsedHTML,t,beginCount,endCount);
      if beginCount<endCount then
      begin//missing endTag
        //missing_tag_count:=endCount-beginCount;
        case t of
          htHtml           :AddHtmlBeginTag(ParsedHTML);
          htHead           :AddHeadBeginTag(ParsedHTML);
          htTitle          :AddTitleBeginTag(ParsedHTML);
          htBody           :AddBodyBeginTag(ParsedHTML);
          //htTable          :AddBlockBeginTags(ParsedHTML,htTable,c_HTMLTableRowParents,c_HTMLTableTags,htTableBody);
          htTableCol,htTH  :AddCellBeginTag(ParsedHTML);
          (*
          htTableRow       :
          htHead           :
          htFont           :
          htBold           :
          htForm           :
          htTextArea       :
          htScript         :
          htNoScript       :
          htDiv            :
          htAnchor         :
          htSpan           :
          htCenter         :
          htStyle          :
          htSelect         :
          htH1,htH2,htH3   :
          htH4,htH5,htH6   :
          htSup            :
          htMap            :
          htLabel          :
          htI              :
          htBlockQuote     :
          htPre            :
          htU              :
          htUl             :
          htFrameSet       :
          htCode           :
          htEm             :
          *)
        end;
      end;
      if beginCount>endCount then
      begin//missing beginTag
        //missing_tag_count:=beginCount-endCount;
        case t of
          htHtml           :AddHtmlEndTag(ParsedHTML);
          htHead           :AddHeadEndTag(ParsedHTML);
          htTitle          :AddTitleEndTag(ParsedHTML);
          htBody           :AddBodyEndTag(ParsedHTML);
          (*
          htTable          :
          htTableRow       :
          htTableCol       :AddCellEndTag(ParsedHTML);
          htTH             :AddCellEndTag(ParsedHTML);
          htHead           :
          htFont           :
          htBold           :
          htForm           :
          htTextArea       :
          htScript         :
          htNoScript       :
          htDiv            :
          htAnchor         :
          htSpan           :
          htCenter         :
          htStyle          :
          htSelect         :
          htH1,htH2,htH3   :
          htH4,htH5,htH6   :
          htSup            :
          htMap            :
          htLabel          :
          htI              :
          htBlockQuote     :
          htPre            :
          htU              :
          htUl             :
          htFrameSet       :
          htCode           :
          htEm             :
          *)
        end;
      end;
    end;
  end;
end;
Procedure ParseHTML(Source:string;ParsedHTML:TStrings;RemoveControlChars:boolean);
var
  s:string;
  l,i:integer;
  InComment:boolean;
  InTag:boolean;
  Instring:boolean;
  TagStr:string;
  DataStr:string;
  tmpList:TStringList;
  fixedErrors:word;
  procedure CheckInComment;
  begin
    if not InComment then
    begin
      if s[i]='<' then
        if i+1<l then
          if s[i+1]='!' then
            if i+2<l then
              if s[i+2]='-' then
                if i+3<l then
                  if s[i+3]='-' then
                    InComment:=true;
    end
    else
    begin
      if i>4 then
        if s[i-3]='-' then
          if s[i-2]='-' then
              if s[i-1]='>' then
                InComment:=False;
    end;
  end;
  procedure CheckInString;
  begin
    if (InComment) or (not InTag) then
      InString:=False
    else
    begin
      if not InString then
      begin
        if (s[i]='"') or (s[i]='''')then
          InString:=true;
      end
      else
      begin
        if i>1 then
          if (s[i]='"') or (s[i]='''') then
          begin
            InString:=False;
            //bug correction
            if i+1<Length(s) then
            if (s[i+1]='"') or (s[i+1]='''') then
              s[i+1]:=' ';
            //end of bug correction
          end;
      end;
    end;
  end;
  procedure CheckInTag;
  begin
    if InComment then
      InTag:=False
    else
    begin
      if not InTag then
      begin
        if s[i]='<' then
          InTag:=true;
      end
      else
      begin
        if i>1 then
          if s[i-1]='>' then
          begin
            //check in string;
            if not InString then
              InTag:=False;
          end;
      end;
    end;
  end;
  procedure CheckData;
  begin
    if DataStr<>'' then
    begin
      if RemoveControlChars then
      begin
        Datastr:=StringReplace(Datastr,#$D+#$A,'',[rfReplaceAll, rfIgnoreCase]);
        Datastr:=TrimLeft(TrimRight(Datastr));
      end
      else
      begin
        Datastr:=StringReplace(Datastr,#$D,'&#13;',[rfReplaceAll, rfIgnoreCase]);
        Datastr:=StringReplace(Datastr,#$A,'&#10;',[rfReplaceAll, rfIgnoreCase]);
      end;
      if (pos('<',Datastr)>0) or (pos('>',Datastr)>0) then
      begin
         //raise Exception.Create('Error parsing data line:'+datastr);
         Datastr:='';
         exit;
      end;
      if Datastr<>'' then
        ParsedHTML.Add(Datastr);
      Datastr:='';
    END;
  end;
  procedure CheckTag;
  begin
    if TagStr<>'' then
    begin
      TagStr:=StringReplace(TagStr,#$D+#$A,'',[rfReplaceAll, rfIgnoreCase]);
      TagStr:=TrimLeft(TrimRight(TagStr));
      if TagStr<>'' then
        ParsedHTML.Add(TagStr);
        if tagstr[length(tagstr)]<>'>' then
          raise Exception.Create('Error parsing tag:'+tagstr);
      TagStr:='';
    end;

  end;
begin
  tmpList:=TStringList.Create;
  try
    s:='';
    tmpList.Text:=source;
    for i:=0 to tmpList.Count-1 do
      s:=s+tmpList[i]+ ' ';
    s:=s+#$D+#$A;//for the last element detection;
  finally
    tmpList.Free;
  end;
  (*
  //bug corrections;
  s:=StringReplace(s,'</table'+#9,'</table>',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'</table'+#$A,'</table>',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'</table'+#$D,'</table>',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'</table ','</table>',[rfReplaceAll, rfIgnoreCase]);
  *)
  //s:=StringReplace(s,#$D+#$A,' ',[rfReplaceAll, rfIgnoreCase]);
  //s:=StringReplace(s,#13,' ',[rfReplaceAll, rfIgnoreCase]);
  //end of bug corrections;
  InComment:=false;
  InTag:=false;
  Instring:=false;
  TagStr:='';
  DataStr:='';
  ParsedHTML.clear;
  l:=length(s);
  for i:=1 to  l do
  begin
    CheckInComment;
    CheckInTag;
    CheckInString;
    if inComment then continue;
    if InTag then
    begin
      TagStr:=TagStr+s[i];
      CheckData;
    end
    else
    if s[i]='<' then
    begin
      InTag:=True;
      CheckData;
      CheckTag;
      TagStr:=TagStr+s[i];
    end
    else
    begin
      DataStr:=Datastr+s[i];
      CheckTag;
    end;
  end;
  for i:=0 to ParsedHTML.Count-1 do
  begin
    ParsedHTML[i]:=StringReplace(ParsedHTML[i],#9,' ',[rfReplaceAll, rfIgnoreCase]);
  end;
  ParsedHTML.Text:=StringReplace(ParsedHTML.Text,'><','>'+#$D+#$A+'<',[rfReplaceAll, rfIgnoreCase]);
  fixedErrors:=0;
  TryToFixErrors(ParsedHTML,fixedErrors);
end;

// *****************************************************************************************************
// ****************   the very important artificial intelligence algortihm *****************************
// -----------   this function calculates possible nearest relationship between two tag types ----------
// *****************************************************************************************************

{ !!! CAUTION RECURSIVE AREA !!!!}

{ !!! POSSIBLE DEAD LOCK LOCATION !!!}
(*
function CheckForTheChildsOfGivenParent(var bestcount:smallint;const TagType:THTMLTagTypes;var currentDistance: THTMLChildParentDistance;CurrentDistanceCount:smallint;CurrentParentType:THTMLTagTypes):integer;
var
  t:THTMLTagTypes;
  res,i:integer;
  aDistance: THTMLChildParentDistance;
  currentSet:set of THTMLTagTypes;
begin
  result:=-1;
  if (bestcount<CurrentDistanceCount) then
  begin
    result:=-1;
    exit;
  end;
  if  (currentDistanceCount>3) then
    exit;
  if TagType in c_HTMLValidChilds[CurrentParentType] then
  begin
    result:=CurrentDistanceCount;
    currentDistance[result-1]:=CurrentParentType;
    exit;
  end
  else
  begin
    fillchar(aDistance,33,75);
    //for i:=0 to 32 do //reset array
    //  aDistance[i]:=htUnknown;
    currentSet:=[];
    for i:=0 to CurrentDistanceCount-1 do
    begin
      aDistance[i]:=currentDistance[i];
      currentSet:=currentSet+[currentDistance[i]];
    end;

    for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
    if t=htComment then continue
    else
    if CurrentParentType<>t then
    if not (t in currentSet) then
    if t in c_HTMLValidChilds[CurrentParentType] then
    if (t in c_HTMLDoubleTags) or (t in c_HTMLOptionalDoubleTags) then
    begin
      aDistance[CurrentDistanceCount]:=t;
      res:=CheckForTheChildsOfGivenParent(bestcount, TagType, aDistance,CurrentDistanceCount+1,t);
      if ((res>-1) and(result=-1)) or ((res>-1) and (res<result)) then
      begin
        result:=res;
        if res<bestcount then
          bestcount:=res;
        for i:=0 to result-1 do
          currentDistance[i]:=aDistance[i];
      end;
      if result=0 then
        break;
    end;
  end;
end;
*)
function CheckForTheChildsOfGivenParentEx(var bestcount:smallint;const TagType:THTMLTagTypes;var currentDistance: THTMLChildParentDistance;CurrentDistanceCount:smallint;CurrentChildType:THTMLTagTypes):integer;
var
  t:THTMLTagTypes;
  res,i:integer;
  aDistance: THTMLChildParentDistance;
  currentSet:set of THTMLTagTypes;
begin
  result:=-1;
  if (bestcount<CurrentDistanceCount) then
  begin
    result:=-1;
    exit;
  end;
  if  (currentDistanceCount>3) then
    exit;
  if TagType in c_HTMLValidParents[CurrentChildType] then
  begin
    result:=CurrentDistanceCount;
    currentDistance[result-1]:=CurrentChildType;
    exit;
  end
  else
  begin
    fillchar(aDistance,33,75);
    //for i:=0 to 32 do //reset array
    //  aDistance[i]:=htUnknown;
    currentSet:=[];
    for i:=0 to CurrentDistanceCount-1 do
    begin
      aDistance[i]:=currentDistance[i];
      currentSet:=currentSet+[currentDistance[i]];
    end;

    for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
    if t=htComment then continue
    else
    if CurrentChildType<>t then
    if not (t in currentSet) then
    if t in c_HTMLDefaultParents[CurrentChildType] then
    if (t in c_HTMLDoubleTags) or (t in c_HTMLOptionalDoubleTags) then
    begin
      aDistance[CurrentDistanceCount]:=t;
      res:=CheckForTheChildsOfGivenParentEx(bestcount, TagType, aDistance,CurrentDistanceCount+1,t);
      if ((res>-1) and(result=-1)) or ((res>-1) and (res<result)) then
      begin
        result:=res;
        if res<bestcount then
          bestcount:=res;
        for i:=0 to result-1 do
          currentDistance[i]:=aDistance[i];
      end;
      if result=0 then
        break;
    end;
  end;
end;
{ ** END OF DEAD LOCK LOCATION ** }

{TMyPersistent}
function TMyPersistent.GetOwner: TPersistent;
begin
  result:=inherited GetOwner;
end;
{TmyComponent}
function TmyComponent.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  result:=inherited QueryInterface(IID,Obj);
end;
{THTMLStringData}

Constructor THTMLStringData.Create;//dont forget to create TFont
begin
  inherited Create;
  //FFont:=TFont.Create;
end;
destructor THTMLStringData.Destroy;
begin
  //Ffont.Free;
  inherited destroy;
end;
{THTMLImageData}

constructor THTMLImage.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  if assigned(Document) then
    Document.AddImage(self);
end;

destructor THTMLImage.Destroy;
begin
  //if assigned(FGraphic) then FGraphic.Destroy;
  if assigned(Document) then
    Document.RemoveImage(self);
  inherited Destroy;
end;
function THTMLImage.getAlt:string;
begin
    result:=Attributes['alt'];
end;
procedure THTMLImage.setAlt(p:string);
begin
  Attributes['alt']:=p;
end;
function  THTMLImage.getSrc:string;
begin
  result:=Attributes['src'];
end;
procedure THTMLImage.setSrc(p:string);
begin
  Attributes['src']:=p;
end;



{THTMLParsedTag}
constructor THTMLParsedTag.Create(aOwner:THTMLParser;aTagStr:string;aSourceRow:dword;aSourceCol:dword);
begin
  inherited Create;
  fOwner     := aOwner;
  fSourceRow := aSourceRow;
  fSourceCol := aSourceCol;
  fChilds    := THTMLParsedTagCollection.Create(false);
  fAttributes:= TStringList.Create;
  TagStr     := aTagStr;
  if assigned(Owner) then
    Owner.ParsedTags.add(self);
end;
constructor THTMLParsedTag.Create(aOwner:THTMLParser);
begin
  inherited Create;
  fChilds    := THTMLParsedTagCollection.Create(false);
  fAttributes:= TStringList.Create;
  fOwner     := aOwner;
  if assigned(Owner) then
    Owner.ParsedTags.add(self);
end;
destructor  THTMLParsedTag.Destroy;
var destroying:boolean;
begin
  destroying:=false;
  if assigned(Owner) then
  begin
    Owner.ParsedTags.remove(self);
    destroying:=Owner.destoying;
  end;
  if not destroying then
  begin
    if assigned(EndTag) and (EndTag<>self) then
      EndTag.BeginTag:=nil;
    if assigned(BeginTag) and (BeginTag<>self) then
      BeginTag.EndTag:=nil;
    if assigned(ParentTag) then
      ParentTag.Childs.Remove(self);
    while fChilds.Count>0 do
      Childs[0].Free;
  end;
  fChilds.Free;
  fAttributes.Clear;
  fAttributes.Free;
  inherited destroy;
end;
procedure THTMLParsedTag.init;
begin
end;
function  THTMLParsedTag.CreateElement(Document:THTMLDocument;parentElement:THTMLElement):THTMLElement;
var
  i:integer;
  cancel:boolean;
begin
  result:=nil;
  try
    if (isValidTag) and (not isBeginTag) then exit;
    if fTagType=htInput then
      result:=nil;
    if assigned(parentElement) then
    begin
      if (TagType=htDocType) and assigned(Document) then
        Document.TagStr:=TagStr
      else
        result:=parentElement.CreateChildElement(self)
    end
    else
    if assigned(Document) then
    begin
      if TagType=htDocType then
        Document.TagStr:=TagStr
      else
         result:=Document.CreateChildElement(self);
    end;
    if assigned(result) then
    begin
      if assigned(BeginTag) then
        result.CodeFormattingCharsB:=BeginTag.CodeFormattingChars;
      if assigned(EndTag) then
        result.CodeFormattingCharsE:=EndTag.CodeFormattingChars;
      result.Props.Assign(Attributes);

      for i:=0 to Childs.Count-1 do
      begin
        try
          if not childs[i].isValidTag then//possible data or text part
            childs[i].CreateElement(Document,result)
          else
          if childs[i].isBeginTag then
            childs[i].CreateElement(Document,result);
        except on e:exception do
          if assigned(owner) then
          if assigned(owner.document) then
            if assigned(owner.document.fonParseError) then
            begin
              owner.document.fonParseError(childs[i],'Error on creating child tag '+childs[i].Tagstr+':'+e.Message,0,0,0,cancel);
              if cancel then raise;
            end;
        end;
      end;
    end;
  except on e:exception do
    if assigned(owner) then
    if assigned(owner.document) then
      if assigned(owner.document.fonParseError) then
      begin
        owner.document.fonParseError(self,Tagstr+':'+e.Message,0,0,0,cancel);
        if cancel then raise;
      end;
  end;
end;
function  THTMLParsedTag.getIsValidTag:boolean;
begin
  result:=(Copy(trimleft(trimright(tagstr)),1,1)='<') or (tagType=htPlainText);
end;
procedure THTMLParser.parse_TagStr(bTag:THTMLParsedTag);
var
  l:dword;
//  t:dword;
  p,pEnd:pchar;
  lastPartType:TSGMLTagParsingStates;
  LastTagCmd  :string;
  LastAttrName:string;
  LastAttrVal :string;
  LastCDATA:string;
  LastAttrValDelm:char;
  //aTagStr         : string;
  aTagCmd         : string;
  aTagType        : THTMLTagTypes;
  aTagSubType     : TTagSubType;

  procedure doInvalidAttrChar;
  begin
    //raise exception.Create('error on parsing SGML tag.Invalid character.');
  end;
  procedure initializeTag;
  begin
    lastPartType:=stpTagCmd;
  end;
  procedure finalizeTag;
  var s:string;
  begin
    lastPartType:=stpCDATA;
    if aTagSubType<>[beEnd] then
    begin
      aTagSubType:=[beBegin];
      bTag.fBeginTag:=bTag;
    end;
    if aTagType=htInput then
    begin
      s:=StringReplace(bTag.Attributes.values['type'],'"','',[rfReplaceAll]);
      s:=StringReplace(s,'''','',[rfReplaceAll]);
      if compareText(s,'hidden')=0 then
        aTagType:=htInputHidden
    end;
  end;
  procedure finalizeTagBlock;  // eg <mytag ... />
  begin
    //XML style single tag block ended..
    lastPartType:=stpCDATA;
    if aTagSubType<>[beEnd] then
    begin
      aTagSubType:=aTagSubType+[beEnd];
      bTag.fEndTag:=bTag;
    end
  end;
  procedure initializeTagCmd;
  begin
    LastTagCmd:='';
    lastPartType:=stpTagCmd;
  end;

  procedure initializeTagBlockEnd;
  begin
    aTagSubType:=[beEnd];
    bTag.fBeginTag:=nil;
    bTag.fEndTag:=bTag;
    initializeTagCmd;
  end;
  procedure finalizeTagCmd;
  begin
    aTagType:=GetTagType(LastTagCmd);
    aTagCmd:=LastTagCmd;
    //if compareText(LastTagcmd,'input')=0 then
    //  fTagType:=htInput;

  end;
  procedure finalizeAttrName;
  begin
    //assume that it is boolean attribute
    //Attributes.values[LastAttrName]:='true';
    if ((p^='/') or (p^='>')) and  (LastAttrName<>'') then
      bTag.Attributes.add(LastAttrName);
  end;
  procedure initalizeAttrName;
  begin
    if LastAttrName<>'' then
      bTag.Attributes.add(LastAttrName);
    LastAttrName:='';
    LastAttrValDelm:=#0;
    lastPartType:=stpAttrName;
  end;
  procedure initializeAttrVal;
  begin
    lastPartType:=stpAttrVal;
    LastAttrValDelm:=p^;
    LastAttrVal:=p^;
  end;
  procedure finalizeAttrVal;
  begin
    //LastAttrVal:=LastAttrVal+p^;
    bTag.Attributes.Add(format('%s=%s',[LastAttrName,LastAttrVal]));
    //Attributes.Values[LastAttrName]:=LastAttrVal;
    LastAttrValDelm:=#0;
    LastAttrName:='';
    LastAttrVal:='';
    lastPartType:=stpAttrNameExpect;
  end;
  procedure CheckTagBegin;
  begin
    case lastPartType of
      stpCDATA         : begin lastPartType:=stpTagCmdExpect; end;
      stpWhiteSpace    : doInvalidAttrChar;//invalid tag! SGML Tags cannot include "<" ch except as tag begin or in attribute values
      stpTagCmd        : doInvalidAttrChar;//invalid tag! SGML Tag names cannot begin with "<<"
      stpTagCmdExpect  : doInvalidAttrChar;//invalid tag! SGML Tag names cannot begin with "<<"
      stpAttrName      : doInvalidAttrChar;//invalid tag! SGML Attr Names cannot include "<" or ">" chars.So Ignore Char
      stpAttrNameExpect: doInvalidAttrChar;//invalid tag! eg <mytag <...
      stpAttrVal       : LastAttrVal:=LastAttrVal+p^;
      stpAttrValExpect : doInvalidAttrChar;//invalid tag! eg <mytag attr=<...
      stpTagEndExpect  : doInvalidAttrChar;//invalid tag!.Tag cmd expected. eg </>
    end;
  end;
  procedure CheckTagEnd;
  begin
    case lastPartType of
      stpCDATA          : begin end; //ignore ">" char in cdata.
      stpWhiteSpace     : finalizeTag;
      stpTagCmd         : begin finalizeTagCmd; finalizeTag; end;
      stpTagCmdExpect   : doInvalidAttrChar;//invalid tag! Tag CMd Expected eg"<>"
      stpAttrName       : begin finalizeAttrName; finalizeTag; end;
      stpAttrNameExpect : finalizeTag;
      stpAttrVal        : begin
                            if (LastAttrValDelm<>#0) and (LastAttrValDelm<>' ')  then
                            begin
                              LastAttrVal:=LastAttrVal+p^;
                            end
                            else
                            begin
                              finalizeAttrVal;
                              finalizeTag;
                            end;
                           end;
      //not sure !
      stpAttrValExpect  : doInvalidAttrChar;//boolean attr or invalid tag! eg <mytag attr=>...
      stpTagEndExpect   : finalizeTagBlock;
    end;
  end;
  procedure CheckAttr;
  begin
    case lastPartType of
      stpCDATA          : begin end; //ignore attr val identifier chars in cdata.
      stpWhiteSpace     : lastPartType:=stpAttrVal;
      stpTagCmd         : doInvalidAttrChar;//invalid tag!Attyribute name expected.. eg <mytag"... or <mytag'...
      stpTagCmdExpect   : doInvalidAttrChar;//invalid tag!Attyribute name expected.. eg <"... or <'...
      stpAttrName       : begin lastPartType:=stpAttrVal; doInvalidAttrChar; end;//invalid tag!"=" ch expected. eg <mytag myattr"
      stpAttrNameExpect : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <mytag attr1="val1"" <-- last attrval deliminiter ist invalid!
      stpAttrVal        : if LastAttrValDelm=#0 then
                            initializeAttrVal
                          else
                          if p^=LastAttrValDelm then
                          begin  LastAttrVal:=LastAttrVal+p^;finalizeAttrVal; end
                          else
                            LastAttrVal:=LastAttrVal+p^; // for ex ... attr=" intattr='int val' "  here ' is part of value and " is deliminiter.
      stpAttrValExpect  : initializeAttrVal;
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag attr1="val1"/" <-- last attrval deliminiter ist invalid!
    end;
  end;
  procedure CheckAssign;
  begin
    case lastPartType of
      stpCDATA          : begin end; //ignore attr assignment chars in cdata.
      stpWhiteSpace     : lastPartType:=stpAttrValExpect;
      stpTagCmd         : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <mytag=...
      stpTagCmdExpect   : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <=...
      stpAttrName       : begin lastPartType:=stpAttrValExpect; finalizeAttrName; end;
      stpAttrNameExpect : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <mytag attr1="val1"" <-- last attrval deliminiter ist invalid!
      stpAttrVal        : LastAttrVal:=LastAttrVal+p^;
      stpAttrValExpect  : initializeAttrVal;//invalid tag! Already expecting Attr Val Identifier. eg  <mytag attr==... last equal ch is invalid.
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag attr1="val1"/= <-- last equal ch is invalid!
    end;
  end;
  procedure CheckWS;
  begin
    case lastPartType of
      stpCDATA          : begin end; //ignore ws chars in cdata.
      stpWhiteSpace     : begin end; //ignore ws chars in ws
      stpTagCmd         : begin lastPartType:=stpAttrNameExpect; finalizeTagCmd; end;
      stpTagCmdExpect   : begin end;
      stpAttrName       : begin lastPartType:=stpWhiteSpace; finalizeAttrName; end;
      stpAttrNameExpect : begin end;
      stpAttrVal        : if LastAttrValDelm=#0 then
                            finalizeAttrVal
                          else
                          if LastAttrValDelm=' ' then
                            finalizeAttrVal
                          else
                             LastAttrVal:=LastAttrVal+p^;
      stpAttrValExpect  : begin end;
      stpTagEndExpect   : begin end;
    end;
  end;
  procedure CheckTagBlockEnd;
  begin
    case lastPartType of
      stpCDATA          : begin end; //ignore ws chars in cdata.
      stpWhiteSpace     : begin lastPartType:=stpTagEndExpect; end; //ignore ws chars in ws
      stpTagCmd         : initializeTagCmd;
      stpTagCmdExpect   : initializeTagBlockEnd;
      stpAttrName       : begin lastPartType:=stpTagEndExpect;finalizeAttrName; end;
      stpAttrNameExpect : begin lastPartType:=stpTagEndExpect;end;
      stpAttrVal        : LastAttrVal:=LastAttrVal+p^;
      stpAttrValExpect  : begin lastPartType:=stpAttrVal;LastAttrValDelm:=' ';LastAttrVal:=LastAttrVal+p^;end; //<IMG src=/pages/img.gif ... >
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag ... // <-- last slash ch is invalid!
    end;
  end;
  procedure ProcessCh;
  begin
    case lastPartType of
      stpCDATA          : LastCDATA:=LastCDATA+p^;
      stpWhiteSpace     : begin end;//ignore ws between that are between parts
      stpTagCmd         :
                          begin
                             LastTagCmd:=LastTagCmd+p^;
                             if LastTagCmd='!--' then
                             begin
                               aTagType:=htComment;
                               aTagCmd:=LastTagCmd;
                               aTagSubType:=[beBegin,beEnd];
                               p:=pEnd;
                             end;
                          end;
      stpTagCmdExpect   : begin lastPartType:=stpTagCmd; LastTagCmd:=LastTagCmd+p^ end;
      stpAttrName       : LastAttrName:=LastAttrName+p^;
      stpAttrNameExpect : begin initalizeAttrName; LastAttrName:=LastAttrName+p^;end;
      stpAttrVal        : LastAttrVal:=LastAttrVal+p^;
      stpAttrValExpect  : begin lastPartType:=stpAttrVal;LastAttrVal:=LastAttrVal+p^;end;
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag ... /? <-- last ch is invalid!
    end;

  end;
begin
  p:=pchar(bTag.fTagStr);
  l:=length(bTag.fTagStr);
  pEnd:=p+l-1;
//  t:=0;
  aTagType:=htUnknown;
  lastPartType:=stpCDATA;
  LastTagCmd:='';
  LastAttrName:='';
  LastAttrVal :='';
  LastCDATA:='';
  while p^<>#0 do
  begin
//    inc(t);
    case p^ of
      '<' : CheckTagBegin;    //tag begin
      '>' : CheckTagEnd;      //tag end
      '''': CheckAttr;        //text attr
      '"' : CheckAttr;        //text attr
      '=' : CheckAssign;      //attr assignment
      ' ' : CheckWS;          //deliminiter or white space
      '/' : CheckTagBlockEnd; //tag block end id if next special ch is '>'
      else ProcessCh;
    end;
    inc(p);
  end;
  if (LastCDATA<>'') and (aTagType=htUnknown) then
    aTagType:=htPlainText;

  bTag.fTagSubType := aTagSubType;
  bTag.fTagType    := aTagType;
  bTag.fTagCmd     := aTagCmd;
  bTag.fIsBeginTag := (beBegin in aTagSubType) or (atagType=htPlainText);
  bTag.fIsEndTag   := (beEnd in aTagSubType) or (atagType=htPlainText);
  bTag.fIsDoubleTag:= atagType in c_HTMLDoubleTags;
  bTag.fIsOptionalTag  := atagType in c_HTMLOptionalDoubleTags;
  bTag.fIsSIngleTag    := atagType in c_HTMLEmptyTags;

end;

procedure THTMLParsedTag.setTagStr(aTagStr:string);
//var
  //t:integer;
  //tagname:string;
  //s:string;
  //CancelParsing:boolean;
begin
  //Parse Tag Str and set some level1 props
  fTagStr:=aTagStr;
  Owner.parse_TagStr(self);
end;
procedure THTMLParsedTag.setBeginTag (aTag:THTMLParsedTag);
begin
  if assigned(aTag) and assigned(fBeginTag) then
    fBeginTag.EndTag:=nil;
  fBeginTag:=aTag;
  if assigned(aTag) then
    if aTag.EndTag<>self then
      if aTag<>self then
        aTag.EndTag:=self;
end;
procedure THTMLParsedTag.setEndTag   (aTag:THTMLParsedTag);
begin
  if assigned(aTag) and assigned(fEndTag) then
    fEndTag.BeginTag:=nil;
  fEndTag:=aTag;
  if assigned(aTag) then
    if aTag.BeginTag<>self then
      if aTag<>self then
        aTag.BeginTag:=self;
end;
procedure THTMLParsedTag.setParentTag(aTag:THTMLParsedTag);
begin
  if aTag=self then
  begin
    fParentTag:=nil;
    exit;
  end;
  if assigned(fParentTag) and (aTag<>fParentTag) then
    fParentTag.childs.Remove(self);

  if assigned(aTag) and (aTag<>fParentTag) then
  begin
    fParentTag:=aTag;
    aTag.childs.Add(self);
    if (isValidTag) and (not isParentValid) then //Calculate nearest Hiearchic Distance from current parent
      CalculateHiearchicDistanceFromCurrentParent
    else
      fDistFromParCnt:=0;//means this is a valid child of current parent
  end
  else
  begin
    fParentTag:=aTag;
    if (isValidTag) and (not isParentValid) then //Calculate nearest Hiearchic Distance from current parent
      CalculateHiearchicDistanceFromCurrentParent
  end;

end;
function  THTMLParsedTag.getPrevTag:THTMLParsedTag;
begin
  result:=nil;
  if assigned(owner) then
  if TagIndex>0 then
  begin
    result:=owner.ParsedTags[TagIndex-1];
  end;
end;
function  THTMLParsedTag.getNextTag:THTMLParsedTag;
begin
  result:=nil;
  if assigned(owner) then
  if TagIndex<owner.ParsedTags.count-1 then
  begin
    result:=owner.ParsedTags[TagIndex+1];
  end;
end;
function  THTMLParsedTag.getTagIndex:integer;
begin
  result:=-1;
  if assigned(owner) then
    if assigned(owner.ParsedTags) then
      result:=owner.ParsedTags.IndexOf(self);
end;
procedure THTMLParsedTag.setTagIndex(NewIndex:integer);
var
  i:integer;
  childIndex:integer;
begin
  if assigned(owner) then
    if assigned(owner.ParsedTags) then
    begin
      owner.ParsedTags.remove(self);
      owner.ParsedTags.insert(NewIndex,self);
    end;
  if assigned(ParentTag) then
  begin
    childIndex:=ParentTag.childs.indexOf(self);
    for i:=0 to ParentTag.childs.count-1 do
    begin
      if (ParentTag.childs[i].TagIndex>NewIndex) and (i<childIndex) then
      begin
        ParentTag.childs.remove(self);
        ParentTag.childs.insert(i,self);
        break;
      end;
    end;
  end;

end;
{
function  THTMLParsedTag.getIsBeginTag:boolean;
begin
  result:=(beBegin in fTagSubType) or (tagType=htPlainText);
end;
function  THTMLParsedTag.getIsEndTag:boolean;
begin
  result:=(beEnd in fTagSubType) or (tagType=htPlainText);
end;

function  THTMLParsedTag.getIsDoubleTag:boolean;
begin
  result:=tagType in c_HTMLDoubleTags;
end;

function  THTMLParsedTag.getIsSingleTag:boolean;
begin
  result:=tagType in c_HTMLEmptyTags;
end;
function  THTMLParsedTag.getIsOptionalTag:boolean;
begin
  result:=tagType in c_HTMLOptionalDoubleTags;
end;
}
function  THTMLParsedTag.getIsBegun:boolean; //return true if BeginTag assigned
begin
  result:=assigned(BeginTag);
end;
function  THTMLParsedTag.getIsClosed:boolean;//return true if endtag assigned
begin
  result:=assigned(EndTag)
end;
function  THTMLParsedTag.getIsParentValid:boolean;
begin
  result:=false;
  if tagType in c_HTMLCodeFormatTags then
  begin
    result:=true;
    exit;
  end;
  if tagType=htComment then
  begin
    result:=true;
    exit;
  end;
  if (tagType=htHtml) and (not assigned(ParentTag)) then //html tag does not need any parent because its root tag
  begin
    result:=true;
    exit;
  end;
  if assigned(ParentTag) then  //alow everything in script block!
  if ParentTag.TagType=htScript then
  begin
    result:=true;
    exit;
  end;
  if assigned(ParentTag) then
    result:=ParentTag.TagType in c_HTMLValidParents[TagType];
  if not result then
    result:=c_HTMLValidParents[TagType]=[];
end;
function  THTMLParsedTag.isCodeFormatTag:boolean;
begin
  result:=TagType in c_HTMLCodeFormatTags;
end;
function  THTMLParsedTag.get_TagType:THTMLTagTypes;
begin
  result:=fTagType;
  if assigned(ParentTag) then
  if ParentTag.fTagType=htScript then
  if fTagType<>htScript then //assume everthing as comment in script blocks...
    result:=htComment
end;
procedure THTMLParsedTag.CalculateHiearchicDistanceFromCurrentParent;
type
  TDistReport = record
    distance: THTMLChildParentDistance;
    count   : smallint;
  end;
var
  dist:TDistReport;
  i:integer;
  bestcount:smallint;
begin
  if not isValidTag then //possible data tag
  begin
    dist.count:=0;
    exit;
  end
  else
    dist.count:=-1; //set default to invalid
  bestcount:=32;
  if assigned(parentTag) then
  begin
    for i:=0 to 32 do
      dist.distance[i]:=htUnknown;
    fDistFromParCnt:=CheckForTheChildsOfGivenParentEx(bestCount,parentTag.TagType,dist.distance,0,tagtype);
    fDistFromParent:=dist.distance;
  end
  else
  begin
    fDistFromParCnt:=CheckForTheChildsOfGivenParentEx(bestcount,htDocType,dist.distance,0,TagType);
    fDistFromParent:=dist.distance;
  end;
end;
{
function  THTMLParsedTag.StacksDiff(aTagType:THTMLTagTypes):integer;
begin
  result:=fFwdStacks[aTagType]-fRwdStacks[aTagType];
end;
}
function  THTMLParsedTag.CheckAsChild (ParsedTagToExamine:THTMLParsedTag):boolean; //returns true if given tag is a valid child to this
begin
  if assigned(ParsedTagToExamine) then
    result:=ParsedTagToExamine.tagType in c_HTMLValidChilds[tagtype]
  else
    raise exception.create('no tag to valid child examination');
end;
function  THTMLParsedTag.CheckAsParent(ParsedTagToExamine:THTMLParsedTag):boolean; //returnd true if given tag is a valid parent to this
begin
  if assigned(ParsedTagToExamine) then
    result:=ParsedTagToExamine.tagType in c_HTMLValidParents[tagtype]
  else
    raise exception.create('no tag to valid parent examination');
end;

{THTMLParsedTagCollection}
function  THTMLParsedTagCollection.getItem(index:integer):THTMLParsedTag;
begin
  result:=THTMLParsedTag(inherited getItem(index));
end;
procedure THTMLParsedTagCollection.setItem(index:integer;aParsedTag:THTMLParsedTag);
begin
  inherited setItem(index,aParsedTag);
end;
{THTMLLinePosObj}
{
constructor THTMLLinePosObj.Create(CurrentRow,CurrentCol:dword);
begin
  inherited create;
  fCol:=CurrentCol;
  fRow:=CurrentRow;
end;
}
{THTMLParser}
constructor THTMLParser.Create(HTMLCode:string;FixProblems:boolean;aDocument:THTMLDocument);
var t:THTMLTagTypes;
begin
  inherited Create;
  fReport        :=TStringList.create;
  fDocument:=aDocument;
  fFixProblems:=FixProblems;
  fParsedTags := THTMLParsedTagCollection.Create(false);
  fSourceLines:= TStringList.Create;
  fSourceLines.Text:=HTMLCode;

  fParsedHTML := TStringList.Create;
  for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
  begin
    fFwdTagStacks[t]:=THTMLParsedTagCollection.Create(false);
    fRwdTagStacks[t]:=THTMLParsedTagCollection.Create(false);
  end;

  StartTimer;
    ParseHTMLCode(False);
  AddToReport('inital SGML Parsing');


  StartTimer;
    CalculateTagLineProps;
  AddToReport('SGML Tag Prop Calc');

  StartTimer;
    MatchTags;
  AddToReport('SGML Tag Matching');

  StartTimer;
    BuildTree;
  AddToReport('SGML Tree Building and Err Fixing');
  //CheckTree;
  StartTimer;
    CheckMinRequirements;
  AddToReport('HTML min Requirements Control');
  StartTimer;
    CheckForMissingTags;
  AddToReport('Missing HTML tags Fixing');
end;
destructor  THTMLParser.destroy;
var
  t:THTMLTagTypes;
begin
  destoying:=true;
  try
    for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
    begin
      if assigned(fFwdTagStacks[t]) then
        fFwdTagStacks[t].Free;
      if assigned(fRwdTagStacks[t]) then
        fRwdTagStacks[t].free;
    end;
    while fParsedTags.Count>0 do
      fParsedTags[0].Free;
  finally
    try
      fParsedTags.Free;
      fSourceLines.Clear;
      fSourceLines.Free;
      fParsedHTML.Clear;
      fParsedHTML.Free;
      fReport.free;
    finally
      inherited Destroy;
    end;
  end;
end;

function THTMLParser.CreateTag(
             aTagCmd:string;
             aTagStr:string;
             Attributes:TStrings;
             aCodeFormattingChars:string;
             aTagSubType:TTagSubType;
             CurrRow:dword;
             CurrCol:dword):THTMLParsedTag;
var
  fTagType:THTMLTagTypes;
  s:string;
begin
  result:=THTMLParsedTag.Create(self);
  result.fCodeFormattingChars:=aCodeFormattingChars;
  result.fTagSubType := aTagSubType;
  result.EndTag:=nil;
  result.BeginTag:=nil;
  if aTagSubType=[beEnd] then
    result.EndTag:=result
  else
  if aTagSubType=[beBegin] then
    result.BeginTag:=result
  else
  begin
    result.BeginTag:=result;
    result.EndTag:=result;
  end;
  if aTagCmd<>'' then
    fTagType:=GetTagType(aTagCmd)
  else
    fTagType:=htPlainText;
  if fTagType=htInput then
  begin
    s:=StringReplace(Attributes.values['type'],'"','',[rfReplaceAll]);
    s:=StringReplace(s,'''','',[rfReplaceAll]);
    if compareText(s,'hidden')=0 then
      fTagType:=htInputHidden;
  end;
  result.fSourceRow:=CurrRow;
  result.fSourceCol:=CurrCol;
  result.fTagType    := fTagType;
  result.fTagStr     := aTagStr;
  result.fTagCmd     := aTagCmd;
  result.fIsBeginTag := (beBegin in aTagSubType) or (fTagType=htPlainText);
  result.fIsEndTag   := (beEnd in aTagSubType) or (fTagType=htPlainText);
  result.fIsDoubleTag:= fTagType in c_HTMLDoubleTags;
  result.fIsOptionalTag  := fTagType in c_HTMLOptionalDoubleTags;
  result.fIsSIngleTag    := fTagType in c_HTMLEmptyTags;
  result.Attributes.Assign(Attributes);
  fParsedHTML.Add(aTagStr);
end;
function  THTMLParser.CreateTag(
             pTagCmd:pchar;
             pTagStr:pchar;
             Attributes:TStrings;
             lTagCmd:byte;
             lTagStr:word;
             pCodeFormattingChars:pchar;
             lCodeFormattingChars:byte;
             aTagSubType:TTagSubType;
             CurrRow:dword;
             CurrCol:dword;
             isComment:boolean):THTMLParsedTag;
var
  fTagType:THTMLTagTypes;
  s:string;
begin
  if lTagStr>512 then
    s:='';
  result:=THTMLParsedTag.Create(self);
  if lCodeFormattingChars>0 then
  begin
    setLength(result.fCodeFormattingChars,lCodeFormattingChars);
    move(pCodeFormattingChars^,result.fCodeFormattingChars[1],lCodeFormattingChars);
  end;
  result.fTagSubType := aTagSubType;
  result.EndTag:=nil;
  result.BeginTag:=nil;
  if aTagSubType=[beEnd] then
    result.EndTag:=result
  else
  if aTagSubType=[beBegin] then
    result.BeginTag:=result
  else
  begin
    result.BeginTag:=result;
    result.EndTag:=result;
  end;
  if lTagCmd>0 then
  begin
    setLength(result.fTagCmd,lTagCmd);
    move(pTagCmd^,result.fTagCmd[1],lTagCmd);
  end;

  if lTagCmd>0 then
    fTagType:=GetTagType(result.fTagCmd)
  else
  if isComment then
    fTagType:=htComment
  else
    fTagType:=htPlainText;
  if fTagType=htInput then
  begin
    s:=StringReplace(Attributes.values['type'],'"','',[rfReplaceAll]);
    s:=StringReplace(s,'''','',[rfReplaceAll]);
    if compareText(s,'hidden')=0 then
      fTagType:=htInputHidden;
  end;
  result.fSourceRow:=CurrRow;
  result.fSourceCol:=CurrCol;
  result.fTagType    := fTagType;
  if lTagStr>0 then
  begin
    setLength(result.fTagStr,lTagStr);
    move(pTagStr^,result.fTagStr[1],lTagStr);
  end;


  result.fIsBeginTag := (beBegin in aTagSubType) or (fTagType=htPlainText);
  result.fIsEndTag   := (beEnd in aTagSubType) or (fTagType=htPlainText);
  result.fIsDoubleTag:= fTagType in c_HTMLDoubleTags;
  result.fIsOptionalTag  := fTagType in c_HTMLOptionalDoubleTags;
  result.fIsSIngleTag    := fTagType in c_HTMLEmptyTags;
  result.Attributes.Assign(Attributes);
  fParsedHTML.Add(result.fTagStr);
end;

procedure THTMLParser.ParseHTMLCode;
var
  p                : pchar;  // denoted 32 bit pointer register
  lastPartType      : TSGMLTagParsingStates;
  CurrCol          : word;   // denoted 16 bit general register
  pCodeFormatting  : pchar;  // denoted 32 bit pointer register
  biTagStart       : byte;   // denoted 8  bit general register
  CurrRow          : dword;  // denoted 32 bit general register
  wTagLen          : word;   // denoted 16 bit general register
  biTagCmd         : byte;   // denoted  8 bit general register
  bTagCmdLen       : byte;   // denoted  8 bit general register
  wiAttrName       : word;   // denoted 16 bit general register
  wAttrNameLen     : word;   // denoted 16 bit general register
  wiAttrValue      : word;   // denoted 16 bit general register
  wAttrValueLen    : word;   // denoted 16 bit general register
  cAttrValDelm     : byte;   // denoted  8 bit general register
  fAttributes:TStringList;
  //LastCDATA         : string;
  aTagSubType       : TTagSubType;
  sLastCDATATagCmd  : string;

  function pTagStart:pchar;
  begin
    result:=pCodeFormatting+biTagStart;
  end;
  function pTagEnd:pchar;
  begin
   result:=pTagStart+wTagLen
  end;
  function pTagCmd:pchar;
  begin
    result:=pchar(pTagStart+biTagCmd);
  end;
  function sTagCmd:string;
  begin
    setLength(result,bTagCmdLen);
    move(pTagCmd^,result[1],bTagCmdLen);
  end;
  function pAttrName:pchar;
  begin
    result:=pchar(pTagStart+wiAttrName);
  end;
  function sAttrName:string;
  begin
    setLength(result,word(wAttrNameLen));
    move(pAttrName^,result[1],wAttrNameLen);
  end;
  function pAttrVal:pchar;
  begin
    result:=pchar(pTagStart+wiAttrValue);
  end;
  function sAttrVal:string;
  begin
    setLength(result,wAttrValueLen);
    move(pAttrVal^,result[1],wAttrValueLen);
  end;
  function CodeFormatLen:dword;
  begin
    result:=pTagStart-pCodeFormatting;
  end;
  function sCodeFormattingChars:string;
  begin
    if CodeFormatLen>0 then
    begin
      setLength(result,CodeFormatLen);
      move(pCodeFormatting^,result[1],CodeFormatLen);
    end;
  end;
  function sTag:string;
  begin
    setLength(result,wTagLen);
    move(pTagStart^,result[1],wTagLen);
  end;

  procedure doInvalidAttrChar;
  begin
    //raise exception.Create('error on parsing SGML tag.Invalid character.');
  end;
  procedure doNotSure;
  begin
    //raise exception.Create('Not Sure');
    //ShowMessage('Not sure');
  end;

  procedure initializeTag;
  begin
    lastPartType:=stpTagCmdExpect;
    biTagStart:=p-pCodeFormatting;
    wAttrNameLen:=0;
    bTagCmdLen:=0;
    aTagSubType:=[beBegin];
  end;
  procedure initializeCDATABlock;
  begin
    lastPartType:=stpCDATABlock;
    biTagStart:=p-pCodeFormatting;
    wAttrNameLen:=0;
    bTagCmdLen:=0;
    aTagSubType:=[beBegin];
  end;
  procedure finalizeTag;
  var
    s:string;
    isComment:boolean;
  begin
    wTagLen:=p-pTagStart;
    isComment:=lastPartType=stpCDATABlock;
    if bTagCmdLen>0 then
      inc(wTagLen); // for the last tag closing ch ">"
    s:=sTagCmd;
    if ((CompareText(s,'script')=0) or (CompareText(s,'style')=0)) then
    begin
      isComment:=True;
      if (aTagSubType=[beEnd]) and (CompareText(sLastCDATATagCmd,s)=0) then
      begin
        lastPartType:=stpCDATA;
      end
      else
        lastPartType:=stpCDATABlockExpected;
      sLastCDATATagCmd:=s;
    end
    else
      lastPartType:=stpCDATA;

    if (aTagSubType=[]) then
    begin
      aTagSubType:=[beBegin];
    end;
    //CreateTag(sTagCmd,sTag,fAttributes,sCodeFormattingChars,aTagSubType,CurrRow,CurrCol);
    CreateTag(pTagCmd,pTagStart,fAttributes,bTagCmdLen,wTagLen,pCodeFormatting,CodeFormatLen,aTagSubType,CurrRow,CurrCol,isComment);
    pCodeFormatting:=p;
    if bTagCmdLen>0 then
      inc(pCodeFormatting);  //for the first ch of tag "<"
    bTagCmdLen:=0;
    biTagStart:=0;
    biTagCmd:=0;
    wTagLen:=0;
    FAttributes.Clear;
    aTagSubType:=[];
  end;
  procedure finalizeTagBlock;  // eg <mytag ... />
  begin
    //XML style single tag block ended..
    //lastPartType:=stpTagEndExpect;
    aTagSubType:=[beBegin,beEnd];

    finalizeTag;
  end;
  procedure initializeComment;
  begin
    biTagCmd:=p-pTagStart;
    lastPartType:=stpCommentBeginExpect;
  end;
  procedure FinalizeCDATA;
  begin
    if wTagLen>0 then
      finalizeTag;
  end;
  procedure initializeTagCmd;
  begin
    if p^<>'/' then
      biTagCmd:=p-pTagStart;
      //LastTagCmd:=p^;
    lastPartType:=stpTagCmd;
  end;
  procedure finalizeTagCmd;
  //var s:string;
  begin
    bTagCmdLen:=p-pTagCmd;
    lastPartType:=stpAttrNameExpect;

  end;
  procedure initializeTagBlockEnd;
  begin
    aTagSubType:=[beEnd];
    lastPartType:=stpTagCmdExpect;
    //initializeTagCmd;
  end;
  procedure finalizeAttrName;
  var s:string;
  begin
    //assume that it is boolean attribute
    //Attributes.values[LastAttrName]:='true';
    wAttrNameLen:=p-pAttrName;
    if ((p^=' ') or (p^='/') or (p^='>')) and  (wAttrNameLen>0) then
    begin
      s:=sAttrName;
      fAttributes.add(s);
      wAttrNameLen:=0;
      wiAttrValue:=0;
      cAttrValDelm:=0;
    end;
  end;
  procedure initalizeAttrName;
  begin
    if wAttrNameLen>0 then
      fAttributes.add(sAttrName);
    //LastAttrName:='';
    wiAttrName:=p-pTagStart;
    wAttrNameLen:=0;
    wiAttrValue:=0;
    cAttrValDelm:=0;
    lastPartType:=stpAttrName;
  end;
  procedure initializeAttrVal;
  begin
    lastPartType:=stpAttrVal;
    if (p^='''') or (p^='"') then
      cAttrValDelm:=byte(p^)
    else
      cAttrValDelm:=0;
    wiAttrValue:=p-pTagStart;
    wAttrValueLen:=0;
    //LastAttrVal:=p^;
  end;
  procedure finalizeAttrVal;
  var sn,sv:string;
  begin
    if wiAttrValue>0 then
    begin
      wAttrValueLen:=p-pAttrVal;
      if cAttrValDelm=byte(p^) then
        inc(wAttrValueLen);  //for the last deliminiter ch <"> or <'>
      sn:=sAttrName;
      sv:=sAttrVal;
      //fAttributes.Add(format('%s=%s',[sAttrName,sAttrVal]));
      fAttributes.Add(format('%s=%s',[sn,sv]));
    end;
    cAttrValDelm:=0;
    wAttrNameLen:=0;
    lastPartType:=stpAttrNameExpect;
  end;

  procedure finalizeComment;
  begin
    aTagSubType:=[beBegin,beEnd];
    bTagCmdLen:=3;
    finalizeTag;
  end;
  function isCDATABlockEnding:boolean;
  var
    i:byte;
    s:string;
  begin
    result:=true;
    s:='';
    for i:=1 to length(sLastCDATATagCmd) do
       s:=s+(p+i+1)^;
    if CompareText(s,sLastCDATATagCmd)<>0 then
       result:=false;
  end;

  procedure CheckCDATABlockEnding;
  var
    //i:byte;
    found:boolean;
    //t:TSGMLTagParsingStates;
  begin
    found:=isCDATABlockEnding;
    if lastPartType<>stpCDATABlock then  // nothing to do CDATA block not initialized because no CDATA actually.
      exit;
    if found then
    begin
      wTagLen:=p-pTagStart;
      //dec(p);
      //t:=lastPartType;
      FinalizeCDATA;
      lastPartType:=stpTagCmdExpect;
      //inc(p);
    end;
  end;
  procedure CheckTagBegin;
  begin
    case lastPartType of
      stpCDATA         : begin FinalizeCDATA;initializeTag;{pTagStart:=dword(p);} end;
      stpWhiteSpace    : doInvalidAttrChar;//invalid tag! SGML Tags cannot include "<" ch except as tag begin or in attribute values
      stpTagCmd        : doInvalidAttrChar;//invalid tag! SGML Tag names cannot begin with "<<"
      stpTagCmdExpect  : doInvalidAttrChar;//invalid tag! SGML Tag names cannot begin with "<<"
      stpAttrName      : doInvalidAttrChar;//invalid tag! SGML Attr Names cannot include "<" or ">" chars.So Ignore Char
      stpAttrNameExpect: doInvalidAttrChar;//invalid tag! eg <mytag <...
      {stpAttrVal       : begin end;}
      stpAttrValExpect : doInvalidAttrChar;//invalid tag! eg <mytag attr=<...
      stpTagEndExpect  : doInvalidAttrChar;//invalid tag!.Tag cmd expected. eg </>
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : begin doNotSure; end;
      stpCDATABlockExpected : if ((p+1)^='/') and (not isCDATABlockEnding) then
                                initializeCDATABlock
                               else  initializeTag;
      stpCDATABlock    : if ((p+1)^='/') then CheckCDATABlockEnding;
    end;
  end;
  procedure CheckTagEnd;
  begin
    case lastPartType of
      {stpCDATA          : begin end;} //ignore ">" char in cdata.
      stpWhiteSpace     : finalizeTag;
      stpTagCmd         : begin finalizeTagCmd; finalizeTag; end;
      stpTagCmdExpect   : doInvalidAttrChar;//invalid tag! Tag CMd Expected eg"<>"
      stpAttrName       : begin finalizeAttrName; finalizeTag; end;
      stpAttrNameExpect : finalizeTag;
      stpAttrVal        : begin
                            if (cAttrValDelm=0) or (cAttrValDelm=byte(' '))  then
                            begin
                              finalizeAttrVal;
                              finalizeTag;
                            end;
                           end;
      //not sure !
      stpAttrValExpect  : doInvalidAttrChar;//boolean attr or invalid tag! eg <mytag attr=>...
      stpTagEndExpect   : finalizeTagBlock;
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : finalizeComment;
      stpCDATABlockExpected : initializeCDATABlock;

    end;
  end;
  procedure CheckAttr;
  begin
    case lastPartType of
      {stpCDATA          : begin end;} //ignore attr val identifier chars in cdata.
      stpWhiteSpace     : lastPartType:=stpAttrVal;
      stpTagCmd         : doInvalidAttrChar;//invalid tag!Attyribute name expected.. eg <mytag"... or <mytag'...
      stpTagCmdExpect   : doInvalidAttrChar;//invalid tag!Attyribute name expected.. eg <"... or <'...
      stpAttrName       : lastPartType:=stpAttrVal; //invalid tag!"=" ch expected. eg <mytag myattr"
      stpAttrNameExpect : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <mytag attr1="val1"" <-- last attrval deliminiter ist invalid!
      stpAttrVal        : if cAttrValDelm=0 then
                            p^:=' '  // quote ch after non-quoted attr val eg <meta content=someVal"...
                          else
                            if byte(p^)=cAttrValDelm then
                          begin finalizeAttrVal; end;
      stpAttrValExpect  : initializeAttrVal;
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag attr1="val1"/" <-- last attrval deliminiter ist invalid!
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : begin doNotSure; end;
      stpCDATABlockExpected : initializeCDATABlock

    end;
  end;
  procedure CheckAssign;
  begin
    case lastPartType of
      {stpCDATA          : begin end;} //ignore attr assignment chars in cdata.
      stpWhiteSpace     : lastPartType:=stpAttrValExpect;
      stpTagCmd         : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <mytag=...
      stpTagCmdExpect   : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <=...
      stpAttrName       : begin lastPartType:=stpAttrValExpect; finalizeAttrName; end;
      stpAttrNameExpect : doInvalidAttrChar;//invalid tag!Attribute name expected.. eg <mytag attr1="val1"" <-- last attrval deliminiter ist invalid!
      {stpAttrVal        : begin end;}
      stpAttrValExpect  : initializeAttrVal;//invalid tag! Already expecting Attr Val Identifier. eg  <mytag attr==... last equal ch is invalid.
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag attr1="val1"/= <-- last equal ch is invalid!
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : begin doNotSure; end;
      stpCDATABlockExpected : initializeCDATABlock
    end;
  end;
  procedure CheckWS;
  begin
    case lastPartType of
      {stpCDATA          : begin end;} //ignore ws chars in cdata.
      {stpWhiteSpace     : begin end;} //ignore ws chars in ws
      stpTagCmd         : begin lastPartType:=stpAttrNameExpect; finalizeTagCmd; end;
      {stpTagCmdExpect   : begin end;}
      stpAttrName       : begin lastPartType:=stpAttrNameExpect; finalizeAttrName; end;
      {stpAttrNameExpect : begin end;}
      stpAttrVal        : if (cAttrValDelm=0) or  (cAttrValDelm=byte(' ')) then finalizeAttrVal;
      {stpAttrValExpect  : begin end;}
      {stpTagEndExpect   : begin end;}
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      {stpCommentEndExpect   : begin doNotSure; end;}
      stpCDATABlockExpected : initializeCDATABlock
    end;
  end;
  procedure CheckTagBlockEnd;
  begin
    case lastPartType of
      {stpCDATA          : begin end;} //ignore ws chars in cdata.
      stpWhiteSpace     : lastPartType:=stpTagEndExpect;
      stpTagCmd         : begin finalizeTagCmd;lastPartType:=stpTagEndExpect;end;
      stpTagCmdExpect   : initializeTagBlockEnd;
      stpAttrName       : begin lastPartType:=stpTagEndExpect;finalizeAttrName; end;
      stpAttrNameExpect : lastPartType:=stpTagEndExpect;
      {stpAttrVal        : begin end;}
      stpAttrValExpect  : initializeAttrVal; //<IMG src=/pages/img.gif ... >
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag ... // <-- last slash ch is invalid!
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : lastPartType:=stpComment;
      stpCDATABlockExpected : initializeCDATABlock
    end;
  end;
  procedure ProcessCh;
  begin
    case lastPartType of
      stpCDATA          : inc(wTagLen);
      {stpWhiteSpace     : begin doNotSure; end;}//ignore ws between that are between parts
      {stpTagCmd         : begin doNotSure; end;}
      stpTagCmdExpect   : initializeTagCmd;
      {stpAttrName       : begin doNotSure; end;}
      stpAttrNameExpect : initalizeAttrName;
      {stpAttrVal        : begin doNotSure; end;}
      stpAttrValExpect  : initializeAttrVal;
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag ... /? <-- last ch is invalid!
      stpCommentBeginExpect : initializeTagCmd;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : lastPartType:=stpComment;
      stpCDATABlockExpected : initializeCDATABlock;
    end;
  end;
  procedure CheckCommentBegin;
  begin

    case lastPartType of
      {stpCDATA          : begin doNotSure; end;}
      stpWhiteSpace     : begin doNotSure; end;
      stpTagCmd         : begin doNotSure; end;
      stpTagCmdExpect   : if ((p+1)^='-') and ((p+2)^='-') then initializeComment else initializeTagCmd;
      {stpAttrName       : begin end;}
      stpAttrNameExpect : initalizeAttrName;
      {stpAttrVal        : begin end;}
      stpAttrValExpect  : initializeAttrVal;
      stpTagEndExpect   : doInvalidAttrChar;//invalid tag!White Space or ">" expected.. eg <mytag ... /? <-- last ch is invalid!
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : begin doNotSure; end;
      stpCDATABlockExpected : initializeCDATABlock
    end;
  end;
  procedure CheckComment;
  begin
    if (pchar(p+1)^='-') then
    begin
      case lastPartType of
        stpCommentBeginExpect : lastPartType:=stpComment;
        stpComment            : if (pchar(p+1)^='-') then lastPartType:=stpCommentEndExpect;
        stpCDATABlockExpected : initializeCDATABlock;
      end;
    end
    else
    case lastPartType of
      stpAttrValExpect      : initializeAttrVal;
    end;
  end;
  procedure processCR;
  begin
    inc(CurrRow);
    CurrCol:=1;
    case lastPartType of
      stpCDATA          : begin FinalizeCDATA;if wTagLen=0 then inc(biTagStart);end;
      {stpWhiteSpace     : begin end;}
      stpTagCmd         : begin lastPartType:=stpAttrNameExpect; finalizeTagCmd; end;
      {stpTagCmdExpect   : begin end;}
      stpAttrName       : begin lastPartType:=stpWhiteSpace; finalizeAttrName; end;
      {stpAttrNameExpect : begin end;}
      stpAttrVal        : if (cAttrValDelm=0) or  (cAttrValDelm=byte(' ')) then finalizeAttrVal;
      {stpAttrValExpect  : begin end;}
      {stpTagEndExpect   : begin end;}
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin doNotSure; end;}
      stpCommentEndExpect   : begin doNotSure; end;
      stpCDATABlockExpected : initializeCDATABlock;
    end;
  end;
  procedure processLF;
  begin
    //inc(CurrRow);
    //CurrCol:=1;
    case lastPartType of
      stpCDATA          : if wTagLen=0 then inc(biTagStart);
      {stpWhiteSpace     : begin end;}
      stpTagCmd         : begin doNotSure; end;
      {stpTagCmdExpect   : begin end;}
      stpAttrName       : begin doNotSure; end;
      {stpAttrNameExpect : begin end;}
      {stpAttrVal        : begin end;}
      {stpAttrValExpect  : begin end;}
      {stpTagEndExpect   : begin end;}
      stpCommentBeginExpect : begin doNotSure; end;
      {stpComment            : begin end;}
      stpCommentEndExpect   : begin doNotSure; end;
      stpCDATABlockExpected : initializeCDATABlock;
    end;
  end;

  procedure processTAB;
  begin
    case lastPartType of
      {stpCDATA              : begin end;}
      {stpWhiteSpace         : begin end;}
      stpTagCmd             : begin lastPartType:=stpAttrNameExpect; finalizeTagCmd; end;
      {stpTagCmdExpect       : begin end;}
      stpAttrName           : begin lastPartType:=stpWhiteSpace; finalizeAttrName; end;
      {stpAttrNameExpect     : begin  end;}
      {stpAttrVal            : begin end;} //ignore tabs in attribute values
      {stpAttrValExpect      : begin end;}
      stpTagEndExpect       : begin doNotSure; end;
      stpCommentBeginExpect : begin doNotSure; end;
      stpCommentEndExpect   : begin doNotSure; end;
      stpCDATABlockExpected : initializeCDATABlock;
    end;
  end;
  var s:string;
begin
  fAttributes:=TStringList.Create;
  try
    s:=fSourceLines.Text;
    p:=pchar(s);
    lastPartType:=stpCDATA;
    sLastCDATATagCmd:='';
    CurrRow:=1;
    CurrCol:=1;
    wTagLen:=0;
    biTagCmd:=0;
    biTagStart:=0;
    wiAttrName:=0;
    wiAttrValue:=0;
    wTagLen:=0;
    bTagCmdLen:=0;
    pCodeFormatting:=p;
    while p^<>#0 do
    begin
      case p^ of
        #10 : processLF;
        #13 : processCR;
        #9  : processTAB;
        '<' : CheckTagBegin;    //tag begin
        '>' : CheckTagEnd;      //tag end
        '''': CheckAttr;        //text attr
        '"' : CheckAttr;        //text attr
        '=' : CheckAssign;      //attr assignment
        ' ' : CheckWS;          //deliminiter or white space
        '/' : CheckTagBlockEnd; //tag block end id if next special ch is '>'
        '!' : CheckCommentBegin;
        '-' : CheckComment;
        else ProcessCh;
      end;
      inc(p);
      inc(CurrCol);
    end;
  finally
    FAttributes.free;
  end;

end;
(*
procedure THTMLParser.ParseHTMLCode_(RemoveControlChars:boolean);
var
  s,s1,s2:string;
  t:THTMLTagTypes;
  l,i,p:integer;
  InComment:boolean;
  InTag:boolean;
  Instring:boolean;
  TagStr:string;
  DataStr:string;
  CommentStr:string;
  tmpList:TStringList;
  CurrentRow:dword;
  CurrentCol:dword;
  lastStringDeliminiter:char;
  LinePos:THTMLLinePos;
  preserveCodeFormat:boolean;
  procedure CheckInComment;

  begin
    if not InComment then
    begin
      if s[i]='<' then
        if i+1<l then
          if s[i+1]='!' then
            if i+2<l then
              if s[i+2]='-' then
                if i+3<l then
                  if s[i+3]='-' then
                    InComment:=true;
    end
    else
    begin
      if i>4 then
        if s[i-3]='-' then
          if s[i-2]='-' then
              if s[i-1]='>' then
                InComment:=False;
    end;
  end;
  procedure CheckInString;
  begin
    if (InComment) or (not InTag) then
      InString:=False
    else
    begin
      if not InString then
      begin
        if (s[i]='"') or (s[i]='''')then
        begin
          InString:=true;
          lastStringDeliminiter:=s[i];
        end;
      end
      else
      begin
        if i>1 then
          //if (s[i]='"') or (s[i]='''') then
          if (s[i]=lastStringDeliminiter) then
          begin
            InString:=False;
            lastStringDeliminiter:=#0;
            //bug correction
            if i+1<Length(s) then
            if (s[i+1]='"') or (s[i+1]='''') then
              s[i+1]:=' ';
            //end of bug correction
          end;
      end;
    end;
  end;
  procedure CheckInTag;
  begin
    if InComment then
      InTag:=False
    else
    begin
      if not InTag then
      begin
        if s[i]='<' then
          InTag:=true;
      end
      else
      begin
        if i>1 then
          if s[i-1]='>' then
          begin
            //check in string;
            if not InString then
              InTag:=False;
          end;
      end;
    end;
  end;
  procedure CheckComment;
  begin
    if CommentStr<>'' then
    begin
      CommentStr:=StringReplace(CommentStr,#$D,'<#CR>',[rfReplaceAll, rfIgnoreCase]);
      CommentStr:=StringReplace(CommentStr,#$A,'<#LF>',[rfReplaceAll, rfIgnoreCase]);
      LinePos.row:=CurrentRow;
      LinePos.col:=CurrentCol;
      //fParsedHTML.AddObject(CommentStr,THTMLLinePosObj.Create(CurrentRow,CurrentCol));
      fParsedHTML.AddObject(CommentStr,TObject(int64(LinePos)));
      CommentStr:='';
    end;
  end;
  procedure CheckData;
  begin
    if DataStr<>'' then
    begin
      if (pos('<',Datastr)>0) or (pos('>',Datastr)>0) then
      begin
         //raise Exception.Create('Error parsing data line:'+datastr);
         Datastr:='';
         exit;
      end;
      LinePos.row:=CurrentRow;
      LinePos.col:=CurrentCol;
      if trimleft(trimright(Datastr))<>'' then
        fParsedHTML.AddObject(Datastr,TObject(int64(LinePos)));
        //fParsedHTML.AddObject(Datastr,THTMLLinePosObj.Create(CurrentRow,CurrentCol));
      Datastr:='';
    END;
  end;
  procedure CheckTag;
  begin
    if TagStr<>'' then
    begin
      //TagStr:=StringReplace(TagStr,#$D,'<#CR>',[rfReplaceAll, rfIgnoreCase]);
      //TagStr:=StringReplace(TagStr,#$A,'<#LF>',[rfReplaceAll, rfIgnoreCase]);
      //TagStr:=StringReplace(TagStr,#$D+#$A,'',[rfReplaceAll, rfIgnoreCase]);
//      TagStr:=TrimLeft(TrimRight(TagStr));
      LinePos.row:=CurrentRow;
      LinePos.col:=CurrentCol;
      if trimleft(trimright(TagStr))<>'' then
        fParsedHTML.AddObject(TagStr,TObject(int64(LinePos)));
        //fParsedHTML.AddObject(TagStr,THTMLLinePosObj.Create(CurrentRow,CurrentCol));
      if tagstr[length(tagstr)]<>'>' then
          raise Exception.Create('Error parsing tag:'+tagstr);
      TagStr:='';
    end;

  end;
begin
  tmpList:=TStringList.Create;
  try
    s:='';
    s1:=fSourceLines.Text;
    for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
      if t in c_HTMLCDataTags then
      begin
         s2:='';
         p:=pos('<'+c_HTMLTagIds[t]+' ',lowercase(s1));//inital search
         if p=0 then
           p:=pos('<'+c_HTMLTagIds[t]+'>',lowercase(s1));
         while p>0 do
         begin
           p:=pos('<'+c_HTMLTagIds[t]+' ',lowercase(s1));
           if p=0 then
             p:=pos('<'+c_HTMLTagIds[t]+'>',lowercase(s1));
           if p>0 then
           begin
             for i:=p+1 to length(s1) do
               if s1[i]='>' then
               begin
                 if s1[i-1]<>'/' then
                   s2:=s2+copy(s1,1,i)+'<!-- ';
                   s1:=copy(s1,i+1,length(s1)-i);
                 break;
               end;
           end;
         end;
         if s2<>'' then
           s1:=s2+s1;
         s1:=StringReplace(s1,'</'+c_HTMLTagIds[t]+'>',' --></'+c_HTMLTagIds[t]+'>',[rfReplaceAll, rfIgnoreCase]);
      end;
    tmpList.Text:=s1;
    for i:=0 to tmpList.Count-1 do
      s:=s+tmpList[i]+ #0;
    s:=s+#$D+#$A;//for the last element detection;
  finally
    tmpList.Free;
  end;
  InComment:=false;
  InTag:=false;
  Instring:=false;
  TagStr:='';
  DataStr:='';
  CommentStr:='';
  lastStringDeliminiter:=#0;
  fParsedHTML.clear;
  l:=length(s);
  CurrentRow:=1;
  CurrentCol :=1;
  if assigned(document) then
    preserveCodeFormat:=not document.ReFormatOutputHTML
  else
    preserveCodeFormat:=true;
  for i:=1 to  l do
  begin
    if (i mod 2000)=1 then
    if assigned(document) then
      document.doProgress(sEventParsingDocument,trunc((i/l)*20),100);
    CheckInComment;
    CheckInTag;
    CheckInString;
    if s[i]=#0 then
    begin
      CurrentCol:=1;
      inc(CurrentRow);
    end;
    if inComment then
    begin
      if s[i]=#0 then
        CommentStr:=CommentStr+#$D+#$A
      else
        CommentStr:=CommentStr+s[i];
      CheckData;
      CheckTag;
    end
    else
    if InTag then
    begin
      if (s[i]=#0) then
        TagStr:=TagStr+''//ignore white spaces in tag block
      else
      if (s[i]=#9) then
        TagStr:=TagStr+' '//convert tab chs to spaces in tag block
      else
        TagStr:=TagStr+s[i];
      CheckData;
      CheckComment;
    end
    else
    if s[i]='<' then
    begin
      InTag:=True;
      CheckData;
      CheckTag;
      CheckComment;
      TagStr:=TagStr+s[i];
    end
    else
    begin
      CheckTag;
      CheckComment;
      if s[i]=#0 then
      begin
        CheckData;
        if preserveCodeFormat then
        begin
          LinePos.row:=CurrentRow;
          LinePos.col:=CurrentCol;
          fParsedHTML.AddObject('<#CRLF>',TObject(int64(LinePos)));
        end;
      end
      else
      if s[i]=#9 then
      begin
        CheckData;
        if preserveCodeFormat then
        begin
          LinePos.row:=CurrentRow;
          LinePos.col:=CurrentCol;
          fParsedHTML.AddObject('<#TAB>',TObject(int64(LinePos)));
        end;
      end
      else
        DataStr:=Datastr+s[i];
    end;
    inc(CurrentCol);
  end;
end;
*)
procedure THTMLParser.ParseTagLines;//creates ParsedTagLines Collection (fills 1.level props only)
var
  i:integer;
  NewParsedTag:THTMLParsedTag;
  //aPosObj:THTMLLinePosObj;
  aPos:THTMLLinePos;
  row,col:dword;
  l:integer;
begin
  l:=fParsedHTML.Count-1;
  for i:=0 to fParsedHTML.Count-1 do
  begin
    if (i mod 1000)=1 then
    if assigned(document) then
      document.doProgress(sEventParsingDocument,20+trunc((i/l)*20),100);
    //aPosObj:=THTMLLinePosObj(fParsedHTML.Objects[i]);
    aPos:=THTMLLinePos(int64(fParsedHTML.Objects[i]));
    row:=aPos.row;
    col:=aPos.col;
    {if assigned(aPosObj) then
    begin
      row:=aPosObj.Row;
      col:=aPosObj.Col;
      aPosObj.Free;
    end
    else
    begin
      row:=i;
      col:=1;
    end;
    }
    NewParsedTag:=THTMLParsedTag.Create(self,fParsedHTML[i],row,col);
    NewParsedTag.init;
  end;
  if l>0 then
    document.doProgress(sEventParsingDocument,20+trunc((fParsedHTML.Count/l)*20),100);
end;
procedure THTMLParser.CalculateTagLineProps;//Fills all 2.level props of tag lines
  procedure CalculateForwards;
  var
    i:integer;
    t:THTMLTagTypes;
  begin
    for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
      fFwdTagStacks[t].clear;
    for i:=0 to ParsedTags.Count-1 do
    begin
      if ParsedTags[i].isValidTag then
      begin
        if not (ParsedTags[i].isBeginTag and ParsedTags[i].isEndTag) then
        begin
          if ParsedTags[i].isBeginTag then
            fFwdTagStacks[ParsedTags[i].TagType].Add(ParsedTags[i]);
          if ParsedTags[i].isEndTag then
            fFwdTagStacks[ParsedTags[i].TagType].Remove(ParsedTags[i]);
        end;
        //for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
        //  ParsedTags[i].fFwdStacks[t]:=fFwdTagStacks[t].Count;
      end;
    end;
  end;
  procedure CalculateRewards;
  var
    i:integer;
    t:THTMLTagTypes;
  begin
    for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
      fRwdTagStacks[t].clear;
    for i:=ParsedTags.Count-1 downto 0 do
    begin
      if ParsedTags[i].isValidTag then
      begin
        if not (ParsedTags[i].isBeginTag and ParsedTags[i].isEndTag) then
        begin
          if ParsedTags[i].isEndTag then
            fRwdTagStacks[ParsedTags[i].TagType].add(ParsedTags[i]);
          if ParsedTags[i].isBeginTag then
            fRwdTagStacks[ParsedTags[i].TagType].remove(ParsedTags[i]);
        end;
        //for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
        //  ParsedTags[i].fRwdStacks[t]:=fRwdTagStacks[ParsedTags[i].TagType].Count;
      end;
    end;
  end;
begin
  CalculateForwards;
  CalculateRewards;
end;
procedure THTMLParser.MatchTags; //Locates Begin & end tags and connects them together (fills 3.Level props)
var
  lastitem:THTMLParsedTag;
  lastitem_index:integer;
  fParentStack:THTMLParsedTagCollection;
  CurrentParent:THTMLParsedTag;
  procedure AddToStack(aTag:THTMLParsedTag);
  begin
    if assigned(currentParent) and (currentParent.TagType=aTag.TagType) and (not (currentParent.tagtype in c_HTMLValidParents[aTag.TagType])) then
    begin
      fParentStack.Remove(currentParent);
      if fParentStack.IndexOf(aTag)=-1 then
        fParentStack.Add(aTag);
      CurrentParent:=aTag;
    end
    else
    begin
      if fParentStack.IndexOf(aTag)=-1 then
        fParentStack.Add(aTag);
      CurrentParent:=aTag;
    end;
  end;
  procedure RemoveFromStack(aTag:THTMLParsedTag);
  begin
    if fParentStack.indexof(aTag)=-1 then
      fParentStack.Remove(aTag);
    fParentStack.Remove(aTag);
    if fParentStack.Count>0 then
      CurrentParent:=fParentStack[fParentStack.Count-1]
    else
      CurrentParent:=nil;
  end;
  procedure ConnectBeginEndTagPairs;
  var
    i,j,k:integer;
    t:THTMLTagTypes;
    //l:integer;
    cancel:boolean;
    newTag:THTMLParsedTag;
    aTag:THTMLParsedTag;
    function getHTMLBeginTagPos:integer;
    var i:integer;
    begin
      result:=-1;
      //for i:=ParsedTags.Count-1 downto 0 do
      for i:=0 to ParsedTags.Count-1 do
        if (ParsedTags[i].TagType=htHTML) and (ParsedTags[i].isBeginTag) then
        begin
          result:=i;
          break;
        end
    end;

    function GetHTMLEndTagPos:integer;
    var i:integer;
    begin
      result:=-1;
      //for i:=ParsedTags.Count-1 downto 0 do
      for i:=0 to ParsedTags.Count-1 do
        if (ParsedTags[i].TagType=htHTML) and (ParsedTags[i].isEndTag) then
        begin
          if result>-1 then
          begin //disable previous </html>
            ParsedTags[result].TagStr:='<!-- '+ ParsedTags[result].fTagStr + '-->';
          end;
          result:=i;
        end
    end;
  procedure ClearFromForwardStacks(aTag:THTMLParsedTag);
  var j:integer;
  begin
    for j:=0 to aTag.Childs.Count-1 do
    begin
      if aTag.Childs[j].isDoubleTag and (not aTag.Childs[j].isClosed) then
      if fFwdTagStacks[aTag.Childs[j].TagType].indexOf(aTag.Childs[j])>-1 then
        fFwdTagStacks[aTag.Childs[j].TagType].Remove(aTag.Childs[j]);
      ClearFromForwardStacks(aTag.Childs[j]);
    end;
  end;
  begin
    fParentStack:=THTMLParsedTagCollection.Create(false);
    try
      for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
        fFwdTagStacks[t].clear;
      //remove all tags before <html> construction
      k:=GetHTMLBeginTagPos;
      j:=GetHTMLEndTagPos;
      if (k=-1) and (j=-1) then // there is no html contructors!
      begin
        newTag:=THTMLParsedTag.Create(self,'<html>',0,0);
        newTag.TagIndex:=0;
        newTag:=THTMLParsedTag.Create(self,'</html>',0,0);
        newTag.TagIndex:=ParsedTags.Count-1;
      end;
      if k>0 then
      begin
        for i:=k-1 downto 0 do
          if ParsedTags[i].fTagType<>htDocType then
            ParsedTags[i].fTagType:=htComment;
      end;
      //remove all tags after </html> conclusion

      if (k=-1) and (j>0) then  //there is no <html> tag which coresponds to present </html>
      begin
        fParsedHTML.Insert(0,'<html>');
        newTag:=THTMLParsedTag.Create(self,'<html>',0,0);
        newTag.TagIndex:=0;
        inc(j);
      end;

      if j>0 then
      begin
        for i:=j+1 to ParsedTags.Count-1 do
          ParsedTags[i].fTagType:=htComment;
      end;
      //c_HTMLConstructorTags
      try
        for i:=0 to ParsedTags.Count-1 do
        begin
          if (ParsedTags[i].TagType in c_HTMLConstructorTags) and (ParsedTags[i].isBeginTag) then
          begin
            if fFwdTagStacks[ParsedTags[i].TagType].Count=0 then
              fFwdTagStacks[ParsedTags[i].TagType].Add(ParsedTags[i])
            else
              ParsedTags[i].fTagType:=htComment;
          end;
        end;
      finally
        for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
          fFwdTagStacks[t].clear;
      end;
      try
        for i:=ParsedTags.Count-1 downto 0  do
        begin
          if (ParsedTags[i].TagType in c_HTMLConstructorTags) and (ParsedTags[i].isEndTag) then
          begin
            if fFwdTagStacks[ParsedTags[i].TagType].Count=0 then
              fFwdTagStacks[ParsedTags[i].TagType].Add(ParsedTags[i])
            else
              ParsedTags[i].Tagstr:='<!--'+ ParsedTags[i].Tagstr + ' -->';
          end;
        end;
      finally
        for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
          fFwdTagStacks[t].clear;
      end;
      for t:=low(THTMLTagTypes) to high(THTMLTagTypes) do
        fFwdTagStacks[t].clear;
      {i:=ParsedTags.Count-1;
      if i>-1 then
        if isHTMLEndTagPresent then
          while (ParsedTags[i].TagType<>htHtml) and (ParsedTags[i].isEndTag) and (i>=0) do
          begin
             //ParsedTags[i].Free;
             ParsedTags[i].fTagType:=htComment;
             dec(i);
          end;
      }
      i:=0;
      CurrentParent:=nil;
      while i<ParsedTags.Count do
      begin
        //if (i mod 100)=1 then
        //if assigned(document) then
        //  document.doProgress(sEventParsingDocument,30+trunc((i/l)*10),100);
        ParsedTags[i].ParentTag:=CurrentParent;
        if not ParsedTags[i].isCodeFormatTag then
        if ParsedTags[i].isValidTag then
        begin
          if (ParsedTags[i].tagType in [htTableCol,htTH]) and ParsedTags[i].isBeginTag and (not ParsedTags[i].isParentValid) and assigned(currentParent) and (currentParent.TagType=htTable) then
          begin
            newTag:=THTMLParsedTag.Create(self,'<tr title="created by parser">',ParsedTags[i].SourceRow,ParsedTags[i].sourcecol);
            newTag.TagIndex:=ParsedTags[i].TagIndex;
            newTag.fisBeginTag:=true;
            newTag.fisEndTag:=false;
            newTag.parentTag:=CurrentParent;

            AddToStack(newTag);
          end;
          if not (ParsedTags[i].isBeginTag and ParsedTags[i].isEndTag) then
          begin
            if ParsedTags[i].isBeginTag then
            begin
              // fixing <tr><tr> problem
              if (ParsedTags[i].TagType in c_HTMLDoubleTags) and (i<ParsedTags.Count-1) and (ParsedTags[i+1].TagType=ParsedTags[i].TagType) and
                 (ParsedTags[i+1].isBeginTag) and (not (ParsedTags[i].tagType in c_HTMLValidParents[ParsedTags[i+1].tagType]))
              then
              begin
                ParsedTags[i].TagStr:='<!-- '+ParsedTags[i].TagStr+' -->';
                ParsedTags[i].fTagType:=htComment;
                inc(i);
                continue;
              end
              else
                fFwdTagStacks[ParsedTags[i].TagType].Add(ParsedTags[i]);
            end;
            if (ParsedTags[i].isEndTag) then
            begin
              lastitem:=nil;
              lastitem_index:=fFwdTagStacks[ParsedTags[i].TagType].count-1;
              if lastitem_index>-1 then
                lastitem:=fFwdTagStacks[ParsedTags[i].TagType].items[lastitem_index];
              if assigned(lastitem) then
              begin
                lastitem.EndTag:=ParsedTags[i];
                fFwdTagStacks[ParsedTags[i].TagType].Remove(lastitem);
              end
              else//bug correction #1: there is no sutiable begin tag for this type of closing tag
              begin
                //we need to create a begin tag in suitable place. suitable place is
                //this bug correcteg in BuildTree
                if not (ParsedTags[i].TagType in c_HTMLConstructorTags) then
                begin
                  cancel:=false;
                  if assigned(document) then
                    if assigned(document.onParseError) then
                      document.onParseError(ParsedTags[i],'there is no sutiable begin tag for this type of closing tag ' +ParsedTags[i].fTagCmd,0,ParsedTags[i].SourceRow, ParsedTags[i].SourceCol, Cancel);

                  //fParsedHTML.delete(i);
                  RemoveFromStack(ParsedTags[i]);
                  ParsedTags[i].Free;
                  if Cancel then abort;
                  continue;
                end;
                //raise exception.create('there is no sutiable begin tag for this type of closing tag');
              end;
            end;
          end;
          if ParsedTags[i].isDoubleTag then
          begin
            if ParsedTags[i].isBeginTag then
              AddToStack(ParsedTags[i])
            else
            begin

              //clear unclosed begin tags from  fFwdTagStacks array;
              aTag:=ParsedTags[i].BeginTag;

              if assigned(aTag) then
              begin
                RemoveFromStack(Atag);
                ClearFromForwardStacks(aTag);
                {
                for j:=0 to aTag.Childs.Count-1 do
                begin
                  if aTag.Childs[j].isDoubleTag and (not aTag.Childs[j].isClosed) then
                    fFwdTagStacks[aTag.Childs[j].TagType].Remove(aTag.Childs[j]);
                end;
                }
              end
            end;
          end;
        end;
        inc(i);
      end;
      //if assigned(document) then
      //    document.doProgress(sEventParsingDocument,30+trunc((l/l)*10),100);
    finally
      fParentStack.Free;
    end;
  end;
begin
  ConnectBeginEndTagPairs;
end;
function getCodeFormattingChar(TagType:THTMLTagTypes):string;
begin
  result:='';
  case TagType of
    htCodeFormat_LF  :  result:=#10;
    htCodeFormat_CR  :  result:=#13;
    htCodeFormat_TAB :  result:=#9;
    htCodeFormat_CRLF:  result:=#13+#10;
  end;
end;
procedure THTMLParser.BuildTree;//(fills 4.Level props)
var
  fParentStack:THTMLParsedTagCollection;
  problemId:integer;
  i,l:integer;
  pTag:THTMLParsedTag;
  lastTag:THTMLParsedTag;
  newTagStr:string;
  newTag:THTMLParsedTag;
  RecursionCount:integer;
  posToPlace:integer;
  ParentDistanceCount:integer;
  bestCount:smallint;
  dist:THTMLChildParentDistance;
  cnt:integer;
  t:integer;
  CancelParsing:boolean;
  CurrentParent:THTMLParsedTag;
  dummy:string;
  function CurrentParent_:THTMLParsedTag;
  begin
    if fParentStack.Count>0 then
      result:=fParentStack[fParentStack.Count-1]
    else
      result:=nil;
  end;
  procedure AddToStack(aTag:THTMLParsedTag);
  begin
    if fParentStack.IndexOf(aTag)=-1 then
      fParentStack.Add(aTag)
    else
      dummy:=aTag.TagStr;
    CurrentParent:=aTag;
  end;
  procedure RemoveFromStack(aTag:THTMLParsedTag);
  begin
    fParentStack.Remove(aTag);
    if fParentStack.Count>0 then
      CurrentParent:=fParentStack[fParentStack.Count-1]
    else
      CurrentParent:=nil;
  end;
  Procedure ReplaceCurrentParent(NewParent:THTMLParsedTag);
  begin
    if CurrentParent<>nil then
    begin
      if CurrentParent.isOptionalTag then
      begin
        if not CurrentParent.isClosed then
        begin
          NewParent.ParentTag:=CurrentParent.ParentTag;
          fParentStack[fParentStack.Count-1]:=NewParent;
        end
        else
        begin
          if NewParent.isEndTag then
            if assigned(NewParent.BeginTag) then
              RemoveFromStack(NewParent.BeginTag);
              //ParentStack.Remove(NewParent.BeginTag);

          NewParent.ParentTag:=CurrentParent;
          if NewParent.isBeginTag then
            AddToStack(NewParent);
            //ParentStack.Add(NewParent);
        end;
      end
      else
      if CurrentParent.isDoubleTag then
      begin
        if NewParent.isEndTag then
        begin
          if (CurrentParent.isOptionalTag) and (not CurrentParent.isClosed) then
            RemoveFromStack(CurrentParent);
            //ParentStack.Remove(CurrentParent);
          if assigned(NewParent.BeginTag) then
            RemoveFromStack(NewParent.BeginTag);
            //ParentStack.Remove(NewParent.BeginTag);
        end;
        NewParent.ParentTag:=CurrentParent;
        if NewParent.isBeginTag then
          AddToStack(NewParent);
          //ParentStack.Add(NewParent);
      end;
    end
    else
    if assigned(NewParent) then
    if (NewParent.isOptionalTag) or (NewParent.isDoubleTag) then
      AddToStack(NewParent);
      //ParentStack.Add(NewParent);
  end;
  function FindSuitableEndTagPosition(currentBlock:THTMLParsedTag;TagToClose:THTMLParsedTag):integer;
  var
    i:integer;
    parentOfCurrent:THTMLParsedTag;
    iMax:integer;
    function getEquiv(aTagType:THTMLTagTypes):THTMLTagTypeSet;
    begin
      result:=[aTagType];
      case aTagType of
        htTableCol: result:=result+[htTH];
        htTH      : result:=result+[htTableCol];
        htHead    : result:=result+[htBody,htFrameSet];
        htBody    : result:=result+[htHead];
        htFrameSet: result:=result+[htHead];
      end;
    end;
  begin
    //result:=-1;
    parentOfCurrent:=currentBlock;
    iMax:=-1;
    if assigned(currentBlock) then
    begin
      if assigned(currentBlock.EndTag) then
        iMax:=currentBlock.EndTag.TagIndex
      else
        if assigned(currentBlock) and assigned(currentBlock.ParentTag) and assigned(currentBlock.ParentTag.EndTag) then
           iMax:=currentBlock.ParentTag.EndTag.TagIndex;
    end;
    //set default to end of the block if possible;
    if assigned(currentBlock) and assigned(currentBlock.EndTag) then
      result:=currentBlock.EndTag.TagIndex
    else
    if assigned(currentBlock) and assigned(currentBlock.ParentTag) and assigned(currentBlock.ParentTag.EndTag) then
      result:=currentBlock.ParentTag.EndTag.TagIndex
    else
    begin
      //assume that TagToClose is currentBlock and walk through until next invalid tag occurance
      result:=ParsedTags.Count;
      i:=TagToClose.TagIndex+1;
      while i<ParsedTags.Count do
      begin
         if (ParsedTags[i].TagType<>htPlainText) and (ParsedTags[i].TagType<>htComment) and (not (ParsedTags[i].TagType in c_HTMLValidChilds[TagToClose.TagType]))
         and (not ParsedTags[i].isCodeFormatTag)
         then
         begin
           bestCount:=32;
           //ParentDistanceCount:=CheckForTheChildsOfGivenParent(bestCount,ParsedTags[i].TagType,dist,0,pTag.TagType);
           ParentDistanceCount:=CheckForTheChildsOfGivenParentEx(bestCount,pTag.TagType ,dist,0,ParsedTags[i].TagType);
           if ParentDistanceCount=-1 then
           begin
             result:=i;
             break;
           end
           else
           if ParsedTags[i].isClosed then//jump to end of uinvalid block!
             i:=ParsedTags[i].EndTag.TagIndex;
         end
         else
         if ParsedTags[i].isBeginTag and ParsedTags[i].isClosed then//jump to end of uinvalid block!
           i:=ParsedTags[i].EndTag.TagIndex;
        inc(i);
      end;
      exit;
    end;
    //search for next valid child start tag for currentBlock (also currentParent)
    i:=TagToClose.TagIndex+1;
    if TagToClose.isDoubleTag then
      parentOfCurrent:=TagToClose;
    while i<iMax do
    begin
       bestCount:=32;
       ParentDistanceCount:=CheckForTheChildsOfGivenParentEx(bestCount,TagToClose.TagType ,dist,0,ParsedTags[i].TagType);
       if ParentDistanceCount=1 then
       begin
         if parentOfCurrent.TagType=dist[0] then
           if ParsedTags[i].isClosed then//current tag is valid in one of child block of TagToClose so jump to end of  block!
             i:=ParsedTags[i].EndTag.TagIndex
           else
             i:=ParsedTags[i].TagIndex;
       end
       else
       if (not (ParsedTags[i].TagType in c_HTMLValidChilds[currentBlock.TagType])) and (ParsedTags[i].isClosed) then
       begin
         if ParsedTags[i].TagType in c_HTMLValidChilds[TagToClose.TagType] then
           i:=ParsedTags[i].EndTag.TagIndex
         else
         begin
           if parentOfCurrent.TagType in c_HTMLValidParents[ParsedTags[i].TagType] then
           begin
             if assigned(ParsedTags[i].BeginTag) then
               result:=ParsedTags[i].BeginTag.TagIndex
             else
               result:=ParsedTags[i].TagIndex;
             break;
           end;
         end;
       end
       else
       if TagToClose.TagType in getEquiv(ParsedTags[i].TagType) then
       begin
         result:=i;
         break;
       end;
       if not ParsedTags[i].isEndTag then
       if (ParsedTags[i].isDoubleTag) or  (ParsedTags[i].isOptionalTag) or (ParsedTags[i].isClosed) then
         parentOfCurrent:=ParsedTags[i];
       inc(i);
    end;
  end;
  procedure InsertComment(posToPlaceComment:integer;comment:string;Parent:THTMLParsedTag;ErrCode:dword);
  var commentTag:THTMLParsedTag;
  begin
      if assigned(document) then
      begin
        if assigned(document.onParseError) then
          document.onParseError(ptag,comment,ErrCode,pTag.SourceRow,pTag.SourceCol,CancelParsing);
        if not document.AddParsingErrorComments then
          exit;
      end;

      newTagStr:=format('<!-- %s -->',[comment]);
      {if posToPlaceComment<ParsedTags.Count then
        fParsedHTML.insert(posToPlaceComment,newTagStr)
      else
        fParsedHTML.add(newTagStr);}
      commentTag:=THTMLParsedTag.Create(self,newTagStr,ParsedTags.Count-1,0);
      commentTag.ParentTag:=parent;
      commentTag.TagIndex:=posToPlaceComment;

      //newTagStr:=format('<#CRLF>',[comment]);
      {if (posToPlaceComment+1)<ParsedTags.Count then
        fParsedHTML.insert(posToPlaceComment+1,newTagStr)
      else
        fParsedHTML.add(newTagStr);}
      //newTag:=THTMLParsedTag.Create(self,newTagStr,ParsedTags.Count-1,0);
      //newTag.ParentTag:=commentTag;
      //newTag.TagIndex:=posToPlaceComment+1;
  end;

  function getParentTagStr(pTag:THTMLParsedTag):string;
  begin
    if assigned(pTag.ParentTag) then
      result:= pTag.ParentTag.Tagstr
    else
      result:='<null parent>';
    result:=StringReplace(result,'<','{',[rfReplaceAll]);
    result:=StringReplace(result,'>','}',[rfReplaceAll]);

  end;
  function get_TagStr(pTag:THTMLParsedTag):string;
  begin
    result:= pTag.Tagstr;
    result:=StringReplace(result,'<','{',[rfReplaceAll]);
    result:=StringReplace(result,'>','}',[rfReplaceAll]);
  end;
  procedure ProcessDoubleTag;
  begin
    if (CurrentParent<>NIL) and (CurrentParent.isOptionalTag) and (not CurrentParent.isClosed) then
    if not (CurrentParent.TagType  in c_HTMLValidParents[pTag.TagType]) then
      RemoveFromStack(CurrentParent);
       //ParentStack.Remove(CurrentParent);
    if pTag.isEndTag then
    begin
      RemoveFromStack(pTag.BeginTag);
      //ParentStack.Remove(pTag.BeginTag);
      if CurrentParent<>nil then
      if CurrentParent.isOptionalTag then
        RemoveFromStack(CurrentParent);
        //ParentStack.Remove(CurrentParent);
    end;
    if not assigned(fTreeRoot) then
      fTreeRoot:=pTag;
    pTag.ParentTag:=CurrentParent;
    if pTag.isBeginTag then
      AddToStack(pTag);
      //ParentStack.Add(pTag);
  end;
  function GetConstructorEndTagPos(ConstructorType:THTMLTagTypes):integer;
  var i:integer;
  begin
    result:=-1;
    //for i:=ParsedTags.Count-1 downto 0 do
    for i:=0 to ParsedTags.Count-1 do
      if (ParsedTags[i].TagType=ConstructorType) and (ParsedTags[i].isEndTag) then
      begin
        if result>-1 then
        begin //disable previous one
          ParsedTags[result].TagStr:='<!-- '+ ParsedTags[result].fTagStr + '-->';
        end;
        result:=i;
      end
  end;
  function CheckIsTagClosed:boolean;
  var row:integer;
  hint:string;
  begin
    //bug correction #4 : there is no end tag for this start tag
    result:=true;
    if problemId<MAX_ALLOWED_PROBLEM_FIXES then
    if (not pTag.isClosed) then
    begin
      inc(problemId);
      hint:=format('there is no end tag for the start tag %s {#%d}',[get_TagStr(pTag),problemId]);
      InsertComment(i,hint,currentParent,ERROR_HTML_PARSING_MISSING_END_TAG);
      if (currentParent<>nil)  then
      begin //insert suitable end tag just before at end of the current block
        newTagStr:=format('</%s>',[c_HTMLTagIds[pTag.Tagtype]]);
        posToPlace:=-1;
        if pTag.TagType in c_HTMLConstructorTags then
          posToPlace:=GetConstructorEndTagPos(pTag.Tagtype);
        if posToPlace=-1 then
          posToPlace:=FindSuitableEndTagPosition(currentParent,pTag);
        if (posToPlace>-1) and (posToPlace>pTag.TagIndex) then
        begin
          //fParsedHTML.Insert(posToPlace,newTagStr);
          if assigned(currentParent.EndTag) then
            row:=currentParent.EndTag.SourceRow
          else
            row:=currentParent.SourceRow;
          newTag:=THTMLParsedTag.Create(pTag.Owner,newTagStr,row,0);
          newTag.BeginTag:=pTag;
          //newTag.ParentTag:=pTag.ParentTag;
          newTag.TagIndex:=posToPlace;
          newTag.fCodeFormattingChars:='<!-- '+hint+' -->';
          InsertComment(posToPlace+1,format('required end tag %s has been placed to solve problem #%d ',[get_TagStr(newTag),problemId]),pTag,ERROR_HTML_PARSING_MISSING_END_TAG);
          ProcessDoubleTag;
        end
        else
          raise exception.Create('Unable to calculate a position to close current block tag '+pTag.TagStr);

        //inc(i);
        //result:=false;
        //possible dead lock location
        {if RecursionCount<c_MAX_RECURSION_COUNT then
        begin
          ParentStack.clear;
          i:=0;
          MatchTags;
          inc(RecursionCount);
          result:=false;
        end;
        }
      end//current parent is nil so there is no current block
      else//append the end tag at the end of the document
      begin
        //check next availble tag in this context!
        newTagStr:=format('</%s>',[c_HTMLTagIds[pTag.Tagtype]]);
        posToPlace:=FindSuitableEndTagPosition(nil,pTag);
        if posToPlace<ParsedTags.Count then
          fParsedHTML.insert(posToPlace,newTagStr)
        else
          fParsedHTML.add(newTagStr);
        newTag:=THTMLParsedTag.Create(pTag.Owner,newTagStr,ParsedTags.Count-1,0);
        newTag.TagIndex:=posToPlace;
        newTag.BeginTag:=pTag;
        newTag.fCodeFormattingChars:=#$D+#$A+#$D+#$A+#$D+#$A;

        //newTag.ParentTag:=pTag.ParentTag;
        InsertComment(posToPlace,format(' required end tag %s has been placed to solve problem #%d',[get_TagStr(newTag),problemId]),pTag,ERROR_HTML_PARSING_MISSING_END_TAG);
        ProcessDoubleTag;
        //inc(i);
        //result:=false;
        //possible dead lock location
        {if RecursionCount<c_MAX_RECURSION_COUNT then
        begin
          ParentStack.clear;
          i:=0;
          MatchTags;
          inc(RecursionCount);
          result:=false;
        end;
        }
      end;
    end;
  end;
  function CheckIsTagBegun:boolean;
  begin
    result:=true;
    //bug correction #1:there is no begin tag for this closing tag
    if problemId<MAX_ALLOWED_PROBLEM_FIXES then
    if not pTag.isBegun then
    begin
      //we need create a begin tag of current closing tag just after the currentParent tag
      // after creation ,if new tag is a double tag, then all operation after the currentParent must be re-done by setting new tag as currentParent
      inc(problemId);
      InsertComment(i,format('there is no begin tag for the closing tag %s {#%d}',[get_TagStr(pTag),problemId]),currentParent,ERROR_HTML_PARSING_MISSING_BEGIN_TAG);

      if pTag.isDoubleTag then
      begin
        //check next tag is a valid child? else try to find an unbegun child tag

        if pTag.parentTag<>nil then
        begin
          newTagStr:=format('<%s>',[c_HTMLTagIds[pTag.TagType]]);
          pTag.Owner.fParsedHTML.Insert(currentParent.TagIndex+1,newTagStr);
          newTag:=THTMLParsedTag.Create(pTag.Owner,newTagStr,currentParent.SourceRow,currentParent.SourceCol+dword(length(currentParent.TagStr)));
          newTag.TagIndex:=currentParent.TagIndex+1;
          newTag.ParentTag:=currentParent;
          newTag.fCodeFormattingChars:='<!-- test -->';
          pTag.BeginTag:=newTag;
          InsertComment(newTag.TagIndex,format('required begin tag %s has been placed to solve problem #%d ',[get_TagStr(newTag),problemId]),newTag,ERROR_HTML_PARSING_MISSING_BEGIN_TAG);
          //possible dead lock location
          //if RecursionCount<c_MAX_RECURSION_COUNT then
          begin
            i:=currentParent.TagIndex+1;
            result:=false;
            inc(RecursionCount);
          end;
        end
        else//bug correction #2://there is no parent to create new child!
        begin
          if pTag.isEndTag then
          begin
            pTag.Free;
            fParentStack.clear;
            i:=0;
            MatchTags;
            inc(RecursionCount);
            result:=false;
            exit;
          end;
        end;
      end;
    end;
  end;
  function getFirstMathcingTagPos(tagType:THTMLTagTypes):integer;
  var i:integer;
  begin
    result:=-1;
    for i:=0 to ParsedTags.Count-1 do
    begin
      if (ParsedTags[i].TagType=tagType) and(ParsedTags[i].isBeginTag) then
      begin
        result:=i;
        break;
      end;
    end;
  end;
  function CheckIsParentValid:boolean;
  var
    comment:string;
    tagPos:integer;
    newTagPos:integer;
    j:integer;
    cnt:integer;
    currParent:THTMLParsedTag;

  begin
    //bug correction #3: current parent is invalid
    //if (pTag.isValidTag) and (not pTag.isParentValid) then
    result:=true;
    if problemId<MAX_ALLOWED_PROBLEM_FIXES then
    if (not pTag.isParentValid) then
    begin
      // very common symptom eg:
      // ...
      // <form>
      // <tr>
      // ...
      // </form>
      // </tr>
      // so simply assign <form> s parent to </form> tag and continue to build tree
      if pTag.isEndTag and pTag.isBegun then
      if assigned(pTag.BeginTag) and (pTag.BeginTag<>pTag.EndTag) then //ie not xml form , example <iframe/>
      begin
        pTag.ParentTag:=pTag.BeginTag.ParentTag;
        result:=true;
        exit;
      end;

      //Possible Causes of symptom:
      //  1) current tag placed in wrong place :ex <table><body>...
      //  2) Possible a missing requiered tag :ex <table> <!--"here must be <tr> but missing " --> <td> ...
      // Possible Solutions:
      // situation detection if Count of Hierarchic Distance to current parent = -1, means (1)
      // so exchange positions of current tag and its parent ex: before <table> ....<body> ...</table>, after <body><table>....
      // this would not solve completely bu can reduce severity of problem
      if (not assigned(pTag.ParentTag)) and (CurrentParent<>nil) then
      begin
        if (CurrentParent=pTag) and (fParentStack.Count>1) then
          pTag.ParentTag:=fParentStack[fParentStack.Count-2]
        else
          pTag.ParentTag:=CurrentParent;
        result:=CheckIsParentValid;
        exit;
      end;
      currParent:=CurrentParent;
      if currParent=pTag then
        currParent:=pTag.ParentTag;
      if ((assigned(currParent)) and (currParent.TagType in [htTableCol,htTH]) and (pTag.TagType in [htTableCol,htTH]) and (pTag.isBeginTag)) or
         ((assigned(currParent)) and (currParent.TagType in [htTableRow]) and (pTag.TagType in [htTableRow]) and (pTag.isBeginTag)) then
      begin
         //special stiuation
         //...
         //<td>
         //...
         //<we need here a /td tag >
         //<td>
         //...
         //</td> </td> <-- last </td> must be ignored
         newTagStr:=format('</%s>',[c_HTMLTagIds[pTag.tagType]]);
         newTag:=THTMLParsedTag.Create(self,newTagStr,pTag.SourceRow,pTag.SourceCol);
         newTag.TagIndex:=pTag.TagIndex;
         RemoveFromStack(pTag);
         newTag.ParentTag:=currParent;
         pTag.ParentTag:=currParent;
         fParentStack.clear;
         i:=0;
         MatchTags;
         inc(RecursionCount);
         result:=false;
         exit;
      end;
      inc(problemId);
      comment:=format('current parent %s is invalid for this tag %s {#%d}',[getParentTagStr(pTag),get_TagStr(pTag),problemId]);
      pTag.Attributes.Add(format('title="%s"',[comment]));
      InsertComment(i,comment,currentParent,ERROR_HTML_PARSING_INVALID_PARENT);
      if (pTag.isBeginTag) and (pTag.DistFromParentCount=-1) and assigned(pTag.ParentTag) and pTag.ParentTag.isClosed then
      begin
        // try previos parent to solve problem if problem persists then ignore tags
        //if assigned(pTag.ParentTag.ParentTag) then
        begin
          if pTag.isClosed then
              pTag.EndTag.ParentTag:=pTag.ParentTag.ParentTag;
          pTag.ParentTag:=pTag.ParentTag.ParentTag;
          result:=CheckIsParentValid;
          exit;
        end;
        if assigned(pTag.EndTag) and (pTag.EndTag<>pTag) then
          pTag.EndTag.Free;
        pTag.Free;
        fParentStack.clear;
        i:=0;
        MatchTags;
        inc(RecursionCount);
        result:=false;
        exit;

      end;
      // situation detection if Count of Hierarchic Distance to current parent >0  , means (2)
      //   so we need to create all tags in DistanceToParent array
      if (ptag.isBeginTag) and (pTag.DistFromParentCount>0) then
      begin
        //if pTag.DistFromParentCount>0 then
         begin
          if pTag.ParentTag<>nil then
          begin
            //newTagStr:=format('<%s>',[c_HTMLTagIds[pTag.DistanceFromParent[pTag.DistFromParentCount-1]]]);
            comment:=format('a valid parent tag %s has been added to solve problem #%d',[c_HTMLTagIds[pTag.DistanceFromParent[0]],problemId]);
            newTagStr:=format('<%s title="%s">',[c_HTMLTagIds[pTag.DistanceFromParent[0]],comment]);
            if pTag.DistanceFromParent[0] in c_HTMLConstructorTags then //ie <html>, <head>, <body>, etc..
            begin
              tagPos:=getFirstMathcingTagPos(pTag.DistanceFromParent[0]);
              if tagPos>-1 then
              begin
                if ParsedTags[tagPos].isClosed then
                  newTagPos:=ParsedTags[tagPos].EndTag.TagIndex
                else
                  newTagPos:=ParsedTags[tagPos].TagIndex;
                pTag.ParentTag:=ParsedTags[tagPos];
                if pTag.isClosed then //move block to under the suitable block
                begin
                  pTag.EndTag.ParentTag:=ParsedTags[tagPos];
                  j:=pTag.tagIndex;
                  cnt:=pTag.EndTag.TagIndex-pTag.TagIndex;
                  while Cnt>=0 do
                  begin
                    ParsedTags[j].TagIndex:=NewTagPos;
                    if j>newTagPos then
                    begin
                      inc(j);
                      inc(NewTagPos);
                    end;
                    dec(cnt);
                  end;
                end
                else  //move only single tag
                   pTag.TagIndex:=NewTagPos;
              end
              else
              begin
                pTag.Owner.fParsedHTML.Insert(pTag.TagIndex,newTagStr);
                newTag:=THTMLParsedTag.Create(pTag.Owner,newTagStr,pTag.SourceRow,0);
                newTag.ParentTag:=pTag.ParentTag;
                newTag.TagIndex:=pTag.TagIndex;
                pTag.ParentTag:=newTag;
                InsertComment(newTag.TagIndex,comment,CurrentParent,ERROR_HTML_PARSING_INVALID_PARENT);
              end;
            end
            else
            begin
              //pTag.Owner.fParsedHTML.Insert(pTag.TagIndex,newTagStr);
              newTag:=THTMLParsedTag.Create(pTag.Owner,newTagStr,pTag.SourceRow,0);
              newTag.ParentTag:=pTag.ParentTag;
              newTag.TagIndex:=pTag.TagIndex;
              pTag.ParentTag:=newTag;
              fParentStack.Insert(fParentStack.count-1,newTag);
              InsertComment(newTag.TagIndex,comment,CurrentParent,ERROR_HTML_PARSING_INVALID_PARENT);
            end;
            //inc(i);
            //possible dead lock location
            //if RecursionCount<c_MAX_RECURSION_COUNT then
            //begin
            fParentStack.clear;
            i:=0;
            MatchTags;
            inc(RecursionCount);
            result:=false;
            //end;
          end
          else
          begin
            t:=pTag.DistFromParentCount-1;
            if t<0 then // try to swap tags to solve problem
            begin
              raise exception.create(pTag.fTagStr);
            end
            else
            begin
              //newTagStr:=format('<%s>',[c_HTMLTagIds[pTag.DistanceFromParent[t]]]);
              comment:=format('a valid parent tag %s has been added to solve problem #%d',[c_HTMLTagIds[pTag.DistanceFromParent[0]],problemId]);
              newTagStr:=format('<%s title="%s">',[c_HTMLTagIds[pTag.DistanceFromParent[0]],comment]);

              if pTag.DistanceFromParent[0] in c_HTMLConstructorTags then //ie <html>, <head>, <body>, etc..
              begin
                tagPos:=getFirstMathcingTagPos(pTag.DistanceFromParent[0]);
                if tagPos>-1 then
                begin
                  if ParsedTags[tagPos].isClosed then
                    newTagPos:=ParsedTags[tagPos].EndTag.TagIndex
                  else
                    newTagPos:=ParsedTags[tagPos].TagIndex;
                  pTag.ParentTag:=ParsedTags[tagPos];
                  if pTag.isClosed then //move block in to the suitable block
                  begin
                    pTag.EndTag.ParentTag:=ParsedTags[tagPos];
                    j:=pTag.tagIndex;
                    cnt:=pTag.EndTag.TagIndex-pTag.TagIndex;
                    while Cnt>=0 do
                    begin
                      ParsedTags[j].TagIndex:=NewTagPos;
                      if j>newTagPos then
                      begin
                        inc(j);
                        inc(NewTagPos);
                      end;
                      dec(cnt);
                    end;
                  end
                  else  //move only single tag
                     pTag.TagIndex:=NewTagPos;
                end
                else
                begin
                  if pTag.DistFromParentCount>1 then
                    tagPos:=getFirstMathcingTagPos(pTag.DistanceFromParent[1])+1
                  else
                    tagPos:=0;
                  fParsedHTML.Insert(tagPos,newTagStr);
                  newTag:=THTMLParsedTag.Create(pTag.Owner,newTagStr,0,0);
                  newTag.TagIndex:=tagPos;
                  newTag.ParentTag:=nil;
                  pTag.ParentTag:=newTag;
                  if pTag.isParentValid then
                  begin
                    NewTagPos:=TagPos+1;
                    if pTag.isClosed then //move block in to the suitable block
                    begin
                      pTag.EndTag.ParentTag:=newTag;
                      j:=pTag.tagIndex;
                      cnt:=pTag.EndTag.TagIndex-pTag.TagIndex;
                      while Cnt>=0 do
                      begin
                        ParsedTags[j].TagIndex:=NewTagPos;
                        if j>newTagPos then
                        begin
                          inc(j);
                          inc(NewTagPos);
                        end;
                        dec(cnt);
                      end;
                    end
                    else  //move only single tag
                       pTag.TagIndex:=NewTagPos;
                  end;
                  InsertComment(newTag.TagIndex,comment,CurrentParent,ERROR_HTML_PARSING_INVALID_PARENT);
                end
              end
              else
              begin
                fParsedHTML.Insert(0,newTagStr);
                newTag:=THTMLParsedTag.Create(pTag.Owner,newTagStr,0,0);
                newTag.TagIndex:=0;
                newTag.ParentTag:=nil;
                pTag.ParentTag:=newTag;
                InsertComment(newTag.TagIndex,comment,CurrentParent,ERROR_HTML_PARSING_INVALID_PARENT);
              end;
              //inc(i);
            end;
            //possible dead lock location
            //if RecursionCount<c_MAX_RECURSION_COUNT then
            begin
              fParentStack.clear;
              i:=0;
              MatchTags;
              inc(RecursionCount);
              result:=false;
            end;
          end;
        end;
      end;
    end;
  end;
  function CheckIsFormatTag:boolean;
  begin
    result:=false;
    if pTag.isCodeFormatTag then
    begin
      if assigned(LastTag) then
      begin
        if LastTag.isBeginTag then
          LastTag.beginTag.CodeFormattingChars:=LastTag.beginTag.CodeFormattingChars+getCodeFormattingChar(pTag.TagType);
        if LastTag.isEndTag then
            LastTag.endTag.CodeFormattingChars:=LastTag.endTag.CodeFormattingChars+getCodeFormattingChar(pTag.TagType);
      end;
      pTag.free;
      fParsedHTML.Delete(i);
      result:=true;
    end;
  end;
  function CheckIsCommentTag:boolean;
  begin

    if pTag.TagType=htComment then
    begin
      result:=true;
      pTag.ParentTag:=CurrentParent;
      lastTag:=pTag;
      inc(i);
    end
    else
      result:=false;
  end;
begin
  fParentStack:=THTMLParsedTagCollection.Create(false);
  i:=0;
  cnt:=0;
  problemId:=0;
  l:=ParsedTags.Count*5;
  LastTag:=nil;
  //CurrentParent:=nil;
  try
    RecursionCount:=0;
    while i<ParsedTags.Count do
    begin
      inc(cnt);
      if (cnt mod 1000)=1 then
      if assigned(document) then
        document.doProgress(sEventParsingDocument+' '+inttostr(cnt)+'/'+inttostr(i),30+trunc((cnt/l)*70),100);
      if i=0 then
      begin
        fTreeRoot:=nil;
        LastTag:=nil;
        CurrentParent:=nil;
      end;

      pTag:=ParsedTags[i];
      //if CheckIsFormatTag then
      //  continue;
      if CheckIsCommentTag then
        continue;

      if (CurrentParent<>nil) and (CurrentParent.tagType=htScript) and (not ((ptag.tagtype=htScript) and ptag.isEndTag)) then
      begin
        pTag.fTagType:=htComment;
        pTag.ParentTag:=CurrentParent;
        inc(i);
        continue;
      end;
      pTag.ParentTag:=CurrentParent;

      try
        if pTag.fisOptionalTag then
        begin
          if (CurrentParent<>NIL) and (CurrentParent.isOptionalTag) and (not CurrentParent.isClosed) then
          if not (CurrentParent.TagType  in c_HTMLValidParents[pTag.TagType]) then
          begin
            RemoveFromStack(CurrentParent);
            //ParentStack.Remove(CurrentParent);
            pTag.ParentTag:=CurrentParent;
          end;

          if pTag.isEndTag and (pTag.BeginTag=CurrentParent) then // eg <option>asdasd...</option>
          if CurrentParent<>nil then
            pTag.ParentTag:=CurrentParent.ParentTag;
          if not assigned(pTag.ParentTag) then
            pTag.ParentTag:=CurrentParent;
          if not CheckIsParentValid then
            continue;
          ReplaceCurrentParent(pTag);
          if not assigned(fTreeRoot) then
            fTreeRoot:=pTag;
        end
        else
        if pTag.fisDoubleTag then
        begin
          if pTag.isClosed then
          begin
            ProcessDoubleTag;
          end
          else
          if (not pTag.isParentValid) and (pTag.ParentTag<>CurrentParent)then
            pTag.ParentTag:=CurrentParent;

          //check for possible missing tags or misplacings
          if not CheckIsParentValid then
            continue;
          if not CheckIsTagClosed then
            continue;
          if not CheckIsTagBegun then
            continue;
        end
        else
          pTag.ParentTag:=CurrentParent;

        if not CheckIsParentValid then
          continue;
      except on e:exception do
        if assigned(fOnParsingError) then
        begin
          if assigned(pTag) then
            fOnParsingError(pTag,e.message,ERROR_HTML_PARSING_UNKNOWN_EXCEPTION,pTag.SourceRow,pTag.SourceCol,CancelParsing)
          else
            fOnParsingError(nil,e.message,ERROR_HTML_PARSING_UNKNOWN_EXCEPTION,0,0,CancelParsing);
          if CancelParsing then
            raise;
        end;
      end;
      inc(i);
      lastTag:=pTag;
    end;
  finally
    fParentStack.Free;
    if assigned(document) then
    if l>0 then
        document.doProgress(sEventParsingDocument,30+trunc((l/l)*70),100);
  end;
end;
procedure THTMLParser.CheckTree;//Examines Hierarchic problems.ie examines Child-Parent Relationships
var
  i:integer;
  pTag:THTMLParsedTag;
  function TryToFindValidParenTag(WalkFrom:THTMLParsedTag):THTMLParsedTag;
  var
    CurrentTag:THTMLParsedTag;
    CurrentParent:THTMLParsedTag;
  begin
    result:=nil;
    if assigned(WalkFrom) then
    begin
      CurrentTag:=WalkFrom;
      CurrentParent:=CurrentTag.ParentTag;
      while assigned(CurrentParent) and (not (CurrentParent.TagType in c_HTMLValidParents[CurrentTag.TagType])) do
      begin
        CurrentParent:=CurrentParent.ParentTag;
      end;
      result:=CurrentParent;
    end;
  end;
begin
  for i:=0 to ParsedTags.Count-1 do
  begin
    pTag:=ParsedTags[i];
    if (pTag.isValidTag) and (not pTag.isParentValid) then
    begin
      pTag.ParentTag:=TryToFindValidParenTag(pTag);
    end;
    {if pTag.isDoubleTag then
    begin
    end;}
  end;
end;

procedure THTMLParser.CheckForMissingTags; //Fixes Unclosed or Unbegun tag problems
begin
end;
procedure THTMLParser.CheckMinRequirements; //Examines that all the main html tags exist in document. ie HTML, HEAD BODY, etc
  procedure CheckForHTMLBeginTag;
  begin
  end;
  procedure CheckForHTMLEndTag;
  begin
  end;
  procedure CheckForHeadBeginTag;
  begin
    //next tag of htmlbegin must be head begin
  end;
  procedure CheckForBaseTag;
  var
    i,k:integer;
    solved:boolean;
    baseTag:THTMLParsedTag;
  begin
    solved:=false;
    if assigned(TreeRoot) then
    begin
      //Tree Root must be <html> tag;
      for i:=0 to TreeRoot.Childs.Count-1 do
      begin
        if TreeRoot.Childs[i].TagType=htHead then
        begin
          for k:=0 to TreeRoot.Childs[i].childs.Count-1 do
            if TreeRoot.Childs[i].childs[k].Tagtype=htbase then
            begin
              solved:=true;
              break;
            end;
          if not solved then
          begin
            fParsedHTML.insert(TreeRoot.Childs[i].tagIndex+1,'<base>');
            baseTag:=THTMLParsedTag.create(self,'<base>',TreeRoot.Childs[i].tagIndex+1,0);
            baseTag.ParentTag:=TreeRoot.Childs[i];
            baseTag.TagIndex:=TreeRoot.Childs[i].tagIndex+1;
            solved:=true;
          end;
          break;
        end;
      end;
      if not solved then
      begin
        fParsedHTML.insert(TreeRoot.tagIndex+1,'<base>');
        baseTag:=THTMLParsedTag.create(self,'<base>',TreeRoot.tagIndex+1,0);
        baseTag.ParentTag:=TreeRoot;
        baseTag.TagIndex:=TreeRoot.tagIndex+1;
        BuildTree;//Rebuild Tree to add head tags
        //solved:=true;
      end;
    end
    else//empty document
    begin
    end;
  end;
begin
  //html begin
  CheckForHTMLBeginTag;
  //html end
  CheckForHTMLEndTag;
  //head begin
  CheckForHeadBeginTag;
  //base
  CheckForBaseTag;
  //head end

  //body begin
  //body end
end;
function  THTMLParser.getParsedHTMLSource:string;//Returns Parsed & Fixed HTML Code
var
  i:integer;
begin
  result:='';
  for i:=0 to ParsedTags.Count-1 do
   result:=result+ParsedTags[i].TagStr+#$D+#$A;
end;
procedure THTMLParser.CreateElements(Document:THTMLDocument);
var
  i:integer;
  //newElement:THTMLElement;
  cancel:boolean;
begin
  cancel:=false;
  StartTimer;
  if not assigned(Document) then
    raise exception.create('There is no document to create elements');
  for i:=0 to ParsedTags.Count-1 do
  begin
    try
      if (i mod 500)=1 then
        Document.doProgress(sEventBuildingDocument,i,ParsedTags.Count);
      if not ParsedTags[i].isCodeFormatTag then
      if not assigned(ParsedTags[i].ParentTag) then
        ParsedTags[i].CreateElement(Document,Document)
       //newElement:=ParsedTags[i].CreateElement(Document,Document)
    except on e:exception do
      if assigned(document) then
        if assigned(document.fonParseError) then
        begin
          document.fonParseError(ParsedTags[i],e.Message,0,0,0,cancel);
          if cancel then raise;
        end;
    end;
  end;
  AddToReport('DOM Element Creation');
  Document.doProgress(sEventBuildingDocument,ParsedTags.Count,ParsedTags.Count);
end;
procedure THTMLParser.StartTimer;
begin
  bTime:=Time;
end;
procedure THTMLParser.AddToReport(s:string);
var
  diff:dword;
  started,ended:dword;
  hour,min,sec,msec:word;
  cancel:boolean;
begin
  eTime:=Time;
  DecodeTime(bTime,hour,min,sec,msec);
  started:=msec+(sec*1000)+(min*60*1000)+(hour*60*60*1000);
  DecodeTime(eTime,hour,min,sec,msec);
  ended:=msec+(sec*1000)+(min*60*1000)+(hour*60*60*1000);
  diff:=ended-started;
  if assigned(Document) then
    if assigned(document.fonParseError) then
      document.fonParseError(nil,s+' : '+inttostr(diff)+' msec(s)',0,0,0,cancel);
end;
{THMTLStyle}
constructor THTMLStyle.Create(AOwnerElement:THTMLElement);
begin
  inherited Create;
  fOwnerElement:=AOwnerElement;
end;

function  THTMLStyle.getAttributeCount:integer;
begin
  result:=fAttributes.Count;
end;

function  THTMLStyle.getStringAttrByName(AttrName:string):string;
begin
  result:=fAttributes.Values[AttrName];
end;

procedure THTMLStyle.setStringAttrByName(AttrName, AttrValue:string);
var
  i:integer;
  found:boolean;
begin
  found:=false;
  for i:=0 to fAttributes.Count-1 do
  begin
    if CompareText(fAttributes.Names[i],AttrName)=0 then
    begin
      found:=true;
      fAttributes[i]:=format('%s=%s',[AttrName,AttrValue]);
      break;
    end;
  end;
  if not found then
    fAttributes.Add(format('%s=%s',[AttrName,AttrValue]));
end;

function  THTMLStyle.getStringAttrByIndex(index:integer):string;
begin
  result:=fAttributes.Values[fAttributes.Names[index]];
end;

procedure THTMLStyle.setStringAttrByIndex(index:integer; AttrValue:string);
begin
  fAttributes[index]:=format('%s=%s',[fAttributes.Names[index],AttrValue]);
end;


function  THTMLStyle.getIntegerAttr(AttrName:String):Integer;
var s:string;
begin
  s:=AttributeByName[AttrName];
  if not TryStrToInt(s,result) then
    result:=0;
end;

procedure THTMLStyle.setIntegerAttr(AttrName:String; AttrValue:Integer);
begin
  AttributeByName[AttrName]:=inttostr(AttrValue);
end;

function  THTMLStyle.getBooleanAttr(AttrName:String):Boolean;
var s:string;
begin
  s:=AttributeByName[AttrName];
  result:=(CompareText(s,'true')=0);
end;

procedure THTMLStyle.setBooleanAttr(AttrName:String; AttrValue:Boolean);
begin
  if AttrValue then AttributeByName[AttrName]:='true'
  else AttributeByName[AttrName]:='false';
end;

procedure THTMLStyle.ParseStyleHTML;
var s:string;
begin
  s:=StringReplace(fStyleHTML,';',#$D+#$A,[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s         ,':','=',[rfReplaceAll, rfIgnoreCase]);
  fAttributes.Text:=s;
end;

function THTMLStyle.getStyleText:string;
var
  i:integer;
  s:string;
begin
  s:='';
  for i:=0 to AttributeCount-1 do
  begin
    s:=s+' '+fAttributes.Names[i]+' : '+ AttributeByIndex[i]+';';
  end;
  fStyleHTML:=s;
  result:=s;
end;

procedure THTMLStyle.setStyleText(NewStyleText:string);
begin
  fStyleHTML:=NewStyleText;
  ParseStyleHTML;
end;

{*************** Font and Text Properties ***********************}

procedure THTMLStyle.Set_fontFamily(const p: String);
begin
  { font-family: [[ family-name | generic-family ] , ]* [ family-name | generic-family ]}
  AttributeByName['font-family']:=p;
end;
function  THTMLStyle.Get_fontFamily: String;
begin
  result:=AttributeByName['font-family'];
end;

procedure THTMLStyle.Set_fontStyle(const p: String);
begin
  { font-style: normal | italic | oblique}
  AttributeByName['font-style']:=p;
end;
function  THTMLStyle.Get_fontStyle: String;
begin
  result:=AttributeByName['font-style'];
end;


procedure THTMLStyle.Set_fontVariant(const p: String);
begin
  { font-variant: normal | small-caps}
  AttributeByName['font-variant']:=p;
end;
function  THTMLStyle.Get_fontVariant: String;
begin
  result:=AttributeByName['font-variant'];
end;

procedure THTMLStyle.Set_fontWeight(const p: String);
begin
  { font-weight: normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900}
  AttributeByName['font-weight']:=p;
end;
function  THTMLStyle.Get_fontWeight: String;
begin
  result:=AttributeByName['font-weight'];
end;

procedure THTMLStyle.Set_fontSize(p: String);
begin
  { font-size: absolute-size | relative-size | length | percentage |}
  AttributeByName['font-size']:=p;
end;
function  THTMLStyle.Get_fontSize: String;
begin
  result:=AttributeByName['font-size'];
end;

procedure THTMLStyle.Set_font(const p: String);
begin
  { font: [ font-style || font-variant || font-weight ] font-size [ line-height ] font-family}
  //  Defines the separate font attributes (font-style, font-variant, font-weight, font-size, line-height,
  //  and font-family).
  // ex: SPAN {font: 24 'Comic Sans MS'}
  AttributeByName['font']:=p;
end;
function  THTMLStyle.Get_font: String;
begin
  result:=AttributeByName['font'];
end;

{********* Color and Background Properties *****************}

procedure THTMLStyle.Set_color(p: string);
begin
(*
  { color: color}
  EM { color: red }              /* natural language / CNS */
  EM { color: #F00 }             /* #RGB */
  EM { color: #FF0000 }          /* #RRGGBB */
  EM { color: rgb 1.0 0.0 0.0 }  /* float range: 0.0 - 1.0 */
*)
  AttributeByName['color']:=p;
end;
function  THTMLStyle.Get_color: string;
begin
  result:=AttributeByName['color'];
end;

procedure THTMLStyle.Set_background(const p: String);
var sList:TStringList;
begin
  //Sets all background attributes (image, attachment, color, repeat, position) for an element at once
  // for ex:  BODY {background: blue url(sample.gif) fixed}
  { background: background-color || background-image || background-repeat || background-attachment ||
    background-position}

  sList:=TStringList.Create;
  try
    sList.Text:=TrimLeft(TrimRight(StringReplace(p, ' ', #$d+#$a, [rfReplaceAll, rfIgnoreCase])));
    if sList.Count>0 then backgroundColor      := sList[0];
    if sList.Count>1 then backgroundImage      := sList[1];
    if sList.Count>2 then backgroundRepeat     := sList[2];
    if sList.Count>3 then backgroundAttachment := sList[3];
    if sList.Count>4 then backgroundPosition   := sList[4];
  finally
    sList.free;
  end;
end;
function  THTMLStyle.Get_background: String;
begin
    result:= '';
    result:= result + backgroundColor      +' ';
    result:= result + backgroundImage      +' ';
    result:= result + backgroundRepeat     +' ';
    result:= result + backgroundAttachment +' ';
    result:= result + backgroundPosition;
    result:=trimleft(trimright(result));
end;

procedure THTMLStyle.Set_backgroundColor(p: String);
begin
  { background-color: color | transparent}
  AttributeByName['background-color']:=p;
end;
function  THTMLStyle.Get_backgroundColor: String;
begin
  result:=AttributeByName['background-color'];
end;

procedure THTMLStyle.Set_backgroundImage(const p: String);
begin
  { background-image: url(...) | none}
  AttributeByName['background-image']:=p;
end;
function  THTMLStyle.Get_backgroundImage: String;
begin
  result:=AttributeByName['background-image'];
end;

procedure THTMLStyle.Set_backgroundRepeat(const p: String);
begin
  { background-repeat: repeat | repeat-x | repeat-y | no-repeat}
  AttributeByName['background-repeat']:=p;
end;
function  THTMLStyle.Get_backgroundRepeat: String;
begin
  result:=AttributeByName['background-repeat'];
end;

procedure THTMLStyle.Set_backgroundAttachment(const p: String);
begin
  { background-attachment: scroll | fixed}
  AttributeByName['background-attachment']:=p;
end;
function  THTMLStyle.Get_backgroundAttachment: String;
begin
  result:=AttributeByName['background-attachment'];
end;

procedure THTMLStyle.Set_backgroundPosition(const p: String);

begin
  { background-position: [percentage | length](1,2) | [top | center | bottom] || [left | center | right]}
  AttributeByName['background-position']:=p;
end;
function  THTMLStyle.Get_backgroundPosition: String;
begin
  result:=AttributeByName['background-position'];
end;

procedure THTMLStyle.Set_backgroundPositionX(p: String);
begin
  { background-position: [percentage | length](1,2) | [top | center | bottom] || [left | center | right]}
  AttributeByName['background-position']:=p +' ' +backgroundPositionY;
end;
function  THTMLStyle.Get_backgroundPositionX: String;
var
  sList:TStringList;
  s:string;
begin
  result:='default';
  s:=AttributeByName['background-position'];
  sList:=TStringList.Create;
  try
    sList.Text:=TrimLeft(TrimRight(StringReplace(s, ' ', #$d+#$a, [rfReplaceAll, rfIgnoreCase])));
    if sList.Count>0 then result := sList[0];
  finally
    sList.free;
  end;
end;

procedure THTMLStyle.Set_backgroundPositionY(p: String);
begin
 AttributeByName['background-position']:=backgroundPositionX + ' '+ p;
end;
function  THTMLStyle.Get_backgroundPositionY: String;
var
  sList:TStringList;
  s:string;
begin
  result:='default';
  s:=AttributeByName['background-position'];
  sList:=TStringList.Create;
  try
    sList.Text:=TrimLeft(TrimRight(StringReplace(s, ' ', #$d+#$a, [rfReplaceAll, rfIgnoreCase])));
    if sList.Count>1 then result := sList[1];
  finally
    sList.free;
  end;
end;

procedure THTMLStyle.Set_wordSpacing(p: String);
begin
  AttributeByName['word-spacing']:=p;
end;
function  THTMLStyle.Get_wordSpacing: String;
begin
  result:=AttributeByName['word-spacing'];
end;

procedure THTMLStyle.Set_letterSpacing(p: String);
begin
  AttributeByName['letter-spacing']:=p;
end;
function  THTMLStyle.Get_letterSpacing: String;
begin
  result:=AttributeByName['letter-spacing'];
end;

procedure THTMLStyle.Set_textDecoration(const p: String);
begin
  { text-decoration: none | [ underline || overline || line-through || blink]}
  AttributeByName['text-decoration']:=p;
end;
function  THTMLStyle.Get_textDecoration: String;
begin
  result:=AttributeByName['text-decoration'];
end;

procedure THTMLStyle.Set_textDecorationNone(p: Boolean);
begin
  if p then
    AttributeByName['text-decoration'] := 'none';
end;
function  THTMLStyle.Get_textDecorationNone: Boolean;
var s:string;
begin
  s:=AttributeByName['text-decoration'];
  result:=(CompareText('none',s)=0) or (s='');
end;

procedure THTMLStyle.Set_textDecorationUnderline(p: Boolean);
begin
  if p then
    AttributeByName['text-decoration'] := 'underline';
end;
function  THTMLStyle.Get_textDecorationUnderline: Boolean;
var s:string;
begin
  s:=AttributeByName['text-decoration'];
  result:=(CompareText('underline',s)=0);
end;

procedure THTMLStyle.Set_textDecorationOverline(p: Boolean);
begin
  if p then
    AttributeByName['text-decoration'] := 'overline';
end;
function  THTMLStyle.Get_textDecorationOverline: Boolean;
var s:string;
begin
  s:=AttributeByName['text-decoration'];
  result:=(CompareText('overline',s)=0);
end;

procedure THTMLStyle.Set_textDecorationLineThrough(p: Boolean);
begin
  if p then
    AttributeByName['text-decoration'] := 'line-through';
end;
function  THTMLStyle.Get_textDecorationLineThrough: Boolean;
var s:string;
begin
  s:=AttributeByName['text-decoration'];
  result:=(CompareText('line-through',s)=0);
end;

procedure THTMLStyle.Set_textDecorationBlink(p: Boolean);
begin
  if p then
    AttributeByName['text-decoration'] := 'blink';
end;
function  THTMLStyle.Get_textDecorationBlink: Boolean;
var s:string;
begin
  s:=AttributeByName['text-decoration'];
  result:=(CompareText('blink',s)=0);
end;

procedure THTMLStyle.Set_verticalAlign(p: String);
begin
  { vertical-align: sub | super }
  AttributeByName['vertical-align'] := p;
end;
function  THTMLStyle.Get_verticalAlign: String;
begin
  result:=AttributeByName['vertical-align'];
end;

procedure THTMLStyle.Set_textTransform(const p: String);
begin
  { text-transform: capitalize | uppercase | lowercase | none}
  AttributeByName['text-transform'] := p;
end;
function  THTMLStyle.Get_textTransform: String;
begin
  result:=AttributeByName['text-transform'];
end;

procedure THTMLStyle.Set_textAlign(const p: String);
begin
  { text-align: left | right | center | justify}
  AttributeByName['text-align'] := p;
end;
function  THTMLStyle.Get_textAlign: String;
begin
  result:=AttributeByName['text-align'];
end;

procedure THTMLStyle.Set_textIndent(p: String);
begin
  { text-indent: length | percentage}
  AttributeByName['text-indent'] := p;
end;
function  THTMLStyle.Get_textIndent: String;
begin
  result:=AttributeByName['text-indent'];
end;

procedure THTMLStyle.Set_lineHeight(p: String);
begin
  { line-height: normal | number | length | percentage}
  AttributeByName['line-height'] := p;
end;
function  THTMLStyle.Get_lineHeight: String;
begin
  result:=AttributeByName['line-height'];
end;

{******* Layout Properties ************}
procedure THTMLStyle.Set_marginTop(p: String);
begin
  { margin-top: [ length | percentage | auto]}
  AttributeByName['margin-top'] := p;
end;
function  THTMLStyle.Get_marginTop: String;
begin
  result:=AttributeByName['margin-top'];
end;

procedure THTMLStyle.Set_marginRight(p: String);
begin
  { margin-right: [ length | percentage | auto]}
  AttributeByName['margin-right'] := p;
end;
function  THTMLStyle.Get_marginRight: String;
begin
  result:=AttributeByName['margin-right'];
end;

procedure THTMLStyle.Set_marginBottom(p: String);
begin
  { margin-bottom: [ length | percentage | auto]}
  AttributeByName['margin-bottom'] := p;
end;
function  THTMLStyle.Get_marginBottom: String;
begin
  result:=AttributeByName['margin-bottom'];
end;

procedure THTMLStyle.Set_marginLeft(p: String);
begin
  { margin-left: [ length | percentage | auto]}
  AttributeByName['margin-left'] := p;
end;
function  THTMLStyle.Get_marginLeft: String;
begin
  result:=AttributeByName['margin-left'];
end;

procedure THTMLStyle.Set_margin(const p: String);
begin
  { margin: [ length | percentage | auto] (1,4)}
  //  Sets the margin on all four sides of an object with a single style sheet rule.
  AttributeByName['margin'] := p;
end;
function  THTMLStyle.Get_margin: String;
begin
  result:=AttributeByName['margin'];
end;

procedure THTMLStyle.Set_paddingTop(p: String);
begin
  { padding-top: length | percentage}
  //  Sets the top padding of an element. Padding values cannot be negative.
  //  Supported on block and replaced elements only.
  AttributeByName['padding-top'] := p;
end;
function  THTMLStyle.Get_paddingTop: String;
begin
  result:=AttributeByName['padding-top'];
end;

procedure THTMLStyle.Set_paddingRight(p: String);
begin
  { padding-right: length | percentage}
  //  Sets the right padding of an element. Padding values cannot be negative.
  //  Supported on block and replaced elements only.
  AttributeByName['padding-right'] := p;
end;
function  THTMLStyle.Get_paddingRight: String;
begin
  result:=AttributeByName['padding-right'];
end;

procedure THTMLStyle.Set_paddingBottom(p: String);
begin
  { padding-bottom: length | percentage}
  //  Sets the bottom padding of an element. Padding values cannot be negative.
  //  Supported on block and replaced elements only.
  AttributeByName['padding-bottom'] := p;
end;
function  THTMLStyle.Get_paddingBottom: String;
begin
  result:=AttributeByName['padding-bottom'];
end;

procedure THTMLStyle.Set_paddingLeft(p: String);
begin
  { padding-left: length | percentage}
  //  Sets the left padding of an element. Padding values cannot be negative.
  //  Supported on block and replaced elements only.
  AttributeByName['padding-left'] := p;
end;
function  THTMLStyle.Get_paddingLeft: String;
begin
  result:=AttributeByName['padding-left'];
end;

procedure THTMLStyle.Set_padding(const p: String);
begin
   { padding: [ length | percentage ] (1,4)}
   //  Specifies the padding-top, padding-bottom, padding-left, and padding-right in one style sheet rule.
   //  Padding describes how much space to insert between the element and its margin, or if there is a border,
   //  between the element and its border.

   //  Remarks:
   //  This is a composite property. The "{1,4}" means that up to four values can be specified.
   //  The order is top, right, bottom, left. If there is only one value specified,
   //  it applies to all sides; if there are two or three, the missing values are taken from the opposite side.
   //  Negative values are not allowed. This property is supported on block and replaced elements only.

   (* Code need to be developed according to remarks! *)

   AttributeByName['padding'] := p;
end;
function  THTMLStyle.Get_padding: String;
begin
  result:=AttributeByName['padding'];
end;

procedure THTMLStyle.Set_border(const p: String);
begin
  { border: border-width || border-style || color}
  // ex: {border: 20px inset blue}
  AttributeByName['border'] := p;
end;
function  THTMLStyle.Get_border: String;
begin
  result:=AttributeByName['border'];
end;

procedure THTMLStyle.Set_borderTop(const p: String);
begin
end;

function  THTMLStyle.Get_borderTop: String;
begin
end;

procedure THTMLStyle.Set_borderRight(const p: String);
begin
end;

function  THTMLStyle.Get_borderRight: String;
begin
end;

procedure THTMLStyle.Set_borderBottom(const p: String);
begin
end;

function  THTMLStyle.Get_borderBottom: String;
begin
end;

procedure THTMLStyle.Set_borderLeft(const p: String);
begin
end;

function  THTMLStyle.Get_borderLeft: String;
begin
end;

procedure THTMLStyle.Set_borderColor(const p: String);
begin
end;

function  THTMLStyle.Get_borderColor: String;
begin
end;

procedure THTMLStyle.Set_borderTopColor(p: String);
begin
end;

function  THTMLStyle.Get_borderTopColor: String;
begin
end;

procedure THTMLStyle.Set_borderRightColor(p: String);
begin
end;

function  THTMLStyle.Get_borderRightColor: String;
begin
end;

procedure THTMLStyle.Set_borderBottomColor(p: String);
begin
end;

function  THTMLStyle.Get_borderBottomColor: String;
begin
end;

procedure THTMLStyle.Set_borderLeftColor(p: String);
begin
end;

function  THTMLStyle.Get_borderLeftColor: String;
begin
end;

procedure THTMLStyle.Set_borderWidth(const p: String);
begin
end;

function  THTMLStyle.Get_borderWidth: String;
begin
end;

procedure THTMLStyle.Set_borderTopWidth(p: String);
begin
end;

function  THTMLStyle.Get_borderTopWidth: String;
begin
end;

procedure THTMLStyle.Set_borderRightWidth(p: String);
begin
end;

function  THTMLStyle.Get_borderRightWidth: String;
begin
end;

procedure THTMLStyle.Set_borderBottomWidth(p: String);
begin
end;

function  THTMLStyle.Get_borderBottomWidth: String;
begin
end;

procedure THTMLStyle.Set_borderLeftWidth(p: String);
begin
end;

function  THTMLStyle.Get_borderLeftWidth: String;
begin
end;

procedure THTMLStyle.Set_borderStyle(const p: String);
begin
end;

function  THTMLStyle.Get_borderStyle: String;
begin
end;

procedure THTMLStyle.Set_borderTopStyle(const p: String);
begin
end;

function  THTMLStyle.Get_borderTopStyle: String;
begin
end;

procedure THTMLStyle.Set_borderRightStyle(const p: String);
begin
end;

function  THTMLStyle.Get_borderRightStyle: String;
begin
end;

procedure THTMLStyle.Set_borderBottomStyle(const p: String);
begin
end;

function  THTMLStyle.Get_borderBottomStyle: String;
begin
end;

procedure THTMLStyle.Set_borderLeftStyle(const p: String);
begin
end;

function  THTMLStyle.Get_borderLeftStyle: String;
begin
end;

procedure THTMLStyle.Set_width(p: String);
begin
end;

function  THTMLStyle.Get_width: String;
begin
end;

procedure THTMLStyle.Set_height(p: String);
begin
end;

function  THTMLStyle.Get_height: String;
begin
end;

procedure THTMLStyle.Set_styleFloat(const p: String);
begin
end;

function  THTMLStyle.Get_styleFloat: String;
begin
end;

procedure THTMLStyle.Set_clear(const p: String);
begin
end;

function  THTMLStyle.Get_clear: String;
begin
end;

procedure THTMLStyle.Set_display(const p: String);
begin
end;

function  THTMLStyle.Get_display: String;
begin
end;

procedure THTMLStyle.Set_visibility(const p: String);
begin
end;

function  THTMLStyle.Get_visibility: String;
begin
end;

procedure THTMLStyle.Set_listStyleType(const p: String);
begin
end;

function  THTMLStyle.Get_listStyleType: String;
begin
end;

procedure THTMLStyle.Set_listStylePosition(const p: String);
begin
end;

function  THTMLStyle.Get_listStylePosition: String;
begin
end;

procedure THTMLStyle.Set_listStyleImage(const p: String);
begin
end;

function  THTMLStyle.Get_listStyleImage: String;
begin
end;

procedure THTMLStyle.Set_listStyle(const p: String);
begin
end;

function  THTMLStyle.Get_listStyle: String;
begin
end;

procedure THTMLStyle.Set_whiteSpace(const p: String);
begin
end;

function  THTMLStyle.Get_whiteSpace: String;
begin
end;

procedure THTMLStyle.Set_top(p: String);
begin
end;

function  THTMLStyle.Get_top: String;
begin
end;

procedure THTMLStyle.Set_left(p: String);
begin
end;

function  THTMLStyle.Get_left: String;
begin
end;

function  THTMLStyle.Get_position: String;
begin
end;

procedure THTMLStyle.Set_zIndex(p: String);
begin
end;

function  THTMLStyle.Get_zIndex: String;
begin
end;

procedure THTMLStyle.Set_overflow(const p: String);
begin
end;

function  THTMLStyle.Get_overflow: String;
begin
end;

procedure THTMLStyle.Set_pageBreakBefore(const p: String);
begin
end;

function  THTMLStyle.Get_pageBreakBefore: String;
begin
end;

procedure THTMLStyle.Set_pageBreakAfter(const p: String);
begin
end;

function  THTMLStyle.Get_pageBreakAfter: String;
begin
end;

procedure THTMLStyle.Set_cssText(const p: String);
begin
end;

function  THTMLStyle.Get_cssText: String;
begin
end;

procedure THTMLStyle.Set_pixelTop(p: Integer);
begin
end;

function  THTMLStyle.Get_pixelTop: Integer;
begin
  result:=strtoint(AttributeByName['pixel-top']);
end;

procedure THTMLStyle.Set_pixelLeft(p: Integer);
begin
  AttributeByName['pixel-top']:=inttostr(p);
end;

function  THTMLStyle.Get_pixelLeft: Integer;
begin
  result:=strtoint(AttributeByName['pixel-left']);
end;

procedure THTMLStyle.Set_pixelWidth(p: Integer);
begin
end;

function  THTMLStyle.Get_pixelWidth: Integer;
begin
    result:=strtoint(AttributeByName['pixel-width']);
end;


procedure THTMLStyle.Set_pixelHeight(p: Integer);
begin
end;

function  THTMLStyle.Get_pixelHeight: Integer;
begin
    result:=strtoint(AttributeByName['pixel-height']);
end;

procedure THTMLStyle.Set_posTop(p: Single);
begin
end;

function  THTMLStyle.Get_posTop: Single;
begin
    result:=strtoint(AttributeByName['pos-top']);
end;

procedure THTMLStyle.Set_posLeft(p: Single);
begin
end;

function  THTMLStyle.Get_posLeft: Single;
begin
      result:=strtoint(AttributeByName['pos-left']);
end;

procedure THTMLStyle.Set_posWidth(p: Single);
begin
end;

function  THTMLStyle.Get_posWidth: Single;
begin
      result:=strtoint(AttributeByName['pos-width']);
end;

procedure THTMLStyle.Set_posHeight(p: Single);
begin
end;

function  THTMLStyle.Get_posHeight: Single;
begin
      result:=strtoint(AttributeByName['pos-height']);
end;

procedure THTMLStyle.Set_cursor(const p: String);
begin
end;

function  THTMLStyle.Get_cursor: String;
begin
end;

procedure THTMLStyle.Set_clip(const p: String);
begin
end;

function  THTMLStyle.Get_clip: String;
begin
end;

procedure THTMLStyle.Set_filter(const p: String);
begin
end;

function  THTMLStyle.Get_filter: String;
begin
end;


{THTMLDOMNode}
procedure THTMLDOMNode.SetTagStr(NewTagStr:string);
begin
 fTagstr:=NewTagStr;
 //ExtractPropValues;
end;

constructor THTMLDOMNode.Create(aDocument:THTMLDocument;OwnerCollection: THTMLElementCollection);
begin
  inherited Create;
  fDocument:=aDocument;
  FChildElementCollection :=THTMLElementCollection.Create(self); ///only direct childs
  FAllElementCollection   :=THTMLElementCollection.Create(self);//all nodes in inner html
  FParentElementCollection:=OwnerCollection;
  //if assigned(Document) and (Document<>self) then
  //  Document.All.InsertItem(self);
  {if assigned(Owner)  then
  begin
    Owner.InsertItem(self);
  end;
  }
  if assigned(parentNode) then
    parentNode.AddChildNode(self);
end;
destructor  THTMLDOMNode.Destroy;
begin
  //if assigned(Document) and (Document<>self) then
  //  Document.All.RemoveItem(self);
  {if assigned(Owner) then
  begin
    Owner.RemoveItem(self);
  end;
  }
  if assigned(parentNode) then
    parentNode.RemoveChildNode(self);
  FChildElementCollection.Free;
  All.Clear(false);
  {if assigned(ParentNode) then
   All.Clear(false)
  else
    All.Clear(True);
  }
  FAllElementCollection.Free;
  inherited Destroy;
end;

function  THTMLDOMNode.GetIndex: Integer;
begin
  result:=Owner.IndexOf(self);
end;
procedure THTMLDOMNode.Changed(AllItems: Boolean);
begin
end;
function  THTMLDOMNode.GetOwner: TPersistent;
begin
  result:=nil;
end;

function  THTMLDOMNode.GetDisplayName: string;
begin
  result:='Node_'+inttostr(Index);
end;
function  THTMLDOMNode.getParentNode:THTMLDomNode;
begin
  result:=nil;
  if assigned(Owner) then
    result:=Owner.OwnerNode;
end;
procedure THTMLDOMNode.setParentNode(NewParent:THTMLDOMNode);
begin
  if assigned(parentNode) then
    parentNode.RemoveChildNode(self);
  Owner:=nil;
  if assigned(NewParent) then
  begin
    Owner:=NewParent.Childs;
    ParentNode.AddChildNode(self);
  end;
end;
procedure THTMLDOMNode.SetParentElementCollection(Value: THTMLElementCollection);
begin
  FParentElementCollection:=Value;
  if assigned(Value) then
    Value.InsertItem(self);
end;
procedure THTMLDOMNode.SetIndex(Value: Integer);
begin
  raise Exception.create(format(sExceptionNotImplemented,['setIndex','THTMLDomNode']));
end;
procedure THTMLDOMNode.SetDisplayName(const Value: string);
begin
  raise Exception.create(format(sExceptionNotImplemented,['setDisplayName','THTMLDomNode']));
end;
procedure THTMLDOMNode.AddToAllArray(itemToAdd:THTMLDomNode);
begin
  All.InsertItem(itemToAdd);
  if assigned(ParentNode) then
    ParentNode.AddToAllArray(itemToAdd);
end;
procedure THTMLDOMNode.RemoveFromAllArray(itemToRemove:THTMLDomNode);
begin
  All.RemoveItem(itemToRemove);
  if assigned(ParentNode) then
    ParentNode.RemoveFromAllArray(itemToRemove);
end;
function  THTMLDOMNode.AddChildNode(aChildNode:THTMLDOMNode):integer;//adds a child node to childs and all array of this and returns its position in childs array
begin
  result:=childs.InsertItem(aChildNode);
  AddToAllArray(aChildNode);
end;
procedure THTMLDOMNode.RemoveChildNode(aChildNode:THTMLDOMNode);// removes given child from childs and all array
begin
  childs.RemoveItem(aChildNode);
  RemoveFromAllArray(aChildNode);
end;

function  THTMLDOMNode.GetNamePath: string;
begin
  //sExceptionNotImplemented    = '%s not yet implemented in %s class';
  raise Exception.create(format(sExceptionNotImplemented,['GetNamePath','THTMLDomNode']));
end;
function  THTMLDOMNode.getDocument:THTMLDocument;
begin
  if self is THTMLDocument then
    result:=THTMLDocument(self)
  else
  result:=fDocument;
end;

procedure THTMLDOMNode.setDocument(aDocument:THTMLDocument);
begin
  fDocument:=aDocument;
end;
function THTMLDOMNode.getChildCount:integer;
begin
  result:=Childs.Count;
end;

{THTMLElement}
constructor THTMLElement.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited Create (OwnerDocument,OwnerCollection);
  NeedToParseInnerHTML:=true;//set default to parse
  Props:=TStringList.Create;
  fParsedInnerHTML:=TStringList.Create;
  fStyle:=THTMLStyle.Create(self);

end;
destructor THTMLElement.destroy;
begin
  props.clear;
  props.free;
  fStyle.Free;
  fParsedInnerHTML.clear;
  fParsedInnerHTML.Free;
  inherited Destroy;
end;
function THTMLElement.getBelongTo:THTMLElementCollection;
begin
  result:=Owner;
end;
function THTMLElement.GetTagName:string;
begin
  if TagType<>htUnknown then
    result:=c_HTMLTagIds[TagType]
  else
    result:=fTagName;
end;
function THTMLElement.getTagType:THTMLTagTypes;
begin
  result:=fTagType;
end;
function THTMLElement.GetTagClass(TagStr:string):THTMLElementClasses;
var
  i:THTMLTagTypes;
  tagid:string;
begin
  tagid:=GetTagCmd(TagStr);
  result:=THTMLElement;
  for i:=low(THTMLTagTypes) to high(THTMLTagTypes) do
   if lowercase(c_HTMLTagIds[i])=lowercase(tagid) then
   begin
     result:=THTMLElementClasses(c_HTMLElementClasses[i]);
     break;
   end;
end;
Function THTMLElement.GetTagCmd(TagStr:string):string;
var t:integer;
begin
  t:=Pos(' ',TagStr);
  if t=0 then
   t:=Pos('>',TagStr);
  if t>0 then
    result:=copy(Tagstr,2,t-2);
end;
function THTMLElement.getAttribute(AttrName:string):string;
{var
  i:integer;
  propName:string;
  found:boolean;
}
begin
  {found:=false;
  for i:=0 to Props.Count-1 do
  begin
    if CompareText(Props.Names[i],AttrName)=0 then
    begin
      found:=true;
      propName:=Props.Names[i];
      break;
    end;
  end;
  if found then
    result:=Props.Values[propName]
  else
    result:=Props.Values[AttrName];
  }
  result:=Props.Values[AttrName];
  result:=TrimLeft(TrimRight(result));
  if length(result)>0 then
  begin
    if (result[1]='''') or (result[1]='"') then
      result:=Copy(result,2,length(result)-1);
    if (result[length(result)]='''') or (result[length(result)]='"') then
      result:=Copy(result,1,length(result)-1);
  end;
  //result:=StringReplace(result,'"','',[rfReplaceAll]);
  //result:=StringReplace(result,'''','',[rfReplaceAll]);
end;
procedure THTMLElement.setAttribute(AttrName:string;AttrValue:string);
var
  i:integer;
  found:boolean;
begin
  found:=false;
  for i:=0 to Props.Count-1 do
  begin
    if CompareText(Props.Names[i],AttrName)=0 then
    begin
      found:=true;
      Props[i]:=format('%s=%s',[AttrName,'"'+AttrValue+'"']);
      break;
    end;
  end;
  if not found then
    Props.Add(format('%s=%s',[AttrName,'"'+AttrValue+'"']));
end;
function THTMLElement.Get_className:string;
begin
  result:=Attributes['class'];
end;
procedure THTMLElement.Set_className(NewValue:string);
begin
  Attributes['class']:=NewValue;
end;

function THTMLElement.getId:string;
begin
  result:=Attributes['id'];
end;
procedure THTMLElement.SetId(NewValue:string);
begin
  Attributes['id']:=NewValue;
end;
function  THTMLElement.getTypeProp:string;
begin
  result:=Attributes['type'];
end;
procedure THTMLElement.setTypeProp(p:string);
begin
  Attributes['type']:=p;
end;

function  THTMLElement.Get_title:string;
begin
  result:=Attributes['title'];
end;
procedure THTMLElement.Set_title(NewValue:string);
begin
  Attributes['title']:=NewValue;
end;

function  THTMLElement.Get_onhelp:string;
begin
  result:=Attributes['onhelp'];
end;
procedure THTMLElement.Set_onhelp(NewValue:string);
begin
  Attributes['onhelp']:=NewValue;
end;
function THTMLElement.Get_onclick:string;
begin
  result:=Attributes['onclick'];
end;
procedure THTMLElement.Set_onclick(NewValue:string);
begin
  Attributes['onclick']:=NewValue;
end;

function THTMLElement.Get_ondblclick:string;
begin
  result:=Attributes['ondblclick'];
end;

procedure THTMLElement.Set_ondblclick(NewValue:string);
begin
  Attributes['ondblclick']:=NewValue;
end;

function THTMLElement.Get_onkeydown:string;
begin
  result:=Attributes['onkeydown'];
end;

procedure THTMLElement.Set_onkeydown(NewValue:string);
begin
  Attributes['onkeydown']:=NewValue;
end;

function THTMLElement.Get_onkeyup:string;
begin
  result:=Attributes['onkeyup'];
end;

procedure THTMLElement.Set_onkeyup(NewValue:string);
begin
  Attributes['onkeyup']:=NewValue;
end;

function THTMLElement.Get_onkeypress:string;
begin
  result:=Attributes['onkeypress'];
end;

procedure THTMLElement.Set_onkeypress(NewValue:string);
begin
  Attributes['onkeypress']:=NewValue;
end;

function THTMLElement.Get_onmouseout:string;
begin
  result:=Attributes['onmouseout'];
end;

procedure THTMLElement.Set_onmouseout(NewValue:string);
begin
  Attributes['onmouseout']:=NewValue;
end;

function THTMLElement.Get_onmouseover:string;
begin
  result:=Attributes['onmouseover'];
end;

procedure THTMLElement.Set_onmouseover(NewValue:string);
begin
  Attributes['onmouseover']:=NewValue;
end;

function THTMLElement.Get_onmousemove:string;
begin
  result:=Attributes['onmousemove'];
end;

procedure THTMLElement.Set_onmousemove(NewValue:string);
begin
  Attributes['onmousemove']:=NewValue;
end;

function THTMLElement.Get_onmousedown:string;
begin
  result:=Attributes['onmousedown'];
end;

procedure THTMLElement.Set_onmousedown(NewValue:string);
begin
  Attributes['onmousedown']:=NewValue;
end;

function THTMLElement.Get_onmouseup:string;
begin
  result:=Attributes['onmouseup'];
end;

procedure THTMLElement.Set_onmouseup(NewValue:string);
begin
  Attributes['onmouseup']:=NewValue;
end;
function THTMLElement.GetFormattedTagStr(IndentCount:integer;Indent_Ch:char;TagStrType:TTagStrTypes):string;
var
  i:integer;
  indents:string;
  Attrs:string;
  aCodeFormattingCharsB:string;
  aCodeFormattingCharsE:string;
  function getAttrStr(i:integer):string;
  begin
    if Props.values[Props.names[i]]<>'' then
      result:=Props.names[i]+'='+{'"'+}Props.values[Props.names[i]]{+'"'}
    else
    begin
      if Pos('=',Props[i])>0 then
        result:=Props.names[i]+'='{+'""'}
      else
        result:=Props[i];
    end;
  end;
  function getCloserCh:string;
  begin
    if Document.ProduceXMLCompatibleHTML then
      result:='/'
    else
      result:='';
  end;
begin
  result:='';
  indents:='';
  Attrs:='';
  if assigned(Document) and (not Document.ReFormatOutputHTML) then
  begin
    aCodeFormattingCharsB:=CodeFormattingCharsB;
    aCodeFormattingCharsE:=CodeFormattingCharsE;
  end
  else
  for i:=0 to IndentCount-1 do
  begin
    indents:=indents+Indent_Ch;
  end;
  for i:=0 to Props.Count-1 do
  begin
    if i=0 then
      Attrs:=Attrs+getAttrStr(i)
    else
      Attrs:=Attrs+' '+getAttrStr(i);

  end;
  case TagStrType of
    tstBegin:
    begin
      if (ChildElementCount=0) and (PlainText='') then
      begin
        if not (tagType in c_HTMLDoubleTags) then
        begin
          if Attrs<>'' then
            result:=format('%s%s<%s %s%s>',[indents,aCodeFormattingCharsB,TagName,Attrs,getCloserCh])
          else
            result:=format('%s%s<%s%s>',[indents,aCodeFormattingCharsB,TagName,getCloserCh]);
        end
        else
        begin
          if Attrs<>'' then
            result:=format('%s%s<%s %s>%s</%s>',[indents,aCodeFormattingCharsE,TagName,Attrs,aCodeFormattingCharsB,TagName])
          else
            result:=format('%s%s<%s>%s</%s>',[indents,aCodeFormattingCharsE,TagName,aCodeFormattingCharsB,TagName]);
        end;
      end
      else
      begin
        if Attrs<>'' then
          result:=format('%s%s<%s %s>',[indents,aCodeFormattingCharsB,TagName,Attrs])
        else
          result:=format('%s%s<%s>',[indents,aCodeFormattingCharsB,TagName]);
      end;
    end;
    tstEnd:
    begin
        result:=format('%s%s</%s>',[indents,aCodeFormattingCharsE,TagName]);
    end;
    tstBoth:
    begin
      if ChildElementCount=0 then
      begin
        if not (tagType in c_HTMLDoubleTags) then
        begin
          if Attrs<>'' then
            result:=format('%s%s<%s %s%s>',[indents,aCodeFormattingCharsB,TagName,Attrs,getCloserCh])
          else
            result:=format('%s%s<%s%s>',[indents,aCodeFormattingCharsB,TagName,getCloserCh]);
        end
        else
        begin
          if Attrs<>'' then
            result:=format('%s%s<%s %s>%s</%s>',[indents,aCodeFormattingCharsE,TagName,Attrs,aCodeFormattingCharsB,TagName])
          else
            result:=format('%s%s<%s>%s</%s>',[indents,aCodeFormattingCharsE,TagName,aCodeFormattingCharsB,TagName]);
        end;
      end
      else
      begin
        if Attrs<>'' then
          result:=format('%s%s<%s %s>%s</%s>',[indents,aCodeFormattingCharsB,TagName,Attrs,aCodeFormattingCharsE,TagName])
        else
          result:=format('%s%s<%s>%s</%s>',[indents,aCodeFormattingCharsE,TagName,aCodeFormattingCharsB,TagName]);
      end;
    end;
  end;
end;
function THTMLElement.Get_innerHTML:string;//only childs
var
  i:integer;
  s:string;
begin
  s:='';
  for i:=0 to ChildElementCount-1 do
  begin
      s:=s + ChildTags[i].outerHTML;
      if not (assigned(Document) and (not Document.ReFormatOutputHTML)) then
      if copy(s,length(s)-1,2)<>#$D+#$A then
        s:=s+#$D+#$A;
  end;
  result:=s;
  //result:=StringReplace(s,'<#TAB>',#9,[rfReplaceAll, rfIgnoreCase]);
  //result:=StringReplace(result,'<#CR>',#13,[rfReplaceAll, rfIgnoreCase]);
  //result:=StringReplace(result,'<#LF>',#10,[rfReplaceAll, rfIgnoreCase]);
  //result:=StringReplace(result,'<#CRLF>',#13+#10,[rfReplaceAll, rfIgnoreCase]);

end;

function THTMLElement.CreateChildElement(tagStr:string):THTMLElement;
var
  tag_type:THTMLTagTypes;
  tag_attributes:TStringList;
  element_class:THTMLElementClasses;
  isClosingTag:boolean;
  input_type:string;
begin
  tag_attributes:=TStringList.Create;
  result:=nil;
  try
    if ParseTagStr(tagStr,tag_type,isClosingTag,tag_attributes) then
    begin
      if not isClosingTag then
      begin
        if tag_type=htInput then
        begin
          input_type:=tag_attributes.Values['type'];
          if input_type='' then
            input_type:='text';
          if compareText(input_type,'button')=0 then
            element_class:=THTMLButton
          else
          if compareText(input_type,'checkbox')=0 then
            element_class:=THTMLCheckBox
          else
          if compareText(input_type,'file')=0 then
            element_class:=THTMLFile
          else
          if compareText(input_type,'hidden')=0 then
            element_class:=THTMLHiddenFormVar
          else
          if compareText(input_type,'image')=0 then
            element_class:=THTMLImageControl
          else
          if compareText(input_type,'password')=0 then
            element_class:=THTMLPasswordEdit
          else
          if compareText(input_type,'radio')=0 then
            element_class:=THTMLRadioButton
          else
          if compareText(input_type,'reset')=0 then
            element_class:=THTMLResetButton
          else
          if compareText(input_type,'submit')=0 then
            element_class:=THTMLSubmitButton
          else
          if compareText(input_type,'text')=0 then
            element_class:=THTMLEditBox
          else
            element_class:=THTMLInputControl;

        end
        else
          element_class:=THTMLElementClasses(c_HTMLElementClasses[tag_type]);
        result:=element_class.Create(Document,self.childs);
        if assigned(result) then
          result.TagStr:=tagStr; //this will parse tag str and set the attributes
      end;
    end
    else
    begin
      element_class:=THTMLPlainText;
      result:=element_class.Create(Document,self.childs);
      if assigned(result) then
         result.innerHTML:=tagStr; //this will parse tag str and set the attributes
    end;
  finally
    tag_attributes.Free;
  end;
end;
function THTMLElement.CreateChildElement(ParsedTag:THTMLParsedTag):THTMLElement;
var
  element_class:THTMLElementClasses;
  CancelParsing:boolean;
  input_type:string;
begin
  result:=nil;
  try
    if ParsedTag.isBeginTag then
    begin
        if ParsedTag.TagType=htPlainText then
          element_class:=THTMLPlainText
        else
        if ParsedTag.TagType=htInput then
        begin
          input_type:=StringReplace(ParsedTag.attributes.Values['type'],'"','',[rfReplaceAll]);
          input_type:=StringReplace(input_type,'''','',[rfReplaceAll]);

          if input_type='' then
            input_type:='text';
          if compareText(input_type,'button')=0 then
            element_class:=THTMLButton
          else
          if compareText(input_type,'checkbox')=0 then
            element_class:=THTMLCheckBox
          else
          if compareText(input_type,'file')=0 then
            element_class:=THTMLFile
          else
          if compareText(input_type,'hidden')=0 then
            element_class:=THTMLHiddenFormVar
          else
          if compareText(input_type,'image')=0 then
            element_class:=THTMLImageControl
          else
          if compareText(input_type,'password')=0 then
            element_class:=THTMLPasswordEdit
          else
          if compareText(input_type,'radio')=0 then
            element_class:=THTMLRadioButton
          else
          if compareText(input_type,'reset')=0 then
            element_class:=THTMLResetButton
          else
          if compareText(input_type,'submit')=0 then
            element_class:=THTMLSubmitButton
          else
          if compareText(input_type,'text')=0 then
            element_class:=THTMLEditBox
          else
            element_class:=THTMLInputControl;

        end
        else
          element_class:=THTMLElementClasses(c_HTMLElementClasses[ParsedTag.tagtype]);
        result:=element_class.Create(Document,self.childs);
        if assigned(result) then
        begin
          result.Props.assign(ParsedTag.Attributes);
          result.fTagType:=ParsedTag.fTagType;
          result.fTagName:=ParsedTag.fTagCmd;
          result.SourceLineBegin:=ParsedTag.SourceRow;
          result.SourceLineEnd:=ParsedTag.SourceCol;
          case ParsedTag.tagtype of
            htPlainText: result.innerHTML:=ParsedTag.tagStr; //this will parse tag str and set the attributes
            htComment  : result.Tagstr:=ParsedTag.tagStr;
            else  result.TagStr:=ParsedTag.tagStr;
          end;
        end;
    end;
  except on e:Exception do
    if assigned(document) then
      if assigned(Document.fonParseError) then
      begin
        Document.fonParseError(ParsedTag,e.message,ERROR_HTML_PARSING_UNKNOWN_EXCEPTION,ParsedTag.SourceRow,ParsedTag.SourceCol,CancelParsing);
        if CancelParsing then
          raise;
      end;
  end;
end;
function  THTMLElement.getExtendedLineCount:integer;
begin
  result:=fExtendedLineCount;
  fExtendedLineCount:=0;
end;
function THTMLElement.RequestOutBoundSource(RequesterChild:THTMLElement;RequestedTagBeginAt:integer;RequestedTagType:THTMLTagTypes;var ExtraSourceLines:string):boolean;
var
  res:integer;
begin
  ExtendedLineCount := 0;
  result:=false;
  res:=GetClosingTagPos(RequestedTagBeginAt+RequesterChild.SourceLineBegin+1,RequestedTagType);
  if res>-1 then
  begin
    ExtendedLineCount:=res-RequesterChild.SourceLineEnd;
    ExtraSourceLines:=getInnerHTML(fParsedInnerHTML,RequesterChild.SourceLineEnd+1,res);
    RequesterChild.SourceLineEnd:=res;
    result:=true;
  end;
end;
function THTMLElement.GetClosingTagPos(curr_pos:integer;aTagType:THTMLTagTypes):integer;
var
  curr_tag_type:THTMLTagTypes;
  tagStack:integer;
  i:integer;
  found:boolean;
  isClosingTag:boolean;
  s:string;
  tmpList:TStringList;
  procedure TryToFind;
  var i:integer;
  begin
    try
      found:=false;
      tagStack:=0;
      for i:=curr_pos to fParsedInnerHTML.count-1 do
      begin
        if ParseTagStr(fParsedInnerHTML[i],curr_tag_type,isClosingTag,nil) then
        begin
          if curr_tag_type=aTagType then
            case isClosingTag of
              false: inc(tagStack);
              true : dec(tagStack);
            end;
          if tagStack=0 then
          begin
            result:=i;
            found:=true;
            break;
          end;
        end;
      end;
    finally
    end;
  end;
begin
  result:=curr_pos;
  TryToFind;
  if not found then
  begin //try to request extended source from parent if possible than try again!
    if assigned(parentElement) then
    if parentElement.RequestOutBoundSource(self,curr_pos,aTagType, s) then
    begin
      tmpList:=TStringList.Create;
      try
        tmpList.Text:=s;
        for i:=0 to tmpList.Count-1 do
          fParsedInnerHTML.add(tmpList[i]);
        TryToFind;
      finally
        tmpList.Free;
      end;
    end;
  end;
  ExtendedLineCount:=0;
  if not found then
    result:=-1;
end;
procedure THTMLElement.Set_innerHTML(NewValue:string);
var
  i:integer;
  curr_tag_type:THTMLTagTypes;
  curr_tag_attributes:TStringList;
  //curr_element_class:THTMLElementClasses;
  isClosingTag:boolean;
  closing_tag_pos:integer;
  NewElement:THTMLElement;
  CancelParsing:boolean;
  function GetNextTagPos(ParsedHTMLCode:TStrings;curr_pos:integer;TagType:THTMLTagTypes):integer;
  var
    curr_tag_type:THTMLTagTypes;
    i:integer;
    found:boolean;
    isClosingTag:boolean;
  begin
    found:=false;
    result:=curr_pos;
    try
      for i:=curr_pos+1 to ParsedHTMLCode.count-1 do
        if ParseTagStr(ParsedHTMLCode[i],curr_tag_type,isClosingTag,nil) then
        begin//succesfully parsing means we have found a next tag!
          result:=i;
          found:=true;
          break;
         end;
    finally
      ExtendedLineCount:=0;
    end;
    if not found then
      result:=curr_pos;
  end;
begin
  ///reset everything
  PlainText:='';
  fInnerHTML:=NewValue;
  All.Clear(true);
  NewElement:=nil;
  //may be you need to free all collection before clearing test it later!!!
  if NeedToParseInnerHTML then
    ParseHTML(fInnerHTML,fParsedInnerHTML,true)
  else
    fParsedInnerHTML.Text:=fInnerHTML;
  i:=0;
  if (fParsedInnerHTML.count=0) and (fInnerHTML<>'') then
  begin
    //Create PlainText Element
    NewElement:=THTMLPlainText.Create(Document,childs);
    NewElement.innerHTML:=fInnerHTML;
  end
  else
  begin
    while i<=fParsedInnerHTML.count-1 do
    begin
      if isTag(fParsedInnerHTML[i]) then
      begin
        curr_tag_attributes:=TStringList.Create;
        try
          if ParseTagStr(fParsedInnerHTML[i],curr_tag_type,isClosingTag,curr_tag_attributes) then
          begin
            if isClosingTag then
            begin
              inc(i);
              continue;
            end;
            (*
            if ((curr_tag_type=htTableCol) or (curr_tag_type=htTH)) and (not (self is THTMLRow)) then
            begin
              fParsedInnerHTML.Insert(i,'<tr>');
              curr_tag_type:=htTableRow;
              curr_tag_attributes.clear;
            end;
            *)
            try
              NewElement:=CreateChildElement(fParsedInnerHTML[i]);
              if assigned(NewElement) then
                NewElement.SourceLineBegin := i;

            except on e:exception do
            begin
              if assigned(Document) then
                if assigned(document.onParseError) then
                begin
                  document.onParseError(nil,e.Message,ERROR_HTML_PARSING_UNKNOWN_EXCEPTION,i,0,CancelParsing);
                  if CancelParsing then
                    raise;
                end;
              inc(i);
              continue;
            end;
            end;
            if assigned(NewElement) then
              NewElement.NeedToParseInnerHTML:=false;
            if curr_tag_type in c_HTMLDoubleTags then
            begin //need closing tag
              closing_tag_pos:=GetClosingTagPos(i,curr_tag_type);
              if closing_tag_pos=-1 then//My Got!! end tag requied but not found!!! so defaul set at the end of current html block [because IE also do so!!!]
              begin
                closing_tag_pos:=fParsedInnerHTML.count-1;
                if assigned(NewElement) then
                begin
                  NewElement.SourceLineEnd := closing_tag_pos;
                  NewElement.innerHTML:=getInnerHTML(fParsedInnerHTML,i+1,fParsedInnerHTML.count-1);
                end;
              end
              else
               if assigned(NewElement) then
               begin
                  NewElement.SourceLineEnd := closing_tag_pos-1;
                  NewElement.innerHTML:=getInnerHTML(fParsedInnerHTML,i+1,closing_tag_pos-1);
               end;
              i:=closing_tag_pos+ExtendedLineCount;  //jump to end of block
            end
            else //closing tag optional
            if curr_tag_type in c_HTMLOptionalDoubleTags then
            begin
               closing_tag_pos:=GetClosingTagPos(i,curr_tag_type);
               if (closing_tag_pos<>-1) then //an optional end tag found set inner html otherwise assume inner html until  next element
               begin
                  if assigned(NewElement) then
                  begin
                    NewElement.SourceLineEnd := closing_tag_pos;
                    NewElement.innerHTML:=getInnerHTML(fParsedInnerHTML,i+1,closing_tag_pos-1);
                  end;
                  i:=closing_tag_pos+ExtendedLineCount;  //jump to end of block
               end
               else//assume that end tag is before the next element!!
               begin
                 closing_tag_pos:=GetNextTagPos(fParsedInnerHTML,i,curr_tag_type)-1;
                 if (closing_tag_pos>i) then
                 begin
                    if assigned(NewElement) then
                    begin
                      NewElement.SourceLineEnd := closing_tag_pos;
                      NewElement.innerHTML:=getInnerHTML(fParsedInnerHTML,i+1,closing_tag_pos);
                    end;
                    i:=closing_tag_pos;  //jump to end of block
                 end;
               end;
            end
            else//an empty element!
            begin
              //nothing do sofar
            end;
          end;
        finally
          curr_tag_attributes.Free;
        end;
      end
      else//plain text
      begin
        //Create PlainText Element
        NewElement:=THTMLPlainText.Create(Document,childs);
        NewElement.SourceLineBegin := i;
        NewElement.SourceLineEnd   := i;
        NewElement.innerHTML:=fParsedInnerHTML[i];
      end;
      inc(i);
    end;
  end;
end;

function THTMLElement.Get_innerText:string;
var
  i:integer;
  s:string;
  cnt:integer;
begin
  s:='';//only childs
  cnt:=ChildElementCount;
  for i:=0 to cnt-1 do
    if not (Childs[i] is THTMLPlainText) then
      s:=s + THTMLElement(Childs[i]).outerText;
  result:=s;
end;


procedure THTMLElement.Set_innerText(NewValue:string);
begin
  raise Exception.Create('not implemented yet.');
end;

function THTMLElement.Get_outerHTML:string;//self +childs
var
  pt:string;
  //i:integer;
  s1,s2,s3:string;
  nof_indent:integer;
  function GetChildDepth:integer;
  var p:THTMLDOMNode;
  begin
    result:=0;
    p:=parentNode;
    while assigned(p) do
    begin
      p:=p.parentNode;
      inc(result);
    end;
  end;
begin
  nof_indent:=GetChildDepth;
  if (ChildElementCount=0) and (pt='') then
  begin
    //if assigned(Document) and (not Document.ReFormatOutputHTML) then
      result:=GetFormattedTagStr(nof_indent,' ',tstBegin)
  end
  else
  begin
    s1:=GetFormattedTagStr(nof_indent,' ',tstBegin);
//    if assigned(Document) and (not Document.ReFormatOutputHTML) then
//      s1:=s1+CodeFormattingCharsB;
    s2:=innerHTML;
    if not (assigned(Document) and (not Document.ReFormatOutputHTML)) then
    if trimleft(trimright(s2))<>'' then
      if copy(s2,length(s2)-1,2)<>#$D+#$A then
        s2:=s2+ #$D+#$A;
    if Childs.Count>0 then
      if not (tagType in c_HTMLEmptyTags) then
        s3:=GetFormattedTagStr(nof_indent,' ',tstEnd);

    if not (assigned(Document) and (not Document.ReFormatOutputHTML)) then
      if trimleft(trimright(s3))<>'' then
        s3 :=s3+  #$D+#$A;
    if (assigned(Document) and (not Document.ReFormatOutputHTML)) then
      result:=s1 +  s2 + s3
    else
      result:=s1 + #$D+#$A + s2 + s3;
  end;
end;

procedure THTMLElement.Set_outerHTML(NewValue:string);
begin
//  if NewValue<>'' then
//    raise Exception.Create('not implemented yet.');
end;

function THTMLElement.Get_outerText:string;
var
  i:integer;
  s:string;
begin
//  s:=PlainText;//self + childs
  for i:=0 to ChildElementCount-1 do
  //  if not (Childs[i] is THTMLPlainText) then
    if Childs[i] is THTMLBreak then
      s:= s+#$d+#$A
    else
      s:=trimleft(s) + ' '+ THTMLElement(Childs[i]).OuterText;
  result:=s;
end;

procedure THTMLElement.Set_outerText(NewValue:string);
begin
  if NewValue<>'' then
    raise Exception.Create('not implemented yet.');
end;
function  THTMLElement.getPlainText:string;
var i:integer;
begin
  result:='';
  for i:=0 to ChildElementCount-1 do
  begin
    if Childs[i] is THTMLPlainText then
      result:=result+trimleft(THTMLPlainText(Childs[i]).innerHTML);
    if Childs[i] is THTMLBreak then
      result:=result+#$d+#$A
  end;
  result:=DecodeHTMLText(result);
  result:=trimleft(stringReplace(result,#9,'',[rfReplaceAll]));
end;
procedure THTMLElement.setPlainText(NewText:string);
begin
  if NewText<>'' then
    raise Exception.Create('not implemented yet.');
end;


function THTMLElement.children(index:integer):THTMLElement;
begin
  result:=THTMLElement(Childs[index]);
end;

(*
Procedure THTMLElement.ExtractPropsFromTag(TagStr:string;var TagCmd:String;Props:TStrings);
var
  s:string;
  //Tag_End_Point:integer;
  i:integer;
  in_str:boolean;
begin
  //validity check!
  exit;
  if not assigned (Props) then
    raise Exception.Create('Property List Not Assigned!Cannot continue to extract tag properties...');
  s:=TagStr;
  if (s[1]<>'<') or (Pos('>',s)=0) then
    raise Exception.Create('Invalid HTML Tag:'+TagStr);

  //Tag_End_Point:=Pos('>',s);
  s:=StringReplace(s,'<','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'/>','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'>','',[rfReplaceAll, rfIgnoreCase]);
  // s:=StringReplace(s,'"','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,#$D+#$A,'',[rfReplaceAll, rfIgnoreCase]);
  in_str:=false;
  for i:=1 to length(s) do
  begin
    if s[i]='"' then
    begin
      in_str:=not in_str;
    end;
    if (not in_str) and (s[i]=' ') then
      s[i]:='<'; //temporarely replace space with some ch!!
  end;
  s:=StringReplace(s,'<',#$D+#$A,[rfReplaceAll, rfIgnoreCase]);
  Props.Text:=s;
  if props.count>0 then
  begin
   TagCmd:=Props[0];
    Props.delete(0);
  end;
  for i:=0 to props.count-1 do
  begin
    props[i]:=StringReplace(props[i],'"','',[rfReplaceAll, rfIgnoreCase]);
    props[i]:=StringReplace(props[i],'''','',[rfReplaceAll, rfIgnoreCase]);
  end;
end;
*)
  (*
procedure THTMLElement.ExtractPropValues;
var
  TagCmd:string;
  function isTag(TagStr:string):boolean;
  begin
    result:=TagStr[1]='<';
  end;
begin

  Props.Clear;
  TagCmd:=GetTagCmd(TagStr);
  ExtractPropsFromTag(TagStr,TagCmd,Props);
  fTagName:=TagCmd;

  //Name:=Props.Values['Name'];
  Name:=StringReplace(Name,'''','',[rfReplaceAll, rfIgnoreCase]);

  StyleProp:=Props.Values['Style'];
  IDProp:=Props.Values['Id'];
  TypeProp:=Props.Values['Type'];
  ClassProp:=Props.Values['Class'];

end;
*)
function  THTMLElement.getName:string;
begin
  result:=Attributes['name'];
end;
procedure THTMLElement.SetName(NewName:string);
begin
 Attributes['name']:=NewName;
end;
procedure THTMLElement.SetParentTag(NewParent:THTMLElement);
begin
  fParentTag:=NewParent;
  if assigned(fParentTag) then
  if fParentTag.IndexOfChildTag(Self)=-1 then
    fParentTag.AddChildTag(self);
//  Parent.Tags.Add
end;
function  THTMLElement.getParentElement:THTMLElement;
begin
  result:=THTMLElement(ParentNode);
end;
procedure THTMLElement.setParentElement(NewParent:THTMLElement);
begin
  parentNode:=NewParent;
end;
function THTMLElement.GetChildTag(index:integer):THTMLElement;
begin
  result:=THTMLElement(Childs[index]);
end;
procedure THTMLElement.SetChildTag (index:integer;ATag:THTMLElement);
begin
  Childs[index]:=ATag;
end;
procedure THTMLElement.AddChildTag(ATag:THTMLElement);
begin
  Childs.InsertItem(ATag);
end;
procedure THTMLElement.RemoveChildTag(ATag:THTMLElement);
begin
  Childs.RemoveItem(ATag);
end;
function THTMLElement.ChildElementCount:integer;
begin
  result:=Childs.Count;
end;
function THTMLElement.getTagTypeFromClass:THTMLTagTypes;
var
  i:THTMLTagTypes;
begin
  result:=low(THTMLTagTypes);
  for i:=low(THTMLTagTypes) to high(THTMLTagTypes) do
   if c_HTMLElementClasses[i]=ClassType then
   begin
     result:=i;
     break;
   end;
end;
function THTMLElement.IndexOfChildTag(ATag:THTMLElement):integer;
begin
  result:=Childs.IndexOf(ATag);
end;
function THTMLElement.AllTagText:string;
//var i:integer;
  function GetRecursive(ATag:THTMLElement):string;
  var i:integer;
  begin
    if not assigned(ATag) then exit;
    result:=ATag.PlainText;
    for i:=0 to ATag.ChildElementCount-1 do
    begin
      result:=Result+GetRecursive(ATag.ChildTags[i]);
      if result<>'' then
        result:=Result+#13;
    end;

  end;
begin
  result:=GetRecursive(self);
  result:=StringReplace(result,'&nbsp;',' ',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'&gt;','>',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'&lt;','<',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'&quot;','"',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'&ampi;','&',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,#$9,' ',[rfReplaceAll, rfIgnoreCase]);
end;

{THTMLLoadableElement}
constructor THTMLLoadableElement.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited;
end;
destructor  THTMLLoadableElement.destroy;
begin
  if assigned(Buffer) then
    Buffer.Free;
  inherited;
end;

function  THTMLLoadableElement.getLoader:TInternetConnection;
begin
  result:=fLoader;
end;
procedure THTMLLoadableElement.setLoader(p:TInternetConnection);
begin
  fLoader:=p;
end;

function  THTMLLoadableElement.getReadyState:THTMLReadyStates;
begin
  raise exception.Create('not implemented yet');
end;
function  THTMLLoadableElement.getOnLoaded:THTMLOnLoadedEvent;
begin
  result:=fOnLoad;
end;
procedure THTMLLoadableElement.setOnLoaded(p:THTMLOnLoadedEvent);
begin
  fOnLoad:=p;
end;
function  THTMLLoadableElement.getOnReadyStateChange:THTMLOnReadyStateChangeEvent;
begin
end;
procedure THTMLLoadableElement.setOnReadyStateChange(p:THTMLOnReadyStateChangeEvent);
begin
end;
procedure THTMLLoadableElement.Load;
begin
end;
procedure THTMLLoadableElement.Parse;
begin
end;

{THTMLScript}

constructor THTMLScript.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited;
  fRawCode    := TStringlist.Create;
  fParsedCode := TStringlist.Create;
end;

destructor THTMLScript.Destroy;
begin
  fRawCode.Free;
  fParsedCode.Free;
  inherited;
end;

function  THTMLScript.Get_outerHTML:string;
begin
  result:=inherited Get_outerHTML;
  result:=StringReplace(result,'<!--','',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'-->','',[rfReplaceAll, rfIgnoreCase]);

end;

function  THTMLScript.Get_outerText:string;
begin
  result:=inherited Get_outerText;
end;

function  THTMLScript.Get_innerText:string;
begin
  result:=inherited Get_innerText;
end;

function  THTMLScript.Get_innerHTML:string;
begin
  result:=inherited Get_innerHTML;
  result:=StringReplace(result,'<!--','',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'-->','',[rfReplaceAll, rfIgnoreCase]);
end;

function  THTMLScript.getSrc:string;
begin
  result:=Attributes['src'];
end;
procedure THTMLScript.setSrc(p:string);
begin
  Attributes['src']:=p;
end;

function  THTMLScript.getEvent:string;
begin
  result:=Attributes['event'];
end;

procedure THTMLScript.setEvent(p:string);
begin
  Attributes['event']:=p;
end;

function  THTMLScript.gethtmlFor:string;
begin
  result:=Attributes['for'];
end;

procedure THTMLScript.sethtmlFor(p:string);
begin
  Attributes['for']:=p;
end;

function  THTMLScript.getLanguage :string;
begin
  result:=Attributes['language'];
end;

procedure THTMLScript.setLanguage(p:string);
begin
  Attributes['language']:=p;
end;

function  THTMLScript.get_Type:string;
begin
  result:=Attributes['type'];
end;

procedure THTMLScript.set_Type(p:string);
begin
  Attributes['type']:=p;
end;


procedure THTMLScript.Load;
begin
  //not implemented yet!!!
end;

procedure THTMLScript.Parse;
begin
  //not implemented yet!!!
end;

Procedure THTMLScript.Execute;
begin
  //not implemented yet!!!
end;
{THTMLLink}
function  THTMLLink.InternalCreateStream:TStream;
begin
  result:=TStringStream.Create('');
end;

function  THTMLLink.InternalGetLocationHRef:string;
begin
  result:=href;
end;


function  THTMLLink.InternalParse:boolean;
begin
  result:=false;
end;
function  THTMLLink.get_disabled:boolean;
begin
  result:=CompareText(Attributes['disabled'],'True')=0;
end;
procedure THTMLLink.set_disabled(p:boolean);
begin
  case p of
    true  : Attributes['disabled']:='True';
    false : Attributes['disabled']:='False';
  end;
end;

function  THTMLLink.get_media:string;
begin
  result:=Attributes['media'];
end;

procedure THTMLLink.set_media(p:string);
begin
  Attributes['media']:='';
end;

function  THTMLLink.get_rel:string;
begin
  result:=Attributes['rel'];
end;

procedure THTMLLink.set_rel(p:string);
begin
  Attributes['rel']:=p;
end;

function  THTMLLink.get_type:string;
begin
  result:=Attributes['type'];
end;

procedure THTMLLink.set_type(p:string);
begin
  Attributes['type']:=p;
end;

function  THTMLLink.get_onload:string;
begin
  result:=Attributes['onload'];
end;

procedure THTMLLink.set_onload(p:string);
begin
  Attributes['onload']:=p;
end;

function  THTMLLink.get_onerror:string;
begin
  result:=Attributes['onerror'];
end;

procedure THTMLLink.set_onerror(p:string);
begin
  Attributes['onerror']:=p;
end;

function  THTMLLink.get_styleSheet:THTMLStyleElement;
begin
  result:=fStyleSheet;
end;

procedure THTMLLink.set_styleSheet(p:THTMLStyleElement);
begin
  fStyleSheet:=p;
end;

function  THTMLLink.get_hRef:string;
begin
  result:=Attributes['href'];
end;
procedure THTMLLink.set_hRef(p:string);
begin
  Attributes['href']:=p;
end;


{THTMLPlainText}

function  THTMLPlainText.Get_outerHTML:string;
  function GetChildDepth:integer;
  var p:THTMLDOMNode;
  begin
    result:=0;
    p:=parentNode;
    while assigned(p) do
    begin
      p:=p.parentNode;
      inc(result);
    end;
  end;
var i:integer;
begin
  result:=finnerHTML;
  if result<>'' then
  if assigned(document) and (document.ReFormatOutputHTML) then
  begin
    for i:=0 to GetChildDepth do
      result:=' '+result;
  end
  else
    result:=CodeFormattingCharsB+result;
end;
function  THTMLPlainText.Get_innerHTML:string;
begin
  result:=finnerHTML;
end;
function  THTMLPlainText.Get_outerText:string;
begin
  result:=DecodeHTMLText(trimleft(finnerHTML));
end;
function  THTMLPlainText.getPlainText:string;
begin
  result:=outerText;
end;

procedure THTMLPlainText.setPlainText(NewText:string);
begin
  outerText:=NewText;
end;

function  THTMLPlainText.Get_innerText:string;
begin
  result:='';//child cant allowed so only outertext is possible;
end;


procedure THTMLPlainText.Set_innerHTML(NewValue:string);
begin
  fInnerHTML:=NewValue;
end;
function  THTMLPlainText.getTagType:THTMLTagTypes;
begin
  result:=htPlainText;
end;
{THTMLComment}
function  THTMLComment.Get_outerHTML:string;
  function GetChildDepth:integer;
  var p:THTMLDOMNode;
  begin
    result:=0;
    p:=parentNode;
    while assigned(p) do
    begin
      p:=p.parentNode;
      inc(result);
    end;
  end;
var i:integer;
begin
  result:=StringReplace(fTagstr,'<#TAB>',#9,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'<#CR>',#13,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'<#LF>',#10,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'<#CRLF>',#13+#10,[rfReplaceAll, rfIgnoreCase]);

  if result<>'' then
  if assigned(document) and (document.ReFormatOutputHTML) then
  begin
    for i:=0 to GetChildDepth do
      result:=' '+result;
  end
  else
    result:=CodeFormattingCharsB+result;
end;

function  THTMLComment.Get_outerText:string;
begin
  result:='';
end;

function  THTMLComment.Get_innerText:string;
begin
  result:='';
end;

function  THTMLComment.Get_innerHTML:string;
begin
  result:=StringReplace(fTagstr,'<#TAB>',#9,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'<#CR>',#13,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'<#LF>',#10,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'<#CRLF>',#13+#10,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(fTagstr,'&#09;',#9,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'&#13;',#13,[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'&#10;',#10,[rfReplaceAll, rfIgnoreCase]);
end;
function THTMLComment.getTagType:THTMLTagTypes;
begin
  result:=htComment;
end;
{THTMLNodeCollection}
constructor THTMLNodeCollection.Create(aOwner:THTMLDOMNode);
begin
  inherited Create;
  fOwner:=aOwner;
  fElements:=TObjectList.create(false);
end;
destructor THTMLNodeCollection.destroy;
begin
  while fElements.count>0 do
    fElements[0].Free;
  fOwner:=nil;
  fElements.Free;
  inherited destroy;
end;
function  THTMLNodeCollection.GetItem(Index: Integer): THTMLDOMNode;
begin
  result:=THTMLDOMNode(fElements[index]);
end;
procedure THTMLNodeCollection.SetItem(Index: Integer; Value: THTMLDOMNode);
begin
  fElements[Index]:=Value;
end;
function  THTMLNodeCollection.getCount:integer;
begin
 if assigned(fElements) then
    result:=fElements.Count
 else
   result:=0;
end;

function  THTMLNodeCollection.IndexOf(Item:THTMLDOMNode):integer;
var i:integer;
begin
  result:=-1;
  for i:=0 to Count-1 do
  begin
    if fElements[i]=Item then
    begin
      result:=i;
      break;
    end;
  end;
end;
procedure GetDesigner(Obj: TPersistent; out Result: IDesignerNotify);
var
  Temp: TPersistent;
begin
  Result := nil;
  if Obj = nil then Exit;
  Temp := TmyPersistent(Obj).GetOwner;
  if Temp = nil then
  begin
    if (Obj is TComponent) and (csDesigning in TComponent(Obj).ComponentState) then
      TmyComponent(Obj).QueryInterface(IDesignerNotify, Result);
  end
  else
  begin
    if (Obj is TComponent) and
      not (csDesigning in TComponent(Obj).ComponentState) then Exit;
    GetDesigner(Temp, Result);
  end;
end;

procedure NotifyDesigner(Self, Item: TPersistent; Operation: TOperation);
var
  Designer: IDesignerNotify;
begin
  GetDesigner(Self, Designer);
  if Designer <> nil then
    Designer.Notification(Item, Operation);
end;
function  THTMLNodeCollection.InsertItem(Item: THTMLDOMNode):integer;
begin
  result:=fElements.Add(Item);
  {if assigned(OwnerNode) then
  begin
    if OwnerNode.All<>self then
      if OwnerNode.All.indexOf(Item)=-1 then
        OwnerNode.All.InsertItem(Item);
    if assigned(OwnerNode.ParentNode) then
      if OwnerNode.ParentNode.All<>self then
        if OwnerNode.ParentNode.All.IndexOf(Item)=-1 then
          OwnerNode.ParentNode.All.InsertItem(Item);
  end;
  }
  //Notify(Item, cnAdded); for designer imp
  //Changed;               for designer imp
  //NotifyDesigner(Self, Item, opInsert); for designer imp
end;
procedure THTMLNodeCollection.RemoveItem(Item: THTMLDOMNode);
begin
  fElements.Remove(Item);
  {if assigned(OwnerNode) then
  begin
    if assigned(OwnerNode.ParentNode) then
      if OwnerNode.ParentNode.All<>self then
        OwnerNode.ParentNode.All.RemoveItem(Item);
    if OwnerNode.All<>self then
      OwnerNode.All.RemoveItem(Item);
  end;
  }
  //Changed; for designer imp
  //NotifyDesigner(Self, Item, opRemove);for designer imp
end;
procedure THTMLNodeCollection.Clear(DestroyItems:boolean);
begin
  if DestroyItems then
  begin
    While Count>0 do
      fElements[0].Free;
  end;
  fElements.Clear;
end;
{THTMLElementCollection}
function  THTMLElementCollection.getItem(Index: Integer): THTMLElement;
begin
  result:=THTMLElement(inherited getItem(index));
end;
procedure THTMLElementCollection.setItem(Index: Integer; Value: THTMLElement);
begin
  inherited setItem(Index, Value);
end;

{THTMLFramesCollection}
function  THTMLFramesCollection.getItem(Index: Integer): THTMLFrame;
begin
  result:=THTMLFrame(inherited getItem(index));
end;
procedure THTMLFramesCollection.setItem(Index: Integer; Value: THTMLFrame);
begin
  inherited setItem(Index, Value);
end;

{THTMLStyleSheetsCollection}

function  THTMLStyleSheetsCollection.getItem(Index: Integer): THTMLStyleElement;
begin
  result:=THTMLStyleElement(inherited getItem(index));
end;

procedure THTMLStyleSheetsCollection.setItem(Index: Integer; Value: THTMLStyleElement);
begin
  inherited setItem(Index, Value);
end;

{THTMLScriptsCollection}

function  THTMLScriptsCollection.getItem(Index: Integer): THTMLScript;
begin
  result:=THTMLScript(inherited getItem(index));
end;

procedure THTMLScriptsCollection.setItem(Index: Integer; Value: THTMLScript);
begin
  inherited setItem(Index, Value);
end;


{THTMLListownerElement}
constructor THTMLListownerElement.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
 inherited Create(OwnerDocument,OwnerCollection);
 fItems:=THTMLListItemsCollection.Create(self);
end;
destructor THTMLListownerElement.Destroy;
begin
  fItems.free;
  inherited;
end;

function  THTMLListownerElement.getItem(index:integer):THTMLListItemElement;
begin
  result:=fItems.getListItem(index);
end;
procedure THTMLListownerElement.setItem(index:integer;aItem: THTMLListItemElement);
begin
  fItems.setItem(index,aItem);
end;

function  THTMLListownerElement.AddItem(aItem: THTMLListItemElement):integer;
begin
  result:=fItems.InsertItem(aItem);
end;

procedure THTMLListownerElement.RemoveItem(aItem:THTMLListItemElement);
begin
  fItems.RemoveItem(aItem);
end;

function THTMLListownerElement.itemCount:integer;
begin
  result:=fItems.Count;
end;

function THTMLListownerElement.indexOf(aItem:THTMLListItemElement):integer;
begin
  result:=fItems.IndexOf(aItem);
end;

{THTMLListItemElement}
constructor THTMLListItemElement.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited create(OwnerDocument,OwnerCollection);
  fListOwner:=findListOwner(parentElement);
  if assigned(fListOwner) then
    fListOwner.AddItem(self);
end;
destructor THTMLListItemElement.Destroy;
begin
  if assigned(fListOwner) then
    fListOwner.RemoveItem(self);
  fListOwner:=nil;
  inherited;
end;
function THTMLListItemElement.findListOwner(el:THTMLElement):THTMLListOwnerElement;
begin
  result:=nil;
  if assigned(el) then
  begin
    if el is THTMLListOwnerElement then
      result:=THTMLListOwnerElement(el)
    else
    if el.parentElement is THTMLListOwnerElement then
      result:=THTMLListOwnerElement(el.parentElement)
    else
      result:=findListOwner(el.parentElement);
  end;
end;

{THTMLListItemsCollection}
constructor THTMLListItemsCollection.Create(aOwner:THTMLListOwnerElement);
begin
  inherited Create(aOwner);
  fOwner:=aOwner;
end;

function  THTMLListItemsCollection.GetListItem(Index:integer):THTMLListItemElement;
begin

  result:=THTMLListItemElement(getItem(Index));
end;

procedure THTMLListItemsCollection.SetListItem(Index:integer;aItem:THTMLListItemElement);
begin
  setItem(Index,aItem);
end;
function THTMLListItemsCollection.IndexOf(AItem:THTMLListItemElement):integer;
begin
  result:=inherited indexof(aItem);
end;

{THTMLBase}
constructor THTMLBase.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,OwnerCollection);
end;
destructor THTMLBase.Destroy;
begin
  inherited Destroy;
end;

function  THTMLBase.getHRef:string;
begin
  result:=Attributes['href'];
end;
procedure THTMLBase.sethRef(p: string);
begin
  Attributes['href']:=p;
end;

function  THTMLBase.getTarget:string;
begin
  result:=Attributes['target'];
end;
procedure THTMLBase.setTarget(p: string);
begin
  Attributes['target']:=p;
end;

{THTMLBaseFont}
function  THTMLBaseFont.getColor:string;
begin
  result:=Attributes['color'];
end;
procedure THTMLBaseFont.setColor(p: string);
begin
  Attributes['color']:=p;
end;

function  THTMLBaseFont.getFace:string;
begin
  result:=Attributes['face'];
end;
procedure THTMLBaseFont.setFace(p: string);
begin
  Attributes['face']:=p;
end;

function  THTMLBaseFont.getSize:string;
begin
  result:=Attributes['size'];
end;
procedure THTMLBaseFont.setSize(p: string);
begin
  Attributes['size']:=p;
end;

{THTMLMeta}
function  THTMLMeta.getHeader:THTMLHeader;
begin
  result:=Document.Header;
end;
procedure THTMLMeta.SetHeader(aHeader:THTMLHeader);
begin
end;

function  THTMLMeta.getContent:string;
begin
  result:=Attributes['content'];
end;
procedure THTMLMeta.setContent(aContent:string);
begin
  Attributes['content']:=aContent;
end;

function  THTMLMeta.getHttpEquiv:string;
begin
  result:=Attributes['Http-Equiv'];
end;
procedure THTMLMeta.setHttpEquiv(aHttpEquiv:string);
begin
  Attributes['Http-Equiv']:=aHttpEquiv;
end;

function  THTMLMeta.getURL:string;
begin
  result:=Attributes['url'];
end;
procedure THTMLMeta.setURL(aURL:string);
begin
  Attributes['url']:=aURL;
end;
constructor THTMLMeta.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited;
  if assigned(Header) then
    Header.AddVariable(self);
end;
destructor THTMLMeta.Destroy;
begin
  if assigned(Header) then
    Header.RemoveVariable(self);
  inherited;
end;




{THTMLFont}
constructor THTMLFont.create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  //fFont:=TFont.Create;
end;
destructor THTMLFont.Destroy;
begin
  //fFont.free;
  inherited Destroy;
end;
{THTMLOption}
constructor THTMLOption.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  FSelect:=FindSelect(ParentNode);
  if assigned(FSelect) then
    FSelect.AddOption(self);
end;
destructor THTMLOption.Destroy;
begin
  inherited DEstroy;
  if assigned(FSelect) then
    fSelect.RemoveOption(self);
end;

function THTMLOption.GetText:string;
begin
  result:=outerText;
end;
procedure THTMLOption.SetText(AText:string);
begin
  outerText:=AText;
end;
function  THTMLOption.getValue:string;
begin
  result:=Attributes['value'];
end;
procedure THTMLOption.setValue(aValue:string);
begin
  Attributes['value']:=aValue;
end;

function  THTMLOption.getSelected:boolean;
begin
  result := props.IndexOf('selected')>-1;
  if not result then
  begin
    if comparetext(Attributes['selected'],'true')=0 then
      result:=true
    else
      result:=false;
  end;

end;
procedure THTMLOption.setSelected(NewValue:boolean);
begin
  case NewValue of
    true :if props.IndexOf('selected')=-1 then props.add('selected');
    false:if props.IndexOf('selected')>-1 then props.Delete(props.IndexOf('selected'));
  end;
end;
function THTMLOption.FindSelect(AParentTag:THTMLDOMNode):THTMLSelect;
begin
  result:=nil;
  if not assigned(AParentTag) then
    exit;
  if AParentTag is THTMLSelect then
  begin
    result:=THTMLSelect(AParentTag);
    exit;
  end
  else
    result:=FindSelect(AParentTag.ParentNode);
end;

(*
procedure THTMLOption.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)

{THTMLSelect}
function THTMLSelect.GetValue:string;
var
  i:integer;
begin
  result:='';
  for i:=0 to OptionCount-1 do
  begin
    if Options[i].Selected then
    begin
      result:=Options[i].Value;
      break;
    end;
  end;
end;
procedure THTMLSelect.SetValue(AValue:string);
var
  i:integer;
begin
  for i:=0 to OptionCount-1 do
  begin
    Options[i].Selected:=false;
    if CompareText(Options[i].Value,AValue)=0 then
    begin
      Options[i].Selected:=true;
    end;
  end;
end;
function THTMLSelect.GetSelText:string;
var
  i:integer;
begin
  result:='';
  for i:=0 to OptionCount-1 do
  begin
    if Options[i].Selected then
    begin
      result:=Options[i].Text;
      break;
    end;
  end;
end;

procedure THTMLSelect.SetSelText(AValue:string);
var
  i:integer;
begin
  for i:=0 to OptionCount-1 do
  begin
    if Options[i].Selected then
    begin
      Options[i].Text:=AValue;
      break;
    end;
  end;
end;

(*
procedure THTMLSelect.ExtractPropValues;
begin
  inherited ExtractPropValues;
  if Props.Values['TabOrder']<>'' then
  begin
    if not trystrtoint(Props.Values['TabOrder'],fTabOrder) then
      TabOrder:=0;
  end
  else
    TabOrder:=0;
  //Value:=Props.Values['Value'];
end;
*)
function THTMLSelect.GetOption(index:integer):THTMLOption;
begin
  result:=THTMLoption(fOptions[index]);
end;
procedure THTMLSelect.SetOption(index:integer;AOption:THTMLOption);
begin
  fOptions[index]:=AOption;
end;
procedure THTMLSelect.AddOption(AOption:THTMLOption);
begin
  fOptions.Add(AOption);
end;
procedure THTMLSelect.RemoveOption(AOption:THTMLOption);
begin
  fOptions.Remove(AOption);
end;
function THTMLSelect.OptionCount:integer;
begin
  result:=fOptions.Count;
end;
constructor THTMLSelect.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  fOptions:=TObjectList.Create(False);
end;

destructor THTMLSelect.Destroy;
begin
  inherited Destroy;
  fOptions.free;
end;

{THTMLCheckBox}
(*
procedure THTMLCheckBox.ExtractPropValues;
begin
  inherited ExtractPropValues;

end;
*)
function  THTMLCheckBox.getChecked:boolean;
begin
  result:=props.IndexOf('checked')>-1;
  if not result then
  begin
    if comparetext(Attributes['checked'],'true')=0 then
      result:=true
    else
      result:=false;
  end;
end;
procedure THTMLCheckBox.setChecked(NewValue:boolean);
begin
  case NewValue of
    true :Attributes['checked']:='true';
    false:Attributes['checked']:='false';
  end;
end;
{THTMLMemo}
function  THTMLMemo.GetValue:string;
begin
  result:=outerText;
end;
procedure THTMLMemo.SetValue(AValue:string);
var
  i:integer;
  succes:boolean;
begin
  succes:=false;
  if childs.count>0 then
  begin
    for i:=0 to childs.count-1 do
    if childs[i] is THTMLPlainText then
    begin
      THTMLPlainText(childs[i]).innerHTML:=aValue;
      succes:=true;
      break;
    end;
  end;
  if not succes then
  begin
    CreateChildElement(aValue);
  end;
end;
{THTMLFile }
function THTMLFile.GetValue:string;
begin
  //result:=fFilename;
  result:=inherited getValue;
end;
procedure THTMLFile.SetValue(AValue:string);
begin
  fFilename:=aValue;
  if assigned(Form) then
    Form.UploadFilename:=fFileName;
  inherited SetValue(AValue);
  {
  if assigned(fFileStream) then
    begin
      fFileStream.Free;
      fFileStream:=nil;
    end;
  if aValue<>'' then
    fFileStream:=TFileStream.Create(aValue);
  }
end;
destructor THTMLFile.Destroy;
begin
  {if assigned(fFileStream) then
    begin
      fFileStream.Free;
      fFileStream:=nil;
    end;
  }
  inherited;
end;
{THTMLAnchor}
constructor THTMLAnchor.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited Create(OwnerDocument, OwnerCollection);
  if assigned(Document) then
    Document.AddAnchor(self);
end;
destructor  THTMLAnchor.destroy;
begin
  if assigned(Document) then
    Document.RemoveAnchor(self);
  inherited destroy;
end;
(*
procedure THTMLAnchor.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)
function  THTMLAnchor.getHRef:string;
begin
  //result:=lowercase(Attributes['href']);
  result:=stringreplace(Attributes['href'],'&amp;','&',[rfReplaceAll]);
end;
procedure THTMLAnchor.setHref(ahRef:string);
begin
  //Attributes['href']:=lowercase(ahRef);
  Attributes['href']:=ahRef;
end;

function  THTMLAnchor.getTarget:string;
begin
  result:=Attributes['target'];
end;

procedure THTMLAnchor.setTarget(aTarget:string);
begin
  Attributes['target']:=aTarget;
end;
procedure THTMLAnchor.Click;
var url,s:string;
begin
  s:=hRef;
  if assigned(document) then
  begin
    url:=document.getAbsoluteURL(s);
    document.location.referrer:=document.location.href;
    document.location.href:=url;
  end;
end;

{THTMLStyleElement}

constructor THTMLStyleElement.create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited;
end;

destructor  THTMLStyleElement.destroy;
begin
  inherited;
end;
function  THTMLStyleElement.Get_outerHTML:string;
begin
  result:=inherited Get_outerHTML;
  result:=StringReplace(result,'<!--','',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'-->','',[rfReplaceAll, rfIgnoreCase]);

end;

function  THTMLStyleElement.Get_outerText:string;
begin
  result:=inherited Get_outerText;
end;

function  THTMLStyleElement.Get_innerText:string;
begin
  result:=inherited Get_innerText;
end;

function  THTMLStyleElement.Get_innerHTML:string;
begin
  result:=inherited Get_innerHTML;
  result:=StringReplace(result,'<!--','',[rfReplaceAll, rfIgnoreCase]);
  result:=StringReplace(result,'-->','',[rfReplaceAll, rfIgnoreCase]);
end;


function  THTMLStyleElement.getDisabled:boolean;
begin
  result:=compareText(Attributes['disabled'],'True')=0;
end;

procedure THTMLStyleElement.setDisabled(p:boolean);
begin
  case p of
    True : Attributes['disabled']:='True';
    False: Attributes['disabled']:='False';
  end;
end;

function  THTMLStyleElement.getMedia:string;
begin
  result:=Attributes['media'];
end;

procedure THTMLStyleElement.setMedia(p:string);
begin
  Attributes['media']:=p;
end;

function  THTMLStyleElement.getType:string;
begin
  result:=Attributes['type'];
end;

procedure THTMLStyleElement.setType(p:string);
begin
  Attributes['type']:=p;
end;
function  THTMLStyleElement.get_href:string;
begin
end;

{THTMLObject}
procedure THTMLCustomControl.SetParent(NewParent:THTMLCustomControl);
begin
  fParent:=NewParent;
  if fParent.IndexOfChildObject(Self)=-1 then
    fParent.AddChildObject(self);
//  Parent.Objects.Add
end;
function THTMLCustomControl.GetChildObject(index:integer):THTMLCustomControl;
begin
  result:=THTMLCustomControl(FChildObjects[index]);
end;
procedure THTMLCustomControl.SetChildObject (index:integer;AObject:THTMLCustomControl);
begin
  FChildObjects[index]:=AObject;
end;
procedure THTMLCustomControl.AddChildObject(AObject:THTMLCustomControl);
begin
  FChildObjects.Add(AObject);
end;
procedure THTMLCustomControl.RemoveChildObject(AObject:THTMLCustomControl);
begin
  FChildObjects.Remove(AObject);
end;
function THTMLCustomControl.ChildObjectCount:integer;
begin
  result:=FChildObjects.Count;
end;
function THTMLCustomControl.IndexOfChildObject(AObject:THTMLCustomControl):integer;
begin
  result:=FChildObjects.IndexOf(AObject);
end;
constructor THTMLCustomControl.create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create (OwnerDocument,BelongTo);
  FChildObjects:=TObjectList.Create(false);
end;
destructor THTMLCustomControl.Destroy;
begin
  FChildObjects.Free;
  inherited destroy;

end;
{THTMLControl}
function  THTMLControl.getWidth:string;
begin
  result:=Attributes['width'];
end;
procedure THTMLControl.setWidth(aWidth:string);
begin
  Attributes['width']:=aWidth;
end;

function  THTMLControl.getHeight:string;
begin
  result:=Attributes['height'];
end;
procedure THTMLControl.setHeight(aHeight:string);
begin
  Attributes['height']:=aHeight;
end;

function  THTMLControl.getAlign:string;
begin
  result:=Attributes['align'];
end;
procedure THTMLControl.setAlign(aAlign:string);
begin
  Attributes['align']:=aAlign;
end;

function  THTMLControl.getVAlign:string;
begin
  result:=Attributes['valign'];
end;
procedure THTMLControl.setVAlign(aVAlign:string);
begin
  Attributes['valign']:=aVAlign;
end;

function  THTMLControl.getPixelWidth:integer;
var s:string;
begin
   s:=width;
   s:=stringreplace(s,'px','',[rfReplaceAll,rfIgnoreCase]);
   if not TryStrToInt(s,result) then
     result:=-1;
end;
procedure THTMLControl.setPixelWidth(p:integer);
begin
  width:=IntToStr(p)+'px';
end;

function  THTMLControl.getPixelHeight:integer;
var s:string;
begin
   s:=Height;
   s:=stringreplace(s,'px','',[rfReplaceAll,rfIgnoreCase]);
   if not TryStrToInt(s,result) then
     result:=-1;
end;

procedure THTMLControl.setPixelHeight(p:integer);
begin
  Height:=IntToStr(p)+'px';
end;

{THTMLParam}
constructor THTMLParam.create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  if assigned(Owner) then
    if assigned(Owner.OwnerNode) then
      if  Owner.OwnerNode is THTMLParametricObject then
        THTMLParametricObject(Owner.OwnerNode).Params.InsertItem(self);
end;
destructor  THTMLParam.Destroy;
begin
  if assigned(Owner) then
    if assigned(Owner.OwnerNode) then
      if  Owner.OwnerNode is THTMLParametricObject then
        THTMLParametricObject(Owner.OwnerNode).Params.RemoveItem(self);
  inherited Destroy;
end;

function  THTMLParam.getValue:string;
begin
  result:=Attributes['value'];
end;

procedure THTMLParam.setValue(p:string);
begin
  Attributes['value']:=p;
end;

{THTMLParametricObject}
constructor THTMLParametricObject.Create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,OwnerCollection);
  fParamsCollection:=THTMLParamsCollection.Create(self);
end;
destructor  THTMLParametricObject.Destroy;
begin
  fParamsCollection.Free;
  inherited Destroy;
end;

function  THTMLParametricObject.getSrc:string;
begin
  result:=Attributes['src'];
end;
procedure THTMLParametricObject.setSrc(p: string);
begin
  Attributes['src']:=p;
end;

function  THTMLParametricObject.getCode:string;
begin
  result:=Attributes['code'];
end;
procedure THTMLParametricObject.setCode(p:string);
begin
  Attributes['code']:=p;
end;

function  THTMLParametricObject.getCodeBase:string;
begin
  result:=Attributes['codebase'];
end;
procedure THTMLParametricObject.setCodeBase(p:string);
begin
  Attributes['codebase']:=p;
end;



{THTMLCell}

constructor THTMLCell.Create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,OwnerCollection);
  Row:=FindRow(ParentNode);
  if Name='' then
    if assigned(Document) then
      if assigned(row) then
        if assigned(row.table) then
          Name:='Cell'+inttostr(Document.TableCount)+inttostr(Row.Table.RowCount)+inttostr(Row.CellCount);

end;

destructor THTMLCell.Destroy;
begin
  //Data.Free;
  Row:=nil;//remove itself from row cells array
  inherited Destroy;
end;
function THTMLCell.FindRow(AParentTag:THTMLDOMNode):THTMLRow;
begin
  result:=nil;
  if not assigned(AParentTag) then
    exit;
  if AParentTag is THTMLRow then
  begin
    result:=THTMLRow(AParentTag);
    exit;
  end
  else
    Result:=FindRow(AParentTag.ParentNode);
  if not assigned(result) then
  begin
    if AParentTag is THTMLTable then
    begin
      result:=THTMLRow.Create(AParentTag.Document,AParentTag.All);
      result.Parent:=THTMLCustomControl(AParentTag);
      result.Table:=THTMLTable(AParentTag);
    end;
  end;
end;
(*
procedure THTMLCell.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)
procedure THTMLCell.SetRow(ARow:THTMLRow);
begin
  if fRow<>ARow then
  begin
    if assigned(fRow) then
      fRow.RemoveCell(Self);
    fRow:=ARow;
    if assigned(ARow) then
      fRow.AddCell(self);
  end;

end;
function THTMLCell.GetColumnIndex:integer;
var i:integer;
begin
  result:=-1;
  for i:=0 to FRow.CellCount-1 do
    if FRow.cells[i]=self then
      begin
        result:=i;
        break;
      end;
end;
{THTMLCells}

constructor THTMLCellCollection.Create(aOwner:THTMLRow);
begin
  inherited Create(aOwner);
end;
function  THTMLCellCollection.GetCell(Index:integer):THTMLCell;
begin
  result:=THTMLCell(getItem(Index));
end;

procedure THTMLCellCollection.SetCell(Index:integer;aCell:THTMLCell);
begin
  setItem(Index,aCell);
end;
function THTMLCellCollection.IndexOf(ACell:THTMLCell):integer;
begin
  result:=inherited indexof(aCell);
end;
{THTMLParamsCollection}
constructor THTMLParamsCollection.Create(aOwner:THTMLParametricObject);
begin
  inherited Create(aOwner);
end;
function  THTMLParamsCollection.getParam(Index:integer):THTMLParam;
begin
  result:=THTMLParam(getItem(index));
end;
procedure THTMLParamsCollection.setParam(Index:integer;aParam:THTMLParam);
begin
  SetItem(Index,aParam);
end;
function  THTMLParamsCollection.IndexOf(AParam:THTMLParam):integer;
begin
  result:=inherited IndexOf(aParam);
end;
{THTMLRowCollection}
constructor THTMLRowCollection.Create(aOwner:THTMLTable);
begin
  inherited Create(aOwner);
  fTable:=aOwner;
end;
function  THTMLRowCollection.getRow(Index:integer):THTMLRow;
begin
  result:=THTMLRow(getItem(Index));
end;

procedure THTMLRowCollection.setRow(Index:integer;aRow:THTMLRow);
begin
  setItem(Index,aRow);
end;
function THTMLRowCollection.IndexOf(ARow:THTMLRow):integer;
begin
  result:=inherited indexof(aRow);
end;

{THTMLTableCollection}
constructor THTMLTableCollection.Create(aOwner:THTMLDocument);
begin
  inherited Create(aOwner);
  fDocument:=aOwner;
end;
function  THTMLTableCollection.getTable(Index:integer):THTMLTable;
begin
  result:=THTMLTable(getItem(Index));
end;
procedure THTMLTableCollection.setTable(Index:integer;aTable:THTMLTable);
begin
  setItem(Index,aTable);
end;
function  THTMLTableCollection.IndexOf(aTable:THTMLTable):integer;
begin
  result:=inherited indexof(aTable);
end;
{THTMLAnchorCollection}
constructor THTMLAnchorCollection.Create(aOwner:THTMLDocument);
begin
  inherited Create(aOwner);
  fDocument:=aOwner;
end;
function  THTMLAnchorCollection.getAnchor(Index:integer):THTMLAnchor;
begin
  result:=THTMLAnchor(getItem(Index));
end;
procedure THTMLAnchorCollection.setAnchor(Index:integer;aAnchor:THTMLAnchor);
begin
  setItem(Index,aAnchor);
end;
function  THTMLAnchorCollection.IndexOf(aAnchor:THTMLAnchor):integer;
begin
  result:=inherited indexof(aAnchor);
end;
{THTMLFormCollection}
constructor THTMLFormCollection.Create(aOwner:THTMLDocument);
begin
  inherited Create(aOwner);
  fDocument:=aOwner;
end;
function  THTMLFormCollection.getForm(Index:integer):THTMLForm;
begin
  result:=THTMLForm(getItem(Index));
end;
procedure THTMLFormCollection.setForm(Index:integer;aForm:THTMLForm);
begin
  setItem(Index,aForm);
end;
function  THTMLFormCollection.IndexOf(aForm:THTMLForm):integer;
begin
  result:=inherited indexof(aForm);
end;

{THTMLImageCollection}
constructor THTMLImageCollection.Create(aOwner:THTMLDocument);
begin
  inherited Create(aOwner);
  fDocument:=aOwner;
end;
function  THTMLImageCollection.getImage(Index:integer):THTMLImage;
begin
  result:=THTMLImage(getItem(Index));
end;
procedure THTMLImageCollection.setImage(Index:integer;aImage:THTMLImage);
begin
  setItem(Index,aImage);
end;
function  THTMLImageCollection.IndexOf(aImage:THTMLImage):integer;
begin
  result:=inherited indexof(aImage);
end;

{THTMLRow}

constructor THTMLRow.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
var cancel:boolean;
begin
  inherited Create(OwnerDocument,BelongTo);
  FCellCollection:=THTMLCellCollection.Create(self);
  Table:=FindTable(ParentNode);
  if not assigned(Table) then
   //Raise exception.create('cannot find Table Object for Table Row tag :'+tagstr);
   if assigned(Document) then
     if Assigned(Document.fOnParseError) then
     Document.fOnParseError(nil,format(sExceptionCouldNotFindTable,[TagStr]),0,0,0,cancel);
  if assigned(Table) then
   if Name='' then
     Name:='Row'+inttostr(Table.Document.TableCount)+inttostr(Table.RowCount);

end;
destructor THTMLRow.destroy;
begin
  Table:=nil;//remove itself from tables row array
  FCellCollection.Free;
  inherited destroy;
end;
function THTMLRow.FindTable(AParentTag:THTMLDOMNode):THTMLTable;
begin
  result:=nil;
  if not assigned(AParentTag) then
    exit;
  if AParentTag is THTMLTable then
  begin
    result:=THTMLTable(AParentTag);
    exit;
  end
  else
    result:=FindTable(AParentTag.ParentNode);
end;
(*
procedure THTMLRow.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)
procedure THTMLRow.SetTable(ATable:THTMLTable);
begin
  if fTable<>ATable then
  begin
    if assigned(fTable) then
      fTable.RemoveRow(Self);
    fTable:=ATable;
    if assigned(ATable) then
      fTable.AddRow(self);
  end;
end;

function THTMLRow.GetRowOrder:integer;
begin
  result:=FTable.Rows.IndexOf(self);
end;

Procedure THTMLRow.AddCell(ACell:THtmlCell);
begin
  fCellCollection.InsertItem(ACell);
end;

procedure THTMLRow.RemoveCell(ACell:THTMLCell);
begin
  fCellCollection.RemoveItem(ACell);
end;


function THTMLRow.IndexOfCell(ACell:THTMLCell):integer;
begin
  result:=fCellCollection.IndexOf(ACell);
end;
function THTMLRow.CellCount:integer;
begin
  result:=fCellCollection.Count;
end;

{THTMLTable}


constructor THTMLTable.Create (OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  fRowCollection:=THTMLRowCollection.Create(self);
  if assigned(Document) then
    Document.AddTable(self);
  if name='' then
    Name:=Title;
  if Name='' then
    Name:='Table'+inttostr(Document.TableCount);
end;
destructor THTMLTable.Destroy;
begin
  fRowCollection.free;
  if assigned(Document) then
    Document.RemoveTable(self);

  Document:=nil;
  inherited Destroy;

end;
function THTMLTable.RowByName(RowName:string):THTMLRow;
var
  i:integer;
  found:boolean;
begin
  result:=nil;
  found:=false;
  for i:=0 to RowCount-1 do
  begin
    if CompareText(Rows[i].Name,RowName)=0 then
    begin
      result:=Rows[i];
      found:=true;
      break;
    end;
  end;
  if not Found then
     Raise Exception.Create('There is no such Row :'+RowName);
end;

function THTMLTable.CellByName(CellName:string):THTMLCell;
var
  i,k:integer;
  found:boolean;
begin
  result:=nil;
  found:=false;
  for i:=0 to RowCount-1 do
  begin
    for k:=0 to Rows[i].CellCount-1 do
    begin
      if CompareText(Rows[i].Cells[k].Name,CellName)=0 then
      begin
        result:=Rows[i].Cells[k];
        found:=true;
        break;
      end;
    end;
    if Found then Break;
  end;
  if not Found then
     Raise Exception.Create('There is no such Cell :'+CellName);
end;
(*
procedure THTMLTable.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)
Procedure THTMLTable.AddRow(ARow:THTMLRow);
begin
  fRowCollection.InsertItem(ArOW);
end;
procedure THTMLTable.RemoveRow(ARow:THTMLRow);
begin
  fRowCollection.RemoveItem(ARow);
end;
function THTMLTable.RowCount:integer;
begin
  result:=fRowCollection.Count;
end;
function THTMLTable.IndexOfRow(ARow:THTMLRow):integer;
begin
  result:=fRowCollection.IndexOf(ARow);
end;

function  THTMLTable.getCellPadding:integer;
var s:string;
begin
  s:=Attributes['cellpadding'];
  if not TryStrToInt(s,result) then
    result:=2; //default value!!
end;
procedure THTMLTable.setCellPadding(aCP:integer);
begin
  Attributes['cellpadding']:=inttostr(aCP);
end;

function  THTMLTable.getCellSpacing:integer;

var s:string;
begin
  s:=Attributes['cellspacing'];
  if not TryStrToInt(s,result) then
    result:=2; //default value!!
end;

procedure THTMLTable.setCellSpacing(aCS:integer);
begin
  Attributes['cellspacing']:=inttostr(aCS);
end;

function  THTMLTable.getBorder:string;
begin
  result:=Attributes['border'];
end;
procedure THTMLTable.setBorder(aBorder:string);
begin
  Attributes['border']:=aBorder;
end;

function  THTMLTable.getBackground:string;
begin
  result:=Attributes['background'];
end;
procedure THTMLTable.setBackground(p: string);
begin
  Attributes['background'] := p;
end;


function  THTMLTable.getBgColor:string;
begin
  result:=Attributes['bgcolor'];
end;
procedure THTMLTable.setBgColor(p: string);
begin
  Attributes['bgcolor'] := p;
end;

function  THTMLTable.getBorderColor: string;
begin
  result:=Attributes['bordercolor'];
end;
procedure THTMLTable.setBorderColor(p: string);
begin
  Attributes['bordercolor']:=p;
end;

function  THTMLTable.getBorderColorLight: string;
begin
  result:=Attributes['bordercolorlight'];
end;
procedure THTMLTable.setBorderColorLight(p:string);
begin
  Attributes['bordercolorlight']:=p;
end;

function  THTMLTable.getBorderColorDark: string;
begin
  result:=Attributes['bordercolordark'];
end;
procedure THTMLTable.setBorderColorDark(p:string);
begin
  Attributes['bordercolordark']:=p;
end;

function  THTMLTable.getAlign: string;
begin
  result:=Attributes['align'];
end;
procedure THTMLTable.setAlign(p: string);
begin
  Attributes['align']:=p;
end;

{THTMLTables}
Constructor THTMLTables.Create(aOwner:THTMLElement);
begin
  inherited Create(aOwner);
end;
destructor THTMLTables.Destroy;
begin
  inherited destroy;
end;
function THTMLTables.GetTable(index:integer):THTMLTable;
begin
  result:=THTMLTable(GetItem(Index));
end;
procedure THTMLTables.SetTable(index:integer;ATable:THTMLTable);
begin
  SetItem(Index,ATable);
end;
{THTMLFormControl}
procedure THTMLFormControl.SetTabOrder(ATabOrder:integer);
begin
  fTabOrder:=ATabOrder;
end;
function THTMLFormControl.GetValue:string;
begin
  result:=Attributes['value'];
end;
procedure THTMLFormControl.SetValue(AValue:string);
begin
  Attributes['value']:=AValue;
end;
function THTMLFormControl.FindForm(AParentTag:THTMLDOMNode):THTMLForm;
begin
  result:=nil;
  if not assigned(AParentTag) then
    exit;
  if AParentTag is THTMLForm then
  begin
    result:=THTMLForm(AParentTag);
    exit;
  end
  else
    result:=FindForm(AParentTag.ParentNode);
end;
(*
procedure THTMLFormControl.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)
procedure THTMLFormControl.SetForm(AForm:THTMLForm);
begin
  if fForm<>AForm then
  begin
    if assigned(fForm) then
      fForm.RemoveControl(Self);
    fForm:=AForm;
    if assigned(AForm) then
      fForm.AddControl(self);
  end;
end;
constructor THTMLFormControl.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  Form:=FindForm(ParentNode);
  if not assigned(form) then
  if OwnerDocument.FormCount>0 then
    form := OwnerDocument.Forms[OwnerDocument.FormCount-1];
end;
destructor THTMLFormControl.Destroy;
begin
  Form:=nil;//remove itself from forms control array
  inherited Destroy;
end;
(*
procedure THTMLInputControl.ExtractPropValues;
begin
  inherited ExtractPropValues;
  if Props.Values['TabOrder']<>'' then
    trystrtoint(Props.Values['TabOrder'],fTabOrder)
  else
    TabOrder:=0;
  Value:=Props.Values['Value'];
  FValue:=StringReplace(FValue,'''','',[rfReplaceAll, rfIgnoreCase]);
end;
*)
{THTMLInputControl}
function  THTMLInputControl.getAccept:string;
begin
  result:=Attributes['accept'];
end;
procedure THTMLInputControl.setAccept(p:string);
begin
  Attributes['accept']:=p;
end;
function  THTMLInputControl.getAlign:string;
begin
  result:=Attributes['align'];
end;
procedure THTMLInputControl.setAlign(p:string);
begin
  Attributes['align']:=p;
end;
function  THTMLInputControl.getAlt:string;
begin
  result:=Attributes['alt'];
end;
procedure THTMLInputControl.setAlt(p:string);
begin
  Attributes['alt']:=p;
end;
function  THTMLInputControl.getComplete:boolean; //Retrieves whether the object is fully loaded.
begin
  raise exception.Create(sExceptionNotImplemented);
end;
function  THTMLInputControl.getDynSRC:string;
begin
  result:=Attributes['dynsrc'];
end;
procedure THTMLInputControl.setDynSRC(p:string);
begin
  Attributes['dynsrc']:=p;
end;
function  THTMLInputControl.gethSpace:string;
begin
  result:=Attributes['hspace'];
end;
procedure THTMLInputControl.sethSpace(p:string);
begin
  Attributes['hspace']:=p;
end;
function  THTMLInputControl.getLoop:integer;
begin
  if not TryStrToInt(attributes['loop'],result) then
    result:=-1;
end;
procedure THTMLInputControl.setLoop(p:integer);
begin
  if p<>-1 then
    attributes['loop']:=inttostr(p);
end;
function  THTMLInputControl.getLowSRC:string;
begin
  result:=Attributes['lowsrc'];
end;
procedure THTMLInputControl.setLowSRC(p:string);
begin
  Attributes['lowsrc']:=p;
end;
function  THTMLInputControl.getStart:string;
begin
  result:=Attributes['start'];
end;
procedure THTMLInputControl.setStart(p:string);
begin
  Attributes['start']:=p;
end;
function  THTMLInputControl.getUseMAP:string;
begin
  result:=Attributes['usemap'];
end;
procedure THTMLInputControl.setUseMAP(p:string);
begin
  Attributes['usemap']:=p;
end;
function  THTMLInputControl.getVSpace:string;
begin
  result:=Attributes['vspace'];
end;
procedure THTMLInputControl.setVSPace(p:string);
begin
  Attributes['vspace']:=p;
end;

{THTMLEditBox}
function  THTMLEditBox.getSize:integer;
begin
 if not TryStrToInt(attributes['size'],result) then
   result:=-1;//means there is no size specified in tag
end;
procedure THTMLEditBox.setSize(p:integer);
begin
  if p<>-1 then
    attributes['size']:=inttostr(p);
end;
function  THTMLEditBox.get_maxLength:integer;
begin
 if not TryStrToInt(attributes['maxlength'],result) then
   result:=-1;//means there is no maxLength specified in tag
end;
procedure THTMLEditBox.set_maxLength(p:integer);
begin
  if p<>-1 then
    attributes['maxlength']:=inttostr(p);
end;

{THTMLImageControl}
procedure THTMLImageControl.parseValue(var x,y:integer);
var
  t:integer;
  sx:string;
  sy:string;
begin
  if value<>'' then
  begin
    t:=pos('&',value);
    if t>0 then
    begin
      sx:=copy(value,1,t-1);
      if not TryStrToInt(sx,x) then
        x:=0;
      sy:=copy(value,t+1,length(value)-t);
      if not TryStrToInt(sy,y) then
        y:=0;
    end
    else
    begin
      x:=0;
      y:=0;
    end;

  end
  else
  begin
    x:=0;
    y:=0;
  end;
end;
function  THTMLImageControl.getX:integer;
var y:integer;
begin
  ParseValue(result,y);
end;
procedure THTMLImageControl.setX(p:integer);
begin
  value:=inttostr(p)+'&'+inttostr(y);
end;
function  THTMLImageControl.getY:integer;
var x:integer;
begin
  ParseValue(x,result);
end;
procedure THTMLImageControl.setY(p:integer);
begin
  value:=inttostr(x)+'&'+inttostr(p);
end;
function  THTMLImageControl.getSrc:string;
begin
  result:=Attributes['src'];
end;
procedure THTMLImageControl.setSrc(p:string);
begin
  Attributes['src']:=p;
end;


{THTMLForm}
constructor THTMLForm.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  fFormElements:=THTMLElementCollection.Create(self);//contain form controls
  fCheckBoxes:=TObjectList.Create(false);
  Document.AddForm(self);
end;
destructor THTMLForm.destroy;
begin
  fFormElements.Free;
  fCheckBoxes.free;
  Document.RemoveForm(self);
  inherited destroy;
end;
function THTMLForm.ControlCount:integer;
begin
  result:=fFormElements.Count;
end;
function THTMLForm.CheckBoxCount:integer;
begin
  result:=fCheckBoxes.Count;
end;
function THTMLForm.IndexOfControl(AControl:THTMLFormControl):integer;
begin
  result:=fFormElements.IndexOf(AControl);
end;
function THTMLForm.ControlByName(ControlName:string):THTMLFormControl;
var
  i:integer;
  found:boolean;
begin
  result:=nil;
  found:=false;
  for i:=0 to ControlCount-1 do
  begin
    if CompareText(Controls[i].Name,ControlName)=0 then
    begin
      result:=Controls[i];
      found:=true;
      break;
    end;
  end;
  if not Found then
     Raise Exception.Create('There is no such Control :'+ControlName);
end;
function THTMLForm.FindControl(ControlName:string):THTMLFormControl;
var
  i:integer;
begin
  result:=nil;
  for i:=0 to ControlCount-1 do
  begin
    if CompareText(Controls[i].Name,ControlName)=0 then
    begin
      result:=Controls[i];
      break;
    end;
  end;
end;

Function THTMLForm.GetPostVariables:string;
var i:integer;
  procedure Add;
  begin
      result:=result+Controls[i].name+'='+Controls[i].Value;
      if i<ControlCount-1 then
        result:=result+'&';
  end;
begin
  result:='';
  for i:=0 to ControlCount-1 do
  begin

    if Controls[i].name<>'' then
    begin
      if (Controls[i] is THTMLCheckBox) then
      begin
       if (THTMLCheckBox(Controls[i]).Checked) then
         Add;
      end
      else
      if (Controls[i] is THTMLRadioButton) then
      begin
       if (THTMLRadioButton(Controls[i]).Selected) then
         Add;
      end
      else
      begin
        if not (Controls[i] is THTMLFile) then
        Add;
      end;
    end;
  end;
  if length(result)>0 then
  if Result[length(result)]='&' then
    result:=copy(result,1,length(result)-1);
end;
procedure THTMLForm.PreparePostData(parser1:THTMLDecoder);
var
  i:integer;
  fs:TFileStream;
  pFile:pchar;
  fSize:integer;
  s:string;
  pPostData:pchar;
  dwPostDataLength:dword;
  canAdd:boolean;
  fExt:string;
  buf:pchar;
  bufIndex:integer;
  p:pchar;
  function getContentType(ext:string):string;
  begin
    if (comparetext(ext,'.jpg')=0) or (comparetext(ext,'.jpeg')=0) then
      result:='image/pjpeg'
    else
    if (comparetext(ext,'.gif')=0)  then
      result:='image/gif'
    else
    if (comparetext(ext,'.htm')=0)  or (comparetext(ext,'.html')=0)  then
      result:='.text/html'
    else
    if (comparetext(ext,'.txt')=0)  or (comparetext(ext,'.text')=0)  then
      result:='text/plain'
    else
      result:='application/octet-stream';
  end;
begin
  getMem(buf,4*1024*1024);
  bufIndex:=0;
  try
  if method=fmPost then
  begin
    //TInternetHTTPRequest(document.location.fLoader).Referrer:=Document.referrer;
    TInternetHTTPRequest(parser1.document.location.fLoader).PostEnctype:='application/x-www-form-urlencoded';
    if comparetext(trim(Enctype),'multipart/form-data')=0 then
    begin
      TInternetHTTPRequest(parser1.document.location.fLoader).PostEnctype:='multipart/form-data; boundary=AaB03x';
      for i:=0 to ControlCount-1 do
      begin
        if Controls[i] is THTMLFile then
        begin
          if THTMLFile(Controls[i]).FileName<>'' then
          begin
            fExt:=ExtractFileExt(THTMLFile(Controls[i]).FileName);
            fs:=TFileStream.create(UploadFilename,fmOpenRead, fmShareDenyNone);
            try
              GetMem(pFile,1000000);
              try
                fSize:=fs.Read(pFile^,1000000);
                if fSize=0 then RaiseLastOSError;
                s:='';
                s:=s+'--AaB03x'+#$D+#$A;
                s:=s+format('Content-Disposition: form-data; name="%s"; filename="%s"',[Controls[i].Name, THTMLFile(Controls[i]).FileName])+#$D+#$A;
                s:=s+'Content-Type: '+getContentType(fExt)+#$D+#$A;
                s:=s+'Content-Transfer-Encoding: binary'+#$D+#$A+#$D+#$A;
                p:=buf+bufIndex;
                StrPCopy(p,s);
                //move(buf[bufIndex],s,length(s));
                inc(bufIndex,length(s));
                p:=buf+bufIndex;
                move(pFile^,p^,fSize);
                inc(bufIndex,fSize);
                p:=buf+bufIndex;
                StrPCopy(p,#$D+#$A);
                inc(bufIndex,2);
                //s:=s+string(pFile)+#$D+#$A;
              finally
                FreeMem(pFile);
              end;
            finally
              fs.free;
            end;
          end;
        end
        else
        begin
          canAdd:=false;
          if Controls[i].name<>'' then
          begin

            if (Controls[i] is THTMLCheckBox) then
            begin
             if (THTMLCheckBox(Controls[i]).Checked) then
               canAdd:=true;
            end
            else
            if (Controls[i] is THTMLRadioButton) then
            begin
             if (THTMLRadioButton(Controls[i]).Selected) then
               canAdd:=true;
            end
            else
              canAdd:=true;
          end;
          if Controls[i] is THTMLResetButton then
            canAdd:=false;
          if canAdd then
          begin
            s:='';
            s:=s+'--AaB03x'+#$D+#$A;
            s:=s+format('Content-Disposition: form-data; name="%s"',[Controls[i].Name])+#$D+#$A+#$D+#$A;
            s:=s+Controls[i].Value+#$D+#$A;
            p:=buf+bufIndex;
            StrPCopy(p,s);
            inc(bufIndex,length(s));
          end;
        end;

      end;
      s:='--AaB03x--'+#$D+#$A;
      p:=buf+bufIndex;
      StrPCopy(p,s);
      inc(bufIndex,length(s));
    end
    else
    begin
      s:=GetPostVariables;
      StrPCopy(buf,s);
      inc(bufIndex,length(s));
    end;
    //GetMem(pPostData,length(s)+1);
    //Move(s,pPostData,length(s));
    //StrPCopy(pPostData,s);
    GetMem(pPostData,bufIndex+1);
    Move(buf^,pPostData^,bufIndex+1);

    dwPostDataLength:=bufIndex+1;
    TInternetHTTPRequest(parser1.document.location.fLoader).UploadData:=pPostData;
    TInternetHTTPRequest(parser1.document.location.fLoader).UploadDataSize:=dwPostDataLength;
  end
  else
  begin
      s:=GetPostVariables;
      s:=DecodeHTMLText(s);
      if pos('UTF-8',uppercase(Document.contentType))>0 then
         s:=utf8Encode(s);
      s:='?'+TIdURI.URLEncode(s);

      Document.location.Set_search(s);
      TInternetHTTPRequest(parser1.document.location.fLoader).UploadData:=nil;
      TInternetHTTPRequest(parser1.document.location.fLoader).UploadDataSize:=0;
  end;
  finally
    freeMem(buf);
  end;
end;
procedure THTMLForm.submit;
var
  //data:string;
  url:string;
begin
 //data:=GetPostVariables;
 if assigned(document) then
 begin
   url:=document.getAbsoluteURL(action);
   PreparePostData(document.Decoder);
   //document.location.PostBuffer:=data;
   //TInternetHTTPRequest(document.location.fLoader).PostEnctype:=EncType;


   //document.location.Filename:=UploadFileName;
   //document.location.Loader.Redirecting:=true;
   try
     if method=fmGet then
     url:=url+document.location.search;

     document.location.href:=url;
   finally
     //document.location.Loader.Redirecting:=false;
   end;
 end;
end;
procedure THTMLForm.submit(parser:THTMLDecoder);
var
  //data:string;
  url:string;
begin
  if not assigned(parser) then
    exit;
 //data:=GetPostVariables;
 if assigned(document) then
 begin
   url:=document.getAbsoluteURL(action);
   PreparePostData(parser);
   //document.location.PostBuffer:=data;
   //TInternetHTTPRequest(document.location.fLoader).PostEnctype:=EncType;


   //document.location.Filename:=UploadFileName;
   //document.location.Loader.Redirecting:=true;
   try
     if method=fmGet then
     url:=url+document.location.search;

     parser.url:=url;
   finally
     //document.location.Loader.Redirecting:=false;
   end;
 end;
end;

procedure THTMLForm.AddControl(AControl:THTMLFormControl);
begin
  fFormElements.InsertItem(AControl);
  if AControl is THTMLCheckBox then
    fCheckBoxes.Add(AControl);
end;

procedure THTMLForm.RemoveControl(AControl:THTMLFormControl);
begin
  fFormElements.RemoveItem(AControl);
  if AControl is THTMLCheckBox then
    fCheckBoxes.Remove(AControl);
end;
function THTMLForm.GetCheckBox(index:integer):THTMLCheckBox;
begin
  result:=THTMLCheckBox(fCheckBoxes[index]);
end;
procedure THTMLForm.SetCheckBox(index:integer;ACheckBox:THTMLCheckBox);
begin
  fCheckBoxes[index]:=ACheckBox;
end;
function  THTMLForm.GetMethod:THTMLFormMethods;
begin
  result:=getFormMethod(Attributes['Method']);
end;
procedure THTMLForm.SetMethod(AMethod:THTMLFormMethods);
var
  i:THTMLFormMethods;
  MethodStr:String;
begin
  for i:=low(THTMLFormMethods) to high(THTMLFormMethods) do
    if i=aMethod then
    begin
      MethodStr:=c_HTMLFormMethods[i];
      break;
    end;
  Attributes['method']:=MethodStr;
end;
function  THTMLForm.GetAction:string;
begin
  result:=Attributes['action'];
end;
procedure THTMLForm.SetAction(AAction:string);
begin
  Attributes['action']:=AAction;
end;

procedure THTMLForm.Set_dir(const p: string);
begin
  Attributes['dir']:=p;
end;
function  THTMLForm.Get_dir: string;
begin
  result:=Attributes['dir'];
end;

procedure THTMLForm.Set_encoding(const p: string);
begin
  Attributes['encoding']:=p;
end;
function  THTMLForm.Get_encoding: string;
begin
  result:=Attributes['encoding'];
end;
function  THTMLForm.getEncType:string;
begin
  result:=Attributes['enctype'];
end;
procedure THTMLForm.setEncType(p: string);
begin
  Attributes['enctype']:=p;
end;

function  THTMLForm.Get_elements: THTMLElementCollection;
begin
  result:=fFormElements;
end;

procedure THTMLForm.Set_target(const p: string);
begin
  Attributes['target']:=p;
end;
function  THTMLForm.Get_target: string;
begin
  result:=Attributes['target'];
end;

procedure THTMLForm.Set_onsubmit(p: string);
begin
  Attributes['onsubmit']:=p;
end;
function  THTMLForm.Get_onsubmit: string;
begin
  result:=Attributes['onsubmit'];
end;

procedure THTMLForm.Set_onreset(p: string);
begin
  Attributes['onreset']:=p;
end;
function  THTMLForm.Get_onreset: string;
begin
  result:=Attributes['onreset'];
end;
(*
procedure THTMLForm.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)
procedure THTMLForm.SetControl(index:integer;AControl:THTMLFormControl);
begin
  fFormElements[index]:=AControl;
end;
function THTMLForm.GetControl(index:integer):THTMLFormControl;
begin
  result:=THTMLFormControl(fFormElements[index]);
end;
{THTMLHeader}
procedure THTMLHeader.SetTitle(ATitle:string);
begin
  FTitle:=ATitle;
end;
function THTMLHeader.GetTitle:string;
var
  i:integer;
begin
  result:='';
  for i:=0 to ChildElementCount-1 do
    if ChildTags[i] is THTMLTitle then
    begin
      Result:=ChildTags[i].outerText;
      break;
    end;
end;

constructor THTMLHeader.create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  fVariables:=TObjectList.Create(false);
  if assigned(Document) then
    Document.Header:=self;
end;
destructor THTMLHeader.destroy;
begin
  fVariables.free;
  if assigned(Document) then
    Document.Header:=nil;
  inherited destroy;
end;
(*
procedure THTMLHeader.ExtractPropValues;
begin
  inherited ExtractPropValues;
end;
*)
procedure THTMLHeader.AddVariable(aVar:THTMLMeta);
var
  s:string;
  sList:TStringList;
  i:integer;
begin
  fVariables.Add(AVar);
  if assigned(aVar) then
  begin
    if CompareText(aVar.HttpEquiv,'REFRESH')=0 then
    begin
      s:=aVar.Content;
      sList:=TStringList.Create;
      try
        s:=StringReplace(s,';',#$D+#$A,[rfReplaceAll, rfIgnoreCase]);
        sList.Text:=s;
        for i:=0 to sList.Count-1 do
        begin
         s:=sList[i];
         if i=0 then
           TryStrToInt(s,fRefreshInterval);
         if pos('URL=',uppercase(s))>0 then
           RefreshURL:=StringReplace(s,'url=','',[rfReplaceAll, rfIgnoreCase]);
        end;
      finally
        sList.free;
      end;
    end;
  end;
end;
procedure THTMLHeader.RemoveVariable(aVar:THTMLMeta);
begin
  fVariables.Remove(aVar);
end;
function THTMLHeader.VariableCount:integer;
begin
  result:=fVariables.Count;
end;
function THTMLHeader.GetVariable(index:integer):THTMLMeta;
begin
  result:=THTMLVariable(fVariables[index]);
end;
procedure THTMLHeader.SetVariable(index:integer;aVar:THTMLMeta);
begin
  fVariables[index]:=aVar;
end;
function  THTMLHeader.getRefreshURL:string;
begin
  result:=Document.getAbsoluteURL(fRefreshURL);
end;
function  THTMLHeader.getRefreshInterval:integer;
var
  aVar:THTMLMeta;
  i,j:integer;
  s:string;
  sList:TStringList;
begin
  result:=-1;
  for j:=0 to all.count-1 do
  if All[j] is THTMLMeta then
  begin
   aVar:=THTMLMeta(All[j]);
    if assigned(aVar) then
    begin
      if CompareText(aVar.HttpEquiv,'REFRESH')=0 then
      begin
        s:=aVar.Content;
        sList:=TStringList.Create;
        try
          s:=StringReplace(s,';',#$D+#$A,[rfReplaceAll, rfIgnoreCase]);
          sList.Text:=s;
          for i:=0 to sList.Count-1 do
          begin
           s:=sList[i];
           if pos('URL=',uppercase(s))>0 then
             fRefreshURL:=StringReplace(s,'url=','',[rfReplaceAll, rfIgnoreCase]);
           if i=0 then
             if not TryStrToInt(s,result) then
               result:=-1;
             //  break;
          end;
        finally
          sList.free;
        end;
      end;
    end;
   end;
end;
procedure THTMLHeader.setRefreshInterval(p:integer);
begin
end;

{THTMLBody}
constructor THTMLBody.create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  if assigned(Document) then
    Document.Body:=self;
end;
destructor THTMLBody.destroy;
begin
  if assigned(Document) then
    Document.Body:=nil;
  inherited destroy;
end;
{THTMLDocument}
function  THTMLDocument.GetFormattedTagStr(IndentCount:integer;Indent_Ch:char;TagStrType:TTagStrTypes):string;
begin
  result:=TagStr;
end;
function THTMLDocument.GetHeader:THTMLHeader;
var i:integer;
begin
  result:=fHeader;
  if not assigned(result) then
  for i:=0 to All.Count-1 do
  begin
    if All[i].ClassType=THTMLHeader then
    begin
      result:=THTMLHeader(All[i]);
      break;
    end;
  end;
end;

{THTMLFrameSet}
constructor THTMLFrameSet.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  fFrameCollection:=THTMLFramesCollection.Create(self);
  Document.Frameset:=self;
end;
destructor THTMLFrameSet.destroy;
begin
  Document.Frameset:=nil;
  fFrameCollection.Free;
  inherited Destroy;
end;
(*
procedure THTMLFrameSet.ExtractPropValues;
begin
  Inherited ExtractPropValues;
end;
*)
procedure THTMLFrameSet.AddFrame(aFrame:THTMLFrame);
begin
  fFrameCollection.InsertItem(aFrame);
end;

procedure THTMLFrameSet.RemoveFrame(aFrame:THTMLFrame);
begin
  fFrameCollection.RemoveItem(aFrame);
end;

function THTMLFrameSet.GetFrame(index:integer):THTMLFrame;
begin
  result:=THTMLFrame(fFrameCollection[index]);
end;

procedure THTMLFrameSet.SetFrame(index:integer; aFrame:THTMLFrame);
begin
  fFrameCollection[index]:=aFrame;
end;
function THTMLFrameSet.Count:integer;
begin
  result:=fFrameCollection.Count;
end;

function  THTMLFrameSet.getFrameSpacing:string;
begin
  result:=Attributes['framespacing'];
end;
procedure THTMLFrameSet.setFrameSpacing(p: string);
begin
  Attributes['framespacing']:=p;
end;

function  THTMLFrameSet.getFrameBorder:string;
begin
  result:=Attributes['frameborder'];
end;
procedure THTMLFrameSet.setFrameBorder(p: string);
begin
  Attributes['frameborder']:=p;
end;

function  THTMLFrameSet.getBorder:string;
begin
  result:=Attributes['border'];
end;
procedure THTMLFrameSet.setBorder(p: string);
begin
  Attributes['border']:=p;
end;

function  THTMLFrameSet.getRows:string;
begin
  result:=Attributes['rows'];
end;
procedure THTMLFrameSet.setfRows(p: string);
begin
  Attributes['rows']:=p;
end;

function  THTMLFrameSet.getWidth:string;
begin
  result:=Attributes['width'];
end;
procedure THTMLFrameSet.setWidth(p: string);
begin
  Attributes['width']:=p;
end;
{THTMLFrame}
constructor THTMLFrame.Create(OwnerDocument:THTMLDocument;OwnerCollection:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,OwnerCollection);
  fFrameDocument:=THTMLDocument.Create(Document,All);
  fFrameDocument.AutoLoad:=false;
  fFrameDocument.AutoParse:=false;
  fFrameDocument.OnProgress:=Document.OnProgress;
  childs.InsertItem(fFrameDocument);
  if assigned(Document) then
    Document.Frames.InsertItem(self);
  if assigned(Owner) then
    if assigned(Owner.OwnerNode) then
      if Owner.OwnerNode is THTMLFrameSet then
      begin
        FrameSet:=THTMLFrameSet(Owner.OwnerNode);
      end;
end;
destructor THTMLFrame.destroy;
begin
  childs.RemoveItem(fFrameDocument);
  fFrameDocument.Free;

  if assigned(Document) then
      Document.Frames.RemoveItem(self);
  if assigned(FrameSet) then
    FrameSet:=NIL;
  inherited destroy;
end;

procedure THTMLFrame.Load;
begin
  FrameDoc.Load;
end;
procedure THTMLFrame.Parse;
begin
  FrameDoc.Parse;
end;
(*
procedure THTMLFrame.ExtractPropValues;
begin
  Inherited ExtractPropValues;
end;
*)
procedure THTMLFrame.SetFrameSet(AFrameSet:THTMLFrameSet);
begin
  if fFrameSet<>AFrameSet then
  begin
    if assigned(fFrameSet) then
      fFrameSet.RemoveFrame(Self);
    fFrameSet:=AFrameSet;
    if assigned(AFrameSet) then
      fFrameSet.AddFrame(self);
  end;
end;

function  THTMLFrame.getSrc:string;
begin
  //result:=Document.getAbsoluteURL(lowercase(Attributes['src']));
  result:=Document.getAbsoluteURL(Attributes['src']);
end;
procedure THTMLFrame.setSrc(p: string);
var hRef:string;
begin
  Attributes['src']:=lowercase(p);
  if assigned(Document) then
  if not Document.EditMode then
  begin
    hRef:=Document.getAbsoluteURL(p);
    FrameDoc.location.href:=hRef;
    if Document.AutoLoadFrames then
      FrameDoc.Load;
    if Document.AutoParseFrames then
      FrameDoc.Parse;
  end;
end;

function  THTMLFrame.getScrolling:string;
begin
  result:=Attributes['scrolling'];
end;
procedure THTMLFrame.setScrolling(p:string);
begin
  Attributes['scrolling']:=p;
end;
function  THTMLFrame.Get_outerHTML:string;
begin
  result:=inherited get_outerHTML;
end;
function  THTMLFrame.Get_innerHTML:string;
begin
  result:='';
end;
function  THTMLFrame.getAutoLoadInnerFrames:boolean;
begin
  result:=FrameDoc.AutoLoadFrames;
end;
procedure THTMLFrame.setAutoLoadInnerFrames(p:boolean);
begin
  FrameDoc.AutoLoadFrames:=p;
  FrameDoc.AutoLoad:=p;
end;
function  THTMLFrame.getAutoParseInnerFrames:boolean;
begin
  result:=FrameDoc.AutoParseFrames;
end;
procedure THTMLFrame.setAutoParseInnerFrames(p:boolean);
begin
  FrameDoc.AutoParseFrames:=p;
  FrameDoc.AutoParse:=p;
end;
function  THTMLFrame.getLoaded:boolean;
begin
  result:=FrameDoc.Loaded;
end;

{THTMLOmNavigator}
function  THTMLOmNavigator.Get_appCodeName: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_appName: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_appVersion: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_userAgent: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_cookieEnabled: boolean;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_javaEnabled: boolean;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_taintEnabled: boolean;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_mimeTypes: THTMLMimeTypesCollection;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_plugins: THTMLPluginsCollection;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_opsProfile: THTMLOpsProfile;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_toString: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_cpuClass: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_systemLanguage: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_browserLanguage: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_userLanguage: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_platform: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_appMinorVersion: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_connectionSpeed: Integer;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_onLine: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLOmNavigator.Get_userProfile: THTMLOpsProfile;
begin
  raise Exception.Create('Not Implemented');
end;
{THTMLWindow}
function  THTMLWindow.Get_frames: THTMLFramesCollection;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_defaultStatus(const p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_defaultStatus: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_status(const p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_status: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_Image: THTMLImageElementFactory;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_location: THTMLLocation;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_history: THTMLOmHistory;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_opener(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_opener: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_navigator: THTMLOmNavigator;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_name(const p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_name: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_parent: THTMLWindow;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_self: THTMLWindow;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_top: THTMLWindow;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_window: THTMLWindow;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onfocus(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onfocus: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onblur(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onblur: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onload(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onload: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onbeforeunload(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onbeforeunload: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onunload(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onunload: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onhelp(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onhelp: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onerror(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onerror: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onresize(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onresize: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_onscroll(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_onscroll: string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_document: THTMLDocument;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_event: THTMLEventObj;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get__newEnum: IUnknown;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_screen: THTMLScreen;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_Option: THTMLOptionElementFactory;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_closed: boolean;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_external: IDispatch;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_clientInformation: THTMLOmNavigator;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.Set_offscreenBuffering(p: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.Get_offscreenBuffering: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.close;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.open(const url: string; const name: string; const features: string;
               replace: boolean): THTMLWindow;
begin
  raise Exception.Create('Not Implemented');
end;

procedure THTMLWindow.navigate(const url: string);
begin
  raise Exception.Create('Not Implemented');
end;

function  THTMLWindow.setTimeout(const expression: string; msec: Integer; var language: string): Integer;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.clearTimeout(timerID: Integer);
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.alert(const message: string);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.confirm(const message: string): boolean;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.prompt(const message: string; const defstr: string): string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.showModalDialog(const dialog: string; var varArgIn: string;
                          var varOptions: string): string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.showHelp(const helpURL: string; helpArg: string; const features: string);
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.focus;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.blur;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.scroll(x: Integer; y: Integer);
begin
  raise Exception.Create('Not Implemented');
end;

function  THTMLWindow.setInterval(const expression: string; msec: Integer; var language: string): Integer;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.clearInterval(timerID: Integer);
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.execScript(const code: string; const language: string): string;
begin
  raise Exception.Create('Not Implemented');
end;
function  THTMLWindow.toString: string;
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.scrollBy(x: Integer; y: Integer);
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.scrollTo(x: Integer; y: Integer);
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.moveTo(x: Integer; y: Integer);
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.moveBy(x: Integer; y: Integer);
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.resizeTo(x: Integer; y: Integer);
begin
  raise Exception.Create('Not Implemented');
end;
procedure THTMLWindow.resizeBy(x: Integer; y: Integer);
begin
  raise Exception.Create('Not Implemented');
end;

{THTMLLocation}
constructor THTMLLocation.Create(aDocument:THTMLDocument);
begin
  inherited Create;
  //fBuffer := TMemoryStream.Create;

  fSession:= TInternetSession.Create(nil);
  fSession.AccessType:=atPreConfig;
  fConnection:= TInternetConnection.Create(nil);
  fConnection.Session:=fSession;
  fLoader := TInternetHTTPRequest.Create(nil);
  fLoader.Connection:=fConnection;
  TInternetHTTPRequest(fLoader).opKeepConnection:=true;

  fDocument:=aDocument;
  fLoader.OnLoaded:=doOnLoaded;
end;
destructor  THTMLLocation.Destroy;
begin
  {fLoader.CloseRequest;
  fLoader.Free;
  fConnection.Disconnect;
  fConnection.free;
  fConnection:=nil;
  }
  fSession.Close;
  fSession.Free;
  fSession:=nil;
  fLoader:=nil;
  //if assigned(fBuffer) then
  //  fBuffer.Free;
  inherited Destroy;
end;
procedure THTMLLocation.Set_href(const p: string); //Sets the entire URL as a string and Causes new url to be loaded.This will replace current document with new one!
begin
  if assigned(fLoader) then
  begin
    fLoader.FileToUpload:=filename;
    fLoader.URL:=p;
  end;
  if assigned(Document) then
  begin

    if assigned(Document.ParentElement) and
       assigned(Document.ParentElement.Document) and
       assigned(Document.ParentElement.Document.location) and
       assigned(Document.ParentElement.Document.location.Loader) and
       (compareText(Document.ParentElement.Document.location.Loader.Server,fLoader.Server)=0) then
         fLoader.Connection:=Document.ParentElement.Document.location.Loader.Connection
       else
       if assigned(fConnection) then
         fLoader.Connection:=fConnection;
    if Document.AutoLoad then
      reLoad(false);
  end;
end;
function  THTMLLocation.Get_href: string;//Retrieves the entire URL as a string.
begin
  if assigned(fLoader) then
    result:=fLoader.URL;
end;

procedure THTMLLocation.Set_protocol(const p: string);//Sets the protocol portion of a URL.
var
  t: TInternetSchemes;
  found:boolean;
begin
  found:=false;
  for t:=low(TInternetSchemes) to high(TInternetSchemes) do
  begin
    if CompareText(c_InternetSchemeIDs[t],p)=0 then
    found:=true;
    fLoader.Scheme:=t;
  end;
  if not found then
    raise EInvalidScheme.Create(format(sExceptionUnknownScheme,[p]));


end;
function  THTMLLocation.Get_protocol: string;//Retireves the protocol portion of a URL.
begin
  result:=c_InternetSchemeIDs[fLoader.Scheme];
end;

procedure THTMLLocation.Set_host(const p: string);//Sets the hostname and port number of the location or URL.
var
  host,port:string;
  nPort:integer;
  t:integer;
begin
  t:=Pos(':',p);
  if t>0 then
  begin
    host:=copy(p,1,t-1);
    port:=copy(p,t+1,length(p)-t);
    fLoader.Server:=host;
    if TryStrToInt(port,nPort) then
      fLoader.Port:=nPort;
  end
  else
    fLoader.Server:=p;
end;
function  THTMLLocation.Get_host: string;//Retrieves the hostname and port number of the location or URL.
begin
  if c_InternetDefaultSchemePorts[fLoader.Scheme]<>fLoader.Port then
    result:=fLoader.Server+':'+inttostr(fLoader.Port)
  else
    result:=fLoader.Server;
end;

procedure THTMLLocation.Set_hostname(const p: string);//Sets the host name part of the location or URL.
begin
 fLoader.Server:=p;
end;
function  THTMLLocation.Get_hostname: string;//Retrieves the host name part of the location or URL.
begin
  result:=fLoader.Server;
end;

procedure THTMLLocation.Set_port(const p: string);//Sets the port number associated with a URL.
var nPort:integer;
begin
  if TryStrToInt(p,nPort) then
    fLoader.Port:=nPort;
end;
function  THTMLLocation.Get_port: string;//Retrieves the port number associated with a URL.
begin
  result:=inttostr(fLoader.Port);
end;

procedure THTMLLocation.Set_pathname(const p: string);//Sets the file name or path specified by the object.
begin
  fLoader.ObjectName:=p;
end;
function  THTMLLocation.Get_pathname: string;//Retrieves the file name or path specified by the object.
begin
  result:=fLoader.ObjectName;
end;

procedure THTMLLocation.Set_search(const p: string);//Sets the substring of the href property that follows the question mark.
begin
  fLoader.ExtraInfo:=p;
end;
function  THTMLLocation.Get_search: string;//Retrieves the substring of the href property that follows the question mark.
begin
  result:=fLoader.ExtraInfo;
end;

procedure THTMLLocation.Set_hash(const p: string);//Sets the subsection of the THTMLAnchor.href property that follows the number sign (#).
begin
  fLoader.ExtraInfo:=p;
end;

function  THTMLLocation.Get_hash: string;//Retrieves the subsection of the THTMLAnchor.href property that follows the number sign (#).
begin
  result:=fLoader.ExtraInfo;
end;
function  THTMLLocation.getReferrer:string;
begin
  result:=fReferrerOut;
end;

procedure THTMLLocation.setReferrer(p:string);
begin
  fReferrerIn:=p;
end;

procedure THTMLLocation.doOnLoaded(Sender:TObject;hInet:HINTERNET; Stream:TStream);
var ss:TStringStream;
s: utf8String;s2:string;

begin
  try
    Stream.Seek(0,soBeginning);
    ss:=TStringStream.Create('');
    try
      TMemoryStream(Stream).SaveToStream(ss);
      if assigned(Document) then
      begin
        if assigned(document.fOldOnLoaded) then
          document.fOldOnLoaded(Sender,hInet,ss);
        Document.doProgress(sEventDocDownloaded,100,100);
        s:=ss.DataString;

        if pos('utf-8', s)>0 then
        begin

          s2:=UTF8StringToLongString(s);

          Document.LoadHTML(s2,TrytoFixProblems);
        end
        else
         Document.LoadHTML(s,TrytoFixProblems);

      end;
    finally
      ss.Free;
    end;
  finally
    {if not Connection.Redirecting then
    begin
      try
        Buffer.Free; //which is equivalent to stream var here
      finally
        fBuffer:=nil;
      end;
    end;
    }
  end;

end;

procedure THTMLLocation.reload(flag: Boolean);
var
  fBuffer      : TMemoryStream;
begin
  try
    if assigned(document) and
       assigned(document.parentElement) and
       assigned(document.parentElement.document) and
       assigned(document.parentElement.document.location) and
       assigned(document.parentElement.document.location.Loader) and
       assigned(document.parentElement.document.location.Loader.Connection) then
       begin
         if Loader is TInternetHTTPRequest then
           TInternetHTTPRequest(Loader).opKeepConnection:=true;
         Loader.Connection:=document.document.location.Loader.Connection
       end
       else
       if assigned(fConnection) then
         Loader.Connection:=fConnection;
    if Loader is TInternetHTTPRequest then
    begin
      TInternetHTTPRequest(Loader).Referrer:=fReferrerIn;
      fReferrerOut:=fReferrerIn;
      fReferrerIn:='';
      if assigned(TInternetHTTPRequest(Loader).UploadData) then
      begin
        //TInternetHTTPRequest(Loader).PostData:=PostBuffer;
        //TInternetHTTPRequest(Loader).FileToUpload:=Filename;
        TInternetHTTPRequest(Loader).Method:=hmPOST;
      end
      else
      begin
        //TInternetHTTPRequest(Loader).PostData:='';
        TInternetHTTPRequest(Loader).Method:=hmGET;
      end;

    end;
    if fLoader.Active then
    begin
     fLoader.CloseRequest;
     if fLoader.Connection.Connected then
      fLoader.Connection.Connected:=false;
    end;
    fLoader.OpenRequest;
    {if assigned(Buffer) then
    begin
      Buffer.Free;
      fBuffer:=nil;
    end;}
    fBuffer:=TMemoryStream.Create;
    try
      fLoader.SendRequest(fBuffer);
    finally
      fBuffer.Free;
      //fBuffer:=nil;
    end;

  finally
    fPostBuffer:='';
  end;
end;
procedure THTMLLocation.replace(const bstr: string);
begin
end;
procedure THTMLLocation.Assign_(const bstr: string);
begin
end;
function  THTMLLocation.toString: string;
begin
  result:='[object:THTMLLocation]';
end;

//event handler helpers

function  THTMLLocation.getOnProgress:TInternetOnProgressEvent;
begin
  result:=fLoader.OnProgress;
end;
procedure THTMLLocation.setOnProgress(p:TInternetOnProgressEvent);
begin
  fLoader.OnProgress:=p;
end;
function  THTMLLocation.getOnRedirect:TInternetOnRedirectEvent;
begin
  result:=fLoader.OnRedirect;
end;
procedure THTMLLocation.setOnRedirect(p:TInternetOnRedirectEvent);
begin
  fLoader.OnRedirect:=p;
end;

(*
function  THTMLLocation.getOnResume:TOnResumeEvent;
begin
  result:=fLoader.OnResume;
end;
procedure THTMLLocation.setOnResume(p:TOnResumeEvent);
begin
  fLoader.OnResume:=p;
end;

function  THTMLLocation.getBeginningTransAction:TBeginningTransActionEvent;
begin
  result:=fLoader.OnBeginningTransaction;
end;
procedure THTMLLocation.setBeginningTransAction(p:TBeginningTransActionEvent);
begin
  fLoader.OnBeginningTransaction:=p;
end;

function  THTMLLocation.getOnResponse:TOnResponseEvent;
begin
  result:=fLoader.OnResponse;
end;
procedure THTMLLocation.setOnResponse(p:TOnResponseEvent);
begin
  fLoader.OnResponse:=p;
end;

function  THTMLLocation.getOnAuthenticate:TAuthenticateEvent;
begin
  result:=floader.OnAuthenticate;
end;
procedure THTMLLocation.setOnAuthenticate(p:TAuthenticateEvent);
begin
  floader.OnAuthenticate:=p;
end;

function  THTMLLocation.getOnComplete:TOnCompleteEvent;
begin
  result:=fLoader.OnComplete;
end;
procedure THTMLLocation.setOnComplete(p:TOnCompleteEvent);
begin
  fLoader.OnComplete:=p;
end;

function  THTMLLocation.getOnData:TOnDataEvent;
begin
  result:=fLoader.OnData;
end;
procedure THTMLLocation.setOnData(p:TOnDataEvent);
begin
  fLoader.OnData:=p;
end;

function  THTMLLocation.getGetwindow:TGetWindowEvent;
begin
  result:=fLoader.OnGetWindow;
end;
procedure THTMLLocation.setGetwindow(p:TGetWindowEvent);
begin
  fLoader.OnGetWindow:=p;
end;

function  THTMLLocation.getOnSecurityProblem:TOnSecurityProblemEvent;
begin
  result:=fLoader.OnSecurityProblem;
end;
procedure THTMLLocation.setOnSecurityProblem(p:TOnSecurityProblemEvent);
begin
  fLoader.OnSecurityProblem:=p;
end;
  *)

{THTMLDocument}
function THTMLDocument.GetBody:THTMLBody;
var i:integer;
begin
  result:=fBody;
  if not assigned(result) then
  for i:=0 to ChildElementCount-1 do
  begin
    if All[i].ClassType=THTMLBody then
    begin
      result:=THTMLBody(All[i]);
      break;
    end;
  end;
end;

function THTMLDocument.GetTitle:string;
begin
  if assigned(header) then
    result:=header.Title;
end;
procedure THTMLDocument.SetHeader(AHeader:THTMLHeader);
begin
  fHeader:=aHeader;
end;
procedure THTMLDocument.SetBody(ABody:THTMLBody);
begin
  if assigned(ABody) then
    BaseHRef:=location.href;
//  else
//  if (not assigned(fBody)) and (not assigned(aBody)) then
//    Raise Exception.Create(sExceptionInvalidBodyElement);
  fBody:=ABody;
end;
procedure THTMLDocument.SetTitle(ATitle:string);
begin
  if assigned(header) then
    header.Title:=ATitle;
end;
constructor THTMLDocument.Create(OwnerDocument:THTMLDocument;BelongTo:THTMLElementCollection);
begin
  inherited Create(OwnerDocument,BelongTo);
  fRawHTML:=TStringList.Create;
  fAutoLoad:=True;
  fAutoParse:=True;
  fAutoLoadFrames:=false;
  fAutoParseFrames:=false;
  fReFormatOutputHTML:=true;
  TagStr:='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.02 Transitional//EN">';
  fLocation         := THTMLLocation.create(self);
  fFrameSet         := THTMLFrameSet.Create(self,childs);
  fFrameCollection  := THTMLFramesCollection.Create(self);
  fFormCollection   := THTMLFormCollection.Create(self);
  fTableCollection  := THTMLTableCollection.Create(self);
  fAnchorCollection := THTMLAnchorCollection.Create(self);
  fImageCollection  := THTMLImageCollection.Create(self);
  fStylesCollection := THTMLStyleSheetsCollection.Create(self);
  fScriptsCollection:= THTMLScriptsCollection.Create(self);

end;
destructor THTMLDocument.destroy;
begin
  if assigned(body) then
    body.free;
  if assigned(header) then
    header.free;
  fBody:=nil;
  fHeader:=nil;
  fFrameCollection.free;
  fFormCollection.free;
  fTableCollection.free;
  fAnchorCollection.Free;
  fImageCollection.Free;
  fStylesCollection.Free;
  fScriptsCollection.Free;
  fFrameSet.free;
  fLocation.Free;
  fRawHTML.Free;
  if assigned(fParser) then
  begin
    fParser.Free;
    fParser:=nil;
  end;
  inherited Destroy;
end;
procedure THTMLDocument.LoadHTML(HtmlCode:string;TrytoFixProblems:boolean);
begin
  RawHTML.Text:=HtmlCode;
  fTrytoFixProblems:=TrytoFixProblems;
  All.Clear(True);
  Childs.Clear(True);
  if AutoParse then
    Parse;
end;
procedure THTMLDocument.AddTable(ATable:THTMLTable);
begin
  fTableCollection.InsertItem(ATable);
end;
procedure THTMLDocument.RemoveTable(ATable:THTMLTable);
begin
  fTableCollection.RemoveItem(ATable);
end;
procedure THTMLDocument.AddForm(AForm:THTMLForm);
begin
  fFormCollection.InsertItem(AForm);
end;
procedure THTMLDocument.RemoveForm(AForm:THTMLForm);
begin
  fFormCollection.RemoveItem(AForm);
end;

procedure THTMLDocument.AddAnchor(aAnchor:THTMLAnchor);
begin
  fAnchorCollection.InsertItem(aAnchor);
end;
procedure THTMLDocument.RemoveAnchor(aAnchor:THTMLAnchor);
begin
  fAnchorCollection.RemoveItem(aAnchor);
end;
procedure THTMLDocument.AddImage(aImage:THTMLImage);
begin
  fImageCollection.InsertItem(aImage);
end;
procedure THTMLDocument.RemoveImage(aImage:THTMLImage);
begin
  fImageCollection.RemoveItem(aImage);
end;

procedure THTMLDocument.AddStyleSheet(aStyleSheet:THTMLStyleElement);
begin
  fStylesCollection.InsertItem(aStyleSheet);
end;

procedure THTMLDocument.RemoveStyleSheet(aStyleSheet:THTMLStyleElement);
begin
  fStylesCollection.RemoveItem(aStyleSheet);
end;

procedure THTMLDocument.AddScript(aScript:THTMLScript);
begin
  fScriptsCollection.InsertItem(aScript);
end;

procedure THTMLDocument.RemoveScript(aScript:THTMLScript);
begin
  fScriptsCollection.RemoveItem(aScript);
end;

function  THTMLDocument.getBaseHRef:string;
var
  i:integer;
begin
  result:='';
  if assigned(header) then
  for i:=0 to Header.ChildCount-1 do
  begin
    if Header.childs[i] is THTMLBase then
    begin
      result:=THTMLBase(Header.childs[i]).hRef;
      break;
    end;
  end;
end;
procedure THTMLDocument.setBaseHRef(p: string);
var
  i:integer;
  found:boolean;
begin
  found:=false;
  if not assigned(Header) then
    exit;
  for i:=0 to Header.ChildCount-1 do
  begin
    if Header.childs[i] is THTMLBase then
    begin
      THTMLBase(Header.childs[i]).hRef:=p;
      found:=true;
      break;
    end;
  end;
  if not found then
  begin
     Header.CreateChildElement('<base href="'+p+'">');
  end;
end;

procedure THTMLDocument.doProgress(StatusText:string; Progress,ProgressMax:dword);
var ev:TInternetOnProgressEvent;
begin
  ev:=OnProgress;
  if assigned(ev) then
    ev(self, Location.Loader.hRequest, Progress, ProgressMax, INTERNET_STATUS_PARSING, StatusText,0, 0,0,'');
end;

function THTMLDocument.TableCount:integer;
begin
  result:=fTableCollection.Count;
end;
function THTMLDocument.FormCount:integer;
begin
  result:=fFormCollection.Count;
end;
function THTMLDocument.TableByName(TableName:string):THTMLTable;
var
  i:integer;
  found:boolean;
begin
  result:=nil;
  found:=false;
  for i:=0 to TableCount-1 do
  begin
    if CompareText(Tables[i].Name,TableName)=0 then
    begin
      result:=Tables[i];
      found:=true;
      break;
    end;
  end;
  if not Found then
     Raise Exception.Create('There is no such Table :'+TableName);
end;
function THTMLDocument.FormByName(FormName:string):THTMLForm;
var
  i:integer;
  found:boolean;
begin
  result:=nil;
  found:=false;
  for i:=0 to FormCount-1 do
  begin
    if CompareText(Forms[i].Name,FormName)=0 then
    begin
      result:=Forms[i];
      found:=true;
      break;
    end;
  end;
  if not Found then
     Raise Exception.Create('There is no such Form :'+FormName);
end;
function THTMLDocument.getElementById(id:string):THTMLElement;
var i:integer;
begin
  result:=nil;
  for i:=0 to All.count-1 do
  begin
    if compareText(All[i].Id,id)=0 then
    begin
      result:=All[i];
      break;
    end;
  end;
end;
function  THTMLDocument.getAbsoluteURL(relativeURL:string):string;
var
  s:string;
  pBuf:pchar;
  dwBufLength:dword;
begin
  if (length(relativeUrl)>=7) and (compareText(copy(relativeUrl,1,7),'http://')=0) then
  begin
    result:=relativeUrl;
    exit;
  end;
  s:=location.href;
  dwBufLength:=4096;
  getMem(pBuf,dwBufLength);
  try
    if not InternetCombineUrl(pchar(s),pchar(relativeURL),pBuf,dwBufLength,ICU_BROWSER_MODE) then
      RaiseLastAPIError;
    result:=string(pBuf);
  finally
    freeMem(pBuf,dwBufLength);
  end;
end;
procedure THTMLDocument.SaveToFile(fileName:string);
var
  fStream:TFileStream;
  sStream:TStringStream;
begin
  fStream:=TFileStream.Create(filename,fmCreate);
  try
    if Parsed then
      sStream:=TStringStream.Create(outerHTML)
    else
      sStream:=TStringStream.Create(fRawHTml.Text);
    try
      fStream.CopyFrom(sStream,sStream.Size);
    finally
      sStream.Free;
    end;
  finally
    fStream.Free;
  end;
end;
procedure THTMLDocument.ConvertToLocalFile(var fileName:string);
var
  i:integer;
  frameFileName:string;
  path:string;
  file_name:string;
  file_ext:string;

begin
  EditMode:=True;
  path:=ExtractFilePath(fileName);
  if Path='' then
    Path:=ExtractFilePath(GetModuleName(hInstance));
  if Path[length(Path)]<>'\' then
   Path:=Path+'\';
  BaseHRef:=Location.href;
  file_ext:=ExtractFileExt(fileName);
  file_name:=ExtractFileName(fileName);
  file_name:=StringReplace(file_name,file_ext,'',[rfReplaceAll,rfIgnoreCase]);

  try
    for i:=0 to Frames.Count-1 do
    if Frames[i].Loaded then
    begin
      frameFileName:=Path+file_name+'_frame_'+inttostr(i)+file_ext;
      Frames[i].FrameDoc.ConvertToLocalFile(frameFileName);
      Frames[i].src:='file://'+frameFileName;
    end;
  finally
    try
      SaveToFile(fileName);
    finally
      EditMode:=false;
    end;
  end;

end;
procedure THTMLDocument.ProcessMetaRefresh;
var
  i:integer;
  refresh_url:string;
  interval:integer;
begin
  if assigned(header) then
  if Header.RefreshInterval>0 then
  begin
    refresh_url:=Header.RefreshURL;
    if refresh_url='' then
      refresh_url:=location.href;
    //wait for x seconds
    interval:=Header.RefreshInterval+5;
    if interval> 60 then
      interval:=60;
    doProgress(format(sEventProcessingMetaRefresh,[0,interval]),0,interval);
    for i:=0 to interval do
    begin
      doProgress(format(sEventProcessingMetaRefresh,[i,interval]),i,interval);
      sleep(1000);
    end;
    Location.href:=refresh_url;
    if not AutoLoad then
      Load;
    if not AutoParse then
      Parse; 
  end;
end;
procedure THTMLDocument.Load;
begin
  fParsed:=false;
  RawHTML.clear;
  Location.reload(false);
end;
procedure THTMLDocument.Parse;
  function getOrgSourceFname:string;
  var mname:string;
  dir:string;
  begin
    if url<>'http://' then
      result:=url
    else
      result:='orginal_doc';
    if length(result)>100 then
      result:=copy(result,1,100);
    result:=StringReplace(result,'http://','',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'/','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'.','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'=','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'?','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'@','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'&','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,';','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,':','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,',','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'\','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'*','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'-','_',[rfIgnoreCase,rfReplaceAll]);
    result:=StringReplace(result,'+','_',[rfIgnoreCase,rfReplaceAll]);
    result:=result+'.html';
    mname:=GetModuleName(hInstance);
    dir:=extractFilePath(mname);
    if length(dir)>0 then
    if dir[length(dir)]<>'\' then
      dir:=dir+'\';
    dir := dir+'debug\';
    if not DirectoryExists(dir) then
      CreateDir(dir);
    result:=dir+result;
  end;
begin
  if assigned(fparser) then
  begin
   fParser.Free;
   fParser:=nil;
  end;
  All.clear(true);
  if fTrytoFixProblems then
  try
    //RawHtml.SaveToFile(getOrgSourceFname);
  except on e:exception do
    raise;
  end;
  fParser:=THTMLParser.Create(RawHtml.Text,fTrytoFixProblems,self);
  try
    fParser.OnParsingError:=onParseError;
    fParser.CreateElements(self);
    fParsed:=true;
  finally
    fParser.free;
    fParser:=nil;
  end;
end;

procedure THTMLDocument.LoadFrames(Parse:boolean);
var i:integer;
begin
  for i:=0 to frames.Count-1 do
  begin
    Frames[i].FrameDoc.AutoParse:=false;
    Frames[i].FrameDoc.AutoLoad:=false;
    Frames[i].FrameDoc.url:=Frames[i].Src;
    Frames[i].Load;
    if Parse then
      Frames[i].Parse;
  end;
end;
procedure THTMLDocument.ParseFrames;
var i:integer;
begin
  for i:=0 to frames.Count-1 do
    Frames[i].Parse;
end;


function  THTMLDocument.Get_parentWindow:THTMLWindow;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_styleSheets:THTMLStyleSheetsCollection;
begin
  result:=fStylesCollection;
end;
function  THTMLDocument.Get_onbeforeupdate:string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_onbeforeupdate(p:string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_onerrorupdate:string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_onerrorupdate(p:string);
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_onreadystatechange(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_onreadystatechange: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_onafterupdate(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_onafterupdate: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_onrowexit(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_onrowexit: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_onrowenter(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_onrowenter: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_ondragstart(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_ondragstart: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_onselectstart(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_onselectstart: string;
begin
  raise exception.create('not implemented');
end;

procedure THTMLDocument.Set_alinkColor(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_alinkColor: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_bgColor(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_bgColor: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_fgColor(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_fgColor: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_linkColor(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_linkColor: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_vlinkColor(p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_vlinkColor: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_referrer: string;
begin
  result:=location.referrer;
end;
procedure THTMLDocument.Set_referrer(p: string);
begin
  location.referrer:=p;
end;

function  THTMLDocument.Get_location: THTMLLocation;
begin
  result:=fLocation;
end;
procedure THTMLDocument.Set_location(p: THTMLLocation);
begin
  fLocation:=p;
end;
function  THTMLDocument.Get_lastModified: string;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_url(const p: string);
begin
  location.href:=p
end;
function  THTMLDocument.Get_url: string;
begin
  result:=location.href;
end;
procedure THTMLDocument.Set_domain(const p: string);
begin
  location.host:=p;
end;
function  THTMLDocument.Get_domain: string;
begin
  result:=location.host;
end;
{
procedure THTMLDocument.Set_cookies(const p: THTTPCookies);
begin

end;
}
function  THTMLDocument.Get_cookies: THTTPCookies;
begin
  result:=location.Connection.Cookies;
end;
procedure THTMLDocument.Set_expando(p: boolean);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_expando: boolean;
begin
  raise exception.create('not implemented');
end;
procedure THTMLDocument.Set_charset(const p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_charset: string;
begin
  raise exception.create('not implemented');
end;

function  THTMLDocument.Get_contentType: string;
var i: integer;
begin
  for i:=0 to Header.VariableCount-1 do
    if comparetext(Header.Variables[i].HttpEquiv,'content-type')=0 then
    begin
      result:=Header.Variables[i].Content;
    end;
end;
procedure THTMLDocument.Set_contentType (p: string);
var i: integer;
begin
  for i:=0 to Header.VariableCount-1 do
    if comparetext(Header.Variables[i].HttpEquiv,'content-type')=0 then
    begin
      Header.Variables[i].Content:=p;
    end;
end;
procedure THTMLDocument.Set_defaultCharset(const p: string);
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_defaultCharset: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_mimeType: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_fileSize: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_fileCreatedDate: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_fileModifiedDate: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_fileUpdatedDate: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_security: string;
begin
  raise exception.create('not implemented');
end;
function  THTMLDocument.Get_protocol: string;
begin
  result:=location.protocol;
end;
function  THTMLDocument.Get_nameProp: string;
begin
  raise exception.create('not implemented');
end;

function  THTMLDocument.getCookieHandling:THTTPCookieHandlingTypes;
begin
  result:=fCookieHandling;
end;
procedure THTMLDocument.setCookieHandling(p:THTTPCookieHandlingTypes);
begin
  fCookieHandling:=p;
  if assigned(Location) then
    if assigned(Location.Loader) then
     if Location.Loader is TInternetHTTPRequest then
       TInternetHTTPRequest(Location.Loader).opCookieHandling:=fCookieHandling;
end;

function  THTMLDocument.getOnProgress: TInternetOnProgressEvent;
begin
  if assigned(location) then
    result:=location.OnProgress;
end;
procedure THTMLDocument.setOnProgress(p:TInternetOnProgressEvent);
begin
  if assigned(location) then
    location.OnProgress:=p;
end;
function  THTMLDocument.getOnRedirect:TInternetOnRedirectEvent;
begin
  if assigned(location) then
   result:=location.OnRedirect;
end;
procedure THTMLDocument.setOnRedirect(p:TInternetOnRedirectEvent);
begin
  if assigned(location) then
    location.OnRedirect:=p;
end;
function  THTMLDocument.getEditMode:boolean;
begin
  result:=fEditMode;
end;
procedure THTMLDocument.setEditMode(p:boolean);
var i:integer;
begin
  fEditMode:=p;
  for i:=0 to Frames.Count-1 do
    Frames[i].FrameDoc.EditMode:=p;
end;

function  THTMLDocument.getAutoLoadFrames:boolean;
begin
  result:=fAutoLoadFrames;
end;
procedure THTMLDocument.setAutoLoadFrames(p:boolean);
var i:integer;
begin
  fAutoLoadFrames:=p;
  for i:=0 to Frames.Count-1 do
    Frames[i].AutoLoadInnerFrames:=p;
end;

function  THTMLDocument.getAutoParseFrames:boolean;
begin
  result:=fAutoParseFrames;
end;
procedure THTMLDocument.setAutoParseFrames(p:boolean);
var i:integer;
begin
  fAutoParseFrames:=p;
  for i:=0 to Frames.Count-1 do
    Frames[i].AutoParseInnerFrames:=p;
end;

function  THTMLDocument.getAutoLoad:boolean;
begin
  result:=fAutoLoad;
end;

procedure THTMLDocument.setAutoLoad(p:boolean);
begin
  fAutoLoad:=p;
end;

function  THTMLDocument.getAutoParse:boolean;
begin
  result:=fAutoParse;
end;

procedure THTMLDocument.setAutoParse(p:boolean);
begin
  fAutoParse:=p;
end;

function  THTMLDocument.getRawHTML:TStrings;
begin
  result:=fRawHTML;
end;

procedure THTMLDocument.setRawHTML(p:TStrings);
begin
  fRawHTML.Assign(p);
end;

function  THTMLDocument.getLoaded:boolean;
begin
  result:=RawHTML.Count>0;
end;

function  THTMLDocument.getProduceXMLCompatibleHTML:boolean;
begin
  result:=fProduceXMLCompatibleHTML;
end;
procedure THTMLDocument.setProduceXMLCompatibleHTML(p:boolean);
var i:integer;
begin
  fProduceXMLCompatibleHTML:=p;
  for i:=0 to Frames.Count-1 do
    Frames[i].FrameDoc.ProduceXMLCompatibleHTML:=p;
end;

{THTMLDecoder}
constructor THTMLDecoder.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  fUseFontTagsAsParent:=false;
  fUseSeperateTextTags:=false;
  fRemoveControlChars :=true;
  FCode:=TStringList.Create;
  TStringList(FCode).OnChange:=OnHTMLCodeChange;
  FParsedCode:=TStringList.Create;
  fHTMLDocument := THTMLDocument.Create(nil,nil);
  fHTMLDocument.Decoder:=self;

end;
destructor THTMLDecoder.Destroy;
begin
  FCode.free;
  FParsedCode.free;
  fHTMLDocument.free;
  inherited Destroy;
end;
procedure THTMLDecoder.GetObjects(AObjectType:THTMLElementClasses;ObjectList:TList);
var i:integer;
begin
  if not assigned(ObjectList) then
    raise Exception.Create('Object List not assigned!');
  ObjectList.clear;
  for i:=0 to Document.All.Count-1 do
  begin
    if Document.All[i] is AObjectType then
      ObjectList.Add(Document.All[i]);
  end;
end;
function THTMLDecoder.GetTextTag(TextToSearch:string;Exact:boolean):THTMLElement;
var i:integer;
begin
  result:=nil;
  for i:=0 to Document.All.Count-1 do
  begin
    if exact then
    begin
      if CompareText(TextToSearch,THTMLElement(Document.All[i]).PlainText)=0 then
      begin
        result:=THTMLElement(Document.All[i]);
        break;
      end;
    end
    else
    begin
      if Pos(TextToSearch,THTMLElement(Document.All[i]).PlainText) >0 then
      begin
        result:=THTMLElement(Document.All[i]);
        break;
      end;
    end;
  end;
  if not assigned(result) then //search in tagstr s
  begin
    for i:=0 to Document.All.Count-1 do
    begin
      if exact then
      begin
        if CompareText(TextToSearch,THTMLElement(Document.All[i]).TagStr)=0 then
        begin
          result:=THTMLElement(Document.All[i]);
          break;
        end;
      end
      else
      begin
        if Pos(TextToSearch,THTMLElement(Document.All[i]).TagStr) >0 then
        begin
          result:=THTMLElement(Document.All[i]);
          break;
        end;
      end;
    end;
  end;
end;
function THTMLDecoder.GetTextTag(StartFrom:integer;TextToSearch:string;Exact:boolean):THTMLElement;
var i:integer;
begin
  result:=nil;
  for i:=StartFrom to Document.All.Count-1 do
  begin
    if exact then
    begin
      if CompareText(TextToSearch,THTMLElement(Document.All[i]).PlainText)=0 then
      begin
        result:=THTMLElement(Document.All[i]);
        break;
      end;
    end
    else
    begin
      if Pos(TextToSearch,THTMLElement(Document.All[i]).PlainText) >0 then
      begin
        result:=THTMLElement(Document.All[i]);
        break;
      end;
    end;
  end;
  if not assigned(result) then //search in tagstr s
  begin
    for i:=StartFrom to Document.All.Count-1 do
    begin
      if exact then
      begin
        if CompareText(TextToSearch,THTMLElement(Document.All[i]).TagStr)=0 then
        begin
          result:=THTMLElement(Document.All[i]);
          break;
        end;
      end
      else
      begin
        if Pos(TextToSearch,THTMLElement(Document.All[i]).TagStr) >0 then
        begin
          result:=THTMLElement(Document.All[i]);
          break;
        end;
      end;
    end;
  end;
end;
function THTMLDecoder.GetTextTag(StartFrom:integer;TextToSearch:string;Exact:boolean;Recursive:boolean):THTMLElement;
var i:integer;
begin
  result:=nil;
  for i:=StartFrom to Document.All.Count-1 do
  begin
    if not Recursive then
      if not (Document.All[i] is  THTMLPlainText) then
        Continue;
    if exact then
    begin
      if CompareText(TextToSearch,THTMLElement(Document.All[i]).PlainText)=0 then
      begin
        result:=THTMLElement(Document.All[i]);
        break;
      end;
    end
    else
    begin
      if Pos(TextToSearch,THTMLElement(Document.All[i]).PlainText) >0 then
      begin
        result:=THTMLElement(Document.All[i]);
        break;
      end;
    end;
  end;
  if not assigned(result) then //search in tagstr s
  begin
    for i:=StartFrom to Document.All.Count-1 do
    begin
      if exact then
      begin
        if CompareText(TextToSearch,THTMLElement(Document.All[i]).TagStr)=0 then
        begin
          result:=THTMLElement(Document.All[i]);
          break;
        end;
      end
      else
      begin
        if Pos(TextToSearch,THTMLElement(Document.All[i]).TagStr) >0 then
        begin
          result:=THTMLElement(Document.All[i]);
          break;
        end;
      end;
    end;
  end;
end;
procedure THTMLDecoder.OnHTMLCodeChange(Sender:TObject);
begin
  Document.All.clear(true);
  FParsedCode.Clear;
  if assigned(fHTMLDocument.Header) then
  begin
    fHTMLDocument.Header.Free;
    fHTMLDocument.Header:=nil;
  end;
  if assigned(fHTMLDocument.Body) then
  begin
    fHTMLDocument.Body.free;
    fHTMLDocument.Body:=nil;
  end;

  //ParseHTML;
  //DecodeHTML;
end;

function  THTMLDecoder.getURL:string;
begin
  if (csDesigning in ComponentState) then
  begin
    result:=fURL;
  end
  else
  if assigned(Document) then
    result:=Document.location.href
  else
    result:='';

end;
procedure THTMLDecoder.setURL(p:string);
begin
  if (csLoading in ComponentState) then
  begin
    fURL:=p;
  end
  else
  if (csDesigning in ComponentState) then
  begin
    fURL:=p;
  end
  else
    if assigned(Document) then
    begin
      if assigned(HttpRequest) then
      begin
        //Document.location.Loader := fHttpRequest;
        //Document.location.Loader := fHttpRequest;
      end;
      Document.location.href:=p;
    end;
end;

function  THTMLDecoder.getOnProgress:TInternetOnProgressEvent;
begin
  if assigned(Document) then
    result:=Document.OnProgress
  else
    result:=nil;
end;

procedure THTMLDecoder.setOnProgress(p:TInternetOnProgressEvent);
begin
  if assigned(Document) then
    Document.OnProgress:=p;
end;
function  THTMLDecoder.getOnRedirect:TInternetOnRedirectEvent;
begin
  if assigned(Document) then
    result:=Document.OnRedirect;
end;

procedure THTMLDecoder.setOnRedirect(p:TInternetOnRedirectEvent);
begin
  if assigned(Document) then
    Document.OnRedirect:=p;
end;

function  THTMLDecoder.getTrytoFixProblems:boolean;
begin
  result:=false;
  if assigned(Document) then
    result:=Document.TrytoFixProblems;
end;

procedure THTMLDecoder.setTrytoFixProblems(p:boolean);
begin
  if assigned(Document) then
    Document.TrytoFixProblems:=p;
end;

function  THTMLDecoder.getOnParsingError:THTMLOnParseErrorEvent;
begin
  result:=document.onParseError;
end;
procedure THTMLDecoder.setOnParsingError(p:THTMLOnParseErrorEvent);
begin
  document.onParseError:=p;
end;

function  THTMLDecoder.getAddParsingErrorComments:boolean;
begin
  result:=document.AddParsingErrorComments;
end;

procedure THTMLDecoder.setAddParsingErrorComments(p:boolean);
begin
  document.AddParsingErrorComments:=p;
end;
function  THTMLDecoder.getReFormatOutputHTML:boolean;
begin
  result:=Document.ReFormatOutputHTML;
end;
procedure THTMLDecoder.setReFormatOutputHTML(p:boolean);
begin
  Document.ReFormatOutputHTML:=p;
end;
function  THTMLDecoder.getHttpRequest:TCustomInternetRequest;
begin
  result:= Document.location.Loader;
end;
procedure THTMLDecoder.SetHttpRequest(p:TCustomInternetRequest);
begin
  if csLoading in componentstate then
  begin
    fTempHttpRequest:=p;
  end;
  if not assigned(p) then
   exit;
  try
    if assigned(Document.location.Loader) and (Document.location.Loader<>p) then
       Document.location.Loader.free;
    if assigned(Document.location.Connection) and (Document.location.Connection<>p.Connection) then
      Document.location.Connection.Free;
  finally
    Document.location.Connection:=TInternetConnection(p.Connection);
    Document.location.Loader:=p;
    if csLoading in ComponentState then
      document.fOldOnLoaded:=p.OnLoaded;
    p.OnLoaded := Document.location.doOnLoaded;
  end;
end;
procedure THTMLDecoder.Loaded;
begin
  inherited;
  if fURL<>'' then
    setURL(fURL);
  SetHttpRequest(fTempHttpRequest);
end;
function  THTMLDecoder.getCurrentUser:string;
begin
  result:=document.location.Loader.Connection.Session.CurrentUser;
end;
procedure THTMLDecoder.setCurrentUser(p:string);
begin
  document.location.Loader.Connection.Session.CurrentUser:=p;
end;

function  THTMLDecoder.getCookieHandling:THTTPCookieHandlingTypes;
begin
  if assigned(Document) then
    result:=Document.CookieHandling
  else
    result:=chNone;
end;
procedure THTMLDecoder.setCookieHandling(p:THTTPCookieHandlingTypes);
begin
  Document.CookieHandling:=p;
end;
(*
procedure THTMLDecoder.SetCode(Value:TStrings);
begin
  if FCode.Text <> Value.Text then
  begin
    FCode.BeginUpdate;
    try
      FCode.Clear;
      FParsedCode.Clear;
      FCode.Assign(Value);
    finally
      FCode.EndUpdate;
    end;
  end;
end;
*)
function THTMLDecoder.GetParsedCode:TStrings;
begin
  result:=FParsedCode;
end;
(*
Procedure THTMLDecoder.ExtractPropsFromTag(TagStr:string;var TagCmd:String;Props:TStrings);
var
  s:string;
  //Tag_End_Point:integer;
begin
  //validity check!
  if not assigned (Props) then
    raise Exception.Create('Property List Not Assigned!Cannot continue to extract tag properties...');
  s:=TagStr;
  if (s[1]<>'<') or (Pos('>',s)=0) then
    raise Exception.Create('Invalid HTML Tag:'+TagStr);

  //Tag_End_Point:=Pos('>',s);
  s:=StringReplace(s,'<','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'>','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'"','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,#$D+#$A,'',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,' ',#$D+#$A,[rfReplaceAll, rfIgnoreCase]);
  Props.Text:=s;
  TagCmd:=Props[0];
  Props.delete(0);

end;
*)
Function THTMLDecoder.GetTagCmd(TagStr:string):string;
var t:integer;
begin
  t:=Pos(' ',TagStr);
  if t=0 then
   t:=Pos('>',TagStr);
  if t>0 then
    result:=copy(Tagstr,2,t-2);
end;
function THTMLDecoder.GetTagClass(TagStr:string):THTMLElementClasses;
var
  i:THTMLTagTypes;
  tagid:string;
begin
  tagid:=GetTagCmd(TagStr);
  result:=THTMLElement;
  for i:=low(THTMLTagTypes) to high(THTMLTagTypes) do
   if lowercase(c_HTMLTagIds[i])=lowercase(tagid) then
   begin
     result:=THTMLElementClasses(c_HTMLElementClasses[i]);
     break;
   end;
end;
procedure THTMLDecoder.ConvertToLocalFile(var fileName:string);
begin
  document.ConvertToLocalFile(fileName);
end;
procedure THTMLDecoder.ProcessMetaRefresh;
begin
  document.ProcessMetaRefresh;
end;
procedure SortTagCmds;
var
  i:THTMLTagTypes;
  j:byte;
  sList:TStringList;
begin
  sList:=TStringList.Create;
  try
    for i:=low(THTMLTagTypes) to high(THTMLTagTypes) do
      sList.AddObject(c_HTMLTagIds[i],tObject(i));
    sList.Sort;
    for j:=0 to sList.Count-1 do
    begin
      vHTMLSortedTagNames[j]:=sList[j];
      vHTMLSortedTagIds[j]:=THTMLTagTypes(sList.Objects[j]);
    end;
  finally
    sList.free;
  end;

end;
initialization
  SortTagCmds

end.

