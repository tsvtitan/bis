unit BisHttpServerHandlerMessageWm;

interface

uses
  SysUtils, Classes, HTTPApp, DB, Contnrs,
  BisHttpServerHandlers;

type

  TBisHttpServerHandlerMessageWebModuleFormat=(mfRaw,mfXml);

  TBisHttpServerHandlerMessageWebModule = class(TWebModule)
    procedure BisHttpServerHandlerUpdateWebModuleUpdateAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerUpdateWebModuleXmlAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    FHandler: TBisHttpServerHandler;

    function Execute(Request: TWebRequest; Response: TWebResponse;
                     StreamFormat: TBisHttpServerHandlerMessageWebModuleFormat): Boolean;
  public
    property Handler: TBisHttpServerHandler read FHandler write FHandler;
  end;

var
  BisHttpServerHandlerMessageWebModule: TBisHttpServerHandlerMessageWebModule;

implementation

{$R *.dfm}

uses Windows, Variants, StrUtils,
     AlXmlDoc,
     BisConsts, BisUtils, BisProvider, BisCore, BisFilterGroups,
     BisLogger, BisParams,
     BisHttpServerHandlerMessageConsts;

type
  TBisMessagePacketItemStatus=(pisError,pisQueue,pisSent,pisInvalidBalance);

  TBisMessagePacketItem=class(TObject)
  private
    FId: Variant;
    FInfo: String;
    FType: Integer;
    FContact: String;
    FDateBegin: TDateTime;
    FDateEnd: TDateTime;
    FText: String;
    FSource: String;
    FDateOut: TDateTime;
    FStatus: TBisMessagePacketItemStatus;
  end;

  TBisMessagePacketItemMode=(pimSend,pimQuery);

  TBisMessagePacketItems=class(TObjectList)
  private
    FQueryExtra: Boolean;
    FSource: String;
    FMode: TBisMessagePacketItemMode;
    function GetItem(Index: Integer): TBisMessagePacketItem;
  public
    procedure GetItems(Id: Variant; List: TBisMessagePacketItems);
    procedure Add(Item: TBisMessagePacketItem); overload;
    function Add(Info: String; &Type: Integer; Contact: String;
                 DateBegin, DateEnd: TDateTime; Text, Source: String): TBisMessagePacketItem; overload;

    property Items[Index: Integer]: TBisMessagePacketItem read GetItem; default;
  end;

  TBisMessagePacketAccountStatus=(pcsError,pcsValid,pcsInvalid,pcsLocked);

  TBisMessagePacket=class(TObject)
  private
    FList: TBisMessagePacketItems;
    FAccountId: Variant;
    FAccountStatus: TBisMessagePacketAccountStatus;
    FQueryBalance: Boolean;
    FBalance: String;
  public
    constructor Create;
    destructor Destroy; override;

    property List: TBisMessagePacketItems read FList;
  end;

{ TBisMessagePacketItems }

procedure TBisMessagePacketItems.Add(Item: TBisMessagePacketItem);
begin
  inherited Add(Item);
end;

function TBisMessagePacketItems.Add(Info: String; &Type: Integer; Contact: String; DateBegin,
                                    DateEnd: TDateTime; Text, Source: String): TBisMessagePacketItem;
begin
  Result:=TBisMessagePacketItem.Create;
  Result.FId:=Null;
  Result.FInfo:=Info;
  Result.FType:=&Type;
  Result.FContact:=Contact;
  Result.FDateBegin:=DateBegin;
  Result.FDateEnd:=DateEnd;
  Result.FText:=Text;
  Result.FSource:=Source;
  Add(Result);
end;

function TBisMessagePacketItems.GetItem(Index: Integer): TBisMessagePacketItem;
begin
  Result:=TBisMessagePacketItem(inherited Items[Index]);
end;

procedure TBisMessagePacketItems.GetItems(Id: Variant; List: TBisMessagePacketItems);
var
  Item: TBisMessagePacketItem;
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if VarSameValueEx(Item.FId,Id) then
      List.Add(Item);
  end;
end;

{ TBisMessagePacket }

constructor TBisMessagePacket.Create;
begin
  inherited Create;
  FList:=TBisMessagePacketItems.Create;
  FAccountId:=Null;
end;


destructor TBisMessagePacket.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

{ TBisHttpServerHandlerMessageWebModule }
  
function TBisHttpServerHandlerMessageWebModule.Execute(Request: TWebRequest; Response: TWebResponse;
                                                       StreamFormat: TBisHttpServerHandlerMessageWebModuleFormat): Boolean;

  function ReadXmlStream(Stream: TMemoryStream; Packet: TBisMessagePacket): Boolean;
  var
    Xml: TALXMLDocument;
    i,j,x: Integer;
    Node,PacketNode: TALXMLNode;
    ListNode,ItemNode: TALXMLNode;
    Info: String;
    &Type: Integer;
    Contact,Text,Source: String;
    DateBegin,DateEnd: TDateTime;
    Item: TBisMessagePacketItem;
  begin
    Result:=false;
    if Stream.Size>0 then begin
      Xml:=TALXMLDocument.Create(nil);
      try
        Xml.LoadFromStream(Stream);
        for i:=0 to Xml.ChildNodes.Count-1 do begin
          Node:=Xml.ChildNodes[i];
          if AnsiSameText(Node.NodeName,'packet') then begin
            PacketNode:=Node;
            for j:=0 to PacketNode.ChildNodes.Count-1 do begin
              Node:=PacketNode.ChildNodes[j];
              if AnsiSameText(Node.NodeName,'account') then
                Packet.FAccountId:=VarToStrDef(Node.Attributes['id'],'');
              if AnsiSameText(Node.NodeName,'balance') then
                Packet.FQueryBalance:=true;
              if AnsiSameText(Node.NodeName,'list') then begin
                ListNode:=Node;
                Packet.List.FQueryExtra:=Boolean(VarToIntDef(ListNode.Attributes['extra'],0));
                Packet.List.FSource:=VarToStrDef(ListNode.Attributes['source'],'');
                Packet.List.FMode:=TBisMessagePacketItemMode(VarToIntDef(ListNode.Attributes['mode'],0));
                for x:=0 to ListNode.ChildNodes.Count-1 do begin
                  ItemNode:=ListNode.ChildNodes[x];
                  if AnsiSameText(ItemNode.NodeName,'item') then begin
                    Info:=VarToStrDef(ItemNode.Attributes['info'],'');
                    &Type:=VarToIntDef(ItemNode.Attributes['type'],0);
                    Contact:=VarToStrDef(ItemNode.Attributes['contact'],'');
                    DateBegin:=VarToDateTimeDef(ItemNode.Attributes['begin'],NullDate);
                    DateEnd:=VarToDateTimeDef(ItemNode.Attributes['end'],NullDate);
                    Text:=VarToStrDef(ItemNode.Attributes['text'],'');
                    Source:=VarToStrDef(ItemNode.Attributes['source'],'');
                    Item:=Packet.List.Add(Info,&Type,Contact,DateBegin,DateEnd,Text,Source);
                    if Assigned(Item) then
                      Item.FId:=ItemNode.Attributes['id'];
                  end;
                end;
              end;
            end;
          end;
        end;
        Result:=Xml.ChildNodes.Count>0;
      finally
        Xml.Free;
      end;
    end;
  end;

  procedure ProcessPacket(Packet: TBisMessagePacket);

    function AccountStatus: TBisMessagePacketAccountStatus;
    var
      P: TBisProvider;
    begin
      Result:=pcsError;
      try
        P:=TBisProvider.Create(nil);
        try
          P.ProviderName:='S_ACCOUNTS';
          P.FieldNames.Add('LOCKED');
          with P.FilterGroups.Add do begin
            Filters.Add('ACCOUNT_ID',fcEqual,Packet.FAccountId);
          end;
          P.Open;
          if P.Active then begin
            if not P.Empty then begin
              if Boolean(P.FieldByName('LOCKED').AsInteger) then
                Result:=pcsLocked
              else
                Result:=pcsValid;
            end else
              Result:=pcsInvalid;
          end;
        finally
          P.Free;
        end;
      except
        On E: Exception do ;
      end;
    end;

    function GetAccountBalance: String;
    var
      P: TBisProvider;
    begin
      Result:='';
      try
        P:=TBisProvider.Create(nil);
        try
          P.ProviderName:='GET_ACCOUNT_BALANCE';
          with P.Params do begin
            AddInvisible('ACCOUNT_ID').Value:=Packet.FAccountId;
            AddInvisible('BALANCE',ptOutput);
          end;
          P.Execute;
          if P.Success then begin
            Result:=FormatFloat('#0.00',P.Params.ParamByName('BALANCE').AsExtended);
            Result:=ReplaceText(Result,DecimalSeparator,'.');
          end;
        finally
          P.Free;
        end;
      except
        On E: Exception do
          Result:=E.Message;
      end;
    end;

    procedure SendItem(Item: TBisMessagePacketItem);
    var
      P: TBisProvider;
      Flag: Boolean;
    begin
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='I_OUT_MESSAGE_BY_ACCOUNT';
        with P.Params do begin
          AddInvisible('OUT_MESSAGE_ID').Value:=GetUniqueID;
          AddInvisible('ACCOUNT_ID').Value:=Packet.FAccountId;
          AddInvisible('TEXT_OUT').Value:=iff(Trim(Item.FText)<>'',Trim(Item.FText),Null);
          AddInvisible('TYPE_MESSAGE').Value:=Item.FType;
          AddInvisible('CONTACT').Value:=iff(Trim(Item.FContact)<>'',Trim(Item.FContact),Null);
          AddInvisible('SOURCE').Value:=iff(Trim(Item.FSource)<>'',Trim(Item.FSource),Trim(Packet.List.FSource));
          AddInvisible('DESCRIPTION').Value:=iff(Trim(Item.FInfo)<>'',Trim(Item.FInfo),Null);
          AddInvisible('DATE_BEGIN').Value:=iff(Item.FDateBegin<>NullDate,Item.FDateBegin,Null);
          AddInvisible('DATE_END').Value:=iff(Item.FDateEnd<>NullDate,Item.FDateEnd,Null);
          AddInvisible('SUCCESS',ptOutput);
        end;
        try
          P.Execute;
          if P.Success then begin
            Flag:=P.ParamByName('SUCCESS').AsBoolean;
            if Flag then begin
              Item.FId:=P.ParamByName('OUT_MESSAGE_ID').Value;
              Item.FStatus:=pisQueue;
            end else
              Item.FStatus:=pisInvalidBalance;
          end else
            Item.FStatus:=pisError;
        except
          on E: Exception do
            Item.FStatus:=pisError;
        end;
      finally
        P.Free;
      end;
    end;

    procedure QueryItems;
    var
      P: TBisProvider;
      i: Integer;
      Item: TBisMessagePacketItem;
      Need: Boolean;
      Id: Variant;
      List: TBisMessagePacketItems;
      DateOut: Variant;
    begin
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='S_OUT_MESSAGES';
        with P.FieldNames do begin
          AddInvisible('OUT_MESSAGE_ID');
          AddInvisible('DATE_OUT');
        end;
        Need:=false;
        with P.FilterGroups.Add do begin
          for i:=0 to Packet.List.Count-1 do begin
            Item:=Packet.List[i];
            if not VarIsNull(Item.FId) then begin
              with Filters.Add('OUT_MESSAGE_ID',fcEqual,Item.FId) do begin
                CheckCase:=true;
                &Operator:=foOr;
              end;
              Need:=true;
            end;
          end;
        end;
        if Need then
          P.Open;
        if P.Active then begin
          List:=TBisMessagePacketItems.Create;
          try
            List.OwnsObjects:=false;
            P.First;
            while not P.Eof do begin
              Id:=P.FieldByName('OUT_MESSAGE_ID').Value;
              DateOut:=P.FieldByName('DATE_OUT').Value;
              List.Clear;
              Packet.List.GetItems(Id,List);
              for i:=0 to List.Count-1 do begin
                Item:=List[i];
                Item.FDateOut:=VarToDateTimeDef(DateOut,NullDate);
                if VarIsNull(DateOut) then
                  Item.FStatus:=pisQueue
                else
                  Item.FStatus:=pisSent;
              end; 
              P.Next;
            end;
          finally
            List.Free;
          end;
        end;
      finally
        P.Free;
      end;
    end; 

  var
    i: Integer;
  begin
    Packet.FAccountStatus:=pcsInvalid;
    if not VarIsNull(Packet.FAccountId) then begin
      Packet.FAccountStatus:=AccountStatus;
      if Packet.FAccountStatus=pcsValid then begin
        if Packet.FQueryBalance then
          Packet.FBalance:=GetAccountBalance;
       if Packet.List.FMode=pimSend then
          for i:=0 to Packet.List.Count-1 do
            SendItem(Packet.List[i])
       else
         QueryItems;
      end;
    end;
  end;

  procedure WriteXmlStream(Stream: TStream; Packet: TBisMessagePacket);
  var
    Xml: TALXMLDocument;
    PacketNode, ListNode, ItemNode: TALXMLNode;
    i: Integer;
    Item: TBisMessagePacketItem;
  begin
    Xml:=TALXMLDocument.Create(nil);
    try
      Xml.Active:=true;
      Xml.Version:='1.0';
      Xml.Encoding:='windows-1251';
      Xml.StandAlone:='yes';
      PacketNode:=Xml.AddChild('packet');
      PacketNode.AddChild('account').NodeValue:=Packet.FAccountStatus;
      if Packet.FAccountStatus=pcsValid then begin
        if Packet.FQueryBalance then
          PacketNode.AddChild('balance').NodeValue:=Packet.FBalance;
        if Packet.List.Count>0 then begin
          ListNode:=PacketNode.AddChild('list');
          for i:=0 to Packet.List.Count-1 do begin
            Item:=Packet.List[i];
            ItemNode:=ListNode.AddChild('item');
            ItemNode.NodeValue:=Item.FStatus;
            if Packet.List.FQueryExtra then
              ItemNode.Attributes['id']:=VarToStrDef(Item.FId,'');
            if (Packet.List.FMode=pimQuery) and (Item.FStatus=pisSent) then
              ItemNode.Attributes['out']:=FormatDateTime('dd.mm.yyyy hh:nn:ss',Item.FDateOut);
          end;
        end;
      end;
      Xml.SaveToStream(Stream);
      Stream.Position:=0;
    finally
      Xml.Free;
    end;
  end;

var
  RequestStream: TMemoryStream;
  Packet: TBisMessagePacket;
  Flag: Boolean;
begin
  Result:=false;
  if Assigned(FHandler) then begin
    RequestStream:=TMemoryStream.Create;
    Packet:=TBisMessagePacket.Create;
    try
      try
        RequestStream.WriteBuffer(Pointer(Request.Content)^,Length(Request.Content));
        RequestStream.Position:=0;

        Flag:=false;
        case StreamFormat of
          mfRaw: ;
          mfXml: Flag:=ReadXmlStream(RequestStream,Packet);
        end;

        if Flag then begin
          ProcessPacket(Packet);
          if Assigned(Response.ContentStream) then begin
            case StreamFormat of
              mfRaw: ;
              mfXml: WriteXmlStream(Response.ContentStream,Packet);
            end;
            Result:=true;
          end;
        end;
      except
        on E: Exception do
          FHandler.LoggerWrite(E.Message,ltError); 
      end;
    finally
      Packet.Free;
      RequestStream.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerMessageWebModule.BisHttpServerHandlerUpdateWebModuleUpdateAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=Execute(Request,Response,mfRaw);
end;

procedure TBisHttpServerHandlerMessageWebModule.BisHttpServerHandlerUpdateWebModuleXmlAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
begin
  Handled:=Execute(Request,Response,mfXml);
end;

end.
