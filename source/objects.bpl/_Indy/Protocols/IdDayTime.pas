{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13782: IdDayTime.pas 
{
{   Rev 1.3    1/21/2004 2:12:40 PM  JPMugaas
{ InitComponent
}
{
{   Rev 1.2    12/8/2002 07:26:30 PM  JPMugaas
{ Added published host and port properties.
}
{
{   Rev 1.1    12/6/2002 05:29:28 PM  JPMugaas
{ Now decend from TIdTCPClientCustom instead of TIdTCPClient.
}
{
{   Rev 1.0    11/14/2002 02:17:02 PM  JPMugaas
}
unit IdDayTime;

{*******************************************************}
{                                                       }
{       Indy QUOTD Client TIdDayTime                    }
{                                                       }
{       Copyright (C) 2000 Winshoes WOrking Group       }
{       Started by J. Peter Mugaas                      }
{       2000-April-23                                   }
{                                                       }
{*******************************************************}
{2000-April-30  J. Peter Mugaas
  changed to drop control charactors and spaces from result to ease
  parsing}
interface

uses
  Classes,
  IdAssignedNumbers,
  IdTCPClient;

type
  TIdDayTime = class(TIdTCPClientCustom)
  protected
    Function GetDayTimeStr : String;
    procedure InitComponent; override;
  public
    Property DayTimeStr : String read GetDayTimeStr;
  published
    property Port default IdPORT_DAYTIME;
    property Host;
  end;

implementation

uses
  SysUtils;

{ TIdDayTime }

procedure TIdDayTime.InitComponent;
begin
  inherited;
  Port := IdPORT_DAYTIME;
end;

function TIdDayTime.GetDayTimeStr: String;
begin
  Result := Trim ( ConnectAndGetAll );
end;

end.
