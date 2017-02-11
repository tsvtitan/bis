object RecvDlg: TRecvDlg
  Left = 744
  Top = 605
  ActiveControl = PortEdit
  Caption = 'Receive stream'
  ClientHeight = 763
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    848
    763)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 696
    Width = 60
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Port:'
  end
  object Label2: TLabel
    Left = 24
    Top = 8
    Width = 33
    Height = 13
    Caption = 'Drivers'
  end
  object Label3: TLabel
    Left = 23
    Top = 341
    Width = 37
    Height = 13
    Caption = 'Formats'
  end
  object Label4: TLabel
    Left = 360
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label5: TLabel
    Left = 376
    Top = 696
    Width = 34
    Height = 13
    Caption = 'Device'
  end
  object Button1: TButton
    Left = 16
    Top = 720
    Width = 75
    Height = 25
    Caption = 'Start'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 96
    Top = 720
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PortEdit: TEdit
    Left = 78
    Top = 693
    Width = 275
    Height = 21
    TabOrder = 2
    Text = '10000'
  end
  object ListBoxDrivers: TListBox
    Left = 24
    Top = 27
    Width = 321
    Height = 302
    ItemHeight = 13
    TabOrder = 3
    OnClick = ListBoxDriversClick
  end
  object ListBoxFormats: TListBox
    Left = 24
    Top = 360
    Width = 801
    Height = 297
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 4
  end
  object MemoDetails: TMemo
    Left = 360
    Top = 27
    Width = 465
    Height = 327
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 5
    WordWrap = False
  end
  object ComboBoxDevices: TComboBox
    Left = 416
    Top = 693
    Width = 369
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 6
  end
end
