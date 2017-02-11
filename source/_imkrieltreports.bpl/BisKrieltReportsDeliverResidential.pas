unit BisKrieltReportsDeliverResidential;

interface

uses Controls, BisProvider, BisKrieltReportsUtils, BisFilterGroups, SysUtils,
  BisKrieltReportsFm;

procedure ExportDeliverApartmentsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverApartmentsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverHousesCottagesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverHousesCottagesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverTownHousesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverOutsideHousesCottages(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportDeliverDatchas(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);

implementation

procedure ExportDeliverApartmentsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow, Code, RoomInt: Integer;
  Excel, Sheet: Variant;
  Region, Room, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_APARTMENTS_KRS_EXPORT';      

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
    AddInvisible('����������');              
    AddInvisible('����');           
    AddInvisible('�����');              
    AddInvisible('���������� �����');               
    AddInvisible('����');                
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('����');               
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('deliver_apartments_krs.xls','����_��������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';
  Room:=Provider.FieldByName('����').AsString;
  Val(Room,RoomInt,Code);

  if Length(Room)=0 then begin
    Sheet.Range['C1']:='';
    Sheet.Range['A4']:='';
  end;
  if (Code=0) Or (Room='1,5') then begin
    Sheet.Range['C1']:='�������� '+Room+'-���������';
    Sheet.Range['A4']:=Room+'-���������';
  end;
  if Room='�' then begin
    Sheet.Range['C1']:='��������';
    Sheet.Range['A4']:='��������';
  end;
  if Room='�������' then begin
    Sheet.Range['C1']:='�������';
    Sheet.Range['A4']:='�������';
  end;
  if Room='�' then begin
    Sheet.Range['C1']:='���������';
    Sheet.Range['A4']:='���������';
  end;

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A5']:=Region;
  LastRow:=8;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;

    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;
    if (Provider.FieldByName('����').AsString<>Room) then Begin
      Room:=Provider.FieldByName('����').AsString;
      Region:=Provider.FieldByName('�����').AsString;

      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow+3);
      InsertExcelRows(Sheet,1,1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow+1);
      InsertExcelRows(Sheet,5,5,'L',LastRow+2);

      Sheet.Range['A'+IntToStr(LastRow)]:='���� � ������ �����';
      Val(Room,RoomInt,Code);
      if Length(Room)=0 then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='';
      end;
      if (Code=0) Or (Room='1,5') then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='�������� '+Room+'-���������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:=Room+'-���������';
      end;
      if Room='�' then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='��������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='��������';
      end;
      if Room='�������' then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='�������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='�������';
      end;
      if Room='�' then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='���������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='���������';
      end;

      Sheet.Range['A'+IntToStr(LastRow+2)]:=Region;
      LastRow:=LastRow+4;
    End;
    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,5,5,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,6,6,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Sheet.Rows[LastRow-1].Clear;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportDeliverApartmentsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow, Code, RoomInt: Integer;
  Excel, Sheet: Variant;
  Room, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_APARTMENTS_OTHERS_EXPORT';      

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
    AddInvisible('����������');              
    AddInvisible('����');               
    AddInvisible('����');                
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('����');               
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('deliver_arartments_others.xls','����_��������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';
  Room:=Provider.FieldByName('����').AsString;
  Val(Room,RoomInt,Code);

  if Length(Room)=0 then begin
    Sheet.Range['C1']:='';
    Sheet.Range['A4']:='';
  end;
  if (Code=0) Or (Room='1,5') then begin
    Sheet.Range['C1']:='�������� '+Room+'-���������';
    Sheet.Range['A4']:=Room+'-���������';
  end;
  if Room='�' then begin
    Sheet.Range['C1']:='��������';
    Sheet.Range['A4']:='��������';
  end;
  if Room='�������' then begin
    Sheet.Range['C1']:='�������';
    Sheet.Range['A4']:='�������';
  end;
  if Room='�' then begin
    Sheet.Range['C1']:='���������';
    Sheet.Range['A4']:='���������';
  end;

  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;
    if (Provider.FieldByName('����').AsString<>Room) then Begin
      Room:=Provider.FieldByName('����').AsString;

      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow+2);
      InsertExcelRows(Sheet,1,1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow+1);

      Sheet.Range['A'+IntToStr(LastRow)]:='���� � ������ �����';
      Val(Room,RoomInt,Code);
      if Length(Room)=0 then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='';
      end;
      if (Code=0) Or (Room='1,5') then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='�������� '+Room+'-���������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:=Room+'-���������';
      end;
      if Room='�' then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='��������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='��������';
      end;
      if Room='�������' then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='�������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='�������';
      end;
      if Room='�' then begin
        Sheet.Range['C'+IntToStr(LastRow)]:='���������';
        Sheet.Range['A'+IntToStr(LastRow+1)]:='���������';
      end;

      LastRow:=LastRow+3;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Sheet.Rows[LastRow-1].Clear;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportDeliverHousesCottagesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_HOUSES_COTTAGES_KRS_EXPORT';      

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

  XLSNew:=CopyExcelDocToNew('deliver_houses_cottages_krs.xls','����_����,_��������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';
  Sheet.Range['C1']:='������� ����, ��������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverHousesCottagesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_HOUSES_COTTAGES_OTHERS_EXPORT';      

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

  XLSNew:=CopyExcelDocToNew('deliver_houses_cottages_others.xls','����_����,_��������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';
  Sheet.Range['C1']:='������� ����, ��������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverTownHousesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_TOWN_HOUSES_KRS_EXPORT';      

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

  XLSNew:=CopyExcelDocToNew('deliver_town_houses_krs.xls','����_���������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';
  Sheet.Range['C1']:='���������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverOutsideHousesCottages(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_OUTSIDE_HOUSES_EXPORT';      

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
    AddInvisible('����������');   
    AddInvisible('����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('deliver_outside_houses.xls','����_����������_����,_��������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';
  Sheet.Range['C1']:='���������� ����, ��������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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

procedure ExportDeliverDatchas(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_DELIVER_DATCHAS_EXPORT';      

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
    AddInvisible('����������');   
    AddInvisible('����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('deliver_datchas.xls','����_����');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='���� � ������ �����';
  Sheet.Range['C1']:='����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
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