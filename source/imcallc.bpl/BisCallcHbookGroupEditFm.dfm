inherited BisCallcHbookGroupEditForm: TBisCallcHbookGroupEditForm
  Left = 424
  Top = 189
  Caption = 'BisCallcHbookGroupEditForm'
  ClientHeight = 222
  ClientWidth = 289
  ExplicitLeft = 424
  ExplicitTop = 189
  ExplicitWidth = 297
  ExplicitHeight = 249
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 184
    Width = 289
    ExplicitTop = 172
    ExplicitWidth = 295
    inherited ButtonOk: TButton
      Left = 112
      ExplicitLeft = 118
    end
    inherited ButtonCancel: TButton
      Left = 209
      ExplicitLeft = 215
    end
  end
  inherited PanelControls: TPanel
    Width = 289
    Height = 184
    ExplicitWidth = 295
    ExplicitHeight = 172
    object LabelName: TLabel
      Left = 12
      Top = 42
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelParent: TLabel
      Left = 40
      Top = 15
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditParent
    end
    object LabelDescription: TLabel
      Left = 38
      Top = 66
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPattern: TLabel
      Left = 49
      Top = 157
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = #1064#1072#1073#1083#1086#1085':'
      FocusControl = EditPattern
    end
    object EditName: TEdit
      Left = 97
      Top = 39
      Width = 182
      Height = 21
      MaxLength = 100
      TabOrder = 2
    end
    object EditParent: TEdit
      Left = 97
      Top = 12
      Width = 155
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParent: TButton
      Left = 258
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1086#1076#1080#1090#1077#1083#1100#1089#1082#1091#1102' '#1075#1088#1091#1087#1087#1091
      Caption = '...'
      TabOrder = 1
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 66
      Width = 182
      Height = 82
      TabOrder = 3
    end
    object EditPattern: TEdit
      Left = 97
      Top = 154
      Width = 155
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonPattern: TButton
      Left = 258
      Top = 154
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1096#1072#1073#1083#1086#1085
      Caption = '...'
      TabOrder = 5
    end
  end
end
