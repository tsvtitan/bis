inherited BisKrieltDataQuestionsForm: TBisKrieltDataQuestionsForm
  Left = 485
  Top = 245
  Caption = #1042#1086#1087#1088#1086#1089#1099
  ClientHeight = 376
  ClientWidth = 592
  ExplicitWidth = 600
  ExplicitHeight = 410
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 357
    Width = 592
    ExplicitTop = 357
    ExplicitWidth = 542
  end
  inherited PanelFrame: TPanel
    Width = 592
    Height = 199
    ExplicitWidth = 542
    ExplicitHeight = 199
  end
  inherited PanelButton: TPanel
    Top = 319
    Width = 592
    ExplicitTop = 319
    ExplicitWidth = 542
    inherited ButtonOk: TButton
      Left = 416
      ExplicitLeft = 366
    end
    inherited ButtonCancel: TButton
      Left = 512
      ExplicitLeft = 462
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 199
    Width = 592
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    ExplicitWidth = 542
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 586
      Height = 114
      Align = alClient
      Caption = ' '#1058#1077#1082#1089#1090' '#1074#1086#1087#1088#1086#1089#1072' '
      TabOrder = 0
      ExplicitWidth = 536
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 582
        Height = 97
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        ExplicitWidth = 532
        object DBMemoQuestionText: TDBMemo
          Left = 5
          Top = 5
          Width = 572
          Height = 87
          Align = alClient
          Color = clBtnFace
          DataField = 'QUESTION_TEXT'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 522
        end
      end
    end
  end
end
