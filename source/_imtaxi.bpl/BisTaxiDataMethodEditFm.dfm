inherited BisTaxiDataMethodEditForm: TBisTaxiDataMethodEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataMethodEditForm'
  ClientHeight = 270
  ClientWidth = 407
  ExplicitWidth = 415
  ExplicitHeight = 304
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 232
    Width = 407
    ExplicitTop = 232
    ExplicitWidth = 373
    inherited ButtonOk: TButton
      Left = 228
      ExplicitLeft = 194
    end
    inherited ButtonCancel: TButton
      Left = 324
      ExplicitLeft = 290
    end
  end
  inherited PanelControls: TPanel
    Width = 407
    Height = 232
    ExplicitWidth = 373
    ExplicitHeight = 232
    object LabelName: TLabel
      Left = 14
      Top = 15
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
    object LabelPriority: TLabel
      Left = 285
      Top = 203
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
      ExplicitLeft = 251
      ExplicitTop = 353
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 296
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
      ExplicitWidth = 262
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 296
      Height = 90
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      ExplicitWidth = 262
    end
    object EditPriority: TEdit
      Left = 339
      Top = 200
      Width = 54
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 4
      ExplicitLeft = 305
    end
    object GroupBoxIncoming: TGroupBox
      Left = 97
      Top = 135
      Width = 104
      Height = 86
      Anchors = [akRight, akBottom]
      Caption = ' '#1055#1088#1080#1085#1080#1084#1072#1077#1084' '
      TabOrder = 2
      object CheckBoxInMessage: TCheckBox
        Left = 12
        Top = 21
        Width = 79
        Height = 17
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
        TabOrder = 0
      end
      object CheckBoxInQuery: TCheckBox
        Left = 12
        Top = 40
        Width = 68
        Height = 17
        Caption = #1047#1072#1087#1088#1086#1089#1099
        TabOrder = 1
      end
      object CheckBoxInCall: TCheckBox
        Left = 12
        Top = 59
        Width = 66
        Height = 17
        Caption = #1042#1099#1079#1086#1074#1099
        TabOrder = 2
      end
    end
    object GroupBoxOutgoing: TGroupBox
      Left = 207
      Top = 135
      Width = 186
      Height = 59
      Anchors = [akRight, akBottom]
      Caption = ' '#1054#1090#1087#1088#1072#1074#1083#1103#1077#1084' '
      TabOrder = 3
      object ComboBoxOutgoing: TComboBox
        Left = 11
        Top = 24
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          #1085#1080#1095#1077#1075#1086' '#1085#1077' '#1086#1090#1087#1088#1072#1074#1083#1103#1077#1084
          #1090#1072#1082' '#1078#1077', '#1082#1072#1082' '#1080' '#1087#1088#1080#1085#1103#1083#1080)
      end
    end
  end
end
