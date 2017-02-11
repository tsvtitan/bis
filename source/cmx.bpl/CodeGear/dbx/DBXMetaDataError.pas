unit DBXMetaDataError;

interface
uses
{$IF DEFINED(CLR)}
  System.Runtime.Serialization,
{$IFEND}
  DBXCommon;

type
{$IF DEFINED(CLR)}
  [Serializable]
{$IFEND}
  TDBXMetaDataError = class(TDBXError)
  public
    constructor Create(const Message: WideString);
{$IF DEFINED(CLR)}
    overload;
  protected
    constructor Create(Info: SerializationInfo; Context: StreamingContext); overload;
{$IFEND}
  end;

implementation

{$IF DEFINED(CLR)}
constructor TDBXMetaDataError.Create(Info: SerializationInfo; Context: StreamingContext);
begin
  inherited Create(Info,Context);
end;
{$IFEND}

constructor TDBXMetaDataError.Create(const Message: WideString);
begin
  inherited Create(TDBXErrorCodes.InvalidOperation, Message);
end;

end.