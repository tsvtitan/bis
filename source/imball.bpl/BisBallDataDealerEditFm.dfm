inherited BisBallDataDealerEditForm: TBisBallDataDealerEditForm
  Left = 424
  Top = 189
  ActiveControl = EditSmallName
  Caption = 'BisBallDataDealerEditForm'
  ClientHeight = 284
  ClientWidth = 611
  ExplicitWidth = 619
  ExplicitHeight = 318
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 246
    Width = 611
    ExplicitTop = 430
    ExplicitWidth = 632
    inherited ButtonOk: TButton
      Left = 432
      ExplicitLeft = 453
    end
    inherited ButtonCancel: TButton
      Left = 528
      ExplicitLeft = 549
    end
  end
  inherited PanelControls: TPanel
    Width = 611
    Height = 246
    ExplicitTop = -1
    ExplicitWidth = 632
    ExplicitHeight = 430
    object LabelSmallName: TLabel
      Left = 26
      Top = 15
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditSmallName
    end
    object LabelFullName: TLabel
      Left = 62
      Top = 42
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1083#1085#1086#1077':'
      FocusControl = EditFullName
    end
    object LabelPhone: TLabel
      Left = 359
      Top = 158
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
    end
    object LabelFax: TLabel
      Left = 378
      Top = 185
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1060#1072#1082#1089':'
      FocusControl = EditFax
    end
    object LabelEmail: TLabel
      Left = 68
      Top = 212
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1095#1090#1072':'
      FocusControl = EditEmail
    end
    object LabelSite: TLabel
      Left = 378
      Top = 212
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1057#1072#1081#1090':'
      FocusControl = EditSite
    end
    object LabelDirector: TLabel
      Left = 49
      Top = 158
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1080#1088#1077#1082#1090#1086#1088':'
      FocusControl = EditDirector
    end
    object LabelContactFace: TLabel
      Left = 11
      Top = 185
      Width = 92
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086':'
      FocusControl = EditContactFace
    end
    object LabelPaymentPercent: TLabel
      Left = 429
      Top = 42
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1086#1094#1077#1085#1090' '#1086#1087#1083#1072#1090#1099':'
      FocusControl = EditPaymentPercent
    end
    object LabelPaymentType: TLabel
      Left = 352
      Top = 15
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1057#1080#1089#1090#1077#1084#1072' '#1086#1087#1083#1072#1090#1099':'
      FocusControl = ComboBoxPaymentType
    end
    object EditSmallName: TEdit
      Left = 109
      Top = 12
      Width = 230
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 0
      OnExit = EditSmallNameExit
    end
    object EditFullName: TEdit
      Left = 109
      Top = 39
      Width = 298
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 2
    end
    object EditPhone: TEdit
      Left = 413
      Top = 155
      Width = 181
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 6
    end
    object EditFax: TEdit
      Left = 413
      Top = 182
      Width = 181
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 8
    end
    object EditEmail: TEdit
      Left = 109
      Top = 209
      Width = 233
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 9
    end
    object EditSite: TEdit
      Left = 413
      Top = 209
      Width = 181
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 10
    end
    object EditDirector: TEdit
      Left = 109
      Top = 155
      Width = 233
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 5
    end
    object EditContactFace: TEdit
      Left = 109
      Top = 182
      Width = 233
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 7
    end
    object GroupBoxPostAddress: TGroupBox
      Left = 109
      Top = 66
      Width = 485
      Height = 80
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1040#1076#1088#1077#1089': '
      TabOrder = 4
      object LabelStreetPost: TLabel
        Left = 46
        Top = 24
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1083#1080#1094#1072':'
        FocusControl = EditStreetPost
      end
      object LabelIndexPost: TLabel
        Left = 353
        Top = 51
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = #1048#1085#1076#1077#1082#1089':'
        FocusControl = EditIndexPost
      end
      object LabelHousePost: TLabel
        Left = 18
        Top = 51
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1086#1084'/'#1082#1086#1088#1087#1091#1089':'
        FocusControl = EditHousePost
      end
      object LabelFlatPost: TLabel
        Left = 175
        Top = 51
        Width = 82
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1074#1072#1088#1090#1080#1088#1072'/'#1086#1092#1080#1089':'
        FocusControl = EditFlatPost
      end
      object EditStreetPost: TEdit
        Left = 87
        Top = 21
        Width = 357
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonStreetPost: TButton
        Left = 450
        Top = 21
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1083#1080#1094#1091
        Caption = '...'
        TabOrder = 1
      end
      object EditIndexPost: TEdit
        Left = 400
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 4
      end
      object EditHousePost: TEdit
        Left = 87
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 2
      end
      object EditFlatPost: TEdit
        Left = 263
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 3
      end
    end
    object EditPaymentPercent: TEdit
      Left = 523
      Top = 39
      Width = 71
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 3
    end
    object ComboBoxPaymentType: TComboBox
      Left = 445
      Top = 12
      Width = 149
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
    end
  end
  inherited ImageList: TImageList
    Left = 24
    Top = 80
  end
end
