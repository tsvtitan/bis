inherited BisUtilsTableEditForm: TBisUtilsTableEditForm
  Left = 547
  Top = 315
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1090#1072#1073#1083#1080#1094
  ClientHeight = 373
  ClientWidth = 492
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  ExplicitWidth = 508
  ExplicitHeight = 411
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 338
    Width = 492
    TabOrder = 1
    ExplicitTop = 338
    ExplicitWidth = 492
    inherited ButtonOk: TButton
      Left = 330
      ModalResult = 1
      ExplicitLeft = 330
    end
    inherited ButtonCancel: TButton
      Left = 411
      ExplicitLeft = 411
    end
  end
  object PanelFrame: TPanel
    Left = 0
    Top = 0
    Width = 492
    Height = 338
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
end
