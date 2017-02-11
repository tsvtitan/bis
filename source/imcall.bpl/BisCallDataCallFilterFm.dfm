inherited BisCallDataCallFilterForm: TBisCallDataCallFilterForm
  Caption = 'BisCallDataCallFilterForm'
  ClientHeight = 357
  ClientWidth = 558
  ExplicitWidth = 574
  ExplicitHeight = 395
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 319
    Width = 558
    ExplicitTop = 319
    ExplicitWidth = 558
    inherited ButtonOk: TButton
      Left = 379
      ExplicitLeft = 379
    end
    inherited ButtonCancel: TButton
      Left = 475
      ExplicitLeft = 475
    end
  end
  inherited PanelControls: TPanel
    Width = 558
    Height = 319
    ExplicitWidth = 558
    ExplicitHeight = 319
    inherited LabelDateCreate: TLabel
      Left = 58
      Top = 182
      Width = 88
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1089':'
      ExplicitLeft = 73
      ExplicitTop = 182
      ExplicitWidth = 88
    end
    inherited LabelDirection: TLabel
      Left = 15
      Top = 128
      ExplicitLeft = 15
      ExplicitTop = 128
    end
    inherited LabelCreator: TLabel
      Left = 25
      Top = 155
      ExplicitLeft = 25
      ExplicitTop = 155
    end
    inherited LabelDateBegin: TLabel
      Left = 69
      Top = 236
      Width = 77
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1089':'
      ExplicitLeft = 84
      ExplicitTop = 236
      ExplicitWidth = 77
    end
    inherited LabelDateEnd: TLabel
      Left = 51
      Top = 263
      Width = 95
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089':'
      ExplicitLeft = 66
      ExplicitTop = 263
      ExplicitWidth = 95
    end
    inherited LabelFirm: TLabel
      Left = 277
      Top = 155
      ExplicitLeft = 277
      ExplicitTop = 155
    end
    inherited LabelCallResult: TLabel
      Left = 290
      Top = 128
      ExplicitLeft = 290
      ExplicitTop = 128
    end
    inherited LabelTypeEnd: TLabel
      Left = 267
      Top = 290
      ExplicitLeft = 282
      ExplicitTop = 290
    end
    object LabelDateCreateTo: TLabel [8]
      Left = 330
      Top = 182
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerCreateTo
      ExplicitLeft = 331
    end
    object LabelDateBeginTo: TLabel [9]
      Left = 330
      Top = 236
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerBeginTo
      ExplicitLeft = 345
    end
    object LabelDateEndTo: TLabel [10]
      Left = 330
      Top = 263
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerEndTo
      ExplicitLeft = 345
    end
    inherited LabelDateFound: TLabel
      Left = 37
      Top = 209
      Width = 109
      Caption = #1044#1072#1090#1072' '#1086#1073#1085#1072#1088#1091#1078#1077#1085#1080#1103' '#1089':'
      ExplicitLeft = 52
      ExplicitTop = 209
      ExplicitWidth = 109
    end
    object LabelDateFoundTo: TLabel [12]
      Left = 330
      Top = 209
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerFoundTo
      ExplicitLeft = 345
    end
    inherited DateTimePickerCreate: TDateTimePicker
      Left = 152
      Top = 179
      Anchors = [akTop, akRight]
      TabOrder = 7
      ExplicitLeft = 152
      ExplicitTop = 179
    end
    inherited DateTimePickerCreateTime: TDateTimePicker
      Left = 246
      Top = 179
      Anchors = [akTop, akRight]
      TabOrder = 8
      ExplicitLeft = 246
      ExplicitTop = 179
    end
    inherited ComboBoxDirection: TComboBox
      Left = 92
      Top = 125
      TabOrder = 2
      ExplicitLeft = 92
      ExplicitTop = 125
    end
    inherited EditCreator: TEdit
      Left = 92
      Top = 152
      Width = 141
      ExplicitLeft = 92
      ExplicitTop = 152
      ExplicitWidth = 141
    end
    inherited DateTimePickerBegin: TDateTimePicker
      Left = 152
      Top = 233
      TabOrder = 17
      ExplicitLeft = 152
      ExplicitTop = 233
    end
    inherited DateTimePickerBeginTime: TDateTimePicker
      Left = 246
      Top = 233
      TabOrder = 18
      ExplicitLeft = 246
      ExplicitTop = 233
    end
    inherited DateTimePickerEnd: TDateTimePicker
      Left = 152
      Top = 260
      TabOrder = 22
      ExplicitLeft = 152
      ExplicitTop = 260
    end
    inherited DateTimePickerEndTime: TDateTimePicker
      Left = 246
      Top = 260
      TabOrder = 23
      ExplicitLeft = 246
      ExplicitTop = 260
    end
    inherited ComboBoxFirm: TComboBox
      Left = 353
      Top = 152
      Width = 194
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
      ExplicitLeft = 353
      ExplicitTop = 152
      ExplicitWidth = 194
    end
    inherited ComboBoxCallResult: TComboBox
      Left = 353
      Top = 125
      Width = 194
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      ExplicitLeft = 353
      ExplicitTop = 125
      ExplicitWidth = 194
    end
    inherited ComboBoxTypeEnd: TComboBox
      Left = 352
      Top = 287
      Width = 195
      TabOrder = 27
      ExplicitLeft = 352
      ExplicitTop = 287
      ExplicitWidth = 195
    end
    inherited GroupBoxCaller: TGroupBox
      Left = 10
      Top = 7
      Width = 537
      Height = 52
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitLeft = 10
      ExplicitTop = 7
      ExplicitWidth = 537
      ExplicitHeight = 52
      inherited LabelCallerPhone: TLabel
        Left = 353
        Top = 23
        Anchors = [akTop, akRight]
        ExplicitLeft = 354
        ExplicitTop = 23
      end
      inherited EditCaller: TEdit
        Width = 201
        Anchors = [akLeft, akTop, akRight]
        ExplicitWidth = 201
      end
      inherited ButtonCaller: TButton
        Left = 315
        Anchors = [akTop, akRight]
        ExplicitLeft = 315
      end
      inherited EditCallerPhone: TEdit
        Left = 407
        Top = 20
        Width = 117
        Anchors = [akTop, akRight]
        ExplicitLeft = 407
        ExplicitTop = 20
        ExplicitWidth = 117
      end
    end
    inherited GroupBoxAcceptor: TGroupBox
      Left = 10
      Top = 65
      Width = 537
      Height = 51
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 10
      ExplicitTop = 65
      ExplicitWidth = 537
      ExplicitHeight = 51
      inherited LabelAcceptorPhone: TLabel
        Left = 353
        Top = 22
        ExplicitLeft = 354
        ExplicitTop = 22
      end
      inherited EditAcceptor: TEdit
        Width = 201
        Anchors = [akLeft, akTop, akRight]
        ExplicitWidth = 201
      end
      inherited ButtonAcceptor: TButton
        Left = 315
        ExplicitLeft = 315
      end
      inherited EditAcceptorPhone: TEdit
        Left = 407
        Top = 19
        Width = 117
        ExplicitLeft = 407
        ExplicitTop = 19
        ExplicitWidth = 117
      end
    end
    inherited DateTimePickerFound: TDateTimePicker
      Left = 152
      Top = 206
      TabOrder = 12
      ExplicitLeft = 152
      ExplicitTop = 206
    end
    inherited DateTimePickerFoundTime: TDateTimePicker
      Left = 246
      Top = 206
      TabOrder = 13
      ExplicitLeft = 246
      ExplicitTop = 206
    end
    object DateTimePickerCreateTo: TDateTimePicker
      Left = 352
      Top = 179
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 9
    end
    object DateTimePickerCreateTimeTo: TDateTimePicker
      Left = 446
      Top = 179
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 10
    end
    object ButtonDateCreate: TButton
      Left = 526
      Top = 179
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 11
      OnClick = ButtonDateCreateClick
    end
    object DateTimePickerBeginTo: TDateTimePicker
      Left = 352
      Top = 233
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 19
    end
    object DateTimePickerBeginTimeTo: TDateTimePicker
      Left = 446
      Top = 233
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 20
    end
    object ButtonDateBegin: TButton
      Left = 526
      Top = 233
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 21
      OnClick = ButtonDateBeginClick
    end
    object DateTimePickerEndTo: TDateTimePicker
      Left = 352
      Top = 260
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 24
    end
    object DateTimePickerEndTimeTo: TDateTimePicker
      Left = 446
      Top = 260
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 25
    end
    object ButtonDateEnd: TButton
      Left = 526
      Top = 260
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 26
      OnClick = ButtonDateEndClick
    end
    object ButtonCreator: TButton
      Left = 239
      Top = 152
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 5
    end
    object DateTimePickerFoundTo: TDateTimePicker
      Left = 352
      Top = 206
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 14
    end
    object DateTimePickerFoundTimeTo: TDateTimePicker
      Left = 446
      Top = 206
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 15
    end
    object ButtonDateFound: TButton
      Left = 526
      Top = 206
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 16
      OnClick = ButtonDateFoundClick
    end
  end
  inherited ImageList: TImageList
    Left = 224
    Top = 48
  end
  inherited OpenDialog: TOpenDialog
    Left = 160
    Top = 48
  end
  inherited SaveDialog: TSaveDialog
    Left = 120
    Top = 48
  end
end
