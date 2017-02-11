object ObjectForm: TObjectForm
  Left = 421
  Top = 139
  Caption = 'Object Properties'
  ClientHeight = 380
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 350
    Width = 358
    Height = 30
    Align = alBottom
    TabOrder = 0
    object CheckBox1: TCheckBox
      Left = 8
      Top = 8
      Width = 57
      Height = 17
      Caption = 'Visible'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 88
      Top = 6
      Width = 81
      Height = 17
      Caption = 'Marked'
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 168
      Top = 8
      Width = 81
      Height = 17
      Caption = 'Contoured'
      TabOrder = 2
      OnClick = CheckBox3Click
    end
    object CheckBox4: TCheckBox
      Left = 248
      Top = 8
      Width = 73
      Height = 17
      Caption = 'Twinkling'
      TabOrder = 3
      OnClick = CheckBox4Click
    end
  end
  object List: TListView
    Left = 0
    Top = 0
    Width = 358
    Height = 350
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
    TabOrder = 1
    ViewStyle = vsReport
  end
end
