inherited BisDesignExchangeForm: TBisDesignExchangeForm
  Caption = #1055#1077#1088#1077#1085#1086#1089' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 283
  ClientWidth = 427
  ExplicitWidth = 435
  ExplicitHeight = 317
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButtons: TPanel
    Top = 218
    Width = 427
    Height = 65
    ExplicitTop = 218
    ExplicitWidth = 427
    ExplicitHeight = 65
    inherited ButtonCancel: TButton
      Left = 342
      Top = 32
      ExplicitLeft = 342
      ExplicitTop = 32
    end
    inherited BitBtnStart: TBitBtn
      Left = 160
      Top = 32
      ExplicitLeft = 160
      ExplicitTop = 32
    end
    inherited BitBtnStop: TBitBtn
      Left = 261
      Top = 32
      ExplicitLeft = 261
      ExplicitTop = 32
    end
    inherited ButtonOptions: TButton
      Top = 32
      ExplicitTop = 32
    end
    object ProgressBar: TProgressBar
      Left = 9
      Top = 9
      Width = 408
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 4
    end
  end
  inherited PanelControls: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 421
    Height = 215
    Margins.Bottom = 0
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 421
    ExplicitHeight = 215
  end
  inherited ActionList: TActionList
    object ActionInfo: TAction
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1073#1084#1077#1085#1091
      OnExecute = ActionInfoExecute
      OnUpdate = ActionInfoUpdate
    end
  end
  object DataSource: TDataSource
    Left = 248
    Top = 112
  end
end
