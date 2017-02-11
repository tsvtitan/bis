unit BisTaxiClientFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDialogFm, BisFm, BisProvider,
  BisControls;

type
  TBisTaxiClientForm = class(TBisDialogForm)
    PanelControls: TPanel;                                                                                  
    LabelUserName: TLabel;
    EditUserName: TEdit;
    LabelBalance: TLabel;
    EditBalance: TEdit;
    EditFIO: TEdit;
    LabelFIO: TLabel;
    LabelFirm: TLabel;
    EditFirm: TEdit;
    LabelJobTitle: TLabel;
    EditJobTitle: TEdit;
    LabelAddress: TLabel;
    EditAddress: TEdit;
    LabelPhone: TLabel;
    EditPhone: TEdit;
  private
    function GetAddressString(StreetPrefix,StreetName,House,Flat,LocalityPrefix,LocalityName: Variant): String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetParams(P: TBisProvider);
  end;

  TBisTaxiClientFormIface=class(TBisDialogFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiClientForm: TBisTaxiClientForm;

implementation

uses BisUtils, BisParam;

{$R *.dfm}

{ TBisTaxiClientFormIface }

constructor TBisTaxiClientFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiClientForm;
end;

{ TBisTaxiClientForm }

constructor TBisTaxiClientForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  EditBalance.Alignment:=taRightJustify;
end;

function TBisTaxiClientForm.GetAddressString(StreetPrefix,StreetName,House,Flat,LocalityPrefix,LocalityName: Variant): String;
var
  F1,F2,F3,F4,F5,F6: String;
const
  SQ='?';
begin
  Result:='';

  F1:=Trim(VarToStrDef(StreetPrefix,''));
  F2:=Trim(VarToStrDef(StreetName,''));
  F3:=Trim(VarToStrDef(House,''));
  F4:=Trim(VarToStrDef(Flat,''));
  F5:=Trim(VarToStrDef(LocalityPrefix,''));
  F6:=Trim(VarToStrDef(LocalityName,''));

  if F2<>'' then
    Result:=FormatEx('%s%s %s-%s (%s%s)',
                     [iff(F1='',SQ,F1),iff(F2='',SQ,F2),iff(F3='',SQ,F3),
                      iff(F4='',SQ,F4),iff(F5='',SQ,F5),iff(F6='',SQ,F6)]);

end;

procedure TBisTaxiClientForm.SetParams(P: TBisProvider);
var
  Balance: Extended;
begin
  Balance:=P.ParamByName('BALANCE').AsExtended;

  EditUserName.Text:=P.ParamByName('USER_NAME').AsString;
  EditBalance.Text:=FormatFloat('#0.00',Balance);
  EditBalance.Font.Color:=iff(Balance>=0.0,clGreen,clRed);
  EditFIO.Text:=Trim(FormatEx('%s %s %s',
                              [P.ParamByName('SURNAME').AsString,
                               P.ParamByName('NAME').AsString,
                               P.ParamByName('PATRONYMIC').AsString]));
  EditFirm.Text:=P.ParamByName('FIRM_SMALL_NAME').AsString;
  EditJobTitle.Text:=P.ParamByName('JOB_TITLE').AsString;
  EditAddress.Text:=GetAddressString(P.ParamByName('STREET_PREFIX').Value,
                                     P.ParamByName('STREET_NAME').Value,
                                     P.ParamByName('HOUSE').Value,
                                     P.ParamByName('FLAT').Value,
                                     P.ParamByName('LOCALITY_PREFIX').Value,
                                     P.ParamByName('LOCALITY_NAME').Value);
  EditPhone.Text:=P.ParamByName('PHONE').AsString;
  ButtonOk.Enabled:=Balance>=0.0;
end;

end.
