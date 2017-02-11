object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 200
  ClientWidth = 643
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
    Left = 32
    Top = 29
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 32
    Top = 61
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 32
    Top = 88
    Width = 31
    Height = 13
    Caption = 'Label3'
  end
  object Button1: TButton
    Left = 280
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 55
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 280
    Top = 86
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 512
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 512
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 4
    OnClick = Button5Click
  end
  object CheckBox1: TCheckBox
    Left = 368
    Top = 152
    Width = 121
    Height = 17
    Caption = 'FreaOnTerminate'
    TabOrder = 5
  end
  object IBDatabase1: TIBDatabase
    Connected = True
    DatabaseName = 's1:E:\Taxi\TAXI.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    Left = 96
    Top = 136
  end
  object IBStoredProc1: TIBStoredProc
    Database = IBDatabase1
    Transaction = IBTransaction1
    StoredProcName = 'GET_TEST'
    Left = 256
    Top = 128
  end
  object IBTransaction1: TIBTransaction
    Active = True
    DefaultDatabase = IBDatabase1
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 176
    Top = 112
  end
end
