unit BisKrieltDataPresentationsFrm;

interface                                                                                                 

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls, Contnrs,

  BisDataGridFrm, BisKrieltPresentationFm, BisKrieltDataColumnsFm;

type
  TBisKrieltDataPresentationsFrameIfaces=class(TObjectList)
  public
    function FindPresentationById(PresentationId: Variant): TBisKrieltDataColumnsFormIface;
  end;

  TBisKrieltDataPresentationsFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    ToolButtonRefreshCurrent: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ActionRefreshCurrent: TAction;
    N13: TMenuItem;
    ActionRefreshFilter: TAction;
    ActionViewPresentation: TAction;
    N15: TMenuItem;
    N16: TMenuItem;
    N18: TMenuItem;
    ToolButtonComposition: TToolButton;
    ActionComposition: TAction;
    MenuItemComposition: TMenuItem;
    procedure ActionRefreshCurrentUpdate(Sender: TObject);
    procedure ActionRefreshCurrentExecute(Sender: TObject);
    procedure ActionRefreshFilterExecute(Sender: TObject);
    procedure ActionRefreshFilterUpdate(Sender: TObject);
    procedure ActionViewPresentationUpdate(Sender: TObject);
    procedure ActionViewPresentationExecute(Sender: TObject);
    procedure ActionCompositionExecute(Sender: TObject);
    procedure ActionCompositionUpdate(Sender: TObject);
  private
    FIfaces: TBisKrieltDataPresentationsFrameIfaces;
    FPresentationIface: TBisKrieltPresentationFormIface;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanComposition: Boolean;
    procedure Composition;


  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisKrieltDataPresentationEditFm, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataPresentationsFrameIfaces }

function TBisKrieltDataPresentationsFrameIfaces.FindPresentationById(PresentationId: Variant): TBisKrieltDataColumnsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisKrieltDataColumnsFormIface) then begin
      if VarSameValue(TBisKrieltDataColumnsFormIface(Obj).PresentationId,PresentationId) then begin
        Result:=TBisKrieltDataColumnsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisKrieltDataPresentationsFrame }

constructor TBisKrieltDataPresentationsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisKrieltDataPresentationsFrameIfaces.Create;
end;

destructor TBisKrieltDataPresentationsFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataPresentationsFrame.ActionRefreshFilterExecute(
  Sender: TObject);
var
  P: TBisProvider;
  DS: TBisProvider;
  OldCursor: TCursor;
  Flag: Boolean;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) and DS.Active and not DS.IsEmpty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    DS.BeginUpdate(true);
    try
      DS.First;
      Flag:=true;
      while not DS.Eof do begin
        if (Trim(DS.FieldByName('TABLE_NAME').AsString)<>'') then begin
          P:=TBisProvider.Create(nil);
          try
            P.WithWaitCursor:=false;
            P.ProviderName:='R_PRESENTATION';
            P.Params.AddInvisible('PRESENTATION_ID').Value:=DS.FieldByName('PRESENTATION_ID').Value;
            P.Execute;
            Flag:=Flag and P.Success;
          finally
            P.Free;
          end;
        end;
        DS.Next;
      end;
      if Flag then
        ShowInfo('������������� ������� ���������.');
    finally
      DS.EndUpdate;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisKrieltDataPresentationsFrame.ActionRefreshFilterUpdate(
  Sender: TObject);
var
  DS: TBisProvider;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) then begin
    ActionRefreshFilter.Enabled:=DS.Active and not DS.IsEmpty;
  end;
end;

procedure TBisKrieltDataPresentationsFrame.ActionCompositionExecute(Sender: TObject);
begin
  Composition;
end;

procedure TBisKrieltDataPresentationsFrame.ActionCompositionUpdate(Sender: TObject);
begin
  ActionComposition.Enabled:=CanComposition;
end;

procedure TBisKrieltDataPresentationsFrame.ActionRefreshCurrentExecute(
  Sender: TObject);
var
  P: TBisProvider;
  DS: TBisProvider;
  OldCursor: TCursor;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) and DS.Active and not DS.IsEmpty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='R_PRESENTATION';
      P.Params.AddInvisible('PRESENTATION_ID').Value:=DS.FieldByName('PRESENTATION_ID').Value;
      P.Execute;
      if P.Success then
        ShowInfo(FormatEx('�������������: %s ������� ���������.',[DS.FieldByName('NAME').AsString]));
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisKrieltDataPresentationsFrame.ActionRefreshCurrentUpdate(
  Sender: TObject);
var
  DS: TBisProvider;
  F: TField;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) then begin
    F:=DS.FindField('TABLE_NAME');
    ActionRefreshCurrent.Enabled:=DS.Active and not DS.IsEmpty and Assigned(F) and (Trim(F.AsString)<>'');
  end;
end;

procedure TBisKrieltDataPresentationsFrame.ActionViewPresentationExecute(
  Sender: TObject);
var
  DS: TBisProvider;
  AIface: TBisKrieltPresentationFormIface;
  PublishingName: String;
  ViewName: string;
  TypeName: String;
  OperationName: String;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) then begin
    if not Assigned(FPresentationIface) then begin
      FPresentationIface:=TBisKrieltPresentationFormIface.Create(Self);
    end;
    AIface:=FPresentationIface;
    AIface.ShowType:=ShowType;
    AIface.PresentationId:=DS.FieldByName('PRESENTATION_ID').Value;
    AIface.PresentationName:=DS.FieldByName('NAME').AsString;
    AIface.TableName:=DS.FieldByName('TABLE_NAME').AsString;
    AIface.PublishingId:=DS.FieldByName('PUBLISHING_ID').Value;
    AIface.ViewId:=DS.FieldByName('VIEW_ID').Value;
    AIface.TypeId:=DS.FieldByName('TYPE_ID').Value;
    AIface.OperationId:=DS.FieldByName('OPERATION_ID').Value;

    PublishingName:=DS.FieldByName('PUBLISHING_NAME').AsString;
    if Trim(PublishingName)='' then PublishingName:='��� �������';
    ViewName:=DS.FieldByName('VIEW_NAME').AsString;
    if Trim(ViewName)='' then ViewName:='��� ����';
    TypeName:=DS.FieldByName('TYPE_NAME').AsString;
    if Trim(TypeName)='' then TypeName:='��� ����';
    OperationName:=DS.FieldByName('OPERATION_NAME').AsString;
    if Trim(OperationName)='' then OperationName:='��� ��������';

    AIface.PresentationPath:=Format('%s\%s\%s\%s',[PublishingName,ViewName,TypeName,OperationName]);
    AIface.RefreshByPresentationId;
    AIface.Show;
  end;
end;

procedure TBisKrieltDataPresentationsFrame.ActionViewPresentationUpdate(
  Sender: TObject);
var
  DS: TBisProvider;
  F,F2: TField;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) then begin
    F:=DS.FindField('TABLE_NAME');
    F2:=DS.FindField('PRESENTATION_TYPE');
    ActionViewPresentation.Enabled:=DS.Active and not DS.IsEmpty and
                                    Assigned(F) and (Trim(F.AsString)<>'') and
                                    Assigned(F2) and (TBisKrieltDataPresentationType(F2.AsInteger) in [ptViewing]);
  end;
end;

function TBisKrieltDataPresentationsFrame.CanComposition: Boolean;
var
  Iface: TBisKrieltDataColumnsFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisKrieltDataColumnsFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisKrieltDataPresentationsFrame.Composition;
var
  Iface: TBisKrieltDataColumnsFormIface;
  PresentationId: Variant;
  PresentationName: String;
begin
  if CanComposition then begin
    PresentationId:=Provider.FieldByName('PRESENTATION_ID').Value;
    PresentationName:=Provider.FieldByName('NAME').AsString;
    Iface:=FIfaces.FindPresentationById(PresentationId);
    if not Assigned(Iface) then begin
      Iface:=TBisKrieltDataColumnsFormIface.Create(Self);
      Iface.PresentationId:=PresentationId;
      Iface.PresentationName:=PresentationName;
      Iface.PresentationType:=TBisKrieltDataPresentationType(Provider.FieldByName('PRESENTATION_TYPE').AsInteger);
      Iface.MaxFormCount:=1;
      Iface.FilterOnShow:=false;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.FilterGroups.Add.Filters.Add('PRESENTATION_ID',fcEqual,PresentationId);
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionComposition.Caption,PresentationName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;    
  end;
end;

end.
