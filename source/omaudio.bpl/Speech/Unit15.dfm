object SpeechForm: TSpeechForm
  Left = 0
  Top = 0
  Caption = 'SpeechForm'
  ClientHeight = 241
  ClientWidth = 555
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 22
    Height = 13
    Caption = 'Text'
  end
  object Memo1: TMemo
    Left = 68
    Top = 21
    Width = 437
    Height = 137
    TabOrder = 0
  end
  object Button1: TButton
    Left = 349
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Speak'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 430
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SQLConnection1: TSQLConnection
    ConnectionName = 'IBConnection'
    DriverName = 'Interbase'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbxint30.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Interbase'
      'Database=s1:e:\base\taxi.fdb'
      'RoleName=RoleName'
      'User_Name=sysdba'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=3'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'Interbase TransIsolation=ReadCommited'
      'Trim Char=False')
    VendorLib = 'GDS32.DLL'
    Left = 48
    Top = 176
  end
  object SQLQuery1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM S_SAMPLE_VOICES'
      'ORDER BY TYPE_SAMPLE, PRIORITY')
    SQLConnection = SQLConnection1
    Left = 128
    Top = 176
  end
end