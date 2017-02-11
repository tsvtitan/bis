unit BisTaxi;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;
                                       
implementation

uses BisCore, BisTaxiConsts,
     BisTaxiMainFm, BisTaxiDataCarTypesFm, BisTaxiDataCarsFm, BisTaxiDataServicesFm,
     BisTaxiDataSourcesFm, BisTaxiDataZonesFm, BisTaxiDataCalcsFm,
     BisTaxiDataParksFm, BisTaxiDataBlacksFm, BisTaxiDataDriversFm, BisTaxiDataDispatchersFm,
     BisTaxiDataShiftsFm, BisTaxiDataReceiptTypesFm, BisTaxiDataChargeTypesFm,
     BisTaxiDataParkStatesFm, BisTaxiDataZoneParksFm,
     BisTaxiDataCostsFm, BisTaxiDataCompositionsFm, BisTaxiDataActionsFm, BisTaxiDataResultsFm,
     BisTaxiDataRatesFm, BisTaxiDataDriverShiftsFm, BisTaxiDataMapObjectsFm,
     BisTaxiDataCarEditFm, BisTaxiDataBlackEditFm, BisTaxiDataDriverEditFm, BisTaxiDataDispatcherEditFm,
     BisTaxiDataDriverInMessagesFm, BisTaxiDataDriverOutMessagesFm, BisTaxiDataMethodsFm,
     BisTaxiDataReceiptEditFm, BisTaxiDataChargeEditFm,
     BisTaxiDataDiscountTypesFm, BisTaxiDataDiscountsFm, 
     BisTaxiDataClientGroupsFm, BisTaxiDataClientsFm, BisTaxiDataClientPhonesFm, BisTaxiDataClientEditFm,
     BisTaxiDataPatternMessagesFm, BisTaxiDataCodeMessagesFm, BisTaxiDataInMessagesFm,
     BisTaxiDataOutMessagesFm, BisTaxiDataOutMessageEditFm, BisTaxiDataOutMessageInsertExFm,
     BisTaxiDataReceiptsFm, BisTaxiDataChargesFm, BisTaxiOrderEditFm, BisTaxiOrdersFm,
     BisTaxiDataOperatorsFm, BisTaxiDataCallResultsFm, BisTaxiDataCallsFm,
     BisTaxiIngitMapFm,
     BisTaxiPhoneFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin

    if IsMainModule then
      Ifaces.AddClass(TBisTaxiMainFormIface);

    CarInsertIface:=TBisTaxiDataCarInsertFormIface(Ifaces.AddClass(TBisTaxiDataCarInsertFormIface));
    OutMessageInsertIface:=TBisTaxiDataOutMessageInsertExFormIface(Ifaces.AddClass(TBisTaxiDataOutMessageInsertExFormIface));
    BlackInsertIface:=TBisTaxiDataBlackInsertFormIface(Ifaces.AddClass(TBisTaxiDataBlackInsertFormIface));
    DriverInsertIface:=TBisTaxiDataDriverInsertFormIface(Ifaces.AddClass(TBisTaxiDataDriverInsertFormIface));
    DispatcherInsertIface:=TBisTaxiDataDispatcherInsertFormIface(Ifaces.AddClass(TBisTaxiDataDispatcherInsertFormIface));
    ClientInsertIface:=TBisTaxiDataClientInsertFormIface(Ifaces.AddClass(TBisTaxiDataClientInsertFormIface));
    ReceiptInsertIface:=TBisTaxiDataReceiptInsertFormIface(Ifaces.AddClass(TBisTaxiDataReceiptInsertFormIface));
    ChargeInsertIface:=TBisTaxiDataChargeInsertFormIface(Ifaces.AddClass(TBisTaxiDataChargeInsertFormIface));
    OrderInsertIface:=TBisTaxiOrderInsertFormIface(Ifaces.AddClass(TBisTaxiOrderInsertFormIface));
    DriverInMessagesIface:=TBisTaxiDataDriverInMessagesFormIface(Ifaces.AddClass(TBisTaxiDataDriverInMessagesFormIface));
    DriverOutMessagesIface:=TBisTaxiDataDriverOutMessagesFormIface(Ifaces.AddClass(TBisTaxiDataDriverOutMessagesFormIface));

    OrdersIface:=TBisTaxiOrdersFormIface(Ifaces.AddClass(TBisTaxiOrdersFormIface));

    Classes.Add(TBisTaxiDataCarTypesFormIface);
    Classes.Add(TBisTaxiDataCarsFormIface);
    Classes.Add(TBisTaxiDataServicesFormIface);
    Classes.Add(TBisTaxiDataSourcesFormIface);
    Classes.Add(TBisTaxiDataZonesFormIface);
    Classes.Add(TBisTaxiDataCalcsFormIface);
    Classes.Add(TBisTaxiDataMethodsFormIface);
    Classes.Add(TBisTaxiDataParksFormIface);
    Classes.Add(TBisTaxiDataBlacksFormIface);
    Classes.Add(TBisTaxiDataDriversFormIface);
    Classes.Add(TBisTaxiDataDispatchersFormIface);                                         
    Classes.Add(TBisTaxiDataShiftsFormIface);
    Classes.Add(TBisTaxiDataReceiptTypesFormIface);
    Classes.Add(TBisTaxiDataChargeTypesFormIface);
    Classes.Add(TBisTaxiDataParkStatesFormIface);
    Classes.Add(TBisTaxiDataZoneParksFormIface);
    Classes.Add(TBisTaxiDataCostsFormIface);
    Classes.Add(TBisTaxiDataCompositionsFormIface);
    Classes.Add(TBisTaxiDataActionsFormIface);
    Classes.Add(TBisTaxiDataResultsFormIface);
    Classes.Add(TBisTaxiDataRatesFormIface);
    Classes.Add(TBisTaxiDataDriverShiftsFormIface);
    Classes.Add(TBisTaxiDataMapObjectsFormIface);
    Classes.Add(TBisTaxiDataReceiptsFormIface);
    Classes.Add(TBisTaxiDataChargesFormIface);
    Classes.Add(TBisTaxiDataCarInsertFormIface);
    Classes.Add(TBisTaxiDataBlackInsertFormIface);
    Classes.Add(TBisTaxiDataDriverInsertFormIface);
    Classes.Add(TBisTaxiDataDispatcherInsertFormIface);
    Classes.Add(TBisTaxiDataReceiptInsertFormIface);
    Classes.Add(TBisTaxiDataChargeInsertFormIface);
    Classes.Add(TBisTaxiDataDriverInMessagesFormIface);
    Classes.Add(TBisTaxiDataDriverOutMessagesFormIface);
    Classes.Add(TBisTaxiDataClientGroupsFormIface);
    Classes.Add(TBisTaxiDataClientsFormIface);
    Classes.Add(TBisTaxiDataClientInsertFormIface);
    Classes.Add(TBisTaxiDataClientPhonesFormIface);
    Classes.Add(TBisTaxiDataDiscountTypesFormIface);
    Classes.Add(TBisTaxiDataDiscountsFormIface);
    Classes.Add(TBisTaxiDataOperatorsFormIface);
    Classes.Add(TBisTaxiDataCallResultsFormIface);
    Classes.Add(TBisTaxiDataCallsFormIface);
    Classes.Add(TBisTaxiDataInCallsFormIface);
    Classes.Add(TBisTaxiDataOutCallsFormIface);

    Classes.Add(TBisTaxiDataPatternMessagesFormIface);
    Classes.Add(TBisTaxiDataCodeMessagesFormIface);
    Classes.Add(TBisTaxiDataInMessagesFormIface);
    Classes.Add(TBisTaxiDataOutMessagesFormIface);
    Classes.Add(TBisTaxiDataOutMessageInsertFormIface);
    Classes.Add(TBisTaxiDataOutMessageInsertExFormIface);

    Classes.Add(TBisTaxiOrderInsertFormIface);
    Classes.Add(TBisTaxiOrdersFormIface);
    Classes.Add(TBisTaxiIngitMapFormIface);
    Classes.Add(TBisTaxiPhoneFormIface);

  end;
end;

end.