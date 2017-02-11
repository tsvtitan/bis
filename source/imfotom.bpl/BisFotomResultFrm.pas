unit BisFotomResultFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  StdCtrls, ExtCtrls, Grids, DBGrids,
  AbArcTyp,
  BisDataGridFrm, BisDataEditFm,
  BisFotomMainFmIntf;

type

  TBisFotomResultFrame = class(TBisDataGridFrame)
    ActionSend: TAction;
    ToolBarFunction: TToolBar;
    ToolButtonSend: TToolButton;
    N13: TMenuItem;
    N15: TMenuItem;
    procedure ActionSendExecute(Sender: TObject);
    procedure ActionSendUpdate(Sender: TObject);
  private
    FOldDeleteShortCut: TShortCut;
    FOldViewShortCut: TShortCut;
    FMainForm: IBisFotomMainForm;
    procedure GridEnter(Sender: TObject);
    procedure GridExit(Sender: TObject);
    procedure ActionViewingUpdate(Sender: TObject);

    procedure ZipFromStreamProc(Sender : TObject; Item : TAbArchiveItem; OutStream, InStream : TStream );

  protected
    function CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure OpenRecords; override;
    function CanExportRecords: Boolean; override;
    procedure ExportRecords; override;
    function CanViewRecord: Boolean; override;
    procedure DoUpdateCounters; override;

    function CanSendRecords: Boolean;
    procedure SendRecords;

    property MainForm: IBisFotomMainForm read FMainForm write FMainForm;
  end;

  TBisFotomResultFrameDeleteIface=class(TBisDataEditFormIface)
  private
    FMainForm: IBisFotomMainForm;
  public
    procedure Execute; override;

    property MainForm: IBisFotomMainForm read FMainForm write FMainForm;
  end;

  TBisFotomResultFrameViewingIface=class(TBisDataEditFormIface)
  private
    FOutputDir: String;
  public
    procedure Execute; override;

    property OutputDir: String read FOutputDir write FOutputDir;
  end;


implementation

uses ShellApi,
     AbZipTyp, AbZipPrc,
     BisDialogs, BisConsts, {BisXmlDocument, }BisCore, BisLogger, BisUtils,
     BisFotomConsts, BisFotomImagePreviewFm, BisFotomSendFm;

{$R *.dfm}

{ TBisFotomResultFrameDeleteIface}

procedure TBisFotomResultFrameDeleteIface.Execute;
var
  FileName: String;
begin
  if Assigned(ParentProvider) and
     ParentProvider.Active and not ParentProvider.IsEmpty and
     (ShowQuestion('Удалить текущую запись?')=mrYes) then begin

    FileName:=ParentProvider.FieldByName(SFieldFileName).AsString;
    FileName:=Format('%s%s%s',[FMainForm.OutputDir,PathDelim,FileName]);
    if FileExists(FileName) then
      DeleteFile(FileName);

    FMainForm.DisableScrolled:=true;
    try
      ParentProvider.Delete;
    finally
      FMainForm.DisableScrolled:=false;
    end;

    FMainForm.ResultFrameProviderAfterScroll(nil);
    FMainForm.ChangesPresent:=true;
  end;
end;

{ TBisFotomResultFrameViewingIface }

procedure TBisFotomResultFrameViewingIface.Execute;
var
  FileName: String;
  AForm: TBisFotomImagePreviewForm;
begin
  if Assigned(ParentProvider) and
     ParentProvider.Active and not ParentProvider.IsEmpty then begin
    FileName:=ParentProvider.FieldByName(SFieldFileName).AsString;
    FileName:=Format('%s%s%s',[FOutputDir,PathDelim,FileName]);
    if FileExists(FileName) then begin
      AForm:=TBisFotomImagePreviewForm.Create(nil);
      try
        AForm.Image.Picture.LoadFromFile(FileName);
        AForm.ShowModal;
      finally
        AForm.Free;
      end;
    end;
  end;
end;

{ TBisFotomResultFrame }

constructor TBisFotomResultFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DeleteClass:=TBisFotomResultFrameDeleteIface;
  ViewClass:=TBisFotomResultFrameViewingIface;
  LabelCounter.Visible:=true;
  ActionRefresh.Enabled:=false;
  ActionRefresh.Visible:=false;
  ActionFilter.Visible:=false;
  ToolBarRefresh.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionUpdate.Visible:=false;
  Grid.NumberVisible:=false;
  Grid.ChessVisible:=true;
  Grid.AutoResizeableColumns:=false;
  Grid.SearchEnabled:=true;
  Grid.OnEnter:=GridEnter;
  Grid.OnExit:=GridExit;


  ActionExport.Caption:='Сохранить';
  ActionExport.ShortCut:=TextToShortCut('Ctrl+S');
  ActionExport.Hint:=ActionExport.Caption;
  ToolButtonExport.Style:=tbsButton;
  ToolButtonExport.Width:=ToolButtonDelete.Width;
  FOldViewShortCut:=ActionUpdate.ShortCut;
  ActionUpdate.ShortCut:=0;
  ActionView.OnUpdate:=ActionViewingUpdate;
  FOldDeleteShortCut:=ActionDelete.ShortCut;
  ActionDelete.ShortCut:=0;
end;

destructor TBisFotomResultFrame.Destroy;
begin
  inherited Destroy;
end;

procedure TBisFotomResultFrame.DoUpdateCounters;
begin
  inherited DoUpdateCounters;
end;

function TBisFotomResultFrame.CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface;
begin
  Result:=inherited CreateIface(AClass);
  if Assigned(Result) then begin
    if Result is TBisFotomResultFrameDeleteIface then
      TBisFotomResultFrameDeleteIface(Result).MainForm:=FMainForm;
    if Result is TBisFotomResultFrameViewingIface then
      TBisFotomResultFrameViewingIface(Result).OutputDir:=FMainForm.OutputDir;
  end;
end;

procedure TBisFotomResultFrame.GridEnter(Sender: TObject);
begin
  ActionDelete.ShortCut:=FOldDeleteShortCut;
  ActionView.ShortCut:=FOldViewShortCut;
end;

procedure TBisFotomResultFrame.GridExit(Sender: TObject);
begin
  ActionDelete.ShortCut:=0;
  ActionView.ShortCut:=0;
end;

procedure TBisFotomResultFrame.Init;
begin
  inherited Init;

end;

procedure TBisFotomResultFrame.OpenRecords;
begin
  // Nothing
end;

procedure TBisFotomResultFrame.ActionSendExecute(Sender: TObject);
begin
  SendRecords;
end;

procedure TBisFotomResultFrame.ActionSendUpdate(Sender: TObject);
begin
  ActionSend.Enabled:=CanSendRecords;
end;

procedure TBisFotomResultFrame.ActionViewingUpdate(Sender: TObject);
begin
end;

function TBisFotomResultFrame.CanExportRecords: Boolean;
begin
  Result:=Provider.Active and
          (Trim(FMainForm.OutputFile)<>'');
end;

procedure TBisFotomResultFrame.ExportRecords;
{var
  Xml: TBisXmlDocument;
  Node, NodeData, NodeItem: TBisXmlDocumentNode;
  OldCursor: TCursor;}
begin
  if CanExportRecords then begin
{    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    Provider.BeginUpdate(true);
    Xml:=TBisXmlDocument.Create(nil);
    try
      try
        NodeData:=Xml.Nodes.AddNode(FMainForm.DataTag);

        Provider.First;
        while not Provider.Eof do begin

          NodeItem:=NodeData.ChildNodes.AddNode(FMainForm.RowTag);

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.DateCreateTag);
          Node.NodeValue:=FormatDateTime(FMainForm.DateCreateFormat,Provider.FieldByName(SFieldDateCreate).Value);

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.UploadTag);
          Node.NodeValue:=Provider.FieldByName(SFieldUpload).Value;

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.BarcodeTag);
          Node.NodeValue:=Provider.FieldByName(SFieldBarcode).Value;

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.CodeTag);
          Node.NodeValue:=Provider.FieldByName(SFieldCode).Value;

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.NameTag);
          Node.NodeValue:=Provider.FieldByName(SFieldName).Value;

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.ProducerTag);
          Node.NodeValue:=Provider.FieldByName(SFieldProducer).Value;

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.CountryTag);
          Node.NodeValue:=Provider.FieldByName(SFieldCountry).Value;

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.OwnerTag);
          Node.NodeValue:=Provider.FieldByName(SFieldOwner).Value;

          Node:=NodeItem.ChildNodes.AddNode(FMainForm.FileNameTag);
          Node.NodeValue:=Provider.FieldByName(SFieldFileName).Value;

          Provider.Next;
        end;

        Xml.SaveToFile(FMainForm.OutputFile);

        FMainForm.ChangesPresent:=false;

      except
        on E: Exception do
          Core.Logger.Write(E.Message,ltError);
      end;

    finally
      Xml.Free;
      Provider.EndUpdate;
      Screen.Cursor:=OldCursor;
    end;}
  end;
end;

function TBisFotomResultFrame.CanViewRecord: Boolean;
var
  Filename: String;
begin
  Result:=inherited CanViewRecord;
  if Result and Provider.Active and not Provider.IsEmpty then begin
    FileName:=Provider.FieldByName(SFieldFileName).AsString;
    FileName:=Format('%s%s%s',[FMainForm.OutputDir,PathDelim,FileName]);
    Result:=FileExists(FileName);
  end;
end;

function TBisFotomResultFrame.CanSendRecords: Boolean;
begin
  Result:=Provider.Active and not Provider.IsEmpty; 
end;

procedure TBisFotomResultFrame.ZipFromStreamProc(Sender : TObject; Item : TAbArchiveItem; OutStream, InStream : TStream);
begin
  AbZipFromStream(TAbZipArchive(Sender), TAbZipItem(Item), OutStream, InStream)
end;

procedure TBisFotomResultFrame.SendRecords;

  function SendRecordExists: Boolean;
  begin
    Provider.BeginUpdate(true);
    try
      Provider.Filter:=FormatEx('%s=0',[SFieldUpload]);
      Provider.Filtered:=true;
      Result:=Provider.RecordCount>0;
    finally
      Provider.EndUpdate;
    end;
  end;

(*  procedure AddNode(NodeItem: TBisXmlDocumentNode);
  var
    Node: TBisXmlDocumentNode;
  begin
    Node:=NodeItem.ChildNodes.AddNode(FMainForm.DateCreateTag);
    Node.NodeValue:=FormatDateTime(FMainForm.DateCreateFormat,Provider.FieldByName(SFieldDateCreate).Value);

{    Node:=NodeItem.ChildNodes.AddNode(FMainForm.UploadTag);
    Node.NodeValue:=Provider.FieldByName(SFieldUpload).Value;}

    Node:=NodeItem.ChildNodes.AddNode(FMainForm.BarcodeTag);
    Node.NodeValue:=Provider.FieldByName(SFieldBarcode).Value;

    Node:=NodeItem.ChildNodes.AddNode(FMainForm.CodeTag);
    Node.NodeValue:=Provider.FieldByName(SFieldCode).Value;

    Node:=NodeItem.ChildNodes.AddNode(FMainForm.NameTag);
    Node.NodeValue:=Provider.FieldByName(SFieldName).Value;

    Node:=NodeItem.ChildNodes.AddNode(FMainForm.ProducerTag);
    Node.NodeValue:=Provider.FieldByName(SFieldProducer).Value;

    Node:=NodeItem.ChildNodes.AddNode(FMainForm.CountryTag);
    Node.NodeValue:=Provider.FieldByName(SFieldCountry).Value;

    Node:=NodeItem.ChildNodes.AddNode(FMainForm.OwnerTag);
    Node.NodeValue:=Provider.FieldByName(SFieldOwner).Value;

    Node:=NodeItem.ChildNodes.AddNode(FMainForm.FileNameTag);
    Node.NodeValue:=Provider.FieldByName(SFieldFileName).Value;
  end;*)

{  procedure FillSends(Sends: TBisFotomSends);
  var
    FileName: String;
    Uploaded: Boolean;
    Strings: TStringList;
    Item: TBisFotomSend;
    Source: TMemoryStream;
    Xml: TBisXmlDocument;
    NodeData, NodeItem: TBisXmlDocumentNode;
    Zip: TAbZipArchive;
    FileStream: TFileStream;
    XmlStream: TMemoryStream;
    ArchiveName: String;
    OldCursor: TCursor;
  begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;

    ArchiveName:=GetUniqueID+'.zip';

    Provider.BeginUpdate(true);
    Strings:=TStringList.Create;
    Source:=TMemoryStream.Create;
    Xml:=TBisXmlDocument.Create(nil);
    Zip:=TAbZipArchive.CreateFromStream(Source,ArchiveName);
    try
      NodeData:=Xml.Nodes.AddNode(FMainForm.DataTag);

      Zip.CompressionMethodToUse:=smDeflated;
      Zip.DeflationOption:=doNormal;
      
      Zip.InsertFromStreamHelper:=ZipFromStreamProc;

      Provider.First;
      while not Provider.Eof do begin
        Uploaded:=Boolean(Provider.FieldByName(SFieldUpload).AsInteger);
        if not Uploaded then begin
          FileName:=Provider.FieldByName(SFieldFileName).AsString;
          FileName:=Format('%s%s%s',[FMainForm.OutputDir,PathDelim,FileName]);
          if FileExists(FileName) then begin
            Strings.Add(Provider.FieldByName(SFieldID).AsString);
            NodeItem:=NodeData.ChildNodes.AddNode(FMainForm.RowTag);
            AddNode(NodeItem);
            FileStream:=TFileStream.Create(FileName,fmOpenRead);
            try
              FileStream.Position:=0;
              Zip.AddFromStream(ExtractFileName(FileName),FileStream);
            finally
              FileStream.Free;
            end;
          end;
          if (Strings.Count=FMainForm.PhotoCount) then begin

            XmlStream:=TMemoryStream.Create;
            try
              Xml.SaveToStream(XmlStream);
              XmlStream.Position:=0;
              Zip.AddFromStream(ExtractFileName(FMainForm.OutputFile),XmlStream);
            finally
              XmlStream.Free;
            end;

            Zip.Save;
            Source.Position:=0;

            Item:=Sends.Add(Source);
            Item.IDs.Assign(Strings);
            Item.FileName:=ArchiveName;

            Strings.Clear;
            Source.Clear;
            Xml.Clear;
            Zip.ItemList.Clear;

            NodeData:=Xml.Nodes.AddNode(FMainForm.DataTag);

          end;
        end;
        Provider.Next;
      end;

      if Strings.Count>0 then begin

        XmlStream:=TMemoryStream.Create;
        try
          Xml.SaveToStream(XmlStream);
          XmlStream.Position:=0;
          Zip.AddFromStream(ExtractFileName(FMainForm.OutputFile),XmlStream);
        finally
          XmlStream.Free;
        end;

        Zip.Save;
        Source.Position:=0;

        Item:=Sends.Add(Source);
        Item.IDs.Assign(Strings);
        Item.FileName:=ArchiveName;

      end;

    finally
      Zip.Free;
      Xml.Free;
      Source.Free;
      Strings.Free;
      Provider.EndUpdate;
      Screen.Cursor:=OldCursor;
    end;
  end;}

  procedure UpdateSends(Sends: TBisFotomSends; IsDelete: Boolean);
  var
    i,j: Integer;
    Item: TBisFotomSend;
    FileName: String;
  begin
    Provider.BeginUpdate(true);
    try
      for i:=0 to Sends.Count-1 do begin
        Item:=Sends.Items[i];
        if Item.Sended then begin
          for j:=0 to Item.IDs.Count-1 do begin
            Provider.First;
            if Provider.Locate(SFieldID,Item.IDs[j],[]) then begin
              if isDelete then begin
                FileName:=Provider.FieldByName(SFieldFileName).AsString;
                FileName:=Format('%s%s%s',[FMainForm.OutputDir,PathDelim,FileName]);
                DeleteFile(FileName);
                Provider.Delete;
              end else begin
                Provider.Edit;
                Provider.FieldByName(SFieldUpload).AsInteger:=Integer(True);
                Provider.Post;
                Grid.Synchronize;
              end;
            end;
          end;
        end;
      end;
    finally
      Provider.EndUpdate();
    end;
  end;

var
  AForm: TBisFotomSendForm;
  S: String;
  Ret: Integer;
  IsDelete: Boolean;
begin
  if CanSendRecords and SendRecordExists then begin
    AForm:=TBisFotomSendForm.Create(nil);
    try
      AForm.MainForm:=FMainForm;
//      FillSends(AForm.Sends);

      S:=AForm.Send;

      FMainForm.UpdateForm;
      
      if AnsiSameText(S,FMainForm.SuccessString) then begin
        ShowInfo(S);
      end else ShowError(S);

      IsDelete:=false;
      if FMainForm.DeleteAfterLoad then begin
        Ret:=ShowQuestion('Удалить загруженные фотографии?',mbNo);
        IsDelete:=Ret=mrYes;
      end;
      UpdateSends(AForm.Sends,IsDelete);
      FMainForm.ChangesPresent:=true;
      ExportRecords;
      
      if FMainForm.RunAfterLoad and (Trim(FMainForm.ShellCommand)<>'') then begin
        Ret:=ShowQuestion('Показать результат загрузки?');
        if Ret=mrYes then begin
          ShellExecute(Handle,'open',PChar(FMainForm.ShellCommand),nil,nil,SW_SHOW);
        end;
      end;
      
    finally
      AForm.Free;
    end;
  end;
end;


end.
