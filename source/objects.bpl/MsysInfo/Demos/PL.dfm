object frmPerfLib: TfrmPerfLib
  Left = 282
  Top = 335
  Width = 528
  Height = 406
  BorderStyle = bsSizeToolWin
  Caption = 'Performance Counters'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 255
    Top = 0
    Width = 3
    Height = 360
    Cursor = crHSplit
  end
  object Panel1: TPanel
    Left = 258
    Top = 0
    Width = 262
    Height = 360
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' '
    TabOrder = 0
    object Box: TListBox
      Left = 6
      Top = 24
      Width = 250
      Height = 330
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 0
    end
    object Panel6: TPanel
      Left = 6
      Top = 6
      Width = 250
      Height = 18
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Instances and Values'
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 255
    Height = 360
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' '
    TabOrder = 1
    object Tree: TTreeView
      Left = 6
      Top = 24
      Width = 243
      Height = 330
      Align = alClient
      BorderStyle = bsNone
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChange = TreeChange
      OnDblClick = TreeDblClick
    end
    object Panel4: TPanel
      Left = 6
      Top = 6
      Width = 243
      Height = 18
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Counters'
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object sb: TStatusBar
    Left = 0
    Top = 360
    Width = 520
    Height = 19
    Panels = <
      item
        Text = 'Performance Statistics for Win9x'
        Width = 50
      end>
    SimplePanel = False
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 116
    Top = 110
  end
end
