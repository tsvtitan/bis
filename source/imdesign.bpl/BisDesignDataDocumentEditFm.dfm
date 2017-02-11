inherited BisDesignDataDocumentEditForm: TBisDesignDataDocumentEditForm
  Left = 476
  Top = 262
  Caption = 'BisDesignDataDocumentEditForm'
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
      Left = 332
      ExplicitLeft = 332
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
    object LabelDocument: TLabel
      Left = 102
      Top = 172
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090':'
      FocusControl = EditDocument
    end
    object LabelPlace: TLabel
      Left = 110
      Top = 145
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1061#1088#1072#1085#1080#1090#1100':'
      FocusControl = ComboBoxPlace
    end
    object LabelOleClass: TLabel
      Left = 304
      Top = 145
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'OLE-'#1082#1083#1072#1089#1089':'
      FocusControl = EditOleClass
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
    object EditDocument: TEdit
      Left = 162
      Top = 169
      Width = 337
      Height = 21
      Anchors = [akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = #1053#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
      OnChange = EditDocumentChange
    end
    object ComboBoxPlace: TComboBox
      Left = 162
      Top = 142
      Width = 134
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        #1074' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093
        #1074' '#1092#1072#1081#1083#1086#1074#1086#1081' '#1089#1080#1089#1090#1077#1084#1077)
    end
    object ButtonLoad: TButton
      Left = 262
      Top = 195
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Enabled = False
      TabOrder = 5
      OnClick = ButtonLoadClick
    end
    object ButtonSave: TButton
      Left = 343
      Top = 195
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Enabled = False
      TabOrder = 6
      OnClick = ButtonSaveClick
    end
    object ButtonClear: TButton
      Left = 424
      Top = 195
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Enabled = False
      TabOrder = 7
      OnClick = ButtonClearClick
    end
    object EditOleClass: TEdit
      Left = 365
      Top = 142
      Width = 134
      Height = 21
      Anchors = [akRight, akBottom]
      MaxLength = 100
      TabOrder = 3
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
      Width = 402
      Height = 96
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object CheckBoxRefresh: TCheckBox
      Left = 262
      Top = 226
      Width = 188
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1099
      TabOrder = 8
    end
  end
  inherited ImageList: TImageList
    Left = 120
  end
  object OpenDialog: TOpenDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 160
    Top = 56
  end
  object SaveDialog: TSaveDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 200
    Top = 56
  end
end
