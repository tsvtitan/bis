object AccountsFrm: TAccountsFrm
  Left = 0
  Top = 0
  Width = 309
  Height = 337
  TabOrder = 0
  object AccountList: TListView
    Left = 8
    Top = 8
    Width = 273
    Height = 249
    Columns = <
      item
        Caption = 'Domain'
        Width = 130
      end
      item
        Caption = 'User name'
        Width = 120
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 8
    Top = 267
    Width = 73
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Button2: TButton
    Left = 85
    Top = 267
    Width = 57
    Height = 25
    TabOrder = 2
  end
  object Button3: TButton
    Left = 149
    Top = 267
    Width = 57
    Height = 25
    TabOrder = 3
  end
  object Button5: TButton
    Left = 213
    Top = 267
    Width = 57
    Height = 25
    TabOrder = 4
  end
end
