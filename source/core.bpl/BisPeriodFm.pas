unit BisPeriodFm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls, Spin,
  BisFm, BisControls;

type
  TBisPeriodType=(ptYear,ptQuarter,ptMonth,ptDay,ptInterval);

  TBisPeriodForm = class(TBisForm)
    RadioButtonQuarter: TRadioButton;
    RadioButtonMonth: TRadioButton;
    RadioButtonDay: TRadioButton;
    RadioButtonInterval: TRadioButton;
    EditQuarter: TEdit;
    UpDownQuarter: TUpDown;
    EditMonth: TEdit;
    UpDownMonth: TUpDown;
    DateTimePickerDay: TDateTimePicker;
    RadioButtonYear: TRadioButton;
    EditYear: TEdit;
    UpDownYear: TUpDown;
    PanelButton: TPanel;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    PanelPeriod: TPanel;
    RadioButtonIntervalDate: TRadioButton;
    DateTimePickerEnd: TDateTimePicker;
    ComboBoxPeriod: TComboBox;
    RadioButtonIntervalPeriod: TRadioButton;
    LabelBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    procedure UpDownQuarterChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure EditQuarterChange(Sender: TObject);
    procedure RadioButtonQuarterClick(Sender: TObject);
    procedure UpDownMonthChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure EditMonthChange(Sender: TObject);
    procedure UpDownYearChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure RadioButtonIntervalDateClick(Sender: TObject);
  private
    CurQuarter: Word;
    CurQuarterYear: Word;
    CurMonth: Word;
    CurMonthYear: Word;
    isChangeQuarter: Boolean;
    isChangeMonth: Boolean;
    FSQuarter: String;
    FSMonth: String;
    FSOneDay: String;
    FSThreeDays: String;
    FSTwoDays: String;
    FSFourDays: String;
    FSFiveDays: String;
    FSSixDays: String;
    FSOneWeek: String;
    FSTwoWeeks: String;
    FSThreeWeeks: String;
    FSFourWeeks: String;
    FSOneMonth: String;
    FSTwoMonths: String;
    FSThreeMonths: String;
    FSFourMonths: String;
    FSFiveMonths: String;
    FSSixMonths: String;
    FSSevenMonths: String;
    FSEightMonths: String;
    FSNineMonths: String;
    FSTenMonths: String;
    FSElevenMonths: String;
    FSOneYear: String;
    FSTwoYears: String;
    FSThreeYears: String;
    FSFiveYears: String;
    FSSixYears: String;
    FSSevenYears: String;
    FSEightYears: String;
    FSNineYears: String;
    FSTenYears: String;
    FSFourYears: String;
    procedure SetQuarterInc(IncDec: Integer);
    procedure SetMonthInc(IncDec: Integer);
    procedure SetPeriod(PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate);
    procedure GetPeriod(var PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    function Select(var PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate): Boolean;
  published
    property SQuarter: String read FSQuarter write FSQuarter;
    property SMonth: String read FSMonth write FSMonth;
    property SOneDay: String read FSOneDay write FSOneDay;
    property STwoDays: String read FSTwoDays write FSTwoDays;
    property SThreeDays: String read FSThreeDays write FSThreeDays;
    property SFourDays: String read FSFourDays write FSFourDays;
    property SFiveDays: String read FSFiveDays write FSFiveDays;
    property SSixDays: String read FSSixDays write FSSixDays;
    property SOneWeek: String read FSOneWeek write FSOneWeek;
    property STwoWeeks: String read FSTwoWeeks write FSTwoWeeks;
    property SThreeWeeks: String read FSThreeWeeks write FSThreeWeeks;
    property SFourWeeks: String read FSFourWeeks write FSFourWeeks;
    property SOneMonth: String read FSOneMonth write FSOneMonth;
    property STwoMonths: String read FSTwoMonths write FSTwoMonths;
    property SThreeMonths: String read FSThreeMonths write FSThreeMonths;
    property SFourMonths: String read FSFourMonths write FSFourMonths;
    property SFiveMonths: String read FSFiveMonths write FSFiveMonths;
    property SSixMonths: String read FSSixMonths write FSSixMonths;
    property SSevenMonths: String read FSSevenMonths write FSSevenMonths;
    property SEightMonths: String read FSEightMonths write FSEightMonths;
    property SNineMonths: String read FSNineMonths write FSNineMonths;
    property STenMonths: String read FSTenMonths write FSTenMonths;
    property SElevenMonths: String read FSElevenMonths write FSElevenMonths;
    property SOneYear: String read FSOneYear write FSOneYear;
    property STwoYears: String read FSTwoYears write FSTwoYears;
    property SThreeYears: String read FSThreeYears write FSThreeYears;
    property SFourYears: String read FSFourYears write FSFourYears;
    property SFiveYears: String read FSFiveYears write FSFiveYears;
    property SSixYears: String read FSSixYears write FSSixYears;
    property SSevenYears: String read FSSevenYears write FSSevenYears;
    property SEightYears: String read FSEightYears write FSEightYears;
    property SNineYears: String read FSNineYears write FSNineYears;
    property STenYears: String read FSTenYears write FSTenYears;       
  end;

  TBisPeriodFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
    function Select(var PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate): Boolean;
  end;

var
  BisPeriodForm: TBisPeriodForm;

implementation

uses DateUtils,
     BisUtils;

{$R *.DFM}

{ TBisPeriodFormIface }

constructor TBisPeriodFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisPeriodForm;
end;

function TBisPeriodFormIface.Select(var PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate): Boolean;
var
  AForm: TBisPeriodForm;
begin
  Result:=false;
  AForm:=TBisPeriodForm(CreateForm);
  if Assigned(AForm) then begin
    try
      AForm.Init;
      BeforeFormShow;
      Result:=AForm.Select(PeriodType,DateBegin,DateEnd);
    finally
      Forms.Remove(AForm);
    end;
  end;
end;

{ TBisPeriodForm }

constructor TBisPeriodForm.Create(AOwner: TComponent);
var
  Year,Month,Day: Word;
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  isChangeQuarter:=true;
  isChangeMonth:=true;
  DecodeDate(Now,Year,Month,Day);

  UpDownYear.Position:=Year;

  CurQuarterYear:=Year;
  if (Month mod 3)<>0 then
    CurQuarter:=(Month div 3)+1
  else CurQuarter:=(Month div 3);

  CurMonthYear:=Year;
  CurMonth:=Month;

  DateTimePickerDay.Time:=StrToTime('0:00:00');
  DateTimePickerDay.date:=Date;

  DateTimePickerBegin.Time:=StrToTime('0:00:00');
  DateTimePickerBegin.date:=Date;

  DateTimePickerEnd.Time:=StrToTime('0:00:00');
  DateTimePickerEnd.date:=Date;

  RadioButtonInterval.Checked:=true;

  FSQuarter:='%d квартал %d г.';
  FSMonth:='%s %d г.';

  FSOneDay:='1 день';
  FSTwoDays:='2 дн€';
  FSThreeDays:='3 дн€';
  FSFourDays:='4 дн€';
  FSFiveDays:='5 дней';
  FSSixDays:='6 дней';
  FSOneWeek:='1 недел€';
  FSTwoWeeks:='2 недели';
  FSThreeWeeks:='3 недели';
  FSFourWeeks:='4 недели';
  FSOneMonth:='1 мес€ц';
  FSTwoMonths:='2 мес€ца';
  FSThreeMonths:='3 мес€ца';
  FSFourMonths:='4 мес€ца';
  FSFiveMonths:='5 мес€цев';
  FSSixMonths:='6 мес€цев';
  FSSevenMonths:='7 мес€цев';
  FSEightMonths:='8 мес€цев';
  FSNineMonths:='9 мес€цев';
  FSTenMonths:='10 мес€цев';
  FSElevenMonths:='11 мес€цев';
  FSOneYear:='1 год';
  FSTwoYears:='2 года';
  FSThreeYears:='3 года';
  FSFourYears:='4 года';
  FSFiveYears:='5 лет';
  FSSixYears:='6 лет';
  FSSevenYears:='7 лет';
  FSEightYears:='8 лет';
  FSNineYears:='9 лет';
  FSTenYears:='10 лет';

end;

procedure TBisPeriodForm.Init;
var
  OldIndex: Integer;
begin
  inherited Init;
  OldIndex:=ComboBoxPeriod.ItemIndex;
  try
    ComboBoxPeriod.Items.Strings[0]:=FSOneDay;
    ComboBoxPeriod.Items.Strings[1]:=FSTwoDays;
    ComboBoxPeriod.Items.Strings[2]:=FSThreeDays;
    ComboBoxPeriod.Items.Strings[3]:=FSFourDays;
    ComboBoxPeriod.Items.Strings[4]:=FSFiveDays;
    ComboBoxPeriod.Items.Strings[5]:=FSSixDays;
    ComboBoxPeriod.Items.Strings[6]:=FSOneWeek;
    ComboBoxPeriod.Items.Strings[7]:=FSTwoWeeks;
    ComboBoxPeriod.Items.Strings[8]:=FSThreeWeeks;
    ComboBoxPeriod.Items.Strings[9]:=FSFourWeeks;
    ComboBoxPeriod.Items.Strings[10]:=FSOneMonth;
    ComboBoxPeriod.Items.Strings[11]:=FSTwoMonths;
    ComboBoxPeriod.Items.Strings[12]:=FSThreeMonths;
    ComboBoxPeriod.Items.Strings[13]:=FSFourMonths;
    ComboBoxPeriod.Items.Strings[14]:=FSFiveMonths;
    ComboBoxPeriod.Items.Strings[15]:=FSSixMonths;
    ComboBoxPeriod.Items.Strings[16]:=FSSevenMonths;
    ComboBoxPeriod.Items.Strings[17]:=FSEightMonths;
    ComboBoxPeriod.Items.Strings[18]:=FSNineMonths;
    ComboBoxPeriod.Items.Strings[19]:=FSTenMonths;
    ComboBoxPeriod.Items.Strings[20]:=FSElevenMonths;
    ComboBoxPeriod.Items.Strings[21]:=FSOneYear;
    ComboBoxPeriod.Items.Strings[22]:=FSTwoYears;
    ComboBoxPeriod.Items.Strings[23]:=FSThreeYears;
    ComboBoxPeriod.Items.Strings[24]:=FSFourYears;
    ComboBoxPeriod.Items.Strings[25]:=FSFiveYears;
    ComboBoxPeriod.Items.Strings[26]:=FSSixYears;
    ComboBoxPeriod.Items.Strings[27]:=FSSevenYears;
    ComboBoxPeriod.Items.Strings[28]:=FSEightYears;
    ComboBoxPeriod.Items.Strings[29]:=FSNineYears;
    ComboBoxPeriod.Items.Strings[30]:=FSTenYears;
  finally
    ComboBoxPeriod.ItemIndex:=OldIndex;
  end;
end;

function TBisPeriodForm.Select(var PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate): Boolean;
begin
  SetPeriod(PeriodType,DateBegin,DateEnd);
  BorderStyle:=bsDialog;
  Result:=ShowModal=mrOk;
  if Result then
     GetPeriod(PeriodType,DateBegin,DateEnd);
end;


procedure TBisPeriodForm.SetPeriod(PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate);
var
  Year,Month,Day: Word;
begin
  if DateBegin=0 then
    DateBegin:=Date;
  DecodeDate(DateBegin,Year,Month,Day);
  case PeriodType of
    ptQuarter: begin
      CurQuarterYear:=Year;
      if (Month mod 3)<>0 then
        CurQuarter:=(Month div 3)+1
      else CurQuarter:=(Month div 3);
      SetQuarterInc(0);
      RadioButtonQuarter.Checked:=true;
    end;
    ptMonth: begin
      CurMonthYear:=Year;
      CurMonth:=Month;
      SetMonthInc(0);
      RadioButtonMonth.Checked:=true;
    end;
    ptDay: begin
      DateTimePickerDay.DateTime:=DateBegin;
      RadioButtonDay.Checked:=true;
    end;
    ptInterval: begin
      DateTimePickerBegin.DateTime:=DateBegin;
      DateTimePickerEnd.DateTime:=DateEnd;
      RadioButtonInterval.Checked:=true;
    end;
    ptYear: begin
      UpDownYear.Position:=Year;
      RadioButtonYear.Checked:=true;
    end;
  end;
  isChangeQuarter:=false;
  isChangeMonth:=false;
end;

procedure TBisPeriodForm.GetPeriod(var PeriodType: TBisPeriodType; var DateBegin, DateEnd: TDate);
var
  Year,Month,Day: Word;
  DBegin,DEnd: TDateTime;
begin
  if RadioButtonQuarter.Checked then begin
    Year:=CurQuarterYear;
    Month:=CurQuarter+2*(CurQuarter-1);
    Day:=1;
    DBegin:=EncodeDate(Year,Month,Day)+EncodeTime(0,0,0,0);
    DEnd:=IncMonth(DBegin,3)-1+EncodeTime(23,59,59,0);
    DateBegin:=DBegin;
    DateEnd:=DEnd;
    PeriodType:=ptQuarter;
    exit;
  end;
  if RadioButtonMonth.Checked then begin
    Year:=CurMonthYear;
    Month:=CurMonth;
    Day:=1;
    DBegin:=EncodeDate(Year,Month,Day)+EncodeTime(0,0,0,0);
    DEnd:=IncMonth(DBegin,1)-1+EncodeTime(23,59,59,0);
    DateBegin:=DBegin;
    DateEnd:=DEnd;
    PeriodType:=ptMonth;
    exit;
  end;
  if RadioButtonDay.Checked then begin
    DBegin:=DateTimePickerDay.date+EncodeTime(0,0,0,0);
    DEnd:=DateTimePickerDay.date+EncodeTime(23,59,59,0);
    DateBegin:=DBegin;
    DateEnd:=DEnd;
    PeriodType:=ptDay;
    exit;
  end;
  if RadioButtonInterval.Checked then begin
    DBegin:=DateTimePickerBegin.date+EncodeTime(0,0,0,0);
    DEnd:=DateTimePickerEnd.date+EncodeTime(23,59,59,0);
    if RadioButtonIntervalPeriod.Checked then begin
      case ComboBoxPeriod.ItemIndex of
        0..5: DEnd:=IncDay(DBegin,ComboBoxPeriod.ItemIndex+1);
        6..9: DEnd:=IncWeek(DBegin,ComboBoxPeriod.ItemIndex-5);
        10..20: DEnd:=IncMonth(DBegin,ComboBoxPeriod.ItemIndex-9);
        21..30: DEnd:=IncYear(DBegin,ComboBoxPeriod.ItemIndex-20);
      end;
    end;
    DateBegin:=DBegin;
    DateEnd:=DEnd;
    PeriodType:=ptInterval;
    exit;
  end;
  if RadioButtonYear.Checked then begin
    DBegin:=EncodeDate(UpDownYear.Position,1,1)+EncodeTime(0,0,0,0);
    DEnd:=IncMonth(DBegin,12)-1+EncodeTime(23,59,59,0);
    DateBegin:=DBegin;
    DateEnd:=DEnd;
    PeriodType:=ptYear;
    exit;
  end;
end;

procedure TBisPeriodForm.UpDownQuarterChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  AllowChange:=false;
  case Direction of
    updUp: begin
     SetQuarterInc(1);
    end;
    updDown: begin
     SetQuarterInc(-1);
    end;
  end;
end;

procedure TBisPeriodForm.SetQuarterInc(IncDec: Integer);
begin
  if ((CurQuarter+IncDec)<=4)and((CurQuarter+IncDec)>0) then begin
    CurQuarter:=CurQuarter+IncDec;
  end else begin
    if ((CurQuarter+IncDec)>4) then begin
      CurQuarter:=1;
      CurQuarterYear:=CurQuarterYear+1;
    end;
    if ((CurQuarter+IncDec)<=0)then begin
      CurQuarter:=4;
      CurQuarterYear:=CurQuarterYear-1;
    end;
  end;
  EditQuarter.Text:=FormatEx(FSQuarter,[CurQuarter,CurQuarterYear]);
  if EditQuarter.CanFocus and Visible then
    EditQuarter.SetFocus;
  EditQuarter.SelectAll;
end;

procedure TBisPeriodForm.EditQuarterChange(Sender: TObject);
begin
  if not isChangeQuarter then begin
    isChangeQuarter:=true;
    EditQuarter.Text:=FormatEx(FSQuarter,[CurQuarter,CurQuarterYear]);
  end;
  EditYear.SelectAll;
end;

procedure TBisPeriodForm.RadioButtonQuarterClick(Sender: TObject);
const
  clDisable=clBtnFace;
  clEnable=clWindow;
begin
  EditYear.Enabled:=false;
  EditYear.Color:=clDisable;
  UpDownYear.Enabled:=false;
  EditQuarter.Enabled:=false;
  EditQuarter.Color:=clDisable;
  UpDownQuarter.Enabled:=false;
  EditMonth.Enabled:=false;
  EditMonth.Color:=ClDisable;
  UpDownMonth.Enabled:=false;
  DateTimePickerDay.Enabled:=false;
  DateTimePickerDay.Color:=clDisable;
  LabelBegin.Enabled:=false;
  DateTimePickerBegin.Enabled:=false;
  DateTimePickerBegin.Color:=clDisable;
  RadioButtonIntervalDate.Enabled:=false;
  DateTimePickerEnd.Enabled:=false;
  DateTimePickerEnd.Color:=clDisable;
  RadioButtonIntervalPeriod.Enabled:=false;
  ComboBoxPeriod.Enabled:=false;
  ComboBoxPeriod.Color:=clDisable;

  if Sender=RadioButtonYear then begin
    EditYear.Enabled:=true;
    EditYear.Color:=clEnable;
    UpDownYear.Enabled:=true;
    exit;
  end;
  if Sender=RadioButtonQuarter then begin
    EditQuarter.Enabled:=true;
    EditQuarter.Color:=clEnable;
    UpDownQuarter.Enabled:=true;
    exit;
  end;
  if Sender=RadioButtonMonth then begin
    EditMonth.Enabled:=true;
    EditMonth.Color:=clEnable;
    UpDownMonth.Enabled:=true;
    exit;
  end;
  if Sender=RadioButtonDay then begin
    DateTimePickerDay.Enabled:=true;
    DateTimePickerDay.Color:=clEnable;
    exit;
  end;
  if Sender=RadioButtonInterval then begin
    LabelBegin.Enabled:=true;
    DateTimePickerBegin.Enabled:=true;
    DateTimePickerBegin.Color:=clEnable;
    RadioButtonIntervalDate.Enabled:=true;
    RadioButtonIntervalPeriod.Enabled:=true;
    if RadioButtonIntervalDate.Checked then begin
      DateTimePickerEnd.Enabled:=true;
      DateTimePickerEnd.Color:=clEnable;
    end else begin
      ComboBoxPeriod.Enabled:=true;
      ComboBoxPeriod.Color:=clEnable;
    end;
  end;
end;

procedure TBisPeriodForm.SetMonthInc(IncDec: Integer);
var
  monthstr: string;
begin
  if ((CurMonth+IncDec)<=12)and((CurMonth+IncDec)>0) then begin
    CurMonth:=CurMonth+IncDec;
  end else begin
    if ((CurMonth+IncDec)>12) then begin
      CurMonth:=1;
      CurMonthYear:=CurMonthYear+1;
    end;
    if ((CurMonth+IncDec)<=0)then begin
      CurMonth:=12;
      CurMonthYear:=CurMonthYear-1;
    end;
  end;
  monthstr:=LongMonthNames[CurMonth];
  EditMonth.Text:=FormatEx(FSMonth,[monthstr,CurMonthYear]);;
  if EditMonth.CanFocus and Visible then
    EditMonth.SetFocus;
  EditMonth.SelectAll;
end;

procedure TBisPeriodForm.UpDownMonthChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  AllowChange:=false;
  case Direction of
    updUp: begin
     SetMonthInc(1);
    end;
    updDown: begin
     SetMonthInc(-1);
    end;
  end;
end;

procedure TBisPeriodForm.EditMonthChange(Sender: TObject);
var
  monthstr: string;
begin
  if not isChangeMonth then begin
    isChangeMonth:=true;
    monthstr:=LongMonthNames[CurMonth];
    EditMonth.Text:=FormatEx(FSMonth,[monthstr,CurMonthYear]);;
  end;
end;

procedure TBisPeriodForm.UpDownYearChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  AllowChange:=true;
  if EditYear.CanFocus and Visible then
    EditYear.SetFocus;
end;

procedure TBisPeriodForm.RadioButtonIntervalDateClick(Sender: TObject);
begin
  DateTimePickerEnd.Enabled:=false;
  DateTimePickerEnd.Color:=clBtnFace;
  ComboBoxPeriod.Enabled:=false;
  ComboBoxPeriod.Color:=clBtnFace;
  if Sender=RadioButtonIntervalDate then begin
    DateTimePickerEnd.Enabled:=true;
    DateTimePickerEnd.Color:=clWindow;
  end;
  if Sender=RadioButtonIntervalPeriod then begin
    ComboBoxPeriod.Enabled:=true;
    ComboBoxPeriod.Color:=clWindow;
  end;
end;


end.
