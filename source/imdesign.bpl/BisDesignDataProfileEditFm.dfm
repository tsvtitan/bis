inherited BisDesignDataProfileEditForm: TBisDesignDataProfileEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataProfileEditForm'
  ClientHeight = 386
  ClientWidth = 411
  ExplicitWidth = 419
  ExplicitHeight = 420
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 348
    Width = 411
    ExplicitTop = 348
    ExplicitWidth = 411
    inherited ButtonOk: TButton
      Left = 232
      ExplicitLeft = 232
    end
    inherited ButtonCancel: TButton
      Left = 328
      ExplicitLeft = 328
    end
  end
  inherited PanelControls: TPanel
    Width = 411
    Height = 348
    ExplicitWidth = 411
    ExplicitHeight = 348
    object LabelApplication: TLabel
      Left = 9
      Top = 13
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
      FocusControl = EditApplication
    end
    object LabelLogin: TLabel
      Left = 42
      Top = 40
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = #1051#1086#1075#1080#1085':'
      FocusControl = EditLogin
    end
    object LabelProfile: TLabel
      Left = 27
      Top = 67
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1086#1092#1080#1083#1100':'
      FocusControl = MemoProfile
    end
    object EditApplication: TEdit
      Left = 84
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonApplication: TButton
      Left = 258
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Caption = '...'
      TabOrder = 1
    end
    object EditLogin: TEdit
      Left = 84
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonLogin: TButton
      Left = 258
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 3
    end
    object MemoProfile: TMemo
      Left = 84
      Top = 64
      Width = 317
      Height = 278
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 4
      WordWrap = False
    end
  end
end