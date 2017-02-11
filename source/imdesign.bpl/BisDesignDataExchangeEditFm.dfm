inherited BisDesignDataExchangeEditForm: TBisDesignDataExchangeEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataExchangeEditForm'
  ClientHeight = 361
  ClientWidth = 331
  ExplicitWidth = 339
  ExplicitHeight = 395
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 323
    Width = 331
    ExplicitTop = 323
    ExplicitWidth = 331
    inherited ButtonOk: TButton
      Left = 152
      ExplicitLeft = 152
    end
    inherited ButtonCancel: TButton
      Left = 248
      ExplicitLeft = 248
    end
  end
  inherited PanelControls: TPanel
    Width = 331
    Height = 323
    ExplicitWidth = 331
    ExplicitHeight = 323
    object LabelName: TLabel
      Left = 13
      Top = 16
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 37
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPriority: TLabel
      Left = 194
      Top = 301
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 146
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 224
      Height = 41
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
    object GroupBoxSource: TGroupBox
      Left = 11
      Top = 87
      Width = 309
      Height = 84
      Anchors = [akLeft, akRight, akBottom]
      Caption = ' '#1048#1089#1090#1086#1095#1085#1080#1082' '
      TabOrder = 3
      DesignSize = (
        309
        84)
      object LabelSource: TLabel
        Left = 13
        Top = 24
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077':'
        FocusControl = ComboBoxSource
      end
      object ComboBoxSource: TComboBox
        Left = 85
        Top = 21
        Width = 209
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 0
      end
      object ButtonSourceBefore: TButton
        Left = 108
        Top = 48
        Width = 90
        Height = 22
        Hint = #1057#1082#1088#1080#1087#1090' '#1076#1086' '#1086#1073#1084#1077#1085#1072' '#1076#1083#1103' '#1080#1089#1090#1086#1095#1085#1080#1082#1072
        Anchors = [akTop, akRight]
        Caption = #1057#1082#1088#1080#1087#1090' '#1076#1086
        TabOrder = 1
        OnClick = ButtonScriptClick
      end
      object ButtonSourceAfter: TButton
        Left = 204
        Top = 48
        Width = 90
        Height = 22
        Hint = #1057#1082#1088#1080#1087#1090' '#1087#1086#1089#1083#1077' '#1086#1073#1084#1077#1085#1072' '#1076#1083#1103' '#1080#1089#1090#1086#1095#1085#1080#1082#1072
        Anchors = [akTop, akRight]
        Caption = #1057#1082#1088#1080#1087#1090' '#1087#1086#1089#1083#1077
        TabOrder = 2
        OnClick = ButtonScriptClick
      end
    end
    object GroupBoxDestination: TGroupBox
      Left = 11
      Top = 208
      Width = 309
      Height = 84
      Anchors = [akLeft, akRight, akBottom]
      Caption = ' '#1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '
      TabOrder = 5
      DesignSize = (
        309
        84)
      object LabelDestination: TLabel
        Left = 13
        Top = 24
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077':'
        FocusControl = ComboBoxDestination
      end
      object ComboBoxDestination: TComboBox
        Left = 85
        Top = 21
        Width = 209
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 0
      end
      object ButtonDestinationBefore: TButton
        Left = 108
        Top = 48
        Width = 90
        Height = 22
        Hint = #1057#1082#1088#1080#1087#1090' '#1076#1086' '#1086#1073#1084#1077#1085#1072' '#1076#1083#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        Anchors = [akTop, akRight]
        Caption = #1057#1082#1088#1080#1087#1090' '#1076#1086
        TabOrder = 1
        OnClick = ButtonScriptClick
      end
      object ButtonDestinationAfter: TButton
        Left = 204
        Top = 48
        Width = 90
        Height = 22
        Hint = #1057#1082#1088#1080#1087#1090' '#1087#1086#1089#1083#1077' '#1086#1073#1084#1077#1085#1072' '#1076#1083#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        Anchors = [akTop, akRight]
        Caption = #1057#1082#1088#1080#1087#1090' '#1087#1086#1089#1083#1077
        TabOrder = 2
        OnClick = ButtonScriptClick
      end
    end
    object ButtonScript: TButton
      Left = 96
      Top = 179
      Width = 209
      Height = 25
      Hint = #1057#1082#1088#1080#1087#1090' '#1086#1073#1084#1077#1085#1072' '#1084#1077#1078#1076#1091' '#1080#1089#1090#1086#1095#1085#1080#1082#1086#1084' '#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077#1084
      Anchors = [akLeft, akRight, akBottom]
      Caption = #1057#1082#1088#1080#1087#1090' '#1086#1073#1084#1077#1085#1072
      TabOrder = 4
      OnClick = ButtonScriptClick
    end
    object CheckBoxEnabled: TCheckBox
      Left = 248
      Top = 15
      Width = 73
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1042#1082#1083#1102#1095#1077#1085#1086
      TabOrder = 1
    end
    object EditPriority: TEdit
      Left = 248
      Top = 298
      Width = 57
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 6
    end
  end
  inherited ImageList: TImageList
    Left = 144
    Top = 48
  end
end
