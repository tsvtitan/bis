unit BisExceptions;

interface

uses SysUtils;

type

  EBisException=class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(ErrorCode: Integer; const Msg: string);
    constructor CreateFmt(ErrorCode: Integer; const Msg: string; const Args: array of const);
    destructor Destroy; override;

    property ErrorCode: Integer read FErrorCode write FErrorCode;
  end;

  EBisConnection=class(EBisException)
  end;

implementation

uses StrUtils,
     BisUtils;

{ EBisException }

constructor EBisException.Create(ErrorCode: Integer; const Msg: string);
begin
  inherited Create(Msg);
  FErrorCode:=ErrorCode;
end;

destructor EBisException.Destroy;
begin
  inherited Destroy;
end;

constructor EBisException.CreateFmt(ErrorCode: Integer; const Msg: string; const Args: array of const);
begin
  Create(ErrorCode,Msg);
  Message:=FormatEx(Message,Args);
end;

initialization

finalization

end.
