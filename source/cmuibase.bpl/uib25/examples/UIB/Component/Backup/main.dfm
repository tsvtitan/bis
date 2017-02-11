object MainForm: TMainForm
  Left = 202
  Top = 188
  Width = 583
  Height = 284
  HorzScrollBar.Range = 54
  VertScrollBar.Range = 181
  ActiveControl = Log
  Caption = 'Backup Database'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 11
  Font.Name = 'MS Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Log: TMemo
    Left = 0
    Top = 57
    Width = 575
    Height = 193
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Go: TButton
    Left = 0
    Top = 6
    Width = 73
    Height = 27
    Caption = 'Backup'
    TabOrder = 1
    OnClick = GoClick
  end
  object Backup: TUIBBackup
    UserName = 'SYSDBA'
    PassWord = 'masterkey'
    LibraryName = 'gds32.dll'
    BackupFiles.Strings = (
      'd:\employee.gbk')
    Database = 'D:\EMPLOYEE.DB'
    OnVerbose = BackupVerbose
    Verbose = True
    Left = 64
    Top = 80
  end
end
