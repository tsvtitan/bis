inherited BisLoginForm: TBisLoginForm
  Left = 486
  Top = 324
  BorderStyle = bsDialog
  Caption = #1040#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1103
  ClientHeight = 228
  ClientWidth = 291
  ExplicitWidth = 297
  ExplicitHeight = 256
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButton: TPanel
    Left = 0
    Top = 191
    Width = 291
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      291
      37)
    object ButtonOk: TButton
      Left = 126
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1050
      Default = True
      TabOrder = 0
      OnClick = ButtonOkClick
    end
    object ButtonCancel: TButton
      Left = 207
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 291
    Height = 191
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PanelGradientHead: TPanel
      Left = 0
      Top = 0
      Width = 291
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      Color = 16703437
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        291
        50)
      object Image: TImage
        Left = 12
        Top = 10
        Width = 32
        Height = 32
        Center = True
      end
      object LabelApplicationTitle: TLabel
        Left = 57
        Top = 16
        Width = 107
        Height = 19
        Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object LabelVersion: TLabel
        AlignWithMargins = True
        Left = 251
        Top = 3
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1042#1077#1088#1089#1080#1103
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
    end
    object PanelGradientDelim: TPanel
      Left = 0
      Top = 50
      Width = 291
      Height = 3
      Align = alTop
      BevelOuter = bvNone
      Color = 16626052
      ParentBackground = False
      TabOrder = 1
    end
    object PanelUserPass: TPanel
      Left = 0
      Top = 53
      Width = 291
      Height = 138
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object LabelConnection: TLabel
        Left = 32
        Top = 76
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077':'
        FocusControl = ComboBoxConnections
      end
      object LabelApplication: TLabel
        Left = 31
        Top = 103
        Width = 67
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
        FocusControl = ComboBoxApplications
      end
      object LabeledEditUser: TLabeledEdit
        Left = 104
        Top = 19
        Width = 165
        Height = 21
        EditLabel.Width = 76
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        EditLabel.Layout = tlCenter
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 0
      end
      object LabeledEditPass: TLabeledEdit
        Left = 104
        Top = 46
        Width = 165
        Height = 21
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Margins.Right = 5
        EditLabel.Caption = #1055#1072#1088#1086#1083#1100':'
        EditLabel.Layout = tlCenter
        LabelPosition = lpLeft
        LabelSpacing = 6
        PasswordChar = '*'
        TabOrder = 1
      end
      object ComboBoxConnections: TComboBox
        Left = 104
        Top = 73
        Width = 138
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 2
        OnChange = ComboBoxConnectionsChange
      end
      object ButtonConnection: TButton
        Left = 248
        Top = 73
        Width = 21
        Height = 21
        Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
        Caption = '...'
        TabOrder = 3
        OnClick = ButtonConnectionClick
      end
      object ComboBoxApplications: TComboBox
        Left = 104
        Top = 100
        Width = 165
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 4
        OnChange = ComboBoxApplicationsChange
      end
    end
  end
end
