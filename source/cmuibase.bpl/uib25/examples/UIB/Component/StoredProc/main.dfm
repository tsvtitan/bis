object MainForm: TMainForm
  Left = 192
  Top = 107
  Caption = 'Strored Proc'
  ClientHeight = 152
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Go: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = GoClick
  end
  object Memo: TMemo
    Left = 8
    Top = 40
    Width = 489
    Height = 113
    TabOrder = 1
  end
  object DataBase: TUIBDataBase
    Params.Strings = (
      'sql_dialect=3'
      'lc_ctype=WIN1251'
      'password=masterkey'
      'user_name=SYSDBA')
    DatabaseName = 'E:\Taxi\TAXI.FDB'
    CharacterSet = csWIN1251
    UserName = 'SYSDBA'
    PassWord = 'masterkey'
    LibraryName = 'gds32.dll'
    Connected = True
    Left = 96
  end
  object Transaction: TUIBTransaction
    DataBase = DataBase
    Left = 128
  end
  object StoredProc: TUIBQuery
    Transaction = Transaction
    DataBase = DataBase
    Left = 160
  end
end
