unit BisFotomCanon;

interface

uses Windows, Classes, SyncObjs, Graphics, Jpeg, ExtCtrls,
     PRAPI,
     BisCoreObjects;

type
  TBisFotomCanonStatusEvent=procedure(Sender: TObject; const Message: String) of object;
  TBisFotomCanonDrawFrameEvent=procedure(Sender: TObject; Graphic: TGraphic) of object;
  TBisFotomCanonDrawPictureEvent=procedure(Sender: TObject; Bitmap: TBitmap) of object;
  TBisFotomCanonProgressEvent=procedure(Sender: TObject; Percent: Integer) of object;

  TBisFotomCanon=class;

  TBisFotomCanonThread=class(TThread)
  private
    FParent: TBisFotomCanon;
    FGraphic: TGraphic;
    procedure DrawFrame;
  public
    constructor Create;
    procedure Execute; override;
    destructor Destroy; override;

    property Parent: TBisFotomCanon read FParent write FParent;
  end;

  TBisFotomCanon=class(TBisCoreObject)
  private
    FOnStatus: TBisFotomCanonStatusEvent;
    FSConnected: String;
    FSDisconnect: String;
    FSResponseOk: String;
    FSResponseExLowBattery: String;
    FSResponseExUndefined: String;
    FSResponseUndefined: String;
    FSResponseNoThumbnailPresent: String;
    FSResponseGeneralError: String;
    FSResponseExDeviceIsHot: String;
    FSResponseInvalidObjectHandle: String;
    FSResponseSessionAlreadyOpen: String;
    FSResponseExUnknownCommandReceived: String;
    FSResponseInvalidDevicePropFormat: String;
    FSResponseSelfTestFailed: String;
    FSResponseExNoRelease: String;
    FSResponseExCoverClosed: String;
    FSResponseExInternalError: String;
    FSResponseInvalidDevicePropValue: String;
    FSResponseExMemAllocFailed: String;
    FSResponseNoValidObjectInfo: String;
    FSResponseStoreFull: String;
    FSResponseOperationNotSupported: String;
    FSResponseSessionNotOpen: String;
    FSResponseAccessDenied: String;
    FSResponseInvalidObjectFormatCode: String;
    FSResponseSpecificationByFormatUnsupported: String;
    FSResponseCaptureAlreadyTerminated: String;
    FSResponseIncompleteTransfer: String;
    FSResponseInvalidParameter: String;
    FSResponseInvalidCodeFormat: String;
    FSResponseStoreReadOnly: String;
    FSResponseParameterNotSupported: String;
    FSResponseExAlreadyExit: String;
    FSResponseExRefusedByOtherProcess: String;
    FSResponseDevicePropNotSupported: String;
    FSResponseStoreNotAvailable: String;
    FSResponsePartialDeletion: String;
    FSResponseObjectWriteProtected: String;
    FSResponseDeviceBusy: String;
    FSResponseSpecificationOfDestinationUnsupported: String;
    FSResponseInvalidTransactionID: String;
    FSResponseTransactionCancelled: String;
    FSResponseInvalidStorageID: String;
    FSResponseExDirIOError: String;
    FSResponseUnknownVendorCode: String;
    FSResponseInvalidParentObject: String;

    FCameraHandle: prHandle;
    FDeviceName: String;
    FSDeviceNotFound: String;
    FViewFinderVisible: Boolean;
    FThread: TBisFotomCanonThread;
    FStreamViewFinder: TMemoryStream;
    FStreamImage: TMemoryStream;
    FMutex: TMutex;
    FWithoutDisconnect: Boolean;
    FSection: TRTLCriticalSection;

    FOnOpenViewFinder: TNotifyEvent;
    FOnCloseViewFinder: TNotifyEvent;
    FOnDrawFrame: TBisFotomCanonDrawFrameEvent;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FPictureHandle: prObjectHandle;
    FOnProgress: TBisFotomCanonProgressEvent;
    FZoomStep: Integer;
    FOnDrawPicture: TBisFotomCanonDrawPictureEvent;
    FRatioX: Extended;
    FRatioY: Extended;

    function GetConnected: Boolean;
    function ApiExists: Boolean;
    function ApiCheck(Ret: prResponse): Boolean;
    function ApiInfo(Ret: prResponse): String;
    procedure OpenViewVider;
    procedure CloseViewFinder;
    procedure Lock;
    procedure Unlock;
  protected
    procedure DoStatus(const Message: String); virtual;
    procedure DoOpenViewFinder; virtual;
    procedure DoCloseViewFinder; virtual;
    procedure DoDrawFrame(Graphic: TGraphic); virtual;
    procedure DoDrawPicture(Bitmap: TBitmap); virtual;
    procedure DoProgress(Percent: Integer); virtual;

    property Thread: TBisFotomCanonThread read FThread;
    property StreamViewFinder: TMemoryStream read FStreamViewFinder;
    property StreamImage: TMemoryStream read FStreamImage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CanConnect: Boolean;
    procedure Connect;
    procedure Disconnect;
    function TakePicture(const FileName: String): Boolean;
    procedure ZoomIn;
    procedure ZoomOut;
    procedure Reset;

    property DeviceName: String read FDeviceName write FDeviceName;
    property ImageWidth: Integer read FImageWidth write FImageWidth;
    property ImageHeight: Integer read FImageHeight write FImageHeight;
    property ZoomStep: Integer read FZoomStep write FZoomStep;

    property RatioX: Extended read FRatioX write FRatioX;
    property RatioY: Extended read FRatioY write FRatioY;

    property Connected: Boolean read GetConnected;
    property ViewFinderVisible: Boolean read FViewFinderVisible;

    property OnStatus: TBisFotomCanonStatusEvent read FOnStatus write FOnStatus;
    property OnOpenViewFinder: TNotifyEvent read FOnOpenViewFinder write FOnOpenViewFinder;
    property OnCloseViewFinder: TNotifyEvent read FOnCloseViewFinder write FOnCloseViewFinder;
    property OnDrawFrame: TBisFotomCanonDrawFrameEvent read FOnDrawFrame write FOnDrawFrame;
    property OnDrawPicture: TBisFotomCanonDrawPictureEvent read FOnDrawPicture write FOnDrawPicture;
    property OnProgress: TBisFotomCanonProgressEvent read FOnProgress write FOnProgress;

  published
    property SConnected: String read FSConnected write FSConnected;
    property SDisconnect: String read FSDisconnect write FSDisconnect;
    property SDeviceNotFound: String read FSDeviceNotFound write FSDeviceNotFound;

    property SResponseOk: String read FSResponseOk write FSResponseOk;
    property SResponseUndefined: String read FSResponseUndefined write FSResponseUndefined;
    property SResponseGeneralError: String read FSResponseGeneralError write FSResponseGeneralError;
    property SResponseSessionNotOpen: String read FSResponseSessionNotOpen write FSResponseSessionNotOpen;
    property SResponseInvalidTransactionID: String read FSResponseInvalidTransactionID write FSResponseInvalidTransactionID;
    property SResponseOperationNotSupported: String read FSResponseOperationNotSupported write FSResponseOperationNotSupported;
    property SResponseParameterNotSupported: String read FSResponseParameterNotSupported write FSResponseParameterNotSupported;
    property SResponseIncompleteTransfer: String read FSResponseIncompleteTransfer write FSResponseIncompleteTransfer;
    property SResponseInvalidStorageID: String read FSResponseInvalidStorageID write FSResponseInvalidStorageID;
    property SResponseInvalidObjectHandle: String read FSResponseInvalidObjectHandle write FSResponseInvalidObjectHandle;
    property SResponseDevicePropNotSupported: String read FSResponseDevicePropNotSupported write FSResponseDevicePropNotSupported;
    property SResponseInvalidObjectFormatCode: String read FSResponseInvalidObjectFormatCode write FSResponseInvalidObjectFormatCode;
    property SResponseStoreFull: String read FSResponseStoreFull write FSResponseStoreFull;
    property SResponseObjectWriteProtected: String read FSResponseObjectWriteProtected write FSResponseObjectWriteProtected;
    property SResponseStoreReadOnly: String read FSResponseStoreReadOnly write FSResponseStoreReadOnly;
    property SResponseAccessDenied: String read FSResponseAccessDenied write FSResponseAccessDenied;
    property SResponseNoThumbnailPresent: String read FSResponseNoThumbnailPresent write FSResponseNoThumbnailPresent;
    property SResponseSelfTestFailed: String read FSResponseSelfTestFailed write FSResponseSelfTestFailed;
    property SResponsePartialDeletion: String read FSResponsePartialDeletion write FSResponsePartialDeletion;
    property SResponseStoreNotAvailable: String read FSResponseStoreNotAvailable write FSResponseStoreNotAvailable;
    property SResponseSpecificationByFormatUnsupported: String read FSResponseSpecificationByFormatUnsupported write FSResponseSpecificationByFormatUnsupported;
    property SResponseNoValidObjectInfo: String read FSResponseNoValidObjectInfo write FSResponseNoValidObjectInfo;
    property SResponseInvalidCodeFormat: String read FSResponseInvalidCodeFormat write FSResponseInvalidCodeFormat;
    property SResponseUnknownVendorCode: String read FSResponseUnknownVendorCode write FSResponseUnknownVendorCode;
    property SResponseCaptureAlreadyTerminated: String read FSResponseCaptureAlreadyTerminated write FSResponseCaptureAlreadyTerminated;
    property SResponseDeviceBusy: String read FSResponseDeviceBusy write FSResponseDeviceBusy;
    property SResponseInvalidParentObject: String read FSResponseInvalidParentObject write FSResponseInvalidParentObject;
    property SResponseInvalidDevicePropFormat: String read FSResponseInvalidDevicePropFormat write FSResponseInvalidDevicePropFormat;
    property SResponseInvalidDevicePropValue: String read FSResponseInvalidDevicePropValue write FSResponseInvalidDevicePropValue;
    property SResponseInvalidParameter: String read FSResponseInvalidParameter write FSResponseInvalidParameter;
    property SResponseSessionAlreadyOpen: String read FSResponseSessionAlreadyOpen write FSResponseSessionAlreadyOpen;
    property SResponseTransactionCancelled: String read FSResponseTransactionCancelled write FSResponseTransactionCancelled;
    property SResponseSpecificationOfDestinationUnsupported: String read FSResponseSpecificationOfDestinationUnsupported write FSResponseSpecificationOfDestinationUnsupported;
    property SResponseExUndefined: String read FSResponseExUndefined write FSResponseExUndefined;
    property SResponseExUnknownCommandReceived: String read FSResponseExUnknownCommandReceived write FSResponseExUnknownCommandReceived;
    property SResponseExMemAllocFailed: String read FSResponseExMemAllocFailed write FSResponseExMemAllocFailed;
    property SResponseExInternalError: String read FSResponseExInternalError write FSResponseExInternalError;
    property SResponseExDirIOError: String read FSResponseExDirIOError write FSResponseExDirIOError;
    property SResponseExRefusedByOtherProcess: String read FSResponseExRefusedByOtherProcess write FSResponseExRefusedByOtherProcess;
    property SResponseExCoverClosed: String read FSResponseExCoverClosed write FSResponseExCoverClosed;
    property SResponseExNoRelease: String read FSResponseExNoRelease write FSResponseExNoRelease;
    property SResponseExDeviceIsHot: String read FSResponseExDeviceIsHot write FSResponseExDeviceIsHot;
    property SResponseExLowBattery: String read FSResponseExLowBattery write FSResponseExLowBattery;
    property SResponseExAlreadyExit: String read FSResponseExAlreadyExit write FSResponseExAlreadyExit;
  end;

implementation

uses SysUtils,
     BisUtils, BisCore;

{ TBisFotomCanonThread }

constructor TBisFotomCanonThread.Create;
begin
  inherited Create(true);
end;

destructor TBisFotomCanonThread.Destroy;
begin
  FParent:=nil;
  TerminateThread(Handle,0);
  inherited Destroy;
end;

procedure TBisFotomCanonThread.DrawFrame;
begin
  try
    if Assigned(FParent) and Assigned(FGraphic) then begin
      FParent.DoDrawFrame(FGraphic);
//      Core.Logger.Write('DrawFrame');
    end;
  except
  end;
end;

procedure TBisFotomCanonThread.Execute;
var
  Jpg: TJPEGImage;
begin
//  Core.Logger.Write('Execute');
  if Assigned(FParent) and (FParent.StreamViewFinder.Size>0) then
    while not Terminated and FParent.ViewFinderVisible do begin
//      Core.Logger.Write('Execute 1');
      Jpg:=TJPEGImage.Create;
      try
        Jpg.LoadFromStream(FParent.StreamViewFinder);
//        Core.Logger.Write('Execute 2');
        if not Jpg.Empty and (Jpg.Width<>0) and (Jpg.Height<>0) then begin
          FGraphic:=Jpg;
          try
//            Core.Logger.Write('Execute 3');
            Synchronize(DrawFrame);
          finally
            FGraphic:=nil;
          end;
        end;
      finally
        Jpg.Free;
//        Core.Logger.Write('Execute 4');
        Suspend;
//        Core.Logger.Write('Execute 5');
      end;
    end;
end;

{ TBisFotomCanon }

constructor TBisFotomCanon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageWidth:=320;
  FImageHeight:=240;
  FZoomStep:=1;

  FThread:=TBisFotomCanonThread.Create;
  FThread.Parent:=Self;

  FStreamViewFinder:=TMemoryStream.Create;
  FStreamImage:=TMemoryStream.Create;

  FSConnected:='���������� �����������.';
  FSDisconnect:='���������� ���������.';
  FSDeviceNotFound:='���������� �� �������.';
  FSResponseOk:='�������� ������� ��������.';
  FSResponseExLowBattery:='ResponseExLowBattery';
  FSResponseExUndefined:='ResponseExUndefined';
  FSResponseUndefined:='ResponseUndefined';
  FSResponseNoThumbnailPresent:='ResponseNoThumbnailPresent';
  FSResponseGeneralError:='ResponseGeneralError';
  FSResponseExDeviceIsHot:='ResponseExDeviceIsHot';
  FSResponseInvalidObjectHandle:='ResponseInvalidObjectHandle';
  FSResponseSessionAlreadyOpen:='ResponseSessionAlreadyOpen';
  FSResponseExUnknownCommandReceived:='ResponseExUnknownCommandReceived';
  FSResponseInvalidDevicePropFormat:='ResponseInvalidDevicePropFormat';
  FSResponseSelfTestFailed:='ResponseSelfTestFailed';
  FSResponseExNoRelease:='ResponseExNoRelease';
  FSResponseExCoverClosed:='ResponseExCoverClosed';
  FSResponseExInternalError:='ResponseExInternalError';
  FSResponseInvalidDevicePropValue:='ResponseInvalidDevicePropValue';
  FSResponseExMemAllocFailed:='ResponseExMemAllocFailed';
  FSResponseNoValidObjectInfo:='ResponseNoValidObjectInfo';
  FSResponseStoreFull:='ResponseStoreFull';
  FSResponseOperationNotSupported:='ResponseOperationNotSupported';
  FSResponseSessionNotOpen:='ResponseSessionNotOpen';
  FSResponseAccessDenied:='ResponseAccessDenied';
  FSResponseInvalidObjectFormatCode:='ResponseInvalidObjectFormatCode';
  FSResponseSpecificationByFormatUnsupported:='ResponseSpecificationByFormatUnsupported';
  FSResponseCaptureAlreadyTerminated:='ResponseCaptureAlreadyTerminated';
  FSResponseIncompleteTransfer:='ResponseIncompleteTransfer';
  FSResponseInvalidParameter:='ResponseInvalidParameter';
  FSResponseInvalidCodeFormat:='ResponseInvalidCodeFormat';
  FSResponseStoreReadOnly:='ResponseStoreReadOnly';
  FSResponseParameterNotSupported:='ResponseParameterNotSupported';
  FSResponseExAlreadyExit:='ResponseExAlreadyExit';
  FSResponseExRefusedByOtherProcess:='ResponseExRefusedByOtherProcess';
  FSResponseDevicePropNotSupported:='ResponseDevicePropNotSupported';
  FSResponseStoreNotAvailable:='ResponseStoreNotAvailable';
  FSResponsePartialDeletion:='ResponsePartialDeletion';
  FSResponseObjectWriteProtected:='ResponseObjectWriteProtected';
  FSResponseDeviceBusy:='ResponseDeviceBusy';
  FSResponseSpecificationOfDestinationUnsupported:='ResponseSpecificationOfDestinationUnsupported';
  FSResponseInvalidTransactionID:='ResponseInvalidTransactionID';
  FSResponseTransactionCancelled:='ResponseTransactionCancelled';
  FSResponseInvalidStorageID:='ResponseInvalidStorageID';
  FSResponseExDirIOError:='ResponseExDirIOError';
  FSResponseUnknownVendorCode:='ResponseUnknownVendorCode';
  FSResponseInvalidParentObject:='ResponseInvalidParentObject';

  InitializeCriticalSection(FSection);

end;

destructor TBisFotomCanon.Destroy;
begin
  DeleteCriticalSection(FSection);

  FStreamImage.Free;
  FStreamViewFinder.Free;
  FThread.Free;
  inherited Destroy;
end;

procedure TBisFotomCanon.Lock;
begin
  EnterCriticalSection(FSection);
end;

procedure TBisFotomCanon.Unlock;
begin
  LeaveCriticalSection(FSection);
end;

procedure TBisFotomCanon.DoCloseViewFinder;
begin
  if Assigned(FOnCloseViewFinder) then
    FOnCloseViewFinder(Self);
end;

procedure TBisFotomCanon.DoDrawPicture(Bitmap: TBitmap);
begin
  if Assigned(FOnDrawPicture) then
    FOnDrawPicture(Self,Bitmap);
end;

procedure TBisFotomCanon.DoDrawFrame(Graphic: TGraphic);
begin
  if Assigned(FOnDrawFrame) then
    FOnDrawFrame(Self,Graphic);
end;

procedure TBisFotomCanon.DoOpenViewFinder;
begin
  if Assigned(FOnOpenViewFinder) then
    FOnOpenViewFinder(Self);
end;

procedure TBisFotomCanon.DoProgress(Percent: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self,Percent);
end;

procedure TBisFotomCanon.DoStatus(const Message: String);
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self,Message);
end;

function TBisFotomCanon.GetConnected: Boolean;
begin
  Result:=FCameraHandle<>0;
end;

function TBisFotomCanon.ApiCheck(Ret: prResponse): Boolean;
begin
  Result:=Ret=prOk;
end;

function TBisFotomCanon.ApiExists: Boolean;
begin
  Result:=PRAPILoaded;
end;

function TBisFotomCanon.ApiInfo(Ret: prResponse): String;
begin
  Result:='';
  case Ret of
    prOK: Result:=FSResponseOk;
    prRESPONSE_Undefined: Result:=FSResponseUndefined;
    prRESPONSE_GeneralError: Result:=FSResponseGeneralError;
    prRESPONSE_SessionNotOpen: Result:=FSResponseSessionNotOpen;
    prRESPONSE_InvalidTransactionID: Result:=FSResponseInvalidTransactionID;
    prRESPONSE_OperationNotSupported: Result:=FSResponseOperationNotSupported;
    prRESPONSE_ParameterNotSupported: Result:=FSResponseParameterNotSupported;
    prRESPONSE_IncompleteTransfer: Result:=FSResponseIncompleteTransfer;
    prRESPONSE_InvalidStorageID: Result:=FSResponseInvalidStorageID;
    prRESPONSE_InvalidObjectHandle: Result:=FSResponseInvalidObjectHandle;
    prRESPONSE_DevicePropNotSupported: Result:=FSResponseDevicePropNotSupported;
    prRESPONSE_InvalidObjectFormatCode: Result:=FSResponseInvalidObjectFormatCode;
    prRESPONSE_StoreFull: Result:=FSResponseStoreFull;
    prRESPONSE_ObjectWriteProtected: Result:=FSResponseObjectWriteProtected;
    prRESPONSE_StoreRead_Only: Result:=FSResponseStoreReadOnly;
    prRESPONSE_AccessDenied: Result:=FSResponseAccessDenied;
    prRESPONSE_NoThumbnailPresent: Result:=FSResponseNoThumbnailPresent;
    prRESPONSE_SelfTestFailed: Result:=FSResponseSelfTestFailed;
    prRESPONSE_PartialDeletion: Result:=FSResponsePartialDeletion;
    prRESPONSE_StoreNotAvailable: Result:=FSResponseStoreNotAvailable;
    prRESPONSE_SpecificationByFormatUnsupported: Result:=FSResponseSpecificationByFormatUnsupported;
    prRESPONSE_NoValidObjectInfo: Result:=FSResponseNoValidObjectInfo;
    prRESPONSE_InvalidCodeFormat: Result:=FSResponseInvalidCodeFormat;
    prRESPONSE_UnknownVendorCode: Result:=FSResponseUnknownVendorCode;
    prRESPONSE_CaptureAlreadyTerminated: Result:=FSResponseCaptureAlreadyTerminated;
    prRESPONSE_DeviceBusy: Result:=FSResponseDeviceBusy;
    prRESPONSE_InvalidParentObject: Result:=FSResponseInvalidParentObject;
    prRESPONSE_InvalidDevicePropFormat: Result:=FSResponseInvalidDevicePropFormat;
    prRESPONSE_InvalidDevicePropValue: Result:=FSResponseInvalidDevicePropValue;
    prRESPONSE_InvalidParameter: Result:=FSResponseInvalidParameter;
    prRESPONSE_SessionAlreadyOpen: Result:=FSResponseSessionAlreadyOpen;
    prRESPONSE_TransactionCancelled: Result:=FSResponseTransactionCancelled;
    prRESPONSE_SpecificationOfDestinationUnsupported: Result:=FSResponseSpecificationOfDestinationUnsupported;
    prRESPONSE_Ex_Undefined: Result:=FSResponseExUndefined;
    prRESPONSE_Ex_UnknownCommandReceived: Result:=FSResponseExUnknownCommandReceived;
    prRESPONSE_Ex_MemAllocFailed: Result:=FSResponseExMemAllocFailed;
    prRESPONSE_Ex_InternalError: Result:=FSResponseExInternalError;
    prRESPONSE_Ex_DirIOError: Result:=FSResponseExDirIOError;
    prRESPONSE_Ex_RefusedByOtherProcess: Result:=FSResponseExRefusedByOtherProcess;
    prRESPONSE_Ex_CoverClosed: Result:=FSResponseExCoverClosed;
    prRESPONSE_Ex_NoRelease: Result:=FSResponseExNoRelease;
    prRESPONSE_Ex_DeviceIsHot: Result:=FSResponseExDeviceIsHot;
    prRESPONSE_Ex_LowBattery: Result:=FSResponseExLowBattery;
    prRESPONSE_Ex_AlreadyExit: Result:=FSResponseExAlreadyExit;
  else
    Result:=SysErrorMessage(GetLastError);
  end;
end;

function SetEventCallBackProc(CameraHandle: prHandle; Context: prContext; pEventData: pEVENT_GENERIC_CONTAINER): prResponse; stdcall;
var
  Obj: TBisFotomCanon;
begin
  Result:=prOK;
  Obj:=TBisFotomCanon(Context);
  if Assigned(Obj) and Assigned(pEventData) then begin
    case pEventData.Code of
      prCAL_SHUTDOWN: begin
        Obj.FWithoutDisconnect:=false;
        Obj.Disconnect;
      end;
		  prPTP_ABORT_PC_EVF: Obj.CloseViewFinder;
		  prPTP_FULL_VIEW_RELEASED: Obj.FPictureHandle:=pEventData.Parameter[0];
		  prPTP_THUMBNAIL_RELEASED: begin
        // ThmbHandle:=pEventData.Parametr[0];
        // ObjThumnailReleased();
      end;
		  prPTP_CAPTURE_COMPLETE:;
		  prPTP_PUSHED_RELEASE_SW:;
  		prPTP_RC_PROP_CHANGED:;
		  prPTP_DEVICE_PROP_CHANGED:; // Obj.UpdateSettings;
    end;
  end;
end;

procedure TBisFotomCanon.Connect;
var
  Ret: prResponse;
  Context: prContext;
  CamHandle: prHandle;
  BufferSize: prUInt32;
  pGetDevList: prDeviceList;
  S: String;
  ImageSizeMode: prUInt8;
  ImageQuality: prUInt8;
  Found: Boolean;
  i: Integer;
//  Buffer: array [0..127] of prUInt32; 
begin
  DoStatus('������ ���������� ...');
  if not Connected and ApiExists and (Trim(FDeviceName)<>'') then begin

    DoStatus('����� ...');

    CamHandle:=0;

    Ret:=PR_StartSDK;
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    BufferSize:=SizeOf(prDeviceList)+SizeOf(prDeviceInfoTable)*9;
    while True do begin
      FillChar(pGetDevList,SizeOf(pGetDevList),0);
      Ret:=PR_GetDeviceList(BufferSize,@pGetDevList);
      if ApiCheck(Ret) then begin
        break;
      end;
    end;

    Found:=false;
    for i:=0 to pGetDevList.NumList-1 do begin
      S:=Trim(pGetDevList.DeviceInfo[i].ModelName);
      DoStatus('������ '+S);
      Found:=AnsiSameText(S,FDeviceName);
      if Found then
        break;
    end;

    if not Found then begin
      DoStatus(FSDeviceNotFound);
      exit;
    end;

    DoStatus('���������� � '+S+' ...');

    Ret:=PR_CreateCameraObject(@pGetDevList.DeviceInfo,CamHandle);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    Context:=prContext(Self);
    Ret:=PR_SetEventCallBack(CamHandle,Context,@SetEventCallBackProc);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    Ret:=PR_ConnectCamera(CamHandle);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    FCameraHandle:=CamHandle;
    DoStatus(FSConnected);

    // ���� �������� �������� �� �� ������ ������ �����

    DoStatus('��������� �������� ...');    

    Ret:=PR_InitiateReleaseControl(CamHandle);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    DoStatus('��������� ���������� ...');

    ImageSizeMode:=0; // Large
    Ret:=PR_SetDevicePropValue(CamHandle,prPTP_DEV_PROP_IMAGE_SIZE,SizeOf(prUInt8),@ImageSizeMode);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    ImageQuality:=5; // SuperFine
    Ret:=PR_SetDevicePropValue(CamHandle,prPTP_DEV_PROP_COMP_QUALITY,SizeOf(prUInt8),@ImageQuality);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

{    BufferSize:=SizeOf(Buffer);
    Ret:=PR_GetDevicePropValue(CamHandle,prPTP_DEV_PROP_SUPPORTED_SIZE,BufferSize,@Buffer);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;}


    FWithoutDisconnect:=true;

    OpenViewVider;

  end;
end;

procedure TBisFotomCanon.Disconnect;
begin
  DoStatus('������ ���������� ...');
  if Connected and ApiExists then begin

    CloseViewFinder;

    DoStatus('��������� �������� ...');

    PR_TerminateReleaseControl(FCameraHandle);
    if FWithoutDisconnect then begin
      PR_DisconnectCamera(FCameraHandle);
  		PR_ClearEventCallBack(FCameraHandle);
      PR_DestroyCameraObject(FCameraHandle);
      PR_FinishSDK;
    end;

    FCameraHandle:=0;
    DoStatus(FSDisconnect);
  end;
end;

function ViewFinderCallBackProc(CameraHandle: prHandle; Context: prContext; Size: prUInt32; pVFData: pprVoid): prResponse; stdcall;
var
  Obj: TBisFotomCanon;
begin
  Result:=prOK;
  Obj:=TBisFotomCanon(Context);
  if Assigned(Obj) then begin
    Obj.Lock;
    try
      if not Obj.Thread.Suspended then
        Obj.Thread.Suspend;
      Obj.StreamViewFinder.Clear;
      Obj.StreamViewFinder.Size:=Size;
      CopyMemory(Obj.StreamViewFinder.Memory,pVFData,Size);
      Obj.Thread.Resume;
    finally
      Obj.Unlock;
    end;
  end;
end;

procedure TBisFotomCanon.OpenViewVider;
var
  Ret: prResponse;
  Context: prContext;
begin
  DoStatus('�������� ������������ ...');
  if Connected and not FViewFinderVisible then begin

    Context:=prContext(Self);
    Ret:=PR_RC_StartViewFinder(FCameraHandle,Context,@ViewFinderCallBackProc);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    FViewFinderVisible:=true;
    DoOpenViewFinder;

    DoStatus('������������ ������.');
  end;
end;

function TBisFotomCanon.CanConnect: Boolean;
begin
  Result:=ApiExists;
end;

procedure TBisFotomCanon.CloseViewFinder;
begin
  DoStatus('�������� ������������ ...');
  if Connected and FViewFinderVisible then begin
    FThread.Suspend;
    PR_RC_TermViewFinder(FCameraHandle);
    FViewFinderVisible:=false;
    DoCloseViewFinder;
    DoStatus('������������ ������.');
  end;
end;

function ReleasedDataCallBackProc(CameraHandle: prHandle; ObjectHandle: prObjectHandle; Context: prContext; pProgress: pprProgress): prResponse; stdcall;
var
  Obj: TBisFotomCanon;
begin
  Result:=prOK;
  Obj:=TBisFotomCanon(Context);
  if Assigned(Obj) and Assigned(pProgress) then begin
    case pProgress.lMessage of
      prMSG_DATA_HEADER: begin
        Obj.FMutex:=TMutex.Create;
        Obj.StreamImage.Clear;
      end;
			prMSG_DATA: begin
        Obj.StreamImage.Seek(pProgress.lOffset,0);
        Obj.StreamImage.Write(pProgress.pbData^,pProgress.lLength);
        Obj.DoProgress(pProgress.lPercentComplete);
      end;
			prMSG_TERMINATION: FreeAndNilEx(Obj.FMutex);
    end;
  end;
end;

function TBisFotomCanon.TakePicture(const FileName: String): Boolean;
var
  Ret: prResponse;
  Context: prContext;
  OldVisible: Boolean;
  Image: TImage;
  Jpg: TJPEGImage;
  Bitmap, BitmapF, BitmapR: TBitmap;
  W,H: Integer;
  X,Y: Integer;
const
  ReadBufferSize=1024*1024;
begin
  Result:=false;
  DoStatus('��������� ����������� ...');
  if Connected then begin

    OldVisible:=FViewFinderVisible;
    if OldVisible then CloseViewFinder;
    try

      DoStatus('������ ...');

      Ret:=PR_RC_Release(FCameraHandle);
      if not ApiCheck(Ret) then begin
        DoStatus(ApiInfo(Ret));
        exit;
      end;

      DoStatus('������ ������.');

      FStreamImage.Clear;
      DoProgress(0);

      DoStatus('�������� ...');

      Context:=prContext(Self);
      Ret:=PR_RC_GetReleasedData(FCameraHandle,FPictureHandle,prPTP_FULL_VIEW_RELEASED,ReadBufferSize,Context,@ReleasedDataCallBackProc);
      if not ApiCheck(Ret) then begin
        DoStatus(ApiInfo(Ret));
        exit;
      end;

      DoStatus('�������� ���������.');

      if Assigned(FMutex) then
        WaitForSingleObject(FMutex.Handle,INFINITE);

      if FStreamImage.Size<>0 then begin

        DoStatus('������ ...');

        FStreamImage.SaveToFile(FileName);
        FStreamImage.Clear;
        Image:=TImage.Create(nil);
        Jpg:=TJPEGImage.Create;
        Bitmap:=TBitmap.Create;
        try
          Bitmap.Width:=FImageWidth;
          Bitmap.Height:=FImageHeight;
          Image.Picture.LoadFromFile(FileName);
          if Assigned(Image.Picture.Graphic) and not Image.Picture.Graphic.Empty then begin
            BitmapF:=TBitmap.Create;
            BitmapR:=TBitmap.Create;
            try
              BitmapF.Width:=Image.Picture.Graphic.Width;
              BitmapF.Height:=Image.Picture.Graphic.Height;
              BitmapF.Canvas.Draw(0,0,Image.Picture.Graphic);

              W:=Round(Image.Picture.Graphic.Width/FRatioX);
              H:=Round(Image.Picture.Graphic.Height/FRatioY);
              BitmapR.Width:=W;
              BitmapR.Height:=H;

              X:=BitmapF.Width div 2 - W div 2;
              Y:=BitmapF.Height div 2 - H div 2;
              BitBlt(BitmapR.Canvas.Handle,0,0,W,H,BitmapF.Canvas.Handle,X,Y,SRCCOPY);

  //            Bitmap.Canvas.StretchDraw(Rect(0,0,FImageWidth,FImageHeight),Image.Picture.Graphic);
              Bitmap.Canvas.StretchDraw(Rect(0,0,FImageWidth,FImageHeight),BitmapR);
              DoDrawPicture(Bitmap);
              Jpg.Assign(Bitmap);
              Jpg.SaveToFile(FileName);
              DoProgress(0);
              Result:=true;

            finally
              BitmapR.Free;
              BitmapF.Free;
            end;
          end;
        finally
          Bitmap.Free;
          Jpg.Free;
          Image.Free;
        end;

        DoStatus('������ ���������.');
      end;
    finally
      if OldVisible then OpenViewVider;
    end;
  end;
end;

procedure TBisFotomCanon.ZoomIn;
var
  Ret: prResponse;
  BufferSize: prUInt32;
  Zoom: prUInt16;
begin
  DoStatus('���������� ...');
  if Connected and FViewFinderVisible then begin

    Ret:=PR_GetDevicePropValue(FCameraHandle,prPTP_DEV_PROP_ZOOM_POS,BufferSize,@Zoom);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    Zoom:=Zoom+FZoomStep;

    Ret:=PR_SetDevicePropValue(FCameraHandle,prPTP_DEV_PROP_ZOOM_POS,SizeOf(prUInt16),@Zoom);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    DoStatus('���������� ���������.');

  end;
end;

procedure TBisFotomCanon.ZoomOut;
var
  Ret: prResponse;
  BufferSize: prUInt32;
  Zoom: prUInt16;
begin
  DoStatus('���������� ...');
  if Connected and FViewFinderVisible then begin

    Ret:=PR_GetDevicePropValue(FCameraHandle,prPTP_DEV_PROP_ZOOM_POS,BufferSize,@Zoom);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    if (Zoom>0) then begin
      Zoom:=Zoom-FZoomStep;
      Ret:=PR_SetDevicePropValue(FCameraHandle,prPTP_DEV_PROP_ZOOM_POS,SizeOf(prUInt16),@Zoom);
      if not ApiCheck(Ret) then begin
        DoStatus(ApiInfo(Ret));
        exit;
      end;
    end;

    DoStatus('���������� ���������.');
  end;
end;

procedure TBisFotomCanon.Reset;
var
  Ret: prResponse;
  Zoom: prUInt16;
begin
  DoStatus('�� ��������� ...');
  if Connected and FViewFinderVisible then begin

    Zoom:=0;

    Ret:=PR_SetDevicePropValue(FCameraHandle,prPTP_DEV_PROP_ZOOM_POS,SizeOf(prUInt16),@Zoom);
    if not ApiCheck(Ret) then begin
      DoStatus(ApiInfo(Ret));
      exit;
    end;

    DoStatus('�� ��������� ��������.');

  end;
end;

end.