inherited BisTaxiDataClientEditForm: TBisTaxiDataClientEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataClientEditForm'
  ClientHeight = 420
  ClientWidth = 642
  ExplicitWidth = 650
  ExplicitHeight = 454
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 382
    Width = 642
    ExplicitTop = 382
    ExplicitWidth = 642
    inherited ButtonOk: TButton
      Left = 463
      ExplicitLeft = 463
    end
    inherited ButtonCancel: TButton
      Left = 559
      ExplicitLeft = 559
    end
  end
  inherited PanelControls: TPanel
    Width = 642
    Height = 382
    ExplicitWidth = 642
    ExplicitHeight = 382
    object PageControl: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 636
      Height = 374
      Margins.Bottom = 5
      ActivePage = TabSheetMain
      Align = alClient
      TabOrder = 0
      OnChange = PageControlChange
      object TabSheetMain: TTabSheet
        Caption = #1050#1072#1088#1090#1086#1095#1082#1072
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        DesignSize = (
          628
          346)
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
          Top = 67
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1077#1083#1077#1092#1086#1085':'
          FocusControl = EditPhone
        end
        object LabelDescription: TLabel
          Left = 238
          Top = 205
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
          FocusControl = MemoDescription
        end
        object LabelFirm: TLabel
          Left = 9
          Top = 40
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
          FocusControl = EditFirm
        end
        object LabelMethod: TLabel
          Left = 305
          Top = 67
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1087#1086#1089#1086#1073' '#1089#1074#1103#1079#1080':'
          FocusControl = ComboBoxMethod
        end
        object LabelUserName: TLabel
          Left = 45
          Top = 205
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Caption = #1051#1086#1075#1080#1085':'
          FocusControl = EditUserName
        end
        object LabelJobTitle: TLabel
          Left = 340
          Top = 40
          Width = 61
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
          FocusControl = EditJobTitle
        end
        object LabelPassword: TLabel
          Left = 38
          Top = 232
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1072#1088#1086#1083#1100':'
          FocusControl = EditPassword
        end
        object LabelDateCreate: TLabel
          Left = 38
          Top = 259
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1086#1079#1076#1072#1085':'
          FocusControl = DateTimePickerCreate
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
          Width = 210
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
        end
        object EditPhone: TEdit
          Left = 85
          Top = 64
          Width = 180
          Height = 21
          MaxLength = 100
          TabOrder = 6
        end
        object MemoDescription: TMemo
          Left = 297
          Top = 202
          Width = 320
          Height = 75
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 15
        end
        object EditFirm: TEdit
          Left = 85
          Top = 37
          Width = 206
          Height = 21
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 3
        end
        object ButtonFirm: TButton
          Left = 297
          Top = 37
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
          Caption = '...'
          TabOrder = 4
        end
        object ComboBoxMethod: TComboBox
          Left = 382
          Top = 64
          Width = 235
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 0
          TabOrder = 8
        end
        object EditUserName: TEdit
          Left = 85
          Top = 202
          Width = 117
          Height = 21
          ParentShowHint = False
          ShowHint = True
          TabOrder = 10
        end
        object EditJobTitle: TEdit
          Left = 407
          Top = 37
          Width = 210
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object BitBtnPhone: TBitBtn
          Left = 271
          Top = 64
          Width = 21
          Height = 21
          TabOrder = 7
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
        object GroupBoxAddress: TGroupBox
          Left = 9
          Top = 91
          Width = 608
          Height = 105
          Anchors = [akLeft, akTop, akRight]
          Caption = ' '#1040#1076#1088#1077#1089' '
          TabOrder = 9
          DesignSize = (
            608
            105)
          object LabelStreet: TLabel
            Left = 13
            Top = 22
            Width = 35
            Height = 13
            Alignment = taRightJustify
            Caption = #1059#1083#1080#1094#1072':'
            FocusControl = EditStreet
          end
          object LabelIndex: TLabel
            Left = 487
            Top = 49
            Width = 41
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = #1048#1085#1076#1077#1082#1089':'
            FocusControl = EditIndex
            ExplicitLeft = 401
          end
          object LabelHouse: TLabel
            Left = 110
            Top = 49
            Width = 24
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = #1044#1086#1084':'
            FocusControl = EditHouse
            ExplicitLeft = 24
          end
          object LabelFlat: TLabel
            Left = 216
            Top = 49
            Width = 53
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = #1050#1074#1072#1088#1090#1080#1088#1072':'
            FocusControl = EditFlat
            ExplicitLeft = 130
          end
          object LabelAddressDesc: TLabel
            Left = 51
            Top = 76
            Width = 92
            Height = 13
            Alignment = taRightJustify
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1072#1076#1088#1077#1089#1072':'
            FocusControl = EditAddressDesc
          end
          object LabelPorch: TLabel
            Left = 355
            Top = 49
            Width = 49
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = #1055#1086#1076#1098#1077#1079#1076':'
            FocusControl = EditPorch
            ExplicitLeft = 269
          end
          object EditStreet: TEdit
            Left = 54
            Top = 19
            Width = 513
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clBtnFace
            MaxLength = 100
            ReadOnly = True
            TabOrder = 0
          end
          object ButtonStreet: TButton
            Left = 573
            Top = 19
            Width = 21
            Height = 21
            Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1083#1080#1094#1091
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 1
          end
          object EditIndex: TEdit
            Left = 534
            Top = 46
            Width = 60
            Height = 21
            Anchors = [akTop, akRight]
            MaxLength = 100
            TabOrder = 5
          end
          object EditHouse: TEdit
            Left = 140
            Top = 46
            Width = 65
            Height = 21
            Anchors = [akTop, akRight]
            MaxLength = 100
            TabOrder = 2
          end
          object EditFlat: TEdit
            Left = 275
            Top = 46
            Width = 65
            Height = 21
            Anchors = [akTop, akRight]
            MaxLength = 100
            TabOrder = 3
          end
          object EditAddressDesc: TEdit
            Left = 149
            Top = 73
            Width = 445
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            MaxLength = 100
            TabOrder = 6
          end
          object EditPorch: TEdit
            Left = 410
            Top = 46
            Width = 65
            Height = 21
            Anchors = [akTop, akRight]
            MaxLength = 100
            TabOrder = 4
          end
        end
        object EditPassword: TEdit
          Left = 85
          Top = 229
          Width = 167
          Height = 21
          ParentShowHint = False
          ShowHint = True
          TabOrder = 12
        end
        object ButtonUserName: TBitBtn
          Left = 208
          Top = 202
          Width = 21
          Height = 21
          Hint = #1053#1086#1074#1099#1081' '#1083#1086#1075#1080#1085
          Caption = '<'
          TabOrder = 11
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
        object GroupBoxLock: TGroupBox
          Left = 85
          Top = 283
          Width = 532
          Height = 52
          Anchors = [akLeft, akRight, akBottom]
          Caption = '                              '
          TabOrder = 16
          DesignSize = (
            532
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
            Width = 237
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Enabled = False
            TabOrder = 3
          end
        end
        object DateTimePickerCreate: TDateTimePicker
          Left = 85
          Top = 256
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Checked = False
          TabOrder = 13
        end
        object DateTimePickerCreateTime: TDateTimePicker
          Left = 179
          Top = 256
          Width = 74
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Kind = dtkTime
          TabOrder = 14
        end
      end
      object TabSheetExtra: TTabSheet
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
        ImageIndex = 6
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 319
        DesignSize = (
          628
          346)
        object LabelPassport: TLabel
          Left = 46
          Top = 119
          Width = 62
          Height = 26
          Alignment = taRightJustify
          Caption = #1055#1072#1089#1087#1086#1088#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077':'
          FocusControl = MemoPassport
          WordWrap = True
        end
        object LabelDateBirth: TLabel
          Left = 24
          Top = 67
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103':'
          FocusControl = DateTimePickerBirth
        end
        object LabelPlaceBirth: TLabel
          Left = 19
          Top = 94
          Width = 89
          Height = 13
          Alignment = taRightJustify
          Caption = #1052#1077#1089#1090#1086' '#1088#1086#1078#1076#1077#1085#1080#1103':'
          FocusControl = EditPlaceBirth
        end
        object LabelGroup: TLabel
          Left = 68
          Top = 12
          Width = 40
          Height = 13
          Alignment = taRightJustify
          Caption = #1043#1088#1091#1087#1087#1072':'
          FocusControl = EditGroup
        end
        object LabelSource: TLabel
          Left = 9
          Top = 40
          Width = 99
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1088#1077#1082#1083#1072#1084#1099':'
          FocusControl = ComboBoxSource
        end
        object LabelSex: TLabel
          Left = 227
          Top = 67
          Width = 23
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1086#1083':'
          FocusControl = ComboBoxSex
        end
        object MemoPassport: TMemo
          Left = 114
          Top = 118
          Width = 505
          Height = 215
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 6
          ExplicitWidth = 525
        end
        object DateTimePickerBirth: TDateTimePicker
          Left = 114
          Top = 64
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 3
        end
        object EditPlaceBirth: TEdit
          Left = 114
          Top = 91
          Width = 425
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 100
          TabOrder = 5
          ExplicitWidth = 445
        end
        object EditGroup: TEdit
          Left = 114
          Top = 10
          Width = 138
          Height = 21
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 0
        end
        object ButtonGroup: TButton
          Left = 258
          Top = 10
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1075#1088#1091#1087#1087#1091
          Caption = '...'
          TabOrder = 1
        end
        object ComboBoxSource: TComboBox
          Left = 114
          Top = 37
          Width = 319
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 0
          TabOrder = 2
        end
        object ComboBoxSex: TComboBox
          Left = 256
          Top = 64
          Width = 99
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          Items.Strings = (
            #1046#1077#1085#1089#1082#1080#1081
            #1052#1091#1078#1089#1082#1086#1081)
        end
      end
      object TabSheetPhones: TTabSheet
        Caption = #1058#1077#1083#1077#1092#1086#1085#1099
        ImageIndex = 6
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 0
      end
      object TabSheetAccount: TTabSheet
        Caption = #1057#1095#1077#1090
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 319
        object PanelReceiptCharges: TPanel
          Left = 0
          Top = 0
          Width = 628
          Height = 37
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 648
          DesignSize = (
            628
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
            Width = 204
            Height = 21
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 0
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
          Width = 622
          Height = 303
          ActivePage = TabSheetAccountReceipts
          Align = alClient
          MultiLine = True
          TabOrder = 1
          OnChange = PageControlAccountChange
          ExplicitWidth = 642
          object TabSheetAccountReceipts: TTabSheet
            Caption = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 634
            ExplicitHeight = 0
          end
          object TabSheetAccountCharges: TTabSheet
            Caption = #1057#1087#1080#1089#1072#1085#1080#1103
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 634
            ExplicitHeight = 0
          end
        end
      end
      object TabSheetDiscounts: TTabSheet
        Caption = #1044#1080#1089#1082#1086#1085#1090#1099
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 0
      end
      object TabSheetMessages: TTabSheet
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 0
        object PageControlMessages: TPageControl
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 622
          Height = 340
          ActivePage = TabSheetOutMessages
          Align = alClient
          MultiLine = True
          TabOrder = 0
          OnChange = PageControlMessagesChange
          ExplicitWidth = 642
          object TabSheetInMessages: TTabSheet
            Caption = #1042#1093#1086#1076#1103#1097#1080#1077
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 634
            ExplicitHeight = 0
          end
          object TabSheetOutMessages: TTabSheet
            Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1077
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 634
            ExplicitHeight = 0
          end
        end
      end
      object TabSheetCalls: TTabSheet
        Caption = #1042#1099#1079#1086#1074#1099
        ImageIndex = 8
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 0
        object PageControlCalls: TPageControl
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 622
          Height = 340
          ActivePage = TabSheetInCalls
          Align = alClient
          MultiLine = True
          TabOrder = 0
          OnChange = PageControlCallsChange
          ExplicitWidth = 642
          object TabSheetInCalls: TTabSheet
            Caption = #1042#1093#1086#1076#1103#1097#1080#1077
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 634
            ExplicitHeight = 0
          end
          object TabSheetOutCalls: TTabSheet
            Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1077
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 634
            ExplicitHeight = 0
          end
        end
      end
      object TabSheetOrders: TTabSheet
        Caption = #1047#1072#1082#1072#1079#1099
        ImageIndex = 7
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 0
      end
      object TabSheetChilds: TTabSheet
        Caption = #1050#1083#1080#1077#1085#1090#1099
        ImageIndex = 7
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 319
      end
      object TabSheetDrivers: TTabSheet
        Caption = #1042#1086#1076#1080#1090#1077#1083#1080
        ImageIndex = 9
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 648
        ExplicitHeight = 0
      end
    end
  end
  inherited ImageList: TImageList
    Left = 152
    Top = 120
    Bitmap = {
      494C010108000900180010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
    Left = 232
    Top = 120
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
end
