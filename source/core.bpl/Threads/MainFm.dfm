object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 634
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    498
    634)
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonCreate: TButton
    Left = 405
    Top = 16
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Create'
    TabOrder = 0
    OnClick = ButtonCreateClick
    ExplicitLeft = 296
  end
  object ButtonFree: TButton
    Left = 405
    Top = 47
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Free'
    TabOrder = 1
    OnClick = ButtonFreeClick
    ExplicitLeft = 296
  end
  object ListBox: TListBox
    Left = 16
    Top = 16
    Width = 374
    Height = 441
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 2
  end
  object ButtonCreateLots: TButton
    Left = 405
    Top = 78
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Create Lots'
    TabOrder = 3
    OnClick = ButtonCreateLotsClick
  end
  object Memo: TMemo
    Left = 16
    Top = 472
    Width = 465
    Height = 145
    Anchors = [akLeft, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 4
    WordWrap = False
  end
  object ButtonStop: TButton
    Left = 405
    Top = 120
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Stop'
    TabOrder = 5
    OnClick = ButtonStopClick
  end
  object ButtonClear: TButton
    Left = 405
    Top = 432
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 6
    OnClick = ButtonClearClick
  end
  object CheckBoxRefresh: TCheckBox
    Left = 416
    Top = 192
    Width = 64
    Height = 17
    Caption = 'Auto'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = CheckBoxRefreshClick
  end
  object ButtonRefresh: TButton
    Left = 405
    Top = 151
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Refresh'
    TabOrder = 8
    OnClick = ButtonRefreshClick
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 440
    Top = 160
  end
end