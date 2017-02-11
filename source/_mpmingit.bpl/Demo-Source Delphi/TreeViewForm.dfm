object TreeForm: TTreeForm
  Left = 261
  Top = 182
  Width = 547
  Height = 374
  Caption = 'Codifier'
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
  object Splitter1: TSplitter
    Left = 298
    Top = 0
    Width = 6
    Height = 338
    Align = alRight
  end
  object Panel1: TPanel
    Left = 304
    Top = 0
    Width = 227
    Height = 338
    Align = alRight
    TabOrder = 0
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 225
      Height = 16
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Attribute codes'
    end
    object AttrTree: TTreeView
      Left = 1
      Top = 17
      Width = 225
      Height = 320
      Align = alClient
      Indent = 19
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 298
    Height = 338
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 296
      Height = 16
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Object codes'
    end
    object ObjTree: TTreeView
      Left = 1
      Top = 17
      Width = 296
      Height = 320
      Align = alClient
      Indent = 19
      TabOrder = 0
    end
  end
end
