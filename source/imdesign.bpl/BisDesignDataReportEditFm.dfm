inherited BisDesignDataReportEditForm: TBisDesignDataReportEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataReportEditForm'
  ClientHeight = 286
  ClientWidth = 512
  Constraints.MinHeight = 320
  Constraints.MinWidth = 520
  ExplicitWidth = 520
  ExplicitHeight = 320
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 248
    Width = 512
    ExplicitTop = 248
    ExplicitWidth = 512
    inherited ButtonOk: TButton
      Left = 333
      ExplicitLeft = 333
    end
    inherited ButtonCancel: TButton
      Left = 429
      ExplicitLeft = 429
    end
  end
  inherited PanelControls: TPanel
    Width = 512
    Height = 248
    ExplicitWidth = 512
    ExplicitHeight = 248
    object LabelReport: TLabel
      Left = 141
      Top = 170
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1095#1077#1090':'
      FocusControl = EditReport
    end
    object LabelEngine: TLabel
      Left = 94
      Top = 143
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1074#1080#1078#1086#1082' '#1086#1090#1095#1077#1090#1072':'
      FocusControl = ComboBoxEngine
    end
    object LabelPlace: TLabel
      Left = 312
      Top = 143
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1061#1088#1072#1085#1080#1090#1100':'
      FocusControl = ComboBoxPlace
    end
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
    object EditReport: TEdit
      Left = 183
      Top = 167
      Width = 318
      Height = 21
      Anchors = [akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = #1053#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      OnChange = EditReportChange
    end
    object ComboBoxEngine: TComboBox
      Left = 183
      Top = 140
      Width = 118
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 2
    end
    object ComboBoxPlace: TComboBox
      Left = 364
      Top = 140
      Width = 137
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        #1074' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093
        #1074' '#1092#1072#1081#1083#1086#1074#1086#1081' '#1089#1080#1089#1090#1077#1084#1077)
    end
    object ButtonLoad: TButton
      Left = 264
      Top = 194
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Enabled = False
      TabOrder = 6
      OnClick = ButtonLoadClick
    end
    object ButtonSave: TButton
      Left = 345
      Top = 194
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Enabled = False
      TabOrder = 7
      OnClick = ButtonSaveClick
    end
    object ButtonClear: TButton
      Left = 426
      Top = 194
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Enabled = False
      TabOrder = 8
      OnClick = ButtonClearClick
    end
    object ButtonEditor: TButton
      Left = 183
      Top = 194
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1056#1077#1076#1072#1082#1090#1086#1088
      Enabled = False
      TabOrder = 5
      OnClick = ButtonEditorClick
    end
    object EditName: TEdit
      Left = 97
      Top = 13
      Width = 300
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 40
      Width = 404
      Height = 94
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object CheckBoxRefresh: TCheckBox
      Left = 183
      Top = 225
      Width = 188
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1099
      TabOrder = 9
    end
  end
  inherited ImageList: TImageList
    Left = 144
    Top = 72
  end
  object OpenDialog: TOpenDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 216
    Top = 72
  end
  object SaveDialog: TSaveDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 288
    Top = 72
  end
end
