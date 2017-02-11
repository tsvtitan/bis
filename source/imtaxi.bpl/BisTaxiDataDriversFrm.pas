unit BisTaxiDataDriversFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  BisFm,
  BisDataGridFrm;

type                                                                                                
  TBisTaxiDataDriversFrame = class(TBisDataGridFrame)
    ActionMessages: TAction;
    N1: TMenuItem;
    MenuItemMessages: TMenuItem;
    procedure ActionMessagesExecute(Sender: TObject);
    procedure ActionMessagesUpdate(Sender: TObject);
  private
    function CanMessages: Boolean;
    procedure Messages;
  public
    constructor Create(AOwner: TComponent); override;

    function CanUpdateRecord: Boolean; override;
    function CanDeleteRecord: Boolean; override;
  end;

implementation

{$R *.dfm}

uses BisCore, BisUtils, BisConsts, BisFilterGroups, BisProvider,
     BisMessDataOutMessageInsertExFm,
     BisTaxiDataDriverEditFm, BisTaxiDataOutMessageEditFm;

type
  TBisTaxiDataDriversOutMessagesFormIface=class(TBisTaxiDataOutMessageInsertExFormIface)
  private
    FFrame: TBisTaxiDataDriversFrame;
  protected
    function CreateForm: TBisForm; override;
  public

    property Frame: TBisTaxiDataDriversFrame read FFrame write FFrame;
  end;


{ TBisTaxiDataDriversOutMessagesFormIface }

function TBisTaxiDataDriversOutMessagesFormIface.CreateForm: TBisForm;
var
  Form: TBisMessDataOutMessageInsertExForm;
  Phone: String;
  OldCursor: TCursor;
begin
  Result:=inherited CreateForm;
  if Assigned(FFrame) and Assigned(Result) and (Result is TBisMessDataOutMessageInsertExForm) then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    FFrame.Provider.BeginUpdate(true);
    try
      Form:=TBisMessDataOutMessageInsertExForm(Result);
      Form.WithLocked:=false;
      FFrame.Provider.First;
      while not FFrame.Provider.Eof do begin
        Phone:=FFrame.Provider.FieldByName('PHONE').AsString;
        if Trim(Phone)<>'' then begin
          Form.AddRecipient(FFrame.Provider.FieldByName('USER_NAME').AsString,
                            FFrame.Provider.FieldByName('SURNAME').AsString,
                            FFrame.Provider.FieldByName('NAME').AsString,
                            FFrame.Provider.FieldByName('PATRONYMIC').AsString,
                            Phone,
                            FFrame.Provider.FieldByName('DRIVER_ID').Value,
                            False);
        end;
        FFrame.Provider.Next;
      end;
    finally
      FFrame.Provider.EndUpdate;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;
     
{ TBisTaxiDataDriversFrame }

constructor TBisTaxiDataDriversFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ViewClass:=TBisTaxiDataDriverViewFormIface;
  FilterClass:=TBisTaxiDataDriverFilterFormIface;
  InsertClass:=TBisTaxiDataDriverInsertFormIface;
  UpdateClass:=TBisTaxiDataDriverUpdateFormIface;
  DeleteClass:=TBisTaxiDataDriverDeleteFormIface;

  with Provider do begin
    ProviderName:='S_DRIVERS';
    with FieldNames do begin
      AddKey('DRIVER_ID');
      AddInvisible('CALC_ID');
      AddInvisible('CAR_ID');
      AddInvisible('METHOD_ID');
      AddInvisible('PHONE_HOME');
      AddInvisible('LICENSE');
      AddInvisible('CATEGORIES');
      AddInvisible('INSURANCE');
      AddInvisible('HEALTH_CERT');
      AddInvisible('DESCRIPTION');
      AddInvisible('ADDICT_CERT');
      AddInvisible('PASSPORT');
      AddInvisible('PLACE_BIRTH');
      AddInvisible('DATE_BIRTH');
      AddInvisible('ADDRESS_RESIDENCE');
      AddInvisible('LOCKED');
      AddInvisible('CALC_NAME');
      AddInvisible('CAR_COLOR');
      AddInvisible('MIN_BALANCE');
      AddInvisible('PRIORITY');
      AddInvisible('DATE_PRIORITY');
      AddInvisible('MIN_HOURS');
      AddInvisible('DATE_SCHEDULE');
      AddInvisible('METHOD_NAME');
      AddInvisible('DATE_CREATE');
      AddInvisible('CAR_CALLSIGN');
      AddInvisible('FIRM_ID');

      AddInvisible('DRIVER_TYPE_ID');
      AddInvisible('DRIVER_TYPE_NAME');
      AddInvisible('DATE_APPEAR');
      AddInvisible('TYPE_SCHEDULE');
      AddInvisible('REST_DAYS');
      AddInvisible('WORK_DAYS');
      AddInvisible('DATE_LOCK');
      AddInvisible('REASON_LOCK');

      Add('USER_NAME','Логин',50);
      Add('SURNAME','Фамилия',80);
      Add('NAME','Имя',70);
      Add('PATRONYMIC','Отчество',80);
      Add('PHONE','Телефон',80);
      Add('CAR_BRAND','Марка автомобиля',90);
      Add('CAR_STATE_NUM','Номер автомобиля',50);
      Add('FIRM_SMALL_NAME','Организация',100);
      Add('ADDRESS_ACTUAL','Адрес фактический',100);
    end;
  end;

  with CreateFilterMenuItem('Активные') do begin
    FilterGroups.AddVisible.Filters.Add('LOCKED',fcEqual,0);
    Checked:=true;
  end;

  with CreateFilterMenuItem('Заблокированные') do begin
    FilterGroups.AddVisible.Filters.Add('LOCKED',fcEqual,1);
  end;

end;

procedure TBisTaxiDataDriversFrame.ActionMessagesExecute(Sender: TObject);
begin
  Messages;
end;

procedure TBisTaxiDataDriversFrame.ActionMessagesUpdate(Sender: TObject);
begin
  ActionMessages.Enabled:=CanMessages;
end;

function TBisTaxiDataDriversFrame.CanMessages: Boolean;
var
  AIface: TBisTaxiDataOutMessageInsertExFormIface;
begin
  Result:=Provider.Active and not Provider.Empty; 
  if Result then begin
    AIface:=TBisTaxiDataOutMessageInsertExFormIface.Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataDriversFrame.Messages;
var
  AIface: TBisTaxiDataDriversOutMessagesFormIface;
begin
  if CanMessages then begin
    AIface:=TBisTaxiDataDriversOutMessagesFormIface.Create(nil);
    try
      AIface.Init;
      AIface.Permissions.Enabled:=false;
      AIface.ShowType:=ShowType;
      AIface.Frame:=Self;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

function TBisTaxiDataDriversFrame.CanUpdateRecord: Boolean;
var
  P: TBisProvider;
begin
  Result:=inherited CanUpdateRecord;
  if Result then begin
    P:=GetCurrentProvider;
    if Assigned(P) and P.Active and not P.Empty then begin
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,P.FieldByName('FIRM_ID').Value);
    end;
  end;
end;

function TBisTaxiDataDriversFrame.CanDeleteRecord: Boolean;
var
  P: TBisProvider;
begin
  Result:=inherited CanDeleteRecord;
  if Result then begin
    P:=GetCurrentProvider;
    if Assigned(P) and P.Active and not P.Empty then begin
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,P.FieldByName('FIRM_ID').Value);
    end;
  end;
end;


end.
