object frmFormMain: TfrmFormMain
  Left = 290
  Top = 300
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FormMain'
  ClientHeight = 165
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  Version = 10
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 16
    Top = 8
    Width = 129
    Height = 25
    Caption = 'Form1'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 16
    Top = 40
    Width = 129
    Height = 25
    Caption = 'Form2'
    TabOrder = 1
    OnClick = BitBtn2Click
  end
end
