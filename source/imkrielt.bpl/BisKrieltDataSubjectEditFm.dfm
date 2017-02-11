inherited BisKrieltDataSubjectEditForm: TBisKrieltDataSubjectEditForm
  Left = 424
  Top = 189
  Caption = 'BisKrieltDataSubjectEditForm'
  ClientHeight = 220
  ClientWidth = 380
  ExplicitWidth = 388
  ExplicitHeight = 254
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 182
    Width = 380
    ExplicitTop = 182
    ExplicitWidth = 380
    inherited ButtonOk: TButton
      Left = 201
      ExplicitLeft = 201
    end
    inherited ButtonCancel: TButton
      Left = 297
      ExplicitLeft = 297
    end
  end
  inherited PanelControls: TPanel
    Width = 380
    Height = 182
    ExplicitWidth = 380
    ExplicitHeight = 182
    object LabelName: TLabel
      Left = 13
      Top = 39
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelParent: TLabel
      Left = 37
      Top = 12
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditParent
    end
    object LabelDescription: TLabel
      Left = 37
      Top = 66
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPriority: TLabel
      Left = 42
      Top = 154
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
      ExplicitTop = 138
    end
    object EditName: TEdit
      Left = 96
      Top = 36
      Width = 238
      Height = 21
      MaxLength = 100
      TabOrder = 2
    end
    object EditParent: TEdit
      Left = 96
      Top = 9
      Width = 211
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParent: TButton
      Left = 313
      Top = 9
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1086#1076#1080#1090#1077#1083#1100#1089#1082#1091#1102' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 1
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 63
      Width = 271
      Height = 82
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 96
      Top = 151
      Width = 75
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 4
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 
      #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' (*.bmp)|*.bmp|'#1048#1082#1086#1085#1082#1080' (*.ico)|*.ico|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*' +
      '.*'
    Options = [ofEnableSizing]
    Left = 160
    Top = 72
  end
  object SavePictureDialog: TSavePictureDialog
    DefaultExt = '.bmp'
    Filter = 
      #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' (*.bmp)|*.bmp|'#1048#1082#1086#1085#1082#1080' (*.ico)|*.ico|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*' +
      '.*'
    Options = [ofEnableSizing]
    Left = 264
    Top = 72
  end
end
