inherited BisTaxiDataCodeMessageEditForm: TBisTaxiDataCodeMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataCodeMessageEditForm'
  ClientHeight = 316
  ClientWidth = 369
  ExplicitWidth = 377
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 278
    Width = 369
    ExplicitTop = 278
    ExplicitWidth = 369
    inherited ButtonOk: TButton
      Left = 190
      ExplicitLeft = 190
    end
    inherited ButtonCancel: TButton
      Left = 286
      ExplicitLeft = 286
    end
  end
  inherited PanelControls: TPanel
    Width = 369
    Height = 278
    ExplicitWidth = 369
    ExplicitHeight = 278
    object LabelCode: TLabel
      Left = 10
      Top = 16
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1076' '#1089#1086#1086#1073#1097#1077#1085#1080#1103':'
      FocusControl = EditCode
    end
    object LabelDescription: TLabel
      Left = 40
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelProcName: TLabel
      Left = 57
      Top = 114
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1086#1094#1077#1076#1091#1088#1072':'
      FocusControl = EditProcName
    end
    object LabelCommandString: TLabel
      Left = 19
      Top = 141
      Width = 98
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1084#1072#1085#1076#1085#1072#1103' '#1089#1090#1088#1086#1082#1072':'
      FocusControl = EditCommandString
    end
    object LabelAnswer: TLabel
      Left = 81
      Top = 168
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1074#1077#1090':'
      FocusControl = MemoAnswer
    end
    object EditCode: TEdit
      Left = 99
      Top = 13
      Width = 257
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 99
      Top = 40
      Width = 257
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object EditProcName: TEdit
      Left = 123
      Top = 111
      Width = 233
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 400
      TabOrder = 2
    end
    object EditCommandString: TEdit
      Left = 123
      Top = 138
      Width = 233
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 400
      TabOrder = 3
    end
    object CheckBoxEnabled: TCheckBox
      Left = 123
      Top = 255
      Width = 97
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1042#1082#1083#1102#1095#1077#1085
      TabOrder = 5
    end
    object MemoAnswer: TMemo
      Left = 123
      Top = 165
      Width = 233
      Height = 84
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 4
    end
  end
end
