unit BisExecuteOptionsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls,
  BisOptionsFrm, BisControls;

type
  TBisExecuteOptionsFrame = class(TBisOptionsFrame)
    CheckBoxAutoStart: TCheckBox;
    EditAutoStartTime: TEdit;
    LabelAutoStartTime: TLabel;
    UpDownAutoStart: TUpDown;
    CheckBoxAutoExit: TCheckBox;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

implementation

{$R *.dfm}

{ TBisExecuteOptionsFrame }

constructor TBisExecuteOptionsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Caption:='dfgdfg';
end;

destructor TBisExecuteOptionsFrame.Destroy;
begin

  inherited Destroy;
end;

end.