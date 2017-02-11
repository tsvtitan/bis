object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = ButtonRunStop
  Caption = 'Test memory leaks'
  ClientHeight = 362
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    536
    362)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 511
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SQL Stored Proc'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 70
    Width = 511
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'IB Stored Proc'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ButtonRunStop: TButton
    Left = 444
    Top = 137
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Run / Stop'
    Default = True
    TabOrder = 8
    OnClick = ButtonRunStopClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 176
    Width = 514
    Height = 178
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Leaks log'
    TabOrder = 9
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 500
      Height = 156
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 0
    end
  end
  object Button3: TButton
    Left = 8
    Top = 39
    Width = 511
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SQL Query'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 101
    Width = 511
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'IB Query'
    TabOrder = 3
    OnClick = Button4Click
  end
  object RadioButtonSelect: TRadioButton
    Left = 15
    Top = 141
    Width = 73
    Height = 17
    Caption = 'SELECT'
    Checked = True
    TabOrder = 4
    TabStop = True
  end
  object RadioButtonInsert: TRadioButton
    Left = 120
    Top = 141
    Width = 73
    Height = 17
    Caption = 'INSERT'
    TabOrder = 5
  end
  object RadioButtonUpdate: TRadioButton
    Left = 216
    Top = 141
    Width = 73
    Height = 17
    Caption = 'UPDATE'
    TabOrder = 6
  end
  object RadioButtonDelete: TRadioButton
    Left = 312
    Top = 141
    Width = 73
    Height = 17
    Caption = 'DELETE'
    TabOrder = 7
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 80
    Top = 232
  end
end
