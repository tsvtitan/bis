unit BisHttpServerHandlerFilesWm;

interface

uses
  SysUtils, Classes, HTTPApp, DB, Contnrs,
  BisLogger, BisHttpServerHandlers;

type

  TBisHttpServerHandlerMobileWebModule = class(TWebModule)
    procedure BisHttpServerHandlerMobileWebModulejavaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerMobileWebModuleDefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    FHandler: TBisHttpServerHandler;

    function Execute(Request: TWebRequest; Response: TWebResponse): Boolean;
    procedure LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);
  public
    property Handler: TBisHttpServerHandler read FHandler write FHandler;
  end;

var
  BisHttpServerHandlerMobileWebModule: TBisHttpServerHandlerMobileWebModule;

implementation

{$R *.dfm}

uses Windows, Variants, StrUtils,
     AlXmlDoc,
     BisConsts, BisUtils, BisProvider, BisCore, BisFilterGroups;

{ TBisHttpServerHandlerMessageWebModule }

procedure TBisHttpServerHandlerMobileWebModule.LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);
begin
  if Assigned(Core) and Assigned(Core.Logger) then
    Core.Logger.Write(Message,LogType,Self.Name);
end;

function TBisHttpServerHandlerMobileWebModule.Execute(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  RequestStream: TMemoryStream;
  FileStream: TFileStream;
  Flag: Boolean;
begin
  Result:=false;
  if Assigned(FHandler) and Assigned(Core) then begin
    LoggerWrite(Request.Query);
    RequestStream:=TMemoryStream.Create;
    try
      RequestStream.WriteBuffer(Pointer(Request.Content)^,Length(Request.Content));
      RequestStream.Position:=0;

      Flag:=true;
      case Request.MethodType of
        mtGet: ;
        mtPost: ;
      end;

      if Flag then begin
        if Assigned(Response.ContentStream) then begin
          case Request.MethodType of
            mtGet: begin
              //if Request.Content='1' then
            //    Response.Content:='OK'
            {  else
                Response.Content:='Internal system error';  }
            end;
            mtPost: ;
          end;
          Response.ContentType:='application/java-archive';
          Result:=true;
        end;
      end;

    finally
      RequestStream.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerMobileWebModule.BisHttpServerHandlerMobileWebModuleDefaultAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  RequestStream: TMemoryStream;
  FileStream: TFileStream;
  Flag: Boolean;
begin
  Handled:=false;
  if Assigned(FHandler) and Assigned(Core) then begin
    LoggerWrite(Request.Query);
    RequestStream:=TMemoryStream.Create;
    try
      RequestStream.WriteBuffer(Pointer(Request.Content)^,Length(Request.Content));
      RequestStream.Position:=0;

      Flag:=true;
      case Request.MethodType of
        mtGet: ;
        mtPost: ;
      end;

      if Flag then begin
        if Assigned(Response.ContentStream) then begin
          case Request.MethodType of
            mtGet: begin
              //if Request.Content='1' then
            //    Response.Content:='OK'
            {  else
                Response.Content:='Internal system error';  }
            end;
            mtPost: ;
          end;
          Response.Content:='OK';
          Handled:=true;
        end;
      end;

    finally
      RequestStream.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerMobileWebModule.BisHttpServerHandlerMobileWebModulejavaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Stream: TMemoryStream;
begin
  if Assigned(FHandler) and Assigned(Core) then begin
    LoggerWrite(Request.Query);
    if Assigned(Response.ContentStream) then begin
      Stream:=TMemoryStream.Create;
      try
        Stream.LoadFromFile('u:\bin\!\taxi.jar');
        Stream.Position:=0;
        Response.ContentStream.CopyFrom(Stream,Stream.Size);
        Response.ContentStream.Position:=0;
        Response.ContentType:='application/java-archive';
        Handled:=true;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

end.
