unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,

  BisSpeech, WideStrings, FMTBcd, DB, SqlExpr;

type
  TSpeechForm = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FSpeech: TBisSpeech;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  SpeechForm: TSpeechForm;

implementation

{$R *.dfm}

{ TSpeechForm }

constructor TSpeechForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FSpeech:=TBisSpeech.Create(nil);
end;

destructor TSpeechForm.Destroy;
begin
  FSpeech.Free;
  inherited Destroy;
end;

procedure TSpeechForm.Button1Click(Sender: TObject);
begin
  Button2Click(nil);
  SQLConnection1.Connected:=true;
  try
    SQLQuery1.Open;
    if SQLQuery1.Active then begin
      SQLQuery1.First;
      while not SQLQuery1.Eof do begin
        
        SQLQuery1.Next;
      end;
    end;
  finally
    SQLConnection1.Connected:=false;
  end;
end;

procedure TSpeechForm.Button2Click(Sender: TObject);
begin
  //
end;

end.
