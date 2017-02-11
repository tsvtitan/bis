unit BisUdpServer;

interface

uses IdUdpServer;

type
  TBisUdpServer=class(TIdUDPServer)
  end;

implementation

uses IdStack,
     BisExceptNotifier;

initialization
  {$IFDEF EXCEPT_NOTIFIER_IGNORES}
    ExceptNotifierIgnores.Add(EIdSocketError);
  {$ENDIF}


end.
