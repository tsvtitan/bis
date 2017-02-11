inherited BisTaxiAddressFrame: TBisTaxiAddressFrame
  Width = 665
  Height = 58
  OnResize = FrameResize
  ExplicitWidth = 665
  ExplicitHeight = 58
  DesignSize = (
    665
    58)
  object LabelZone: TLabel
    Left = 494
    Top = 34
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = #1047#1086#1085#1072':'
    FocusControl = ComboBoxZone
    Transparent = True
  end
  object LabelLocality: TLabel
    Left = 77
    Top = 7
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1055#1091#1085#1082#1090':'
    FocusControl = ComboBoxLocality
    Transparent = True
  end
  object LabelStreet: TLabel
    Left = 351
    Top = 7
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1059#1083#1080#1094#1072':'
    FocusControl = ComboBoxStreet
    Transparent = True
  end
  object LabelHouse: TLabel
    Left = 42
    Top = 34
    Width = 70
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1086#1084' / '#1050#1086#1088#1087#1091#1089':'
    FocusControl = EditHouse
    Transparent = True
  end
  object LabelFlat: TLabel
    Left = 193
    Top = 34
    Width = 90
    Height = 13
    Alignment = taRightJustify
    Caption = #1050#1074#1072#1088#1090#1080#1088#1072' / '#1054#1092#1080#1089':'
    FocusControl = EditFlat
    Transparent = True
  end
  object LabelPorch: TLabel
    Left = 379
    Top = 34
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = #1055#1086#1076#1098#1077#1079#1076':'
    FocusControl = EditPorch
    Transparent = True
  end
  object ImageAddress: TImage
    Left = 168
    Top = 31
    Width = 21
    Height = 21
    Hint = #1057#1090#1072#1090#1091#1089' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1084#1072#1088#1096#1088#1091#1090#1072
    Center = True
    Transparent = True
  end
  object ComboBoxZone: TComboBox
    Left = 528
    Top = 31
    Width = 131
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 7
    OnChange = ComboBoxZoneChange
  end
  object ComboBoxLocality: TComboBox
    Left = 118
    Top = 4
    Width = 221
    Height = 21
    AutoDropDown = True
    AutoCloseUp = True
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBoxLocalityChange
    OnExit = ComboBoxLocalityExit
  end
  object ComboBoxStreet: TComboBox
    Left = 392
    Top = 4
    Width = 267
    Height = 21
    AutoDropDown = True
    AutoCloseUp = True
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    OnChange = ComboBoxLocalityChange
    OnExit = ComboBoxStreetExit
  end
  object EditHouse: TEdit
    Left = 118
    Top = 31
    Width = 50
    Height = 21
    Constraints.MaxWidth = 300
    TabOrder = 3
    OnChange = ComboBoxLocalityChange
    OnExit = EditHouseExit
  end
  object EditFlat: TEdit
    Left = 289
    Top = 31
    Width = 50
    Height = 21
    Constraints.MaxWidth = 300
    TabOrder = 4
    OnChange = ComboBoxLocalityChange
  end
  object EditPorch: TEdit
    Left = 434
    Top = 31
    Width = 50
    Height = 21
    Constraints.MaxWidth = 300
    TabOrder = 6
    OnChange = ComboBoxLocalityChange
  end
  object ButtonFirm: TBitBtn
    Left = 5
    Top = 4
    Width = 60
    Height = 21
    Hint = #1053#1072#1081#1090#1080' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
    Caption = #1085#1072#1081#1090#1080
    TabOrder = 0
    OnClick = ButtonFirmClick
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E9
      E9EFEFEFFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFEDEDEDF1F1F1FBFBFBFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFA0B9D35C85
      B0C2C8CFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFC7C7C79E9E9ED2D2D2F1F1F1FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF9CB8D60B5DB50C5E
      B94676ABDCE0E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFC6C6C67A7A7A7B7B7B939393E4E4E4FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFDFDFDFDFDFDFCFCFCFFFFFF9BBBDA116BC50D6CCD0D62
      BC5E8BBDEFF2F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFDFDFDFD
      FDFDFFFFFFC8C8C88383838282827D7D7DA3A3A3F5F5F5FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFBFBFBE3E5E8D6D9DCE2E3E4A5BCD20E79DA0678E51070CF548C
      C3F0F4F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBEAEAEADFDFDFE5
      E5E5C8C8C88989898989898383839E9E9EF6F6F6FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF4F6F9BFC0C1949088919185A19994929CA93685C41387EE5894CFF2F2
      F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7C1C1C18D8D8D8B8B8B9D
      9D9DAAAAAA8B8B8B8E8E8EA1A1A1F5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FBFCFEB4B7B7DAAF7AFFD5AAFFD5AAF6BA74AF9F898A96A279A4CCE9EDF1FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCB2B2B29A9A9ABCBCBCBCBCBCA0
      A0A09292929A9A9AAAAAAAF0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      C9CACCD1AD83FFD5AAFFD5AAFFD5AAFFD5AAF4BC6FAF9F93D5D4D2FDFDFDFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCCCC999999BCBCBCBCBCBCBCBCBCBC
      BCBCA0A0A09F9F9FD9D9D9FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      8F8D8BFFD5AAFFD5AAFFD5AAFFD5AAFFD5AAFFD5AAAF9C7EBFC5CCFEFEFEFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF919191BCBCBCBCBCBCBCBCBCBCBCBCBC
      BCBCBCBCBC909090CCCCCCFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      898785FFD5AAFFD5AAFFD5AAFFD5AAFFD5AAFFD5AAB19E7EC5CCD4FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8C8CBCBCBCBCBCBCBCBCBCBCBCBCBC
      BCBCBCBCBC919191D1D1D1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      C1C3C7C8B091FFD5AAFFD5AAFFD5AAFFD5AAF8B053B0A296E2E6E9FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC8C8C89B9B9BBCBCBCBCBCBCBCBCBCBC
      BCBC9797979D9D9DE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FAFCFDA4A8A9D1AD7BFFD5AAFFD5AAFAAF56B9AA91CED4DAFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCA9A9A9989898BCBCBCBCBCBC97
      97979A9A9AD5D5D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF0F2F4BFC3C997938B989381AFA8A3DBE0E6F8F8F8FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4C4C4C48F8F8F8B8B8BA5
      A5A5E1E1E1FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Margin = 0
    NumGlyphs = 2
  end
  object BitBtnCheckAddress: TBitBtn
    Left = 345
    Top = 31
    Width = 21
    Height = 21
    Hint = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1072#1076#1088#1077#1089' '#1087#1086' '#1095#1077#1088#1085#1086#1084#1091' '#1089#1087#1080#1089#1082#1091
    TabOrder = 5
    OnClick = BitBtnCheckAddressClick
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFEFEFEFBFBFBEEEEEEBFBFBF9A9A9AB8B8B8ECECECF9F9F9FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCF0F0F0C9C9C9A8
      A8A8C2C2C2EFEFEFFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFEFEFEF3F3F3909B914B694F49624A939593CBCBCBF5F5F5FDFDFDFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEF4F4F4A8A8A86C6C6C6C
      6C6CA5A5A5D2D2D2F7F7F7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF3F3F38C968D6C8D6FD1F5D7ADD3AF4B5F4DB1B1B1E4E4E4FAFAFAFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4A4A4A47E7E7EB5B5B59F
      9F9F717171BBBBBBE8E8E8FBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE
      F7F7F78F9990698E6AC2EFC1D8FFD9D5FFD66D956F767D76C7C7C7F3F3F3FDFD
      FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7A6A6A67D7D7DAFAFAFBDBDBDBA
      BABA7E7E7E909090CECECEF5F5F5FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9
      9FAAA0658D65B8EDB3C6FFC498CC97C4FAC2B7EAB44E664FA4A4A4DBDBDBF9F9
      F9FEFEFEFFFFFFFFFFFFFFFFFFFAFAFAB3B3B37B7B7BACACACB5B5B5989898B2
      B2B2A8A8A8707070B0B0B0E0E0E0FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFEDEEED
      4B704BB3F0AABCFFB46CA06B4F6B4F9DD89AC1FEBD84B9835F6B5FC4C4C4ECEC
      ECFBFBFBFFFFFFFFFFFFFFFFFFF1F1F16D6D6DAAAAAAB1B1B18080807373739F
      9F9FB2B2B28D8D8D7E7E7ECACACAEFEFEFFCFCFCFFFFFFFFFFFFFFFFFFEEEFEE
      456D449AE49160985E929F93E6E6E6537752B6FCADA8ECA35F835E8D8D8DD9D9
      D9F5F5F5FFFFFFFFFFFFFFFFFFF2F2F26A6A6A9E9E9E7A7A7AA9A9A9EAEAEA73
      7373ADADADA4A4A47B7B7B9F9F9FDEDEDEF7F7F7FFFFFFFFFFFFFFFFFFFFFFFF
      D2D8D269806AACB7ACFBFBFBFFFFFFA6B3A771AE6CB8FFAE83C47D637263B5B5
      B5E4E4E4FFFFFFFFFFFFFFFFFFFFFFFFDCDCDC8A8A8ABEBEBEFBFBFBFFFFFFB9
      B9B9848484B1B1B18F8F8F808080BDBDBDE8E8E8FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFC60806099EB8EA3F6986394607D7F
      7DCBCBCBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC
      FCFC7F7F7F9E9E9EA6A6A67F7F7F949494D1D1D1FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCBD1CB5B9256A4FF9680CE77647C
      63A2A3A3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFD6D6D6787878AAAAAA909090828282AFAFAFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F988A18677CB6C9DFF8B5081
      4AADAFADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFAFAFAA0A0A08C8C8CA8A8A8727272BCBCBCFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFE3E061885D518B488AA2
      88E9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFE6E6E67F7F7F717171A1A1A1ECECECFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFEE6E9E6D5D9D5F1F2
      F1FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFEBEBEBDEDEDEF4F4F4FDFDFDFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Margin = 0
    NumGlyphs = 2
  end
  object BitBtnClear: TBitBtn
    Left = 5
    Top = 31
    Width = 21
    Height = 21
    Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1072#1076#1088#1077#1089
    TabOrder = 8
    OnClick = BitBtnClearClick
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFD
      F6F6F6CBCBCDA3A3A3C3C3C3EBEBEBF8F8F8FCFCFCF7F7F7DEDEDEAFAFB0ABAB
      ABDBDBDBFFFFFFFFFFFFFFFFFFFEFEFEF7F7F7D2D2D2AFAFAFCCCCCCEEEEEEF9
      F9F9FDFDFDF8F8F8E3E3E3BABABAB7B7B7E0E0E0FFFFFFFFFFFFFFFFFFFDFDFE
      B3B3CF20258F3E41898D8D91C7C7C7ECECECF6F6F6CFCFD4525399191C836F70
      8CAEAEAEFFFFFFFFFFFFFFFFFFFEFEFEC3C3C35858586B6B6B9D9D9DCFCFCFEF
      EFEFF7F7F7D7D7D77979794F4F4F898989B9B9B9FFFFFFFFFFFFFFFFFFEDEDF1
      191E9E1F38FF1224E53437938E8E91C8C8C8C3C3C74447A20010DE0016FF1319
      929C9CA0FFFFFFFFFFFFFFFFFFF0F0F05757578282826C6C6C6565659D9D9DCF
      CFCFCBCBCB7272725E5E5E6D6D6D515151AAAAAAFFFFFFFFFFFFFFFFFFF3F3F7
      3C3FAC2739F1AAAAFF1424E43337927777823C419A0215DFAAAAFF0013ED2D31
      9ACACACEFFFFFFFFFFFFFFFFFFF5F5F56F6F6F797979C7C7C76C6C6C6464648A
      8A8A6B6B6B626262C7C7C7666666636363D1D1D1FFFFFFFFFFFFFFFFFFFEFEFE
      CACADF4248BF2637F0AAAAFF1525E5242BA70C1EE2AAAAFF0319EF262DACB0B1
      C2F4F4F4FFFFFFFFFFFFFFFFFFFEFEFED4D4D4787878787878C7C7C76D6D6D60
      6060686868C7C7C76B6B6B646464BEBEBEF6F6F6FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFC4C4D84349BF2739F1AAAAFFAAAAFFAAAAFF0F24F2252EAAA6A6B5F3F3
      F3FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCF787878797979C7C7C7C7
      C7C7C7C7C7717171626262B4B4B4F4F4F4FDFDFDFFFFFFFFFFFFFFFFFFFFFFFF
      FEFEFEFFFFFF9E9EB52630C8AAAAFFAAAAFFAAAAFF2128B769687CC4C4C4ECEC
      ECF8F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAEAE6A6A6AC7C7C7C7
      C7C7C7C7C76161617F7F7FCBCBCBEFEFEFF9F9F9FFFFFFFFFFFFFFFFFFFFFFFF
      FDFDFDD2D2D75355AF313FE7AAAAFFAAAAFFAAAAFF1D2DEA3032908F8F93C8C8
      C8ECECECFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDD8D8D87D7D7D787878C7C7C7C7
      C7C7C7C7C77373736262629E9E9ECFCFCFEFEFEFFFFFFFFFFFFFFFFFFFFEFEFE
      DADAE2585AB33B46E5AAAAFF3847F42530D92D3FF4AAAAFF1E2DE73539948C8C
      92C7C7C7FFFFFFFFFFFFFFFFFFFEFEFEDFDFDF8181817C7C7CC7C7C78080806D
      6D6D7C7C7CC7C7C77171716666669C9C9CCFCFCFFFFFFFFFFFFFFFFFFFF5F5F8
      6164B94954E5AAAAFF4551F23D42B88484A94247BE3040F2AAAAFF1F2FE43D40
      8E9D9DA0FFFFFFFFFFFFFFFFFFF6F6F6888888818181C7C7C78585857171719A
      9A9A7575757D7D7DC7C7C77272726B6B6BAAAAAAFFFFFFFFFFFFFFFFFFECECF2
      1B1FA47582FF5560F3444ABBB2B2C6FDFDFDC1C1D5474CC03444F2364DFF1920
      A0B1B1B9FFFFFFFFFFFFFFFFFFEFEFEF575757A4A4A48B8B8B767676BFBFBFFD
      FDFDCCCCCC7979797F7F7F8D8D8D575757BCBCBCFFFFFFFFFFFFFFFFFFFBFBFC
      9696CF2529AE4A4CB8BBBBD3FBFBFBFEFEFEFFFFFFC7C7DD4549B51219A6888A
      C0EFEFF1FFFFFFFFFFFFFFFFFFFCFCFCB0B0B05F5F5F787878C8C8C8FBFBFBFF
      FFFFFFFFFFD2D2D2767676555555A4A4A4F1F1F1FFFFFFFFFFFFFFFFFFFFFFFF
      FBFBFCD4D4E6E2E2ECFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFE5E5EDD4D4E3F5F5
      F6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCDBDBDBE7E7E7FDFDFDFFFFFFFF
      FFFFFFFFFFFFFFFFE9E9E9DBDBDBF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Margin = 0
    NumGlyphs = 2
  end
  object TimerChangeAddress: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerChangeAddressTimer
    Left = 576
  end
  object ImageList: TImageList
    BkColor = clWhite
    Left = 608
    Bitmap = {
      494C010104000900040010001000FFFFFF00FF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF001C811F001B7E1F001B7A1F001A731E001A701E001B711F001B711F001B6C
      1F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000F1000000F1000000F1000000F1000000EF000000EF000000ED000000
      ED00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0072747500717374006F7172006B6D6E00696B6C006A6C6D006A6C6D00686A
      6B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00646667006466670064666700646667006466670064666700646667006466
      6700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001C8A
      21001B831F0042A0520087CA9A009BD3AB009BD2AB0083C796003D974C001A6E
      1E001B701F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      F5001A20F5003C4CF9003A49F8003847F8003545F8003443F7003242F700141B
      F1000000ED00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007779
      7A007375760093949500C0C1C100CBCCCC00CACBCB00BEBFBF008C8D8E00696B
      6C006A6C6D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006567
      680077797A0092939400919293008F9091008E8F90008C8D8E008C8D8E007375
      760064666700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001C912B001B8A
      20006DBE8300A8DBB50087CC980066BC7D0064BA7C0086CB9800A5D9B40066B7
      7D001A6C1D001B711F00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000F7001D23
      F9004453FA002429F9001212F7000F0FF6000C0CF5000909F500161BF5003343
      F700141BF1000000ED00FFFFFF00FFFFFF00FFFFFF00FFFFFF007D7F80007779
      7A00B3B4B400D2D3D300C1C2C200B0B1B100AEAFAF00C0C1C100D1D2D200ADAE
      AE00686A6B006A6C6D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00666869007A7C
      7D00969898007D7F8000707273006E7071006C6E6F006A6C6D00747677008C8D
      8E007375760064666700FFFFFF00FFFFFF00FFFFFF001D9B36001C962F0072C2
      8700A8DBB20060BC77005CBA730059B8700059B56F0058B56F005BB77400A5D9
      B30069B87F001A711E001B711F00FFFFFF00FFFFFF000000F9001F25FA004A58
      FB004247FB00C9C9FD003B3BF9001313F7001010F6003333F700C5C5FD003035
      F7003444F700141BF2000000ED00FFFFFF00FFFFFF008788890082838400B6B7
      B700D2D3D300AEAFAF00ABACAC00A8AAAA00A6A8A800A6A8A800A9ABAB00D1D2
      D200AFB0B0006A6C6D006A6C6D00FFFFFF00FFFFFF00666869007C7E7F009A9C
      9C0091929300DFDFDF008A8B8C00717374006F71720084858600DDDDDD008586
      87008D8E8F007375760064666700FFFFFF00FFFFFF001EA43D004CB06400AADD
      B40064C179005FBE710075C58500D4ECD9008ACD990056B66C0058B56E005CB7
      7400A6DAB400419B4E001B771F00FFFFFF00FFFFFF000000FB004F5DFD003237
      FB00CBCBFE00F2F2FF00EBEBFE003B3BF9003939F800EAEAFE00F1F1FE00C5C5
      FD00181DF6003343F7000000EF00FFFFFF00FFFFFF008C8D8E00A0A2A200D3D4
      D400B1B2B200ADAEAE00B7B8B800E8E8E800C2C3C300A6A8A800A6A8A800A9AB
      AB00D2D3D3008F9091006E707100FFFFFF00FFFFFF0067696A009D9F9F008788
      8900E1E1E100F7F7F700F3F3F3008A8B8C0088898A00F3F3F300F6F6F600DDDD
      DD00767879008C8D8E0064666700FFFFFF00FFFFFF001FA9420091D29F008DD4
      9A0064C3740079C98700F2FAF400FFFFFF00FDFEFD0086CB960057B76D005BB9
      720085CC970087C79A001B781F00FFFFFF00FFFFFF000000FD00525FFD002828
      FC004747FC00ECECFF00F2F2FF00ECECFF00ECECFE00F1F1FF00EAEAFE003434
      F7000B0BF5003545F8000000EF00FFFFFF00FFFFFF0091929300C7C8C800C6C7
      C700B0B1B100BABBBB00F9F9F900FFFFFF00FEFEFE00C0C1C100A7A9A900ABAC
      AC00C1C2C200BFC0C0006E707100FFFFFF00FFFFFF0067696A009FA1A1007F80
      810091929300F4F4F400F7F7F700F4F4F400F4F4F400F7F7F700F3F3F3008586
      87006C6E6F008E8F900064666700FFFFFF00FFFFFF001FAD4200A6DCAF0070CA
      7F0073CA8000F0F9F100FFFFFF00EBF7ED00FFFFFF00FBFDFC0088CD96005BB9
      710067BE7D00A0D7AF001B7A1E00FFFFFF00FFFFFF000000FD005562FE002C2C
      FD002929FC004848FC00EDEDFF00F2F2FF00F2F2FF00ECECFE003A3AF9001212
      F7000F0FF6003848F8000000F100FFFFFF00FFFFFF0092939400D2D3D300B8B9
      B900B9BABA00F7F7F700FFFFFF00F5F5F500FFFFFF00FDFDFD00C1C2C200ABAC
      AC00B0B1B100CECFCF006E707100FFFFFF00FFFFFF0067696A00A0A2A2008283
      84008081820092939400F5F5F500F7F7F700F7F7F700F4F4F400898A8B007072
      73006E7071009091920064666700FFFFFF00FFFFFF0026B44B00A7DDB10072CC
      800066C77300B0E1B700D2EED60063C17000B8E3BF00FFFFFF00FBFDFC008CD0
      990069C17E00A1D7AE001B7F1E00FFFFFF00FFFFFF000000FD005764FE003030
      FD002D2DFD004B4BFC00EDEDFF00F2F2FF00F2F2FF00ECECFF003D3DF9001616
      F8001313F7003C4BF8000000F100FFFFFF00FFFFFF00999B9B00D2D3D300B9BA
      BA00B3B4B400D8D8D800E9E9E900AFB0B000DBDBDB00FFFFFF00FDFDFD00C3C4
      C400B3B4B400CECFCF0071737400FFFFFF00FFFFFF0067696A00A1A3A3008485
      86008283840094969600F5F5F500F7F7F700F7F7F700F4F4F4008B8C8D007274
      7500717374009192930064666700FFFFFF00FFFFFF002DBB540095D7A10091D7
      9B0069C9760064C66F0061C46E0061C36F0061C26F00B9E4C000FFFFFF00E3F4
      E6008BD199008BCE9D001C882000FFFFFF00FFFFFF000000FF005A67FE003333
      FE005050FD00EDEDFF00F3F3FF00EDEDFF00EDEDFF00F2F2FF00ECECFE003E3E
      FA001717F8003F4EF9000000F100FFFFFF00FFFFFF009FA1A100CACBCB00C8C9
      C900B5B6B600B1B2B200B0B1B100B0B1B100AFB0B000DCDCDC00FFFFFF00F1F1
      F100C4C5C500C3C4C40077797A00FFFFFF00FFFFFF00686A6B00A4A6A6008687
      880096989800F5F5F500F8F8F800F5F5F500F5F5F500F7F7F700F4F4F4008C8D
      8E00737576009394950064666700FFFFFF00FFFFFF0034BE590057BF7000AFE1
      B7006DCC7A0068C8720065C7700063C56E0062C46E0063C47100B6E3BE006FC7
      7E00ACDFB50048A95E001C8F2600FFFFFF00FFFFFF000000FF005B68FF004347
      FE00CFCFFF00F3F3FF00EDEDFF004C4CFC004A4AFC00ECECFF00F2F2FF00CACA
      FE002A2FFA004251FA000000F300FFFFFF00FFFFFF00A2A4A400ACADAD00D8D8
      D800B7B8B800B3B4B400B2B3B300B0B1B100B0B1B100B0B1B100DBDBDB00B6B7
      B700D6D6D6009B9D9D007C7E7F00FFFFFF00FFFFFF00686A6B00A5A7A7009192
      9300E3E3E300F8F8F800F5F5F5009496960093949500F4F4F400F7F7F700E0E0
      E000828384009698980064666700FFFFFF00FFFFFF0039C25C0034BE55007FCE
      9000AEE1B5006DCC7A006ACA760068C8720068C8740068C875006BC97900ACDF
      B40076C489001C962D001C942D00FFFFFF00FFFFFF000000FF00262BFF005D6A
      FF00585BFF00CFCFFF005252FE002F2FFD002C2CFD004B4BFC00CCCCFE00484C
      FB004957FB001D23F9000000F500FFFFFF00FFFFFF00A5A7A700A1A3A300BFC0
      C000D7D7D700B7B8B800B5B6B600B3B4B400B4B5B500B4B5B500B5B6B600D6D6
      D600B8B9B9008283840081828300FFFFFF00FFFFFF00686A6B0082838400A5A7
      A7009D9F9F00E3E3E300989A9A00838485008283840094969600E2E2E2009496
      9600999B9B007A7C7D0065676800FFFFFF00FFFFFF00FFFFFF003BC55E0034C0
      55007FCE9000AFE1B70092D89D0077CE830077CE830092D89D00AEE1B50078C8
      8B001D9D32001D9D3600FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF00262B
      FF005D6AFF004347FF003434FE003232FE003030FD002D2DFD00383CFC004F5D
      FC001F25FA000000F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00A8AAAA00A2A4
      A400BFC0C000D8D8D800C9CACA00BBBCBC00BBBCBC00C9CACA00D7D7D700BABB
      BB008788890087888900FFFFFF00FFFFFF00FFFFFF00FFFFFF00686A6B008283
      8400A5A7A70091929300878889008687880084858600828384008B8C8D009D9F
      9F007C7E7F0066686900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003DC7
      600036C2590059C2740096D7A300A5DCAE00A5DCAE0095D6A10050B96A001FAB
      42001FA94200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF00262BFF005C69FF005B68FF005A67FE005865FE005663FE005461FE002227
      FC000000FB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ABAC
      AC00A5A7A700B0B1B100CACBCB00D1D2D200D1D2D200C9CACA00A6A8A8009192
      930091929300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00686A
      6B0082838400A5A7A700A5A7A700A4A6A600A2A4A400A1A3A300A0A2A2007D7F
      800067696A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0040C962003BC55E0039C25B0031BD54002DBB52002BB952002BB7520028B4
      4E00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000FD000000FD000000FD000000
      FD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00ACADAD00A8AAAA00A5A7A700A0A2A2009FA1A1009D9F9F009C9E9E009A9C
      9C00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00686A6B00686A6B00686A6B00686A6B0067696A0067696A0067696A006769
      6A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFF00FF00FF00FF00F
      E007E007E007E007C003C003C003C00380018001800180018001800180018001
      8101800181018001828180018281800180418001804180018021800180218001
      80018001800180018001800180018001C003C003C003C003E007E007E007E007
      F00FF00FF00FF00FFFFFFFFFFFFFFFFF}
  end
end