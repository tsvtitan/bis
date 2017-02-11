inherited BisTaxiDataDriverEditForm: TBisTaxiDataDriverEditForm
  Left = 513
  Top = 212
  ActiveControl = EditMinHours
  Caption = 'BisTaxiDataDriverEditForm'
  ClientHeight = 442
  ClientWidth = 601
  ExplicitWidth = 617
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 404
    Width = 601
    ExplicitTop = 404
    ExplicitWidth = 601
    inherited ButtonOk: TButton
      Left = 422
      ExplicitLeft = 422
    end
    inherited ButtonCancel: TButton
      Left = 518
      ExplicitLeft = 518
    end
  end
  inherited PanelControls: TPanel
    Width = 601
    Height = 404
    ExplicitWidth = 601
    ExplicitHeight = 404
    object PageControl: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 595
      Height = 396
      Margins.Bottom = 5
      ActivePage = TabSheetSchedules
      Align = alClient
      TabOrder = 0
      OnChange = PageControlChange
      object TabSheetMain: TTabSheet
        Caption = #1050#1072#1088#1090#1086#1095#1082#1072
        DesignSize = (
          587
          368)
        object LabelSurname: TLabel
          Left = 31
          Top = 13
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = #1060#1072#1084#1080#1083#1080#1103':'
          FocusControl = EditSurname
        end
        object LabelName: TLabel
          Left = 212
          Top = 13
          Width = 23
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1084#1103':'
          FocusControl = EditName
        end
        object LabelPatronymic: TLabel
          Left = 348
          Top = 13
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
          FocusControl = EditPatronymic
        end
        object LabelPhone: TLabel
          Left = 31
          Top = 40
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1077#1083#1077#1092#1086#1085':'
          FocusControl = EditPhone
        end
        object LabelDescription: TLabel
          Left = 272
          Top = 229
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akBottom]
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
          FocusControl = MemoDescription
        end
        object LabelCar: TLabel
          Left = 14
          Top = 148
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100':'
          FocusControl = EditCar
        end
        object LabelMethod: TLabel
          Left = 305
          Top = 40
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1087#1086#1089#1086#1073' '#1089#1074#1103#1079#1080':'
          FocusControl = ComboBoxMethod
        end
        object LabelUserName: TLabel
          Left = 45
          Top = 202
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akBottom]
          Caption = #1051#1086#1075#1080#1085':'
          FocusControl = EditUserName
          ExplicitTop = 297
        end
        object LabelLicense: TLabel
          Left = 181
          Top = 175
          Width = 57
          Height = 13
          Alignment = taRightJustify
          Caption = #1059#1076#1086#1089#1090'-'#1085#1080#1077':'
          FocusControl = EditLicense
        end
        object LabelDateCreate: TLabel
          Left = 38
          Top = 229
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akBottom]
          Caption = #1057#1086#1079#1076#1072#1085':'
          FocusControl = DateTimePickerCreate
          ExplicitTop = 324
        end
        object LabelFirm: TLabel
          Left = 9
          Top = 94
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
        end
        object LabelAddressActual: TLabel
          Left = 44
          Top = 67
          Width = 35
          Height = 13
          Alignment = taRightJustify
          Caption = #1040#1076#1088#1077#1089':'
          FocusControl = EditAddressActual
        end
        object LabelDriverType: TLabel
          Left = 5
          Top = 121
          Width = 74
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1080#1087' '#1074#1086#1076#1080#1090#1077#1083#1103':'
          FocusControl = ComboBoxDriverType
        end
        object LabelDateAppear: TLabel
          Left = 7
          Top = 175
          Width = 72
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072' '#1074#1099#1093#1086#1076#1072':'
          FocusControl = DateTimePickerAppear
        end
        object EditSurname: TEdit
          Left = 85
          Top = 10
          Width = 110
          Height = 21
          TabOrder = 0
        end
        object EditName: TEdit
          Left = 241
          Top = 10
          Width = 94
          Height = 21
          TabOrder = 1
        end
        object EditPatronymic: TEdit
          Left = 407
          Top = 10
          Width = 169
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
        end
        object EditPhone: TEdit
          Left = 85
          Top = 37
          Width = 180
          Height = 21
          MaxLength = 100
          TabOrder = 3
        end
        object MemoDescription: TMemo
          Left = 331
          Top = 226
          Width = 245
          Height = 75
          Anchors = [akLeft, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 19
        end
        object EditCar: TEdit
          Left = 85
          Top = 145
          Width = 213
          Height = 21
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 9
        end
        object ButtonCar: TButton
          Left = 304
          Top = 145
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1100
          Caption = '...'
          TabOrder = 10
        end
        object ComboBoxMethod: TComboBox
          Left = 382
          Top = 37
          Width = 194
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 5
        end
        object EditUserName: TEdit
          Left = 85
          Top = 199
          Width = 88
          Height = 21
          Anchors = [akLeft, akBottom]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 13
        end
        object EditLicense: TEdit
          Left = 244
          Top = 172
          Width = 81
          Height = 21
          Hint = #1059#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
          ParentShowHint = False
          ShowHint = True
          TabOrder = 12
        end
        object BitBtnPhone: TBitBtn
          Left = 271
          Top = 37
          Width = 21
          Height = 21
          TabOrder = 4
          OnClick = BitBtnPhoneClick
          Glyph.Data = {
            46040000424D460400000000000036000000280000001A0000000D0000000100
            18000000000010040000120B0000120B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFECC280D78300ECC280FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2B2B2646464B2B2B2FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFF1D1A0E9BA70FDF8F0E1A240F0CA76E4
            AA50FDF8F0E6B260F1D1A0FFFFFFFFFFFFFFFFFFFFFFFFC5C5C5A8A8A8F6F6F6
            8A8A8AB4B4B4949494F6F6F69E9E9EC5C5C5FFFFFFFFFFFF0000FFFFFFF1D1A0
            D98707E39C27DA8B10D98909FADF94D78300DA8B10E6A330D98807F1D1A0FFFF
            FFFFFFFFC5C5C56868688080806E6E6E6A6A6ACBCBCB6464646E6E6E87878769
            6969C5C5C5FFFFFF0000FFFFFFE6B260E69F29FFD377F7C96AF7CD73FFE396F7
            CE75FAD075FFD57AE39B23E9BA70FFFFFFFFFFFF9E9E9E828282BBBBBBB1B1B1
            B6B6B6CECECEB7B7B7B8B8B8BDBDBD7E7E7EA8A8A8FFFFFF0000FFFFFFFBF0E0
            DA8B10FAC45DFFD275F7C767EBAF44F7C868FFD377F7C059DA8B10FDF8F0FFFF
            FFFFFFFFECECEC6E6E6EAAAAAABABABAAFAFAF949494AFAFAFBBBBBBA6A6A66E
            6E6EF6F6F6FFFFFF0000ECC280E4AA50D78300F7BB4FF7BD52D98707FFFFFFD9
            8707F7BE54F7BC4FD98706E1A240ECC280B2B2B2949494646464A0A0A0A2A2A2
            686868FFFFFF686868A3A3A3A1A1A16868688A8A8AB2B2B20000D78300F2C15F
            FCD47BFFDB8DEBAD43FFFFFFFFFFFFFFFFFFEBAD43FFDA8BFACD70F0BA55D783
            00646464A8A8A8BDBDBDC7C7C7939393FFFFFFFFFFFFFFFFFF939393C6C6C6B5
            B5B5A1A1A16464640000ECC280E1A240D98808F9DEA5F7D288D98808FFFFFFD9
            8808F7D288F9DEA4D88607E4AA50ECC280B2B2B28A8A8A696969CFCFCFBFBFBF
            696969FFFFFF696969BFBFBFCFCFCF686868949494B2B2B20000FFFFFFFDF8F0
            DA8B10F7D27DFFF1CDF7DCA5EBB75DF7DCA5FFF2D0FAD989DA8B10FDF8F0FFFF
            FFFFFFFFF6F6F66E6E6EBCBCBCE7E7E7CECECEA1A1A1CECECEE9E9E9C4C4C46E
            6E6EF6F6F6FFFFFF0000FFFFFFE9BA70E3A537FFF0B8FDF4DDFCF2D9FFF8E1FB
            EDCDFCF3DAFFF1BEE6AB41E6B260FFFFFFFFFFFFA8A8A88A8A8AE0E0E0EEEEEE
            EBEBEBF1F1F1E4E4E4ECECECE3E3E39191919E9E9EFFFFFF0000FFFFFFF1D1A0
            D98A0BE6AC43E5AF5AD8880CFEFBEED9890AE5AF5AE3A538D98A0BF1D1A0FFFF
            FFFFFFFFC5C5C56B6B6B9292929A9A9A6A6A6AF7F7F76A6A6A9A9A9A8A8A8A6B
            6B6BC5C5C5FFFFFF0000FFFFFFFFFFFFF1D1A0E6B260FDF8F0E4AA50F2D58FE1
            A240FDF8F0E9BA70F1D1A0FFFFFFFFFFFFFFFFFFFFFFFFC5C5C59E9E9EF6F6F6
            949494C2C2C28A8A8AF6F6F6A8A8A8C5C5C5FFFFFFFFFFFF0000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFECC280D78300ECC280FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2B2B2646464B2B2B2FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF0000}
          NumGlyphs = 2
        end
        object DateTimePickerCreate: TDateTimePicker
          Left = 85
          Top = 226
          Width = 88
          Height = 21
          Anchors = [akLeft, akBottom]
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Checked = False
          TabOrder = 15
        end
        object DateTimePickerCreateTime: TDateTimePicker
          Left = 179
          Top = 226
          Width = 76
          Height = 21
          Anchors = [akLeft, akBottom]
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Kind = dtkTime
          TabOrder = 16
        end
        object GroupBoxPriority: TGroupBox
          Left = 85
          Top = 253
          Width = 240
          Height = 48
          Anchors = [akLeft, akBottom]
          Caption = ' '#1054#1087#1088#1086#1089' '
          TabOrder = 17
          object LabelPriority: TLabel
            Left = 12
            Top = 19
            Width = 48
            Height = 13
            Alignment = taRightJustify
            Caption = #1055#1086#1088#1103#1076#1086#1082':'
            FocusControl = EditPriority
          end
          object LabelDatePriority: TLabel
            Left = 106
            Top = 19
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = #1044#1072#1090#1072':'
            FocusControl = DateTimePickerPriority
          end
          object EditPriority: TEdit
            Left = 66
            Top = 16
            Width = 31
            Height = 21
            Hint = #1055#1086#1088#1103#1076#1086#1082' '#1086#1087#1088#1086#1089#1072
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
          object DateTimePickerPriority: TDateTimePicker
            Left = 142
            Top = 16
            Width = 88
            Height = 21
            Hint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1089#1084#1077#1085#1099' '#1087#1086#1088#1103#1076#1082#1072' '#1086#1087#1088#1086#1089#1072
            Date = 39507.457070671300000000
            Time = 39507.457070671300000000
            Checked = False
            TabOrder = 1
          end
        end
        object ButtonUserName: TBitBtn
          Left = 179
          Top = 199
          Width = 21
          Height = 21
          Hint = #1053#1086#1074#1099#1081' '#1083#1086#1075#1080#1085
          Anchors = [akLeft, akBottom]
          Caption = '<'
          TabOrder = 14
          OnClick = ButtonUserNameClick
          Glyph.Data = {
            36060000424D3606000000000000360000002800000020000000100000000100
            18000000000000060000120B0000120B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFF6FBF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFDEEEE1037B1E0A8229FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECEC6E707174
            7677FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFD8EBDC1B893643A15F0B8833FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9E97C7E7F9698987A
            7C7DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFD5E9D918893446A36280C1963A9F5E108C3C1690441C924A229852FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7E7E77C7E7F999B9BBABBBB95
            97977F80818485868788898C8D8EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            CFE6D415883348A56682C2976AB68588C59E8AC6A18DC8A590CAA9299B5BFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E47B7D7E9B9D9DBBBCBCAFB0B0BF
            C0C0C0C1C1C3C4C4C5C6C6919293FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            0381273CA05C83C29867B58261B38066B6856BB8896FBA8E94CDAD319F63FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF727475959797BCBDBDADAEAEABACACAF
            B0B0B1B2B2B4B5B5C8C9C9969898FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            F1F8F308883646A5688AC7A174BC9090CBA891CBAA94CDAD96CEB037A36BFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F77A7C7D9B9D9DC1C2C2B5B6B6C5
            C6C6C6C7C7C8C9C9C9CACA9A9C9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFF4FAF61890464FAB7491CBAA55AF7C309E6234A26838A46E3DA56FFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFA848586A2A4A4C6C7C7A6
            A8A8959797989A9A9B9D9D9C9E9EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFF8FCF92898575AB38139A369FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFB8E8F90ABACAC9A
            9C9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFF8FCFA319F653FA771FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFC9698989E
            A0A0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          Margin = 0
          NumGlyphs = 2
        end
        object EditAddressActual: TEdit
          Left = 85
          Top = 64
          Width = 240
          Height = 21
          Hint = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089
          MaxLength = 100
          TabOrder = 6
        end
        object ComboBoxFirm: TComboBox
          Left = 85
          Top = 91
          Width = 240
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 7
        end
        object PanelPhoto: TPanel
          Left = 331
          Top = 63
          Width = 245
          Height = 157
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          Caption = #1053#1077#1090' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1080
          Color = clWindow
          ParentBackground = False
          TabOrder = 18
          DesignSize = (
            245
            157)
          object ShapePhoto: TShape
            Left = 0
            Top = 0
            Width = 245
            Height = 157
            Align = alClient
            Brush.Style = bsClear
            Pen.Style = psDot
            ExplicitWidth = 189
            ExplicitHeight = 132
          end
          object ImagePhoto: TImage
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 239
            Height = 151
            Align = alClient
            Center = True
            PopupMenu = PopupActionBarPhoto
            Proportional = True
            Stretch = True
            ExplicitLeft = 0
            ExplicitTop = 6
            ExplicitWidth = 324
            ExplicitHeight = 220
          end
          object ButtonPhoto: TButton
            Left = 163
            Top = 125
            Width = 75
            Height = 25
            Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1077#1081
            Anchors = [akRight, akBottom]
            Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
            TabOrder = 0
            OnClick = ButtonPhotoClick
          end
        end
        object GroupBoxLock: TGroupBox
          Left = 85
          Top = 307
          Width = 491
          Height = 52
          Anchors = [akLeft, akRight, akBottom]
          Caption = '                              '
          TabOrder = 20
          DesignSize = (
            491
            52)
          object LabelDateLock: TLabel
            Left = 19
            Top = 23
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = #1044#1072#1090#1072':'
            Enabled = False
            FocusControl = DateTimePickerLock
          end
          object LabelReasonLock: TLabel
            Left = 232
            Top = 23
            Width = 47
            Height = 13
            Alignment = taRightJustify
            Caption = #1055#1088#1080#1095#1080#1085#1072':'
            Enabled = False
            FocusControl = EditReasonLock
          end
          object CheckBoxLocked: TCheckBox
            Left = 13
            Top = 0
            Width = 87
            Height = 17
            Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072
            TabOrder = 0
            OnClick = CheckBoxLockedClick
          end
          object DateTimePickerLock: TDateTimePicker
            Left = 55
            Top = 20
            Width = 88
            Height = 21
            Date = 39507.457070671300000000
            Time = 39507.457070671300000000
            Checked = False
            Enabled = False
            TabOrder = 1
          end
          object DateTimePickerLockTime: TDateTimePicker
            Left = 149
            Top = 20
            Width = 74
            Height = 21
            Date = 39507.457070671300000000
            Time = 39507.457070671300000000
            Enabled = False
            Kind = dtkTime
            TabOrder = 2
          end
          object EditReasonLock: TEdit
            Left = 285
            Top = 20
            Width = 196
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Enabled = False
            TabOrder = 3
          end
        end
        object ComboBoxDriverType: TComboBox
          Left = 85
          Top = 118
          Width = 240
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 8
        end
        object DateTimePickerAppear: TDateTimePicker
          Left = 85
          Top = 172
          Width = 88
          Height = 21
          Hint = #1044#1072#1090#1072' '#1087#1088#1077#1076#1087#1086#1083#1086#1078#1080#1090#1077#1083#1100#1085#1086#1075#1086' '#1074#1099#1093#1086#1076#1072
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Checked = False
          TabOrder = 11
        end
      end
      object TabSheetExtra: TTabSheet
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
        ImageIndex = 6
        DesignSize = (
          587
          368)
        object LabelPhoneHome: TLabel
          Left = 51
          Top = 339
          Width = 102
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = #1058#1077#1083#1077#1092#1086#1085' '#1076#1086#1084#1072#1096#1085#1080#1081':'
          FocusControl = EditPhoneHome
          ExplicitLeft = 15
          ExplicitTop = 213
        end
        object LabelPassport: TLabel
          Left = 55
          Top = 64
          Width = 62
          Height = 26
          Alignment = taRightJustify
          Caption = #1055#1072#1089#1087#1086#1088#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077':'
          FocusControl = MemoPassport
          WordWrap = True
        end
        object LabelAddressResidence: TLabel
          Left = 15
          Top = 13
          Width = 102
          Height = 13
          Alignment = taRightJustify
          Caption = #1040#1076#1088#1077#1089' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080':'
          FocusControl = EditAddressResidence
        end
        object LabelDateBirth: TLabel
          Left = 33
          Top = 40
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103':'
          FocusControl = DateTimePickerBirth
        end
        object LabelPlaceBirth: TLabel
          Left = 224
          Top = 40
          Width = 89
          Height = 13
          Alignment = taRightJustify
          Caption = #1052#1077#1089#1090#1086' '#1088#1086#1078#1076#1077#1085#1080#1103':'
          FocusControl = EditPlaceBirth
        end
        object LabelCategories: TLabel
          Left = 367
          Top = 339
          Width = 58
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080':'
          FocusControl = EditCategories
          ExplicitLeft = 315
          ExplicitTop = 162
        end
        object EditPhoneHome: TEdit
          Left = 159
          Top = 336
          Width = 190
          Height = 21
          Anchors = [akRight, akBottom]
          Constraints.MaxWidth = 220
          MaxLength = 100
          TabOrder = 4
        end
        object MemoPassport: TMemo
          Left = 123
          Top = 64
          Width = 453
          Height = 266
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object EditAddressResidence: TEdit
          Left = 123
          Top = 10
          Width = 453
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 100
          TabOrder = 0
        end
        object DateTimePickerBirth: TDateTimePicker
          Left = 123
          Top = 37
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 1
        end
        object EditPlaceBirth: TEdit
          Left = 319
          Top = 37
          Width = 257
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 100
          TabOrder = 2
        end
        object EditCategories: TEdit
          Left = 431
          Top = 336
          Width = 145
          Height = 21
          Anchors = [akRight, akBottom]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
      end
      object TabSheetAccount: TTabSheet
        Caption = #1057#1095#1077#1090
        ImageIndex = 1
        object PanelReceiptCharges: TPanel
          Left = 0
          Top = 0
          Width = 587
          Height = 37
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            587
            37)
          object LabelCalc: TLabel
            Left = 329
            Top = 13
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Caption = #1060#1086#1088#1084#1072' '#1088#1072#1089#1095#1077#1090#1072':'
            FocusControl = ComboBoxCalc
          end
          object LabelMinBalance: TLabel
            Left = 167
            Top = 13
            Width = 66
            Height = 13
            Alignment = taRightJustify
            Caption = #1052#1080#1085'. '#1073#1072#1083#1072#1085#1089':'
            FocusControl = EditMinBalance
          end
          object LabelActualBalance: TLabel
            Left = 37
            Top = 13
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = #1041#1072#1083#1072#1085#1089':'
            FocusControl = EditActualBalance
          end
          object ComboBoxCalc: TComboBox
            Left = 415
            Top = 10
            Width = 163
            Height = 21
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 2
          end
          object EditMinBalance: TEdit
            Left = 239
            Top = 10
            Width = 60
            Height = 21
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object EditActualBalance: TEdit
            Left = 82
            Top = 10
            Width = 60
            Height = 21
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 0
          end
        end
        object PageControlAccount: TPageControl
          AlignWithMargins = True
          Left = 3
          Top = 40
          Width = 581
          Height = 325
          ActivePage = TabSheetAccountReceipts
          Align = alClient
          MultiLine = True
          TabOrder = 1
          OnChange = PageControlAccountChange
          object TabSheetAccountReceipts: TTabSheet
            Caption = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103
          end
          object TabSheetAccountCharges: TTabSheet
            Caption = #1057#1087#1080#1089#1072#1085#1080#1103
            ImageIndex = 1
          end
        end
      end
      object TabSheetSchedules: TTabSheet
        Caption = #1043#1088#1072#1092#1080#1082
        ImageIndex = 7
        object LabelSchedule: TLabel
          Left = 0
          Top = 37
          Width = 587
          Height = 331
          Align = alClient
          Alignment = taCenter
          Caption = #1053#1077' '#1074#1099#1073#1088#1072#1085' '#1075#1088#1072#1092#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 108
          ExplicitHeight = 13
        end
        object PanelSchedule: TPanel
          Left = 0
          Top = 0
          Width = 587
          Height = 37
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object LabelMinHours: TLabel
            Left = 253
            Top = 13
            Width = 86
            Height = 13
            Alignment = taRightJustify
            Caption = #1063#1072#1089#1086#1074' '#1074' '#1085#1077#1076#1077#1083#1102':'
            FocusControl = EditMinHours
          end
          object LabelDateSchedule: TLabel
            Left = 401
            Top = 13
            Width = 69
            Height = 13
            Alignment = taRightJustify
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
            FocusControl = DateTimePickerSchedule
          end
          object LabelTypeSchedule: TLabel
            Left = 15
            Top = 13
            Width = 68
            Height = 13
            Alignment = taRightJustify
            Caption = #1058#1080#1087' '#1075#1088#1072#1092#1080#1082#1072':'
            FocusControl = ComboBoxTypeSchedule
          end
          object EditMinHours: TEdit
            Left = 345
            Top = 10
            Width = 39
            Height = 21
            Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1072#1089#1086#1074' '#1074' '#1085#1077#1076#1077#1083#1102
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object DateTimePickerSchedule: TDateTimePicker
            Left = 476
            Top = 10
            Width = 88
            Height = 21
            Hint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1075#1088#1072#1092#1080#1082#1072
            Date = 39507.457070671300000000
            Time = 39507.457070671300000000
            Checked = False
            TabOrder = 2
          end
          object ComboBoxTypeSchedule: TComboBox
            Left = 89
            Top = 10
            Width = 144
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = #1073#1077#1079' '#1075#1088#1072#1092#1080#1082#1072
            OnChange = ComboBoxTypeScheduleChange
            Items.Strings = (
              #1073#1077#1079' '#1075#1088#1072#1092#1080#1082#1072
              #1085#1077#1076#1077#1083#1100#1085#1099#1081
              #1076#1085#1077#1074#1085#1086#1081)
          end
        end
      end
      object TabSheetShifts: TTabSheet
        Caption = #1057#1084#1077#1085#1099
        ImageIndex = 3
      end
      object TabSheetParkStates: TTabSheet
        Caption = #1057#1090#1086#1103#1085#1082#1080
        ImageIndex = 4
      end
      object TabSheetMessages: TTabSheet
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
        ImageIndex = 5
        object PageControlMessages: TPageControl
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 581
          Height = 362
          ActivePage = TabSheetInMessages
          Align = alClient
          MultiLine = True
          TabOrder = 0
          OnChange = PageControlMessagesChange
          object TabSheetInMessages: TTabSheet
            Caption = #1042#1093#1086#1076#1103#1097#1080#1077
          end
          object TabSheetOutMessages: TTabSheet
            Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1077
            ImageIndex = 1
          end
        end
      end
      object TabSheetCalls: TTabSheet
        Caption = #1042#1099#1079#1086#1074#1099
        ImageIndex = 8
        object PageControlCalls: TPageControl
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 581
          Height = 362
          ActivePage = TabSheetInCalls
          Align = alClient
          MultiLine = True
          TabOrder = 0
          OnChange = PageControlCallsChange
          object TabSheetInCalls: TTabSheet
            Caption = #1042#1093#1086#1076#1103#1097#1080#1077
          end
          object TabSheetOutCalls: TTabSheet
            Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1077
            ImageIndex = 1
          end
        end
      end
      object TabSheetOrders: TTabSheet
        Caption = #1047#1072#1082#1072#1079#1099
        ImageIndex = 7
      end
      object TabSheetScores: TTabSheet
        Caption = #1054#1094#1077#1085#1082#1080
        ImageIndex = 9
      end
    end
  end
  inherited ImageList: TImageList
    Left = 112
    Top = 128
    Bitmap = {
      494C010108000900200010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C7C7C7007C7C7C0076767600777777007777770077777700787878007575
      7500A6A6A600000000000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B030000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B100CACACA00CACACA00CACACA00CACACA00CBCBCB00CACACA00C9C9
      C90071717100000000000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B132000000000000000000000000000000000000A9735100CE9E
      7D00D3A27D00D5A88200D7AB8400D7AE8700D8B28B00D8B28C00D8B38D00D8B4
      8E00D7B38E00CDA68300AE7F5B00000000000000000000000000000000000000
      0000ACACAC00D3D3D300AAAAAA00C8C8C800AAAAAA00C5C5C500AAAAAA00CECE
      CE007D7D7D00000000000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B130000000000000000000000000000000000000BD7A4E00FDFB
      F700F6E7DC00FFF8F100FFF9F300FFF9F400FFFBF500FFF9F400FFF8F200FFF7
      F000F8E8DD00F4EAE200C99A6C00000000000000000000000000000000000000
      0000A7A7A700D6D6D600A3A3A300C2C2C200A0A0A000BFBFBF00A0A0A000CFCF
      CF0077777700000000000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E50066330000663300006633
      000066330000973A11000000000000000000A1250000FFFFFF00FFF9ED00FFF9
      ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9
      ED00FFFFFF00B132000000000000000000000000000000000000C67D4F00FCF6
      F100F2D7C300F3DAC700FDE9DA00FAE0CE00EFC9AF00F9DCC900FDE8D600F4D8
      C200F0CEB400F8EEE400D19D6A00000000000000000000000000000000000000
      0000A3A3A300D8D8D800C6C6C600C4C4C400C1C1C100C0C0C000BEBEBE00CFCF
      CF00747474000000000000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900663300003366CC003366
      CC0066330000973A110000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFD
      E900FFFFFF00B132000000000000000000000000000000000000C9845A00FDF8
      F400FCE5D400F2D6C300EECCB100E7BD9F00F3DED000E6BC9D00EEC8AC00F0CE
      B500FADBC100FBF2E900CF9E6B00000000000000000000000000000000000000
      0000A0A0A000DADADA006FBE780076C57F00A0A0A000C2C2C2005E52D400CFCF
      CF0070707000000000000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100663300003366CC003366
      CC0066330000973A11000000000000000000AC3C0000A53C00009F3000009F30
      00009F3000009F3000009F300000666666006666660066666600666666006666
      6600666666006666660066666600000000000000000000000000CC8E6600FDF8
      F400FEE8D700F6D8C100E1B29100F0D7C600FFFCFA00F3E0D400E0AD8B00F3CA
      AA00FDDBC000FBF0E700CF9D6B00000000000000000000000000000000000000
      00009D9D9D00DCDCDC00CBCBCB00C9C9C900C6C6C600C4C4C400C1C1C100D0D0
      D0006D6D6D00000000000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00FF9C1B00663300003366CC003366
      CC0066330000973A11000000000000000000BA3B0000FFA72900FFA42300FFA7
      2900FFA72900FFA72900FFA7290066666600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0066666600000000000000000000000000D0967100FDF8
      F400F8D9C300E9BDA000F0D7C500FFF8F300FEF5ED00FFFBF800F4DFD200E7B5
      9200F5C7A300FCF1E500CF9D6B00000000000000000000000000000000000000
      00009A9A9A00DEDEDE00F79D2100F79E2100F69F2000F6A02100F5A12100D6CD
      BD0069696900000000000000000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE370066330000663300003366CC003366CC003366
      CC003366CC00663300006633000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F6AE3700F6AE3700F6AE370066666600FFFFFF009F3000009F3000009F30
      00009F300000FFFFFF0066666600000000000000000000000000D49E7C00FAF1
      EA00E8BC9D00F0D5C200FEF4EC00FEEDE000FEEFE400FEF2E900FFFAF500F3DC
      CC00E7B08800F4E1D000D19F6B00000000000000000000000000000000000000
      000096969600E0E0E000F79A2000F7DBA300F6DAA300F6DAA500F5AF3000D9CE
      BE0065656500000000000000000000000000DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00663300003366CC003366CC003366CC003366
      CC003366CC003366CC006633000000000000DB390000FFFA8A00FFFD9300FFFA
      8A00FFFA8A00FFFA8A00FFFA8A0066666600FFFFFF009F3000009F3000009F30
      00009F300000FFFFFF0066666600000000000000000000000000DBAF9400FCF5
      F100F4DDCF00FFFFFD00FFFBF600FFF8F000FFFAF600FFFCF700FFFFFD000000
      0000F7E1D500F7E8DF00CB9D6F00000000000000000000000000000000000000
      000094949400E5E5E500F8981F00F8D89D00F7DAA100F7DAA200F6AC2F00D9CF
      BE0061616100000000000000000000000000EFC28000973A1100973A1100973A
      1100973A1100973A1100973A1100663300003366CC003366CC003366CC003366
      CC003366CC003366CC006633000000000000EFC28000973A1100973A1100B132
      0000B1320000B1320000B132000066666600FFFFFF009F3000009F3000009F30
      00009F300000FFFFFF0066666600000000000000000000000000D8B49C00E6C7
      B100E2BDA200DFB79A00DFB79A00DEB79900DDB59500DCB49400DBB19100DBB1
      8F00DAB39200D5B29400B0825F00000000000000000000000000000000000000
      000090909000E8E8E800F9951E00F7992700F8971E00F7971E00F29D2B00DBD5
      CC005D5D5D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000663300003366CC003366CC003366CC003366
      CC003366CC003366CC0066330000000000000000000000000000000000000000
      000000000000000000000000000066666600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000092929200D9D9D900E0E0E000E4E4E400E4E4E400E1E1E100DEDEDE00DCDC
      DC00595959000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000663300006633000066330000663300006633
      0000663300006633000066330000000000000000000000000000000000000000
      0000000000000000000000000000666666006666660066666600666666006666
      6600666666006666660066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600ACACAC00A2A2A2009A9A9A00989898009999990097979700B3B3
      B300565656000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000D3C6B500B1320000B1320000B132
      0000B1320000B1320000B1320000B1320000B1320000B1320000B1320000B132
      0000B1320000D5C9B7000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000B1320000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B13200000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000B1320000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B13200000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000B1320000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000B1320000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13200000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4
      E500FFFFFF00973A11000000000000000000B1320000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4
      E500FFFFFF00B13200000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E5009FA5A000AEBC
      BA00FFFFFF00973A11000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4
      E500FFFFFF00973A110000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900973A1100973A1100973A
      1100973A1100973A11000000000000000000B1320000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFD
      E900FFFFFF00B132000000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900DAD8C7000E1314000C15
      1800D6E0E300973A110000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFD
      E900FFFFFF00973A11000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100973A110033CC330033CC
      3300973A1100973A11000000000000000000AC3C0000B13200009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100973A1100973A1100973A
      1100973A1100B13200000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100943911001B0F090031657600207E
      9E001C1E1D00943912000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100973A1100973A1100973A
      1100973A1100973A11000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00973A1100973A1100973A110033CC330033CC
      3300973A1100973A1100973A110000000000B1320000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C
      1B00FF9C1B00B13200000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00784A0E002F3B310033CCFF0033CC
      FF001D3F440046281B000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C
      1B00FF9C1B00973A11000000000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700973A110033CC330033CC330033CC330033CC
      330033CC330033CC3300973A110000000000B1320000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700F6AE3700F6AE3700F6AE3700F6AE3700F6AE
      3700F6AE3700B13200000000000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700B782290017130A004DB8CE0033CCFF0033CC
      FF002FBDEC000E1415009D9FA00000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700973A1100973A1100973A1100973A1100973A
      1100973A1100973A1100973A110000000000DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00973A110033CC330033CC330033CC330033CC
      330033CC330033CC3300973A110000000000B1320000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00FEED7E00FEED7E00FEED7E00FEED7E006666
      660066666600666666006666660000000000DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00F0E077001E1E11005E9D940033CCFF0033CCFF0033CC
      FF0033CCFF002E8CAB00181E1F00C1C1C100DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00973A11000000FF000000FF000000FF000000
      FF000000FF000000FF00973A110000000000EFC28000973A1100973A1100973A
      1100973A1100973A1100973A1100973A1100973A1100973A110033CC330033CC
      3300973A1100973A1100973A110000000000DBC8AB00B1320000B1320000B132
      0000B1320000B1320000B1320000B1320000B1320000B1320000B13200006666
      66000033FF000033FF006666660000000000EFC28000973A1100973A1100973A
      1100973A1100973A11003C180800332F2C0036C8F80033CCFF0033CCFF0033CC
      FF0033CCFF0033CCFF003464740043464800EFC28000973A1100973A1100973A
      1100973A1100973A1100973A1100973A11000000FF000000FF000000FF000000
      FF000000FF000000FF00973A1100000000000000000000000000000000000000
      00000000000000000000000000000000000000000000973A110033CC330033CC
      3300973A11000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006666
      66000033FF000033FF0066666600000000000000000000000000000000000000
      000000000000000000000F3D4D00264E5C001452660014526600145266001452
      66001452660014526600145064000F3D4D000000000000000000000000000000
      0000000000000000000000000000973A1100973A1100973A1100973A1100973A
      1100973A1100973A1100973A1100000000000000000000000000000000000000
      00000000000000000000000000000000000000000000973A1100973A1100973A
      1100973A11000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006666
      6600666666006666660066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFF00030003FFFFFFFF
      00030003FFFFF00700030003FFFFF00700030003C001F00700030003C001F007
      00030003C001F00700030003C001F00700030001C001F00700030001C001F007
      00010001C001F00700010001C011F00700010001C001F007FE01FE01FFFFF007
      FE01FE01FFFFF007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0003000300030003
      0003000300030003000300030003000300030003000300030003000300030003
      0003000300030003000300030003000300030003000300030001000300030003
      000100030001000100010001000000010001000100000001FF87FFE1FC00FE01
      FF87FFE1FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupPhone: TPopupActionBar
    Images = ImageList
    OnPopup = PopupPhonePopup
    Left = 192
    Top = 128
    object PhoneMenuItemMessage: TMenuItem
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
      Hint = #1053#1072#1087#1080#1089#1072#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      ImageIndex = 6
      OnClick = PhoneMenuItemMessageClick
    end
    object PhoneMenuItemCall: TMenuItem
      Caption = #1042#1099#1079#1086#1074
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1074#1099#1079#1086#1074
      ImageIndex = 7
      OnClick = PhoneMenuItemCallClick
    end
  end
  object SavePictureDialog: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 493
    Top = 128
  end
  object OpenPictureDialog: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 277
    Top = 128
  end
  object PopupActionBarPhoto: TPopupActionBar
    OnPopup = PopupActionBarPhotoPopup
    Left = 389
    Top = 128
    object MenuItemLoadPhoto: TMenuItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1102
      OnClick = MenuItemLoadPhotoClick
    end
    object MenuItemSavePhoto: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1102
      OnClick = MenuItemSavePhotoClick
    end
    object MenuItemClearPhoto: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1086#1090#1086
      OnClick = MenuItemClearPhotoClick
    end
  end
  object TimerAction: TTimer
    Enabled = False
    Interval = 500
    Left = 448
    Top = 184
  end
end