inherited BisKrieltDataSubscriptionEditForm: TBisKrieltDataSubscriptionEditForm
  Left = 683
  Top = 368
  Caption = 'BisKrieltDataSubscriptionEditForm'
  ClientHeight = 200
  ClientWidth = 322
  ExplicitWidth = 330
  ExplicitHeight = 234
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 162
    Width = 322
    ExplicitTop = 162
    ExplicitWidth = 322
    inherited ButtonOk: TButton
      Left = 143
      ExplicitLeft = 143
    end
    inherited ButtonCancel: TButton
      Left = 240
      ExplicitLeft = 240
    end
  end
  inherited PanelControls: TPanel
    Width = 322
    Height = 162
    ExplicitWidth = 322
    ExplicitHeight = 162
    object LabelName: TLabel
      Left = 13
      Top = 16
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 37
      Top = 69
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelService: TLabel
      Left = 52
      Top = 42
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1089#1083#1091#1075#1072':'
      FocusControl = EditService
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 216
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 66
      Width = 216
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 3
    end
    object EditService: TEdit
      Left = 97
      Top = 39
      Width = 188
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonService: TButton
      Left = 291
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1089#1083#1091#1075#1091
      Caption = '...'
      TabOrder = 2
    end
  end
end
