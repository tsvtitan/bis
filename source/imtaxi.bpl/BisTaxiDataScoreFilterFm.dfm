inherited BisTaxiDataScoreFilterForm: TBisTaxiDataScoreFilterForm
  Caption = 'BisTaxiDataScoreFilterForm'
  ClientHeight = 264
  ClientWidth = 488
  ExplicitWidth = 496
  ExplicitHeight = 298
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 226
    Width = 488
    inherited ButtonOk: TButton
      Left = 309
    end
    inherited ButtonCancel: TButton
      Left = 405
    end
  end
  inherited PanelControls: TPanel
    Width = 488
    Height = 226
    inherited LabelDescription: TLabel
      Top = 74
      ExplicitTop = 74
    end
    inherited LabelDateCreate: TLabel
      Left = 37
      Top = 170
      Width = 38
      Caption = #1044#1072#1090#1072' '#1089':'
      ExplicitLeft = 37
      ExplicitTop = 239
      ExplicitWidth = 38
    end
    inherited LabelCreator: TLabel
      Left = 213
      Top = 197
      ExplicitLeft = 213
      ExplicitTop = 266
    end
    inherited LabelAmount: TLabel
      Left = 361
      Top = 47
      ExplicitLeft = 361
      ExplicitTop = 47
    end
    object LabelDateCreateTo: TLabel [6]
      Left = 258
      Top = 170
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerCreateTo
      ExplicitTop = 239
    end
    inherited EditRating: TEdit
      Width = 222
      ExplicitWidth = 222
    end
    inherited ButtonRating: TButton
      Left = 309
      ExplicitLeft = 309
    end
    inherited MemoDescription: TMemo
      Top = 71
      Width = 394
      Height = 90
      ExplicitTop = 71
      ExplicitWidth = 394
      ExplicitHeight = 159
    end
    inherited EditDriver: TEdit
      Width = 222
      ExplicitWidth = 222
    end
    inherited ButtonDriver: TButton
      Left = 309
      ExplicitLeft = 309
    end
    inherited DateTimePickerCreate: TDateTimePicker
      Left = 81
      Top = 167
      ExplicitLeft = 81
      ExplicitTop = 236
    end
    inherited DateTimePickerCreateTime: TDateTimePicker
      Left = 175
      Top = 167
      ExplicitLeft = 175
      ExplicitTop = 236
    end
    inherited EditCreator: TEdit
      Left = 280
      Top = 194
      Width = 168
      Color = clWindow
      ReadOnly = False
      TabOrder = 11
      ExplicitLeft = 280
      ExplicitTop = 194
      ExplicitWidth = 168
    end
    inherited EditAmount: TEdit
      Left = 403
      Top = 44
      ExplicitLeft = 403
      ExplicitTop = 44
    end
    object DateTimePickerCreateTo: TDateTimePicker [16]
      Left = 280
      Top = 167
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 8
      ExplicitTop = 236
    end
    object DateTimePickerCreateToTime: TDateTimePicker [17]
      Left = 374
      Top = 167
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
      ExplicitTop = 236
    end
    object ButtonDateCreate: TButton [18]
      Left = 454
      Top = 167
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 10
      OnClick = ButtonDateCreateClick
      ExplicitTop = 236
    end
    inherited ButtonCreator: TButton
      Left = 454
      Top = 194
      TabOrder = 12
      ExplicitLeft = 454
      ExplicitTop = 194
    end
  end
  inherited ImageList: TImageList
    Left = 128
    Top = 80
  end
end
