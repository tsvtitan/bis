/////////////////////////////////////////////////////////////
//        описание класса базовой формы
//        –ощупкин ј.¬. 2003 г.
/////////////////////////////////////////////////////////////
unit BaseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  //DsgnIntf;                //при использовании Delphi5
  DesignIntf, DesignEditors; //при использовании Delphi6

const
  ItmID = $00a0; //идентификатор нового пункта системного меню

type
  TBaseForm = class(TForm)
  private
    FVersion: integer;          //верси€ формы
    FMnuItmAbout: MENUITEMINFO; //структура нового пункта меню
    FOldWndProc : Pointer;      //указатель на старую функцию обработки
                                //сообщений окна (формы)
    FNewWndProc : Pointer;      //указатель на новую функцию обработки
                                //сообщений окна (формы)

    // возвращает информацию о форме в виде строки
    function GetAboutString: string;

  protected

  public
    //конструктор
    constructor Create(AOwner: TComponent); override;
    //деструктор :)
    destructor  Destroy; override;
    //возвращает указатель на старую функцию обработки сообщений окна (формы)
    function    GetOldWindowProc: Pointer;
    //показывает информацию о форме
    procedure   ShowFormInfo;

  published
    property Version: integer read FVersion write FVersion default 1;

  end;

//новую функцию обработки сообщений окна (формы)
function  NewWndProc(wnd: HWND; Msg: UINT; wPrm: WPARAM; lPrm: LPARAM): LRESULT stdcall;

//процедура регистрации класса
procedure Register;

implementation

constructor TBaseForm.Create(AOwner: TComponent);
begin
   inherited;

   //у наших окон всегда должно быть системное меню!!!
   if not ( biSystemMenu in Self.BorderIcons ) then
      Self.BorderIcons := Self.BorderIcons + [biSystemMenu];

   //создаем новый пункт систменого меню, по выборе которого
   //будет показана информаци€ о форме
   FMnuItmAbout.cbSize := 44;
   FMnuItmAbout.fMask := MIIM_DATA or MIIM_ID or MIIM_STATE	or MIIM_TYPE;
   FMnuItmAbout.fType := MFT_STRING;
   FMnuItmAbout.fState := MFS_ENABLED;
   FMnuItmAbout.wID := ItmID;
   FMnuItmAbout.hSubMenu := 0;
   FMnuItmAbout.hbmpChecked := 0;
   FMnuItmAbout.hbmpUnchecked := 0;
   FMnuItmAbout.dwTypeData := PChar('ќ форме');

   InsertMenuItem(
      GetSystemMenu(Self.Handle, False),
      0,
      True,
      FMnuItmAbout);

   //регистраци€ новой процедуры обработки сообщений окна (формы)
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
      PChar('—ведени€ о форме'),
      MB_OK);
end;

function TBaseForm.GetAboutString: string;
begin
   Result :=
      '»м€ класса формы:  ' + Self.ClassName + #13 +
      '»м€ формы:  ' + Self.Name + '  верси€  ' + IntToStr(FVersion);
end;

////////////////////////////////////////////////////////////////
// в данном примере нова€ процедура обработки сообщений
// окна (формы) создана только дл€ одного сообщени€ -
// ловить выбор пункта системного меню "ќ форме"
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
      //выбран пункт системного меню "ќ форме"
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
