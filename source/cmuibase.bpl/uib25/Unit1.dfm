object WaitForm: TWaitForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Waiting'
  ClientHeight = 117
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 80
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = Button1Click
  end
end
