{*******************************************************}
{                                                       }
{                       EhLib v2.6                      }
{     Conditional defines that affect compilation       }
{                                                       }
{   Copyright (c) 1998, 2002 by Dmitry V. Bolshakov     }
{                                                       }
{*******************************************************}

{$DEFINE EH_LIB_CLX}

{$IFDEF VER100} { Borland Delphi 3.0 }
  {$MESSAGE ERROR 'This version of EhLib does not support Delphi 3' }
{$ENDIF}

{$IFDEF VER110}         { C++Builder 3.0 }
  {$MESSAGE ERROR 'This version of EhLib does not support C++Builder 3' }
{$ENDIF}

{$IFDEF VER120}         { Borland Delphi 4.0 }
  {$MESSAGE ERROR 'This version of EhLib does not support Delphi 4' }
{$ENDIF}

{$IFDEF VER125}         { CPP Builder 4.0 }
  {$MESSAGE ERROR 'This version of EhLib does not support C++Builder 4' }
{$ENDIF}

{$IFDEF VER130}         { Borland Delphi 5.0 or CPP Builder 5.0 }
  {$MESSAGE ERROR 'This version of EhLib does not support Delphi 5' }
{$ENDIF}

{$IFDEF VER140}         { Borland Delphi 6.0 or CPP Builder 6.0}
  {$DEFINE EH_LIB_5}
  {$DEFINE EH_LIB_6}
{$ENDIF}

{$IFDEF VER150}         { Borland Delphi 7.0 }
  {$DEFINE EH_LIB_5}
  {$DEFINE EH_LIB_6}
  {$DEFINE EH_LIB_7}
{$ENDIF}


//{$define eval}
