inherited BisTaxiOrdersForm: TBisTaxiOrdersForm
  Left = 485
  Top = 245
  Caption = #1047#1072#1082#1072#1079#1099
  ClientHeight = 453
  ClientWidth = 752
  Constraints.MinHeight = 480
  Constraints.MinWidth = 760
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    000000000000000000000000000000000000CDAD99FFC49E86FFB88564FFB883
    62FFB88362FFB88362FFB88362FFB88362FFB88362FFB78666FFC8A58FFF0000
    000000000000000000000000000000000000B17B5AFFEFECEAFFF7F0ECFFF8F1
    ECFFF7F1ECFFF7F0ECFFF7F0EBFFF7F0EBFFF8F0EBFFF2EEE9FFB88766FF0000
    000000000000000000000000000000000000AB6D44FFF6F0ECFFEDD7C4FFF3DB
    C7FFF3DBC7FFF3DBC7FFF3DBC7FFF3DBC7FFEED7C4FFF5E9E0FFB78360FF0000
    000000000000000000000000000000000000AB6D44FFF7F0EBFF866644FFB387
    5BFFB3875BFFB3875BFFB3875BFFB3875BFF8B6A47FFE8DBD0FFB78361FF0000
    0000CDAD99FFC49E86FFB88564FFB88362FFAD6F45FFF7F0EBFFAC8258FFE5AD
    75FFE5AD75FFE5AD75FFE5AD75FFE5AD75FFB3875BFFECDFD3FFB78462FF0000
    0000B17B5AFFEFECEAFFF7F0ECFFF8F1ECFFAD6F47FFF7F2EDFFA67F56FFDEAA
    73FFDDA973FFDDA873FFDCA772FFDCA772FFAB8258FFEBDFD3FFB78462FF0000
    0000AB6D44FFF6F0ECFFEDD7C4FFF3DBC7FFAD6F47FFF7F3EEFF9C966EFFE6C7
    9DFFDFC496FFC8BD88FFE4BA82FFD5C096FFAA9E7EFFEBE2D8FFB78462FF0000
    0000AB6D44FFF7F0EBFF866644FFB3875BFFAD6F47FFF7F4EFFFB6A583FFF5DD
    B0FFF4DDAFFFF1DCADFFF3DAABFFEFD9ADFFBBAB89FFECE4D9FFB78562FF0000
    0000AD6F45FFF7F0EBFFAC8258FFE5AD75FFAD6F47FFF7F4F3FFB6A481FFF2DC
    ADFFF2DDAFFFF6DEAFFFF7DFAFFFFBE2B3FFC5B28DFFEFE6DCFFB88563FF0000
    0000AD6F47FFF7F2EDFFA67F56FFDEAA73FFAD7651FFF3F2F1FF96815CFFA69E
    76FFABA07AFFBAA27AFFBAA37CFFBBA782FF948568FFEAE2D9FFB88563FF0000
    0000AD6F47FFF7F3EEFF9C966EFFE6C79DFFB28566FFDFDFDDFFF3F3F2FFF7F4
    F3FFF7F4F1FFF7F4EFFFF8F4EFFFF8F2EBFFF7F2EBFFF1EEE8FFB88767FF0000
    0000AD6F47FFF7F4EFFFB6A583FFF5DDB0FFD0B6A4FFB38367FFAD7651FFAD6F
    45FFAD6F45FFAD6F45FFAD6F45FFAD6D45FFAD6D45FFAD734CFFCAA994FF0000
    0000AD6F47FFF7F4F3FFB6A481FFF2DCADFFF2DDAFFFF6DEAFFFF7DFAFFFFBE2
    B3FFC5B28DFFEFE6DCFFB88563FF000000000000000000000000000000000000
    0000AD7651FFF3F2F1FF96815CFFA69E76FFABA07AFFBAA27AFFBAA37CFFBBA7
    82FF948568FFEAE2D9FFB88563FF000000000000000000000000000000000000
    0000B28566FFDFDFDDFFF3F3F2FFF7F4F3FFF7F4F1FFF7F4EFFFF8F4EFFFF8F2
    EBFFF7F2EBFFF1EEE8FFB88767FF000000000000000000000000000000000000
    0000D0B6A4FFB38367FFAD7651FFAD6F45FFAD6F45FFAD6F45FFAD6F45FFAD6D
    45FFAD6D45FFAD734CFFCAA994FF00000000000000000000000000000000FFFF
    0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
    0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000}
  ExplicitWidth = 768
  ExplicitHeight = 491
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 434
    Width = 752
    Height = 19
    Panels = <>
  end
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 752
    Height = 434
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object SplitterOrders: TSplitter
      Left = 447
      Top = 0
      Width = 5
      Height = 434
      Align = alRight
      MinSize = 310
      ExplicitLeft = 469
      ExplicitTop = 1
      ExplicitHeight = 295
    end
    object PanelOrders: TPanel
      Left = 0
      Top = 0
      Width = 447
      Height = 434
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object PanelBottom: TPanel
        Left = 0
        Top = 409
        Width = 447
        Height = 25
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        Visible = False
      end
    end
    object PanelRight: TPanel
      Left = 452
      Top = 0
      Width = 300
      Height = 434
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      OnResize = PanelRightResize
      object SplitterDriverShifts: TSplitter
        Left = 0
        Top = 201
        Width = 300
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        MinSize = 200
        ExplicitTop = 196
      end
      object PanelDriverShifts: TPanel
        Left = 0
        Top = 0
        Width = 300
        Height = 201
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
      end
      object PanelDriverParks: TPanel
        Left = 0
        Top = 206
        Width = 300
        Height = 228
        Align = alBottom
        BevelOuter = bvNone
        Constraints.MinHeight = 200
        TabOrder = 1
      end
    end
  end
end
