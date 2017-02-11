inherited BisKrieltDataConsultantEditForm: TBisKrieltDataConsultantEditForm
  Left = 659
  Top = 255
  Caption = 'BisKrieltDataConsultantEditForm'
  ClientHeight = 330
  ClientWidth = 465
  ExplicitWidth = 473
  ExplicitHeight = 364
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 292
    Width = 465
    ExplicitTop = 292
    ExplicitWidth = 465
    inherited ButtonOk: TButton
      Left = 285
      ExplicitLeft = 285
    end
    inherited ButtonCancel: TButton
      Left = 382
      ExplicitLeft = 382
    end
  end
  inherited PanelControls: TPanel
    Width = 465
    Height = 292
    ExplicitTop = -1
    ExplicitWidth = 465
    ExplicitHeight = 292
    object LabelUserName: TLabel
      Left = 46
      Top = 13
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = #1051#1086#1075#1080#1085':'
      FocusControl = EditUserName
    end
    object LabelDescription: TLabel
      Left = 15
      Top = 148
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPassword: TLabel
      Left = 39
      Top = 40
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1086#1083#1100':'
      FocusControl = EditPassword
    end
    object LabelSurname: TLabel
      Left = 32
      Top = 67
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      FocusControl = EditSurname
    end
    object LabelName: TLabel
      Left = 57
      Top = 94
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
      FocusControl = EditName
    end
    object LabelPatronymic: TLabel
      Left = 27
      Top = 121
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditPatronymic
    end
    object LabelPhone: TLabel
      Left = 32
      Top = 212
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
      ExplicitTop = 315
    end
    object LabelEmail: TLabel
      Left = 272
      Top = 212
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1095#1090#1072':'
      FocusControl = EditEmail
      ExplicitTop = 288
    end
    object LabelFirm: TLabel
      Left = 10
      Top = 239
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      FocusControl = EditFirm
      ExplicitTop = 342
    end
    object LabelDateCreate: TLabel
      Left = 202
      Top = 266
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitLeft = 208
    end
    object LabelJobTitle: TLabel
      Left = 296
      Top = 239
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
      FocusControl = EditJobTitle
      ExplicitTop = 315
    end
    object EditUserName: TEdit
      Left = 86
      Top = 10
      Width = 171
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 86
      Top = 145
      Width = 370
      Height = 58
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 7
    end
    object EditPassword: TEdit
      Left = 86
      Top = 37
      Width = 78
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object CheckBoxLocked: TCheckBox
      Left = 170
      Top = 39
      Width = 87
      Height = 17
      Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072
      TabOrder = 2
    end
    object EditSurname: TEdit
      Left = 86
      Top = 64
      Width = 171
      Height = 21
      TabOrder = 3
    end
    object EditName: TEdit
      Left = 86
      Top = 91
      Width = 171
      Height = 21
      TabOrder = 4
    end
    object EditPatronymic: TEdit
      Left = 86
      Top = 118
      Width = 171
      Height = 21
      TabOrder = 5
    end
    object EditPhone: TEdit
      Left = 86
      Top = 209
      Width = 171
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 8
    end
    object EditEmail: TEdit
      Left = 313
      Top = 209
      Width = 143
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Constraints.MaxHeight = 300
      TabOrder = 9
    end
    object EditFirm: TEdit
      Left = 86
      Top = 236
      Width = 171
      Height = 21
      Anchors = [akLeft, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 10
    end
    object ButtonFirm: TButton
      Left = 263
      Top = 236
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Anchors = [akLeft, akBottom]
      Caption = '...'
      TabOrder = 11
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 288
      Top = 263
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 13
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 382
      Top = 263
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 14
    end
    object PanelPhoto: TPanel
      Left = 266
      Top = 10
      Width = 190
      Height = 129
      BevelOuter = bvNone
      Caption = #1053#1077#1090' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1080
      Color = clWindow
      ParentBackground = False
      TabOrder = 6
      DesignSize = (
        190
        129)
      object ShapePhoto: TShape
        Left = 0
        Top = 0
        Width = 190
        Height = 129
        Align = alClient
        Brush.Style = bsClear
        Pen.Style = psDot
        ExplicitTop = 1
        ExplicitWidth = 180
      end
      object ImagePhoto: TImage
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 184
        Height = 123
        Align = alClient
        Center = True
        PopupMenu = PopupActionBarPhoto
        Proportional = True
        Stretch = True
        ExplicitLeft = 0
        ExplicitTop = -80
        ExplicitWidth = 181
        ExplicitHeight = 131
      end
      object ButtonPhoto: TButton
        Left = 108
        Top = 97
        Width = 75
        Height = 25
        Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1077#1081
        Anchors = [akRight, akBottom]
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
        TabOrder = 0
        OnClick = ButtonPhotoClick
      end
    end
    object EditJobTitle: TEdit
      Left = 363
      Top = 236
      Width = 93
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Constraints.MaxHeight = 300
      TabOrder = 12
    end
  end
  inherited ImageList: TImageList
    Left = 288
    Top = 32
  end
  object PopupActionBarPhoto: TPopupActionBar
    OnPopup = PopupActionBarPhotoPopup
    Left = 413
    Top = 32
    object MenuItemLoadPhoto: TMenuItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1102
      OnClick = MenuItemLoadPhotoClick
    end
    object MenuItemSavePhoto: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1102
      OnClick = MenuItemSavePhotoClick
    end
    object MenuItemClearPhoto: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1086#1090#1086
      OnClick = MenuItemClearPhotoClick
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 373
    Top = 32
  end
  object SavePictureDialog: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 333
    Top = 32
  end
end
