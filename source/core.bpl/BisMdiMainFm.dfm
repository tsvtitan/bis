inherited BisMdiMainForm: TBisMdiMainForm
  Left = 404
  Top = 160
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ClientHeight = 553
  ClientWidth = 772
  Color = clWindow
  Constraints.MinHeight = 580
  Constraints.MinWidth = 780
  Enabled = False
  FormStyle = fsMDIForm
  OldCreateOrder = True
  PopupMode = pmExplicit
  OnClose = FormClose
  OnResize = FormResize
  ExplicitWidth = 788
  ExplicitHeight = 591
  DesignSize = (
    772
    553)
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar [0]
    Left = 0
    Top = 534
    Width = 772
    Height = 19
    Panels = <
      item
        Width = 250
      end
      item
        Width = 300
      end
      item
        Width = 250
      end
      item
        Width = 100
      end>
    OnResize = StatusBarResize
  end
  object PanelLogo: TPanel [1]
    Left = 300
    Top = 338
    Width = 250
    Height = 70
    Anchors = [akRight, akBottom]
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    Visible = False
    object ImageLogo: TImage
      Left = 0
      Top = 0
      Width = 250
      Height = 70
      Cursor = crHandPoint
      Hint = #1057#1072#1081#1090' '#1082#1086#1084#1087#1072#1085#1080#1080' NextSoft'
      Align = alClient
      AutoSize = True
      Center = True
      Constraints.MaxHeight = 70
      Constraints.MaxWidth = 250
      Constraints.MinHeight = 70
      Constraints.MinWidth = 250
      ParentShowHint = False
      ShowHint = True
      OnClick = ImageLogoClick
      ExplicitLeft = -24
    end
  end
  object PanelContent: TPanel [2]
    Left = 344
    Top = 176
    Width = 297
    Height = 97
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object WebBrowser: TWebBrowser
      Left = 0
      Top = 0
      Width = 297
      Height = 97
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 6
      ExplicitWidth = 300
      ExplicitHeight = 150
      ControlData = {
        4C000000B21E0000060A00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126200000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object ActionMainMenuBar: TActionMainMenuBar [3]
    Left = 0
    Top = 0
    Width = 772
    Height = 25
    UseSystemFont = False
    Caption = 'ActionMainMenuBar'
    ColorMap.HighlightColor = 15921906
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 15921906
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    PersistentHotKeys = True
    Spacing = 0
    OnDockOver = ActionMainMenuBarDockOver
  end
  object PanelProgress: TPanel [4]
    Left = 280
    Top = 448
    Width = 225
    Height = 20
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 4
    Visible = False
    object ButtonInterrupt: TSpeedButton
      AlignWithMargins = True
      Left = 204
      Top = 1
      Width = 18
      Height = 18
      Margins.Left = 0
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alRight
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FFFF
        FFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF00
        00FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF00
        00FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFF0000FF0000FF0000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FFFFFFFFFF
        FFFFFFFFFFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Visible = False
      OnClick = ButtonInterruptClick
      OnMouseEnter = ButtonInterruptMouseEnter
      OnMouseLeave = ButtonInterruptMouseLeave
      ExplicitLeft = 201
    end
    object ProgressBar: TProgressBar
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 198
      Height = 14
      Align = alClient
      TabOrder = 0
    end
  end
  object ImageListMenu: TImageList [5]
    Left = 112
    Top = 224
  end
  object ApplicationEvents: TApplicationEvents [6]
    OnHint = ApplicationEventsHint
    Left = 104
    Top = 288
  end
  inherited TrayIcon: TTrayIcon
    Left = 24
    Top = 88
  end
  inherited ImageList: TImageList
    Left = 88
    Top = 88
  end
  inherited PopupActionBar: TPopupActionBar
    Left = 168
    Top = 88
  end
end
