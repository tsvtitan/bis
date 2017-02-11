inherited BisKrieltDataPresentationEditForm: TBisKrieltDataPresentationEditForm
  Left = 261
  Top = 159
  Caption = 'BisKrieltDataPresentationEditForm'
  ClientHeight = 288
  ClientWidth = 594
  ExplicitWidth = 602
  ExplicitHeight = 322
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 250
    Width = 594
    ExplicitTop = 178
    ExplicitWidth = 594
    inherited ButtonOk: TButton
      Left = 415
      ExplicitLeft = 415
    end
    inherited ButtonCancel: TButton
      Left = 512
      ExplicitLeft = 512
    end
  end
  inherited PanelControls: TPanel
    Width = 594
    Height = 250
    ExplicitWidth = 594
    ExplicitHeight = 178
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
      Top = 70
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPresentationType: TLabel
      Left = 68
      Top = 43
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087':'
      FocusControl = ComboBoxPresentationType
    end
    object LabelTableName: TLabel
      Left = 44
      Top = 124
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1072#1073#1083#1080#1094#1072':'
      FocusControl = EditTableName
    end
    object LabelSorting: TLabel
      Left = 27
      Top = 151
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072':'
      FocusControl = EditSorting
    end
    object LabelView: TLabel
      Left = 303
      Top = 43
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditView
    end
    object LabelType: TLabel
      Left = 304
      Top = 70
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditType
    end
    object LabelOperation: TLabel
      Left = 324
      Top = 97
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
      FocusControl = EditOperation
    end
    object LabelPublishing: TLabel
      Left = 331
      Top = 16
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1048#1079#1076#1072#1085#1080#1077':'
      FocusControl = EditPublishing
    end
    object LabelConditions: TLabel
      Left = 306
      Top = 124
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1089#1083#1086#1074#1080#1077':'
      FocusControl = MemoConditions
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 195
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 67
      Width = 195
      Height = 48
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object ComboBoxPresentationType: TComboBox
      Left = 96
      Top = 40
      Width = 195
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 1
    end
    object EditTableName: TEdit
      Left = 96
      Top = 121
      Width = 168
      Height = 21
      TabOrder = 3
    end
    object EditSorting: TEdit
      Left = 96
      Top = 148
      Width = 256
      Height = 21
      TabOrder = 5
    end
    object EditView: TEdit
      Left = 384
      Top = 40
      Width = 168
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 8
    end
    object ButtonView: TButton
      Left = 558
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 9
    end
    object EditType: TEdit
      Left = 384
      Top = 67
      Width = 168
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 10
    end
    object ButtonType: TButton
      Left = 558
      Top = 67
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 11
    end
    object EditOperation: TEdit
      Left = 384
      Top = 94
      Width = 168
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 12
    end
    object ButtonOperation: TButton
      Left = 558
      Top = 94
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 13
    end
    object EditPublishing: TEdit
      Left = 384
      Top = 13
      Width = 168
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonPublishing: TButton
      Left = 558
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079#1076#1072#1085#1080#1077
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 7
    end
    object MemoConditions: TMemo
      Left = 358
      Top = 121
      Width = 222
      Height = 120
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 14
      ExplicitHeight = 48
    end
    object ButtonTableName: TButton
      Left = 270
      Top = 121
      Width = 21
      Height = 21
      Hint = #1053#1086#1074#1086#1077' '#1080#1084#1103' '#1090#1072#1073#1083#1080#1094#1099
      Caption = '...'
      TabOrder = 4
      OnClick = ButtonTableNameClick
    end
  end
end
