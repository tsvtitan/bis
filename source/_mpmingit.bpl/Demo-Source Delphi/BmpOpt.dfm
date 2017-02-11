object BitmapOptForm: TBitmapOptForm
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Bitmap Options'
  ClientHeight = 200
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 224
    Top = 107
    Width = 42
    Height = 13
    Caption = 'Font size'
  end
  object Label8: TLabel
    Left = 8
    Top = 136
    Width = 48
    Height = 13
    Caption = 'File name:'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 121
    Caption = 'Coordinates'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 26
      Height = 13
      Caption = 'North'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'West'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 28
      Height = 13
      Caption = 'South'
    end
    object Label4: TLabel
      Left = 8
      Top = 96
      Width = 21
      Height = 13
      Caption = 'East'
    end
    object Edit1: TEdit
      Left = 40
      Top = 19
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 40
      Top = 43
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 40
      Top = 67
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 40
      Top = 91
      Width = 121
      Height = 21
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 192
    Top = 8
    Width = 177
    Height = 73
    Caption = 'Picture size'
    TabOrder = 1
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object Label6: TLabel
      Left = 8
      Top = 48
      Width = 31
      Height = 13
      Caption = 'Height'
    end
    object Edit5: TEdit
      Left = 48
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Edit6: TEdit
      Left = 48
      Top = 44
      Width = 121
      Height = 21
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 208
    Top = 168
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 296
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object Edit7: TEdit
    Left = 272
    Top = 104
    Width = 73
    Height = 21
    TabOrder = 2
    Text = '10'
  end
  object UpDown1: TUpDown
    Left = 345
    Top = 104
    Width = 21
    Height = 21
    Associate = Edit7
    Min = 2
    Max = 50
    Position = 10
    TabOrder = 3
  end
  object Edit8: TEdit
    Left = 72
    Top = 136
    Width = 265
    Height = 21
    TabOrder = 4
  end
  object Button3: TButton
    Left = 344
    Top = 136
    Width = 25
    Height = 22
    Caption = '...'
    TabOrder = 5
    OnClick = Button3Click
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.bmp'
    Filter = 'Bitmap files|*.bmp|All files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 80
    Top = 168
  end
end
