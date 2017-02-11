unit BisBase64;

interface

function Base64ToStr(S: String): String;
function StrToBase64(S: String): String;

implementation

uses DIMime;

function Base64ToStr(S: String): String;
begin
  try
    Result:=MimeDecodeString(S);
  except
  end;
end;

function StrToBase64(S: String): String;
begin
  try
    Result:=MimeEncodeStringNoCRLF(S);
  except
  end;
end;


end.
