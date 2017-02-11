object SelectMapForm: TSelectMapForm
  Left = 192
  Top = 114
  Width = 488
  Height = 213
  BorderWidth = 6
  Caption = 'Select map'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object List: TListView
    Left = 0
    Top = 0
    Width = 385
    Height = 167
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Filename'
        Width = 250
      end>
    ColumnClick = False
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = Button1Click
  end
  object Panel1: TPanel
    Left = 385
    Top = 0
    Width = 83
    Height = 167
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 8
      Top = 0
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 32
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
