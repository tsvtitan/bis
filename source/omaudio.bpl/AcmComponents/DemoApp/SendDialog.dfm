object SendDlg: TSendDlg
  Left = 963
  Top = 510
  ActiveControl = HostEdit
  Caption = 'Send stream'
  ClientHeight = 771
  ClientWidth = 840
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    840
    771)
  PixelsPerInch = 96
  TextHeight = 13
  object HostLbl: TLabel
    Left = 15
    Top = 680
    Width = 60
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Host:'
  end
  object Label1: TLabel
    Left = 15
    Top = 704
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
    Left = 240
    Top = 680
    Width = 34
    Height = 13
    Caption = 'Device'
  end
  object Button1: TButton
    Left = 62
    Top = 728
    Width = 75
    Height = 25
    Caption = 'Start'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 142
    Top = 728
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object HostEdit: TEdit
    Left = 83
    Top = 677
    Width = 134
    Height = 21
    TabOrder = 2
    Text = '127.0.0.1'
  end
  object PortEdit: TEdit
    Left = 83
    Top = 701
    Width = 134
    Height = 21
    TabOrder = 3
    Text = '10000'
  end
  object ListBoxDrivers: TListBox
    Left = 24
    Top = 27
    Width = 321
    Height = 302
    ItemHeight = 13
    TabOrder = 4
    OnClick = ListBoxDriversClick
  end
  object ListBoxFormats: TListBox
    Left = 24
    Top = 360
    Width = 799
    Height = 297
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 5
  end
  object MemoDetails: TMemo
    Left = 360
    Top = 27
    Width = 463
    Height = 327
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 6
    WordWrap = False
  end
  object ComboBoxDevices: TComboBox
    Left = 280
    Top = 677
    Width = 543
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 7
  end
end
