inherited BisCallcTaskOperatorForm: TBisCallcTaskOperatorForm
  Left = 432
  Top = 219
  Caption = #1047#1072#1076#1072#1085#1080#1077' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
  Font.Name = 'Tahoma'
  ExplicitLeft = 432
  ExplicitTop = 219
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelTask: TPanel
    Height = 133
    ExplicitHeight = 133
    inherited GroupBoxTask: TGroupBox
      Height = 130
      ExplicitHeight = 137
      inherited PanelControls: TPanel
        Height = 113
        ExplicitWidth = 555
        ExplicitHeight = 113
        inherited LabelAction: TLabel
          Left = 13
          Width = 77
          ExplicitLeft = 13
          ExplicitWidth = 77
        end
        inherited LabelDateBegin: TLabel
          Left = 277
          Width = 69
          ExplicitLeft = 277
          ExplicitWidth = 69
        end
        inherited LabelTime: TLabel
          Left = 488
          Width = 34
          ExplicitLeft = 488
          ExplicitWidth = 34
        end
        inherited LabelDescription: TLabel
          Left = 19
          Width = 71
          ExplicitLeft = 19
          ExplicitWidth = 71
        end
        inherited LabelResult: TLabel
          Left = 33
          Width = 57
          ExplicitLeft = 33
          ExplicitWidth = 57
        end
        inherited LabelNextDate: TLabel
          Width = 66
          ExplicitWidth = 66
        end
        inherited ButtonExecute: TBitBtn
          Enabled = True
        end
      end
    end
  end
  inherited PanelFrame: TPanel
    Top = 133
    Height = 296
    ExplicitTop = 136
    ExplicitHeight = 296
  end
  inherited TimerRefresh: TTimer
    Left = 165
  end
end
