object Form1: TForm1
  Left = 261
  Top = 182
  Width = 610
  Height = 453
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object VirtualButtonTree1: TVirtualButtonTree
    Left = 8
    Top = 8
    Width = 497
    Height = 369
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Shell Dlg 2'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    RootNodeCount = 200
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toExtendedFocus]
    OnGetButtonInfo = VirtualButtonTree1GetButtonInfo
    OnButtonClick = VirtualButtonTree1ButtonClick
    Columns = <
      item
        Position = 0
        Width = 100
        WideText = 'Column 1'
      end
      item
        Position = 1
        Width = 250
        WideText = 'Column 2'
      end
      item
        Position = 2
        Width = 100
        WideText = 'Column 3'
      end>
  end
end
