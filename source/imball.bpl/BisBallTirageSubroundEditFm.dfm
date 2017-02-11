inherited BisBallTirageSubroundEditForm: TBisBallTirageSubroundEditForm
  Left = 513
  Top = 212
  Caption = 'BisBallTirageSubroundEditForm'
  ClientHeight = 134
  ClientWidth = 296
  ExplicitWidth = 304
  ExplicitHeight = 168
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 96
    Width = 296
    ExplicitTop = 96
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 117
      ExplicitLeft = 118
    end
    inherited ButtonCancel: TButton
      Left = 213
      ExplicitLeft = 214
    end
  end
  inherited PanelControls: TPanel
    Width = 296
    Height = 96
    ExplicitWidth = 297
    ExplicitHeight = 96
    object LabelName: TLabel
      Left = 16
      Top = 40
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelPriority: TLabel
      Left = 45
      Top = 13
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelRoundNum: TLabel
      Left = 153
      Top = 13
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1091#1088' 2 '#1080#1075#1088#1099':'
      FocusControl = ComboBoxRoundNum
      Visible = False
    end
    object LabelPercent: TLabel
      Left = 164
      Top = 67
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1086#1094#1077#1085#1090':'
      FocusControl = EditPercent
      ExplicitLeft = 165
    end
    object EditName: TEdit
      Left = 99
      Top = 37
      Width = 180
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      ExplicitWidth = 181
    end
    object EditPriority: TEdit
      Left = 99
      Top = 10
      Width = 47
      Height = 21
      Hint = #1055#1086#1088#1103#1076#1086#1082' '#1088#1086#1079#1099#1075#1088#1099#1096#1072
      MaxLength = 100
      TabOrder = 0
      OnChange = EditPriorityChange
    end
    object EditPercent: TEdit
      Left = 217
      Top = 64
      Width = 62
      Height = 21
      Anchors = [akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 3
      ExplicitLeft = 218
    end
    object ComboBoxRoundNum: TComboBox
      Left = 218
      Top = 10
      Width = 62
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 3
      TabOrder = 1
      Text = '4'
      Visible = False
      Items.Strings = (
        '1'
        '2'
        '3'
        '4')
    end
  end
  inherited ImageList: TImageList
    Left = 40
    Top = 72
  end
end
