inherited BisTimedMsgForm: TBisTimedMsgForm
  Left = 472
  Top = 324
  BorderStyle = bsDialog
  ClientHeight = 68
  ClientWidth = 135
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 141
  ExplicitHeight = 100
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel: TBevel
    Left = 0
    Top = 57
    Width = 135
    Height = 3
    Align = alTop
    Shape = bsTopLine
    ExplicitLeft = 208
    ExplicitTop = 72
    ExplicitWidth = 50
  end
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 135
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object ImageIcon: TImage
      Left = 8
      Top = 16
      Width = 32
      Height = 32
    end
    object LabelMessage: TLabel
      Left = 49
      Top = 16
      Width = 32
      Height = 32
      AutoSize = False
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 15899232
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
    end
    object ButtonTimer: TSpeedButton
      Left = 90
      Top = 16
      Width = 32
      Height = 32
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Flat = True
      Glyph.Data = {
        7A090000424D7A090000000000003204000028000000340000001A0000000100
        08000000000048050000C30E0000C30E0000FF000000FF00000000000000FFFF
        FF00FF00FF0088868700EDE9EA00E1DBDC007A71720085797A0079696A00826B
        6C007B656600D97C7B00917575008C727200977D7D00947A7A00917A7A009D85
        8500A28B8B00A58E8E00AA949400B09B9B00AE999900B3A0A000B7A5A500BDAC
        AC00C4B4B400CCBFBF00C8BBBB00C9BDBD00D6CCCC00DAD1D100E0D8D800DDD5
        D500E6DFDF00E4DDDD00E3DCDC00E7E1E100E5DFDF00EEE9E900EBE6E600EEEA
        EA00F0EDED00F6F4F400F4F2F200FEFDFD00FCFBFB00F8F7F700DC867F00A98F
        8D00D1C6C5009D7E7B00B6A2A000E0D7D600E8C9C500E4DCDB00AD938E00CF3E
        1D00BDA8A300DACAC600F2D2C900C4ACA500BC9E9500D6734E00A97C6C00E8BA
        A900CCBAB400B8887400EED9D000A86E5100A7867500CBB0A300E36F3000D4BA
        AB00E9976700CB9B7F00D4A48700BE957C00D5AC9400E9874800D5885600D996
        6800D89D7700E3AB8400BD9B8500FAECE300EF965600F1A26500E6A77700F2B3
        8400F2B68B00F9E9DD00F3A66A00F2AA6F00F3AD7300F3B27A00B5865D00F5B8
        8100F5BB8600E4BA9500F6BF8B00F6C08C00F6C49200EBBB8C00F8C79500241D
        160016141200FDF5ED00F7C89700F9CC9C00F7CB9B00F9CFA100F9D0A300E7C3
        9B00D1C2B2007E6A5200FAD4A600F9D3A600FAD5A900F5D1A600FAD7AC00D2B5
        91005B4E3F00FBD9AF00F6D4AC00E9CAA400E2D9CE00F1EAE2006A5B4800FBDB
        B100FBDDB500FCE6CA00FCDFB500FCE0B600FCE2BB005F554500FBE1B900FDE4
        BC00FCE5BF00EAD7B900EAE1D300FDE6BF00FAE4BE00FDE7C100FDE9C300FEEB
        C500FDEBC80091866F00B3A68A00FEECC700FAEAC600FEEDCA00FEEFCD00FFF1
        D200FFF3D800FFF6E300FFF8E900FFF1CE00FFF1D000FDF0D000FFF2D400FDF0
        D200FDF1D400FFF3D700FDF2D700FFF4DA00FDF2D800F7EDD400FDF3DB00FFF5
        DE00FDF4DF00FDF5E100FFF7E400FEF9ED00FDFAF300FFF6DF00FDF4DD00FCF2
        D500FDF8E9000606050082828300FCFCFC00FBFBFB00F8F8F800F7F7F700F5F5
        F500F3F3F300F1F1F100EEEEEE00ECECEC00EBEBEB00E9E9E900E7E7E700E5E5
        E500E2E2E200E0E0E000DFDFDF00DCDCDC00DBDBDB00D8D8D800D6D6D600D5D5
        D500D2D2D200D1D1D100CECECE00CDCDCD00CACACA00C9C9C900C6C6C600C5C5
        C500C3C3C300C1C1C100BFBFBF00BDBDBD00BBBBBB00B8B8B800B7B7B700B4B4
        B400B2B2B200B1B1B100AEAEAE00ADADAD00ABABAB00A8A8A800A7A7A700A4A4
        A400A2A2A200A1A1A1009F9F9F009D9D9D009B9B9B0098989800979797009595
        950092929200909090008D8D8D008A8A8A008888880086868600858585007F7F
        7F007C7C7C007676760075757500686868006666660062626200595959005353
        53004D4D4D001D1D1D0015151500121212000505050002020202020202020307
        100E0E100D09060318020202020202020202020202020202E6F1F0EDEDF0F1F3
        F403D6020202020202020202020202020311171A1D1D1C1A1917120C08B41802
        02020202020202020202E6E1D8D5D2D2D3D5D9DFE8B4EEE8D602020202020202
        02020212191F1F1D1915141414161818130D0818020202020202020202E0D2C9
        C9D2DBE0E4E4E4E1DCDCE7F1EED60202020202020202151E371B34427E7F3644
        8C72381115160E0A1802020202020202DAC7C4D1DED3C7BFC8C4C4D3E5EAE1E1
        EDEED60202020202023424231972A79BAD6B0B41B2AAB18B4612150E0A180202
        020202D7C1C3DBD3C1BBB9B9DECDBABCBFCBEBE9E1EDEED6020202021528223A
        8B9DA69B9CAE5B559CB0A097885411160E1602020202DABEC2DBCBC0BEBBB9B7
        BFBCBABCBFC1C6E3EAE1EDDA0202020221043D7D8998A2A9AC9CAD9C9BA89995
        82704D11140D16020202C4BED9D0C5C1BFBCBBB9B9BABBBDBFC2C7CCE5EAE4E9
        DA02021CBA1B637082919FA4B0ABABABA8A2988A7B6D64401413120202CEB9D1
        D5CCC7C2C0BEBCBCBCBCBDBFC1C5C9CED3EDE4E7DF020228284E646E78869299
        A09AA6A3A0989084756862580F15121602BEBFDAD3CFCAC6C2BFBFBEBEBEBFC1
        C3C7CCD0D5DC03E0DFDA1A2F325861666F7B8691989D9F9D978F85766E655F5C
        40161203CFB7CDDCD6D1CDC9C6C2C1C0C0C0C1C4C7CBCFD3D8DCEDE1E9031E2F
        475C5F62686F7884898D8A8D8681746D65615E5750121512CAB8D8DCD9D5D0CD
        CAC7C5C4C4C4C6C8CBCED3D6D9DEE9E8E1E8262A4C5C5C5F62666E6F6F937379
        71716767615E57564F331812C2BCDEDCDCD8D5D2CFCCCDB4F5DBD3D3D6D6D6D9
        DEE2E7ECDCE82904514A4A5F5F61646646F9F96A696969605E57564848401912
        BDBEE2DFDFD8D8D6D3D1EEF9F9FCFBFBFBEDD9DEE2EBEBEDD9E82A28513F3F68
        6C65616145F9F66A8073735157564F3948401912BCBFE4E6ECD0D0D3D6D6F2F9
        F7FDF8F5F5E2DEE2E7F3EFEDD8E8290451595A6F74787B7B7C9387B37A71776F
        665D4F4848461912BDBEE4D6D4CDCBCAC9C9CBB4F9FEFAD3CDCDD1DBE7EFEFEB
        D8E8252B52647076818488898D8F8E93B38771766F6E645648311A12C1B9E0D3
        CCCBC8C7C6C5C4C4C5F2FEF9D3CBCDCFD3E2EFE6D5E81F2E495D7881888A9095
        979797969300877D7C6F6E643F181A1EC5B5D4DBCAC8C6C5C3C2C2C2C2C3F200
        F9D0CBCDCFD3ECDCD6CA022E054A81869097989E9999A19E9D93B3807C766F5E
        401B1A3202B5C4DFC8C6C3C2C1C0BFBFC0C0C0F1FEF8CBCBCDD9EDD1D1C90227
        B74C688F979EA2A3A5A5A6A3A09F9394887B705034321A0202BCB7DCD0C4C1C0
        BFBEBDBDBEBEBFC1B4E4C6C9CCE9DECCD10202022E37528A9FA2A6B0AAAAAAB0
        A6A29F928A815F431E1E22020202B5C4E0C4C0BFBEBCBCBCBCBCBEBFC0C2C5C7
        D8E8CCC7C0020202232D3B5898A5AAAC9C9C55AAAFA6A09D906643321E220202
        0202C12DCBDCC0BDBCBBBABABDBCBCBEBFC0C3D2EACDC7C002020202022AB63B
        53839B9CAD6B30419BB0A3986743322022020202020202BBB6CBD9C2BBB9B8B9
        DDCDBBBCBEC1D6E8CFC2C0020202020202022A2E204E715BAEAE413CACAA7C52
        3E2125220202020202020202BBB5C5DAD3BDB7B7CDC5BABCCBE0DFC7BFC00202
        02020202020202222D2B1F4E4E4141414E4B3D1E292322020202020202020202
        02C02DB8C9DAD8D1D1D1D8E1D9CABCC1C00202020202020202020202022A2EB6
        2A22353526292C27220202020202020202020202020202BBB5B6BCC2C6C6C2BD
        B9BCC00202020202020202020202020202020221282C2B2C2821270202020202
        02020202020202020202020202C4BFBAB9BABFC7BC020202020202020202}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = ButtonTimerClick
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 67
    Top = 8
  end
end
