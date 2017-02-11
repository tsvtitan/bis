object Form1: TForm1
  Left = 187
  Top = 98
  Caption = 
    'kbmMemTable demo. Created by Components4Developers (www.componen' +
    'ts4developers.com)'
  ClientHeight = 565
  ClientWidth = 762
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 235
    Top = 0
    Width = 527
    Height = 534
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 527
      Height = 383
      Align = alClient
      DataSource = DataSource1
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -10
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object DBNavigator1: TDBNavigator
      Left = 0
      Top = 512
      Width = 527
      Height = 22
      DataSource = DataSource1
      Align = alBottom
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 0
      Top = 383
      Width = 527
      Height = 129
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object DBImage1: TDBImage
        Left = 0
        Top = 0
        Width = 138
        Height = 129
        Align = alLeft
        DataSource = DataSource1
        Stretch = True
        TabOrder = 0
      end
      object DBMemo1: TDBMemo
        Left = 138
        Top = 0
        Width = 204
        Height = 129
        Align = alClient
        TabOrder = 1
      end
      object Panel6: TPanel
        Left = 342
        Top = 0
        Width = 185
        Height = 129
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 2
        object Label34: TLabel
          Left = 8
          Top = 8
          Width = 48
          Height = 13
          Caption = 'BytesField'
        end
        object DBEdit1: TDBEdit
          Left = 8
          Top = 24
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object Button22: TButton
          Left = 8
          Top = 56
          Width = 75
          Height = 25
          Caption = 'Clear Memo'
          TabOrder = 1
          OnClick = Button22Click
        end
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 235
    Height = 534
    ActivePage = TabSheet13
    Align = alLeft
    MultiLine = True
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Basic functionality'
      object Label6: TLabel
        Left = 7
        Top = 7
        Width = 117
        Height = 26
        AutoSize = False
        Caption = 'Define some fields programatically'
        WordWrap = True
      end
      object Label7: TLabel
        Left = 7
        Top = 52
        Width = 130
        Height = 20
        AutoSize = False
        Caption = 'Open the memorytable'
        WordWrap = True
      end
      object Label8: TLabel
        Left = 7
        Top = 85
        Width = 137
        Height = 26
        AutoSize = False
        Caption = 'Close the memorytable'
        WordWrap = True
      end
      object Label9: TLabel
        Left = 7
        Top = 229
        Width = 124
        Height = 20
        AutoSize = False
        Caption = 'Generate sample data'
        WordWrap = True
      end
      object Label25: TLabel
        Left = 8
        Top = 112
        Width = 129
        Height = 33
        AutoSize = False
        Caption = 'Number of records in sample data'
        WordWrap = True
      end
      object Label26: TLabel
        Left = 8
        Top = 432
        Width = 70
        Height = 13
        Caption = 'Recordnumber'
      end
      object lRecNo: TLabel
        Left = 112
        Top = 432
        Width = 3
        Height = 13
        Caption = '-'
      end
      object Label35: TLabel
        Left = 8
        Top = 408
        Width = 54
        Height = 13
        Caption = 'Old VALUE'
      end
      object lOldValue: TLabel
        Left = 112
        Top = 408
        Width = 3
        Height = 13
        Caption = '.'
      end
      object Button6: TButton
        Left = 156
        Top = 7
        Width = 61
        Height = 20
        Caption = 'Def. Fields'
        TabOrder = 0
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 156
        Top = 52
        Width = 61
        Height = 20
        Caption = 'Open'
        TabOrder = 1
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 156
        Top = 85
        Width = 61
        Height = 20
        Caption = 'Close'
        TabOrder = 2
        OnClick = Button8Click
      end
      object Button1: TButton
        Left = 156
        Top = 221
        Width = 61
        Height = 20
        Caption = 'Generate'
        TabOrder = 3
        OnClick = Button1Click
      end
      object eRecordCount: TEdit
        Left = 156
        Top = 112
        Width = 61
        Height = 21
        TabOrder = 4
        Text = '100'
      end
      object chbEnableIndexes: TCheckBox
        Left = 8
        Top = 152
        Width = 137
        Height = 17
        Caption = 'Update indexes'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = chbEnableIndexesClick
      end
      object chbRandomColor: TCheckBox
        Left = 8
        Top = 176
        Width = 97
        Height = 17
        Caption = 'Random COLOR data'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object chbGenerateMemos: TCheckBox
        Left = 8
        Top = 200
        Width = 129
        Height = 17
        Caption = 'Generate memos'
        Checked = True
        State = cbChecked
        TabOrder = 7
      end
      object Button13: TButton
        Left = 128
        Top = 253
        Width = 89
        Height = 20
        Caption = 'AppendRecord'
        TabOrder = 8
        OnClick = Button13Click
      end
      object Button10: TButton
        Left = 142
        Top = 296
        Width = 75
        Height = 17
        Caption = 'Goto 10'
        TabOrder = 9
        OnClick = Button10Click
      end
      object Button25: TButton
        Left = 142
        Top = 331
        Width = 75
        Height = 17
        Caption = 'Pack'
        TabOrder = 10
        OnClick = Button25Click
      end
      object Button26: TButton
        Left = 142
        Top = 361
        Width = 75
        Height = 17
        Caption = 'Empty'
        TabOrder = 11
        OnClick = Button26Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Load/Save'
      object Label19: TLabel
        Left = 13
        Top = 259
        Width = 210
        Height = 30
        AutoSize = False
        Caption = 
          'Check this, press the save above, after always with this checked' +
          ' press Load'
        WordWrap = True
      end
      object lblLZH: TLabel
        Left = 12
        Top = 294
        Width = 5
        Height = 13
        Caption = ' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 72
        Width = 227
        Height = 380
        ActivePage = TabSheet5
        Align = alClient
        TabOrder = 0
        TabPosition = tpBottom
        object TabSheet5: TTabSheet
          Caption = 'Copy, Save, Load'
          object Label1: TLabel
            Left = 7
            Top = 92
            Width = 137
            Height = 26
            AutoSize = False
            Caption = 'Copy structur and data from another datasource.'
            WordWrap = True
          end
          object Label2: TLabel
            Left = 7
            Top = 229
            Width = 137
            Height = 26
            AutoSize = False
            Caption = 'Save contents in a file, incl. blobs'
            WordWrap = True
          end
          object Label3: TLabel
            Left = 7
            Top = 268
            Width = 137
            Height = 26
            AutoSize = False
            Caption = 'Load data from a file'
            WordWrap = True
          end
          object Label20: TLabel
            Left = 6
            Top = 21
            Width = 209
            Height = 61
            AutoSize = False
            Caption = 
              'Check Blob InMemory Compression before loading the table and the' +
              ' Blob fIelds will be transparently de/compressed using less memo' +
              'ry'
            WordWrap = True
          end
          object Button9: TButton
            Left = 156
            Top = 92
            Width = 61
            Height = 19
            Caption = 'Copy'
            TabOrder = 0
            OnClick = Button9Click
          end
          object Button2: TButton
            Left = 156
            Top = 229
            Width = 61
            Height = 19
            Caption = 'Save'
            TabOrder = 1
            OnClick = Button2Click
          end
          object Button3: TButton
            Left = 156
            Top = 268
            Width = 61
            Height = 19
            Caption = 'Load'
            TabOrder = 2
            OnClick = Button3Click
          end
          object BlobCompression: TCheckBox
            Left = 6
            Top = -1
            Width = 204
            Height = 17
            Caption = 'Blob InMemory Compression'
            TabOrder = 3
          end
          object BinarySave: TCheckBox
            Left = 7
            Top = 130
            Width = 143
            Height = 14
            Caption = 'Save/Load as binary'
            TabOrder = 4
            OnClick = BinarySaveClick
          end
          object chbSaveIndexDef: TCheckBox
            Left = 8
            Top = 152
            Width = 201
            Height = 17
            Caption = 'Save index definitions too'
            TabOrder = 5
          end
          object chbSaveDeltas: TCheckBox
            Left = 8
            Top = 176
            Width = 209
            Height = 17
            Caption = 'Save deltas too (only if binary checked)'
            Enabled = False
            TabOrder = 6
          end
          object chbNoQuotes: TCheckBox
            Left = 8
            Top = 200
            Width = 97
            Height = 17
            Caption = 'No quotes'
            TabOrder = 7
          end
        end
        object TabSheet6: TTabSheet
          Caption = 'CommaText'
          object Label4: TLabel
            Left = 7
            Top = 7
            Width = 111
            Height = 59
            AutoSize = False
            Caption = 
              'Save contents in CSV format in the memo. Note that Blobs doesnt ' +
              'get saved.'
            WordWrap = True
          end
          object Label5: TLabel
            Left = 7
            Top = 79
            Width = 111
            Height = 32
            AutoSize = False
            Caption = 'Load contents from CSV formatted memo.'
            WordWrap = True
          end
          object Button4: TButton
            Left = 124
            Top = 27
            Width = 91
            Height = 19
            Caption = 'Get CommaText'
            TabOrder = 0
            OnClick = Button4Click
          end
          object Button5: TButton
            Left = 124
            Top = 85
            Width = 91
            Height = 20
            Caption = 'Set CommaText'
            TabOrder = 1
            OnClick = Button5Click
          end
          object Memo1: TMemo
            Left = 0
            Top = 222
            Width = 219
            Height = 132
            Align = alBottom
            TabOrder = 2
          end
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 227
        Height = 72
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label21: TLabel
          Left = 7
          Top = 23
          Width = 215
          Height = 43
          AutoSize = False
          Caption = 
            'Remember to check this before loading from a compressed file or ' +
            'before saving to a file with compression.'
          WordWrap = True
        end
        object LZHCompressed: TCheckBox
          Left = 6
          Top = 3
          Width = 204
          Height = 17
          Caption = '(De)Compress CSV file/CommaText'
          TabOrder = 0
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Sorting/Searching'
      OnEnter = TabSheet3Enter
      object Label10: TLabel
        Left = 7
        Top = 1
        Width = 124
        Height = 13
        AutoSize = False
        Caption = 'Sort the table on'
        WordWrap = True
      end
      object Label12: TLabel
        Left = 7
        Top = 100
        Width = 137
        Height = 20
        AutoSize = False
        Caption = 'What to search for'
        WordWrap = True
      end
      object Label13: TLabel
        Left = 7
        Top = 126
        Width = 91
        Height = 26
        AutoSize = False
        Caption = 'Locate for PERIOD'
        WordWrap = True
      end
      object Label14: TLabel
        Left = 7
        Top = 163
        Width = 91
        Height = 40
        AutoSize = False
        Caption = 'Locate for VALUE. If sorted will do binary locate.'
        WordWrap = True
      end
      object Label15: TLabel
        Left = 7
        Top = 214
        Width = 91
        Height = 26
        AutoSize = False
        Caption = 'Locate for CALC'
        WordWrap = True
      end
      object Label16: TLabel
        Left = 7
        Top = 307
        Width = 91
        Height = 27
        AutoSize = False
        Caption = 'Lookup for PERIOD'
        WordWrap = True
      end
      object Label17: TLabel
        Left = 7
        Top = 340
        Width = 137
        Height = 20
        AutoSize = False
        Caption = 'What has been looked up'
        WordWrap = True
      end
      object Label24: TLabel
        Left = 8
        Top = 248
        Width = 95
        Height = 13
        Caption = 'FindNearest VALUE'
      end
      object Label47: TLabel
        Left = 8
        Top = 280
        Width = 76
        Height = 13
        Caption = 'FindKey VALUE'
      end
      object Button11: TButton
        Left = 152
        Top = 15
        Width = 61
        Height = 20
        Caption = 'Sort'
        TabOrder = 0
        OnClick = Button11Click
      end
      object btnLocatePeriod: TButton
        Left = 111
        Top = 125
        Width = 102
        Height = 21
        Caption = 'Locate Period'
        TabOrder = 5
        OnClick = btnLocatePeriodClick
      end
      object eSearch: TEdit
        Left = 156
        Top = 100
        Width = 57
        Height = 21
        TabOrder = 4
      end
      object btnLocateValue: TButton
        Left = 111
        Top = 169
        Width = 102
        Height = 22
        Caption = 'Locate Value'
        TabOrder = 6
        OnClick = btnLocateValueClick
      end
      object chbCaseInsensitive: TCheckBox
        Left = 7
        Top = 54
        Width = 162
        Height = 17
        Caption = 'CaseInsensitive'
        TabOrder = 2
      end
      object chbPartialKey: TCheckBox
        Left = 7
        Top = 74
        Width = 97
        Height = 17
        Caption = 'PartialKey'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object btnLookupCalc: TButton
        Left = 111
        Top = 305
        Width = 102
        Height = 22
        Caption = 'Period->Calc'
        TabOrder = 8
        OnClick = btnLookupCalcClick
      end
      object btnLocateCalc: TButton
        Left = 111
        Top = 206
        Width = 102
        Height = 21
        Caption = 'Locate CALC'
        TabOrder = 7
        OnClick = btnLocateCalcClick
      end
      object eResult: TEdit
        Left = 156
        Top = 333
        Width = 57
        Height = 21
        TabOrder = 9
      end
      object chbDescending: TCheckBox
        Left = 7
        Top = 39
        Width = 78
        Height = 14
        Caption = 'Descending'
        TabOrder = 1
      end
      object cbSortField: TComboBox
        Left = 7
        Top = 13
        Width = 91
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 10
      end
      object btnFindNearest: TButton
        Left = 111
        Top = 240
        Width = 102
        Height = 21
        Caption = 'FindNearest'
        TabOrder = 11
        OnClick = btnFindNearestClick
      end
      object Button23: TButton
        Left = 111
        Top = 272
        Width = 102
        Height = 21
        Caption = 'FindKey'
        TabOrder = 12
        OnClick = Button23Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Master/Detail'
      object DBGrid2: TDBGrid
        Left = 0
        Top = 144
        Width = 227
        Height = 264
        Align = alClient
        DataSource = dsMaster
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -10
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 227
        Height = 144
        Align = alTop
        BevelOuter = bvLowered
        TabOrder = 1
        object Label18: TLabel
          Left = 7
          Top = 7
          Width = 215
          Height = 91
          AutoSize = False
          Caption = 
            'This shows masterdetail relations, by using a TTable as master, ' +
            'and copying the contents of another TTable into the memory table' +
            ' and then specifying mastersource/fields and indexfields on the ' +
            'memory table.'
          WordWrap = True
        end
        object Button12: TButton
          Left = 39
          Top = 111
          Width = 150
          Height = 20
          Caption = 'Open Master/Detail'
          TabOrder = 0
          OnClick = Button12Click
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 433
        Width = 227
        Height = 19
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 2
        object Label27: TLabel
          Left = 8
          Top = 4
          Width = 35
          Height = 13
          Caption = 'Rec.no'
        end
        object lMasterRecNo: TLabel
          Left = 88
          Top = 4
          Width = 3
          Height = 13
          Caption = '-'
        end
      end
      object DBNavigator2: TDBNavigator
        Left = 0
        Top = 408
        Width = 227
        Height = 25
        DataSource = dsMaster
        Align = alBottom
        TabOrder = 3
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Bookmarks'
      ImageIndex = 4
      object Label11: TLabel
        Left = 104
        Top = 0
        Width = 121
        Height = 57
        AutoSize = False
        Caption = 
          'Gets a bookmark which can be used to reposition to the same plac' +
          'e later'
        WordWrap = True
      end
      object Label29: TLabel
        Left = 104
        Top = 56
        Width = 121
        Height = 65
        AutoSize = False
        Caption = 'Goto the bookmark retrieved by Get Bookmark'
        WordWrap = True
      end
      object btnGetBookmark: TButton
        Left = 8
        Top = 8
        Width = 89
        Height = 25
        Caption = 'Get bookmark'
        TabOrder = 0
        OnClick = btnGetBookmarkClick
      end
      object btnGotoBookmark: TButton
        Left = 8
        Top = 56
        Width = 89
        Height = 25
        Caption = 'Goto bookmark'
        TabOrder = 1
        OnClick = btnGotoBookmarkClick
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Indexes'
      ImageIndex = 5
      OnEnter = TabSheet8Enter
      object Label30: TLabel
        Left = 104
        Top = 16
        Width = 113
        Height = 25
        AutoSize = False
        Caption = 'Rebuild all defined indexes.'
        WordWrap = True
      end
      object Label31: TLabel
        Left = 8
        Top = 56
        Width = 121
        Height = 17
        AutoSize = False
        Caption = 'Specify index to use.'
        WordWrap = True
      end
      object Label32: TLabel
        Left = 120
        Top = 160
        Width = 105
        Height = 17
        AutoSize = False
        Caption = 'Add COLOR index.'
        WordWrap = True
      end
      object Label33: TLabel
        Left = 120
        Top = 224
        Width = 105
        Height = 17
        AutoSize = False
        Caption = 'Delete COLOR index.'
        WordWrap = True
      end
      object Label48: TLabel
        Left = 120
        Top = 192
        Width = 105
        Height = 17
        AutoSize = False
        Caption = 'Add index Period<70'
        WordWrap = True
      end
      object btnRebuildIdx: TButton
        Left = 8
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Rebuild'
        TabOrder = 0
        OnClick = btnRebuildIdxClick
      end
      object cbIndexes: TComboBox
        Left = 8
        Top = 72
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbIndexesChange
      end
      object btnAddIndex: TButton
        Left = 8
        Top = 152
        Width = 75
        Height = 25
        Caption = 'Add Index'
        TabOrder = 2
        OnClick = btnAddIndexClick
      end
      object btnDeleteIndex: TButton
        Left = 8
        Top = 216
        Width = 75
        Height = 25
        Caption = 'Delete Index'
        TabOrder = 3
        OnClick = btnDeleteIndexClick
      end
      object chbColorUnique: TCheckBox
        Left = 8
        Top = 104
        Width = 97
        Height = 17
        Caption = 'Unique index'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object chbColorDescending: TCheckBox
        Left = 8
        Top = 128
        Width = 97
        Height = 17
        Caption = 'Descending'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object Button24: TButton
        Left = 8
        Top = 184
        Width = 97
        Height = 25
        Caption = 'Add filtered Index'
        TabOrder = 6
        OnClick = Button24Click
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'Versioning'
      ImageIndex = 7
      object Label36: TLabel
        Left = 96
        Top = 16
        Width = 121
        Height = 57
        AutoSize = False
        Caption = 
          'Define the base for versioning. Only changes from this checkpoin' +
          't will be versioned.'
        WordWrap = True
      end
      object Label37: TLabel
        Left = 96
        Top = 144
        Width = 129
        Height = 41
        AutoSize = False
        Caption = 'Save versioning delta to the file '#39'c:\deltas.dat'#39'.'
        WordWrap = True
      end
      object Label38: TLabel
        Left = 96
        Top = 192
        Width = 129
        Height = 65
        AutoSize = False
        Caption = 
          'If checked keep all versions of a record, otherwise keep only ne' +
          'west and original.'
        WordWrap = True
      end
      object Label39: TLabel
        Left = 96
        Top = 80
        Width = 121
        Height = 57
        AutoSize = False
        Caption = 'Using the TDemoDeltaHandler resolves all changes.'
        WordWrap = True
      end
      object Button14: TButton
        Left = 8
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Checkpoint'
        TabOrder = 0
        OnClick = Button14Click
      end
      object chbVersionAll: TCheckBox
        Left = 8
        Top = 200
        Width = 73
        Height = 17
        TabOrder = 1
        OnClick = chbVersionAllClick
      end
      object Button15: TButton
        Left = 8
        Top = 144
        Width = 75
        Height = 25
        Caption = 'Save'
        TabOrder = 2
        OnClick = Button15Click
      end
      object Button16: TButton
        Left = 8
        Top = 80
        Width = 75
        Height = 25
        Caption = 'Resolve'
        TabOrder = 3
        OnClick = Button16Click
      end
    end
    object TabSheet11: TTabSheet
      Caption = 'Snapshots'
      ImageIndex = 8
      object Label40: TLabel
        Left = 128
        Top = 16
        Width = 97
        Height = 49
        AutoSize = False
        Caption = 'Get a snapshot into a variant variable.'
        WordWrap = True
      end
      object Label41: TLabel
        Left = 128
        Top = 72
        Width = 97
        Height = 49
        AutoSize = False
        Caption = 'Set the table contents from a snapshot.'
        WordWrap = True
      end
      object Button17: TButton
        Left = 8
        Top = 16
        Width = 113
        Height = 25
        Caption = 'Save to snapshot'
        TabOrder = 0
        OnClick = Button17Click
      end
      object Button18: TButton
        Left = 8
        Top = 72
        Width = 113
        Height = 25
        Caption = 'Load from snapshot'
        TabOrder = 1
        OnClick = Button18Click
      end
    end
    object TabSheet12: TTabSheet
      Caption = 'Transactions'
      ImageIndex = 9
      object Label42: TLabel
        Left = 8
        Top = 416
        Width = 81
        Height = 13
        Caption = 'Transaction level'
      end
      object lTransactionLevel: TLabel
        Left = 128
        Top = 416
        Width = 20
        Height = 13
        Caption = 'N/A'
      end
      object Label43: TLabel
        Left = 120
        Top = 8
        Width = 105
        Height = 153
        AutoSize = False
        Caption = 
          'Starts a new transaction (several transactions can be active at ' +
          'the same time but remember to commit or rollback as many times a' +
          's you have started a transaction.'
        WordWrap = True
      end
      object Label44: TLabel
        Left = 122
        Top = 168
        Width = 105
        Height = 65
        AutoSize = False
        Caption = 'Keep the changes made since last start transaction.'
        WordWrap = True
      end
      object Label45: TLabel
        Left = 122
        Top = 240
        Width = 105
        Height = 57
        AutoSize = False
        Caption = 'Discard all changes made since start transaction.'
        WordWrap = True
      end
      object Button19: TButton
        Left = 8
        Top = 8
        Width = 97
        Height = 25
        Caption = 'Start transaction'
        TabOrder = 0
        OnClick = Button19Click
      end
      object Button20: TButton
        Left = 8
        Top = 168
        Width = 75
        Height = 25
        Caption = 'Commit'
        TabOrder = 1
        OnClick = Button20Click
      end
      object Button21: TButton
        Left = 8
        Top = 240
        Width = 75
        Height = 25
        Caption = 'Rollback'
        TabOrder = 2
        OnClick = Button21Click
      end
    end
    object TabSheet13: TTabSheet
      Caption = 'Filtering/Ranges'
      ImageIndex = 10
      object Label28: TLabel
        Left = 8
        Top = 8
        Width = 22
        Height = 13
        Caption = 'Filter'
      end
      object Label22: TLabel
        Left = 8
        Top = 72
        Width = 97
        Height = 33
        AutoSize = False
        Caption = 'Set range where 50<Period<70'
        WordWrap = True
      end
      object Label23: TLabel
        Left = 8
        Top = 112
        Width = 63
        Height = 13
        Caption = 'Cancel range'
      end
      object eFilter: TEdit
        Left = 52
        Top = 8
        Width = 161
        Height = 21
        TabOrder = 0
        Text = 'PERIOD>10'
      end
      object TableFilteredCheckBox: TCheckBox
        Left = 7
        Top = 35
        Width = 82
        Height = 17
        Caption = 'Use Filter'
        TabOrder = 1
        Visible = False
        OnClick = TableFilteredCheckBoxClick
      end
      object btnSetFilter: TButton
        Left = 116
        Top = 32
        Width = 97
        Height = 21
        Caption = 'Set filter'
        TabOrder = 2
        OnClick = btnSetFilterClick
      end
      object btnSetRange: TButton
        Left = 136
        Top = 72
        Width = 75
        Height = 22
        Caption = 'Set range'
        TabOrder = 3
        OnClick = btnSetRangeClick
      end
      object btnCancelRange: TButton
        Left = 136
        Top = 104
        Width = 75
        Height = 22
        Caption = 'Cancel range'
        TabOrder = 4
        OnClick = btnCancelRangeClick
      end
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 534
    Width = 762
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Label46: TLabel
      Left = 8
      Top = 8
      Width = 44
      Height = 13
      Caption = 'Progress:'
    end
    object lProgress: TLabel
      Left = 64
      Top = 8
      Width = 20
      Height = 13
      Caption = 'N/A'
    end
  end
  object DataSource1: TDataSource
    DataSet = kbmMemTable1
    Left = 296
    Top = 352
  end
  object kbmMemTable1: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
    FieldDefs = <>
    AutoReposition = True
    IndexDefs = <>
    SortOptions = []
    Performance = mtpfSmall
    PersistentFile = 'testfil.txt'
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    EnableVersioning = True
    VersioningMode = mtvmAllSinceCheckPoint
    FilterOptions = [foNoPartialCompare]
    Version = '5.51'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    OnProgress = kbmMemTable1Progress
    OnCompressBlobStream = kbmMemTable1CompressBlobStream
    OnDecompressBlobStream = kbmMemTable1DecompressBlobStream
    AfterEdit = kbmMemTable1AfterEdit
    AfterPost = kbmMemTable1AfterScroll
    AfterScroll = kbmMemTable1AfterScroll
    OnCalcFields = MemTable1CalcFields
    OnFilterRecord = kbmMemTable1FilterRecord
    Left = 296
    Top = 384
  end
  object Table1: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'BIOLIFE.DB'
    Left = 328
    Top = 384
  end
  object tMaster: TTable
    AfterScroll = tMasterAfterScroll
    DatabaseName = 'DBDEMOS'
    TableName = 'customer.db'
    Left = 296
    Top = 288
  end
  object dsMaster: TDataSource
    DataSet = tMaster
    Left = 328
    Top = 288
  end
  object tDetailTemplate: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'orders.db'
    Left = 296
    Top = 320
  end
  object sfBinary: TkbmBinaryStreamFormat
    Version = '3.00'
    sfUsingIndex = [sfSaveUsingIndex]
    sfData = [sfSaveData, sfLoadData]
    sfCalculated = []
    sfLookup = []
    sfNonVisible = [sfSaveNonVisible, sfLoadNonVisible]
    sfBlobs = [sfSaveBlobs, sfLoadBlobs]
    sfDef = [sfSaveDef, sfLoadDef]
    sfIndexDef = [sfSaveIndexDef, sfLoadIndexDef]
    sfFiltered = [sfSaveFiltered]
    sfIgnoreRange = [sfSaveIgnoreRange]
    sfIgnoreMasterDetail = [sfSaveIgnoreMasterDetail]
    sfDeltas = []
    sfDontFilterDeltas = []
    sfAppend = []
    sfFieldKind = [sfSaveFieldKind]
    sfFromStart = [sfLoadFromStart]
    sfDataTypeHeader = [sfSaveDataTypeHeader, sfLoadDataTypeHeader]
    OnCompress = sfBinaryCompress
    OnDeCompress = sfBinaryDeCompress
    BufferSize = 16384
    Left = 299
    Top = 415
  end
  object sfCSV: TkbmCSVStreamFormat
    CSVQuote = '"'
    CSVFieldDelimiter = ','
    CSVRecordDelimiter = ','
    CSVTrueString = 'True'
    CSVFalseString = 'False'
    sfLocalFormat = []
    sfQuoteOnlyStrings = []
    sfNoHeader = []
    Version = '3.00'
    sfData = [sfSaveData, sfLoadData]
    sfCalculated = []
    sfLookup = []
    sfNonVisible = [sfSaveNonVisible, sfLoadNonVisible]
    sfBlobs = [sfSaveBlobs, sfLoadBlobs]
    sfDef = [sfSaveDef, sfLoadDef]
    sfIndexDef = [sfSaveIndexDef, sfLoadIndexDef]
    sfPlaceHolders = []
    sfFiltered = [sfSaveFiltered]
    sfIgnoreRange = [sfSaveIgnoreRange]
    sfIgnoreMasterDetail = [sfSaveIgnoreMasterDetail]
    sfDeltas = []
    sfDontFilterDeltas = []
    sfAppend = []
    sfFieldKind = [sfSaveFieldKind]
    sfFromStart = [sfLoadFromStart]
    OnCompress = sfBinaryCompress
    OnDeCompress = sfBinaryDeCompress
    Left = 331
    Top = 415
  end
  object sfBinaryWithDeltas: TkbmBinaryStreamFormat
    Version = '3.00'
    sfUsingIndex = [sfSaveUsingIndex]
    sfData = [sfSaveData, sfLoadData]
    sfCalculated = []
    sfLookup = []
    sfNonVisible = [sfSaveNonVisible, sfLoadNonVisible]
    sfBlobs = [sfSaveBlobs, sfLoadBlobs]
    sfDef = [sfSaveDef, sfLoadDef]
    sfIndexDef = [sfSaveIndexDef, sfLoadIndexDef]
    sfFiltered = [sfSaveFiltered]
    sfIgnoreRange = [sfSaveIgnoreRange]
    sfIgnoreMasterDetail = [sfSaveIgnoreMasterDetail]
    sfDeltas = [sfSaveDeltas]
    sfDontFilterDeltas = []
    sfAppend = []
    sfFieldKind = [sfSaveFieldKind]
    sfFromStart = [sfLoadFromStart]
    sfDataTypeHeader = [sfSaveDataTypeHeader, sfLoadDataTypeHeader]
    OnCompress = sfBinaryCompress
    OnDeCompress = sfBinaryDeCompress
    BufferSize = 16384
    Left = 363
    Top = 415
  end
end
