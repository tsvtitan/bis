inherited BisTaxiClientForm: TBisTaxiClientForm
  Left = 0
  Top = 0
  Caption = #1050#1083#1080#1077#1085#1090
  ClientHeight = 197
  ClientWidth = 388
  ExplicitWidth = 394
  ExplicitHeight = 225
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 162
    Width = 388
    TabOrder = 1
    ExplicitTop = 162
    ExplicitWidth = 388
    inherited ButtonOk: TButton
      Left = 221
      Enabled = False
      ModalResult = 1
      ExplicitLeft = 221
    end
    inherited ButtonCancel: TButton
      Left = 303
      ExplicitLeft = 303
    end
  end
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 388
    Height = 162
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object LabelUserName: TLabel
      Left = 18
      Top = 16
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = #1051#1086#1075#1080#1085':'
      FocusControl = EditUserName
    end
    object LabelBalance: TLabel
      Left = 264
      Top = 43
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = #1041#1072#1083#1072#1085#1089':'
      FocusControl = EditBalance
    end
    object LabelFIO: TLabel
      Left = 25
      Top = 43
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1048#1054':'
      FocusControl = EditFIO
    end
    object LabelFirm: TLabel
      Left = 62
      Top = 97
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      FocusControl = EditFirm
    end
    object LabelJobTitle: TLabel
      Left = 71
      Top = 124
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
      FocusControl = EditJobTitle
    end
    object LabelAddress: TLabel
      Left = 17
      Top = 70
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089':'
      FocusControl = EditAddress
    end
    object LabelPhone: TLabel
      Left = 210
      Top = 16
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
    end
    object EditUserName: TEdit
      Left = 58
      Top = 13
      Width = 132
      Height = 21
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object EditBalance: TEdit
      Left = 309
      Top = 40
      Width = 65
      Height = 21
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object EditFIO: TEdit
      Left = 58
      Top = 40
      Width = 197
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object EditFirm: TEdit
      Left = 138
      Top = 94
      Width = 236
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
    object EditJobTitle: TEdit
      Left = 138
      Top = 121
      Width = 236
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object EditAddress: TEdit
      Left = 58
      Top = 67
      Width = 316
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object EditPhone: TEdit
      Left = 264
      Top = 13
      Width = 110
      Height = 21
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
  end
end
