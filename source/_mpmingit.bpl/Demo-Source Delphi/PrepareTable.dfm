object PrepareTableForm: TPrepareTableForm
  Left = 192
  Top = 114
  Width = 616
  Height = 398
  ActiveControl = List
  BorderIcons = [biSystemMenu]
  BorderWidth = 6
  Caption = 'PrepareTableForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Grid: TStringGrid
    Left = 0
    Top = 169
    Width = 596
    Height = 183
    Align = alClient
    ColCount = 2
    DefaultColWidth = 100
    DefaultRowHeight = 16
    RowCount = 4
    FixedRows = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goThumbTracking]
    TabOrder = 0
    OnSetEditText = GridSetEditText
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 596
    Height = 169
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 233
      Height = 169
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 155
        Height = 13
        Caption = 'Available tables for loaded maps:'
      end
      object Comment: TLabel
        Left = 0
        Top = 82
        Width = 225
        Height = 41
        AutoSize = False
        Caption = 'Multiline comment'
        WordWrap = True
      end
      object List: TListBox
        Left = 0
        Top = 16
        Width = 225
        Height = 60
        ItemHeight = 13
        TabOrder = 0
        OnClick = ListClick
        OnDblClick = OkBtnClick
      end
      object OkBtn: TButton
        Left = 0
        Top = 136
        Width = 65
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 1
        OnClick = OkBtnClick
      end
      object Button2: TButton
        Left = 152
        Top = 136
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 2
      end
      object ColumnsBtn: TButton
        Left = 72
        Top = 136
        Width = 75
        Height = 25
        Caption = 'Columns...'
        TabOrder = 3
        OnClick = ColumnsBtnClick
      end
    end
    object Panel3: TPanel
      Left = 233
      Top = 0
      Width = 363
      Height = 169
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 76
        Height = 13
        Caption = 'Load command:'
      end
      object Label3: TLabel
        Left = 0
        Top = 84
        Width = 26
        Height = 13
        Caption = 'Style:'
      end
      object LoadCmdMemo: TMemo
        Left = 0
        Top = 16
        Width = 361
        Height = 60
        Lines.Strings = (
          'line1'
          'line2'
          'line3'
          'line4'
          'line5')
        TabOrder = 0
      end
      object StyleMemo: TMemo
        Left = 0
        Top = 101
        Width = 361
        Height = 60
        Lines.Strings = (
          'line1'
          'line2'
          'line3'
          'line4'
          'line5')
        TabOrder = 1
      end
    end
  end
end
