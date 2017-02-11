inherited BisKrieltImportForm: TBisKrieltImportForm
  Left = 364
  Top = 200
  ActiveControl = EditAccount
  Caption = #1048#1084#1087#1086#1088#1090' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1081
  ClientHeight = 436
  ClientWidth = 622
  OldCreateOrder = True
  OnResize = FormResize
  ExplicitWidth = 630
  ExplicitHeight = 470
  PixelsPerInch = 96
  TextHeight = 13
  object PanelGeneral: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 2
    Width = 612
    Height = 275
    Margins.Left = 5
    Margins.Top = 2
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Constraints.MinHeight = 210
    TabOrder = 0
    object PanelGeneralLeft: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 293
      Height = 275
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object GroupBoxGeneralLeft: TGroupBox
        Left = 0
        Top = 0
        Width = 293
        Height = 275
        Align = alClient
        Caption = ' '#1054#1073#1097#1080#1077' '#1076#1072#1085#1085#1099#1077' '
        TabOrder = 0
        DesignSize = (
          293
          275)
        object LabelAccount: TLabel
          Left = 12
          Top = 20
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
          FocusControl = EditAccount
        end
        object LabelView: TLabel
          Left = 21
          Top = 47
          Width = 75
          Height = 13
          Alignment = taRightJustify
          Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074':'
          FocusControl = EditView
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object LabelType: TLabel
          Left = 22
          Top = 74
          Width = 74
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074':'
          FocusControl = EditType
        end
        object LabelOperation: TLabel
          Left = 42
          Top = 101
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
          FocusControl = EditOperation
        end
        object LabelDateBegin: TLabel
          Left = 27
          Top = 156
          Width = 69
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
          FocusControl = DateTimePickerDateBegin
        end
        object LabelNext: TLabel
          Left = 54
          Top = 183
          Width = 42
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1077#1088#1080#1086#1076':'
          FocusControl = ComboBoxNext
        end
        object LabelPublishing: TLabel
          Left = 49
          Top = 209
          Width = 47
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1079#1076#1072#1085#1080#1103':'
          FocusControl = ComboBoxNext
        end
        object LabelDesign: TLabel
          Left = 28
          Top = 128
          Width = 68
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077':'
          FocusControl = EditDesign
        end
        object LabelPriority: TLabel
          Left = 158
          Top = 248
          Width = 59
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090':'
          FocusControl = EditPriority
        end
        object LabelColor: TLabel
          Left = 24
          Top = 248
          Width = 50
          Height = 13
          Caption = 'LabelColor'
          Color = 16119285
          ParentColor = False
          Transparent = False
          Visible = False
        end
        object EditAccount: TEdit
          Left = 102
          Top = 17
          Width = 153
          Height = 21
          Color = 15000804
          MaxLength = 100
          ReadOnly = True
          TabOrder = 0
        end
        object ButtonAccount: TButton
          Left = 261
          Top = 17
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
          Caption = '...'
          TabOrder = 1
          OnClick = ButtonAccountClick
        end
        object EditView: TEdit
          Left = 102
          Top = 44
          Width = 153
          Height = 21
          Color = 15000804
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
        object ButtonView: TButton
          Left = 261
          Top = 44
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076' '#1086#1073#1098#1077#1082#1090#1072
          Caption = '...'
          TabOrder = 3
          OnClick = ButtonViewClick
        end
        object EditType: TEdit
          Left = 102
          Top = 71
          Width = 153
          Height = 21
          Color = 15000804
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
        end
        object ButtonType: TButton
          Left = 261
          Top = 71
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087
          Caption = '...'
          TabOrder = 5
          OnClick = ButtonTypeClick
        end
        object EditOperation: TEdit
          Left = 102
          Top = 98
          Width = 153
          Height = 21
          Color = 15000804
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
        object ButtonOperation: TButton
          Left = 261
          Top = 98
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
          Caption = '...'
          TabOrder = 7
          OnClick = ButtonOperationClick
        end
        object DateTimePickerTimeBegin: TDateTimePicker
          Left = 204
          Top = 152
          Width = 78
          Height = 22
          Date = 39467.616504444440000000
          Time = 39467.616504444440000000
          Kind = dtkTime
          TabOrder = 10
        end
        object DateTimePickerDateBegin: TDateTimePicker
          Left = 102
          Top = 152
          Width = 96
          Height = 22
          Date = 39467.616504444440000000
          Time = 39467.616504444440000000
          TabOrder = 11
        end
        object ComboBoxNext: TComboBox
          Left = 102
          Top = 180
          Width = 95
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 6
          TabOrder = 12
          Text = '1 '#1085#1077#1076#1077#1083#1103
          Items.Strings = (
            '1 '#1076#1077#1085#1100
            '2 '#1076#1085#1103
            '3 '#1076#1085#1103
            '4 '#1076#1085#1103
            '5 '#1076#1085#1077#1081
            '6 '#1076#1085#1077#1081
            '1 '#1085#1077#1076#1077#1083#1103
            '2 '#1085#1077#1076#1077#1083#1080
            '3 '#1085#1077#1076#1077#1083#1080
            '1 '#1084#1077#1089#1103#1094)
        end
        object CheckBoxTimer: TCheckBox
          Left = 234
          Top = 182
          Width = 48
          Height = 17
          Caption = #1040#1074#1090#1086
          Checked = True
          State = cbChecked
          TabOrder = 14
          OnClick = CheckBoxTimerClick
        end
        object ButtonIssue: TButton
          Left = 203
          Top = 180
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1099#1087#1091#1089#1082
          Caption = '...'
          TabOrder = 13
          OnClick = ButtonIssueClick
        end
        object CheckListBoxPublishing: TCheckListBox
          Left = 102
          Top = 207
          Width = 180
          Height = 32
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          Items.Strings = (
            '1'
            '2')
          TabOrder = 15
          OnDblClick = CheckListBoxPublishingDblClick
        end
        object EditDesign: TEdit
          Left = 102
          Top = 125
          Width = 153
          Height = 21
          Color = 15000804
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ReadOnly = True
          TabOrder = 8
        end
        object ButtonDesign: TButton
          Left = 261
          Top = 125
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1077
          Caption = '...'
          TabOrder = 9
          OnClick = ButtonDesignClick
        end
        object EditPriority: TEdit
          Left = 223
          Top = 245
          Width = 59
          Height = 21
          Anchors = [akRight, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          TabOrder = 16
        end
      end
    end
    object PanelGeneralClient: TPanel
      AlignWithMargins = True
      Left = 300
      Top = 0
      Width = 312
      Height = 275
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object GroupBoxPresentation: TGroupBox
        Left = 0
        Top = 0
        Width = 312
        Height = 275
        Align = alClient
        Caption = ' '#1055#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077' '
        TabOrder = 0
        DesignSize = (
          312
          275)
        object EditPresentation: TEdit
          Left = 12
          Top = 17
          Width = 228
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Color = 15000804
          MaxLength = 100
          ReadOnly = True
          TabOrder = 0
        end
        object ButtonPresentation: TButton
          Left = 246
          Top = 16
          Width = 23
          Height = 22
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = ButtonPresentationClick
        end
        object GridPresentation: TDBGrid
          Left = 12
          Top = 44
          Width = 287
          Height = 221
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = DataSourcePresentation
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgCancelOnExit]
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnCellClick = GridPresentationCellClick
          OnColEnter = GridPresentationColEnter
          OnColExit = GridPresentationColExit
          OnDrawColumnCell = GridPresentationDrawColumnCell
          OnEditButtonClick = GridPresentationEditButtonClick
          OnKeyDown = GridPresentationKeyDown
          Columns = <
            item
              Expanded = False
              FieldName = 'NAME'
              ReadOnly = True
              Title.Caption = #1050#1086#1083#1086#1085#1082#1072
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRIPTION'
              ReadOnly = True
              Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
              Width = 130
              Visible = True
            end
            item
              ButtonStyle = cbsEllipsis
              Expanded = False
              FieldName = 'VALUE_DEFAULT'
              Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
              Width = 130
              Visible = True
            end
            item
              Expanded = False
              ReadOnly = True
              Width = 20
              Visible = True
            end>
        end
      end
    end
  end
  object PanelPreview: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 279
    Width = 612
    Height = 132
    Margins.Left = 5
    Margins.Top = 2
    Margins.Right = 5
    Margins.Bottom = 6
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 100
    TabOrder = 1
    object GroupBoxPreview: TGroupBox
      Left = 0
      Top = 0
      Width = 612
      Height = 132
      Align = alClient
      Caption = ' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088' '
      TabOrder = 0
      object PanelPreviewBottom: TPanel
        Left = 2
        Top = 98
        Width = 608
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          608
          32)
        object LabelCount: TLabel
          Left = 326
          Top = 6
          Width = 84
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = #1042#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081': 0'
        end
        object ButtonImport: TButton
          Left = 422
          Top = 1
          Width = 100
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
          Enabled = False
          TabOrder = 1
          OnClick = ButtonImportClick
        end
        object Navigator: TDBNavigator
          Left = 86
          Top = 1
          Width = 234
          Height = 25
          DataSource = DataSourcePreview
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
          Anchors = [akLeft, akBottom]
          Hints.Strings = (
            #1055#1077#1088#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
            #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
            #1057#1083#1077#1076#1091#1102#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
            #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1079#1072#1087#1080#1089#1100
            #1042#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
            #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
            #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
            #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            #1054#1090#1084#1077#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077)
          ConfirmDelete = False
          TabOrder = 0
        end
        object ButtonCancel: TButton
          Left = 528
          Top = 1
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #1054#1090#1084#1077#1085#1072
          TabOrder = 2
          OnClick = ButtonCancelClick
        end
        object ButtonLoad: TButton
          Left = 5
          Top = 1
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = ButtonLoadClick
        end
      end
      object PanelGridPreview: TPanel
        AlignWithMargins = True
        Left = 7
        Top = 15
        Width = 598
        Height = 78
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object GridPreview: TDBGrid
          Left = 0
          Top = 0
          Width = 598
          Height = 78
          Align = alClient
          DataSource = DataSourcePreview
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
          PopupMenu = PopupActionBarPreview
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = GridPreviewDrawColumnCell
          OnEditButtonClick = GridPreviewEditButtonClick
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 417
    Width = 622
    Height = 19
    Panels = <>
  end
  object OpenDialogExcel: TOpenDialog
    DefaultExt = '*.xls'
    Filter = #1060#1072#1081#1083#1099' Excel (*.xls)|*.xls|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 55
    Top = 321
  end
  object PopupActionBarPreview: TPopupActionBar
    OnPopup = PopupActionBarPreviewPopup
    Left = 327
    Top = 313
    object MenuItemRefresh: TMenuItem
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ShortCut = 116
      OnClick = MenuItemRefreshClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object MenuItemAddVariant: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1072#1088#1080#1072#1085#1090
      ShortCut = 114
      OnClick = MenuItemAddVariantClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object MenuItemDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ShortCut = 16430
      OnClick = MenuItemDeleteClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuItemClear: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      OnClick = MenuItemClearClick
    end
  end
  object DataSourcePreview: TDataSource
    Left = 167
    Top = 329
  end
  object DataSourcePresentation: TDataSource
    Left = 382
    Top = 117
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 127
    Top = 41
  end
end
