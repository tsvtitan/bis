inherited BisSupportReasonsForm: TBisSupportReasonsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeable
  Caption = #1055#1088#1080#1095#1080#1085#1072
  ClientHeight = 96
  ClientWidth = 284
  Position = poMainFormCenter
  ExplicitWidth = 300
  ExplicitHeight = 134
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 61
    Width = 284
    TabOrder = 1
    ExplicitTop = 61
    ExplicitWidth = 244
    inherited ButtonOk: TButton
      Left = 119
      ModalResult = 1
      ExplicitLeft = 79
    end
    inherited ButtonCancel: TButton
      Left = 201
      ExplicitLeft = 161
    end
  end
  object GroupBoxReasons: TGroupBox
    AlignWithMargins = True
    Left = 5
    Top = 3
    Width = 274
    Height = 53
    Margins.Left = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Caption = ' '#1042#1072#1088#1080#1072#1085#1090#1099' '
    TabOrder = 0
    ExplicitWidth = 234
    DesignSize = (
      274
      53)
    object EditOther: TEdit
      Left = 16
      Top = 19
      Width = 241
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Visible = False
      OnChange = EditOtherChange
    end
  end
end
