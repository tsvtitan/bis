inherited BisRegEmailForm: TBisRegEmailForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1055#1088#1080#1084#1077#1088' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1086#1085#1085#1086#1075#1086' '#1087#1080#1089#1100#1084#1072
  ClientHeight = 416
  ClientWidth = 622
  Font.Name = 'Tahoma'
  ExplicitWidth = 630
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  object LabelFrom: TLabel
    Left = 15
    Top = 15
    Width = 44
    Height = 13
    Alignment = taRightJustify
    Caption = #1054#1090' '#1082#1086#1075#1086':'
    FocusControl = EditFrom
  end
  object LabelTo: TLabel
    Left = 30
    Top = 42
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = #1050#1086#1084#1091':'
    FocusControl = EditTo
  end
  object LabelSubject: TLabel
    Left = 31
    Top = 69
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = #1058#1077#1084#1072':'
    FocusControl = EditSubject
  end
  object GroupBoxDesc: TGroupBox
    Left = 280
    Top = 4
    Width = 334
    Height = 83
    Anchors = [akLeft, akTop, akRight]
    Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
    TabOrder = 4
    ExplicitWidth = 353
    object MemoDesc: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 17
      Width = 320
      Height = 59
      Margins.Left = 5
      Margins.Top = 2
      Margins.Right = 5
      Margins.Bottom = 5
      TabStop = False
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        '  '#1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1089#1086#1079#1076#1072#1085#1080#1077' '#1087#1080#1089#1100#1084#1072' '#1087#1088#1086#1096#1083#1086' '#1085#1077#1091#1076#1072#1095#1085#1086', '
        #1087#1086#1101#1090#1086#1084#1091' '#1089#1092#1086#1088#1084#1080#1088#1091#1081#1090#1077' '#1087#1080#1089#1100#1084#1086' '#1074#1088#1091#1095#1085#1091#1102' '#1089' '#1087#1072#1088#1072#1084#1077#1090#1088#1072#1084#1080', '
        #1082#1086#1090#1086#1088#1099#1077' '#1087#1088#1080#1074#1077#1076#1077#1085#1099' '#1085#1072' '#1101#1090#1086#1081' '#1092#1086#1088#1084#1077' '#1080' '#1086#1090#1087#1088#1072#1074#1100#1090#1077' '#1077#1075#1086' '#1085#1072' '#1085#1072#1096' '
        #1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1103#1097#1080#1082'.')
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      ExplicitWidth = 290
    end
  end
  object EditFrom: TEdit
    Left = 65
    Top = 12
    Width = 196
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object EditTo: TEdit
    Left = 65
    Top = 39
    Width = 196
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object GroupBoxBody: TGroupBox
    Left = 8
    Top = 93
    Width = 606
    Height = 315
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' '#1058#1077#1082#1089#1090' '#1087#1080#1089#1100#1084#1072' '
    TabOrder = 3
    ExplicitWidth = 625
    ExplicitHeight = 298
    object MemoBody: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 17
      Width = 592
      Height = 291
      Margins.Left = 5
      Margins.Top = 2
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      ExplicitWidth = 611
      ExplicitHeight = 274
    end
  end
  object EditSubject: TEdit
    Left = 65
    Top = 66
    Width = 196
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
end
