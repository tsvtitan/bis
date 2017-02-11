unit TAPIMediaCtl;

interface

{$INCLUDE TAPI.INC}

uses Windows, Classes, TAPI,TAPILines;

type
  TLineMediaControl = (lmcNone,lmcStart,lmcReset,lmcPause,lmcResume,lmcRateUp,
       lmcRateDown,lmcRateNormal,lmcVolumeUp,lmcVolumeDown,lmcVolumeNormal);

  TTAPIMediaControl = class(TComponent)
    FLine:TTAPILine;
  public
    //property Active:boolean read FActive write SetActive;
  published
    property Line:TTAPILine read FLine write FLine;
  end;      

implementation

end.
 