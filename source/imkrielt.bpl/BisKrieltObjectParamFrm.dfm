inherited BisKrieltObjectParamFrame: TBisKrieltObjectParamFrame
  Width = 267
  Height = 206
  ExplicitWidth = 267
  ExplicitHeight = 206
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 267
    Height = 206
    ActivePage = TabSheetLink
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    OnChange = PageControlChange
    object TabSheetList: TTabSheet
      Caption = #1057#1087#1080#1089#1086#1082
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        259
        175)
      object ComboBoxListValue: TComboBox
        Left = 3
        Top = 3
        Width = 253
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 0
        OnChange = ComboBoxListValueChange
      end
    end
    object TabSheetInteger: TTabSheet
      Caption = #1062#1077#1083#1086#1077' '#1095#1080#1089#1083#1086
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object EditInteger: TEdit
        Left = 3
        Top = 3
        Width = 86
        Height = 21
        TabOrder = 0
        OnChange = ComboBoxListValueChange
      end
    end
    object TabSheetFloat: TTabSheet
      Caption = #1063#1080#1089#1083#1086' '#1089' '#1090#1086#1095#1082#1086#1081
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object EditFloat: TEdit
        Left = 3
        Top = 3
        Width = 86
        Height = 21
        TabOrder = 0
        OnChange = ComboBoxListValueChange
      end
    end
    object TabSheetString: TTabSheet
      Caption = #1057#1090#1088#1086#1082#1072
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MemoString: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 253
        Height = 169
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
    object TabSheetDate: TTabSheet
      Caption = #1044#1072#1090#1072
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DateTimePicker: TDateTimePicker
        Left = 3
        Top = 3
        Width = 89
        Height = 21
        Date = 40251.633861574070000000
        Time = 40251.633861574070000000
        TabOrder = 0
        OnChange = ComboBoxListValueChange
      end
    end
    object TabSheetDateTime: TTabSheet
      Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 93
        Height = 13
        Align = alClient
        Alignment = taCenter
        Caption = #1053#1077' '#1088#1077#1072#1083#1080#1079#1086#1074#1072#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
    end
    object TabSheetImage: TTabSheet
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 93
        Height = 13
        Align = alClient
        Alignment = taCenter
        Caption = #1053#1077' '#1088#1077#1072#1083#1080#1079#1086#1074#1072#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
    end
    object TabSheetDocument: TTabSheet
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 93
        Height = 13
        Align = alClient
        Alignment = taCenter
        Caption = #1053#1077' '#1088#1077#1072#1083#1080#1079#1086#1074#1072#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
    end
    object TabSheetVideo: TTabSheet
      Caption = #1042#1080#1076#1077#1086
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 93
        Height = 13
        Align = alClient
        Alignment = taCenter
        Caption = #1053#1077' '#1088#1077#1072#1083#1080#1079#1086#1074#1072#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
    end
    object TabSheetLink: TTabSheet
      Caption = #1057#1089#1099#1083#1082#1072
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object EditLink: TEdit
        Left = 3
        Top = 3
        Width = 253
        Height = 21
        TabOrder = 0
        OnChange = ComboBoxListValueChange
      end
    end
  end
end
