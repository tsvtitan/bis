inherited BisTaxiDataOperatorEditForm: TBisTaxiDataOperatorEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataOperatorEditForm'
  ClientHeight = 324
  ClientWidth = 606
  ExplicitWidth = 614
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 286
    Width = 606
    ExplicitTop = 270
    ExplicitWidth = 377
    inherited ButtonOk: TButton
      Left = 427
      ExplicitLeft = 198
    end
    inherited ButtonCancel: TButton
      Left = 523
      ExplicitLeft = 294
    end
  end
  inherited PanelControls: TPanel
    Width = 606
    Height = 286
    ExplicitTop = -1
    ExplicitWidth = 603
    ExplicitHeight = 301
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
      Left = 43
      Top = 261
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
      ExplicitTop = 276
    end
    object LabelConversions: TLabel
      Left = 15
      Top = 121
      Width = 76
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1077':'
      FocusControl = MemoConversions
    end
    object LabelRanges: TLabel
      Left = 370
      Top = 20
      Width = 61
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1044#1080#1072#1087#1072#1079#1086#1085#1099':'
      FocusControl = MemoRanges
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 235
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 232
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 259
      Height = 74
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 256
    end
    object CheckBoxEnabled: TCheckBox
      Left = 157
      Top = 260
      Width = 67
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1042#1082#1083#1102#1095#1077#1085
      Checked = True
      State = cbChecked
      TabOrder = 5
      ExplicitTop = 275
    end
    object EditPriority: TEdit
      Left = 97
      Top = 258
      Width = 54
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 4
      ExplicitTop = 273
    end
    object MemoConversions: TMemo
      Left = 97
      Top = 118
      Width = 259
      Height = 134
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 2
      WordWrap = False
      ExplicitWidth = 256
      ExplicitHeight = 149
    end
    object MemoRanges: TMemo
      Left = 362
      Top = 39
      Width = 232
      Height = 213
      Anchors = [akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 3
      WordWrap = False
      ExplicitLeft = 359
      ExplicitHeight = 228
    end
  end
  inherited ImageList: TImageList
    Left = 168
    Top = 48
  end
end