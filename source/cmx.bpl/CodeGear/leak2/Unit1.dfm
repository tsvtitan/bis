object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = ButtonRunStop
  Caption = 'Test memory leaks'
  ClientHeight = 449
  ClientWidth = 647
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    647
    449)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelDatabase: TLabel
    Left = 16
    Top = 16
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = 'Database:'
  end
  object ShapeSqlStoredProc: TShape
    Left = 9
    Top = 45
    Width = 19
    Height = 19
    Brush.Color = clBlue
  end
  object ShapeSqlQuery: TShape
    Left = 9
    Top = 76
    Width = 19
    Height = 19
    Brush.Color = clRed
  end
  object ShapeIbStoredProc: TShape
    Left = 9
    Top = 107
    Width = 19
    Height = 19
    Brush.Color = 4210816
  end
  object ShapeIbQuery: TShape
    Left = 9
    Top = 138
    Width = 19
    Height = 19
    Brush.Color = clGreen
  end
  object ButtonSqlStoredProc: TButton
    Left = 32
    Top = 42
    Width = 607
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SQL Stored Proc'
    TabOrder = 2
    OnClick = ButtonSqlStoredProcClick
  end
  object ButtonIbStoredProc: TButton
    Left = 32
    Top = 104
    Width = 607
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'IB Stored Proc'
    TabOrder = 4
    OnClick = ButtonIbStoredProcClick
  end
  object ButtonRunStop: TButton
    Left = 555
    Top = 179
    Width = 84
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Run / Stop'
    Default = True
    TabOrder = 10
    OnClick = ButtonRunStopClick
    ExplicitLeft = 440
  end
  object GroupBoxLeaksLog: TGroupBox
    Left = 8
    Top = 210
    Width = 273
    Height = 231
    Anchors = [akLeft, akTop, akBottom]
    Caption = ' Leaks log'
    TabOrder = 11
    ExplicitHeight = 139
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 259
      Height = 209
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
      ExplicitHeight = 117
    end
  end
  object ButtonSqlQuery: TButton
    Left = 32
    Top = 73
    Width = 607
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SQL Query'
    TabOrder = 3
    OnClick = ButtonSqlQueryClick
  end
  object ButtonIbQuery: TButton
    Left = 32
    Top = 135
    Width = 607
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'IB Query'
    TabOrder = 5
    OnClick = ButtonIbQueryClick
  end
  object RadioButtonSelect: TRadioButton
    Left = 15
    Top = 183
    Width = 73
    Height = 17
    Caption = 'SELECT'
    Checked = True
    TabOrder = 6
    TabStop = True
  end
  object RadioButtonInsert: TRadioButton
    Left = 120
    Top = 183
    Width = 73
    Height = 17
    Caption = 'INSERT'
    TabOrder = 7
  end
  object RadioButtonUpdate: TRadioButton
    Left = 216
    Top = 183
    Width = 73
    Height = 17
    Caption = 'UPDATE'
    TabOrder = 8
  end
  object RadioButtonDelete: TRadioButton
    Left = 312
    Top = 183
    Width = 73
    Height = 17
    Caption = 'DELETE'
    TabOrder = 9
  end
  object EditDatabase: TEdit
    Left = 72
    Top = 13
    Width = 362
    Height = 21
    TabOrder = 0
  end
  object ButtonDatabase: TButton
    Left = 440
    Top = 11
    Width = 75
    Height = 25
    Hint = 'Select database file'
    Caption = 'Select'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = ButtonDatabaseClick
  end
  object Chart1: TChart
    Left = 287
    Top = 210
    Width = 352
    Height = 231
    Legend.Visible = False
    Title.AdjustFrame = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BottomAxis.Title.Caption = 'Execute (count)'
    LeftAxis.Title.Caption = 'Memory (Byte)'
    View3D = False
    Zoom.Animated = True
    BevelOuter = bvLowered
    Color = clWindow
    TabOrder = 12
    Anchors = [akLeft, akTop, akRight, akBottom]
    ExplicitWidth = 237
    ExplicitHeight = 139
    object Series1: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = 4210816
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series4: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 80
    Top = 232
  end
  object OpenDialog1: TOpenDialog
    Left = 192
    Top = 256
  end
end
