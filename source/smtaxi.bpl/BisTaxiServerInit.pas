unit BisTaxiServerInit;

interface

uses Windows, Classes, Contnrs, Variants, DB, SyncObjs,
     BisObject, BisCoreObjects, BisServers, BisServerModules,
     BisLogger, BisThreads;

type
  TBisTaxiServer=class(TBisServer)
  private
    FInterval: Integer;
    FThread: TBisWaitThread;
    FDestroying: Boolean;
    procedure ChangeParams(Sender: TObject);
    procedure ThreadTimeout(Thread: TBisWaitThread);
  protected
    function GetStarted: Boolean; override;

    property Interval: Integer read FInterval write FInterval;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start; override;
    procedure Stop; override;
  end;

procedure InitServerModule(AModule: TBisServerModule); stdcall;

exports
  InitServerModule;

implementation

uses SysUtils, StrUtils, Math,
     BisTaxiServerConsts, BisConsts, BisUtils, BisDataSet, BisProvider,
     BisCore, BisFilterGroups, BisValues, BisOrders, BisDataParams;


procedure InitServerModule(AModule: TBisServerModule); stdcall;
begin
  AModule.ServerClass:=TBisTaxiServer;
end;

type
  TBisTaxiServerThread=class(TBisWaitThread)
  end;

{ TBisTaxiServer }

constructor TBisTaxiServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Params.OnChange:=ChangeParams;

  FThread:=TBisTaxiServerThread.Create;
  FThread.OnTimeout:=ThreadTimeout;
  
  FInterval:=1000;
end;

destructor TBisTaxiServer.Destroy;
begin
  FDestroying:=true;
  Stop;
  FThread.Free;
  inherited Destroy;
end;

function TBisTaxiServer.GetStarted: Boolean;
begin
  Result:=FThread.Working;
end;

procedure TBisTaxiServer.ChangeParams(Sender: TObject);
begin
  FInterval:=Params.AsInteger(SParamInterval,FInterval);
end;

procedure TBisTaxiServer.ThreadTimeout(Thread: TBisWaitThread);

  procedure ProcessOrders;

    procedure ProcessOrder(OrderId: Variant);
    var
      P: TBisProvider;
    begin
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='PROCESS_ORDER';
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
          AddInvisible('ORDER_ID').Value:=OrderId;
          AddInvisible('TYPE_PROCESS').Value:=0;
        end;
        try
          P.Execute;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;

    procedure ProcessOrdersEnd;
    var
      P: TBisProvider;
    begin
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='PROCESS_ORDERS_END';
        try
          P.Execute;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;

  var
    PLock: TBisProvider;
  begin
    if not Thread.Terminated then begin
      PLock:=TBisProvider.Create(nil);
      try
        PLock.ProviderName:='PROCESS_ORDERS_BEGIN';
        with PLock.FieldNames do begin
          AddInvisible('ORDER_ID');
          AddInvisible('ACTION_ID');
        end;
        try
          PLock.OpenMode:=omExecute;
          PLock.Open;
          if PLock.Active then begin
            try
              PLock.First;
              while not PLock.Eof do begin
                if Thread.Terminated then
                  break;
                ProcessOrder(PLock.FieldByName('ORDER_ID').Value);
                PLock.Next;
              end;
            finally
              ProcessOrdersEnd;
            end;
          end;
        except
          on E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        PLock.Free;
      end;
    end;
  end;

begin
  Working:=true;
  try
    ProcessOrders;
  finally
    Thread.Reset;
    Working:=false;
  end;
end;

procedure TBisTaxiServer.Start;
begin
  Stop;
  if not Started and Enabled then begin
    LoggerWrite(SStart);
    try
      FThread.Timeout:=FInterval;
      FThread.Start;
      LoggerWrite(SStartSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStartFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

procedure TBisTaxiServer.Stop;
begin
  if Started then begin
    LoggerWrite(SStop);
    try
      FThread.Stop;
      LoggerWrite(SStopSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStopFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

end.
