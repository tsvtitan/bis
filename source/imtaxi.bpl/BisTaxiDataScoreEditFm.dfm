inherited BisTaxiDataScoreEditForm: TBisTaxiDataScoreEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataScoreEditForm'
  ClientHeight = 268
  ClientWidth = 302
  ExplicitWidth = 310
  ExplicitHeight = 302
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 230
    Width = 302
    ExplicitTop = 207
    ExplicitWidth = 302
    DesignSize = (
      302
      38)
    inherited ButtonOk: TButton
      Left = 123
      ExplicitLeft = 123
    end
    inherited ButtonCancel: TButton
      Left = 219
      ExplicitLeft = 219
    end
  end
  inherited PanelControls: TPanel
    Width = 302
    Height = 230
    ExplicitWidth = 302
    ExplicitHeight = 207
    DesignSize = (
      302
      230)
    object LabelRating: TLabel
      Left = 13
      Top = 47
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076' '#1086#1094#1077#1085#1082#1080':'
      FocusControl = EditRating
    end
    object LabelDescription: TLabel
      Left = 22
      Top = 101
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
    end
    object LabelDriver: TLabel
      Left = 22
      Top = 20
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditDriver
    end
    object LabelDateCreate: TLabel
      Left = 34
      Top = 178
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
    end
    object LabelCreator: TLabel
      Left = 53
      Top = 205
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
    end
    object LabelAmount: TLabel
      Left = 39
      Top = 74
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = #1041#1072#1083#1083#1099':'
      FocusControl = EditAmount
    end
    object EditRating: TEdit
      Left = 81
      Top = 44
      Width = 164
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonRating: TButton
      Left = 251
      Top = 44
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076' '#1086#1094#1077#1085#1082#1080
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
    end
    object MemoDescription: TMemo
      Left = 81
      Top = 98
      Width = 207
      Height = 71
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
    end
    object EditDriver: TEdit
      Left = 81
      Top = 17
      Width = 164
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonDriver: TButton
      Left = 251
      Top = 17
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1103
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 120
      Top = 175
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 6
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 214
      Top = 175
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 7
    end
    object EditCreator: TEdit
      Left = 120
      Top = 202
      Width = 141
      Height = 21
      Anchors = [akRight, akBottom]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 8
    end
    object EditAmount: TEdit
      Left = 81
      Top = 71
      Width = 72
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object ButtonCreator: TButton
      Left = 267
      Top = 202
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 9
    end
  end
  inherited ImageList: TImageList
    Left = 40
    Top = 296
  end
end
