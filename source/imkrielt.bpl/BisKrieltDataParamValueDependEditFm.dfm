inherited BisKrieltDataParamValueDependEditForm: TBisKrieltDataParamValueDependEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataParamValueDependEditForm'
  ClientHeight = 159
  ClientWidth = 335
  ExplicitWidth = 343
  ExplicitHeight = 193
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 121
    Width = 335
    ExplicitTop = 121
    ExplicitWidth = 335
    inherited ButtonOk: TButton
      Left = 156
      ExplicitLeft = 156
    end
    inherited ButtonCancel: TButton
      Left = 253
      ExplicitLeft = 253
    end
  end
  inherited PanelControls: TPanel
    Width = 335
    Height = 121
    ExplicitWidth = 335
    ExplicitHeight = 121
    object LabelWhatValue: TLabel
      Left = 37
      Top = 13
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1072#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077':'
      FocusControl = EditWhatValue
    end
    object LabelWhatParam: TLabel
      Left = 36
      Top = 40
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1072#1082#1086#1081' '#1087#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditWhatParam
    end
    object LabelFromParam: TLabel
      Left = 9
      Top = 94
      Width = 113
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090' '#1082#1072#1082#1086#1075#1086' '#1087#1072#1088#1072#1084#1077#1090#1088#1072':'
      FocusControl = EditFromParam
    end
    object LabelFromValue: TLabel
      Left = 16
      Top = 67
      Width = 106
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090' '#1082#1072#1082#1086#1075#1086' '#1079#1085#1072#1095#1077#1085#1080#1103':'
      FocusControl = EditFromValue
    end
    object EditWhatValue: TEdit
      Left = 128
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonWhatValue: TButton
      Left = 302
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077
      Caption = '...'
      TabOrder = 1
    end
    object EditWhatParam: TEdit
      Left = 128
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonWhatParam: TButton
      Left = 302
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 3
    end
    object EditFromParam: TEdit
      Left = 128
      Top = 91
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonFromParam: TButton
      Left = 302
      Top = 91
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 7
    end
    object EditFromValue: TEdit
      Left = 128
      Top = 64
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonFromValue: TButton
      Left = 302
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077
      Caption = '...'
      TabOrder = 5
    end
  end
end
