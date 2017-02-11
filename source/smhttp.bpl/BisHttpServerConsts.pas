unit BisHttpServerConsts;

interface

const
  PageNotFound=404;
  PageAccessDenied=403;

  INDEX_RESP_Version = 0;
  INDEX_RESP_ReasonString = 1;
  INDEX_RESP_Server = 2;
  INDEX_RESP_WWWAuthenticate = 3;
  INDEX_RESP_Realm = 4;
  INDEX_RESP_Allow = 5;
  INDEX_RESP_Location = 6;
  INDEX_RESP_ContentEncoding = 7;
  INDEX_RESP_ContentType = 8;
  INDEX_RESP_ContentVersion = 9;
  INDEX_RESP_DerivedFrom = 10;
  INDEX_RESP_Title = 11;
  INDEX_RESP_ContentLength = 0;
  INDEX_RESP_Date = 0;
  INDEX_RESP_Expires = 1;
  INDEX_RESP_LastModified = 2;

  INDEX_Method           = 0;
  INDEX_ProtocolVersion  = 1;
  INDEX_URL              = 2;
  INDEX_Query            = 3;
  INDEX_PathInfo         = 4;
  INDEX_PathTranslated   = 5;
  INDEX_CacheControl     = 6;
  INDEX_Date             = 7;
  INDEX_Accept           = 8;
  INDEX_From             = 9;
  INDEX_Host             = 10;
  INDEX_IfModifiedSince  = 11;
  INDEX_Referer          = 12;
  INDEX_UserAgent        = 13;
  INDEX_ContentEncoding  = 14;
  INDEX_ContentType      = 15;
  INDEX_ContentLength    = 16;
  INDEX_ContentVersion   = 17;
  INDEX_DerivedFrom      = 18;
  INDEX_Expires          = 19;
  INDEX_Title            = 20;
  INDEX_RemoteAddr       = 21;
  INDEX_RemoteHost       = 22;
  INDEX_ScriptName       = 23;
  INDEX_ServerPort       = 24;
  INDEX_Content          = 25;
  INDEX_Connection       = 26;
  INDEX_Cookie           = 27;
  INDEX_Authorization    = 28;

resourcestring
  SParamIP='IP';
  SParamPort='Port';
  SParamExtendedLog='ExtendedLog';
  SParamConnectionUpdate='ConnectionUpdate';
  SParamWhoamiUrl='WhoamiUrl';
  SParamModules='Modules';
  SParamRedirects='Redirects';
  SParamWhiteList='WhiteList';
  SParamBlackList='BlackList';
  SParamHost='Host';
  SParamPath='Path';
  SParamUseCrypter='UseCrypter';
  SParamCrypterAlgorithm='CrypterAlgorithm';
  SParamCrypterMode='CrypterMode';
  SParamCrypterKey='CrypterKey';
  SParamSoftware='Software';
  SParamAuthRealm='AuthRealm';
  SParamAuthUsers='AuthUsers';
  SParamUseCompressor='UseCompressor';
  SParamCompressorLevel='CompressorLevel';
  SParamAuthUserName='AuthUserName';
  SParamAuthPassword='AuthPassword';
  SParamProtocol='Protocol';
  SParamUseProxy='UseProxy';
  SParamProxyHost='ProxyHost';
  SParamProxyPort='ProxyPort';
  SParamProxyUserName='ProxyUserName';
  SParamProxyPassword='ProxyPassword';

  SFieldHandlers='HANDLERS';
  SFieldInParams='IN_PARAMS';
  SFieldOutParams='OUT_PARAMS';
  SFieldMode='MODE';

  SInitHttpServerHandlerModule='InitHttpServerHandlerModule';

  SSlash='/';

implementation

end.
