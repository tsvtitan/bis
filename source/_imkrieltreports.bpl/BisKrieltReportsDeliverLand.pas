unit BisKrieltReportsDeliverLand;

interface

uses Controls, BisProvider, BisKrieltReportsUtils, BisFilterGroups, SysUtils,
  BisKrieltReportsFm;

procedure ExportDeliverLandKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverLandOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverLandOutPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);

implementation

procedure ExportDeliverLandKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_LAND_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('��������');              
    AddInvisible('�������');              
    AddInvisible('����������');              
    AddInvisible('����������');              
    AddInvisible('����');              
    AddInvisible('�����');              
    AddInvisible('���������� �����');              
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('deliver_land_krs.xls','����_�����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('�������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,4,4,'L',LastRow);
      Sheet.Range['A'+IntToStr(LastRow)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,5,5,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportDeliverLandOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_LAND_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');   
    AddInvisible('�������');   
    AddInvisible('����������');   
    AddInvisible('����������');   
    AddInvisible('����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('deliver_land_others.xls','����_�����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('�������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportDeliverLandOutPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_LAND_OUT_POINT_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����������');   
    AddInvisible('�������');   
    AddInvisible('����������');   
    AddInvisible('����������');   
    AddInvisible('����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('deliver_land_out_point.xls','����_�����_��_�����������_��������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('�������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

end.
