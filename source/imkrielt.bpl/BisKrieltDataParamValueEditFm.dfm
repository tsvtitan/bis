inherited BisKrieltDataParamValueEditForm: TBisKrieltDataParamValueEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataParamValueEditForm'
  ClientHeight = 271
  ClientWidth = 545
  ExplicitWidth = 553
  ExplicitHeight = 305
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 233
    Width = 545
    ExplicitTop = 233
    ExplicitWidth = 545
    inherited ButtonOk: TButton
      Left = 366
      ExplicitLeft = 366
    end
    inherited ButtonCancel: TButton
      Left = 463
      ExplicitLeft = 463
    end
  end
  inherited PanelControls: TPanel
    Width = 545
    Height = 233
    ExplicitWidth = 545
    ExplicitHeight = 233
    object LabelParam: TLabel
      Left = 17
      Top = 15
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditParam
    end
    object LabelName: TLabel
      Left = 18
      Top = 42
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 17
      Top = 96
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPriority: TLabel
      Left = 164
      Top = 210
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelVariants: TLabel
      Left = 304
      Top = 15
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1072#1088#1080#1072#1085#1090#1099':'
      FocusControl = MemoVariants
    end
    object LabelExport: TLabel
      Left = 25
      Top = 69
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1069#1082#1089#1087#1086#1088#1090':'
      FocusControl = EditExport
    end
    object EditParam: TEdit
      Left = 76
      Top = 12
      Width = 188
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParam: TButton
      Left = 270
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 1
    end
    object EditName: TEdit
      Left = 76
      Top = 39
      Width = 215
      Height = 21
      TabOrder = 2
    end
    object MemoDescription: TMemo
      Left = 76
      Top = 93
      Width = 215
      Height = 108
      Anchors = [akLeft, akTop, akBottom]
      TabOrder = 4
    end
    object EditPriority: TEdit
      Left = 218
      Top = 207
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 5
    end
    object MemoVariants: TMemo
      Left = 297
      Top = 34
      Width = 240
      Height = 194
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 6
    end
    object EditExport: TEdit
      Left = 76
      Top = 66
      Width = 215
      Height = 21
      TabOrder = 3
    end
  end
end
