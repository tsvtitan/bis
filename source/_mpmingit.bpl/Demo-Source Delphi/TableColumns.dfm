object TableColumnForm: TTableColumnForm
  Left = 192
  Top = 114
  Width = 508
  Height = 272
  BorderIcons = [biSystemMenu]
  BorderWidth = 6
  Caption = 'Edit Table Columns'
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
  object List: TListView
    Left = 0
    Top = 0
    Width = 315
    Height = 226
    Align = alClient
    Columns = <
      item
        Caption = 'Type'
        Width = 60
      end
      item
        Caption = 'Name'
        Width = 80
      end
      item
        Caption = 'Description'
        Width = 120
      end
      item
        Caption = 'Index'
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = ListSelectItem
  end
  object Panel1: TPanel
    Left = 315
    Top = 0
    Width = 173
    Height = 226
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 0
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object Label3: TLabel
      Left = 8
      Top = 88
      Width = 48
      Height = 13
      Caption = 'Decription'
    end
    object Button1: TButton
      Left = 8
      Top = 192
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 96
      Top = 192
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object TypeCombo: TComboBox
      Left = 8
      Top = 16
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = TypeComboChange
      Items.Strings = (
        'TEXT'
        'INTEGER'
        'DOUBLE')
    end
    object NameEdit: TEdit
      Left = 8
      Top = 64
      Width = 161
      Height = 21
      TabOrder = 3
      OnChange = NameEditChange
    end
    object DescrEdit: TEdit
      Left = 8
      Top = 104
      Width = 161
      Height = 21
      TabOrder = 4
      OnChange = DescrEditChange
    end
    object AddBtn: TButton
      Left = 8
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 5
      OnClick = AddBtnClick
    end
    object DeleteBtn: TButton
      Left = 96
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 6
      OnClick = DeleteBtnClick
    end
  end
end
