object Form1: TForm1
  Left = 192
  Top = 114
  Width = 420
  Height = 480
  Caption = 'ZylGSM Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 9
    Top = 15
    Width = 394
    Height = 234
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnOpen: TButton
    Left = 9
    Top = 260
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Open'
    TabOrder = 1
    OnClick = btnOpenClick
  end
  object txtNo: TEdit
    Left = 9
    Top = 339
    Width = 121
    Height = 21
    Hint = 'Phone No.'
    Anchors = [akLeft, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object btnSendStr: TButton
    Left = 318
    Top = 379
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Send'
    TabOrder = 3
    OnClick = btnSendStrClick
  end
  object btnClose: TButton
    Left = 9
    Top = 293
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object lstPort: TListBox
    Left = 91
    Top = 260
    Width = 81
    Height = 57
    Hint = 'Port'
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    Items.Strings = (
      'COM1'
      'COM2'
      'COM3'
      'COM4'
      'COM5'
      'COM6'
      'COM7'
      'COM8'
      'COM9'
      'COM10'
      'COM11'
      'COM12'
      'COM13'
      'COM14'
      'COM15'
      'COM16'
      'COM17'
      'COM18'
      'COM19')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object lstBaudRate: TListBox
    Left = 178
    Top = 260
    Width = 81
    Height = 57
    Hint = 'Baud Rate'
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    Items.Strings = (
      '110'
      '300'
      '600'
      '1200'
      '2400'
      '4800'
      '9600'
      '14400'
      '19200'
      '38400'
      '56000'
      '57600'
      '115200'
      '128000'
      '230400'
      '256000'
      '460800')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object btnDial: TButton
    Left = 142
    Top = 339
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Dial'
    TabOrder = 7
    OnClick = btnDialClick
  end
  object btnAnswer: TButton
    Left = 230
    Top = 339
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Answer'
    TabOrder = 8
    OnClick = btnAnswerClick
  end
  object btnSendSMSText: TButton
    Left = 142
    Top = 379
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'SendSMS-Txt'
    TabOrder = 9
    OnClick = btnSendSMSTextClick
  end
  object txtMessage: TMemo
    Left = 8
    Top = 366
    Width = 121
    Height = 66
    Hint = 'Command'
    Anchors = [akLeft, akBottom]
    Lines.Strings = (
      'Text')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
  end
  object btnTerminate: TButton
    Left = 318
    Top = 339
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Terminate'
    TabOrder = 11
    OnClick = btnTerminateClick
  end
  object btnSendSMSPDU: TButton
    Left = 230
    Top = 379
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'SendSMS-PDU'
    TabOrder = 12
    OnClick = btnSendSMSPDUClick
  end
  object ZylGSM: TZylGSM
    CustomBaudRate = 0
    OnReceive = ZylGSMReceive
    OnConnect = ZylGSMConnect
    OnDisconnect = ZylGSMDisconnect
    OnRing = ZylGSMRing
    Left = 112
    Top = 120
  end
end
