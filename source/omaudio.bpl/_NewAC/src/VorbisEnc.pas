(*
  Delphi/Kylix headers for Ogg Vorbis software codec.
  Translated from vorbisenc.h header
  by Andrei Borovsky, anb@symmetrica.net
  The original C/C++ headers and libraries (C) COPYRIGHT 1994-2001
  by the XIPHOPHORUS Company http://www.xiph.org/
*)

(* $Revision: 1.1 $ $Date: 2007/06/20 00:42:14 $ *)

unit VorbisEnc;

(* Unit: VorbisEnc.pas
    Delphi/Kylix headers for Ogg Vorbis software codec. Translated from
    vorbisenc.h header by Andrei Borovsky (anb@symmetrica.net)
    
    The original C/C++ headers and libraries (C) COPYRIGHT 1994-2001 by the
    XIPHOPHORUS Company http://www.xiph.org/. *)

interface

uses

  ACS_Procs,

  {$IFDEF LINUX}
  Libc,
  {$ENDIF}
  {$IFDEF WIN32}
  Windows,
  {$ENDIF}

  Codec;


const

{$IFDEF LINUX}
  LibvorbisencPath = 'libvorbisenc.so*'; //'/usr/lib/libvorbisenc.so';
  {$DEFINE SEARCH_LIBS}
{$ENDIF}

{$IFDEF WIN32}
  LibvorbisencPath = 'vorbisenc.dll';
{$ENDIF}


OV_ECTL_RATEMANAGE2_GET = $14;
OV_ECTL_RATEMANAGE2_SET = $15;


var
  LibvorbisencLoaded : Boolean = False;

type

  vorbis_encode_init_t = function(vi: PVORBIS_INFO;
                            channels: LongInt;
                            rate: LongInt;
                            max_bitrate: LongInt;
                            nominal_bitrate: LongInt;
                            min_bitrate: LongInt): Integer cdecl;

  vorbis_encode_setup_managed_t = function(vi: PVORBIS_INFO;
                                     channels: LongInt;
                                     rate: LongInt;
                                     max_bitrate: LongInt;
                                     nominal_bitrate: LongInt;
                                     min_bitrate: LongInt): Integer; cdecl;

  vorbis_encode_setup_vbr_t = function(vi: PVORBIS_INFO;
                                 channels: LongInt;
                                 rate: LongInt;
                                 fl: Single): Integer; cdecl;

  vorbis_encode_init_vbr_t = function(vi: PVORBIS_INFO;
                                channels: LongInt;
                                rate: LongInt;
                                base_quality: Single): Integer; cdecl;

  vorbis_encode_setup_init_t = function(vi: PVORBIS_INFO): Integer; cdecl;

  vorbis_encode_ctl_t = function(vi: PVORBIS_INFO;
                           number: Integer;
                           arg: Pointer): Integer; cdecl;

ovectl_ratemanage2_arg = record
  management_active : Integer;
  bitrate_limit_min_kbps : LongWord;
  bitrate_limit_max_kbps : LongWord;
  bitrate_limit_reservoir_bits : LongWord;
  bitrate_limit_reservoir_bias : Double;
  bitrate_average_kbps : LongWord;
  bitrate_average_damping : Double;
end;


var

  vorbis_encode_init : vorbis_encode_init_t;

  vorbis_encode_setup_managed : vorbis_encode_setup_managed_t;

  vorbis_encode_setup_vbr : vorbis_encode_setup_vbr_t;

  vorbis_encode_init_vbr : vorbis_encode_init_vbr_t;

  vorbis_encode_setup_init : vorbis_encode_setup_init_t;

  vorbis_encode_ctl : vorbis_encode_ctl_t;


implementation

{$IFDEF LINUX}

var
  Libhandle : Pointer;

{$IFDEF SEARCH_LIBS}
  Path : String;
{$ENDIF}

initialization

{$IFDEF SEARCH_LIBS}

  Libhandle := nil;
  Path := FindLibs(LibvorbisencPath);
  if Path <> '' then Libhandle := dlopen(@Path[1], RTLD_NOW or RTLD_GLOBAL);

{$ELSE}

  Libhandle := dlopen(LibvorbisencPath, RTLD_NOW or RTLD_GLOBAL);

{$ENDIF}

  if Libhandle <> nil then
  begin
    LibvorbisencLoaded := True;
    vorbis_encode_init := dlsym(Libhandle, 'vorbis_encode_init');
    vorbis_encode_setup_managed := dlsym(Libhandle, 'vorbis_encode_setup_managed');
    vorbis_encode_setup_vbr := dlsym(Libhandle, 'vorbis_encode_setup_vbr');
    vorbis_encode_init_vbr := dlsym(Libhandle, 'vorbis_encode_init_vbr');
    vorbis_encode_setup_init := dlsym(Libhandle, 'vorbis_encode_setup_init');
    vorbis_encode_ctl := dlsym(Libhandle, 'vorbis_encode_ctl');
  end;

finalization

  if libhandle <> nil then dlclose(Libhandle);

{$ENDIF}

{$IFDEF WIN32}

var
  Libhandle : HMODULE;

initialization

  Libhandle := LoadLibraryEx(LibvorbisencPath, 0, 0);
  if Libhandle <> 0 then
  begin
    LibvorbisencLoaded := True;
    vorbis_encode_init := GetProcAddress(Libhandle, 'vorbis_encode_init');
    vorbis_encode_setup_managed := GetProcAddress(Libhandle, 'vorbis_encode_setup_managed');
    vorbis_encode_setup_vbr := GetProcAddress(Libhandle, 'vorbis_encode_setup_vbr');
    vorbis_encode_init_vbr := GetProcAddress(Libhandle, 'vorbis_encode_init_vbr');
    vorbis_encode_setup_init := GetProcAddress(Libhandle, 'vorbis_encode_setup_init');
    vorbis_encode_ctl := GetProcAddress(Libhandle, 'vorbis_encode_ctl');
  end;

finalization

  if libhandle <> 0 then FreeLibrary(Libhandle);

{$ENDIF}

end.
