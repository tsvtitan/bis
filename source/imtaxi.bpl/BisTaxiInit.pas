unit BisTaxiInit;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
                                                                                                        
exports
  InitIfaceModule;
                                       
implementation

uses BisCore,
     BisTaxiConsts,
     BisTaxiMainFm, BisTaxiDataCarTypesFm, BisTaxiDataCarsFm, BisTaxiDataServicesFm,
     BisTaxiDataSourcesFm, BisTaxiDataZonesFm, BisTaxiDataCalcsFm,
     BisTaxiDataParksFm, BisTaxiDataBlacksFm, BisTaxiDataDriversFm, BisTaxiDataDispatchersFm,
     BisTaxiDataShiftsFm, BisTaxiDataReceiptTypesFm, BisTaxiDataChargeTypesFm,
     BisTaxiDataParkStatesFm, BisTaxiDataZoneParksFm,
     BisTaxiDataCostsFm, BisTaxiDataCompositionsFm, BisTaxiDataActionsFm, BisTaxiDataResultsFm,
     BisTaxiDataRatesFm, BisTaxiDataDriverShiftsFm, 
     BisTaxiDataCarEditFm, BisTaxiDataBlackEditFm, BisTaxiDataDriverEditFm, BisTaxiDataDispatcherEditFm,
     BisTaxiDataDriverInMessagesFm, BisTaxiDataDriverOutMessagesFm, BisTaxiDataDriverTypesFm,
     BisTaxiDataMethodsFm, BisTaxiDataRatingsFm, BisTaxiDataScoresFm,
     BisTaxiDataReceiptEditFm, BisTaxiDataChargeEditFm,
     BisTaxiDataDiscountTypesFm, BisTaxiDataDiscountsFm, 
     BisTaxiDataClientGroupsFm, BisTaxiDataClientsFm, BisTaxiDataClientPhonesFm, BisTaxiDataClientEditFm,
     BisTaxiDataClientDriversFm,
     BisTaxiDataInMessagesFm,
     BisTaxiDataOutMessagesFm, BisTaxiDataOutMessageEditFm, 
     BisTaxiDataReceiptsFm, BisTaxiDataChargesFm, BisTaxiOrderEditFm, BisTaxiOrdersFm,
     BisTaxiDataCallsFm,
     BisTaxiPhoneFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin

    if IsMainModule then 
      Ifaces.AddClass(TBisTaxiMainFormIface);

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
    Classes.Add(TBisTaxiDataDriverTypesFormIface);

    Classes.Add(TBisTaxiDataRatingsFormIface);
    Classes.Add(TBisTaxiDataScoresFormIface);

    Classes.Add(TBisTaxiDataClientGroupsFormIface);
    Classes.Add(TBisTaxiDataClientsFormIface);
    Classes.Add(TBisTaxiDataClientInsertFormIface);
    Classes.Add(TBisTaxiDataClientPhonesFormIface);
    Classes.Add(TBisTaxiDataClientDriversFormIface);

    Classes.Add(TBisTaxiDataDiscountTypesFormIface);
    Classes.Add(TBisTaxiDataDiscountsFormIface);

    Classes.Add(TBisTaxiDataCallsFormIface);
    Classes.Add(TBisTaxiDataInCallsFormIface);
    Classes.Add(TBisTaxiDataOutCallsFormIface);
    Classes.Add(TBisTaxiPhoneFormIface);

    Classes.Add(TBisTaxiDataInMessagesFormIface);
    Classes.Add(TBisTaxiDataOutMessagesFormIface);
    Classes.Add(TBisTaxiDataOutMessageInsertFormIface);
    Classes.Add(TBisTaxiDataOutMessageInsertExFormIface);

    Classes.Add(TBisTaxiOrderInsertFormIface);
    Classes.Add(TBisTaxiOrdersFormIface);

  end;
end;

end.
