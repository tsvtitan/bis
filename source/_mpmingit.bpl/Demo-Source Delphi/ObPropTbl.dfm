object ObjPropTable: TObjPropTable
  Left = 520
  Top = 304
  Width = 362
  Height = 421
  Caption = 'Object Properties Table'
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
    Width = 354
    Height = 357
    Align = alClient
    Columns = <
      item
        Caption = 'Property'
        Width = 150
      end
      item
        Caption = 'Value'
        Width = 150
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 357
    Width = 354
    Height = 30
    Align = alBottom
    TabOrder = 1
    object CheckBox1: TCheckBox
      Left = 8
      Top = 8
      Width = 57
      Height = 17
      Caption = 'Visible'
      TabOrder = 0
      OnClick = visChange
    end
    object CheckBox2: TCheckBox
      Left = 88
      Top = 8
      Width = 81
      Height = 17
      Caption = 'Marked'
      TabOrder = 1
      OnClick = visChange
    end
    object CheckBox3: TCheckBox
      Left = 168
      Top = 8
      Width = 81
      Height = 17
      Caption = 'Contoured'
      TabOrder = 2
      OnClick = visChange
    end
    object CheckBox4: TCheckBox
      Left = 248
      Top = 8
      Width = 73
      Height = 17
      Caption = 'Twinkling'
      TabOrder = 3
      OnClick = visChange
    end
  end
end
