object Form1: TForm1
  Left = 192
  Top = 103
  Width = 269
  Height = 233
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VirtualPropertyTree1: TVirtualPropertyTree
    Left = 0
    Top = 0
    Width = 261
    Height = 206
    Align = alClient
    BorderStyle = bsSingle
    Colors.GridLineColor = clSilver
    DefaultNodeHeight = 16
    EditDelay = 0
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDblClickResize, hoDrag]
    Header.Style = hsThickButtons
    HintAnimation = hatNone
    HintMode = hmDefault
    IncrementalSearchDirection = sdForward
    Indent = 0
    LineStyle = lsSolid
    Margin = 16
    NodeDataSize = 28
    TabOrder = 0
    TextMargin = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toPopupMode, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    Columns = <
      item
        Position = 0
        Width = 80
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
        Position = 1
        Width = 177
      end>
  end
end
