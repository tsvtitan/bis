{******************************************************************************}
{*        Copyright 1999-2003 by J.Friebel all rights reserved.               *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 7                                         *}
{*        System          :  Windows XP / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  24.07.2003                                       *}
{*        Version         :  0.3                                              *}
{*        EMail           :  tapi@delphiclub.de                               *}
{******************************************************************************}
{*                                                                            *}
{*    This File is free software; You can redistribute it and/or modify it    *}
{*    under the term of GNU Library General Public License as published by    *}
{*    the Free Software Foundation. This File is distribute in the hope       *}
{*    it will be useful "as is", but WITHOUT ANY WARRANTY OF ANY KIND;        *}
{*    See the GNU Library Public Licence for more details.                    *}
{*                                                                            *}
{******************************************************************************}
{*                                                                            *}
{*    Diese Datei ist Freie-Software. Sie können sie weitervertreiben         *}
{*    und/oder verändern im Sinne der Bestimmungen der "GNU Library GPL"      *}
{*    der Free Software Foundation. Diese Datei wird,"wie sie ist",           *}
{*    zur Verfügung gestellt, ohne irgendeine GEWÄHRLEISTUNG                  *}
{*                                                                            *}
{******************************************************************************}
{*                          www.delphiclub.de                                 *}
{******************************************************************************}

unit linedlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSelLineDlg = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  SelLineDlg: TSelLineDlg;

implementation

{$R *.dfm}

end.
