program gwxDemo;

uses
  Forms,
  Dialogs,
  MainForm in 'MainForm.pas' {MapForm},
  TreeViewForm in 'TreeViewForm.pas' {TreeForm},
  ObjStatus in 'ObjStatus.pas' {ObjStatusForm},
  SelectMap in 'SelectMap.pas' {SelectMapForm},
  ContextSrch in 'ContextSrch.pas' {ContextSearchForm},
  ObjList in 'ObjList.pas' {ObjListForm},
  ObjProp in 'ObjProp.pas' {ObjectForm},
  MapList in 'MapList.pas' {MapListForm},
  RouteParams in 'RouteParams.pas' {RouteParamsForm},
  BmpOpt in 'BmpOpt.pas' {BitmapOptForm},
  DbSelect in 'DbSelect.pas' {DbForm},
  DbErrors in 'DbErrors.pas' {DbErrForm},
  PrepareTable in 'PrepareTable.pas' {PrepareTableForm},
  TableColumns in 'TableColumns.pas' {TableColumnForm},
  ObPropTbl in 'ObPropTbl.pas' {ObjPropTable},
  RtVars in 'RtVars.pas' {RouteVariants},
  MDBFTable in 'MDBFTable.pas';

{$R *.res}

begin
  Application.Initialize;
  try
    Application.CreateForm(TMapForm, MapForm);
  Application.CreateForm(TTableColumnForm, TableColumnForm);
  Application.CreateForm(TObjPropTable, ObjPropTable);
  Application.CreateForm(TRouteVariants, RouteVariants);
  except  // most probably is that GWX is not registered
    MessageDlg('GWX Control ver.4 in not registered in the system.'#13#10+
      'Please register it using ''REGSVR32.EXE gwx.dll'' and run the application again',
      mtError, [mbOK], 0);
    exit;
  end;
  Application.CreateForm(TTreeForm, TreeForm);
  Application.CreateForm(TObjStatusForm, ObjStatusForm);
  Application.CreateForm(TSelectMapForm, SelectMapForm);
  Application.CreateForm(TContextSearchForm, ContextSearchForm);
  Application.CreateForm(TObjListForm, ObjListForm);
  Application.CreateForm(TObjectForm, ObjectForm);
  Application.CreateForm(TMapListForm, MapListForm);
  Application.CreateForm(TRouteParamsForm, RouteParamsForm);
  Application.CreateForm(TBitmapOptForm, BitmapOptForm);
  Application.CreateForm(TDbForm, DbForm);
  Application.CreateForm(TDbErrForm, DbErrForm);
  Application.CreateForm(TPrepareTableForm, PrepareTableForm);
  Application.Run;
end.
