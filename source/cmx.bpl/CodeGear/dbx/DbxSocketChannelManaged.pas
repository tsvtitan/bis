{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Client                                                       }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

/// <summary> DBX Client </summary>

unit DBXSocketChannelManaged;

{$Z+}


interface

uses
  DBXCommon, Classes, SysUtils, DBXChannel,
  System.Net.Sockets, System.IO
  ;
type

TDBXSocketChannel = class(TDBXChannel)
  strict private
    FTcpClient:   TcpClient;
    FSocket:      Socket;
    FInStream:    System.IO.Stream;
    FOutStream:   System.IO.Stream;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Open; override;
    procedure Close; override;
    function Read(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; override;
    function Write(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; override;
end;

implementation

{ TDBXSocketChannel }

procedure TDBXSocketChannel.Close;
begin
  if FSocket <> nil then
  begin
    FSocket.Close;
    FSocket := nil;
  end;
  if FTcpClient <> nil then
  begin
    FTcpClient.Close;
    FTcpClient := nil;
  end;
  FInStream := nil;
  FOutStream := nil;

end;

constructor TDBXSocketChannel.Create;
begin
  inherited Create;
end;

destructor TDBXSocketChannel.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TDBXSocketChannel.Open;
begin
  if FTcpClient = nil then
  begin
    try
      FTcpClient := TcpClient.Create(DbxProperties[TDBXPropertyNames.HostName],
                                    DbxProperties.GetInteger(TDBXPropertyNames.Port));
      FSocket := FTcpClient.Client;
      FSocket.SetSocketOption(System.Net.Sockets.SocketOptionLevel.Tcp, System.Net.Sockets.SocketOptionName.NoDelay, 1);
      FInstream := System.Net.Sockets.NetworkStream.Create(FSocket);
      FOutStream := System.Net.Sockets.NetworkStream.Create(FSocket);    
    finally
      if FOutStream = nil then
        Close;
    end;
  end;
end;

function TDBXSocketChannel.Read(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
begin
  Assert(Offset = 0);
  Result := FInStream.Read(Buffer, Offset, Count);
end;

function TDBXSocketChannel.Write(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
begin
  Assert(Offset = 0);
  FOutStream.Write(Buffer, Offset, Count);
  Result := Count;
end;

end.

