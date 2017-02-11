inherited BisKrieltDataCommentEditForm: TBisKrieltDataCommentEditForm
  Left = 424
  Top = 189
  Caption = 'BisKrieltDataCommentEditForm'
  ClientHeight = 347
  ClientWidth = 487
  ExplicitWidth = 495
  ExplicitHeight = 381
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 309
    Width = 487
    ExplicitTop = 182
    ExplicitWidth = 380
    inherited ButtonOk: TButton
      Left = 308
      ExplicitLeft = 201
    end
    inherited ButtonCancel: TButton
      Left = 404
      ExplicitLeft = 297
    end
  end
  inherited PanelControls: TPanel
    Width = 487
    Height = 309
    ExplicitWidth = 380
    ExplicitHeight = 182
    object LabelTitle: TLabel
      Left = 57
      Top = 120
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082':'
      FocusControl = EditTitle
    end
    object LabelParent: TLabel
      Left = 61
      Top = 12
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditParent
    end
    object LabelDateComment: TLabel
      Left = 15
      Top = 39
      Width = 99
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103':'
      FocusControl = DateTimePickerComment
    end
    object LabelAccount: TLabel
      Left = 30
      Top = 66
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelArticle: TLabel
      Left = 73
      Top = 93
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1072#1090#1100#1103':'
      FocusControl = EditArticle
    end
    object LabelText: TLabel
      Left = 81
      Top = 147
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object EditTitle: TEdit
      Left = 120
      Top = 117
      Width = 350
      Height = 21
      MaxLength = 100
      TabOrder = 9
    end
    object EditParent: TEdit
      Left = 120
      Top = 9
      Width = 222
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParent: TButton
      Left = 348
      Top = 11
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1086#1076#1080#1090#1077#1083#1100#1089#1082#1091#1102' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 1
    end
    object DateTimePickerComment: TDateTimePicker
      Left = 120
      Top = 36
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 2
    end
    object DateTimePickerCommentTime: TDateTimePicker
      Left = 214
      Top = 36
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 3
    end
    object EditAccount: TEdit
      Left = 120
      Top = 63
      Width = 222
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 5
    end
    object ButtonAccount: TButton
      Left = 348
      Top = 63
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 6
    end
    object EditArticle: TEdit
      Left = 120
      Top = 90
      Width = 222
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 7
    end
    object ButtonArticle: TButton
      Left = 348
      Top = 90
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1089#1090#1072#1090#1100#1102
      Caption = '...'
      TabOrder = 8
    end
    object MemoText: TMemo
      Left = 120
      Top = 144
      Width = 350
      Height = 153
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 10
    end
    object CheckBoxVisible: TCheckBox
      Left = 294
      Top = 38
      Width = 75
      Height = 17
      Hint = #1042#1080#1076#1080#1084#1086#1089#1090#1100' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  inherited ImageList: TImageList
    Left = 48
    Top = 184
  end
end
