inherited BisTaxiDataCarEditForm: TBisTaxiDataCarEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataCarEditForm'
  ClientHeight = 313
  ClientWidth = 470
  ExplicitWidth = 478
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 275
    Width = 470
    ExplicitTop = 230
    ExplicitWidth = 499
    inherited ButtonOk: TButton
      Left = 291
      ExplicitLeft = 320
    end
    inherited ButtonCancel: TButton
      Left = 387
      ExplicitLeft = 416
    end
  end
  inherited PanelControls: TPanel
    Width = 470
    Height = 275
    ExplicitWidth = 470
    ExplicitHeight = 275
    object LabelStateNum: TLabel
      Left = 13
      Top = 15
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1043#1086#1089' '#1085#1086#1084#1077#1088':'
      FocusControl = EditStateNum
    end
    object LabelDescription: TLabel
      Left = 189
      Top = 15
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelYearCreated: TLabel
      Left = 82
      Top = 198
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1043#1086#1076' '#1074#1099#1087#1091#1089#1082#1072':'
      FocusControl = EditYearCreated
      ExplicitTop = 203
    end
    object LabelCallsign: TLabel
      Left = 13
      Top = 117
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1079#1099#1074#1085#1086#1081':'
      FocusControl = EditCallsign
      ExplicitTop = 122
    end
    object LabelBrand: TLabel
      Left = 31
      Top = 144
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1052#1072#1088#1082#1072':'
      FocusControl = EditBrand
      ExplicitTop = 149
    end
    object LabelColor: TLabel
      Left = 37
      Top = 171
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1062#1074#1077#1090':'
      FocusControl = EditColor
      ExplicitTop = 176
    end
    object LabelPts: TLabel
      Left = 218
      Top = 117
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1058#1057':'
      FocusControl = MemoPts
      ExplicitTop = 122
    end
    object LabelPayload: TLabel
      Left = 29
      Top = 225
      Width = 122
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1043#1088#1091#1079#1086#1087#1086#1076#1098#1077#1084#1085#1086#1089#1090#1100' ('#1082#1075'):'
      FocusControl = EditPayload
      ExplicitTop = 230
    end
    object LabelAmount: TLabel
      Left = 58
      Top = 252
      Width = 93
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' ('#1095#1077#1083'):'
      FocusControl = EditAmount
      ExplicitTop = 257
    end
    object LabelCarTypes: TLabel
      Left = 37
      Top = 39
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087#1099':'
      FocusControl = CheckListBoxCarTypes
    end
    object EditStateNum: TEdit
      Left = 73
      Top = 12
      Width = 96
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 248
      Top = 12
      Width = 209
      Height = 96
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 8
      ExplicitWidth = 238
      ExplicitHeight = 101
    end
    object EditYearCreated: TEdit
      Left = 157
      Top = 195
      Width = 70
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 5
      ExplicitTop = 200
    end
    object EditCallsign: TEdit
      Left = 73
      Top = 114
      Width = 128
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 2
      ExplicitTop = 119
    end
    object EditBrand: TEdit
      Left = 73
      Top = 141
      Width = 154
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 3
      ExplicitTop = 146
    end
    object EditColor: TEdit
      Left = 73
      Top = 168
      Width = 154
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 4
      ExplicitTop = 173
    end
    object MemoPts: TMemo
      Left = 248
      Top = 114
      Width = 209
      Height = 156
      Anchors = [akLeft, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 9
      ExplicitTop = 119
      ExplicitWidth = 238
    end
    object EditPayload: TEdit
      Left = 157
      Top = 222
      Width = 70
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 6
      ExplicitTop = 227
    end
    object EditAmount: TEdit
      Left = 157
      Top = 249
      Width = 70
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 7
      ExplicitTop = 254
    end
    object CheckListBoxCarTypes: TCheckListBox
      Left = 73
      Top = 39
      Width = 154
      Height = 69
      OnClickCheck = CheckListBoxCarTypesClickCheck
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      Items.Strings = (
        #1069#1082#1086#1085#1086#1084
        #1050#1086#1084#1092#1086#1088#1090
        #1052#1080#1085#1080#1074#1101#1085
        #1043#1088#1091#1079#1086#1074#1086#1081
        #1041#1080#1079#1085#1077#1089)
      TabOrder = 1
    end
  end
  inherited ImageList: TImageList
    Left = 296
    Top = 24
  end
end
