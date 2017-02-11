inherited BisMessDataAccountEditForm: TBisMessDataAccountEditForm
  Left = 659
  Top = 255
  Caption = 'BisMessDataAccountEditForm'
  ClientHeight = 348
  ClientWidth = 531
  ExplicitWidth = 539
  ExplicitHeight = 382
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 310
    Width = 531
    ExplicitTop = 310
    ExplicitWidth = 531
    inherited ButtonOk: TButton
      Left = 351
      ExplicitLeft = 351
    end
    inherited ButtonCancel: TButton
      Left = 448
      ExplicitLeft = 448
    end
  end
  inherited PanelControls: TPanel
    Width = 531
    Height = 310
    ExplicitWidth = 531
    ExplicitHeight = 310
    object LabelDescription: TLabel
      Left = 80
      Top = 201
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelSurname: TLabel
      Left = 22
      Top = 12
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      FocusControl = EditSurname
    end
    object LabelName: TLabel
      Left = 217
      Top = 12
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
      FocusControl = EditName
    end
    object LabelPatronymic: TLabel
      Left = 360
      Top = 12
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditPatronymic
    end
    object LabelPhone: TLabel
      Left = 26
      Top = 39
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
    end
    object LabelEmail: TLabel
      Left = 349
      Top = 39
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1095#1090#1072':'
      FocusControl = EditEmail
    end
    object LabelDateCreate: TLabel
      Left = 265
      Top = 282
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
    end
    object MemoDescription: TMemo
      Left = 80
      Top = 220
      Width = 439
      Height = 53
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 7
    end
    object EditSurname: TEdit
      Left = 80
      Top = 9
      Width = 116
      Height = 21
      TabOrder = 0
    end
    object EditName: TEdit
      Left = 248
      Top = 9
      Width = 90
      Height = 21
      TabOrder = 1
    end
    object EditPatronymic: TEdit
      Left = 416
      Top = 9
      Width = 103
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 200
      TabOrder = 2
    end
    object EditPhone: TEdit
      Left = 80
      Top = 36
      Width = 258
      Height = 21
      TabOrder = 3
    end
    object EditEmail: TEdit
      Left = 388
      Top = 36
      Width = 131
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object GroupBoxRoles: TGroupBox
      Left = 267
      Top = 63
      Width = 252
      Height = 132
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1056#1086#1083#1080' '
      TabOrder = 6
      object CheckListBoxRoles: TCheckListBox
        AlignWithMargins = True
        Left = 7
        Top = 18
        Width = 238
        Height = 107
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        OnClickCheck = CheckListBoxRolesClickCheck
        Align = alClient
        ItemHeight = 15
        Style = lbOwnerDrawFixed
        TabOrder = 0
      end
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 351
      Top = 279
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 8
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 445
      Top = 279
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
    end
    object PanelPhoto: TPanel
      Left = 80
      Top = 64
      Width = 181
      Height = 131
      BevelOuter = bvNone
      Caption = #1053#1077#1090' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1080
      Color = clWindow
      ParentBackground = False
      TabOrder = 5
      object ShapePhoto: TShape
        Left = 0
        Top = 0
        Width = 181
        Height = 131
        Align = alClient
        Brush.Style = bsClear
        Pen.Style = psDot
        ExplicitLeft = 32
        ExplicitTop = 40
        ExplicitWidth = 65
        ExplicitHeight = 65
      end
      object ImagePhoto: TImage
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 175
        Height = 125
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
        Left = 99
        Top = 99
        Width = 75
        Height = 25
        Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1077#1081
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
        TabOrder = 0
        OnClick = ButtonPhotoClick
      end
    end
  end
  inherited ImageList: TImageList
    Left = 120
    Top = 136
  end
  object PopupActionBarPhoto: TPopupActionBar
    OnPopup = PopupActionBarPhotoPopup
    Left = 197
    Top = 72
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
    Left = 157
    Top = 72
  end
  object SavePictureDialog: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 117
    Top = 72
  end
end
