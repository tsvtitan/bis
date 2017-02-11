/////////////////////////////////////////////////////////////
//        �������� ������ ������� �����
//        �������� �.�. 2003 �.
/////////////////////////////////////////////////////////////
unit BaseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  //DsgnIntf;                //��� ������������� Delphi5
  DesignIntf, DesignEditors; //��� ������������� Delphi6

const
  ItmID = $00a0; //������������� ������ ������ ���������� ����

type
  TBaseForm = class(TForm)
  private
    FVersion: integer;          //������ �����
    FMnuItmAbout: MENUITEMINFO; //��������� ������ ������ ����
    FOldWndProc : Pointer;      //��������� �� ������ ������� ���������
                                //��������� ���� (�����)
    FNewWndProc : Pointer;      //��������� �� ����� ������� ���������
                                //��������� ���� (�����)

    // ���������� ���������� � ����� � ���� ������
    function GetAboutString: string;

  protected

  public
    //�����������
    constructor Create(AOwner: TComponent); override;
    //���������� :)
    destructor  Destroy; override;
    //���������� ��������� �� ������ ������� ��������� ��������� ���� (�����)
    function    GetOldWindowProc: Pointer;
    //���������� ���������� � �����
    procedure   ShowFormInfo;

  published
    property Version: integer read FVersion write FVersion default 1;

  end;

//����� ������� ��������� ��������� ���� (�����)
function  NewWndProc(wnd: HWND; Msg: UINT; wPrm: WPARAM; lPrm: LPARAM): LRESULT stdcall;

//��������� ����������� ������
procedure Register;

implementation

constructor TBaseForm.Create(AOwner: TComponent);
begin
   inherited;

   //� ����� ���� ������ ������ ���� ��������� ����!!!
   if not ( biSystemMenu in Self.BorderIcons ) then
      Self.BorderIcons := Self.BorderIcons + [biSystemMenu];

   //������� ����� ����� ���������� ����, �� ������ ��������
   //����� �������� ���������� � �����
   FMnuItmAbout.cbSize := 44;
   FMnuItmAbout.fMask := MIIM_DATA or MIIM_ID or MIIM_STATE	or MIIM_TYPE;
   FMnuItmAbout.fType := MFT_STRING;
   FMnuItmAbout.fState := MFS_ENABLED;
   FMnuItmAbout.wID := ItmID;
   FMnuItmAbout.hSubMenu := 0;
   FMnuItmAbout.hbmpChecked := 0;
   FMnuItmAbout.hbmpUnchecked := 0;
   FMnuItmAbout.dwTypeData := PChar('� �����');

   InsertMenuItem(
      GetSystemMenu(Self.Handle, False),
      0,
      True,
      FMnuItmAbout);

   //����������� ����� ��������� ��������� ��������� ���� (�����)
   FNewWndProc := Pointer(@NewWndProc);
   FOldWndProc := Pointer(GetWindowLong(Self.Handle, GWL_WNDPROC));
   SetWindowLong(Self.Handle, GWL_WNDPROC, Longint(FNewWndProc));
end;

destructor TBaseForm.Destroy;
begin
   inherited;
end;

function TBaseForm.GetOldWindowProc: Pointer;
begin
   Result := FOldWndProc;
end;

procedure TBaseForm.ShowFormInfo;
var
   InfStr: string;
begin
   InfStr := GetAboutString;

   MessageBox(
      Self.Handle,
      PChar(InfStr),
      PChar('�������� � �����'),
      MB_OK);
end;

function TBaseForm.GetAboutString: string;
begin
   Result :=
      '��� ������ �����:  ' + Self.ClassName + #13 +
      '��� �����:  ' + Self.Name + '  ������  ' + IntToStr(FVersion);
end;

////////////////////////////////////////////////////////////////
// � ������ ������� ����� ��������� ��������� ���������
// ���� (�����) ������� ������ ��� ������ ��������� -
// ������ ����� ������ ���������� ���� "� �����"
////////////////////////////////////////////////////////////////
function NewWndProc(wnd: HWND; Msg: UINT; wPrm: WPARAM; lPrm: LPARAM): LRESULT stdcall;
var
   FrmHWND: HWND;
   wctrl: TWinControl;
   BFrm: TBaseForm;
begin
   Result := 0;

   FrmHWND := wnd;
   wctrl := FindControl(FrmHWND);
   if ( wctrl = nil ) then
      Exit;
   FrmHWND := GetParentForm(wctrl).Handle;
   if ( FrmHWND = 0 ) then
      Exit;

   BFrm := TBaseForm(FindControl(FrmHWND));
   if ( BFrm = nil ) then
      Exit;

   Result := CallWindowProc(
      BFrm.GetOldWindowProc,
      wnd,
      Msg,
      wPrm,
      lPrm);

   case ( Msg ) of
      //������ ����� ���������� ���� "� �����"
      WM_SYSCOMMAND :
         begin
            if ( LOWORD(wPrm) = ItmID ) then
            begin
               wctrl := FindControl(wnd);
               if ( wctrl <> nil ) then
                  if ( wctrl is TBaseForm ) then
                     TBaseForm(wctrl).ShowFormInfo;
            end;
         end;
   end;

end;

procedure Register;
begin
  RegisterCustomModule(TBaseForm, TCustomModule);
end;


end.
