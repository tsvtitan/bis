unit VSTEdit;

// MF Editors link component for VirtualStringTree
// Version 1.0.2 Beta
// Copyright (c) 2001 Manfred Fuchs
// Manfred@Fuchsrudel.de
//
// This software is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied.
//
//----------------------------------------------------------------------------------------------------------------------
//
// 02-JUN-2001:
//   - compatibility with VST 2.4.20
//
// 08-MAY-2001:
//   - compatibility with VST 2.4
//
// 30-APR-2001:
//   - added ComboEditor
//   - dropped OnNewData event (now OnNewText of VST will be fired)
//   - Escape and OnEditCancelled bug fixed
//   - bug fixes
//
// 27-APR-2001:
//   - first beta release
//
//----------------------------------------------------------------------------------------------------------------------

interface

uses
  Windows, SysUtils, Forms, Classes, Messages, Graphics, Controls,
   StdCtrls, ExtCtrls, ComCtrls, CommCtrl, Menus, Buttons, Dialogs, Mask, Math,
   VirtualTrees, MFEdit;

type
  TVSTEditorType     = (etNone,
                        etEditor,           // TMFEdit
                        etButtonEditor,     // TMFButtonEdit
                        etComboEditor,      // TMFComboEdit
                        etNumEditor,        // TMFNumEdit
                        etCurrencyEditor,   //          TMFCurrencyEdit
                        etDateTimeEditor,   // TMFDateTimeEdit
                        etFilenameEditor,   //          TMFFilenameEdit
                        etDirectoryEditor,  //          TMFDirectoryEdit
                        etColorEditor,      //          TMFColorEdit
                        etFontEditor        //          TMFFontEdit
                       );

  TVSTEditor = class;

  TVSTEditorLink = class(TInterfacedObject, IVTEditLink)
  private
    FEditorLink  : TVSTEditor;
    FEdit        : TWinControl;
    FEditType    : TVSTEditorType;
    FTree        : TCustomVirtualStringTree;
    FNode        : PVirtualNode;
    FColumn      : Integer;
    FOldEditProc : TWndMethod;
    FStopping    : Boolean;
    FHasModified : Boolean;

  protected
    procedure EditChange(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditWindowProc(var Message: TMessage);

  public
    constructor Create;
    destructor  Destroy; override;

    function  BeginEdit: Boolean; stdcall;
    function  CancelEdit: Boolean; stdcall;
    function  EndEdit: Boolean; stdcall;
    function  GetBounds: TRect; stdcall;
    function  PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;

    property EditorLink : TVSTEditor               read FEditorLink write FEditorLink;
    property EditType   : TVSTEditorType           read FEditType   write FEditType;

    property Tree       : TCustomVirtualStringTree read FTree;
    property Node       : PVirtualNode             read FNode;
    property Column     : Integer                  read FColumn;
  end;

// ****************************************************************************

  TVSTEditor = class(TComponent)
  protected
    FLink                 : TVSTEditorLink;

    FEditor               : TMFEdit;
    FButtonEditor         : TMFButtonEdit;
    FComboEditor          : TMFComboEdit;
    FNumEditor            : TMFNumEdit;
    FDateTimeEditor       : TMFDateTimeEdit;

    FEditorParent         : TWinControl;
    FButtonEditorParent   : TWinControl;
    FComboEditorParent    : TWinControl;
    FNumEditorParent      : TWinControl;
    FDateTimeEditorParent : TWinControl;

    procedure SetEditor(Value: TMFEdit);
    procedure SetButtonEditor(Value: TMFButtonEdit);
    procedure SetComboEditor(Value: TMFComboEdit);
    procedure SetNumEditor(Value: TMFNumEdit);
    procedure SetDateTimeEditor(Value: TMFDateTimeEdit);
    procedure SetLink(Value: TVSTEditorLink);

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LinkEditor(var EditLink: IVTEditLink; Text: String);
    procedure LinkButtonEditor(var EditLink: IVTEditLink; Text: String);
    procedure LinkComboEditor(var EditLink: IVTEditLink; Text: String);
    procedure LinkNumEditor(var EditLink: IVTEditLink; Value: Double);
    procedure LinkDateTimeEditor(var EditLink: IVTEditLink; Date, Time: TDateTime);

    property Link           : TVSTEditorLink             read FLink           write SetLink;

  published
    property Editor         : TMFEdit                    read FEditor         write SetEditor;
    property ButtonEditor   : TMFButtonEdit              read FButtonEditor   write SetButtonEditor;
    property ComboEditor    : TMFComboEdit               read FComboEditor    write SetComboEditor;
    property NumEditor      : TMFNumEdit                 read FNumEditor      write SetNumEditor;
    property DateTimeEditor : TMFDateTimeEdit            read FDateTimeEditor write SetDateTimeEditor;
  end;

procedure Register;

implementation

//{$R *.dcr}

constructor TVSTEditorLink.Create;
begin
    inherited Create;

    FEditorLink  := nil;
    FEditType    := etNone;
    FHasModified := False;
end;

destructor TVSTEditorLink.Destroy;
begin
    if Assigned( FEditorLink ) then
        FEditorLink.Link := nil;
    FEditorLink := nil;
    FEdit       := nil;

    inherited;
end;

function TVSTEditorLink.BeginEdit: Boolean;
begin
    Result := not FStopping;
    if Result then
    begin
        FEdit.Show;
//        FEdit.SelectAll;
        FEdit.SetFocus;
        FOldEditProc     := FEdit.WindowProc;
        FEdit.WindowProc := EditWindowProc;
    end;
end;

function TVSTEditorLink.CancelEdit: Boolean;
begin
    Result := not FStopping;
    if Result then
    begin
        FStopping        := True;
        FEdit.WindowProc := FOldEditProc;
        FEdit.Hide;
        FTree.CancelEditNode;
    end;
end;

procedure TVSTEditorLink.EditWindowProc(var Message: TMessage);
begin
    case Message.Msg of
        WM_KILLFOCUS:
        begin
            if FEdit is TMFButtonEdit then
            begin
                if not TMFButtonEdit( FEdit ).DroppedDown then
                    FTree.EndEditNode;
            end
            else
                if FEdit is TMFComboEdit then
                begin
                    if not TMFComboEdit( FEdit ).DroppedDown then
                        FTree.EndEditNode;
                end
                else
                    if FEdit is TMFNumEdit then
                    begin
                        if not TMFNumEdit( FEdit ).DroppedDown then
                            FTree.EndEditNode;
                    end
                    else
                        if FEdit is TMFDateTimeEdit then
                        begin
                            if not TMFDateTimeEdit( FEdit ).DroppedDown then
                                FTree.EndEditNode;
                        end
                        else
                            FTree.EndEditNode;
        end;
    else
      begin
        FOldEditProc( Message );
      end;
    end;
end;

procedure TVSTEditorLink.EditChange(Sender: TObject);
begin
    FHasModified := True;
end;

procedure TVSTEditorLink.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
    CanAdvance : Boolean;
begin
    case Key of
        VK_RETURN,
        VK_ESCAPE,
        VK_UP,
        VK_DOWN:
        begin
            // consider special cases before finishing edit mode
            CanAdvance := Shift = [];
            if FEdit is TMFButtonEdit then
                CanAdvance := CanAdvance and not TMFButtonEdit( FEdit ).DroppedDown;
            if FEdit is TMFComboEdit then
                CanAdvance := CanAdvance and not TMFComboEdit( FEdit ).DroppedDown;
            if FEdit is TMFNumEdit then
                CanAdvance := CanAdvance and not TMFNumEdit( FEdit ).DroppedDown;
            if FEdit is TMFDateTimeEdit then
                CanAdvance := CanAdvance and not TMFDateTimeEdit( FEdit ).DroppedDown;

            if CanAdvance then
            begin
                if Key = VK_ESCAPE then
                    FTree.CancelEditNode
                else
                begin
                    FTree.EndEditNode;
                    with FTree do
                    begin
                        if Key = VK_UP then
                        FocusedNode := GetPreviousVisible( FocusedNode )
                    else
                        FocusedNode           := GetNextVisible( FocusedNode );
                        Selected[FocusedNode] := True;
                    end;
                end;
                Key := 0;
            end;
        end;
    end;
end;

function TVSTEditorLink.EndEdit: Boolean;
begin
    Result := not FStopping;
    if Result then
    begin
        FStopping        := True;
        FEdit.WindowProc := FOldEditProc;
        if FHasModified then
        begin
            case FEditType of
                etEditor:
                begin
                    FTree.Text[FNode, FColumn] := TMFEdit( FEdit ).Text;
                end;
                etButtonEditor:
                begin
                    FTree.Text[FNode, FColumn] := TMFButtonEdit( FEdit ).Text;
                end;
                etComboEditor:
                begin
                    FTree.Text[FNode, FColumn] := TMFComboEdit( FEdit ).Text;
                end;
                etNumEditor:
                begin
                    FTree.Text[FNode, FColumn] := TMFNumEdit( FEdit ).Text;
                end;
                etDateTimeEditor:
                begin
                    case TMFDateTimeEdit( FEdit ).Kind of
                        dtkDate:
                            FTree.Text[FNode, FColumn] := DateToStr( TMFDateTimeEdit( FEdit ).Date );
                        dtkTime:
                            FTree.Text[FNode, FColumn] := TimeToStr( TMFDateTimeEdit( FEdit ).Time );
                    end;
                end;
            end;
            FHasModified := False;
        end;
        FEdit.Hide;
        FTree.EndEditNode;
    end;
end;

function TVSTEditorLink.GetBounds: TRect;
begin
    Result := FEdit.BoundsRect;
end;

function TVSTEditorLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
begin
    Result := not FStopping;
    if Result then
    begin
        FTree   := Tree as TCustomVirtualStringTree;
        FNode   := Node;
        FColumn := Column;

        // determine what edit type actually is needed
        FEdit.Free;
        FEdit := nil;

        case FEditType of
            etNone:
            begin
                Result := False;
                Exit;
            end;
            etEditor:
            begin
                if not Assigned( FEditorLink.FEditor ) then
                begin
                    Result := False;
                    Exit;
                end;
                FEdit := FEditorLink.FEditor;
                with FEdit as TMFEdit do
                begin
                    Visible        := False;
                    Parent         := Tree;

//                    EditStyle      := esCtl2D;

                    OnChange       := EditChange;
                    OnKeyDown      := EditKeyDown;
                end;
            end;
            etButtonEditor:
            begin
                if not Assigned( FEditorLink.FButtonEditor ) then
                begin
                    Result := False;
                    Exit;
                end;
                FEdit := FEditorLink.FButtonEditor;
                with FEdit as TMFButtonEdit do
                begin
                    Visible        := False;
                    Parent         := Tree;

//                    EditStyle      := esCtl2D;

                    OnChange       := EditChange;
                    OnKeyDown      := EditKeyDown;
                end;
            end;
            etComboEditor:
            begin
                if not Assigned( FEditorLink.FComboEditor ) then
                begin
                    Result := False;
                    Exit;
                end;
                FEdit := FEditorLink.FComboEditor;
                with FEdit as TMFComboEdit do
                begin
                    Visible        := False;
                    Parent         := Tree;

//                    EditStyle      := esCtl2D;

                    OnChange       := EditChange;
                    OnKeyDown      := EditKeyDown;
                end;
            end;
            etNumEditor:
            begin
                if not Assigned( FEditorLink.FNumEditor ) then
                begin
                    Result := False;
                    Exit;
                end;
                FEdit := FEditorLink.FNumEditor;
                with FEdit as TMFNumEdit do
                begin
                    Visible        := False;
                    Parent         := Tree;

//                    EditStyle      := esCtl2D;

                    OnChange       := EditChange;
                    OnKeyDown      := EditKeyDown;
                end;
            end;
            etDateTimeEditor:
            begin
                if not Assigned( FEditorLink.FDateTimeEditor ) then
                begin
                    Result := False;
                    Exit;
                end;
                FEdit := FEditorLink.FDateTimeEditor;
                with FEdit as TMFDateTimeEdit do
                begin
                    Visible        := False;
                    Parent         := Tree;

//                    EditStyle      := esCtl2D;

                    OnChange       := EditChange;
                    OnKeyDown      := EditKeyDown;
                end;
            end;
        else
            Result := False;
        end;
    end;
end;

procedure TVSTEditorLink.ProcessMessage(var Message: TMessage); stdcall;
begin
    FEdit.WindowProc(Message);
end;

procedure TVSTEditorLink.SetBounds(R: TRect);
begin
    Inc( R.Left, 6 );
    FEdit.BoundsRect := R;
end;

// ****************************************************************************

constructor TVSTEditor.Create(AOwner: TComponent);
begin
    inherited Create( AOwner );

    FLink := nil;
end;

destructor TVSTEditor.Destroy;
begin
    inherited;
end;

procedure TVSTEditor.LinkEditor(var EditLink: IVTEditLink; Text: String);
begin
    FLink            := TVSTEditorLink.Create;
    FLink.EditorLink := Self;
    FLink.EditType   := etEditor;
    EditLink         := FLink;

    if Assigned( FEditor ) then
        FEditor.Text := Text;
end;

procedure TVSTEditor.LinkButtonEditor(var EditLink: IVTEditLink; Text: String);
begin
    FLink            := TVSTEditorLink.Create;
    FLink.EditorLink := Self;
    FLink.EditType   := etButtonEditor;
    EditLink         := FLink;

    if Assigned( FButtonEditor ) then
        FButtonEditor.Text := Text;
end;

procedure TVSTEditor.LinkComboEditor(var EditLink: IVTEditLink; Text: String);
begin
    FLink            := TVSTEditorLink.Create;
    FLink.EditorLink := Self;
    FLink.EditType   := etComboEditor;
    EditLink         := FLink;

    if Assigned( FComboEditor ) then
        if FComboEditor.Style = csDropDownList then
            FComboEditor.ItemIndex := FComboEditor.Items.IndexOf( Text )
        else
            FComboEditor.Text := Text;
end;

procedure TVSTEditor.LinkNumEditor(var EditLink: IVTEditLink; Value: Double);
begin
    FLink            := TVSTEditorLink.Create;
    FLink.EditorLink := Self;
    FLink.EditType   := etNumEditor;
    EditLink         := FLink;

    if Assigned( FNumEditor ) then
        FNumEditor.Value := Value;
end;

procedure TVSTEditor.LinkDateTimeEditor(var EditLink: IVTEditLink; Date, Time: TDateTime);
begin
    FLink            := TVSTEditorLink.Create;
    FLink.EditorLink := Self;
    FLink.EditType   := etDateTimeEditor;
    EditLink         := FLink;

    if Assigned( FDateTimeEditor ) then
    begin
        FDateTimeEditor.Date := Date;
        FDateTimeEditor.Time := Time;
    end;
end;

procedure TVSTEditor.SetEditor(Value: TMFEdit);
begin
    if FEditor <> Value then
    begin
        FEditor := Value;
        if Assigned( FEditor ) then
            FEditorParent := FEditor.Parent
        else
            FEditorParent := nil;
    end;
end;

procedure TVSTEditor.SetButtonEditor(Value: TMFButtonEdit);
begin
    if FButtonEditor <> Value then
    begin
        FButtonEditor := Value;
        if Assigned( FButtonEditor ) then
            FButtonEditorParent := FButtonEditor.Parent
        else
            FButtonEditorParent := nil;
    end;
end;

procedure TVSTEditor.SetComboEditor(Value: TMFComboEdit);
begin
    if FComboEditor <> Value then
    begin
        FComboEditor := Value;
        if Assigned( FComboEditor ) then
            FComboEditorParent := FComboEditor.Parent
        else
            FComboEditorParent := nil;
    end;
end;

procedure TVSTEditor.SetNumEditor(Value: TMFNumEdit);
begin
    if FNumEditor <> Value then
    begin
        FNumEditor := Value;
        if Assigned( FNumEditor ) then
            FNumEditorParent := FNumEditor.Parent
        else
            FNumEditorParent := nil;
    end;
end;

procedure TVSTEditor.SetDateTimeEditor(Value: TMFDateTimeEdit);
begin
    if FDateTimeEditor <> Value then
    begin
        FDateTimeEditor := Value;
        if Assigned( FDateTimeEditor ) then
            FDateTimeEditorParent := FDateTimeEditor.Parent
        else
            FDateTimeEditorParent := nil;
    end;
end;

procedure TVSTEditor.SetLink(Value: TVSTEditorLink);
begin
    if Assigned( FLink ) and Assigned( Value ) then
    begin
        ShowMessage( 'TVSTEditor: Failure in SetLink (must be nil)!' );
        Exit;
    end;
    if not Assigned( FLink ) and not Assigned( Value ) then
    begin
        ShowMessage( 'TVSTEditor: Failure in SetLink (must not be nil)!' );
        Exit;
    end;
    if FLink <> Value then
    begin
        if Assigned( FLink ) then
        begin
            case FLink.EditType of
                etEditor:
                    FEditor.Parent         := FEditorParent;
                etButtonEditor:
                    FButtonEditor.Parent   := FButtonEditorParent;
                etComboEditor:
                    FComboEditor.Parent    := FComboEditorParent;
                etNumEditor:
                    FNumEditor.Parent      := FNumEditorParent;
                etDateTimeEditor:
                    FDateTimeEditor.Parent := FDateTimeEditorParent;
            end;
        end;
        FLink := Value;
        if Assigned( FLink ) then
        begin
            FEditorParent         := FEditor.Parent;
            FButtonEditorParent   := FButtonEditor.Parent;
            FComboEditorParent    := FComboEditor.Parent;
            FNumEditorParent      := FNumEditor.Parent;
            FDateTimeEditorParent := FDateTimeEditor.Parent;
        end;
    end;
end;

// ****************************************************************************

procedure Register;
begin
    RegisterComponents('Virtual Controls', [TVSTEditor]);
end;

end.
