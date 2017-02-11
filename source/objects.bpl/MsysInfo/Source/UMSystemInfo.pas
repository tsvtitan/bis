unit UMSystemInfo;

interface

uses Classes;

type
  TFuck=class(TPersistent)
  published
    function GetSystemInfo: string; virtual; abstract;
  end;

implementation

end.
