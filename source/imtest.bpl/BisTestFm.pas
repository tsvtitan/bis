unit BisTestFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls,
  ComCtrls, ExtCtrls, Buttons, DB,
  BisFm, BisIfaces, BisFieldNames, BisDataSet, BisProvider;

type

  TBisTestForm = class(TBisForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Panel1: TPanel;
    Button4: TButton;
    Edit1: TEdit;
    Button5: TButton;
    Button6: TButton;
    ButtonCalculate: TBitBtn;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ButtonCalculateClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    FProvider: TBisProvider;
    FProvider2: TBisProvider;
    FCollectionItem: TBisDataSetCollectionItem;

    FCanceled: Boolean;

    function GetNewName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;

    procedure ProviderThreadBegin(Sender: TObject);
    procedure ProviderThreadEnd(Sender: TObject);
    procedure Provider2ThreadBegin(Sender: TObject);
    procedure Provider2ThreadEnd(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisTestFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTestForm: TBisTestForm;

var
  TestIface: TBisIface=nil;

implementation

uses DateUtils, StrUtils,
     BisCore, BisInterfaces, BisDataFm, BisIfaceModules, BisUtils,
     BisFilterGroups,
     BisPeriodFm, BisDocumentFm, BisDialogs;

{$R *.dfm}

{ TBisTestFormIface }

constructor TBisTestFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTestForm;
  AutoShow:=true;
  ApplicationCreateForm:=true;
  OnlyOneForm:=false;
  Permissions.Enabled:=false;
//  ShowType:=stNormal;
  with Permissions.Add('�����') do begin
    Values.Add('��� �� ����');
    Values.Add('����� ����');
  end;
end;

{ TBisTestForm }

constructor TBisTestForm.Create(AOwner: TComponent);
var
  P1: TBisProvider;
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  FProvider2:=TBisProvider.Create(Self);
  FProvider2.Threaded:=true;
  FProvider2.UseShowWait:=true;
  FProvider2.WaitInterval:=250;
  FProvider2.WaitTimeout:=10;
  FProvider2.WaitAsModal:=true;
  FProvider2.UseWaitCursor:=false;
  FProvider2.OnThreadBegin:=Provider2ThreadBegin;
  FProvider2.OnThreadEnd:=Provider2ThreadEnd;

 with FProvider2.FieldDefs do begin
    Add('NAME',ftString,100);
  end;

  with FProvider2.FieldNames do begin
    Add('NAME','���',40);
  end;
  FProvider2.CreateTable();

//  FProvider2.ProviderName:='S_ACCOUNTS';

  P1:=TBisProvider.Create(nil);
  try
    P1.ProviderName:='S_DRIVERS';

    FCollectionItem:=nil;
   // FCollectionItem:=FProvider2.Collection.AddDataSet(P1);
  finally
    P1.Free;
  end;

  Button11Click(nil);
end;

destructor TBisTestForm.Destroy;
begin
  FProvider2.Free;
  if Assigned(FProvider) then begin
     FProvider.Free;
     FProvider:=nil;
  end;
  inherited Destroy;
end;

procedure TBisTestForm.Provider2ThreadBegin(Sender: TObject);
begin
  //
end;

procedure TBisTestForm.Provider2ThreadEnd(Sender: TObject);
var
  P1,P2: TBisDataSet;
begin
  if FProvider2.Active then begin
    P1:=TBisDataSet.Create(nil);
    P2:=TBisDataSet.Create(nil);
    try
      if Assigned(FCollectionItem) and FCollectionItem.GetDataSet(P1) then begin

  {      with P2.FieldDefs do begin
          Add('NAME',ftString,100);
        end;

        with P2.FieldNames do begin
          Add('NAME','���',40);
        end;
        P2.CreateTable();

        while not P1.Eof do begin
          P2.Append;
          P2.FieldByName('NAME').AsString:=P1.FieldByName('NAME').AsString;
          P2.Post;
          P1.Next;
        end;}



        P1.First;

   {     with FProvider2.FieldDefs do begin
          Add('NAME',ftString,100);
        end;

        with FProvider2.FieldNames do begin
          Add('NAME','���',40);
        end;
        FProvider2.CreateTable();  }

        while not P1.Eof do begin
          FProvider2.Append;
          FProvider2.FieldByName('NAME').AsString:=P1.FieldByName('NAME').AsString;
          FProvider2.Post;
          P1.Next;
        end;
 
      end;
    finally
      P2.Free;
      P1.Free;
    end;
  end; 
end;

procedure TBisTestForm.ProviderThreadBegin(Sender: TObject);
begin
 // ShowInfo('begin');
end;

procedure TBisTestForm.ProviderThreadEnd(Sender: TObject);
var
  S,S1: String;
begin
  if Assigned(FProvider) then begin
    S:=FProvider.Error;
    if FProvider.Success then begin
      if not FCanceled then
        S:='success'
      else
        S:='cancel';
      if FProvider.Active then
        S1:=FormatEx('active (%d) %s',[FProvider.RecordCount,FProvider.Fields[0].AsString])
      else
        S1:='not active';
    end;
    ShowInfo(FormatEx('end (%d %s): %s',[FProvider.Period,S1,S]));
  end;
end;

procedure TBisTestForm.Button1Click(Sender: TObject);
var
  DS: TBisDataSet;
begin
  DS:=TBisDataSet.Create(nil);
  try
{   if Core.DataSelectInto('�����������',DS,
                          'SMALL_NAME',Label1.Caption,false,imInterface) then begin
     Label1.Caption:=DS.FieldByName('SMALL_NAME').AsString;
   end;}
   if Core.DataSelectInto('�������',DS,
                          'ID',Label1.Caption,false,imInterface) then begin
     Label1.Caption:=DS.FieldByName('ID').AsString;
   end;    
  finally
    DS.Free;
  end;
end;

procedure TBisTestForm.Button9Click(Sender: TObject);
var
  I: TBisInterface;
begin
  I:=Core.FindInterface('���� �����������');
  if Assigned(I) then
    I.IfaceShow;
end;

procedure TBisTestForm.Button2Click(Sender: TObject);
var
  DS: TBisDataSet;
begin
  DS:=TBisDataSet.Create(nil);
  try
   if Core.DataSelectInto('CallcHbookFirmTypesFormIface',DS,
                          'NAME',Label2.Caption,false,imIface,CheckBox1.Checked) then begin
     Label2.Caption:=DS.FieldByName('NAME').AsString;
   end;
  finally
    DS.Free;
  end;
end;


procedure TBisTestForm.Button3Click(Sender: TObject);
var
  Iface: TBisPeriodFormIface;
  D1, D2: TDate;
  PeriodType: TBisPeriodType;
begin
  Iface:=TBisPeriodFormIface.Create(nil);
  try
    Iface.Init;
    PeriodType:=ptYear;
    D1:=DateTimePicker1.Date;
    D2:=DateTimePicker2.Date;
    if Iface.Select(PeriodType,D1,D2) then begin
      DateTimePicker1.Date:=D1;
      DateTimePicker2.Date:=D2;
    end;
  finally
    Iface.Free;
  end;

end;

type
  TBisDocumentFormIfaceClass=class of TBisDocumentFormIface;

procedure TBisTestForm.Button4Click(Sender: TObject);
var
  AInterface: TBisDocumentInterface;
  AIfaceClass: TBisDocumentFormIfaceClass;
  AIface: TBisDocumentFormIface;
  A: OleVariant;
  D: OleVariant;
begin
  AInterface:=TBisDocumentInterface(Core.GetInterface(Edit1.Text));
  if Assigned(AInterface.Iface)  then begin
    AIfaceClass:=TBisDocumentFormIfaceClass(AInterface.Iface.ClassType);
      AIface:=AIfaceClass.Create(Self);
      AIface.DocumentId:=TBisDocumentFormIface(AInterface.Iface).DocumentId;
      AIface.OleClass:=TBisDocumentFormIface(AInterface.Iface).OleClass;
      AIface.DocumentVisible:=false;
      AIface.Show;
      if Assigned(AIface.LastOleObject) then begin
        A:=Variant(AIface.LastOleObject as IDispatch);
        D:=A.Application;
        D.Visible:=true;
        D.WindowState:=3;
      end;

  end;
end;

procedure TBisTestForm.Button5Click(Sender: TObject);
var
  P: TBisProvider;
  P1,P2,P3: TBisProvider;
  C1,C2,C3: TBisDataSetCollectionItem;
  T1: TTime;
begin
  P:=TBisProvider.Create(nil);
  P1:=TBisProvider.Create(nil);
  P2:=TBisProvider.Create(nil);
  P3:=TBisProvider.Create(nil);
  try
    P.UseShowWait:=true;
    P.WaitStatus:='��������� ������ ...';
    P.WaitAsModal:=true;
    P.WaitInterval:=10;



    P.ProviderName:='S_DISPATCHERS';

    P1.ProviderName:='S_ACCOUNTS';
    P1.FieldNames.Add('ACCOUNT_ID');                             
    P1.FieldNames.Add('USER_NAME');
    P1.FieldNames.Add('PASSWORD');
    P1.Orders.Add('USER_NAME');
    P1.Orders.Add('PASSWORD');

    P2.ProviderName:='S_DRIVERS';
    P2.FieldNames.Add('DRIVER_ID');
    P2.FieldNames.Add('SURNAME');
    P2.FieldNames.Add('NAME');
    P2.Orders.Add('SURNAME');
    P2.Orders.Add('NAME');

    P3.ProviderName:='S_CLIENTS';
    P3.FieldNames.Add('CLIENT_ID');
    P3.FieldNames.Add('NAME');
    P3.FieldNames.Add('PATRONYMIC');
    P3.Orders.Add('NAME');
    P3.Orders.Add('PATRONYMIC');

    C1:=P.CollectionAfter.AddDataSet(P1);
    C2:=P.CollectionAfter.AddDataSet(P2);
    C3:=P.CollectionAfter.AddDataSet(P3);

    T1:=Time;
    try
      P.Open;
    finally
      ShowInfo(IntToStr(MilliSecondsBetween(Time,T1)));
    end;

    if P.Active and not P.Empty then
      ShowInfo('P='+P.Fields[0].AsString);

    if C1.GetDataSet(P1) and not P1.Empty then
      ShowInfo('P1='+P1.Fields[0].AsString);

    if C2.GetDataSet(P2) and not P2.Empty then
      ShowInfo('P2='+P2.Fields[0].AsString);

    if C3.GetDataSet(P3) and not P3.Empty then
      ShowInfo('P3='+P3.Fields[0].AsString);

  finally
    P3.Free;
    P2.Free;
    P1.Free;
    P.Free;
  end;
end;

procedure TBisTestForm.Button6Click(Sender: TObject);
var
  P: TBisProvider;
  P1,P2,P3: TBisProvider;
  T1: TTime;
begin
  P:=TBisProvider.Create(nil);
  P1:=TBisProvider.Create(nil);
  P2:=TBisProvider.Create(nil);
  P3:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_DISPATCHERS';

    P1.ProviderName:='S_ACCOUNTS';
    P1.FieldNames.Add('ACCOUNT_ID');
    P1.FieldNames.Add('USER_NAME');
    P1.FieldNames.Add('PASSWORD');
    P1.Orders.Add('USER_NAME');
    P1.Orders.Add('PASSWORD');

    P2.ProviderName:='S_DRIVERS';
    P2.FieldNames.Add('DRIVER_ID');
    P2.FieldNames.Add('SURNAME');
    P2.FieldNames.Add('NAME');
    P2.Orders.Add('SURNAME');
    P2.Orders.Add('NAME');

    P3.ProviderName:='S_CLIENTS';
    P3.FieldNames.Add('CLIENT_ID');
    P3.FieldNames.Add('NAME');
    P3.FieldNames.Add('PATRONYMIC');
    P3.Orders.Add('NAME');
    P3.Orders.Add('PATRONYMIC');

    T1:=Time;
    try
      P.Open;
      P1.Open;
      P2.Open;
      P3.Open;
    finally
      ShowInfo(IntToStr(MilliSecondsBetween(Time,T1)));
    end;

  finally
    P3.Free;
    P2.Free;
    P1.Free;
    P.Free;
  end;
end;

function TBisTestForm.GetNewName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  VName: Variant;
begin
  Result:=Null;
  if DataSet.Active then begin
    VName:=DataSet.FieldByName('NAME').Value;
    Result:=iff(VarIsNull(VName),Result,VarToStrDef(VName,'')+'+!');
  end;
end;

procedure TBisTestForm.ButtonCalculateClick(Sender: TObject);
var
  P: TBisProvider;
  i: Integer;
  Field: TField;
  Stream: TMemoryStream;
  DS: TBisDataSet;
begin
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNTS';
    with P.FieldNames do begin
      AddInvisible('NAME');
      AddCalculate('NEW_NAME','',GetNewName,ftString,250,100).Visible:=false;
    end;
    P.FilterGroups.Add.Filters.Add('USER_NAME',fcEqual,'tsv');
    P.Open;
    if P.Active and not P.Empty then begin

      for i:=0 to P.Fields.Count-1 do begin
        Field:=P.Fields[i];
        ShowInfo(Field.AsString);
      end;

      Stream:=TMemoryStream.Create;
      DS:=TBisDataSet.Create(nil);
      try
        P.SaveToStream(Stream);
        Stream.Position:=0;
        DS.LoadFromStream(Stream);

        for i:=0 to DS.Fields.Count-1 do begin
          Field:=DS.Fields[i];
          ShowInfo(Field.AsString);
        end;

      finally
        DS.Free;
        Stream.Free;
      end;

    end;
  finally
    P.Free;
  end;
end;

procedure TBisTestForm.Button7Click(Sender: TObject);
begin
  if Assigned(FProvider) then begin
    FCanceled:=false;
    FProvider.Close;
    FProvider.Open;
  //  FProvider.Execute;
  end;
end;

procedure TBisTestForm.Button8Click(Sender: TObject);
begin
  if Assigned(FProvider) then begin
    FCanceled:=true;
    FProvider.Terminate;
  end;
end;

procedure TBisTestForm.Button11Click(Sender: TObject);
begin
  if not Assigned(FProvider) then begin

    FProvider:=TBisProvider.Create(nil);
    FProvider.UseShowWait:=true;
    FProvider.WaitStatus:=DupeString('���-�� ������ 1',5);
    FProvider.WaitTimeout:=30;
    FProvider.WaitAsModal:=true;
    FProvider.WaitInterval:=1500;
  //  FProvider.WaitInterval:=0;

  //  FProvider.ProviderName:='TASK_TEST';
    FProvider.ProviderName:='S_ORDERS';
    FProvider.FilterGroups.Add.Filters.Add('DATE_ACCEPT',fcGreater,StrToDate('15.06.2011'));
  //  FProvider.FilterGroups.Add.Filters.Add('DATE_ACCEPT',fcGreater,StrToDate('23.08.2011'));

    FProvider.Threaded:=true;
    FProvider.UseShowError:=false;
    FProvider.UseWaitCursor:=false;
    FProvider.OnThreadBegin:=ProviderThreadBegin;
    FProvider.OnThreadEnd:=ProviderThreadEnd;
  end;
end;

procedure TBisTestForm.Button12Click(Sender: TObject);
begin
  FProvider2.Close;
  FProvider2.Open;

end;

procedure TBisTestForm.Button10Click(Sender: TObject);
begin
  if Assigned(FProvider) then begin
    FProvider.Free;
    FProvider:=nil;
  end;
end;


end.
