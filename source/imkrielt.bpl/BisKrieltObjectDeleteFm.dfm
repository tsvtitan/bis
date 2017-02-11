inherited BisKrieltObjectDeleteForm: TBisKrieltObjectDeleteForm
  Left = 399
  Top = 211
  ActiveControl = ComboBoxTypeDelete
  Caption = 'BisKrieltObjectDeleteForm'
  ClientHeight = 373
  ClientWidth = 597
  ExplicitWidth = 605
  ExplicitHeight = 407
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 335
    Width = 597
    ExplicitTop = 335
    ExplicitWidth = 597
    inherited ButtonOk: TButton
      Left = 420
      ExplicitLeft = 420
    end
    inherited ButtonCancel: TButton
      Left = 517
      ExplicitLeft = 517
    end
  end
  inherited PanelControls: TPanel
    Width = 597
    Height = 335
    ExplicitWidth = 597
    ExplicitHeight = 335
    object LabelPublishing: TLabel
      Left = 47
      Top = 11
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1079#1076#1072#1085#1080#1077':'
      FocusControl = EditPublishing
    end
    object LabelTypeDelete: TLabel
      Left = 281
      Top = 313
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1058#1080#1087' '#1091#1076#1072#1083#1077#1085#1080#1103':'
      FocusControl = ComboBoxTypeDelete
    end
    object LabelDateBegin: TLabel
      Left = 346
      Top = 65
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelAccount: TLabel
      Left = 337
      Top = 11
      Width = 78
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1090#1086' '#1088#1072#1079#1084#1077#1089#1090#1080#1083':'
      FocusControl = EditAccount
    end
    object LabelView: TLabel
      Left = 19
      Top = 38
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditView
    end
    object LabelType: TLabel
      Left = 20
      Top = 65
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditType
    end
    object LabelOperation: TLabel
      Left = 40
      Top = 92
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
      FocusControl = EditOperation
    end
    object LabelDateEnd: TLabel
      Left = 328
      Top = 92
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelEmail: TLabel
      Left = 311
      Top = 38
      Width = 104
      Height = 13
      Alignment = taRightJustify
      Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072':'
      FocusControl = EditEmail
    end
    object EditPublishing: TEdit
      Left = 100
      Top = 8
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonPublishing: TButton
      Left = 274
      Top = 8
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079#1076#1072#1085#1080#1077
      Caption = '...'
      TabOrder = 1
    end
    object ComboBoxTypeDelete: TComboBox
      Left = 361
      Top = 310
      Width = 228
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 16
      Items.Strings = (
        #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1089' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077#1084
        #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1073#1077#1079' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
        #1059#1076#1072#1083#1077#1085#1080#1077' '#1089#1086#1074#1089#1077#1084)
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 421
      Top = 62
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 11
    end
    object EditAccount: TEdit
      Left = 421
      Top = 8
      Width = 141
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 8
    end
    object ButtonAccount: TButton
      Left = 568
      Top = 8
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 9
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 515
      Top = 62
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 12
    end
    object EditView: TEdit
      Left = 100
      Top = 35
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonView: TButton
      Left = 274
      Top = 35
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076
      Caption = '...'
      TabOrder = 3
    end
    object EditType: TEdit
      Left = 100
      Top = 62
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonType: TButton
      Left = 274
      Top = 62
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087
      Caption = '...'
      TabOrder = 5
    end
    object EditOperation: TEdit
      Left = 100
      Top = 89
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonOperation: TButton
      Left = 274
      Top = 89
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 7
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 421
      Top = 89
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 13
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 515
      Top = 89
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 14
    end
    object EditEmail: TEdit
      Left = 421
      Top = 35
      Width = 168
      Height = 21
      MaxLength = 100
      TabOrder = 10
    end
    object GroupBoxNotify: TGroupBox
      Left = 100
      Top = 116
      Width = 489
      Height = 188
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077'  '
      TabOrder = 15
      object MemoNotify: TMemo
        AlignWithMargins = True
        Left = 7
        Top = 47
        Width = 475
        Height = 134
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        Lines.Strings = (
          #1059#1074#1072#1078#1072#1077#1084#1099#1081'('#1072#1103') %ACCOUNT_NAME,'
          ''
          
            #1042#1072#1096#1077' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1077', '#1087#1086#1076#1072#1085#1085#1086#1077' %DATE_BEGIN '#1085#1072' '#1089#1072#1081#1090' http://krasrielt.r' +
            'u'
          #1073#1099#1083#1086' '#1091#1076#1072#1083#1077#1085#1086' '#1087#1086' '#1087#1088#1080#1095#1080#1085#1077' '#1085#1077#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1103' '#1091#1089#1083#1086#1074#1080#1103#1084' '#1087#1086#1076#1072#1095#1080'.'
          ''
          
            #1044#1083#1103' '#1086#1079#1085#1072#1082#1086#1084#1083#1077#1085#1080#1103' '#1089' '#1055#1056#1040#1042#1048#1051#1040#1052#1048' '#1055#1054#1044#1040#1063#1048' '#1054#1041#1066#1071#1042#1051#1045#1053#1048#1049' '#1087#1077#1088#1077#1081#1076#1080#1090#1077' '#1087#1086' '#1089#1089#1099#1083 +
            #1082#1077':'
          'http://krasrielt.ru/rules.php'
          ''
          #1042#1072#1096#1077' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1077':'
          '======================='
          #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074': %VIEW_NAME'
          #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074': %TYPE_NAME'
          #1054#1087#1077#1088#1072#1094#1080#1103': %OPERATION_NAME'
          '%DETAIL'
          ''
          #1053#1077#1074#1077#1088#1085#1086' '#1091#1082#1072#1079#1072#1085#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099':'
          '========================='
          
            '('#1054#1087#1077#1088#1072#1090#1086#1088#1086#1084' '#1091#1076#1072#1083#1103#1102#1090#1089#1103' '#1074#1077#1088#1085#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1080' '#1086#1089#1090#1072#1074#1083#1103#1102#1090#1089#1103' ' +
            #1085#1077#1074#1077#1088#1085#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1085#1099#1077')'
          #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074': %VIEW_NAME'
          #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074': %TYPE_NAME'
          #1054#1087#1077#1088#1072#1094#1080#1103': %OPERATION_NAME'
          '%DETAIL'
          ''
          
            #1042' '#1089#1083#1091#1095#1072#1077', '#1077#1089#1083#1080' '#1085#1077#1074#1077#1088#1085#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1086' '#1087#1086#1083#1077' '#1055#1056#1048#1052#1045#1063#1040#1053#1048#1045', '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1089 +
            #1083#1077#1076#1091#1102#1097#1080#1081' '#1096#1072#1073#1083#1086#1085':'
          ''
          
            #1042' '#1055#1056#1048#1052#1045#1063#1040#1053#1048#1048' '#1091#1082#1072#1079#1072#1085#1099' '#1087#1072#1088#1072#1084#1077#1090#1088#1099', '#1082#1086#1090#1086#1088#1099#1077' '#1076#1086#1083#1078#1085#1099' '#1073#1099#1090#1100' '#1074#1085#1077#1089#1077#1085#1099' '#1074' '#1089#1086 +
            #1086#1090#1074#1077#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1087#1086#1083#1103'.'
          ''
          
            #1044#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1080' '#1087#1086#1074#1090#1086#1088#1085#1086#1075#1086' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1103' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1103' '#1087#1077#1088#1077#1081#1076#1080#1090#1077' ' +
            #1087#1086' '#1089#1089#1099#1083#1082#1077':'
          
            'http://www.krasrielt.ru/descr.php?object_id=%OBJECT_ID&account_i' +
            'd=%ACCOUNT_ID'
          '   '
          ''
          '%ADMIN_NAME,'
          #1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088' '#1089#1072#1081#1090#1072','
          'email: %ADMIN_EMAIL'
          #1058#1077#1083#1077#1092#1086#1085' '#1075#1086#1088#1103#1095#1077#1081' '#1083#1080#1085#1080#1080': 8 (3912) 65-55-77')
        ScrollBars = ssBoth
        TabOrder = 1
        OnKeyDown = MemoNotifyKeyDown
      end
      object PanelSubject: TPanel
        Left = 2
        Top = 15
        Width = 485
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object LabelSubject: TLabel
          Left = 14
          Top = 8
          Width = 28
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1077#1084#1072':'
          FocusControl = EditSubject
        end
        object EditSubject: TEdit
          Left = 48
          Top = 5
          Width = 266
          Height = 21
          MaxLength = 100
          TabOrder = 0
          Text = #1059#1076#1072#1083#1077#1085#1080#1077' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1103' '#1089' '#1089#1072#1081#1090#1072' krasrielt.ru'
        end
      end
    end
  end
end
