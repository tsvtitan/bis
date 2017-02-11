object frmEditorConfirmReplace: TfrmEditorConfirmReplace
  Left = 176
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Confirm replace'
  ClientHeight = 98
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblConfirmation: TLabel
    Left = 60
    Top = 12
    Width = 261
    Height = 44
    AutoSize = False
    WordWrap = True
  end
  object ImageIcon: TImage
    Left = 16
    Top = 16
    Width = 32
    Height = 32
  end
  object btnReplace: TButton
    Left = 8
    Top = 64
    Width = 65
    Height = 23
    Caption = '&Yes'
    Default = True
    ModalResult = 6
    TabOrder = 0
  end
  object btnSkip: TButton
    Left = 80
    Top = 64
    Width = 65
    Height = 23
    Caption = '&No'
    ModalResult = 7
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 152
    Top = 64
    Width = 65
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnReplaceAll: TButton
    Left = 224
    Top = 64
    Width = 97
    Height = 23
    Caption = 'Yes to &all'
    ModalResult = 10
    TabOrder = 3
  end
end
