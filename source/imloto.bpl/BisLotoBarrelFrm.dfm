inherited BisLotoBarrelFrame: TBisLotoBarrelFrame
  Width = 461
  Height = 177
  ParentBackground = False
  ExplicitWidth = 461
  ExplicitHeight = 177
  object GroupBoxBarrel: TGroupBox
    AlignWithMargins = True
    Left = 5
    Top = 3
    Width = 451
    Height = 134
    Margins.Left = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Caption = ' '#1041#1086#1095#1086#1085#1082#1080' '
    Constraints.MinHeight = 130
    TabOrder = 0
    object PanelBurrel: TPanel
      Left = 2
      Top = 15
      Width = 447
      Height = 117
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        447
        117)
      object LabelBarrelNum: TLabel
        Left = 16
        Top = 12
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1086#1084#1077#1088':'
        FocusControl = EditBarrelNum
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelPrize: TLabel
        Left = 239
        Top = 12
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1079':'
        FocusControl = ComboBoxPrize
      end
      object StringGrid: TStringGrid
        Left = 11
        Top = 38
        Width = 424
        Height = 67
        TabStop = False
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 1
        DefaultColWidth = 24
        DefaultRowHeight = 18
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goVertLine, goHorzLine]
        ScrollBars = ssHorizontal
        TabOrder = 5
        OnDrawCell = StringGridDrawCell
        ColWidths = (
          24)
      end
      object EditBarrelNum: TEdit
        Left = 62
        Top = 6
        Width = 43
        Height = 26
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxLength = 2
        ParentFont = False
        TabOrder = 0
        OnChange = EditBarrelNumChange
      end
      object ButtonAdd: TBitBtn
        Left = 111
        Top = 7
        Width = 30
        Height = 25
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1084#1077#1088
        Default = True
        TabOrder = 1
        OnClick = ButtonAddClick
        Glyph.Data = {
          36060000424D3606000000000000360000002800000020000000100000000100
          18000000000000060000D70D0000D70D00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFE7EEE796BB9D91BB9B91BA9B94BA9CE3ECE4FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBEBEBAEAEAEADADADAC
          ACACADADADE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFCBDBCC309656169A4F15994F2C9554C5D8C7FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4D4D478787876767675
          7575777777D1D1D1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFC7DAC927A15907A74F07A64E259E56C4D8C6FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3D3D37F7F7F7C7C7C7B
          7B7B7C7C7CD0D0D0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          ECF2ECC4D7C7C7DAC999BD9F25AB5C08B65608B45524A85A99BD9FC7DACAC5D7
          C7ECF2ECFFFFFFFFFFFFFFFFFFEFEFEFD0D0D0D3D3D3B0B0B085858587878786
          8686838383B0B0B0D3D3D3D0D0D0EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          B9D0BC47A06631A76126AD5E17BF6109C45C09C15B17BA5E25A75A259D553192
          54B8CFBBFFFFFFFFFFFFFFFFFFC7C7C785858586868687878792929292929290
          90908E8E8E8282827B7B7B757575C6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          B8D1BC4FAF7641BF7A2EC4711DCB6A13D2680DCC620ABE5A08B15407A24C1E96
          50B6CFBBFFFFFFFFFFFFFFFFFFC8C8C89494949D9D9D9C9C9C9C9C9C9F9F9F99
          99998E8E8E848484787878757575C6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          B8D1BC52B1794DC38247CB8240D38137D87F2DD27725C56C1EB76319A959289A
          58B7D0BBFFFFFFFFFFFFFFFFFFC8C8C8969696A3A3A3A7A7A7ABABABADADADA6
          A6A69A9A9A8E8E8E8282827A7A7AC7C7C7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          B9D0BC53A56F54B37A4FB9794BCC833FCF7F39CC7A3CC3773BAE6A37A4633B96
          5BB8CFBBFFFFFFFFFFFFFFFFFFC7C7C78C8C8C9898989B9B9BA9A9A9A8A8A8A4
          A4A49E9E9E8E8E8E8585857B7B7BC6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          ECF2ECC5D8C7C8DACA9ABEA04DB77743C67E3CC37843B27099BD9FC8DACAC5D7
          C7ECF2ECFFFFFFFFFFFFFFFFFFEFEFEFD1D1D1D3D3D3B1B1B1999999A3A3A39F
          9F9F939393B0B0B0D3D3D3D0D0D0EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFC7DACA51AF7647BD7C40B97646AA6EC4D8C7FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3D3D39494949D9D9D98
          98988E8E8ED0D0D0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFCBDBCC52A5704EB07848AD7449A169C5D8C7FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4D4D48C8C8C95959591
          9191878787D1D1D1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFE7EEE79ABDA097BDA097BDA098BC9FE3ECE4FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBEBEBB0B0B0B0B0B0B0
          B0B0AFAFAFE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        NumGlyphs = 2
      end
      object ButtonDel: TBitBtn
        Left = 147
        Top = 7
        Width = 30
        Height = 25
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1080#1081' '#1085#1086#1084#1077#1088
        TabOrder = 2
        OnClick = ButtonDelClick
        Glyph.Data = {
          36060000424D3606000000000000360000002800000020000000100000000100
          18000000000000060000D70D0000D70D00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FEFEFEF6F6F9F6F6F8F6F6F8F6F6F8F6F6F7F6F6F8F6F6F8F6F6F8F6F6F8F7F7
          F9FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEF6F6F6F6F6F6F6F6F6F6F6F6F6
          F6F6F6F6F6F6F6F6F6F6F6F6F6F6F7F7F7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFF
          C7C7DD6868AE5E5EB25858B55858B95858BC5858BB5858B75858B25858AC5D5D
          A6C6C6DCFFFFFFFFFFFFFFFFFFFFFFFFCDCDCD7D7D7D77777773737375757576
          7676757575747474737373717171727272CCCCCCFFFFFFFFFFFFFFFFFFFFFFFF
          B6B6D34B4BB03E3EBD2B2BC21D1DCA1515D11111CC0E0EBF0D0DB10B0BA21D1D
          97B4B4D2FFFFFFFFFFFFFFFFFFFFFFFFBEBEBE6969696464645858585050504D
          4D4D4949494343433E3E3E383838414141BDBDBDFFFFFFFFFFFFFFFFFFFFFFFF
          B6B6D35151B24F4FC24949CA4242D23A3AD73131D22929C52323B71D1DA92828
          9CB4B4D2FFFFFFFFFFFFFFFFFFFFFFFFBEBEBE6E6E6E7171716F6F6F6D6D6D69
          69696161615757574F4F4F4747474A4A4ABDBDBDFFFFFFFFFFFFFFFFFFFFFFFF
          C6C6DC7171B17272B97070BB6E6EBE6C6CC06A6ABE6868BB6565B66363B16363
          A9C6C6DBFFFFFFFFFFFFFFFFFFFFFFFFCCCCCC84848487878786868686868685
          85858383838080807D7D7D7A7A7A787878CCCCCCFFFFFFFFFFFFFFFFFFFFFFFF
          FEFEFEF6F6F9F5F5F8F5F5F7F5F5F7F5F5F7F5F5F7F5F5F8F5F5F8F5F5F8F6F6
          F9FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEF6F6F6F5F5F5F5F5F5F5F5F5F5
          F5F5F5F5F5F5F5F5F5F5F5F5F5F5F6F6F6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        NumGlyphs = 2
      end
      object ComboBoxPrize: TComboBox
        Left = 273
        Top = 9
        Width = 162
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 4
        OnChange = ComboBoxPrizeChange
      end
      object ButtonClear: TBitBtn
        Left = 183
        Top = 7
        Width = 30
        Height = 25
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1085#1086#1084#1077#1088#1072
        TabOrder = 3
        OnClick = ButtonClearClick
        Glyph.Data = {
          36060000424D3606000000000000360000002800000020000000100000000100
          18000000000000060000D70D0000D70D00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFDF6F4F1FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFDFDFDF3F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFCFBC3AD95DFD2C3FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFBFBFBA8A8A8CECECEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD0BDA6A77D42DFD2C3FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFB8B8B86F6F6FCECECEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5DBD1A2722CAC8247EEE7
          E0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFD9D9D9616161747474E5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFEDBCEBFEEE8E2FFFFFFFFFFFFEDE6E0A678379F6915C3A7
          83FEFDFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFECACACAE6E6E6FF
          FFFFFFFFFFE4E4E46969695555559F9F9FFDFDFDFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFDED1BCB59050E7DED3FFFFFFFFFFFFD9CAB8A371269F6710A77A
          39ECE6DEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCCCC808080DBDBDBFF
          FFFFFFFFFFC6C6C65F5F5F5252526B6B6BE4E4E4FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFE2D6C6C29A42C49830CDB795D7C4A7C8AD80B3873BA77114A06811A16D
          1FD5C4B0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD2D2D28383837D7D7DAFAFAFBD
          BDBDA2A2A27474745A5A5A5353535A5A5ABFBFBFFFFFFFFFFFFFFFFFFFFFFFFF
          E4DACCC39C4AD4A31FD8A822D0A127C99923C18F1DB78216AB7514A56F1BA36F
          20C8B092FFFFFFFFFFFFFFFFFFFFFFFFD6D6D68787878080808484848181817A
          7A7A7171716666665D5D5D5B5B5B5C5C5CA9A9A9FFFFFFFFFFFFFFFFFFE8DED3
          C0994DD09F1FDCAB1DE3B21EDEAD1DD3A01AC69318BB871AB48225AA7826A471
          23C8B194FFFFFFFFFFFFFFFFFFDBDBDB8686867D7D7D8585858A8A8A8686867C
          7C7C7373736B6B6B6B6B6B6464645E5E5EAAAAAAFFFFFFFFFFFFFAF9F9C1A57C
          CBA03BD5A628E0B023E7B823E1B222D6A625CD9E2DC59737BA8B35AC7A29A576
          30DBCDBCFFFFFFFFFFFFF9F9F99B9B9B8686868484848A8A8A9090908B8B8B84
          84848080807E7E7E757575666666656565C9C9C9FFFFFFFFFFFFFFFFFFE4DACC
          CAAC75E1C171E6C463E8C45AE4BF55DDB752D3AB4DC79C43BA8C37AC7D32BA9B
          72F8F5F3FFFFFFFFFFFFFFFFFFD6D6D69E9E9EACACACAAAAAAA7A7A7A2A2A29C
          9C9C9292928585857777776B6B6B919191F4F4F4FFFFFFFFFFFFFFFFFFFFFFFF
          E2D7C9CDB077E3C577E2C36FD8B560D1AB57C7A14FBE954AB79156C6AD8DF1ED
          E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3D3D3A1A1A1B0B0B0ACACAC9F9F9F95
          95958C8C8C828282838383A5A5A5EBEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFE1D5C6CEAF74D0B06DD0BCA0DECFBADDCFBBE2D6C8EFEAE4FDFDFCFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD1D1D1A0A0A09F9F9FB5B5B5CA
          CACACACACAD3D3D3E8E8E8FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE0D3C3BE9F6FE8DFD5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCF939393DCDCDCFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFDCD0C3EFE9E3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDCDCDE7E7E7FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        NumGlyphs = 2
      end
    end
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 142
    Width = 461
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      461
      35)
    object LabelPrizeSum: TLabel
      Left = 10
      Top = 8
      Width = 82
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1079#1086#1074#1086#1081' '#1092#1086#1085#1076':'
      FocusControl = EditPrizeSum
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelTicketCount: TLabel
      Left = 200
      Top = 8
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditTicketCount
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelTicketSum: TLabel
      Left = 337
      Top = 8
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1091#1084#1084#1072':'
      FocusControl = EditTicketSum
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EditPrizeSum: TEdit
      Left = 98
      Top = 5
      Width = 90
      Height = 21
      Hint = #1055#1088#1080#1079#1086#1074#1086#1081' '#1092#1086#1085#1076' '#1090#1091#1088#1072
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object EditTicketCount: TEdit
      Left = 270
      Top = 5
      Width = 58
      Height = 21
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1086#1074#1087#1072#1074#1096#1080#1093' '#1073#1080#1083#1077#1090#1086#1074
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object EditTicketSum: TEdit
      Left = 378
      Top = 5
      Width = 75
      Height = 21
      Hint = #1057#1091#1084#1084#1072' '#1085#1072' '#1086#1076#1080#1085' '#1073#1080#1083#1077#1090
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object PanelWait: TPanel
      Left = 194
      Top = 2
      Width = 262
      Height = 27
      Anchors = [akLeft, akRight, akBottom]
      Caption = #1048#1076#1077#1090' '#1088#1072#1089#1095#1077#1090'.'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      Visible = False
    end
  end
end
