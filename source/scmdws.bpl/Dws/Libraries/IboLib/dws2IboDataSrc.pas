{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 1, 2001                                                   }
{                                                                      }
{    http://www.dwscript.com                                           }
{                                                                      }
{    The Initial Developers of the Original Code are Matthias          }
{    Ackermann and hannes hernler.                                     }
{    Portions created by Matthias Ackermann are Copyright (C) 2001     }
{    Matthias Ackermann, Switzerland. All Rights Reserved.             }
{    Portions created by hannes hernler are Copyright (C) 2001         }
{    hannes hernler, Austria. All Rights Reserved.                     }
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2IboDataSrc;

interface

uses
  SysUtils, Classes, dws2Comp, dws2Symbols, dws2IboModule,
  IB_components, IB_StoredProc;

type
  Tdws2IboDataSrc = class(TComponent)
  private
    { Private-Deklarationen }
    FIBOStatement: TIB_Statement;
    FIBOLib: Tdws2IboLib;

    FDeclaration: string;
    function AllCompAssigned: boolean;
    procedure SetIBOLib(AdwsLib: Tdws2IboLib);
    function GetIBOStatement: TIB_Statement;
    procedure SetIBOStatement(AStatement: TIB_Statement);
    procedure AddPredefDataset;
    procedure RemovePredefDataset;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    dwsIBOStatementObj: TdwsIBOStatementObj;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitScriptInstance(var ExtObject: TObject);
  published
    property Declaration: string read FDeclaration write FDeclaration;
    property IBOLib: Tdws2IboLib read FIBOLib write SetIBOLib;
    property IBOStatement: TIB_Statement read GetIBOStatement write SetIBOStatement;
  end;

  Tdws2IboDataBase = class(TComponent)
  private
    { Private-Deklarationen }
    FDataBase: TIB_Connection;
    FIBOLib: Tdws2IboLib;
    FDeclaration: string;
    function AllCompAssigned: boolean;
    procedure SetIBOLib(AdwsLib: Tdws2IboLib);
    function GetIBOConnection: TIB_Connection;
    procedure SetIBOConnection(AConnection: TIB_Connection);
    procedure AddPredefDataBase;
    procedure RemovePredefDataBase;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    dwsIboDataBaseObj: TdwsIboDataBaseObj;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitScriptInstance(var ExtObject: TObject);
  published
    property Declaration: string read FDeclaration write FDeclaration;
    property IBOLib: Tdws2IboLib read FIBOLib write SetIBOLib;
    property DataBase: TIB_Connection read GetIBOConnection write SetIBOConnection;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2IboDataSrc]);
  RegisterComponents('DWS2', [Tdws2IboDataBase]);
end;

// --------------------------------------------------------------
// -----------------   Tdws2IboDataSrc    ---------------------
// --------------------------------------------------------------

constructor Tdws2IboDataSrc.Create(AOwner: TComponent);
begin
  inherited;
  dwsIBOStatementObj := TdwsIBOStatementObj.Create;
end;

destructor Tdws2IboDataSrc.Destroy;
begin
  RemovePredefDataset;
  if assigned(dwsIBOStatementObj) then
  begin
    dwsIBOStatementObj.IBOStatement := nil;
    dwsIBOStatementObj.Free;
  end;
  inherited;
end;

function Tdws2IboDataSrc.AllCompAssigned: boolean;
begin
  result := Assigned(FIBOLib) and Assigned(FIBOStatement);
end;

procedure Tdws2IboDataSrc.InitScriptInstance(var ExtObject: TObject);
begin
  FIBOStatement.prepare;
  dwsIBOStatementObj.IBOStatement := FIBOStatement;
  ExtObject := dwsIBOStatementObj;
end;

procedure Tdws2IboDataSrc.AddPredefDataset;
var
  PredefDataset: Tdws2Instance;
begin
  if AllCompAssigned and not (csDesigning in ComponentState) then
  begin
    PredefDataset := Tdws2Instance(FIBOLib.customIBOUnit.Instances.Add);
    if (FIBOStatement is TIB_Query) then
      PredefDataset.DataType := 'TQuery'
    else  if (FIBOStatement is TIB_StoredProc) then
    begin
      if TIB_StoredProc(FIBOStatement).StoredProcForSelect then
        PredefDataset.DataType := 'TDataSet'
      else
        PredefDataset.DataType := 'TStatement';
    end
    else if (FIBOStatement is TIB_DataSet) then
      PredefDataset.DataType := 'TDataSet'
    else if (FIBOStatement is TIB_Statement) then
      PredefDataset.DataType := 'TStatement';

    PredefDataset.Name := Declaration;
    PredefDataset.AutoInstantiate := true;
    PredefDataset.AutoDestroyExternalObject := false;
    PredefDataset.OnInstantiate := InitScriptInstance;
  end;
end;

procedure Tdws2IboDataSrc.RemovePredefDataset;
var
  i: Integer;
begin
  if AllCompAssigned and not (csDesigning in ComponentState) then
    with FIBOLib.customIBOUnit.Variables do
    begin
      for i := 0 to count - 1 do
      begin
        if Tdws2Global(items[i]).name = Declaration then
        begin
          delete(i);
          exit;
        end;
      end;
    end;
end;

procedure Tdws2IboDataSrc.SetIBOLib(AdwsLib: Tdws2IBOLib);
begin
  if AdwsLib <> FIBOLib then
  begin
    //    if Assigned(FIBOLib) then
    //      FIBOLib.RemoveFreeNotification(Self);
    if Assigned(AdwsLib) then
      AdwsLib.FreeNotification(Self);
    RemovePredefDataset;
    FIBOLib := AdwsLib;
    AddPredefDataset;
  end;
end;

procedure Tdws2IboDataSrc.SetIBOStatement(AStatement: TIB_Statement);
begin
  if AStatement <> FIBOStatement then
  begin
    //    if Assigned(FIBOStatement) then
    //      FIBOStatement.RemoveFreeNotification(Self);
    //    if Assigned(AStatement) then
    //      AStatement.FreeNotification(Self);
    RemovePredefDataset;
    FIBOStatement := AStatement;
    AddPredefDataset;
  end;
end;

function Tdws2IboDataSrc.GetIBOStatement: TIB_Statement;
begin
  Result := FIBOStatement;
end;

procedure Tdws2IboDataSrc.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  // The FIBOStatement object notifies us that it's going to be removed
  if (Operation = opRemove) and (AComponent = FIBOStatement) then
    SetIBOStatement(nil);
  if (Operation = opRemove) and (AComponent = FIBOLib) then
    SetIBOLib(nil);
end;

// --------------------------------------------------------------
// -----------------   Tdws2IboDataBase  ---------------------
// --------------------------------------------------------------

constructor Tdws2IboDataBase.Create(AOwner: TComponent);
begin
  inherited;
  dwsIboDataBaseObj := TdwsIboDataBaseObj.Create;
end;

destructor Tdws2IboDataBase.Destroy;
begin
  RemovePredefDataBase;
  if assigned(dwsIboDataBaseObj) then
  begin
    dwsIboDataBaseObj.IBOConnection := nil;
    dwsIboDataBaseObj.free;
  end;
  inherited;
end;

function Tdws2IboDataBase.AllCompAssigned: boolean;
begin
  result := Assigned(FIBOLib) and Assigned(FDataBase);
end;

procedure Tdws2IboDataBase.InitScriptInstance(var ExtObject: TObject);
begin
  FDataBase.Connect;
  dwsIboDataBaseObj.IBOConnection := FDataBase;
  ExtObject := dwsIboDataBaseObj;
end;

procedure Tdws2IboDataBase.AddPredefDataBase;
var
  PredefDataBase: Tdws2Instance;
begin
  if AllCompAssigned and not (csDesigning in ComponentState) then
  begin
    PredefDataBase := Tdws2Instance(FIBOLib.customIBOUnit.Instances.Add);
    PredefDataBase.DataType := 'TDataBase';
    PredefDataBase.Name := Declaration;
    PredefDataBase.AutoInstantiate := true;
    PredefDataBase.AutoDestroyExternalObject := false;
    PredefDataBase.OnInstantiate := InitScriptInstance;
  end;
end;

procedure Tdws2IboDataBase.RemovePredefDataBase;
var
  i: Integer;
begin
  if assigned(FIBOLib) and not (csDesigning in ComponentState) then
    with FIBOLib.customIBOUnit.Variables do
    begin
      for i := 0 to count - 1 do
      begin
        if Tdws2Global(items[i]).name = Declaration then
        begin
          delete(i);
          exit;
        end;
      end;
    end;
end;

procedure Tdws2IboDataBase.SetIBOLib(AdwsLib: Tdws2IboLib);
begin
  if AdwsLib <> FIBOLib then
  begin
    //    if Assigned(FIBOLib) then
    //      FIBOLib.RemoveFreeNotification(Self);
    if Assigned(AdwsLib) then
      AdwsLib.FreeNotification(Self);
    RemovePredefDataBase;
    FIBOLib := AdwsLib;
    AddPredefDataBase;
  end;
end;

procedure Tdws2IboDataBase.SetIBOConnection(AConnection: TIB_Connection);
begin
  if AConnection <> FDataBase then
  begin
    //    if Assigned(FDataBase) then
    //      FDataBase.RemoveFreeNotification(Self);
    //    if Assigned(AConnection) then
    //      AConnection.FreeNotification(Self);
    //    RemovePredefDataset;
    FDataBase := AConnection;
    AddPredefDataBase;
  end;
end;

function Tdws2IboDataBase.GetIBOConnection: TIB_Connection;
begin
  Result := FDataBase;
end;

procedure Tdws2IboDataBase.Notification(AComponent: TComponent; Operation: TOperation);
begin
  // The FIBOConnection object notifies us that it's going to be removed
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataBase) then
    SetIBOConnection(nil);
  if (Operation = opRemove) and (AComponent = FIBOLib) then
    SetIBOLib(nil);
end;

end.

