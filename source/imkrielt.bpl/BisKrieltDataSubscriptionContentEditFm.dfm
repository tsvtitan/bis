inherited BisKrieltDataSubscriptionContentEditForm: TBisKrieltDataSubscriptionContentEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataSubscriptionContentEditForm'
  ClientHeight = 185
  ClientWidth = 301
  ExplicitWidth = 309
  ExplicitHeight = 219
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 147
    Width = 301
    ExplicitTop = 147
    ExplicitWidth = 301
    inherited ButtonOk: TButton
      Left = 122
      ExplicitLeft = 122
    end
    inherited ButtonCancel: TButton
      Left = 219
      ExplicitLeft = 219
    end
  end
  inherited PanelControls: TPanel
    Width = 301
    Height = 147
    ExplicitWidth = 301
    ExplicitHeight = 147
    object LabelView: TLabel
      Left = 14
      Top = 67
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditView
    end
    object LabelType: TLabel
      Left = 15
      Top = 94
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditType
    end
    object LabelOperation: TLabel
      Left = 35
      Top = 121
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
      FocusControl = EditOperation
    end
    object LabelSubscription: TLabel
      Left = 36
      Top = 13
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1076#1087#1080#1089#1082#1072':'
      FocusControl = EditSubscription
    end
    object LabelPublishing: TLabel
      Left = 42
      Top = 40
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1079#1076#1072#1085#1080#1077':'
      FocusControl = EditPublishing
    end
    object EditView: TEdit
      Left = 95
      Top = 64
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonView: TButton
      Left = 269
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076
      Caption = '...'
      TabOrder = 5
    end
    object EditType: TEdit
      Left = 95
      Top = 91
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonType: TButton
      Left = 269
      Top = 91
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087
      Caption = '...'
      TabOrder = 7
    end
    object EditOperation: TEdit
      Left = 95
      Top = 118
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 8
    end
    object ButtonOperation: TButton
      Left = 269
      Top = 118
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 9
    end
    object EditSubscription: TEdit
      Left = 95
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonSubscription: TButton
      Left = 269
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1076#1087#1080#1089#1082#1091
      Caption = '...'
      TabOrder = 1
    end
    object EditPublishing: TEdit
      Left = 95
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonPublishing: TButton
      Left = 269
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079#1076#1072#1085#1080#1077
      Caption = '...'
      TabOrder = 3
    end
  end
end
