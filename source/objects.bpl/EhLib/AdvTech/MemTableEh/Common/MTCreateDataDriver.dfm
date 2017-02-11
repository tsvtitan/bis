object fMTCreateDataDriver: TfMTCreateDataDriver
  Left = 536
  Top = 249
  BorderStyle = bsDialog
  Caption = 'fMTCreateDataDriver'
  ClientHeight = 234
  ClientWidth = 332
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 6
    Width = 118
    Height = 13
    Caption = 'List of available dataset'#39's'
  end
  object Label2: TLabel
    Left = 180
    Top = 6
    Width = 132
    Height = 13
    Caption = 'List of availbale DataDrivers'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 195
    Width = 321
    Height = 2
  end
  object DataSetList: TListBox
    Left = 15
    Top = 24
    Width = 133
    Height = 160
    ItemHeight = 13
    TabOrder = 0
  end
  object DataDriversList: TListBox
    Left = 180
    Top = 24
    Width = 121
    Height = 163
    ItemHeight = 13
    Items.Strings = (
      'TDataSetDriverEh'
      'TSQLDataDriverEh'
      'TBDEDataDriverEh'
      'TDBXDataDriverEh'
      'TADODataDriverEh'
      'TIBXDataDriverEh')
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 170
    Top = 203
    Width = 75
    Height = 25
    Caption = 'Create'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 250
    Top = 203
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
