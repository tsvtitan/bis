object RouteVariants: TRouteVariants
  Left = 192
  Top = 114
  Width = 436
  Height = 325
  Caption = 'Route variants'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object List: TListView
    Left = 0
    Top = 0
    Width = 428
    Height = 291
    Align = alClient
    Columns = <
      item
        Caption = 'Variant'
        Width = 180
      end
      item
        Caption = 'Value'
        Width = 180
      end>
    ColumnClick = False
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
end
