object fmGenDelphiCode: TfmGenDelphiCode
  Left = 192
  Top = 106
  AutoScroll = False
  Caption = 'Generate Delphi Code'
  ClientHeight = 283
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  ShowHint = True
  OnShow = FormShow
  DesignSize = (
    583
    283)
  PixelsPerInch = 120
  TextHeight = 16
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 49
    Height = 16
    Caption = 'Classes'
  end
  object Label3: TLabel
    Left = 160
    Top = 8
    Width = 119
    Height = 16
    Caption = 'Function/Procedure'
  end
  object sbtnClassesAll: TSpeedButton
    Left = 8
    Top = 219
    Width = 23
    Height = 22
    Hint = 'Check all'
    Anchors = [akLeft, akBottom]
    Caption = 'All'
    OnClick = sbtnClassesAllClick
  end
  object sbtnClassesNone: TSpeedButton
    Left = 32
    Top = 219
    Width = 41
    Height = 22
    Hint = 'Uncheck all'
    Anchors = [akLeft, akBottom]
    Caption = 'None'
    OnClick = sbtnClassesNoneClick
  end
  object sbtnClassesToggle: TSpeedButton
    Left = 74
    Top = 219
    Width = 49
    Height = 22
    Hint = 'Toggle check selections'
    Anchors = [akLeft, akBottom]
    Caption = 'Invert'
    OnClick = sbtnClassesToggleClick
  end
  object sbtnFuncAll: TSpeedButton
    Left = 160
    Top = 219
    Width = 23
    Height = 22
    Hint = 'Check all'
    Anchors = [akLeft, akBottom]
    Caption = 'All'
    OnClick = sbtnFuncAllClick
  end
  object sbtnFuncNone: TSpeedButton
    Left = 184
    Top = 219
    Width = 41
    Height = 22
    Hint = 'Uncheck all'
    Anchors = [akLeft, akBottom]
    Caption = 'None'
    OnClick = sbtnFuncNoneClick
  end
  object sbtnFuncToggle: TSpeedButton
    Left = 226
    Top = 219
    Width = 49
    Height = 22
    Hint = 'Toggle check selections'
    Anchors = [akLeft, akBottom]
    Caption = 'Invert'
    OnClick = sbtnFuncToggleClick
  end
  object btnGenerate: TButton
    Left = 187
    Top = 249
    Width = 75
    Height = 25
    Hint = 'Generate or synch the code in Delphi'
    Anchors = [akLeft, akBottom]
    Caption = '&Generate!'
    TabOrder = 3
    OnClick = btnGenerateClick
  end
  object grpCodeOptions: TGroupBox
    Left = 311
    Top = 16
    Width = 267
    Height = 225
    Anchors = [akTop, akRight]
    Caption = 'Code Options:'
    TabOrder = 2
    object Label1: TLabel
      Left = 39
      Top = 180
      Width = 89
      Height = 16
      Caption = 'Variable prefix:'
    end
    object Bevel1: TBevel
      Left = 8
      Top = 51
      Width = 209
      Height = 6
      Shape = bsTopLine
    end
    object rbtnWrapped: TRadioButton
      Left = 8
      Top = 56
      Width = 145
      Height = 17
      Hint = 
        'Generate wrapper code to wrap the script call to a matching one ' +
        'in Delphi.'
      Caption = 'Wrap Existing Code'
      TabOrder = 2
      OnClick = UpdateCheckStates
    end
    object rbtnCreateUpdate: TRadioButton
      Left = 8
      Top = 96
      Width = 249
      Height = 17
      Hint = 
        'Create code in Delphi without attempting to wrap to an existing ' +
        'call.'
      Caption = 'Create/Synch procedures in script unit'
      Checked = True
      TabOrder = 4
      TabStop = True
      OnClick = UpdateCheckStates
    end
    object chkVarDeclaration: TCheckBox
      Left = 24
      Top = 112
      Width = 225
      Height = 17
      Caption = 'Declare parameters as variables'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = UpdateCheckStates
    end
    object chkOnlyNeededParams: TCheckBox
      Left = 40
      Top = 128
      Width = 217
      Height = 17
      Caption = 'Only declare for needed params'
      TabOrder = 6
    end
    object chkScriptCall: TCheckBox
      Left = 8
      Top = 32
      Width = 225
      Height = 17
      Hint = 
        'Inserts a comment that is the script function being represented ' +
        'in the event.'
      Caption = 'Insert comment showing script call'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chkVarAssign: TCheckBox
      Left = 40
      Top = 144
      Width = 193
      Height = 17
      Hint = 'Do variable assignement (Script var to Delphi var).'
      Caption = 'Assign script variable values '
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object chkVarRevAssign: TCheckBox
      Left = 40
      Top = 160
      Width = 209
      Height = 17
      Hint = 'Create a reverse assignement (Delphi var to script var).'
      Caption = 'Reverse variable assignments'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object edVarPrefix: TEdit
      Left = 136
      Top = 176
      Width = 73
      Height = 24
      TabOrder = 9
    end
    object chkAssertWrappedCall: TCheckBox
      Left = 24
      Top = 72
      Width = 233
      Height = 17
      Hint = 'Add assertions to test the object being operated on.'
      Caption = 'Create Assertions for object validity'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object rbtnClearEvent: TRadioButton
      Left = 8
      Top = 200
      Width = 257
      Height = 17
      Hint = 'Removes all code from the event. '
      Caption = 'Clear Delphi Event Code (experimental)'
      TabOrder = 10
      OnClick = UpdateCheckStates
    end
    object chkScriptComments: TCheckBox
      Left = 8
      Top = 16
      Width = 209
      Height = 17
      Hint = 
        'Inserts comment tags used to update the code when generating for' +
        ' an existing event.'
      Caption = 'Include synching comment tags'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
  object btnClose: TButton
    Left = 275
    Top = 249
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object clbClasses: TCheckListBox
    Left = 8
    Top = 24
    Width = 145
    Height = 194
    Hint = 'Classes to generate/synch code.'
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 16
    TabOrder = 0
  end
  object clbFuncs: TCheckListBox
    Left = 160
    Top = 24
    Width = 145
    Height = 194
    Hint = 'Functions to generate/synch code.'
    Anchors = [akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 1
  end
end
