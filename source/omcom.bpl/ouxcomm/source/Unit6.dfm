object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 341
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 152
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 279
    Top = 30
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 80
    Width = 449
    Height = 233
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
    WordWrap = False
  end
  object Button2: TButton
    Left = 520
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object XModem1: TXModem
    BaudRate = br9600
    BaudValue = 9600
    Buffers.InputSize = 2048
    Buffers.OutputSize = 2048
    Buffers.InputTimeout = 500
    Buffers.OutputTimeout = 500
    RTSSettings = []
    DataControl.DataBits = db8
    DataControl.Parity = paNone
    DataControl.StopBits = sb1
    DeviceName = 'COM2'
    DTRSettings = []
    EventChars.XonChar = #17
    EventChars.XoffChar = #19
    EventChars.EofChar = #0
    EventChars.ErrorChar = #0
    EventChars.EventChar = #10
    MonitorEvents = [deChar, deFlag, deOutEmpty]
    FlowControl = fcNone
    ModemSettings.DialType = dtTone
    ModemSettings.ConnectType = ctWait
    ModemSettings.InitString = 'ATX&C1&D2&K3M0'
    ModemSettings.ResetString = 'ATZ'
    ModemSettings.Speed = 33600
    ModemSettings.WaitRings = 2
    Options = []
    Synchronize = True
    Timeouts.ReadInterval = 1
    Timeouts.ReadMultiplier = 0
    Timeouts.ReadConstant = 1
    Timeouts.WriteMultiplier = 0
    Timeouts.WriteConstant = 1
    XOnXOffSettings = []
    OnCommEvent = XModem1CommEvent
    OnConnect = XModem1Connect
    OnData = XModem1Data
    OnDisconnect = XModem1Disconnect
    OnHayesAT = XModem1HayesAT
    OnRead = XModem1Read
    OnSend = XModem1Send
    Left = 520
    Top = 112
  end
  object XComm1: TXComm
    BaudRate = br9600
    BaudValue = 9600
    Buffers.InputSize = 2048
    Buffers.OutputSize = 2048
    Buffers.InputTimeout = 500
    Buffers.OutputTimeout = 500
    RTSSettings = []
    DataControl.DataBits = db8
    DataControl.Parity = paNone
    DataControl.StopBits = sb1
    DeviceName = 'COM4'
    DTRSettings = []
    EventChars.XonChar = #17
    EventChars.XoffChar = #19
    EventChars.EofChar = #0
    EventChars.ErrorChar = #0
    EventChars.EventChar = #10
    MonitorEvents = [deChar, deFlag, deOutEmpty, deBreak]
    FlowControl = fcNone
    Options = [coDiscardNull]
    Synchronize = True
    Timeouts.ReadInterval = 1
    Timeouts.ReadMultiplier = 0
    Timeouts.ReadConstant = 1
    Timeouts.WriteMultiplier = 0
    Timeouts.WriteConstant = 1
    XOnXOffSettings = []
    OnCommEvent = XModem1CommEvent
    OnData = XModem1Data
    OnRead = XModem1Read
    OnSend = XModem1Send
    Left = 528
    Top = 200
  end
end
