inherited BisCallcHbookPatternEditForm: TBisCallcHbookPatternEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookPatternEditForm'
  ClientHeight = 376
  ClientWidth = 386
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 394
  ExplicitHeight = 403
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 338
    Width = 386
    ExplicitTop = 130
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 209
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 306
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 386
    Height = 338
    ExplicitTop = 1
    ExplicitWidth = 386
    ExplicitHeight = 338
    object LabelName: TLabel
      Left = 9
      Top = 16
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 35
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPattern: TLabel
      Left = 20
      Top = 92
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = #1064#1072#1073#1083#1086#1085':'
      FocusControl = RichEditPattern
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 281
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 281
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object RichEditPattern: TRichEdit
      Left = 9
      Top = 111
      Width = 368
      Height = 186
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 2
    end
    object ButtonLoad: TButton
      Left = 10
      Top = 303
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 3
      OnClick = ButtonLoadClick
    end
    object ButtonSave: TButton
      Left = 91
      Top = 303
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Enabled = False
      TabOrder = 4
      OnClick = ButtonSaveClick
    end
    object ButtonClear: TButton
      Left = 172
      Top = 303
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Enabled = False
      TabOrder = 5
      OnClick = ButtonClearClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = #1060#1072#1081#1083#1099' RTF (*.rtf)|*.rtf|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 96
    Top = 168
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.rtf'
    Filter = #1060#1072#1081#1083#1099' RTF (*.rtf)|*.rtf|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 176
    Top = 168
  end
end
