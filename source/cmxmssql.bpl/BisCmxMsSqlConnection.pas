unit BisCmxMsSqlConnection;

interface

uses Classes,
     BisCmxConnection, BisConnections;

type
  TBisCmxMsSqlSession=class(TBisCmxSession)
  public
    constructor Create(ASessions: TBisCmxSessions); override;
  end;

  TBisCmxMsSqlSessions=class(TBisCmxSessions)
  protected
    function GetSessionClass: TBisCmxSessionClass; override;
  public
    constructor Create(AConnection: TBisCmxConnection); override;
  end;

  TBisCmxMsSqlConnection=class(TBisCmxConnection)
  protected
    function GetSessionsClass: TBisCmxSessionsClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TBisCmxMsSqlSession }

constructor TBisCmxMsSqlSession.Create(ASessions: TBisCmxSessions);
begin
  inherited Create(ASessions);
  SCheckPermissions:='NAME=%s';
  SFormatDateTime:='yyyy-mm-dd hh:nn:ss';  // English
  SSqlInsert:='INSERT INTO /*PREFIX*/SESSIONS (SESSION_ID,APPLICATION_ID,ACCOUNT_ID,DATE_CREATE,DATE_CHANGE,PARAMS) '+
              'VALUES (%s,%s,%s,CONVERT(DATETIME,%s,120),CONVERT(DATETIME,%s,120),:PARAMS)';
  SSqlUpdate:='UPDATE /*PREFIX*/SESSIONS SET DATE_CHANGE=CONVERT(DATETIME,%s,120) WHERE SESSION_ID=%s';
  SSqlDelete:='DELETE FROM /*PREFIX*/SESSIONS WHERE SESSION_ID=%s';
  SSqlLoadPermissions:='SELECT P.INTERFACE_ID, I.NAME, P.RIGHT_ACCESS, P.VALUE '+
                       'FROM /*PREFIX*/PERMISSIONS P JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=P.INTERFACE_ID '+
                       'WHERE P.ACCOUNT_ID IN (%s)';
  SSqlLoadRoles:='SELECT ROLE_ID FROM /*PREFIX*/ACCOUNT_ROLES WHERE ACCOUNT_ID=%s';
  SSqlLoadProfile:='SELECT P.PROFILE FROM /*PREFIX*/PROFILES P WHERE P.APPLICATION_ID=%s AND P.ACCOUNT_ID=%s';
  SSqlSaveProfile:='UPDATE /*PREFIX*/PROFILES SET PROFILE=:PROFILE WHERE APPLICATION_ID=%s AND ACCOUNT_ID=%s';
  SSqlLoadInterfaces:='SELECT AI.INTERFACE_ID, AI.PRIORITY, AI.AUTO_RUN, I.NAME, I.DESCRIPTION, '+
                      'I.MODULE_NAME, I.MODULE_INTERFACE, I.INTERFACE_TYPE, '+
                      'R.REPORT_ID, R.ENGINE AS REPORT_ENGINE, R.PLACE AS REPORT_PLACE, '+
                      'D.DOCUMENT_ID, D.OLE_CLASS AS DOCUMENT_OLE_CLASS, D.PLACE AS DOCUMENT_PLACE '+
                      'FROM /*PREFIX*/APPLICATION_INTERFACES AI '+
                      'JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=AI.INTERFACE_ID '+
                      'LEFT JOIN /*PREFIX*/REPORTS R ON R.REPORT_ID=AI.INTERFACE_ID '+
                      'LEFT JOIN /*PREFIX*/DOCUMENTS D ON D.DOCUMENT_ID=AI.INTERFACE_ID '+
                      'WHERE AI.APPLICATION_ID=%s AND AI.ACCOUNT_ID IN (%s) '+
                      'ORDER BY AI.PRIORITY';
  SSqlGetRecords:='SELECT %s FROM %s %s %s %s %s';
  SSqlGetRecordsCount:='SELECT COUNT(*) FROM (%s)';
  SSqlLoadMenus:='SELECT M.MENU_ID, M.PARENT_ID, M.NAME, M.DESCRIPTION, M.INTERFACE_ID, '+
                 'M.SHORTCUT, M.PICTURE, M.PRIORITY '+
                 'FROM /*PREFIX*/APPLICATION_MENUS AP '+
                 'JOIN /*PREFIX*/MENUS M ON M.MENU_ID=AP.MENU_ID '+
                 'WHERE AP.APPLICATION_ID=%s '+
                  'AND (M.INTERFACE_ID IN (SELECT INTERFACE_ID FROM /*PREFIX*/APPLICATION_INTERFACES '+
                                           'WHERE APPLICATION_ID=AP.APPLICATION_ID AND ACCOUNT_ID IN (%s)) '+
                 'OR M.INTERFACE_ID IS NULL) '+
                 'ORDER BY M.LEVEL, M.PRIORITY ';
  SSqlLoadReport:='SELECT REPORT, PLACE FROM /*PREFIX*/REPORTS WHERE REPORT_ID=%s';
  SSqlLoadDocument:='SELECT DOCUMENT, PLACE FROM /*PREFIX*/DOCUMENTS WHERE DOCUMENT_ID=%s';
  SParamPrefix:='@';
end;

{ TBisCmxMsSqlSessions }

constructor TBisCmxMsSqlSessions.Create(AConnection: TBisCmxConnection);
begin
  inherited Create(AConnection);
  SSchemaOverride:='SchemaOverride';
  SFormatSchemaName:='%s.dbo';
end;

function TBisCmxMsSqlSessions.GetSessionClass: TBisCmxSessionClass;
begin
  Result:=TBisCmxMsSqlSession;
end;

{ TBisCmxMsSqlConnection }

constructor TBisCmxMsSqlConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SSqlGetDbUserName:='SELECT ACCOUNT_ID, DB_USER_NAME, DB_PASSWORD, PASSWORD FROM /*PREFIX*/ACCOUNTS '+
                     'WHERE UPPER(USER_NAME)=%s AND LOCKED<>1';
  SSqlApplicationExists:='SELECT A.LOCKED, P.PROFILE '+
                          'FROM /*PREFIX*/PROFILES P '+
                          'JOIN /*PREFIX*/APPLICATIONS A ON A.APPLICATION_ID=P.APPLICATION_ID '+
                          'WHERE P.APPLICATION_ID=%s '+
                          'AND P.ACCOUNT_ID=%s';
  SSqlSessionExists:='SELECT SESSION_ID FROM /*PREFIX*/SESSIONS WHERE SESSION_ID=%s ';
  SFieldNameQuote:='"';
  SFormatDateTimeValue:='yyyy-mm-dd hh:nn:ss';
  SSqlInsert:='INSERT INTO %s (%s) VALUES (%s)';
  SFormatFilterDateValue:='CONVERT(DATETIME,%s,120)';
end;

function TBisCmxMsSqlConnection.GetSessionsClass: TBisCmxSessionsClass;
begin
  Result:=TBisCmxMsSqlSessions;
end;
end.
