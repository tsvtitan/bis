object FrmDebugger: TFrmDebugger
  Left = 253
  Top = 132
  Width = 679
  Height = 502
  Caption = 'RegExp Debugger'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object gbExpression: TGroupBox
    Left = 0
    Top = 0
    Width = 671
    Height = 129
    Align = alTop
    Caption = ' Expression '
    TabOrder = 0
    DesignSize = (
      671
      129)
    object LblErrorPos: TLabel
      Left = 20
      Top = 74
      Width = 9
      Height = 17
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblError: TLabel
      Left = 20
      Top = 91
      Width = 3
      Height = 16
    end
    object EdtExpr: TLabeledEdit
      Left = 16
      Top = 40
      Width = 641
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 133
      EditLabel.Height = 16
      EditLabel.Caption = 'Debugger expression:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '[0-9]+'
    end
    object BtnValider: TButton
      Left = 512
      Top = 87
      Width = 145
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Validate'
      TabOrder = 1
      OnClick = BtnValiderClick
    end
    object EdtModifiers: TLabeledEdit
      Left = 16
      Top = 88
      Width = 489
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 79
      EditLabel.Height = 16
      EditLabel.Caption = 'Modificators :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'rsg-imx'
    end
  end
  object gbText: TGroupBox
    Left = 0
    Top = 129
    Width = 671
    Height = 326
    Align = alClient
    Caption = ' Text '
    TabOrder = 1
    object Splitter: TSplitter
      Left = 2
      Top = 169
      Width = 667
      Height = 4
      Cursor = crVSplit
      Align = alTop
    end
    object REdit: TRichEdit
      Left = 2
      Top = 18
      Width = 667
      Height = 151
      Align = alTop
      Lines.Strings = (
        'Tapez ici le texte d'#39'entree.'
        'Double cliquez pour ouvir un fichier texte')
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object MatchTree: TTreeView
      Left = 2
      Top = 173
      Width = 667
      Height = 151
      Align = alClient
      Indent = 19
      TabOrder = 1
    end
  end
  object SB: TStatusBar
    Left = 0
    Top = 455
    Width = 671
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object OD: TOpenDialog
    Left = 192
    Top = 241
  end
end
