unit BisDesignDataReportsFrm;

interface

uses                                                                                             
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, Contnrs, StdCtrls,

  BisDataGridFrm, BisDataFrm, BisReportEditorFm, BisReportFm, BisReportModules;

type
  TBisDesignDataReportsFrameEditors=class(TObjectList)
  public
    function FindByClass(AClass: TClass; ACaption: String): TBisReportEditorFormIface;
  end;

  TBisDesignDataReportsFrameReports=class(TObjectList)
  public
    function FindByClass(AClass: TClass; ACaption: String): TBisReportFormIface;
  end;

  TBisDesignDataReportsFrame = class(TBisDataGridFrame)
    ToolBarReport: TToolBar;
    ToolButtonReportEdit: TToolButton;
    ToolButtonReportShow: TToolButton;
    ActionReportEdit: TAction;
    MenuItemReportEdit: TMenuItem;
    ActionReportShow: TAction;
    MenuItemReportShow: TMenuItem;
    N16: TMenuItem;
    procedure ActionReportEditUpdate(Sender: TObject);
    procedure ActionReportEditExecute(Sender: TObject);
    procedure ActionReportShowExecute(Sender: TObject);
    procedure ActionReportShowUpdate(Sender: TObject);
  private
    FEditors: TBisDesignDataReportsFrameEditors;
    FReports: TBisDesignDataReportsFrameReports;
    FOnCanReportEdit: TBisDataFrameCanEvent;
    FOnCanReportShow: TBisDataFrameCanEvent;
    function GetReportEditorClass: TBisReportEditorFormIfaceClass;
    function GetReportClass: TBisReportFormIfaceClass;
    procedure EditorSaveChanges(Sender: TObject);
    procedure EditorPreview(Sender: TObject);
    function GetModuleByName(EngineName: String): TBisReportModule; 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanReportEdit: Boolean;
    procedure ReportEdit;
    function CanReportShow: Boolean;
    procedure ReportShow;

    property OnCanReportEdit: TBisDataFrameCanEvent read FOnCanReportEdit write FOnCanReportEdit;
    property OnCanReportShow: TBisDataFrameCanEvent read FOnCanReportShow write FOnCanReportShow;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups,
     BisParam, BisCore;

{$R *.dfm}

{ TBisDesignDataReportsFrameEditors }

function TBisDesignDataReportsFrameEditors.FindByClass(AClass: TClass; ACaption: String): TBisReportEditorFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisReportEditorFormIface) and (Obj.ClassType=AClass) then begin
      if AnsiSameText(TBisReportEditorFormIface(Obj).Caption,ACaption) then begin
        Result:=TBisReportEditorFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisDesignDataReportsFrameReports }

function TBisDesignDataReportsFrameReports.FindByClass(AClass: TClass; ACaption: String): TBisReportFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisReportFormIface) and (Obj.ClassType=AClass) then begin
      if Trim(ACaption)<>'' then begin
        if AnsiSameText(TBisReportFormIface(Obj).Caption,ACaption) then begin
          Result:=TBisReportFormIface(Obj);
          exit;
        end;
      end else begin
        Result:=TBisReportFormIface(Obj);
        exit;
      end;
    end;
  end;
end;


{ TBisDesignDataReportsFrame }

constructor TBisDesignDataReportsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditors:=TBisDesignDataReportsFrameEditors.Create;
  FReports:=TBisDesignDataReportsFrameReports.Create;
end;

destructor TBisDesignDataReportsFrame.Destroy;
begin
  FReports.Free;
  FEditors.Free;
  inherited Destroy;
end;

procedure TBisDesignDataReportsFrame.ActionReportEditUpdate(Sender: TObject);
begin
  ActionReportEdit.Enabled:=CanReportEdit;
end;

procedure TBisDesignDataReportsFrame.ActionReportShowExecute(Sender: TObject);
begin
  ReportShow;
end;

procedure TBisDesignDataReportsFrame.ActionReportShowUpdate(Sender: TObject);
begin
  ActionReportShow.Enabled:=CanReportShow;
end;

procedure TBisDesignDataReportsFrame.ActionReportEditExecute(Sender: TObject);
begin
  ReportEdit;
end;

function TBisDesignDataReportsFrame.CanReportEdit: Boolean;
var
  P: TBisProvider;
  AClass: TBisReportEditorFormIfaceClass;
begin
  P:=GetCurrentProvider;
  AClass:=GetReportEditorClass;
  Result:=Assigned(P) and P.Active and not P.IsEmpty and Assigned(AClass);
  if Result and Assigned(FOnCanReportEdit) then begin
    Result:=FOnCanReportEdit(Self);
  end;
end;

function TBisDesignDataReportsFrame.GetModuleByName(EngineName: String): TBisReportModule;
var
  i: Integer;
  Module: TBisReportModule;  
begin
  Result:=nil;
  for i:=0 to Core.ReportModules.Count-1 do begin
    Module:=Core.ReportModules.Items[i];
    if AnsiSameText(Module.ObjectName,EngineName) then begin
      Result:=Module;
      exit;
    end;
  end;
end;

function TBisDesignDataReportsFrame.GetReportEditorClass: TBisReportEditorFormIfaceClass;
var
  P: TBisProvider;
  Module: TBisReportModule;
begin
  Result:=nil;
  P:=GetCurrentProvider;
  if Assigned(P) and P.Active and not P.IsEmpty then begin
    Module:=GetModuleByName(P.FieldByName('ENGINE').AsString);
    if Assigned(Module) and Assigned(Module.ReportEditorClass) then
      Result:=Module.ReportEditorClass;
  end;
end;

function TBisDesignDataReportsFrame.GetReportClass: TBisReportFormIfaceClass;
var
  P: TBisProvider;
  Module: TBisReportModule;
begin
  Result:=nil;
  P:=GetCurrentProvider;
  if Assigned(P) and P.Active and not P.IsEmpty then begin
    Module:=GetModuleByName(P.FieldByName('ENGINE').AsString);
    if Assigned(Module) and Assigned(Module.ReportClass) then
      Result:=Module.ReportClass;
  end;
end;

procedure TBisDesignDataReportsFrame.EditorSaveChanges(Sender: TObject);
var
  Stream: TMemoryStream;
  OldCursor: TCursor;
  S: String;
  P: TBisProvider;
  P2: TBisProvider;
begin
  P:=GetCurrentProvider;
  if Assigned(P) and P.Active and not P.IsEmpty and
     Assigned(Sender) and (Sender is TBisReportEditorForm) then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    P.BeginUpdate(true);
    Stream:=TMemoryStream.Create;
    P2:=TBisProvider.Create(nil);
    try
      if P.Locate('REPORT_ID',TBisReportEditorForm(Sender).ReportId,[]) then begin
        P2.ProviderName:='U_REPORT';
        with P2.Params do begin
          AddInvisible('REPORT_ID').Older('OLD_REPORT_ID');
          AddInvisible('ENGINE');
          AddInvisible('PLACE');
          AddInvisible('REPORT');
          RefreshByDataSet(P,true,false);
        end;
        if not Boolean(P.FieldByName('PLACE').AsInteger) then begin
          TBisReportEditorForm(Sender).SaveToStream(Stream);
          Stream.Position:=0;
          P2.Params.ParamByName('REPORT').LoadFromStream(Stream);
        end else begin
          S:=TBisReportEditorForm(Sender).FileName;
          TBisReportEditorForm(Sender).SaveToFile(S);
          P2.Params.ParamByName('REPORT').Value:=S;
        end;
        P2.Execute;
      end;
    finally
      P2.Free;
      Stream.Free;
      P.EndUpdate();
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisDesignDataReportsFrame.EditorPreview(Sender: TObject);
var
  P: TBisProvider;
begin
  P:=GetCurrentProvider;
  if Assigned(P) and P.Active and not P.IsEmpty and
     Assigned(Sender) and (Sender is TBisReportEditorForm) then begin
    P.BeginUpdate(true);
    try
      if P.Locate('REPORT_ID',TBisReportEditorForm(Sender).ReportId,[]) then begin
        ReportShow;
      end;
    finally
      P.EndUpdate();
    end;
  end;
end;

procedure TBisDesignDataReportsFrame.ReportEdit;
var
  P: TBisProvider;
  AClass: TBisReportEditorFormIfaceClass;
  AEditor: TBisReportEditorFormIface;
  S: String;
  Stream: TMemoryStream;
  P2: TBisProvider;
  ACaption: String;
  AReportId: Variant;
begin
  if CanReportEdit then begin
    P:=GetCurrentProvider;
    if Assigned(P) and P.Active and not P.IsEmpty then begin
      AClass:=GetReportEditorClass;
      if Assigned(AClass) then begin
        Stream:=TMemoryStream.Create;
        P2:=TBisProvider.Create(nil);
        AEditor:=nil;
        try
          ACaption:=P.FieldByName('INTERFACE_NAME').AsString;
          AReportId:=P.FieldByName('REPORT_ID').Value;
          AEditor:=FEditors.FindByClass(AClass,ACaption);
          if not Assigned(AEditor) then begin
            AEditor:=AClass.Create(Self);
            FEditors.Add(AEditor);
            AEditor.Init;
          end;
          AEditor.ReportId:=AReportId;
          AEditor.Caption:=ACaption;
          AEditor.OnSaveChanges:=EditorSaveChanges;
          AEditor.OnPreview:=EditorPreview;
          P2.ProviderName:='S_REPORTS';
          P2.FieldNames.AddInvisible('REPORT');
          P2.FilterGroups.Add.Filters.Add('REPORT_ID',fcEqual,AReportId);
          P2.Open;
          if P2.Active and not P2.IsEmpty then begin
            if not Boolean(P.FieldByName('PLACE').AsInteger) then begin
              S:=P.FieldByName('INTERFACE_NAME').AsString;
              TBlobField(P2.FieldByName('REPORT')).SaveToStream(Stream);
            end else begin
              S:=VarToStrDef(P2.FieldByName('REPORT').AsString,'');
              if FileExists(S) then begin
                Stream.LoadFromFile(S);
              end;
            end;
            Stream.Position:=0;
            AEditor.FileName:=S;
            AEditor.Stream:=Stream;
            AEditor.ShowType:=ShowType;
            if not AsModal then
              AEditor.Show
            else AEditor.ShowModal;
          end;
        finally
          P2.Free;
          if Assigned(AEditor) then 
            AEditor.Stream:=nil;
          Stream.Free;
        end;
      end;
    end;
  end;
end;

function TBisDesignDataReportsFrame.CanReportShow: Boolean;
var
  P: TBisProvider;
  AClass: TBisReportFormIfaceClass;
begin
  P:=GetCurrentProvider;
  AClass:=GetReportClass;
  Result:=Assigned(P) and P.Active and not P.IsEmpty and Assigned(AClass);
  if Result and Assigned(FOnCanReportShow) then begin
    Result:=FOnCanReportShow(Self);
  end;
end;

procedure TBisDesignDataReportsFrame.ReportShow;
var
  P: TBisProvider;
  AClass: TBisReportFormIfaceClass;
  AReport: TBisReportFormIface;
  ACaption: String;
begin
  if CanReportShow then begin
    P:=GetCurrentProvider;
    if Assigned(P) and P.Active and not P.IsEmpty then begin
      AClass:=GetReportClass;
      if Assigned(AClass) then begin
        ACaption:=P.FieldByName('INTERFACE_NAME').AsString;
        AReport:=FReports.FindByClass(AClass,ACaption);
        if not Assigned(AReport) then begin
          AReport:=AClass.Create(Self);
          AReport.Permissions.Enabled:=false;
          FReports.Add(AReport);
          AReport.Init;
        end;
        AReport.Caption:=ACaption;
        AReport.ReportId:=P.FieldByName('REPORT_ID').Value;
        AReport.ShowType:=ShowType;
        if not AsModal then
          AReport.Show
        else AReport.ShowModal;
      end;
    end;
  end;
end;


end.
