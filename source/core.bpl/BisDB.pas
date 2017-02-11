unit BisDB;

interface

uses Classes, StdCtrls, DB;

type
  TBlobField=class(DB.TBlobField)
  protected
    function GetClassDesc: String; override;
  end;

implementation

uses Windows;


{ TBlobField }

function TBlobField.GetClassDesc: String;
var
  S: String;
const
  MaxLen=100;  
begin
  if Assigned(DataSet) and not DataSet.IsEmpty then
    if IsNull then
      Result:='NULL'
    else begin
      S:=AsString;
      Result:=Copy(S,1,MaxLen);
      if Length(S)>MaxLen then
        Result:=Result+'...';
    end;
end;


function TBlobField_NewInstance(AClass: TClass): TObject;
begin
  Result := TBlobField.NewInstance;
end;

function GetVirtualMethod(AClass: TClass; const VmtOffset: Integer): Pointer;
begin
  Result := PPointer(Integer(AClass) + VmtOffset)^;
end;

procedure SetVirtualMethod(AClass: TClass; const VmtOffset: Integer; const Method: Pointer);
var
  WrittenBytes: DWORD;
  PatchAddress: PPointer;
begin
  PatchAddress := Pointer(Integer(AClass) + VmtOffset);
  WriteProcessMemory(GetCurrentProcess, PatchAddress, @Method, SizeOf(Method), WrittenBytes);
end;

{$IFOPT W+}{$DEFINE WARN}{$ENDIF}{$WARNINGS OFF} // no compiler warning
const
  vmtNewInstance = System.vmtNewInstance;
{$IFDEF WARN}{$WARNINGS ON}{$ENDIF}

var
  OrgTBlobField_NewInstance: Pointer;

initialization
  OrgTBlobField_NewInstance := GetVirtualMethod(TBlobField, vmtNewInstance);
  SetVirtualMethod(DB.TBlobField, vmtNewInstance, @TBlobField_NewInstance);

finalization
  SetVirtualMethod(DB.TBlobField, vmtNewInstance, OrgTBlobField_NewInstance);

end.
