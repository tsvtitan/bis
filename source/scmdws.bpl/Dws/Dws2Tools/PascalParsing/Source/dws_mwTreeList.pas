{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: mwTreeList.pas, released March 20, 2000.

The Initial Developer of the Original Code is Martin Waldenburg
(Martin.Waldenburg@T-Online.de).
Portions created by Martin Waldenburg are Copyright (C) 2000 Martin
Waldenburg.
All Rights Reserved.

Contributor(s): _______________________________________________________________.

Last Modified: mm/dd/yyyy
Current Version: 1.0

Notes: 

Modification history:

Known Issues:
-----------------------------------------------------------------------------}

unit dws_mwTreeList;

interface

uses
  SysUtils, Classes, 
  TypInfo,  // MAE 10/31/2002 - Added TypInfo for helper functions
  dws_mwSimplePasParTypes;  // MAE 07/04/2003 - Removed/merged TmwPasCodeInfo to types unit

type
  TmwCodeTree = class;

  TmwCC = packed record
    Count: Word;
    Capacity: Word;
    CodeInfo: Word;
    StartLineNumber: Word;
    StartLinePosition: Word;
    EndLineNumber: Word;
    EndLinePosition: Word;
  end;

  PmwItemList = ^TmwItemList;
  TmwItemList = array[0..0] of TmwCodeTree;

  TmwCodeTree = class(TPersistent)
  private
    fItemList: PmwItemList;
    FData: string;
    fParent: TmwCodeTree;
    procedure SetCount(const Value: Word);
    function GetCodeInfo: TmwPasCodeInfo;
    procedure SetCodeInfo(const Value: TmwPasCodeInfo);
    function GetNodes(Index: Word): TmwCodeTree;
    procedure SetNodes(Index: Word; const Value: TmwCodeTree);
    function GetStartLineNumber: Word;
    function GetStartLinePosition: Word;
    procedure SetStartLineNumber(const Value: Word);
    procedure SetStartLinePosition(const Value: Word);
    function GetEndLineNumber: Word;
    function GetEndLinePosition: Word;
    procedure SetEndLineNumber(const Value: Word);
    procedure SetEndLinePosition(const Value: Word);
  protected
    CC: TmwCC;
    procedure DisposeItems(Index, aCount: Word);
    procedure DisposeListItem(Index: Word);
    procedure Expand;
    function GetCapacity: Integer;
    function GetCount: Word;
    procedure SetCapacity(NewCapacity: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const Value: TmwCodeTree): Integer;
    procedure Clear;
    procedure Delete(Index: Word);
    procedure Insert(Index: Word; const Value: TmwCodeTree);
    function IndexOf(CodeTree: TmwCodeTree): Integer; //MAE 11/2/2002
    property Count: Word read GetCount write SetCount;
    property CodeInfo: TmwPasCodeInfo read GetCodeInfo write SetCodeInfo;
    property EndLineNumber: Word read GetEndLineNumber write SetEndLineNumber;
    property EndLinePosition: Word read GetEndLinePosition write SetEndLinePosition;
    property ItemList: PmwItemList read fItemList;
    property StartLineNumber: Word read GetStartLineNumber write SetStartLineNumber;
    property StartLinePosition: Word read GetStartLinePosition write SetStartLinePosition;
    property Data: string read FData write fData;
    property Nodes[Index: Word]: TmwCodeTree read GetNodes write SetNodes;
    property Parent: TmwCodeTree read fParent write FParent;
  end;

//MAE 10/31/2002 - Added helper functions
function CodeInfoName(Value: TmwPasCodeInfo): string;
function ciCodeInfoName(Value: TmwPasCodeInfo): string;

implementation

function CodeInfoName(Value: TmwPasCodeInfo): string;
begin //MAE 10/31/2002
  Result := Copy(ciCodeInfoName(Value), 3, MaxInt);
end;

function ciCodeInfoName(Value: TmwPasCodeInfo): string;
begin //MAE 10/31/2002
  result := GetEnumName(TypeInfo(TmwPasCodeInfo), Integer(Value));
end;

{ TmwCodeTree }

function TmwCodeTree.Add(const Value: TmwCodeTree): Integer;
begin
  Result := CC.Count;
  if CC.Count = CC.Capacity then Expand;
  Value.Parent := Self;
  fItemList^[Result] := Value;
  inc(CC.Count);
end;

procedure TmwCodeTree.Clear;
begin
  if CC.Capacity = 0 then exit;
  SetCapacity(0);
end;

constructor TmwCodeTree.Create;
begin
  inherited Create;
end;

procedure TmwCodeTree.Delete(Index: Word);
begin
  if Index < CC.Count then
  begin
    DisposeListItem(Index);
    Dec(CC.Count);
    if Index < CC.Count then
      System.Move(fItemList^[Index + 1], fItemList^[Index],
        (CC.Count - Index) * SizeOf(TmwCodeTree));
    SetCapacity(CC.Count);
  end;
end;

destructor TmwCodeTree.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TmwCodeTree.DisposeItems(Index, aCount: Word);
var
  I: Integer;
begin
  for I := Index to Index + aCount - 1 do DisposeListItem(I);
end;

procedure TmwCodeTree.DisposeListItem(Index: Word);
begin
  fItemList^[Index].Free;
end;

procedure TmwCodeTree.Expand;
var
  Delta: Word;
begin
  Delta := 1;
  if CC.Count > 100 then Delta := CC.Count div 50;
  SetCapacity(CC.Count + Delta);
end;

function TmwCodeTree.GetCapacity: Integer;
begin
  Result := CC.Capacity;
end;

function TmwCodeTree.GetCodeInfo: TmwPasCodeInfo;
begin
  Result := TmwPasCodeInfo(CC.CodeInfo);
end;

function TmwCodeTree.GetCount: Word;
begin
  Result := CC.Count;
end;

function TmwCodeTree.GetEndLineNumber: Word;
begin
  Result := CC.EndLineNumber;
end;

function TmwCodeTree.GetEndLinePosition: Word;
begin
  Result := CC.EndLinePosition;
end;

function TmwCodeTree.GetStartLineNumber: Word;
begin
  Result := CC.StartLineNumber;
end;

function TmwCodeTree.GetStartLinePosition: Word;
begin
  Result := CC.StartLinePosition;
end;

function TmwCodeTree.GetNodes(Index: Word): TmwCodeTree;
begin
  Result := nil;
  if Index < CC.Count then Result := fItemList^[Index];
end;

procedure TmwCodeTree.Insert(Index: Word; const Value: TmwCodeTree);
begin
  if CC.Count = CC.Capacity then Expand;
  if Index < CC.Count then
    System.Move(fItemList^[Index], fItemList^[Index + 1],
      (CC.Count - Index) * SizeOf(TmwCodeTree));
  Value.Parent := Self;
  fItemList^[Index] := Value;
  inc(CC.Count);
end;

procedure TmwCodeTree.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity <> CC.Capacity then
  begin
    if NewCapacity < CC.Count then
    begin
      DisposeItems(NewCapacity, CC.Count - NewCapacity);
      CC.Count := NewCapacity;
    end;
    ReallocMem(fItemList, NewCapacity * SizeOf(Self.ClassType));//MAE 10/31/2002 TmwCodeTree));
    CC.Capacity := NewCapacity;
  end;
end;

procedure TmwCodeTree.SetCodeInfo(const Value: TmwPasCodeInfo);
begin
  CC.CodeInfo := Word(Value);
end;

procedure TmwCodeTree.SetCount(const Value: Word);
begin
  CC.Count := Value;
end;

procedure TmwCodeTree.SetStartLineNumber(const Value: Word);
begin
  CC.StartLineNumber := Value;
end;

procedure TmwCodeTree.SetStartLinePosition(const Value: Word);
begin
  CC.StartLinePosition := Value;
end;

procedure TmwCodeTree.SetNodes(Index: Word; const Value: TmwCodeTree);
begin
  if Index < CC.Count then
    if Assigned(fItemList^[Index]) then fItemList^[Index].Free;
  Value.Parent := Self;
  fItemList^[Index] := Value;
end;

procedure TmwCodeTree.SetEndLineNumber(const Value: Word);
begin
  CC.EndLineNumber := Value;
end;

procedure TmwCodeTree.SetEndLinePosition(const Value: Word);
begin
  CC.EndLinePosition := Value;
end;

function TmwCodeTree.IndexOf(CodeTree: TmwCodeTree): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if Nodes[i] = CodeTree then
    begin
      Result := i;
      Break;
    end;
end;

end.

