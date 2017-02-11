inherited BisLotoDataMemberEditForm: TBisLotoDataMemberEditForm
  Left = 513
  Top = 212
  Caption = 'BisLotoDataMemberEditForm'
  ClientHeight = 190
  ClientWidth = 334
  ExplicitWidth = 342
  ExplicitHeight = 224
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 152
    Width = 334
    ExplicitTop = 355
    ExplicitWidth = 571
    inherited ButtonOk: TButton
      Left = 155
      ExplicitLeft = 392
    end
    inherited ButtonCancel: TButton
      Left = 251
      ExplicitLeft = 488
    end
  end
  inherited PanelControls: TPanel
    Width = 334
    Height = 152
    ExplicitTop = -1
    ExplicitWidth = 571
    ExplicitHeight = 355
    object LabelName: TLabel
      Left = 68
      Top = 40
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
      FocusControl = EditName
    end
    object LabelWorkPlace: TLabel
      Left = 18
      Top = 94
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099':'
      FocusControl = EditWorkPlace
    end
    object LabelSurname: TLabel
      Left = 41
      Top = 13
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      FocusControl = EditSurname
    end
    object LabelPatronymic: TLabel
      Left = 43
      Top = 67
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditPatronymic
    end
    object LabelWorkPosition: TLabel
      Left = 32
      Top = 121
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
      FocusControl = EditWorkPosition
    end
    object EditName: TEdit
      Left = 99
      Top = 37
      Width = 137
      Height = 21
      TabOrder = 1
    end
    object EditWorkPlace: TEdit
      Left = 99
      Top = 91
      Width = 220
      Height = 21
      MaxLength = 100
      TabOrder = 3
    end
    object EditSurname: TEdit
      Left = 99
      Top = 10
      Width = 137
      Height = 21
      TabOrder = 0
    end
    object EditPatronymic: TEdit
      Left = 99
      Top = 64
      Width = 174
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 2
    end
    object EditWorkPosition: TEdit
      Left = 99
      Top = 118
      Width = 220
      Height = 21
      Constraints.MaxWidth = 220
      MaxLength = 100
      TabOrder = 4
    end
  end
  inherited ImageList: TImageList
    Left = 256
    Top = 16
  end
end
