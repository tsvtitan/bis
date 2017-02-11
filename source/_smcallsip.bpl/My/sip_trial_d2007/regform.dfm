object RegistrationForm: TRegistrationForm
  Left = 596
  Top = 242
  BorderStyle = bsDialog
  Caption = 'SIP account'
  ClientHeight = 278
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 49
    Height = 13
    Caption = 'SIP server'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label3: TLabel
    Left = 16
    Top = 80
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 26
    Height = 13
    Caption = 'Proxy'
  end
  object Button1: TButton
    Left = 16
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Save'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object ServerEdit: TEdit
    Left = 88
    Top = 16
    Width = 233
    Height = 21
    TabOrder = 1
  end
  object UserEdit: TEdit
    Left = 88
    Top = 48
    Width = 233
    Height = 21
    TabOrder = 2
  end
  object PasswordEdit: TEdit
    Left = 88
    Top = 80
    Width = 233
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object STUNEdit: TEdit
    Left = 88
    Top = 144
    Width = 233
    Height = 21
    Enabled = False
    TabOrder = 0
  end
  object StunBox: TCheckBox
    Left = 8
    Top = 144
    Width = 73
    Height = 17
    Caption = 'use STUN'
    TabOrder = 5
    OnClick = StunBoxClick
  end
  object Button2: TButton
    Left = 104
    Top = 216
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object ProxyEdit: TEdit
    Left = 88
    Top = 112
    Width = 233
    Height = 21
    TabOrder = 7
  end
end
