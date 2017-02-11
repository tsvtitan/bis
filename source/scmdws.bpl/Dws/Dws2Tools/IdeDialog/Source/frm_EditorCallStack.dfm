object frmEditorCallStack: TfrmEditorCallStack
  Left = 415
  Top = 242
  Width = 401
  Height = 284
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Call stack'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox: TListBox
    Left = 0
    Top = 0
    Width = 393
    Height = 257
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = ListBoxDblClick
  end
end
