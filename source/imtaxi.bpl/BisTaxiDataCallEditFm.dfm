inherited BisTaxiDataCallEditForm: TBisTaxiDataCallEditForm
  Caption = 'BisTaxiDataCallEditForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelControls: TPanel
    inherited GroupBoxCaller: TGroupBox
      inherited ButtonCaller: TButton
        OnClick = ButtonCallerClick
      end
    end
    inherited GroupBoxAcceptor: TGroupBox
      inherited ButtonAcceptor: TButton
        OnClick = ButtonAcceptorClick
      end
    end
  end
  object PopupAccount: TPopupActionBar
    OnPopup = PopupAccountPopup
    Left = 344
    Top = 72
    object MenuItemAccounts: TMenuItem
      Caption = #1059#1095#1077#1090#1085#1099#1077' '#1079#1072#1087#1080#1089#1080
      OnClick = MenuItemAccountsClick
    end
    object MenuItemDispatchers: TMenuItem
      Caption = #1044#1080#1089#1087#1077#1090#1095#1077#1088#1099
      OnClick = MenuItemDispatchersClick
    end
    object MenuItemDrivers: TMenuItem
      Caption = #1042#1086#1076#1080#1090#1077#1083#1080
      OnClick = MenuItemDriversClick
    end
    object MenuItemClients: TMenuItem
      Caption = #1050#1083#1080#1077#1085#1090#1099
      OnClick = MenuItemClientsClick
    end
  end
end
