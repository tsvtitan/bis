unit BisSipUtils;

interface

function GetBranch: String;
function GetTag: String;

implementation

uses BisUtils, BisCrypter;

function GetBranch: String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.HashString(GetUniqueID,haCRC32,hfHEX);
    Result:='z9hG4bK'+Result;
  finally
    Crypter.Free;
  end;
end;

function GetTag: String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.HashString(GetUniqueID,haCRC32,hfHEX);
  finally
    Crypter.Free;
  end;
end;

end.
