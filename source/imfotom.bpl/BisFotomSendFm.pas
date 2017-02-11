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

  TBisFotomSendForm=class;

  TBisFotomSendThread=class(TThread)
  private
    FLastResult: String;
    FPosition: Integer;
    FMax: Integer;
    FCount, FRealyCount: Integer;
    FParent: TBisFotomSendForm;
    procedure UpdateProgressBar;
    procedure UpdateLabelStatus;
  public
    destructor Destroy; override;
    procedure Execute; override;
    procedure Suspend; reintroduce;

    property LastResult: String read FLastResult;
    property Parent: TBisFotomSendForm read FParent write FParent;
  end;

  TBisFotomSendForm = class(TBisForm)
    ProgressBar: TProgressBar;
    ButtonBreak: TButton;
    LabelStatus: TLabel;
    procedure ButtonBreakClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMainForm: IBisFotomMainForm;
    FSends: TBisFotomSends;
    FThread: TBisFotomSendThread;
    procedure ThreadTerminate(Sender: TObject);
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

{ TBisFotomSendThread }

destructor TBisFotomSendThread.Destroy;
begin
  TerminateThread(Handle,0);
  inherited Destroy;
end;

procedure TBisFotomSendThread.UpdateProgressBar;
begin
  FParent.ProgressBar.Position:=FPosition;
  FParent.ProgressBar.Max:=FMax;
  FParent.ProgressBar.Update;
end;

procedure TBisFotomSendThread.UpdateLabelStatus;
begin
  FParent.LabelStatus.Caption:=FormatEx('�������� %d �� %d ����������.',[FCount,FRealyCount]);
  FParent.LabelStatus.Update;
end;

procedure TBisFotomSendThread.Execute;
var
  Url: String;
  Source: TIdMultiPartFormDataStream;
  Http: TBisFotomIdHttp;
  i: Integer;
  Item: TBisFotomSend;
  Ret: String;
  AUrl: String;
begin
  Ret:='������ �� ����������.';
  try
    Http:=TBisFotomIdHttp.Create(nil);
    FPosition:=0;
    FMax:=FParent.FSends.Count;
    Synchronize(UpdateProgressBar);
    try
      FCount:=0;
      FRealyCount:=FParent.FSends.RealyCount;
      Http.Request.UserAgent:='';

      AUrl:='';
      try
        Http.URL.Host:=FParent.FMainForm.WebHost;
        Http.URL.Port:=IntToStr(FParent.FMainForm.WebPort);
        Http.URL.Protocol:=FParent.FMainForm.WebProtocol;
        Http.URL.Path:=FParent.FMainForm.WebPath;
        AUrl:=Http.URL.GetFullURI([]);
      except
      end;

      if FParent.FMainForm.UseProxy then begin
        Http.ProxyParams.ProxyServer:=FParent.FMainForm.ProxyHost;
        Http.ProxyParams.ProxyPort:=FParent.FMainForm.ProxyPort;
        Http.ProxyParams.ProxyUsername:=FParent.FMainForm.ProxyUser;
        Http.ProxyParams.ProxyPassword:=FParent.FMainForm.ProxyPassword;
      end;

      for i:=0 to FParent.FSends.Count-1 do begin
        Item:=FParent.FSends.Items[i];

        FCount:=FCount+Item.IDs.Count;
        Synchronize(UpdateLabelStatus);
        FPosition:=i+1;
        Synchronize(UpdateProgressBar);

        Source:=TIdMultiPartFormDataStream.Create;
        try
          Item.Position:=0;
          Source.AddObject(FParent.FMainForm.FormParam,'application/x-zip-compressed',Item,Item.FileName);

          Ret:=Trim(Http.Post(AUrl,Source));
          if not AnsiSameText(Ret,FParent.FMainForm.SuccessString) then
            raise Exception.Create(Ret);

          Item.Sended:=true;
        finally
          Source.Free;
        end;

      end;
      FLastResult:=Ret;
    finally
      Http.Free;
    end;
  except
    On E: Exception do begin
      FLastResult:=E.Message;
    end;
  end;
end;


procedure TBisFotomSendThread.Suspend;
begin
  FLastResult:='�������� ��������.';
  inherited Suspend;
end;

{ TBisFotomSendForm }

constructor TBisFotomSendForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSends:=TBisFotomSends.Create;
  FThread:=TBisFotomSendThread.Create(true);
  FThread.Parent:=Self;
  FThread.OnTerminate:=ThreadTerminate;
end;

destructor TBisFotomSendForm.Destroy;
begin
  FThread.Free;
  FSends.Free;
  inherited Destroy;
end;

procedure TBisFotomSendForm.FormShow(Sender: TObject);
begin
  FThread.Resume;
end;

procedure TBisFotomSendForm.ButtonBreakClick(Sender: TObject);
begin
  if not FThread.Suspended then
    FThread.Suspend;
  Close;
end;

function TBisFotomSendForm.Send: String;
begin
  ShowModal;
  Result:=FThread.LastResult;
end;

procedure TBisFotomSendForm.ThreadTerminate(Sender: TObject);
begin
  Close;
end;

end.