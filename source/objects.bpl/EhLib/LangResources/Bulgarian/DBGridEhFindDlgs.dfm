object DBGridEhFindDlg: TDBGridEhFindDlg
  Left = 278
  Top = 124
  BorderStyle = bsDialog
  Caption = '������� �� �����'
  ClientHeight = 124
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 12
    Width = 93
    Height = 13
    Caption = '����� �� �������:'
  end
  object Label2: TLabel
    Left = 7
    Top = 35
    Width = 44
    Height = 13
    Caption = '����� �:'
  end
  object cbMatchType: TLabel
    Left = 7
    Top = 58
    Width = 65
    Height = 13
    Caption = '����������:'
  end
  object Label3: TLabel
    Left = 7
    Top = 82
    Width = 41
    Height = 13
    Caption = '������:'
  end
  object cbText: TDBComboBoxEh
    Left = 104
    Top = 9
    Width = 300
    Height = 21
    DropDownBox.Rows = 17
    DropDownBox.Sizable = True
    EditButtons = <>
    TabOrder = 0
    Text = 'cbText'
    Visible = True
    OnChange = cbTextChange
  end
  object bFind: TButton
    Left = 413
    Top = 9
    Width = 82
    Height = 23
    Caption = '����� �����'
    TabOrder = 6
    OnClick = bFindClick
  end
  object bCancel: TButton
    Left = 413
    Top = 37
    Width = 82
    Height = 22
    Cancel = True
    Caption = '�����'
    ModalResult = 2
    TabOrder = 7
    OnClick = bCancelClick
  end
  object cbFindIn: TDBComboBoxEh
    Left = 104
    Top = 32
    Width = 192
    Height = 21
    DropDownBox.Rows = 17
    DropDownBox.Sizable = True
    EditButtons = <>
    TabOrder = 1
    Text = 'cbFindIn'
    Visible = True
    OnChange = cbFindInChange
  end
  object cbMatchinType: TDBComboBoxEh
    Left = 104
    Top = 55
    Width = 161
    Height = 21
    EditButtons = <>
    Items.Strings = (
      '�� ����� ���� �� ������'
      '������ ����'
      '�� �������� �� ������')
    KeyItems.Strings = (
      '�� ����� ���� �� ������'
      '������ ����'
      '�� �������� �� ������')
    TabOrder = 2
    Text = '�� ����� ���� �� ������'
    Visible = True
  end
  object cbFindDirection: TDBComboBoxEh
    Left = 104
    Top = 79
    Width = 144
    Height = 21
    EditButtons = <>
    Items.Strings = (
      '������'
      '������'
      '�����')
    KeyItems.Strings = (
      '������'
      '������'
      '�����')
    TabOrder = 3
    Text = '�����'
    Visible = True
    OnChange = cbTextChange
  end
  object cbCharCase: TDBCheckBoxEh
    Left = 64
    Top = 105
    Width = 209
    Height = 14
    Caption = '������������ �����/������ &�����'
    TabOrder = 4
    TabStop = True
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbUseFormat: TDBCheckBoxEh
    Left = 292
    Top = 105
    Width = 144
    Height = 14
    Caption = '������������ &�������'
    Checked = True
    State = cbChecked
    TabOrder = 5
    TabStop = True
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
end