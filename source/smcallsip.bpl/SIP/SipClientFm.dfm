object SipClientForm: TSipClientForm
  Left = 0
  Top = 0
  Caption = 'SIP Client'
  ClientHeight = 638
  ClientWidth = 822
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    822
    638)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxRegister: TGroupBox
    Left = 8
    Top = 5
    Width = 305
    Height = 105
    Caption = ' Register '
    TabOrder = 0
    object LabelHost: TLabel
      Left = 48
      Top = 19
      Width = 26
      Height = 13
      Alignment = taRightJustify
      Caption = 'Host:'
    end
    object LabelPort: TLabel
      Left = 210
      Top = 19
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'Port:'
    end
    object LabelUserName: TLabel
      Left = 22
      Top = 46
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Username:'
    end
    object LabelPassword: TLabel
      Left = 160
      Top = 46
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password:'
    end
    object EditHost: TEdit
      Left = 80
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '195.112.242.242'
    end
    object EditPort: TEdit
      Left = 240
      Top = 16
      Width = 49
      Height = 21
      TabOrder = 1
      Text = '5060'
    end
    object EditUserName: TEdit
      Left = 80
      Top = 43
      Width = 73
      Height = 21
      TabOrder = 2
      Text = '2026672'
    end
    object EditPassword: TEdit
      Left = 216
      Top = 43
      Width = 73
      Height = 21
      TabOrder = 3
      Text = 'an7yntwspr'
    end
    object ButtonRegister: TButton
      Left = 135
      Top = 70
      Width = 75
      Height = 25
      Caption = 'Register'
      TabOrder = 4
      OnClick = ButtonRegisterClick
    end
    object ButtonUnRegister: TButton
      Left = 216
      Top = 70
      Width = 75
      Height = 25
      Caption = 'UnRegister'
      Enabled = False
      TabOrder = 5
      OnClick = ButtonUnRegisterClick
    end
  end
  object GroupBoxCall: TGroupBox
    Left = 319
    Top = 5
    Width = 298
    Height = 105
    Caption = ' Call '
    TabOrder = 1
    object ButtonInvite: TButton
      Left = 168
      Top = 64
      Width = 75
      Height = 25
      Caption = 'Invite'
      TabOrder = 0
      OnClick = ButtonInviteClick
    end
  end
  object GroupBoxLog: TGroupBox
    Left = 8
    Top = 116
    Width = 803
    Height = 514
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Log '
    TabOrder = 2
    object MemoLog: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 789
      Height = 492
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
      ExplicitLeft = 9
      ExplicitTop = 17
    end
  end
end
