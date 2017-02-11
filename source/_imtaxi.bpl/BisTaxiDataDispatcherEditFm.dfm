inherited BisTaxiDataDispatcherEditForm: TBisTaxiDataDispatcherEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataDispatcherEditForm'
  ClientHeight = 402
  ClientWidth = 589
  ExplicitWidth = 597
  ExplicitHeight = 436
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 364
    Width = 589
    ExplicitTop = 364
    ExplicitWidth = 589
    inherited ButtonOk: TButton
      Left = 410
      ExplicitLeft = 410
    end
    inherited ButtonCancel: TButton
      Left = 506
      ExplicitLeft = 506
    end
  end
  inherited PanelControls: TPanel
    Width = 589
    Height = 364
    ExplicitWidth = 589
    ExplicitHeight = 364
    object PageControl: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 583
      Height = 356
      Margins.Bottom = 5
      ActivePage = TabSheetMain
      Align = alClient
      TabOrder = 0
      OnChange = PageControlChange
      object TabSheetMain: TTabSheet
        Caption = #1050#1072#1088#1090#1086#1095#1082#1072
        DesignSize = (
          575
          328)
        object LabelName: TLabel
          Left = 226
          Top = 13
          Width = 23
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1084#1103':'
          FocusControl = EditName
        end
        object LabelDescription: TLabel
          Left = 40
          Top = 207
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
          FocusControl = MemoDescription
        end
        object LabelPhone: TLabel
          Left = 45
          Top = 40
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1077#1083#1077#1092#1086#1085':'
          FocusControl = EditPhone
        end
        object LabelSurname: TLabel
          Left = 45
          Top = 13
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = #1060#1072#1084#1080#1083#1080#1103':'
          FocusControl = EditSurname
        end
        object LabelPatronymic: TLabel
          Left = 362
          Top = 13
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
          FocusControl = EditPatronymic
        end
        object LabelCalc: TLabel
          Left = 42
          Top = 271
          Width = 80
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = #1060#1086#1088#1084#1072' '#1088#1072#1089#1095#1077#1090#1072':'
          FocusControl = ComboBoxCalc
        end
        object LabelPhoneHome: TLabel
          Left = 359
          Top = 40
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1086#1084#1072#1096#1085#1080#1081':'
          FocusControl = EditPhoneHome
        end
        object LabelPassport: TLabel
          Left = 31
          Top = 94
          Width = 62
          Height = 26
          Alignment = taRightJustify
          Caption = #1055#1072#1089#1087#1086#1088#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077':'
          FocusControl = MemoPassport
          WordWrap = True
        end
        object LabelPlaceBirth: TLabel
          Left = 200
          Top = 180
          Width = 89
          Height = 13
          Alignment = taRightJustify
          Caption = #1052#1077#1089#1090#1086' '#1088#1086#1078#1076#1077#1085#1080#1103':'
          FocusControl = EditPlaceBirth
        end
        object LabelDateBirth: TLabel
          Left = 9
          Top = 180
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103':'
          FocusControl = DateTimePickerBirth
        end
        object LabelAddressResidence: TLabel
          Left = 25
          Top = 146
          Width = 68
          Height = 26
          Alignment = taRightJustify
          Caption = #1040#1076#1088#1077#1089' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080':'
          FocusControl = EditAddressResidence
          WordWrap = True
        end
        object LabelAddressActual: TLabel
          Left = 321
          Top = 66
          Width = 35
          Height = 13
          Hint = #1040#1076#1088#1077#1089' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081
          Alignment = taRightJustify
          Caption = #1040#1076#1088#1077#1089':'
          FocusControl = EditAddressActual
        end
        object LabelUserName: TLabel
          Left = 88
          Top = 298
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = #1051#1086#1075#1080#1085':'
          FocusControl = EditUserName
        end
        object LabelBalance: TLabel
          Left = 395
          Top = 271
          Width = 39
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = #1041#1072#1083#1072#1085#1089':'
          FocusControl = EditBalance
        end
        object LabelPassword: TLabel
          Left = 268
          Top = 298
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = #1055#1072#1088#1086#1083#1100':'
          FocusControl = EditPassword
        end
        object LabelFirm: TLabel
          Left = 23
          Top = 67
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
        end
        object LabelPhoneInternal: TLabel
          Left = 225
          Top = 40
          Width = 64
          Height = 13
          Alignment = taRightJustify
          Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081':'
          FocusControl = EditPhoneInternal
        end
        object EditName: TEdit
          Left = 255
          Top = 10
          Width = 94
          Height = 21
          TabOrder = 1
        end
        object MemoDescription: TMemo
          Left = 99
          Top = 204
          Width = 468
          Height = 58
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 12
        end
        object EditPhone: TEdit
          Left = 99
          Top = 37
          Width = 111
          Height = 21
          MaxLength = 100
          TabOrder = 3
        end
        object EditSurname: TEdit
          Left = 99
          Top = 10
          Width = 110
          Height = 21
          TabOrder = 0
        end
        object EditPatronymic: TEdit
          Left = 421
          Top = 10
          Width = 146
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxWidth = 300
          TabOrder = 2
        end
        object ComboBoxCalc: TComboBox
          Left = 128
          Top = 268
          Width = 220
          Height = 21
          Style = csDropDownList
          Anchors = [akRight, akBottom]
          ItemHeight = 13
          TabOrder = 13
        end
        object EditPhoneHome: TEdit
          Left = 421
          Top = 36
          Width = 146
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxWidth = 300
          MaxLength = 100
          TabOrder = 5
        end
        object MemoPassport: TMemo
          Left = 99
          Top = 91
          Width = 468
          Height = 53
          Anchors = [akLeft, akTop, akRight]
          ScrollBars = ssVertical
          TabOrder = 8
        end
        object DateTimePickerBirth: TDateTimePicker
          Left = 99
          Top = 177
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 10
        end
        object EditAddressResidence: TEdit
          Left = 99
          Top = 150
          Width = 468
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 100
          TabOrder = 9
        end
        object EditAddressActual: TEdit
          Left = 362
          Top = 63
          Width = 205
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 100
          TabOrder = 7
        end
        object EditPlaceBirth: TEdit
          Left = 295
          Top = 177
          Width = 272
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 100
          TabOrder = 11
        end
        object CheckBoxLocked: TCheckBox
          Left = 440
          Top = 297
          Width = 87
          Height = 17
          Anchors = [akRight, akBottom]
          Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072
          TabOrder = 17
        end
        object EditUserName: TEdit
          Left = 128
          Top = 295
          Width = 127
          Height = 21
          Anchors = [akRight, akBottom]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
        end
        object EditBalance: TEdit
          Left = 440
          Top = 268
          Width = 127
          Height = 21
          Anchors = [akRight, akBottom]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 14
        end
        object EditPassword: TEdit
          Left = 315
          Top = 295
          Width = 119
          Height = 21
          Anchors = [akRight, akBottom]
          PasswordChar = '*'
          TabOrder = 16
        end
        object ComboBoxFirm: TComboBox
          Left = 99
          Top = 64
          Width = 207
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 6
        end
        object EditPhoneInternal: TEdit
          Left = 295
          Top = 37
          Width = 54
          Height = 21
          MaxLength = 100
          TabOrder = 4
        end
      end
      object TabSheetMessages: TTabSheet
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object PageControlMessages: TPageControl
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 569
          Height = 322
          ActivePage = TabSheetInMessages
          Align = alClient
          MultiLine = True
          TabOrder = 0
          OnChange = PageControlMessagesChange
          ExplicitWidth = 582
          ExplicitHeight = 286
          object TabSheetInMessages: TTabSheet
            Caption = #1042#1093#1086#1076#1103#1097#1080#1077
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 676
            ExplicitHeight = 369
          end
          object TabSheetOutMessages: TTabSheet
            Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1077
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 676
            ExplicitHeight = 369
          end
        end
      end
      object TabSheetCalls: TTabSheet
        Caption = #1042#1099#1079#1086#1074#1099
        ImageIndex = 8
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object PageControlCalls: TPageControl
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 569
          Height = 322
          ActivePage = TabSheetInCalls
          Align = alClient
          MultiLine = True
          TabOrder = 0
          OnChange = PageControlCallsChange
          ExplicitWidth = 582
          ExplicitHeight = 286
          object TabSheetInCalls: TTabSheet
            Caption = #1042#1093#1086#1076#1103#1097#1080#1077
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 676
            ExplicitHeight = 369
          end
          object TabSheetOutCalls: TTabSheet
            Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1077
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 676
            ExplicitHeight = 369
          end
        end
      end
      object TabSheetOrders: TTabSheet
        Caption = #1047#1072#1082#1072#1079#1099
        ImageIndex = 7
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 690
        ExplicitHeight = 403
      end
    end
  end
  inherited ImageList: TImageList
    Left = 408
    Top = 160
  end
end
