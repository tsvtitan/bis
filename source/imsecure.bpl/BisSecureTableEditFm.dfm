inherited BisSecureTableEditForm: TBisSecureTableEditForm
  Left = 547
  Top = 315
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1090#1072#1073#1083#1080#1094
  ClientHeight = 466
  ClientWidth = 592
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  ExplicitWidth = 600
  ExplicitHeight = 500
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 431
    Width = 592
    TabOrder = 1
    ExplicitTop = 388
    ExplicitWidth = 542
    inherited ButtonOk: TButton
      Left = 430
      ModalResult = 1
      ExplicitLeft = 380
    end
    inherited ButtonCancel: TButton
      Left = 511
      ExplicitLeft = 461
    end
  end
  object PanelFrame: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 431
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 542
    ExplicitHeight = 388
  end
end
