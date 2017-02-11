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
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 22
    Height = 13
    Caption = 'Text'
  end
  object LabelCount: TLabel
    Left = 268
    Top = 208
    Width = 33
    Height = 13
    Alignment = taRightJustify
    Caption = 'Count:'
  end
  object Memo1: TMemo
    Left = 68
    Top = 21
    Width = 437
    Height = 137
    Lines.Strings = (
      #1055#1088#1080#1074#1077#1090)
    TabOrder = 0
  end
  object Button1: TButton
    Left = 268
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
  object Button3: TButton
    Left = 349
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Speak2'
    TabOrder = 3
    OnClick = Button3Click
  end
  object TrackBar1: TTrackBar
    Left = 68
    Top = 164
    Width = 181
    Height = 45
    Max = 100
    Min = 1
    Position = 50
    TabOrder = 4
  end
  object EditCount: TEdit
    Left = 307
    Top = 205
    Width = 36
    Height = 21
    TabOrder = 5
    Text = '10'
  end
  object UpDownCount: TUpDown
    Left = 343
    Top = 205
    Width = 16
    Height = 21
    Associate = EditCount
    Min = 1
    Position = 10
    TabOrder = 6
  end
  object CheckBoxAsync: TCheckBox
    Left = 365
    Top = 207
    Width = 97
    Height = 17
    Caption = 'Async'
    TabOrder = 7
  end
  object SQLConnection1: TSQLConnection
    ConnectionName = 'IBConnection'
    DriverName = 'Interbase'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbxint30.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Interbase'
      'Database=s1:e:\taxi\taxi.fdb'
      'RoleName='
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
  object IBQuery1: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    SQL.Strings = (
      'SELECT * FROM GET_SAMPLE_VOICES(:IN_TEXT)')
    Left = 464
    Top = 72
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IN_TEXT'
        ParamType = ptUnknown
      end>
  end
  object IBDatabase1: TIBDatabase
    Connected = True
    DatabaseName = 'E:\Taxi\TAXI.FDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    Left = 320
    Top = 72
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = IBDatabase1
    Left = 408
    Top = 64
  end
end
