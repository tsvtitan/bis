// DO NOT EDIT THIS FILE - WARNING WARNING - Generated file
unit DBXTraceHandler;
interface
type
  TDBXTraceHandler = class abstract
  public
    procedure Trace(Message: WideString); virtual; abstract;
  protected
    function IsTracing: Boolean; virtual; abstract;
  public
    property Tracing: Boolean read IsTracing;
  end;

implementation

end.
