inherited BisMainForm: TBisMainForm
  Caption = #1043#1083#1072#1074#1085#1072#1103' '#1092#1086#1088#1084#1072
  ClientHeight = 92
  ClientWidth = 255
  ExplicitWidth = 271
  ExplicitHeight = 130
  PixelsPerInch = 96
  TextHeight = 13
  object TrayIcon: TTrayIcon
    BalloonFlags = bfInfo
    Icons = ImageList
    PopupMenu = PopupActionBar
    OnDblClick = TrayIconDblClick
    Left = 16
    Top = 8
  end
  object ImageList: TImageList
    Left = 64
    Top = 8
  end
  object PopupActionBar: TPopupActionBar
    Images = ImageList
    OnPopup = PopupActionBarPopup
    Left = 128
    Top = 8
    object MenuItemShow: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      Default = True
      OnClick = MenuItemShowClick
    end
    object MenuItemHide: TMenuItem
      Caption = #1057#1082#1088#1099#1090#1100
      OnClick = MenuItemHideClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuItemAbout: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      Hint = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnClick = MenuItemAboutClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuItemExit: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = MenuItemExitClick
    end
  end
end
