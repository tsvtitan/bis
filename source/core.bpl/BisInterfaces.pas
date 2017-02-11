unit BisInterfaces;

interface

uses Classes,
     BisObject, BisCoreObjects, BisIfaceModules, BisIfaces, BisPermissions, BisFm,
     BisReportFm, BisDocumentFm, BisReportModules, BisScriptModules, BisScriptIface;

type
  TBisInterfaceType=(itInternal,itScript,itReport,itDocument);

  TBisInterface=class(TBisCoreObject)
  private
    FID: Variant;
    FAutoShow: Boolean;
    FInterfaceType: TBisInterfaceType;
    FPermissions: TBisPermissions;
    procedure IfaceBeforeFormShow(Sender: TObject);
  protected
    function GetIface: TBisIface; virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure IfaceCreate; virtual;
    procedure IfaceFree; virtual;
    procedure IfaceShow; virtual;
    procedure IfaceShowModal; virtual;
    procedure IfaceShowAsMainForm(First: Boolean); virtual;
    procedure IfaceHide; virtual;
    procedure IfaceOptions; virtual;
    procedure IfaceLoadOptions; virtual;
    procedure IfaceSaveOptions; virtual;

    procedure IfaceRefresh;
    function IfaceWorking: Boolean;

    property ID: Variant read FID write FID;
    property AutoShow: Boolean read FAutoShow write FAutoShow;
    property InterfaceType: TBisInterfaceType read FInterfaceType write FInterfaceType;

    property Iface: TBisIface read GetIface;
    property Permissions: TBisPermissions read FPermissions; 
  end;

  TBisInterfaceClass=class of TBisInterface;

  TBisInternalInterface=class(TBisInterface)
  private
    FIface: TBisIface;
    FModuleName: String;
    FModuleInterface: String;
    function GetModule: TBisIfaceModule;
  protected
    function GetIface: TBisIface; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure IfaceCreate; override;
    procedure IfaceFree; override;

    property Module: TBisIfaceModule read GetModule;
    property ModuleName: String read FModuleName write FModuleName;
    property ModuleInterface: String read FModuleInterface write FModuleInterface;
  end;

  TBisScriptPlace=(spDatabase,spFileSystem);

  TBisScriptInterface=class(TBisInterface)
  private
    FIface: TBisScriptIface;
    FEngine: String;
    FPlace: TBisScriptPlace;
    function GetModule: TBisScriptModule;
  protected
    function GetIface: TBisIface; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure IfaceCreate; override;
    procedure IfaceFree; override;

    property Module: TBisScriptModule read GetModule;
    property Engine: String read FEngine write FEngine;
    property Place: TBisScriptPlace read FPlace write FPlace;
  end;

  TBisReportPlace=(rpDatabase,rpFileSystem);

  TBisReportInterface=class(TBisInterface)
  private
    FIface: TBisReportFormIface;
    FEngine: String;
    FPlace: TBisReportPlace;
    function GetModule: TBisReportModule;
  protected
    function GetIface: TBisIface; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure IfaceCreate; override;
    procedure IfaceFree; override;

    property Module: TBisReportModule read GetModule;
    property Engine: String read FEngine write FEngine;
    property Place: TBisReportPlace read FPlace write FPlace;
  end;

  TBisDocumentPlace=(dpDatabase,dpFileSystem);

  TBisDocumentInterface=class(TBisInterface)
  private
    FIface: TBisDocumentFormIface;
    FOleClass: String;
    FPlace: TBisDocumentPlace;
  protected
    function GetIface: TBisIface; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure IfaceCreate; override;
    procedure IfaceFree; override;

    property OleClass: String read FOleClass write FOleClass;
    property Place: TBisDocumentPlace read FPlace write FPlace;
  end;

  TBisInterfaces=class(TBisCoreObjects)
  private
    function GetItems(Index: Integer): TBisInterface;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    function Add(ID: Variant; ObjectName: String; AClass: TBisInterfaceClass): TBisInterface; reintroduce;
    function AddInternal(ID: Variant; ObjectName: String; ModuleName, ModuleInterface: String): TBisInternalInterface;
    function AddScript(ID: Variant; ObjectName: String; Engine: String; Place: TBisScriptPlace): TBisScriptInterface;
    function AddReport(ID: Variant; ObjectName: String; Engine: String; Place: TBisReportPlace): TBisReportInterface;
    function AddDocument(ID: Variant; ObjectName: String; OleClass: String; Place: TBisDocumentPlace): TBisDocumentInterface;

    function FindByID(ID: Variant): TBisInterface;

    procedure IfacesCreate;
    procedure IfacesFree;
    procedure IfacesShow;
    procedure IfacesHide;
    procedure IfacesLoadOptions;
    procedure IfacesSaveOptions;
    procedure IfacesRefresh;


    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    property Items[Index: Integer]: TBisInterface read GetItems;
  end;

implementation

uses SysUtils, Variants, Forms,
     BisCore, BisUtils, BisDataSet, BisConsts, BisLogger, BisCoreUtils;

{ TBisInterface }

constructor TBisInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPermissions:=TBisPermissions.Create(Self);
end;

destructor TBisInterface.Destroy;
begin
  IfaceFree;
  FPermissions.Free;
  inherited Destroy;
end;

function TBisInterface.GetIface: TBisIface;
begin
  Result:=nil;
end;

procedure TBisInterface.IfaceShow;
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then
    AIface.Show;
end;

procedure TBisInterface.IfaceBeforeFormShow(Sender: TObject);
var
  AIface: TBisFormIface;
begin
  if Assigned(Sender) and (Sender is TBisFormIface) then begin
    AIface:=TBisFormIface(Sender);
    if Assigned(AIface.LastForm) and Assigned(Application) then begin
      if AIface.LastForm=Application.MainForm then begin
        //
      end else begin
        AIface.LastForm.CloseMode:=cmMinimize;
      end;
    end;
  end;
end;

procedure TBisInterface.IfaceShowAsMainForm(First: Boolean);
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then begin
    if AIface is TBisFormIface then begin
      TBisFormIface(AIface).OnBeforeShowForm:=IfaceBeforeFormShow;
      if First then
        TBisFormIface(AIface).ApplicationCreateForm:=true;
      TBisFormIface(AIface).Show;
    end else
      AIface.Show;
  end;
end;

procedure TBisInterface.IfaceShowModal;
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then begin
    if AIface is TBisFormIface then
      TBisFormIface(AIface).ShowModal
    else
      AIface.Show;
  end;
end;

function TBisInterface.IfaceWorking: Boolean;
var
  AIface: TBisIface;
begin
  Result:=false;
  AIface:=Iface;
  if Assigned(AIface) then
    Result:=AIface.Working;
end;

procedure TBisInterface.IfaceHide;
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then
    AIface.Hide;
end;

procedure TBisInterface.IfaceCreate;
begin
end;

procedure TBisInterface.IfaceFree;
begin
end;

procedure TBisInterface.IfaceOptions;
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then
    AIface.Options;
end;

procedure TBisInterface.IfaceRefresh;
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then begin
    AIface.Caption:=ObjectName;
    AIface.Description:=Description;
    AIface.Permissions.CopyFrom(FPermissions,false);
    TranslateObject(AIface,AIface.TranslateClass);
  end;
end;

procedure TBisInterface.IfaceSaveOptions;
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then
    AIface.SaveOptions;
end;

procedure TBisInterface.IfaceLoadOptions;
var
  AIface: TBisIface;
begin
  AIface:=Iface;
  if Assigned(AIface) then
    AIface.LoadOptions;
end;

{ TBisInternalInterface }

constructor TBisInternalInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIface:=nil;
end;

function TBisInternalInterface.GetIface: TBisIface;
begin
  Result:=FIface;
end;

function TBisInternalInterface.GetModule: TBisIfaceModule;
begin
  Result:=Core.IfaceModules.Find(FModuleName);
end;

procedure TBisInternalInterface.IfaceCreate;
var
  AModule: TBisIfaceModule;
  AClass: TBisIfaceClass;
begin
  if not Assigned(FIface) then begin
    AModule:=GetModule;
    if Assigned(AModule) then begin
      AClass:=AModule.Classes.Find(FModuleInterface);
      if Assigned(AClass) then begin
        FIface:=AClass.Create(Self);
        AModule.ReadIfaceDataParams(FIface);
        FIface.Init;
      end;
    end;
  end;
  IfaceRefresh;
end;

procedure TBisInternalInterface.IfaceFree;
begin
  FreeAndNilEx(FIface);
end;

{ TBisScriptInterface }

constructor TBisScriptInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIface:=nil;
end;

function TBisScriptInterface.GetIface: TBisIface;
begin
  Result:=FIface;
end;

function TBisScriptInterface.GetModule: TBisScriptModule;
begin
  Result:=Core.ScriptModules.Find(FEngine);
end;

procedure TBisScriptInterface.IfaceCreate;
var
  AModule: TBisScriptModule;
begin
  if not Assigned(FIface) then begin
    AModule:=GetModule;
    if Assigned(AModule) and Assigned(AModule.ScriptClass) then begin
      FIface:=AModule.ScriptClass.Create(Self);
      if Assigned(FIface) then begin
        FIface.ScriptId:=ID;
        FIface.Init;
      end;
    end;
  end;
  IfaceRefresh;
end;

procedure TBisScriptInterface.IfaceFree;
begin
  FreeAndNilEx(FIface);
end;

{ TBisReportInterface }

constructor TBisReportInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIface:=nil;
end;

function TBisReportInterface.GetIface: TBisIface;
begin
  Result:=FIface;
end;

function TBisReportInterface.GetModule: TBisReportModule;
begin
  Result:=Core.ReportModules.Find(FEngine);
end;

procedure TBisReportInterface.IfaceCreate;
var
  AModule: TBisReportModule;
begin
  if not Assigned(FIface) then begin
    AModule:=GetModule;
    if Assigned(AModule) and Assigned(AModule.ReportClass) then begin
      FIface:=AModule.ReportClass.Create(Self);
      if Assigned(FIface) then begin
        FIface.ReportId:=ID;
        FIface.Init;
      end;
    end;
  end;
  IfaceRefresh;
end;

procedure TBisReportInterface.IfaceFree;
begin
  FreeAndNilEx(FIface);
end;

{ TBisDocumentInterface }

constructor TBisDocumentInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIface:=nil;
end;

function TBisDocumentInterface.GetIface: TBisIface;
begin
  Result:=FIface;
end;

procedure TBisDocumentInterface.IfaceCreate;
begin
  if not Assigned(FIface) then begin
    FIface:=TBisDocumentFormIface.Create(Self);
    FIface.DocumentId:=ID;
    FIface.OleClass:=FOleClass;
    FIface.Init;
  end;
  IfaceRefresh;
end;

procedure TBisDocumentInterface.IfaceFree;
begin
  FreeAndNilEx(FIface);
end;

{ TBisInterfaces }

function TBisInterfaces.GetItems(Index: Integer): TBisInterface;
begin
  Result:=TBisInterface(inherited Items[Index]);
end;

function TBisInterfaces.GetObjectClass: TBisObjectClass;
begin
  Result:=nil;
end;

function TBisInterfaces.Add(ID: Variant; ObjectName: String; AClass: TBisInterfaceClass): TBisInterface;
begin
  Result:=FindByID(ID);
  if not Assigned(Result) then begin
    if Assigned(AClass) then begin
      Result:=AClass.Create(Self);
      Result.ID:=ID;
      Result.ObjectName:=ObjectName;
      AddObject(Result);
    end;
  end;
end;

function TBisInterfaces.AddInternal(ID: Variant; ObjectName, ModuleName, ModuleInterface: String): TBisInternalInterface;
begin
  Result:=TBisInternalInterface(Add(ID,ObjectName,TBisInternalInterface));
  if Assigned(Result) then begin
    Result.ModuleName:=ModuleName;
    Result.ModuleInterface:=ModuleInterface;
  end;
end;

function TBisInterfaces.AddScript(ID: Variant; ObjectName, Engine: String; Place: TBisScriptPlace): TBisScriptInterface;
begin
  Result:=TBisScriptInterface(Add(ID,ObjectName,TBisScriptInterface));
  if Assigned(Result) then begin
    Result.Engine:=Engine;
    Result.Place:=Place;
  end;
end;

function TBisInterfaces.AddReport(ID: Variant; ObjectName: String; Engine: String; Place: TBisReportPlace): TBisReportInterface;
begin
  Result:=TBisReportInterface(Add(ID,ObjectName,TBisReportInterface));
  if Assigned(Result) then begin
    Result.Engine:=Engine;
    Result.Place:=Place;
  end;
end;

function TBisInterfaces.AddDocument(ID: Variant; ObjectName, OleClass: String; Place: TBisDocumentPlace): TBisDocumentInterface;
begin
  Result:=TBisDocumentInterface(Add(ID,ObjectName,TBisDocumentInterface));
  if Assigned(Result) then begin
    Result.OleClass:=OleClass;
    Result.Place:=Place;
  end;
end;

function TBisInterfaces.FindByID(ID: Variant): TBisInterface;
var
  i: Integer;
  Item: TBisInterface;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if VarSameValue(Item.ID,ID) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

procedure TBisInterfaces.IfacesCreate;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    try
      Items[i].IfaceCreate;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisInterfaces.IfacesFree;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    try
      Items[i].IfaceFree;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisInterfaces.IfacesShow;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    try
      if Items[i].AutoShow then
        Items[i].IfaceShow;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisInterfaces.IfacesHide;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    try
      Items[i].IfaceHide;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisInterfaces.IfacesSaveOptions;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    try
      Items[i].IfaceSaveOptions;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisInterfaces.IfacesLoadOptions;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    try
      Items[i].IfaceLoadOptions;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisInterfaces.IfacesRefresh;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    try
      Items[i].IfaceRefresh;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisInterfaces.SaveToStream(Stream: TStream);
var
  Writer: TWriter;
  i,j,x: Integer;
  Item: TBisInterface;
  Perm: TBisPermission;
begin
  Writer:=TWriter.Create(Stream,WriterBufferSize);
  try
    Writer.WriteListBegin;
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      Writer.WriteVariant(Item.ID);
      Writer.WriteString(Item.ObjectName);
      Writer.WriteString(Item.Description);
      Writer.WriteBoolean(Item.AutoShow);
      Writer.WriteInteger(Integer(Item.InterfaceType));

      Writer.WriteListBegin;
      for j:=0 to Item.Permissions.Count-1 do begin
        Perm:=Item.Permissions.Items[j];
        Writer.WriteString(Perm.ObjectName);
        Writer.WriteListBegin;
        for x:=0 to Perm.Values.Count-1 do begin
          Writer.WriteString(Perm.Values[x]);
          Writer.WriteBoolean(Perm.Exists[x]);
        end;
        Writer.WriteListEnd;
      end;
      Writer.WriteListEnd;

      case Item.InterfaceType of
        itInternal: begin
          Writer.WriteString(TBisInternalInterface(Item).ModuleName);
          Writer.WriteString(TBisInternalInterface(Item).ModuleInterface);
        end;
        itScript: begin
          Writer.WriteString(TBisScriptInterface(Item).Engine);
          Writer.WriteInteger(Integer(TBisScriptInterface(Item).Place));
        end;
        itReport: begin
          Writer.WriteString(TBisReportInterface(Item).Engine);
          Writer.WriteInteger(Integer(TBisReportInterface(Item).Place));
        end;
        itDocument: begin
          Writer.WriteString(TBisDocumentInterface(Item).OleClass);
          Writer.WriteInteger(Integer(TBisDocumentInterface(Item).Place));
        end;
      end;
    end;
    Writer.WriteListEnd;
  finally
    Writer.Free;
  end;
end;

procedure TBisInterfaces.LoadFromStream(Stream: TStream);
var
  Reader: TReader;
  ID: Variant;
  AutoShow: Boolean;
  InterfaceType: TBisInterfaceType;
  ModuleName, ModuleInterface: String;
  ScriptEngine: String;
  ScriptPlace: TBisScriptPlace;
  ReportEngine: String;
  ReportPlace: TBisReportPlace;
  DocumentOleClass: String;
  DocumentPlace: TBisDocumentPlace;
  ObjectName, Description: String;
  Item: TBisInterface;
  Permissions: TBisPermissions;
  Perm: TBisPermission;
  PermName: String;
  PermValue: String;
  Index: Integer;
begin
  Reader:=TReader.Create(Stream,ReaderBufferSize);
  try
    Reader.ReadListBegin;
    while not Reader.EndOfList do begin

      Permissions:=TBisPermissions.Create(nil);
      try
        ID:=Reader.ReadVariant;
        ObjectName:=Reader.ReadString;
        Description:=Reader.ReadString;
        AutoShow:=Reader.ReadBoolean;
        InterfaceType:=TBisInterfaceType(Reader.ReadInteger);

        Reader.ReadListBegin;
        while not Reader.EndOfList do begin
          PermName:=Reader.ReadString;
          Perm:=Permissions.Add(PermName);
          if Assigned(Perm) then begin
            Reader.ReadListBegin;
            while not Reader.EndOfList do begin
              PermValue:=Reader.ReadString;
              Index:=Perm.Values.Add(PermValue);
              Perm.Exists[Index]:=Reader.ReadBoolean;
            end;
            Reader.ReadListEnd;
          end;
        end;
        Reader.ReadListEnd;

        Item:=FindByID(ID);
        case InterfaceType of
          itInternal: begin
            ModuleName:=Reader.ReadString;
            ModuleInterface:=Reader.ReadString;
            if not Assigned(Item) then
              Item:=AddInternal(ID,ObjectName,ModuleName,ModuleInterface);
          end;
          itScript: begin
            ScriptEngine:=Reader.ReadString;
            ScriptPlace:=TBisScriptPlace(Reader.ReadInteger);
            if not Assigned(Item) then
              Item:=AddScript(ID,ObjectName,ScriptEngine,ScriptPlace);
          end;
          itReport: begin
            ReportEngine:=Reader.ReadString;
            ReportPlace:=TBisReportPlace(Reader.ReadInteger);
            if not Assigned(Item) then
              Item:=AddReport(ID,ObjectName,ReportEngine,ReportPlace);
          end;
          itDocument: begin
            DocumentOleClass:=Reader.ReadString;
            DocumentPlace:=TBisDocumentPlace(Reader.ReadInteger);
            if not Assigned(Item) then
              Item:=AddDocument(ID,ObjectName,DocumentOleClass,DocumentPlace);
          end;
        end;
        if Assigned(Item) then begin
          Item.Description:=Description;
          Item.AutoShow:=AutoShow;
          Item.InterfaceType:=InterfaceType;
          Item.Permissions.CopyFrom(Permissions);
        end;
      finally
        Permissions.Free;
      end;
    end;
    Reader.ReadListEnd;
  finally
    Reader.Free;
  end;
end;

end.
