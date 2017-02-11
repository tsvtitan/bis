object BrowserForm: TBrowserForm
  Left = 333
  Top = 125
  Width = 600
  Height = 440
  Caption = 'DWS Browser'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object BrowseBut: TButton
      Left = 7
      Top = 7
      Width = 60
      Height = 20
      Caption = '&Browse'
      TabOrder = 0
      OnClick = BrowseButClick
    end
    object BackBut: TButton
      Left = 78
      Top = 7
      Width = 61
      Height = 20
      Caption = 'B&ack'
      TabOrder = 1
      OnClick = BackButClick
    end
    object HomeBut: TButton
      Left = 150
      Top = 7
      Width = 60
      Height = 20
      Caption = '&Home'
      TabOrder = 2
    end
  end
  object SymList: TListView
    Left = 0
    Top = 33
    Width = 592
    Height = 380
    Align = alClient
    Columns = <
      item
        Caption = 'Type'
        Width = 81
      end
      item
        Caption = '#'
        Width = 33
      end
      item
        Caption = 'Symbol'
        Width = 341
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = SymListDblClick
  end
end
