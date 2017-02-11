inherited BisKrieltDataIssueEditForm: TBisKrieltDataIssueEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataIssueEditForm'
  ClientHeight = 230
  ClientWidth = 377
  ExplicitWidth = 385
  ExplicitHeight = 264
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 192
    Width = 377
    ExplicitTop = 192
    ExplicitWidth = 377
    inherited ButtonOk: TButton
      Left = 198
      ExplicitLeft = 198
    end
    inherited ButtonCancel: TButton
      Left = 295
      ExplicitLeft = 295
    end
  end
  inherited PanelControls: TPanel
    Width = 377
    Height = 192
    ExplicitWidth = 377
    ExplicitHeight = 192
    object LabelPublishing: TLabel
      Left = 36
      Top = 42
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1079#1076#1072#1085#1080#1077':'
      FocusControl = EditPublishing
    end
    object LabelNum: TLabel
      Left = 48
      Top = 15
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088':'
      FocusControl = EditNum
    end
    object LabelDescription: TLabel
      Left = 30
      Top = 69
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelDateBegin: TLabel
      Left = 14
      Top = 164
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 182
      Top = 164
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077':'
      FocusControl = DateTimePickerEnd
    end
    object EditPublishing: TEdit
      Left = 89
      Top = 39
      Width = 176
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonPublishing: TButton
      Left = 271
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079#1076#1072#1085#1080#1077
      Caption = '...'
      TabOrder = 2
    end
    object EditNum: TEdit
      Left = 89
      Top = 12
      Width = 136
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 89
      Top = 66
      Width = 274
      Height = 89
      TabOrder = 3
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 89
      Top = 161
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 4
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 248
      Top = 161
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 5
    end
    object ButtonPeriod: TButton
      Left = 342
      Top = 161
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Caption = '...'
      TabOrder = 6
      OnClick = ButtonPeriodClick
    end
  end
end
