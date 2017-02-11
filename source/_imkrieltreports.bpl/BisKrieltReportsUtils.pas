unit BisKrieltReportsUtils;

interface

uses StdCtrls, ComCtrls, Windows, Controls, Variants, SysUtils, ComObj,
  ActiveX, BisProvider, BisKrieltReportsFm;

procedure SetDefaultForm(BisKrieltReportsForm: TBisKrieltReportsForm);
procedure SetFormExportInProgress(BisKrieltReportsForm: TBisKrieltReportsForm);
function GetUniqueID: String;
function OpenExcelDoc(Path: String): Variant;
procedure InsertExcelRows(Sheet: Variant; StartRow: Integer; EndRow: Integer; EndColLitter: String; InsertRow: Integer);
function CopyExcelDocToNew(SourceFileName: string; NewName: string): String;
function ConvertDateTime(Date: TDate; Note: String): String;
procedure SetProgressBarToNull(BisKrieltReportsForm: TBisKrieltReportsForm; Provider: TBisProvider);
procedure ExtendPosProgressBar(BisKrieltReportsForm: TBisKrieltReportsForm);

implementation

uses BisUtils;

procedure SetDefaultForm(BisKrieltReportsForm: TBisKrieltReportsForm);
begin
  With BisKrieltReportsForm do begin
    ExportTimer.Enabled:=True;
    AllListBox.Items.Clear;
    AddButton.Enabled:=True;
    DeleteButton.Enabled:=True;
    ClearButton.Enabled:=True;
    AllListBox.Enabled:=True;
    StartExportButton.Enabled:=True;
    RealtyTypeComboBox.Enabled:=True;
    ActionComboBox.Enabled:=True;
    ReportComboBox.Enabled:=True;
    BeginDateTimePicker.Enabled:=True;
    EndDateTimePicker.Enabled:=True;
    ActionComboBox.ItemIndex:=-1;
    RealtyTypeComboBox.ItemIndex:=-1;
    ReportComboBox.ItemIndex:=-1;
    BeginDateTimePicker.Date:=Date;
    EndDateTimePicker.Date:=Date;
    ExportProgressBar.Position:=0;
    ExportRecordsLabel.Caption:='��������������:';
    AllRecordsLabel.Caption:='����� �������:';
    Height:=375;
    StartExportButton.Enabled:=False;
    Update;
  end;
end;

procedure SetFormExportInProgress(BisKrieltReportsForm: TBisKrieltReportsForm);
begin
  with BisKrieltReportsForm do begin
    ExportTimer.Enabled:=False;
    AddButton.Enabled:=False;
    DeleteButton.Enabled:=False;
    ClearButton.Enabled:=False;
    AllListBox.Enabled:=False;
    StartExportButton.Enabled:=False;
    RealtyTypeComboBox.Enabled:=False;
    ActionComboBox.Enabled:=False;
    ReportComboBox.Enabled:=False;
    BeginDateTimePicker.Enabled:=False;
    EndDateTimePicker.Enabled:=False;
    Update;
  end;
end;

function GetUniqueID: String;
begin
  Result:=BisUtils.GetUniqueId;
end;

function OpenExcelDoc(Path: String): Variant;
var Excel: Variant;
begin
  Excel:=CreateOleObject('Excel.Application');
  Excel.Workbooks.Open[Path];
  OpenExcelDoc:=Excel;
end;

procedure InsertExcelRows(Sheet: Variant; StartRow: Integer; EndRow: Integer; EndColLitter: String; InsertRow: Integer);
var St:string;
  I, H, Num: Integer;
  RCopy, RInsert: Variant;
begin
 St:='A'+IntToStr(StartRow)+':'+EndColLitter+IntToStr(EndRow);
 RCopy:=Sheet.Range[St,EmptyParam];
 St:='A'+IntToStr(InsertRow)+':'+EndColLitter+IntToStr(InsertRow+(EndRow-StartRow));
 RInsert:=Sheet.Range[St,EmptyParam];
 RCopy.Copy(RInsert);

 Num:=0;
 For I:=StartRow To EndRow Do Begin
   H:=Sheet.Rows[I].RowHeight;
   Sheet.Rows[Num+InsertRow].RowHeight:=H;
   Num:=Num+1;
 End;
end;

function CopyExcelDocToNew(SourceFileName: string; NewName: string): String;
var EXEPath, XLSSource, XLSNew: String;
  D: TDate;
begin
  EXEPath:=ExtractFilePath(paramstr(0));
//  EXEPath:=Copy(EXEPath,1,Length(EXEPath)-4);
  XLSSource:=EXEPath+'patterns\'+SourceFileName;
  D:=Date;
  XLSNew:=EXEPath+'results\'+NewName+'_'+DateToStr(D)+'_'+GetUniqueID+'.xls';
  CopyFile(PAnsiChar(XLSSource),PAnsiChar(XLSNew),True);
  CopyExcelDocToNew:=XLSNew;
end;

function ConvertDateTime(Date: TDate; Note: String):String;
var SDate, Y, M, D: String;
begin
  SDate:=DateToStr(Date);
  Y:=Copy(SDate,7,4);
  M:=Copy(SDate,4,2);
  D:=Copy(SDate,1,2);
  if Note='Begin' then
    SDate:=Y+'-'+M+'-'+D+' 00:00:00';
  if Note='End' then
    SDate:=Y+'-'+M+'-'+D+' 23:59:59';
  ConvertDateTime:=SDate;
end;

procedure SetProgressBarToNull(BisKrieltReportsForm: TBisKrieltReportsForm; Provider: TBisProvider);
begin
  with BisKrieltReportsForm do begin
    ExportProgressBar.Min:=0;
    ExportProgressBar.Max:=Provider.RecordCount;
    ExportProgressBar.Position:=0;
    ExportRecordsLabel.Caption:='��������������: 0';
    AllRecordsLabel.Caption:='����� �������: '+IntToStr(ExportProgressBar.Max);
    Update;
  end;
end;

procedure ExtendPosProgressBar(BisKrieltReportsForm: TBisKrieltReportsForm);
begin
  with BisKrieltReportsForm do begin
      ExportProgressBar.Position:=ExportProgressBar.Position+1;
      ExportRecordsLabel.Caption:='��������������: '+IntToStr(ExportProgressBar.Position);
      Update;
    end;
end;

end.