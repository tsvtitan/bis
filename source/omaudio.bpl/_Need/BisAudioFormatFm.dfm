inherited BisAudioFormatForm: TBisAudioFormatForm
  Left = 0
  Top = 0
  ActiveControl = ListBoxFormats
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeable
  Caption = #1060#1086#1088#1084#1072#1090' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 257
  ClientWidth = 451
  ExplicitWidth = 467
  ExplicitHeight = 295
  PixelsPerInch = 96
  TextHeight = 13
  object LabelDriver: TLabel [0]
    Left = 8
    Top = 11
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1088#1072#1081#1074#1077#1088':'
  end
  inherited PanelButton: TPanel
    Top = 222
    Width = 451
    TabOrder = 2
    ExplicitTop = 222
    ExplicitWidth = 451
    inherited ButtonOk: TButton
      Left = 284
      Enabled = False
      ModalResult = 1
      TabOrder = 3
      ExplicitLeft = 284
    end
    inherited ButtonCancel: TButton
      Left = 366
      TabOrder = 4
      ExplicitLeft = 366
    end
    object RadioButtonBoth: TRadioButton
      Left = 16
      Top = 8
      Width = 105
      Height = 17
      Caption = #1052#1086#1085#1086' '#1080' '#1089#1090#1077#1088#1077#1086
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButtonBothClick
    end
    object RadioButtonMono: TRadioButton
      Left = 127
      Top = 8
      Width = 58
      Height = 17
      Caption = #1052#1086#1085#1086
      TabOrder = 1
      OnClick = RadioButtonBothClick
    end
    object RadioButtonStereo: TRadioButton
      Left = 191
      Top = 8
      Width = 74
      Height = 17
      Caption = #1057#1090#1077#1088#1077#1086
      TabOrder = 2
      OnClick = RadioButtonBothClick
    end
  end
  object ComboBoxDrivers: TComboBox
    Left = 62
    Top = 8
    Width = 381
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 0
    OnChange = ComboBoxDriversChange
    OnCloseUp = ComboBoxDriversCloseUp
  end
  object ListBoxFormats: TListBox
    Left = 8
    Top = 35
    Width = 435
    Height = 175
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBoxFormatsClick
  end
end
