unit mainframe;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TDialFrm = class(TFrame)
    LineMemo: TMemo;
    PhoneEdit: TEdit;
    CallBtn: TSpeedButton;
    HangUpBtn: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SBtn1: TSpeedButton;
    SBtn2: TSpeedButton;
    SBtn3: TSpeedButton;
    SBtn6: TSpeedButton;
    SBtn5: TSpeedButton;
    SBtn4: TSpeedButton;
    ConferenceBtn: TBitBtn;
    TransferBtn: TBitBtn;
    HoldBtn: TBitBtn;
    TransferEdit: TEdit;
    RecordBtn: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
