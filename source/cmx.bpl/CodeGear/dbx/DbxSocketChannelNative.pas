{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Client                                                       }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

/// <summary> DBX Client </summary>

unit DbxSocketChannelNative;

{$Z+}


interface

uses
  DBXCommon, Classes, SysUtils, DBXChannel, ScktComp;
type

TDBXSocketChannel = class(TDBXChannel)
  strict private
    FTcpClient:   TClientSocket;
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
  if FTcpClient <> nil then
  begin
    FTcpClient.Close;
    FreeAndNil(FTcpClient);
  end;

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
    FTcpClient := TClientSocket.Create(nil);
  FTcpClient.Host := DbxProperties[TDBXPropertyNames.HostName];
  FTcpClient.Port := DbxProperties.GetInteger(TDBXPropertyNames.Port);
  FTcpClient.ClientType := ctBlocking;
  
//  FTcpClient.ReadTimeout := -1;
  FTcpClient.Open();
end;

function TDBXSocketChannel.Read(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
begin
  Assert(Offset = 0);
  Result := FTcpClient.Socket.ReceiveBuf(Buffer[0], Count);
end;

function TDBXSocketChannel.Write(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
begin
  Assert(Offset = 0);
  FTcpClient.Socket.SendBuf(Buffer[0], Count);
  Result := Count;
end;

end.

