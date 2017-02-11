unit BisKrieltDataAdvertismentEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, GIFImg, ExtDlgs, ActiveX,
  ShockwaveFlashObjects_TLB, 
  BisDataEditFm, BisControls, BisParam, ImgList;

type
  TShockwaveFlash=class(ShockwaveFlashObjects_TLB.TShockwaveFlash)
  private
    FStreamSize: Int64;
    FOleObject: IOleObject;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FImageUrl: String;
  protected
    procedure InitControlInterface(const Obj: IUnknown); override;
  public
    procedure LoadFromStream(Stream: TStream);

    property StreamSize: Int64 read FStreamSize write FStreamSize;
    property ImageWidth: Integer read FImageWidth write FImageWidth;
    property ImageHeight: Integer read FImageHeight write FImageHeight;
    property ImageUrl: String read FImageUrl write FImageUrl; 
  end;

  TBisKrieltDataAdvertismentEditForm = class(TBisDataEditForm)
    LabelService: TLabel;
    EditService: TEdit;
    ButtonService: TButton;
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelLink: TLabel;
    EditLink: TEdit;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelLocation: TLabel;
    ComboBoxLocation: TComboBox;
    PageControlValue: TPageControl;
    TabSheetPath: TTabSheet;
    TabSheetText: TTabSheet;
    TabSheetBanner: TTabSheet;
    TabSheetFlash: TTabSheet;
    PanelBanner: TPanel;
    ShapeBanner: TShape;
    ImageBanner: TImage;
    PanelBannerEdit: TPanel;
    ButtonBannerLoad: TButton;
    ButtonBannerSave: TButton;
    ButtonBannerClear: TButton;
    ComboBoxBannerSize: TComboBox;
    OpenBannerDialog: TOpenPictureDialog;
    GroupBoxPath: TGroupBox;
    MemoPath: TMemo;
    SaveBannerDialog: TSavePictureDialog;
    GroupBoxText: TGroupBox;
    MemoText: TMemo;
    ShapeBannerFrame: TShape;
    LabelBannerInfo: TLabel;
    PanelFlashEdit: TPanel;
    LabelFlashInfo: TLabel;
    ButtonFlashLoad: TButton;
    ButtonFlashSave: TButton;
    ButtonFlashClear: TButton;
    ComboBoxFlashSize: TComboBox;
    OpenFlashDialog: TOpenDialog;
    SaveFlashDialog: TSaveDialog;
    PanelFlash: TPanel;
    ShapeFlashFrame: TShape;
    ShapeFlash: TShape;
    procedure ButtonBannerLoadClick(Sender: TObject);
    procedure ButtonBannerSaveClick(Sender: TObject);
    procedure ButtonBannerClearClick(Sender: TObject);
    procedure MemoPathKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemoTextKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBoxBannerSizeChange(Sender: TObject);
    procedure PanelBannerResize(Sender: TObject);
    procedure ButtonFlashLoadClick(Sender: TObject);
    procedure ComboBoxFlashSizeChange(Sender: TObject);
    procedure ButtonFlashSaveClick(Sender: TObject);
    procedure PanelFlashResize(Sender: TObject);
  private
    FChangeFlag: Boolean;
    FOldBannerInfo: String;
    FOldFlashInfo: String;
    FFlash: TShockwaveFlash;
    procedure VisibleTabSheet;
    procedure RepositionShapeBannerFrame;
    procedure RepositionShapeFlashFrame;
    function CheckBannerSizes(AWidth,AHeight,ASize: Integer): Boolean;
    function CheckFlashSizes(AWidth,AHeight,ASize: Integer): Boolean;
    procedure UpdateBannerInfo;
    procedure UpdateFlashInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
    function ChangesExists: Boolean; override;
    function CheckParam(Param: TBisParam): Boolean; override;
  end;

  TBisKrieltDataAdvertismentEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAdvertismentInsertFormIface=class(TBisKrieltDataAdvertismentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAdvertismentUpdateFormIface=class(TBisKrieltDataAdvertismentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAdvertismentDeleteFormIface=class(TBisKrieltDataAdvertismentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAdvertismentEditForm: TBisKrieltDataAdvertismentEditForm;

function GetAdvertismentTypeByIndex(Index: Integer): String;

implementation

{$R *.dfm}

uses Zlib,
     BisKrieltDataServicesFm,
     BisProvider, BisCore, BisInterfaces, BisIfaces, BisUtils, BisFilterGroups, BisPicture,
     BisDialogs;

function GetAdvertismentTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='����� (txt)';
    1: Result:='����� (jpg, gif)';
    2: Result:='���� (swf)';
  end;
end;

{ TShockwaveFlash }

procedure TShockwaveFlash.InitControlInterface(const Obj: IInterface);
begin
  FOleObject := Obj as IOleObject;
end;

procedure TShockwaveFlash.LoadFromStream(Stream: TStream);
var
  unCompress: TStream;
  Mem, Mem2: TMemoryStream;
  SRCSize: longint;
  PersistStream: IPersistStreamInit;
  SAdapt: TStreamAdapter;
  ISize: Int64;
  B: byte;
  ASign: array [0..2] of char;
  isCompress: boolean;
  ZStream: TDeCompressionStream;
begin
  FStreamSize:=Stream.Size;

  // prepare Stream movie
  Stream.Read(ASign, 3);
  isCompress := ASign = 'CWS';
  if isCompress then begin
    unCompress := TMemoryStream.Create;
    ASign := 'FWS';
    unCompress.Write(ASign, 3);
    unCompress.CopyFrom(Stream, 1); // version
    Stream.Read(SRCSize, 4);
    unCompress.Write(SRCSize, 4);
    ZStream := TDeCompressionStream.Create(Stream);
    try
      unCompress.CopyFrom(ZStream, SRCSize - 8);
    finally
      ZStream.free;
    end;

    unCompress.Position := 0;
  end else begin
    Stream.Position := Stream.Position - 3;
    SRCSize := Stream.Size - Stream.Position;
    unCompress := Stream;
  end;

  // store "template"
  EmbedMovie := false;
  FOleObject.QueryInterface(IPersistStreamInit, PersistStream);
  PersistStream.GetSizeMax(ISize);
  Mem := TMemoryStream.Create;
  Mem.SetSize(ISize);
  SAdapt := TStreamAdapter.Create(Mem);
  PersistStream.Save(SAdapt, true);
  SAdapt.Free;

  // insert movie to "template"
  Mem.Position := 1;
  Mem2 := TMemoryStream.Create;
  B := $66; // magic flag: "f" - embed swf; "g" - without swf;
  Mem2.Write(B, 1);
  Mem2.CopyFrom(Mem, 3);
  Mem2.Write(SRCSize, 4);
  Mem2.CopyFrom(unCompress, SRCSize);
  Mem2.CopyFrom(Mem, Mem.Size - Mem.Position);

  // load activeX data
  Mem2.Position := 0;
  SAdapt := TStreamAdapter.Create(Mem2);
  PersistStream.Load(SAdapt);
  SAdapt.Free;

  // free all
  Mem2.Free;
  Mem.Free;
  PersistStream := nil;
  if isCompress then unCompress.Free;

  FImageWidth:=Round(TGetPropertyAsNumber('/',8));
  FImageHeight:=Round(TGetPropertyAsNumber('/',9));
  FImageUrl:=TGetProperty('/',15)
end;

{ TBisKrieltDataAdvertismentEditFormIface }

constructor TBisKrieltDataAdvertismentEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAdvertismentEditForm;
  with Params do begin
    AddKey('ADVERTISMENT_ID').Older('OLD_ADVERTISMENT_ID');
    AddEditDataSelect('SERVICE_ID','EditService','LabelService','ButtonService',
                      TBisKrieltDataServicesFormIface,'SERVICE_NAME',true,false,'','NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddComboBox('ADVERTISMENT_TYPE','ComboBoxType','LabelType',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddComboBox('LOCATION','ComboBoxLocation','LabelLocation',true);
    AddEdit('LINK','EditLink','LabelLink',true);
    AddInvisible('VALUE').Required:=true;
  end;
end;

{ TBisKrieltDataAdvertismentInsertFormIface }

constructor TBisKrieltDataAdvertismentInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ADVERTISMENT';
end;

{ TBisKrieltDataAdvertismentUpdateFormIface }

constructor TBisKrieltDataAdvertismentUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ADVERTISMENT';
end;

{ TBisKrieltDataAdvertismentDeleteFormIface }

constructor TBisKrieltDataAdvertismentDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ADVERTISMENT';
end;


{ TBisKrieltDataAdvertismentEditForm }

constructor TBisKrieltDataAdvertismentEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  FFlash:=TShockwaveFlash.Create(Self);
  FFlash.Parent:=PanelFlash;
  FFlash.Visible:=false;

  ShapeFlash.Parent:=PanelFlash;
  ShapeFlashFrame.Parent:=PanelFlash;

  ComboBoxType.Clear;
  for i:=0 to 2 do begin
    ComboBoxType.Items.Add(GetAdvertismentTypeByIndex(i));
  end;
  FChangeFlag:=false;
  FOldBannerInfo:=LabelBannerInfo.Caption;
  FOldFlashInfo:=LabelFlashInfo.Caption;

  TabSheetPath.TabVisible:=false;
  TabSheetText.TabVisible:=false;
  TabSheetBanner.TabVisible:=false;
  TabSheetFlash.TabVisible:=false;

  RepositionShapeBannerFrame;
  RepositionShapeFlashFrame;
end;

destructor TBisKrieltDataAdvertismentEditForm.Destroy;
begin
///  FFlash.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataAdvertismentEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emDelete,emFilter] then begin
    GroupBoxPath.Enabled:=false;
    GroupBoxText.Enabled:=false;

    ButtonBannerLoad.Enabled:=false;
    ButtonBannerSave.Enabled:=false;
    ButtonBannerClear.Enabled:=false;
    ComboBoxBannerSize.Enabled:=false;

    ButtonFlashLoad.Enabled:=false;
    ButtonFlashSave.Enabled:=false;
    ButtonFlashClear.Enabled:=false;
    ComboBoxFlashSize.Enabled:=false;

    PageControlValue.Enabled:=false;
  end;

  FFlash.HandleNeeded;
end;

function TBisKrieltDataAdvertismentEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists;
end;

procedure TBisKrieltDataAdvertismentEditForm.VisibleTabSheet;
var
  Stream: TMemoryStream;
//  Param: TBisParam;
begin
  case PageControlValue.ActivePageIndex of
    0: begin
      MemoPath.Lines.Text:=VarToStrDef(Provider.Params.ParamByName('VALUE').Value,'');
      TabSheetPath.Visible:=true;
    end;
    1: begin
      MemoText.Lines.Text:=VarToStrDef(Provider.Params.ParamByName('VALUE').Value,'');
      TabSheetText.Visible:=true;
    end;
    2: begin
      Stream:=TMemoryStream.Create;
      try
        Provider.Params.ParamByName('VALUE').SaveToStream(Stream);
        Stream.Position:=0;
        ImageBanner.Picture.Assign(nil);
        if Stream.Size>0 then begin
          try
            TBisPicture(ImageBanner.Picture).LoadFromStream(Stream);
          except
          end;
        end;
        UpdateBannerInfo;
        RepositionShapeBannerFrame;
        TabSheetBanner.Visible:=true;
      finally
        Stream.Free;
      end;
    end;
    3: begin
      Stream:=TMemoryStream.Create;
      try
        Provider.Params.ParamByName('VALUE').SaveToStream(Stream);
        Stream.Position:=0;
        FFlash.Stop;
        FFlash.EmbedMovie:=true;
        if Stream.Size>0 then begin
          try
            FFlash.LoadFromStream(Stream);
            FFlash.Width:=FFlash.ImageWidth;
            FFlash.Height:=FFlash.ImageHeight;
            FFlash.DoObjectVerb(OLEIVERB_PRIMARY);
            FFlash.Stop;
            FFlash.ScaleMode:=3;
            FFlash.Loop:=true;
            FFlash.Rewind;
            FFlash.Play;

         {   Param:=Provider.Params.ParamByName('LINK');
            if Param.Empty then
              Param.Value:=FFlash.ImageUrl;  }
          except
          end;
        end;
        UpdateFlashInfo;
        RepositionShapeFlashFrame;
        TabSheetFlash.Visible:=true;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

procedure TBisKrieltDataAdvertismentEditForm.ChangeParam(Param: TBisParam);
var
  P: TBisProvider;
  Param2: TBisParam;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'ADVERTISMENT_ID') and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_ADVERTISMENTS';
      P.FieldNames.AddInvisible('VALUE');
      P.FilterGroups.Add.Filters.Add('ADVERTISMENT_ID',fcEqual,Param.Value);
      P.Open;
      if P.Active and not P.IsEmpty then
        Provider.Params.ParamByName('VALUE').SetNewValue(P.FieldByName('VALUE').Value);
    finally
      P.Free;
    end;
  end;

  if AnsiSameText(Param.ParamName,'ADVERTISMENT_TYPE') and not Param.Empty then begin
    Param2:=Provider.Params.ParamByName('LOCATION');
    if not Param2.Empty then
      PageControlValue.ActivePageIndex:=iff(Param2.Value=0,Param.Value+1,0)
    else
      PageControlValue.ActivePageIndex:=-1;

    if PageControlValue.ActivePageIndex<>-1 then
      VisibleTabSheet;
  end;

  if AnsiSameText(Param.ParamName,'LOCATION') and not Param.Empty then begin
    Param2:=Provider.Params.ParamByName('ADVERTISMENT_TYPE');
    if not Param2.Empty then
      PageControlValue.ActivePageIndex:=iff(Param.Value=0,Param2.Value+1,0)
    else PageControlValue.ActivePageIndex:=-1;

    if PageControlValue.ActivePageIndex<>-1 then
      VisibleTabSheet;
  end;

  if AnsiSameText(Param.ParamName,'VALUE') then begin

    if not (Mode in [emDelete,emFilter]) then begin
      ButtonBannerSave.Enabled:=not Param.Empty;
      ButtonBannerClear.Enabled:=ButtonBannerSave.Enabled;
      ComboBoxBannerSize.Enabled:=ButtonBannerSave.Enabled;
      ImageBanner.Visible:=ButtonBannerSave.Enabled;

      ButtonFlashSave.Enabled:=not Param.Empty;
      ButtonFlashClear.Enabled:=ButtonFlashSave.Enabled;
      ComboBoxFlashSize.Enabled:=ButtonFlashSave.Enabled;
      FFlash.Visible:=ButtonFlashSave.Enabled;
    end;

    VisibleTabSheet;
  end;

end;

procedure TBisKrieltDataAdvertismentEditForm.ButtonFlashLoadClick(Sender: TObject);
begin
  if OpenFlashDialog.Execute then
    Provider.Params.ParamByName('VALUE').LoadFromFile(OpenFlashDialog.FileName);
end;

procedure TBisKrieltDataAdvertismentEditForm.ButtonFlashSaveClick(
  Sender: TObject);
begin
  if SaveFlashDialog.Execute then
    Provider.Params.ParamByName('VALUE').SaveToFile(SaveFlashDialog.FileName);
end;

procedure TBisKrieltDataAdvertismentEditForm.ButtonBannerClearClick(
  Sender: TObject);
begin
  Provider.Params.ParamByName('VALUE').Clear;
end;

procedure TBisKrieltDataAdvertismentEditForm.ButtonBannerLoadClick(
  Sender: TObject);
begin
  if OpenBannerDialog.Execute then
    Provider.Params.ParamByName('VALUE').LoadFromFile(OpenBannerDialog.FileName);
end;


procedure TBisKrieltDataAdvertismentEditForm.ButtonBannerSaveClick(
  Sender: TObject);
begin
  if SaveBannerDialog.Execute then
    Provider.Params.ParamByName('VALUE').SaveToFile(SaveBannerDialog.FileName);
end;

procedure TBisKrieltDataAdvertismentEditForm.MemoPathKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Provider.Params.ParamByName('VALUE').Value:=TMemo(Sender).Lines.Text;
end;

procedure TBisKrieltDataAdvertismentEditForm.MemoTextKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  MemoPathKeyUp(Sender,Key,Shift);
end;

procedure TBisKrieltDataAdvertismentEditForm.PanelBannerResize(
  Sender: TObject);
begin
  RepositionShapeBannerFrame;
end;

procedure TBisKrieltDataAdvertismentEditForm.PanelFlashResize(Sender: TObject);
begin
  RepositionShapeFlashFrame;
end;

function TBisKrieltDataAdvertismentEditForm.CheckParam(Param: TBisParam): Boolean;
var
  ACaption: String;
  AControl: TWinControl;
begin
  Result:=inherited CheckParam(Param);
  if AnsiSameText(Param.ParamName,'VALUE') then begin
    if Param.Empty then begin
      ACaption:='';
      AControl:=nil;
      case PageControlValue.ActivePageIndex of
        0: begin
          ACaption:='����';
          AControl:=MemoPath;
        end;
        1: begin
          ACaption:='�����';
          AControl:=MemoText;
        end;
        2: begin
          ACaption:='������';
          AControl:=ButtonBannerLoad;
        end;
        3: begin
          ACaption:='����';
          AControl:=nil;
        end;
      end;
      if Trim(ACaption)<>'' then begin
        ShowError(Format(SNeedControlValue,[ACaption]));
        if Assigned(AControl) and AControl.CanFocus then
          AControl.SetFocus;
        Result:=false;
      end;
    end;
  end;
end;

procedure TBisKrieltDataAdvertismentEditForm.ComboBoxBannerSizeChange(
  Sender: TObject);
begin
  UpdateBannerInfo;
  RepositionShapeBannerFrame;
end;

procedure TBisKrieltDataAdvertismentEditForm.ComboBoxFlashSizeChange(
  Sender: TObject);
begin
  UpdateFlashInfo;
  RepositionShapeFlashFrame;
end;

procedure TBisKrieltDataAdvertismentEditForm.RepositionShapeFlashFrame;
begin
  ShapeFlashFrame.Align:=alNone;
  case ComboBoxFlashSize.ItemIndex of
    0: begin
      ShapeFlashFrame.Width:=202;
      ShapeFlashFrame.Height:=62;
    end;
    1: begin
      ShapeFlashFrame.Width:=242;
      ShapeFlashFrame.Height:=402;
    end;
  end;
  ShapeFlashFrame.Left:=ShapeFlash.Width div 2 - ShapeFlashFrame.Width div 2;
  ShapeFlashFrame.Top:=ShapeFlash.Height div 2 - ShapeFlashFrame.Height div 2;
  FFlash.Left:=PanelFlash.Width div 2 - FFlash.Width div 2;
  FFlash.Top:=PanelFlash.Height div 2 - FFlash.Height div 2;
  PanelFlash.Visible:=false;
  PanelFlash.Visible:=true;
  FFlash.UpdateRecreatingFlag(false);
end;

procedure TBisKrieltDataAdvertismentEditForm.RepositionShapeBannerFrame;
begin
  ShapeBannerFrame.Align:=alNone;
  case ComboBoxBannerSize.ItemIndex of
    0: begin
      ShapeBannerFrame.Width:=202;
      ShapeBannerFrame.Height:=62;
    end;
    1: begin
      ShapeBannerFrame.Width:=242;
      ShapeBannerFrame.Height:=402;
    end;
  end;
  ShapeBannerFrame.Left:=ShapeBanner.Width div 2 - ShapeBannerFrame.Width div 2;
  ShapeBannerFrame.Top:=ShapeBanner.Height div 2 - ShapeBannerFrame.Height div 2;
  ImageBanner.Left:=PanelBanner.Width div 2 - ImageBanner.Width div 2;
  ImageBanner.Top:=PanelBanner.Height div 2 - ImageBanner.Height div 2;
  PanelBanner.Visible:=false;
  PanelBanner.Visible:=true;
end;

function TBisKrieltDataAdvertismentEditForm.CheckFlashSizes(AWidth,AHeight,ASize: Integer): Boolean;
begin
  Result:=false;
  case ComboBoxFlashSize.ItemIndex of
    0: Result:=(AWidth<=200) and (AHeight<=60) and (ASize/1024<=15);
    1: Result:=(AWidth<=240) and (AHeight<=400) and (ASize/1024<=30);
  end;
end;

function TBisKrieltDataAdvertismentEditForm.CheckBannerSizes(AWidth,AHeight,ASize: Integer): Boolean;
begin
  Result:=false;
  case ComboBoxBannerSize.ItemIndex of
    0: Result:=(AWidth<=200) and (AHeight<=60) and (ASize/1024<=15);
    1: Result:=(AWidth<=240) and (AHeight<=400) and (ASize/1024<=30);
  end;
end;

procedure TBisKrieltDataAdvertismentEditForm.UpdateFlashInfo;
var
  S: String;
  AWidth,AHeight,ASize: Integer;
begin
  if FFlash.Visible then begin
    AWidth:=FFlash.ImageWidth;
    AHeight:=FFlash.ImageHeight;
    ASize:=FFlash.StreamSize;
  end else begin
    AWidth:=0;
    AHeight:=0;
    ASize:=0;
  end;

  if (AWidth>0) and (AHeight>0) and (ASize>0) then begin
    S:=Format('%s %d x %d, %d Kb',[FOldFlashInfo,AWidth,AHeight,Round(ASize/1024)]);
  end else S:=FOldFlashInfo;
  LabelFlashInfo.Caption:=S;
  LabelFlashInfo.Font.Color:=iff(CheckFlashSizes(AWidth,AHeight,ASize),clWindowText,clRed);
  LabelFlashInfo.Update;
end;

procedure TBisKrieltDataAdvertismentEditForm.UpdateBannerInfo;
var
  S: String;
  AWidth,AHeight,ASize: Integer;
  Stream: TMemoryStream;
begin
  if ImageBanner.Visible then begin
    AWidth:=TBisPicture(ImageBanner.Picture).Width;
    AHeight:=TBisPicture(ImageBanner.Picture).Height;
    ASize:=0;
    if not TBisPicture(ImageBanner.Picture).Empty then begin
      Stream:=TMemoryStream.Create;
      try
        TBisPicture(ImageBanner.Picture).SaveToStream(Stream);
        ASize:=Stream.Size;
      finally
        Stream.Free;
      end;
    end;
  end else begin
    AWidth:=0;
    AHeight:=0;
    ASize:=0;
  end;

  if (AWidth>0) and (AHeight>0) and (ASize>0) then begin
    S:=Format('%s %d x %d, %d Kb',[FOldBannerInfo,AWidth,AHeight,Round(ASize/1024)]);
  end else S:=FOldBannerInfo;
  LabelBannerInfo.Caption:=S;
  LabelBannerInfo.Font.Color:=iff(CheckBannerSizes(AWidth,AHeight,ASize),clWindowText,clRed);
  LabelBannerInfo.Update;
end;

end.
