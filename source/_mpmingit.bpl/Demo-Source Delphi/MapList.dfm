object MapListForm: TMapListForm
  Left = 192
  Top = 114
  Width = 491
  Height = 309
  BorderWidth = 6
  Caption = 'Loaded maps, DB and tables'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 225
    Width = 463
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 0
      Top = 8
      Width = 121
      Height = 25
      Caption = 'Unload selected'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 136
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 1
    end
  end
  object List: TListView
    Left = 0
    Top = 0
    Width = 463
    Height = 225
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Description'
        Width = 150
      end
      item
        Caption = 'Scale'
        Width = 100
      end
      item
        Caption = 'Codifier'
        Width = 100
      end
      item
        Caption = 'Lookup'
        Width = 100
      end
      item
        Caption = 'Frame'
        Width = 200
      end>
    ColumnClick = False
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    SmallImages = ListImages
    TabOrder = 1
    ViewStyle = vsReport
  end
  object ListImages: TImageList
    Left = 280
    Top = 80
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800080808000C0C0C000C0C0C000808080008080800080808000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C000C0C0C000C0C0C0008080800080808000808080008080
      8000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000080000000000000FF0000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00C0C0C000C0C0C000808080008080800080808000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      000000FF000000800000008000000000000080000000FF000000800000000080
      0000008000000080000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C000C0C0C000C0C0C0008080800080808000808080008080
      8000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      00000080000000FF00000080000000000000FF00000080000000008000000080
      0000008000000080000000000000000000000000000000000000000000008080
      8000FFFFFF00C0C0C000C0C0C000808080008080800080808000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000FF00000080000000800000FF000000800000000080000000FF00000080
      0000008000000080000000800000000000000000000000000000000000008080
      8000C0C0C000C0C0C000C0C0C000C0C0C0008080800080808000808080008080
      8000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000800000FF000000FF000000FF000000FF000000008000000000000000FF
      0000008000000080000000800000000000000000000000000000000000008080
      8000FFFFFF00C0C0C000C0C0C000808080008080800080808000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000808080000000
      000080800000FF000000FF000000FF000000FF00000080000000008000000000
      000000FF000000FF000000800000000000000000000000000000000000008080
      8000FFFFFF0000FFFF00C0C0C000C0C0C0008080800080808000808080008080
      8000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF00000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000800000000080
      0000000000000000000000FF000000000000000000000000000000FFFF008080
      8000C0C0C00000FFFF00C0C0C0008080800000FFFF0080808000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00000080000000800000FF000000FF000000FF000000FF00000080000000FF00
      00000080000000000000000000000000000000000000000000000000000000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C000C0C0C000C0C0C0008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000080
      000000FF000000800000FF000000FF000000FF00000080000000FF0000008000
      0000FF0000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0000FFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000080
      00000000000000FF00000080000000800000FF0000000080000000800000FF00
      000080000000FF00000000000000000000000000000000FFFF0000FFFF0000FF
      FF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C000C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF000000000000FF0000008000000080000000800000008000000080
      0000FF0000008000000000000000000000000000000000000000000000008080
      8000FFFFFF0000FFFF00FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800080808000FFFFFF00FFFFFF0000FF000000800000008000000080
      00000080000000000000000000000000000000000000000000000000000000FF
      FF008080800000FFFF00C0C0C00000FFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000FFFF00808080008080800000FFFF0080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFF80700000000FC1FE00300000000
      F007E00100000000E003E00100000000D001E00100000000D001E00100000000
      D000E001000000009020E001000000008010E00100000000800CC00100000000
      C006E00100000000C005E00100000000C801800100000000E403E00100000000
      F007E00300000000FC1FD80F0000000000000000000000000000000000000000
      000000000000}
  end
end
