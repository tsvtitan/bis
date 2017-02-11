unit BisSmpp;

interface

uses Classes, SysUtils, Contnrs;

type
  TBisSmppCommandStatus=(csNoError,csMessageLengthInvalid,csCommandLengthInvalid,csInvalidCommandId,
                         csIncorrectBindStatus,csAlreadyBoundState,csInvalidPriorityFlag,csInvalidRegisteredDeliveryFlag,
                         csSystemError,csInvalidSourceAddress,csInvalidDestAddress,csMessageIdInvalid,csBindFailed,
                         csInvalidPassword,csInvalidSystemId,csCancelSMFailed,csReplaceSMFailed,csMessageQueueFull,
                         csInvalidServiceType,csInvalidNumberDestinations,csInvalidDistributionListName,
                         csDestinationFlagInvalid,csInvalidSubmitWithWeplaceRequest,csInvalidEsmClassFieldData,
                         csCannotSubmitDistributionList,csSubmitSmOrSubmitMultiFailed,csInvalidSourceAddressTON,
                         csInvalidSourceaddressNPI,csInvalidDestinationAddressTON,csInvalidDestinationAddressNPI,
                         csInvalidSystemTypeField,csInvalidReplaceIfPresentFlag,csInvalidNumberMessages,
                         csThrottlingError,csInvalidScheduledDeliveryTime,csInvalidMessageValidityPeriod,
                         csPredefinedMessageInvalidOrNotFound,csReceiverTemporaryAppErrorCode,csReceiverPermanentAppErrorCode,
                         csReceiverRejectMessageErrorCode,csQuerySmRequestFailed,csErrorOptionalPartPDUBody,
                         csOptionalParameterNotAllowed,csInvalidParameterLength,csExpectedOptionalParameterMissing,
                         csInvalidOptionalParameterValue,csDeliveryFailure,csUnknownError);

  TBisSmppCommandStatusInfo=class(TObject)
  private
    FStatus: TBisSmppCommandStatus;
    FCode: Cardinal;
    FDescription: String;
  public
    constructor Create(Status: TBisSmppCommandStatus; Code: Cardinal; Description: String);

    property Status: TBisSmppCommandStatus read FStatus;
    property Code: Cardinal read FCode;
    property Description: String read FDescription;
  end;

  TBisSmppTypeOfNumber=(tonUnknown,tonInternational,tonNational,tonNetworkSpecific,
                        tonSubscriberNumber,tonAlphanumeric,tonAbbreviated);

  TBisSmppNumberingPlanIndicator=(npiUnknown,npiISDN,npiReserved002,npiData,npiTelex,
                                  npiReserved005,npiLandMobile,npiReserved007,npiNational,
                                  npiPrivate,npiERMES,npiReserved011,npiReserved012,
                                  npiReserved013,npiInternet,npiReserved015,npiReserved016,
                                  npiReserved017,npiWAPClientId);


  TBisSmppStream=class(TMemoryStream)
  public
    procedure WriteBytes(Value: TBytes);
    procedure WriteInteger(Value: Integer);
    procedure WriteWord(Value: Word);
    procedure WriteByte(Value: Byte);
    procedure WriteString(Value: String; Len: Cardinal=MaxInt; WithZero: Boolean=true);

    procedure ReadBytes(var Value: TBytes);
    function ReadInteger: Integer;
    function ReadWord: Word;
    function ReadByte: Byte;
    function ReadString(Len: Cardinal=MaxInt): String;
  end;

  TBisSmppOptionalParameter=class(TObject)
  protected
    FData: TBytes;
    class function GetParameterTag: Word; virtual; abstract;
  public
    constructor Create(AData: TBytes=nil); virtual;

    property ParameterTag: Word read GetParameterTag;
  end;

  TBisSmppOptionalParameterClass=class of TBisSmppOptionalParameter;

  TBisSmppBooleanValue=class(TBisSmppOptionalParameter)
  private
    function GetValue: Boolean;
    procedure SetValue(AValue: Boolean);
  public
    property Value: Boolean read GetValue write SetValue;
  end;

  TBisSmppByteValue=class(TBisSmppOptionalParameter)
  private
    function GetValue: Byte;
    procedure SetValue(AValue: Byte);
  public
    property Value: Byte read GetValue write SetValue;
  end;

  TBisSmppWordValue=class(TBisSmppOptionalParameter)
  private
    function GetValue: Word;
    procedure SetValue(AValue: Word);
  public
    property Value: Word read GetValue write SetValue;
  end;

  TBisSmppStringValue=class(TBisSmppOptionalParameter)
  private
    function GetValue: String;
    procedure SetValue(AValue: String);
  public
    property Value: String read GetValue write SetValue;
  end;

  TBisSmppScInterfaceVersion=class(TBisSmppByteValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppMsAvailabilityStatusValue=(masvAvailable,masvDenied,masvUnavailable);

  TBisSmppMsAvailabilityStatus=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppMsAvailabilityStatusValue;
    procedure SetValue(AValue: TBisSmppMsAvailabilityStatusValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppMsAvailabilityStatusValue read GetValue write SetValue;
  end;

  TBisSmppUserMessageReference=class(TBisSmppWordValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppSourcePort=class(TBisSmppWordValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppAddrSubunitValue=(asvUnknown,asvMSDisplay,asvMobileEquipment,asvSmartCard1,asvExternalUnit1);

  TBisSmppAddrSubunit=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppAddrSubunitValue;
    procedure SetValue(AValue: TBisSmppAddrSubunitValue);
  public
    property Value: TBisSmppAddrSubunitValue read GetValue write SetValue;
  end;

  TBisSmppSourceAddrSubunit=class(TBisSmppAddrSubunit)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppDestinationPort=class(TBisSmppWordValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppDestAddrSubunit=class(TBisSmppAddrSubunit)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppSarMsgRefNum=class(TBisSmppWordValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppSarTotalSegments=class(TBisSmppByteValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppSarSegmentSeqnum=class(TBisSmppByteValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppMoreMessagesToSend=class(TBisSmppBooleanValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppPayloadTypeValue=(ptvWDP,ptvWCMP);

  TBisSmppPayloadType=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppPayloadTypeValue;
    procedure SetValue(AValue: TBisSmppPayloadTypeValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppPayloadTypeValue read GetValue write SetValue;
  end;

  TBisSmppMessagePayload=class(TBisSmppStringValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppPrivacyIndicatorValue=(pivNotRestricted,pivRestricted,pivConfidential,pivSecret);

  TBisSmppPrivacyIndicator=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppPrivacyIndicatorValue;
    procedure SetValue(AValue: TBisSmppPrivacyIndicatorValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppPrivacyIndicatorValue read GetValue write SetValue;
  end;

  TBisSmppCallbackNumDigitMode=(cndmDTMF,cndmASCII);

  TBisSmppCallbackNum=class(TBisSmppOptionalParameter)
  private
    function GetDigitMode: TBisSmppCallbackNumDigitMode;
    function GetTON: TBisSmppTypeOfNumber;
    function GetNPI: TBisSmppNumberingPlanIndicator;
    function GetNumber: String;
    procedure SetDigitMode(const Value: TBisSmppCallbackNumDigitMode);
    procedure SetNPI(const Value: TBisSmppNumberingPlanIndicator);
    procedure SetTON(const Value: TBisSmppTypeOfNumber);
    procedure SetNumber(const Value: String);
  protected
    class function GetParameterTag: Word; override;
  public
    property DigitMode: TBisSmppCallbackNumDigitMode read GetDigitMode write SetDigitMode;
    property TON: TBisSmppTypeOfNumber read GetTON write SetTON;
    property NPI: TBisSmppNumberingPlanIndicator read GetNPI write SetNPI;
    property Number: String read GetNumber write SetNumber;
  end;

  TBisSmppCallbackNumPresIndPresentation=(cnpipAllowed,cnpipRestricted,cnpipNotAvailable,cnpipReserved);
  TBisSmppCallbackNumPresIndScreening=(cnpisUserProvidedNotScreened,cnpisUserProvidedVerifiedAndPassed,
                                       cnpisUserProvidedVerifiedAndFailed,cnpisNetworkProvided);

  TBisSmppCallbackNumPresInd=class(TBisSmppOptionalParameter)
  private
    function GetPresentation: TBisSmppCallbackNumPresIndPresentation;
    function GetScreening: TBisSmppCallbackNumPresIndScreening;
    procedure SetPresentation(const Value: TBisSmppCallbackNumPresIndPresentation);
    procedure SetScreening(const Value: TBisSmppCallbackNumPresIndScreening);
  protected
    class function GetParameterTag: Word; override;
  public
    property Presentation: TBisSmppCallbackNumPresIndPresentation read GetPresentation write SetPresentation;
    property Screening: TBisSmppCallbackNumPresIndScreening read GetScreening write SetScreening;
  end;

  TBisSmppDataCoding=(dcDefaultAlphabet,dcIA5,dcOctetUnspecified1,dcLatin1,dcOctetUnspecified2,dcJIS,dcCyrllic,
                      dcLatinHebrew,dcUCS2,dcPictogramEncoding,dcISO2022JP,dcExtendedKanjiJIS,dcKS);

  TBisSmppCallbackNumAtag=class(TBisSmppOptionalParameter)
  private
    function GetDataCoding: TBisSmppDataCoding;
    function GetDisplay: String;
    procedure SetDataCoding(const Value: TBisSmppDataCoding);
    procedure SetDisplay(const Value: String);
  protected
    class function GetParameterTag: Word; override;
  public
    property DataCoding: TBisSmppDataCoding read GetDataCoding write SetDataCoding;
    property Display: String read GetDisplay write SetDisplay;
  end;

  TBisSmppSubaddressType=(satUnknown,satReserved01,satReserved02,satNSAPEven,satNSAPOdd,satUserSpecified);

  TBisSmppSubaddress=class(TBisSmppOptionalParameter)
  private
    function GetSubaddressType: TBisSmppSubaddressType;
    function GetSubject: String;
    procedure SetSubaddressType(const Value: TBisSmppSubaddressType);
    procedure SetSubject(const Value: String);
  public
    property SubaddressType: TBisSmppSubaddressType read GetSubaddressType write SetSubaddressType;
    property Subject: String read GetSubject write SetSubject;
  end;

  TBisSmppSourceSubaddress=class(TBisSmppSubaddress)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppDestSubaddress=class(TBisSmppSubaddress)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppUserResponseCode=class(TBisSmppByteValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppDisplayTimeValue=(dtvTemporary,dtvDefault,dtvInvoke);

  TBisSmppDisplayTime=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppDisplayTimeValue;
    procedure SetValue(AValue: TBisSmppDisplayTimeValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppDisplayTimeValue read GetValue write SetValue;
  end;

  TBisSmppSmsSignal=class(TBisSmppWordValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppMsValidityValue=(mvvStoreIndefinitely,mvvPowerDown,mvvSIDbased,mvvDisplayOnly);

  TBisSmppMsValidity=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppMsValidityValue;
    procedure SetValue(AValue: TBisSmppMsValidityValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppMsValidityValue read GetValue write SetValue;
  end;

  TBisSmppMsMsgWaitFacilitiesType=(mmwftVoicemail,mmwftFax,mmwftElectronicMail,mmwftOther);

  TBisSmppMsMsgWaitFacilities=class(TBisSmppOptionalParameter)
  private
    function GetIndicationInactive: Boolean;
    function GetMessageType: TBisSmppMsMsgWaitFacilitiesType;
    procedure SetIndicationInactive(const Value: Boolean);
    procedure SetMessageType(const Value: TBisSmppMsMsgWaitFacilitiesType);
  protected
    class function GetParameterTag: Word; override;
  public
    property IndicationInactive: Boolean read GetIndicationInactive write SetIndicationInactive;
    property MessageType: TBisSmppMsMsgWaitFacilitiesType read GetMessageType write SetMessageType;
  end;

  TBisSmppNumberOfMessages=class(TBisSmppByteValue)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppAlertOnMsgDelivery=class(TBisSmppOptionalParameter)
  protected
    class function GetParameterTag: Word; override;
  end;

  TBisSmppLanguageIndicatorValue=(livUnspecified,livEnglish,livFrench,livSpanish,livGerman,livPortuguese);

  TBisSmppLanguageIndicator=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppLanguageIndicatorValue;
    procedure SetValue(AValue: TBisSmppLanguageIndicatorValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppLanguageIndicatorValue read GetValue write SetValue;
  end;

  TBisSmppItsReplyTypeValue=(irtvDigit,irtvNumber,irtvTelephoneNo,irtvPassword,
                             irtvCharacterLine,irtvMenu,irtvDate,irtvTime,irtvContinue);

  TBisSmppItsReplyType=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppItsReplyTypeValue;
    procedure SetValue(AValue: TBisSmppItsReplyTypeValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppItsReplyTypeValue read GetValue write SetValue;
  end;

  TBisSmppItsSessionInfo=class(TBisSmppOptionalParameter)
  private
    function GetEndIndicator: Boolean;
    function GetSequenceNumber: Byte;
    function GetSessionNumber: Byte;
    procedure SetEndIndicator(const Value: Boolean);
    procedure SetSequenceNumber(const Value: Byte);
    procedure SetSessionNumber(const Value: Byte);
  protected
    class function GetParameterTag: Word; override;
  public
    property SessionNumber: Byte read GetSessionNumber write SetSessionNumber;
    property SequenceNumber: Byte read GetSequenceNumber write SetSequenceNumber;
    property EndIndicator: Boolean read GetEndIndicator write SetEndIndicator;
  end;

  TBisSmppUssdServiceOpValue=(usovPSSDindication,usovPSSRindication,usovUSSRrequest,usovUSSNrequest,
                              usovReserved04,usovReserved05,usovReserved06,usovReserved07,
                              usovReserved08,usovReserved09,usovReserved10,usovReserved11,
                              usovReserved12,usovReserved13,usovReserved14,usovReserved15,
                              usovPSSDresponse,usovPSSRresponse,usovUSSRconfirm,usovUSSNconfirm);

  TBisSmppUssdServiceOp=class(TBisSmppByteValue)
  private
    function GetValue: TBisSmppUssdServiceOpValue;
    procedure SetValue(AValue: TBisSmppUssdServiceOpValue);
  protected
    class function GetParameterTag: Word; override;
  public
    property Value: TBisSmppUssdServiceOpValue read GetValue write SetValue;
  end;

  TBisSmppOptionalParameters=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSmppOptionalParameter;
    function AddClass(AClass: TBisSmppOptionalParameterClass): TBisSmppOptionalParameter;
  public
    function FindClass(AClass: TBisSmppOptionalParameterClass): TBisSmppOptionalParameter;
//    function Add(Parameter: TBisSmppOptionalParameter): Integer;

    function AddScInterfaceVersion(Value: Byte): TBisSmppScInterfaceVersion;
    function AddMsAvailabilityStatus(Value: TBisSmppMsAvailabilityStatusValue): TBisSmppMsAvailabilityStatus;
    function AddUserMessageReference(Value: Word): TBisSmppUserMessageReference;
    function AddSourcePort(Value: Word): TBisSmppSourcePort;
    function AddSourceAddrSubunit(Value: TBisSmppAddrSubunitValue): TBisSmppSourceAddrSubunit;
    function AddDestinationPort(Value: Word): TBisSmppDestinationPort;
    function AddDestAddrSubunit(Value: TBisSmppAddrSubunitValue): TBisSmppDestAddrSubunit;
    function AddSarMsgRefNum(Value: Word): TBisSmppSarMsgRefNum;
    function AddSarTotalSegments(Value: Byte): TBisSmppSarTotalSegments;
    function AddSarSegmentSeqnum(Value: Byte): TBisSmppSarSegmentSeqnum;
    function AddMoreMessagesToSend(Value: Boolean): TBisSmppMoreMessagesToSend;
    function AddPayloadType(Value: TBisSmppPayloadTypeValue): TBisSmppPayloadType;
    function AddMessagePayload(Value: String): TBisSmppMessagePayload;
    function AddPrivacyIndicator(Value: TBisSmppPrivacyIndicatorValue): TBisSmppPrivacyIndicator;
    function AddCallbackNum(DigitMode: TBisSmppCallbackNumDigitMode; TON: TBisSmppTypeOfNumber;
                            NPI: TBisSmppNumberingPlanIndicator; Number: String): TBisSmppCallbackNum;
    function AddCallbackNumPresInd(Presentation: TBisSmppCallbackNumPresIndPresentation;
                                   Screening: TBisSmppCallbackNumPresIndScreening): TBisSmppCallbackNumPresInd;
    function AddCallbackNumAtag(DataCoding: TBisSmppDataCoding; Display: String): TBisSmppCallbackNumAtag;
    function AddSourceSubaddress(SubaddressType: TBisSmppSubaddressType; Subject: String): TBisSmppSourceSubaddress;
    function AddDestSubaddress(SubaddressType: TBisSmppSubaddressType; Subject: String): TBisSmppDestSubaddress;
    function AddUserResponseCode(Value: Byte): TBisSmppUserResponseCode; 
    function AddDisplayTime(Value: TBisSmppDisplayTimeValue): TBisSmppDisplayTime;
    function AddSmsSignal(Value: Word): TBisSmppSmsSignal;
    function AddMsValidity(Value: TBisSmppMsValidityValue): TBisSmppMsValidity;
    function AddMsMsgWaitFacilities(IndicationInactive: Boolean; MessageType: TBisSmppMsMsgWaitFacilitiesType): TBisSmppMsMsgWaitFacilities;
    function AddNumberOfMessages(Value: Byte): TBisSmppNumberOfMessages; 
    function AddAlertOnMsgDelivery: TBisSmppAlertOnMsgDelivery; 
    function AddLanguageIndicator(Value: TBisSmppLanguageIndicatorValue): TBisSmppLanguageIndicator; 
    function AddItsReplyType(Value: TBisSmppItsReplyTypeValue): TBisSmppItsReplyType; 
    function AddItsSessionInfo(SessionNumber,SequenceNumber: Byte; EndIndicator: Boolean): TBisSmppItsSessionInfo;
    function AddUssdServiceOp(Value: TBisSmppUssdServiceOpValue): TBisSmppUssdServiceOp;


    procedure WriteData(Stream: TBisSmppStream);
    procedure ReadData(Stream: TBisSmppStream);

    property Items[Index: Integer]: TBisSmppOptionalParameter read GetItem; default;
  end;

  TBisSmppMessage=class(TObject)
  private
    FSequenceNumber: Cardinal;
    FCommandStatusCode: Cardinal;
    FParameters: TBisSmppOptionalParameters;
    function GetCommandStatus: TBisSmppCommandStatus;
    procedure SetCommandStatus(const Value: TBisSmppCommandStatus);
  protected
    class function GetCommandId: Cardinal; virtual; abstract;
    procedure WriteData(Stream: TBisSmppStream); virtual;
    procedure ReadData(Stream: TBisSmppStream); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function GetData(var Data: TBytes): Boolean;
    procedure SetData(Data: TBytes);

    property CommandId: Cardinal read GetCommandId;
    property Parameters: TBisSmppOptionalParameters read FParameters;

    property CommandStatus: TBisSmppCommandStatus read GetCommandStatus write SetCommandStatus;
    property SequenceNumber: Cardinal read FSequenceNumber write FSequenceNumber;
  end;

  TBisSmppMessageClass=class of TBisSmppMessage;

  TBisSmppMessages=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSmppMessage;
  public
    property Items[Index: Integer]: TBisSmppMessage read GetItem; default;
  end;

  TBisSmppResponse=class;
  
  TBisSmppRequest=class(TBisSmppMessage)
  private
    FResponse: TBisSmppResponse;
  public
    destructor Destroy; override;

    property Response: TBisSmppResponse read FResponse write FResponse;
  end;

  TBisSmppRequests=class(TBisSmppMessages)
  private
    function GetItem(Index: Integer): TBisSmppRequest;
  public
    property Items[Index: Integer]: TBisSmppRequest read GetItem; default;
  end;

  TBisSmppResponse=class(TBisSmppMessage)
  public
    procedure SetRequest(Request: TBisSmppRequest); virtual;
  end;

  TBisSmppResponseClass=class of TBisSmppResponse;

  TBisSmppGenericNackResponse=class(TBisSmppResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppBindRequest=class(TBisSmppRequest)
  private
    FSystemId: String;
    FPassword: String;
    FSystemType: String;
    FInterfaceVersion: Byte;
    FAddrTon: TBisSmppTypeOfNumber;
    FAddrNpi: TBisSmppNumberingPlanIndicator;
    FAddressRange: String;
  protected
    procedure WriteData(Stream: TBisSmppStream); override;
  public
    constructor Create; override;

    property SystemId: String read FSystemId write FSystemId;
    property Password: String read FPassword write FPassword;
    property SystemType: String read FSystemType write FSystemType;
    property InterfaceVersion: Byte read FInterfaceVersion write FInterfaceVersion;
    property AddrTon: TBisSmppTypeOfNumber read FAddrTon write FAddrTon;
    property AddrNpi: TBisSmppNumberingPlanIndicator read FAddrNpi write FAddrNpi;
    property AddressRange: String read FAddressRange write FAddressRange;
  end;

  TBisSmppBindResponse=class(TBisSmppResponse)
  private
    FSystemId: String;
  protected
    procedure ReadData(Stream: TBisSmppStream); override;
  public
    property SystemId: String read FSystemId;
  end;

  TBisSmppBindTransmitterRequest=class(TBisSmppBindRequest)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppBindTransmitterResponse=class(TBisSmppBindResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppBindReceiverRequest=class(TBisSmppBindRequest)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppBindReceiverResponse=class(TBisSmppBindResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppBindTransceiverRequest=class(TBisSmppBindRequest)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppBindTransceiverResponse=class(TBisSmppBindResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppOutbindRequest=class(TBisSmppRequest)
  private
    FSystemId: String;
    FPassword: String;
  protected
    class function GetCommandId: Cardinal; override;
    procedure ReadData(Stream: TBisSmppStream); override;
  public
    property SystemId: String read FSystemId;
    property Password: String read FPassword;
  end;

  TBisSmppUnBindRequest=class(TBisSmppRequest)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppUnBindResponse=class(TBisSmppResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppEsmClassMessagingMode=(ecmDefault,ecmDatagram,ecmForward,ecmStoreAndForward);
  TBisSmppEsmClassMessagingType=(ectDefault,ectDelivery,ectManual);
  TBisSmppEsmClassFeatures=(ecfNotSelected,ecfUDHI,ecfReplayPath,ecfUDHIandReplyPath);

  TBisSmmProtocolId=(pidSMEtoSME,
                     pidTelematicImplicit,pidTelematicTelex,pidTelematicGroup3Telefax,pidTelematicGroup4Telefax,
                     pidTelematicVoiceTelephone,pidTelematicERMES,pidTelematicNationalPagingSystem,pidTelematicVideotex,
                     pidTelematicTeletexCarrierUnspecified,pidTelematicTeletexInPSPDN,pidTelematicTeletexInCSPDN,
                     pidTelematicTeletexInAnaloguePSTN,pidTelematicTeletexInDigitalISDN,pidTelematicUCI,
                     pidTelematicMessageHandlingFacility,pidTelematicAnyPublicX400,pidTelematicInternetElectronicMail,
                     pidTelematicGSMMobileStation,
                     pidNetworkShortMessageType0,pidNetworkReplaceShortMessageType1,pidNetworkReplaceShortMessageType2,
                     pidNetworkReplaceShortMessageType3,pidNetworkReplaceShortMessageType4,pidNetworkReplaceShortMessageType5,
                     pidNetworkReplaceShortMessageType6,pidNetworkReplaceShortMessageType7,pidNetworkReturnCallMessage,
                     pidNetworkSIMDataDownload);
  TBisSmppPriorityFlag=(pfNormal,pfInteractive,pfUrgent,pfEmergency); // for IS-95 (CDMA), ANSI-136 (TDMA)

  TBisSmppRegisteredDeliveryReceipt=(rdrNotRequested,rdrSuccessOrFailure,rdrFailure);
  TBisSmppRegisteredDeliveryAck=(rdaNotRequested,rdaDelivery,rdaManualOrUser,rdaBoth);

  TBisSmppIndication=(indNone,indFlash);

  TBisSmppSubmitRequest=class(TBisSmppRequest)
  private
    FServiceType: String;
    FSourceAddrTon: TBisSmppTypeOfNumber;
    FSourceAddrNpi: TBisSmppNumberingPlanIndicator;
    FSourceAddr: String;
    FEsmClassMessagingMode: TBisSmppEsmClassMessagingMode;
    FEsmClassMessageType: TBisSmppEsmClassMessagingType;
    FEsmClassFeatures: TBisSmppEsmClassFeatures;
    FProtocolId: TBisSmmProtocolId;
    FPriorityFlag: TBisSmppPriorityFlag;
    FScheduleDeliveryTime: TDateTime;
    FValidityPeriod: Int64;
    FRegisteredDeliveryReceipt: TBisSmppRegisteredDeliveryReceipt;
    FRegisteredDeliveryAck: TBisSmppRegisteredDeliveryAck;
    FRegisteredDeliveryNotification: Boolean;
    FReplaceIfPresentFlag: Boolean;
    FDataCoding: TBisSmppDataCoding;
    FSmDefaultMsgId: Byte;
    FSmLength: Byte;
    FShortMessage: String;
    FIndication: TBisSmppIndication;
  public
    property ServiceType: String read FServiceType write FServiceType;
    property SourceAddrTon: TBisSmppTypeOfNumber read FSourceAddrTon write FSourceAddrTon;
    property SourceAddrNpi: TBisSmppNumberingPlanIndicator read FSourceAddrNpi write FSourceAddrNpi;
    property SourceAddr: String read FSourceAddr write FSourceAddr;
    property EsmClassMessagingMode: TBisSmppEsmClassMessagingMode read FEsmClassMessagingMode write FEsmClassMessagingMode;
    property EsmClassMessageType: TBisSmppEsmClassMessagingType read FEsmClassMessageType write FEsmClassMessageType;
    property EsmClassFeatures: TBisSmppEsmClassFeatures read FEsmClassFeatures write FEsmClassFeatures;
    property ProtocolId: TBisSmmProtocolId read FProtocolId write FProtocolId;
    property PriorityFlag: TBisSmppPriorityFlag read FPriorityFlag write FPriorityFlag;
    property ScheduleDeliveryTime: TDateTime read FScheduleDeliveryTime write FScheduleDeliveryTime;
    property ValidityPeriod: Int64 read FValidityPeriod write FValidityPeriod;
    property RegisteredDeliveryReceipt: TBisSmppRegisteredDeliveryReceipt read FRegisteredDeliveryReceipt write FRegisteredDeliveryReceipt;
    property RegisteredDeliveryAck: TBisSmppRegisteredDeliveryAck read FRegisteredDeliveryAck write FRegisteredDeliveryAck;
    property RegisteredDeliveryNotification: Boolean read FRegisteredDeliveryNotification write FRegisteredDeliveryNotification;
    property ReplaceIfPresentFlag: Boolean read FReplaceIfPresentFlag write FReplaceIfPresentFlag;
    property DataCoding: TBisSmppDataCoding read FDataCoding write FDataCoding;
    property Indication: TBisSmppIndication read FIndication write FIndication;
    property SmDefaultMsgId: Byte read FSmDefaultMsgId write FSmDefaultMsgId;
    property SmLength: Byte read FSmLength write FSmLength;
    property ShortMessage: String read FShortMessage write FShortMessage;
  end;

  TBisSmppSubmitRequestClass=class of TBisSmppSubmitRequest;

  TBisSmppSubmitSmRequest=class(TBisSmppSubmitRequest)
  private
    FDestAddrTon: TBisSmppTypeOfNumber;
    FDestAddrNpi: TBisSmppNumberingPlanIndicator;
    FDestinationAddr: String;
  protected
    class function GetCommandId: Cardinal; override;
    procedure WriteData(Stream: TBisSmppStream); override;
  public
    property DestAddrTon: TBisSmppTypeOfNumber read FDestAddrTon write FDestAddrTon;
    property DestAddrNpi: TBisSmppNumberingPlanIndicator read FDestAddrNpi write FDestAddrNpi;
    property DestinationAddr: String read FDestinationAddr write FDestinationAddr;
  end;

  TBisSmppSubmitSmResponse=class(TBisSmppResponse)
  private
    FMessageId: String;
  protected
    class function GetCommandId: Cardinal; override;
    procedure ReadData(Stream: TBisSmppStream); override;
  public
    property MessageId: String read FMessageId;
  end;

  TBisSmppDestAddressDestFlag=(dadfUnknown,dadfSMEAddress,dadfDistributionListName);

  TBisSmppDestAddress=class(TObject)
  private
    FFlag: TBisSmppDestAddressDestFlag;
    FAddrTon: TBisSmppTypeOfNumber;
    FAddrNpi: TBisSmppNumberingPlanIndicator;
    FAddr: String;
    FDLName: String;
  public
    property Flag: TBisSmppDestAddressDestFlag read FFlag write FFlag;
    property AddrTon: TBisSmppTypeOfNumber read FAddrTon write FAddrTon;
    property AddrNpi: TBisSmppNumberingPlanIndicator read FAddrNpi write FAddrNpi;
    property Addr: String read FAddr write FAddr;
    property DLName: String read FDLName write FDLName;
  end;

  TBisSmppDestAddresses=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSmppDestAddress;
  public
    function Add(Flag: TBisSmppDestAddressDestFlag; AddrTon: TBisSmppTypeOfNumber; AddrNpi: TBisSmppNumberingPlanIndicator;
                 Addr: String; DLName: String): TBisSmppDestAddress;
    function AddSMEAddress(AddrTon: TBisSmppTypeOfNumber; AddrNpi: TBisSmppNumberingPlanIndicator; Addr: String): TBisSmppDestAddress;
    function AddDistributionListName(DLName: String): TBisSmppDestAddress;

    property Items[Index: Integer]: TBisSmppDestAddress read GetItem; default;
  end;

  TBisSmppSubmitMultiRequest=class(TBisSmppSubmitRequest)
  private
    FDestAddresses: TBisSmppDestAddresses;
    function GetNumberOfDests: Byte;
  protected
    class function GetCommandId: Cardinal; override;
    procedure WriteData(Stream: TBisSmppStream); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property NumberOfDests: Byte read GetNumberOfDests;
    property DestAddresses: TBisSmppDestAddresses read FDestAddresses;
  end;

  TBisSmppUnsuccessSme=class(TObjectList)
  private
    FAddrNpi: TBisSmppNumberingPlanIndicator;
    FAddr: String;
    FAddrTon: TBisSmppTypeOfNumber;
    FErrorStatusCode: TBisSmppCommandStatus;
  public
    property AddrTon: TBisSmppTypeOfNumber read FAddrTon write FAddrTon;
    property AddrNpi: TBisSmppNumberingPlanIndicator read FAddrNpi write FAddrNpi;
    property Addr: String read FAddr write FAddr;
    property ErrorStatusCode: TBisSmppCommandStatus read FErrorStatusCode write FErrorStatusCode;
  end;

  TBisSmppUnsuccessSmes=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSmppUnsuccessSme;
  public
    function Add(AddrTon: TBisSmppTypeOfNumber; AddrNpi: TBisSmppNumberingPlanIndicator;
                 Addr: String; ErrorStatusCode: TBisSmppCommandStatus): TBisSmppUnsuccessSme;

    property Items[Index: Integer]: TBisSmppUnsuccessSme read GetItem; default;
  end;

  TBisSmppSubmitMultiResponse=class(TBisSmppResponse)
  private
    FMessageId: String;
    FUnsuccessSmes: TBisSmppUnsuccessSmes;
    function GetNoUnsuccess: Byte;
  protected
    class function GetCommandId: Cardinal; override;
    procedure ReadData(Stream: TBisSmppStream); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property MessageId: String read FMessageId;
    property NoUnsuccess: Byte read GetNoUnsuccess;
    property UnsuccessSmes: TBisSmppUnsuccessSmes read FUnsuccessSmes; 
  end;

  TBisSmppDeliverSmRequest=class(TBisSmppRequest)
  private
    FSourceAddrNpi: TBisSmppNumberingPlanIndicator;
    FSourceAddr: String;
    FSourceAddrTon: TBisSmppTypeOfNumber;
    FServiceType: String;
    FDestinationAddr: String;
    FEsmClassMessagingMode: TBisSmppEsmClassMessagingMode;
    FDestAddrNpi: TBisSmppNumberingPlanIndicator;
    FEsmClassFeatures: TBisSmppEsmClassFeatures;
    FDestAddrTon: TBisSmppTypeOfNumber;
    FEsmClassMessageType: TBisSmppEsmClassMessagingType;
    FPriorityFlag: TBisSmppPriorityFlag;
    FProtocolId: TBisSmmProtocolId;
    FRegisteredDeliveryNotification: Boolean;
    FDataCoding: TBisSmppDataCoding;
    FRegisteredDeliveryAck: TBisSmppRegisteredDeliveryAck;
    FRegisteredDeliveryReceipt: TBisSmppRegisteredDeliveryReceipt;
    FScheduleDeliveryTime: TDateTime;
    FReplaceIfPresentFlag: Boolean;
    FValidityPeriod: Int64;
    FSmDefaultMsgId: Byte;
    FShortMessage: String;
    FSmLength: Byte;
    FIndication: TBisSmppIndication;
  protected
    class function GetCommandId: Cardinal; override;
    procedure ReadData(Stream: TBisSmppStream); override;
  public
    property ServiceType: String read FServiceType write FServiceType;
    property SourceAddrTon: TBisSmppTypeOfNumber read FSourceAddrTon write FSourceAddrTon;
    property SourceAddrNpi: TBisSmppNumberingPlanIndicator read FSourceAddrNpi write FSourceAddrNpi;
    property SourceAddr: String read FSourceAddr write FSourceAddr;
    property DestAddrTon: TBisSmppTypeOfNumber read FDestAddrTon write FDestAddrTon;
    property DestAddrNpi: TBisSmppNumberingPlanIndicator read FDestAddrNpi write FDestAddrNpi;
    property DestinationAddr: String read FDestinationAddr write FDestinationAddr;
    property EsmClassMessagingMode: TBisSmppEsmClassMessagingMode read FEsmClassMessagingMode write FEsmClassMessagingMode;
    property EsmClassMessageType: TBisSmppEsmClassMessagingType read FEsmClassMessageType write FEsmClassMessageType;
    property EsmClassFeatures: TBisSmppEsmClassFeatures read FEsmClassFeatures write FEsmClassFeatures;
    property ProtocolId: TBisSmmProtocolId read FProtocolId write FProtocolId;
    property PriorityFlag: TBisSmppPriorityFlag read FPriorityFlag write FPriorityFlag;
    property ScheduleDeliveryTime: TDateTime read FScheduleDeliveryTime write FScheduleDeliveryTime;
    property ValidityPeriod: Int64 read FValidityPeriod write FValidityPeriod;
    property RegisteredDeliveryReceipt: TBisSmppRegisteredDeliveryReceipt read FRegisteredDeliveryReceipt write FRegisteredDeliveryReceipt;
    property RegisteredDeliveryAck: TBisSmppRegisteredDeliveryAck read FRegisteredDeliveryAck write FRegisteredDeliveryAck;
    property RegisteredDeliveryNotification: Boolean read FRegisteredDeliveryNotification write FRegisteredDeliveryNotification;
    property ReplaceIfPresentFlag: Boolean read FReplaceIfPresentFlag write FReplaceIfPresentFlag;
    property DataCoding: TBisSmppDataCoding read FDataCoding write FDataCoding;
    property Indication: TBisSmppIndication read FIndication write FIndication;
    property SmDefaultMsgId: Byte read FSmDefaultMsgId write FSmDefaultMsgId;
    property SmLength: Byte read FSmLength write FSmLength;
    property ShortMessage: String read FShortMessage write FShortMessage;
  end;

  TBisSmppDeliverSmResponse=class(TBisSmppResponse)
  private
    FMessageId: String;
  protected
    class function GetCommandId: Cardinal; override;
    procedure WriteData(Stream: TBisSmppStream); override;
  public
    property MessageId: String read FMessageId write FMessageId;
  end;

  TBisSmppDataSmRequest=class(TBisSmppRequest)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppDataSmResponse=class(TBisSmppResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppQuerySmRequest=class(TBisSmppRequest)
  private
    FMessageId: String;
    FSourceAddrNpi: TBisSmppNumberingPlanIndicator;
    FSourceAddr: String;
    FSourceAddrTon: TBisSmppTypeOfNumber;
  protected
    class function GetCommandId: Cardinal; override;
    procedure WriteData(Stream: TBisSmppStream); override;
  public
    property MessageId: String read FMessageId write FMessageId;
    property SourceAddrTon: TBisSmppTypeOfNumber read FSourceAddrTon write FSourceAddrTon;
    property SourceAddrNpi: TBisSmppNumberingPlanIndicator read FSourceAddrNpi write FSourceAddrNpi;
    property SourceAddr: String read FSourceAddr write FSourceAddr;
  end;

  TBisSmppMessageState=(msRESERVED,msENROUTE,msDELIVERED,msEXPIRED,msDELETED,msUNDELIVERABLE,msACCEPTED,msUNKNOWN,msREJECTED);

  TBisSmppQuerySmResponse=class(TBisSmppResponse)
  private
    FMessageId: String;
    FFinalDate: TDateTime;
    FMessageState: TBisSmppMessageState;
    FErrorCode: Byte;
  protected
    class function GetCommandId: Cardinal; override;
    procedure ReadData(Stream: TBisSmppStream); override;
  public
    property MessageId: String read FMessageId;
    property FinalDate: TDateTime read FFinalDate;
    property MessageState: TBisSmppMessageState read FMessageState;
    property ErrorCode: Byte read FErrorCode;  
  end;

  TBisSmppCancelSmRequest=class(TBisSmppRequest)
  private
    FServiceType: String;
    FMessageId: String;
    FSourceAddrNpi: TBisSmppNumberingPlanIndicator;
    FSourceAddr: String;
    FSourceAddrTon: TBisSmppTypeOfNumber;
    FDestinationAddr: String;
    FDestAddrNpi: TBisSmppNumberingPlanIndicator;
    FDestAddrTon: TBisSmppTypeOfNumber;
  protected
    class function GetCommandId: Cardinal; override;
    procedure WriteData(Stream: TBisSmppStream); override;
  public
    property ServiceType: String read FServiceType write FServiceType;
    property MessageId: String read FMessageId write FMessageId;
    property SourceAddrTon: TBisSmppTypeOfNumber read FSourceAddrTon write FSourceAddrTon;
    property SourceAddrNpi: TBisSmppNumberingPlanIndicator read FSourceAddrNpi write FSourceAddrNpi;
    property SourceAddr: String read FSourceAddr write FSourceAddr;
    property DestAddrTon: TBisSmppTypeOfNumber read FDestAddrTon write FDestAddrTon;
    property DestAddrNpi: TBisSmppNumberingPlanIndicator read FDestAddrNpi write FDestAddrNpi;
    property DestinationAddr: String read FDestinationAddr write FDestinationAddr;
  end;

  TBisSmppCancelSmResponse=class(TBisSmppResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppEnquireLinkRequest=class(TBisSmppRequest)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppEnquireLinkResponse=class(TBisSmppResponse)
  protected
    class function GetCommandId: Cardinal; override;
  end;

  TBisSmppAlertNotificationRequest=class(TBisSmppRequest)
  private
    FSourceAddrTon: TBisSmppTypeOfNumber;
    FSourceAddrNpi: TBisSmppNumberingPlanIndicator;
    FSourceAddr: String;
    FEsmeAddrTon: TBisSmppTypeOfNumber;
    FEsmeAddrNpi: TBisSmppNumberingPlanIndicator;
    FEmseAddr: String;
  protected
    class function GetCommandId: Cardinal; override;
    procedure ReadData(Stream: TBisSmppStream); override;
  public
    property SourceAddrTon: TBisSmppTypeOfNumber read FSourceAddrTon;
    property SourceAddrNpi: TBisSmppNumberingPlanIndicator read FSourceAddrNpi;
    property SourceAddr: String read FSourceAddr;
    property EsmeAddrTon: TBisSmppTypeOfNumber read FEsmeAddrTon;
    property EsmeAddrNpi: TBisSmppNumberingPlanIndicator read FEsmeAddrNpi;
    property EmseAddr: String read FEmseAddr;
  end;

const
  NullDateTime=0.0;

procedure InvertBytes(var Bytes: TBytes);
function FindStatusInfo(Status: TBisSmppCommandStatus): TBisSmppCommandStatusInfo;
function FindMessageClass(CommandId: Cardinal): TBisSmppMessageClass;
function BytesToString(Bytes: TBytes; FromPos: Integer): String;


implementation

uses Windows, DateUtils,
     BisUtils;

var
  FParameterClassList: TClassList=nil;
  FMessageClassList: TClassList=nil;
  FCommandStatusList: TObjectList=nil;

const
  DefaultInterfaceVersion=$34;

{ TBisSmppCommandStatusInfo }

constructor TBisSmppCommandStatusInfo.Create(Status: TBisSmppCommandStatus; Code: Cardinal; Description: String);
begin
  inherited Create;
  FStatus:=Status;
  FCode:=Code;
  FDescription:=Description
end;

function CodeToStatus(Code: Cardinal; var Status: TBisSmppCommandStatus): Boolean;
var
  i: Integer;
  Item: TBisSmppCommandStatusInfo;
begin
  Result:=false;
  if Assigned(FCommandStatusList) then begin
    for i:=0 to FCommandStatusList.Count-1 do begin
      Item:=TBisSmppCommandStatusInfo(FCommandStatusList.Items[i]);
      if Item.Code=Code then begin
        Status:=Item.Status;
        Result:=true;
        exit;
      end;
    end;
  end;
end;

function FindStatusInfo(Status: TBisSmppCommandStatus): TBisSmppCommandStatusInfo;
var
  i: Integer;
  Item: TBisSmppCommandStatusInfo;
begin
  Result:=nil;
  if Assigned(FCommandStatusList) then begin
    for i:=0 to FCommandStatusList.Count-1 do begin
      Item:=TBisSmppCommandStatusInfo(FCommandStatusList.Items[i]);
      if Item.Status=Status then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function StatusToCode(Status: TBisSmppCommandStatus; var Code: Cardinal): Boolean;
var
  Item: TBisSmppCommandStatusInfo;
begin
  Result:=false;
  Item:=FindStatusInfo(Status);
  if Assigned(Item) then begin
    Code:=Item.Code;
    Result:=true;
  end;
end;

function FindMessageClass(CommandId: Cardinal): TBisSmppMessageClass;
var
  i: Integer;
  AClass: TBisSmppMessageClass;
begin
  Result:=nil;
  if Assigned(FMessageClassList) then begin
    for i:=0 to FMessageClassList.Count-1 do begin
      AClass:=TBisSmppMessageClass(FMessageClassList[i]);
      if AClass.GetCommandId=CommandId then begin
        Result:=AClass;
        exit;
      end;
    end;
  end;
end;

function FindParameterClass(Tag: Word): TBisSmppOptionalParameterClass;
var
  i: Integer;
  AClass: TBisSmppOptionalParameterClass;
begin
  Result:=nil;
  if Assigned(FParameterClassList) then begin
    for i:=0 to FParameterClassList.Count-1 do begin
      AClass:=TBisSmppOptionalParameterClass(FParameterClassList[i]);
      if AClass.GetParameterTag=Tag then begin
        Result:=AClass;
        exit;
      end;
    end;
  end;
end;

procedure InvertBytes(var Bytes: TBytes);
var
  D: TBytes;
  i: Integer;
  L: Integer;
begin
  L:=Length(Bytes);
  SetLength(D,L);
  for i:=0 to L-1 do
    D[i]:=Bytes[L-i-1];
  Move(Pointer(D)^,Pointer(Bytes)^,L);
end;

procedure SetBit(var Value: Byte; Bit: Byte);
begin
  Value:=Value or (1 shl Bit);
end;

function GetBit(Value: Byte; Bit: Byte): Boolean;
begin
  Result:=(Value and (1 shl Bit)) <> 0;
end;

procedure SetBits(var Value: Byte; Bits: array of Byte);
var
  i: Integer;
begin
  for i:=Low(Bits) to High(Bits) do
    if Bits[i]<8 then
      SetBit(Value,Bits[i]);
end;

procedure GetBits(Value: Byte; var B0,B1,B2,B3,B4,B5,B6,B7: Boolean);
begin
  B0:=GetBit(Value,0);
  B1:=GetBit(Value,1);
  B2:=GetBit(Value,2);
  B3:=GetBit(Value,3);
  B4:=GetBit(Value,4);
  B5:=GetBit(Value,5);
  B6:=GetBit(Value,6);
  B7:=GetBit(Value,7);
end;

procedure SetByte(var Value1: Byte; FromBit, ToBit: Byte; Value2: Byte);
var
  i: Byte;
  Bi: Boolean;
begin
  for i:=ToBit downto FromBit do begin
    Bi:=GetBit(Value2,i);
    if Bi then begin
      SetBit(Value1,i);
    end;
  end;
end;

function GetByte(Value: Byte; FromBit, ToBit: Byte): Byte;
var
  i: Byte;
  Bi: Boolean;
begin
  Result:=0;
  for i:=ToBit downto FromBit do begin
    Bi:=GetBit(Value,i);
    if Bi then begin
      Result:=Result or (1 shl i);
    end;
  end;
end;

function BitsExists(Value: Byte; Bits: array of Byte): Boolean;

  function InBits(Bit: Byte): Boolean;
  var
    i: Integer;
  begin
    Result:=false;
    for i:=Low(Bits) to High(Bits) do begin
      if Bits[i]=Bit then begin
        Result:=true;
        exit;
      end;
    end;
  end;

var
  i: Byte;
begin
  Result:=(High(Bits)-Low(Bits))>0;
  for i:=0 to 7 do begin
    if InBits(i) then
      Result:=Result and GetBit(Value,i)
    else
      Result:=Result and not GetBit(Value,i);
    if not Result then
      break;
  end;
end;

function BitExists(Value: Byte; Bit: Byte): Boolean;
begin
  Result:=BitsExists(Value,[Bit]);
end;

function ConvertDateToTimeFormat(D: TDateTime): String;
begin
  Result:=FormatDateTime('yymmddhhnnssz00R',D);
end;

function ConvertTimeFormatToDate(const S: String): TDateTime;
var
  S1: String;
  Year,Month,Day,Hour,Minute,Sec: Word;
begin
  Result:=NullDateTime;
  S1:=Trim(S);
  if Length(S1)=17 then begin
    try
      Year:=StrToIntDef(Copy(S1,1,2),0);
      Month:=StrToIntDef(Copy(S1,3,2),0);
      Day:=StrToIntDef(Copy(S1,5,2),0);
      Hour:=StrToIntDef(Copy(S1,7,2),0);
      Minute:=StrToIntDef(Copy(S1,9,2),0);
      Sec:=StrToIntDef(Copy(S1,11,2),0);

      Result:=EncodeDateTime(Year,Month,Day,Hour,Minute,Sec,0);
    except
      On E: Exception do
        Result:=Now;
    end;
  end;
end;

function ConvertSecondsToTimeFormat(Secs: Int64): String;
var
  Year,Month,Day,Hour,Minute,Sec: Word;
  D1,D2: TDateTime;
begin
  Result:='';
  D1:=Now;
  D2:=D1;
  D2:=IncSecond(D2,Secs);
  Year:=YearsBetween(D1,D2);
  D2:=IncYear(D2,-Year);
  Month:=MonthsBetween(D1,D2);
  D2:=IncMonth(D2,-Month);
  Day:=DaysBetween(D1,D2);
  D2:=IncDay(D2,-Day);
  Hour:=HoursBetween(D1,D2);
  D2:=IncHour(D2,-Hour);
  Minute:=MinutesBetween(D1,D2);
  D2:=IncMinute(D2,-Minute);
  Sec:=SecondsBetween(D1,D2);
  Result:=Format('%.*d%.*d%.*d%.*d%.*d%.*d000R',[2,Year,2,Month,2,Day,2,Hour,2,Minute,2,Sec]);
end;

function BytesToString(Bytes: TBytes; FromPos: Integer): String;
var
  P: Pointer;
begin
  Result:='';
  if Length(Bytes)>FromPos then begin
    SetLength(Result,Length(Bytes)-FromPos);
    P:=Pointer(Integer(Pointer(Bytes))+FromPos);
    Move(P^,Pointer(Result)^,Length(Result));
  end;
end;

function StringToBytes(S: String; var Bytes: TBytes): Boolean;
begin
  Result:=false;
  if Length(S)>0 then begin
    SetLength(Bytes,Length(S));
    Move(Pointer(S)^,Pointer(Bytes)^,Length(Bytes));
    Result:=Length(Bytes)>0;
  end;
end;

{function CopyToBytes(var Dest: TBytes; Source: TBytes; FromPos,FromLen: Integer): Boolean;
var
  P: Pointer;
begin
  Result:=false;
  if Assigned(Source) then begin
    if not Assigned(Dest) or (Length(Dest)<FromLen) then
      SetLength(Dest,FromLen);
    P:=Pointer(Integer(Pointer(Dest))+FromPos);
    Move(Pointer(Source)^,P^,FromLen);
    Result:=true;
  end;
end;}

function CopyBytes(Source: TBytes; FromPos,FromLen: Integer; var Dest: TBytes; ToPos: Integer=0): Boolean;
var
  P1,P2: Pointer;
begin
  Result:=false;
  if Assigned(Source) then begin
    if not Assigned(Dest) or (Length(Dest)<(FromLen+ToPos)) then
      SetLength(Dest,FromLen+ToPos);
    P1:=Pointer(Integer(Pointer(Source))+FromPos);
    P2:=Pointer(Integer(Pointer(Dest))+ToPos);
    Move(P1^,P2^,FromLen);
    Result:=true;
  end;
end;

{ TBisSmppStream }

procedure TBisSmppStream.WriteBytes(Value: TBytes);
begin
  Write(Pointer(Value)^,Length(Value));
end;

procedure TBisSmppStream.WriteByte(Value: Byte);
begin
  Write(Value,SizeOf(Value));
end;

procedure TBisSmppStream.WriteWord(Value: Word);
var
  Bytes: TBytes;
begin
  SetLength(Bytes,SizeOf(Value));
  Move(Value,Pointer(Bytes)^,Length(Bytes));
  InvertBytes(Bytes);
  WriteBytes(Bytes);
end;

procedure TBisSmppStream.WriteInteger(Value: Integer);
var
  Bytes: TBytes;
begin
  SetLength(Bytes,SizeOf(Value));
  Move(Value,Pointer(Bytes)^,Length(Bytes));
  InvertBytes(Bytes);
  WriteBytes(Bytes);
end;

procedure TBisSmppStream.WriteString(Value: String; Len: Cardinal=MaxInt; WithZero: Boolean=true);
var
  V: String;
begin
  V:=Copy(Value,1,Len);
  if WithZero then
    V:=V+#0;
  Write(Pointer(V)^,Length(V));
end;

procedure TBisSmppStream.ReadBytes(var Value: TBytes);
begin
  Read(Pointer(Value)^,Length(Value));
end;

function TBisSmppStream.ReadByte: Byte;
begin
  Read(Result,SizeOf(Result));
end;

function TBisSmppStream.ReadWord: Word;
var
  Bytes: TBytes;
begin
  SetLength(Bytes,SizeOf(Result));
  ReadBytes(Bytes);
  InvertBytes(Bytes);
  Move(Pointer(Bytes)^,Result,Length(Bytes));
end;

function TBisSmppStream.ReadInteger: Integer;
var
  Bytes: TBytes;
begin
  SetLength(Bytes,SizeOf(Result));
  ReadBytes(Bytes);
  InvertBytes(Bytes);
  Move(Pointer(Bytes)^,Result,Length(Bytes));
end;

function TBisSmppStream.ReadString(Len: Cardinal): String;
var
  i: Cardinal;
  B: Byte;
begin
  Result:='';
  for i:=1 to Len do begin
    if Size>Position then begin
      B:=ReadByte;
      if (B=0) then
        break;
      Result:=Result+Char(B);
    end else
      break;
  end;
end;

{ TBisSmppOptionalParameter }

constructor TBisSmppOptionalParameter.Create(AData: TBytes=nil);
begin
  inherited Create;
  if Assigned(AData) then begin
    SetLength(FData,Length(AData));
    Move(Pointer(AData)^,Pointer(FData)^,Length(AData));
  end;
end;

{ TBisSmppBooleanValue }

function TBisSmppBooleanValue.GetValue: Boolean;
begin
  Result:=false;
  if Length(FData)=1 then
    Result:=Boolean(FData[0]);
end;

procedure TBisSmppBooleanValue.SetValue(AValue: Boolean);
var
  D: TBytes;
begin
  SetLength(D,1);
  D[0]:=Byte(AValue);
  CopyBytes(D,0,Length(D),FData);
end;

{ TBisSmppByteValue }

function TBisSmppByteValue.GetValue: Byte;
begin
  Result:=0;
  if Length(FData)=1 then
    Result:=FData[0];
end;

procedure TBisSmppByteValue.SetValue(AValue: Byte);
var
  D: TBytes;
begin
  SetLength(D,SizeOf(AValue));
  if Length(D)>0 then begin
    D[0]:=AValue;
    CopyBytes(D,0,Length(D),FData);
  end;
end;

{ TBisSmppWordValue }

function TBisSmppWordValue.GetValue: Word;
var
  D: TBytes;
begin
  Result:=0;
  if Length(FData)=2 then begin
    SetLength(D,Length(FData));
    Move(Pointer(FData)^,Pointer(D)^,Length(D));
//    InvertBytes(D);
    Move(Pointer(D)^,Result,Length(D));
  end;
end;

procedure TBisSmppWordValue.SetValue(AValue: Word);
var
  D: TBytes;
begin
  SetLength(D,SizeOf(AValue));
  if Length(D)=2 then begin
    Move(AValue,Pointer(D)^,Length(D));
    InvertBytes(D);
    CopyBytes(D,0,Length(D),FData);
  end;
end;

{ TBisSmppStringValue }

function TBisSmppStringValue.GetValue: String;
begin
  Result:='';
  if Length(FData)>0 then
    Result:=BytesToString(FData,0);
end;

procedure TBisSmppStringValue.SetValue(AValue: String);
var
  D: TBytes;
begin
  if StringToBytes(AValue,D) then
    CopyBytes(D,0,Length(D),FData);
end;

{ TBisSmppScInterfaceVersion }

class function TBisSmppScInterfaceVersion.GetParameterTag: Word;
begin
  Result:=$0210;
end;

{ TBisSmppMsAvailabilityStatus }

class function TBisSmppMsAvailabilityStatus.GetParameterTag: Word;
begin
  Result:=$0422;
end;

function TBisSmppMsAvailabilityStatus.GetValue: TBisSmppMsAvailabilityStatusValue;
begin
  Result:=TBisSmppMsAvailabilityStatusValue(inherited Value);
end;

procedure TBisSmppMsAvailabilityStatus.SetValue(AValue: TBisSmppMsAvailabilityStatusValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppUserMessageReference }

class function TBisSmppUserMessageReference.GetParameterTag: Word;
begin
  Result:=$0204;
end;

{ TBisSmppSourcePort }

class function TBisSmppSourcePort.GetParameterTag: Word;
begin
  Result:=$0205;
end;

{ TBisSmppAddrSubunit }

function TBisSmppAddrSubunit.GetValue: TBisSmppAddrSubunitValue;
begin
  Result:=TBisSmppAddrSubunitValue(inherited Value);
end;

procedure TBisSmppAddrSubunit.SetValue(AValue: TBisSmppAddrSubunitValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppSourceAddrSubunit }

class function TBisSmppSourceAddrSubunit.GetParameterTag: Word;
begin
  Result:=$000D;
end;

{ TBisSmppDestinationPort }

class function TBisSmppDestinationPort.GetParameterTag: Word;
begin
  Result:=$020B;
end;

{ TBisSmppDestAddrSubunit }

class function TBisSmppDestAddrSubunit.GetParameterTag: Word;
begin
  Result:=$0005;
end;

{ TBisSmppSarMsgRefNum }

class function TBisSmppSarMsgRefNum.GetParameterTag: Word;
begin
  Result:=$020C;
end;

{ TBisSmppSarTotalSegments }

class function TBisSmppSarTotalSegments.GetParameterTag: Word;
begin
  Result:=$020E;
end;

{ TBisSmppSarSegmentSeqnum }

class function TBisSmppSarSegmentSeqnum.GetParameterTag: Word;
begin
  Result:=$020F;
end;

{ TBisSmppMoreMessagesToSend }

class function TBisSmppMoreMessagesToSend.GetParameterTag: Word;
begin
  Result:=$0426;
end;

{ TBisSmppPayloadType }

class function TBisSmppPayloadType.GetParameterTag: Word;
begin
  Result:=$0019;
end;

function TBisSmppPayloadType.GetValue: TBisSmppPayloadTypeValue;
begin
   Result:=TBisSmppPayloadTypeValue(inherited Value);
end;

procedure TBisSmppPayloadType.SetValue(AValue: TBisSmppPayloadTypeValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppMessagePayload }

class function TBisSmppMessagePayload.GetParameterTag: Word;
begin
  Result:=$0424;
end;

{ TBisSmppPrivacyIndicator }

class function TBisSmppPrivacyIndicator.GetParameterTag: Word;
begin
  Result:=$0201;
end;

function TBisSmppPrivacyIndicator.GetValue: TBisSmppPrivacyIndicatorValue;
begin
  Result:=TBisSmppPrivacyIndicatorValue(inherited Value);
end;

procedure TBisSmppPrivacyIndicator.SetValue(AValue: TBisSmppPrivacyIndicatorValue);
begin
  inherited Value:=Byte(AValue); 
end;

{ TBisSmppCallbackNum }

class function TBisSmppCallbackNum.GetParameterTag: Word;
begin
  Result:=$0381;
end;

function TBisSmppCallbackNum.GetDigitMode: TBisSmppCallbackNumDigitMode;
var
  Bit: Boolean;
begin
  Result:=cndmDTMF;
  if Length(FData)>0 then begin
    Bit:=GetBit(FData[0],0);
    if not Bit then
      Result:=cndmDTMF
    else
      Result:=cndmASCII;
  end;
end;

procedure TBisSmppCallbackNum.SetDigitMode(const Value: TBisSmppCallbackNumDigitMode);
var
  D: TBytes;
begin
  SetLength(D,1);
  case Value of
    cndmDTMF: ;
    cndmASCII: SetBit(D[0],0);
  end;
  CopyBytes(D,0,Length(D),FData);
end;

function TBisSmppCallbackNum.GetNPI: TBisSmppNumberingPlanIndicator;
begin
  Result:=npiUnknown;
  if Length(FData)>2 then
    Result:=TBisSmppNumberingPlanIndicator(FData[2]);
end;

procedure TBisSmppCallbackNum.SetNPI(const Value: TBisSmppNumberingPlanIndicator);
var
  D: TBytes;
begin
  SetLength(D,1);
  D[0]:=Byte(Value);
  CopyBytes(D,0,Length(D),FData,2);
end;

function TBisSmppCallbackNum.GetTON: TBisSmppTypeOfNumber;
begin
  Result:=tonUnknown;
  if Length(FData)>1 then
    Result:=TBisSmppTypeOfNumber(FData[1]);
end;

procedure TBisSmppCallbackNum.SetTON(const Value: TBisSmppTypeOfNumber);
var
  D: TBytes;
begin
  SetLength(D,1);
  D[0]:=Byte(Value);
  CopyBytes(D,0,Length(D),FData,1);
end;

function TBisSmppCallbackNum.GetNumber: String;
begin
  Result:='';
  if Length(FData)>3 then
    Result:=BytesToString(FData,3);
end;

procedure TBisSmppCallbackNum.SetNumber(const Value: String);
var
  D: TBytes;
begin
  if StringToBytes(Value,D) then
    CopyBytes(D,0,Length(D),FData,3);
end;


{ TBisSmppCallbackNumPresInd }

class function TBisSmppCallbackNumPresInd.GetParameterTag: Word;
begin
  Result:=$0302;
end;

function TBisSmppCallbackNumPresInd.GetPresentation: TBisSmppCallbackNumPresIndPresentation;
var
  Bit2,Bit3: Boolean;
begin
  Result:=cnpipAllowed;
  if Length(FData)>0 then begin
    Bit2:=GetBit(FData[0],2);
    Bit3:=GetBit(FData[0],3);
    if Bit2 and Bit3 then
      Result:=cnpipReserved
    else begin
      if Bit2 then
        Result:=cnpipRestricted;
      if Bit3 then
        Result:=cnpipNotAvailable;
    end;
  end;
end;

procedure TBisSmppCallbackNumPresInd.SetPresentation(const Value: TBisSmppCallbackNumPresIndPresentation);
var
  D: TBytes;
begin
  SetLength(D,1);
  if not CopyBytes(FData,0,Length(D),D) then
    D[0]:=0;
  case Value of
    cnpipAllowed: ;
    cnpipRestricted: SetBit(D[0],2);
    cnpipNotAvailable: SetBit(D[0],3);
    cnpipReserved: SetBits(D[0],[2,3]);
  end;
  CopyBytes(D,0,Length(D),FData);
end;

function TBisSmppCallbackNumPresInd.GetScreening: TBisSmppCallbackNumPresIndScreening;
var
  Bit0,Bit1: Boolean;
begin
  Result:=cnpisUserProvidedNotScreened;
  if Length(FData)>0 then begin
    Bit0:=GetBit(FData[0],0);
    Bit1:=GetBit(FData[0],1);
    if Bit0 and Bit1 then
      Result:=cnpisNetworkProvided
    else begin
      if Bit0 then
        Result:=cnpisUserProvidedVerifiedAndPassed;
      if Bit1 then
        Result:=cnpisUserProvidedVerifiedAndFailed;
    end;
  end;
end;

procedure TBisSmppCallbackNumPresInd.SetScreening(const Value: TBisSmppCallbackNumPresIndScreening);
var
  D: TBytes;
begin
  SetLength(D,1);
  if not CopyBytes(FData,0,Length(D),D) then
    D[0]:=0;
  case Value of
    cnpisUserProvidedNotScreened: ;
    cnpisUserProvidedVerifiedAndPassed: SetBit(D[0],0);
    cnpisUserProvidedVerifiedAndFailed: SetBit(D[0],1);
    cnpisNetworkProvided: SetBits(D[0],[0,1]);
  end;
  CopyBytes(D,0,Length(D),FData);
end;

{ TBisSmppCallbackNumAtag }

class function TBisSmppCallbackNumAtag.GetParameterTag: Word;
begin
  Result:=$0303;
end;

function TBisSmppCallbackNumAtag.GetDataCoding: TBisSmppDataCoding;
begin
  Result:=dcDefaultAlphabet;
  if Length(FData)>0 then begin

    if BitsExists(FData[0],[0]) then Result:=dcIA5;
    if BitsExists(FData[0],[1]) then Result:=dcOctetUnspecified1;
    if BitsExists(FData[0],[0,1]) then Result:=dcLatin1;
    if BitsExists(FData[0],[2]) then Result:=dcOctetUnspecified2;
    if BitsExists(FData[0],[0,2]) then Result:=dcJIS;
    if BitsExists(FData[0],[1,2]) then Result:=dcCyrllic;
    if BitsExists(FData[0],[0,1,2]) then Result:=dcLatinHebrew;
    if BitsExists(FData[0],[3]) then Result:=dcUCS2;
    if BitsExists(FData[0],[0,3]) then Result:=dcPictogramEncoding;
    if BitsExists(FData[0],[1,3]) then Result:=dcISO2022JP;
    if BitsExists(FData[0],[0,2,3]) then Result:=dcExtendedKanjiJIS;
    if BitsExists(FData[0],[1,2,3]) then Result:=dcKS;

  end;
end;

procedure TBisSmppCallbackNumAtag.SetDataCoding(const Value: TBisSmppDataCoding);
var
  D: TBytes;
begin
  SetLength(D,1);
  D[0]:=0;
  case Value of
    dcDefaultAlphabet: ;
    dcIA5: SetBit(D[0],0);
    dcOctetUnspecified1: SetBit(D[0],1);
    dcLatin1: SetBits(D[0],[0,1]);
    dcOctetUnspecified2: SetBit(D[0],2);
    dcJIS: SetBits(D[0],[0,2]);
    dcCyrllic: SetBits(D[0],[1,2]);
    dcLatinHebrew: SetBits(D[0],[0,1,2]);
    dcUCS2: SetBit(D[0],3);
    dcPictogramEncoding: SetBits(D[0],[0,3]);
    dcISO2022JP: SetBits(D[0],[1,3]);
    dcExtendedKanjiJIS: SetBits(D[0],[0,2,3]);
    dcKS: SetBits(D[0],[1,2,3]);
  end;
  CopyBytes(D,0,Length(D),FData);
end;

function TBisSmppCallbackNumAtag.GetDisplay: String;
begin
  Result:='';
  if Length(FData)>1 then
    Result:=BytesToString(FData,1);
end;

procedure TBisSmppCallbackNumAtag.SetDisplay(const Value: String);
var
  D: TBytes;
begin
  if StringToBytes(Value,D) then
    CopyBytes(D,0,Length(D),FData,1);
end;

{ TBisSmppSubaddress }

function TBisSmppSubaddress.GetSubaddressType: TBisSmppSubaddressType;
begin
  Result:=satUnknown;
  if Length(FData)>0 then begin

    if BitExists(FData[0],0) then Result:=satReserved01;
    if BitExists(FData[0],1) then Result:=satReserved02;
    if BitExists(FData[0],7) then Result:=satNSAPEven;
    if BitsExists(FData[0],[3,7]) then Result:=satNSAPOdd;
    if BitsExists(FData[0],[5,7]) then Result:=satUserSpecified;

  end;
end;

procedure TBisSmppSubaddress.SetSubaddressType(const Value: TBisSmppSubaddressType);
var
  D: TBytes;
begin
  SetLength(D,1);
  D[0]:=0;
  case Value of
    satUnknown: ;
    satReserved01: SetBit(D[0],0);
    satReserved02: SetBit(D[0],1);
    satNSAPEven: SetBit(D[0],7);
    satNSAPOdd: SetBits(D[0],[3,7]);
    satUserSpecified: SetBits(D[0],[5,7]);
  end;
  CopyBytes(D,0,Length(D),FData);
end;

function TBisSmppSubaddress.GetSubject: String;
begin
  Result:='';
  if Length(FData)>1 then
    Result:=BytesToString(FData,1);
end;

procedure TBisSmppSubaddress.SetSubject(const Value: String);
var
  D: TBytes;
begin
  if StringToBytes(Value,D) then
    CopyBytes(D,0,Length(D),FData,1);
end;

{ TBisSmppSourceSubaddress }

class function TBisSmppSourceSubaddress.GetParameterTag: Word;
begin
  Result:=$0202;
end;

{ TBisSmppDestSubaddress }

class function TBisSmppDestSubaddress.GetParameterTag: Word;
begin
  Result:=$0203;
end;

{ TBisSmppUserResponseCode }

class function TBisSmppUserResponseCode.GetParameterTag: Word;
begin
  Result:=$0205;
end;

{ TBisSmppDisplayTime }

class function TBisSmppDisplayTime.GetParameterTag: Word;
begin
  Result:=$1201;
end;

function TBisSmppDisplayTime.GetValue: TBisSmppDisplayTimeValue;
begin
  Result:=TBisSmppDisplayTimeValue(inherited Value);
end;

procedure TBisSmppDisplayTime.SetValue(AValue: TBisSmppDisplayTimeValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppSmsSignal }

class function TBisSmppSmsSignal.GetParameterTag: Word;
begin
  Result:=$1203;
end;

{ TBisSmppMsValidity }

class function TBisSmppMsValidity.GetParameterTag: Word;
begin
  Result:=$1204;
end;

function TBisSmppMsValidity.GetValue: TBisSmppMsValidityValue;
begin
  Result:=TBisSmppMsValidityValue(inherited Value);
end;

procedure TBisSmppMsValidity.SetValue(AValue: TBisSmppMsValidityValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppMsMsgWaitFacilities }

class function TBisSmppMsMsgWaitFacilities.GetParameterTag: Word;
begin
  Result:=$0030;
end;

function TBisSmppMsMsgWaitFacilities.GetIndicationInactive: Boolean;
begin
  Result:=false;
  if Length(FData)>0 then
    Result:=GetBit(FData[0],7);
end;

procedure TBisSmppMsMsgWaitFacilities.SetIndicationInactive(const Value: Boolean);
var
  D: TBytes;
begin
  SetLength(D,1);
  if not CopyBytes(FData,0,Length(D),D) then
    D[0]:=0;
  if Value then
    SetBit(D[0],7);
  CopyBytes(D,0,Length(D),FData);  
end;

function TBisSmppMsMsgWaitFacilities.GetMessageType: TBisSmppMsMsgWaitFacilitiesType;
var
  Bit0,Bit1: Boolean;
begin
  Result:=mmwftVoicemail;
  if Length(FData)>0 then begin
    Bit0:=GetBit(FData[0],0);
    Bit1:=GetBit(FData[0],1);

    if not Bit0 and not Bit1 then
      Result:=mmwftVoicemail;

    if Bit0 and not Bit1 then
      Result:=mmwftFax;

    if not Bit0 and Bit1 then
      Result:=mmwftElectronicMail;

    if Bit0 and Bit1 then
      Result:=mmwftOther;

  end;
end;

procedure TBisSmppMsMsgWaitFacilities.SetMessageType(const Value: TBisSmppMsMsgWaitFacilitiesType);
var
  D: TBytes;
begin
  SetLength(D,1);
  if not CopyBytes(FData,0,Length(D),D) then
    D[0]:=0;
  case Value of
    mmwftVoicemail: ;
    mmwftFax: SetBit(D[0],0);
    mmwftElectronicMail: SetBit(D[0],1);
    mmwftOther: SetBits(D[0],[0,1]);
  end;
  CopyBytes(D,0,Length(D),FData)
end;


{ TBisSmppNumberOfMessages }

class function TBisSmppNumberOfMessages.GetParameterTag: Word;
begin
  Result:=$0304;
end;

{ TBisSmppAlertOnMsgDelivery }

class function TBisSmppAlertOnMsgDelivery.GetParameterTag: Word;
begin
  Result:=$130C;
end;

{ TBisSmppLanguageIndicator }

class function TBisSmppLanguageIndicator.GetParameterTag: Word;
begin
  Result:=$020D;
end;

function TBisSmppLanguageIndicator.GetValue: TBisSmppLanguageIndicatorValue;
begin
  Result:=TBisSmppLanguageIndicatorValue(inherited Value);
end;

procedure TBisSmppLanguageIndicator.SetValue(AValue: TBisSmppLanguageIndicatorValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppItsReplyType }

class function TBisSmppItsReplyType.GetParameterTag: Word;
begin
  Result:=$1380;
end;

function TBisSmppItsReplyType.GetValue: TBisSmppItsReplyTypeValue;
begin
  Result:=TBisSmppItsReplyTypeValue(inherited Value);
end;

procedure TBisSmppItsReplyType.SetValue(AValue: TBisSmppItsReplyTypeValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppItsSessionInfo }

class function TBisSmppItsSessionInfo.GetParameterTag: Word;
begin
  Result:=$1383;
end;

function TBisSmppItsSessionInfo.GetSessionNumber: Byte;
begin
  Result:=0;
  if Length(FData)>0 then
    Result:=FData[0];
end;

procedure TBisSmppItsSessionInfo.SetSessionNumber(const Value: Byte);
var
  D: TBytes;
begin
  SetLength(D,1);
  D[0]:=Value;
  CopyBytes(D,0,Length(D),FData);
end;

function TBisSmppItsSessionInfo.GetSequenceNumber: Byte;
begin
  Result:=0;
  if Length(FData)>1 then
    Result:=GetByte(FData[1],1,7);
end;

procedure TBisSmppItsSessionInfo.SetSequenceNumber(const Value: Byte);
var
  D: TBytes;
begin
  SetLength(D,1);
  if not CopyBytes(FData,1,Length(D),D) then
    D[0]:=0;
  SetByte(D[0],1,7,Value);
  CopyBytes(D,0,Length(D),FData,1);
end;

function TBisSmppItsSessionInfo.GetEndIndicator: Boolean;
begin
  Result:=false;
  if Length(FData)>1 then
    Result:=GetBit(FData[1],0);
end;

procedure TBisSmppItsSessionInfo.SetEndIndicator(const Value: Boolean);
var
  D: TBytes;
begin
  SetLength(D,1);
  if not CopyBytes(FData,1,Length(D),D) then
    D[0]:=0;
  if Value then
    SetBit(D[0],0);
  CopyBytes(D,0,Length(D),FData,1);
end;


{ TBisSmppUssdServiceOp }

class function TBisSmppUssdServiceOp.GetParameterTag: Word;
begin
  Result:=$0501;
end;

function TBisSmppUssdServiceOp.GetValue: TBisSmppUssdServiceOpValue;
begin
  Result:=TBisSmppUssdServiceOpValue(inherited Value);
end;

procedure TBisSmppUssdServiceOp.SetValue(AValue: TBisSmppUssdServiceOpValue);
begin
  inherited Value:=Byte(AValue);
end;

{ TBisSmppOptionalParameters }

function TBisSmppOptionalParameters.AddDestAddrSubunit(Value: TBisSmppAddrSubunitValue): TBisSmppDestAddrSubunit;
begin
  Result:=TBisSmppDestAddrSubunit(AddClass(TBisSmppDestAddrSubunit));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddDestinationPort(Value: Word): TBisSmppDestinationPort;
begin
  Result:=TBisSmppDestinationPort(AddClass(TBisSmppDestinationPort));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddDestSubaddress(SubaddressType: TBisSmppSubaddressType; Subject: String): TBisSmppDestSubaddress;
begin
  Result:=TBisSmppDestSubaddress(AddClass(TBisSmppDestSubaddress));
  if Assigned(Result) then begin
    Result.SubaddressType:=SubaddressType;
    Result.Subject:=Subject;
  end;
end;

function TBisSmppOptionalParameters.AddDisplayTime(Value: TBisSmppDisplayTimeValue): TBisSmppDisplayTime;
begin
  Result:=TBisSmppDisplayTime(AddClass(TBisSmppDisplayTime));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddItsReplyType(Value: TBisSmppItsReplyTypeValue): TBisSmppItsReplyType;
begin
  Result:=TBisSmppItsReplyType(AddClass(TBisSmppItsReplyType));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddItsSessionInfo(SessionNumber, SequenceNumber: Byte; EndIndicator: Boolean): TBisSmppItsSessionInfo;
begin
  Result:=TBisSmppItsSessionInfo(AddClass(TBisSmppItsSessionInfo));
  if Assigned(Result) then begin
    Result.SessionNumber:=SessionNumber;
    Result.SequenceNumber:=SequenceNumber;
    Result.EndIndicator:=EndIndicator;
  end;
end;

function TBisSmppOptionalParameters.AddLanguageIndicator(Value: TBisSmppLanguageIndicatorValue): TBisSmppLanguageIndicator;
begin
  Result:=TBisSmppLanguageIndicator(AddClass(TBisSmppLanguageIndicator));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddMessagePayload(Value: String): TBisSmppMessagePayload;
begin
  Result:=TBisSmppMessagePayload(AddClass(TBisSmppMessagePayload));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddMoreMessagesToSend(Value: Boolean): TBisSmppMoreMessagesToSend;
begin
  Result:=TBisSmppMoreMessagesToSend(AddClass(TBisSmppMoreMessagesToSend));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddMsAvailabilityStatus(Value: TBisSmppMsAvailabilityStatusValue): TBisSmppMsAvailabilityStatus;
begin
  Result:=TBisSmppMsAvailabilityStatus(AddClass(TBisSmppMsAvailabilityStatus));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddMsMsgWaitFacilities(IndicationInactive: Boolean;
                                                           MessageType: TBisSmppMsMsgWaitFacilitiesType): TBisSmppMsMsgWaitFacilities;
begin
  Result:=TBisSmppMsMsgWaitFacilities(AddClass(TBisSmppMsMsgWaitFacilities));
  if Assigned(Result) then begin
    Result.IndicationInactive:=IndicationInactive;
    Result.MessageType:=MessageType;
  end;
end;

function TBisSmppOptionalParameters.AddMsValidity(Value: TBisSmppMsValidityValue): TBisSmppMsValidity;
begin
  Result:=TBisSmppMsValidity(AddClass(TBisSmppMsValidity));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddNumberOfMessages(Value: Byte): TBisSmppNumberOfMessages;
begin
  Result:=TBisSmppNumberOfMessages(AddClass(TBisSmppNumberOfMessages));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddPayloadType(Value: TBisSmppPayloadTypeValue): TBisSmppPayloadType;
begin
  Result:=TBisSmppPayloadType(AddClass(TBisSmppPayloadType));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddPrivacyIndicator(Value: TBisSmppPrivacyIndicatorValue): TBisSmppPrivacyIndicator;
begin
  Result:=TBisSmppPrivacyIndicator(AddClass(TBisSmppPrivacyIndicator));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddSarMsgRefNum(Value: Word): TBisSmppSarMsgRefNum;
begin
  Result:=TBisSmppSarMsgRefNum(AddClass(TBisSmppSarMsgRefNum));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddSarSegmentSeqnum(Value: Byte): TBisSmppSarSegmentSeqnum;
begin
  Result:=TBisSmppSarSegmentSeqnum(AddClass(TBisSmppSarSegmentSeqnum));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddSarTotalSegments(Value: Byte): TBisSmppSarTotalSegments;
begin
  Result:=TBisSmppSarTotalSegments(AddClass(TBisSmppSarTotalSegments));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddScInterfaceVersion(Value: Byte): TBisSmppScInterfaceVersion;
begin
  Result:=TBisSmppScInterfaceVersion(AddClass(TBisSmppScInterfaceVersion));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddSmsSignal(Value: Word): TBisSmppSmsSignal;
begin
  Result:=TBisSmppSmsSignal(AddClass(TBisSmppSmsSignal));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddSourceAddrSubunit(Value: TBisSmppAddrSubunitValue): TBisSmppSourceAddrSubunit;
begin
  Result:=TBisSmppSourceAddrSubunit(AddClass(TBisSmppSourceAddrSubunit));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddSourcePort(Value: Word): TBisSmppSourcePort;
begin
  Result:=TBisSmppSourcePort(AddClass(TBisSmppSourcePort));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddSourceSubaddress(SubaddressType: TBisSmppSubaddressType; Subject: String): TBisSmppSourceSubaddress;
begin
  Result:=TBisSmppSourceSubaddress(AddClass(TBisSmppSourceSubaddress));
  if Assigned(Result) then begin
    Result.SubaddressType:=SubaddressType;
    Result.Subject:=Subject;
  end;
end;

function TBisSmppOptionalParameters.AddUserMessageReference(Value: Word): TBisSmppUserMessageReference;
begin
  Result:=TBisSmppUserMessageReference(AddClass(TBisSmppUserMessageReference));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddUserResponseCode(Value: Byte): TBisSmppUserResponseCode;
begin
  Result:=TBisSmppUserResponseCode(AddClass(TBisSmppUserResponseCode));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddUssdServiceOp(Value: TBisSmppUssdServiceOpValue): TBisSmppUssdServiceOp;
begin
  Result:=TBisSmppUssdServiceOp(AddClass(TBisSmppUssdServiceOp));
  if Assigned(Result) then
    Result.Value:=Value;
end;

function TBisSmppOptionalParameters.AddAlertOnMsgDelivery: TBisSmppAlertOnMsgDelivery;
begin
  Result:=TBisSmppAlertOnMsgDelivery(AddClass(TBisSmppAlertOnMsgDelivery));
end;

function TBisSmppOptionalParameters.AddCallbackNum(DigitMode: TBisSmppCallbackNumDigitMode; TON: TBisSmppTypeOfNumber;
                                                   NPI: TBisSmppNumberingPlanIndicator; Number: String): TBisSmppCallbackNum;
begin
  Result:=TBisSmppCallbackNum(AddClass(TBisSmppCallbackNum));
  if Assigned(Result) then begin
    Result.DigitMode:=DigitMode;
    Result.TON:=TON;
    Result.NPI:=NPI;
    Result.Number:=Number;
  end;
end;

function TBisSmppOptionalParameters.AddCallbackNumAtag(DataCoding: TBisSmppDataCoding; Display: String): TBisSmppCallbackNumAtag;
begin
  Result:=TBisSmppCallbackNumAtag(AddClass(TBisSmppCallbackNumAtag));
  if Assigned(Result) then begin
    Result.DataCoding:=DataCoding;
    Result.Display:=Display;
  end;
end;

function TBisSmppOptionalParameters.AddCallbackNumPresInd(Presentation: TBisSmppCallbackNumPresIndPresentation;
                                                          Screening: TBisSmppCallbackNumPresIndScreening): TBisSmppCallbackNumPresInd;
begin
  Result:=TBisSmppCallbackNumPresInd(AddClass(TBisSmppCallbackNumPresInd));
  if Assigned(Result) then begin
    Result.Presentation:=Presentation;
    Result.Screening:=Screening;
  end;
end;

function TBisSmppOptionalParameters.FindClass(AClass: TBisSmppOptionalParameterClass): TBisSmppOptionalParameter;
var
  i: Integer;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    for i:=0 to Count-1 do begin
      if Items[i].ClassType=AClass then begin
        Result:=Items[i];
        exit;
      end;
    end;
  end;
end;

{function TBisSmppOptionalParameters.Add(Parameter: TBisSmppOptionalParameter): Integer;
var
  Item: TBisSmppOptionalParameter;
begin
  Result:=-1;
  if Assigned(Parameter) then begin
    Item:=FindClass(TBisSmppOptionalParameterClass(Parameter.ClassType));
    if not Assigned(Item) then
      Result:=inherited Add(Parameter);
  end;
end;}

function TBisSmppOptionalParameters.AddClass(AClass: TBisSmppOptionalParameterClass): TBisSmppOptionalParameter;
begin
  Result:=FindClass(AClass);
  if not Assigned(Result) then begin
    Result:=AClass.Create;
    inherited Add(Result);
  end;
end;

function TBisSmppOptionalParameters.GetItem(Index: Integer): TBisSmppOptionalParameter;
begin
  Result:=TBisSmppOptionalParameter(inherited Items[Index]);
end;

procedure TBisSmppOptionalParameters.ReadData(Stream: TBisSmppStream);
var
  Tag,Len: Word;
  Data: TBytes;
  AClass: TBisSmppOptionalParameterClass;
  Param: TBisSmppOptionalParameter;
begin
  while (Stream.Position<Stream.Size) do begin
    Tag:=Stream.ReadWord;
    Len:=Stream.ReadWord;
    SetLength(Data,Len);
    Stream.ReadBytes(Data);
    AClass:=FindParameterClass(Tag);
    if Assigned(AClass) then begin
      Param:=TBisSmppOptionalParameterClass(AClass).Create(Data);
      Add(Param);
    end;
  end;
end;

procedure TBisSmppOptionalParameters.WriteData(Stream: TBisSmppStream);
var
  i: Integer;
  Item: TBisSmppOptionalParameter;
  L: Word;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Stream.WriteWord(Item.ParameterTag);
    L:=Length(Item.FData);
    Stream.WriteWord(L);
    if L>0 then
      Stream.WriteBytes(Item.FData);
  end;
end;

{ TBisSmppMessage }

constructor TBisSmppMessage.Create;
begin
  inherited Create;
  FParameters:=TBisSmppOptionalParameters.Create;
end;

destructor TBisSmppMessage.Destroy;
begin
  FParameters.Free;
  inherited Destroy;
end;

function TBisSmppMessage.GetCommandStatus: TBisSmppCommandStatus;
var
  Status: TBisSmppCommandStatus;
begin
  Result:=csNoError;
  if CodeToStatus(FCommandStatusCode,Status) then
    Result:=Status;
end;

procedure TBisSmppMessage.SetCommandStatus(const Value: TBisSmppCommandStatus);
begin
  StatusToCode(Value,FCommandStatusCode);
end;

procedure TBisSmppMessage.WriteData(Stream: TBisSmppStream);
begin
  //
end;

function TBisSmppMessage.GetData(var Data: TBytes): Boolean;
var
  Stream: TBisSmppStream;
begin
  Stream:=TBisSmppStream.Create;
  try
    Stream.WriteInteger(GetCommandId);
    Stream.WriteInteger(FCommandStatusCode);
    Stream.WriteInteger(FSequenceNumber);

    WriteData(Stream);
    FParameters.WriteData(Stream);

    SetLength(Data,Stream.Size);
    Stream.Position:=0;
    Stream.ReadBytes(Data);
    Result:=Stream.Size>0;
  finally
    Stream.Free;
  end;
end;

procedure TBisSmppMessage.ReadData(Stream: TBisSmppStream);
begin
  //
end;

procedure TBisSmppMessage.SetData(Data: TBytes);
var
  Stream: TBisSmppStream;
begin
  Stream:=TBisSmppStream.Create;
  try
    Stream.WriteBytes(Data);
    Stream.Position:=0;

    Stream.ReadInteger; // CommandId
    FCommandStatusCode:=Stream.ReadInteger;
    FSequenceNumber:=Stream.ReadInteger;

    ReadData(Stream);
    FParameters.Clear;
    FParameters.ReadData(Stream);
  finally
    Stream.Free;
  end;
end;

{ TBisSmppMessages }

function TBisSmppMessages.GetItem(Index: Integer): TBisSmppMessage;
begin
  Result:=TBisSmppMessage(inherited Items[Index]);
end;

{ TBisSmppRequest }

destructor TBisSmppRequest.Destroy;
begin
  FreeAndNilEx(FResponse);
  inherited Destroy;
end;

{ TBisSmppRequests }

function TBisSmppRequests.GetItem(Index: Integer): TBisSmppRequest;
begin
  Result:=TBisSmppRequest(inherited Items[Index]);
end;

{ TBisSmppResponse }

procedure TBisSmppResponse.SetRequest(Request: TBisSmppRequest);
begin
  if Assigned(Request) then begin
    FSequenceNumber:=Request.SequenceNumber;
  end;
end;

{ TBisSmppGenericNackResponse }

class function TBisSmppGenericNackResponse.GetCommandId: Cardinal;
begin
  Result:=$80000000;
end;

{ TBisSmppBindRequest }

constructor TBisSmppBindRequest.Create;
begin
  inherited Create;
  FInterfaceVersion:=DefaultInterfaceVersion;
end;

procedure TBisSmppBindRequest.WriteData(Stream: TBisSmppStream);
begin
  inherited WriteData(Stream);
  Stream.WriteString(FSystemId,16);
  Stream.WriteString(FPassword,9);
  Stream.WriteString(FSystemType,13);
  Stream.WriteByte(FInterfaceVersion);
  Stream.WriteByte(Byte(FAddrTon));
  Stream.WriteByte(Byte(FAddrNpi));
  Stream.WriteString(FAddressRange,41);
end;

{ TBisSmppBindResponse }

procedure TBisSmppBindResponse.ReadData(Stream: TBisSmppStream);
begin
  inherited ReadData(Stream);
  FSystemId:=Stream.ReadString(16);
end;

{ TBisSmppBindTransmitterRequest }

class function TBisSmppBindTransmitterRequest.GetCommandId: Cardinal;
begin
  Result:=$00000002;
end;

{ TBisSmppBindTransmitterResponse }

class function TBisSmppBindTransmitterResponse.GetCommandId: Cardinal;
begin
  Result:=$80000002;
end;

{ TBisSmppBindReceiverRequest }

class function TBisSmppBindReceiverRequest.GetCommandId: Cardinal;
begin
  Result:=$00000001;
end;

{ TBisSmppBindReceiverResponse }

class function TBisSmppBindReceiverResponse.GetCommandId: Cardinal;
begin
  Result:=$80000001;
end;

{ TBisSmppBindTransceiverRequest }

class function TBisSmppBindTransceiverRequest.GetCommandId: Cardinal;
begin
  Result:=$00000009;
end;

{ TBisSmppBindTransceiverResponse }

class function TBisSmppBindTransceiverResponse.GetCommandId: Cardinal;
begin
  Result:=$80000009;
end;

{ TBisSmppOutbindRequest }

class function TBisSmppOutbindRequest.GetCommandId: Cardinal;
begin
  Result:=$0000000B;
end;

procedure TBisSmppOutbindRequest.ReadData(Stream: TBisSmppStream);
begin
  inherited ReadData(Stream);
  FSystemId:=Stream.ReadString(16);
  FPassword:=Stream.ReadString(9);
end;

{ TBisSmppUnBindRequest }

class function TBisSmppUnBindRequest.GetCommandId: Cardinal;
begin
  Result:=$00000006;
end;

{ TBisSmppUnBindResponse }

class function TBisSmppUnBindResponse.GetCommandId: Cardinal;
begin
  Result:=$80000006;
end;

{ TBisSmppSubmitSmRequest }

class function TBisSmppSubmitSmRequest.GetCommandId: Cardinal;
begin
  Result:=$00000004;
end;

procedure TBisSmppSubmitSmRequest.WriteData(Stream: TBisSmppStream);
var
  B: Byte;
  S: String;
begin
  inherited WriteData(Stream);

  Stream.WriteString(FServiceType,6);
  Stream.WriteByte(Byte(FSourceAddrTon));
  Stream.WriteByte(Byte(FSourceAddrNpi));
  Stream.WriteString(FSourceAddr,21);
  Stream.WriteByte(Byte(FDestAddrTon));
  Stream.WriteByte(Byte(FDestAddrNpi));
  Stream.WriteString(FDestinationAddr,21);

  B:=0;
  case FEsmClassMessagingMode of
    ecmDefault: ;
    ecmDatagram: SetBit(B,0);
    ecmForward: SetBit(B,1);
    ecmStoreAndForward: SetBits(B,[0,1]);
  end;
  case FEsmClassMessageType of
    ectDefault: ;
    ectDelivery: SetBit(B,3);
    ectManual: SetBit(B,4);
  end;
  case FEsmClassFeatures of
    ecfNotSelected: ;
    ecfUDHI: SetBit(B,6);
    ecfReplayPath: SetBit(B,7);
    ecfUDHIandReplyPath: SetBits(B,[6,7]);
  end;
  Stream.WriteByte(B);

  B:=0;
  case FProtocolId of
    pidSMEtoSME: ;
    pidTelematicImplicit: SetBit(B,5);
    pidTelematicTelex: SetBits(B,[0,5]);
    pidTelematicGroup3Telefax: SetBits(B,[1,5]);
    pidTelematicGroup4Telefax: SetBits(B,[0,1,5]);
    pidTelematicVoiceTelephone: SetBits(B,[2,5]);
    pidTelematicERMES: SetBits(B,[0,2,5]);
    pidTelematicNationalPagingSystem: SetBits(B,[1,2,5]);
    pidTelematicVideotex: SetBits(B,[0,1,2,5]);
    pidTelematicTeletexCarrierUnspecified: SetBits(B,[3,5]);
    pidTelematicTeletexInPSPDN: SetBits(B,[0,3,5]);
    pidTelematicTeletexInCSPDN: SetBits(B,[1,3,5]);
    pidTelematicTeletexInAnaloguePSTN: SetBits(B,[0,1,3,5]);
    pidTelematicTeletexInDigitalISDN: SetBits(B,[2,3,5]);
    pidTelematicUCI: SetBits(B,[0,2,3,5]);
    pidTelematicMessageHandlingFacility: SetBits(B,[4,5]);
    pidTelematicAnyPublicX400: SetBits(B,[0,4,5]);
    pidTelematicInternetElectronicMail: SetBits(B,[1,4,5]);
    pidTelematicGSMMobileStation: SetBits(B,[0,1,2,3,4,5]);
    pidNetworkShortMessageType0: SetBit(B,6);
    pidNetworkReplaceShortMessageType1: SetBits(B,[0,6]);
    pidNetworkReplaceShortMessageType2: SetBits(B,[1,6]);
    pidNetworkReplaceShortMessageType3: SetBits(B,[0,1,6]);
    pidNetworkReplaceShortMessageType4: SetBits(B,[2,6]);
    pidNetworkReplaceShortMessageType5: SetBits(B,[0,2,6]);
    pidNetworkReplaceShortMessageType6: SetBits(B,[1,2,6]);
    pidNetworkReplaceShortMessageType7: SetBits(B,[0,1,2,6]);
    pidNetworkReturnCallMessage: SetBits(B,[0,1,2,3,4,0,6]);
    pidNetworkSIMDataDownload: SetBits(B,[0,1,2,3,4,5,6]);
  end;
  Stream.WriteByte(B);
  Stream.WriteByte(Byte(FPriorityFlag));

  S:='';
  if FScheduleDeliveryTime<>NullDateTime then
    S:=ConvertDateToTimeFormat(FScheduleDeliveryTime);
  Stream.WriteString(S,16);

  S:='';
  if FValidityPeriod<>0 then
    S:=ConvertSecondsToTimeFormat(FValidityPeriod);
  Stream.WriteString(S,16);

  B:=0;
  case FRegisteredDeliveryReceipt of
    rdrNotRequested: ;
    rdrSuccessOrFailure: SetBit(B,0);
    rdrFailure: SetBit(B,1);
  end;
  case FRegisteredDeliveryAck of
    rdaNotRequested: ;
    rdaDelivery: SetBit(B,2);
    rdaManualOrUser: SetBit(B,3);
    rdaBoth: SetBits(B,[2,3]);
  end;
  if FRegisteredDeliveryNotification then
    SetBit(B,4);
  Stream.WriteByte(B);

  Stream.WriteByte(Byte(FReplaceIfPresentFlag));

  B:=0;
  case FDataCoding of
    dcDefaultAlphabet: ;
    dcIA5: SetBit(B,0);
    dcOctetUnspecified1: SetBit(B,1);
    dcLatin1: SetBits(B,[0,1]);
    dcOctetUnspecified2: SetBit(B,2);
    dcJIS: SetBits(B,[0,2]);
    dcCyrllic: SetBits(B,[1,2]);
    dcLatinHebrew: SetBits(B,[0,1,2]);
    dcUCS2: SetBit(B,3);
    dcPictogramEncoding: SetBits(B,[0,3]);
    dcISO2022JP: SetBits(B,[1,3]);
    dcExtendedKanjiJIS: SetBits(B,[0,2,3]);
    dcKS: SetBits(B,[1,2,3]);
  end;
  case FIndication of
    indNone: ;
    indFlash: SetBit(B,4);
  end;
  Stream.WriteByte(B);

  Stream.WriteByte(FSmDefaultMsgId);
  Stream.WriteByte(FSmLength);
  Stream.WriteString(FShortMessage,255,false);

end;

{ TBisSmppSubmitSmResponse }

class function TBisSmppSubmitSmResponse.GetCommandId: Cardinal;
begin
  Result:=$80000004;
end;

procedure TBisSmppSubmitSmResponse.ReadData(Stream: TBisSmppStream);
begin
  inherited ReadData(Stream);
  FMessageId:=Stream.ReadString(65);
end;

{ TBisSmppDestAddresses }

function TBisSmppDestAddresses.Add(Flag: TBisSmppDestAddressDestFlag; AddrTon: TBisSmppTypeOfNumber;
                                   AddrNpi: TBisSmppNumberingPlanIndicator; Addr, DLName: String): TBisSmppDestAddress;
begin
  Result:=TBisSmppDestAddress.Create;
  Result.Flag:=Flag;
  Result.AddrTon:=AddrTon;
  Result.AddrNpi:=AddrNpi;
  Result.Addr:=Addr;
  Result.DLName:=DLName;
  inherited Add(Result);
end;

function TBisSmppDestAddresses.AddDistributionListName(DLName: String): TBisSmppDestAddress;
begin
  Result:=Add(dadfDistributionListName,tonUnknown,npiUnknown,'',DLName);
end;

function TBisSmppDestAddresses.AddSMEAddress(AddrTon: TBisSmppTypeOfNumber; AddrNpi: TBisSmppNumberingPlanIndicator;
                                             Addr: String): TBisSmppDestAddress;
begin
  Result:=Add(dadfSMEAddress,AddrTon,AddrNpi,Addr,'');
end;

function TBisSmppDestAddresses.GetItem(Index: Integer): TBisSmppDestAddress;
begin
  Result:=TBisSmppDestAddress(inherited Items[Index]);
end;

{ TBisSmppSubmitMultiRequest }

constructor TBisSmppSubmitMultiRequest.Create;
begin
  inherited Create;
  FDestAddresses:=TBisSmppDestAddresses.Create;
end;

destructor TBisSmppSubmitMultiRequest.Destroy;
begin
  FDestAddresses.Free;
  inherited Destroy;
end;

class function TBisSmppSubmitMultiRequest.GetCommandId: Cardinal;
begin
  Result:=$00000021;
end;

function TBisSmppSubmitMultiRequest.GetNumberOfDests: Byte;
begin
  Result:=FDestAddresses.Count;
end;

procedure TBisSmppSubmitMultiRequest.WriteData(Stream: TBisSmppStream);
var
  B: Byte;
  S: String;
  i: Integer;
  Item: TBisSmppDestAddress;
begin
  inherited WriteData(Stream);

  Stream.WriteString(FServiceType,6);
  Stream.WriteByte(Byte(FSourceAddrTon));
  Stream.WriteByte(Byte(FSourceAddrNpi));
  Stream.WriteString(FSourceAddr,21);

  Stream.WriteByte(Byte(FDestAddresses.Count));
  for i:=0 to FDestAddresses.Count-1 do begin
    Item:=FDestAddresses.Items[i];
    Stream.WriteByte(Byte(Item.Flag));
    case Item.Flag of
      dadfUnknown: ;
      dadfSMEAddress: begin
        Stream.WriteByte(Byte(Item.AddrTon));
        Stream.WriteByte(Byte(Item.AddrNpi));
        Stream.WriteString(Item.Addr,21);
      end;
      dadfDistributionListName: Stream.WriteString(Item.DLName,21);
    end;
  end;

  B:=0;
  case FEsmClassMessagingMode of
    ecmDefault: ;
    ecmDatagram: SetBit(B,0);
    ecmForward: SetBit(B,1);
    ecmStoreAndForward: SetBits(B,[0,1]);
  end;
  case FEsmClassMessageType of
    ectDefault: ;
    ectDelivery: SetBit(B,3);
    ectManual: SetBit(B,4);
  end;
  case FEsmClassFeatures of
    ecfNotSelected: ;
    ecfUDHI: SetBit(B,6);
    ecfReplayPath: SetBit(B,7);
    ecfUDHIandReplyPath: SetBits(B,[6,7]);
  end;
  Stream.WriteByte(B);

  B:=0;
  case FProtocolId of
    pidSMEtoSME: ;
    pidTelematicImplicit: SetBit(B,5);
    pidTelematicTelex: SetBits(B,[0,5]);
    pidTelematicGroup3Telefax: SetBits(B,[1,5]);
    pidTelematicGroup4Telefax: SetBits(B,[0,1,5]);
    pidTelematicVoiceTelephone: SetBits(B,[2,5]);
    pidTelematicERMES: SetBits(B,[0,2,5]);
    pidTelematicNationalPagingSystem: SetBits(B,[1,2,5]);
    pidTelematicVideotex: SetBits(B,[0,1,2,5]);
    pidTelematicTeletexCarrierUnspecified: SetBits(B,[3,5]);
    pidTelematicTeletexInPSPDN: SetBits(B,[0,3,5]);
    pidTelematicTeletexInCSPDN: SetBits(B,[1,3,5]);
    pidTelematicTeletexInAnaloguePSTN: SetBits(B,[0,1,3,5]);
    pidTelematicTeletexInDigitalISDN: SetBits(B,[2,3,5]);
    pidTelematicUCI: SetBits(B,[0,2,3,5]);
    pidTelematicMessageHandlingFacility: SetBits(B,[4,5]);
    pidTelematicAnyPublicX400: SetBits(B,[0,4,5]);
    pidTelematicInternetElectronicMail: SetBits(B,[1,4,5]);
    pidTelematicGSMMobileStation: SetBits(B,[0,1,2,3,4,5]);
    pidNetworkShortMessageType0: SetBit(B,6);
    pidNetworkReplaceShortMessageType1: SetBits(B,[0,6]);
    pidNetworkReplaceShortMessageType2: SetBits(B,[1,6]);
    pidNetworkReplaceShortMessageType3: SetBits(B,[0,1,6]);
    pidNetworkReplaceShortMessageType4: SetBits(B,[2,6]);
    pidNetworkReplaceShortMessageType5: SetBits(B,[0,2,6]);
    pidNetworkReplaceShortMessageType6: SetBits(B,[1,2,6]);
    pidNetworkReplaceShortMessageType7: SetBits(B,[0,1,2,6]);
    pidNetworkReturnCallMessage: SetBits(B,[0,1,2,3,4,0,6]);
    pidNetworkSIMDataDownload: SetBits(B,[0,1,2,3,4,5,6]);
  end;
  Stream.WriteByte(B);
  Stream.WriteByte(Byte(FPriorityFlag));

  S:='';
  if FScheduleDeliveryTime<>NullDateTime then
    S:=ConvertDateToTimeFormat(FScheduleDeliveryTime);
  Stream.WriteString(S,16);

  S:='';
  if FValidityPeriod<>0 then
    S:=ConvertSecondsToTimeFormat(FValidityPeriod);
  Stream.WriteString(S,16);

  B:=0;
  case FRegisteredDeliveryReceipt of
    rdrNotRequested: ;
    rdrSuccessOrFailure: SetBit(B,0);
    rdrFailure: SetBit(B,1);
  end;
  case FRegisteredDeliveryAck of
    rdaNotRequested: ;
    rdaDelivery: SetBit(B,2);
    rdaManualOrUser: SetBit(B,3);
    rdaBoth: SetBits(B,[2,3]);
  end;
  if FRegisteredDeliveryNotification then
    SetBit(B,4);
  Stream.WriteByte(B);

  Stream.WriteByte(Byte(FReplaceIfPresentFlag));

  B:=0;
  case FDataCoding of
    dcDefaultAlphabet: ;
    dcIA5: SetBit(B,0);
    dcOctetUnspecified1: SetBit(B,1);
    dcLatin1: SetBits(B,[0,1]);
    dcOctetUnspecified2: SetBit(B,2);
    dcJIS: SetBits(B,[0,2]);
    dcCyrllic: SetBits(B,[1,2]);
    dcLatinHebrew: SetBits(B,[0,1,2]);
    dcUCS2: SetBit(B,3);
    dcPictogramEncoding: SetBits(B,[0,3]);
    dcISO2022JP: SetBits(B,[1,3]);
    dcExtendedKanjiJIS: SetBits(B,[0,2,3]);
    dcKS: SetBits(B,[1,2,3]);
  end;
  case FIndication of
    indNone: ;
    indFlash: SetBit(B,4);
  end;
  Stream.WriteByte(B);

  Stream.WriteByte(FSmDefaultMsgId);
  Stream.WriteByte(FSmLength);
  Stream.WriteString(FShortMessage,255,false);

end;

{ TBisSmppUnsuccessSmes }

function TBisSmppUnsuccessSmes.Add(AddrTon: TBisSmppTypeOfNumber; AddrNpi: TBisSmppNumberingPlanIndicator; Addr: String;
                                   ErrorStatusCode: TBisSmppCommandStatus): TBisSmppUnsuccessSme;
begin
  Result:=TBisSmppUnsuccessSme.Create;
  Result.AddrTon:=AddrTon;
  Result.AddrNpi:=AddrNpi;
  Result.Addr:=Addr;
  Result.ErrorStatusCode:=ErrorStatusCode;
  inherited Add(Result);
end;

function TBisSmppUnsuccessSmes.GetItem(Index: Integer): TBisSmppUnsuccessSme;
begin
  Result:=TBisSmppUnsuccessSme(inherited Items[Index]);
end;

{ TBisSmppSubmitMultiResponse }

constructor TBisSmppSubmitMultiResponse.Create;
begin
  inherited Create;
  FUnsuccessSmes:=TBisSmppUnsuccessSmes.Create;
end;

destructor TBisSmppSubmitMultiResponse.Destroy;
begin
  FUnsuccessSmes.Free;
  inherited Destroy;
end;

class function TBisSmppSubmitMultiResponse.GetCommandId: Cardinal;
begin
  Result:=$80000021;
end;

function TBisSmppSubmitMultiResponse.GetNoUnsuccess: Byte;
begin
  Result:=FUnsuccessSmes.Count;
end;

procedure TBisSmppSubmitMultiResponse.ReadData(Stream: TBisSmppStream);
var
  Count: Byte;
  i: Integer;
  B: Byte;
  AddrTon: TBisSmppTypeOfNumber;
  AddrNpi: TBisSmppNumberingPlanIndicator;
  Addr: String;
  ErrorStatus: TBisSmppCommandStatus;
begin
  inherited ReadData(Stream);
  FMessageId:=Stream.ReadString(65);

  FUnsuccessSmes.Clear;
  Count:=Stream.ReadByte;
  for i:=0 to Count-1 do begin
    AddrTon:=TBisSmppTypeOfNumber(Stream.ReadByte);
    AddrNpi:=TBisSmppNumberingPlanIndicator(Stream.ReadByte);

    B:=Stream.ReadByte;// what is it?
    if B>0 then ;
    
    Addr:=Stream.ReadString(21);
    ErrorStatus:=TBisSmppCommandStatus(Stream.ReadInteger);
    FUnsuccessSmes.Add(AddrTon,AddrNpi,Addr,ErrorStatus);
  end;

end;

{ TBisSmppDeliverSmRequest }

class function TBisSmppDeliverSmRequest.GetCommandId: Cardinal;
begin
  Result:=$00000005;
end;

procedure TBisSmppDeliverSmRequest.ReadData(Stream: TBisSmppStream);
var
  B: Byte;
  S: String;
begin
  inherited ReadData(Stream);

  FServiceType:=Stream.ReadString(6);
  FSourceAddrTon:=TBisSmppTypeOfNumber(Stream.ReadByte);
  FSourceAddrNpi:=TBisSmppNumberingPlanIndicator(Stream.ReadByte);
  FSourceAddr:=Stream.ReadString(21);
  FDestAddrTon:=TBisSmppTypeOfNumber(Stream.ReadByte);
  FDestAddrNpi:=TBisSmppNumberingPlanIndicator(Stream.ReadByte);
  FDestinationAddr:=Stream.ReadString(21);

  B:=Stream.ReadByte;

  FEsmClassMessagingMode:=ecmDefault;
  if BitsExists(B,[0]) then FEsmClassMessagingMode:=ecmDatagram;
  if BitsExists(B,[1]) then FEsmClassMessagingMode:=ecmStoreAndForward;
  if BitsExists(B,[0,1]) then FEsmClassMessagingMode:=ecmStoreAndForward;

  FEsmClassMessageType:=ectDefault;
  if BitsExists(B,[3]) then FEsmClassMessageType:=ectDelivery;
  if BitsExists(B,[4]) then FEsmClassMessageType:=ectManual;

  FEsmClassFeatures:=ecfNotSelected;
  if BitsExists(B,[6]) then FEsmClassFeatures:=ecfUDHI;
  if BitsExists(B,[7]) then FEsmClassFeatures:=ecfReplayPath;
  if BitsExists(B,[6,7]) then FEsmClassFeatures:=ecfUDHIandReplyPath;

  B:=Stream.ReadByte;

  FProtocolId:=pidSMEtoSME;
  if BitsExists(B,[5]) then FProtocolId:=pidTelematicImplicit;
  if BitsExists(B,[0,5]) then FProtocolId:=pidTelematicTelex;
  if BitsExists(B,[1,5]) then FProtocolId:=pidTelematicGroup3Telefax;
  if BitsExists(B,[0,1,5]) then FProtocolId:=pidTelematicGroup4Telefax;
  if BitsExists(B,[2,5]) then FProtocolId:=pidTelematicVoiceTelephone;
  if BitsExists(B,[0,2,5]) then FProtocolId:=pidTelematicERMES;
  if BitsExists(B,[1,2,5]) then FProtocolId:=pidTelematicNationalPagingSystem;
  if BitsExists(B,[0,1,2,5]) then FProtocolId:=pidTelematicVideotex;
  if BitsExists(B,[3,5]) then FProtocolId:=pidTelematicTeletexCarrierUnspecified;
  if BitsExists(B,[0,3,5]) then FProtocolId:=pidTelematicTeletexInPSPDN;
  if BitsExists(B,[1,3,5]) then FProtocolId:=pidTelematicTeletexInCSPDN;
  if BitsExists(B,[0,1,3,5]) then FProtocolId:=pidTelematicTeletexInAnaloguePSTN;
  if BitsExists(B,[2,3,5]) then FProtocolId:=pidTelematicTeletexInDigitalISDN;
  if BitsExists(B,[0,2,3,5]) then FProtocolId:=pidTelematicUCI;
  if BitsExists(B,[4,5]) then FProtocolId:=pidTelematicMessageHandlingFacility;
  if BitsExists(B,[0,4,5]) then FProtocolId:=pidTelematicAnyPublicX400;
  if BitsExists(B,[1,4,5]) then FProtocolId:=pidTelematicInternetElectronicMail;
  if BitsExists(B,[0,1,2,3,4,5]) then FProtocolId:=pidTelematicGSMMobileStation;
  if BitsExists(B,[6]) then FProtocolId:=pidNetworkShortMessageType0;
  if BitsExists(B,[0,6]) then FProtocolId:=pidNetworkReplaceShortMessageType1;
  if BitsExists(B,[1,6]) then FProtocolId:=pidNetworkReplaceShortMessageType2;
  if BitsExists(B,[0,1,6]) then FProtocolId:=pidNetworkReplaceShortMessageType3;
  if BitsExists(B,[2,6]) then FProtocolId:=pidNetworkReplaceShortMessageType4;
  if BitsExists(B,[0,2,6]) then FProtocolId:=pidNetworkReplaceShortMessageType5;
  if BitsExists(B,[1,2,6]) then FProtocolId:=pidNetworkReplaceShortMessageType6;
  if BitsExists(B,[0,1,2,6]) then FProtocolId:=pidNetworkReplaceShortMessageType7;
  if BitsExists(B,[0,1,2,3,4,6]) then FProtocolId:=pidNetworkReturnCallMessage;
  if BitsExists(B,[0,1,2,3,4,5,6]) then FProtocolId:=pidNetworkSIMDataDownload;
  
  FPriorityFlag:=TBisSmppPriorityFlag(Stream.ReadByte);

  FScheduleDeliveryTime:=NullDateTime;
  S:=Trim(Stream.ReadString(16));
  if S<>'' then
    FScheduleDeliveryTime:=ConvertTimeFormatToDate(S);
  

  FValidityPeriod:=0;
  S:=Trim(Stream.ReadString(16));
  if S<>'' then ;
//    FValidityPeriod:=ConvertTimeFormatToSeconds(FValidityPeriod);

  B:=Stream.ReadByte;
  FRegisteredDeliveryReceipt:=rdrNotRequested;
  if BitsExists(B,[0]) then FRegisteredDeliveryReceipt:=rdrSuccessOrFailure;
  if BitsExists(B,[1]) then FRegisteredDeliveryReceipt:=rdrFailure;

  FRegisteredDeliveryAck:=rdaNotRequested;
  if BitsExists(B,[2]) then FRegisteredDeliveryAck:=rdaDelivery;
  if BitsExists(B,[3]) then FRegisteredDeliveryAck:=rdaManualOrUser;
  if BitsExists(B,[2,3]) then FRegisteredDeliveryAck:=rdaBoth;

  FRegisteredDeliveryNotification:=BitExists(B,4);

  FReplaceIfPresentFlag:=Boolean(Stream.ReadByte);

  B:=Stream.ReadByte;
  FDataCoding:=dcDefaultAlphabet;
  if BitsExists(B,[0]) then FDataCoding:=dcIA5;
  if BitsExists(B,[1]) then FDataCoding:=dcOctetUnspecified1;
  if BitsExists(B,[0,1]) then FDataCoding:=dcLatin1;
  if BitsExists(B,[2]) then FDataCoding:=dcOctetUnspecified2;
  if BitsExists(B,[0,2]) then FDataCoding:=dcJIS;
  if BitsExists(B,[1,2]) then FDataCoding:=dcCyrllic;
  if BitsExists(B,[0,1,2]) then FDataCoding:=dcLatinHebrew;
  if BitsExists(B,[3]) then FDataCoding:=dcUCS2;
  if BitsExists(B,[0,3]) then FDataCoding:=dcPictogramEncoding;
  if BitsExists(B,[1,3]) then FDataCoding:=dcISO2022JP;
  if BitsExists(B,[0,2,3]) then FDataCoding:=dcExtendedKanjiJIS;
  if BitsExists(B,[1,2,3]) then FDataCoding:=dcKS;

  FIndication:=indNone;
  if GetBit(B,4) then FIndication:=indFlash;

  FSmDefaultMsgId:=Stream.ReadByte;
  FSmLength:=Stream.ReadByte;
  FShortMessage:=Stream.ReadString(FSmLength);

end;

{ TBisSmppDeliverSmResponse }

class function TBisSmppDeliverSmResponse.GetCommandId: Cardinal;
begin
  Result:=$80000005;
end;

procedure TBisSmppDeliverSmResponse.WriteData(Stream: TBisSmppStream);
begin
  inherited WriteData(Stream);
  Stream.WriteString(FMessageId,1);
end;

{ TBisSmppDataSmRequest }

class function TBisSmppDataSmRequest.GetCommandId: Cardinal;
begin
  Result:=$00000103;
end;

{ TBisSmppDataSmResponse }

class function TBisSmppDataSmResponse.GetCommandId: Cardinal;
begin
  Result:=$80000103;
end;

{ TBisSmppQuerySmRequest }

class function TBisSmppQuerySmRequest.GetCommandId: Cardinal;
begin
  Result:=$00000003;
end;

procedure TBisSmppQuerySmRequest.WriteData(Stream: TBisSmppStream);
begin
  inherited WriteData(Stream);
  Stream.WriteString(FMessageId,65);
  Stream.WriteByte(Byte(FSourceAddrTon));
  Stream.WriteByte(Byte(FSourceAddrNpi));
  Stream.WriteString(FSourceAddr,21);
end;

{ TBisSmppQuerySmResponse }

class function TBisSmppQuerySmResponse.GetCommandId: Cardinal;
begin
  Result:=$80000003;
end;

procedure TBisSmppQuerySmResponse.ReadData(Stream: TBisSmppStream);
begin
  inherited ReadData(Stream);
  FMessageId:=Stream.ReadString(65);
  FFinalDate:=ConvertTimeFormatToDate(Stream.ReadString(17));
  FMessageState:=TBisSmppMessageState(Stream.ReadByte);
  FErrorCode:=Stream.ReadByte;
end;

{ TBisSmppCancelSmRequest }

class function TBisSmppCancelSmRequest.GetCommandId: Cardinal;
begin
  Result:=$00000008;
end;

procedure TBisSmppCancelSmRequest.WriteData(Stream: TBisSmppStream);
begin
  inherited WriteData(Stream);
  Stream.WriteString(FServiceType,6);
  Stream.WriteString(FMessageId,65);
  Stream.WriteByte(Byte(FSourceAddrTon));
  Stream.WriteByte(Byte(FSourceAddrNpi));
  Stream.WriteString(FSourceAddr,21);
  Stream.WriteByte(Byte(FDestAddrTon));
  Stream.WriteByte(Byte(FDestAddrNpi));
  Stream.WriteString(FDestinationAddr,21);
end;

{ TBisSmppCancelSmResponse }

class function TBisSmppCancelSmResponse.GetCommandId: Cardinal;
begin
  Result:=$80000008;
end;

{ TBisSmppEnquireLinkRequest }

class function TBisSmppEnquireLinkRequest.GetCommandId: Cardinal;
begin
  Result:=$00000015;
end;

{ TBisSmppEnquireLinkResponse }

class function TBisSmppEnquireLinkResponse.GetCommandId: Cardinal;
begin
  Result:=$80000015;
end;

{ TBisSmppAlertNotificationRequest }

class function TBisSmppAlertNotificationRequest.GetCommandId: Cardinal;
begin
  Result:=$00000102;
end;

procedure TBisSmppAlertNotificationRequest.ReadData(Stream: TBisSmppStream);
begin
  inherited ReadData(Stream);
  FSourceAddrTon:=TBisSmppTypeOfNumber(Stream.ReadByte);
  FSourceAddrNpi:=TBisSmppNumberingPlanIndicator(Stream.ReadByte);
  FSourceAddr:=Stream.ReadString(65);
  FEsmeAddrTon:=TBisSmppTypeOfNumber(Stream.ReadByte);
  FEsmeAddrNpi:=TBisSmppNumberingPlanIndicator(Stream.ReadByte);
  FEmseAddr:=Stream.ReadString(65);
end;

initialization

  FParameterClassList:=TClassList.Create;
  with FParameterClassList do begin
    Add(TBisSmppScInterfaceVersion);
    Add(TBisSmppMsAvailabilityStatus);
    Add(TBisSmppUserMessageReference);
    Add(TBisSmppSourcePort);
    Add(TBisSmppSourceAddrSubunit);
    Add(TBisSmppDestinationPort);
    Add(TBisSmppDestAddrSubunit);
    Add(TBisSmppSarMsgRefNum);
    Add(TBisSmppSarTotalSegments);
    Add(TBisSmppSarSegmentSeqnum);
    Add(TBisSmppMoreMessagesToSend);
    Add(TBisSmppPayloadType);
    Add(TBisSmppMessagePayload);
    Add(TBisSmppPrivacyIndicator);
    Add(TBisSmppCallbackNum);
    Add(TBisSmppCallbackNumPresInd);
    Add(TBisSmppCallbackNumAtag);
    Add(TBisSmppSourceSubaddress);
    Add(TBisSmppDestSubaddress);
    Add(TBisSmppUserResponseCode);
    Add(TBisSmppDisplayTime);
    Add(TBisSmppSmsSignal);
    Add(TBisSmppMsValidity);
    Add(TBisSmppMsMsgWaitFacilities);
    Add(TBisSmppNumberOfMessages);
    Add(TBisSmppAlertOnMsgDelivery);
    Add(TBisSmppLanguageIndicator);
    Add(TBisSmppItsReplyType);
    Add(TBisSmppItsSessionInfo);
    Add(TBisSmppUssdServiceOp);
  end;

  FMessageClassList:=TClassList.Create;
  with FMessageClassList do begin
    Add(TBisSmppGenericNackResponse);
    Add(TBisSmppOutbindRequest);
    Add(TBisSmppBindTransmitterRequest);
    Add(TBisSmppBindTransmitterResponse);
    Add(TBisSmppBindReceiverRequest);
    Add(TBisSmppBindReceiverResponse);
    Add(TBisSmppBindTransceiverRequest);
    Add(TBisSmppBindTransceiverResponse);
    Add(TBisSmppUnBindRequest);
    Add(TBisSmppUnBindResponse);
    Add(TBisSmppSubmitSmRequest);
    Add(TBisSmppSubmitSmResponse);
    Add(TBisSmppSubmitMultiRequest);
    Add(TBisSmppSubmitMultiResponse);

    Add(TBisSmppDeliverSmRequest);
    Add(TBisSmppDeliverSmResponse);

    Add(TBisSmppDataSmRequest);
    Add(TBisSmppDataSmResponse);

    Add(TBisSmppQuerySmRequest);
    Add(TBisSmppQuerySmResponse);

    Add(TBisSmppCancelSmRequest);
    Add(TBisSmppCancelSmResponse);

    Add(TBisSmppEnquireLinkRequest);
    Add(TBisSmppEnquireLinkResponse);
    Add(TBisSmppAlertNotificationRequest);
  end;

  FCommandStatusList:=TObjectList.Create;
  with FCommandStatusList do begin
    Add(TBisSmppCommandStatusInfo.Create(csNoError,$00000000,'No Error'));
    Add(TBisSmppCommandStatusInfo.Create(csMessageLengthInvalid,$00000001,'Message Length is invalid'));
    Add(TBisSmppCommandStatusInfo.Create(csCommandLengthInvalid,$00000002,'Command Length is invalid'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidCommandId,$00000003,'Invalid Command ID'));
    Add(TBisSmppCommandStatusInfo.Create(csIncorrectBindStatus,$00000004,'Incorrect BIND Status for given command'));
    Add(TBisSmppCommandStatusInfo.Create(csAlreadyBoundState,$00000005,'ESME Already in Bound State'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidPriorityFlag,$00000006,'Invalid Priority Flag'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidRegisteredDeliveryFlag,$00000007,'Invalid Registered Delivery Flag'));
    Add(TBisSmppCommandStatusInfo.Create(csSystemError,$00000008,'System Error'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidSourceAddress,$0000000A,'Invalid Source Address'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidDestAddress,$0000000B,'Invalid Dest Address'));
    Add(TBisSmppCommandStatusInfo.Create(csMessageIdInvalid,$0000000C,'Message ID is invalid'));
    Add(TBisSmppCommandStatusInfo.Create(csBindFailed,$0000000D,'Bind Failed'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidPassword,$0000000E,'Invalid Password'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidSystemId,$0000000F,'Invalid System ID'));
    Add(TBisSmppCommandStatusInfo.Create(csCancelSMFailed,$00000011,'Cancel SM Failed'));
    Add(TBisSmppCommandStatusInfo.Create(csReplaceSMFailed,$00000013,'Replace SM Failed'));
    Add(TBisSmppCommandStatusInfo.Create(csMessageQueueFull,$00000014,'Message Queue Full'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidServiceType,$00000015,'Invalid Service Type'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidNumberDestinations,$00000033,'Invalid number of destinations'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidDistributionListName,$00000034,'Invalid Distribution List name'));
    Add(TBisSmppCommandStatusInfo.Create(csDestinationFlagInvalid,$00000040,'Destination flag is invalid (submit_multi)'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidSubmitWithWeplaceRequest,$00000042,'Invalid ‘submit with replace’ request (i.e. submit_sm with replace_if_present_flag set)'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidEsmClassFieldData,$00000043,'Invalid esm_class field data'));
    Add(TBisSmppCommandStatusInfo.Create(csCannotSubmitDistributionList,$00000044,'Cannot Submit to Distribution List'));
    Add(TBisSmppCommandStatusInfo.Create(csSubmitSmOrSubmitMultiFailed,$00000045,'submit_sm or submit_multi failed'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidSourceAddressTON,$00000048,'Invalid Source address TON'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidSourceaddressNPI,$00000049,'Invalid Source address NPI'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidDestinationAddressTON,$00000050,'Invalid Destination address TON'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidDestinationAddressNPI,$00000051,'Invalid Destination address NPI'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidSystemTypeField,$00000053,'Invalid system_type field'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidReplaceIfPresentFlag,$00000054,'Invalid replace_if_present flag'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidNumberMessages,$00000055,'Invalid number of messages'));
    Add(TBisSmppCommandStatusInfo.Create(csThrottlingError,$00000058,'Throttling error (ESME has exceeded allowed message limits)'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidScheduledDeliveryTime,$00000061,'Invalid Scheduled Delivery Time'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidMessageValidityPeriod,$00000062,'Invalid message validity period (Expiry time)'));
    Add(TBisSmppCommandStatusInfo.Create(csPredefinedMessageInvalidOrNotFound,$00000063,'Predefined Message Invalid or Not Found'));
    Add(TBisSmppCommandStatusInfo.Create(csReceiverTemporaryAppErrorCode,$00000064,'ESME Receiver Temporary App Error Code'));
    Add(TBisSmppCommandStatusInfo.Create(csReceiverPermanentAppErrorCode,$00000065,'ESME Receiver Permanent App Error Code'));
    Add(TBisSmppCommandStatusInfo.Create(csReceiverRejectMessageErrorCode,$00000066,'ESME Receiver Reject Message Error Code'));
    Add(TBisSmppCommandStatusInfo.Create(csQuerySmRequestFailed,$00000067,'Query_sm request failed'));
    Add(TBisSmppCommandStatusInfo.Create(csErrorOptionalPartPDUBody,$000000C0,'Error in the optional part of the PDU Body'));
    Add(TBisSmppCommandStatusInfo.Create(csOptionalParameterNotAllowed,$000000C1,'Optional Parameter not allowed'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidParameterLength,$000000C2,'Invalid Parameter Length'));
    Add(TBisSmppCommandStatusInfo.Create(csExpectedOptionalParameterMissing,$000000C3,'Expected Optional Parameter missing'));
    Add(TBisSmppCommandStatusInfo.Create(csInvalidOptionalParameterValue,$000000C4,'Invalid Optional Parameter Value'));
    Add(TBisSmppCommandStatusInfo.Create(csDeliveryFailure,$000000FE,'Delivery Failure (used for data_sm_resp)'));
    Add(TBisSmppCommandStatusInfo.Create(csUnknownError,$000000FF,'Unknown Error'));

  end;
finalization
  FCommandStatusList.Free;
  FMessageClassList.Free;
  FParameterClassList.Free;

end.
