object DbForm: TDbForm
  Left = 192
  Top = 114
  Width = 456
  Height = 496
  BorderIcons = [biSystemMenu]
  BorderWidth = 6
  Caption = 'Select database to load'
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
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 436
    Height = 16
    Align = alTop
    AutoSize = False
    Caption = '  Databases available for loaded maps:'
    ShowAccelChar = False
  end
  object Comment: TLabel
    Left = 0
    Top = 193
    Width = 436
    Height = 29
    Align = alTop
    AutoSize = False
    WordWrap = True
  end
  object List: TListBox
    Left = 0
    Top = 16
    Width = 436
    Height = 177
    Align = alTop
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListClick
    OnDblClick = OkBtnClick
  end
  object Style: TMemo
    Left = 0
    Top = 252
    Width = 436
    Height = 165
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 222
    Width = 436
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label3: TLabel
      Left = 0
      Top = 9
      Width = 40
      Height = 13
      Caption = 'DBF file:'
    end
    object Button1: TButton
      Left = 407
      Top = 6
      Width = 25
      Height = 22
      Caption = '...'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Filename: TEdit
      Left = 48
      Top = 6
      Width = 352
      Height = 21
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 417
    Width = 436
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Panel3: TPanel
      Left = 236
      Top = 0
      Width = 200
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object OkBtn: TButton
        Left = 33
        Top = 8
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = OkBtnClick
      end
      object Button3: TButton
        Left = 124
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.bmp'
    Filter = 'DBF files|*.dbf|All files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 360
    Top = 184
  end
end
