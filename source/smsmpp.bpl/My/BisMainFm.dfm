object BisMainForm: TBisMainForm
  Left = 0
  Top = 0
  Caption = 'Smpp'
  ClientHeight = 558
  ClientWidth = 893
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    893
    558)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxConnection: TGroupBox
    Left = 8
    Top = 8
    Width = 289
    Height = 246
    Caption = ' Connection '
    TabOrder = 0
    object LabelHost: TLabel
      Left = 48
      Top = 23
      Width = 26
      Height = 13
      Alignment = taRightJustify
      Caption = 'Host:'
      FocusControl = EditHost
    end
    object LabelPort: TLabel
      Left = 186
      Top = 23
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'Port:'
      FocusControl = EditPort
    end
    object LabelSystemId: TLabel
      Left = 22
      Top = 50
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'System Id:'
      FocusControl = EditSystemId
    end
    object LabelPassword: TLabel
      Left = 24
      Top = 77
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password:'
      FocusControl = EditPassword
    end
    object LabelSystemType: TLabel
      Left = 144
      Top = 50
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'System Type:'
      FocusControl = EditSystemType
    end
    object LabelTypeOfNumber: TLabel
      Left = 32
      Top = 104
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type of Number:'
    end
    object LabelPlanIndicator: TLabel
      Left = 43
      Top = 131
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = 'Plan Indicator:'
    end
    object LabelRange: TLabel
      Left = 145
      Top = 77
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = 'Range:'
      FocusControl = EditRange
    end
    object LabelMode: TLabel
      Left = 83
      Top = 158
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Mode:'
      FocusControl = ComboBoxMode
    end
    object LabelReadTimeOut: TLabel
      Left = 41
      Top = 185
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = 'Read TimeOut:'
      FocusControl = EditReadTimeOut
    end
    object EditHost: TEdit
      Left = 80
      Top = 20
      Width = 97
      Height = 21
      TabOrder = 0
      Text = '95.172.133.169'
    end
    object EditPort: TEdit
      Left = 216
      Top = 20
      Width = 57
      Height = 21
      TabOrder = 1
      Text = '900'
    end
    object EditSystemId: TEdit
      Left = 80
      Top = 47
      Width = 57
      Height = 21
      TabOrder = 2
      Text = 'AtaXi014'
    end
    object EditPassword: TEdit
      Left = 80
      Top = 74
      Width = 57
      Height = 21
      TabOrder = 4
      Text = 'MAgK723'
    end
    object EditSystemType: TEdit
      Left = 216
      Top = 47
      Width = 57
      Height = 21
      TabOrder = 6
    end
    object EditRange: TEdit
      Left = 186
      Top = 74
      Width = 87
      Height = 21
      TabOrder = 7
    end
    object ButtonConnect: TButton
      Left = 119
      Top = 208
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 10
      OnClick = ButtonConnectClick
    end
    object ButtonDisconnect: TButton
      Left = 198
      Top = 208
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      Enabled = False
      TabOrder = 11
      OnClick = ButtonDisconnectClick
    end
    object ComboBoxMode: TComboBox
      Left = 119
      Top = 155
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 8
      Text = 'transceiver'
      Items.Strings = (
        'transmitter'
        'receiver'
        'transceiver')
    end
    object ComboBoxTypeOfNumber: TComboBox
      Left = 119
      Top = 101
      Width = 154
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'Unknown'
      Items.Strings = (
        'Unknown'
        'International'
        'National'
        'NetworkSpecific'
        'SubscriberNumber'
        'Alphanumeric'
        'Abbreviated')
    end
    object ComboBoxPlanIndicator: TComboBox
      Left = 119
      Top = 128
      Width = 154
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 5
      Text = 'Unknown'
      Items.Strings = (
        'Unknown'
        'ISDN'
        'Reserved002'
        'Data'
        'Telex'
        'Reserved005'
        'LandMobile'
        'Reserved007'
        'National'
        'Private'
        'ERMES'
        'Reserved011'
        'Reserved012'
        'Reserved013'
        'Internet'
        'Reserved015'
        'Reserved016'
        'Reserved017'
        'WAPClientId')
    end
    object EditReadTimeOut: TEdit
      Left = 119
      Top = 182
      Width = 57
      Height = 21
      TabOrder = 9
      Text = '2000'
    end
  end
  object GroupBoxOperations: TGroupBox
    Left = 308
    Top = 8
    Width = 577
    Height = 246
    Anchors = [akLeft, akTop, akRight]
    Caption = ' Operations '
    TabOrder = 1
    object LabelMessage: TLabel
      Left = 20
      Top = 161
      Width = 46
      Height = 13
      Caption = 'Message:'
      FocusControl = MemoMessage
    end
    object LabelLetters: TLabel
      Left = 50
      Top = 203
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Caption = '0/0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelSendType: TLabel
      Left = 11
      Top = 134
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Caption = 'Send Type:'
      FocusControl = ComboBoxSendType
    end
    object LabelConcat: TLabel
      Left = 197
      Top = 134
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Concat:'
      FocusControl = ComboBoxConcat
    end
    object LabelMaxLen: TLabel
      Left = 14
      Top = 181
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'Max:'
    end
    object ButtonSend: TButton
      Left = 486
      Top = 129
      Width = 75
      Height = 25
      Caption = 'Send'
      TabOrder = 5
      OnClick = ButtonSendClick
    end
    object MemoMessage: TMemo
      Left = 72
      Top = 158
      Width = 408
      Height = 59
      Lines.Strings = (
        
          #1055#1088#1086#1074#1077#1088#1082#1072' 1 '#1055#1088#1086#1074#1077#1088#1082#1072' 2 '#1055#1088#1086#1074#1077#1088#1082#1072' 3 '#1055#1088#1086#1074#1077#1088#1082#1072' 4 '#1055#1088#1086#1074#1077#1088#1082#1072' 5 '#1055#1088#1086#1074#1077#1088#1082#1072' ' +
          '6')
      ScrollBars = ssVertical
      TabOrder = 2
      WantReturns = False
      OnChange = MemoMessageChange
    end
    object GroupBoxSource: TGroupBox
      Left = 14
      Top = 20
      Width = 209
      Height = 103
      Caption = ' Source '
      TabOrder = 0
      object LabelSourceAddrTON: TLabel
        Left = 11
        Top = 22
        Width = 81
        Height = 13
        Alignment = taRightJustify
        Caption = 'Type of Number:'
      end
      object LabelSourceAddrNPI: TLabel
        Left = 22
        Top = 49
        Width = 70
        Height = 13
        Alignment = taRightJustify
        Caption = 'Plan Indicator:'
      end
      object LabelSourceAddr: TLabel
        Left = 49
        Top = 76
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'Address:'
        FocusControl = EditSourceAddr
      end
      object ComboBoxSourceAddrTON: TComboBox
        Left = 98
        Top = 19
        Width = 99
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 5
        TabOrder = 0
        Text = 'Alphanumeric'
        Items.Strings = (
          'Unknown'
          'International'
          'National'
          'NetworkSpecific'
          'SubscriberNumber'
          'Alphanumeric'
          'Abbreviated')
      end
      object ComboBoxSourceAddrNPI: TComboBox
        Left = 98
        Top = 46
        Width = 99
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Unknown'
        Items.Strings = (
          'Unknown'
          'ISDN'
          'Reserved002'
          'Data'
          'Telex'
          'Reserved005'
          'LandMobile'
          'Reserved007'
          'National'
          'Private'
          'ERMES'
          'Reserved011'
          'Reserved012'
          'Reserved013'
          'Internet'
          'Reserved015'
          'Reserved016'
          'Reserved017'
          'WAPClientId')
      end
      object EditSourceAddr: TEdit
        Left = 98
        Top = 73
        Width = 99
        Height = 21
        TabOrder = 2
        Text = 'What'#39's up?'
      end
    end
    object GroupBoxDest: TGroupBox
      Left = 230
      Top = 20
      Width = 331
      Height = 103
      Caption = ' Destination '
      TabOrder = 1
      object LabelDestAddrTON: TLabel
        Left = 11
        Top = 22
        Width = 81
        Height = 13
        Alignment = taRightJustify
        Caption = 'Type of Number:'
      end
      object LabelDestAddrNPI: TLabel
        Left = 22
        Top = 49
        Width = 70
        Height = 13
        Alignment = taRightJustify
        Caption = 'Plan Indicator:'
      end
      object LabelDestAddresses: TLabel
        Left = 206
        Top = 22
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Addresses:'
      end
      object LabelDestPort: TLabel
        Left = 23
        Top = 76
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = 'Port:'
        FocusControl = EditDestPort
      end
      object ComboBoxDestAddrTON: TComboBox
        Left = 98
        Top = 19
        Width = 99
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = 'International'
        Items.Strings = (
          'Unknown'
          'International'
          'National'
          'NetworkSpecific'
          'SubscriberNumber'
          'Alphanumeric'
          'Abbreviated')
      end
      object ComboBoxDestAddrNPI: TComboBox
        Left = 98
        Top = 46
        Width = 99
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 1
        Text = 'ISDN'
        Items.Strings = (
          'Unknown'
          'ISDN'
          'Reserved002'
          'Data'
          'Telex'
          'Reserved005'
          'LandMobile'
          'Reserved007'
          'National'
          'Private'
          'ERMES'
          'Reserved011'
          'Reserved012'
          'Reserved013'
          'Internet'
          'Reserved015'
          'Reserved016'
          'Reserved017'
          'WAPClientId')
      end
      object MemoDestAddresses: TMemo
        Left = 203
        Top = 41
        Width = 110
        Height = 53
        Lines.Strings = (
          '79029232332')
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object EditDestPort: TEdit
        Left = 53
        Top = 73
        Width = 39
        Height = 21
        TabOrder = 2
        OnChange = EditDestPortChange
      end
      object ComboBoxDestPort: TComboBox
        Left = 98
        Top = 73
        Width = 99
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 4
        Text = 'optional param'
        OnChange = ComboBoxDestPortChange
        Items.Strings = (
          'optional param'
          'UDH coding'
          'optional & UDH')
      end
    end
    object ComboBoxSendType: TComboBox
      Left = 72
      Top = 131
      Width = 102
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'alone address'
      Items.Strings = (
        'alone address'
        'multi address')
    end
    object ComboBoxConcat: TComboBox
      Left = 241
      Top = 131
      Width = 185
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 4
      Text = 'not used'
      OnChange = ComboBoxConcatChange
      Items.Strings = (
        'not used'
        'using division without UDH'
        'using division with UDH if it needs')
    end
    object CheckBoxUCS2: TCheckBox
      Left = 432
      Top = 133
      Width = 48
      Height = 17
      Caption = 'UCS2'
      TabOrder = 6
      OnClick = CheckBoxUCS2Click
    end
    object ButtonQuery: TButton
      Left = 486
      Top = 160
      Width = 75
      Height = 25
      Caption = 'Query'
      TabOrder = 7
      OnClick = ButtonQueryClick
    end
    object CheckBoxRequestDelivery: TCheckBox
      Left = 72
      Top = 221
      Width = 126
      Height = 17
      Caption = 'Request Delivery'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object CheckBoxFlash: TCheckBox
      Left = 207
      Top = 221
      Width = 97
      Height = 17
      Caption = 'Flash'
      TabOrder = 9
    end
    object ButtonCancel: TButton
      Left = 486
      Top = 191
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 10
      OnClick = ButtonCancelClick
    end
    object EditMaxLen: TEdit
      Left = 41
      Top = 178
      Width = 25
      Height = 21
      TabOrder = 11
      Text = '255'
      OnChange = EditMaxLenChange
    end
  end
  object GroupBoxLog: TGroupBox
    Left = 8
    Top = 260
    Width = 877
    Height = 290
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Log '
    TabOrder = 2
    object MemoLog: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 863
      Height = 268
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
end
