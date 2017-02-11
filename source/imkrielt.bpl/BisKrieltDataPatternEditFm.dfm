inherited BisKrieltDataPatternEditForm: TBisKrieltDataPatternEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataPatternEditForm'
  ClientHeight = 289
  ClientWidth = 379
  ExplicitWidth = 387
  ExplicitHeight = 323
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 251
    Width = 379
    ExplicitTop = 236
    ExplicitWidth = 326
    inherited ButtonOk: TButton
      Left = 200
      ExplicitLeft = 147
    end
    inherited ButtonCancel: TButton
      Left = 296
      ExplicitLeft = 243
    end
  end
  inherited PanelControls: TPanel
    Width = 379
    Height = 251
    ExplicitWidth = 326
    ExplicitHeight = 236
    object LabelExport: TLabel
      Left = 37
      Top = 15
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1069#1082#1089#1087#1086#1088#1090':'
      FocusControl = EditExport
    end
    object LabelDesign: TLabel
      Left = 15
      Top = 42
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077':'
      FocusControl = ComboBoxDesign
    end
    object EditExport: TEdit
      Left = 89
      Top = 12
      Width = 249
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
      ExplicitWidth = 196
    end
    object ButtonExport: TButton
      Left = 344
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1101#1082#1089#1087#1086#1088#1090
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      ExplicitLeft = 291
    end
    object PageControl: TPageControl
      Left = 7
      Top = 66
      Width = 366
      Height = 179
      ActivePage = TabSheetRtf
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 3
      object TabSheetRtf: TTabSheet
        Caption = 'RTF'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 289
        ExplicitHeight = 136
        object MemoRtf: TMemo
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 352
          Height = 145
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          ExplicitWidth = 283
          ExplicitHeight = 130
        end
      end
    end
    object ComboBoxDesign: TComboBox
      Left = 89
      Top = 39
      Width = 276
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 2
    end
  end
  inherited ImageList: TImageList
    Left = 128
    Top = 16
  end
end
