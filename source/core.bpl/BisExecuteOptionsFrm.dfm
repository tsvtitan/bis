inherited BisExecuteOptionsFrame: TBisExecuteOptionsFrame
  Width = 233
  Height = 129
  ExplicitWidth = 233
  ExplicitHeight = 129
  object LabelAutoStartTime: TLabel
    Left = 47
    Top = 42
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = #1042#1088#1077#1084#1103':'
    FocusControl = EditAutoStartTime
  end
  object CheckBoxAutoStart: TCheckBox
    Left = 16
    Top = 16
    Width = 137
    Height = 17
    Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1089#1090#1072#1088#1090
    TabOrder = 0
  end
  object EditAutoStartTime: TEdit
    Left = 87
    Top = 39
    Width = 34
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = '0'
  end
  object UpDownAutoStart: TUpDown
    Left = 121
    Top = 39
    Width = 16
    Height = 21
    Associate = EditAutoStartTime
    TabOrder = 2
  end
  object CheckBoxAutoExit: TCheckBox
    Left = 16
    Top = 66
    Width = 137
    Height = 17
    Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1074#1099#1093#1086#1076
    TabOrder = 3
  end
end
