object SipClientForm: TSipClientForm
  Left = 0
  Top = 0
  Caption = 'SIP Client'
  ClientHeight = 741
  ClientWidth = 1076
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    1076
    741)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelDtmf: TLabel
    Left = 349
    Top = 141
    Width = 27
    Height = 13
    Alignment = taRightJustify
    Caption = 'Dtmf:'
  end
  object LabelCount: TLabel
    Left = 343
    Top = 117
    Width = 33
    Height = 13
    Alignment = taRightJustify
    Caption = 'Count:'
  end
  object LabelLifeTime: TLabel
    Left = 558
    Top = 117
    Width = 44
    Height = 13
    Alignment = taRightJustify
    Caption = 'Life time:'
  end
  object LabelOffset: TLabel
    Left = 448
    Top = 117
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Offset:'
  end
  object GroupBoxRegister: TGroupBox
    Left = 8
    Top = 5
    Width = 321
    Height = 152
    Caption = ' Register '
    TabOrder = 0
    object LabelRemoteHost: TLabel
      Left = 15
      Top = 46
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Remote Host:'
    end
    object LabelRemotePort: TLabel
      Left = 217
      Top = 46
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'Port:'
    end
    object LabelUserName: TLabel
      Left = 29
      Top = 73
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Username:'
    end
    object LabelPassword: TLabel
      Left = 158
      Top = 73
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password:'
    end
    object LabelLocalHost: TLabel
      Left = 28
      Top = 19
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Local Host:'
    end
    object LabelLocalPort: TLabel
      Left = 217
      Top = 19
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'Port:'
    end
    object EditRemoteHost: TEdit
      Left = 87
      Top = 43
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object EditRemotePort: TEdit
      Left = 247
      Top = 43
      Width = 64
      Height = 21
      TabOrder = 1
    end
    object EditUserName: TEdit
      Left = 87
      Top = 70
      Width = 62
      Height = 21
      TabOrder = 2
    end
    object EditPassword: TEdit
      Left = 214
      Top = 70
      Width = 97
      Height = 21
      TabOrder = 3
    end
    object ButtonRegister: TButton
      Left = 155
      Top = 97
      Width = 75
      Height = 25
      Caption = 'Register'
      TabOrder = 5
      OnClick = ButtonRegisterClick
    end
    object ButtonUnRegister: TButton
      Left = 236
      Top = 97
      Width = 75
      Height = 25
      Caption = 'UnRegister'
      Enabled = False
      TabOrder = 6
      OnClick = ButtonUnRegisterClick
    end
    object ComboBoxProviders: TComboBox
      Left = 15
      Top = 99
      Width = 130
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 4
      Text = #1057#1080#1073#1080#1088#1100' 2231003'
      OnChange = ComboBoxProvidersChange
      Items.Strings = (
        #1057#1080#1073#1080#1088#1100' 2026672'
        #1048#1085#1090#1077#1088#1090#1072#1082#1089' 2904021'
        #1057#1080#1073#1080#1088#1100' 2231003')
    end
    object CheckBoxTransport: TCheckBox
      Left = 15
      Top = 128
      Width = 69
      Height = 17
      Caption = 'Transport'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = CheckBoxTransportClick
    end
    object CheckBoxUseRport: TCheckBox
      Left = 90
      Top = 128
      Width = 69
      Height = 17
      Caption = 'Use Rport'
      TabOrder = 8
      OnClick = CheckBoxUseRportClick
    end
    object CheckBoxUseReceived: TCheckBox
      Left = 165
      Top = 128
      Width = 84
      Height = 17
      Caption = 'Use Received'
      TabOrder = 9
      OnClick = CheckBoxUseReceivedClick
    end
    object EditLocalHost: TEdit
      Left = 87
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 10
    end
    object EditLocalPort: TEdit
      Left = 247
      Top = 16
      Width = 64
      Height = 21
      TabOrder = 11
    end
    object EditRegister: TEdit
      Left = 255
      Top = 126
      Width = 40
      Height = 21
      TabOrder = 12
      Text = '120'
    end
    object UpDownRegister: TUpDown
      Left = 295
      Top = 126
      Width = 17
      Height = 21
      Associate = EditRegister
      Min = 10
      Max = 3600
      Increment = 10
      Position = 120
      TabOrder = 13
      Thousands = False
    end
  end
  object GroupBoxCall: TGroupBox
    Left = 335
    Top = 5
    Width = 337
    Height = 105
    Caption = ' Call '
    TabOrder = 1
    object LabelNumber: TLabel
      Left = 10
      Top = 18
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Number:'
    end
    object ButtonDial: TButton
      Left = 9
      Top = 42
      Width = 75
      Height = 25
      Caption = 'Dial'
      Enabled = False
      TabOrder = 0
      OnClick = ButtonDialClick
    end
    object ButtonHangup: TButton
      Left = 90
      Top = 42
      Width = 75
      Height = 25
      Caption = 'Hangup'
      Enabled = False
      TabOrder = 1
      OnClick = ButtonHangupClick
    end
    object ButtonAnswer: TButton
      Left = 171
      Top = 42
      Width = 75
      Height = 25
      Caption = 'Answer'
      Enabled = False
      TabOrder = 2
      OnClick = ButtonAnswerClick
    end
    object ButtonPlay: TButton
      Left = 171
      Top = 73
      Width = 75
      Height = 25
      Caption = 'Play'
      Enabled = False
      TabOrder = 3
      OnClick = ButtonPlayClick
    end
    object ButtonClear: TButton
      Left = 9
      Top = 73
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 4
      OnClick = ButtonClearClick
    end
    object ButtonHold: TButton
      Left = 91
      Top = 73
      Width = 75
      Height = 25
      Caption = 'Hold'
      Enabled = False
      TabOrder = 5
      OnClick = ButtonHoldClick
    end
    object CheckBoxAccept: TCheckBox
      Left = 160
      Top = 18
      Width = 97
      Height = 17
      Caption = 'Accept'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object ButtonTimers: TButton
      Left = 252
      Top = 73
      Width = 75
      Height = 25
      Caption = 'Stop timers'
      Enabled = False
      TabOrder = 7
      OnClick = ButtonTimersClick
    end
    object ComboBoxPhones: TComboBox
      Left = 57
      Top = 15
      Width = 97
      Height = 21
      ItemHeight = 13
      TabOrder = 8
      Text = '2026672'
      Items.Strings = (
        '2026672'
        '2374863'
        '2932332'
        '89029232332'
        '89504005373')
    end
    object CheckBoxTimers: TCheckBox
      Left = 224
      Top = 18
      Width = 81
      Height = 17
      Caption = 'Use Timers'
      TabOrder = 9
      OnClick = CheckBoxTimersClick
    end
    object ComboBoxAnswer: TComboBox
      Left = 252
      Top = 44
      Width = 75
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 10
      Text = 'Voice'
      Items.Strings = (
        'Voice'
        'Music'
        'Dtmf')
    end
  end
  object GroupBoxLog: TGroupBox
    Left = 8
    Top = 164
    Width = 1060
    Height = 569
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = '                '
    TabOrder = 2
    object MemoLog: TMemo
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 1046
      Height = 547
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
    object CheckBoxLog: TCheckBox
      Left = 12
      Top = -1
      Width = 42
      Height = 16
      Caption = 'Log'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object ButtonGroupLines: TButtonGroup
    Left = 678
    Top = 10
    Width = 390
    Height = 148
    Anchors = [akLeft, akTop, akRight]
    BorderWidth = 2
    ButtonOptions = [gboFullSize, gboGroupStyle, gboShowCaptions]
    Items = <
      item
        Caption = 'tyryrtywrty'
        ImageIndex = 0
      end
      item
        Caption = 'rtytwrytwry'
        ImageIndex = 1
      end>
    TabOrder = 3
    OnButtonClicked = ButtonGroupLinesButtonClicked
  end
  object EditDtmf: TEdit
    Left = 382
    Top = 138
    Width = 161
    Height = 21
    TabOrder = 4
  end
  object EditCount: TEdit
    Left = 382
    Top = 114
    Width = 37
    Height = 21
    ReadOnly = True
    TabOrder = 5
    Text = '1'
  end
  object UpDownCount: TUpDown
    Left = 419
    Top = 114
    Width = 17
    Height = 21
    Associate = EditCount
    Min = 1
    Position = 1
    TabOrder = 6
    Thousands = False
  end
  object EditLifeTime: TEdit
    Left = 608
    Top = 114
    Width = 38
    Height = 21
    ReadOnly = True
    TabOrder = 7
    Text = '10'
  end
  object UpDownLifetime: TUpDown
    Left = 646
    Top = 114
    Width = 17
    Height = 21
    Associate = EditLifeTime
    Min = 1
    Max = 1000
    Position = 10
    TabOrder = 8
    Thousands = False
  end
  object EditOffset: TEdit
    Left = 489
    Top = 114
    Width = 37
    Height = 21
    ReadOnly = True
    TabOrder = 9
    Text = '1000'
  end
  object UpDownOffset: TUpDown
    Left = 526
    Top = 114
    Width = 17
    Height = 21
    Associate = EditOffset
    Min = 10
    Max = 20000
    Increment = 100
    Position = 1000
    TabOrder = 10
    Thousands = False
  end
  object CheckBoxDtmf: TCheckBox
    Left = 549
    Top = 141
    Width = 76
    Height = 17
    Caption = 'Check Dtmf'
    TabOrder = 11
  end
  object TimerDtfm: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerDtfmTimer
    Left = 424
    Top = 296
  end
  object TimerExpires: TTimer
    Enabled = False
    OnTimer = TimerExpiresTimer
    Left = 352
    Top = 296
  end
  object TimerCounter: TTimer
    Enabled = False
    OnTimer = TimerCounterTimer
    Left = 280
    Top = 296
  end
  object TimerHangup: TTimer
    Enabled = False
    OnTimer = TimerHangupTimer
    Left = 520
    Top = 296
  end
  object TimerDial: TTimer
    Enabled = False
    OnTimer = TimerDialTimer
    Left = 616
    Top = 296
  end
end
