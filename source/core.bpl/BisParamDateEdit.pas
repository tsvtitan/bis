unit BisParamDateEdit;

interface

uses Classes, Controls, StdCtrls, DB,
     BisParam, BisControls;

type
  TBisParamDateEdit=class(TBisParam)
  end;


{ private
    FDateEdit: TSgtsDateEdit;
    FLabelDate: TLabel;
    FDateName: String;
    FLabelName: String;
    FOldDateChange: TNotifyEvent;

    procedure DateChange(Sender: TObject);
    function ReplaceDateTimePicker(DateTimePicker: TDateTimePicker): TSgtsDateEdit;
  protected
    function GetValue: Variant; override;
    procedure SetValue(AValue: Variant); override;
    function GetEmpty: Boolean; override;
    function GetSize: Integer; override;
    procedure SetSize(ASize: Integer); override;

    property DateName: String read FDateName write FDateName;
    property LabelName: String read FLabelName write FLabelName;
  public
    procedure LinkControls(Parent: TWinControl); override;

    property DateEdit: TSgtsDateEdit read FDateEdit;
    property LabelDate: TLabel read FLabelDate;
  end;}


implementation

end.
