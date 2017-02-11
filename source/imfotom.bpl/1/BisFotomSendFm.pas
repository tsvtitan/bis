unit BisFotomSendFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Contnrs,
  IdHttp,
  BisFm, BisFotomMainFmIntf;

type
  TBisFotomSend=class(TMemoryStream)
  private
    FSended: Boolean;
    FIDs: TStringList;
    FFileName: String;
  public
    constructor Create;
    destructor Destroy; override;

    property Sended: Boolean read FSended write FSended;
    property IDs: TStringList read FIDs;
    property FileName: String read FFileName write FFileName; 
  end;

  TBisFotomSends=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisFotomSend;
  public
    function Add(Source: TStream): TBisFotomSend;
    function RealyCount: Integer;

    property Items[Index: Integer]: TBisFotomSend read GetItem;
  end;

  TBisFotomIdHttp=class(TIdHttp)
  end;

  TBisFotomSendForm = class(TBisForm)
    ProgressBar: TProgressBar;
    ButtonBreak: TButton;
    LabelStatus: TLabel;
    procedure ButtonBreakClick(Sender: TObject);
  private
    FBreaked: Boolean;
    FMainForm: IBisFotomMainForm;
    FSends: TBisFotomSends;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Send: String;

    property MainForm: IBisFotomMainForm read FMainForm write FMainForm;

    property Sends: TBisFotomSends read FSends;
  end;

var
  BisFotomSendForm: TBisFotomSendForm;

implementation

uses IdMultipartFormData,
     BisUtils;

{$R *.dfm}


{ TBisFotomSend }

constructor TBisFotomSend.Create;
begin
  inherited Create;
  FIDs:=TStringList.Create;
end;

destructor TBisFotomSend.Destroy;
begin
  FIDs.Free;
  inherited Destroy;
end;


{ TBisFotomSends }

function TBisFotomSends.Add(Source: TStream): TBisFotomSend;
begin
  Result:=TBisFotomSend.Create;
  Result.CopyFrom(Source,Source.Size);
  inherited Add(Result);
end;

function TBisFotomSends.GetItem(Index: Integer): TBisFotomSend;
begin
  Result:=TBisFotomSend(inherited Items[Index]);
end;


function TBisFotomSends.RealyCount: Integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Result:=Result+Items[i].IDs.Count;
  end;
end;

{ TBisFotomSendForm }

constructor TBisFotomSendForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSends:=TBisFotomSends.Create;
end;

destructor TBisFotomSendForm.Destroy;
begin
  FSends.Free;
  inherited Destroy;
end;

procedure TBisFotomSendForm.ButtonBreakClick(Sender: TObject);
begin
  FBreaked:=true;
end;

function TBisFotomSendForm.Send: String;
var
  Url: String;
  Source: TIdMultiPartFormDataStream;
  Http: TBisFotomIdHttp;
  i: Integer;
  Item: TBisFotomSend;
  Ret: String;
  AUrl: String;
  ACount, ARealyCount: Integer;
begin
  Ret:='Ошибка не определена.';
  try
    Http:=TBisFotomIdHttp.Create(Self);
    ProgressBar.Position:=0;
    ProgressBar.Max:=FSends.Count;
    Show;
    try
      ACount:=0;
      ARealyCount:=FSends.RealyCount;
      Http.Request.UserAgent:='';

      AUrl:='';
      try
        Http.URL.Host:=FMainForm.WebHost;
        Http.URL.Port:=IntToStr(FMainForm.WebPort);
        Http.URL.Protocol:=FMainForm.WebProtocol;
        Http.URL.Path:=FMainForm.WebPath;
        AUrl:=Http.URL.GetFullURI([]);
      except
      end;

      if FMainForm.UseProxy then begin
        Http.ProxyParams.ProxyServer:=FMainForm.ProxyHost;
        Http.ProxyParams.ProxyPort:=FMainForm.ProxyPort;
        Http.ProxyParams.ProxyUsername:=FMainForm.ProxyUser;
        Http.ProxyParams.ProxyPassword:=FMainForm.ProxyPassword;
      end;

      for i:=0 to FSends.Count-1 do begin
        Item:=FSends.Items[i];

        Application.ProcessMessages;
        if FBreaked then begin
          Result:='Загрузка прервана.';
          exit;
        end;

        ACount:=ACount+Item.IDs.Count;
        LabelStatus.Caption:=FormatEx('Загрузка %d из %d фотографий.',[ACount,ARealyCount]);
        LabelStatus.Update;

        ProgressBar.Position:=i+1;
        ProgressBar.Update;
        
        Source:=TIdMultiPartFormDataStream.Create;
        try
          Item.Position:=0;
          Source.AddObject(FMainForm.FormParam,'application/x-zip-compressed',Item,Item.FileName);

          Ret:=Trim(Http.Post(Url,Source));
          if not AnsiSameText(Ret,FMainForm.SuccessString) then
            raise Exception.Create(Ret);

          Item.Sended:=true;
        finally
          Source.Free;
        end;

      end;
      Result:=Ret;
    finally
      ProgressBar.Position:=0;
      Http.Free;
      Hide;
    end;
  except
    On E: Exception do begin
      Result:=E.Message;
    end;
  end;
end;


end.
