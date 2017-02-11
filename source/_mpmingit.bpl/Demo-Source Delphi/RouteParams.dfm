object RouteParamsForm: TRouteParamsForm
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Route parameters'
  ClientHeight = 249
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 152
    Width = 61
    Height = 13
    Caption = 'Vehicle type:'
  end
  object Label2: TLabel
    Left = 8
    Top = 80
    Width = 60
    Height = 13
    Caption = 'Optimization:'
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 33
    Height = 13
    Caption = 'Length'
  end
  object Label4: TLabel
    Left = 176
    Top = 104
    Width = 23
    Height = 13
    Caption = 'Time'
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 200
    Width = 193
    Height = 11
    TabOrder = 5
  end
  object AbortBtn: TButton
    Left = 144
    Top = 216
    Width = 57
    Height = 25
    Caption = 'Abort'
    Enabled = False
    TabOrder = 6
    OnClick = AbortBtnClick
  end
  object AutoRecalc: TCheckBox
    Left = 8
    Top = 8
    Width = 185
    Height = 17
    Caption = 'Auto recalc on points change'
    TabOrder = 0
  end
  object OptimizeOrder: TCheckBox
    Left = 8
    Top = 24
    Width = 161
    Height = 17
    Caption = 'Optimize points order'
    TabOrder = 1
    OnClick = OptimizeOrderClick
  end
  object FixStart: TCheckBox
    Left = 32
    Top = 40
    Width = 121
    Height = 17
    Caption = 'Fix first point as Start'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = FixStartClick
  end
  object FixFinish: TCheckBox
    Left = 32
    Top = 56
    Width = 129
    Height = 17
    Caption = 'Fix last point as Finish'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = FixFinishClick
  end
  object VTypes: TComboBox
    Left = 8
    Top = 168
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = VTypesChange
  end
  object CalcBtn: TButton
    Left = 8
    Top = 216
    Width = 121
    Height = 25
    Caption = 'Calculate route'
    TabOrder = 7
    OnClick = CalcBtnClick
  end
  object OptTime: TTrackBar
    Left = 48
    Top = 96
    Width = 121
    Height = 27
    TabOrder = 8
    OnChange = OptTimeChange
  end
  object BtnVars: TButton
    Left = 108
    Top = 136
    Width = 91
    Height = 25
    Caption = 'Show variants'
    TabOrder = 9
    OnClick = BtnVarsClick
  end
end
