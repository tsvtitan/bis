inherited BisDocproManagementMasterEditForm: TBisDocproManagementMasterEditForm
  Left = 644
  Top = 253
  Caption = 'BisDocproManagementMasterEditForm'
  ClientHeight = 410
  ClientWidth = 392
  Font.Name = 'Tahoma'
  ExplicitLeft = 644
  ExplicitTop = 253
  ExplicitWidth = 400
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 372
    Width = 392
    ExplicitTop = 415
    ExplicitWidth = 634
    inherited ButtonOk: TButton
      Left = 216
      Top = 8
      ExplicitLeft = 458
      ExplicitTop = 8
    end
    inherited ButtonCancel: TButton
      Left = 312
      Top = 8
      ExplicitLeft = 554
      ExplicitTop = 8
    end
  end
  inherited PanelControls: TPanel
    Width = 392
    Height = 372
    ExplicitLeft = 8
    ExplicitTop = 2
    ExplicitWidth = 354
    ExplicitHeight = 203
    object LabelDateIssue: TLabel
      Left = 23
      Top = 16
      Width = 82
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080':'
      FocusControl = DateTimePickerDateIssue
    end
    object LabelWhoFirm: TLabel
      Left = 68
      Top = 43
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1076#1077#1083':'
      FocusControl = EditWhoFirm
    end
    object LabelWhoAccount: TLabel
      Left = 36
      Top = 70
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1090#1086' '#1087#1077#1088#1077#1076#1072#1083':'
      FocusControl = EditWhoAccount
    end
    object DateTimePickerDateIssue: TDateTimePicker
      Left = 111
      Top = 13
      Width = 89
      Height = 21
      Date = 39741.612262361110000000
      Time = 39741.612262361110000000
      TabOrder = 0
    end
    object DateTimePickerTimeIssue: TDateTimePicker
      Left = 206
      Top = 13
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 1
    end
    object GroupBoxDoc: TGroupBox
      Left = 15
      Top = 96
      Width = 363
      Height = 79
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1044#1086#1082#1091#1084#1077#1085#1090' '
      TabOrder = 4
      ExplicitWidth = 334
      DesignSize = (
        363
        79)
      object LabelName: TLabel
        Left = 17
        Top = 48
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
        FocusControl = EditName
      end
      object LabelNum: TLabel
        Left = 59
        Top = 21
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1086#1084#1077#1088':'
        FocusControl = EditNum
      end
      object LabelDateDoc: TLabel
        Left = 196
        Top = 21
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072':'
        FocusControl = DateTimePickerDateDoc
      end
      object EditName: TEdit
        Left = 100
        Top = 45
        Width = 249
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        ExplicitWidth = 220
      end
      object EditNum: TEdit
        Left = 100
        Top = 18
        Width = 88
        Height = 21
        MaxLength = 100
        TabOrder = 1
      end
      object DateTimePickerDateDoc: TDateTimePicker
        Left = 232
        Top = 18
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        TabOrder = 2
      end
    end
    object EditWhoFirm: TEdit
      Left = 111
      Top = 40
      Width = 194
      Height = 21
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object EditWhoAccount: TEdit
      Left = 111
      Top = 67
      Width = 224
      Height = 21
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
    end
    object GroupBoxDescription: TGroupBox
      Left = 15
      Top = 183
      Width = 363
      Height = 158
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '
      TabOrder = 5
      ExplicitWidth = 334
      ExplicitHeight = 130
      object LabelDescription: TLabel
        Left = 80
        Top = 48
        Width = 65
        Height = 13
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
        FocusControl = MemoDescription
        Visible = False
      end
      object MemoDescription: TMemo
        AlignWithMargins = True
        Left = 9
        Top = 18
        Width = 345
        Height = 131
        Margins.Left = 7
        Margins.Right = 7
        Margins.Bottom = 7
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitLeft = 7
        ExplicitWidth = 320
        ExplicitHeight = 113
      end
    end
    object CheckBoxProcess: TCheckBox
      Left = 23
      Top = 347
      Width = 154
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1076#1074#1080#1078#1077#1085#1080#1077
      TabOrder = 6
    end
  end
end