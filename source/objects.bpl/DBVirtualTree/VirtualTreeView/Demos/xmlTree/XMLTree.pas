unit XMLTree;

// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License
// at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
// the License for the specific language governing rights and limitations
// under the License.
//
// Copyright (c) 2001 by Moritz Franckenstein, AMADEE AG
// http://www.amadee.de/
//
// Version 0.0.27 - 16.10.2001
// Tested with VirtualTree 2.5.40


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, MSXML_TLB;

const
  // NodeType (also used as image index)
  ntUnknown = 0; // Error
  ntRoot = 1; // DocumentElement, NODE_DOCUMENT, NODE_PROCESSING_INSTRUCTION
  ntComment = 2; // NODE_COMMENT
  ntText = 3; // NODE_TEXT, NODE_CDATA_SECTION
  ntAttribute = 4; // NODE_ATTRIBUTE
  ntElement = 5; // NODE_ELEMENT without ChildNodes
  ntNode = 6; // NODE_ELEMENT with ChildNodes

  BackColors: array[ntUnknown..ntNode] of TColor =
  ($0000EE, $FFFFFF, $EEEEEE, $EEFFEE, $FFEEEE, $EEFFEE, $FFFFFF);

type
  PNodeData = ^TNodeData;
  TNodeData = record
    XmlNode: IXMLDOMNode;
    XmlPath: string;
    NodeType: Integer;
  end;

  TXMLTree = class;

  TAutoExpand = (
    aeDisabled,
    aeRootNodes,
    aeFullExpand);

  TGridMode = (
    gmCustom,
    gmNoGrid,
    gmNormal,
    gmBands);

  TExpandedState = record
    List: TStringList;
    InUse: Boolean;
    TopPath, FocPath: string;
    TopFound, FocFound: PVirtualNode;
  end;

  TCheckNodeEvent = procedure(Sender: TXMLTree; Node: PVirtualNode;
    var NewXmlNode: IXMLDOMNode; var NewNodeType: Integer; var Add: Boolean) of object;
  TGetBackColorEvent = procedure(Sender: TXMLTree; ParentNode: PVirtualNode;
    XmlNode: IXMLDOMNode; NodeType: Integer; var BackColor: TColor) of object;

  TXMLTree = class(TCustomVirtualStringTree)
  private
    FXmlDoc: IXMLDOMDocument;
    FAutoExpand: TAutoExpand;
    FOnCheckNode: TCheckNodeEvent;
    FOnGetBackColor: TGetBackColorEvent;
    FInternalDataOffset: Cardinal;
    FGridMode: TGridMode;
    FXmlNamespaces: TStrings;
    FValueColumn: Integer;
    FUseTextNodes: Boolean;
    FExpandedState: TExpandedState;
    InAddChildren: Boolean;
    FLastParseErrorPos: TPoint;
    FHideDocumentElement: Boolean;
    FLastParseErrorCode: Integer;
    function GetXmlDoc: IXMLDOMDocument;
    procedure SetXmlDoc(const Value: IXMLDOMDocument);
    function GetXml: string;
    procedure SetXml(Value: string);
    procedure SetAutoExpand(const Value: TAutoExpand);
    procedure SetValueColumn(const Value: Integer);
    procedure SetGridMode(const Value: TGridMode);
    function GetXmlNamespaces: TStrings;
    procedure SetXmlNamespaces(const Value: TStrings);
    function AddChildren(Node: PVirtualNode; XmlNode: IXMLDOMNode): Cardinal;
    procedure CorrectNamespaces(var Xml: string; RemoveOnly: Boolean);
    function GetCleared: Boolean;
    procedure IterateCallback(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Data: Pointer; var Abort: Boolean);
    function GetNodeXml(Node: PVirtualNode): string;
    procedure SetNodeXml(Node: PVirtualNode; const Value: string);
    function GetOptions: TStringTreeOptions;
    procedure SetOptions(const Value: TStringTreeOptions);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear; override;
    property Cleared: Boolean read GetCleared;
    property XmlDoc: IXMLDOMDocument read GetXmlDoc write SetXmlDoc;
    function ParseXml(NewXml: string): IXMLDOMDocument;
    property LastParseErrorPos: TPoint read FLastParseErrorPos;
    property LastParseErrorCode: Integer read FLastParseErrorCode;
    function GetData(Node: PVirtualNode): PNodeData;
    function GetXmlStr(XmlNode: IXMLDOMNode): string;
    function GetXmlPath(XmlNode: IXMLDOMNode): string;
    function FindNode(XmlNode: IXMLDOMNode; DoInit: Boolean = False;
      DoExpand: Boolean = False): PVirtualNode; overload;
    function FindNode(QueryString: string; DoInit: Boolean = False;
      DoExpand: Boolean = False): PVirtualNode; overload;
    procedure ExpandedStateClear;
    procedure ExpandedStateRestore;
    procedure ExpandedStateSave;
    procedure RefreshNode(Node: PVirtualNode; Parent: Boolean = False);
    procedure NewNode(Node: PVirtualNode; NewNodeType: Integer;
      Name: string = ''; Value: string = ''; Before: Boolean = False;
      AddBreak: Boolean = False; XmlNode: IXMLDOMNode = nil);
    property NodeXml[Node: PVirtualNode]: string read GetNodeXml write SetNodeXml;
  protected
    function GetOptionsClass: TTreeOptionsClass; override;
    procedure DoInitNode(Parent, Node: PVirtualNode;
      var InitStates: TVirtualNodeInitStates); override;
    procedure DoFreeNode(Node: PVirtualNode); override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var Text: WideString); override;
    procedure DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var Index: Integer); override;
    procedure DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex;
      TextType: TVSTTextType); override;
    procedure DoBeforeItemErase(Canvas: TCanvas; Node: PVirtualNode;
      ItemRect: TRect; var Color: TColor;
      var EraseAction: TItemEraseAction); override;
    procedure DoBeforeCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); override;
    procedure DoExpanded(Node: PVirtualNode); override;
    procedure DoCollapsed(Node: PVirtualNode); override;
    procedure DoCanEdit(Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean); override;
    procedure DoNewText(Node: PVirtualNode; Column: TColumnIndex; Text: WideString); override;
    function DoGetNodeHint(Node: PVirtualNode; Column: TColumnIndex): WideString; override;

    procedure DoCheckNode(Parent: PVirtualNode; var NewXmlNode: IXMLDOMNode;
      var NewNodeType: Integer; var Add: Boolean); virtual;
    procedure DoGetBackColor(Node: PVirtualNode;
      var BackColor: TColor); virtual;
  published
    property Xml: string read GetXml write SetXml;
    property XmlNamespaces: TStrings read GetXmlNamespaces write SetXmlNamespaces;
    property ValueColumn: Integer read FValueColumn write SetValueColumn;
    property AutoExpand: TAutoExpand read FAutoExpand write SetAutoExpand default aeRootNodes;
    property GridMode: TGridMode read FGridMode write SetGridMode default gmBands;
    property UseTextNodes: Boolean read FUseTextNodes write FUseTextNodes;
    property HideDocumentElement: Boolean read FHideDocumentElement write FHideDocumentElement;
    property OnCheckNode: TCheckNodeEvent read FOnCheckNode write FOnCheckNode;
    property OnGetBackColor: TGetBackColorEvent read FOnGetBackColor write FOnGetBackColor;

    property Align;
    property Alignment;
    property Anchors;
    property AnimationDuration;
    property AutoExpandDelay;
    property AutoScrollDelay;
    property AutoScrollInterval;
    property BiDiMode;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BorderStyle;
    property ButtonFillMode;
    property ButtonStyle;
    property BorderWidth;
    property ChangeDelay;
    property CheckImageKind;
    property ClipboardFormats;
    property Color;
    property Colors;
    property Constraints;
    property Ctl3D;
    property CustomCheckImages;
    property DefaultPasteMode;
    property DragHeight;
    property DragKind;
    property DragImageKind;
    property DragMode;
    property DragOperations;
    property DragType;
    property DragWidth;
    property DrawSelectionMode;
    property EditDelay;
    property Enabled;
    property Font;
    property Header;
    property HintAnimation;
    property HintMode;
    property HotCursor;
    property Images;
    property Indent;
    property LineMode;
    property LineStyle;
    property Margin;
    property NodeAlignment;
    property NodeDataSize;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBarOptions;
    property SelectionCurveRadius;
    property ShowHint;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property TextMargin;
    property TreeOptions: TStringTreeOptions read GetOptions write SetOptions;
    property Visible;
    property WantTabs;

    property OnChange;
    property OnChecked;
    property OnChecking;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnColumnClick;
    property OnColumnDblClick;
    property OnColumnResize;
    property OnCompareNodes;
    property OnCreateDataObject;
    property OnCreateDragManager;
    property OnCreateEditor;
    property OnDblClick;
    property OnDragAllowed;
    property OnDragOver;
    property OnDragDrop;
    property OnEditCancelled;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanded;
    property OnExpanding;
    property OnFocusChanged;
    property OnFocusChanging;
    property OnFreeNode;
    property OnGetText;
    property OnPaintText;
    property OnGetHelpContext;
    property OnGetImageIndex;
    property OnGetHint;
    property OnGetLineStyle;
    property OnGetNodeDataSize;
    property OnGetPopupMenu;
    property OnGetUserClipboardFormats;
    property OnHeaderClick;
    property OnHeaderDblClick;
    property OnHeaderDragged;
    property OnHeaderDragging;
    property OnHeaderDraw;
    property OnHeaderMouseDown;
    property OnHeaderMouseMove;
    property OnHeaderMouseUp;
    property OnHotChange;
    property OnInitNode;
    property OnKeyAction;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnNewText;
    property OnNodeCopied;
    property OnNodeCopying;
    property OnNodeMoved;
    property OnNodeMoving;
    property OnResetNode;
    property OnResize;
    property OnScroll;
    property OnShortenString;
    property OnStartDock;
    property OnStartDrag;
    property OnStructureChange;
    property OnUpdating;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Virtual Controls', [TXMLTree]);
end;

{ TXMLTree }

constructor TXMLTree.Create(AOwner: TComponent);
begin
  inherited;
  FInternalDataOffset := AllocateInternalDataArea(SizeOf(TNodeData));
  FAutoExpand := aeRootNodes;
  GridMode := gmBands;
  Color := clWhite;

  DefaultText := #255;

  // if you don't like the following in your descendant, simply
  // set ValueColumn <> 0 before the inherited Create call!
  if (csDesigning in ComponentState) and (FValueColumn = 0) then
    with Header do begin
      FValueColumn := 1;
      with Columns.Add do begin
        Text := 'Tree';
        Width := 150;
      end;
      with Columns.Add do begin
        Text := 'Value';
        Width := 150;
      end;
      AutoSizeIndex := 1;
      Options := Options + [hoAutoResize, hoVisible];
    end;
end;

destructor TXMLTree.Destroy;
begin
  FXmlNamespaces.Free;
  inherited;
end;

function TXMLTree.GetData(Node: PVirtualNode): PNodeData;
begin
  Assert(Assigned(Node), 'GetData: Node must not be nil.');
  Result := PNodeData(PChar(Node) + FInternalDataOffset);
end;

procedure TXMLTree.CorrectNamespaces(var Xml: string; RemoveOnly: Boolean);
// removes and inserts namespace declarations and a header into the xml
var
  I, J, K: Integer;
  S: string;
begin
  if not Assigned(FXmlNamespaces) then Exit;

  I := Pos('>', Xml);
  if (I > 1) and (Xml[I - 1] = '?') then begin
    while (I < Length(Xml)) and (Xml[I + 1] <= #32) do Inc(I);
    Delete(Xml, 1, I);
    I := Pos('>', Xml);
  end;
  while (I > 2) do begin
    if Xml[I - 1] = '/' then Dec(I);
    J := Pos(' xmlns:', Xml);
    if (J > I) or (J < 1) then Break;
    K := J + 7;
    while not (Xml[K] in ['=', '"', ' ']) do Inc(K);
    if Copy(Xml, K, 8) = '="dummy"' then Delete(Xml, J, K - J + 8)
    else Break;
    I := Pos('>', Xml);
  end;

  if RemoveOnly or (I < 1) then Exit;

  S := '<?xml version="1.0"?>'#13#10 + Copy(Xml, 1, I - 1);
  for J := 0 to FXmlNamespaces.Count - 1 do
    S := S + ' xmlns:' + Trim(FXmlNamespaces[J]) + '="dummy"';
  Delete(Xml, 1, I - 1);
  Insert(S, Xml, 1);
end;

function TXMLTree.GetXml: string;
begin
  if Assigned(FXmlDoc) then begin
    Result := FXmlDoc.xml;
    CorrectNamespaces(Result, True);
  end
  else Result := '';
end;

procedure TXMLTree.SetXml(Value: string);
begin
  // if Value = Xml then Exit;
  XmlDoc := ParseXml(Value);
end;

function TXMLTree.ParseXml(NewXml: string): IXMLDOMDocument;
begin
  Result := nil;
  if NewXml = '' then Exit;
  CorrectNamespaces(NewXml, False);
  Result := CoDOMDocument.Create;
  with Result do begin
    preserveWhiteSpace := True;
    if not loadXML(NewXml) then
      with parseError do begin
        FLastParseErrorPos := Point(linepos - 1, line - 2);
        FLastParseErrorCode := errorCode;
        NewXml := Format('Parse Error: %s(Line: %d, Pos: %d)', [reason, line, linepos]);
        Result := nil; // to free it
        raise Exception.Create(NewXml);
      end;
  end;
end;

function TXMLTree.GetXmlDoc: IXMLDOMDocument;
begin
  if not Assigned(FXmlDoc) then begin
    FXmlDoc := CoDOMDocument.Create;
    FXmlDoc.preserveWhiteSpace := True;
  end;
  Result := FXmlDoc;
end;

procedure TXMLTree.SetXmlDoc(const Value: IXMLDOMDocument);
var
  WasCleared: Boolean;
begin
  if not Assigned(Value) then begin
    Clear;
    Exit;
  end;
  WasCleared := Cleared;
  try
    BeginUpdate;
    if not WasCleared then ExpandedStateSave;

    Clear;
    FXmlDoc := Value;
    if FHideDocumentElement then
      AddChildren(nil, FXmlDoc.documentElement)
    else AddChildren(nil, FXmlDoc);

    if not WasCleared then ExpandedStateRestore
    else if FAutoExpand = aeFullExpand then FullExpand;
  finally
    EndUpdate;
    if not WasCleared then ExpandedStateClear;
  end;
end;

function TXMLTree.GetCleared: Boolean;
begin
  Result := not Assigned(FXmlDoc);
end;

function TXMLTree.GetXmlNamespaces: TStrings;
begin
  if not Assigned(FXmlNamespaces) then
    FXmlNamespaces := TStringList.Create;
  Result := FXmlNamespaces;
end;

procedure TXMLTree.SetXmlNamespaces(const Value: TStrings);
begin
  if not Assigned(Value) or (Value.Count = 0) then FreeAndNil(FXmlNamespaces)
  else XmlNamespaces.Assign(Value);
end;

procedure TXMLTree.SetAutoExpand(const Value: TAutoExpand);
begin
  if Value = FAutoExpand then Exit;
  if (FAutoExpand = aeFullExpand) and (Value = aeDisabled) then FullCollapse
  else if Value = aeFullExpand then FullExpand;
  FAutoExpand := Value;
end;

procedure TXMLTree.SetGridMode(const Value: TGridMode);
begin
  if Value = FGridMode then Exit;
  FGridMode := Value;
  if Value = gmCustom then Exit;
  if Value = gmNoGrid then
    TreeOptions.PaintOptions :=
      TreeOptions.PaintOptions - [toShowHorzGridLines, toShowVertGridLines]
  else TreeOptions.PaintOptions :=
    TreeOptions.PaintOptions + [toShowHorzGridLines, toShowVertGridLines];
  if Value = gmBands then begin
    LineMode := lmBands;
    Colors.TreeLineColor := Colors.GridLineColor;
    TreeOptions.PaintOptions :=
      TreeOptions.PaintOptions + [toShowRoot];
  end
  else begin
    LineMode := lmNormal;
    Colors.TreeLineColor := clBtnShadow;
  end;
end;

procedure TXMLTree.SetValueColumn(const Value: Integer);
begin
  if Value < 0 then FValueColumn := -2
  else if Value <> Header.MainColumn then FValueColumn := Value;
end;

procedure TXMLTree.Clear;
begin
  FXmlDoc := nil;
  inherited;
end;

procedure TXMLTree.DoCheckNode(Parent: PVirtualNode; var NewXmlNode: IXMLDOMNode;
  var NewNodeType: Integer; var Add: Boolean);
begin
  if Assigned(FOnCheckNode) then
    FOnCheckNode(Self, Parent, NewXmlNode, NewNodeType, Add);
end;
{
Explanation of the CheckNode event:

This event is called for every Xml node in the document including text and
other special node types.
The Add parameter defines if the node will be displayed in the tree. It
defaults to true on normal nodes, attributes and comments.

You can set NewXmlNode to another node to display it instead. In this
case you can also change NewNodeType accordingly. Or you set it to -1, then
the NewNodeType and the Add flag is determined again and the event is also
called again with the changed node.

Note: Since the new tree node is not created in this state you cannot access
it or set any user data. Use the InitNode event instead, it is called after
the internal node initialization.
}

function TXMLTree.AddChildren(Node: PVirtualNode; XmlNode: IXMLDOMNode): Cardinal;
var
  ParentPath: string;
  NameCache: TStringList;

  function GetDefaultNodeType(XmlNode: IXMLDOMNode): Integer;
  begin
    Assert(Assigned(XmlNode), 'GetDefaultNodeType');
    case XmlNode.nodeType of
      NODE_ELEMENT:
        if XmlNode.parentNode.nodeType = NODE_DOCUMENT then Result := ntRoot
        else if Assigned(XmlNode.selectSingleNode('*')) then Result := ntNode
        else Result := ntElement;
      NODE_ATTRIBUTE: Result := ntAttribute;
      NODE_COMMENT: Result := ntComment;
      NODE_TEXT, NODE_CDATA_SECTION: Result := ntText;
      NODE_DOCUMENT, NODE_PROCESSING_INSTRUCTION: Result := ntRoot;
    else Result := ntUnknown;
    end;
  end;

  procedure CheckNode(NewXmlNode: IXMLDOMNode; Att: Boolean);
  var
    Add: Boolean;
    NewNodeType, I, Count: Integer;
  begin
    if (not FUseTextNodes) and (NewXmlNode.nodeType = NODE_TEXT) then Exit;
    repeat
      Add := NewXmlNode.nodeType in [NODE_ELEMENT, NODE_ATTRIBUTE, NODE_COMMENT];
      NewNodeType := GetDefaultNodeType(NewXmlNode);
      if Add and Assigned(FXmlNamespaces) and (NewNodeType = ntAttribute)
        and (NewXmlNode.prefix = 'xmlns') and (NewXmlNode.text = 'dummy') then Add := False;

      DoCheckNode(Node, NewXmlNode, NewNodeType, Add);
      if not (Add and Assigned(NewXmlNode)) then Exit;
    until NewNodeType >= 0;

    ChildCount[Node] := ChildCount[Node] + 1;
    with GetData(Node.LastChild)^ do begin
      XmlNode := NewXmlNode;
      NodeType := NewNodeType;

      if Att then XmlPath := ParentPath + '@' + XmlNode.nodeName
      else if XmlNode.nodeType = NODE_ELEMENT then begin
        XmlPath := ParentPath + XmlNode.nodeName;
        if Assigned(NameCache) then begin
          I := NameCache.IndexOf(XmlNode.nodeName);
          if I < 0 then begin
            I := NameCache.Add(XmlNode.nodeName);
            Count := 0;
          end
          else Count := Integer(NameCache.Objects[I]) + 1;
          NameCache.Objects[I] := TObject(Count);
          if Count > 0 then XmlPath := XmlPath + '[' + IntToStr(Count) + ']';
        end;
      end
      else XmlPath := ParentPath + '!';
    end;
    Include(Node.LastChild.States, vsInitialUserData);
    Inc(Result);
  end;

var
  I: Integer;
begin
  Result := 0;
  if not Assigned(XmlNode)
    or (XmlNode.nodeType in [NODE_ATTRIBUTE, NODE_COMMENT,
    NODE_CDATA_SECTION, NODE_TEXT]) then Exit;
  try
    InAddChildren := True;
    BeginUpdate;

    if not Assigned(Node) then begin
      Node := RootNode;
      ParentPath := '';
    end
    else ParentPath := GetData(Node).XmlPath + '/';

    with XmlNode do begin
      if Assigned(attributes) then
        for I := 0 to attributes.length - 1 do CheckNode(attributes[I], True);
      if Assigned(childNodes) and (childNodes.length > 0) then begin
        NameCache := nil;
        if childNodes.length = 1 then
          CheckNode(childNodes[0], False)
        else try
          NameCache := TStringList.Create;
          NameCache.Sorted := True;
          for I := 0 to childNodes.length - 1 do CheckNode(childNodes[I], False);
        finally
          NameCache.Free;
        end;
      end;
    end;

  finally
    EndUpdate;
    InAddChildren := False;
  end;
end;

procedure TXMLTree.DoInitNode(Parent, Node: PVirtualNode;
  var InitStates: TVirtualNodeInitStates);
begin
  //Assert(not InAddChildren, 'AddChildren caused call of InitNode');
  with GetData(Node)^ do begin
    Assert(Assigned(XmlNode), 'DoInitNode');
    Include(Node.States, vsInitialized);

    if not Assigned(Parent) and (FAutoExpand <> aeDisabled) then
      Include(InitStates, ivsExpanded);

    if AddChildren(Node, XmlNode) > 0 then
      Include(InitStates, ivsHasChildren);
  end;
  inherited;
end;

procedure TXMLTree.DoFreeNode(Node: PVirtualNode);
begin
  with GetData(Node)^ do
    if Assigned(XmlNode) then begin
      XmlNode := nil;
      XmlPath := '';
      NodeType := 0;
    end;
  inherited;
end;

procedure TXMLTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var
  S, Temp: string;
  I: Integer;
  TempNode: PVirtualNode;
begin
  S := '';
  with GetData(Node)^ do
    if Assigned(XmlNode) then
      if (Column < 0) or (Column = Header.MainColumn) then begin
        if NodeType = ntComment then S := Trim(XmlNode.text)
        else begin
          S := XmlNode.nodeName;
          if (XmlNode.nodeType in [NODE_ELEMENT, NODE_DOCUMENT, NODE_PROCESSING_INSTRUCTION])
            and not Expanded[Node] then begin
            TempNode := Node.FirstChild;
            while Assigned(TempNode) do begin
              with GetData(TempNode)^ do
                if NodeType <> ntAttribute then Break
                else S := S + ' ' + XmlNode.xml;
              TempNode := TempNode.NextSibling;
            end;
          end;
        end;
      end
      else if Column = FValueColumn then
        if (NodeType <> ntComment) and (XmlNode.hasChildNodes) or (NodeType = ntText) then
          if (NodeType in [ntElement, ntAttribute, ntText])
            or not Assigned(XmlNode.selectSingleNode('*')) then
            S := Trim(XmlNode.text)
          else with XmlNode.selectNodes('text()') do
              for I := 0 to length - 1 do begin
                Temp := Trim(item[I].text);
                if Temp = '' then Continue;
                if S = '' then S := Temp
                else S := S + ' ' + Temp;
              end;
  Text := S;
  inherited;
end;

function TXMLTree.DoGetNodeHint(Node: PVirtualNode; Column: TColumnIndex): WideString;
begin
  if Column = Header.MainColumn then Result := GetData(Node).XmlPath
  else Result := Hint;
  if Assigned(OnGetHint) then
    OnGetHint(Self, Node, Column, ttNormal, Result);
end;

procedure TXMLTree.DoCollapsed(Node: PVirtualNode);
begin
  InvalidateNode(Node);
  inherited;
end;

procedure TXMLTree.DoExpanded(Node: PVirtualNode);
begin
  InvalidateNode(Node);
  inherited;
end;

procedure TXMLTree.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var Index: Integer);
begin
  if (Column = Header.MainColumn) and (Kind in [ikNormal, ikSelected]) then
    Index := GetData(Node).NodeType;
  inherited;
end;

procedure TXMLTree.DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if GetData(Node).NodeType = ntComment then
    Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
  inherited;
end;

procedure TXMLTree.DoGetBackColor(Node: PVirtualNode; var BackColor: TColor);
begin
  with GetData(Node)^ do begin
    if (NodeType >= Low(BackColors)) and (NodeType <= High(BackColors)) then
      BackColor := BackColors[NodeType]
    else BackColor := Color;
    if Assigned(FOnGetBackColor) then
      FOnGetBackColor(Self, Node, XmlNode, NodeType, BackColor);
  end;
end;

procedure TXMLTree.DoBeforeItemErase(Canvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var Color: TColor; var EraseAction: TItemEraseAction);
var
  BackColor: TColor;
begin
  if LineMode <> lmBands then begin
    DoGetBackColor(Node, BackColor);
    if BackColor <> Self.Color then begin
      Color := BackColor;
      EraseAction := eaColor;
    end;
  end;
  inherited;
end;

procedure TXMLTree.DoBeforeCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  BackColor: TColor;
  Ind: Integer;
  Rtl: Boolean;
begin
  if LineMode = lmBands then begin

    if Column = Header.MainColumn then begin
      Ind := GetNodeLevel(Node) * Indent;
      Rtl := (Column >= 0) and (Header.Columns[Column].BiDiMode = bdRightToLeft)
        or (Column < 0) and (BiDiMode = bdRightToLeft);
      if Rtl then
      begin Dec(CellRect.Right, Ind); Ind := Integer(Indent); end
      else
      begin Inc(CellRect.Left, Ind); Ind := -Integer(Indent); end;
    end
    else
    begin Ind := 0; Rtl := False; end;

    DoGetBackColor(Node, BackColor);
    if BackColor <> Color then begin // fill cell
      Canvas.Brush.Color := BackColor;
      Canvas.FillRect(CellRect);
    end;

    if Column = Header.MainColumn then begin
      if Rtl then
        CellRect.Left := CellRect.Right - Integer(Indent)
      else
        CellRect.Right := CellRect.Left + Integer(Indent);
      Inc(CellRect.Bottom);

      repeat
        if BackColor <> Color then begin // fill vertical band
          Canvas.Brush.Color := BackColor;
          Canvas.FillRect(CellRect);
        end;

        Node := Node.Parent;
        if not Assigned(Node) or (Node = RootNode) then Break;

        Inc(CellRect.Left, Ind);
        Inc(CellRect.Right, Ind);
        DoGetBackColor(Node, BackColor);
      until False;
    end;

  end;
  inherited;
end;

{old version without filling vertical bands:

procedure TXMLTree.DoBeforeCellPaint(Canvas: TCanvas; Node: PVirtualNode;
  Column: Integer; CellRect: TRect);
var
  BackColor: TColor;
  Ind: Integer;
begin
  if LineMode = lmBands then begin
    DoGetBackColor(Node, BackColor);
    if BackColor <> Color then begin
      if Column = Header.MainColumn then begin
        Ind:= GetNodeLevel(Node) * Indent;
        if vsExpanded in Node.States then Inc(Ind, Indent);
        if Header.Columns[Column].BiDiMode = bdRightToLeft then
          Dec(CellRect.Right, Ind-2)
        else Inc(CellRect.Left, Ind);
       end;
      Canvas.Brush.Color:= BackColor;
      Canvas.FillRect(CellRect);
     end;
   end;
  inherited;
end;
}

procedure TXMLTree.DoCanEdit(Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  if Allowed and (Column >= 0) and (Column in [FValueColumn, Header.MainColumn]) then
    case GetData(Node).NodeType of
      ntElement, ntAttribute, ntText: Allowed := Column = FValueColumn;
      ntComment: Allowed := Column = Header.MainColumn;
    else Allowed := False;
    end;
  inherited;
end;

procedure TXMLTree.DoNewText(Node: PVirtualNode; Column: TColumnIndex; Text: WideString);
begin
  inherited;
  with GetData(Node)^ do
    if ((Column = Header.MainColumn) and (NodeType = ntComment)
      or (Column = FValueColumn)
      and (NodeType in [ntElement, ntAttribute, ntText]))
      and (XmlNode.text <> Text) then begin
      XmlNode.text := Text;
      if (NodeType <> ntComment) and (Text = '') then
        with XmlNode do while Assigned(firstChild) do removeChild(firstChild);
      if not (vsExpanded in Node.States) then ResetNode(Node)
      else try
        BeginUpdate;
        ResetNode(Node);
        Expanded[Node] := True;
      finally
        EndUpdate;
      end;
    end;
end;

function TXMLTree.GetXmlPath(XmlNode: IXMLDOMNode): string;
// calculates the path to this xml node
var
  S: string;
  Count: Integer;
  Temp: IXMLDOMNode;
begin
  Assert(Assigned(XmlNode), 'GetXmlPath: XmlNode must not be nil.');

  if XmlNode.nodeType = NODE_ATTRIBUTE then begin
    Result := '@' + XmlNode.nodeName;
    XmlNode := XmlNode.selectSingleNode('..');
  end
  else Result := '';

  while Assigned(XmlNode) and (XmlNode.nodeType <> NODE_DOCUMENT) do begin
    S := XmlNode.nodeName;
    Temp := XmlNode.previousSibling;
    Count := 0;
    while Assigned(Temp) do begin
      if (Temp.nodeType = NODE_ELEMENT) and (Temp.nodeName = S) then Inc(Count);
      Temp := Temp.previousSibling;
    end;
    if Count > 0 then S := S + '[' + IntToStr(Count) + ']';
    if Result = '' then Result := S
    else Result := S + '/' + Result;

    XmlNode := XmlNode.parentNode;
  end;
end;

function TXMLTree.FindNode(QueryString: string; DoInit: Boolean = False;
  DoExpand: Boolean = False): PVirtualNode;
// finds a tree node by the given xml querystring or path
var
  Temp: IXMLDOMNode;
begin
  Result := nil;
  if Assigned(FXmlDoc) then begin
    Temp := FXmlDoc.selectSingleNode(QueryString);
    if Assigned(Temp) then
      Result := FindNode(Temp, DoInit, DoExpand)
  end;
end;

function TXMLTree.FindNode(XmlNode: IXMLDOMNode; DoInit: Boolean = False;
  DoExpand: Boolean = False): PVirtualNode;
// finds a tree node by the given xml node
var
  SearchPath, S: string;
  I: Integer;
begin
  SearchPath := GetXmlPath(XmlNode);
  I := 0;
  Result := RootNode.FirstChild;
  try
    if DoExpand then BeginUpdate;
    while Assigned(Result) do begin
      repeat Inc(I);
      until (I > Length(SearchPath)) or (SearchPath[I] = '/');
      S := Copy(SearchPath, 1, I - 1);

      while Assigned(Result) do begin
        if not (vsInitialized in Result.States) then
          if DoInit or DoExpand then ValidateNode(Result, False)
          else begin Result := nil; Exit; end;

        if GetData(Result).XmlPath = S then begin
          if I > Length(SearchPath) then Exit;

          if not Expanded[Result] then
            if DoExpand then Expanded[Result] := True
            else if not DoInit then begin Result := nil; Exit; end;
          Result := Result.FirstChild;
          Break;
        end
        else Result := Result.NextSibling;
      end;
    end;
  finally
    if DoExpand then EndUpdate;
  end;
end;

procedure TXMLTree.IterateCallback(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
begin
//  if not Expanded[Node] then
  if not (vsExpanded in Node.States) then
    TStrings(Data).Add(GetData(Node).XmlPath);
end;

procedure TXMLTree.ExpandedStateClear;
begin
  with FExpandedState do begin
    if not Assigned(List) then List := TStringList.Create;
    List.Clear;
    InUse := False;
    TopPath := ''; FocPath := '';
    TopFound := nil; FocFound := nil;
  end;
end;

procedure TXMLTree.ExpandedStateSave;
begin
  with FExpandedState do begin
    ExpandedStateClear;
    if Cleared then Exit;
    InUse := True;
    if Assigned(TopNode) then
      TopPath := GetData(TopNode).XmlPath;
    if Assigned(FocusedNode) then
      FocPath := GetData(FocusedNode).XmlPath;
    IterateSubtree(nil, IterateCallback, List,
      [vsInitialized, vsHasChildren, vsVisible]);
  end;
end;

procedure TXMLTree.ExpandedStateRestore;
// Sets the expanded state of all nodes to the previously saved state.
// The nodes are searched by their XmlPath so that it works after a complete
// reload of the Xml. All new nodes are automatically expanded.

  procedure Recurse(Node: PVirtualNode);
  begin
    Expanded[Node] := True;
    Node := Node.FirstChild;
    while Assigned(Node) do begin
      ValidateNode(Node, False);
      with GetData(Node)^, FExpandedState do begin
        if XmlPath = TopPath then TopFound := Node;
        if XmlPath = FocPath then FocFound := Node;
        if vsHasChildren in Node.States then
          if List.IndexOf(XmlPath) < 0 then Recurse(Node);
      end;
      Node := Node.NextSibling;
    end;
  end;
begin
  with FExpandedState do begin
    Assert(Assigned(List), 'ExpandedStateRestore: No saved state.');
    if not InUse then Exit;
    List.Sorted := True;
    Recurse(RootNode);
    TopNode := TopFound;
    FocusedNode := FocFound;
    Selected[FocFound] := True;
    ExpandedStateClear;
  end;
end;

procedure TXMLTree.RefreshNode(Node: PVirtualNode; Parent: Boolean = False);
begin
  ExpandedStateSave;
  FocusedNode := nil; // not sure if this should be done or not
  if Parent and Assigned(Node.Parent) and (Node.Parent <> RootNode) then
    Node := Node.Parent;
  try
    BeginUpdate;
    ResetNode(Node);
    ExpandedStateRestore;
  finally
    ExpandedStateClear;
    EndUpdate;
  end;
end;

procedure TXMLTree.NewNode(Node: PVirtualNode; NewNodeType: Integer;
  Name: string = ''; Value: string = ''; Before: Boolean = False;
  AddBreak: Boolean = False; XmlNode: IXMLDOMNode = nil);
// Note: XmlNode is not the new node to be added (see below)!
var
  Temp: IXMLDOMNode;
begin
  Assert(Assigned(Node), 'NewNode: Node must not be nil.');
  if not Assigned(XmlNode) then XmlNode := GetData(Node).XmlNode;
  if NewNodeType = ntAttribute then begin Before := False; AddBreak := False; end
  else if NewNodeType = ntNode then NewNodeType := ntElement;

  Assert(XmlNode.nodeType in [NODE_ELEMENT, NODE_COMMENT],
    'NewNode: XmlNode has invalid type.');
  Assert(NewNodeType in [ntComment, ntText, ntAttribute, ntElement],
    'NewNode: Invalid NewNodeType.');
  Assert(Before or (XmlNode.nodeType = NODE_ELEMENT),
    'NewNode: This node cannot have children.');
  Assert((not Before) or (not Assigned(XmlNode.parentNode))
    or (XmlNode.parentNode.nodeType <> NODE_DOCUMENT),
    'NewNode: Cannot insert before the DocumentElement.');

  if (NewNodeType in [ntAttribute, ntElement]) and (Name = '') then begin
    if NewNodeType = ntAttribute then Name := 'Attribute' else Name := 'Element';
    if not InputQuery('Create new ' + Name,
      'Please enter the name for this ' + Name + ':', Name) or (Name = '') then Exit;
  end;

  with XmlNode do begin
    case NewNodeType of
      ntAttribute:
        (XmlNode as IXMLDOMElement).setAttribute(Name, Value);
      ntElement: begin
          Temp := ownerDocument.createElement(Name);
          if Value <> '' then Temp.text := Value;
          if Before then
            parentNode.insertBefore(Temp, XmlNode)
          else appendChild(Temp);
        end;
      ntComment:
        if Before then
          parentNode.insertBefore(ownerDocument.createComment(Value), XmlNode)
        else appendChild(ownerDocument.createComment(Value));
      ntText:
        if Before then
          parentNode.insertBefore(ownerDocument.createTextNode(Value), XmlNode)
        else appendChild(ownerDocument.createTextNode(Value));
    end;
    if AddBreak then
      if Before then
        parentNode.insertBefore(ownerDocument.createTextNode(#13#10), XmlNode)
      else appendChild(ownerDocument.createTextNode(#13#10));
  end;

  if not Before then Expanded[Node] := True;
  RefreshNode(Node, True);
end;

function TXMLTree.GetXmlStr(XmlNode: IXMLDOMNode): string;
var
  J: Integer;
begin
  Assert(Assigned(XmlNode), 'GetXml: XmlNode must not be nil.');
  Result := XmlNode.xml;
  for J := 0 to FXmlNamespaces.Count - 1 do
    Result := StringReplace(Result,
      ' xmlns:' + Trim(FXmlNamespaces[J]) + '="dummy"', '', [rfReplaceAll]);
end;

function TXMLTree.GetNodeXml(Node: PVirtualNode): string;
begin
  Assert(Assigned(Node) and (GetData(Node).XmlNode.nodeType = NODE_ELEMENT),
    'GetNodeXml: Node must be an Element.');
  Result := GetXmlStr(GetData(Node).XmlNode);
end;

procedure TXMLTree.SetNodeXml(Node: PVirtualNode; const Value: string);
// Note: Raises an exception when the Xml contains errors.
var
  NewXmlDoc: IXMLDOMDocument;
  NewXmlNode: IXMLDOMNode;
  P: PNodeData;
begin
  Assert(Assigned(Node) and (GetData(Node).XmlNode.nodeType = NODE_ELEMENT),
    'SetNodeXml: Node must be an Element.');
  NewXmlDoc := ParseXml(Value);
  if not Assigned(NewXmlDoc) then
    raise Exception.Create('Parse Error: No Rootnode!');
  try
    P := GetData(Node);
    NewXmlNode := NewXmlDoc.documentElement.cloneNode(True);
    P.XmlNode.parentNode.replaceChild(NewXmlNode, P.XmlNode);
    P.XmlNode := NewXmlNode;
    P.XmlPath := GetXmlPath(NewXmlNode);
    RefreshNode(Node, False);
  finally
    NewXmlDoc := nil;
  end;
end;

function TXMLTree.GetOptions: TStringTreeOptions;
begin
  Result := inherited TreeOptions as TStringTreeOptions;
end;

procedure TXMLTree.SetOptions(const Value: TStringTreeOptions);
begin
  inherited TreeOptions.Assign(Value);
end;

function TXMLTree.GetOptionsClass: TTreeOptionsClass;
begin
  Result := TStringTreeOptions;
end;

end.

