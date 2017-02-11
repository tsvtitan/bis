object ObjListForm: TObjListForm
  Left = 346
  Top = 158
  Width = 562
  Height = 410
  Caption = 'List of objects'
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
    Top = 304
    Width = 554
    Height = 72
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Show properties'
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 136
      Top = 8
      Width = 137
      Height = 25
      Caption = 'Mark/unmark selected'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Mark All'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 368
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Unmark All'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 456
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Get Object'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 136
      Top = 40
      Width = 137
      Height = 25
      Caption = 'Set Visibility selected:'
      TabOrder = 5
      OnClick = Button6Click
    end
    object Edit1: TEdit
      Left = 288
      Top = 40
      Width = 153
      Height = 21
      TabOrder = 6
    end
    object Button7: TButton
      Left = 8
      Top = 40
      Width = 113
      Height = 25
      Caption = 'Get Object Table'
      TabOrder = 7
      OnClick = Button7Click
    end
  end
  object List: TListView
    Left = 0
    Top = 0
    Width = 554
    Height = 304
    Align = alClient
    Columns = <
      item
        Caption = 'ID'
        Width = 40
      end
      item
        Caption = 'Type'
        Width = 80
      end
      item
        Caption = 'Code'
        Width = 150
      end
      item
        Caption = 'Text'
        Width = 250
      end>
    ColumnClick = False
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = Button1Click
  end
end
