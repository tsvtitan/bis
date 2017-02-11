object frmEditorCodeExplorer: TfrmEditorCodeExplorer
  Left = 679
  Top = 290
  Width = 293
  Height = 524
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Code Explorer'
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CodeExplorerTree: TXMLTreeView
    Left = 0
    Top = 0
    Width = 285
    Height = 497
    Align = alClient
    Indent = 19
    ReadOnly = True
    SortType = stText
    TabOrder = 0
    DescAttribute = 'description'
    NodeNameFormat = nnfDataOnly
  end
end
