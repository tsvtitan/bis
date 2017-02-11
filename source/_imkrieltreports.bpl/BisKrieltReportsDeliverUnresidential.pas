unit BisKrieltReportsDeliverUnresidential;

interface

uses Controls, BisProvider, BisKrieltReportsUtils, BisFilterGroups, SysUtils,
  BisKrieltReportsFm;

procedure ExportDeliverOfficesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverOfficesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverTradePremisesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverTradePremisesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverBasesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverBasesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverBuildingsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverBuildingsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverRestaurantsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverRestaurantsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverProductionsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverProductionsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverGaragesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverGaragesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverFreePurposeKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverFreePurposeOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);

implementation

procedure ExportDeliverOfficesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_OFFICES_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
    AddInvisible('��������� �������');              
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

  XLSNew:=CopyExcelDocToNew('deliver_offices_krs.xls','����_�����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='�����';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������� �������').AsString;
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

procedure ExportDeliverOfficesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_OFFICES_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
    AddInvisible('��������� �������');   
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

  XLSNew:=CopyExcelDocToNew('deliver_offices_others.xls','����_�����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='�����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������� �������').AsString;
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

procedure ExportDeliverTradePremisesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_TRADE_PREMISES_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
    AddInvisible('��������� �������');              
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

  XLSNew:=CopyExcelDocToNew('deliver_trade_premises_krs.xls','����_��������_���������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='�������� ���������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������� �������').AsString;
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

procedure ExportDeliverTradePremisesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_TRADE_PREMISES_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
    AddInvisible('��������� �������');   
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

  XLSNew:=CopyExcelDocToNew('deliver_trade_premises_others.xls','����_��������_���������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='�������� ���������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������� �������').AsString;
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

procedure ExportDeliverBasesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_BASES_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
    AddInvisible('�������');              
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

  XLSNew:=CopyExcelDocToNew('deliver_bases_krs.xls','����_������,_����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='������, ����';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('�������').AsString;
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

procedure ExportDeliverBasesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_BASES_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
    AddInvisible('�������');   
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

  XLSNew:=CopyExcelDocToNew('deliver_bases_others.xls','����_������,_����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='������, ����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('�������').AsString;
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

procedure ExportDeliverBuildingsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_BUILDINGS_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
    AddInvisible('��������� �������');              
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

  XLSNew:=CopyExcelDocToNew('deliver_buildings_krs.xls','����_������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������� �������').AsString;
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

procedure ExportDeliverBuildingsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_BUILDINGS_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
    AddInvisible('��������� �������');   
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

  XLSNew:=CopyExcelDocToNew('deliver_buildings_others.xls','����_������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['E1']:='������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������� �������').AsString;
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

procedure ExportDeliverRestaurantsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_RESTAURANTS_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
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

  XLSNew:=CopyExcelDocToNew('deliver_restaurants_krs.xls','����_���������,_����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='���������, ����';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverRestaurantsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_RESTAURANTS_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
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

  XLSNew:=CopyExcelDocToNew('deliver_restaurants_others.xls','����_���������,_����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='���������, ����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverProductionsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_PRODUCTIONS_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
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

  XLSNew:=CopyExcelDocToNew('deliver_productions_krs.xls','����_������������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='������������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverProductionsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_PRODUCTIONS_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
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

  XLSNew:=CopyExcelDocToNew('deliver_productions_others.xls','����_������������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='������������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverGaragesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_GARAGES_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
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

  XLSNew:=CopyExcelDocToNew('deliver_garages_krs.xls','����_������,_�����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverGaragesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_GARAGES_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
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

  XLSNew:=CopyExcelDocToNew('deliver_garages_others.xls','����_������,_�����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverFreePurposeKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_FREE_PURPOSE_KRS_EXPORT';      

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
    AddInvisible('��, �2');              
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

  XLSNew:=CopyExcelDocToNew('deliver_free_purpose_krs.xls','����_����������_����������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='��������� ����������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverFreePurposeOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_FREE_PURPOSE_OTHERS_EXPORT';      

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
    AddInvisible('��, �2');   
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

  XLSNew:=CopyExcelDocToNew('deliver_free_purpose_others.xls','����_����������_����������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �������';
  Sheet.Range['D1']:='��������� ����������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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
