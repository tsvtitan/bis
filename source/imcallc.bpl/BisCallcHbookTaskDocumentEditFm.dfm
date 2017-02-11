inherited BisCallcHbookTaskDocumentEditForm: TBisCallcHbookTaskDocumentEditForm
  Left = 440
  Top = 228
  Caption = 'BisCallcHbookTaskDocumentEditForm'
  ClientHeight = 337
  ClientWidth = 361
  ExplicitLeft = 440
  ExplicitTop = 228
  ExplicitWidth = 369
  ExplicitHeight = 364
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 299
    Width = 361
    ExplicitTop = 299
    ExplicitWidth = 361
    inherited ButtonOk: TButton
      Left = 184
      ExplicitLeft = 184
    end
    inherited ButtonCancel: TButton
      Left = 281
      ExplicitLeft = 281
    end
  end
  inherited PanelControls: TPanel
    Width = 361
    Height = 299
    ExplicitWidth = 361
    ExplicitHeight = 299
    object LabelTask: TLabel
      Left = 50
      Top = 14
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1072#1076#1072#1085#1080#1077':'
      FocusControl = EditTask
    end
    object LabelDateDocument: TLabel
      Left = 10
      Top = 180
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
      FocusControl = DateTimePickerDocument
    end
    object LabelDescription: TLabel
      Left = 43
      Top = 207
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelName: TLabel
      Left = 17
      Top = 126
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelType: TLabel
      Left = 17
      Top = 41
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
      FocusControl = ComboBoxType
    end
    object LabelDocument: TLabel
      Left = 40
      Top = 68
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090':'
      FocusControl = EditDocument
    end
    object LabelExtension: TLabel
      Left = 30
      Top = 153
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1072#1089#1096#1080#1088#1077#1085#1080#1077':'
      FocusControl = EditExtension
    end
    object EditTask: TEdit
      Left = 102
      Top = 11
      Width = 221
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonTask: TButton
      Left = 329
      Top = 11
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
      Caption = '...'
      TabOrder = 1
    end
    object DateTimePickerDocument: TDateTimePicker
      Left = 102
      Top = 177
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 9
    end
    object MemoDescription: TMemo
      Left = 102
      Top = 204
      Width = 248
      Height = 89
      ScrollBars = ssVertical
      TabOrder = 11
    end
    object DateTimePickerTimeDocument: TDateTimePicker
      Left = 196
      Top = 177
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 10
    end
    object EditName: TEdit
      Left = 102
      Top = 123
      Width = 248
      Height = 21
      TabOrder = 7
    end
    object ComboBoxType: TComboBox
      Left = 102
      Top = 38
      Width = 167
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
    object EditDocument: TEdit
      Left = 102
      Top = 65
      Width = 248
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
      Text = #1053#1077' '#1079#1072#1075#1088#1091#1078#1077#1085
    end
    object ButtonLoad: TButton
      Left = 102
      Top = 92
      Width = 75
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 4
      OnClick = ButtonLoadClick
    end
    object ButtonSave: TButton
      Left = 188
      Top = 92
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Enabled = False
      TabOrder = 5
      OnClick = ButtonSaveClick
    end
    object ButtonClear: TButton
      Left = 275
      Top = 92
      Width = 75
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Enabled = False
      TabOrder = 6
      OnClick = ButtonClearClick
    end
    object EditExtension: TEdit
      Left = 102
      Top = 150
      Width = 167
      Height = 21
      TabOrder = 8
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*|'#1044#1086#1082#1091#1084#1077#1085#1090#1099' (*.doc)|*.doc|'#1040#1091#1076#1080#1086' (*.mp3,*.wma)|' +
      '*.mp3;*.wma|'#1042#1080#1076#1077#1086' (*.avi)|*.avi|'#1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' (*.jpg)|*.jpg'
    Options = [ofEnableSizing]
    Left = 168
    Top = 192
  end
  object SaveDialog: TSaveDialog
    Filter = 
      #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*|'#1044#1086#1082#1091#1084#1077#1085#1090#1099' (*.doc)|*.doc|'#1040#1091#1076#1080#1086' (*.mp3,*.wma)|' +
      '*.mp3;*.wma|'#1042#1080#1076#1077#1086' (*.avi)|*.avi|'#1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' (*.jpg)|*.jpg'
    Options = [ofEnableSizing]
    Left = 248
    Top = 192
  end
end
