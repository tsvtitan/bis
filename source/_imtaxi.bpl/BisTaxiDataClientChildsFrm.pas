unit BisTaxiDataClientChildsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,

  BisDataGridFrm, BisDataEditFm;

type
  TBisTaxiDataClientChildsFrame = class(TBisDataGridFrame)
  private
    FClientId: Variant;
    FUserName: String;
    { Private declarations }
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;  
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;

    property ClientId: Variant read FClientId write FClientId;
    property UserName: String read FUserName write FUserName;
  end;

implementation

uses BisDataSet, BisProvider, BisDialogs, BisUtils,
     BisTaxiDataClientsFm;

{$R *.dfm}

type
  TBisTaxiDataClientChildsFrameInsertFormIface=class(TBisDataEditFormIface)
  private
    FClientId: Variant;
  public
    procedure Execute; override;

    property ClientId: Variant read FClientId write FClientId;
  end;

{ TBisTaxiDataClientChildsFrameInsertFormIface }

procedure TBisTaxiDataClientChildsFrameInsertFormIface.Execute;
var
  Iface: TBisTaxiDataClientsFormIface;
  P: TBisProvider;
  DS: TBisDataSet;
begin
  if Assigned(ParentProvider) then begin
    Iface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      if Iface.SelectInto(DS) then begin
        P:=TBisProvider.Create(nil);
        try
          P.WithWaitCursor:=true;
          P.StopException:=true;
          P.ProviderName:='I_CLIENT_CHILD';
          P.Params.AddInvisible('CLIENT_ID').Value:=FClientId;
          P.Params.AddInvisible('CHILD_ID').Value:=DS.FieldByName('ID').Value;
          P.Execute;
          if P.Success then begin
            ParentProvider.Append;
            ParentProvider.FieldByName('CLIENT_ID').Value:=FClientId;
            ParentProvider.FieldByName('CHILD_ID').Value:=DS.FieldByName('ID').Value;
            ParentProvider.FieldByName('CHILD_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
            ParentProvider.FieldByName('CHILD_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
            ParentProvider.FieldByName('CHILD_NAME').Value:=DS.FieldByName('NAME').Value;
            ParentProvider.FieldByName('CHILD_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
            ParentProvider.Post;
          end;
        finally
          P.Free;
        end;
      end;
    finally
      DS.Free;
      Iface.Free;
    end;
  end;
end;

type
  TBisTaxiDataClientChildsFrameDeleteFormIface=class(TBisDataEditFormIface)
  public
    procedure Execute; override;
  end;

{ TBisTaxiDataClientChildsFrameDeleteFormIface }

procedure TBisTaxiDataClientChildsFrameDeleteFormIface.Execute;
var
  P: TBisProvider;
  S: String;
begin
  if Assigned(ParentProvider) and ParentProvider.Active and not ParentProvider.Empty then begin
    S:=FormatEx('������� ������� %s �� ������?',[ParentProvider.FieldByName('CHILD_USER_NAME').AsString]);
    if ShowQuestion(S,mbNo)=mrYes then begin
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=true;
        P.StopException:=true;
        P.ProviderName:='D_CLIENT_CHILD';
        P.Params.AddInvisible('OLD_CLIENT_ID').Value:=ParentProvider.FieldByName('CLIENT_ID').Value;
        P.Params.AddInvisible('OLD_CHILD_ID').Value:=ParentProvider.FieldByName('CHILD_ID').Value;
        P.Execute;
        if P.Success then
          ParentProvider.Delete;
      finally
        P.Free;
      end;
    end;
  end;
end;

{ TBisTaxiDataClientChildsFrame }

constructor TBisTaxiDataClientChildsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InsertClass:=TBisTaxiDataClientChildsFrameInsertFormIface;
  DeleteClass:=TBisTaxiDataClientChildsFrameDeleteFormIface;
  with Provider do begin
    ProviderName:='S_CLIENT_CHILDS';
    with FieldNames do begin
      AddKey('CLIENT_ID');
      AddKey('CHILD_ID');
      Add('CHILD_USER_NAME','�����',100);
      Add('CHILD_SURNAME','�������',120);
      Add('CHILD_NAME','���',100);
      Add('CHILD_PATRONYMIC','��������',130);
    end;
    Orders.Add('CHILD_USER_NAME');
  end;

  ActionDuplicate.Visible:=false;
  ActionUpdate.Visible:=false;

  FClientId:=Null;
end;

procedure TBisTaxiDataClientChildsFrame.Init;
begin
  inherited Init;
  DuplicateClass:=nil;
end;

procedure TBisTaxiDataClientChildsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
  if Assigned(AIface) then begin

    if (AIface is TBisTaxiDataClientChildsFrameInsertFormIface) then
      TBisTaxiDataClientChildsFrameInsertFormIface(AIface).ClientId:=FClientId;

  end;
end;


end.
