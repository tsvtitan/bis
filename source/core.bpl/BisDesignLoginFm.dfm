inherited BisDesignLoginForm: TBisDesignLoginForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Authentification'
  ClientHeight = 183
  ClientWidth = 282
  Font.Name = 'Tahoma'
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 288
  ExplicitHeight = 208
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButton: TPanel
    Left = 0
    Top = 146
    Width = 282
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      282
      37)
    object ButtonOk: TButton
      Left = 120
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1050
      Default = True
      TabOrder = 0
      OnClick = ButtonOkClick
    end
    object ButtonCancel: TButton
      Left = 201
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object PanelUserPass: TPanel
    Left = 0
    Top = 0
    Width = 282
    Height = 146
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object GroupBoxUserPass: TGroupBox
      Left = 5
      Top = 5
      Width = 272
      Height = 136
      Align = alClient
      Caption = ' Will Enter their own data '
      TabOrder = 0
      object LabelConnection: TLabel
        Left = 33
        Top = 80
        Width = 58
        Height = 13
        Alignment = taRightJustify
        Caption = 'Connection:'
      end
      object LabeledEditUser: TLabeledEdit
        Left = 96
        Top = 22
        Width = 165
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'User:'
        EditLabel.Layout = tlCenter
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 0
        Text = #1058#1077#1089#1090
      end
      object LabeledEditPass: TLabeledEdit
        Left = 96
        Top = 49
        Width = 165
        Height = 21
        EditLabel.Width = 50
        EditLabel.Height = 13
        EditLabel.Margins.Right = 5
        EditLabel.Caption = 'Password:'
        EditLabel.Layout = tlCenter
        LabelPosition = lpLeft
        LabelSpacing = 5
        PasswordChar = '*'
        TabOrder = 1
        Text = '1'
      end
      object ComboBoxConnections: TComboBox
        Left = 96
        Top = 77
        Width = 165
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = ComboBoxConnectionsChange
      end
    end
  end
end
