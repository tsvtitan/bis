inherited BisDesignDataInterfaceEditForm: TBisDesignDataInterfaceEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataInterfaceEditForm'
  ClientHeight = 241
  ClientWidth = 392
  Constraints.MinHeight = 275
  Constraints.MinWidth = 400
  ExplicitWidth = 400
  ExplicitHeight = 275
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 203
    Width = 392
    ExplicitTop = 241
    ExplicitWidth = 354
    inherited ButtonOk: TButton
      Left = 213
      ExplicitLeft = 175
    end
    inherited ButtonCancel: TButton
      Left = 309
      ExplicitLeft = 271
    end
  end
  inherited PanelControls: TPanel
    Width = 392
    Height = 203
    ExplicitWidth = 392
    ExplicitHeight = 203
    object LabelName: TLabel
      Left = 14
      Top = 16
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 38
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelModuleName: TLabel
      Left = 111
      Top = 127
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1052#1086#1076#1091#1083#1100':'
      FocusControl = ComboBoxModuleName
    end
    object LabelModuleInterface: TLabel
      Left = 94
      Top = 154
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089':'
      FocusControl = ComboBoxModuleInterface
      ExplicitTop = 179
    end
    object EditName: TEdit
      Left = 97
      Top = 13
      Width = 232
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 40
      Width = 284
      Height = 78
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      ExplicitWidth = 246
      ExplicitHeight = 116
    end
    object CheckBoxRefresh: TCheckBox
      Left = 160
      Top = 178
      Width = 188
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1099
      TabOrder = 4
      ExplicitTop = 203
    end
    object ComboBoxModuleName: TComboBox
      Left = 160
      Top = 124
      Width = 221
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akRight, akBottom]
      ItemHeight = 0
      Sorted = True
      TabOrder = 2
    end
    object ComboBoxModuleInterface: TComboBox
      Left = 160
      Top = 151
      Width = 221
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akRight, akBottom]
      ItemHeight = 0
      Sorted = True
      TabOrder = 3
    end
  end
  inherited ImageList: TImageList
    Left = 160
    Top = 96
  end
end
