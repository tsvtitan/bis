object dlgCounter: TdlgCounter
  Left = 282
  Top = 226
  BorderStyle = bsDialog
  Caption = 'Properties'
  ClientHeight = 418
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 384
    Width = 401
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object Button1: TButton
      Left = 317
      Top = 2
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Cancel = True
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 401
    Height = 384
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Caption = ' '
    TabOrder = 1
    object pc: TPageControl
      Left = 10
      Top = 10
      Width = 381
      Height = 364
      Cursor = crHandPoint
      ActivePage = tsGeneral
      Align = alClient
      HotTrack = True
      TabOrder = 0
      object tsGeneral: TTabSheet
        Caption = ' General '
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 373
          Height = 336
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object Bevel3: TBevel
            Left = 10
            Top = 42
            Width = 362
            Height = 3
            Anchors = [akLeft, akTop, akRight]
            Shape = bsTopLine
          end
          object lType: TLabel
            Left = 50
            Top = 55
            Width = 28
            Height = 13
            Alignment = taRightJustify
            Caption = 'Type:'
            FocusControl = stType
          end
          object lScale: TLabel
            Left = 12
            Top = 102
            Width = 66
            Height = 13
            Alignment = taRightJustify
            Caption = 'Default scale:'
            FocusControl = stScale
          end
          object lSize: TLabel
            Left = 55
            Top = 79
            Width = 23
            Height = 13
            Alignment = taRightJustify
            Caption = 'Size:'
            FocusControl = stSize
          end
          object lName: TLabel
            Left = 48
            Top = 20
            Width = 31
            Height = 13
            Alignment = taRightJustify
            Caption = 'Name:'
            FocusControl = stName
          end
          object Label1: TLabel
            Left = 14
            Top = 163
            Width = 53
            Height = 13
            Caption = 'Description'
            FocusControl = Memo
          end
          object Bevel1: TBevel
            Left = 9
            Top = 149
            Width = 362
            Height = 3
            Anchors = [akLeft, akTop, akRight]
            Shape = bsTopLine
          end
          object lLevel: TLabel
            Left = 22
            Top = 125
            Width = 56
            Height = 13
            Alignment = taRightJustify
            Caption = 'Detail level:'
          end
          object stLevel: TLabel
            Left = 83
            Top = 125
            Width = 63
            Height = 13
            Caption = 'Not Available'
          end
          object stType: TLabel
            Left = 82
            Top = 55
            Width = 63
            Height = 13
            Caption = 'Not Available'
          end
          object stScale: TLabel
            Left = 82
            Top = 102
            Width = 63
            Height = 13
            Caption = 'Not Available'
          end
          object stSize: TLabel
            Left = 82
            Top = 79
            Width = 63
            Height = 13
            Caption = 'Not Available'
          end
          object stName: TEdit
            Left = 83
            Top = 20
            Width = 283
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            BorderStyle = bsNone
            Font.Charset = EASTEUROPE_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = True
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            Text = 'Name'
          end
          object Memo: TMemo
            Left = 11
            Top = 180
            Width = 351
            Height = 143
            Lines.Strings = (
              ' ')
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 1
          end
        end
      end
      object tsObject: TTabSheet
        Caption = ' Object '
        ImageIndex = 1
        object Bevel2: TBevel
          Left = 10
          Top = 42
          Width = 364
          Height = 3
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object lCntr: TLabel
          Left = 16
          Top = 55
          Width = 79
          Height = 13
          Alignment = taRightJustify
          Caption = 'Default counter:'
          FocusControl = stCntr
        end
        object lLevel1: TLabel
          Left = 39
          Top = 99
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = 'Detail level:'
          FocusControl = stLevel1
        end
        object lInst: TLabel
          Left = 44
          Top = 132
          Width = 51
          Height = 13
          Alignment = taRightJustify
          Caption = 'Instances:'
          FocusControl = stInst
        end
        object lPage: TLabel
          Left = 39
          Top = 77
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = 'Code page:'
          FocusControl = stPage
        end
        object lObjname: TLabel
          Left = 65
          Top = 20
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = 'Name:'
          FocusControl = stObjName
        end
        object Label7: TLabel
          Left = 14
          Top = 239
          Width = 53
          Height = 13
          Caption = 'Description'
          FocusControl = Memo1
        end
        object Bevel4: TBevel
          Left = 9
          Top = 121
          Width = 364
          Height = 3
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object lCtrs: TLabel
          Left = 47
          Top = 153
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = 'Counters:'
          FocusControl = stCtrs
        end
        object Bevel5: TBevel
          Left = 9
          Top = 231
          Width = 364
          Height = 3
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object Bevel6: TBevel
          Left = 12
          Top = 175
          Width = 364
          Height = 3
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object lTime: TLabel
          Left = 69
          Top = 188
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = 'Time:'
          FocusControl = stTime
        end
        object lFreq: TLabel
          Left = 40
          Top = 207
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = 'Frequency:'
          FocusControl = stFreq
        end
        object stLevel1: TLabel
          Left = 98
          Top = 99
          Width = 63
          Height = 13
          Caption = 'Not Available'
        end
        object stObjName: TLabel
          Left = 100
          Top = 20
          Width = 74
          Height = 13
          Caption = 'Not Available'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object stCntr: TLabel
          Left = 98
          Top = 55
          Width = 63
          Height = 13
          Caption = 'Not Available'
        end
        object stInst: TLabel
          Left = 98
          Top = 132
          Width = 63
          Height = 13
          Caption = 'Not Available'
        end
        object stPage: TLabel
          Left = 98
          Top = 77
          Width = 63
          Height = 13
          Caption = 'Not Available'
        end
        object stCtrs: TLabel
          Left = 98
          Top = 153
          Width = 63
          Height = 13
          Caption = 'Not Available'
        end
        object stTime: TLabel
          Left = 98
          Top = 188
          Width = 63
          Height = 13
          Caption = 'Not Available'
        end
        object stFreq: TLabel
          Left = 98
          Top = 207
          Width = 63
          Height = 13
          Caption = 'Not Available'
        end
        object Memo1: TMemo
          Left = 9
          Top = 257
          Width = 355
          Height = 70
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
