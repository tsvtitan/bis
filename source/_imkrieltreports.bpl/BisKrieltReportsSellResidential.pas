unit BisKrieltReportsSellResidential;

interface

uses Controls, BisProvider, BisKrieltReportsUtils, BisFilterGroups, SysUtils,
  BisKrieltReportsFm;

procedure ExportSellApartmentsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellApartmentsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellHousesCottagesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellHousesCottagesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellTownHousesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellOutsideHouses(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellDatchas(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);

implementation

procedure ExportSellApartmentsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow, Code, RoomInt: Integer;
  Excel, Sheet: Variant;
  Region, Room, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_APARTMENTS_KRS_EXPORT';

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('����');               
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('����.');              
    AddInvisible('����');               
    AddInvisible('���');                
    AddInvisible('���');                
    AddInvisible('��, �2');             
    AddInvisible('�������');            
    AddInvisible('������');             
    AddInvisible('������� �������');    
    AddInvisible('����');               
    AddInvisible('���������� �����');   
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

  XLSNew:=CopyExcelDocToNew('sell_apartments_krs.xls','������_��������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, ������� �����';
  Room:=Provider.FieldByName('����').AsString;
  Val(Room,RoomInt,Code);

  if Length(Room)=0 then begin
    Sheet.Range['I1']:='';
    Sheet.Range['A4']:='';
  end;
  if (Code=0) Or (Room='1,5') then begin
    Sheet.Range['I1']:='�������� '+Room+'-���������';
    Sheet.Range['A4']:=Room+'-���������';
  end;
  if Room='�' then begin
    Sheet.Range['I1']:='��������';
    Sheet.Range['A4']:='��������';
  end;
  if Room='�������' then begin
    Sheet.Range['I1']:='�������';
    Sheet.Range['A4']:='�������';
  end;
  if Room='�' then begin
    Sheet.Range['I1']:='���������';
    Sheet.Range['A4']:='���������';
  end;

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A5']:=Region;
  LastRow:=9;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-3)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-3)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-3)]:=Provider.FieldByName('����.').AsString;
    Sheet.Range['D'+IntToStr(LastRow-3)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-3)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['F'+IntToStr(LastRow-3)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['G'+IntToStr(LastRow-3)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['H'+IntToStr(LastRow-3)]:=Provider.FieldByName('�������').AsString;
    Sheet.Range['I'+IntToStr(LastRow-3)]:=Provider.FieldByName('������').AsString;
    Sheet.Range['J'+IntToStr(LastRow-3)]:=Provider.FieldByName('������� �������').AsString;
    Sheet.Range['K'+IntToStr(LastRow-3)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['L'+IntToStr(LastRow-3)]:=Provider.FieldByName('PHONE').AsString;

    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;
    if (Provider.FieldByName('����').AsString<>Room) then Begin
      Room:=Provider.FieldByName('����').AsString;
      Region:=Provider.FieldByName('�����').AsString;

      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow+3);
      InsertExcelRows(Sheet,LastRow-2,LastRow-2,'L',LastRow+2);
      InsertExcelRows(Sheet,LastRow+3,LastRow+3,'L',LastRow-2);
      InsertExcelRows(Sheet,1,1,'L',LastRow-1);
      InsertExcelRows(Sheet,4,4,'L',LastRow);
      InsertExcelRows(Sheet,5,5,'L',LastRow+1);

      Sheet.Range['A'+IntToStr(LastRow-1)]:='������, ������� �����';
      Val(Room,RoomInt,Code);
      if Length(Room)=0 then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='';
        Sheet.Range['A'+IntToStr(LastRow)]:='';
      end;
      if (Code=0) Or (Room='1,5') then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='�������� '+Room+'-���������';
        Sheet.Range['A'+IntToStr(LastRow)]:=Room+'-���������';
      end;
      if Room='�' then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='��������';
        Sheet.Range['A'+IntToStr(LastRow)]:='��������';
      end;
      if Room='�������' then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='�������';
        Sheet.Range['A'+IntToStr(LastRow)]:='�������';
      end;
      if Room='�' then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='���������';
        Sheet.Range['A'+IntToStr(LastRow)]:='���������';
      end;

      Sheet.Range['A'+IntToStr(LastRow+1)]:=Region;
      LastRow:=LastRow+4;
    End;
    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,LastRow-2,LastRow-2,'L',LastRow-1);
      InsertExcelRows(Sheet,5,5,'L',LastRow-2);
      Sheet.Range['A'+IntToStr(LastRow-2)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,LastRow-2,LastRow-2,'L',LastRow-1);
    InsertExcelRows(Sheet,6,6,'L',LastRow-2);
    Sheet.Rows[LastRow-2]:='';
    LastRow:=LastRow+1;
  Until False;

  Sheet.Rows[LastRow-1].Clear;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellApartmentsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow, Code, RoomInt: Integer;
  Excel, Sheet: Variant;
  Room, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_APARTMENTS_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('����');               
    AddInvisible('�����');              
    AddInvisible('����.');              
    AddInvisible('����');               
    AddInvisible('���');                
    AddInvisible('���');                
    AddInvisible('��, �2');             
    AddInvisible('�������');            
    AddInvisible('������');             
    AddInvisible('������� �������');    
    AddInvisible('����');               
    AddInvisible('���������� �����');   
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

  XLSNew:=CopyExcelDocToNew('sell_apartments_others.xls','������_��������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, ������� �����';
  Room:=Provider.FieldByName('����').AsString;
  Val(Room,RoomInt,Code);

  if Length(Room)=0 then begin
    Sheet.Range['I1']:='';
    Sheet.Range['A4']:='';
  end;
  if (Code=0) Or (Room='1,5') then begin
    Sheet.Range['I1']:='�������� '+Room+'-���������';
    Sheet.Range['A4']:=Room+'-���������';
  end;
  if Room='�' then begin
    Sheet.Range['I1']:='��������';
    Sheet.Range['A4']:='��������';
  end;
  if Room='�������' then begin
    Sheet.Range['I1']:='�������';
    Sheet.Range['A4']:='�������';
  end;
  if Room='�' then begin
    Sheet.Range['I1']:='���������';
    Sheet.Range['A4']:='���������';
  end;

  LastRow:=8;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-3)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-3)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-3)]:=Provider.FieldByName('����.').AsString;
    Sheet.Range['D'+IntToStr(LastRow-3)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['E'+IntToStr(LastRow-3)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['F'+IntToStr(LastRow-3)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['G'+IntToStr(LastRow-3)]:=Provider.FieldByName('��, �2').AsString;
    Sheet.Range['H'+IntToStr(LastRow-3)]:=Provider.FieldByName('�������').AsString;
    Sheet.Range['I'+IntToStr(LastRow-3)]:=Provider.FieldByName('������').AsString;
    Sheet.Range['J'+IntToStr(LastRow-3)]:=Provider.FieldByName('������� �������').AsString;
    Sheet.Range['K'+IntToStr(LastRow-3)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['L'+IntToStr(LastRow-3)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;
    if (Provider.FieldByName('����').AsString<>Room) then Begin
      Room:=Provider.FieldByName('����').AsString;

      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow+2);
      InsertExcelRows(Sheet,LastRow-2,LastRow-2,'L',LastRow+1);
      InsertExcelRows(Sheet,LastRow+2,LastRow+2,'L',LastRow-2);
      InsertExcelRows(Sheet,1,1,'L',LastRow-1);
      InsertExcelRows(Sheet,4,4,'L',LastRow);

      Sheet.Range['A'+IntToStr(LastRow-1)]:='������, ������� �����';
      Val(Room,RoomInt,Code);
      if Length(Room)=0 then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='';
        Sheet.Range['A'+IntToStr(LastRow)]:='';
      end;
      if (Code=0) Or (Room='1,5') then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='�������� '+Room+'-���������';
        Sheet.Range['A'+IntToStr(LastRow)]:=Room+'-���������';
      end;
      if Room='�' then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='��������';
        Sheet.Range['A'+IntToStr(LastRow)]:='��������';
      end;
      if Room='�������' then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='�������';
        Sheet.Range['A'+IntToStr(LastRow)]:='�������';
      end;
      if Room='�' then begin
        Sheet.Range['I'+IntToStr(LastRow-1)]:='���������';
        Sheet.Range['A'+IntToStr(LastRow)]:='���������';
      end;

      LastRow:=LastRow+3;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,LastRow-2,LastRow-2,'L',LastRow-1);
    InsertExcelRows(Sheet,5,5,'L',LastRow-2);
    Sheet.Rows[LastRow-2]:='';
    LastRow:=LastRow+1;
  Until False;

  Sheet.Rows[LastRow-1].Clear;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellHousesCottagesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_HOUSES_COTTAGES_KRS_EXPORT';      

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
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('��������� ����');     
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����');               
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

  XLSNew:=CopyExcelDocToNew('sell_houses_cottages_krs.xls','������_����,_��������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, ������� �����';
  Sheet.Range['D1']:='������� ����, ��������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������� ����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellHousesCottagesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_HOUSES_COTTAGES_OTHERS_EXPORT';

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
    AddInvisible('��������� ����');     
    AddInvisible('���');                
    AddInvisible('����� �������');      
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

  XLSNew:=CopyExcelDocToNew('sell_houses_cottages_others.xls','������_����,_��������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, ������� �����';
  Sheet.Range['C1']:='������� ����, ��������';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������� ����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellTownHousesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_TOWN_HOUSES_KRS_EXPORT';      

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
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('��������� ����');     
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����');               
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

  XLSNew:=CopyExcelDocToNew('sell_town_houses_krs.xls','������_���������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, ������� �����';
  Sheet.Range['D1']:='���������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������� ����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellOutsideHouses(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_OUTSIDE_HOUSES_EXPORT';      

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
    AddInvisible('��������� ����');     
    AddInvisible('���');                
    AddInvisible('����� �������');      
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

  XLSNew:=CopyExcelDocToNew('sell_outside_houses.xls','������_����������_����');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, ������� �����';
  Sheet.Range['C1']:='���������� ����';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������� ����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellDatchas(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_DATCHAS_EXPORT';      

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
    AddInvisible('�������');            
    AddInvisible('����� �������');      
    AddInvisible('���');                
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

  XLSNew:=CopyExcelDocToNew('sell_datchas.xls','������_����');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, ������� �����';
  Sheet.Range['C1']:='����';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

end.
